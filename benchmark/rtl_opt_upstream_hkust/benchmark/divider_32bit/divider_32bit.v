module divider_32bit (
    input wire [31:0] A,       
    input wire [15:0] B,        
    output wire [31:0] result,  
    output wire [31:0] odd      
);

reg [63:0] temp;  
integer i;

always @(*) begin
    temp = {32'b0, A};  
    
    for (i = 0; i < 32; i = i + 1) begin
        temp = temp << 1;  
        
        if (temp[63] == 1'b0) begin  
            temp[63:32] = temp[63:32] - {16'b0, B};
        end 
        else begin                  
            temp[63:32] = temp[63:32] + {16'b0, B};
        end
        
        
        temp[0] = ~temp[63];
    end
    
    
    if (temp[63] == 1'b1) begin
        temp[63:32] = temp[63:32] + {16'b0, B};
    end
end

assign result = temp[31:0];  
assign odd = temp[63:32];   

endmodule