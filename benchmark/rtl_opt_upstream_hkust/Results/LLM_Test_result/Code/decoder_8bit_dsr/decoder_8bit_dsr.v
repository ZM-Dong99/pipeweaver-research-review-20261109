module decoder_8bit_dsr #(
    parameter N = 8
) (
    input [N-1:0] in,
    output [(1<<N)-1:0] out
);

genvar i;
generate
    for (i = 0; i < (1 << N); i = i + 1) begin : gen_decoder
        assign out[i] = (in == i);
    end
endgenerate

endmodule