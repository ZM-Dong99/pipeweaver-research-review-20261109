module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

// 16-bit zero-extended multiplicand for shifting
wire [15:0] mult_ext = {8'b0, multiplicand};

// Eight partial product rows: multiplicand shifted by multiplier bit position,
// gated by the corresponding multiplier bit.
wire [15:0] pp [0:7];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: gen_pp
        assign pp[i] = (mult_ext << i) & {16{multiplier[i]}};
    end
endgenerate

// Balanced binary adder tree: 3 levels instead of 7 serial additions
wire [15:0] sum01 = pp[0] + pp[1];
wire [15:0] sum23 = pp[2] + pp[3];
wire [15:0] sum45 = pp[4] + pp[5];
wire [15:0] sum67 = pp[6] + pp[7];
wire [15:0] sum0123 = sum01 + sum23;
wire [15:0] sum4567 = sum45 + sum67;

assign product = sum0123 + sum4567;

endmodule
