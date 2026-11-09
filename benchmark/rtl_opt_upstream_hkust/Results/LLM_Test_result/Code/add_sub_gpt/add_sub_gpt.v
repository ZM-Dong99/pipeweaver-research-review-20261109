module add_sub_gpt (
    input [15:0] a, b,    
    input control,        
    output reg [15:0] result 
);

    always @(*) begin
        result = (control) ? (a + b) : (a - b); 
    end

endmodule