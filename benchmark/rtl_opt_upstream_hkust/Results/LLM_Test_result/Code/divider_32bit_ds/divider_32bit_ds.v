module divider_32bit_ds (
    input wire [31:0] A,
    input wire [15:0] B,
    output wire [31:0] result,
    output wire [31:0] odd
);

wire [31:0] B_ext = {16'b0, B};
reg [31:0] quotient;
reg [31:0] remainder;
reg [31:0] temp_remainder;
integer i;

always @(*) begin
    remainder = 32'b0;
    temp_remainder = A;

    for (i = 0; i < 32; i = i + 1) begin
        remainder = {remainder[30:0], temp_remainder[31]};
        temp_remainder = {temp_remainder[30:0], 1'b0};

        if (remainder[31] == 1'b0) begin
            remainder = remainder - B_ext;
        end else begin
            remainder = remainder + B_ext;
        end

        quotient = {quotient[30:0], ~remainder[31]};
    end

    if (remainder[31] == 1'b1) begin
        remainder = remainder + B_ext;
    end
end

assign result = quotient;
assign odd = remainder;

endmodule