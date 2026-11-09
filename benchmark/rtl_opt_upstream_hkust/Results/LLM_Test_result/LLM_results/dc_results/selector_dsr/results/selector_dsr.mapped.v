/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:40:01 2025
/////////////////////////////////////////////////////////////


module selector_dsr ( clk, sel, dout );
  input [3:0] sel;
  output [6:0] dout;
  input clk;
  wire   N7, N8, N9, N10, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15, n16, n17, n18, n19, n20;

  DFF_X1 dout_reg_5_ ( .D(sel[3]), .CK(clk), .Q(dout[5]) );
  DFF_X1 dout_reg_4_ ( .D(N10), .CK(clk), .Q(dout[4]) );
  DFF_X1 dout_reg_3_ ( .D(N9), .CK(clk), .Q(dout[3]) );
  DFF_X1 dout_reg_2_ ( .D(N8), .CK(clk), .Q(dout[2]) );
  DFF_X1 dout_reg_1_ ( .D(N7), .CK(clk), .Q(dout[1]) );
  DFF_X1 dout_reg_0_ ( .D(sel[0]), .CK(clk), .Q(dout[0]) );
  INV_X1 U3 ( .A(1'b1), .ZN(dout[6]) );
  INV_X1 U5 ( .A(sel[2]), .ZN(n15) );
  NAND2_X1 U6 ( .A1(n11), .A2(n10), .ZN(n13) );
  NAND2_X1 U8 ( .A1(sel[2]), .A2(sel[1]), .ZN(n11) );
  INV_X1 U9 ( .A(n16), .ZN(n3) );
  CLKBUF_X1 U10 ( .A(n20), .Z(n4) );
  NAND2_X1 U11 ( .A1(n13), .A2(n12), .ZN(n14) );
  INV_X1 U12 ( .A(sel[1]), .ZN(n5) );
  INV_X1 U13 ( .A(sel[1]), .ZN(n16) );
  XOR2_X1 U14 ( .A(n16), .B(sel[0]), .Z(N7) );
  INV_X1 U15 ( .A(sel[0]), .ZN(n6) );
  NOR2_X1 U16 ( .A1(n3), .A2(n6), .ZN(n7) );
  XOR2_X1 U17 ( .A(sel[2]), .B(n7), .Z(N8) );
  NAND3_X1 U18 ( .A1(n5), .A2(sel[0]), .A3(sel[2]), .ZN(n8) );
  OAI21_X1 U19 ( .B1(sel[2]), .B2(n16), .A(n8), .ZN(n9) );
  INV_X1 U20 ( .A(n9), .ZN(n20) );
  INV_X1 U21 ( .A(sel[3]), .ZN(n10) );
  NAND3_X1 U22 ( .A1(sel[3]), .A2(sel[2]), .A3(sel[1]), .ZN(n12) );
  FA_X1 U23 ( .A(n14), .B(n15), .CI(n20), .S(N9) );
  INV_X1 U24 ( .A(sel[2]), .ZN(n19) );
  OAI21_X1 U25 ( .B1(n16), .B2(n19), .A(sel[3]), .ZN(n17) );
  OAI21_X1 U26 ( .B1(sel[2]), .B2(n3), .A(n17), .ZN(n18) );
  OAI21_X1 U27 ( .B1(n4), .B2(n19), .A(n18), .ZN(N10) );
endmodule

