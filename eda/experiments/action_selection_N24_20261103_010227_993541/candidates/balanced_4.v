module comparator #(
    parameter N = 8              // Define parameter first
) (
    input [2:0] SEL,          // 3-bit selection signal
    input [N-1:0] value1,     // First comparison value
    input [N-1:0] value2,     // Second comparison value
    output reg OUT            // Comparison result output
);

// Pre-compute comparison results
// PipeWeaver whitelisted action: balanced, chunk_bits=4.
localparam integer PW_GROUP_BITS = 4;
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
localparam integer PW_LEAVES = 1 << $clog2(PW_GROUPS);
wire [2*PW_LEAVES-1:1] pw_eq_tree, pw_gt_tree;
genvar pw_leaf, pw_node;
generate
    for (pw_leaf=0; pw_leaf<PW_LEAVES; pw_leaf=pw_leaf+1) begin : pw_tree_leaves
        if (pw_leaf<PW_GROUPS) begin : real_chunk
            assign pw_eq_tree[PW_LEAVES+pw_leaf] = pw_chunk_eq[pw_leaf];
            assign pw_gt_tree[PW_LEAVES+pw_leaf] = pw_chunk_gt[pw_leaf];
        end else begin : neutral_padding
            assign pw_eq_tree[PW_LEAVES+pw_leaf] = 1'b1;
            assign pw_gt_tree[PW_LEAVES+pw_leaf] = 1'b0;
        end
    end
    for (pw_node=1; pw_node<PW_LEAVES; pw_node=pw_node+1) begin : pw_tree_nodes
        assign pw_eq_tree[pw_node] = pw_eq_tree[2*pw_node+1] & pw_eq_tree[2*pw_node];
        assign pw_gt_tree[pw_node] = pw_gt_tree[2*pw_node+1] | (pw_eq_tree[2*pw_node+1] & pw_gt_tree[2*pw_node]);
    end
endgenerate
wire cmp_equal = pw_eq_tree[1];
wire cmp_greater = pw_gt_tree[1];

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