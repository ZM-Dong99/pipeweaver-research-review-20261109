"""Publish all development outcomes and tool-fix evidence, without new experiments."""
from pathlib import Path
import sys,json,hashlib
R=Path(r'D:\verilog_lab\PipeWeaver');sys.path.insert(0,str(R/'eda/experiments'))
from run_native_comb import resolved_native_path,q
E=R/'eda/experiments';F=E/'tool_isolation_fix_20261105_141047_548029';A=E/'mixed_localization_20261105_141351_477871';B=E/'mixed_block_mapping_20261105_142005_822258'
def load(f):return json.loads(f.read_text(encoding='utf-8'))
def sha(f):return hashlib.sha256(f.read_bytes()).hexdigest()
def save(f,x):f.write_text(json.dumps(x,indent=2,ensure_ascii=False),encoding='utf-8')
a=load(A/'SUMMARY.json');b=load(B/'SUMMARY.json');pa=load(A/'protocol.json');pb=load(B/'protocol.json')
assert load(A/'AUDIT.json')['passed'] and load(B/'AUDIT.json')['passed'] and load(F/'REGRESSION_V2.json')['passed']
invariants=dict(exact_same_four_RTL_designs=pa['design_sha256']==pb['design_sha256'],exact_same_five_SDC_profiles=pa['sdc_sha256']==pb['sdc_sha256'],same_area_ratio=pa['area_ratio_limit']==pb['area_ratio_limit']==1.10,same_action_budget=pa['action_count_budget']==pb['action_count_budget']==1,same_library=pa['liberty_sha256']==pb['liberty_sha256'])
assert all(invariants.values());save(B/'MAPPING_BOUNDARY_INVARIANTS.json',invariants)
path_checks=dict(normalized_existing_path=resolved_native_path(R)==R,extended_local_path=resolved_native_path(Path('\\\\?\\'+str(R)))==R,quoted_paths_have_no_extended_prefix='//?/' not in q(Path('\\\\?\\'+str(R))))
assert all(path_checks.values());save(F/'PATH_CHECKS.json',path_checks)
tool_note='''# 组合评估器运行隔离修复

2026-11-05非对称实验的原始基线映射失败，日志中的ABC source指向并行候选的abc.script。保留失败批次mixed_localization_20261105_140731_693499，不能用其残缺PPA作比较。

修复仅涉及run_native_comb.py的工具运行隔离与路径规范化：每个输出目录独立作为Yosys工作目录，子进程TMPDIR/TMP/TEMP指向该目录私有yosys_tmp；移除Win32扩展路径前缀后再传给MinGW/ABC和WSL。综合脚本、工艺库、映射策略和时序约束不变，OpenSTA环境未改。代码前后版本与CODE_DIFF.patch保留。

第一次隔离测试的mux_range遇到扩展路径兼容错误，REGRESSION.json与regression/原样保留。修正路径后在regression_v2/新目录运行四个并行测试，REGRESSION_V2.json全部通过：mux_minimal0.80ns/792.0096µm²、mux_range0.90ns/830.7968µm²、priority1281.41ns/4052.6368µm²、comparator241.21ns/833.2992µm²。全部重新完成源级与门级证明、电气和STA，日志均引用自身ABC脚本。

对近期mux/dual/mixed/priority动作研究的102份映射日志扫描，发现1份交叉脚本引用，就是上述未通过映射的基线；不是全仓库或所有历史研究的全面审计，不能据此保证其他未扫描记录无问题。四个关键案例在修复后复现支持其已报告指标。没有删除或覆盖任何原始失败日志。

原冻结研究的评估器快照及哈希保留；当前评估器已经变更，因此旧runner的严格代码指纹检查可能拒绝直接重用，不能修改旧协议哈希以绕过。研究复现应记录新的执行目录与评估器版本。本次修复范围是组合评估器，不声称其他独立时序后端也完成隔离审计。

零API调用。PATH_CHECKS.json保存三项路径检查。REGRESSION_V2.json保存真实完整回归，而不是软件自报通过。
'''
(F/'INTERPRETATION.md').write_text(tool_note,encoding='utf-8');save(F/'FINAL_EVIDENCE.json',dict(status='FIXED_AND_FOUR_CONCURRENT_REGRESSIONS_PASSED',model_requests=0,current_evaluator_sha256=sha(R/'eda/experiments/run_native_comb.py'),historical_scan=load(F/'HISTORICAL_LOG_SCAN.json')['scanned_mapping_logs'],historical_foreign_references=load(F/'HISTORICAL_LOG_SCAN.json')['foreign_script_reference_count'],hashes={f:sha(F/f) for f in ['run_native_comb_before.py','run_native_comb_isolation_v1.py','run_native_comb_after.py','CODE_DIFF.patch','HISTORICAL_LOG_SCAN.json','REGRESSION_PLAN.json','REGRESSION.json','REGRESSION_PLAN_V2.json','REGRESSION_V2.json','PATH_CHECKS.json','INTERPRETATION.md']}))
lines=['# 非对称定位跟进：映射边界是重要条件','',
       '2026-11-05。本次零API。所有版本为手工组合的10路8位选择器+64路优先编码器，148位输入、79位输出，不是新自然工程基准。前期组件及动作已经暴露，不是独立盲测。', '',
       '## 没有省略的开发记录', '',
       '| 记录 | 结果 | 证据目录 |', '|---|---|---|',
       '| 最初并行扁平映射 | 基线映射失败，发现交叉ABC脚本路径 | mixed_localization_20261105_140731_693499 |',
       '| 组合评估器隔离修复 | 第一次测试暴露路径前缀问题；修正后四个关键回归全部通过 | tool_isolation_fix_20261105_141047_548029 |',
       '| 修复后的扁平综合 | 五个配置均改优先编码器最优，定位假设未成立 | mixed_localization_20261105_141351_477871 |',
       '| 首次分块门级组合 | 完整等价证明通过，OpenSTA拒绝索引切片语法 | mixed_block_mapping_20261105_141858_816593 |',
       '| 固定切片修正后的分块映射 | 最优位置随约束变化，候选和约束与扁平实验相同 | mixed_block_mapping_20261105_142005_822258 |', '',
       '这不是在原扁平结果里替换不利数据：两个映射条件的完整结果分开保存。四份RTL、五份SDC、库、面积比例和动作次数预算完全一致，MAPPING_BOUNDARY_INVARIANTS.json记录核对。分块条件只锁定已独立映射的组件，避免未改区域被全局ABC重新映射；它不冒充原有扁平工具流程。', '',
       '## 分块固定映射下的实测结果', '',
       '| 配置 | mux输入延迟 | priority输入延迟 | 原始 | 改mux | 改priority | 最优单动作 |', '|---|---|---|---|---|---|---|']
