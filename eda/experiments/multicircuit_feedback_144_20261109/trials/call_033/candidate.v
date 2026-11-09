module decoder_8bit
 #(
    parameter N = 8
) (
    input [N-1:0] in,
    output reg [(1<<N)-1:0] out
);
    reg [15:0] low_onehot;

    always @(*) begin
        low_onehot = 16'b1 << in[3:0];
        out = {{(1<<N)-1{1'b0}}, 1'b0};
        case (in[7:4])
            4'h0: out[15:0]    = low_onehot;
            4'h1: out[31:16]   = low_onehot;
            4'h2: out[47:32]   = low_onehot;
            4'h3: out[63:48]   = low_onehot;
            4'h4: out[79:64]   = low_onehot;
            4'h5: out[95:80]   = low_onehot;
            4'h6: out[111:96]  = low_onehot;
            4'h7: out[127:112] = low_onehot;
            4'h8: out[143:128] = low_onehot;
            4'h9: out[159:144] = low_onehot;
            4'hA: out[175:160] = low_onehot;
            4'hB: out[191:176] = low_onehot;
            4'hC: out[207:192] = low_onehot;
            4'hD: out[223:208] = low_onehot;
            4'hE: out[239:224] = low_onehot;
            4'hF: out[255:240] = low_onehot;
            default: ;
        endcase
    end
endmodule
