module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    wire [3:0] dec0;
    wire [3:0] dec1;
    wire [3:0] dec2;
    wire [3:0] dec3;
    integer i;

    assign dec0[0] = ~in[1] & ~in[0];
    assign dec0[1] = ~in[1] &  in[0];
    assign dec0[2] =  in[1] & ~in[0];
    assign dec0[3] =  in[1] &  in[0];

    assign dec1[0] = ~in[3] & ~in[2];
    assign dec1[1] = ~in[3] &  in[2];
    assign dec1[2] =  in[3] & ~in[2];
    assign dec1[3] =  in[3] &  in[2];

    assign dec2[0] = ~in[5] & ~in[4];
    assign dec2[1] = ~in[5] &  in[4];
    assign dec2[2] =  in[5] & ~in[4];
    assign dec2[3] =  in[5] &  in[4];

    assign dec3[0] = ~in[7] & ~in[6];
    assign dec3[1] = ~in[7] &  in[6];
    assign dec3[2] =  in[7] & ~in[6];
    assign dec3[3] =  in[7] &  in[6];

    always @(*) begin
        out = '0;
        for (i = 0; i < (1 << N); i = i + 1)
            out[i] = dec3[(i >> 6) & 3] &
                     dec2[(i >> 4) & 3] &
                     dec1[(i >> 2) & 3] &
                     dec0[i & 3];
    end
endmodule
