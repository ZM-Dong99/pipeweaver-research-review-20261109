module decoder_6bit_gpt 
 #(
    parameter N = 6
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    
    always @(*) begin
        out = 1'b0; // Initialize out to 0
        out[in] = 1'b1; // Set the bit corresponding to the input value
    end
endmodule