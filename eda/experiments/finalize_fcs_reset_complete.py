"""Publish arbitrary-state reset qualification and its fresh physical comparison."""
import copy
import json
import math
import os
from pathlib import Path
import re
import shutil
import subprocess

from qualify_fcs_reset_complete import ROOT, OUT, TOP, RUNNER, sha, save
from run_fcs_reset_cts_pdn import GLOBAL, PDN_PLATFORM
from run_fcs_physical import PLATFORM, TOOLS, LIB, OPENROAD, wsl
from route_fcs_detailed import logical_graph
from verify_fcs_reset_cts_pdn import normalize_clock

PHYSICAL=ROOT/'eda/experiments/fcs_reset_cts_pdn_20261107'


def load(p):
    return json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    protocol=load(OUT/'protocol.json')
    phys_protocol=load(PHYSICAL/'protocol.json')
    results=load(OUT/'RESULT.json')['cases']
    verification=load(PHYSICAL/'VERIFICATION.json')
    checks=dict(reset_protocol_checksum=sha(OUT/'protocol.json')==(OUT/'protocol.sha256').read_text().strip(),
       reset_runner_unchanged=sha(RUNNER)==protocol['runner_sha256'],
       reset_driver_unchanged=sha(Path(__file__).with_name('qualify_fcs_reset_complete.py'))==protocol['driver_sha256'],
       reset_single_dut_properties=load(OUT/'independent_contract/RESET_PROPERTY.json')['passed'],
       independent_raw_simulation=load(OUT/'independent_contract/SIMULATION.json')['passed'],
       physical_verification=verification['passed'],
       physical_driver_unchanged=sha(Path(__file__).with_name('run_fcs_reset_cts_pdn.py'))==phys_protocol['driver_sha256'],
       physical_verifier_unchanged=sha(Path(__file__).with_name('verify_fcs_reset_cts_pdn.py'))==verification['driver_sha256'],
       physical_protocol_checksum=sha(PHYSICAL/'protocol.json')==(PHYSICAL/'protocol.sha256').read_text().strip(),
       physical_source_result_unchanged=sha(OUT/'RESULT.json')==phys_protocol['source_result_sha256'],
       physical_preparation_protocol_unchanged=sha(GLOBAL/'protocol.json')==phys_protocol['prior_physical_protocol_sha256'],
       liberty_unchanged=sha(LIB)==phys_protocol['liberty_sha256'],
       binary_unchanged=sha(OPENROAD)==phys_protocol['openroad_binary_sha256'],
       no_model_calls=protocol['new_model_calls']==phys_protocol['new_model_calls']==0)
    for name,digest in protocol['sources'].items():
        checks['raw_source:'+name]=sha(OUT/name/'source.v')==digest
    for old in ('fcs_physical_20261107_detailed_empty_supply_fix','fcs_cts_pdn_20261107_initial'):
        folder=ROOT/'eda/experiments'/old
        checks[old+':all_artifacts_unchanged']=all(sha(folder/name)==digest for name,digest in load(folder/'ARTIFACTS.json').items())
    for old in ('expanded_feedback_80_20261107','crc_feedback_20_20261107_ready'):
        checks[old+':frozen_code_unchanged']=all(sha(ROOT/name)==digest for name,digest in load(ROOT/'eda/experiments'/old/'protocol.json')['dependencies'].items())
    for label in ('missing_reset','wrong_output'):
        checks[label+':actual_formal_failure']=results[label]['formal']=='FAIL' and 'model found for base case: FAIL!' in (OUT/label/'evaluation/formal.log').read_text()
        checks[label+':counterexample_preserved']=(OUT/label/'evaluation/formal_counterexample.vcd').is_file()
    env=os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    yosys=Path(env.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH']=str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    ld=':'.join(load(TOOLS/'RUNTIME.json')['library_paths'])
    negative_controls={}
    for case in ('baseline','optimized'):
        r=results[case]
        checks[case+':full_eda_pass']=all(r[k]=='PASS' for k in ('status','formal','mapped_formal','ppa')) and r['electrical']['status']=='PASS'
        for filename in ('before_opt.json','elaborated.json','evaluation/candidate_schema.json','evaluation/reference_schema.json','evaluation/mapped.json'):
            module=load(OUT/case/filename)['modules'][TOP]
            checks[case+':no_init:'+filename]=not any('init' in n.get('attributes',{}) for n in module['netnames'].values())
        for stage in ('formal','mapped_formal'):
            text=(OUT/case/'evaluation'/(stage+'.log')).read_text()
            checks[case+':'+stage+':complete_induction']='Induction step proven: SUCCESS!' in text and 'Base case for induction length' in text
            checks[case+':'+stage+':unconstrained_initial_states']='No constraints for initial state found.' in text
            state=load(OUT/case/'evaluation'/(stage+'_state_invariants.json'))
            checks[case+':'+stage+':no_state_assumptions']=state['assumed_state_equalities']==0
        checks[case+':mapped_checksum']=sha(OUT/case/'evaluation/mapped.v')==r['mapped_sha256']
        folder=PHYSICAL/case
        original=load(folder/'original.json')['modules'][TOP]
        modules=load(folder/'routed.json')['modules']
        routed=modules[TOP]
        normalized,clock=normalize_clock(original,routed,modules)
        checks[case+':clock_data_graph']=logical_graph(original)==logical_graph(normalized)
        script=folder/'read_qualified.ys'
        script.write_text(f'read_liberty -lib "{LIB.as_posix()}"\nread_verilog "{(OUT/case/"evaluation/mapped.v").as_posix()}"\nhierarchy -check -top {TOP}\nwrite_json qualified_readback.json\n')
        p=subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=folder,env=env,capture_output=True,timeout=60)
        (folder/'read_qualified.log').write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError('Readback failed')
        gold=load(folder/'qualified_readback.json')['modules'][TOP]
        checks[case+':proved_to_physical_input_graph']=logical_graph(gold)==logical_graph(original)
        def rejects(bad):
            try:
                normalized,_=normalize_clock(original,bad,modules)
                return logical_graph(original)!=logical_graph(normalized)
            except AssertionError:
                return True
        bad=copy.deepcopy(routed)
        ff=next(n for n in original['cells'] if 'CLK' in bad['cells'][n]['connections'])
        bad['cells'][ff]['connections']['CLK']=[routed['ports']['s_axis_tdata']['bits'][0]]
        clock_negative=rejects(bad)
        bad=copy.deepcopy(routed)
        bad['cells'][ff]['connections']['D']=['0']
        data_negative=rejects(bad)
        negative_controls[case]=dict(clock_rewire_rejected=clock_negative,data_rewire_rejected=data_negative,
            scope='In-memory actual routed-graph mutations, not new EDA/model samples')
        checks[case+':physical_graph_negatives']=clock_negative and data_negative
        tcl=folder/'final_pdn_check.tcl'
        tcl.write_text(f'read_liberty {{{wsl(LIB)}}}\nread_db {{{wsl(folder/"detailed.odb")}}}\ncheck_power_grid -net VDD -error_file final_vdd_errors.rpt\ncheck_power_grid -net VSS -error_file final_vss_errors.rpt\nputs PW_FINAL_PDN_PASS\n',encoding='ascii')
        p=subprocess.run(['wsl.exe','-d','Ubuntu','--','env','LD_LIBRARY_PATH='+ld,'QT_QPA_PLATFORM=offscreen',wsl(OPENROAD),'-no_init','-exit',wsl(tcl)],cwd=folder,env=env,capture_output=True,timeout=120)
        pglog=(p.stdout+p.stderr).decode(errors='replace')
        (folder/'final_pdn_check.log').write_text(pglog,encoding='utf-8')
        checks[case+':final_pdn_connected']=p.returncode==0 and 'PW_FINAL_PDN_PASS' in pglog and all('All shapes on net '+n+' are connected.' in pglog for n in ('VDD','VSS'))
        pr=load(folder/'RESULT.json')
        checks[case+':drc_empty']=(folder/'drc.rpt').is_file() and (folder/'drc.rpt').stat().st_size==0
        checks[case+':last_drc_count_zero']=re.findall(r'Number of violations = (\d+)\.',(folder/'openroad.log').read_text())[-1]=='0'
        checks[case+':physical_setup_hold_pass']=all(math.isfinite(pr[s]['wns_ns']) and pr[s]['wns_ns']>=0 and pr[s]['tns_ns']==0 for s in ('setup','hold'))
        checks[case+':spef_checksum']=sha(folder/'extracted.spef')==pr['spef_sha256']==verification['cases'][case]['spef_sha256']
        checks[case+':no_independent_sta_warning']=not re.search(r'^Warning:',(folder/'independent_sta.log').read_text(),re.M)
    b,c=verification['cases']['baseline'],verification['cases']['optimized']
    checks['new_baseline_physical_area_cap']=c['physical_cell_area_um2']<=1.1*b['physical_cell_area_um2']
    checks['new_baseline_strict_wns_improvement']=c['setup']['wns_ns']>b['setup']['wns_ns']
    checks['identical_physical_sdc']=(GLOBAL/'baseline/timing.sdc').read_bytes()==(GLOBAL/'optimized/timing.sdc').read_bytes()
    audit=dict(passed=all(checks.values()),check_count=len(checks),checks=checks)
    save(OUT/'AUDIT.json',audit)
    save(PHYSICAL/'NEGATIVE_CONTROLS.json',negative_controls)
    if not audit['passed']:
        raise RuntimeError('Failed checks: '+str([k for k,v in checks.items() if not v]))
    exports=OUT/'exports'
    exports.mkdir(exist_ok=True)
    for name,target in [('baseline','baseline.v'),('optimized','best.v')]:
        shutil.copyfile(OUT/name/'elaborated.v',exports/target)
    shutil.copyfile(ROOT/'benchmark/ethernet_fcs_integration_20261107/COPYING',exports/'COPYING')
    save(exports/'CONTRACT.json',dict(top=TOP,parameters='Already specialized to DATA_WIDTH8, KEEP_ENABLE0, KEEP_WIDTH1; no overrides',
        reset='Active-high synchronous reset sampled for at least one rising edge before use. Clears CRC state to FFFFFFFF, FCS to 0 and FCS valid to 0. Reset overrides simultaneous frame completion.',
        initial_state='No declared initialization or physical power-up value assumed. Without reset, no startup-output guarantee.',
        behavior_change='New named reset-complete variant, intentionally different from original upstream FCS word during reset/invalid intervals',
        output_comparison='All 34 output bits including invalid FCS data; no protocol/input restrictions beyond startup reset',
        baseline_sha256=sha(exports/'baseline.v'),best_sha256=sha(exports/'best.v'),new_model_calls=0))
    gain=round(c['setup']['wns_ns']-b['setup']['wns_ns'],2)
    area_gain=round(100*(1-c['physical_cell_area_um2']/b['physical_cell_area_um2']),2)
    summary=dict(status='PASS_RESET_ONLY_AND_PHYSICAL',top=TOP,initial_state_assumptions=False,reset_edges_required=1,
         source_and_gate_induction=True,single_dut_reset_constant_property=True,independent_raw_simulation_cycles=4096,
         physical_cases=verification['cases'],setup_wns_gain_ns=gain,total_cell_area_reduction_percent=area_gain,
         new_model_calls=0,full_physical_signoff=False)
    save(OUT/'SUMMARY.json',summary)
    report=f'''# 复位完整FCS及新物理验证

已建立单独命名的 `{TOP}`，移除原三个状态寄存器的RTL初值，并为原来未复位的FCS字寄存器增加同步清零。原始CRC实现与历史优化CRC实现接受相同修改，各自重新映射和物理实现。一次有效同步复位后不再依赖任何DUT初值；新增模型调用0次。

## 新接口契约

至少一个上升沿采样到rst=1后，CRC状态为FFFFFFFF、output_fcs为0、output_fcs_valid为0、s_axis_tready为1。之后所有定义值输入任意，包含重复复位、停顿、任意帧尾和tkeep/tuser；比较所有34位输出，无效期间的FCS数据也不屏蔽。复位优先于同拍帧尾，新的fcs_reg清零会覆盖该拍CRC字写入。

这是有意加强复位保证的新版本，不声称与未修改上游在复位/无效数据期间全引脚等价。未复位时不承诺上电输出，物理复位信号仍必须按同步接口提供有效时钟边沿。

## 证明与仿真

- 源级和实际标准单元门级均从独立任意定义初态开始，完成基础情形及时间归纳，比较全部输出及额外待证明状态关系。没有初态相等假设、RTL初值、状态切点假设或有效数据掩码。两个源级和两个门级日志均明确记录 `No constraints for initial state found.`。
- 独立单DUT复位性质不依赖两个实现之间的关系：全65个状态位和全34个输出位在第一次复位边沿后固定到规定值。原始和优化两版的源级及门级均通过。缺少FCS复位的旧行为无初值版本给出真实反例。
- 缺失复位、翻转输出的两个源级负例均被SAT反例拒绝，反例VCD保留。物理连接检查的时钟/数据接错负例另行拒绝。
- Linux Icarus 12.0-3直接编译两份原始RTL，对独立Python逐位CRC模型完成4096拍核对，包含标准123456789→CBF43926、任意停顿/帧尾/重复复位，以及首拍rst、valid、last同时为1的复位优先级检查。

## 重新建立的实现结果

| 同一新复位契约和流程 | 新原始版 | 新优化版 |
|---|---:|---:|
| 前布局WNS / ns | {results['baseline']['wns_ns']:.2f} | {results['optimized']['wns_ns']:.2f} |
| CTS/PDN/详细布线/提取后建立WNS / ns | {b['setup']['wns_ns']:.2f} | {c['setup']['wns_ns']:.2f} |
| 提取后保持WNS / ns | {b['hold']['wns_ns']:.2f} | {c['hold']['wns_ns']:.2f} |
| 建立/保持TNS / ns | 0 / 0 | 0 / 0 |
| 全部物理单元面积 / µm² | {b['physical_cell_area_um2']:.4f} | {c['physical_cell_area_um2']:.4f} |
| 物理单元数 | {b['physical_cell_count']} | {c['physical_cell_count']} |

新契约下建立时间裕量增加{gain:.2f}ns，总单元面积降低{area_gain:.2f}%。两版均147个tap、9个实际时钟树缓冲、7个时钟虚负载。核心/die相同，未将单元面积下降称作芯片面积已缩小。旧版本的17.75%不作为本轮结果，复位硬件改变后使用本轮新基线。

固定SKY130HD TT、10ns时钟、die130×130µm、相同site对齐核心、相同密度0.60、供电规则、CTS库、2线程和路由种子42。原数据和状态图从已证明门级网表到物理准备、最终网表均保持，只有经过库函数核实的非反相时钟树和无输出负载的时钟虚负载被结构归一；实际STA保留全部延迟和负载。

两版完整物理单元PG引脚正确，详细布线后再次确认VDD/VSS全部形状连通。实际SPEF由独立OpenSTA重读，传播时钟下建立/保持、电气及全部有负载寄生覆盖通过。路由器支持范围内0违规，DRC报告为空。全部{len(checks)}项审计通过，旧模型实验与两轮历史物理产物不改。

## 工具兼容性与保留记录

首次尝试目录fcs_reset_complete_20261107保留：本机Yosys拒绝同时使用-prove-skip与-tempinduct，尚未启动有效SAT，不算功能错误。修正为工具要求的-seq归纳起点后重新建立当前独立目录；单DUT两拍复位性质另用允许的有界-prove-skip验证，无省略的基础情形或临时假设。

Windows Icarus在原始RTL编译中原生访问违例退出（0xC0000005），长inline测试台和紧凑测试台均失败；原长测试台、空失败日志和诊断记录保留，没有宣称Windows仿真通过。改用项目隔离的官方Ubuntu Icarus12包，未安装系统软件，使用同一原始源码和冻结4096拍向量通过。Linux工具包哈希和版本保留。没有通过改变DUT来绕过编译错误。

## 交付与边界

exports/best.v是已证明的固定8位优化RTL，顶层{TOP}；baseline.v、许可证和CONTRACT.json配套。它们没有初值属性或参数覆盖接口，必须遵循一次同步复位契约。

仍不是完整流片签核：缺少独立工艺DRC/LVS、完整GDS/填充边界流程、天线签核、电源IR压降/电迁移与功耗测量。路由器不支持部分LEF58规则，0条路由违规不能冒充完整制造规则通过。一次固定实例、种子和TT角也不能证明STA提示方法优势或跨设计泛化。

下一步可以围绕这对稳定的复位完整实现开展独立DRC/LVS和电源完整性检查；研究评价仍需新的独立电路/固定预算对照，不能把本轮实现验证计成新增模型样本。
'''
    (OUT/'INTERPRETATION.md').write_text(report,encoding='utf-8')
    save(OUT/'WINDOWS_SIM_FAILURE.json',dict(status='COMPILER_ACCESS_VIOLATION',exit_code_unsigned=3221225477,exit_code_hex='0xC0000005',
        inline_tb_preserved='independent_contract/tb_inline_first.v',compile_log='independent_contract/compile_first.log',
        compact_tb_also_failed=True,linux_fallback_passed=True,functional_failure_claim=False))
    save(OUT/'IMPLEMENTATION_SHA256.json',{str(p.relative_to(ROOT)):sha(p) for p in (
        Path(__file__),RUNNER,Path(__file__).with_name('qualify_fcs_reset_complete.py'),Path(__file__).with_name('verify_fcs_reset_contract.py'),
        Path(__file__).with_name('simulate_fcs_reset_vectors.py'),Path(__file__).with_name('run_fcs_reset_cts_pdn.py'),
        Path(__file__).with_name('verify_fcs_reset_cts_pdn.py'),ROOT/'eda/tools/iverilog_linux_20261107/run_reset_sim.py',ROOT/'eda/tools/iverilog_linux_20261107/SOURCE_LOCK.json')} )
    save(OUT/'ARTIFACTS.json',{str(p.relative_to(OUT)):sha(p) for p in OUT.rglob('*') if p.is_file() and p.name!='ARTIFACTS.json'})
    save(PHYSICAL/'ARTIFACTS.json',{str(p.relative_to(PHYSICAL)):sha(p) for p in PHYSICAL.rglob('*') if p.is_file() and p.name!='ARTIFACTS.json'})
    print(json.dumps(dict(passed=True,checks=len(checks),reset_edges=1,setup_wns_gain_ns=gain,physical_area_reduction_percent=area_gain,new_model_calls=0)))


if __name__=='__main__':
    main()
