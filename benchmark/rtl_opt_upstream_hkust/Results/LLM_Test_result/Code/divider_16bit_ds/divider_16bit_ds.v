module divider_16bit_ds (
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

wire [15:0] B_ext = {8'b0, B};
reg [15:0] remainder;
reg [15:0] quotient;
reg [15:0] temp_remainder;
reg [15:0] temp_quotient;
integer i;

always @(*) begin
    remainder = 16'b0;
    quotient = A;
    
    for (i = 0; i < 16; i = i + 1) begin
        {remainder, quotient} = {remainder[14:0], quotient, 1'b0};
        
        temp_remainder = remainder[15] ? (remainder + B_ext) : (remainder - B_ext);
        temp_quotient = quotient | ~temp_remainder[15];
        
        remainder = temp_remainder;
        quotient = temp_quotient;
    end
    
    if (remainder[15]) begin
        remainder = remainder + B_ext;
    end
end

assign result = quotient;
assign odd = remainder;

endmodule