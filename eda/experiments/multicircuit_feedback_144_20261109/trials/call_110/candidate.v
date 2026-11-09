`default_nettype none
module crc32_d8(input wire [7:0] data_in, input wire [31:0] state_in, output wire [7:0] data_out, output wire [31:0] state_out);
    reg [31:0] state;
    reg [7:0] shifted_data;
    reg feedback;
    integer i;

    always @* begin
        for (i = 0; i < 32; i = i + 1)
            state[i] = state_in[31-i];
        shifted_data = 8'b0;
        feedback = 1'b0;
        for (i = 0; i < 8; i = i + 1) begin
            feedback = state[31] ^ data_in[i];
            shifted_data[i] = feedback;
            state = {state[30:0], feedback} ^ ({32{feedback}} & 32'h04c11db6);
        end
    end

    genvar k;
    generate
        for (k = 0; k < 8; k = k + 1) begin : gen_data
            assign data_out[k] = shifted_data[k];
        end
        for (k = 0; k < 32; k = k + 1) begin : gen_state
            assign state_out[k] = state[31-k];
        end
    endgenerate
endmodule
`default_nettype wire
