module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    generate
        if (N == 8) begin : g_fast8
            (* keep = 1 *) wire [15:0] low_mismatch;
            (* keep = 1 *) wire [15:0] high_mismatch;
            wire [255:0] decoded;
            for (genvar k = 0; k < 16; k = k + 1) begin : g_predecode
                localparam [3:0] VALUE = k;
                assign low_mismatch[k] = |(in[3:0] ^ VALUE);
                assign high_mismatch[k] = |(in[7:4] ^ VALUE);
            end
            for (genvar h = 0; h < 16; h = h + 1) begin : g_high
                for (genvar l = 0; l < 16; l = l + 1) begin : g_low
                    assign decoded[16*h+l] = ~(high_mismatch[h] | low_mismatch[l]);
                end
            end
            always @(*) begin
                out = decoded;
            end
        end else begin : g_generic
            always @(*) begin
                out = {{(1<<N)-1{1'b0}}, 1'b1} << in;
            end
        end
    endgenerate
endmodule
