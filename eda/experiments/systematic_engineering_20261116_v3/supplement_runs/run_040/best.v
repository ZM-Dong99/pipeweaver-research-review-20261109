module axis_eth_fcs_reset(
    input wire clk,
    input wire rst,
    input wire [7:0] s_axis_tdata,
    input wire s_axis_tkeep,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tlast,
    input wire s_axis_tuser,
    output wire [31:0] output_fcs,
    output wire output_fcs_valid
);
    reg [31:0] crc_state;
    reg [31:0] fcs_reg;
    reg fcs_valid_reg;
    wire [31:0] crc_next;
    wire [7:0] feedback;

    // Combine matching data and state terms before the parity network.
    assign feedback = crc_state[7:0] ^ s_axis_tdata;

    assign crc_next[0]  = crc_state[8]  ^ (^(feedback & 8'h04));
    assign crc_next[1]  = crc_state[9]  ^ (^(feedback & 8'h09));
    assign crc_next[2]  = crc_state[10] ^ (^(feedback & 8'h13));
    assign crc_next[3]  = crc_state[11] ^ (^(feedback & 8'h26));
    assign crc_next[4]  = crc_state[12] ^ (^(feedback & 8'h4d));
    assign crc_next[5]  = crc_state[13] ^ (^(feedback & 8'h9a));
    assign crc_next[6]  = crc_state[14] ^ (^(feedback & 8'h30));
    assign crc_next[7]  = crc_state[15] ^ (^(feedback & 8'h61));
    assign crc_next[8]  = crc_state[16] ^ (^(feedback & 8'hc2));
    assign crc_next[9]  = crc_state[17] ^ (^(feedback & 8'h80));
    assign crc_next[10] = crc_state[18] ^ (^(feedback & 8'h04));
    assign crc_next[11] = crc_state[19] ^ (^(feedback & 8'h08));
    assign crc_next[12] = crc_state[20] ^ (^(feedback & 8'h11));
    assign crc_next[13] = crc_state[21] ^ (^(feedback & 8'h23));
    assign crc_next[14] = crc_state[22] ^ (^(feedback & 8'h46));
    assign crc_next[15] = crc_state[23] ^ (^(feedback & 8'h8c));
    assign crc_next[16] = crc_state[24] ^ (^(feedback & 8'h1d));
    assign crc_next[17] = crc_state[25] ^ (^(feedback & 8'h3b));
    assign crc_next[18] = crc_state[26] ^ (^(feedback & 8'h77));
    assign crc_next[19] = crc_state[27] ^ (^(feedback & 8'hee));
    assign crc_next[20] = crc_state[28] ^ (^(feedback & 8'hd8));
    assign crc_next[21] = crc_state[29] ^ (^(feedback & 8'hb4));
    assign crc_next[22] = crc_state[30] ^ (^(feedback & 8'h6c));
    assign crc_next[23] = crc_state[31] ^ (^(feedback & 8'hd8));
    assign crc_next[24] = ^(feedback & 8'hb5);
    assign crc_next[25] = ^(feedback & 8'h6f);
    assign crc_next[26] = ^(feedback & 8'hdf);
    assign crc_next[27] = ^(feedback & 8'hba);
    assign crc_next[28] = ^(feedback & 8'h71);
    assign crc_next[29] = ^(feedback & 8'he3);
    assign crc_next[30] = ^(feedback & 8'hc3);
    assign crc_next[31] = ^(feedback & 8'h82);

    always @(posedge clk) begin
        if (rst)
            crc_state <= 32'hffffffff;
        else if (s_axis_tvalid) begin
            if (s_axis_tlast)
                crc_state <= 32'hffffffff;
            else
                crc_state <= crc_next;
        end
    end

    always @(posedge clk) begin
        if (rst)
            fcs_reg <= 32'h00000000;
        else if (s_axis_tvalid && s_axis_tlast)
            fcs_reg <= ~crc_next;
    end

    always @(posedge clk) begin
        if (rst || !s_axis_tvalid)
            fcs_valid_reg <= 1'b0;
        else
            fcs_valid_reg <= s_axis_tlast;
    end

    assign s_axis_tready = 1'b1;
    assign output_fcs = fcs_reg;
    assign output_fcs_valid = fcs_valid_reg;
endmodule
