module adder_carry_ds(a,b,cin, sum, cout);

input [7:0]a, b;
input cin;
output [7:0] sum;
output cout;
wire [7:0]p,g;
wire [6:0]c;

// Optimized partial full adder for bit 0
assign p[0] = a[0] ^ b[0];
assign sum[0] = p[0] ^ cin;
assign g[0] = a[0] & b[0];
assign c[0] = g[0] | (p[0] & cin);

genvar i;
generate
    for(i=1; i<7 ; i=i+1) begin: adder_gen
        // Optimized partial full adder
        assign p[i] = a[i] ^ b[i];
        assign sum[i] = p[i] ^ c[i-1];
        assign g[i] = a[i] & b[i];
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end
endgenerate

// Optimized partial full adder for bit 7
assign p[7] = a[7] ^ b[7];
assign sum[7] = p[7] ^ c[6];
assign g[7] = a[7] & b[7];
assign cout = g[7] | (p[7] & c[6]);

endmodule