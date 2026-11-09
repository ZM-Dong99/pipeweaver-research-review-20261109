module comparator #(
    parameter N = 8              // Define parameter first
) (
    input [2:0] SEL,          // 3-bit selection signal
    input [N-1:0] value1,     // First comparison value
    input [N-1:0] value2,     // Second comparison value
    output reg OUT            // Comparison result output
);

// Pre-compute comparison results
// PipeWeaver whitelisted action: linear, chunk_bits=8.
localparam integer PW_GROUP_BITS = 8;
localparam integer PW_GROUPS = (N + PW_GROUP_BITS - 1) / PW_GROUP_BITS;
wire [PW_GROUPS-1:0] pw_chunk_eq, pw_chunk_gt;
genvar pw_chunk;
generate
    for (pw_chunk=0; pw_chunk<PW_GROUPS; pw_chunk=pw_chunk+1) begin : pw_compare_chunks
        localparam integer LO = pw_chunk*PW_GROUP_BITS;
        localparam integer HI = (LO+PW_GROUP_BITS > N) ? N-1 : LO+PW_GROUP_BITS-1;
        assign pw_chunk_eq[pw_chunk] = value1[HI:LO] == value2[HI:LO];
        assign pw_chunk_gt[pw_chunk] = value1[HI:LO] > value2[HI:LO];
    end
endgenerate
wire [PW_GROUPS:0] pw_eq_chain, pw_gt_chain;
assign pw_eq_chain[0] = 1'b1;
assign pw_gt_chain[0] = 1'b0;
genvar pw_stage;
generate
    for (pw_stage=0; pw_stage<PW_GROUPS; pw_stage=pw_stage+1) begin : pw_chain_nodes
        assign pw_eq_chain[pw_stage+1] = pw_chunk_eq[pw_stage] & pw_eq_chain[pw_stage];
        assign pw_gt_chain[pw_stage+1] = pw_chunk_gt[pw_stage] | (pw_chunk_eq[pw_stage] & pw_gt_chain[pw_stage]);
    end
endgenerate
wire cmp_equal = pw_eq_chain[PW_GROUPS];
wire cmp_greater = pw_gt_chain[PW_GROUPS];

always @(*) begin
    case (SEL)
        3'b000: OUT = 1'b0;               // Constant 0
        3'b001: OUT = 1'b1;               // Constant 1
        3'b010: OUT = cmp_equal;         // ==
        3'b011: OUT = ~cmp_equal;        // !=
        3'b100: OUT = (cmp_equal || cmp_greater);  // >=
        3'b101: OUT = ~cmp_greater;      // <=
        3'b110: OUT = (~cmp_equal && ~cmp_greater); // <
        3'b111: OUT = cmp_greater;       // >
        default: OUT = 1'b0;             // Default case
    endcase
end

endmodule