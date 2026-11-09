module crc32_d8(
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    function automatic [39:0] crc_mask(input integer index);
        reg [31:0] state_mask [0:31];
        reg [7:0]  data_mask_vec [0:31];
        reg [31:0] output_state_mask [0:7];
        reg [7:0]  output_data_mask [0:7];
        reg [31:0] state_val;
        reg [7:0]  data_val;
        reg [7:0]  step_mask;
        reg [31:0] state_result;
        reg [7:0]  data_result;
        integer i;
        integer j;
        begin
            for (i = 0; i < 32; i = i + 1) begin
                state_mask[i] = 32'b0;
                state_mask[i][i] = 1'b1;
                data_mask_vec[i] = 8'b0;
            end
            for (i = 0; i < 8; i = i + 1) begin
                output_state_mask[i] = 32'b0;
                output_data_mask[i] = 8'b0;
            end

            for (step_mask = 8'b10000000;
                 step_mask != 8'b0;
                 step_mask = step_mask >> 1) begin
                state_val = state_mask[31];
                data_val = data_mask_vec[31] ^ step_mask;

                for (j = 31; j > 0; j = j - 1) begin
                    state_mask[j] = state_mask[j-1];
                    data_mask_vec[j] = data_mask_vec[j-1];
                end
                for (j = 7; j > 0; j = j - 1) begin
                    output_state_mask[j] = output_state_mask[j-1];
                    output_data_mask[j] = output_data_mask[j-1];
                end

                output_state_mask[0] = state_val;
                output_data_mask[0] = data_val;
                state_mask[0] = state_val;
                data_mask_vec[0] = data_val;

                for (j = 1; j < 32; j = j + 1) begin
                    if ((32'h04c11db7 >> j) & 1'b1) begin
                        state_mask[j] = state_mask[j] ^ state_val;
                        data_mask_vec[j] = data_mask_vec[j] ^ data_val;
                    end
                end
            end

            state_result = 32'b0;
            data_result = 8'b0;
            if (index < 32) begin
                for (i = 0; i < 32; i = i + 1)
                    state_result[i] = state_mask[31-index][31-i];
                for (i = 0; i < 8; i = i + 1)
                    data_result[i] = data_mask_vec[31-index][7-i];
            end else begin
                for (i = 0; i < 32; i = i + 1)
                    state_result[i] = output_state_mask[7-(index-32)][31-i];
                for (i = 0; i < 8; i = i + 1)
                    data_result[i] = output_data_mask[7-(index-32)][7-i];
            end
            crc_mask = {data_result, state_result};
        end
    endfunction

    wire [39:0] input_vector;
    assign input_vector = {data_in, state_in};

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : state_bits
            assign state_out[n] = ^(input_vector & crc_mask(n));
        end
        for (n = 0; n < 8; n = n + 1) begin : data_bits
            assign data_out[n] = ^(input_vector & crc_mask(n + 32));
        end
    endgenerate
endmodule
