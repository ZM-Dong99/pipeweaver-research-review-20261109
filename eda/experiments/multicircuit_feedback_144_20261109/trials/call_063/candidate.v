module decoder_8bit
#(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    generate
        if (N == 8) begin : g_predecode
            wire [15:0] low_miss;
            wire [15:0] high_miss;
            wire [255:0] decoded;

            for (genvar p = 0; p < 16; p = p + 1) begin : g_half
                localparam [3:0] CODE = p;
                assign low_miss[p] = |(in[3:0] ^ CODE);
                assign high_miss[p] = |(in[7:4] ^ CODE);
            end

            for (genvar h = 0; h < 16; h = h + 1) begin : g_high
                for (genvar l = 0; l < 16; l = l + 1) begin : g_low
                    assign decoded[16*h+l] = ~(high_miss[h] | low_miss[l]);
                end
            end

            always @(*) begin
                out = decoded;
            end
        end else begin : g_original
            always @(*) begin
                out = {{(1<<N)-1{1'b0}}, 1'b1} << in;
            end
        end
    endgenerate
endmodule
