"""Inventory model labels from saved request/generation evidence, not inferred call totals."""
from collections import defaultdict
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
EXP = ROOT / 'eda/experiments'


def main():
    models = defaultdict(lambda: dict(request_records=[], generation_records=[], reported_response_models=set(), studies=set()))
    for f in EXP.rglob('*.json'):
        if f.name not in ('request.json', 'generation.json') or any(x in f.relative_to(EXP).parts for x in ('code_snapshot', 'design')):
            continue
        try:
            d = json.loads(f.read_text(encoding='utf-8-sig'))
        except (OSError, ValueError):
            continue
        if not isinstance(d, dict):
            continue
        if f.name == 'request.json':
            body = d.get('body', d.get('payload', {}))
            model = body.get('model') if isinstance(body, dict) else None
            kind = 'request_records'
        else:
            model = d.get('requested_model', d.get('generation_parameters', {}).get('requested_model'))
            kind = 'generation_records'
        if not isinstance(model, str) or not re.fullmatch(r'[A-Za-z0-9_.:/-]+', model):
            continue
        record = models[model]
        record[kind].append(str(f.relative_to(ROOT)))
        record['studies'].add(f.relative_to(EXP).parts[0])
        reported = d.get('response_model_id')
        response = f.parent / 'response.json'
        if response.exists():
            try:
                reported = json.loads(response.read_text(encoding='utf-8-sig')).get('model')
            except (OSError, ValueError):
                pass
        if isinstance(reported, str):
            record['reported_response_models'].add(reported)
    serial = {}
    for model, record in sorted(models.items()):
        serial[model] = {k: sorted(v) for k, v in record.items()}
        serial[model]['request_record_count'] = len(record['request_records'])
        serial[model]['generation_record_count'] = len(record['generation_records'])
    report = dict(date='2026-11-06', model_ids=serial,
        counting_scope='Saved record inventory only: request record is not proof of successful delivery; generations/requests may overlap or be replay copies. No total independent call count, billing or cross-model ranking inferred.',
        identity_scope='Requested API aliases and reported IDs, not independently verified immutable model builds. Prepared protocols, deterministic search and test fixtures do not establish another tested model.')
    target = EXP / 'MODEL_COVERAGE_20261106.json'
    target.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding='utf-8')
    print(json.dumps({m: {'request_records': v['request_record_count'], 'generation_records': v['generation_record_count']} for m,v in serial.items()}))


if __name__ == '__main__':
    main()
