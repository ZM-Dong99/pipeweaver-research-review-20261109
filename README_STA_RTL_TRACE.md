# RTL path-cone tracer

`eda/experiments/trace_sta_rtl_cone.py` consumes a pre-ABC Yosys JSON netlist and a top-level STA input bit/output bit pair. It supports bitwise AND/OR/XOR/XNOR and unsigned add/sub dependencies. It reports source-attributed operator cells that may lie on a structural path between those bits. Unsupported operators are listed; failure to find a supported path is inconclusive.

The report is a conservative RTL operator cone. It is not a cell-by-cell match between OpenSTA's ABC-mapped path and RTL source. On the 8x8 multiplier baseline it found 13 possible RTLIL cells (5 additions, 8 partial-product ANDs) with source attribution on all 13, between `multiplicand[3]` and `product[11]`.

The native evaluator writes `rtl_source_cone.json` alongside the raw STA result. The guided multiplier runner supplies that JSON to the model and explicitly states its precision limit.

Named chains now include source signal aliases at every supported dependency step, including generated arrays such as `partial_products[3][0]` and `sum[4][3]`. Declared Verilog indices are resolved correctly for nonzero offsets and ascending ranges; both semantic unit checks and an actual Yosys read/write range probe were run. The reported source-attribution fraction is only over selected supported pre-ABC RTLIL cells. It is not gate-to-source localization accuracy or complete timing-path coverage.

The newer feedback ablation and its independent API/EDA audit are documented in `README_FEEDBACK_ABLATION.md`. Additional baseline-only slew/load/fanout diagnostics are kept separate from frozen prompts. OpenSTA instance names should be joined against JSON read back from its exact input Verilog; the earlier internal Yosys JSON may use different hidden names.