for profile,v in pb['profiles'].items():
    pool=b['timings'][profile];lines.append(f"| {profile} | {v['mux']:.2f}ns | {v['priority']:.2f}ns | {pool['baseline']['max_data_arrival_ns']:.2f}ns | {pool['rewrite_mux']['max_data_arrival_ns']:.2f}ns | {pool['rewrite_priority']['max_data_arrival_ns']:.2f}ns | {b['oracle'][profile]} |")
lines += ['', '## 简单控制策略（不是模型分组）', '',
          '| 映射条件 | 策略 | 选中单动作最优的配置数 | 至少5%改进配置数 |', '|---|---|---|---|']
for label,s in [('扁平',a),('分块固定',b)]:
    for policy in ['fixed_mux','fixed_priority','largest_input_delay','baseline_sta_endpoint']:
        rows=[x for x in s['policies'] if x['policy']==policy];lines.append(f"| {label} | {policy} | {sum(abs(x['regret_ns'])<1e-8 for x in rows)}/5 | {sum(x['gain_percent']>=5 for x in rows)}/5 |")
lines += ['',
          '分块条件中，真实STA端点规则在5个相关配置都选中最优动作；仅选输入延迟更大区域的规则为2/5，固定优先编码器为4/5。比如mux输入延迟0.50ns时仍应改内部延迟更长的优先编码器，延迟1.73→1.54ns；mux输入延迟0.90ns时才应改mux，1.94→1.73ns。', '',
          '两套流程规则输出都在候选场景STA之前固定，依据只有原始STA端点或完整输入约束，不用候选PPA决定规则动作。源级和门级等价覆盖全部输出，包括valid0编码器默认值。', '',
          '扁平条件中，改变另一区域也改变了未修改区域的映射时序；端点定位不等于最优改写排序，固定优先编码器反而在5/5配置最优。该反例说明需要EDA候选评估，不能只靠一条STA路径承诺局部改写收益。', '',
          '仍不能声称STA引导LLM已经胜出：本轮没有模型调用，组件公开且已用于开发，五个配置来自同一构造电路，聪明的无STA模型可能依据RTL和完整约束估计正确位置。仅排除了largest_input_delay这个简单解释。分块条件不是通用芯片流或自然工程独立验证，没有统计显著性结论。', '',
          '本轮有效研究的证据：扁平条件115项审计、20次配置STA、4次STA复跑；分块条件127项审计、20次配置STA、4次STA复跑，另有4个组件完整证明/映射和4个顶层组合门级证明。修复回归另列，不混为独立模型样本。初始失败运行不算通过。', '',
          '下一步可冻结两组同预算的真实模型动作选择，明确以分块固定映射为研究条件；无STA与STA组都应获得完整RTL、相同约束、相同动作语义、单次改写预算与原面积110%上限。STA组只额外获得真实基线路径。先作为探索性对照，不能预先承诺STA会赢；调用前需新批次授权。', '',
          '原始证据在上述目录的protocol.json、SUMMARY.json、AUDIT.json、REPRODUCTION.json、mapping/或leaf_mapping/、sta/。两种映射条件各自固定TT库与IO，无布局布线寄生、功耗或硅片频率结论。']
