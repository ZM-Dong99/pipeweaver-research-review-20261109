module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

// Constant elaboration functions describing a four-level Dadda tree.
function integer height;
    input integer st;
    input integer col;
    integer h [0:15];
    integer nh [0:15];
    integer s, k, target, incoming, excess, nf, na;
    begin
        for (k = 0; k < 16; k = k + 1) begin
            if (k < 8) h[k] = k + 1;
            else h[k] = 15 - k;
        end
        for (s = 0; s < st; s = s + 1) begin
            case (s)
                0: target = 6;
                1: target = 4;
                2: target = 3;
                default: target = 2;
            endcase
            incoming = 0;
            for (k = 0; k < 16; k = k + 1) begin
                excess = h[k] + incoming - target;
                if (excess < 0) excess = 0;
                nf = excess / 2;
                na = excess % 2;
                nh[k] = h[k] + incoming - 2*nf - na;
                incoming = nf + na;
            end
            for (k = 0; k < 16; k = k + 1)
                h[k] = nh[k];
        end
        height = h[col];
    end
endfunction

function integer outgoing;
    input integer st;
    input integer col;
    integer k, target, carry, excess;
    begin
        case (st)
            0: target = 6;
            1: target = 4;
            2: target = 3;
            default: target = 2;
        endcase
        carry = 0;
        for (k = 0; k <= col; k = k + 1) begin
            excess = height(st,k) + carry - target;
            if (excess < 0) excess = 0;
            carry = (excess + 1) / 2;
        end
        outgoing = carry;
    end
endfunction

wire [7:0] heap [0:4][0:15];
wire [7:0] carries [0:3][0:15];
genvar c, b, s;
generate
    for (c = 0; c < 16; c = c + 1) begin: initial_columns
        localparam integer H = height(0,c);
        localparam integer FIRST = (c < 8) ? 0 : c-7;
        for (b = 0; b < 8; b = b + 1) begin: bits_in_column
            if (b < H) begin: partial_product
                assign heap[0][c][b] = multiplicand[FIRST+b] & multiplier[c-FIRST-b];
            end else begin: unused
                assign heap[0][c][b] = 1'b0;
            end
        end
    end
    for (s = 0; s < 4; s = s + 1) begin: reduction
        localparam integer TARGET = (s == 0) ? 6 : (s == 1) ? 4 : (s == 2) ? 3 : 2;
        for (c = 0; c < 16; c = c + 1) begin: column
            localparam integer H = height(s,c);
            localparam integer INC = outgoing(s,c-1);
            localparam integer EXCESS = (H+INC > TARGET) ? H+INC-TARGET : 0;
            localparam integer NF = EXCESS/2;
            localparam integer NA = EXCESS%2;
            localparam integer LOCAL_BITS = H-2*NF-NA;
            localparam integer NEXT_H = height(s+1,c);
            for (b = 0; b < 8; b = b + 1) begin: compressor
                if (b < NF) begin: full_adder
                    assign heap[s+1][c][b] = heap[s][c][3*b] ^ heap[s][c][3*b+1] ^ heap[s][c][3*b+2];
                    assign carries[s][c][b] = (heap[s][c][3*b] & heap[s][c][3*b+1]) |
                                               (heap[s][c][3*b] & heap[s][c][3*b+2]) |
                                               (heap[s][c][3*b+1] & heap[s][c][3*b+2]);
                end else if (b < NF+NA) begin: half_adder
                    assign heap[s+1][c][b] = heap[s][c][3*NF] ^ heap[s][c][3*NF+1];
                    assign carries[s][c][b] = heap[s][c][3*NF] & heap[s][c][3*NF+1];
                end else begin: other
                    assign carries[s][c][b] = 1'b0;
                    if (b < LOCAL_BITS) begin: bypass
                        assign heap[s+1][c][b] = heap[s][c][b+2*NF+NA];
                    end else if ((b < NEXT_H) && (c > 0)) begin: carry_input
                        assign heap[s+1][c][b] = carries[s][c-1][b-LOCAL_BITS];
                    end else begin: padding
                        assign heap[s+1][c][b] = 1'b0;
                    end
                end
            end
        end
    end
endgenerate

// Parallel-prefix carry propagation for the two remaining rows.
wire [15:0] a, d, propagate;
wire [15:0] pg [0:4];
wire [15:0] gg [0:4];
generate
    for (c = 0; c < 16; c = c + 1) begin: final_rows
        assign a[c] = heap[4][c][0];
        assign d[c] = heap[4][c][1];
    end
endgenerate
assign propagate = a ^ d;
assign pg[0] = propagate;
assign gg[0] = a & d;
generate
    for (s = 0; s < 4; s = s + 1) begin: prefix_level
        for (c = 0; c < 16; c = c + 1) begin: prefix_bit
            if (c >= (1 << s)) begin: combine
                assign gg[s+1][c] = gg[s][c] | (pg[s][c] & gg[s][c-(1 << s)]);
                assign pg[s+1][c] = pg[s][c] & pg[s][c-(1 << s)];
            end else begin: bypass
                assign gg[s+1][c] = gg[s][c];
                assign pg[s+1][c] = pg[s][c];
            end
        end
    end
endgenerate
assign product = propagate ^ {gg[4][14:0], 1'b0};
endmodule
