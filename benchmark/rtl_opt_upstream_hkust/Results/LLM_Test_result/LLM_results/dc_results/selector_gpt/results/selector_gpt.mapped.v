/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:30:57 2025
/////////////////////////////////////////////////////////////


module selector_gpt ( clk, sel, dout );
  input [3:0] sel;
  output [6:0] dout;
  input clk;
  wire   N7, N8, N9, N10, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12,
         n13, n14, n15, n16, n17, n18;

  DFF_X1 dout_reg_6_ ( .D(1'b0), .CK(clk), .Q(dout[6]) );
  DFF_X1 dout_reg_5_ ( .D(sel[3]), .CK(clk), .Q(dout[5]) );
  DFF_X1 dout_reg_4_ ( .D(N10), .CK(clk), .Q(dout[4]) );
  DFF_X1 dout_reg_3_ ( .D(N9), .CK(clk), .Q(dout[3]) );
  DFF_X1 dout_reg_2_ ( .D(N8), .CK(clk), .Q(dout[2]) );
  DFF_X1 dout_reg_1_ ( .D(N7), .CK(clk), .Q(dout[1]) );
  DFF_X1 dout_reg_0_ ( .D(sel[0]), .CK(clk), .Q(dout[0]) );
  INV_X1 U3 ( .A(sel[2]), .ZN(n13) );
  NAND2_X1 U4 ( .A1(n9), .A2(n8), .ZN(n11) );
  NAND2_X1 U5 ( .A1(sel[2]), .A2(sel[1]), .ZN(n9) );
  INV_X1 U6 ( .A(n14), .ZN(n1) );
  CLKBUF_X1 U7 ( .A(n18), .Z(n2) );
  NAND2_X1 U8 ( .A1(n11), .A2(n10), .ZN(n12) );
  INV_X1 U9 ( .A(sel[1]), .ZN(n3) );
  INV_X1 U10 ( .A(sel[1]), .ZN(n14) );
  XOR2_X1 U11 ( .A(n14), .B(sel[0]), .Z(N7) );
  INV_X1 U12 ( .A(sel[0]), .ZN(n4) );
  NOR2_X1 U13 ( .A1(n1), .A2(n4), .ZN(n5) );
  XOR2_X1 U14 ( .A(sel[2]), .B(n5), .Z(N8) );
  NAND3_X1 U15 ( .A1(n3), .A2(sel[0]), .A3(sel[2]), .ZN(n6) );
  OAI21_X1 U16 ( .B1(sel[2]), .B2(n14), .A(n6), .ZN(n7) );
  INV_X1 U17 ( .A(n7), .ZN(n18) );
  INV_X1 U18 ( .A(sel[3]), .ZN(n8) );
  NAND3_X1 U19 ( .A1(sel[3]), .A2(sel[2]), .A3(sel[1]), .ZN(n10) );
  FA_X1 U20 ( .A(n12), .B(n13), .CI(n18), .S(N9) );
  INV_X1 U21 ( .A(sel[2]), .ZN(n17) );
  OAI21_X1 U22 ( .B1(n14), .B2(n17), .A(sel[3]), .ZN(n15) );
  OAI21_X1 U23 ( .B1(sel[2]), .B2(n1), .A(n15), .ZN(n16) );
  OAI21_X1 U24 ( .B1(n2), .B2(n17), .A(n16), .ZN(N10) );
endmodule

