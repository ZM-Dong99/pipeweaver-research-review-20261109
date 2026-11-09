module decoder_8bit_gpt 
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    
    always @(*) begin
        out = 1 << in;
    end
endmodule