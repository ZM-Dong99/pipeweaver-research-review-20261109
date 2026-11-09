module crc32_d8(input wire [7:0] data_in, input wire [31:0] state_in, output wire [7:0] data_out, output wire [31:0] state_out);
function [31:0] crc_step;
    input [31:0] state;
    input data_bit;
    reg feedback;
    integer i;
    begin
        feedback = state[31] ^ data_bit;
        crc_step[0] = feedback;
        for (i = 1; i < 32; i = i + 1) begin
            if ((32'h04c11db7 >> i) & 1)
                crc_step[i] = state[i-1] ^ feedback;
            else
                crc_step[i] = state[i-1];
        end
    end
endfunction
wire [31:0] s0 = {state_in[0],state_in[1],state_in[2],state_in[3],state_in[4],state_in[5],state_in[6],state_in[7],state_in[8],state_in[9],state_in[10],state_in[11],state_in[12],state_in[13],state_in[14],state_in[15],state_in[16],state_in[17],state_in[18],state_in[19],state_in[20],state_in[21],state_in[22],state_in[23],state_in[24],state_in[25],state_in[26],state_in[27],state_in[28],state_in[29],state_in[30],state_in[31]};
wire [31:0] s1 = crc_step(s0, data_in[0]);
wire [31:0] s2 = crc_step(s1, data_in[1]);
wire [31:0] s3 = crc_step(s2, data_in[2]);
wire [31:0] s4 = crc_step(s3, data_in[3]);
wire [31:0] s5 = crc_step(s4, data_in[4]);
wire [31:0] s6 = crc_step(s5, data_in[5]);
wire [31:0] s7 = crc_step(s6, data_in[6]);
wire [31:0] s8 = crc_step(s7, data_in[7]);
assign data_out[0] = s0[31] ^ data_in[0];
assign data_out[1] = s1[31] ^ data_in[1];
assign data_out[2] = s2[31] ^ data_in[2];
assign data_out[3] = s3[31] ^ data_in[3];
assign data_out[4] = s4[31] ^ data_in[4];
assign data_out[5] = s5[31] ^ data_in[5];
assign data_out[6] = s6[31] ^ data_in[6];
assign data_out[7] = s7[31] ^ data_in[7];
assign state_out = {s8[0],s8[1],s8[2],s8[3],s8[4],s8[5],s8[6],s8[7],s8[8],s8[9],s8[10],s8[11],s8[12],s8[13],s8[14],s8[15],s8[16],s8[17],s8[18],s8[19],s8[20],s8[21],s8[22],s8[23],s8[24],s8[25],s8[26],s8[27],s8[28],s8[29],s8[30],s8[31]};
endmodule
