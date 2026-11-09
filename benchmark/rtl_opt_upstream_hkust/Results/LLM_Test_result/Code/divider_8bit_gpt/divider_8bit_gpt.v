module divider_8bit_gpt (
    input wire [7:0] A,       
    input wire [3:0] B,    
    output wire [7:0] result, 
    output wire [7:0] odd   
);

reg [15:0] temp;  
integer i;

always @(*) begin
    temp = {8'b0, A};  
    
    for (i = 0; i < 8; i = i + 1) begin
        temp = temp << 1;
        
        temp[15:8] = (temp[15] == 1'b0) ? (temp[15:8] - {4'b0, B}) : (temp[15:8] + {4'b0, B});
        temp[0] = ~temp[15];
    end
    
    temp[15:8] = (temp[15] == 1'b1) ? (temp[15:8] + {4'b0, B}) : temp[15:8];
end

assign result = temp[7:0];  
assign odd = temp[15:8];   

endmodule