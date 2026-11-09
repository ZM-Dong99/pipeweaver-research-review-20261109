module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Combine the two inputs to each reflected feedback position first.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant-only symbolic evaluation of the fixed reflected CRC.
    // Each symbolic bit is a mask over q[7:0].
    function automatic [7:0] crc_mask(input integer index);
        reg [7:0] s [0:31];
        reg [7:0] feedback;
        reg [7:0] selected_feedback;
        reg [31:0] polynomial;
        integer i;
        integer t;
        begin
            polynomial = 32'hedb88320;
            selected_feedback = 8'b0;
            for (i = 0; i < 32; i = i + 1) begin
                if (i < 8)
                    s[i] = 8'b00000001 << i;
                else
                    s[i] = 8'b0;
            end
            for (t = 0; t < 8; t = t + 1) begin
                feedback = s[0];
                if (index == 32 + t)
                    selected_feedback = feedback;
                for (i = 0; i < 31; i = i + 1)
                    s[i] = s[i+1];
                s[31] = 8'b0;
                for (i = 0; i < 32; i = i + 1)
                    if (polynomial[i])
                        s[i] = s[i] ^ feedback;
            end
            if (index < 32)
                crc_mask = s[index];
            else
                crc_mask = selected_feedback;
        end
    endfunction

    // Pack nonzero mask entries so sparse masks do not create sparse trees.
    function automatic integer mask_term(
        input [7:0] mask,
        input integer ordinal
    );
        integer i;
        integer count;
        begin
            count = 0;
            mask_term = 8;
            for (i = 0; i < 8; i = i + 1) begin
                if (mask[i]) begin
                    if (count == ordinal)
                        mask_term = i;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar n;
    genvar k;
    generate
        for (n = 0; n < 40; n = n + 1) begin : outputs_tree
            localparam [7:0] MASK = crc_mask(n);
            wire [8:0] term;
            wire [2:0] group_parity;
            wire result;

            for (k = 0; k < 8; k = k + 1) begin : packed_terms
                localparam integer SOURCE = mask_term(MASK, k);
                if (SOURCE < 8) begin : present
                    assign term[k] = q[SOURCE];
                end else begin : absent
                    assign term[k] = 1'b0;
                end
            end

            if (n < 24) begin : shifted_state
                assign term[8] = state_in[n+8];
            end else begin : no_shifted_state
                assign term[8] = 1'b0;
            end

            assign group_parity[0] = term[0] ^ term[1] ^ term[2];
            assign group_parity[1] = term[3] ^ term[4] ^ term[5];
            assign group_parity[2] = term[6] ^ term[7] ^ term[8];
            assign result = group_parity[0] ^ group_parity[1] ^ group_parity[2];

            if (n < 32) begin : state_result
                assign state_out[n] = result;
            end else begin : data_result
                assign data_out[n-32] = result;
            end
        end
    endgenerate
endmodule
