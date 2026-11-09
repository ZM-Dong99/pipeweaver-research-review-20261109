module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);

    wire [7:0] pair_ab;
    wire [7:0] pair_cd;
    wire [7:0] pair_ef;
    wire [7:0] pair_gh;
    wire [7:0] pair_ij;
    wire en_ab, en_cd, en_ef, en_gh, en_ij, en_default;

    assign pair_ab = sel[0] ? block_b : block_a;
    assign pair_cd = sel[0] ? block_d : block_c;
    assign pair_ef = sel[0] ? block_f : block_e;
    assign pair_gh = sel[0] ? block_h : block_g;
    assign pair_ij = sel[0] ? block_j : block_i;

    assign en_ab = ~sel[3] & ~sel[2] & ~sel[1];
    assign en_cd = ~sel[3] & ~sel[2] &  sel[1];
    assign en_ef = ~sel[3] &  sel[2] & ~sel[1];
    assign en_gh = ~sel[3] &  sel[2] &  sel[1];
    assign en_ij =  sel[3] & ~sel[2] & ~sel[1];
    assign en_default = sel[3] & (sel[2] | sel[1]);

    always @(*) begin
        block_out = ({8{en_ab}} & pair_ab)
                  | ({8{en_cd}} & pair_cd)
                  | ({8{en_ef}} & pair_ef)
                  | ({8{en_gh}} & pair_gh)
                  | ({8{en_ij}} & pair_ij)
                  | ({8{en_default}} & block_a);
    end
endmodule
