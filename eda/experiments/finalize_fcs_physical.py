"""Audit fixed-geometry, ideal-clock detailed FCS routing and its limits."""
import json
import math
import os
from pathlib import Path
import re
import subprocess

from route_fcs_detailed import OUT, GLOBAL, ROOT, SOURCE, PLATFORM, TOOLS, LIB, OPENROAD, sha, save, logical_graph


def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def unannotated_coverage(module, text, library_modules):
    match = re.search(r'Found (\d+) unannotated drivers\.\n([\s\S]*?)Found (\d+) partially unannotated drivers\.',text)
    if not match:
        return dict(passed=False,reason='Coverage report missing')
    drivers = [line.strip() for line in match[2].splitlines() if line.strip()]
    loads = {}
    for cell in module['cells'].values():
        for pin,bits in cell['connections'].items():
            if cell['port_directions'][pin] == 'input':
                for bit in bits:
                    loads[bit] = loads.get(bit,0)+1
    for port in module['ports'].values():
        if port['direction'] == 'output':
            for bit in port['bits']:
                loads[bit] = loads.get(bit,0)+1
    checks = {}
    for driver in drivers:
        if driver in module['ports'] and module['ports'][driver]['direction'] == 'input':
            bits = module['ports'][driver]['bits']
            checks[driver] = all(loads.get(bit,0)==0 for bit in bits)
        elif '/' in driver:
            cell_name,pin = driver.rsplit('/',1)
            cell = module['cells'].get(cell_name)
            direction = (cell['port_directions'].get(pin) or library_modules[cell['type']]['ports'].get(pin,{}).get('direction')) if cell else None
            checks[driver] = bool(cell and direction=='output' and
                                  all(loads.get(bit,0)==0 for bit in cell['connections'].get(pin,[])))
        else:
            checks[driver] = False
    return dict(passed=len(drivers)==int(match[1]) and int(match[3])==0 and all(checks.values()),
                unannotated_drivers=checks,partially_unannotated_drivers=int(match[3]),
                meaning='Each missing driver has exactly zero input-pin and top-output loads in the actual routed netlist')


