module pw_crc32_d16 (
    input wire [15:0] data_in,
    input wire [31:0] state_in,
    output wire [15:0] data_out,
    output wire [31:0] state_out
);
    // Fold matching input and initial-state bits before the CRC matrix.
    wire [15:0] f;
    assign f = data_in ^ state_in[15:0];

    // Constant-time symbolic evaluation of the reflected CRC recurrence.
    // Indices 0..31 select next-state bits; 32..47 select shifted-out bits.
    function [15:0] crc_mask;
        input integer index;
        reg [15:0] r [0:32];
        reg [15:0] feedback;
        reg [15:0] selected;
        integer k, j;
        begin
            for (j = 0; j <= 32; j = j + 1)
                r[j] = 16'b0;
            selected = 16'b0;
            for (k = 0; k < 16; k = k + 1) begin
                feedback = r[0] ^ (16'h0001 << k);
                if (index == 32+k)
                    selected = feedback;
                for (j = 0; j < 32; j = j + 1) begin
                    r[j] = r[j+1];
                    if ((32'hedb88320 >> j) & 1)
                        r[j] = r[j] ^ feedback;
                end
            end
            if (index < 32)
                crc_mask = r[index];
            else
                crc_mask = selected;
        end
    endfunction

    function integer popcount;
        input [15:0] value;
        integer k;
        begin
            popcount = 0;
            for (k = 0; k < 16; k = k + 1)
                popcount = popcount + value[k];
        end
    endfunction

    genvar n, k;
    generate
        for (n = 0; n < 48; n = n + 1) begin : outputs_matrix
            localparam [15:0] MASK = crc_mask(n);
            localparam integer COUNT = popcount(MASK);
            localparam integer WIDTH = COUNT + ((n < 16) ? 1 : 0);
            wire [WIDTH-1:0] terms;
            wire result;
            for (k = 0; k < 16; k = k + 1) begin : selected_terms
                if (MASK[k]) begin : present
                    localparam integer POSITION = popcount(MASK & ((16'h0001 << k)-16'h0001));
                    assign terms[POSITION] = f[k];
                end
            end
            if (n < 16) begin : remaining_state
                assign terms[COUNT] = state_in[n+16];
            end
            pw_crc32_d16_parity #(.WIDTH(WIDTH)) parity_inst (
                .in(terms),
                .out(result)
            );
            if (n < 32) begin : state_result
                assign state_out[n] = result;
            end else begin : data_result
                assign data_out[n-32] = result;
            end
        end
    endgenerate
endmodule

module pw_crc32_d16_parity #(
    parameter WIDTH = 1
) (
    input wire [WIDTH-1:0] in,
    output wire out
);
    function integer tree_size;
        input integer width;
        integer p;
        begin
            p = 1;
            while (p < width)
                p = p * 2;
            tree_size = p;
        end
    endfunction
    localparam integer P = tree_size(WIDTH);
    wire [2*P-1:1] tree;
    genvar i;
    generate
        for (i = 0; i < P; i = i + 1) begin : leaves
            if (i < WIDTH) begin : used
                assign tree[P+i] = in[i];
            end else begin : padding
                assign tree[P+i] = 1'b0;
            end
        end
        for (i = 1; i < P; i = i + 1) begin : branches
            assign tree[i] = tree[2*i] ^ tree[2*i+1];
        end
    endgenerate
    assign out = tree[1];
endmodule
