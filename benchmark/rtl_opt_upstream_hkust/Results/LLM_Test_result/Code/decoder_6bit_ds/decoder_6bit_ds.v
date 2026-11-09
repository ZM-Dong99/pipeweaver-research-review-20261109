module decoder_6bit_ds #(
    parameter N = 6
) (
    input [N-1:0] in,
    output [(1<<N)-1:0] out
);
    
    assign out = 1'b1 << in;
endmodule