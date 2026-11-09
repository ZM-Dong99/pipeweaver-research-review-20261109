/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:07:53 2025
/////////////////////////////////////////////////////////////


module gray_ref ( clk, rst_n, cmd, out );
  input [3:0] cmd;
  output [7:0] out;
  input clk, rst_n;
  wire   n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93,
         n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105,
         n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116,
         n117, n118, n119, n120;
  wire   [3:0] state;
  wire   [3:0] next_state;

  DFFR_X1 state_reg_2_ ( .D(next_state[2]), .CK(clk), .RN(rst_n), .Q(state[2]), 
        .QN(n76) );
  DFFR_X1 state_reg_3_ ( .D(next_state[3]), .CK(clk), .RN(rst_n), .Q(state[3]), 
        .QN(n75) );
  DFFR_X1 state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(rst_n), .Q(state[1]), 
        .QN(n73) );
  DFFR_X1 state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(rst_n), .Q(state[0]), 
        .QN(n77) );
  BUF_X1 U66 ( .A(n76), .Z(n52) );
  CLKBUF_X1 U67 ( .A(n77), .Z(n55) );
  INV_X1 U68 ( .A(cmd[1]), .ZN(n53) );
  BUF_X1 U69 ( .A(state[1]), .Z(n54) );
  BUF_X1 U70 ( .A(n71), .Z(n56) );
  BUF_X1 U71 ( .A(n71), .Z(n61) );
  BUF_X1 U72 ( .A(n76), .Z(n63) );
  OR2_X1 U73 ( .A1(n73), .A2(state[2]), .ZN(n112) );
  CLKBUF_X1 U74 ( .A(n103), .Z(n57) );
  INV_X1 U75 ( .A(n114), .ZN(n58) );
  CLKBUF_X1 U76 ( .A(n66), .Z(n59) );
  INV_X1 U77 ( .A(n65), .ZN(n102) );
  BUF_X1 U78 ( .A(n73), .Z(n60) );
  CLKBUF_X1 U79 ( .A(n77), .Z(n62) );
  BUF_X1 U80 ( .A(n75), .Z(n64) );
  AND4_X1 U81 ( .A1(state[2]), .A2(n77), .A3(n84), .A4(state[1]), .ZN(n65) );
  INV_X1 U82 ( .A(n77), .ZN(n66) );
  AND2_X1 U83 ( .A1(n62), .A2(n64), .ZN(n67) );
  BUF_X1 U84 ( .A(n120), .Z(n68) );
  INV_X1 U85 ( .A(n70), .ZN(n69) );
  BUF_X1 U86 ( .A(n75), .Z(n70) );
  INV_X1 U87 ( .A(n76), .ZN(n71) );
  INV_X1 U88 ( .A(n75), .ZN(n72) );
  OAI33_X1 U89 ( .A1(n79), .A2(n66), .A3(n78), .B1(n117), .B2(n72), .B3(n77), 
        .ZN(n74) );
  INV_X1 U90 ( .A(cmd[2]), .ZN(n95) );
  OAI21_X1 U91 ( .B1(cmd[3]), .B2(n95), .A(n73), .ZN(n79) );
  NAND2_X1 U92 ( .A1(n72), .A2(n52), .ZN(n78) );
  NAND2_X1 U93 ( .A1(state[2]), .A2(n73), .ZN(n117) );
  OAI33_X1 U94 ( .A1(n79), .A2(n66), .A3(n78), .B1(n117), .B2(state[3]), .B3(
        n77), .ZN(n92) );
  INV_X1 U95 ( .A(n74), .ZN(n89) );
  INV_X1 U96 ( .A(cmd[1]), .ZN(n83) );
  XOR2_X1 U97 ( .A(n53), .B(cmd[0]), .Z(n96) );
  NAND2_X1 U98 ( .A1(state[3]), .A2(n96), .ZN(n81) );
  NAND2_X1 U99 ( .A1(n76), .A2(n73), .ZN(n111) );
  AOI21_X1 U100 ( .B1(cmd[1]), .B2(cmd[0]), .A(state[3]), .ZN(n80) );
  OAI33_X1 U101 ( .A1(n81), .A2(state[0]), .A3(n63), .B1(n80), .B2(n111), .B3(
        n77), .ZN(n87) );
  NOR3_X1 U102 ( .A1(n60), .A2(state[0]), .A3(n83), .ZN(n86) );
  INV_X1 U103 ( .A(cmd[3]), .ZN(n104) );
  INV_X1 U104 ( .A(cmd[0]), .ZN(n82) );
  NAND4_X1 U105 ( .A1(n104), .A2(n95), .A3(n83), .A4(n82), .ZN(n84) );
  NAND4_X1 U106 ( .A1(n77), .A2(state[1]), .A3(n76), .A4(n75), .ZN(n103) );
  INV_X1 U107 ( .A(n103), .ZN(n85) );
  NOR4_X1 U108 ( .A1(n87), .A2(n85), .A3(n86), .A4(n65), .ZN(n88) );
  NAND2_X1 U109 ( .A1(n88), .A2(n89), .ZN(next_state[1]) );
  INV_X1 U110 ( .A(n112), .ZN(n90) );
  NAND3_X1 U111 ( .A1(cmd[2]), .A2(n59), .A3(n90), .ZN(n94) );
  NAND2_X1 U112 ( .A1(state[0]), .A2(n72), .ZN(n113) );
  INV_X1 U113 ( .A(n113), .ZN(n91) );
  NAND2_X1 U114 ( .A1(n91), .A2(n90), .ZN(n115) );
  AOI21_X1 U115 ( .B1(n61), .B2(n55), .A(n92), .ZN(n93) );
  NAND3_X1 U116 ( .A1(n93), .A2(n115), .A3(n94), .ZN(next_state[2]) );
  INV_X1 U117 ( .A(n117), .ZN(n114) );
  NAND3_X1 U118 ( .A1(cmd[3]), .A2(n67), .A3(n114), .ZN(n101) );
  OAI33_X1 U119 ( .A1(n66), .A2(n56), .A3(n64), .B1(n64), .B2(state[0]), .B3(
        n60), .ZN(n99) );
  AOI22_X1 U120 ( .A1(state[1]), .A2(n95), .B1(n77), .B2(cmd[0]), .ZN(n97) );
  OAI33_X1 U121 ( .A1(n97), .A2(n56), .A3(n69), .B1(n96), .B2(state[0]), .B3(
        n64), .ZN(n98) );
  NOR2_X1 U122 ( .A1(n98), .A2(n99), .ZN(n100) );
  NAND4_X1 U123 ( .A1(n100), .A2(n102), .A3(n101), .A4(n57), .ZN(next_state[0]) );
  NAND3_X1 U124 ( .A1(n114), .A2(n104), .A3(n67), .ZN(n107) );
  NOR4_X1 U125 ( .A1(state[0]), .A2(n71), .A3(state[1]), .A4(cmd[0]), .ZN(n105) );
  AOI221_X1 U126 ( .B1(n69), .B2(n62), .C1(n69), .C2(n63), .A(n105), .ZN(n106)
         );
  NAND2_X1 U127 ( .A1(n106), .A2(n107), .ZN(next_state[3]) );
  INV_X1 U128 ( .A(n111), .ZN(n108) );
  NAND2_X1 U129 ( .A1(n108), .A2(n70), .ZN(n110) );
  NAND3_X1 U130 ( .A1(n69), .A2(n61), .A3(n54), .ZN(n109) );
  XOR2_X1 U131 ( .A(n77), .B(state[3]), .Z(n120) );
  INV_X1 U132 ( .A(n120), .ZN(n119) );
  AOI21_X1 U133 ( .B1(n110), .B2(n109), .A(n119), .ZN(out[0]) );
  NOR2_X1 U134 ( .A1(n68), .A2(n111), .ZN(out[1]) );
  XOR2_X1 U135 ( .A(n64), .B(state[1]), .Z(n118) );
  NOR3_X1 U136 ( .A1(n119), .A2(n61), .A3(n118), .ZN(out[2]) );
  NOR2_X1 U137 ( .A1(n68), .A2(n112), .ZN(out[3]) );
  NAND2_X1 U138 ( .A1(n114), .A2(n113), .ZN(n116) );
  AOI21_X1 U139 ( .B1(n116), .B2(n115), .A(n119), .ZN(out[4]) );
  NOR2_X1 U140 ( .A1(n68), .A2(n58), .ZN(out[5]) );
  NOR3_X1 U141 ( .A1(n119), .A2(n118), .A3(n63), .ZN(out[6]) );
  NOR3_X1 U142 ( .A1(n68), .A2(n63), .A3(n60), .ZN(out[7]) );
endmodule

