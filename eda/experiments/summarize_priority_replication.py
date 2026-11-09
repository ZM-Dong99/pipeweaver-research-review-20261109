"""Read-only source studies; post-hoc two-round summary and Pareto exports."""
import hashlib
import json
from pathlib import Path
import shutil

ROOT=Path(__file__).resolve().parents[2]
NAMES=['timing_feedback_ablation_priority256_20261102_193927_399076','timing_feedback_ablation_priority256_20261102_203544_758268']
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')

def main():
    studies=[ROOT/'eda/experiments'/name for name in NAMES]
    out=ROOT/'eda/experiments/priority256_replication_20261102';out.mkdir(exist_ok=False)
    protocols=[load(s/'protocol.json') for s in studies]
    assert protocols[0]['prompt_sha256']==protocols[1]['prompt_sha256']
    base=protocols[0]['baseline_metrics'];points=[];rows=[];generations=[]
    for index,(s,p) in enumerate(zip(studies,protocols),1):
        assert load(s/'AUDIT.json')['status']=='PASS'
        assert load(s/'verified_selections/REPRODUCTION.json')['all_passed']
        summary=load(s/'summary.json')
        for arm in p['arms']:
            g=summary['groups'][arm];rows.append(dict(round=index,arm=arm,**g))
        for slot in p['call_schedule']:
            folder=s/slot['arm']/slot['candidate_id'];g=load(folder/'generation.json');r=load(folder/'result.json')
            generations.append(dict(round=index,arm=slot['arm'],id=slot['candidate_id'],status=g['status'],error=g.get('error'),seconds=g['generation_seconds'],
                transport=load(folder/'api_audit/transport.json') if (folder/'api_audit/transport.json').exists() else None))
            if not g['candidate_sha256']:continue
            m=r['metrics'];assert m['formal']==m['mapped_formal']==m['ppa']=='PASS'
            points.append(dict(round=index,arm=slot['arm'],candidate=slot['candidate_id'],source=str(folder/'candidate.v'),
                sha256=g['candidate_sha256'],delay_ns=m['max_data_arrival_ns'],area_um2=m['mapped_area_um2'],metrics=m))
    eligible=[p for p in points if p['area_um2']<=base['mapped_area_um2']*1.10+1e-9 and p['metrics']['electrical']['status']=='PASS']
    front=[]
    for p in eligible:
        dominated=any(q['delay_ns']<=p['delay_ns'] and q['area_um2']<=p['area_um2'] and (q['delay_ns']<p['delay_ns'] or q['area_um2']<p['area_um2']) for q in eligible if q is not p)
        if not dominated:front.append(p)
    front.sort(key=lambda p:(p['delay_ns'],p['area_um2']))
    exports=out/'pareto_exports';exports.mkdir()
    for i,p in enumerate(front,1):
        target=exports/f'priority_encoder_choice_{i:02d}.v';shutil.copyfile(p['source'],target)
        assert sha(target)==p['sha256'];p['export']=str(target.relative_to(out))
    shutil.copyfile(ROOT/'benchmark/engineering_sources_20261030/verilog-axis/COPYING',exports/'UPSTREAM_COPYING')
    save(out/'RESULTS.json',dict(scope='Post-hoc joint analysis of two identical-prompt exploratory rounds; one circuit family',
        attempts=12,returned_rtl=len(points),rounds=rows,all_returned_candidates=points,pareto_within_10pct_area=front,
        generations=generations,original_baseline=base,source_protocol_sha256=[sha(s/'protocol.json') for s in studies]))
    second=studies[1];balanced=load(second/'BALANCED_REPRODUCTION_CHECK.json');assert balanced['passed']
    g=load(second/'actual_paths/candidate_03/generation.json');actual_prompt=(second/'prompts/actual_paths.txt').read_text(encoding='utf-8')
    text=(second/'baseline/evaluation/eda/sta.log').read_text(encoding='utf-8')
    trace=[]
    for cell,number in [('buf_12','1.20'),('mux2i_4','0.58'),('o2111a_4','0.47')]:
        matching=[line for line in text.splitlines() if cell in line and number in line]
        assert matching and matching[0].strip() in actual_prompt and cell in g['explanation']['bottleneck'] and number in g['explanation']['bottleneck']
        trace.append(dict(cell=cell,referenced_number=number,actual_sta_line=matching[0].strip()))
    save(out/'STA_EXPLANATION_TRACE.json',dict(passed=True,matches=trace,scope='Visible explanation cites actual transmitted STA cells/numbers; not proof of internal reasoning or causal contribution'))
    lines=['# 同一优先编码器的两轮重复：真实结果','',
        '第二轮使用逐字相同的两组提示、模型请求参数、固定映射和原始面积上限。只增加安全的客户端计时记录。两轮各6次请求，均未重试。','',
        '| 轮次 | 条件 | 返回RTL/请求 | 面积内合格 | 保留基线后的最好到达时间ns |','|---|---|---:|---:|---:|']
    for r in rows:lines.append(f'| {r["round"]} | {r["arm"]} | {r["generated"]}/{r["scheduled"]} | {r["area_eligible"]}/{r["scheduled"]} | {r["selected_delay_with_baseline_ns"]} |')
    lines+=['','两轮合计：无反馈2/6返回、0/6面积合格；STA组6/6返回、4/6面积合格。全部8份实际返回完成源级与映射后等价证明及STA。每轮各164项证据核对通过，基线及两组实际选择分别独立复跑一致。','',
       '## 新发现：延迟和面积同时改善的候选','',
       '第二轮STA candidate_03为1.54ns、7933.8592µm²；相对原始2.60ns、8056.4768µm²，延迟降低40.77%、映射面积减少1.52%。不是以更多面积换时序。源级/门级证明和电气检查通过，另独立重跑的数值与网表哈希一致。',
       '', '原协议按最快合格延迟选中1.50ns版本；这里额外保存事后联合的面积/时序帕累托选择，未改写原始排名或协议。','',
       '| 可选方案 | 来源 | 到达时间ns | 面积µm² |','|---|---|---:|---:|']
    for i,p in enumerate(front,1):lines.append(f'| choice_{i:02d} | 第{p["round"]}轮 {p["candidate"]} | {p["delay_ns"]:.2f} | {p["area_um2"]:.4f} |')
    lines+=['','## STA是否真的进入了模型请求','',
       '每个request.json的user内容与冻结提示一致。第二轮candidate_03的可见解释引用buf_12处1.20ns、mux2i_4的0.58ns和o2111a_4的0.47ns，这些均与实际发送报告的原始行一致，见STA_EXPLANATION_TRACE.json。能核实信息来源及返回解释，不能由此证明模型内部推理或STA的因果作用。','',
       '## 连接失败仍然影响比较','',
       '第二轮无反馈两次均为curl exit 56，记录的TCP连接时间约0.011/0.023秒，未收到HTTP首字节，总时间约166/96秒；不是已记录的客户端180秒主动超时。仅此不能定位TLS、中转或上游服务，不能归因于模型能力。',
       '', '两轮返回数量仍为2对6，最优值受可用候选数影响；重复了可用结果，但没有消除混杂。这里仍只有一个公开家族，没有统计显著性或普遍优越性结论。候选普遍专门优化WIDTH=256分支，其他参数不能直接泛化。',
       '', '同一网表的额外IO扫点是条件敏感性测量，不是更多独立模型样本。各组实际费用不能由已返回token数完整推算，失败调用费用未知。','',
       '所有原始调用、失败和测量仍在两轮原目录；RESULTS.json链接来源，pareto_exports保留可验证原始RTL字节。没有追加第七次请求。','']
    (out/'INTERPRETATION.md').write_text('\n'.join(lines),encoding='utf-8')
    shutil.copyfile(Path(__file__),out/'analysis_used.py')
    print('Two rounds summarized; returned RTL='+str(len(points))+'; bounded Pareto exports='+str(len(front)))

if __name__=='__main__':main()
