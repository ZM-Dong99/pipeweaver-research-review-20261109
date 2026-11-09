module crc32_d32(input wire [31:0] data_in,input wire [31:0] state_in,output wire [31:0] data_out,output wire [31:0] state_out);
wire [31:0] s[0:32]; assign s[0]=state_in;
genvar i; generate for(i=0;i<32;i=i+1) begin: step
wire feedback=s[i][0]^data_in[i];
assign s[i+1]=(s[i]>>1)^({32{feedback}} & 32'hedb88320);
assign data_out[i]=feedback;
end endgenerate
assign state_out=s[32];
endmodule
