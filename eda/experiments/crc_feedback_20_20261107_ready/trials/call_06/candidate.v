module crc32_xor_tree #(
    parameter integer N = 1
) (
    input wire [N-1:0] x,
    output wire y
);
    generate
        if (N == 1) begin : leaf
            assign y = x[0];
        end else begin : branch
            localparam integer L = N/2;
            wire a, b;
            crc32_xor_tree #(.N(L)) left_tree (
                .x(x[L-1:0]), .y(a)
            );
            crc32_xor_tree #(.N(N-L)) right_tree (
                .x(x[N-1:L]), .y(b)
            );
            assign y = a ^ b;
        end
    endgenerate
endmodule

module crc32_d8 (
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);
    // All eight injected input/state pairs are shared explicitly.
    wire [7:0] t;
    assign t = data_in ^ state_in[7:0];

    // Constant-only symbolic evaluation of the reflected CRC recurrence.
    // Indices 0..31 select next-state masks; 32..39 select
    // the feedback bits emitted in chronological, LSB-first order.
    function automatic [7:0] crc_mask(input integer index);
        reg [7:0] s [0:31];
        reg [7:0] emitted [0:7];
        reg [7:0] feedback;
        reg [31:0] polynomial;
        integer i, j;
        begin
            polynomial = 32'hedb88320;
            for (j = 0; j < 32; j = j + 1) begin
                s[j] = 8'b0;
                if (j < 8)
                    s[j] = 8'b00000001 << j;
            end
            for (i = 0; i < 8; i = i + 1) begin
                feedback = s[0];
                emitted[i] = feedback;
                for (j = 0; j < 31; j = j + 1)
                    s[j] = s[j+1];
                s[31] = 8'b0;
                for (j = 0; j < 32; j = j + 1)
                    if (polynomial[j])
                        s[j] = s[j] ^ feedback;
            end
            if (index < 32)
                crc_mask = s[index];
            else
                crc_mask = emitted[index-32];
        end
    endfunction

    function automatic integer popcount(input [7:0] mask);
        integer i;
        begin
            popcount = 0;
            for (i = 0; i < 8; i = i + 1)
                popcount = popcount + ((mask >> i) & 1);
        end
    endfunction

    function automatic integer selected_bit(
        input [7:0] mask,
        input integer ordinal
    );
        integer i, count;
        begin
            count = 0;
            selected_bit = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (mask[i]) begin
                    if (count == ordinal)
                        selected_bit = i;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar n, k;
    generate
        for (n = 0; n < 32; n = n + 1) begin : state_equation
            localparam [7:0] M = crc_mask(n);
            localparam integer C = popcount(M);
            localparam integer N = C + ((n < 24) ? 1 : 0);
            if (N == 0) begin : constant_output
                assign state_out[n] = 1'b0;
            end else begin : nonconstant_output
                wire [N-1:0] terms;
                for (k = 0; k < C; k = k + 1) begin : selected_terms
                    assign terms[k] = t[selected_bit(M, k)];
                end
                if (n < 24) begin : shifted_state
                    assign terms[C] = state_in[n+8];
                end
                crc32_xor_tree #(.N(N)) tree (
                    .x(terms), .y(state_out[n])
                );
            end
        end
        for (n = 0; n < 8; n = n + 1) begin : data_equation
            localparam [7:0] M = crc_mask(32+n);
            localparam integer C = popcount(M);
            wire [C-1:0] terms;
            for (k = 0; k < C; k = k + 1) begin : selected_terms
                assign terms[k] = t[selected_bit(M, k)];
            end
            crc32_xor_tree #(.N(C)) tree (
                .x(terms), .y(data_out[n])
            );
        end
    endgenerate
endmodule
