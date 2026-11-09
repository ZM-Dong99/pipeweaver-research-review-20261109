module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire choose_a, choose_b, choose_c, choose_d, choose_e;
    wire choose_f, choose_g, choose_h, choose_i, choose_j;

    assign choose_a = (~sel[3] & ~sel[2] & ~sel[1] & ~sel[0])
                    | (sel[3] & (sel[2] | sel[1]));
    assign choose_b = ~sel[3] & ~sel[2] & ~sel[1] &  sel[0];
    assign choose_c = ~sel[3] & ~sel[2] &  sel[1] & ~sel[0];
    assign choose_d = ~sel[3] & ~sel[2] &  sel[1] &  sel[0];
    assign choose_e = ~sel[3] &  sel[2] & ~sel[1] & ~sel[0];
    assign choose_f = ~sel[3] &  sel[2] & ~sel[1] &  sel[0];
    assign choose_g = ~sel[3] &  sel[2] &  sel[1] & ~sel[0];
    assign choose_h = ~sel[3] &  sel[2] &  sel[1] &  sel[0];
    assign choose_i =  sel[3] & ~sel[2] & ~sel[1] & ~sel[0];
    assign choose_j =  sel[3] & ~sel[2] & ~sel[1] &  sel[0];

    always @* begin
        block_out = ({8{choose_a}} & block_a)
                  | ({8{choose_b}} & block_b)
                  | ({8{choose_c}} & block_c)
                  | ({8{choose_d}} & block_d)
                  | ({8{choose_e}} & block_e)
                  | ({8{choose_f}} & block_f)
                  | ({8{choose_g}} & block_g)
                  | ({8{choose_h}} & block_h)
                  | ({8{choose_i}} & block_i)
                  | ({8{choose_j}} & block_j);
    end
endmodule
