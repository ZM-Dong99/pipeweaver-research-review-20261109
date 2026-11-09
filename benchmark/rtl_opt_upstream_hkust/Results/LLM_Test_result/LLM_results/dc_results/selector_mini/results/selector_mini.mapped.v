/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:09:30 2025
/////////////////////////////////////////////////////////////


module selector_mini ( clk, sel, dout );
  input [3:0] sel;
  output [6:0] dout;
  input clk;
  wire   N8, N10, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15,
         n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n30;

  DFF_X1 dout_reg_5_ ( .D(sel[3]), .CK(clk), .Q(dout[5]) );
  DFF_X1 dout_reg_3_ ( .D(n30), .CK(clk), .Q(dout[3]) );
  DFF_X1 dout_reg_1_ ( .D(n3), .CK(clk), .Q(dout[1]) );
  DFF_X1 dout_reg_0_ ( .D(n6), .CK(clk), .Q(dout[0]) );
  DFF_X1 dout_reg_4_ ( .D(N10), .CK(clk), .Q(dout[4]) );
  DFF_X1 dout_reg_2_ ( .D(N8), .CK(clk), .Q(dout[2]) );
  INV_X1 U3 ( .A(1'b1), .ZN(dout[6]) );
  BUF_X2 U5 ( .A(sel[0]), .Z(n6) );
  XNOR2_X1 U6 ( .A(n6), .B(sel[1]), .ZN(n3) );
  INV_X1 U7 ( .A(n8), .ZN(n4) );
  XNOR2_X1 U8 ( .A(n5), .B(sel[2]), .ZN(n10) );
  NAND2_X1 U9 ( .A1(n7), .A2(sel[1]), .ZN(n5) );
  AOI22_X1 U10 ( .A1(n27), .A2(sel[1]), .B1(n26), .B2(sel[3]), .ZN(n28) );
  NOR2_X1 U11 ( .A1(n8), .A2(sel[3]), .ZN(n27) );
  INV_X1 U12 ( .A(sel[3]), .ZN(n14) );
  AOI21_X1 U14 ( .B1(sel[0]), .B2(sel[1]), .A(sel[2]), .ZN(n26) );
  INV_X1 U15 ( .A(sel[0]), .ZN(n7) );
  NAND2_X1 U16 ( .A1(n15), .A2(n14), .ZN(n19) );
  INV_X1 U17 ( .A(sel[2]), .ZN(n8) );
  XNOR2_X1 U18 ( .A(n9), .B(n4), .ZN(n12) );
  XNOR2_X1 U19 ( .A(sel[3]), .B(sel[1]), .ZN(n9) );
  NAND2_X1 U20 ( .A1(sel[2]), .A2(n20), .ZN(n22) );
  INV_X1 U21 ( .A(sel[3]), .ZN(n20) );
  XNOR2_X1 U22 ( .A(n3), .B(n10), .ZN(N8) );
  XNOR2_X1 U23 ( .A(n29), .B(n28), .ZN(N10) );
  NAND2_X1 U24 ( .A1(n23), .A2(n24), .ZN(n29) );
  INV_X1 U25 ( .A(sel[2]), .ZN(n15) );
  INV_X1 U26 ( .A(sel[1]), .ZN(n17) );
  NAND2_X1 U27 ( .A1(n6), .A2(n4), .ZN(n11) );
  INV_X1 U28 ( .A(n11), .ZN(n13) );
  OAI22_X1 U29 ( .A1(n12), .A2(n13), .B1(sel[3]), .B2(n11), .ZN(n30) );
  INV_X1 U30 ( .A(sel[0]), .ZN(n16) );
  NAND3_X1 U31 ( .A1(n16), .A2(sel[2]), .A3(sel[3]), .ZN(n18) );
  NAND3_X1 U32 ( .A1(n18), .A2(n19), .A3(n17), .ZN(n24) );
  INV_X1 U33 ( .A(sel[2]), .ZN(n25) );
  NAND3_X1 U34 ( .A1(n25), .A2(sel[0]), .A3(sel[3]), .ZN(n21) );
  NAND3_X1 U35 ( .A1(n21), .A2(n22), .A3(sel[1]), .ZN(n23) );
endmodule

