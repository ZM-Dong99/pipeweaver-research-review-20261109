module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);

    wire select_a;
    wire select_b;
    wire select_c;
    wire select_d;
    wire select_e;
    wire select_f;
    wire select_g;
    wire select_h;
    wire select_i;
    wire select_j;

    assign select_a = (~|sel) | (sel[3] & (sel[2] | sel[1]));
    assign select_b = (sel == 4'b0001);
    assign select_c = (sel == 4'b0010);
    assign select_d = (sel == 4'b0011);
    assign select_e = (sel == 4'b0100);
    assign select_f = (sel == 4'b0101);
    assign select_g = (sel == 4'b0110);
    assign select_h = (sel == 4'b0111);
    assign select_i = (sel == 4'b1000);
    assign select_j = (sel == 4'b1001);

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
