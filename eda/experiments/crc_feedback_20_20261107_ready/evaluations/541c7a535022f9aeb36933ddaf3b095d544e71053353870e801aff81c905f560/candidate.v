module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Fold the incoming byte into the low state byte before
    // evaluating the fixed reflected CRC transformation.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Return the eight-bit coefficient mask for one output.
    // Indices 0..31 select next-state bits; 32..39 select the
    // feedback bits in chronological, reflected output order.
    // This function is evaluated only with elaboration constants.
    function automatic [7:0] coefficient_mask;
        input integer index;
        reg [31:0] r;
        reg [7:0] feedback;
        reg b;
        integer k;
        integer t;
        begin
            coefficient_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                r = 32'h00000001 << k;
                feedback = 8'b0;
                for (t = 0; t < 8; t = t + 1) begin
                    b = r[0];
                    feedback[t] = b;
                    r = r >> 1;
                    if (b)
                        r = r ^ 32'hedb88320;
                end
                if (index < 32)
                    coefficient_mask[k] = r[index];
                else
                    coefficient_mask[k] = feedback[index-32];
            end
        end
    endfunction

    function automatic integer population;
        input [7:0] mask;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                population = population + (mask[k] ? 1 : 0);
        end
    endfunction

    // Map a compact leaf position to its selected q bit.
    function automatic integer selected_bit;
        input [7:0] mask;
        input integer position;
        integer k;
        integer count;
        begin
            selected_bit = 0;
            count = 0;
            for (k = 0; k < 8; k = k + 1) begin
                if (mask[k]) begin
                    if (count == position)
                        selected_bit = k;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar o, l, n;
    generate
        for (o = 0; o < 40; o = o + 1) begin : outputs_balanced
            localparam [7:0] MASK = coefficient_mask(o);
            localparam integer Q_COUNT = population(MASK);
            localparam integer HAS_STATE = (o < 24) ? 1 : 0;
            localparam integer COUNT = Q_COUNT + HAS_STATE;
            localparam integer LEAVES = (COUNT <= 1) ? 1 :
                                        (COUNT <= 2) ? 2 :
                                        (COUNT <= 4) ? 4 :
                                        (COUNT <= 8) ? 8 : 16;
            wire [2*LEAVES-1:1] tree;

            for (l = 0; l < LEAVES; l = l + 1) begin : leaves
                if (l < Q_COUNT) begin : from_q
                    localparam integer BIT_INDEX = selected_bit(MASK, l);
                    assign tree[LEAVES+l] = q[BIT_INDEX];
                end else if ((HAS_STATE != 0) && (l == Q_COUNT)) begin : from_state
                    assign tree[LEAVES+l] = state_in[o+8];
                end else begin : padding
                    assign tree[LEAVES+l] = 1'b0;
                end
            end

            for (n = 1; n < LEAVES; n = n + 1) begin : branches
                assign tree[n] = tree[2*n] ^ tree[2*n+1];
            end

            if (o < 32) begin : state_result
                assign state_out[o] = tree[1];
            end else begin : data_result
                assign data_out[o-32] = tree[1];
            end
        end
    endgenerate
endmodule
