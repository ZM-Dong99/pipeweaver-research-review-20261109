module mux_large_dsr (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);

    wire [7:0] input_blocks [9:0];
    assign input_blocks[0] = block_a;
    assign input_blocks[1] = block_b;
    assign input_blocks[2] = block_c;
    assign input_blocks[3] = block_d;
    assign input_blocks[4] = block_e;
    assign input_blocks[5] = block_f;
    assign input_blocks[6] = block_g;
    assign input_blocks[7] = block_h;
    assign input_blocks[8] = block_i;
    assign input_blocks[9] = block_j;

    always @(*) begin
        block_out = (sel < 4'd10) ? input_blocks[sel] : input_blocks[0];
    end

endmodule