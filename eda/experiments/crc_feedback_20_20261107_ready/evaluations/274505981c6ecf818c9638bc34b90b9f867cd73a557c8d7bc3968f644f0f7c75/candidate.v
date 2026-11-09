module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Factor the coincident data and low-state coefficients first.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Elaboration-only construction of a row of the byte-update matrix.
    // A basis vector in the low byte is advanced through eight reflected
    // Galois steps using the reversed representation of 0x04c11db7.
    function automatic [7:0] byte_row;
        input integer row;
        reg [31:0] basis;
        integer column;
        integer step;
        begin
            byte_row = 8'b0;
            for (column = 0; column < 8; column = column + 1) begin
                basis = 32'b1 << column;
                for (step = 0; step < 8; step = step + 1) begin
                    if (basis[0])
                        basis = (basis >> 1) ^ 32'hedb88320;
                    else
                        basis = basis >> 1;
                end
                byte_row[column] = basis[row];
            end
        end
    endfunction

    // Explicit balanced parity topology; all zero mask inputs disappear
    // during constant propagation. No run-time table or memory is inferred.
    function automatic parity8;
        input [7:0] x;
        reg [3:0] p;
        reg [1:0] t;
        begin
            p[0] = x[0] ^ x[1];
            p[1] = x[2] ^ x[3];
            p[2] = x[4] ^ x[5];
            p[3] = x[6] ^ x[7];
            t[0] = p[0] ^ p[1];
            t[1] = p[2] ^ p[3];
            parity8 = t[0] ^ t[1];
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : g_state
            localparam [7:0] MASK = byte_row(n);
            wire contribution;
            assign contribution = parity8(q & MASK);
            if (n < 24) begin : g_shift
                assign state_out[n] = contribution ^ state_in[n+8];
            end else begin : g_no_shift
                assign state_out[n] = contribution;
            end
        end
    endgenerate

    // The original data output is the sequence of feedback bits, not
    // a copy of the input byte. The reflected polynomial's lowest tap
    // is bit 5, which first affects feedback at step 6.
    assign data_out[5:0] = q[5:0];
    assign data_out[6] = q[6] ^ q[0];
    assign data_out[7] = q[7] ^ q[1];

endmodule
