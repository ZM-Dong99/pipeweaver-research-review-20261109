module decoder_8bit_ds #(
    parameter N = 8
) (
    input [N-1:0] in,
    output [(1<<N)-1:0] out
);
    
    assign out = 1'b1 << in;
endmodule