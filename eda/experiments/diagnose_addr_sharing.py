"""Post-hoc synthesis diagnostic. Never used in the frozen six generation prompts."""
from collections import Counter,deque
import hashlib
import json
import os
from pathlib import Path
import subprocess
ROOT=Path(__file__).resolve().parents[2]
s=ROOT/"eda/experiments/timing_feedback_ablation_addr_calcu_20261030_214426_830978"
d=s/"diagnostics_posthoc"
before=json.loads((s/"baseline/evaluation/eda/candidate_schema.json").read_text())["modules"]["addr_calcu"]
after=json.loads((d/"actual_fine_prefix.json").read_text())["modules"]["addr_calcu"]
start=after["ports"]["control"]["bits"][0]
end=after["ports"]["count"]["bits"][10]
graph={}
for name,c in after["cells"].items():
    cn=("cell",name)
    for port,bits in c["connections"].items():
        direction=c["port_directions"][port]
        for bit in bits:
            if not isinstance(bit,int): continue
            bn=("bit",bit)
            u,v=(bn,cn) if direction=="input" else (cn,bn)
            graph.setdefault(u,[]).append(v)
origin=("bit",start); target=("bit",end)
queue=deque([origin]); prev={origin:None}
while queue:
    u=queue.popleft()
    if u==target: break
    for v in graph.get(u,[]):
        if v not in prev:
            prev[v]=u
            queue.append(v)
assert target in prev
chain=[]; u=target
while u is not None:
    if u[0]=="cell":
        c=after["cells"][u[1]]
        chain.append({"cell":u[1],"type":c["type"],"source":c.get("attributes",{}).get("src")})
    u=prev[u]
chain.reverse()
assert [c["type"] for c in chain]==["$mux","$alu","$alu","$alu"]
mapping=s/"baseline/evaluation/eda/mapping.log"
lines=mapping.read_text(encoding="utf-8").splitlines()
events=[]
for index,line in enumerate(lines):
    if "Found cells that share an operand and can be merged by moving" in line:
        events.append({"source_line":index+1,"text":"\n".join(lines[index:index+7])})
assert events
formal=(s/"baseline/evaluation/eda/formal.ys").read_text(encoding="utf-8").splitlines()
assert formal[0]==formal[5] and formal[5].startswith("read_verilog")
formal[5]=f'read_json "{(d/"actual_fine_prefix.json").as_posix()}"'
formal[8:8]=["techmap","opt"]
ys=d/"postsharing_equiv.ys"
ys.write_text("\n".join(formal)+"\n",encoding="utf-8")
env=os.environ.copy(); env.pop("OPENAI_API_KEY",None)
env["PATH"]=os.pathsep.join([r"D:\oss-cad-suite\bin",r"D:\oss-cad-suite\lib",env.get("PATH","")])
p=subprocess.run([r"D:\oss-cad-suite\bin\yosys.exe","-Q","-l",str(d/"postsharing_equiv.log"),str(ys)],cwd=ROOT,env=env,
                 stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=180)
(d/"postsharing_equiv_stdout.log").write_bytes(p.stdout)
assert p.returncode==0 and b"SAT proof finished - no model found: SUCCESS!" in p.stdout
result={
    "stage":"End of coarse plus fine-phase initial opt/memory_map/opt prefix, before gate techmap",
    "not_the_final_mapped_netlist":True,
    "posthoc_not_supplied_to_current_llm_prompts":True,
    "original_mapping_log_sha256":hashlib.sha256(mapping.read_bytes()).hexdigest(),
    "observed_sharing_events_in_actual_baseline_log":events,
    "pre_synth_operator_counts":dict(Counter(c["type"] for c in before["cells"].values())),
    "post_shared_operator_counts":dict(Counter(c["type"] for c in after["cells"].values())),
    "control_to_count10_potential_chain":chain,
    "precision":"Conservative whole-cell input-to-output connectivity, not sensitized bit-level timing or exact mapped-gate-to-source localization",
    "source_attrs_missing_on_created_mux":chain[0]["source"] is None,
    "intermediate_json_equivalence_to_original_default_instance":"FULL_INPUT_SAT_PASS",
    "initial_probe_scope":"capture.ys/post_resource_sharing.json used an earlier partial-pass experiment; authoritative actual coarse/fine-prefix capture is capture_actual_prefix.ys/actual_fine_prefix.json",
    "supported_observation":"The synthesis flow already moves the control mux ahead of shared arithmetic. Pre-synthesis source cone alone omits that transformed structure.",
    "unproven_hypothesis":"Adding synthesis-transform context may prevent redundant rewrite suggestions; effect on LLM quality requires a new controlled ablation.",
}
(d/"DIAGNOSIS.json").write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding="utf-8")
report="""# 综合变换诊断（事后，未进入当前提示）

当前冻结研究的源码反馈来自综合前的 proc/flatten/opt 图，其中 control→count[10] 的保守依赖链只有末端 mux。它不是精确的标准单元路径定位。

实际 baseline/evaluation/eda/mapping.log 明确记录 OPT_SHARE 将 mux 移到被合并的算术单元前。另按同一综合流程的 coarse 及 fine 起始优化捕获中间结构：共三个 $alu 和一个综合器新建 mux。control 到 count[10] 的保守整单元连接链为 mux→alu→alu→alu，证明源码层和资源共享后的结构位置不同。

actual_fine_prefix.json 已通过额外的完整输入 SAT 证明，确认该默认参数中间设计与原 RTL 等价。postsharing_equiv.log 为实际证明日志。

这里的整单元链对输入/输出位进行保守连接，不证明具体路径敏化，也不是最终门级关键路径。综合器创建的 mux 没有 src 属性，必须保留这一缺失，不能伪造源码行。

capture.ys/post_resource_sharing.json 是早期部分阶段的探测，不能当成最终门级图；真正带 coarse 算术单元的阶段捕获为 capture_actual_prefix.ys/actual_fine_prefix.json。两份均保留，DIAGNOSIS.json 明确区分。

当前路径组 candidate_01 的公开解释将瓶颈描述为两路算术结果的末端选择，并提出把选择前移、共享运算；而综合器已经执行了相应类别的变换。这个不匹配可核查，但不能单凭一例认定它造成全部性能下降，也不能证明增加综合日志一定有收益。

下一步可测试的机制是：把经过功能证明的综合后结构、已执行变换以及缺失源码归属一起提供给 LLM，避免把源码形态当作最终电路。需要另设反馈条件、冻结同等预算并保留负结果；不得回填本次提示或修改本次成绩。
"""
(d/"DIAGNOSIS.md").write_text(report,encoding="utf-8")
print(json.dumps({"post_synthesis_diagnostic":"PASS","extra_intermediate_formal":"PASS",
                  "pre_types":result["pre_synth_operator_counts"],"post_types":result["post_shared_operator_counts"],
                  "chain":[c["type"] for c in chain],"not_in_prompts":True}))

