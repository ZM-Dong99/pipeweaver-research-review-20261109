"""Conservatively trace a STA input/output bit pair through Yosys RTLIL JSON.

This reports an RTL operator cone, not an exact mapping from ABC gates to source lines.
Unsupported operator semantics are omitted and disclosed.
"""
from __future__ import annotations
import argparse, json, re
from collections import defaultdict, deque
from pathlib import Path

SIG = re.compile(r"^([A-Za-z_$][A-Za-z0-9_$]*)(?:\[(-?\d+)\])?(?:\s|$)")

def declared_indices(net: dict) -> list[int]:
    """Translate JSON's LSB-first positions to the declared Verilog indices."""
    offset = int(net.get("offset", 0))
    indices = list(range(offset, offset + len(net["bits"])))
    return list(reversed(indices)) if net.get("upto", 0) else indices

def endpoint_bit(port: dict, index: int | None) -> int:
    if index is None:
        if len(port["bits"]) != 1:
            raise ValueError("A bus endpoint requires an explicit declared [bit] index")
        bit = port["bits"][0]
    else:
        indices = declared_indices(port)
        if index not in indices:
            raise ValueError("STA endpoint bit is outside the declared Verilog range")
        bit = port["bits"][indices.index(index)]
    if not isinstance(bit, int):
        raise ValueError("STA endpoint is a constant rather than a signal")
    return bit

def parse_endpoint(value: str) -> tuple[str, int | None]:
    m = SIG.match(value.strip())
    if not m: raise ValueError(f"Unsupported endpoint syntax: {value}")
    return m.group(1), int(m.group(2)) if m.group(2) is not None else None

def param_int(cell: dict, name: str, default: int = 0) -> int:
    raw = cell.get("parameters", {}).get(name)
    if raw is None: return default
    return int(raw, 2)

def source_record(cell: dict, name: str, kind: str) -> dict:
    src = cell.get("attributes", {}).get("src")
    line = None
    if src:
        m = re.search(r":(\d+)(?:\.\d+)?", src)
        if m: line = int(m.group(1))
    return {"cell": name, "type": kind, "src": src, "line": line}

def cell_dependencies(cell: dict) -> dict | None:
    """Conservative RTLIL bit dependencies; no timing weights or path sensitization."""
    kind, con = cell["type"], cell["connections"]
    outs = [p for p, d in cell["port_directions"].items() if d == "output"]
    if outs != ["Y"] or not con.get("Y"):
        return None
    width = len(con["Y"])

    def indexed(port, index, signed=False):
        bits = con[port]
        if index < len(bits):
            return (port, index, bits[index])
        if signed and bits:
            return (port, len(bits)-1, bits[-1])
        return (port, index, "0")

    if kind in ("$add", "$sub") and all(p in con for p in ("A", "B")):
        # Carry/borrow into bit j cannot depend on input bits above j.
        # Different input/output widths, including a widened carry output, are supported.
        return {j: [(p, k, bit) for p in ("A", "B")
                    for k, bit in enumerate(con[p][:j+1])] for j in range(width)}
    if kind in ("$and", "$or", "$xor", "$xnor") and all(p in con for p in ("A", "B")):
        # If signedness differs, retaining a possible sign-bit dependency over-approximates
        # either extension interpretation; it never assigns a measured timing delay.
        signed = bool(param_int(cell, "A_SIGNED") or param_int(cell, "B_SIGNED"))
        return {j: [indexed(p, j, signed) for p in ("A", "B")] for j in range(width)}
    if kind in ("$not", "$pos") and "A" in con:
        return {j: [indexed("A", j, bool(param_int(cell, "A_SIGNED")))] for j in range(width)}
    if kind in ("$eq", "$ne", "$eqx", "$nex", "$lt", "$le", "$gt", "$ge") and all(p in con for p in ("A", "B")):
        return {0: [(p, k, bit) for p in ("A", "B") for k, bit in enumerate(con[p])]}
    if kind in ("$logic_not", "$reduce_and", "$reduce_or", "$reduce_xor", "$reduce_xnor", "$reduce_bool") and "A" in con:
        return {0: [("A", k, bit) for k, bit in enumerate(con["A"])]}
    if kind == "$mux" and all(p in con for p in ("A", "B", "S")):
        if len(con["A"]) == len(con["B"]) == width and len(con["S"]) == 1:
            return {j: [indexed("A", j), indexed("B", j), indexed("S", 0)] for j in range(width)}
    if kind == "$pmux" and all(p in con for p in ("A", "B", "S")):
        if len(con["A"]) == width and len(con["B"]) == width * len(con["S"]):
            # Every selector may affect every output. This does not assert simultaneous
            # select activation or prove that a structural path is functionally sensitizable.
            return {j: [indexed("A", j)]
                       + [indexed("B", k*width+j) for k in range(len(con["S"]))]
                       + [indexed("S", k) for k in range(len(con["S"]))] for j in range(width)}
    return None

