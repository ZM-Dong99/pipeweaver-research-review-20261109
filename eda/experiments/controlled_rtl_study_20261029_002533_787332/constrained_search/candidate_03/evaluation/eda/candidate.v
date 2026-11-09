module timing_adder(input wire clk, input wire rst_n, input wire [31:0] a, input wire [31:0] b, input wire [31:0] c, output reg [31:0] y);
reg [31:0] sum1, sum2; wire [31:0] ab_sum, c_sum;
grouped_adder32 add_ab(.a(a), .b(b), .sum(ab_sum));
grouped_adder32 add_c(.a(sum1), .b(c), .sum(c_sum));
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin sum1 <= 0; sum2 <= 0; y <= 0; end
  else begin sum1 <= ab_sum; sum2 <= c_sum; y <= sum2; end
end
endmodule

module grouped_adder32(input wire [31:0] a, b, output wire [31:0] sum);
wire [1:0] p, g; wire [2:0] carry;
wire [16:0] gen_0;
assign gen_0 = {1'b0, a[15:0]} + {1'b0, b[15:0]};
assign g[0] = gen_0[16];
assign p[0] = &(a[15:0] ^ b[15:0]);
wire [16:0] gen_1;
assign gen_1 = {1'b0, a[31:16]} + {1'b0, b[31:16]};
assign g[1] = gen_1[16];
assign p[1] = &(a[31:16] ^ b[31:16]);
assign carry[0] = 1'b0;
assign carry[1] = (g[0]);
assign carry[2] = (g[1]) | (p[1] & g[0]);
assign sum[15:0] = a[15:0] + b[15:0] + carry[0];
assign sum[31:16] = a[31:16] + b[31:16] + carry[1];
endmodule
