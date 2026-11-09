/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:09:49 2025
/////////////////////////////////////////////////////////////


module sub_8bit_mini ( a, b, diff, overflow );
  input [7:0] a;
  input [7:0] b;
  output [7:0] diff;
  output overflow;
  wire   n13, n14, n15, n16, n17, n18, n19, n20, n21, add_15_n60, add_15_n59,
         add_15_n58, add_15_n57, add_15_n56, add_15_n55, add_15_n54,
         add_15_n53, add_15_n52, add_15_n51, add_15_n50, add_15_n49,
         add_15_n48, add_15_n47, add_15_n46, add_15_n45, add_15_n44,
         add_15_n43, add_15_n42, add_15_n41, add_15_n40, add_15_n39,
         add_15_n38, add_15_n37, add_15_n36, add_15_n35, add_15_n34,
         add_15_n33, add_15_n32, add_15_n31, add_15_n30, add_15_n29,
         add_15_n28, add_15_n27, add_15_n26, add_15_n25, add_15_n24,
         add_15_n23, add_15_n22, add_15_n21, add_15_n20, add_15_n19,
         add_15_n18, add_15_n17, add_15_n16, add_15_n15, add_15_n14,
         add_15_n13, add_15_n12, add_15_n11, add_15_n10, add_15_n9, add_15_n8,
         add_15_n7, add_15_n6, add_15_n5, add_15_n4, add_15_n3, add_15_n2,
         add_15_n1;

  XNOR2_X1 U15 ( .A(a[7]), .B(b[7]), .ZN(n13) );
  INV_X1 U16 ( .A(b[3]), .ZN(n18) );
  NOR2_X1 U17 ( .A1(n14), .A2(n13), .ZN(overflow) );
  XNOR2_X1 U18 ( .A(diff[7]), .B(a[7]), .ZN(n14) );
  INV_X1 U19 ( .A(b[6]), .ZN(n15) );
  INV_X1 U20 ( .A(b[5]), .ZN(n16) );
  INV_X1 U21 ( .A(b[4]), .ZN(n17) );
  INV_X1 U22 ( .A(b[2]), .ZN(n19) );
  INV_X1 U23 ( .A(b[1]), .ZN(n20) );
  INV_X1 U24 ( .A(b[0]), .ZN(n21) );
  INV_X1 add_15_U69 ( .A(add_15_n8), .ZN(add_15_n58) );
  NAND3_X1 add_15_U68 ( .A1(add_15_n31), .A2(add_15_n12), .A3(a[2]), .ZN(
        add_15_n29) );
  NAND3_X1 add_15_U67 ( .A1(add_15_n6), .A2(add_15_n5), .A3(add_15_n51), .ZN(
        add_15_n50) );
  XNOR2_X1 add_15_U66 ( .A(add_15_n43), .B(add_15_n48), .ZN(diff[4]) );
  INV_X1 add_15_U65 ( .A(add_15_n43), .ZN(add_15_n37) );
  NAND2_X1 add_15_U64 ( .A1(n18), .A2(a[4]), .ZN(add_15_n40) );
  OAI21_X1 add_15_U63 ( .B1(add_15_n37), .B2(add_15_n26), .A(add_15_n25), .ZN(
        add_15_n35) );
  XNOR2_X1 add_15_U62 ( .A(add_15_n35), .B(add_15_n36), .ZN(diff[6]) );
  NAND3_X1 add_15_U61 ( .A1(add_15_n16), .A2(add_15_n32), .A3(add_15_n33), 
        .ZN(add_15_n28) );
  INV_X1 add_15_U60 ( .A(add_15_n24), .ZN(add_15_n23) );
  XNOR2_X1 add_15_U59 ( .A(add_15_n18), .B(add_15_n19), .ZN(diff[7]) );
  AND2_X1 add_15_U58 ( .A1(n21), .A2(a[1]), .ZN(add_15_n33) );
  NAND4_X1 add_15_U57 ( .A1(add_15_n16), .A2(a[0]), .A3(add_15_n32), .A4(
        add_15_n34), .ZN(add_15_n27) );
  AND2_X1 add_15_U56 ( .A1(add_15_n1), .A2(a[1]), .ZN(add_15_n51) );
  NAND4_X1 add_15_U55 ( .A1(add_15_n8), .A2(add_15_n6), .A3(a[0]), .A4(
        add_15_n17), .ZN(add_15_n49) );
  NAND2_X1 add_15_U54 ( .A1(add_15_n13), .A2(a[1]), .ZN(add_15_n59) );
  NAND2_X1 add_15_U53 ( .A1(add_15_n59), .A2(add_15_n8), .ZN(add_15_n60) );
  NAND4_X1 add_15_U52 ( .A1(add_15_n49), .A2(add_15_n50), .A3(add_15_n3), .A4(
        add_15_n30), .ZN(add_15_n43) );
  NAND2_X1 add_15_U51 ( .A1(add_15_n7), .A2(a[3]), .ZN(add_15_n30) );
  OAI21_X1 add_15_U50 ( .B1(add_15_n15), .B2(add_15_n20), .A(add_15_n21), .ZN(
        add_15_n18) );
  AOI21_X1 add_15_U49 ( .B1(add_15_n4), .B2(add_15_n22), .A(add_15_n23), .ZN(
        add_15_n21) );
  NAND2_X1 add_15_U48 ( .A1(add_15_n9), .A2(add_15_n22), .ZN(add_15_n20) );
  NAND2_X1 add_15_U47 ( .A1(add_15_n47), .A2(add_15_n42), .ZN(add_15_n48) );
  NAND2_X1 add_15_U46 ( .A1(add_15_n43), .A2(add_15_n42), .ZN(add_15_n46) );
  NAND2_X1 add_15_U45 ( .A1(add_15_n2), .A2(add_15_n42), .ZN(add_15_n26) );
  NAND2_X1 add_15_U44 ( .A1(n17), .A2(a[5]), .ZN(add_15_n41) );
  INV_X1 add_15_U43 ( .A(n17), .ZN(add_15_n44) );
  NAND2_X1 add_15_U42 ( .A1(add_15_n55), .A2(add_15_n6), .ZN(add_15_n57) );
  NAND2_X1 add_15_U41 ( .A1(add_15_n56), .A2(add_15_n6), .ZN(add_15_n54) );
  NAND2_X1 add_15_U40 ( .A1(add_15_n40), .A2(add_15_n41), .ZN(add_15_n38) );
  NAND2_X1 add_15_U39 ( .A1(add_15_n44), .A2(add_15_n45), .ZN(add_15_n39) );
  NAND2_X1 add_15_U38 ( .A1(add_15_n44), .A2(add_15_n45), .ZN(add_15_n14) );
  CLKBUF_X1 add_15_U37 ( .A(add_15_n1), .Z(add_15_n13) );
  OR2_X1 add_15_U36 ( .A1(n19), .A2(a[3]), .ZN(add_15_n17) );
  NAND2_X1 add_15_U35 ( .A1(n18), .A2(a[4]), .ZN(add_15_n47) );
  XNOR2_X1 add_15_U34 ( .A(add_15_n60), .B(a[0]), .ZN(diff[1]) );
  NAND2_X1 add_15_U33 ( .A1(add_15_n12), .A2(a[2]), .ZN(add_15_n55) );
  INV_X1 add_15_U32 ( .A(a[0]), .ZN(diff[0]) );
  NAND2_X1 add_15_U31 ( .A1(n16), .A2(a[6]), .ZN(add_15_n24) );
  OR2_X2 add_15_U30 ( .A1(n16), .A2(a[6]), .ZN(add_15_n22) );
  INV_X1 add_15_U29 ( .A(a[5]), .ZN(add_15_n45) );
  NAND2_X1 add_15_U28 ( .A1(add_15_n38), .A2(add_15_n39), .ZN(add_15_n25) );
  XNOR2_X1 add_15_U27 ( .A(n15), .B(a[7]), .ZN(add_15_n19) );
  XNOR2_X1 add_15_U26 ( .A(add_15_n56), .B(add_15_n57), .ZN(diff[2]) );
  NAND2_X1 add_15_U25 ( .A1(add_15_n54), .A2(add_15_n55), .ZN(add_15_n52) );
  NAND2_X1 add_15_U24 ( .A1(add_15_n30), .A2(add_15_n17), .ZN(add_15_n53) );
  XNOR2_X1 add_15_U23 ( .A(add_15_n52), .B(add_15_n53), .ZN(diff[3]) );
  OAI21_X1 add_15_U22 ( .B1(add_15_n58), .B2(diff[0]), .A(add_15_n59), .ZN(
        add_15_n56) );
  NAND2_X1 add_15_U21 ( .A1(add_15_n24), .A2(add_15_n22), .ZN(add_15_n36) );
  AND2_X1 add_15_U20 ( .A1(add_15_n2), .A2(add_15_n41), .ZN(add_15_n11) );
  AND2_X1 add_15_U19 ( .A1(add_15_n46), .A2(add_15_n47), .ZN(add_15_n10) );
  XNOR2_X1 add_15_U18 ( .A(add_15_n10), .B(add_15_n11), .ZN(diff[5]) );
  AND2_X1 add_15_U17 ( .A1(add_15_n14), .A2(add_15_n42), .ZN(add_15_n9) );
  OR2_X1 add_15_U16 ( .A1(n21), .A2(a[1]), .ZN(add_15_n34) );
  OR2_X1 add_15_U15 ( .A1(n21), .A2(a[1]), .ZN(add_15_n8) );
  OR2_X2 add_15_U14 ( .A1(n18), .A2(a[4]), .ZN(add_15_n42) );
  OR2_X1 add_15_U13 ( .A1(n19), .A2(a[3]), .ZN(add_15_n31) );
  CLKBUF_X1 add_15_U12 ( .A(n19), .Z(add_15_n7) );
  OR2_X1 add_15_U11 ( .A1(n20), .A2(a[2]), .ZN(add_15_n32) );
  OR2_X1 add_15_U10 ( .A1(n20), .A2(a[2]), .ZN(add_15_n6) );
  CLKBUF_X1 add_15_U9 ( .A(add_15_n17), .Z(add_15_n5) );
  AND2_X1 add_15_U8 ( .A1(add_15_n38), .A2(add_15_n39), .ZN(add_15_n4) );
  OR2_X1 add_15_U7 ( .A1(n19), .A2(a[3]), .ZN(add_15_n16) );
  CLKBUF_X1 add_15_U6 ( .A(add_15_n29), .Z(add_15_n3) );
  CLKBUF_X1 add_15_U5 ( .A(add_15_n14), .Z(add_15_n2) );
  AND4_X2 add_15_U4 ( .A1(add_15_n27), .A2(add_15_n28), .A3(add_15_n29), .A4(
        add_15_n30), .ZN(add_15_n15) );
  BUF_X1 add_15_U3 ( .A(n20), .Z(add_15_n12) );
  CLKBUF_X1 add_15_U2 ( .A(n21), .Z(add_15_n1) );
endmodule

