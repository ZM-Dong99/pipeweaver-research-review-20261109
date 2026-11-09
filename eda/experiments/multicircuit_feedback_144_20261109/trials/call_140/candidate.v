module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

// Heights of the unsigned partial-product heap after Dadda reductions.
function automatic integer height(input integer stage, input integer column);
    integer h [0:15];
    integer nh [0:15];
    integer s, k, target, incoming, excess;
    begin
        for (k = 0; k < 16; k = k + 1)
            h[k] = (k < 8) ? k + 1 : 15 - k;
        for (s = 0; s < stage; s = s + 1) begin
            case (s)
                0: target = 6;
                1: target = 4;
                2: target = 3;
                default: target = 2;
            endcase
            incoming = 0;
            for (k = 0; k < 16; k = k + 1) begin
                excess = h[k] + incoming - target;
                if (excess > 0) begin
                    nh[k] = target;
                    incoming = (excess + 1) / 2;
                end else begin
                    nh[k] = h[k] + incoming;
                    incoming = 0;
                end
            end
            for (k = 0; k < 16; k = k + 1)
                h[k] = nh[k];
        end
        height = h[column];
    end
endfunction

function automatic integer incoming_count(input integer stage, input integer column);
    integer k, target, n, excess;
    begin
        case (stage)
            0: target = 6;
            1: target = 4;
            2: target = 3;
            default: target = 2;
        endcase
        n = 0;
        for (k = 0; k < column; k = k + 1) begin
            excess = height(stage, k) + n - target;
            n = (excess > 0) ? (excess + 1) / 2 : 0;
        end
        incoming_count = n;
    end
endfunction

wire [7:0] heap [0:4][0:15];
wire [7:0] carry_bits [0:3][0:16];
genvar c, r, s, f, u;
generate
    for (c = 0; c < 16; c = c + 1) begin: partial_column
        localparam integer LOW = (c > 7) ? c - 7 : 0;
        localparam integer N = (c < 8) ? c + 1 : 15 - c;
        for (r = 0; r < N; r = r + 1) begin: bit_product
            assign heap[0][c][r] = multiplicand[LOW+r] & multiplier[c-LOW-r];
        end
        for (r = N; r < 8; r = r + 1) begin: unused
            assign heap[0][c][r] = 1'b0;
        end
    end
    for (s = 0; s < 4; s = s + 1) begin: reduction
        localparam integer TARGET = (s == 0) ? 6 : (s == 1) ? 4 : (s == 2) ? 3 : 2;
        assign carry_bits[s][0] = 8'b0;
        for (c = 0; c < 16; c = c + 1) begin: column
            localparam integer N = height(s,c);
            localparam integer INC = incoming_count(s,c);
            localparam integer EX = (N + INC > TARGET) ? N + INC - TARGET : 0;
            localparam integer NF = EX / 2;
            localparam integer NH = EX % 2;
            localparam integer REM = N - 3*NF - 2*NH;
            localparam integer OUT = NF + NH + REM + INC;
            for (f = 0; f < NF; f = f + 1) begin: full_adder
                wire a, b, d;
                assign a = heap[s][c][3*f];
                assign b = heap[s][c][3*f+1];
                assign d = heap[s][c][3*f+2];
                assign heap[s+1][c][f] = a ^ b ^ d;
                assign carry_bits[s][c+1][f] = (a & b) | (a & d) | (b & d);
            end
            if (NH != 0) begin: half_adder
                assign heap[s+1][c][NF] = heap[s][c][3*NF] ^ heap[s][c][3*NF+1];
                assign carry_bits[s][c+1][NF] = heap[s][c][3*NF] & heap[s][c][3*NF+1];
            end
            for (u = 0; u < REM; u = u + 1) begin: remaining
                assign heap[s+1][c][NF+NH+u] = heap[s][c][3*NF+2*NH+u];
            end
            for (u = 0; u < INC; u = u + 1) begin: incoming
                assign heap[s+1][c][NF+NH+REM+u] = carry_bits[s][c][u];
            end
            for (u = OUT; u < 8; u = u + 1) begin: padding
                assign heap[s+1][c][u] = 1'b0;
            end
            for (u = NF+NH; u < 8; u = u + 1) begin: carry_padding
                assign carry_bits[s][c+1][u] = 1'b0;
            end
        end
    end
endgenerate

// Only the final two rows require carry propagation.
wire [15:0] a, b, bit_sum;
wire [15:0] p [0:4];
wire [15:0] g [0:4];
generate
    for (c = 0; c < 16; c = c + 1) begin: final_rows
        assign a[c] = heap[4][c][0];
        assign b[c] = heap[4][c][1];
    end
endgenerate
assign bit_sum = a ^ b;
assign p[0] = a | b;
assign g[0] = a & b;
generate
    for (s = 0; s < 4; s = s + 1) begin: prefix_level
        for (c = 0; c < 16; c = c + 1) begin: prefix_bit
            if (c >= (1 << s)) begin: combine
                assign g[s+1][c] = g[s][c] | (p[s][c] & g[s][c-(1 << s)]);
                assign p[s+1][c] = p[s][c] & p[s][c-(1 << s)];
            end else begin: pass_through
                assign g[s+1][c] = g[s][c];
                assign p[s+1][c] = p[s][c];
            end
        end
    end
endgenerate
assign product = bit_sum ^ {g[4][14:0],1'b0};
endmodule
