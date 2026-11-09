module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);

    wire en_a, en_b, en_c, en_d, en_e;
    wire en_f, en_g, en_h, en_i, en_j;
    wire [7:0] group_abcd;
    wire [7:0] group_efgh;
    wire [7:0] group_ij;

    assign en_a = (~sel[3] & ~sel[2] & ~sel[1] & ~sel[0])
                | (sel[3] & (sel[2] | sel[1]));
    assign en_b = ~sel[3] & ~sel[2] & ~sel[1] &  sel[0];
    assign en_c = ~sel[3] & ~sel[2] &  sel[1] & ~sel[0];
    assign en_d = ~sel[3] & ~sel[2] &  sel[1] &  sel[0];
    assign en_e = ~sel[3] &  sel[2] & ~sel[1] & ~sel[0];
    assign en_f = ~sel[3] &  sel[2] & ~sel[1] &  sel[0];
    assign en_g = ~sel[3] &  sel[2] &  sel[1] & ~sel[0];
    assign en_h = ~sel[3] &  sel[2] &  sel[1] &  sel[0];
    assign en_i =  sel[3] & ~sel[2] & ~sel[1] & ~sel[0];
    assign en_j =  sel[3] & ~sel[2] & ~sel[1] &  sel[0];

    assign group_abcd = (({8{en_a}} & block_a) | ({8{en_b}} & block_b))
                      | (({8{en_c}} & block_c) | ({8{en_d}} & block_d));
    assign group_efgh = (({8{en_e}} & block_e) | ({8{en_f}} & block_f))
                      | (({8{en_g}} & block_g) | ({8{en_h}} & block_h));
    assign group_ij = ({8{en_i}} & block_i) | ({8{en_j}} & block_j);

    always @(*) begin
        block_out = group_abcd | group_efgh | group_ij;
    end
endmodule
