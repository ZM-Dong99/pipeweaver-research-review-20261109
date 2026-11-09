//Carry lookahead adder -8bit inputs

module adder_carry_mini(a,b,cin, sum, cout);

input [7:0]a, b;
input cin;
output [7:0] sum;
output cout;
wire [7:0]p,g;
wire [7:0]c; // Increase size of c to simplify logic

assign p = a ^ b;
assign g = a & b;

assign c[0] = g[0] | (p[0] & cin);

genvar        i ;
generate
    for(i=1; i<8 ; i=i+1) begin: carry_gen
    assign c[i] = g[i] | (p[i] & c[i-1]);
    end
endgenerate

assign sum = p ^ {c[6:0], cin}; // Use carry directly for sum calculation
assign cout = c[7];

endmodule