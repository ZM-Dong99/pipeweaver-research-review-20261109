// Project-authored composition of the public axis_adapter and axis_register.
// The adapter packs bytes, then a two-entry skid register accepts backpressure.
// Invalid output data and sidebands are explicitly zero in this new interface.
module pw_axis_chain #(
    parameter M_DATA_WIDTH = 32,
    parameter M_KEEP_WIDTH = M_DATA_WIDTH/8
)(
    input wire clk, rst,
    input wire [7:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tlast,
    input wire s_axis_tuser,
    output wire [M_DATA_WIDTH-1:0] m_axis_tdata,
    output wire [M_KEEP_WIDTH-1:0] m_axis_tkeep,
    output wire m_axis_tvalid,
    input wire m_axis_tready,
    output wire m_axis_tlast,
    output wire m_axis_tuser
);
    wire [M_DATA_WIDTH-1:0] packed_data, registered_data;
    wire [M_KEEP_WIDTH-1:0] packed_keep, registered_keep;
    wire packed_valid, packed_ready, packed_last, packed_user;
    wire registered_last, registered_user;

    axis_adapter #(
        .S_DATA_WIDTH(8), .S_KEEP_ENABLE(0), .S_KEEP_WIDTH(1),
        .M_DATA_WIDTH(M_DATA_WIDTH), .M_KEEP_ENABLE(1),
        .M_KEEP_WIDTH(M_KEEP_WIDTH), .ID_ENABLE(0), .ID_WIDTH(1),
        .DEST_ENABLE(0), .DEST_WIDTH(1), .USER_ENABLE(1), .USER_WIDTH(1)
    ) adapter (
        .clk(clk), .rst(rst), .s_axis_tdata(s_axis_tdata), .s_axis_tkeep(1'b1),
        .s_axis_tvalid(s_axis_tvalid), .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast), .s_axis_tid(1'b0), .s_axis_tdest(1'b0),
        .s_axis_tuser(s_axis_tuser), .m_axis_tdata(packed_data),
        .m_axis_tkeep(packed_keep), .m_axis_tvalid(packed_valid),
        .m_axis_tready(packed_ready), .m_axis_tlast(packed_last),
        .m_axis_tid(), .m_axis_tdest(), .m_axis_tuser(packed_user)
    );

    axis_register #(
        .DATA_WIDTH(M_DATA_WIDTH), .KEEP_ENABLE(1), .KEEP_WIDTH(M_KEEP_WIDTH),
        .LAST_ENABLE(1), .ID_ENABLE(0), .ID_WIDTH(1), .DEST_ENABLE(0),
        .DEST_WIDTH(1), .USER_ENABLE(1), .USER_WIDTH(1), .REG_TYPE(2)
    ) skid_register (
        .clk(clk), .rst(rst), .s_axis_tdata(packed_data), .s_axis_tkeep(packed_keep),
        .s_axis_tvalid(packed_valid), .s_axis_tready(packed_ready),
        .s_axis_tlast(packed_last), .s_axis_tid(1'b0), .s_axis_tdest(1'b0),
        .s_axis_tuser(packed_user), .m_axis_tdata(registered_data),
        .m_axis_tkeep(registered_keep), .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready), .m_axis_tlast(registered_last),
        .m_axis_tid(), .m_axis_tdest(), .m_axis_tuser(registered_user)
    );

    genvar lane;
    generate
        for (lane = 0; lane < M_KEEP_WIDTH; lane = lane+1) begin: valid_bytes
            assign m_axis_tdata[lane*8 +: 8] =
                m_axis_tvalid && registered_keep[lane] ? registered_data[lane*8 +: 8] : 0;
        end
    endgenerate
    assign m_axis_tkeep = m_axis_tvalid ? registered_keep : 0;
    assign m_axis_tlast = m_axis_tvalid && registered_last;
    assign m_axis_tuser = m_axis_tvalid && registered_user;
endmodule
