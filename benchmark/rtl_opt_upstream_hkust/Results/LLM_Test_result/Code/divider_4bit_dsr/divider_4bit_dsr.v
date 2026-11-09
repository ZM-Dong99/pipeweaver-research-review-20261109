module divider_4bit_dsr (
    input wire [3:0] A,
    input wire [1:0] B,
    output wire [3:0] result,
    output wire [3:0] odd
);

reg [7:0] temp;
reg [3:0] B_ext;

always @(*) begin
    B_ext = {2'b00, B};
    temp = {4'b0, A};

    // Stage 0
    temp = temp << 1;
    temp[7:4] = (temp[7] ? temp[7:4] + B_ext : temp[7:4] - B_ext);
    temp[0] = ~temp[7];

    // Stage 1
    temp = temp << 1;
    temp[7:4] = (temp[7] ? temp[7:4] + B_ext : temp[7:4] - B_ext);
    temp[0] = ~temp[7];

    // Stage 2
    temp = temp << 1;
    temp[7:4] = (temp[7] ? temp[7:4] + B_ext : temp[7:4] - B_ext);
    temp[0] = ~temp[7];

    // Stage 3
    temp = temp << 1;
    temp[7:4] = (temp[7] ? temp[7:4] + B_ext : temp[7:4] - B_ext);
    temp[0] = ~temp[7];

    // Final correction
    if (temp[7]) temp[7:4] = temp[7:4] + B_ext;
end

assign result = temp[3:0];
assign odd = temp[7:4];

endmodule