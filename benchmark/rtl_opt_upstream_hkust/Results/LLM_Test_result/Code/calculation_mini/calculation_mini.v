module calculation_mini
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    input [BW-1:0] d,
    output [BW-1:0] s1,
    output [BW-1:0] s2,
    output [BW-1:0] s3,
    output [BW-1:0] s4,
    output [BW-1:0] s5,
    output [BW-1:0] s6
);

    // s1 and s2 are fundamental operations, likely not optimizable without changing functionality
    wire [BW-1:0] a_plus_b = a + b;
    wire [2*BW-1:0] a_times_b = a * b; // Use wider wire for multiplication result

    assign s1 = a_plus_b;
    assign s2 = a_times_b[BW-1:0]; // Truncate to BW bits for output

    // s3 involves modulo which is complex. Optimization here is vendor/tool dependent.
    // Keeping as is for generic optimization.
    wire [BW-1:0] a_mod_b = a % b;
    assign s3 = a_mod_b + d;

    // s4 uses a * b which is already computed for s2. Reuse the result.
    wire [2*BW-1:0] c_plus_d = c + d;
    assign s4 = c_plus_d[BW-1:0] + a_times_b[BW-1:0]; // Sum truncated values

    // s5 is a fundamental operation.
    assign s5 = a - b;

    // s6 can be rearranged: (b*a + a) + d + c - b. Reuse a*b.
    // This might not save much silicon, but clarifies structure.
    // The original expression is already quite optimized at the arithmetic level.
    // Let's keep the original expression as it might be better for synthesis tools.
    wire [BW-1:0] b_plus_1 = b + 1;
    wire [2*BW-1:0] temp_s6_mult = b_plus_1 * a;
    wire [2*BW-1:0] temp_s6_intermediate = temp_s6_mult + d + c;
    assign s6 = temp_s6_intermediate[BW-1:0] - b; // Perform subtraction after additions

endmodule