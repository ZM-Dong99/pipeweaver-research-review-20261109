# Three-arm RTL timing study

Protocol SHA-256: `cdc16ba3e693ed335319c47ee9c0568480ef70a9bccc4fce5d3473a7912253a7`

| Arm | Generated | Formal pass | PPA complete | Area eligible | Best eligible WNS (ns) | Average WNS (ns) | Avg area delta | Avg runtime (s) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| generic_llm | 3/3 | 100% (3/3) | 3 | 2 | 1.380 | 1.380 | 6.231% | 227.590 |
| sta_guided_llm | 3/3 | — | 2 | 2 | 3.190 | 3.190 | 8.499% | 74.688 |
| constrained_search | 3/3 | 100% (3/3) | 3 | 3 | 4.890 | 3.240 | 3.699% | 1.757 |

## Scope

One timing_adder design, one selected SKY130HD TT library, and one exploratory SDC; no generalization beyond these tested conditions.
