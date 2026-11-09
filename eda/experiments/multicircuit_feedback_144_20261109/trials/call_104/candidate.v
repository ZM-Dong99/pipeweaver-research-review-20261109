module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    wire [3:0] low_pair;
    wire [3:0] low_pair_hi;
    wire [3:0] high_pair;
    wire [3:0] high_pair_hi;
    wire [15:0] low_dec;
    wire [15:0] high_dec;
    wire [(1<<N)-1:0] decoded;

    decoder_2bit u_low_pair (
        .in(in[1:0]),
        .out(low_pair)
    );

    decoder_2bit u_low_pair_hi (
        .in(in[3:2]),
        .out(low_pair_hi)
    );

    decoder_2bit u_high_pair (
        .in(in[5:4]),
        .out(high_pair)
    );

    decoder_2bit u_high_pair_hi (
        .in(in[7:6]),
        .out(high_pair_hi)
    );

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_low_decode
            assign low_dec[i] = low_pair_hi[i/4] & low_pair[i%4];
            assign high_dec[i] = high_pair_hi[i/4] & high_pair[i%4];
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < 256; j = j + 1) begin : gen_output_decode
            assign decoded[j] = high_dec[j/16] & low_dec[j%16];
        end
    endgenerate

    always @(*) begin
        out = decoded;
    end
endmodule

module decoder_2bit (
    input [1:0] in,
    output [3:0] out
);
    assign out[0] = ~in[1] & ~in[0];
    assign out[1] = ~in[1] &  in[0];
    assign out[2] =  in[1] & ~in[0];
    assign out[3] =  in[1] &  in[0];
endmodule
