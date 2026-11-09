module adder_carry_dsr(a,b,cin, sum, cout);
input [7:0]a, b;
input cin;
output [7:0] sum;
output cout;

wire [7:0]p,g;
wire [7:0]c;

// Optimized carry computation and inline partial adder logic
assign p[0] = a[0] ^ b[0];
assign sum[0] = p[0] ^ cin;
assign g[0] = a[0] & b[0];
assign c[0] = g[0] | (p[0] & cin);

genvar i;
generate
    for(i=1; i<8; i=i+1) begin: adder_gen
        assign p[i] = a[i] ^ b[i];
        assign sum[i] = p[i] ^ c[i-1];
        assign g[i] = a[i] & b[i];
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end
endgenerate

assign cout = c[7];
endmodule