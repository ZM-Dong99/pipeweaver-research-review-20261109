"""Audit source-backed ordinary-bulk qualification without revising old failures."""
import json
from pathlib import Path

from qualify_fcs_bulk_profile import ROOT, OUT, SOURCE, BASE, PLATFORM, sha, save


def load(p):
    return json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    protocol=load(OUT/'protocol.json')
    result=load(OUT/'RESULT.json')
    original=(PLATFORM/'lvs/sky130hd.lylvs').read_text()
    profile=(OUT/'ordinary_bulk.lylvs').read_text()
    old=protocol['normalized_diff']['after']
    addition=protocol['normalized_diff']['inserted_one_line']
    checks=dict(protocol_checksum=sha(OUT/'protocol.json')==(OUT/'protocol.sha256').read_text().strip(),
        driver_unchanged=sha(Path(__file__).with_name('qualify_fcs_bulk_profile.py'))==protocol['driver_sha256'],
        original_deck_unchanged=sha(PLATFORM/'lvs/sky130hd.lylvs')==protocol['original_deck_sha256'],
        declared_profile_checksum=sha(OUT/'ordinary_bulk.lylvs')==protocol['profile_sha256'],
        exact_one_line_profile_change=profile.replace(old+'\n'+addition,old)==original and profile.count(addition)==1,
        five_cases_completed=len(result['cases'])==5 and result['all_as_expected'],
        no_model_calls=result['new_model_calls']==protocol['new_model_calls']==0,
        original_failure_not_overwritten=result['unmodified_orfs_deck_pass'] is False,
        no_foundry_signoff_claim=result['full_foundry_signoff'] is False)
    for entry in protocol['independent_sources']:
        checks['source:'+entry['file']]=sha(BASE/'sources'/entry['file'])==entry['sha256']
    efa=(BASE/'sources/efabless_sky130.lvs').read_text()
    magic=(BASE/'sources/open_pdks_sky130_extract.tech').read_text()
    checks['efabless_substrate_and_ptap_same_global']=all(line in efa for line in ('connect_global(sub  , substrate_name)','connect_global(ptap_conn  , substrate_name)'))
    checks['open_pdks_ptap_substrate_with_isolation_exclusions']='substrate *ppdiff,*mvppdiff,space/w,pwell well $SUB -dnwell,isosub' in magic
    for case in ('baseline','optimized'):
        r=result['cases'][case]
        checks[case+':original_gds_unchanged']=sha(SOURCE/case/'design.gds')==r['gds_sha256']
        checks[case+':reference_unchanged']=sha(SOURCE/case/'reference_complete.cdl')==r['reference_sha256']
        checks[case+':full_lvs_success']=r['status']=='PASS' and r['tool_exit_code']==0 and 'INFO : Congratulations! Netlists match.' in (OUT/case/'lvs.log').read_text()
        guards=load(OUT/case/'PREFLIGHT.json')
        checks[case+':all_isolation_guards_clear']=guards['supported'] and all(value==0 for value in guards['unsupported_polygon_counts'].values())
        checks[case+':native_report_exists']=(OUT/case/'lvs.lvsdb').stat().st_size>0
        checks[case+':old_default_failure_retained']=load(SOURCE/case/'RESULT.json')['lvs']['status']=='FAIL'
    for case in ('no_taps','wrong_gate'):
        r=result['cases'][case]
        checks[case+':actual_negative_failure']=r['status']=='FAIL' and r['lvs_run'] and "ERROR : Netlists don't match" in (OUT/case/'lvs.log').read_text()
    r=result['cases']['substrate_cut']
    checks['substrate_cut_rejected_before_lvs']=r['status']=='REJECT_UNSUPPORTED' and not r['lvs_run'] and not r['supported']
    checks['substrate_cut_marker_detected']=load(OUT/'substrate_cut/PREFLIGHT.json')['unsupported_polygon_counts']['substrate_cut']>0
    for prior in ('fcs_filled_independent_layout_20261108','fcs_filled_layout_20261108','fcs_reset_complete_20261107_induction_fixed'):
        folder=ROOT/'eda/experiments'/prior
        checks[prior+':all_frozen_artifacts_unchanged']=all(sha(folder/name)==digest for name,digest in load(folder/'ARTIFACTS.json').items())
    for prior in ('expanded_feedback_80_20261107','crc_feedback_20_20261107_ready'):
        checks[prior+':frozen_code_unchanged']=all(sha(ROOT/name)==digest for name,digest in load(ROOT/'eda/experiments'/prior/'protocol.json')['dependencies'].items())
    audit=dict(passed=all(checks.values()),check_count=len(checks),checks=checks,
        scope='Qualification of the named fixed ordinary-bulk extraction profile, not unmodified ORFS default or foundry signoff')
    save(OUT/'AUDIT.json',audit)
    if not audit['passed']:
        raise RuntimeError('Audit failures: '+str([k for k,v in checks.items() if not v]))
    summary=dict(status='QUALIFIED_ORDINARY_BULK_LVS_PROFILE',baseline_lvs='PASS',optimized_lvs='PASS',
        original_gds_and_reference_unchanged=True,auxiliary_substrate_overlay_required=False,
        independent_source_basis=True,real_negative_controls_rejected=True,isolation_guard_test_passed=True,
        unmodified_orfs_default_lvs_passed=False,full_foundry_signoff=False,new_model_calls=0)
    save(OUT/'SUMMARY.json',summary)
    sources={r['repo']:r for r in protocol['independent_sources']}
    ef=sources['efabless/sky130_klayout_pdk']
    mg=sources['RTimothyEdwards/open_pdks']
    report=f'''# 有独立依据的普通体硅LVS配置

两版复位完整FCS的**原始已填充GDS**及原始完整晶体管参考，在明确、受约束的普通体硅提取配置下均通过LVS；无需修改GDS或补充236/0辅助面。这闭合了当前固定实例的工程提取配置问题，不是制造商完整签核。新增模型调用0次。

## 独立依据

[Efabless SKY130 KLayout源码]({ef['url']})，固定提交{ef['commit']}，将sub与真实ptap_conn声明为同一全局衬底名称，并保留PTAP到licon再到金属的接触连接。这是本轮新配置的直接独立代码依据。本轮没有运行该完整Efabless规则，不能把本轮标成Efabless全流程签核。

[OpenPDKs SKY130 Magic提取源码]({mg['url']})，固定提交{mg['commit']}，将p+扩散、普通pwell等列入衬底，并明确排除dnwell与isosub。这从另一工具实现支持了普通体硅与隔离结构应区分处理。本轮没有执行Magic提取，不声称Magic LVS通过。

[SkyWater工艺规则](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#dnwell)给出深N阱隔离pwell的用途；[工艺图层说明](https://skywater-pdk.readthedocs.io/en/main/rules/layers.html)将81/53标记为需单独考虑的SubstrateCut区域。这些资料支持限制适用范围，不能单凭文字资料代替实际提取。

[KLayout-PEX项目说明](https://iic-jku.github.io/klayout-pex-website/doc/doc.html#test-pattern-plate-20um-x-20um-li1-over-ptap)还解释了提取工具中p-tap与衬底可能采用不同网络表示。因此先前VNB/VSS不匹配需要明确提取约定，而不是直接归为RTL错误或忽略该网络。

## 本轮实际修改与运行

原ORFS规则、GDS和参考均未改。本轮另建ordinary_bulk.lylvs提取配置，完整比较原规则文本后确认仅增加一条PTAP到VNB的全局衬底声明，保留其已有SUB到VNB声明。这是移用上述Efabless的普通共享衬底约定，不是直接把VNB指定为VSS。实际tap及金属接触仍决定它是否接地。

运行入口先对真实GDS检查八类不支持的标记：深N阱、衬底隔离切分、高压/超高压、pwell block及双极器件标记。两版均无这些标记，只在本轮固定低压数字FCS实例上资格成立；配置文件不可脱离前置检查当通用PDK规则使用。

| 实际测试 | 结果 |
|---|---|
| 原始版原GDS + 原参考 | PASS |
| 优化版原GDS + 原参考 | PASS |
| 删除实际tap有源几何 | LVS FAIL，符合预期 |
| 从参考删除一个逻辑门 | LVS FAIL，符合预期 |
| 加入SubstrateCut标记 | 前置拒绝，未运行LVS |

完整器件、网络与引脚比较保留，未放宽器件参数容差、未黑盒替代、未跳过单元或网络。正例GDS和晶体管参考SHA与前轮逐字节相同。两项LVS负例均有原生报告及明确未匹配日志；隔离负例用于验证入口拒绝能力，不冒充完整隔离设计LVS测试。

## 结论边界与交付

本轮{len(checks)}项资格审计通过。旧ORFS默认配置直接运行仍为FAIL，旧诊断及失败记录原样冻结；新状态为“原始GDS在有独立源码依据的普通体硅配置下LVS通过”。不再需要靠修改辅助GDS几何来获得当前实例的匹配结果。

前轮公开DRC仍两版145类0违规；填充后新提取WNS7.13→8.02ns，保持均0.49ns。非filler单元面积下降15.71%，含filler总占用面积两版相同。这些旧测量未重算或改写。本轮只闭合提取配置与源代码依据，没有新增模型样本。

仍缺少制造商认证、完整工艺DRC/LVS、天线与IR/电迁移等检查，不给出流片保证。可以将当前固定普通体硅FCS作为工程研究正例，下一步收敛可复现验证链，并回到未参与开发的电路上做系统对照；无需把每项流片签核都当作LLM方法研究的前置结论。
'''
    (OUT/'INTERPRETATION.md').write_text(report,encoding='utf-8')
    save(OUT/'IMPLEMENTATION_SHA256.json',{str(p.relative_to(ROOT)):sha(p) for p in (
        Path(__file__),Path(__file__).with_name('qualify_fcs_bulk_profile.py'),
        Path(__file__).with_name('fcs_bulk_profile_preflight.py'),Path(__file__).with_name('fcs_bulk_profile_negative.py'))})
    for folder in (BASE,OUT):
        save(folder/'ARTIFACTS.json',{str(p.relative_to(folder)):sha(p) for p in folder.rglob('*') if p.is_file() and p.name!='ARTIFACTS.json'})
    print(json.dumps(dict(passed=True,checks=len(checks),baseline_lvs='PASS',optimized_lvs='PASS',original_gds_unchanged=True,new_model_calls=0)))


if __name__=='__main__':
    main()
