"""Independent finite-vector check of addr_calcu's default parameter instance."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import random
import subprocess
ROOT=Path(__file__).resolve().parents[2]

def expected(address,ptr1,ptr2,b,control):
    ptr=ptr1 if control else ptr2
    offset=(128-ptr)&255
    return (address-offset+b)&65535

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument("study",type=Path)
    ap.add_argument("--baseline-only",action="store_true")
    args=ap.parse_args()
    study=args.study.resolve()
    protocol=json.loads((study/"protocol.json").read_text(encoding="utf-8"))
    assert protocol["profile"]=="addr_calcu"
    out=study/("oracle_preflight" if args.baseline_only else "independent_vector_validation")
    out.mkdir(exist_ok=False)
    vectors=[]
    for p1 in range(256):
        for p2 in range(256):
            for c in (0,1):
                vectors.append((0,p1,p2,0,c))
    for a in (0,1,127,128,255):
        for b in (0,1,127,128,255):
            for ptr in range(256):
                for c in (0,1):
                    vectors.append((a,ptr,ptr^255,b,c))
    rng=random.Random(20261030)
    for _ in range(1024):
        a,p1,p2,b=[rng.randrange(256) for _ in range(4)]
        vectors.extend([(a,p1,p2,b,c) for c in (0,1)])
    vectors=list(dict.fromkeys(vectors))
    vp=out/"vectors.hex"
    vp.write_text("".join(f"{a:02x} {p1:02x} {p2:02x} {b:02x} {c:x} {expected(a,p1,p2,b,c):04x}\n"
                          for a,p1,p2,b,c in vectors),encoding="ascii")
    tb=out/"tb.v"
    tb.write_text("""module pw_addr_vector_tb;
reg [7:0] address,ptr1,ptr2,b;
reg control;
wire [15:0] count;
reg [15:0] expected;
reg [8191:0] filename;
integer fd,rc,n;
addr_calcu dut(.address(address),.ptr1(ptr1),.ptr2(ptr2),.b(b),.control(control),.count(count));
initial begin
  n=0;
  if (!$value$plusargs("VECTORS=%s",filename)) $fatal(1,"Missing vectors");
  fd=$fopen(filename,"r");
  if(fd==0) $fatal(1,"Cannot open vectors");
  while(!$feof(fd)) begin
    rc=$fscanf(fd,"%h %h %h %h %h %h\\n",address,ptr1,ptr2,b,control,expected);
    if(rc==6) begin
      #1;
      if(count !== expected)
        $fatal(1,"MISMATCH row=%0d a=%h p1=%h p2=%h b=%h c=%h got=%h expected=%h",n,address,ptr1,ptr2,b,control,count,expected);
      n=n+1;
    end else if(!$feof(fd)) $fatal(1,"Malformed vector");
  end
  $fclose(fd);
  $display("VECTOR_PASS count=%0d",n);
  $finish;
end
endmodule
""",encoding="ascii")
    env=os.environ.copy()
    env.pop("OPENAI_API_KEY",None)
    suite=Path(r"D:\oss-cad-suite")
    env["PATH"]=os.pathsep.join([str(suite/"bin"),str(suite/"lib"),env.get("PATH","")])
    ver=subprocess.run([str(suite/"bin/iverilog.exe"),"-V"],env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=30)
    (out/"iverilog_version.log").write_bytes(ver.stdout)
    manifest={"slots":[]} if args.baseline_only else json.loads((study/"candidate_manifest.json").read_text(encoding="utf-8"))
    sources=[("baseline",ROOT/protocol["baseline_rtl"])]
    missing=[]
    for slot in manifest["slots"]:
        label=slot["arm"]+"_"+slot["candidate_id"]
        if slot["candidate_sha256"]:
            sources.append((label,study/slot["arm"]/slot["candidate_id"]/"candidate.v"))
        else:
            missing.append({"candidate":label,"status":"GENERATION_FAILED_NO_RTL"})
    records=[]
    for label,rtl in sources:
        dst=out/label
        dst.mkdir()
        binary=dst/"simulation.vvp"
        c=subprocess.run([str(suite/"bin/iverilog.exe"),"-g2012","-s","pw_addr_vector_tb","-o",str(binary),str(tb),str(rtl)],
                         cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=60)
        (dst/"compile.log").write_bytes(c.stdout)
        r={"candidate":label,"rtl":str(rtl.relative_to(ROOT)),"rtl_sha256":hashlib.sha256(rtl.read_bytes()).hexdigest(),
           "compile_exit":c.returncode,"status":"COMPILE_FAILED"}
        if c.returncode==0:
            sim=subprocess.run([str(suite/"bin/vvp.exe"),str(binary),"+VECTORS="+vp.as_posix()],
                               cwd=ROOT,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=120)
            (dst/"simulation.log").write_bytes(sim.stdout)
            ok=sim.returncode==0 and f"VECTOR_PASS count={len(vectors)}" in sim.stdout.decode("utf-8",errors="replace")
            r.update(status="PASS" if ok else "FAIL",simulation_exit=sim.returncode,vectors=len(vectors))
        records.append(r)
    result={"oracle":"Independent Python integer formula with explicit 8-bit offset and 16-bit output truncation",
            "configuration":"Default base=128 only","baseline_only_preflight":args.baseline_only,
            "vectors_per_rtl":len(vectors),"random_seed":20261030,
            "coverage":"All ptr1/ptr2 pairs and both controls at address=b=0; pointer/operand boundaries plus random inputs",
            "not_full_input_exhaustion":True,"full_input_proof":"Separate recorded SAT checks",
            "vectors_sha256":hashlib.sha256(vp.read_bytes()).hexdigest(),"results":records,
            "generation_failures":missing,"llm_generation_requests":0}
    (out/"SUMMARY.json").write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding="utf-8")
    print(json.dumps(result,ensure_ascii=False,indent=2))
    return 0 if all(r["status"]=="PASS" for r in records) else 1

if __name__=="__main__":
    raise SystemExit(main())

