"""Export the authorized width sweep and its reproduction implementation."""
import json
import os
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from agents.portfolio_loop import load, save, sha

STUDY = ROOT / 'eda/experiments/systematic_parameter_20261117'
DESTINATION = ROOT / 'output/teacher_review_20261109'
OMIT_DIRECTORIES = {'.git', '__pycache__', 'yosys_tmp', 'tmp', '_tmp', 'slang_tmp'}
OMIT_NAMES = {'mapped.json', 'before_opt.json', 'after_opt.json'}
OMIT_SUFFIXES = {'.lib', '.lef', '.gds', '.gdsii', '.odb', '.db', '.spef', '.exe', '.dll',
                 '.pyc', '.aig', '.aag', '.blif', '.il'}


def main():
    if not (STUDY / 'COMPLETION.json').is_file():
        raise RuntimeError('Collection still running')
    analysis = load(STUDY / 'ANALYSIS.json')
    if analysis['attempted'] != load(STUDY / 'COMPLETION.json')['reserved_requests']:
        raise RuntimeError('Analysis and request count disagree')
    files = set(STUDY.rglob('*'))
    protocol = load(STUDY / 'protocol.json')
    files.update(ROOT / name.replace('\\', '/') for name in protocol['source_dependencies'])
    files.update(ROOT / name for name in load(STUDY / 'EXECUTION_PLAN.json')['runtime_dependencies'])
    files.update(ROOT / name for name in [
        'eda/experiments/collect_parameter_study.py', 'eda/experiments/analyze_parameter_study.py',
        'tools/reproduce_research.py', 'tools/export_parameter_review.py',
        'tests/test_parameter_study.py', 'docs/PARAMETER_REPRODUCE_20261117.md'])
    validation = ROOT / 'output/parameter_review_validation_20261117'
    files.update(validation.rglob('*'))
    secrets = [os.environ[name].encode('utf-8') for name in
               ('OPENAI_API_KEY', 'DEEPSEEK_API_KEY', 'ANTHROPIC_API_KEY', 'GH_TOKEN', 'GITHUB_TOKEN')
               if len(os.environ.get(name, '')) >= 8]
    copied = []
    for source in sorted(files):
        if not source.is_file():
            continue
        relative = source.relative_to(ROOT)
        if (source.is_symlink() or any(part in OMIT_DIRECTORIES for part in relative.parts)
                or source.suffix in OMIT_SUFFIXES or source.name in OMIT_NAMES):
            continue
        if source.stat().st_size > 8 * 1024 * 1024:
            raise RuntimeError('Large research asset needs explicit selection ' + relative.as_posix())
        data = source.read_bytes()
        if any(secret in data for secret in secrets):
            raise RuntimeError('Configured credential found in ' + relative.as_posix())
        target = DESTINATION / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)
        copied.append(relative.as_posix())
    study_relative = STUDY.relative_to(ROOT).as_posix()
    report = (STUDY / 'REPORT.md').read_text(encoding='utf-8')
    (DESTINATION / 'PARAMETER_REPORT.md').write_text(
        report.replace('](calls/', f']({study_relative}/calls/'), encoding='utf-8')
    shutil.copyfile(STUDY / 'ANALYSIS.json', DESTINATION / 'PARAMETER_ANALYSIS.json')
    shutil.copyfile(ROOT / 'docs/PARAMETER_REPRODUCE_20261117.md', DESTINATION / 'PARAMETER_REPRODUCE.md')
    save(DESTINATION / 'PARAMETER_EXPORT.json', dict(files=copied, exact_configured_credential_scan='PASS',
        scope='Public parameter RTL and approved model/verification evidence; external assets and temporary intermediates excluded'))
    print(json.dumps(dict(copied=len(copied), credential_scan='PASS')))


if __name__ == '__main__':
    main()
