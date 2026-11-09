module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    wire [127:0] h0, h1, h2, h3, h4;
    genvar c, k;
    generate
        for (c = 0; c < 16; c = c + 1) begin: initial_columns
            localparam integer LO = (c > 7) ? c-7 : 0;
            localparam integer HI = (c < 8) ? c : 7;
            localparam integer N = (HI >= LO) ? HI-LO+1 : 0;
            for (k = 0; k < 8; k = k + 1) begin: bits_in_column
                if (k < N) begin: occupied
                    assign h0[8*c+k] = multiplicand[LO+k] & multiplier[c-LO-k];
                end else begin: empty
                    assign h0[8*c+k] = 1'b0;
                end
            end
        end
    endgenerate
    mul_subexpression_reduce #(.HEIGHTS(64'h0123456787654321), .TARGET(6)) r0(h0,h1);
    mul_subexpression_reduce #(.HEIGHTS(64'h0123466666654321), .TARGET(4)) r1(h1,h2);
    mul_subexpression_reduce #(.HEIGHTS(64'h0124444444444321), .TARGET(3)) r2(h2,h3);
    mul_subexpression_reduce #(.HEIGHTS(64'h0133333333333321), .TARGET(2)) r3(h3,h4);

    wire [15:0] a, b;
    wire [15:0] p [0:4];
    wire [15:0] g [0:4];
    generate
        for (c = 0; c < 16; c = c + 1) begin: final_rows
            assign a[c] = h4[8*c];
            assign b[c] = h4[8*c+1];
        end
    endgenerate
    assign p[0] = a ^ b;
    assign g[0] = a & b;
    genvar level, bitno;
    generate
        for (level = 0; level < 4; level = level + 1) begin: prefix_levels
            for (bitno = 0; bitno < 16; bitno = bitno + 1) begin: prefix_bits
                if (bitno >= (1 << level)) begin: combine
                    assign g[level+1][bitno] = g[level][bitno] | (p[level][bitno] & g[level][bitno-(1 << level)]);
                    assign p[level+1][bitno] = p[level][bitno] & p[level][bitno-(1 << level)];
                end else begin: pass
                    assign g[level+1][bitno] = g[level][bitno];
                    assign p[level+1][bitno] = p[level][bitno];
                end
            end
        end
    endgenerate
    assign product = p[0] ^ {g[4][14:0],1'b0};
endmodule

module mul_subexpression_reduce #(
    parameter [63:0] HEIGHTS = 64'b0,
    parameter integer TARGET = 2
)(
    input [127:0] din,
    output [127:0] dout
);
    function integer incoming;
        input integer column;
        integer j, n, excess, carry_count;
        begin
            carry_count = 0;
            for (j = 0; j < column; j = j + 1) begin
                n = (HEIGHTS >> (4*j)) & 15;
                excess = n + carry_count - TARGET;
                if (excess > 0)
                    carry_count = (excess / 2) + (excess % 2);
                else
                    carry_count = 0;
            end
            incoming = carry_count;
        end
    endfunction
    wire [135:0] carries;
    assign carries[7:0] = 8'b0;
    genvar c, f, k;
    generate
        for (c = 0; c < 16; c = c + 1) begin: column
            localparam integer N = (HEIGHTS >> (4*c)) & 15;
            localparam integer CI = incoming(c);
            localparam integer E = (N + CI > TARGET) ? N + CI - TARGET : 0;
            localparam integer NF = E / 2;
            localparam integer NH = E % 2;
            localparam integer USED = 3*NF + 2*NH;
            localparam integer OUTN = CI + NF + NH + N - USED;
            for (k = 0; k < CI; k = k + 1) begin: incoming_bits
                assign dout[8*c+k] = carries[8*c+k];
            end
            for (f = 0; f < NF; f = f + 1) begin: full_adders
                wire x, y, z;
                assign x = din[8*c+3*f];
                assign y = din[8*c+3*f+1];
                assign z = din[8*c+3*f+2];
                assign dout[8*c+CI+f] = x ^ y ^ z;
                assign carries[8*(c+1)+f] = (x & y) | (x & z) | (y & z);
            end
            if (NH != 0) begin: half_adder
                assign dout[8*c+CI+NF] = din[8*c+3*NF] ^ din[8*c+3*NF+1];
                assign carries[8*(c+1)+NF] = din[8*c+3*NF] & din[8*c+3*NF+1];
            end
            for (k = USED; k < N; k = k + 1) begin: remaining
                assign dout[8*c+CI+NF+NH+k-USED] = din[8*c+k];
            end
            for (k = OUTN; k < 8; k = k + 1) begin: unused_outputs
                assign dout[8*c+k] = 1'b0;
            end
            for (k = NF+NH; k < 8; k = k + 1) begin: unused_carries
                assign carries[8*(c+1)+k] = 1'b0;
            end
        end
    endgenerate
endmodule
