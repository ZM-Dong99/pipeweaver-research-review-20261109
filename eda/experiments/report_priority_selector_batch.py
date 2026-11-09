"""Build a factual report only after the frozen batch and audit complete."""
import json
import hashlib
import statistics
from pathlib import Path

S = Path(r'D:\verilog_lab\PipeWeaver\eda\experiments\priority_selector_api_20261103_190958_372230')
def load(name):
    return json.loads((S/name).read_text(encoding='utf-8'))
def save(name, value):
    (S/name).write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding='utf-8')

p, s, a, reproduction = [load(f) for f in ['protocol.json','summary.json','AUDIT.json','REPRODUCTION.json']]
assert a['passed'] and reproduction['passed']
lines = ['# 真实模型受限动作选择：12次请求结果', '',
         '两种位宽、两种提示条件，每格3次独立请求，每次只选1个动作。所有选择冻结后才测量候选。原始设计始终作为回退；面积上限为原始的110%，这是实验约束，不是工程通用要求。', '',
         '| 位宽 | 条件 | 有效选择/尝试 | 合格改进 | 延迟中位数(ns) | 各次保留后延迟(ns) |',
         '|---|---|---|---|---|---|']
for w in p['widths']:
    for arm in ['no_sta','sta']:
        g=s['groups'][str(w)][arm]
        lines.append(f"| {w} | {arm} | {g['valid_selections']}/3 | {g['improved_trials']}/3 | {g['median_delay_ns']:.2f} | {g['delays_ns']} |")
lines += ['', '## 所有请求', '', '| 请求 | 位宽 | 条件 | 状态 | 选择动作 | 最终采用 | 延迟(ns) | 面积(µm²) |', '|---|---|---|---|---|---|---|---|']
for r in s['trials']:
    m=r['metrics']
    lines.append(f"| {r['call_index']} | {r['width']} | {r['arm']} | {r['status']} | {', '.join(r['action_ids']) or '无'} | {r['selected']} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} |")
    if r.get('error'):lines.append(f"\n请求{r['call_index']}失败记录：{r['error']}\n")
lines += ['', '## 固定策略与完整枚举参照', '', '| 位宽 | 参照 | 最终采用 | 延迟(ns) | 面积(µm²) |', '|---|---|---|---|---|']
for w in p['widths']:
    key=str(w); base=p['baseline_metrics'][key];c=s['controls'][key]
    lines.append(f"| {w} | 原始 | baseline | {base['max_data_arrival_ns']:.2f} | {base['mapped_area_um2']:.4f} |")
    for role in ['static16','static8']:
        r=c[role];m=r['metrics'];lines.append(f"| {w} | 预定{role} | {r['selected']} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} |")
    m=c['oracle_metrics'];lines.append(f"| {w} | 六动作枚举（更大预算） | {c['oracle']} | {m['max_data_arrival_ns']:.2f} | {m['mapped_area_um2']:.4f} |")
lines += ['', '## 全部候选及面积淘汰', '', '| 位宽 | 动作 | 延迟(ns) | 面积变化 | 预算内 |', '|---|---|---|---|---|']
for w in p['widths']:
    key=str(w);base=p['baseline_metrics'][key]
    for i,m in s['action_results'][key].items():
        delta=(m['mapped_area_um2']/base['mapped_area_um2']-1)*100
        lines.append(f"| {w} | {i} | {m['max_data_arrival_ns']:.2f} | {delta:+.2f}% | {'是' if m['mapped_area_um2']<=p['area_cap_um2'][key] else '否'} |")
lines += ['', '## 网络失败的影响与可支持结论', '',
          '64位无STA组含1次连接失败，失败按预定规则回退原始设计。成功返回的条件统计另列如下，不能删除失败后替代主结果。', '',
          '| 位宽 | 条件 | 成功返回数 | 成功返回中的合格改进数 | 成功返回后的延迟中位数(ns) |',
          '|---|---|---|---|---|']
for w in p['widths']:
    for arm in ['no_sta','sta']:
        rows=[r for r in s['trials'] if r['width']==w and r['arm']==arm and r['status']=='SELECTED']
        median=statistics.median(r['metrics']['max_data_arrival_ns'] for r in rows) if rows else None
        lines.append(f"| {w} | {arm} | {len(rows)} | {sum(r['selected']!='baseline' for r in rows)} | {median} |")
lines += ['',
          '64位的8位分组动作把延迟从1.73ns降至1.10ns（-36.42%），面积增加5.06%，所有输出的源级和映射后等价证明通过。16位分组虽然延迟降到1.23ns，但面积增加约49.96%，超过预算，因此选择该动作时最终回退基线。这说明本实例选动作时必须同时考虑映射成本。', '',
          '本轮64位STA组主指标更好，但仅3次/组，且无STA组多一次网络失败；无法证明因果优势。预先指定的固定8位分组每次都可取得1.10ns，优于本轮STA组最差试次，所以尚未证明模型或STA反馈优于简单固定策略。128位两组全部选择16位分组，结果完全相同。', '',
          '首轮审计按列表位置错误配对请求与按位宽重排的汇总，出现8项不匹配；原失败记录保存在AUDIT_BEFORE_ID_ALIGNMENT_FIX.json和audit_before_id_alignment_fix.py。仅审计器改为按唯一call_index配对并增加身份检查，原始返回、测量、协议和主统计均未修改。']
lines += ['', '## 解释范围与证据', '',
          '64位是本次主要实例，候选PPA在选择冻结之后测量；128位已用于动作开发，仅作已暴露案例重复。两位宽仍属同一电路家族，每格仅3次，不作统计普遍性或跨电路泛化结论。相同动作复用同一PPA测量，不视为独立RTL样本。', '',
          '此处模型只选择注册动作，确定性改写器生成RTL；不是自由代码生成对照。六动作枚举使用更大候选预算，不能作为单候选模型的公平胜负参照。原始STA反馈进入请求可由request.json核查，无法从返回解释证明模型内部如何利用信息。', '',
          '本轮使用第三方网关请求模型gpt-6.1-sol，无法独立验证后端身份。无自动重试或补抽。provider报告的token总数：'+str(a['provider_reported_tokens'])+'；没有可靠单价，未编造费用。', '',
          f"审计{a['check_count']}项通过；独立本地复跑{len(reproduction['cases'])}个去重案例通过。复跑不是新模型请求。性能为固定TT库与IO约束的布局布线前估计，不是芯片签核或实测频率。", '',
          '原始证据：protocol.json、AUTHORIZATION.json、selection_manifest.json、各trial的api_audit/request.json和response.json、generation.json、各evaluations的formal.log/mapped_formal.log/sta.log/mapping.log、summary.json、AUDIT.json、REPRODUCTION.json。']
(S/'INTERPRETATION.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
save('STATUS.json',{'state':'COMPLETED_AUDITED_REPRODUCED','actual_model_requests':12,'actual_provider_responses':a['actual_provider_responses']})
save('FINAL_EVIDENCE.json',{'status':'COMPLETED_AUDITED_REPRODUCED','actual_model_requests':12,'actual_provider_responses':a['actual_provider_responses'],'provider_reported_tokens':a['provider_reported_tokens'],'audit_checks':a['check_count'],'reproduction_cases':len(reproduction['cases']),'groups':s['groups'],'hashes':{f:hashlib.sha256((S/f).read_bytes()).hexdigest() for f in ['protocol.json','AUTHORIZATION.json','summary.json','selection_manifest.json','AUDIT.json','REPRODUCTION.json','INTERPRETATION.md']}})
print('Report and final evidence saved:',S)
