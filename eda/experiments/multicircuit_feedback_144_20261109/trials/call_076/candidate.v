`timescale 1ns / 1ps
`default_nettype none

module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Combine the eight matching input/state terms before the CRC matrix.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant elaboration-time impulse response of the reflected CRC.
    // Indices 0..31 select state outputs; 32..39 select data outputs.
    function [7:0] output_mask;
        input integer index;
        reg [31:0] s;
        reg [7:0] d;
        reg feedback;
        integer k;
        integer j;
        begin
            output_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                s = 32'h00000001 << k;
                d = 8'b0;
                for (j = 0; j < 8; j = j + 1) begin
                    feedback = s[0];
                    d[j] = feedback;
                    s = (s >> 1) ^ (32'hedb88320 & {32{feedback}});
                end
                if (index < 32)
                    output_mask[k] = s[index];
                else
                    output_mask[k] = d[index-32];
            end
        end
    endfunction

    function integer popcount;
        input [7:0] value;
        integer j;
        begin
            popcount = 0;
            for (j = 0; j < 8; j = j + 1)
                popcount = popcount + value[j];
        end
    endfunction

    wire [39:0] result;
    genvar n, k;
    generate
        for (n = 0; n < 40; n = n + 1) begin : output_matrix
            localparam [7:0] MASK = output_mask(n);
            localparam integer COUNT = popcount(MASK);
            localparam integer TAIL = (n < 24) ? 1 : 0;

            if (COUNT + TAIL > 0) begin : nonzero_row
                // Pack only live operands so reduction synthesis constructs
                // a balanced tree without zero-filled intermediate branches.
                wire [COUNT+TAIL-1:0] terms;
                for (k = 0; k < 8; k = k + 1) begin : input_terms
                    if (MASK[k]) begin : selected
                        localparam integer POSITION = popcount(MASK & ((8'h01 << k) - 8'h01));
                        assign terms[POSITION] = q[k];
                    end
                end
                if (TAIL != 0) begin : shifted_state
                    assign terms[COUNT] = state_in[n+8];
                end
                assign result[n] = ^terms;
            end else begin : zero_row
                assign result[n] = 1'b0;
            end
        end
    endgenerate

    assign state_out = result[31:0];
    assign data_out = result[39:32];

endmodule

`default_nettype wire
