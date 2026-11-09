module divider_8bit_ref (
    input wire [7:0] A,       
    input wire [3:0] B,       
    output wire [7:0] result, 
    output wire [7:0] odd     
);

reg [7:0] a_reg;
reg [3:0] b_reg;
reg [15:0] tmp_a;  
reg [15:0] tmp_b; 
integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    tmp_a = {8'b0, a_reg};  
    tmp_b = {b_reg, 8'b0};  
    
    for (i = 0; i < 8; i = i + 1) begin
        tmp_a = tmp_a << 1;  
        
        if (tmp_a >= tmp_b) begin
            tmp_a = tmp_a - tmp_b + 1;  
        end
        else begin
            tmp_a = tmp_a;              
        end
    end
end

assign odd = tmp_a[15:8];    
assign result = tmp_a[7:0];  

endmodule