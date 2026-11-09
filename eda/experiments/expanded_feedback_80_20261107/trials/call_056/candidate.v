module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire en_a, en_b, en_c, en_d, en_e;
    wire en_f, en_g, en_h, en_i, en_j;

    assign en_a = (~|sel) | (sel[3] & (sel[2] | sel[1]));
    assign en_b = (sel == 4'd1);
    assign en_c = (sel == 4'd2);
    assign en_d = (sel == 4'd3);
    assign en_e = (sel == 4'd4);
    assign en_f = (sel == 4'd5);
    assign en_g = (sel == 4'd6);
    assign en_h = (sel == 4'd7);
    assign en_i = (sel == 4'd8);
    assign en_j = (sel == 4'd9);

    always @* begin
        block_out = ({8{en_a}} & block_a)
                  | ({8{en_b}} & block_b)
                  | ({8{en_c}} & block_c)
                  | ({8{en_d}} & block_d)
                  | ({8{en_e}} & block_e)
                  | ({8{en_f}} & block_f)
                  | ({8{en_g}} & block_g)
                  | ({8{en_h}} & block_h)
                  | ({8{en_i}} & block_i)
                  | ({8{en_j}} & block_j);
    end
endmodule
