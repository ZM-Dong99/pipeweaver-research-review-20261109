"""Add the explicitly scoped 2026-11-16 research evidence to the review clone."""
import json
import os
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from agents.portfolio_loop import load, save, sha

STUDY = ROOT / 'eda/experiments/systematic_engineering_20261116_v3'
DESTINATION = ROOT / 'output/teacher_review_20261109'
OMIT_DIRECTORIES = {'.git', '__pycache__', 'yosys_tmp', 'tmp', '_tmp', 'slang_tmp'}
OMIT_SUFFIXES = {'.lib', '.lef', '.gds', '.gdsii', '.odb', '.db', '.spef', '.exe', '.dll',
                 '.pyc', '.aig', '.aag', '.blif', '.il'}
OMIT_NAMES = {'mapped.json', 'before_opt.json', 'after_opt.json'}


def main():
    if not (STUDY / 'SUPPLEMENT_COMPLETION.json').is_file():
        raise RuntimeError('Model collection remains incomplete')
    if not load(STUDY / 'audits/definedness/RESULT.json')['passed']:
        raise RuntimeError('Candidate definedness audit must pass')
    protocol = load(STUDY / 'protocol.json')
    files = set(STUDY.rglob('*'))
    files.update((ROOT / 'benchmark/systematic_20261116').rglob('*'))
    for case in protocol['cases']:
        files.update(ROOT / item['path'] for item in case['provenance'])
    files.update(ROOT / name.replace('\\', '/') for name in protocol['source_dependencies'])
    plan = load(STUDY / 'EXECUTION_PLAN.json')
    files.update(ROOT / name for name in plan['runtime_dependencies'])
    files.update(ROOT / name for name in [
        'eda/experiments/collect_systematic_study.py',
        'eda/experiments/supplement_systematic_study.py',
        'eda/experiments/summarize_systematic_study.py',
        'eda/experiments/check_systematic_controls.py',
        'eda/experiments/check_systematic_definedness.py',
        'tools/reproduce_research.py', 'tools/export_systematic_review.py',
        'agents/routing_policy.py',
        'docs/SYSTEMATIC_REPRODUCE_20261116.md',
        'tests/test_systematic_study.py', 'tests/test_adaptive_optimizer.py',
        'tests/test_sse_transport.py'])
    validation = ROOT / 'output/systematic_review_validation_20261116'
    files.update(validation.rglob('*'))
    copied, omitted = [], []
    preserved = []
    configured_secrets = [os.environ[name].encode('utf-8') for name in
                          ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY', 'GITHUB_TOKEN', 'GH_TOKEN')
                          if len(os.environ.get(name, '')) >= 8]
    for source in sorted(files):
        if not source.is_file():
            continue
        relative = source.relative_to(ROOT)
        if (source.is_symlink() or any(part in OMIT_DIRECTORIES for part in relative.parts)
                or source.suffix in OMIT_SUFFIXES or source.name in OMIT_NAMES):
            continue
        if source.stat().st_size > 8 * 1024 * 1024:
            omitted.append(dict(path=relative.as_posix(), bytes=source.stat().st_size, sha256=sha(source)))
            continue
        if any(secret in source.read_bytes() for secret in configured_secrets):
            raise RuntimeError('Configured credential found in ' + relative.as_posix())
        destination = DESTINATION / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        if destination.is_file() and source.suffix == '.py' and sha(source) != sha(destination):
            backup_relative = Path('archive/code_before_20261116') / relative
            backup = DESTINATION / backup_relative
            if not backup.exists():
                backup.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(destination, backup)
            preserved.append(dict(current=relative.as_posix(), historical=backup_relative.as_posix(),
                                  historical_sha256=sha(backup)))
        shutil.copyfile(source, destination)
        copied.append(relative.as_posix())
    save(DESTINATION / 'SYSTEMATIC_EXPORT.json', dict(files=copied, large_omitted=omitted, preserved_code=preserved,
        exact_configured_credential_scan='PASS',
        scope='Only the new research study, its fixed source dependencies, public RTL provenance and local validation evidence; external assets and temporary intermediates excluded'))
    study_relative = STUDY.relative_to(ROOT).as_posix()
    report = (STUDY / 'ENGINEERING_REPORT.md').read_text(encoding='utf-8')
    (DESTINATION / 'SYSTEMATIC_REPORT.md').write_text(
        report.replace('](calls/', f']({study_relative}/calls/'), encoding='utf-8')
    shutil.copyfile(STUDY / 'ENGINEERING_RESULTS.json', DESTINATION / 'SYSTEMATIC_RESULTS.json')
    shutil.copyfile(ROOT / 'docs/SYSTEMATIC_REPRODUCE_20261116.md', DESTINATION / 'SYSTEMATIC_REPRODUCE.md')
    print(json.dumps(dict(copied=len(copied), large_omitted=len(omitted))))


if __name__ == '__main__':
    main()
