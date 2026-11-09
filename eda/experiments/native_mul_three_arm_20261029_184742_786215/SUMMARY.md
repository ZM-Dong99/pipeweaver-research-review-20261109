# Native 8x8 multiplier: three-arm study

Protocol SHA-256: `666d378eaa214239a6ecf5f4010c2e4015e7b1e32cef22a3792bffd039d987bb`

Baseline: max data arrival 2.78 ns, area 2965.344 µm².

| Method | Valid improvements | Formal pass | PPA complete | Best area-eligible data arrival (ns) |
|---|---:|---:|---:|---:|
| generic_llm | 0/3 | 2/3 | 2/3 | 2.81 |
| sta_guided_llm | 0/3 | 3/3 | 3/3 | 2.78 |
| constrained_search | 0/3 | 3/3 | 3/3 | 2.78 |

## Scope

One unsigned 8x8 combinational multiplier, one library corner/SDC and three candidate slots per method; pre-layout only.

Every slot and raw prompt, model record, candidate RTL, formal log and OpenSTA log is preserved. API generation failures and formal failures remain in the denominator.