def main():
    result = load(OUT/'RESULT.json')
    protocol = load(OUT/'protocol.json')
    parent = load(GLOBAL/'protocol.json')
    checks = {
        'protocol_checksum':sha(OUT/'protocol.json')==(OUT/'protocol.sha256').read_text().strip(),
        'driver_unchanged':sha(Path(__file__).with_name('route_fcs_detailed.py'))==protocol['driver_sha256'],
        'parent_protocol':sha(GLOBAL/'protocol.json')==protocol['parent_protocol_sha256'],
        'parent_driver_unchanged':sha(Path(__file__).with_name('run_fcs_physical.py'))==parent['driver_sha256'],
        'liberty':sha(LIB)==protocol['liberty_sha256']==parent['liberty_sha256'],
        'openroad_binary':sha(OPENROAD)==protocol['openroad_binary_sha256'],
        'runtime_manifest':sha(TOOLS/'RUNTIME.json')==protocol['runtime_sha256'],
        'physical_platform_manifest':sha(PLATFORM/'PROVENANCE.json')==protocol['platform_manifest_sha256'],
        'independent_sta':load(OUT/'INDEPENDENT_STA.json')['passed'],
        'earlier_functional_audit':load(SOURCE/'AUDIT.json')['passed'],
        'earlier_functional_result_unchanged':sha(SOURCE/'RESULT.json')==parent['source_result_sha256'],
        'no_model_calls':result['new_model_calls']==protocol['new_model_calls']==0,
        'ideal_clock_explicit':result['clock_model']=='ideal' and result['cts'] is False and result['pdn'] is False,
    }
    for entry in load(PLATFORM/'PROVENANCE.json')['files']:
        checks['platform:'+entry['path']] = sha(Path(entry['path']))==entry['sha256']
    for entry in load(TOOLS/'RUNTIME.json')['packages']:
        checks['runtime_package:'+entry['name']] = sha(TOOLS/'deps'/entry['name'])==entry['sha256']
    lib_areas = {name:float(value) for name,value in re.findall(r'cell\s*\(\s*"?([A-Za-z0-9_]+)"?\s*\)\s*\{[\s\S]*?\barea\s*:\s*([\d.]+)',LIB.read_text())}
    lef = (PLATFORM/'lef/sky130_fd_sc_hd_merged.lef').read_text()
    lef_areas = {name:float(width)*float(height) for name,width,height in re.findall(r'MACRO\s+(\S+)[\s\S]*?SIZE\s+([\d.]+)\s+BY\s+([\d.]+)',lef)}
    coverage, cases = {}, {}
    env = os.environ.copy()
    for key in ('OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY'):
        env.pop(key,None)
    yosys = Path(env.get('YOSYS','D:/oss-cad-suite/bin/yosys.exe'))
    env['PATH'] = str(yosys.parent)+os.pathsep+str(yosys.parent.parent/'lib')+os.pathsep+env.get('PATH','')
    for name in ('baseline','optimized'):
        folder = OUT/name
        r = result['cases'][name]
        library_modules = load(folder/'routed.json')['modules']
        module = library_modules['axis_eth_fcs']
        prepared = load(GLOBAL/name/'prepared.json')['modules']['axis_eth_fcs']
        # write_verilog assigns public names to private cells. Re-read the exact
        # proven mapped Verilog, rather than comparing pre-export private names.
        original_file = GLOBAL/name/'original_mapped.v'
        checks[name+':original_mapped_input_checksum'] = sha(original_file)==load(SOURCE/name/'evaluation/result.json')['mapped_sha256']
        script = folder/'read_original.ys'
        script.write_text(f'read_liberty -lib "{LIB.as_posix()}"\nread_verilog "{original_file.as_posix()}"\nhierarchy -check -top axis_eth_fcs\nwrite_json original_readback.json\n')
        p = subprocess.run([str(yosys),'-Q','-s',str(script)],cwd=folder,env=env,capture_output=True,timeout=60)
        (folder/'read_original.log').write_bytes(p.stdout+p.stderr)
        if p.returncode:
            raise RuntimeError('Could not read original mapped source')
        original = load(folder/'original_readback.json')['modules']['axis_eth_fcs']
        checks[name+':complete'] = r['status']=='DETAILED_ROUTE_AND_EXTRACTION_COMPLETE' and r['tool_exit_code']==0
        checks[name+':finite_metrics'] = all(isinstance(r.get(k),(int,float)) and math.isfinite(r[k]) for k in ('wns_ns','tns_ns','reported_area_um2'))
        checks[name+':source_to_prepared_graph'] = logical_graph(original)==logical_graph(prepared)
        checks[name+':prepared_to_routed_graph'] = logical_graph(prepared)==logical_graph(module)
        checks[name+':drc_empty'] = (folder/'drc.rpt').is_file() and (folder/'drc.rpt').stat().st_size==0
        checks[name+':drc_log'] = re.findall(r'Number of violations = (\d+)\.',(folder/'openroad.log').read_text())[-1]=='0'
        checks[name+':electrical_clean'] = r['electrical_violation_rows']==0
        checks[name+':spef_checksum'] = sha(folder/'extracted.spef')==r['spef_sha256']
        checks[name+':spef_has_rc'] = all(token in (folder/'extracted.spef').read_text() for token in ('*D_NET','*CAP','*RES','*END'))
        checks[name+':input_db_checksum'] = sha(GLOBAL/name/'global_routed.odb')==protocol['sources'][name]['db_sha256']
        coverage[name] = unannotated_coverage(module,(folder/'independent_sta.log').read_text(),library_modules)
        checks[name+':all_loaded_drivers_annotated'] = coverage[name]['passed']
        area = sum(lib_areas[c['type']] for c in module['cells'].values())
        lef_area = sum(lef_areas[c['type']] for c in module['cells'].values())
        checks[name+':liberty_lef_area_agree'] = math.isclose(area,lef_area,rel_tol=1e-9)
        checks[name+':reported_area_consistent'] = abs(area-r['reported_area_um2'])<1
        log = (folder/'openroad.log').read_text()
        wire_length = int(re.findall(r'Total wire length = (\d+) um\.',log)[-1])
        cases[name] = dict(**r,exact_cell_area_um2=round(area,4),cell_count=len(module['cells']),wire_length_um=wire_length)
    checks['identical_sdc'] = (GLOBAL/'baseline/timing.sdc').read_bytes()==(GLOBAL/'optimized/timing.sdc').read_bytes()
    for study in ('expanded_feedback_80_20261107','crc_feedback_20_20261107_ready'):
        deps = load(ROOT/'eda/experiments'/study/'protocol.json')['dependencies']
        checks[study+':frozen_code_unchanged'] = all(sha(ROOT/path)==digest for path,digest in deps.items())
    b,c = cases['baseline'],cases['optimized']
    checks['strict_timing_improvement'] = c['wns_ns']>b['wns_ns'] and c['tns_ns']>=b['tns_ns']
    checks['area_cap'] = c['exact_cell_area_um2']<=1.1*b['exact_cell_area_um2']
    save(OUT/'ANNOTATION_COVERAGE.json',coverage)
    audit = dict(passed=all(checks.values()),check_count=len(checks),checks=checks)
    save(OUT/'AUDIT.json',audit)
    if not audit['passed']:
        raise RuntimeError('Failed audit: '+str([k for k,v in checks.items() if not v]))
    summary = dict(status='PASS_WITH_EXPLICIT_SCOPE',cases=cases,
         wns_gain_ns=round(c['wns_ns']-b['wns_ns'],2),
         cell_area_reduction_percent=round(100*(1-c['exact_cell_area_um2']/b['exact_cell_area_um2']),2),
         scope='Fixed-geometry detailed signal routing, extracted SPEF, ideal clocks. No CTS, PDN, physical-init or signoff claim.',
         validated_loaded_parasitic_coverage=True,full_physical_signoff=False,new_model_calls=0)
    save(OUT/'SUMMARY.json',summary)
    report = f'''# FCS详细信号布线与实际寄生结果

固定8位以太网FCS的历史CRC优化收益在详细信号布线、OpenRCX提取真实布线RC后仍保留。本轮新增模型请求0次，固定一个几何和一个布线种子；时钟仍理想，没有CTS和供电网络，不是完整物理签核。

| 同一库、10ns时钟、同一核心区域 | 原始版 | 优化版 |
|---|---:|---:|
| 前布局WNS / ns | 7.68 | 8.55 |
| 全局布线估算RC后WNS / ns | {b['global_route_estimated']['wns_ns']:.2f} | {c['global_route_estimated']['wns_ns']:.2f} |
| 详细信号布线提取SPEF后WNS / ns | {b['wns_ns']:.2f} | {c['wns_ns']:.2f} |
| 提取后TNS / ns | {b['tns_ns']:.2f} | {c['tns_ns']:.2f} |
| 单元面积（含新增常量单元）/ µm² | {b['exact_cell_area_um2']:.4f} | {c['exact_cell_area_um2']:.4f} |
| 单元数（含常量单元）| {b['cell_count']} | {c['cell_count']} |
| 路由器报告总线长 / µm | {b['wire_length_um']} | {c['wire_length_um']} |

提取后WNS增加{summary['wns_gain_ns']:.2f}ns，单元面积降低{summary['cell_area_reduction_percent']:.2f}%。两版芯片/核心几何完全相同，不能把单元面积降低宣称为芯片面积已经缩小。没有频率或功耗实测。

## 可核查证据

- OpenROAD固定版本26Q2-1164-g08f67ee5ec；官方预编译包尺寸/MD5核对通过，记录SHA256，项目内隔离解包并补齐运行库，未安装或升级系统软件包。平台来自OpenROAD-flow-scripts提交aef47dd6ed123b0ed7cedac372b00456722be327，保留LEF、RC规则和许可证哈希。
- 两版都从已证明的映射网表出发，仅插入常量单元、放置和布线，不做逻辑重写或尺寸修复。完整的类型化单元、端口和引脚连接图从原始映射网表到准备网表再到详细布线网表严格一致（常量单元归一为0/1），保留先前功能证明的适用条件。
- 详细布线输出DEF、ODB和Verilog，OpenRCX输出非空含R/C网络的SPEF。两版路由器最后报告0条违规，DRC文件均为空；最大转换时间和最大电容检查通过。
- 原有独立OpenSTA从详细布线Verilog和SPEF重新建立分析，两版WNS/TNS均与OpenROAD内置STA相同。寄生覆盖报告各有3个未注释驱动：未使用tkeep、tuser输入和常量单元未使用LO输出；从实际路由网表确认每个均无任何单元输入或顶层输出负载，且无部分未注释驱动。未忽略带负载的数据路径。
- Liberty面积求和与LEF物理尺寸求和一致。全部{len(checks)}项审计通过，旧80次及CRC20次冻结代码依赖未改变。

## 固定实现条件与限制

两版die均130×130µm，要求core为(10,10)-(120,120)，工具按site对齐后均为(10.12,10.88)-(119.60,119.68)，核心面积11911.424µm²。相同放置密度目标0.60、2线程、met1-met5信号布线、met3-met5时钟布线规则、容量折减0.2及详细布线种子42。单元面积不同导致实际利用率不同，未为优化版另缩小核心。

时钟仍使用理想延迟，无CTS、时钟偏斜和真实时钟树负载分析；没有PDN、IR压降、天线签核、填充或GDS交付。详细路由器明确警告不支持部分LEF58_ENCLOSURE规则，因此“0路由器违规”仅指该工具支持的检查范围，绝非完整工艺DRC/LVS通过。RC规则是公开平台共享规则，并非制造商签核提取认证。

功能依然保留上轮原始RTL声明初值的逻辑契约；不能据此保证标准单元任意物理上电状态。一次固定布局实验不证明跨布局种子、跨工艺角或更大系统泛化。不同RC估计与提取结果不要求单调，已分阶段列出，没有混用基线。

## 保留的失败与修复

初始全局布线结果的JSON解析未识别`worst slack max`格式，故数值为null；此处独立按原始日志解析，并与详细布线阶段分开。初始`write_spef`提示无OpenRCX数据，该阶段只有估计RC，未声称提取成功。旧目录完整保留。

首轮详细布线因新版弃用-bottom_routing_layer参数而停止；第二轮因导入器产生的空GROUND占位网zero_而停止。最后一轮统一采用set_routing_layers，并只删除无任何单元/端口连接的供电占位网；遇到有连接的供电网会拒绝继续，未将供电网冒充信号网。每轮日志和驱动快照均保留。

初次审计误报也保留在AUDIT_FIRST.json：它把Yosys导出前私有单元名直接与导出后公开名比较，并把未连接LO引脚缺少局部方向字段当成失败。复核改为重新读取哈希一致的原始已证明Verilog，用实际导出单元名比较全图；缺省引脚方向从同份Liberty模型读取，并验证确实无连接/负载。未修改被测硬件、寄生或时序数据，没有重跑布线来筛选结果。

## 下一步

在独立协议中加入CTS及供电/合法物理单元，保持相同几何重新比较真实时钟影响；同时明确产品复位契约。当前结果已回答“已有CRC优化能否在真实上层和数据连线寄生下保留收益”，没有新增模型样本或追加历史成功率分母。
'''
    (OUT/'INTERPRETATION.md').write_text(report,encoding='utf-8')
    save(OUT/'IMPLEMENTATION_SHA256.json',{str(p.relative_to(ROOT)):sha(p) for p in (
        Path(__file__),Path(__file__).with_name('run_fcs_physical.py'),Path(__file__).with_name('route_fcs_detailed.py'),
        Path(__file__).with_name('check_fcs_extracted_sta.py'),TOOLS/'SOURCE_LOCK.json',TOOLS/'RUNTIME.json')})
    save(OUT/'ARTIFACTS.json',{str(p.relative_to(OUT)):sha(p) for p in OUT.rglob('*') if p.is_file() and p.name!='ARTIFACTS.json'})
    print(json.dumps(dict(passed=True,checks=len(checks),wns_gain_ns=summary['wns_gain_ns'],cell_area_reduction_percent=summary['cell_area_reduction_percent'],new_model_calls=0)))


if __name__ == '__main__':
    main()
