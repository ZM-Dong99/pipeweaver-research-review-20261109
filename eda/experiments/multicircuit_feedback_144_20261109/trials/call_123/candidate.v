module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    wire [3:0] low_pair0;
    wire [3:0] low_pair1;
    wire [3:0] high_pair0;
    wire [3:0] high_pair1;
    wire [15:0] low_dec;
    wire [15:0] high_dec;
    wire [255:0] decoded;

    genvar p;
    generate
        for (p = 0; p < 4; p = p + 1) begin : gen_pair_decode
            assign low_pair0[p]  = (p & 1) ? in[0] : ~in[0];
            assign low_pair1[p]  = (p & 1) ? in[2] : ~in[2];
            assign high_pair0[p] = (p & 1) ? in[4] : ~in[4];
            assign high_pair1[p] = (p & 1) ? in[6] : ~in[6];
        end
    endgenerate

    genvar q;
    generate
        for (q = 0; q < 16; q = q + 1) begin : gen_nibble_decode
            assign low_dec[q]  = low_pair0[q % 4] & low_pair1[q / 4];
            assign high_dec[q] = high_pair0[q % 4] & high_pair1[q / 4];
        end
    endgenerate

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
