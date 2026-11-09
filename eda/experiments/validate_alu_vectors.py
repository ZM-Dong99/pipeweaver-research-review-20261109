"""Independent finite-vector ALU oracle regression. Not a replacement for formal proof."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import random
import subprocess

ROOT = Path(__file__).resolve().parents[2]
MASK = (1 << 64) - 1

def expected(a, b, op):
    return ((a+b, a-b, b-a, a|b, a&b, a^b, ~(a^b), 0)[op]) & MASK

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("study", type=Path)
    ap.add_argument("--baseline-only", action="store_true", help="check the independent oracle against only the original RTL before candidates finish")
    args = ap.parse_args()
    study = args.study.resolve()
    protocol = json.loads((study/"protocol.json").read_text(encoding="utf-8"))
    if protocol["profile"] != "alu64":
        raise ValueError("Only the frozen alu64 contract is supported")
    out = study / ("oracle_preflight" if args.baseline_only else "independent_vector_validation")
    out.mkdir(exist_ok=False)
    corners = [0,1,2,3,7,MASK,MASK-1,1<<63,(1<<63)-1,(1<<32)-1,1<<32,(1<<32)+1,
               0x5555555555555555,0xaaaaaaaaaaaaaaaa]
    pairs = [(a,b) for a in corners for b in corners]
    for k in range(1,65):
        pairs.extend([((1<<k)-1,1),(1,(1<<k)-1)])
    rng = random.Random(20261030)
    pairs += [(rng.getrandbits(64),rng.getrandbits(64)) for _ in range(512)]
    pairs = list(dict.fromkeys(pairs))
    vectors = out / "vectors.hex"
    vectors.write_text("".join(f"{a:016x} {b:016x} {op:x} {expected(a,b,op):016x}\n"
                              for a,b in pairs for op in range(8)),encoding="ascii")
    total = len(pairs)*8
    tb = out / "tb.v"
    tb.write_text("""module pw_alu_vector_tb;
reg [63:0] a,b,expected;
reg [2:0] Oper;
wire [63:0] sum;
reg [8191:0] filename;
integer fd,rc,count;
alu_64bit dut(.a(a),.b(b),.Oper(Oper),.sum(sum));
initial begin
  count=0;
  if (!$value$plusargs("VECTORS=%s",filename)) $fatal(1,"VECTORS missing");
  fd=$fopen(filename,"r");
  if (fd==0) $fatal(1,"vectors unavailable");
  while (!$feof(fd)) begin
    rc=$fscanf(fd,"%h %h %h %h\\n",a,b,Oper,expected);
    if (rc==4) begin
      #1;
      if (sum !== expected)
        $fatal(1,"MISMATCH row=%0d op=%0d a=%h b=%h actual=%h expected=%h",count,Oper,a,b,sum,expected);
      count=count+1;
    end else if (!$feof(fd)) $fatal(1,"Malformed vectors");
  end
  $fclose(fd);
  $display("VECTOR_PASS count=%0d",count);
  $finish;
end
endmodule
""",encoding="ascii")
    env = os.environ.copy()
    env.pop("OPENAI_API_KEY",None)
    suite = Path(r"D:\oss-cad-suite")
    env["PATH"] = os.pathsep.join([str(suite/"bin"),str(suite/"lib"),env.get("PATH","")])
    version = subprocess.run([str(suite/"bin/iverilog.exe"),"-V"],cwd=ROOT,env=env,
                             stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=30)
    (out/"iverilog_version.log").write_bytes(version.stdout)
    manifest = {"slots": []} if args.baseline_only else json.loads((study/"candidate_manifest.json").read_text(encoding="utf-8"))
    sources = [("baseline", ROOT/protocol["baseline_rtl"])]
    missing = []
    for slot in manifest["slots"]:
        label = slot["arm"]+"_"+slot["candidate_id"]
        if slot["candidate_sha256"]:
            sources.append((label,study/slot["arm"]/slot["candidate_id"]/"candidate.v"))
        else:
            missing.append({"candidate":label,"status":"NO_RTL_GENERATION_FAILED","excluded_from_simulation":True})
    records = []
    for label, rtl in sources:
        target = out / label
        target.mkdir()
        binary = target / "simulation.vvp"
        compile_cmd=[str(suite/"bin/iverilog.exe"),"-g2012","-s","pw_alu_vector_tb","-o",str(binary),str(tb),str(rtl)]
        compile_proc = subprocess.run(compile_cmd,cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=60)
        (target/"compile.log").write_bytes(compile_proc.stdout)
        row={"candidate":label,"rtl":str(rtl.relative_to(ROOT)),
             "rtl_sha256":hashlib.sha256(rtl.read_bytes()).hexdigest(),"compile_exit":compile_proc.returncode,
             "status":"COMPILE_FAILED"}
        if compile_proc.returncode == 0:
            sim = subprocess.run([str(suite/"bin/vvp.exe"),str(binary),"+VECTORS="+vectors.as_posix()],
                                 cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=60)
            (target/"simulation.log").write_bytes(sim.stdout)
            passed = sim.returncode == 0 and f"VECTOR_PASS count={total}" in sim.stdout.decode("utf-8",errors="replace")
            row.update(status="PASS" if passed else "FAIL",simulation_exit=sim.returncode,vectors=total)
        records.append(row)
    summary={"oracle":"Python integer arithmetic masked to 64 bits; independently encoded eight operations",
             "baseline_only_preflight": args.baseline_only,
             "scope":"Finite vectors only; separate full-input SAT and gate-level proofs remain authoritative",
             "random_seed":20261030,"vectors_per_rtl":total,"operands_pairs":len(pairs),
             "all_eight_operations":True,"vectors_sha256":hashlib.sha256(vectors.read_bytes()).hexdigest(),
             "api_calls":0,"results":records,"generation_failures":missing}
    (out/"SUMMARY.json").write_text(json.dumps(summary,indent=2,ensure_ascii=False),encoding="utf-8")
    print(json.dumps(summary,indent=2,ensure_ascii=False))
    return 0 if all(r["status"]=="PASS" for r in records) else 1

if __name__=="__main__":
    raise SystemExit(main())

