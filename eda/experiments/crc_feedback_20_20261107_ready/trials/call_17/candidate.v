module crc32_d8(
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

function [39:0] crc_mask;
    input integer out_idx;
    reg [39:0] state_vec [0:31];
    reg [39:0] data_vec [0:7];
    reg [39:0] shifted_out [0:7];
    reg [39:0] feedback;
    integer i;
    integer j;
    integer k;
    begin
        for (i = 0; i < 32; i = i + 1) begin
            state_vec[i] = 40'b0;
            state_vec[i][i] = 1'b1;
        end
        for (i = 0; i < 8; i = i + 1) begin
            data_vec[i] = 40'b0;
            data_vec[i][32+i] = 1'b1;
            shifted_out[i] = 40'b0;
        end

        for (k = 0; k < 8; k = k + 1) begin
            feedback = state_vec[0] ^ data_vec[k];
            shifted_out[k] = state_vec[0];

            for (j = 0; j < 31; j = j + 1)
                state_vec[j] = state_vec[j+1];
            state_vec[31] = 40'b0;

            for (j = 0; j < 32; j = j + 1) begin
                if ((32'hedb88320 >> j) & 1)
                    state_vec[j] = state_vec[j] ^ feedback;
            end
        end

        if (out_idx < 32)
            crc_mask = state_vec[out_idx];
        else
            crc_mask = shifted_out[7-(out_idx-32)];
    end
endfunction

genvar n;
generate
    for (n = 0; n < 32; n = n + 1) begin : state_bits
        assign state_out[n] = ^({data_in, state_in} & crc_mask(n));
    end
    for (n = 0; n < 8; n = n + 1) begin : data_bits
        assign data_out[n] = ^({data_in, state_in} & crc_mask(32+n));
    end
endgenerate

endmodule
