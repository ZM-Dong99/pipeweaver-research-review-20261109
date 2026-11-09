module divider_8bit_dsr (
    input wire [7:0] A,
    input wire [3:0] B,
    output wire [7:0] result,
    output wire [7:0] odd
);

reg [15:0] temp;

always @(*) begin
    reg [7:0] upper;
    reg [4:0] op_res;
    temp = {8'b0, A};

    // Unrolled iteration 0
    temp = temp << 1;
    upper = temp[15:8];
    if (temp[15]) begin
        op_res = upper[3:0] + B;
        temp[15:8] = {upper[7:4] + op_res[4], op_res[3:0]};
    end else begin
        op_res = upper[3:0] - B;
        temp[15:8] = {upper[7:4] - op_res[4], op_res[3:0]};
    end
    temp[0] = ~temp[15];

    // Unrolled iteration 1
    temp = temp << 1;
    upper = temp[15:8];
    if (temp[15]) begin
        op_res = upper[3:0] + B;
        temp[15:8] = {upper[7:4] + op_res[4], op_res[3:0]};
    end else begin
        op_res = upper[3:0] - B;
        temp[15:8] = {upper[7:4] - op_res[4], op_res[3:0]};
    end
    temp[0] = ~temp[15];

    // Unrolled iteration 2
    temp = temp << 1;
    upper = temp[15:8];
    if (temp[15]) begin
        op_res = upper[3:0] + B;
        temp[15:8] = {upper[7:4] + op_res[4], op_res[3:0]};
    end else begin
        op_res = upper[3:0] - B;
        temp[15:8] = {upper[7:4] - op_res[4], op_res[3:0]};
    end
    temp[0] = ~temp[15];

    // Unrolled iteration 3
    temp = temp << 1;
    upper = temp[15:8];
    if (temp[15]) begin
        op_res = upper[3:0] + B;
        temp[15:8] = {upper[7:4] + op_res[4], op_res[3:0]};
    end else begin
        op_res = upper[3:0] - B;
        temp[15:8] = {upper[7:4] - op_res[4], op_res[3:0]};
    end
    temp[0] = ~temp[15];

    // Unrolled iteration 4
    temp = temp << 1;
    upper = temp[15:8];
    if (temp[15]) begin
        op_res = upper[3:0] + B;
        temp[15:8] = {upper[7:4] + op_res[4], op_res[3:0]};
    end else begin
        op_res = upper[3:0] - B;
        temp[15:8] = {upper[7:4] - op_res[4], op_res[3:0]};
    end
    temp[0] = ~temp[15];

    // Unrolled iteration 5
    temp = temp << 1;
    upper = temp[15:8];
    if (temp[15]) begin
        op_res = upper[3:0] + B;
        temp[15:8] = {upper[7:4] + op_res[4], op_res[3:0]};
    end else begin
        op_res = upper[3:0] - B;
        temp[15:8] = {upper[7:4] - op_res[4], op_res[3:0]};
    end
    temp[0] = ~temp[15];

    // Unrolled iteration 6
    temp = temp << 1;
    upper = temp[15:8];
    if (temp[15]) begin
        op_res = upper[3:0] + B;
        temp[15:8] = {upper[7:4] + op_res[4], op_res[3:0]};
    end else begin
        op_res = upper[3:0] - B;
        temp[15:8] = {upper[7:4] - op_res[4], op_res[3:0]};
    end
    temp[0] = ~temp[15];

    // Unrolled iteration 7
    temp = temp << 1;
    upper = temp[15:8];
    if (temp[15]) begin
        op_res = upper[3:0] + B;
        temp[15:8] = {upper[7:4] + op_res[4], op_res[3:0]};
    end else begin
        op_res = upper[3:0] - B;
        temp[15:8] = {upper[7:4] - op_res[4], op_res[3:0]};
    end
    temp[0] = ~temp[15];

    // Final correction
    if (temp[15]) begin
        op_res = temp[15:8][3:0] + B;
        temp[15:8] = {temp[15:8][7:4] + op_res[4], op_res[3:0]};
    end
end

assign result = temp[7:0];
assign odd = temp[15:8];

endmodule