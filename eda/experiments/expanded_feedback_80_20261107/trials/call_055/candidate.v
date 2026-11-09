module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire lo00, lo01, lo10, lo11;
    wire hi00, hi01, hi10;
    wire en_a, en_b, en_c, en_d, en_e;
    wire en_f, en_g, en_h, en_i, en_j;

    assign lo00 = ~sel[1] & ~sel[0];
    assign lo01 = ~sel[1] &  sel[0];
    assign lo10 =  sel[1] & ~sel[0];
    assign lo11 =  sel[1] &  sel[0];
    assign hi00 = ~sel[3] & ~sel[2];
    assign hi01 = ~sel[3] &  sel[2];
    assign hi10 =  sel[3] & ~sel[2];

    assign en_a = (hi00 & lo00) | (sel[3] & (sel[2] | sel[1]));
    assign en_b = hi00 & lo01;
    assign en_c = hi00 & lo10;
    assign en_d = hi00 & lo11;
    assign en_e = hi01 & lo00;
    assign en_f = hi01 & lo01;
    assign en_g = hi01 & lo10;
    assign en_h = hi01 & lo11;
    assign en_i = hi10 & lo00;
    assign en_j = hi10 & lo01;

    always @(*) begin
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
