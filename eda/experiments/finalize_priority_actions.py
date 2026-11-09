"""Publish measured action transfer and CLI integration with explicit scope."""
from pathlib import Path
import shutil
import sys
ROOT=Path(r'D:\verilog_lab\PipeWeaver');E=ROOT/'eda/experiments';sys.path.insert(0,str(ROOT))
from agents.action_loop import load,save,sha
S=E/'priority_action_transfer_20261103_174528_356729'
p=load(S/'protocol.json');s=load(S/'SUMMARY.json');a=load(S/'AUDIT.json');r=load(S/'REPRODUCTION.json');noop=load(S/'no_op_controls/SUMMARY.json')
assert a['passed'] and r['passed'] and r['independent_eda_replays']==4
primary=next(x for x in s['profiles'] if x['id']==p['primary_profile'])
area_choice=next(x for x in primary['results'] if x['id']=='group_factored_8')
integration_checks=[]
for name,reference in [('priority_action_cli_validation_20261103',primary),('comparator_action_cli_regression_20261103',None)]:
    folder=E/name;d=load(folder/'SUMMARY.json');assert d['mode']=='MANUAL_JSON_REPLAY_NOT_MODEL_GENERATION' and d['model_calls']==0
    if reference:
        expected={'baseline':reference['baseline'],**{row['id']:row['metrics'] for row in reference['results']}}
        for i,m in [('baseline',d['baseline'])]+list(d['results'].items()):
            checks={k:m[k]==expected[i][k] for k in ['status','formal','mapped_formal','ppa','max_data_arrival_ns','mapped_area_um2','mapped_sha256']}
            assert all(checks.values());integration_checks.append(dict(case=name+'/'+i,passed=True,checks=checks))
        assert d['selected']==reference['selected']['id']
    else:
        assert d['selected']=='baseline' and d['baseline']['max_data_arrival_ns']==1.21
        assert all(m['formal']==m['mapped_formal']==m['ppa']=='PASS' for m in d['results'].values())
        integration_checks.append(dict(case=name,passed=True,default_comparator_retention_verified=True))
save(S/'CLI_INTEGRATION.json',dict(passed=True,model_calls=0,actual_integration_eda_runs=6,checks=integration_checks,
     source_files_sha256={str(f.relative_to(ROOT)):sha(f) for f in [ROOT/'agents/action_loop.py',ROOT/'agents/action_selector.py',ROOT/'agents/optimization_loop.py']},
     mode='Manual choices to verify entry/RTL/formal/STA/ranking; not fresh model output'))
lines=['# 优先编码结构动作库：主实例改进与真实验证','',
'本轮从此前实际模型候选的分组获胜位结构提取六个受限动作，并做人工参数化；本轮没有新模型调用，没有让LLM选择这六个新动作。标准分组优先编码结构不是本项目首创。全部候选在测量前冻结，选择规则及10%面积上限未改。','',
'## 预先指定的128位主实验','',
'原始最大到达时间2.23ns，映射面积4267.8432 µm²。下列两个选择均完成源级SAT、实际门级SAT、真实OpenSTA及电气检查，且独立复跑的指标和网表哈希一致。','',
'| 128位选择 | 到达时间ns | 延迟降低 | 面积µm² | 面积变化 |','|---|---:|---:|---:|---:|']
for title,row in [('最快',primary['selected']),('较小面积',area_choice)]:
    m=row['metrics'];b=primary['baseline'];lines.append(f"| {title}：{row['id']} | {m['max_data_arrival_ns']:.2f} | {100*(1-m['max_data_arrival_ns']/b['max_data_arrival_ns']):.2f}% | {m['mapped_area_um2']:.4f} | {100*(m['mapped_area_um2']/b['mapped_area_um2']-1):+.2f}% |")
lines += ['',
'原结构先生成全局编码，再通过移位译码产生one-hot输出；新结构在组内计算获胜位并由组使能直接生成one-hot，同时共享局部结果产生编码。主实例原最坏路径为input_unencoded[91]→output_unencoded[102]，新最坏路径为input_unencoded[105]→output_encoded[2]。全局最坏路径已重新测量，不只追踪旧端点。此结构解释不等于逐门源码延迟归因。','',
'## 其他固定参数实例','',
'| 角色 | 原始延迟ns | 实际选择延迟ns | 原面积 | 选择面积 |','|---|---:|---:|---:|---:|']
for profile in s['profiles']:
    b,m=profile['baseline'],profile['selected']['metrics'];lines.append(f"| {profile['id']} | {b['max_data_arrival_ns']:.2f} | {m['max_data_arrival_ns']:.2f} | {b['mapped_area_um2']:.4f} | {m['mapped_area_um2']:.4f} |")
lines += ['',
'256位是已暴露的开发参照，不是独立盲测；17位是非二次幂边界。32位LSB优先使用原逻辑回退，虽测得1.35→1.33ns的小差异，也不计为分组架构收益。四个强制关闭快分支的只包装对照均回到对应原始基线数值；仅凭这些记录不能唯一解释所有综合表达/命名扰动。','',
'## 全部六动作结果','',
'| 实例 | 动作 | 到达ns | 面积µm² | 原预算内严格改善 |','|---|---|---:|---:|---|']
for profile in s['profiles']:
    for row in profile['results']:
        m=row['metrics'];lines.append(f"| {profile['id']} | {row['id']} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} | {'是' if row['strict_improvement'] else '否'} |")
