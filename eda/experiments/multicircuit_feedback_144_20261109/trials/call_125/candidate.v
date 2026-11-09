module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    // Elaboration-time Dadda column schedule.
    function automatic integer schedule;
        input integer level;
        input integer column;
        input integer field;
        integer heights [0:15];
        integer s, c, target, incoming, old_height;
        integer excess, nf, nh, result;
        begin
            for (c = 0; c < 16; c = c + 1) begin
                if (c < 8) heights[c] = c + 1;
                else heights[c] = 15 - c;
            end
            result = 0;
            for (s = 1; s <= level; s = s + 1) begin
                case (s)
                    1: target = 6;
                    2: target = 4;
                    3: target = 3;
                    default: target = 2;
                endcase
                incoming = 0;
                for (c = 0; c < 16; c = c + 1) begin
                    old_height = heights[c];
                    excess = old_height + incoming - target;
                    if (excess < 0) excess = 0;
                    nf = excess / 2;
                    nh = excess % 2;
                    heights[c] = old_height - 2*nf - nh + incoming;
                    if ((s == level) && (c == column)) begin
                        case (field)
                            0: result = old_height;
                            1: result = nf;
                            2: result = nh;
                            default: result = heights[c];
                        endcase
                    end
                    incoming = nf + nh;
                end
            end
            schedule = result;
        end
    endfunction

    wire [7:0] dots [0:4][0:15];
    wire [7:0] carries [1:4][0:15];
    genvar c, k, s;
    generate
        for (c = 0; c < 16; c = c + 1) begin: initial_columns
            localparam integer HEIGHT = (c < 8) ? c+1 : 15-c;
            localparam integer TOP = (c < 8) ? c : 7;
            for (k = 0; k < 8; k = k + 1) begin: initial_bits
                if (k < HEIGHT) begin: valid_bit
                    assign dots[0][c][k] = multiplicand[TOP-k] & multiplier[c-TOP+k];
                end else begin: padding
                    assign dots[0][c][k] = 1'b0;
                end
            end
        end
        for (s = 1; s <= 4; s = s + 1) begin: reduction_stage
            for (c = 0; c < 16; c = c + 1) begin: column
                localparam integer H = schedule(s,c,0);
                localparam integer F = schedule(s,c,1);
                localparam integer A = schedule(s,c,2);
                localparam integer OUT_H = schedule(s,c,3);
                localparam integer REMAIN = H-3*F-2*A;
                for (k = 0; k < F; k = k + 1) begin: full_adders
                    wire a, b, d;
                    assign a = dots[s-1][c][3*k];
                    assign b = dots[s-1][c][3*k+1];
                    assign d = dots[s-1][c][3*k+2];
                    assign dots[s][c][k] = a ^ b ^ d;
                    assign carries[s][c][k] = (a & b) | (a & d) | (b & d);
                end
                if (A != 0) begin: half_adder
                    assign dots[s][c][F] = dots[s-1][c][3*F] ^ dots[s-1][c][3*F+1];
                    assign carries[s][c][F] = dots[s-1][c][3*F] & dots[s-1][c][3*F+1];
                end
                for (k = 0; k < REMAIN; k = k + 1) begin: remaining_bits
                    assign dots[s][c][F+A+k] = dots[s-1][c][3*F+2*A+k];
                end
                if (c > 0) begin: incoming_carries
                    localparam integer N = schedule(s,c-1,1)+schedule(s,c-1,2);
                    for (k = 0; k < N; k = k + 1) begin: incoming_bit
                        assign dots[s][c][F+A+REMAIN+k] = carries[s][c-1][k];
                    end
                end
                for (k = OUT_H; k < 8; k = k + 1) begin: output_padding
                    assign dots[s][c][k] = 1'b0;
                end
                for (k = F+A; k < 8; k = k + 1) begin: carry_padding
                    assign carries[s][c][k] = 1'b0;
                end
            end
        end
    endgenerate

    // Parallel-prefix carry resolution of the two remaining rows.
    wire [15:0] row_a, row_b;
    wire [15:0] p [0:4];
    wire [15:0] g [0:4];
    generate
        for (c = 0; c < 16; c = c + 1) begin: final_rows
            assign row_a[c] = dots[4][c][0];
            assign row_b[c] = dots[4][c][1];
        end
    endgenerate
    assign p[0] = row_a ^ row_b;
    assign g[0] = row_a & row_b;
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
    assign product = p[0] ^ {g[4][14:0], 1'b0};
endmodule
