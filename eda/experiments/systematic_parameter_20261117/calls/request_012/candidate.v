`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d16 (
    input  wire [15:0] data_in,
    input  wire [31:0] state_in,
    output wire [15:0] data_out,
    output wire [31:0] state_out
);

    // During these sixteen reflected shifts, only the initial low
    // sixteen state bits participate in feedback. Combine each with
    // its corresponding data bit before forming the parity networks.
    wire [15:0] mixed;
    assign mixed = data_in ^ state_in[15:0];

    // Constant coefficient generation. The first 32 rows describe the
    // final state; the remaining 16 describe chronological feedback.
    function [15:0] coefficient;
        input integer row;
        reg [31:0] s;
        reg [15:0] feedback;
        reg bit_out;
        integer k;
        integer step;
        begin
            coefficient = 16'b0;
            for (k = 0; k < 16; k = k + 1) begin
                s = 32'h00000001 << k;
                feedback = 16'b0;
                for (step = 0; step < 16; step = step + 1) begin
                    bit_out = s[0];
                    feedback[step] = bit_out;
                    s = s >> 1;
                    if (bit_out)
                        s = s ^ 32'hedb88320;
                end
                if (row < 32)
                    coefficient[k] = s[row];
                else
                    coefficient[k] = feedback[row-32];
            end
        end
    endfunction

    // Return the input index of the requested nonzero coefficient.
    // All calls have elaboration-time constant arguments.
    function integer selected_index;
        input [15:0] mask;
        input integer ordinal;
        integer k;
        integer count;
        begin
            selected_index = -1;
            count = 0;
            for (k = 0; k < 16; k = k + 1) begin
                if (mask[k]) begin
                    if (count == ordinal)
                        selected_index = k;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar row;
    genvar leaf;
    genvar node;
    generate
        for (row = 0; row < 48; row = row + 1) begin : parity_row
            localparam [15:0] MASK = coefficient(row);
            localparam integer EXTRA = (row < 16) ? 1 : 0;
            wire [63:1] tree;

            // Pack live leaves together so constant propagation removes
            // unused branches without creating a serial XOR accumulator.
            for (leaf = 0; leaf < 32; leaf = leaf + 1) begin : input_leaf
                localparam integer INDEX = selected_index(MASK, leaf-EXTRA);
                if ((EXTRA != 0) && (leaf == 0)) begin : upper_state
                    assign tree[32+leaf] = state_in[row+16];
                end else if (INDEX >= 0) begin : mixed_input
                    assign tree[32+leaf] = mixed[INDEX];
                end else begin : zero_input
                    assign tree[32+leaf] = 1'b0;
                end
            end

            for (node = 1; node < 32; node = node + 1) begin : xor_node
                assign tree[node] = tree[2*node] ^ tree[2*node+1];
            end

            if (row < 32) begin : state_result
                assign state_out[row] = tree[1];
            end else begin : data_result
                assign data_out[row-32] = tree[1];
            end
        end
    endgenerate
endmodule

`default_nettype wire