(B/'FOLLOWUP_SUMMARY.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
e=load(B/'FINAL_EVIDENCE.json')
for f in ['MAPPING_BOUNDARY_INVARIANTS.json','FOLLOWUP_SUMMARY.md']:e['hashes'][f]=sha(B/f)
save(B/'FINAL_EVIDENCE.json',e)
root_note=f'''# 定位研究当前入口

最新跟进2026-11-05：已完成非对称mux+优先编码器的本地开发与映射边界对照，零新API。分块固定映射下最优区域会随约束改变；扁平综合下定位假设未成立，两者分别保留。

[完整跟进与全部失败记录](eda/experiments/{B.name}/FOLLOWUP_SUMMARY.md)

[分块条件原始证据](eda/experiments/{B.name}/INTERPRETATION.md)

[扁平条件反例](eda/experiments/{A.name}/INTERPRETATION.md)

[工具隔离修复、历史日志核对和四项真实回归](eda/experiments/{F.name}/INTERPRETATION.md)

尚未进行这套新定位任务的真实LLM分组，不能记作新的STA组胜出案例。
'''
(R/'README_LOCALIZATION.md').write_text(root_note,encoding='utf-8')
rel=str(B.relative_to(R)).replace('\\','/')
entry='2026-11-05定位跟进完成：发现并修复组合评估器并行临时文件风险及Windows路径兼容问题，四个关键PPA复现。相同非对称RTL/约束下，扁平综合定位假设未成立；分块固定映射下端点规则5/5配置选中最优，最大输入延迟规则2/5。零API，不是LLM优势或统计独立性证明。'
for file,prefix in [(R/'EXPERIMENT_INDEX.md',''),(R/'docs/CURRENT_STATUS.md','../')]:
    text=file.read_text(encoding='utf-8');line=entry+' [完整跟进及失败证据]('+prefix+rel+'/FOLLOWUP_SUMMARY.md)。\n\n'
    if line not in text:file.write_text(line+text,encoding='utf-8')
for s in [F,A,B]:
    evidence=load(s/'FINAL_EVIDENCE.json');assert all(sha(s/f)==h for f,h in evidence['hashes'].items())
print('All invariants, path checks and final evidence hashes PASS.')
print('Summary:',B/'FOLLOWUP_SUMMARY.md')
