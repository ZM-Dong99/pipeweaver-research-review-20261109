"""Summarize OpenSTA JSON paths using the corresponding mapped netlist; no LLM calls."""
from collections import Counter, defaultdict
import argparse
import hashlib
import json
import math
from pathlib import Path


def scaled(value, factor):
    if value is None:
        return None
    result = float(value) * factor
    if not math.isfinite(result):
        raise ValueError("Nonfinite STA number")
    return round(result, 9)


def summarize(report, module):
    cells = module["cells"]
    sinks = Counter()
    for cell in cells.values():
        for port, direction in cell["port_directions"].items():
            if direction == "input":
                sinks.update(bit for bit in cell["connections"][port] if isinstance(bit, int))
    for port in module["ports"].values():
        if port["direction"] == "output":
            sinks.update(bit for bit in port["bits"] if isinstance(bit, int))
    paths, overlap = [], defaultdict(list)
    for index, check in enumerate(report["checks"], 1):
        arcs, unresolved = [], []
        pins = check["source_path"]
        for previous, node in zip(pins, pins[1:]):
            instance = node.get("instance")
            if not instance or previous.get("instance") != instance:
                continue
            cell = cells.get(instance)
            if cell is None:
                unresolved.append(instance)
                continue
            pin = node["pin"][len(instance) + 1:]
            input_pin = previous["pin"][len(instance) + 1:]
            if cell["port_directions"].get(pin) != "output" or cell["port_directions"].get(input_pin) != "input":
                continue
            bits = cell["connections"][pin]
            arc = {
                "instance": instance, "cell_type": cell["type"],
                "input_pin": input_pin, "output_pin": pin,
                "cell_arc_delay_ns": scaled(node["arrival"] - previous["arrival"], 1e9),
                "output_slew_ns": scaled(node.get("slew"), 1e9),
                "output_capacitance_pf": scaled(node.get("capacitance"), 1e12),
                "sink_pin_count_in_mapped_netlist": sinks[bits[0]] if len(bits) == 1 else None,
                "verilog_src_reported_by_sta": node.get("verilog_src") or None,
            }
            if arc["cell_arc_delay_ns"] < -1e-6:
                raise ValueError(f"Negative cell arc delay on {instance}; unsupported path format")
            arcs.append(arc)
        for instance in set(a["instance"] for a in arcs):
            overlap[instance].append(index)
        source = pins[0]
        paths.append({
            "rank_in_report": index, "startpoint": check["startpoint"], "endpoint": check["endpoint"],
            "max_data_arrival_ns": scaled(check["data_arrival_time"], 1e9),
            "slack_ns": scaled(check["slack"], 1e9),
            "startpoint_slew_ns": scaled(source.get("slew"), 1e9),
            "startpoint_capacitance_pf": scaled(source.get("capacitance"), 1e12),
            "mapped_cell_arcs": arcs,
            "resolved_cell_arc_count": len(arcs),
            "largest_cell_arcs": sorted(arcs, key=lambda a: -a["cell_arc_delay_ns"])[:5],
            "unresolved_instances": sorted(set(unresolved)),
        })
    return {
        "status": "PARTIAL" if any(p["unresolved_instances"] for p in paths) else "PASS",
        "scope": "Structured measured gate-path evidence. Arc deltas use reported JSON arrival timestamps and inherit their rounding. Cell occurrences across correlated paths are not independent timing gains.",
        "unit_conversion": {"OpenSTA_JSON_time": "seconds", "output_time": "ns", "time_factor": 1e9,
                            "OpenSTA_JSON_capacitance": "farads", "output_capacitance": "pF", "capacitance_factor": 1e12},
        "fanout_definition": "Number of mapped input-pin connections plus top output-port connections on a net; not a physical wire estimate.",
        "path_count": len(paths), "paths": paths,
        "common_cells": [{"instance": inst, "cell_type": cells[inst]["type"],
                          "path_occurrences": len(ranks), "path_ranks": ranks}
                         for inst, ranks in sorted(overlap.items(), key=lambda x: (-len(x[1]), x[0]))],
        "source_mapping": "Only verilog_src values actually returned by OpenSTA are retained. Empty source attributes are not replaced with inferred RTL line numbers.",
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("sta_json", type=Path)
    parser.add_argument("--mapped-json", type=Path, required=True)
    parser.add_argument("--top", required=True)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    report = json.loads(args.sta_json.read_text(encoding="utf-8"))
    module = json.loads(args.mapped_json.read_text(encoding="utf-8"))["modules"][args.top]
    result = summarize(report, module)
    result["input_sha256"] = {str(p): hashlib.sha256(p.read_bytes()).hexdigest()
                              for p in (args.sta_json, args.mapped_json)}
    args.out.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"path_count": result["path_count"], "first_path": {
        k: result["paths"][0][k] for k in ("startpoint", "endpoint", "max_data_arrival_ns", "largest_cell_arcs")
    }}, indent=2))
    if result["status"] != "PASS":
        raise SystemExit("Unresolved STA instances: use JSON read back from the exact STA input Verilog; Yosys internal JSON names may differ after export.")
