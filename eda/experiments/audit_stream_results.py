"""Audit the completed real streaming batch; no API requests or EDA reruns."""
import argparse
import json
from pathlib import Path
import statistics
from run_stream_feedback import validate,load,sha,parse_candidate,choose,eligible,ARMS


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('batch',type=Path);a=ap.parse_args();s=a.batch.resolve()
    p=validate(s);manifest=load(s/'candidate_manifest.json');summary=load(s/'summary.json');checks=[]
    def check(label,value):checks.append(dict(check=label,passed=bool(value)))
    auth=load(s/'AUTHORIZATION.json')
    check('Explicit new12-call consent',auth['status']=='EXPLICITLY_APPROVED' and auth['maximum_requests']==12 and auth['endpoint']==p['endpoint'] and auth['protocol_sha256']==sha(s/'protocol.json'))
    check('Manifest hash',sha(s/'candidate_manifest.json')==(s/'candidate_manifest.sha256').read_text().strip())
    check('Manifest exact frozen protocol',manifest['protocol_sha256']==sha(s/'protocol.json'))
    check('Every scheduled identity once',[r['slot'] for r in manifest['rows']]==p['schedule'])
    check('Actual12 attempt markers',len(list(s.glob('trials/*/attempt.json')))==12)
    cases={c['id']:c for c in p['cases']};tokens=0;usage_records=0;responses=0;models=set();usage_mismatches=[];network=[]
    rows=[]
    for original,slot in zip(manifest['rows'],p['schedule']):
        label=f"Call{slot['call_index']}";folder=s/'trials'/f"call_{slot['call_index']:02d}"
        attempt=load(folder/'attempt.json');generation=load(folder/'generation.json');request=load(folder/'api_audit/request.json')
        prompt=s/slot['prompt']
        check(label+' identity',generation==original and attempt['slot']==slot and attempt['protocol_sha256']==sha(s/'protocol.json'))
        check(label+' prompt hash',attempt['prompt_sha256']==sha(prompt))
        expected=dict(model=p['model'],**p['request_parameters'],response_format={'type':'json_object'},
            messages=[dict(role='system',content=p['system_message']),dict(role='user',content=prompt.read_text(encoding='utf-8'))])
        check(label+' exact actual request',request['body']==expected and request['endpoint']==p['endpoint']+'/chat/completions')
        check(label+' no credentials persisted',request['credentials']=='Authorization header omitted' and 'headers' not in request)
        transport=load(folder/'api_audit/transport.json');check(label+' no retry',transport['retry_count']==0)
        network.append(dict(call_index=slot['call_index'],case=slot['case'],arm=slot['arm'],
            **{k:transport.get(k) for k in ('exit_code','http_status','client_timeout','elapsed_seconds','connect_seconds','first_byte_seconds')}))
        rp=folder/'api_audit/response.json'
        if rp.exists():
            responses+=1;response=load(rp);models.add(str(response.get('model')))
            usage=response.get('usage',{});value=usage.get('total_tokens') if isinstance(usage,dict) else None
            if type(value) is int and value>=0:tokens+=value;usage_records+=1
            if isinstance(usage,dict) and all(type(usage.get(k)) is int for k in ('prompt_tokens','completion_tokens','total_tokens')):
                if usage['prompt_tokens']+usage['completion_tokens']!=usage['total_tokens']:usage_mismatches.append(slot['call_index'])
            try:parsed=parse_candidate(response['choices'][0]['message']['content'])
            except (KeyError,IndexError,TypeError,RuntimeError):check(label+' invalid format retained',generation['status']=='FAILED_GENERATION')
            else:
                candidate=folder/'candidate.v'
                check(label+' original response produces exact RTL',generation['status']=='GENERATED' and candidate.read_text(encoding='utf-8')==parsed['rtl'] and sha(candidate)==generation['candidate_sha256'])
        else:check(label+' absent response is failed',generation['status']=='FAILED_GENERATION')
        row=next(r for r in summary['rows'] if r['slot']['call_index']==slot['call_index']);check(label+' summary generation matches',all(row.get(k)==v for k,v in generation.items()))
        base=cases[slot['case']]['baseline'];check(label+' decision recomputes',row['decision']==choose(row['metrics'],base));rows.append(row)
        if generation['status']=='GENERATED':
            ef=s/'evaluations'/slot['case']/generation['candidate_sha256']
            if (ef/'result.json').exists():check(label+' exact EDA evidence',load(ef/'result.json')==row['metrics'])
            else:check(label+' missing EDA correctly incomplete',row['metrics']['status']=='INCOMPLETE')
            if (ef/'protocol.json').exists():
                ep=load(ef/'protocol.json');bp=load(s/'baselines'/slot['case']/'protocol.json')
                check(label+' same reset/mapping/lib/parameters',all(ep.get(k)==bp.get(k) for k in ('initial_state_policy','stream_contract','unmap_clock_enables','clock','reset','reset_cycles','warmup_samples','period_ns','parameter_overrides','liberty_sha256')))
                for stage in ('formal','mapped_formal'):
                    if row['metrics'].get(stage)=='PASS':check(label+' '+stage+' complete proof','Induction step proven: SUCCESS!' in (ef/row['metrics'][stage+'_decisive_log']).read_text(encoding='utf-8'))
            if eligible(row['metrics']):check(label+' no-init eligibility',row['metrics']['no_declared_initial_values_relied_on'] and row['metrics']['electrical']['violation_rows']==0)
    for c in p['cases']:
        for arm in ARMS:
            rr=[r for r in rows if r['slot']['case']==c['id'] and r['slot']['arm']==arm];g=summary['groups'][c['id']][arm]
            check(c['id']+'/'+arm+' all3 in primary median',len(rr)==g['attempted']==3 and statistics.median(r['decision']['retained_wns_ns'] for r in rr)==g['median_retained_wns_ns'])
            check(c['id']+'/'+arm+' exact improvement count',sum(r['decision']['improved'] for r in rr)==g['strict_improvements'])
    report=dict(passed=all(c['passed'] for c in checks),check_count=len(checks),checks=checks,actual_attempts=12,
        saved_responses=responses,reported_total_tokens=tokens,usage_records=usage_records,usage_subtotal_mismatch_calls=usage_mismatches,
        reported_response_models=sorted(models),transport_observations=network,
        scope='Evidence consistency only; audit items and repeated EDA are not independent model samples. Provider usage is not an independently verified bill.')
    (s/'AUDIT.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    lines=['# 两个自然流模块：真实模型对照结果','',
        '用户明确授权的12个槽位已全部执行，无重试或补抽。全部生成先冻结，再进行候选EDA；同案例同RTL哈希复用一次EDA，所有请求仍在分母中。', '',
        '| 模块 | 条件 | 返回RTL/尝试 | 源级通过 | 门级通过 | 合格改善 | 保留后中位WNS ns | 最佳保留WNS ns |',
        '|---|---|---:|---:|---:|---:|---:|---:|']
    for c in p['cases']:
        for arm in ARMS:
            rr=[r for r in rows if r['slot']['case']==c['id'] and r['slot']['arm']==arm];g=summary['groups'][c['id']][arm]
            lines.append(f"| {c['top']} | {arm} | {g['generated']}/3 | {sum(r['metrics'].get('formal')=='PASS' for r in rr)}/3 | {sum(r['metrics'].get('mapped_formal')=='PASS' for r in rr)}/3 | {g['strict_improvements']}/3 | {g['median_retained_wns_ns']} | {max(r['decision']['retained_wns_ns'] for r in rr)} |")
    lines += ['', 'WNS越大越好。主指标是各模块全3次尝试保留后的中位WNS，最佳一次仅作辅助，不取代主指标。', '',
        '| 请求 | 模块 | 条件 | 生成/验证 | 原始候选WNS ns | 原始面积µm² | 实际选择 | 保留WNS ns |', '|---|---|---|---|---:|---:|---|---:|']
    for r in rows:
        slot=r['slot'];m=r['metrics'];dec=r['decision']
        lines.append(f"| {slot['call_index']} | {slot['case']} | {slot['arm']} | {r['status']}/{m.get('status','未运行')} | {m.get('wns_ns','—')} | {m.get('mapped_area_um2','—')} | {dec['selected']} | {dec['retained_wns_ns']} |")
    lines += ['', '## 通信因素与条件统计', '',
        '| 模块 | 条件 | 成功返回RTL数 | 成功返回子集保留后中位WNS ns |', '|---|---|---:|---:|']
    for c in p['cases']:
        for arm in ARMS:
            rr=[r for r in rows if r['slot']['case']==c['id'] and r['slot']['arm']==arm and r['status']=='GENERATED']
            value=statistics.median(r['decision']['retained_wns_ns'] for r in rr) if rr else '不可计算'
            lines.append(f"| {c['top']} | {arm} | {len(rr)} | {value} |")
    lines += ['', '这些成功返回条件统计只是通信敏感性描述，不替代包含全部失败的主结果。无返回不能判断RTL质量；有效样本过少或组间返回不等时，不能据主结果推断STA的因果收益。', '',
        '| 请求 | HTTP | curl退出码 | 记录耗时秒 | 客户端超时 |', '|---|---:|---:|---:|---|']
    for n in network:lines.append(f"| {n['call_index']} | {n['http_status']} | {n['exit_code']} | {n['elapsed_seconds']} | {n['client_timeout']} |")
    lines += ['', '## 契约、失败与限制','',
        '首个采样点同步复位，此后输入和复位任意；ready/valid逐拍比较，输出valid时比较边带和keep，data只比较有效keep字节。源级、综合和门级证明均移除声明初值，不依赖上电数据。不是旧的所有引脚每周期相等，也不是完整AXI规范证明。', '',
        '两组共享固定原始RTL、参数、10ns时钟、TT库、零外部IO延迟、0.10ns输入转换、0.010pF负载、无init综合/使能展开映射和110%基线面积上限。STA组只追加原始基线路径。基线adapter WNS8.87ns/面积2574.9696，skid WNS8.71ns/面积3564.6688。', '',
        '辅助状态关系失败不等于接口错误：再做接口专用证明。INCOMPLETE/超时不能算已证明错误，也不能算通过；均回退基线。两案例来自同一公开仓库且已用于契约开发，每格3次，不是盲测、统计显著性或跨模型普遍优势证明。', '',
        f"本轮保存{responses}份供应商响应、{usage_records}份用量记录，共报告{tokens}tokens。分项用量不相加的请求编号：{usage_mismatches}。这些不是独立核实账单，不推算金额。请求模型ID为{p['model']}，第三方网关后端身份未独立验证。", '',
        f"实际唯一候选EDA数：{summary['unique_candidate_eda']}；独立重复核查另列，不作为新模型样本。证据核对{len(checks)}项，通过={report['passed']}。"]
    for r in rows:
        error=r.get('error') or r['metrics'].get('failure_reason') or r['metrics'].get('reason')
        if error:lines+=['',f"请求{r['slot']['call_index']}：{error}"]
    (s/'INTERPRETATION.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print(json.dumps(dict(passed=report['passed'],checks=len(checks),responses=responses,tokens=tokens),ensure_ascii=False))
    return 0 if report['passed'] else 1


if __name__=='__main__':raise SystemExit(main())
