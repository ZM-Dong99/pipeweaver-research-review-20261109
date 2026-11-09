module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    generate
        if (N == 8) begin : gen_fast_decode
            wire [3:0] pre0;
            wire [3:0] pre1;
            wire [3:0] pre2;
            wire [3:0] pre3;
            wire [15:0] low_n;
            wire [15:0] high_n;
            wire [255:0] decoded;

            for (genvar j = 0; j < 4; j = j + 1) begin : gen_predecode
                localparam [1:0] VALUE = j;
                assign pre0[j] = (in[1:0] == VALUE);
                assign pre1[j] = (in[3:2] == VALUE);
                assign pre2[j] = (in[5:4] == VALUE);
                assign pre3[j] = (in[7:6] == VALUE);
            end

            for (genvar k = 0; k < 16; k = k + 1) begin : gen_nibble
                assign low_n[k] = ~(pre1[k/4] & pre0[k%4]);
                assign high_n[k] = ~(pre3[k/4] & pre2[k%4]);
            end

            for (genvar i = 0; i < 256; i = i + 1) begin : gen_output
                assign decoded[i] = ~(high_n[i/16] | low_n[i%16]);
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
