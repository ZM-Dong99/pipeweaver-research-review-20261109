"""Post-hoc cell-area decomposition using actual mapped JSON and frozen Liberty."""
import argparse
from collections import Counter,defaultdict
import json
from pathlib import Path
import re
from run_seq_feedback_study import ROOT,LIB,load,save,sha

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('study',type=Path);s=ap.parse_args().study.resolve();p=load(s/'protocol.json');summary=load(s/'summary.json')
    assert sha(LIB)==p['library_sha256']
    text=LIB.read_text(encoding='utf-8');starts=list(re.finditer(r'\bcell\s*\(\s*"?([^\s"()]+)"?\s*\)\s*\{',text));cells={}
    for i,m in enumerate(starts):
        block=text[m.end():starts[i+1].start() if i+1<len(starts) else len(text)];area=re.search(r'\barea\s*:\s*([-+\d.eE]+)\s*;',block)
        if not area:continue
        category='sequential' if re.search(r'\b(?:ff|latch)\s*\(',block) else 'buffer_inverter' if re.search(r'__(?:buf|clkbuf|inv|clkinv)_',m[1]) else 'other_combinational'
        cells[m[1]]=dict(area=float(area[1]),category=category)
    entries=[('baseline',s/'baseline',p['baseline_metrics'])]+[(r['arm']+'/'+r['candidate_id'],s/r['arm']/r['candidate_id']/'eda',r['metrics']) for r in summary['results'] if r['metrics'] and r['metrics'].get('status')=='PASS']
    rows=[];baseline_counts=None
    for name,folder,metrics in entries:
        mapped=load(folder/'mapped.json')['modules']['arbiter']['cells'];counts=Counter(c['type'] for c in mapped.values());assert all(t in cells for t in counts)
        categories=defaultdict(lambda:dict(count=0,area=0.))
        for t,n in counts.items():categories[cells[t]['category']]['count']+=n;categories[cells[t]['category']]['area']+=n*cells[t]['area']
        total=sum(v['area'] for v in categories.values());assert abs(total-metrics['mapped_area_um2'])<.0001
        assert sum(counts.values())==metrics['mapped_cells']
        if baseline_counts is None:baseline_counts=counts.copy()
        changes=[dict(cell=t,count_delta=counts[t]-baseline_counts[t],area_delta=(counts[t]-baseline_counts[t])*cells[t]['area']) for t in counts.keys()|baseline_counts.keys() if counts[t]!=baseline_counts[t]]
        changes.sort(key=lambda x:-x['area_delta'])
        rows.append(dict(label=name,categories=dict(categories),total_area_um2=total,wns_ns=metrics['wns_ns'],mapped_json_sha256=sha(folder/'mapped.json'),top_added_cell_area=changes[:10],all_cell_count_changes=changes))
    save(s/'AREA_COST_ANALYSIS.json',dict(scope='Post-hoc cell-area attribution, not exact gate-to-RTL mapping or power evidence',liberty_sha256=sha(LIB),rows=rows))
    lines=['# 面积超限定位：实际工艺单元分解','', '所有面积由mapped.json的真实实例数乘以同一Liberty单元面积求和，与EDA报告总面积核对一致。该分析在结果之后进行，不修改原10%面积约束或选择。','',
       '| 版本 | WNS ns | 时序单元数 | 时序单元面积 | buffer/inverter面积 | 其他组合面积 | 总面积 |','|---|---:|---:|---:|---:|---:|---:|']
    for row in rows:
        c=row['categories'];get=lambda name,key:c.get(name,{}).get(key,0)
        lines.append(f'| {row["label"]} | {row["wns_ns"]:.2f} | {get("sequential","count")} | {get("sequential","area"):.4f} | {get("buffer_inverter","area"):.4f} | {get("other_combinational","area"):.4f} | {row["total_area_um2"]:.4f} |')
    lines+=['', '分类依据Liberty中的ff/latch组及buffer/inverter单元名；不推断RTL哪一行造成了面积，不把buffer面积当功耗。每个候选新增最多的单元面积贡献在AREA_COST_ANALYSIS.json保留。','',
        '这些数据用于设计后续受约束改写策略。不能根据本轮结果事后放宽面积上限或补挑候选，不能将手工开发正例当成新的独立对照组。','']
    (s/'AREA_COST_ANALYSIS.md').write_text('\n'.join(lines),encoding='utf-8')
    print(json.dumps([dict(label=r['label'],area=r['total_area_um2'],sequential=r['categories'].get('sequential')) for r in rows],ensure_ascii=False))

if __name__=='__main__':main()
