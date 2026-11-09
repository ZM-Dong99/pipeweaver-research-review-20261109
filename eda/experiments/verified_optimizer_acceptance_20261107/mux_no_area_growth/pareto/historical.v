module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire select_a;
    wire select_b, select_c, select_d, select_e;
    wire select_f, select_g, select_h, select_i, select_j;

    assign select_a = (~sel[3] & ~sel[2] & ~sel[1] & ~sel[0])
                    | (sel[3] & (sel[2] | sel[1]));
    assign select_b = (sel == 4'd1);
    assign select_c = (sel == 4'd2);
    assign select_d = (sel == 4'd3);
    assign select_e = (sel == 4'd4);
    assign select_f = (sel == 4'd5);
    assign select_g = (sel == 4'd6);
    assign select_h = (sel == 4'd7);
    assign select_i = (sel == 4'd8);
    assign select_j = (sel == 4'd9);

    always @(*) begin
        block_out = ({8{select_a}} & block_a)
                  | ({8{select_b}} & block_b)
                  | ({8{select_c}} & block_c)
                  | ({8{select_d}} & block_d)
                  | ({8{select_e}} & block_e)
                  | ({8{select_f}} & block_f)
                  | ({8{select_g}} & block_g)
                  | ({8{select_h}} & block_h)
                  | ({8{select_i}} & block_i)
                  | ({8{select_j}} & block_j);
    end
endmodule
