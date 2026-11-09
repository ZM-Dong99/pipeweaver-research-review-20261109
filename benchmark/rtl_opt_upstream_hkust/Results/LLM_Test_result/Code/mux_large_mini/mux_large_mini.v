module mux_large_mini (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,  // 4 bit select signal
    output [7:0] block_out
);

    wire [7:0] inputs [0:9];

    assign inputs[0] = block_a;
    assign inputs[1] = block_b;
    assign inputs[2] = block_c;
    assign inputs[3] = block_d;
    assign inputs[4] = block_e;
    assign inputs[5] = block_f;
    assign inputs[6] = block_g;
    assign inputs[7] = block_h;
    assign inputs[8] = block_i;
    assign inputs[9] = block_j;

    assign block_out = inputs[sel];

endmodule