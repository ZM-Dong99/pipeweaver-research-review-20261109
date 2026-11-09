module divider_32bit_ref (
    input wire [31:0] A,       
    input wire [15:0] B,        
    output wire [31:0] result,  
    output wire [31:0] odd      
);

reg [63:0] tmp_a;  
reg [63:0] tmp_b;  
integer i;

always @(*) begin
    tmp_a = {32'b0, A};  
    tmp_b = {B, 32'b0};  
    
    for (i = 0; i < 32; i = i + 1) begin
        tmp_a = tmp_a << 1;  
        
        if (tmp_a >= tmp_b) begin
            tmp_a = tmp_a - tmp_b + 1;  
        end
        else begin
            tmp_a = tmp_a;              
        end
    end
end

assign odd = tmp_a[63:32];    
assign result = tmp_a[31:0];  

endmodule