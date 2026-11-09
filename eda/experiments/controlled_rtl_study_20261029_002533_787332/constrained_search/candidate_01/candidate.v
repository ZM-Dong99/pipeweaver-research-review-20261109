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
wire [7:0] p, g; wire [8:0] carry;
wire [4:0] gen_0;
assign gen_0 = {1'b0, a[3:0]} + {1'b0, b[3:0]};
assign g[0] = gen_0[4];
assign p[0] = &(a[3:0] ^ b[3:0]);
wire [4:0] gen_1;
assign gen_1 = {1'b0, a[7:4]} + {1'b0, b[7:4]};
assign g[1] = gen_1[4];
assign p[1] = &(a[7:4] ^ b[7:4]);
wire [4:0] gen_2;
assign gen_2 = {1'b0, a[11:8]} + {1'b0, b[11:8]};
assign g[2] = gen_2[4];
assign p[2] = &(a[11:8] ^ b[11:8]);
wire [4:0] gen_3;
assign gen_3 = {1'b0, a[15:12]} + {1'b0, b[15:12]};
assign g[3] = gen_3[4];
assign p[3] = &(a[15:12] ^ b[15:12]);
wire [4:0] gen_4;
assign gen_4 = {1'b0, a[19:16]} + {1'b0, b[19:16]};
assign g[4] = gen_4[4];
assign p[4] = &(a[19:16] ^ b[19:16]);
wire [4:0] gen_5;
assign gen_5 = {1'b0, a[23:20]} + {1'b0, b[23:20]};
assign g[5] = gen_5[4];
assign p[5] = &(a[23:20] ^ b[23:20]);
wire [4:0] gen_6;
assign gen_6 = {1'b0, a[27:24]} + {1'b0, b[27:24]};
assign g[6] = gen_6[4];
assign p[6] = &(a[27:24] ^ b[27:24]);
wire [4:0] gen_7;
assign gen_7 = {1'b0, a[31:28]} + {1'b0, b[31:28]};
assign g[7] = gen_7[4];
assign p[7] = &(a[31:28] ^ b[31:28]);
assign carry[0] = 1'b0;
assign carry[1] = (g[0]);
assign carry[2] = (g[1]) | (p[1] & g[0]);
assign carry[3] = (g[2]) | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
assign carry[4] = (g[3]) | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
assign carry[5] = (g[4]) | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]);
assign carry[6] = (g[5]) | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) | (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]);
assign carry[7] = (g[6]) | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) | (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]);
assign carry[8] = (g[7]) | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]) | (p[7] & p[6] & p[5] & p[4] & g[3]) | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]);
assign sum[3:0] = a[3:0] + b[3:0] + carry[0];
assign sum[7:4] = a[7:4] + b[7:4] + carry[1];
assign sum[11:8] = a[11:8] + b[11:8] + carry[2];
assign sum[15:12] = a[15:12] + b[15:12] + carry[3];
assign sum[19:16] = a[19:16] + b[19:16] + carry[4];
assign sum[23:20] = a[23:20] + b[23:20] + carry[5];
assign sum[27:24] = a[27:24] + b[27:24] + carry[6];
assign sum[31:28] = a[31:28] + b[31:28] + carry[7];
endmodule
