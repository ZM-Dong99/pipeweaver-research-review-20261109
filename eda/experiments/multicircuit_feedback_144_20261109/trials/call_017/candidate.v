module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    wire [3:0] p0;
    wire [3:0] p1;
    wire [3:0] p2;
    wire [3:0] p3;
    wire [255:0] decoded;

    assign p0[0] = ~in[1] & ~in[0];
    assign p0[1] = ~in[1] &  in[0];
    assign p0[2] =  in[1] & ~in[0];
    assign p0[3] =  in[1] &  in[0];

    assign p1[0] = ~in[3] & ~in[2];
    assign p1[1] = ~in[3] &  in[2];
    assign p1[2] =  in[3] & ~in[2];
    assign p1[3] =  in[3] &  in[2];

    assign p2[0] = ~in[5] & ~in[4];
    assign p2[1] = ~in[5] &  in[4];
    assign p2[2] =  in[5] & ~in[4];
    assign p2[3] =  in[5] &  in[4];

    assign p3[0] = ~in[7] & ~in[6];
    assign p3[1] = ~in[7] &  in[6];
    assign p3[2] =  in[7] & ~in[6];
    assign p3[3] =  in[7] &  in[6];

    genvar g0, g1, g2, g3;
    generate
        for (g3 = 0; g3 < 4; g3 = g3 + 1) begin : gen_g3
            for (g2 = 0; g2 < 4; g2 = g2 + 1) begin : gen_g2
                for (g1 = 0; g1 < 4; g1 = g1 + 1) begin : gen_g1
                    for (g0 = 0; g0 < 4; g0 = g0 + 1) begin : gen_g0
                        assign decoded[(g3*64)+(g2*16)+(g1*4)+g0] = p3[g3] & p2[g2] & p1[g1] & p0[g0];
                    end
                end
            end
        end
    endgenerate

    always @(*) begin
        out = decoded;
    end
endmodule
