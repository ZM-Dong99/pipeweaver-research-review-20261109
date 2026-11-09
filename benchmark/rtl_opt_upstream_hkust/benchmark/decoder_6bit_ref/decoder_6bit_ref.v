module decoder_6bit_ref
 #(
    parameter N = 6
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    integer i;
    
    always @(*) begin
        out = {(1<<N){1'b0}}; // 默认全0
        for (i = 0; i < (1<<N); i = i + 1) begin
            if (in == i)
                out[i] = 1'b1;
        end
    end
endmodule