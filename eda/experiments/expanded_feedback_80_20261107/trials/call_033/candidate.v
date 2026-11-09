module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire [3:0] low_dec;
    wire [2:0] high_dec;
    wire [9:0] enable;

    assign low_dec[0] = ~sel[1] & ~sel[0];
    assign low_dec[1] = ~sel[1] &  sel[0];
    assign low_dec[2] =  sel[1] & ~sel[0];
    assign low_dec[3] =  sel[1] &  sel[0];

    assign high_dec[0] = ~sel[3] & ~sel[2];
    assign high_dec[1] = ~sel[3] &  sel[2];
    assign high_dec[2] =  sel[3] & ~sel[2];

    assign enable[0] = (high_dec[0] & low_dec[0]) |
                       (sel[3] & (sel[2] | sel[1]));
    assign enable[1] = high_dec[0] & low_dec[1];
    assign enable[2] = high_dec[0] & low_dec[2];
    assign enable[3] = high_dec[0] & low_dec[3];
    assign enable[4] = high_dec[1] & low_dec[0];
    assign enable[5] = high_dec[1] & low_dec[1];
    assign enable[6] = high_dec[1] & low_dec[2];
    assign enable[7] = high_dec[1] & low_dec[3];
    assign enable[8] = high_dec[2] & low_dec[0];
    assign enable[9] = high_dec[2] & low_dec[1];

    always @(*) begin
        block_out = (block_a & {8{enable[0]}}) |
                    (block_b & {8{enable[1]}}) |
                    (block_c & {8{enable[2]}}) |
                    (block_d & {8{enable[3]}}) |
                    (block_e & {8{enable[4]}}) |
                    (block_f & {8{enable[5]}}) |
                    (block_g & {8{enable[6]}}) |
                    (block_h & {8{enable[7]}}) |
                    (block_i & {8{enable[8]}}) |
                    (block_j & {8{enable[9]}});
    end
endmodule
