module divider_4bit_gpt (
    input wire [3:0] A,      
    input wire [1:0] B,       
    output wire [3:0] result, 
    output wire [3:0] odd    
);

reg [7:0] temp;  

always @(*) begin
    temp = {4'b0, A};  
    
    for (integer i = 0; i < 4; i = i + 1) begin
        temp = temp << 1;

        if (temp[7] == 1'b0) begin 
            temp[7:4] = temp[7:4] - {2'b0, B};
        end else begin               
            temp[7:4] = temp[7:4] + {2'b0, B};
        end
        
        temp[0] = ~temp[7];
    end
    
    if (temp[7]) begin
        temp[7:4] = temp[7:4] + {2'b0, B};
    end
end

assign result = temp[3:0];  
assign odd = temp[7:4];     

endmodule