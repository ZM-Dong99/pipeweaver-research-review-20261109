module axis_eth_fcs_reset (
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
    wire frame_end;
    wire crc_clear;

    assign feedback = crc_state[7:0] ^ s_axis_tdata;
    assign frame_end = s_axis_tvalid & s_axis_tlast;
    assign crc_clear = rst | frame_end;

    // Constant byte-feedback masks from the reference linear transform.
    function [7:0] feedback_mask;
        input integer bit_index;
        begin
            case (bit_index)
                 0: feedback_mask = 8'h04;
                 1: feedback_mask = 8'h09;
                 2: feedback_mask = 8'h13;
                 3: feedback_mask = 8'h26;
                 4: feedback_mask = 8'h4d;
                 5: feedback_mask = 8'h9a;
                 6: feedback_mask = 8'h30;
                 7: feedback_mask = 8'h61;
                 8: feedback_mask = 8'hc2;
                 9: feedback_mask = 8'h80;
                10: feedback_mask = 8'h04;
                11: feedback_mask = 8'h08;
                12: feedback_mask = 8'h11;
                13: feedback_mask = 8'h23;
                14: feedback_mask = 8'h46;
                15: feedback_mask = 8'h8c;
                16: feedback_mask = 8'h1d;
                17: feedback_mask = 8'h3b;
                18: feedback_mask = 8'h77;
                19: feedback_mask = 8'hee;
                20: feedback_mask = 8'hd8;
                21: feedback_mask = 8'hb4;
                22: feedback_mask = 8'h6c;
                23: feedback_mask = 8'hd8;
                24: feedback_mask = 8'hb5;
                25: feedback_mask = 8'h6f;
                26: feedback_mask = 8'hdf;
                27: feedback_mask = 8'hba;
                28: feedback_mask = 8'h71;
                29: feedback_mask = 8'he3;
                30: feedback_mask = 8'hc3;
                31: feedback_mask = 8'h82;
                default: feedback_mask = 8'h00;
            endcase
        end
    endfunction

    genvar b;
    generate
        for (b = 0; b < 32; b = b + 1) begin : crc_bits
            localparam [7:0] MASK = feedback_mask(b);
            wire parity;
            assign parity = ^(feedback & MASK);
            if (b < 24) begin : with_shifted_state
                assign crc_next[b] = parity ^ crc_state[b+8];
            end else begin : feedback_only
                assign crc_next[b] = parity;
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (crc_clear)
            crc_state <= 32'hffffffff;
        else if (s_axis_tvalid)
            crc_state <= crc_next;

        if (rst)
            fcs_reg <= 32'h00000000;
        else if (frame_end)
            fcs_reg <= ~crc_next;

        if (rst)
            fcs_valid_reg <= 1'b0;
        else
            fcs_valid_reg <= frame_end;
    end

    assign s_axis_tready = 1'b1;
    assign output_fcs = fcs_reg;
    assign output_fcs_valid = fcs_valid_reg;
endmodule
