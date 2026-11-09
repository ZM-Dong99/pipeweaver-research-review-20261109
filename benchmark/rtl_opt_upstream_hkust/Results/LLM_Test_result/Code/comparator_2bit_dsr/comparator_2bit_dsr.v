module comparator_2bit_dsr (
    input [1:0] A, B,
    output eq, gt, lt
);
    assign {eq, gt, lt} = (A == B) ? 3'b100 : 
                          (A > B)  ? 3'b010 : 
                                      3'b001;
endmodule