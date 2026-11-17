module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam LEVELS = (WIDTH > 1) ? $clog2(WIDTH) : 0;

    wire [WIDTH-1:0] x;
    wire [WIDTH-1:0] ag [0:LEVELS];
    wire [WIDTH-1:0] ap [0:LEVELS];
    wire [WIDTH-1:0] bg [0:LEVELS];
    wire [WIDTH-1:0] bp [0:LEVELS];
    wire [WIDTH-1:0] add_result;
    wire [WIDTH-1:0] ab_result;
    wire [WIDTH-1:0] ba_result;
    wire [WIDTH-1:0] selected;

    wire sel_add = (Oper == 3'b000);
    wire sel_ab  = (Oper == 3'b001);
    wire sel_ba  = (Oper == 3'b010);
    wire sel_or  = (Oper == 3'b011);
    wire sel_and = (Oper == 3'b100);
    wire sel_xor = (Oper == 3'b101);
    wire sel_xnr = (Oper == 3'b110);

    assign x = a ^ b;
    assign ag[0] = a & b;
    assign ap[0] = x;
    assign bg[0] = (~a) & b;
    assign bp[0] = ~x;

    genvar s, i;
    generate
        for (s = 0; s < LEVELS; s = s + 1) begin : prefix_stage
            for (i = 0; i < WIDTH; i = i + 1) begin : prefix_bit
                if (i >= (1 << s)) begin : combine
                    assign ag[s+1][i] = ag[s][i] |
                        (ap[s][i] & ag[s][i-(1 << s)]);
                    assign ap[s+1][i] = ap[s][i] & ap[s][i-(1 << s)];
                    assign bg[s+1][i] = bg[s][i] |
                        (bp[s][i] & bg[s][i-(1 << s)]);
                    assign bp[s+1][i] = bp[s][i] & bp[s][i-(1 << s)];
                end else begin : pass_through
                    assign ag[s+1][i] = ag[s][i];
                    assign ap[s+1][i] = ap[s][i];
                    assign bg[s+1][i] = bg[s][i];
                    assign bp[s+1][i] = bp[s][i];
                end
            end
        end
        for (i = 0; i < WIDTH; i = i + 1) begin : result_bit
            if (i == 0) begin : low_bit
                assign add_result[i] = x[i];
                assign ab_result[i] = x[i];
                assign ba_result[i] = x[i];
            end else begin : upper_bit
                assign add_result[i] = x[i] ^ ag[LEVELS][i-1];
                assign ab_result[i] = x[i] ^ bg[LEVELS][i-1];
                assign ba_result[i] = x[i] ^
                    (~(bg[LEVELS][i-1] | bp[LEVELS][i-1]));
            end
            assign selected[i] =
                (sel_add & add_result[i]) |
                (sel_ab  & ab_result[i]) |
                (sel_ba  & ba_result[i]) |
                (sel_or  & (a[i] | b[i])) |
                (sel_and & (a[i] & b[i])) |
                (sel_xor & x[i]) |
                (sel_xnr & ~x[i]);
        end
    endgenerate

    always @* begin
        sum = selected;
    end
endmodule
