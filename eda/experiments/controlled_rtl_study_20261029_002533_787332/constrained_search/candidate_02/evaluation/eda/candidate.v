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
wire [3:0] p, g; wire [4:0] carry;
wire [8:0] gen_0;
assign gen_0 = {1'b0, a[7:0]} + {1'b0, b[7:0]};
assign g[0] = gen_0[8];
assign p[0] = &(a[7:0] ^ b[7:0]);
wire [8:0] gen_1;
assign gen_1 = {1'b0, a[15:8]} + {1'b0, b[15:8]};
assign g[1] = gen_1[8];
assign p[1] = &(a[15:8] ^ b[15:8]);
wire [8:0] gen_2;
assign gen_2 = {1'b0, a[23:16]} + {1'b0, b[23:16]};
assign g[2] = gen_2[8];
assign p[2] = &(a[23:16] ^ b[23:16]);
wire [8:0] gen_3;
assign gen_3 = {1'b0, a[31:24]} + {1'b0, b[31:24]};
assign g[3] = gen_3[8];
assign p[3] = &(a[31:24] ^ b[31:24]);
assign carry[0] = 1'b0;
assign carry[1] = (g[0]);
assign carry[2] = (g[1]) | (p[1] & g[0]);
assign carry[3] = (g[2]) | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
assign carry[4] = (g[3]) | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
assign sum[7:0] = a[7:0] + b[7:0] + carry[0];
assign sum[15:8] = a[15:8] + b[15:8] + carry[1];
assign sum[23:16] = a[23:16] + b[23:16] + carry[2];
assign sum[31:24] = a[31:24] + b[31:24] + carry[3];
endmodule
