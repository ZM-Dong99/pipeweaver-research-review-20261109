module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    wire [15:0] low_decode;
    wire [15:0] high_decode;
    wire [255:0] decoded;

    assign low_decode  = 16'b1 << in[3:0];
    assign high_decode = 16'b1 << in[7:4];

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : gen_decode
            assign decoded[i] = low_decode[i % 16] & high_decode[i / 16];
        end
    endgenerate

    always @(*) begin
        out = decoded;
    end
endmodule
