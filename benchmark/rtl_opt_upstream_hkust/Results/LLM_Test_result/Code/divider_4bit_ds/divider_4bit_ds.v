module divider_4bit_ds (
    input wire [3:0] A,
    input wire [1:0] B,
    output wire [3:0] result,
    output wire [3:0] odd
);

wire [3:0] temp_high;
wire [3:0] temp_low;

assign {temp_high, temp_low} = {4'b0, A};

wire [3:0] step1_high = temp_high << 1 | temp_low[3];
wire [3:0] step1_low = temp_low << 1;
wire step1_sign = step1_high[3];
wire [3:0] step1_adj = step1_sign ? (step1_high + {2'b0, B}) : (step1_high - {2'b0, B});
wire [3:0] step1_res = {step1_adj[2:0], ~step1_adj[3]};

wire [3:0] step2_high = step1_res[3:1];
wire [3:0] step2_low = {step1_res[0], step1_low[2:0]};
wire step2_sign = step2_high[2];
wire [3:0] step2_adj = step2_sign ? ({1'b0, step2_high} + {2'b0, B}) : ({1'b0, step2_high} - {2'b0, B});
wire [3:0] step2_res = {step2_adj[2:0], ~step2_adj[3]};

wire [3:0] step3_high = step2_res[3:1];
wire [3:0] step3_low = {step2_res[0], step2_low[2:0]};
wire step3_sign = step3_high[2];
wire [3:0] step3_adj = step3_sign ? ({1'b0, step3_high} + {2'b0, B}) : ({1'b0, step3_high} - {2'b0, B});
wire [3:0] step3_res = {step3_adj[2:0], ~step3_adj[3]};

wire [3:0] step4_high = step3_res[3:1];
wire [3:0] step4_low = {step3_res[0], step3_low[2:0]};
wire step4_sign = step4_high[2];
wire [3:0] step4_adj = step4_sign ? ({1'b0, step4_high} + {2'b0, B}) : ({1'b0, step4_high} - {2'b0, B});
wire [3:0] step4_res = {step4_adj[2:0], ~step4_adj[3]};

wire final_sign = step4_res[3];
wire [3:0] final_high = final_sign ? (step4_res + {2'b0, B}) : step4_res;

assign result = {step4_res[0], step4_low[2:0]};
assign odd = final_high[3:0];

endmodule