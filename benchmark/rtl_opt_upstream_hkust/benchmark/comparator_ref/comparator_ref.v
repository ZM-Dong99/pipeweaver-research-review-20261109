module comparator_ref #(
    parameter N = 8              // Define parameter first
) (
    input [2:0] SEL,          // 3-bit selection signal
    input [N-1:0] value1,     // First comparison value
    input [N-1:0] value2,     // Second comparison value
    output reg OUT            // Comparison result output
);
           

always @(*) begin
    case (SEL)
        3'b000: OUT = 1'b0;             
        3'b001: OUT = 1'b1;              
        3'b010: OUT = (value1 == value2);  
        3'b011: OUT = (value1 != value2);  
        3'b100: OUT = (value1 >= value2);  
        3'b101: OUT = (value1 <= value2);  
        3'b110: OUT = (value1 < value2);   
        3'b111: OUT = (value1 > value2);   
        default: OUT = 1'b0;               
    endcase
end

endmodule