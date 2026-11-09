module timing_adder (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [31:0] c,
    output reg  [31:0] y
);

    reg [31:0] sum1;
    reg [31:0] sum2;

    wire [31:0] sum1_comb;
    wire [31:0] sum2_comb;

    // Carry-lookahead (Kogge-Stone) adders for both additions
    cla_adder #(.WIDTH(32)) u_cla_sum1 (
        .a(a),
        .b(b),
        .sum(sum1_comb)
    );

    cla_adder #(.WIDTH(32)) u_cla_sum2 (
        .a(sum1),
        .b(c),
        .sum(sum2_comb)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 32'b0;
            sum2 <= 32'b0;
            y    <= 32'b0;
        end else begin
            sum1 <= sum1_comb;
            sum2 <= sum2_comb;
            y    <= sum2;
        end
    end

endmodule

module cla_adder #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] p = a ^ b;
    wire [WIDTH-1:0] g = a & b;

    localparam LEVELS = $clog2(WIDTH);

    // Prefix network arrays
    wire [WIDTH-1:0] P [0:LEVELS];
    wire [WIDTH-1:0] G [0:LEVELS];

    assign P[0] = p;
    assign G[0] = g;

    genvar stage, i;
    generate
        for (stage = 0; stage < LEVELS; stage = stage + 1) begin : ks_stage
            for (i = 0; i < WIDTH; i = i + 1) begin : bit
                localparam int shift = 1 << stage;
                if (i >= shift) begin
                    assign P[stage+1][i] = P[stage][i] & P[stage][i-shift];
                    assign G[stage+1][i] = G[stage][i] | (P[stage][i] & G[stage][i-shift]);
                end else begin
                    assign P[stage+1][i] = P[stage][i];
                    assign G[stage+1][i] = G[stage][i];
                end
            end
        end
    endgenerate

    wire [WIDTH-1:0] carries;
    assign carries[0] = 1'b0;
    genvar j;
    generate
        for (j = 1; j < WIDTH; j = j + 1) begin : carry_gen
            assign carries[j] = G[LEVELS][j-1];
        end
    endgenerate

    assign sum = p ^ carries;

endmodule