msb_pairs=sum(row['strict_improvement'] for profile in s['profiles'] if profile['lsb']==0 for row in profile['results'])
lines += ['',
f'计划内28次评估全部通过源级/门级证明与STA。原始计数20/24候选—参数组合严格改善，包含6个LSB回退映射小差异；剔除回退角色后，MSB重写实例为{msb_pairs}/18。以上是6份固定源码在4种参数下复用，不能写成24份独立LLM样本或4个电路家族。', '',
'## 功能与接口边界','',
'- 验证比较全部三个输出，mismatch没有被output_valid屏蔽。零输入时MSB原设计的encoded=0及unencoded[0]=1必须保留；本轮未把valid=0时输出当无关值。',
'- 源码必须匹配固定公开priority_encoder模板，动作仅允许分组8/16/32和两种编码组织，拒绝额外RTL及未知动作；7项拒绝检查通过。LSB与非默认LEVELS/W走原实现回退，但本轮仅证明冻结的四个实例。',
'- actions主入口已支持priority_encoder模板和明确WIDTH/LSB参数。手工选择两个动作的3次真实EDA回放与实验一致；原比较器默认路径3次回归通过，8项模板路由/非法输入检查通过。手工回放不是新的模型生成。',
'- 同一已暴露家族上的算子开发和参数迁移，不是通用RTL解析器、独立家族泛化或公平LLM方法比较。尚无“新动作库有/无STA引导选择”的真实新调用对照。',
'- SKY130HD TT、0.10ns输入转换、0.010pF输出负载、固定buffer_size映射；组合到达时间而非芯片Fmax。布局布线前，无寄生、多角、功耗或物理签核。','',
'## 原始证据','',
f'[冻结协议](protocol.json)；[全部结果](SUMMARY.json)；[{a["check_count"]}项证据核对](AUDIT.json)；[四次独立复跑](REPRODUCTION.json)；[四个只包装对照](no_op_controls/SUMMARY.json)；[主入口回放](CLI_INTEGRATION.json)；[模板路由检查](TEMPLATE_DISPATCH_TESTS.json)。',
'protocol.json记录原始模型候选路径与SHA-256；inputs/validated_model_reference.v保留来源字节，candidates/保留每个动作JSON及生成RTL。不存在新模型token或费用记录，因为本轮没有调用API。','']
(S/'INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
(S/'exports').mkdir(exist_ok=True);shutil.copyfile(S/'inputs/LICENSE',S/'exports/LICENSE')
exports=[]
for name,profile,row in [('priority128_fast',primary,primary['selected']),('priority128_small',primary,area_choice),
    ('priority256_fast',s['profiles'][1],s['profiles'][1]['selected'])]:
    path=S/'exports'/(name+'.v');shutil.copyfile(S/'candidates'/(row['id']+'.v'),path)
    contract=dict(top='priority_encoder',parameters={'WIDTH':profile['WIDTH'],'LSB_HIGH_PRIORITY':profile['lsb']},source_sha256=sha(path),action=row['id'],metrics=row['metrics'],
                  note='Parameter overrides are required; original declaration defaults intentionally preserved. Pre-layout TT measurements, not signoff.')
    save(S/'exports'/(name+'.json'),contract);exports.append(dict(name=name,**contract))
save(S/'EXPORTS.json',exports)
save(S/'FINAL_EVIDENCE.json',dict(status='COMPLETED_AUDITED_REPRODUCED_AND_CLI_VALIDATED',model_calls=0,source_versions=6,candidate_parameter_pairs=24,
    planned_eda_cases=28,no_op_control_eda_cases=4,independent_replays=4,manual_cli_integration_eda_cases=6,audit_checks=a['check_count'],audit_passed=True,
    raw_strict_improved_pairs=20,msb_rewrite_improved_pairs=msb_pairs,lsb_fallback_pairs_excluded_from_architecture_gain=6,
    primary=dict(width=128,baseline_delay_ns=2.23,fast_delay_ns=1.41,fast_area_um2=4052.6368),
    hashes={n:sha(S/n) for n in ['protocol.json','SUMMARY.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md','CLI_INTEGRATION.json','TEMPLATE_DISPATCH_TESTS.json','EXPORTS.json']}))
(S/'validation_tools').mkdir(exist_ok=True)
shutil.copyfile(E/'audit_priority_action_transfer.py',S/'validation_tools/audit_priority_action_transfer.py');shutil.copyfile(Path(__file__).resolve(),S/'validation_tools/finalize_priority_actions.py')
entry='2026-11-03优先编码受限动作库完成：128位主实例2.23→1.41ns（-36.77%）、面积-5.04%；较小面积选择1.47ns、面积-22.63%。28次源级/门级证明与STA、四次复跑、四个只包装对照通过，576项核对。已接入actions入口并做手工回放；本轮零模型调用，不宣称新模型方法优势。'
for path,prefix in [(ROOT/'EXPERIMENT_INDEX.md','eda/experiments/'),(ROOT/'docs/CURRENT_STATUS.md','../eda/experiments/')]:
    text=path.read_text(encoding='utf-8')
    if '优先编码受限动作库完成：' not in text:
        pos=text.find('\n\n')+2;path.write_text(text[:pos]+entry+f' [全部真实证据]({prefix}{S.name}/INTERPRETATION.md)。\n\n'+text[pos:],encoding='utf-8')
print('Reported primary improvement with verified evidence; current model calls:0; CLI regression passed.')
