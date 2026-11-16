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
wire [7:0] q;
assign q = crc_state[7:0] ^ s_axis_tdata;

// Parallel GF(2) equations. Fold the matching data/state terms first.
assign crc_next[0]  = q[2] ^ crc_state[8];
assign crc_next[1]  = ^{q[0],q[3],crc_state[9]};
assign crc_next[2]  = ^{q[0],q[1],q[4],crc_state[10]};
assign crc_next[3]  = ^{q[1],q[2],q[5],crc_state[11]};
assign crc_next[4]  = ^{q[0],q[2],q[3],q[6],crc_state[12]};
assign crc_next[5]  = ^{q[1],q[3],q[4],q[7],crc_state[13]};
assign crc_next[6]  = ^{q[4],q[5],crc_state[14]};
assign crc_next[7]  = ^{q[0],q[5],q[6],crc_state[15]};
assign crc_next[8]  = ^{q[1],q[6],q[7],crc_state[16]};
assign crc_next[9]  = q[7] ^ crc_state[17];
assign crc_next[10] = q[2] ^ crc_state[18];
assign crc_next[11] = q[3] ^ crc_state[19];
assign crc_next[12] = ^{q[0],q[4],crc_state[20]};
assign crc_next[13] = ^{q[0],q[1],q[5],crc_state[21]};
assign crc_next[14] = ^{q[1],q[2],q[6],crc_state[22]};
assign crc_next[15] = ^{q[2],q[3],q[7],crc_state[23]};
assign crc_next[16] = ^{q[0],q[2],q[3],q[4],crc_state[24]};
assign crc_next[17] = ^{q[0],q[1],q[3],q[4],q[5],crc_state[25]};
assign crc_next[18] = ^{q[0],q[1],q[2],q[4],q[5],q[6],crc_state[26]};
assign crc_next[19] = ^{q[1],q[2],q[3],q[5],q[6],q[7],crc_state[27]};
assign crc_next[20] = ^{q[3],q[4],q[6],q[7],crc_state[28]};
assign crc_next[21] = ^{q[2],q[4],q[5],q[7],crc_state[29]};
assign crc_next[22] = ^{q[2],q[3],q[5],q[6],crc_state[30]};
assign crc_next[23] = ^{q[3],q[4],q[6],q[7],crc_state[31]};
assign crc_next[24] = ^{q[0],q[2],q[4],q[5],q[7]};
assign crc_next[25] = ^{q[0],q[1],q[2],q[3],q[5],q[6]};
assign crc_next[26] = ^{q[0],q[1],q[2],q[3],q[4],q[6],q[7]};
assign crc_next[27] = ^{q[1],q[3],q[4],q[5],q[7]};
assign crc_next[28] = ^{q[0],q[4],q[5],q[6]};
assign crc_next[29] = ^{q[0],q[1],q[5],q[6],q[7]};
assign crc_next[30] = ^{q[0],q[1],q[6],q[7]};
assign crc_next[31] = q[1] ^ q[7];

// Disjoint update terms avoid a priority mux chain on the CRC result.
wire crc_load = ~rst & s_axis_tvalid & ~s_axis_tlast;
wire crc_hold = ~rst & ~s_axis_tvalid;
wire crc_clear = rst | (s_axis_tvalid & s_axis_tlast);
wire fcs_load = ~rst & s_axis_tvalid & s_axis_tlast;
wire fcs_hold = ~rst & ~(s_axis_tvalid & s_axis_tlast);

always @(posedge clk) begin
    crc_state <= ({32{crc_load}} & crc_next)
               | ({32{crc_hold}} & crc_state)
               | {32{crc_clear}};
    fcs_reg <= ({32{fcs_load}} & ~crc_next)
             | ({32{fcs_hold}} & fcs_reg);
    fcs_valid_reg <= ~rst & s_axis_tvalid & s_axis_tlast;
end

assign s_axis_tready = 1'b1;
assign output_fcs = fcs_reg;
assign output_fcs_valid = fcs_valid_reg;
endmodule
