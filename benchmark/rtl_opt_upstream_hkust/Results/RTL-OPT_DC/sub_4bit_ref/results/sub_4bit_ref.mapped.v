/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:10:03 2025
/////////////////////////////////////////////////////////////


module sub_4bit_ref ( a, b, diff, overflow );
  input [3:0] a;
  input [3:0] b;
  output [3:0] diff;
  output overflow;
  wire   n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28;

  XNOR2_X1 U4 ( .A(n6), .B(n3), .ZN(diff[2]) );
  XOR2_X1 U5 ( .A(b[2]), .B(a[2]), .Z(n3) );
  OR2_X1 U6 ( .A1(n19), .A2(n20), .ZN(n4) );
  OR2_X1 U7 ( .A1(b[3]), .A2(n18), .ZN(n5) );
  NAND3_X1 U8 ( .A1(n17), .A2(n5), .A3(n4), .ZN(n22) );
  CLKBUF_X1 U9 ( .A(n27), .Z(n6) );
  INV_X1 U10 ( .A(a[3]), .ZN(n18) );
  INV_X1 U11 ( .A(n16), .ZN(n19) );
  XNOR2_X1 U12 ( .A(n21), .B(n7), .ZN(diff[3]) );
  XNOR2_X1 U13 ( .A(b[3]), .B(a[3]), .ZN(n7) );
  XNOR2_X1 U14 ( .A(n24), .B(n25), .ZN(diff[1]) );
  XNOR2_X1 U15 ( .A(n12), .B(a[1]), .ZN(n25) );
  NAND2_X1 U16 ( .A1(a[1]), .A2(n12), .ZN(n13) );
  INV_X1 U17 ( .A(b[1]), .ZN(n12) );
  AOI21_X1 U18 ( .B1(n27), .B2(n28), .A(n26), .ZN(n21) );
  INV_X1 U19 ( .A(b[0]), .ZN(n11) );
  NAND2_X1 U20 ( .A1(n13), .A2(n14), .ZN(n27) );
  OAI22_X1 U21 ( .A1(a[0]), .A2(n11), .B1(n10), .B2(a[1]), .ZN(n14) );
  INV_X1 U22 ( .A(b[1]), .ZN(n10) );
  XNOR2_X1 U23 ( .A(n21), .B(n22), .ZN(overflow) );
  INV_X1 U24 ( .A(a[3]), .ZN(n8) );
  NAND2_X1 U25 ( .A1(b[3]), .A2(n8), .ZN(n16) );
  INV_X1 U26 ( .A(b[2]), .ZN(n9) );
  NAND2_X1 U27 ( .A1(a[2]), .A2(n9), .ZN(n20) );
  INV_X1 U28 ( .A(a[2]), .ZN(n15) );
  NAND2_X1 U29 ( .A1(b[2]), .A2(n15), .ZN(n28) );
  NAND3_X1 U30 ( .A1(n27), .A2(n16), .A3(n28), .ZN(n17) );
  INV_X1 U31 ( .A(n20), .ZN(n26) );
  INV_X1 U32 ( .A(a[0]), .ZN(n23) );
  NAND2_X1 U33 ( .A1(b[0]), .A2(n23), .ZN(n24) );
  OAI21_X1 U34 ( .B1(b[0]), .B2(n23), .A(n24), .ZN(diff[0]) );
endmodule

