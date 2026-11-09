`default_nettype none
module crc32_d8(input wire [7:0] data_in, input wire [31:0] state_in, output wire [7:0] data_out, output wire [31:0] state_out);
wire [31:0] s0;
wire [31:0] s1;
wire [31:0] s2;
wire [31:0] s3;
wire [31:0] s4;
wire [31:0] s5;
wire [31:0] s6;
wire [31:0] s7;
wire [31:0] s8;
assign s0 = state_in;
assign s1 = {s0[30:0],1'b0} ^ ({32{s0[31]}} & 32'h04c11db6) | {{31{1'b0}},s0[31]};
assign s2 = {s1[30:0],1'b0} ^ ({32{s1[31]}} & 32'h04c11db6) | {{31{1'b0}},s1[31]};
assign s3 = {s2[30:0],1'b0} ^ ({32{s2[31]}} & 32'h04c11db6) | {{31{1'b0}},s2[31]};
assign s4 = {s3[30:0],1'b0} ^ ({32{s3[31]}} & 32'h04c11db6) | {{31{1'b0}},s3[31]};
assign s5 = {s4[30:0],1'b0} ^ ({32{s4[31]}} & 32'h04c11db6) | {{31{1'b0}},s4[31]};
assign s6 = {s5[30:0],1'b0} ^ ({32{s5[31]}} & 32'h04c11db6) | {{31{1'b0}},s5[31]};
assign s7 = {s6[30:0],1'b0} ^ ({32{s6[31]}} & 32'h04c11db6) | {{31{1'b0}},s6[31]};
assign s8 = {s7[30:0],1'b0} ^ ({32{s7[31]}} & 32'h04c11db6) | {{31{1'b0}},s7[31]};
assign data_out[0] = data_in[0] ^ s0[31];
assign data_out[1] = data_in[1] ^ s1[31];
assign data_out[2] = data_in[2] ^ s2[31];
assign data_out[3] = data_in[3] ^ s3[31];
assign data_out[4] = data_in[4] ^ s4[31];
assign data_out[5] = data_in[5] ^ s5[31];
assign data_out[6] = data_in[6] ^ s6[31];
assign data_out[7] = data_in[7] ^ s7[31];
assign state_out = {s8[0],s8[1],s8[2],s8[3],s8[4],s8[5],s8[6],s8[7],s8[8],s8[9],s8[10],s8[11],s8[12],s8[13],s8[14],s8[15],s8[16],s8[17],s8[18],s8[19],s8[20],s8[21],s8[22],s8[23],s8[24],s8[25],s8[26],s8[27],s8[28],s8[29],s8[30],s8[31]};
endmodule
`default_nettype wire
