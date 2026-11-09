module add_sub_ds (
    input [15:0] a, b,    
    input control,        
    output [15:0] result 
);

    assign result = control ? (a + b) : (a - b);

endmodule