module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Fold matching data and state bits before distributing the CRC terms.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Feedback bits emitted by the eight reflected Galois steps.
    assign data_out[5:0] = q[5:0];
    assign data_out[6] = q[6] ^ q[0];
    assign data_out[7] = q[7] ^ q[1];

    // Constant coefficient matrix for eight reflected shifts.
    function [7:0] coefficient_mask;
        input integer output_bit;
        reg [31:0] v;
        integer k;
        integer step;
        begin
            coefficient_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                v = 32'h00000001 << k;
                for (step = 0; step < 8; step = step + 1) begin
                    if (v[0])
                        v = (v >> 1) ^ 32'hedb88320;
                    else
                        v = v >> 1;
                end
                coefficient_mask[k] = v[output_bit];
            end
        end
    endfunction

    function integer population;
        input [7:0] mask;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                population = population + mask[k];
        end
    endfunction

    function integer selected_index;
        input [7:0] mask;
        input integer ordinal;
        integer k;
        integer seen;
        begin
            selected_index = 0;
            seen = 0;
            for (k = 0; k < 8; k = k + 1) begin
                if (mask[k]) begin
                    if (seen == ordinal)
                        selected_index = k;
                    seen = seen + 1;
                end
            end
        end
    endfunction

    genvar b, j;
    generate
        for (b = 0; b < 32; b = b + 1) begin : output_bit
            localparam [7:0] MASK = coefficient_mask(b);
            localparam integer Q_COUNT = population(MASK);
            localparam integer COUNT = Q_COUNT + ((b < 24) ? 1 : 0);

            if (COUNT == 0) begin : empty
                assign state_out[b] = 1'b0;
            end else begin : parity
                // A compact binary heap gives a balanced XOR tree without
                // introducing a separate final XOR for the shifted state.
                wire [2*COUNT-1:1] tree;
                for (j = 0; j < COUNT; j = j + 1) begin : leaf
                    if (j < Q_COUNT) begin : feedback_term
                        localparam integer INDEX = selected_index(MASK, j);
                        assign tree[COUNT+j] = q[INDEX];
                    end else begin : shifted_term
                        if (b < 24) begin : present
                            assign tree[COUNT+j] = state_in[b+8];
                        end else begin : absent
                            assign tree[COUNT+j] = 1'b0;
                        end
                    end
                end
                for (j = 1; j < COUNT; j = j + 1) begin : branch
                    assign tree[j] = tree[2*j] ^ tree[2*j+1];
                end
                assign state_out[b] = tree[1];
            end
        end
    endgenerate
endmodule
