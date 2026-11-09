/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:07:33 2025
/////////////////////////////////////////////////////////////


module sub_4bit_ds ( a, b, diff, overflow );
  input [3:0] a;
  input [3:0] b;
  output [3:0] diff;
  output overflow;
  wire   n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34;

  OAI22_X1 U5 ( .A1(a[1]), .A2(n18), .B1(a[0]), .B2(n17), .ZN(n3) );
  OAI22_X1 U6 ( .A1(a[1]), .A2(n18), .B1(a[0]), .B2(n17), .ZN(n4) );
  OAI22_X1 U7 ( .A1(a[1]), .A2(n18), .B1(a[0]), .B2(n17), .ZN(n26) );
  AOI21_X1 U8 ( .B1(n4), .B2(n25), .A(n20), .ZN(n21) );
  XNOR2_X1 U9 ( .A(n27), .B(n5), .ZN(diff[2]) );
  NAND2_X1 U10 ( .A1(n25), .A2(n3), .ZN(n5) );
  NAND2_X1 U11 ( .A1(n6), .A2(a[3]), .ZN(n16) );
  XNOR2_X1 U12 ( .A(n34), .B(n24), .ZN(diff[1]) );
  NAND2_X1 U13 ( .A1(a[3]), .A2(n19), .ZN(n20) );
  NOR2_X1 U14 ( .A1(n9), .A2(n19), .ZN(n23) );
  AND2_X1 U15 ( .A1(a[2]), .A2(n10), .ZN(n6) );
  XNOR2_X1 U16 ( .A(a[3]), .B(b[3]), .ZN(n14) );
  INV_X1 U17 ( .A(a[2]), .ZN(n7) );
  XNOR2_X1 U18 ( .A(n32), .B(n14), .ZN(diff[3]) );
  NOR3_X1 U19 ( .A1(n22), .A2(n23), .A3(n21), .ZN(overflow) );
  INV_X1 U20 ( .A(a[2]), .ZN(n8) );
  CLKBUF_X1 U21 ( .A(n11), .Z(n9) );
  INV_X1 U22 ( .A(a[3]), .ZN(n13) );
  OAI21_X1 U23 ( .B1(n8), .B2(b[2]), .A(n13), .ZN(n11) );
  NAND2_X1 U24 ( .A1(b[2]), .A2(n8), .ZN(n19) );
  INV_X1 U25 ( .A(b[2]), .ZN(n10) );
  INV_X1 U26 ( .A(b[1]), .ZN(n18) );
  NAND2_X1 U27 ( .A1(a[1]), .A2(n18), .ZN(n25) );
  INV_X1 U28 ( .A(n11), .ZN(n12) );
  INV_X1 U29 ( .A(b[0]), .ZN(n17) );
  NAND3_X1 U30 ( .A1(n12), .A2(n25), .A3(n26), .ZN(n15) );
  INV_X1 U31 ( .A(n14), .ZN(n33) );
  NAND3_X1 U32 ( .A1(n15), .A2(n16), .A3(n33), .ZN(n22) );
  INV_X1 U33 ( .A(a[0]), .ZN(n28) );
  NAND2_X1 U34 ( .A1(b[0]), .A2(n28), .ZN(n24) );
  OAI21_X1 U35 ( .B1(b[0]), .B2(n28), .A(n24), .ZN(diff[0]) );
  XOR2_X1 U36 ( .A(b[2]), .B(a[2]), .Z(n27) );
  INV_X1 U37 ( .A(a[1]), .ZN(n29) );
  AOI222_X1 U38 ( .A1(b[0]), .A2(n28), .B1(n29), .B2(b[1]), .C1(n7), .C2(b[2]), 
        .ZN(n31) );
  AOI211_X1 U39 ( .C1(b[2]), .C2(n8), .A(b[1]), .B(n29), .ZN(n30) );
  NOR3_X1 U40 ( .A1(n31), .A2(n6), .A3(n30), .ZN(n32) );
  XOR2_X1 U41 ( .A(b[1]), .B(a[1]), .Z(n34) );
endmodule

