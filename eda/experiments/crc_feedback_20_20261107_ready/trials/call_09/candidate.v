module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Fold each incoming bit into the corresponding low state bit once.
    wire [7:0] x;
    assign x = data_in ^ state_in[7:0];

    // Constant-only symbolic evaluation of eight reflected Galois steps.
    // Bits 0..31 select state outputs; bits 32..39 select data outputs.
    function automatic [7:0] contribution_mask(input integer index);
        reg [7:0] s [0:31];
        reg [7:0] d [0:7];
        reg [7:0] feedback;
        reg [31:0] poly;
        integer i, k;
        begin
            poly = 32'hedb88320;
            for (i = 0; i < 32; i = i + 1) begin
                s[i] = 8'b0;
                if (i < 8)
                    s[i] = 8'b1 << i;
            end
            for (k = 0; k < 8; k = k + 1) begin
                feedback = s[0];
                d[k] = feedback;
                for (i = 0; i < 31; i = i + 1)
                    s[i] = s[i+1];
                s[31] = 8'b0;
                for (i = 0; i < 32; i = i + 1)
                    if (poly[i])
                        s[i] = s[i] ^ feedback;
            end
            if (index < 32)
                contribution_mask = s[index];
            else
                contribution_mask = d[index-32];
        end
    endfunction

    // Return the ordinal-th selected input, or -1 for an unused leaf.
    function automatic integer selected_bit(
        input [7:0] mask,
        input integer ordinal
    );
        integer i, count;
        begin
            selected_bit = -1;
            count = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (mask[i]) begin
                    if (count == ordinal)
                        selected_bit = i;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar o, j;
    generate
        for (o = 0; o < 40; o = o + 1) begin : output_tree
            localparam [7:0] MASK = contribution_mask(o);
            wire [15:0] leaf;
            wire [7:0] level1;
            wire [3:0] level2;
            wire [1:0] level3;
            wire result;

            if (o < 24) begin : shifted_state
                assign leaf[0] = state_in[o+8];
            end else begin : no_shifted_state
                assign leaf[0] = 1'b0;
            end

            for (j = 0; j < 8; j = j + 1) begin : selected_terms
                localparam integer BIT_INDEX = selected_bit(MASK, j);
                if (BIT_INDEX >= 0) begin : present
                    assign leaf[j+1] = x[BIT_INDEX];
                end else begin : absent
                    assign leaf[j+1] = 1'b0;
                end
            end
            assign leaf[15:9] = 7'b0;

            for (j = 0; j < 8; j = j + 1) begin : first_level
                assign level1[j] = leaf[2*j] ^ leaf[2*j+1];
            end
            for (j = 0; j < 4; j = j + 1) begin : second_level
                assign level2[j] = level1[2*j] ^ level1[2*j+1];
            end
            for (j = 0; j < 2; j = j + 1) begin : third_level
                assign level3[j] = level2[2*j] ^ level2[2*j+1];
            end
            assign result = level3[0] ^ level3[1];

            if (o < 32) begin : state_result
                assign state_out[o] = result;
            end else begin : data_result
                assign data_out[o-32] = result;
            end
        end
    endgenerate
endmodule
