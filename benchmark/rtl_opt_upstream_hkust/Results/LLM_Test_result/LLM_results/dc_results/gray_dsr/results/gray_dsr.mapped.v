/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:39:13 2025
/////////////////////////////////////////////////////////////


module gray_dsr ( clk, rst_n, cmd, out );
  input [3:0] cmd;
  output [7:0] out;
  input clk, rst_n;
  wire   n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64,
         n65, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93,
         n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105,
         n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
         n139;
  wire   [3:0] state;
  wire   [3:0] next_state;

  DFFR_X1 state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(rst_n), .Q(state[0]), 
        .QN(n87) );
  DFFR_X1 state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(rst_n), .Q(state[1]), 
        .QN(n80) );
  DFFR_X1 state_reg_2_ ( .D(next_state[2]), .CK(clk), .RN(rst_n), .Q(state[2]), 
        .QN(n86) );
  DFFR_X1 state_reg_3_ ( .D(next_state[3]), .CK(clk), .RN(rst_n), .Q(state[3]), 
        .QN(n85) );
  BUF_X1 U65 ( .A(n87), .Z(n76) );
  INV_X1 U66 ( .A(n80), .ZN(n81) );
  BUF_X1 U67 ( .A(state[0]), .Z(n57) );
  INV_X1 U68 ( .A(n99), .ZN(n51) );
  BUF_X1 U69 ( .A(n72), .Z(n52) );
  INV_X1 U70 ( .A(n74), .ZN(n53) );
  OR2_X1 U71 ( .A1(n74), .A2(cmd[2]), .ZN(n54) );
  CLKBUF_X1 U72 ( .A(n86), .Z(n55) );
  CLKBUF_X1 U73 ( .A(n130), .Z(n56) );
  INV_X1 U74 ( .A(n85), .ZN(n58) );
  NAND3_X1 U75 ( .A1(n108), .A2(n101), .A3(n96), .ZN(n59) );
  NAND2_X1 U76 ( .A1(n84), .A2(n60), .ZN(n97) );
  INV_X1 U77 ( .A(n59), .ZN(n60) );
  NOR3_X1 U78 ( .A1(n97), .A2(n70), .A3(n54), .ZN(n98) );
  BUF_X1 U79 ( .A(n87), .Z(n74) );
  OR2_X1 U80 ( .A1(n137), .A2(n81), .ZN(n61) );
  NAND2_X1 U81 ( .A1(n61), .A2(n90), .ZN(n123) );
  BUF_X1 U82 ( .A(n123), .Z(n73) );
  BUF_X1 U83 ( .A(n86), .Z(n70) );
  BUF_X1 U84 ( .A(n86), .Z(n63) );
  CLKBUF_X1 U85 ( .A(n134), .Z(n62) );
  INV_X1 U86 ( .A(n70), .ZN(n64) );
  AND4_X1 U87 ( .A1(n91), .A2(n96), .A3(n84), .A4(n77), .ZN(n65) );
  OAI21_X1 U88 ( .B1(n79), .B2(n108), .A(out[4]), .ZN(n110) );
  AND2_X1 U89 ( .A1(n68), .A2(n62), .ZN(n109) );
  AOI21_X1 U90 ( .B1(n107), .B2(n79), .A(n65), .ZN(n111) );
  AND3_X1 U91 ( .A1(n82), .A2(n74), .A3(state[2]), .ZN(out[4]) );
  NAND4_X1 U92 ( .A1(n111), .A2(n109), .A3(n110), .A4(n129), .ZN(next_state[3]) );
  BUF_X1 U93 ( .A(n85), .Z(n67) );
  CLKBUF_X1 U94 ( .A(n131), .Z(n68) );
  BUF_X1 U95 ( .A(state[0]), .Z(n69) );
  INV_X1 U96 ( .A(n86), .ZN(n71) );
  INV_X1 U97 ( .A(n75), .ZN(n72) );
  BUF_X1 U98 ( .A(n87), .Z(n75) );
  INV_X1 U99 ( .A(state[3]), .ZN(n77) );
  NOR2_X1 U100 ( .A1(n76), .A2(n82), .ZN(n107) );
  CLKBUF_X1 U101 ( .A(n86), .Z(n78) );
  INV_X1 U102 ( .A(n85), .ZN(n79) );
  INV_X1 U103 ( .A(n80), .ZN(n82) );
  INV_X1 U104 ( .A(state[1]), .ZN(n83) );
  INV_X1 U105 ( .A(state[1]), .ZN(n84) );
  NAND3_X1 U106 ( .A1(state[2]), .A2(state[3]), .A3(state[0]), .ZN(n137) );
  INV_X1 U107 ( .A(cmd[2]), .ZN(n115) );
  NOR3_X1 U108 ( .A1(n85), .A2(cmd[3]), .A3(n115), .ZN(n89) );
  INV_X1 U109 ( .A(cmd[3]), .ZN(n108) );
  OAI21_X1 U110 ( .B1(n108), .B2(state[3]), .A(state[1]), .ZN(n88) );
  OAI211_X1 U111 ( .C1(n81), .C2(n89), .A(n88), .B(n71), .ZN(n90) );
  INV_X1 U112 ( .A(n73), .ZN(n93) );
  NAND2_X1 U113 ( .A1(n63), .A2(n76), .ZN(n112) );
  NAND2_X1 U114 ( .A1(n67), .A2(n81), .ZN(n113) );
  INV_X1 U115 ( .A(cmd[0]), .ZN(n96) );
  NAND2_X1 U116 ( .A1(n75), .A2(n86), .ZN(n126) );
  INV_X1 U117 ( .A(n126), .ZN(n91) );
  AOI221_X1 U118 ( .B1(n64), .B2(n52), .C1(n100), .C2(cmd[2]), .A(n65), .ZN(
        n92) );
  NAND2_X1 U119 ( .A1(n92), .A2(n93), .ZN(next_state[2]) );
  NAND4_X1 U120 ( .A1(state[2]), .A2(n58), .A3(n69), .A4(n83), .ZN(n95) );
  NAND4_X1 U121 ( .A1(n81), .A2(n69), .A3(n77), .A4(n63), .ZN(n94) );
  NAND2_X1 U122 ( .A1(n95), .A2(n94), .ZN(out[2]) );
  NOR2_X1 U123 ( .A1(n112), .A2(n113), .ZN(n100) );
  NAND4_X1 U124 ( .A1(n53), .A2(n82), .A3(state[2]), .A4(n58), .ZN(n131) );
  INV_X1 U125 ( .A(n131), .ZN(n99) );
  INV_X1 U126 ( .A(cmd[1]), .ZN(n101) );
  AOI221_X1 U127 ( .B1(n100), .B2(cmd[2]), .C1(cmd[1]), .C2(n99), .A(n98), 
        .ZN(n106) );
  NAND2_X1 U128 ( .A1(state[0]), .A2(n85), .ZN(n130) );
  NAND2_X1 U129 ( .A1(cmd[1]), .A2(cmd[0]), .ZN(n118) );
  NOR3_X1 U130 ( .A1(n56), .A2(n71), .A3(n118), .ZN(n104) );
  XOR2_X1 U131 ( .A(n101), .B(cmd[0]), .Z(n102) );
  NOR4_X1 U132 ( .A1(n112), .A2(n84), .A3(n102), .A4(n77), .ZN(n103) );
  NOR4_X1 U133 ( .A1(out[2]), .A2(n103), .A3(n104), .A4(out[4]), .ZN(n105) );
  NAND2_X1 U134 ( .A1(n106), .A2(n105), .ZN(next_state[1]) );
  NAND4_X1 U135 ( .A1(state[2]), .A2(n79), .A3(n84), .A4(n76), .ZN(n129) );
  NAND4_X1 U136 ( .A1(n82), .A2(n55), .A3(state[3]), .A4(n74), .ZN(n134) );
  INV_X1 U137 ( .A(n112), .ZN(n116) );
  INV_X1 U138 ( .A(n113), .ZN(n114) );
  NAND3_X1 U139 ( .A1(n116), .A2(n115), .A3(n114), .ZN(n125) );
  NAND2_X1 U140 ( .A1(n67), .A2(n78), .ZN(n119) );
  NAND3_X1 U141 ( .A1(n80), .A2(n78), .A3(cmd[0]), .ZN(n117) );
  OAI33_X1 U142 ( .A1(n119), .A2(n81), .A3(n118), .B1(n117), .B2(n72), .B3(n79), .ZN(n122) );
  INV_X1 U143 ( .A(n134), .ZN(n121) );
  NAND4_X1 U144 ( .A1(n57), .A2(state[2]), .A3(n82), .A4(n85), .ZN(n133) );
  INV_X1 U145 ( .A(n133), .ZN(n120) );
  NOR4_X1 U146 ( .A1(n123), .A2(n122), .A3(n121), .A4(n120), .ZN(n124) );
  OAI211_X1 U147 ( .C1(cmd[1]), .C2(n51), .A(n125), .B(n124), .ZN(
        next_state[0]) );
  NOR2_X1 U148 ( .A1(n81), .A2(n126), .ZN(out[0]) );
  INV_X1 U149 ( .A(n130), .ZN(n127) );
  NAND3_X1 U150 ( .A1(n127), .A2(n63), .A3(n83), .ZN(n128) );
  NAND2_X1 U151 ( .A1(n128), .A2(n129), .ZN(out[1]) );
  NAND3_X1 U152 ( .A1(n81), .A2(n76), .A3(n70), .ZN(n132) );
  OAI21_X1 U153 ( .B1(n77), .B2(n72), .A(n130), .ZN(n138) );
  AOI21_X1 U154 ( .B1(n131), .B2(n132), .A(n138), .ZN(out[3]) );
  NAND2_X1 U155 ( .A1(n133), .A2(n134), .ZN(out[5]) );
  NOR3_X1 U156 ( .A1(n70), .A2(n58), .A3(n76), .ZN(n136) );
  NOR3_X1 U157 ( .A1(n67), .A2(n71), .A3(n76), .ZN(n135) );
  MUX2_X1 U158 ( .A(n136), .B(n135), .S(n81), .Z(out[6]) );
  OAI211_X1 U159 ( .C1(n71), .C2(n79), .A(n83), .B(n137), .ZN(n139) );
  NOR2_X1 U160 ( .A1(n139), .A2(n138), .ZN(out[7]) );
endmodule

