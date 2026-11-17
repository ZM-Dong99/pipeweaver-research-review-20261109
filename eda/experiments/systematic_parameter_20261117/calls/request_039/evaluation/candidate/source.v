module pw_crc32_d16 (
    input wire [15:0] data_in,
    input wire [31:0] state_in,
    output wire [15:0] data_out,
    output wire [31:0] state_out
);
    // Combine paired input terms before the parallel CRC transform.
    wire [15:0] t;
    assign t = data_in ^ state_in[15:0];

    // Constant-only symbolic simulation. Each 16-bit slice represents
    // the coefficients of t in one reflected CRC register bit.
    function [15:0] crc_mask;
        input integer index;
        reg [511:0] s;
        reg [255:0] feedbacks;
        reg [15:0] f;
        reg [31:0] poly;
        integer i, j;
        begin
            s = 512'b0;
            feedbacks = 256'b0;
            poly = 32'hedb88320;
            for (i = 0; i < 16; i = i + 1)
                s[16*i+i] = 1'b1;
            for (i = 0; i < 16; i = i + 1) begin
                f = s[15:0];
                feedbacks[16*i +: 16] = f;
                s = s >> 16;
                for (j = 0; j < 32; j = j + 1)
                    if (poly[j])
                        s[16*j +: 16] = s[16*j +: 16] ^ f;
            end
            if (index < 32)
                crc_mask = s[16*index +: 16];
            else
                crc_mask = feedbacks[16*(index-32) +: 16];
        end
    endfunction

    genvar b;
    generate
        for (b = 0; b < 32; b = b + 1) begin : state_bits
            localparam [15:0] M = crc_mask(b);
            if (b < 16) begin : with_upper_state
                pw_crc32_d16_parity #(.MASK({1'b1, M})) p (
                    .x({state_in[b+16], t}), .y(state_out[b])
                );
            end else begin : without_upper_state
                pw_crc32_d16_parity #(.MASK({1'b0, M})) p (
                    .x({1'b0, t}), .y(state_out[b])
                );
            end
        end
        for (b = 0; b < 16; b = b + 1) begin : data_bits
            localparam [15:0] M = crc_mask(32+b);
            pw_crc32_d16_parity #(.MASK({1'b0, M})) p (
                .x({1'b0, t}), .y(data_out[b])
            );
        end
    endgenerate
endmodule

// Compact the selected operands before constructing a balanced XOR tree.
module pw_crc32_d16_parity #(
    parameter [16:0] MASK = 17'b1
)(
    input wire [16:0] x,
    output wire y
);
    function integer population;
        input [16:0] m;
        integer i;
        begin
            population = 0;
            for (i = 0; i < 17; i = i + 1)
                population = population + m[i];
        end
    endfunction
    function integer power_two;
        input integer n;
        integer v;
        begin
            v = 1;
            while (v < n)
                v = v * 2;
            power_two = v;
        end
    endfunction
    function integer selected_index;
        input integer ordinal;
        integer i, count;
        begin
            count = 0;
            selected_index = 0;
            for (i = 0; i < 17; i = i + 1) begin
                if (MASK[i]) begin
                    if (count == ordinal)
                        selected_index = i;
                    count = count + 1;
                end
            end
        end
    endfunction
    localparam integer COUNT = population(MASK);
    localparam integer N = power_two(COUNT);
    wire [2*N-1:1] tree;
    genvar k;
    generate
        for (k = 0; k < N; k = k + 1) begin : leaves
            if (k < COUNT) begin : used
                localparam integer INDEX = selected_index(k);
                assign tree[N+k] = x[INDEX];
            end else begin : unused
                assign tree[N+k] = 1'b0;
            end
        end
        for (k = 1; k < N; k = k + 1) begin : branches
            assign tree[k] = tree[2*k] ^ tree[2*k+1];
        end
    endgenerate
    assign y = tree[1];
endmodule
