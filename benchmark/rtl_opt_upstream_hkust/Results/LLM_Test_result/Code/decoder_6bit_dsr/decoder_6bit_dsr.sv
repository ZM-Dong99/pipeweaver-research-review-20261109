module decoder_6bit_dsr 
 #(
    parameter N = 6
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    
    always @(*) begin
        for (integer i=0; i<(1<<N); i=i+1)
            out[i] = (i == in);
    end
endmodule