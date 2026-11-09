import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

def run_eda(rtl):
    cmd = [sys.executable, str(ROOT / "eda" / "run_eda.py"), str(rtl)]
    return subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)

def load_metrics(rtl):
    top = Path(rtl).stem
    p = ROOT / "eda" / "reports" / f"{top}_metrics.json"
    return json.loads(p.read_text(encoding="utf-8"))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python agents/optimizer.py benchmark/timing_adder.v")
        raise SystemExit(1)
    result = run_eda(sys.argv[1])
    print(result.stdout)
    if result.returncode:
        print(result.stderr)
        raise SystemExit(result.returncode)
    print(json.dumps(load_metrics(sys.argv[1]), indent=2))
