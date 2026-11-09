module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    wire [15:0] low_dec;
    wire [15:0] high_dec;
    wire [255:0] decoded;

    assign low_dec = 16'b1 << in[3:0];
    assign high_dec = 16'b1 << in[7:4];

    genvar k;
    generate
        for (k = 0; k < 256; k = k + 1) begin : gen_decode
            assign decoded[k] = low_dec[k % 16] & high_dec[k / 16];
        end
    endgenerate

    always @(*) begin
        out = decoded;
    end
endmodule
