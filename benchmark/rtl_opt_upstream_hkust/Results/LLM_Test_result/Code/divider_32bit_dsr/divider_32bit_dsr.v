module divider_32bit_dsr (
    input wire [31:0] A,
    input wire [15:0] B,
    output wire [31:0] result,
    output wire [31:0] odd
);

reg [31:0] quotient;
reg [31:0] remainder;
integer i;

always @(*) begin
    remainder = 32'b0;
    quotient = A;
    
    for (i = 0; i < 32; i = i + 1) begin
        {remainder, quotient} = {remainder, quotient} << 1;
        
        reg [15:0] rh = remainder[31:16];
        reg [15:0] rl = remainder[15:0];
        reg [15:0] new_rh, new_rl;
        reg brw, cry;

        if (remainder[31]) begin
            {cry, new_rl} = rl + B;
            new_rh = rh + cry;
        end else begin
            {brw, new_rl} = rl - B;
            new_rh = rh - brw;
        end
        
        remainder = {new_rh, new_rl};
        quotient[0] = ~remainder[31];
    end

    if (remainder[31]) begin
        reg [15:0] crh = remainder[31:16];
        reg [15:0] crl = remainder[15:0];
        reg [15:0] new_crh;
        reg ccry;
        {ccry, crl} = crl + B;
        new_crh = crh + ccry;
        remainder = {new_crh, crl};
    end
end

assign result = quotient;
assign odd = remainder;

endmodule