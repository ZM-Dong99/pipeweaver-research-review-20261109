module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire take_a, take_b, take_c, take_d, take_e;
    wire take_f, take_g, take_h, take_i, take_j;

    // Select A for zero and for every unused select code (10 through 15).
    assign take_a = (~sel[3] & ~sel[2] & ~sel[1] & ~sel[0]) |
                    (sel[3] & (sel[2] | sel[1]));
    assign take_b = (sel == 4'd1);
    assign take_c = (sel == 4'd2);
    assign take_d = (sel == 4'd3);
    assign take_e = (sel == 4'd4);
    assign take_f = (sel == 4'd5);
    assign take_g = (sel == 4'd6);
    assign take_h = (sel == 4'd7);
    assign take_i = (sel == 4'd8);
    assign take_j = (sel == 4'd9);

    always @(*) begin
        block_out = ({8{take_a}} & block_a) |
                    ({8{take_b}} & block_b) |
                    ({8{take_c}} & block_c) |
                    ({8{take_d}} & block_d) |
                    ({8{take_e}} & block_e) |
                    ({8{take_f}} & block_f) |
                    ({8{take_g}} & block_g) |
                    ({8{take_h}} & block_h) |
                    ({8{take_i}} & block_i) |
                    ({8{take_j}} & block_j);
    end
endmodule
