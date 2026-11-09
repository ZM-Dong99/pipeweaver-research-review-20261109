module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire en_a, en_b, en_c, en_d, en_e;
    wire en_f, en_g, en_h, en_i, en_j;

    // Decode the default directly rather than complementing all other cases.
    assign en_a = (sel == 4'b0000) |
                  (sel[3] & (sel[2] | sel[1]));
    assign en_b = (sel == 4'b0001);
    assign en_c = (sel == 4'b0010);
    assign en_d = (sel == 4'b0011);
    assign en_e = (sel == 4'b0100);
    assign en_f = (sel == 4'b0101);
    assign en_g = (sel == 4'b0110);
    assign en_h = (sel == 4'b0111);
    assign en_i = (sel == 4'b1000);
    assign en_j = (sel == 4'b1001);

    always @(*) begin
        block_out = ({8{en_a}} & block_a) |
                    ({8{en_b}} & block_b) |
                    ({8{en_c}} & block_c) |
                    ({8{en_d}} & block_d) |
                    ({8{en_e}} & block_e) |
                    ({8{en_f}} & block_f) |
                    ({8{en_g}} & block_g) |
                    ({8{en_h}} & block_h) |
                    ({8{en_i}} & block_i) |
                    ({8{en_j}} & block_j);
    end
endmodule
