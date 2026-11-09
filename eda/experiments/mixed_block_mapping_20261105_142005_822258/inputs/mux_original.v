module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,  // 4 bit select signal
    output reg [7:0] block_out
);

    always @(*) begin
        case (sel)
            4'b0000: block_out = block_a;
            4'b0001: block_out = block_b;
            4'b0010: block_out = block_c;
            4'b0011: block_out = block_d;
            4'b0100: block_out = block_e;
            4'b0101: block_out = block_f;
            4'b0110: block_out = block_g;
            4'b0111: block_out = block_h;
            4'b1000: block_out = block_i;
            4'b1001: block_out = block_j;
            default: block_out = block_a; 
        endcase
    end
endmodule