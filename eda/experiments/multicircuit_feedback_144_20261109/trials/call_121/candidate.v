module crc32_d8 (
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);
    function [39:0] crc_mask;
        input integer index;
        reg [31:0] state_mask [0:31];
        reg [7:0] data_mask [0:31];
        reg [31:0] output_state_mask [0:7];
        reg [7:0] output_data_mask [0:7];
        reg [31:0] state_value;
        reg [7:0] data_value;
        reg [7:0] bit_mask;
        integer i;
        integer j;
        integer pass;
        begin
            for (i = 0; i < 32; i = i + 1) begin
                state_mask[i] = 32'b0;
                state_mask[i][i] = 1'b1;
                data_mask[i] = 8'b0;
            end
            for (i = 0; i < 8; i = i + 1) begin
                output_state_mask[i] = 32'b0;
                output_data_mask[i] = 8'b0;
                output_state_mask[i][i] = 1'b1;
            end

            for (pass = 0; pass < 8; pass = pass + 1) begin
                bit_mask = 8'h80 >> pass;
                state_value = state_mask[31];
                data_value = data_mask[31] ^ bit_mask;

                for (j = 31; j > 0; j = j - 1) begin
                    state_mask[j] = state_mask[j-1];
                    data_mask[j] = data_mask[j-1];
                end
                for (j = 7; j > 0; j = j - 1) begin
                    output_state_mask[j] = output_state_mask[j-1];
                    output_data_mask[j] = output_data_mask[j-1];
                end
                output_state_mask[0] = state_value;
                output_data_mask[0] = data_value;
                state_mask[0] = state_value;
                data_mask[0] = data_value;

                for (j = 1; j < 32; j = j + 1) begin
                    if ((32'h04c11db7 >> j) & 1'b1) begin
                        state_mask[j] = state_mask[j] ^ state_value;
                        data_mask[j] = data_mask[j] ^ data_value;
                    end
                end
            end

            state_value = 32'b0;
            data_value = 8'b0;
            if (index < 32) begin
                for (i = 0; i < 32; i = i + 1)
                    state_value[i] = state_mask[31-index][31-i];
                for (i = 0; i < 8; i = i + 1)
                    data_value[i] = data_mask[31-index][7-i];
            end else begin
                for (i = 0; i < 32; i = i + 1)
                    state_value[i] = output_state_mask[7-(index-32)][31-i];
                for (i = 0; i < 8; i = i + 1)
                    data_value[i] = output_data_mask[7-(index-32)][7-i];
            end
            crc_mask = {data_value, state_value};
        end
    endfunction

    function integer popcount8;
        input [7:0] value;
        integer i;
        begin
            popcount8 = 0;
            for (i = 0; i < 8; i = i + 1)
                popcount8 = popcount8 + value[i];
        end
    endfunction

    function integer bit_position;
        input [7:0] value;
        input integer bit_index;
        integer i;
        begin
            bit_position = 0;
            for (i = 0; i < bit_index; i = i + 1)
                bit_position = bit_position + value[i];
        end
    endfunction

    genvar n;
    genvar k;
    generate
        for (n = 0; n < 32; n = n + 1) begin : state_rows
            localparam [39:0] MASK = crc_mask(n);
            localparam integer TERMS = popcount8(MASK[7:0]) + popcount8(MASK[15:8]) + popcount8(MASK[23:16]) + popcount8(MASK[31:24]);
            localparam integer DATA_TERMS = popcount8(MASK[39:32]);
            localparam integer N = TERMS + DATA_TERMS;
            wire [N-1:0] operands;
            for (k = 0; k < 32; k = k + 1) begin : state_inputs
                if (MASK[k])
                    assign operands[bit_position(MASK[31:0], k)] = state_in[k];
            end
            for (k = 0; k < 8; k = k + 1) begin : data_inputs
                if (MASK[k+32])
                    assign operands[TERMS + bit_position(MASK[39:32], k)] = data_in[k];
            end
            crc32_d8_xor_tree #(.N(N)) reduce (.a(operands), .y(state_out[n]));
        end
        for (n = 0; n < 8; n = n + 1) begin : data_rows
            localparam [39:0] MASK = crc_mask(n+32);
            localparam integer TERMS = popcount8(MASK[7:0]) + popcount8(MASK[15:8]) + popcount8(MASK[23:16]) + popcount8(MASK[31:24]);
            localparam integer DATA_TERMS = popcount8(MASK[39:32]);
            localparam integer N = TERMS + DATA_TERMS;
            wire [N-1:0] operands;
            for (k = 0; k < 32; k = k + 1) begin : state_inputs
                if (MASK[k])
                    assign operands[bit_position(MASK[31:0], k)] = state_in[k];
            end
            for (k = 0; k < 8; k = k + 1) begin : data_inputs
                if (MASK[k+32])
                    assign operands[TERMS + bit_position(MASK[39:32], k)] = data_in[k];
            end
            crc32_d8_xor_tree #(.N(N)) reduce (.a(operands), .y(data_out[n]));
        end
    endgenerate
endmodule

module crc32_d8_xor_tree #(
    parameter integer N = 1
) (
    input wire [N-1:0] a,
    output wire y
);
    generate
        if (N == 1) begin : single
            assign y = a[0];
        end else begin : split
            localparam integer LEFT_N = N / 2;
            wire left_value;
            wire right_value;
            crc32_d8_xor_tree #(.N(LEFT_N)) left_tree (
                .a(a[LEFT_N-1:0]),
                .y(left_value)
            );
            crc32_d8_xor_tree #(.N(N-LEFT_N)) right_tree (
                .a(a[N-1:LEFT_N]),
                .y(right_value)
            );
            assign y = left_value ^ right_value;
        end
    endgenerate
endmodule
