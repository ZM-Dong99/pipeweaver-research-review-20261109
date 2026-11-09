module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire hi_00, hi_01, hi_10;
    wire lo_00, lo_01, lo_10, lo_11;
    wire take_a, take_b, take_c, take_d, take_e;
    wire take_f, take_g, take_h, take_i, take_j;

    assign hi_00 = ~sel[3] & ~sel[2];
    assign hi_01 = ~sel[3] &  sel[2];
    assign hi_10 =  sel[3] & ~sel[2];

    assign lo_00 = ~sel[1] & ~sel[0];
    assign lo_01 = ~sel[1] &  sel[0];
    assign lo_10 =  sel[1] & ~sel[0];
    assign lo_11 =  sel[1] &  sel[0];

    assign take_a = (hi_00 & lo_00) |
                    (sel[3] & (sel[2] | sel[1]));
    assign take_b = hi_00 & lo_01;
    assign take_c = hi_00 & lo_10;
    assign take_d = hi_00 & lo_11;
    assign take_e = hi_01 & lo_00;
    assign take_f = hi_01 & lo_01;
    assign take_g = hi_01 & lo_10;
    assign take_h = hi_01 & lo_11;
    assign take_i = hi_10 & lo_00;
    assign take_j = hi_10 & lo_01;

    always @(*) begin
        block_out = (block_a & {8{take_a}}) |
                    (block_b & {8{take_b}}) |
                    (block_c & {8{take_c}}) |
                    (block_d & {8{take_d}}) |
                    (block_e & {8{take_e}}) |
                    (block_f & {8{take_f}}) |
                    (block_g & {8{take_g}}) |
                    (block_h & {8{take_h}}) |
                    (block_i & {8{take_i}}) |
                    (block_j & {8{take_j}});
    end
endmodule
