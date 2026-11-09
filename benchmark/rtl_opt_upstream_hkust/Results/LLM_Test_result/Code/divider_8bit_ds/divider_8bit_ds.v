module divider_8bit_ds (
    input wire [7:0] A,
    input wire [3:0] B,
    output wire [7:0] result,
    output wire [7:0] odd
);

wire [8:0] temp_sub = {1'b0, A[7:4]} - {1'b0, B};
wire [8:0] temp_add = {1'b0, A[7:4]} + {1'b0, B};
wire [15:0] temp = {temp_sub[8] ? temp_add[7:0] : temp_sub[7:0], A[3:0]};

reg [15:0] temp_reg;
integer i;

always @(*) begin
    temp_reg = temp;
    
    for (i = 0; i < 8; i = i + 1) begin
        temp_reg = temp_reg << 1;
        
        if (temp_reg[15] == 1'b0) begin
            temp_reg[15:8] = temp_reg[15:8] - {4'b0, B};
        end else begin
            temp_reg[15:8] = temp_reg[15:8] + {4'b0, B};
        end
        
        temp_reg[0] = ~temp_reg[15];
    end
    
    if (temp_reg[15]) begin
        temp_reg[15:8] = temp_reg[15:8] + {4'b0, B};
    end
end

assign result = temp_reg[7:0];
assign odd = temp_reg[15:8];

endmodule