`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Combine the corresponding data and CRC bits before the CRC matrix.
    wire [7:0] t;
    assign t = data_in ^ state_in[7:0];

    // Constant elaboration-time matrix construction.  Entries represent
    // coefficients of t, not hardware storage or runtime iteration.
    function [7:0] crc_mask;
        input integer index;
        reg [7:0] s [0:31];
        reg [7:0] feedback;
        reg [31:0] polynomial;
        integer i, j;
        begin
            polynomial = 32'hedb88320;
            crc_mask = 8'b0;
            for (j = 0; j < 32; j = j + 1) begin
                s[j] = 8'b0;
                if (j < 8)
                    s[j] = 8'b00000001 << j;
            end
            for (i = 0; i < 8; i = i + 1) begin
                feedback = s[0];
                if (index == 32+i)
                    crc_mask = feedback;
                for (j = 0; j < 31; j = j + 1)
                    s[j] = s[j+1];
                s[31] = 8'b0;
                for (j = 0; j < 32; j = j + 1)
                    if (polynomial[j])
                        s[j] = s[j] ^ feedback;
            end
            if (index < 32)
                crc_mask = s[index];
        end
    endfunction

    function integer population;
        input [7:0] mask;
        integer j;
        begin
            population = 0;
            for (j = 0; j < 8; j = j + 1)
                population = population + mask[j];
        end
    endfunction

    function integer prefix_population;
        input [7:0] mask;
        input integer limit;
        integer j;
        begin
            prefix_population = 0;
            for (j = 0; j < limit; j = j + 1)
                prefix_population = prefix_population + mask[j];
        end
    endfunction

    wire [39:0] result;
    genvar n, b;
    generate
        for (n = 0; n < 40; n = n + 1) begin : output_matrix
            localparam [7:0] MASK = crc_mask(n);
            localparam integer TERMS = population(MASK);
            localparam integer SHIFT_TERM = (n < 24) ? 1 : 0;
            localparam integer N = TERMS + SHIFT_TERM;
            if (N == 0) begin : constant_output
                assign result[n] = 1'b0;
            end else begin : parity_output
                wire [N-1:0] leaves;
                for (b = 0; b < 8; b = b + 1) begin : select_term
                    if (MASK[b]) begin : selected
                        localparam integer POSITION = prefix_population(MASK, b);
                        assign leaves[POSITION] = t[b];
                    end
                end
                if (n < 24) begin : shifted_state
                    assign leaves[TERMS] = state_in[n+8];
                end
                pw_crc32_d8_parity #(.N(N)) parity (
                    .x(leaves),
                    .y(result[n])
                );
            end
        end
    endgenerate

    assign state_out = result[31:0];
    assign data_out = result[39:32];
endmodule

module pw_crc32_d8_parity #(
    parameter integer N = 1
) (
    input  wire [N-1:0] x,
    output wire y
);
    generate
        if (N == 1) begin : leaf
            assign y = x[0];
        end else begin : branch
            localparam integer L = N/2;
            localparam integer R = N-L;
            wire yl, yr;
            pw_crc32_d8_parity #(.N(L)) left_tree (
                .x(x[L-1:0]), .y(yl)
            );
            pw_crc32_d8_parity #(.N(R)) right_tree (
                .x(x[N-1:L]), .y(yr)
            );
            assign y = yl ^ yr;
        end
    endgenerate
endmodule

`default_nettype wire
