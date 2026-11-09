/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:09:45 2025
/////////////////////////////////////////////////////////////


module sub_4bit_mini ( a, b, diff, overflow );
  input [3:0] a;
  input [3:0] b;
  output [3:0] diff;
  output overflow;
  wire   sum_ext_4_, cout, N8, N7, N6, N10, n6, n7, n8, n9, n10, n11, n12, n13,
         add_19_2_n28, add_19_2_n27, add_19_2_n26, add_19_2_n25, add_19_2_n24,
         add_19_2_n23, add_19_2_n22, add_19_2_n21, add_19_2_n20, add_19_2_n19,
         add_19_2_n18, add_19_2_n17, add_19_2_n16, add_19_2_n15, add_19_2_n14,
         add_19_2_n13, add_19_2_n12, add_19_2_n11, add_19_2_n10, add_19_2_n9,
         add_19_2_n8, add_19_2_n7, add_19_2_n6, add_19_2_n5, add_19_2_n4,
         add_19_2_n3, add_19_2_n2;

  BUF_X1 U9 ( .A(b[2]), .Z(n6) );
  NOR2_X1 U10 ( .A1(b[1]), .A2(b[0]), .ZN(n7) );
  XNOR2_X1 U11 ( .A(n12), .B(b[1]), .ZN(N6) );
  XNOR2_X1 U12 ( .A(n7), .B(n6), .ZN(N7) );
  NOR3_X1 U13 ( .A1(b[0]), .A2(b[1]), .A3(b[2]), .ZN(n8) );
  XNOR2_X1 U14 ( .A(n8), .B(b[3]), .ZN(N8) );
  CLKBUF_X1 U15 ( .A(b[0]), .Z(n9) );
  INV_X1 U16 ( .A(b[3]), .ZN(n10) );
  INV_X1 U17 ( .A(b[1]), .ZN(n13) );
  INV_X1 U18 ( .A(b[0]), .ZN(n12) );
  INV_X1 U19 ( .A(n6), .ZN(n11) );
  NAND4_X1 U20 ( .A1(n10), .A2(n13), .A3(n12), .A4(n11), .ZN(N10) );
  XOR2_X1 U21 ( .A(cout), .B(sum_ext_4_), .Z(overflow) );
  MUX2_X1 add_19_2_U30 ( .A(add_19_2_n19), .B(add_19_2_n5), .S(add_19_2_n6), 
        .Z(cout) );
  INV_X1 add_19_2_U29 ( .A(N7), .ZN(add_19_2_n17) );
  NAND2_X1 add_19_2_U28 ( .A1(N7), .A2(a[2]), .ZN(add_19_2_n10) );
  NOR2_X1 add_19_2_U27 ( .A1(add_19_2_n21), .A2(add_19_2_n22), .ZN(
        add_19_2_n20) );
  NAND2_X1 add_19_2_U26 ( .A1(N10), .A2(add_19_2_n12), .ZN(add_19_2_n11) );
  AOI21_X1 add_19_2_U25 ( .B1(add_19_2_n9), .B2(add_19_2_n10), .A(add_19_2_n11), .ZN(add_19_2_n8) );
  XNOR2_X1 add_19_2_U24 ( .A(add_19_2_n20), .B(add_19_2_n5), .ZN(sum_ext_4_)
         );
  NOR2_X1 add_19_2_U23 ( .A1(add_19_2_n8), .A2(add_19_2_n7), .ZN(add_19_2_n6)
         );
  NAND2_X1 add_19_2_U22 ( .A1(add_19_2_n17), .A2(add_19_2_n16), .ZN(
        add_19_2_n27) );
  NOR2_X1 add_19_2_U21 ( .A1(add_19_2_n18), .A2(add_19_2_n3), .ZN(add_19_2_n7)
         );
  AOI21_X1 add_19_2_U20 ( .B1(add_19_2_n25), .B2(add_19_2_n10), .A(
        add_19_2_n26), .ZN(add_19_2_n21) );
  NAND2_X1 add_19_2_U19 ( .A1(add_19_2_n4), .A2(N10), .ZN(add_19_2_n18) );
  INV_X1 add_19_2_U18 ( .A(add_19_2_n4), .ZN(add_19_2_n26) );
  NAND4_X1 add_19_2_U17 ( .A1(add_19_2_n27), .A2(add_19_2_n13), .A3(
        add_19_2_n14), .A4(add_19_2_n15), .ZN(add_19_2_n9) );
  NAND4_X1 add_19_2_U16 ( .A1(add_19_2_n27), .A2(add_19_2_n13), .A3(
        add_19_2_n14), .A4(add_19_2_n15), .ZN(add_19_2_n25) );
  INV_X1 add_19_2_U15 ( .A(add_19_2_n2), .ZN(add_19_2_n3) );
  AND2_X1 add_19_2_U14 ( .A1(N8), .A2(a[3]), .ZN(add_19_2_n2) );
  NAND2_X1 add_19_2_U13 ( .A1(add_19_2_n28), .A2(add_19_2_n24), .ZN(
        add_19_2_n13) );
  NAND2_X1 add_19_2_U12 ( .A1(add_19_2_n23), .A2(add_19_2_n24), .ZN(
        add_19_2_n15) );
  INV_X1 add_19_2_U11 ( .A(a[2]), .ZN(add_19_2_n16) );
  INV_X1 add_19_2_U10 ( .A(a[1]), .ZN(add_19_2_n23) );
  NAND2_X1 add_19_2_U9 ( .A1(n9), .A2(a[0]), .ZN(add_19_2_n28) );
  INV_X1 add_19_2_U8 ( .A(N10), .ZN(add_19_2_n19) );
  INV_X1 add_19_2_U7 ( .A(N6), .ZN(add_19_2_n24) );
  INV_X1 add_19_2_U6 ( .A(add_19_2_n19), .ZN(add_19_2_n5) );
  NAND2_X1 add_19_2_U5 ( .A1(add_19_2_n28), .A2(add_19_2_n23), .ZN(
        add_19_2_n14) );
  NOR2_X1 add_19_2_U4 ( .A1(add_19_2_n3), .A2(add_19_2_n26), .ZN(add_19_2_n22)
         );
  OR2_X1 add_19_2_U3 ( .A1(N8), .A2(a[3]), .ZN(add_19_2_n4) );
  OR2_X1 add_19_2_U2 ( .A1(a[3]), .A2(N8), .ZN(add_19_2_n12) );
endmodule

