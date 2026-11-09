module decoder_8bit
#(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    generate
        if (N == 8) begin : gen_decode8
            wire [15:0] low_miss;
            wire [15:0] high_miss;
            wire [255:0] decoded;

            for (genvar p = 0; p < 16; p = p + 1) begin : gen_predecode
                localparam [3:0] CODE = p;
                assign low_miss[p] = |(in[3:0] ^ CODE);
                assign high_miss[p] = |(in[7:4] ^ CODE);
            end

            for (genvar q = 0; q < 256; q = q + 1) begin : gen_outputs
                assign decoded[q] = ~(high_miss[q / 16] | low_miss[q % 16]);
            end

            always @(*) begin
                out = decoded;
            end
        end else begin : gen_other_width
            always @(*) begin
                out = {{(1<<N)-1{1'b0}}, 1'b1} << in;
            end
        end
    endgenerate
endmodule
