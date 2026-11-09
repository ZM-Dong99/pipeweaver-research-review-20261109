module add_sub_dsr (
    input [15:0] a, b,    
    input control,        
    output reg [15:0] result 
);

    always @(*) begin
        result = a + (b ^ {16{~control}}) + ~control;
    end

endmodule