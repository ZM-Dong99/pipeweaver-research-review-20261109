`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d4 (
    input  wire [3:0]  data_in,
    input  wire [31:0] state_in,
    output wire [3:0]  data_out,
    output wire [31:0] state_out
);
    // Reflected CRC32 polynomial. During these four shifts, feedback
    // cannot reach any of the four state bits being shifted out.
    localparam [31:0] POLY = 32'hedb88320;
    localparam [31:0] T0 = POLY >> 3;
    localparam [31:0] T1 = POLY >> 2;
    localparam [31:0] T2 = POLY >> 1;
    localparam [31:0] T3 = POLY;

    wire [3:0] feedback;
    wire [31:0] shifted;
    assign feedback = state_in[3:0] ^ data_in;
    assign data_out = feedback;
    assign shifted = {4'b0000, state_in[31:4]};

    function integer population;
        input [3:0] mask;
        integer j;
        begin
            population = 0;
            for (j = 0; j < 4; j = j + 1)
                population = population + mask[j];
        end
    endfunction

    function integer selected_index;
        input [3:0] mask;
        input integer ordinal;
        integer j;
        integer count;
        begin
            selected_index = 0;
            count = 0;
            for (j = 0; j < 4; j = j + 1) begin
                if (mask[j]) begin
                    if (count == ordinal)
                        selected_index = j;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar b;
    generate
        for (b = 0; b < 32; b = b + 1) begin : output_bit
            localparam [3:0] MASK = {T3[b], T2[b], T1[b], T0[b]};
            localparam integer COUNT = population(MASK);
            localparam integer I0 = selected_index(MASK, 0);
            localparam integer I1 = selected_index(MASK, 1);
            localparam integer I2 = selected_index(MASK, 2);
            localparam integer I3 = selected_index(MASK, 3);

            if (COUNT == 0) begin : no_feedback
                assign state_out[b] = shifted[b];
            end else if (COUNT == 1) begin : one_feedback
                assign state_out[b] = shifted[b] ^ feedback[I0];
            end else if (COUNT == 2) begin : two_feedback
                assign state_out[b] = shifted[b] ^
                                      (feedback[I0] ^ feedback[I1]);
            end else if (COUNT == 3) begin : three_feedback
                assign state_out[b] = (feedback[I0] ^ feedback[I1]) ^
                                      (feedback[I2] ^ shifted[b]);
            end else begin : four_feedback
                assign state_out[b] = (feedback[I0] ^ feedback[I1]) ^
                                      ((feedback[I2] ^ feedback[I3]) ^ shifted[b]);
            end
        end
    endgenerate
endmodule

`default_nettype wire
