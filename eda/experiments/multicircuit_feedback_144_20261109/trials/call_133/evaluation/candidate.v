`default_nettype none
module crc32_d8(input wire [7:0] data_in, input wire [31:0] state_in, output wire [7:0] data_out, output wire [31:0] state_out);

function [31:0] reverse32;
    input [31:0] value;
    integer i;
    begin
        for (i = 0; i < 32; i = i + 1)
            reverse32[i] = value[31-i];
    end
endfunction

function [31:0] crc_step;
    input [31:0] state;
    input feedback;
    begin
        crc_step = {state[30:0], feedback} ^ ({32{feedback}} & 32'h04c11db6);
    end
endfunction

wire [31:0] s0;
wire [31:0] s1;
wire [31:0] s2;
wire [31:0] s3;
wire [31:0] s4;
wire [31:0] s5;
wire [31:0] s6;
wire [31:0] s7;
wire [31:0] s8;
wire q0;
wire q1;
wire q2;
wire q3;
wire q4;
wire q5;
wire q6;
wire q7;

assign s0 = reverse32(state_in);
assign q0 = s0[31] ^ data_in[7];
assign s1 = crc_step(s0, q0);
assign q1 = s1[31] ^ data_in[6];
assign s2 = crc_step(s1, q1);
assign q2 = s2[31] ^ data_in[5];
assign s3 = crc_step(s2, q2);
assign q3 = s3[31] ^ data_in[4];
assign s4 = crc_step(s3, q3);
assign q4 = s4[31] ^ data_in[3];
assign s5 = crc_step(s4, q4);
assign q5 = s5[31] ^ data_in[2];
assign s6 = crc_step(s5, q5);
assign q6 = s6[31] ^ data_in[1];
assign s7 = crc_step(s6, q6);
assign q7 = s7[31] ^ data_in[0];
assign s8 = crc_step(s7, q7);

assign data_out[0] = q0;
assign data_out[1] = q1;
assign data_out[2] = q2;
assign data_out[3] = q3;
assign data_out[4] = q4;
assign data_out[5] = q5;
assign data_out[6] = q6;
assign data_out[7] = q7;
assign state_out = reverse32(s8);

endmodule
`default_nettype wire