def trace(module: dict, top: str, start: str, end: str) -> dict:
    ports = module["ports"]
    sn, si = parse_endpoint(start); en, ei = parse_endpoint(end)
    if sn not in ports or en not in ports: raise ValueError("STA endpoints must name top-level ports")
    if ports[sn]["direction"] != "input" or ports[en]["direction"] != "output":
        raise ValueError("This tracer supports top-level input-to-output STA paths only")
    source_bit, target_bit = endpoint_bit(ports[sn], si), endpoint_bit(ports[en], ei)
    graph: dict[object, list[tuple[object, dict]]] = defaultdict(list)
    reverse: dict[object, list[tuple[object, dict]]] = defaultdict(list)
    unsupported: dict[str, int] = defaultdict(int)
    cells_by_name = module.get("cells", {})
    modeled=0
    for cname, cell in cells_by_name.items():
        ctype=cell["type"]
        deps = cell_dependencies(cell)
        if deps is None:
            unsupported[ctype]+=1; continue
        outport, outbits = "Y", cell["connections"]["Y"]
        modeled+=1
        rec=source_record(cell,cname,ctype)
        for j,ybit in enumerate(outbits):
            if not isinstance(ybit,int): continue
            for pin,idx,xbit in deps.get(j, []):
                if isinstance(xbit,int):
                    edge={**rec,"input_port":pin,"input_bit":idx,"output_port":outport,"output_bit":j}
                    graph[xbit].append((ybit,edge)); reverse[ybit].append((xbit,edge))
    def walk(startbit, g):
        seen={startbit}; q=deque([startbit])
        while q:
            u=q.popleft()
            for v,_ in g.get(u,[]):
                if v not in seen: seen.add(v); q.append(v)
        return seen
    fw=walk(source_bit,graph); bw=walk(target_bit,reverse)
    if target_bit not in fw:
        return {"status":"NO_SUPPORTED_PATH_FOUND","meaning":"No path found among the supported bit-dependency rules; this is inconclusive if unsupported cells remain.","top":top,"start":start,"end":end,"supported_cells_modeled":modeled,"unsupported_cell_types":dict(sorted(unsupported.items()))}
    cone_edges=[]
    cone_cells={}
    for u, edges in graph.items():
        if u not in fw: continue
        for v,edge in edges:
            if v in bw:
                cone_edges.append({"from_bit":u,"to_bit":v,**edge})
                cone_cells[edge["cell"]]=edge
    # One shortest structural dependency path, alongside the broader set of cells that can lie on any path.
    parent={source_bit:None}; q=deque([source_bit])
    while q and target_bit not in parent:
        u=q.popleft()
        for v,e in graph.get(u,[]):
            if v not in parent: parent[v]=(u,e); q.append(v)
    path=[]; cur=target_bit
    while cur!=source_bit and cur in parent:
        prev,e=parent[cur]; path.append({"from_bit":prev,"to_bit":cur,**e}); cur=prev
    path.reverse()
    name_aliases=defaultdict(list)
    for name,net in module.get("netnames",{}).items():
        for idx,bit in zip(declared_indices(net), net["bits"]):
            if isinstance(bit,int):
                label = name if len(net["bits"]) == 1 and idx == 0 else f"{name}[{idx}]"
                name_aliases[bit].append(label)
    for bit, aliases in name_aliases.items():
        name_aliases[bit] = sorted(set(aliases), key=lambda x:(x.startswith("$"), len(x), x))
    for edge in path:
        edge["from_net_aliases"] = name_aliases.get(edge["from_bit"], [])[:6]
        edge["to_net_aliases"] = name_aliases.get(edge["to_bit"], [])[:6]
    selected=sorted((source_record(cells_by_name[name], name, cells_by_name[name]["type"])
                     for name in cone_cells), key=lambda x:(x.get("src") or "",x["cell"]))
    src_selected=sum(bool(x.get("src")) for x in selected)
    return {
        "status":"CONSERVATIVE_RTL_OPERATOR_CONE_FOUND",
        "meaning":"These RTLIL operator cells have structural bit dependencies from the STA start bit to the STA end bit. This is a conservative cone, not proof that every listed cell is on the exact mapped timing path.",
        "top":top,"sta_startpoint":start,"sta_endpoint":end,
        "start_net_aliases":name_aliases.get(source_bit,[])[:20],"end_net_aliases":name_aliases.get(target_bit,[])[:20],
        "rtl_operator_cells_on_possible_cone_paths":len(selected),"source_attributed_selected_cells":src_selected,
        "source_attribution_coverage":(src_selected/len(selected) if selected else None),
        "coverage_scope":"Source attributes among the selected pre-ABC supported RTLIL cells only; this is not mapped-gate localization accuracy.",
        "rtl_source_locations":sorted({x["src"] for x in selected if x.get("src")}),
        "candidate_cells":selected,
        "shortest_structural_dependency_path":path,
        "structural_path_edge_count":len(path),"all_possible_cone_edge_count":len(cone_edges),
        "chain_warning":"One shortest structural dependency chain, not the longest mapped timing path. Synthesis may restructure the source arithmetic; do not infer mapped serial adder depth from RTL adder count.",
        "supported_cells_modeled":modeled,"unsupported_cell_types":dict(sorted(unsupported.items())),
        "precision":"BIT_LEVEL_CONSERVATIVE; unknown cell types are omitted. Add/sub carry or borrow may depend on lower operand bits. Mux/decoder dependencies are potential dependencies, not proof of path sensitization or mapped timing depth.",
    }

def main() -> int:
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("schema",type=Path); ap.add_argument("--top",required=True); ap.add_argument("--start",required=True); ap.add_argument("--end",required=True); ap.add_argument("--out",type=Path,required=True)
    a=ap.parse_args(); data=json.loads(a.schema.read_text(encoding="utf-8")); mod=data["modules"][a.top]
    result=trace(mod,a.top,a.start,a.end); a.out.write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding="utf-8")
    print(json.dumps({k:result.get(k) for k in ("status","meaning","sta_startpoint","sta_endpoint","rtl_operator_cells_on_possible_cone_paths","source_attributed_selected_cells","source_attribution_coverage","rtl_source_locations","unsupported_cell_types","precision")},indent=2,ensure_ascii=False))
    return 0 if result["status"]=="CONSERVATIVE_RTL_OPERATOR_CONE_FOUND" else 2
if __name__=="__main__": raise SystemExit(main())
