module adder_carry_gpt(a, b, cin, sum, cout);

input [7:0] a, b;
input cin;
output [7:0] sum;
output cout;
wire [7:0] p, g;
wire [6:0] c;

partial_full_adder p_adder_0(p[0], sum[0], g[0], a[0], b[0], cin);
assign c[0] = g[0] | (p[0] & cin);

genvar i;
generate
    for (i = 1; i < 8; i = i + 1) begin: adder_gen
        partial_full_adder p_adder(p[i], sum[i], g[i], a[i], b[i], c[i-1]);
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end
endgenerate

assign cout = g[7] | (p[7] & c[6]);

endmodule

module partial_full_adder(pi, si, gi, ai, bi, ci);
output pi, si, gi;
input ai, bi, ci;

assign pi = ai ^ bi;
assign si = pi ^ ci;
assign gi = ai & bi;

endmodule