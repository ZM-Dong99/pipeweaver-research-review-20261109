"""Final CTS/PDN evidence audit and report; no model API calls."""
import argparse
import copy
import csv
import json
import math
import os
from pathlib import Path
import re
import subprocess

from run_fcs_cts_pdn import PDN_PLATFORM
from run_fcs_physical import ROOT, SOURCE, PLATFORM, TOOLS, LIB, OPENROAD, wsl, sha, save
from route_fcs_detailed import GLOBAL, OUT as PRIOR, logical_graph
from verify_fcs_cts_pdn import normalize_clock


def load(p):
    return json.loads(p.read_text(encoding='utf-8-sig'))


def negatives(original,routed,modules):
    results={}
    def rejected(candidate):
        try:
            normalized,_=normalize_clock(original,candidate,modules)
            return logical_graph(original)!=logical_graph(normalized)
        except AssertionError:
            return True
    bad=copy.deepcopy(routed)
    first=next(n for n,c in bad['cells'].items() if c['type']=='sky130_fd_sc_hd__clkbuf_16')
    bad['cells'][first]['type']='sky130_fd_sc_hd__clkinv_4'
    results['loaded_inverting_clock_cell_rejected']=rejected(bad)
    bad=copy.deepcopy(routed)
    first=next(n for n in original['cells'] if 'CLK' in bad['cells'][n]['connections'])
    bad['cells'][first]['connections']['CLK']=[routed['ports']['s_axis_tdata']['bits'][0]]
    results['register_clock_rewired_to_data_rejected']=rejected(bad)
    bad=copy.deepcopy(routed)
    bad['cells'][first]['connections']['D']=['0']
    results['register_data_forced_constant_rejected']=rejected(bad)
    return dict(passed=all(results.values()),checks=results,
         scope='Three in-memory mutations of actual routed JSON, checker negatives only; no change to measured RTL, layout, SPEF or model sample count')


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('out',type=Path)
    out=ap.parse_args().out.resolve()
    protocol=load(out/'protocol.json')
    verification=load(out/'VERIFICATION.json')
    results=load(out/'RESULT.json')
    checks=dict(protocol_checksum=sha(out/'protocol.json')==(out/'protocol.sha256').read_text().strip(),
        implementation_driver_unchanged=sha(Path(__file__).with_name('run_fcs_cts_pdn.py'))==protocol['driver_sha256'],
        verification_driver_unchanged=sha(Path(__file__).with_name('verify_fcs_cts_pdn.py'))==verification['driver_sha256'],
        all_verification_passed=verification['passed'],new_model_calls_zero=protocol['new_model_calls']==results['new_model_calls']==verification['new_model_calls']==0,
        liberty_unchanged=sha(LIB)==protocol['liberty_sha256'],binary_unchanged=sha(OPENROAD)==protocol['openroad_binary_sha256'],
        runtime_manifest_unchanged=sha(TOOLS/'RUNTIME.json')==protocol['runtime_sha256'],
        prior_physical_protocol_unchanged=sha(GLOBAL/'protocol.json')==protocol['prior_physical_protocol_sha256'],
        original_functional_result_unchanged=sha(SOURCE/'RESULT.json')==protocol['source_result_sha256'])
    for item in protocol['pdn_platform']['files']:
        checks['pdn_source:'+item['path']]=sha(Path(item['path']))==item['sha256']
    for name,digest in load(PRIOR/'ARTIFACTS.json').items():
        checks['prior_physical_artifact:'+name]=sha(PRIOR/name)==digest
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    ld=':'.join(load(TOOLS/'RUNTIME.json')['library_paths'])
    negatives_all={}
    cases={}
    tap='sky130_fd_sc_hd__tapvpwrvgnd_1'
    lef=(PLATFORM/'lef/sky130_fd_sc_hd_merged.lef').read_text()
    tap_block=lef.split('MACRO '+tap,1)[1].split('END '+tap,1)[0]
    tap_pins=re.findall(r'PIN\s+(\S+)[\s\S]*?USE\s+(\S+)\s*;',tap_block)
    checks['excluded_tap_has_only_supply_pins']=bool(tap_pins) and all(use in ('POWER','GROUND') for _,use in tap_pins)
    for case in ('baseline','optimized'):
        folder=out/case
        r=results['cases'][case]
        v=verification['cases'][case]
        checks[case+':routed_and_extracted']=r['status']=='CTS_PDN_ROUTED_EXTRACTED' and r['tool_exit_code']==0
        checks[case+':drc_empty']=(folder/'drc.rpt').is_file() and (folder/'drc.rpt').stat().st_size==0
        checks[case+':spef_checksum']=sha(folder/'extracted.spef')==r['spef_sha256']==v['spef_sha256']
        checks[case+':same_source_input']=sha(GLOBAL/case/'prepared.v')==protocol['inputs'][case]['prepared_sha256']
        checks[case+':same_sdc_input']=sha(GLOBAL/case/'timing.sdc')==protocol['inputs'][case]['sdc_sha256']
        log=(folder/'openroad.log').read_text()
        checks[case+':final_router_violations_zero']=re.findall(r'Number of violations = (\d+)\.',log)[-1]=='0'
        checks[case+':setup_and_hold_nonnegative']=all(math.isfinite(r[stage]['wns_ns']) and r[stage]['wns_ns']>=0 and r[stage]['tns_ns']==0 for stage in ('setup','hold'))
        checks[case+':electric_clean']=r['setup']['electrical_violation_rows']==0
        checks[case+':propagated_clock_in_sta']='clock network delay (propagated)' in (folder/'independent_sta.log').read_text() or 'clkbuf_0_clk/X' in (folder/'independent_sta.log').read_text()
        checks[case+':no_independent_sta_warnings']=not re.search(r'^Warning:',(folder/'independent_sta.log').read_text(),re.M)
        cts=(folder/'cts.rpt').read_text()
        checks[case+':65_clock_sinks']='Total number of Sinks: 65.' in cts
        checks[case+':one_clock_root']='Total number of Clock Roots: 1.' in cts
        original=load(folder/'original.json')['modules']['axis_eth_fcs']
        modules=load(folder/'routed.json')['modules']
        routed=modules['axis_eth_fcs']
        negatives_all[case]=negatives(original,routed,modules)
        checks[case+':clock_and_data_negative_controls']=negatives_all[case]['passed']
        tcl=folder/'final_pdn_check.tcl'
        tcl.write_text(f'''read_liberty {{{wsl(LIB)}}}
read_db {{{wsl(folder/'detailed.odb')}}}
check_power_grid -net VDD -error_file final_vdd_errors.rpt
check_power_grid -net VSS -error_file final_vss_errors.rpt
puts PW_FINAL_PDN_PASS
''',encoding='ascii')
        p=subprocess.run(['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+ld,'QT_QPA_PLATFORM=offscreen',
                          wsl(OPENROAD),'-no_init','-exit',wsl(tcl)],cwd=folder,env=env,capture_output=True,timeout=120)
        pglog=(p.stdout+p.stderr).decode(errors='replace')
        (folder/'final_pdn_check.log').write_text(pglog,encoding='utf-8')
        checks[case+':final_routed_pdn_connected']=p.returncode==0 and 'PW_FINAL_PDN_PASS' in pglog and all('All shapes on net '+net+' are connected.' in pglog for net in ('VDD','VSS'))
        with (folder/'physical_cells.tsv').open() as f:
            physical=list(csv.DictReader(f,delimiter='\t'))
        checks[case+':physical_area_reproduces']=math.isclose(sum(float(c['area_um2']) for c in physical),v['physical_cell_area_um2'],abs_tol=1e-6)
        checks[case+':reported_area_agrees']=abs(v['physical_cell_area_um2']-r['setup']['reported_area_um2'])<1
        cases[case]=dict(setup_wns_ns=r['setup']['wns_ns'],hold_wns_ns=r['hold']['wns_ns'],setup_tns_ns=r['setup']['tns_ns'],hold_tns_ns=r['hold']['tns_ns'],
                         cell_area_um2=v['physical_cell_area_um2'],physical_cells=v['physical_cell_count'],
                         tap_cells=v['tap_count'],clock_buffers=v['clock_buffer_count'],clock_dummy_loads=v['clock_dummy_count'],
                         pg_pins=v['power_ground_pin_count'],clock_sinks=65)
    b,c=cases['baseline'],cases['optimized']
    checks['strict_setup_wns_improvement']=c['setup_wns_ns']>b['setup_wns_ns']
    checks['area_cap']=c['cell_area_um2']<=1.1*b['cell_area_um2']
    checks['identical_sdc']=(GLOBAL/'baseline/timing.sdc').read_bytes()==(GLOBAL/'optimized/timing.sdc').read_bytes()
    for study in ('expanded_feedback_80_20261107','crc_feedback_20_20261107_ready'):
        deps=load(ROOT/'eda/experiments'/study/'protocol.json')['dependencies']
        checks[study+':frozen_code_unchanged']=all(sha(ROOT/path)==digest for path,digest in deps.items())
    save(out/'NEGATIVE_CONTROLS.json',negatives_all)
    audit=dict(passed=all(checks.values()),check_count=len(checks),checks=checks)
    save(out/'AUDIT.json',audit)
    if not audit['passed']:
        raise RuntimeError('Failed audit: '+str([k for k,v in checks.items() if not v]))
    gain=round(c['setup_wns_ns']-b['setup_wns_ns'],2)
    area_reduction=round(100*(1-c['cell_area_um2']/b['cell_area_um2']),2)
    summary=dict(status='PASS_WITH_EXPLICIT_SCOPE',cases=cases,setup_wns_gain_ns=gain,
        total_cell_area_reduction_percent=area_reduction,clock_model='propagated extracted clock tree',
        cts=True,pdn=True,final_pdn_connectivity=True,supported_router_drc_zero=True,
        logical_initial_state_scope_retained=True,full_physical_signoff=False,new_model_calls=0)
    save(out/'SUMMARY.json',summary)
    report=f'''# FCS时钟树、供电与寄生验证

同一8位以太网FCS原始版和历史CRC优化版，使用新建立的相同CTS/PDN流程，完成放置、时钟树、详细布线、OpenRCX提取和传播时钟分析。优化收益仍保留；本轮新增模型调用0次。

| 同一10ns时钟、130×130µm die及固定核心 | 原始版 | 优化版 |
|---|---:|---:|
| 提取后建立时间WNS / ns | {b['setup_wns_ns']:.2f} | {c['setup_wns_ns']:.2f} |
| 提取后保持时间WNS / ns | {b['hold_wns_ns']:.2f} | {c['hold_wns_ns']:.2f} |
| 建立/保持TNS / ns | 0 / 0 | 0 / 0 |
| 全部单元面积 / µm² | {b['cell_area_um2']:.4f} | {c['cell_area_um2']:.4f} |
| 全部物理单元数 | {b['physical_cells']} | {c['physical_cells']} |
| tap单元数 | {b['tap_cells']} | {c['tap_cells']} |
| 实际时钟树缓冲数 | {b['clock_buffers']} | {c['clock_buffers']} |
| 时钟虚负载单元数 | {b['clock_dummy_loads']} | {c['clock_dummy_loads']} |

建立时间裕量改善{gain:.2f}ns，含tap、时钟缓冲和虚负载的总单元面积降低{area_reduction:.2f}%。保持时间均为正，未做hold修复；优化版保持裕量略低，未宣称保持时间改善。核心和die相同，单元面积下降不等于芯片面积已缩小，也没有功耗或频率实测。

## 实现与核验

固定OpenROAD 26Q2-1164-g08f67ee5ec、SKY130HD TT、工艺平台提交aef47dd6ed123b0ed7cedac372b00456722be327。die和site对齐后的核心与上一轮一致，但这次重新建立两版同流程基线，未将上一轮理想时钟数字当成当前对照。

从旧已验证prepared.v重新开始；相同tap距离14µm、未改的上游PDN/全局供电连接脚本、相同密度0.60、CTS缓冲库/根缓冲、2线程和路由种子42。两版各65个寄存器时钟接入单个根、9个非反相时钟缓冲。CTS自动增加无逻辑输出负载的虚负载以匹配时钟负载；其电容和面积保留在实际时序和面积中。

完整原始数据、状态和逻辑端口连接图保持一致，只在结构核对中收缩实际库函数为X=A的时钟缓冲；对每个虚负载确认所有输入来自时钟树、输出无负载。实际传播时钟延迟从真实布线SPEF读取，并未在STA中删除这些单元。六个离线结构负例（两版各三个：换反相钟元、把寄存器时钟接数据、把寄存器数据置常量）均被拒绝；它们是检查器负例，不是新RTL优化样本。

物理DB中每个单元都有正确VDD/VSS连接，分别检查{b['pg_pins']}和{c['pg_pins']}个PG引脚。PDN在CTS后及详细布线后两次检查均连通。tap单元LEF只有电源/地引脚，因此只从数字时序网表排除，未从物理面积、供电检查或DEF/ODB中删除。

独立OpenSTA重读最终Verilog和SPEF，启用传播时钟，建立/保持WNS、TNS与OpenROAD内置STA完全一致，电气检查通过。覆盖核对表明未注释的输入、常量闲置输出及虚负载闲置输出均无任何数字负载，没有部分未注释驱动；所有有负载的数据信号和时钟信号均覆盖。路由器最终报告0条违规，DRC文件为空。{len(checks)}项审计通过；旧80次、CRC20次与前轮物理证据保持不变。

## 兼容性记录

首次结构核对发现PDN为物理顶层增加了VDD/VSS端口；先验证它们未连接任何数字信号，再仅在独立时序视图中删除这两个闲置供电端口，保留原物理网表、DB及供电网络。这消除了将供电口当成无约束数据口的假报，没有为真实数据路径增加或放宽约束。初次失败核对保留在VERIFICATION_FIRST.json。

库函数检查区分function与power_down_function，并识别等价表达式(A)。所有测量布局、网表和SPEF未因检查器兼容修正而重新生成或挑选。

## 范围与下一步

这是包含CTS、tap和连通PDN的固定实例实现验证；尚无完整GDS、独立工艺DRC/LVS签核、天线签核、IR压降或电迁移分析。路由器依旧明确警告不支持部分LEF58_ENCLOSURE规则，0条路由器违规不能当完整制造规则通过。未声称包含完整边界/填充单元流程。供电连通不代表承载电流或压降满足要求。

原功能证明保留RTL逻辑初值契约；物理tap/供电/时钟树不保证任意上电状态会得到这些初值。一次固定几何/种子/TT角，不证明跨角和跨设计泛化。这是历史候选在更真实实现条件下的迁移证据，没有增加历史模型调用分母。

下一步应先明确并验证不依赖物理初值的产品复位契约，再评估独立DRC/LVS与电源完整性；研究方法有效性仍需独立设计和统一预算对照。
'''
    (out/'INTERPRETATION.md').write_text(report,encoding='utf-8')
    save(out/'IMPLEMENTATION_SHA256.json',{str(p.relative_to(ROOT)):sha(p) for p in (Path(__file__),Path(__file__).with_name('run_fcs_cts_pdn.py'),Path(__file__).with_name('verify_fcs_cts_pdn.py'))})
    save(out/'ARTIFACTS.json',{str(p.relative_to(out)):sha(p) for p in out.rglob('*') if p.is_file() and p.name!='ARTIFACTS.json'})
    print(json.dumps(dict(passed=True,checks=len(checks),setup_wns_gain_ns=gain,total_cell_area_reduction_percent=area_reduction,new_model_calls=0)))


if __name__=='__main__':
    main()
