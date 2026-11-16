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

    assign feedback = crc_state[7:0] ^ s_axis_tdata;

    function [7:0] crc_mask;
        input integer index;
        begin
            case (index)
                0: crc_mask = 8'h04;
                1: crc_mask = 8'h09;
                2: crc_mask = 8'h13;
                3: crc_mask = 8'h26;
                4: crc_mask = 8'h4d;
                5: crc_mask = 8'h9a;
                6: crc_mask = 8'h30;
                7: crc_mask = 8'h61;
                8: crc_mask = 8'hc2;
                9: crc_mask = 8'h80;
                10: crc_mask = 8'h04;
                11: crc_mask = 8'h08;
                12: crc_mask = 8'h11;
                13: crc_mask = 8'h23;
                14: crc_mask = 8'h46;
                15: crc_mask = 8'h8c;
                16: crc_mask = 8'h1d;
                17: crc_mask = 8'h3b;
                18: crc_mask = 8'h77;
                19: crc_mask = 8'hee;
                20: crc_mask = 8'hd8;
                21: crc_mask = 8'hb4;
                22: crc_mask = 8'h6c;
                23: crc_mask = 8'hd8;
                24: crc_mask = 8'hb5;
                25: crc_mask = 8'h6f;
                26: crc_mask = 8'hdf;
                27: crc_mask = 8'hba;
                28: crc_mask = 8'h71;
                29: crc_mask = 8'he3;
                30: crc_mask = 8'hc3;
                31: crc_mask = 8'h82;
                default: crc_mask = 8'h00;
            endcase
        end
    endfunction

    genvar bit_index;
    generate
        for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1) begin : crc_bits
            localparam [7:0] MASK = crc_mask(bit_index);
            wire parity;
            assign parity = ^(feedback & MASK);
            if (bit_index < 24) begin : shifted
                assign crc_next[bit_index] = parity ^ crc_state[bit_index+8];
            end else begin : unshifted
                assign crc_next[bit_index] = parity;
            end
        end
    endgenerate

    wire frame_end;
    wire crc_set;
    wire crc_load;
    wire crc_hold;
    wire fcs_load;
    wire fcs_hold;
    assign frame_end = s_axis_tvalid & s_axis_tlast;
    assign crc_set = rst | frame_end;
    assign crc_load = ~rst & s_axis_tvalid & ~s_axis_tlast;
    assign crc_hold = ~rst & ~s_axis_tvalid;
    assign fcs_load = ~rst & frame_end;
    assign fcs_hold = ~rst & ~frame_end;

    always @(posedge clk) begin
        crc_state <= {32{crc_set}} |
                     (crc_next & {32{crc_load}}) |
                     (crc_state & {32{crc_hold}});
        fcs_reg <= (~crc_next & {32{fcs_load}}) |
                   (fcs_reg & {32{fcs_hold}});
        fcs_valid_reg <= ~rst & frame_end;
    end

    assign s_axis_tready = 1'b1;
    assign output_fcs = fcs_reg;
    assign output_fcs_valid = fcs_valid_reg;
endmodule
