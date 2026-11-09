"""LLM adapter for timing-guided RTL candidate generation.

Uses only the Python standard library and an OpenAI-compatible Chat Completions
endpoint. This module never executes model output; it returns a Verilog string
and structured explanation for the experiment driver to validate.
"""
from __future__ import annotations

import json
import math
import os
import re
import shutil
import subprocess
import tempfile
import time
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path


class LLMGenerationError(RuntimeError):
    pass


def http_transport() -> str:
    selected = os.environ.get("PIPEWEAVER_HTTP_TRANSPORT", "urllib").strip().lower()
    if selected not in ("urllib", "curl"):
        raise LLMGenerationError("PIPEWEAVER_HTTP_TRANSPORT must be urllib or curl")
    return selected


def _curl_json(request: urllib.request.Request, timeout_s: int, audit_dir: Path | None = None) -> dict:
    """One verified HTTPS attempt. Credential travels via stdin, never argv or disk."""
    executable = shutil.which("curl.exe" if os.name == "nt" else "curl")
    if not executable:
        raise LLMGenerationError("curl transport selected but executable not found")
    authorization = request.get_header("Authorization", "")
    if any(c in authorization for c in ("\r", "\n", "\x00")):
        raise LLMGenerationError("Invalid authorization header")
    escaped = authorization.replace("\\", "\\\\").replace('"', '\\"')
    config = f'header = "Authorization: {escaped}"\n' if authorization else ""
    env = os.environ.copy()
    env.pop("OPENAI_API_KEY", None)
    started = time.monotonic()
    def record_transport(returncode, output=b"", timed_out=False):
        if audit_dir is None:
            return
        parts = output.decode("ascii", errors="replace").strip().split("|")
        report = {"transport": "curl", "exit_code": returncode,
                  "http_status": int(parts[0]) if parts[0].isdigit() else None,
                  "client_timeout": timed_out, "retry_count": 0,
                  "elapsed_seconds": round(time.monotonic() - started, 6),
                  "scope": "Numeric client observations only; no stderr, credentials, headers or response body. Does not identify the failing server."}
        for index, key in enumerate(("connect_seconds", "first_byte_seconds", "total_seconds", "downloaded_bytes"), 1):
            try:
                value = float(parts[index])
                report[key] = value if math.isfinite(value) and value >= 0 else None
            except (IndexError, ValueError):
                report[key] = None
        audit_dir.mkdir(parents=True, exist_ok=True)
        (audit_dir / "transport.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    with tempfile.TemporaryDirectory(prefix="pipeweaver_http_") as tmp:
        folder = Path(tmp)
        response_path = folder / "response.json"
        command = [executable, "-q", "--config", "-", "--silent", "--show-error",
                   "--proto", "=https", "--request", request.get_method(), "--url", request.full_url,
                   "--header", "Content-Type: application/json", "--output", str(response_path),
                   "--write-out", "%{http_code}|%{time_connect}|%{time_starttransfer}|%{time_total}|%{size_download}", "--connect-timeout", str(min(30, timeout_s)),
                   "--max-time", str(timeout_s), "--retry", "0"]
        if request.data is not None:
            body_path = folder / "body.json"
            body_path.write_bytes(request.data)
            command += ["--data-binary", "@" + str(body_path)]
        try:
            proc = subprocess.run(command, input=config.encode("utf-8"), env=env,
                                  stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                  timeout=timeout_s + 10,
                                  creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        except subprocess.TimeoutExpired:
            record_transport(None, timed_out=True)
            raise LLMGenerationError("curl transport timed out; no automatic retry") from None
        record_transport(proc.returncode, proc.stdout)
        if proc.returncode:
            raise LLMGenerationError(f"curl transport failed (exit {proc.returncode}); no automatic retry")
        status = proc.stdout.decode("ascii", errors="replace").strip().split("|", 1)[0]
        if not status.isdigit() or not 200 <= int(status) < 300:
            safe_status = status if status.isdigit() else "unavailable"
            raise LLMGenerationError(f"LLM API returned HTTP {safe_status}")
        try:
            result = json.loads(response_path.read_text(encoding="utf-8"))
        except (OSError, UnicodeError, json.JSONDecodeError):
            raise LLMGenerationError("curl transport returned invalid JSON") from None
        if not isinstance(result, dict):
            raise LLMGenerationError("LLM API envelope must be a JSON object")
        return result


@dataclass
class GeneratedCandidate:
    rtl: str
    explanation: dict
    model: str
    generation_parameters: dict


def api_configured() -> bool:
    return bool(os.environ.get("OPENAI_API_KEY", "").strip())


def _strip_verilog_fence(value: str) -> str:
    text = value.strip()
    fenced = re.fullmatch(r"```(?:verilog|systemverilog|sv)?\s*\n?(.*?)\n?```", text, re.I | re.S)
    if fenced:
        text = fenced.group(1).strip()
    if "```" in text:
        raise LLMGenerationError("Candidate RTL contains extra or nested code fences")
    return text + "\n"


def _parse_content(content: str) -> tuple[str, dict]:
    normalizations = []
    content = content.strip()
    if content.startswith("<think>"):
        end = content.find("</think>")
        if end < 0:
            raise LLMGenerationError("Model response has an unclosed leading wrapper")
        content = content[end + len("</think>"):].strip()
        normalizations.append("Removed complete leading think wrapper before JSON parsing")
    try:
        payload = json.loads(content)
    except json.JSONDecodeError as exc:
        raise LLMGenerationError("Model response must be a single JSON object") from exc
    required = {"candidate_rtl", "bottleneck", "rewrite", "expected_timing_gain",
                "area_or_other_cost", "functional_boundaries"}
    if not isinstance(payload, dict) or not required.issubset(payload):
        missing = sorted(required - set(payload) if isinstance(payload, dict) else required)
        raise LLMGenerationError(f"Model JSON is missing required fields: {', '.join(missing)}")
    code = payload["candidate_rtl"]
    if not isinstance(code, str) or not code.strip():
        raise LLMGenerationError("candidate_rtl must be a non-empty string")
    if "\n" not in code and r"\n" in code:
        # Recover only unambiguous source separators, never escapes inside strings.
        if '"' in code or "\\" in code.replace(r"\n", ""):
            raise LLMGenerationError("Ambiguous double-escaped RTL; refusing automatic unescaping")
        code = code.replace(r"\n", "\n")
        normalizations.append("Recovered double-escaped newlines; no strings or other backslashes present")
    explanation = {k: payload[k] for k in required if k != "candidate_rtl"}
    if normalizations:
        explanation["output_format_normalization"] = normalizations
    return _strip_verilog_fence(code), explanation


def build_candidate_prompt(*, current_rtl: str, sta_context: dict, metrics: dict,
                           candidate_index: int, feedback: dict | None = None,
                           area_cap_um2: float | None = None) -> dict:
    constraints = [
        "Return one JSON object with fields candidate_rtl, bottleneck, rewrite, expected_timing_gain, area_or_other_cost, functional_boundaries.",
        "candidate_rtl must contain only synthesizable Verilog/SystemVerilog source code.",
        "Keep module timing_adder ports, reset behavior, and cycle-by-cycle output behavior unchanged.",
        "Do not add latency or change the SDC assumptions.",
        "Target the supplied measured path; discuss area cost honestly.",
        "Do not include shell commands, Python, markdown, or prose outside the JSON object."
    ]
    if area_cap_um2 is not None:
        constraints.append(
            f"Hard fixed mapped-area cap: {area_cap_um2:.4f} square microns. "
            "The candidate must remain at or below this cap; do not trade area above it for timing."
        )
    return {
        "task": "Rewrite this timing_adder RTL to improve the measured critical-path WNS.",
        "constraints": constraints,
        "candidate_index": candidate_index,
        "current_metrics": metrics,
        "critical_path": sta_context,
        "previous_candidate_eda_feedback": feedback,
        "current_rtl": current_rtl,
    }


def request_parameters_for_model(model: str, temperature: float = 0.2) -> dict:
    """Return API sampling parameters supported by the requested model family."""
    if model.lower().startswith(("gpt-6-", "gpt-6.")):
        # GPT-6 reasoning requests reject temperature unless reasoning_effort=none.
        # Keep reasoning enabled for RTL optimization and omit temperature.
        return {"reasoning_effort": "medium"}
    return {"temperature": temperature}


def generate_candidate(*, current_rtl: str, sta_context: dict, metrics: dict,
                       model: str, candidate_index: int, timeout_s: int = 120,
                       feedback: dict | None = None,
                       area_cap_um2: float | None = None,
                       audit_dir: Path | None = None) -> GeneratedCandidate:
    api_key = os.environ.get("OPENAI_API_KEY", "").strip()
    if not api_key:
        raise LLMGenerationError(
            "OPENAI_API_KEY is not configured. Use --candidate-rtl PATH for a manual candidate."
        )
    base_url = os.environ.get("OPENAI_BASE_URL", "https://api.openai.com/v1").rstrip("/")
    prompt = build_candidate_prompt(current_rtl=current_rtl, sta_context=sta_context,
                                    metrics=metrics, candidate_index=candidate_index,
                                    feedback=feedback, area_cap_um2=area_cap_um2)
    request_parameters = request_parameters_for_model(model, 0.2)
    body = json.dumps({
        "model": model,
        **request_parameters,
        "response_format": {"type": "json_object"},
        "messages": [
            {"role": "system", "content": "You are a conservative RTL timing optimization engineer. Preserve sequential semantics."},
            {"role": "user", "content": json.dumps(prompt, ensure_ascii=False)},
        ],
    }).encode("utf-8")
    if audit_dir is not None:
        audit_dir.mkdir(parents=True, exist_ok=False)
        (audit_dir / "request.json").write_text(json.dumps({
            "endpoint": f"{base_url}/chat/completions", "body": json.loads(body),
            "http_transport": http_transport(),
            "credentials": "Authorization header omitted",
        }, indent=2, ensure_ascii=False), encoding="utf-8")
    request = urllib.request.Request(
        f"{base_url}/chat/completions", data=body,
        headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
        method="POST",
    )
    try:
        if http_transport() == "curl":
            response_json = _curl_json(request, timeout_s, audit_dir=audit_dir)
        else:
            with urllib.request.urlopen(request, timeout=timeout_s) as response:
                response_json = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        # Never include request headers or credential-bearing objects in logs.
        raise LLMGenerationError(f"LLM API returned HTTP {exc.code}") from None
    except (urllib.error.URLError, TimeoutError, OSError) as exc:
        raise LLMGenerationError(f"LLM API request failed: {type(exc).__name__}: {exc}") from None
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise LLMGenerationError(f"LLM API returned invalid JSON ({type(exc).__name__})") from None
    if audit_dir is not None:
        audit_response = {k: response_json[k] for k in
                          ("id", "object", "created", "model", "usage", "system_fingerprint") if k in response_json}
        audit_response["choices"] = [{
            "index": choice.get("index"), "finish_reason": choice.get("finish_reason"),
            "message": {k: choice.get("message", {}).get(k) for k in ("role", "content")},
        } for choice in response_json.get("choices", [])]
        audit_response["audit_scope"] = "Provider envelope and visible message content; reasoning fields omitted."
        (audit_dir / "response.json").write_text(json.dumps(audit_response, indent=2, ensure_ascii=False), encoding="utf-8")
    try:
        content = response_json["choices"][0]["message"]["content"]
    except (KeyError, IndexError, TypeError):
        raise LLMGenerationError("LLM API response has no choices[0].message.content") from None
    rtl, explanation = _parse_content(content)
    usage = response_json.get("usage", {})
    return GeneratedCandidate(
        rtl=rtl,
        explanation=explanation,
        model=str(response_json.get("model", model)),
        generation_parameters={
            "requested_model": model,
            "http_transport": http_transport(),
            **request_parameters,
            "candidate_index": candidate_index,
            "usage": {k: usage[k] for k in ("prompt_tokens", "completion_tokens", "total_tokens") if k in usage},
        },
    )


def generate_from_prompt(prompt_text: str, *, model: str, temperature: float = 0.2,
                         candidate_index: int = 1, timeout_s: int = 120,
                         audit_dir: Path | None = None) -> GeneratedCandidate:
    """Call the configured compatible endpoint using an already frozen prompt."""
    api_key = os.environ.get("OPENAI_API_KEY", "").strip()
    if not api_key:
        raise LLMGenerationError("OPENAI_API_KEY is not configured")
    base_url = os.environ.get("OPENAI_BASE_URL", "https://api.openai.com/v1").rstrip("/")
    request_parameters = request_parameters_for_model(model, temperature)
    payload = {
        "model": model, **request_parameters,
        "response_format": {"type": "json_object"},
        "messages": [
            {"role": "system", "content": "Optimize synthesizable RTL conservatively. Preserve sequential behavior."},
            {"role": "user", "content": prompt_text},
        ],
    }
    body = json.dumps(payload).encode("utf-8")
    if audit_dir is not None:
        audit_dir.mkdir(parents=True, exist_ok=False)
        (audit_dir / "request.json").write_text(json.dumps({
            "endpoint": f"{base_url}/chat/completions", "body": payload,
            "http_transport": http_transport(),
            "credentials": "Authorization header omitted",
        }, indent=2, ensure_ascii=False), encoding="utf-8")
    request = urllib.request.Request(
        f"{base_url}/chat/completions", data=body,
        headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}, method="POST")
    try:
        if http_transport() == "curl":
            result = _curl_json(request, timeout_s, audit_dir=audit_dir)
        else:
            with urllib.request.urlopen(request, timeout=timeout_s) as response:
                result = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        raise LLMGenerationError(f"LLM API returned HTTP {exc.code}") from None
    except (urllib.error.URLError, TimeoutError, OSError) as exc:
        raise LLMGenerationError(f"LLM API request failed: {type(exc).__name__}: {exc}") from None
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise LLMGenerationError(f"LLM API returned invalid JSON ({type(exc).__name__})") from None
    if audit_dir is not None:
        # Preserve the returned visible content before schema parsing, including invalid RTL/JSON.
        # Do not save Authorization headers or provider reasoning fields.
        audit_response = {k: result[k] for k in
                          ("id", "object", "created", "model", "usage", "system_fingerprint") if k in result}
        audit_response["choices"] = [{
            "index": choice.get("index"), "finish_reason": choice.get("finish_reason"),
            "message": {k: choice.get("message", {}).get(k) for k in ("role", "content")},
        } for choice in result.get("choices", [])]
        audit_response["audit_scope"] = "Provider envelope and visible message content; reasoning fields omitted."
        (audit_dir / "response.json").write_text(json.dumps(audit_response, indent=2, ensure_ascii=False), encoding="utf-8")
    try:
        content = result["choices"][0]["message"]["content"]
    except (KeyError, IndexError, TypeError):
        raise LLMGenerationError("LLM API response has no choices[0].message.content") from None
    rtl, explanation = _parse_content(content)
    usage = result.get("usage", {})
    return GeneratedCandidate(
        rtl=rtl, explanation=explanation,
        model=result.get("model") if isinstance(result.get("model"), str) else None,
        generation_parameters={
            "requested_model": model, **request_parameters,
            "http_transport": http_transport(),
            "response_format": "json_object", "candidate_index": candidate_index,
            "response_id": result.get("id"), "response_created": result.get("created"),
            "finish_reason": result.get("choices", [{}])[0].get("finish_reason"),
            "usage": {k: usage[k] for k in ("prompt_tokens", "completion_tokens", "total_tokens") if k in usage},
        },
    )
