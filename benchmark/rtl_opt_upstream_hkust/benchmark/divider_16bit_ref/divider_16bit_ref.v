module divider_16bit_ref (
    input wire [15:0] A,     
    input wire [7:0] B,       
    output wire [15:0] result, 
    output wire [15:0] odd    
);

reg [31:0] tmp_a;  
reg [31:0] tmp_b;  
integer i;

always @(*) begin
    tmp_a = {16'b0, A}; 
    tmp_b = {B, 16'b0};  
    
    for (i = 0; i < 16; i = i + 1) begin
        tmp_a = tmp_a << 1;  
        
        if (tmp_a >= tmp_b) begin
            tmp_a = tmp_a - tmp_b + 1; 
        end
        else begin
            tmp_a = tmp_a;             
        end
    end
end

assign odd = tmp_a[31:16];    
assign result = tmp_a[15:0]; 

endmodule