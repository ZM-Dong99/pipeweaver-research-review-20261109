module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire [3:0] lo;
    wire [3:0] hi;
    wire [9:0] enable;

    assign lo[0] = ~sel[1] & ~sel[0];
    assign lo[1] = ~sel[1] &  sel[0];
    assign lo[2] =  sel[1] & ~sel[0];
    assign lo[3] =  sel[1] &  sel[0];

    assign hi[0] = ~sel[3] & ~sel[2];
    assign hi[1] = ~sel[3] &  sel[2];
    assign hi[2] =  sel[3] & ~sel[2];
    assign hi[3] =  sel[3] &  sel[2];

    assign enable[0] = (hi[0] & lo[0]) |
                       (sel[3] & (sel[2] | sel[1]));
    assign enable[1] = hi[0] & lo[1];
    assign enable[2] = hi[0] & lo[2];
    assign enable[3] = hi[0] & lo[3];
    assign enable[4] = hi[1] & lo[0];
    assign enable[5] = hi[1] & lo[1];
    assign enable[6] = hi[1] & lo[2];
    assign enable[7] = hi[1] & lo[3];
    assign enable[8] = hi[2] & lo[0];
    assign enable[9] = hi[2] & lo[1];

    always @(*) begin
        block_out = ({8{enable[0]}} & block_a) |
                    ({8{enable[1]}} & block_b) |
                    ({8{enable[2]}} & block_c) |
                    ({8{enable[3]}} & block_d) |
                    ({8{enable[4]}} & block_e) |
                    ({8{enable[5]}} & block_f) |
                    ({8{enable[6]}} & block_g) |
                    ({8{enable[7]}} & block_h) |
                    ({8{enable[8]}} & block_i) |
                    ({8{enable[9]}} & block_j);
    end
endmodule
