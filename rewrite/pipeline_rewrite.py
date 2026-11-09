from pathlib import Path
import re

def suggest_pipeline(rtl_text: str):
    """
    Conservative first MVP:
    identify long combinational assignments and report candidate lines.
    It intentionally does NOT silently change sequential semantics.
    """
    candidates = []
    lines = rtl_text.splitlines()
    for i, line in enumerate(lines, 1):
        s = line.strip()
        if "<=" in s and "if" not in s and "case" not in s:
            if any(op in s for op in ("+", "*", "&", "|", "^")):
                candidates.append({
                    "line": i,
                    "text": s,
                    "reason": "sequential assignment containing combinational logic"
                })
    return candidates

def insert_register_example(rtl_text: str):
    raise NotImplementedError(
        "Automatic pipeline insertion is deliberately disabled in the safe MVP. "
        "A legal rewrite must be generated only after module ports, clock/reset, "
        "latency constraints, and functional equivalence checks are known."
    )
