# Uniform re-evaluation of frozen native multiplier candidates

Re-evaluation protocol SHA-256: `89d967879b51618cef3d7ad59dc3c331e7531bb1191cbc53d8bef0d291967716`
Source study protocol SHA-256: `666d378eaa214239a6ecf5f4010c2e4015e7b1e32cef22a3792bffd039d987bb`
Source candidate manifest SHA-256: `01c2cb9345ffdef876eb2a966be223c3f9428afa6c254bceb28e054d46cbe20f`

No new model API calls were made. All nine previously frozen RTL files were re-evaluated after fixing helper-module flattening; initial logs remain unchanged.

Baseline: 2.78 ns, 2965.344 µm².

| Method | Formal | PPA complete | Valid improvements | Best eligible max data arrival |
|---|---:|---:|---:|---:|
| generic_llm | 3/3 | 3/3 | 1/3 | 2.49 ns |
| sta_guided_llm | 3/3 | 3/3 | 0/3 | 2.78 ns |
| constrained_search | 3/3 | 3/3 | 0/3 | 2.78 ns |

## Scope and caveat

Post-hoc uniform re-evaluation of the same nine frozen candidates after a mechanical evaluator repair; the original logs remain intact. One small combinational design, pre-layout only.
