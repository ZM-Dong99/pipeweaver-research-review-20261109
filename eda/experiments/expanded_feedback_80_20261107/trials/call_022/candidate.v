module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);

    wire pick_a, pick_b, pick_c, pick_d, pick_e;
    wire pick_f, pick_g, pick_h, pick_i, pick_j;

    assign pick_a = ((~sel[3]) & (~sel[2]) & (~sel[1]) & (~sel[0]))
                  | (sel[3] & (sel[2] | sel[1]));
    assign pick_b = (sel == 4'd1);
    assign pick_c = (sel == 4'd2);
    assign pick_d = (sel == 4'd3);
    assign pick_e = (sel == 4'd4);
    assign pick_f = (sel == 4'd5);
    assign pick_g = (sel == 4'd6);
    assign pick_h = (sel == 4'd7);
    assign pick_i = (sel == 4'd8);
    assign pick_j = (sel == 4'd9);

    always @(*) begin
        block_out = ({8{pick_a}} & block_a)
                  | ({8{pick_b}} & block_b)
                  | ({8{pick_c}} & block_c)
                  | ({8{pick_d}} & block_d)
                  | ({8{pick_e}} & block_e)
                  | ({8{pick_f}} & block_f)
                  | ({8{pick_g}} & block_g)
                  | ({8{pick_h}} & block_h)
                  | ({8{pick_i}} & block_i)
                  | ({8{pick_j}} & block_j);
    end
endmodule
