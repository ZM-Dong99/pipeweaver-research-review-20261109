from pathlib import Path
import json,hashlib,shutil
R=Path(r'D:\verilog_lab\PipeWeaver');S=R/'eda/experiments/mux_action_development_20261104_154849_392802'
def load(f):return json.loads((S/f).read_text(encoding='utf-8'))
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
s=load('SUMMARY.json');a=load('AUDIT.json');r=load('REPRODUCTION.json');p=load('protocol.json')
assert a['passed'] and r['passed'];b=s['baseline'];best=s['results'][s['selected']]
lines=['# 数据选择器家族：冻结动作开发结果（零API）','',
       '日期：2026-11-04。公开RTL-OPT的mux_large，10路8位输入、4位选择，原始23行。属于selection家族，与前期优先编码器不同；短组合模块仍不代表大型工程系统。', '',
       '六份候选一次性冻结后再测量。每份均直接与原始设计比较所有输入、所有输出；sel=10～15必须输出block_a，无输入约束或无效输出豁免。形式证明覆盖二态语义，不宣称X/Z四态仿真等价。', '',
       '| 版本 | 到达时间(ns) | 面积(µm²) | 面积变化 | 10%上限内 |', '|---|---|---|---|---|',
       f"| 原始 | {b['max_data_arrival_ns']:.2f} | {b['mapped_area_um2']:.4f} | — | 是 |"]
for i,m in s['results'].items():
    delta=(m['mapped_area_um2']/b['mapped_area_um2']-1)*100
    lines.append(f"| {i} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} | {delta:+.2f}% | {'是' if delta<=10 else '否'} |")
lines += ['', '采用decoded_masks：延迟降低13.46%、面积降低9.17%。所有六动作均通过源级和映射后SAT等价、OpenSTA以及电气检查；五种更快结构均超过面积上限，没有事后放宽。10%是实验规则，不是通用工程标准。', '',
          '原始设计以case选择十路数据并设置默认分支。采用的结构显式计算十路选择掩码，其中block_a条件为sel==0或sel>=10，最后按位与、或形成输出。这是标准译码逻辑改写，不宣称新的电路算法。', '',
          '原始关键路径sel[3]→block_out[2]；改写后sel[1]→block_out[0]。这些是实际映射后STA端点；不能仅据此声称已完成逐门到RTL源码归因。', '',
          f"共7个完整本地评估（原始+6候选），{a['check_count']}项审计通过；原始与选中候选另做2次独立完整复跑，延迟、面积和映射网表哈希一致。不是9个独立模型样本。模型调用0次。", '',
          '结论边界：证明了不同电路家族的动作空间中存在可复现改进；不证明STA反馈比无反馈模型好，也不计入STA组较好的案例数。本动作PPA已暴露，后续在本案例开展模型对照必须标注开发条件，不能称盲测。当前只有一个动作满足10%上限，固定选择该动作就是很强的简单参照，应纳入后续设计。', '',
          '全部原始数据：[冻结协议](protocol.json)、[结果](SUMMARY.json)、[审计](AUDIT.json)、[独立复跑](REPRODUCTION.json)。各evaluations目录包含formal.log、mapped_formal.log、mapping.log、sta.log和result.json；independent_reproduction保存复跑原始文件。', '',
          '可复用输出：[best.v](exports/best.v)，模块mux_large，接口及默认输入行为保持原始设计；附MIT许可证。保留所有未采用动作，不删除超面积记录。', '',
          '性能是固定SKY130HD TT库、输入转换0.10ns、输出负载0.010pF、理想虚拟时钟下的布局布线前估计，不是物理签核、功耗或硅片频率结果。']
(S/'INTERPRETATION.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
(S/'exports').mkdir(exist_ok=True);shutil.copyfile(S/'candidates'/(s['selected']+'.v'),S/'exports/best.v');shutil.copyfile(S/'inputs/LICENSE',S/'exports/LICENSE')
snapshot=['protocol.json','SUMMARY.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md','exports/best.v']
e={'status':'LOCAL_DEVELOPMENT_COMPLETE_AUDITED_REPRODUCED','family':'selection','model_requests':0,'complete_eda_evaluations':7,'independent_reproductions':2,'audit_checks':a['check_count'],'selected':s['selected'],'baseline_delay_ns':b['max_data_arrival_ns'],'selected_delay_ns':best['max_data_arrival_ns'],'baseline_area_um2':b['mapped_area_um2'],'selected_area_um2':best['mapped_area_um2'],'sta_method_advantage_tested':False,'hashes':{f:sha(S/f) for f in snapshot}}
(S/'FINAL_EVIDENCE.json').write_text(json.dumps(e,indent=2),encoding='utf-8')
rel=str(S.relative_to(R)).replace('\\','/')
for file,prefix in [(R/'EXPERIMENT_INDEX.md',''),(R/'docs/CURRENT_STATUS.md','../')]:
    text=file.read_text(encoding='utf-8');entry='2026-11-04新增数据选择器家族本地开发：10x8 mux_large显式译码从1.04→0.90ns（-13.46%）、面积914.6272→830.7968µm²（-9.17%）。7次完整验证与STA、57项审计、2次独立复跑通过。其余5个动作面积超原110%被保留但不采用。零API调用，不计为第三个STA胜出案例。 [全部真实证据]('+prefix+rel+'/INTERPRETATION.md)。\n\n'
    if entry not in text:file.write_text(entry+text,encoding='utf-8')
print(json.dumps(e,indent=2))
