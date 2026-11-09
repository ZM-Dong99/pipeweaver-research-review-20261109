module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire hi_00, hi_01, hi_10;
    wire lo_00, lo_01, lo_10, lo_11;
    wire use_default;

    assign hi_00 = ~sel[3] & ~sel[2];
    assign hi_01 = ~sel[3] &  sel[2];
    assign hi_10 =  sel[3] & ~sel[2];

    assign lo_00 = ~sel[1] & ~sel[0];
    assign lo_01 = ~sel[1] &  sel[0];
    assign lo_10 =  sel[1] & ~sel[0];
    assign lo_11 =  sel[1] &  sel[0];

    assign use_default = sel[3] & (sel[2] | sel[1]);

    always @(*) begin
        block_out =
            (block_a & {8{hi_00}} & {8{lo_00}}) |
            (block_b & {8{hi_00}} & {8{lo_01}}) |
            (block_c & {8{hi_00}} & {8{lo_10}}) |
            (block_d & {8{hi_00}} & {8{lo_11}}) |
            (block_e & {8{hi_01}} & {8{lo_00}}) |
            (block_f & {8{hi_01}} & {8{lo_01}}) |
            (block_g & {8{hi_01}} & {8{lo_10}}) |
            (block_h & {8{hi_01}} & {8{lo_11}}) |
            (block_i & {8{hi_10}} & {8{lo_00}}) |
            (block_j & {8{hi_10}} & {8{lo_01}}) |
            (block_a & {8{use_default}});
    end
endmodule
