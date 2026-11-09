module mux_large_ds (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output [7:0] block_out
);

    wire [7:0] mux_out [0:9];
    assign mux_out[0] = block_a;
    assign mux_out[1] = block_b;
    assign mux_out[2] = block_c;
    assign mux_out[3] = block_d;
    assign mux_out[4] = block_e;
    assign mux_out[5] = block_f;
    assign mux_out[6] = block_g;
    assign mux_out[7] = block_h;
    assign mux_out[8] = block_i;
    assign mux_out[9] = block_j;

    assign block_out = (sel < 4'd10) ? mux_out[sel] : block_a;
endmodule