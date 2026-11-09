module comparator_4bit_dsr (
    input [3:0] A, B,
    output eq, gt, lt
);
    assign eq = (A == B);
    
    wire [3:0] gt_bit, lt_bit;
    
    generate
    for (genvar i=0; i<4; i=i+1) begin : gen_comp
        wire eq_high = (A[3:i+1] == B[3:i+1]);
        assign gt_bit[i] = eq_high & (A[i] > B[i]);
        assign lt_bit[i] = eq_high & (A[i] < B[i]);
    end
    endgenerate
    
    assign gt = |gt_bit;
    assign lt = |lt_bit;
endmodule