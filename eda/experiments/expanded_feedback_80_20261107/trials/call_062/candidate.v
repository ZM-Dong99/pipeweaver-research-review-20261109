module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);

    wire [9:0] enable;

    assign enable[0] = ((~sel[3]) & (~sel[2]) & (~sel[1]) & (~sel[0]))
                     | (sel[3] & (sel[2] | sel[1]));
    assign enable[1] = (sel == 4'd1);
    assign enable[2] = (sel == 4'd2);
    assign enable[3] = (sel == 4'd3);
    assign enable[4] = (sel == 4'd4);
    assign enable[5] = (sel == 4'd5);
    assign enable[6] = (sel == 4'd6);
    assign enable[7] = (sel == 4'd7);
    assign enable[8] = (sel == 4'd8);
    assign enable[9] = (sel == 4'd9);

    always @* begin
        block_out = ({8{enable[0]}} & block_a)
                  | ({8{enable[1]}} & block_b)
                  | ({8{enable[2]}} & block_c)
                  | ({8{enable[3]}} & block_d)
                  | ({8{enable[4]}} & block_e)
                  | ({8{enable[5]}} & block_f)
                  | ({8{enable[6]}} & block_g)
                  | ({8{enable[7]}} & block_h)
                  | ({8{enable[8]}} & block_i)
                  | ({8{enable[9]}} & block_j);
    end

endmodule
