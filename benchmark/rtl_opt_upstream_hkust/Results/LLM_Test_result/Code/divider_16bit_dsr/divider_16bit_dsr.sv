module divider_16bit_dsr (
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

reg [31:0] temp;
wire [15:0] B_ext = {8'b0, B};

always @(*) begin
    temp = {16'b0, A};
    for (integer i=0; i<16; i=i+1) begin:unrolled_loop
        temp = temp << 1;
        temp[31:16] = temp[31] ? temp[31:16] + B_ext : temp[31:16] - B_ext;
        temp[0] = ~temp[31];
    end
    
    if (temp[31]) begin
        temp[31:16] = temp[31:16] + B_ext;
    end
end

assign result = temp[15:0];
assign odd = temp[31:16];

endmodule