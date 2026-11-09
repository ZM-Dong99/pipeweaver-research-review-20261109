module divider_8bit_mini (
    input wire [7:0] A,       
    input wire [3:0] B,    
    output wire [7:0] result, 
    output wire [7:0] odd   
);

wire [15:0] B_ext = {12'b0, B};
wire [7:0] quotient;
wire [7:0] remainder;

reg [15:0] dividend;
reg [3:0] i;

always @* begin
    dividend = {8'b0, A};
    
    for (i = 0; i < 8; i = i + 1) begin
        dividend = dividend << 1;
        if (dividend[15:8] >= B) begin // Optimized comparison
            dividend[15:8] = dividend[15:8] - B;
            dividend[0] = 1'b1;
        end else begin
            dividend[0] = 1'b0;
        end
    end
end

assign result = dividend[7:0];
assign odd = dividend[15:8];

endmodule