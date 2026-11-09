"""Audit and publish the local, logically initialized FCS integration evidence."""
import json
from pathlib import Path
import re
import shutil

from integrate_crc_fcs import OUT, ROOT, SOURCE, RUNNER, sha, save


def load(p):
    return json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    checks = {}
    protocol = load(OUT/'protocol.json')
    checks['protocol_checksum'] = sha(OUT/'protocol.json') == (OUT/'protocol.sha256').read_text().strip()
    checks['runner_unchanged'] = sha(RUNNER) == protocol['runner_sha256']
    checks['driver_unchanged'] = sha(Path(__file__).with_name('integrate_crc_fcs.py')) == protocol['driver_sha256']
    for item in protocol['upstream']['files']:
        checks['upstream:'+item['path']] = sha(Path(item['path'])) == item['sha256']
    for name, digest in protocol['sources'].items():
        checks['raw_source:'+name] = sha(OUT/name/'source.v') == digest
    result = load(OUT/'RESULT.json')
    checks['qualified'] = result['qualified'] is True
    checks['timing_improvement'] = result['valid_timing_improvement'] is True
    checks['negative_source_counterexample'] = result['negative_control_passed'] is True
    checks['actual_counterexample_log'] = 'model found for base case: FAIL!' in (OUT/'negative_output/evaluation/formal.log').read_text()
    repro = load(OUT/'independent_verification/RESULT.json')
    checks['independent_reruns'] = repro['passed'] is True
    checks['raw_2048_cycle_oracle_simulation'] = repro['raw_simulation_passed'] and repro['cycles'] == 2048
    checks['standard_crc32_vector'] = repro['standard_check_value'] == 'cbf43926'
    for name in ('baseline','optimized'):
        folder = OUT/name/'evaluation'
        schema = load(folder/'candidate_schema.json')['modules']['axis_eth_fcs']['ports']
        checks[name+':all_outputs'] = {n:len(v['bits']) for n,v in schema.items() if v['direction']=='output'} == dict(s_axis_tready=1,output_fcs=32,output_fcs_valid=1)
        for stage in ('formal','mapped_formal'):
            checks[name+':'+stage+':induction'] = 'Induction step proven: SUCCESS!' in (folder/(stage+'.log')).read_text()
            checks[name+':'+stage+':no_assumed_states'] = load(folder/(stage+'_state_invariants.json'))['assumed_state_equalities'] == 0
        checks[name+':mapped_checksum'] = sha(folder/'mapped.v') == result['results'][name]['mapped_sha256']
        checks[name+':sdc_checksum'] = sha(folder/'timing.sdc') == result['results'][name]['sdc_sha256']
    checks['identical_sdc'] = (OUT/'baseline/evaluation/timing.sdc').read_bytes() == (OUT/'optimized/evaluation/timing.sdc').read_bytes()
    for study in ('expanded_feedback_80_20261107','crc_feedback_20_20261107_ready'):
        deps = load(ROOT/'eda/experiments'/study/'protocol.json')['dependencies']
        for path,digest in deps.items():
            checks[study+':'+path] = sha(ROOT/path) == digest
    checks['new_model_calls_zero'] = protocol['model_calls'] == result['model_calls'] == repro['model_calls'] == 0
    audit = dict(passed=all(checks.values()),check_count=len(checks),checks=checks)
    save(OUT/'AUDIT.json',audit)
    if not audit['passed']:
        raise RuntimeError('Failed audit: '+str([k for k,v in checks.items() if not v]))
    exports = OUT/'exports'
    exports.mkdir(exist_ok=False)
    for name,target in [('baseline','baseline.v'),('optimized','best.v')]:
        # Exact fixed-parameter elaborated RTL that was proved and measured.
        shutil.copyfile(OUT/name/'elaborated.v',exports/target)
    shutil.copyfile(SOURCE/'COPYING',exports/'COPYING')
    save(exports/'CONTRACT.json',dict(top='axis_eth_fcs',parameter_overrides={},
         specialization=protocol['parameters'],scope=protocol['scope'],state_policy=protocol['state_policy'],
         baseline_sha256=sha(exports/'baseline.v'),best_sha256=sha(exports/'best.v'),
         power_up_initialization_guaranteed=False,physical_parasitics=False,model_calls=0))
    baseline, opt = [result['results'][n] for n in ('baseline','optimized')]
    arrival = {}
    for name in ('baseline','optimized'):
        log = (OUT/name/'evaluation/sta.log').read_text()
        arrival[name] = float(re.search(r'\n\s*([\d.]+)\s+data arrival time',log)[1])
    report = f'''# 真实以太网FCS上层集成结果

本轮把历史模型生成的CRC32字节更新候选接入公开 `axis_eth_fcs` 上层模块。新增模型调用 **0次**，不是新增独立模型样本。源级、门级逐拍等价和STA/电气通过；两版完整独立复跑与原始RTL仿真复核通过。

| 同一10ns时钟与库、同一映射流程 | 原始FCS | 优化FCS |
|---|---:|---:|
| WNS / ns（越大越好） | {baseline['wns_ns']:.2f} | {opt['wns_ns']:.2f} |
| TNS / ns | {baseline['tns_ns']:.2f} | {opt['tns_ns']:.2f} |
| 第一条最差slack路径的数据到达时间 / ns | {arrival['baseline']:.2f} | {arrival['optimized']:.2f} |
| 映射面积 / µm² | {baseline['mapped_area_um2']:.4f} | {opt['mapped_area_um2']:.4f} |
| 映射单元数 | {baseline['mapped_cells']} | {opt['mapped_cells']} |

WNS改善 {opt['wns_ns']-baseline['wns_ns']:.2f} ns，面积降低 {100*(1-opt['mapped_area_um2']/baseline['mapped_area_um2']):.2f}%。单元数略增，不等于面积增加。数据到达时间包含时钟到Q，不把 `10-WNS` 冒充组合延迟或频率实测。

## 集成范围

公开仓库为 https://github.com/alexforencich/verilog-ethernet ，固定提交 `{protocol['upstream']['commit']}`。顶层141行，加原始LFSR依赖后的输入589行；替换后组合输入261行（含同样上层控制与128行历史候选）。行数含注释、声明与空行，不能当硬件复杂度指标。

固定 DATA_WIDTH=8、KEEP_ENABLE=0、KEEP_WIDTH=1，只替换CRC运算，保留CRC状态、帧尾处理、输出时序和全部引脚。原上层STYLE=AUTO，与历史孤立核REDUCTION配置不同，故建立本轮新基线，不能直接使用历史0.98ns作分母。独立输入保持任意定义值，包含复位重入、停顿、任意tlast/tkeep/tuser；不施加合法报文假设。

## 完成的验证

- 源级和实际标准单元门级均完成SAT基础情形及时间归纳；比较全部34位输出，校验值无效期间也不屏蔽。共同状态关系是额外待证明目标，未假设状态相等。
- 电气检查覆盖库中最大转换时间与最大电容；两版TNS均为0，满足预先固定110%面积上限和WNS严格改善要求。
- 原始RTL由Icarus直接编译，2048拍同时比较原始版、优化版及独立逐位CRC模型，包含标准 `123456789` → `CBF43926`，停顿、随机帧尾和重复复位。
- 两版完整EDA独立重跑，证明、WNS、TNS、面积、单元数、映射网表哈希及SDC哈希均一致。故意翻转output_fcs位0的负例被真实源级SAT反例拒绝。
- 本轮审计{len(checks)}项通过；旧80次与CRC20次协议中的冻结代码依赖保持不变。

## 必须保留的条件

原始 `fcs_reg` 声明为0初值，但没有复位赋值；本轮保留原始RTL逻辑初值完成全输出证明，**不证明标准单元物理上电值**。这不是不依赖初值的复位后验证，也不能宣称已完成物理实现签核。若产品要求任意上电态和复位立即确定所有输出，需另立明确接口契约和复位设计。

采用SKY130HD TT、理想时钟和前布局单元延迟，无布线寄生、功耗测量或流片结果；仅一个8位上层实例，不是完整MAC或跨设计泛化。没有新模型样本，不能扩充历史20次成功率分母，也不能据此主张STA提示普遍优于无STA。

首次尝试保留在 `../ethernet_fcs_integration_20261107/`：源级通过，门级证明在恢复逻辑初值时因内部信号名含方括号被后端拒绝，属于INCOMPLETE。新轮对两版统一执行 `rename -unescape`，仅规范内部名称；未修改冻结验证后端、未删除初值或输出，未放宽失败门槛。

## 可使用的产物与下一步

`exports/best.v` 是已验证固定参数展开RTL，顶层 `axis_eth_fcs`；`exports/baseline.v` 为同范围原始版，配套许可证和CONTRACT.json。原始输入及全部工具日志仍保留。不要对导出文件套用其他宽度参数。

下一步应在独立实验中加入布局布线与寄生提取，比较这对已验证FCS实现的物理时序/面积；同时明确产品是否要求不依赖RTL初值的复位契约。当前先得到一个真实工程子模块中的可复现正例，不继续堆叠同类模型调用。
'''
    (OUT/'INTERPRETATION.md').write_text(report,encoding='utf-8')
    print(json.dumps(dict(passed=True,checks=len(checks),wns_gain_ns=round(opt['wns_ns']-baseline['wns_ns'],2),area_reduction_percent=round(100*(1-opt['mapped_area_um2']/baseline['mapped_area_um2']),2),model_calls=0)))


if __name__ == '__main__':
    main()
