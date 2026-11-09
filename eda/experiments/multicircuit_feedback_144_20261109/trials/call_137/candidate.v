module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    wire [3:0] p0;
    wire [7:0] p1;
    wire [7:0] p2;
    wire [31:0] lower;
    wire [255:0] decoded;

    assign p0[0] = ~in[1] & ~in[0];
    assign p0[1] = ~in[1] &  in[0];
    assign p0[2] =  in[1] & ~in[0];
    assign p0[3] =  in[1] &  in[0];

    assign p1[0] = ~in[4] & ~in[3] & ~in[2];
    assign p1[1] = ~in[4] & ~in[3] &  in[2];
    assign p1[2] = ~in[4] &  in[3] & ~in[2];
    assign p1[3] = ~in[4] &  in[3] &  in[2];
    assign p1[4] =  in[4] & ~in[3] & ~in[2];
    assign p1[5] =  in[4] & ~in[3] &  in[2];
    assign p1[6] =  in[4] &  in[3] & ~in[2];
    assign p1[7] =  in[4] &  in[3] &  in[2];

    assign p2[0] = ~in[7] & ~in[6] & ~in[5];
    assign p2[1] = ~in[7] & ~in[6] &  in[5];
    assign p2[2] = ~in[7] &  in[6] & ~in[5];
    assign p2[3] = ~in[7] &  in[6] &  in[5];
    assign p2[4] =  in[7] & ~in[6] & ~in[5];
    assign p2[5] =  in[7] & ~in[6] &  in[5];
    assign p2[6] =  in[7] &  in[6] & ~in[5];
    assign p2[7] =  in[7] &  in[6] &  in[5];

    genvar g0, g1, g2;
    generate
        for (g1 = 0; g1 < 8; g1 = g1 + 1) begin : gen_lower_group
            for (g0 = 0; g0 < 4; g0 = g0 + 1) begin : gen_lower_bit
                assign lower[g1*4+g0] = p1[g1] & p0[g0];
            end
        end
        for (g2 = 0; g2 < 8; g2 = g2 + 1) begin : gen_upper_group
            for (g1 = 0; g1 < 8; g1 = g1 + 1) begin : gen_output_group
                assign decoded[g2*32+g1] = p2[g2] & lower[g1];
            end
        end
    endgenerate

    always @(*) begin
        out = decoded;
    end
endmodule
