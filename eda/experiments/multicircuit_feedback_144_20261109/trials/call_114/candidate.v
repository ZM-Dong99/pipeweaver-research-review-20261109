module decoder_8bit
#(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    generate
        if (N == 8) begin : g_decode8
            wire [15:0] low_n;
            wire [15:0] high_n;

            for (genvar p = 0; p < 16; p = p + 1) begin : g_predecode
                assign low_n[p]  = ~(in[3:0] == p);
                assign high_n[p] = ~(in[7:4] == p);
            end

            for (genvar q = 0; q < 256; q = q + 1) begin : g_output
                always @(*) begin
                    out[q] = ~(low_n[q % 16] | high_n[q / 16]);
                end
            end
        end else begin : g_other_width
            always @(*) begin
                out = {{(1<<N)-1{1'b0}}, 1'b1} << in;
            end
        end
    endgenerate
endmodule
