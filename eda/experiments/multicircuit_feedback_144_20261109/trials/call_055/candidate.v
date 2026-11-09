module decoder_8bit
#(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    generate
        if (N == 8) begin : g_decode8
            wire [15:0] low_mismatch;
            wire [15:0] high_mismatch;

            for (genvar p = 0; p < 16; p = p + 1) begin : g_predecode
                localparam [3:0] CODE = p;
                assign low_mismatch[p] = |(in[3:0] ^ CODE);
                assign high_mismatch[p] = |(in[7:4] ^ CODE);
            end

            integer k;
            always @(*) begin
                for (k = 0; k < 256; k = k + 1) begin
                    out[k] = ~(low_mismatch[k % 16] |
                               high_mismatch[k / 16]);
                end
            end
        end else begin : g_generic
            always @(*) begin
                out = {{(1<<N)-1{1'b0}}, 1'b1} << in;
            end
        end
    endgenerate
endmodule
