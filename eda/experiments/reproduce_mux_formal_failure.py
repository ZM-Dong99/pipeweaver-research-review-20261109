"""A real Icarus simulation of the rejected candidate's default-selection bug."""
from pathlib import Path
import json,re,subprocess,os,hashlib
R=Path(r'D:\verilog_lab\PipeWeaver');S=R/'eda/experiments/mux_feedback_study_20261104_155643_522144';F=S/'formal_failure_reproduction';F.mkdir(exist_ok=False)
gold=S/'inputs/original.v';cand=S/'no_sta/trial_02/candidate.v'
for source,name in [(gold,'gold'),(cand,'cand')]:
    text,count=re.subn(r'\bmodule\s+mux_large\b','module '+name,source.read_text(encoding='utf-8'),count=1);assert count==1
    (F/(name+'.v')).write_text(text,encoding='utf-8')
ports=', '.join('.block_'+c+'(block_'+c+')' for c in 'abcdefghij')
tb='module tb;\n'+ '\n'.join('reg [7:0] block_'+c+';' for c in 'abcdefghij')+'\nreg [3:0] sel; wire [7:0] gold_out, cand_out;\n'
tb+=f'gold g({ports}, .sel(sel), .block_out(gold_out));\ncand c({ports}, .sel(sel), .block_out(cand_out));\ninitial begin\n'
tb+='\n'.join('block_'+c+" = 8'd0;" for c in 'abcdefghij')+'\nblock_i = 8\'d1; sel = 4\'d12; #1;\n'
tb+='''$display("sel=%0d original=%0d candidate=%0d",sel,gold_out,cand_out);
if (gold_out !== 8'd0 || cand_out !== 8'd1) $fatal(1,"Counterexample mismatch");
$display("EXPECTED_INEQUIVALENCE_REPRODUCED"); $finish;
end
endmodule
'''
(F/'tb.v').write_text(tb,encoding='utf-8');env=os.environ.copy()
for key in ['OPENAI_API_KEY','DEEPSEEK_API_KEY','ANTHROPIC_API_KEY']:env.pop(key,None)
commands=[[r'D:\oss-cad-suite\bin\iverilog.exe','-g2005-sv','-s','tb','-o',str(F/'counterexample.vvp'),str(F/'gold.v'),str(F/'cand.v'),str(F/'tb.v')],[r'D:\oss-cad-suite\bin\vvp.exe',str(F/'counterexample.vvp')]]
outputs=[]
for n,command in enumerate(commands):
    result=subprocess.run(command,cwd=R,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=30);out=result.stdout.decode('utf-8',errors='replace');(F/('compile.log' if n==0 else 'simulation.log')).write_text(out,encoding='utf-8');assert result.returncode==0,out;outputs.append(out)
assert 'sel=12 original=0 candidate=1' in outputs[-1] and 'EXPECTED_INEQUIVALENCE_REPRODUCED' in outputs[-1]
report=dict(expected_inequivalence_reproduced=True,meaning='This confirms the rejected candidate is WRONG; it is not a functional-equivalence pass.',call_index=4,arm='no_sta',trial=2,inputs=dict(sel=12,block_i=1,all_other_data_inputs=0),original_output=0,candidate_output=1,original_sha256=hashlib.sha256(gold.read_bytes()).hexdigest(),candidate_sha256=hashlib.sha256(cand.read_bytes()).hexdigest(),model_requests=0,scope='One concrete simulation corroborates the existing full SAT counterexample; it does not replace universal proofs.')
(F/'RESULT.json').write_text(json.dumps(report,indent=2),encoding='utf-8');print(outputs[-1]);print('Rejected candidate bug reproduced; no model call.')
