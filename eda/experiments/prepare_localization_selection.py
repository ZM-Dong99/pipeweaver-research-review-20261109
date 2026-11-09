"""Freeze a bounded localization selection design from existing evidence; no API or EDA."""
from collections import Counter
import argparse
from datetime import datetime
import hashlib
import json
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[2]
PARENT = ROOT / 'eda/experiments/mixed_block_mapping_20261105_142005_822258'
ARMS = ('no_sta', 'sta')
PROFILES = ('mux_delay050', 'mux_delay090')
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
load = lambda p: json.loads(p.read_text(encoding='utf-8-sig'))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--out', required=True, type=Path)
    args = ap.parse_args()
    out = args.out.resolve()
    out.mkdir(parents=True, exist_ok=False)
    p = load(PARENT / 'protocol.json')
    assert sha(PARENT / 'protocol.json') == (PARENT / 'protocol.sha256').read_text().split()[0]
    assert load(PARENT / 'AUDIT.json')['passed']
    for name, expected in p['design_sha256'].items():
        assert sha(PARENT / 'designs' / (name + '.v')) == expected
    for name, expected in p['sdc_sha256'].items():
        assert sha(PARENT / 'profiles' / (name + '.sdc')) == expected
    for name in ('inputs', 'prompts', 'analysis_only', 'code_snapshot'):
        (out / name).mkdir()
    shutil.copyfile(Path(__file__), out / 'code_snapshot' / Path(__file__).name)
    for action in ('baseline', 'rewrite_mux', 'rewrite_priority'):
        shutil.copyfile(PARENT / 'designs' / (action + '.v'), out / 'inputs' / (action + '.v'))
    # Full candidate implementations are visible identically in both arms, but their PPA is not.
    source_text = '\n\n'.join('Implementation ' + a + ':\n' + (out / 'inputs' / (a + '.v')).read_text(encoding='utf-8')
                                 for a in ('baseline', 'rewrite_mux', 'rewrite_priority'))
    checks = []
    for profile in PROFILES:
        sdc = PARENT / 'profiles' / (profile + '.sdc')
        shutil.copyfile(sdc, out / 'inputs' / sdc.name)
        sta = PARENT / 'sta' / profile / 'baseline' / 'sta.log'
        shutil.copyfile(sta, out / 'inputs' / (profile + '_baseline_sta.log'))
        common = f'''Select exactly one registered rewrite for mixed_datapath. Do not generate new RTL.
Return exactly one JSON object with action_id (rewrite_mux or rewrite_priority) and rationale (string).
Objective: minimum whole-design maximum data arrival after one regional action; mapped area must be <=2719.608320um^2 (110% of original2472.3712um^2). No change in outputs, state, latency or assumptions. All148 input bits and all79 output bits must preserve the original two-state behavior, including mux default sel10..15 and encoder invalid-input outputs.
Actions are defined by the complete implementations below. Both arms receive the same action implementations and full constraints. No candidate PPA or winning-action labels are supplied.
Mapping condition: independently mapped fixed leaf blocks, composed without whole-design ABC remapping. Only the changed block is replaced; the other block's mapped netlist is identical. This is a controlled block-mapping experiment, not unrestricted flat synthesis. SKY130HD TT25C1.80V, no physical parasitics. Input transition0.10ns, output load0.010pF. The SDC below is authoritative, including external input delays. The virtual100ns clock is only a reporting reference.
Choosing an over-area or non-improving action retains the original. No retries or repairing selections.

Full SDC:
{sdc.read_text(encoding='utf-8')}

{source_text}
'''
        chunks = sta.read_text(encoding='utf-8').split('Startpoint:')[1:]
        assert chunks
        report = ''.join('Startpoint:' + c for c in chunks[:3]).split('worst slack max')[0].split('PW_ELECTRICAL_BEGIN')[0]
        suffix = '\nActual baseline OpenSTA paths, in report order:\n' + report
        for arm, prompt in (('no_sta', common), ('sta', common + suffix)):
            (out / 'prompts' / (profile + '_' + arm + '.txt')).write_text(prompt, encoding='utf-8')
        checks.append(dict(profile=profile, common_prompt_is_exact_prefix=(common + suffix).startswith(common),
                           actual_baseline_paths=min(3, len(chunks)), source_sha256=p['design_sha256']))
    schedule = []
    for slot in range(3):
        for i, profile in enumerate(PROFILES):
            for arm in (ARMS if (slot + i) % 2 == 0 else ARMS[::-1]):
                schedule.append(dict(call_index=len(schedule)+1, profile=profile, arm=arm, trial=slot+1,
                                     prompt='prompts/' + profile + '_' + arm + '.txt'))
    # Preserve known outcomes separately for later scoring, never as model-visible input.
    shutil.copyfile(PARENT / 'SUMMARY.json', out / 'analysis_only' / 'prior_mapping_and_sta.json')
    shutil.copyfile(PARENT / 'POLICY_DECISIONS.json', out / 'analysis_only' / 'deterministic_controls.json')
    manifest = {str(f.relative_to(out)): sha(f) for f in out.rglob('*') if f.is_file()}
    plan = dict(status='DESIGN_FROZEN_NO_REQUESTS', date='2026-11-06', prepared_at=datetime.now().astimezone().isoformat(),
        parent=str(PARENT.relative_to(ROOT)), parent_protocol_sha256=sha(PARENT / 'protocol.json'),
        task='Choose one region action; all action PPA is already known from local development and not supplied to prompts',
        proposed_max_requests=12, model_requests_made=0, authorization='No fresh request budget consumed or inferred from exhausted historical batches',
        model='gpt-6.1-sol requested alias, proposed continuation of prior route; actual endpoint/request parameters must be frozen before execution',
        schedule=schedule, frozen_files=manifest,
        primary='All attempted slots retain baseline on failure, over-area or no strict gain. Report retained-delay median for each profile/arm and paired profile-normalized gain. Do not replace medians with best candidates after observing outcomes.',
        secondary='Chosen-action optimality and regret against existing two-action enumeration, plus success-conditioned statistics separately',
        controls=['fixed_mux', 'fixed_priority', 'largest_input_delay', 'baseline_sta_endpoint'],
        phase_order='Freeze all actual model selections before scoring them against the pre-existing measured pool; model returns no arbitrary executable code',
        stopping='No retries, replacement requests or prompt changes after generation begins. Report null/negative outcome rather than adding slots until winning.',
        limitations='Two correlated configurations selected after observing existing local PPA; components and actions already exposed. Mechanism development only, not blind testing, independent families or statistical generality. Flat mapping previously did not show action-location switching.',
        execution_readiness='Prompts/schedule/scoring design prepared. New-task request/response parser, interrupted-attempt guard and executor still require offline validation before any request.')
    (out / 'protocol.json').write_text(json.dumps(plan, indent=2, ensure_ascii=False), encoding='utf-8')
    (out / 'protocol.sha256').write_text(sha(out / 'protocol.json') + '\n', encoding='ascii')
    counts = Counter((r['profile'], r['arm']) for r in schedule)
    assert len(schedule) == 12 and set(counts.values()) == {3}
    assert all(sha(out / rel) == h for rel, h in manifest.items())
    for profile in PROFILES:
        a, b = ((out / 'prompts' / (profile + '_' + arm + '.txt')).read_text(encoding='utf-8') for arm in ARMS)
        assert b.startswith(a) and len(b) > len(a)
    (out / 'PREPARATION_CHECKS.json').write_text(json.dumps(dict(passed=True, profiles=checks, schedule_slots=12,
        frozen_file_count=len(manifest), model_requests=0, note='Preparation checks, not new EDA or API execution validation'), indent=2), encoding='utf-8')
    print(json.dumps(dict(prepared=str(out), files=len(manifest), requests=0, proposed_slots=12)), flush=True)


if __name__ == '__main__':
    main()
