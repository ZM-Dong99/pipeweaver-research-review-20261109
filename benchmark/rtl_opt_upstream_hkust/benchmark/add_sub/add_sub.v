module add_sub (
    input [15:0] a, b,    
    input control,        
    output reg [15:0] result 
);

    always @(*) begin
        if (control == 1'b1)
            result = a + b; 
        else
            result = a - b; 
    end

endmodule