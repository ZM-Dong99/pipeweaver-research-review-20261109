`timescale 1ns / 1ps
`default_nettype none

module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Combine corresponding message and initial-state contributions first.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant columns of the eight-step reflected CRC transformation.
    function automatic [7:0] state_mask;
        input integer output_bit;
        reg [31:0] column;
        integer k, step;
        begin
            state_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                column = 32'b1 << k;
                for (step = 0; step < 8; step = step + 1) begin
                    if (column[0])
                        column = (column >> 1) ^ 32'hedb88320;
                    else
                        column = column >> 1;
                end
                state_mask[k] = column[output_bit];
            end
        end
    endfunction

    function automatic integer bit_count;
        input [7:0] mask;
        integer k;
        begin
            bit_count = 0;
            for (k = 0; k < 8; k = k + 1)
                bit_count = bit_count + mask[k];
        end
    endfunction

    function automatic integer bit_rank;
        input [7:0] mask;
        input integer index;
        integer k;
        begin
            bit_rank = 0;
            for (k = 0; k < index; k = k + 1)
                bit_rank = bit_rank + mask[k];
        end
    endfunction

    genvar n, k;
    generate
        for (n = 0; n < 32; n = n + 1) begin : output_bit
            localparam [7:0] MASK = state_mask(n);
            localparam integer COUNT = bit_count(MASK);
            localparam integer SHIFT_TERM = (n < 24) ? 1 : 0;
            wire [COUNT+SHIFT_TERM-1:0] terms;
            for (k = 0; k < 8; k = k + 1) begin : input_bit
                if (MASK[k]) begin : selected
                    assign terms[bit_rank(MASK, k)] = q[k];
                end
            end
            if (n < 24) begin : shifted_state
                assign terms[COUNT] = state_in[n+8];
            end
            assign state_out[n] = ^terms;
        end
    endgenerate

    // The shifted-out value is the feedback at each step, not raw input data.
    assign data_out[5:0] = q[5:0];
    assign data_out[6] = q[6] ^ q[0];
    assign data_out[7] = q[7] ^ q[1];
endmodule

`default_nettype wire
