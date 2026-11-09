/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:09:03 2025
/////////////////////////////////////////////////////////////


module mul_const_mini ( a, b, c, s1, s2, s3 );
  input [7:0] a;
  input [7:0] b;
  input [7:0] c;
  output [7:0] s1;
  output [7:0] s2;
  output [7:0] s3;
  wire   n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, mult_13_n64, mult_13_n63,
         mult_13_n62, mult_13_n61, mult_13_n60, mult_13_n59, mult_13_n58,
         mult_13_n57, mult_13_n56, mult_13_n55, mult_13_n54, mult_13_n53,
         mult_13_n52, mult_13_n51, mult_13_n50, mult_13_n49, mult_13_n48,
         mult_13_n47, mult_13_n46, mult_13_n45, mult_13_n44, mult_13_n43,
         mult_13_n42, mult_13_n41, mult_13_n40, mult_13_n39, mult_13_n38,
         mult_13_n37, mult_13_n33, mult_13_n32, mult_13_n31, mult_13_n30,
         mult_13_n29, mult_13_n28, mult_13_n27, mult_13_n26, mult_13_n25,
         mult_13_n24, mult_13_n23, mult_13_n22, mult_13_n21, mult_13_n20,
         mult_13_n19, mult_13_n18, mult_13_n17, mult_13_n16, mult_13_n15,
         mult_13_n14, mult_13_n13, mult_13_n12, mult_13_n11, mult_13_n10,
         mult_13_n9, mult_13_n8, mult_13_n7, mult_13_n6, mult_13_n5,
         mult_13_n4, mult_13_n3, mult_13_n2, mult_13_add1_6_, mult_13_add0_7_;

  INV_X1 U3 ( .A(1'b1), .ZN(s1[0]) );
  INV_X1 U5 ( .A(1'b1), .ZN(s1[1]) );
  XNOR2_X1 U7 ( .A(n5), .B(n14), .ZN(s3[6]) );
  OR2_X1 U8 ( .A1(n7), .A2(n10), .ZN(n5) );
  BUF_X1 U9 ( .A(c[3]), .Z(n6) );
  AND2_X1 U10 ( .A1(n32), .A2(n31), .ZN(n7) );
  XNOR2_X1 U11 ( .A(n8), .B(n13), .ZN(n32) );
  XOR2_X1 U12 ( .A(c[3]), .B(c[6]), .Z(n8) );
  XOR2_X1 U13 ( .A(c[3]), .B(c[6]), .Z(n9) );
  NOR2_X1 U14 ( .A1(n32), .A2(n31), .ZN(n10) );
  XNOR2_X1 U15 ( .A(n36), .B(n11), .ZN(s3[7]) );
  XNOR2_X1 U16 ( .A(n35), .B(n34), .ZN(n11) );
  XOR2_X1 U17 ( .A(c[5]), .B(c[2]), .Z(n12) );
  AND2_X1 U18 ( .A1(c[2]), .A2(c[5]), .ZN(n13) );
  AND3_X2 U19 ( .A1(n26), .A2(n15), .A3(n16), .ZN(n14) );
  XOR2_X1 U20 ( .A(c[4]), .B(c[1]), .Z(n15) );
  AND2_X1 U21 ( .A1(c[0]), .A2(c[3]), .ZN(n16) );
  BUF_X1 U22 ( .A(a[5]), .Z(s1[7]) );
  BUF_X1 U23 ( .A(a[4]), .Z(s1[6]) );
  BUF_X1 U24 ( .A(a[3]), .Z(s1[5]) );
  BUF_X1 U25 ( .A(a[2]), .Z(s1[4]) );
  BUF_X1 U26 ( .A(a[1]), .Z(s1[3]) );
  BUF_X1 U27 ( .A(a[0]), .Z(s1[2]) );
  BUF_X1 U28 ( .A(c[2]), .Z(s3[2]) );
  BUF_X1 U29 ( .A(c[1]), .Z(s3[1]) );
  BUF_X1 U30 ( .A(c[0]), .Z(s3[0]) );
  XOR2_X1 U31 ( .A(n15), .B(n16), .Z(s3[4]) );
  NAND2_X1 U32 ( .A1(c[1]), .A2(c[4]), .ZN(n29) );
  XOR2_X1 U33 ( .A(n29), .B(n12), .Z(n28) );
  NAND2_X1 U34 ( .A1(n16), .A2(n15), .ZN(n27) );
  XOR2_X1 U35 ( .A(c[2]), .B(c[5]), .Z(n26) );
  AOI21_X1 U36 ( .B1(n28), .B2(n27), .A(n14), .ZN(s3[5]) );
  INV_X1 U37 ( .A(n29), .ZN(n30) );
  NAND2_X1 U38 ( .A1(n30), .A2(n12), .ZN(n31) );
  NAND2_X1 U39 ( .A1(n32), .A2(n31), .ZN(n33) );
  AOI21_X1 U40 ( .B1(n14), .B2(n33), .A(n10), .ZN(n36) );
  XOR2_X1 U41 ( .A(c[7]), .B(c[4]), .Z(n35) );
  AOI22_X1 U42 ( .A1(c[6]), .A2(n6), .B1(n13), .B2(n9), .ZN(n34) );
  XOR2_X1 U43 ( .A(c[0]), .B(n6), .Z(s3[3]) );
  NAND3_X1 mult_13_U68 ( .A1(mult_13_n64), .A2(mult_13_n63), .A3(mult_13_n62), 
        .ZN(s2[7]) );
  NAND3_X1 mult_13_U67 ( .A1(mult_13_n50), .A2(mult_13_n16), .A3(mult_13_n60), 
        .ZN(mult_13_n62) );
  INV_X1 mult_13_U66 ( .A(mult_13_n59), .ZN(mult_13_n60) );
  NAND4_X1 mult_13_U65 ( .A1(mult_13_n11), .A2(mult_13_n57), .A3(mult_13_n56), 
        .A4(mult_13_n59), .ZN(mult_13_n63) );
  INV_X1 mult_13_U64 ( .A(mult_13_n50), .ZN(mult_13_n56) );
  NOR2_X1 mult_13_U63 ( .A1(mult_13_n19), .A2(mult_13_n57), .ZN(mult_13_n51)
         );
  OAI211_X1 mult_13_U62 ( .C1(mult_13_n14), .C2(mult_13_n55), .A(mult_13_n47), 
        .B(mult_13_n48), .ZN(s2[6]) );
  OAI211_X1 mult_13_U61 ( .C1(mult_13_n46), .C2(mult_13_n45), .A(mult_13_n49), 
        .B(mult_13_n55), .ZN(mult_13_n47) );
  INV_X1 mult_13_U60 ( .A(mult_13_n44), .ZN(mult_13_n46) );
  NAND3_X1 mult_13_U59 ( .A1(mult_13_n18), .A2(mult_13_n44), .A3(mult_13_n43), 
        .ZN(mult_13_n48) );
  INV_X1 mult_13_U58 ( .A(mult_13_n45), .ZN(mult_13_n43) );
  NAND2_X1 mult_13_U57 ( .A1(mult_13_n57), .A2(mult_13_n52), .ZN(mult_13_n45)
         );
  NAND2_X1 mult_13_U56 ( .A1(mult_13_n33), .A2(mult_13_n30), .ZN(mult_13_n57)
         );
  NAND2_X1 mult_13_U55 ( .A1(mult_13_n58), .A2(mult_13_n61), .ZN(mult_13_n49)
         );
  NAND2_X1 mult_13_U54 ( .A1(mult_13_n29), .A2(mult_13_add1_6_), .ZN(
        mult_13_n58) );
  XOR2_X1 mult_13_U53 ( .A(mult_13_n33), .B(mult_13_n30), .Z(mult_13_n42) );
  NAND2_X1 mult_13_U52 ( .A1(mult_13_n7), .A2(mult_13_n40), .ZN(mult_13_n44)
         );
  XOR2_X1 mult_13_U51 ( .A(mult_13_n41), .B(mult_13_n39), .Z(s2[4]) );
  NAND2_X1 mult_13_U50 ( .A1(mult_13_n8), .A2(mult_13_n31), .ZN(mult_13_n52)
         );
  AOI21_X1 mult_13_U49 ( .B1(mult_13_n21), .B2(mult_13_n38), .A(mult_13_n41), 
        .ZN(s2[3]) );
  INV_X1 mult_13_U48 ( .A(mult_13_n37), .ZN(mult_13_n41) );
  NAND2_X1 mult_13_U47 ( .A1(mult_13_n32), .A2(mult_13_n27), .ZN(mult_13_n37)
         );
  INV_X1 mult_13_U46 ( .A(mult_13_n32), .ZN(mult_13_n38) );
  OAI21_X1 mult_13_U45 ( .B1(mult_13_n53), .B2(mult_13_n37), .A(mult_13_n52), 
        .ZN(mult_13_n54) );
  NOR2_X1 mult_13_U44 ( .A1(mult_13_n31), .A2(mult_13_n26), .ZN(mult_13_n53)
         );
  NAND2_X1 mult_13_U43 ( .A1(mult_13_n55), .A2(mult_13_n54), .ZN(mult_13_n59)
         );
  XNOR2_X1 mult_13_U42 ( .A(mult_13_add0_7_), .B(mult_13_n28), .ZN(mult_13_n50) );
  BUF_X1 mult_13_U41 ( .A(b[0]), .Z(s2[0]) );
  BUF_X1 mult_13_U40 ( .A(b[1]), .Z(s2[1]) );
  XOR2_X1 mult_13_U39 ( .A(mult_13_n6), .B(b[0]), .Z(s2[2]) );
  AND2_X1 mult_13_U38 ( .A1(mult_13_n6), .A2(b[4]), .ZN(mult_13_n33) );
  AND2_X1 mult_13_U37 ( .A1(b[0]), .A2(b[2]), .ZN(mult_13_n32) );
  AND2_X1 mult_13_U36 ( .A1(b[1]), .A2(b[3]), .ZN(mult_13_n31) );
  XOR2_X1 mult_13_U35 ( .A(b[5]), .B(b[3]), .Z(mult_13_n30) );
  XOR2_X1 mult_13_U34 ( .A(b[7]), .B(b[5]), .Z(mult_13_n28) );
  XOR2_X1 mult_13_U33 ( .A(b[3]), .B(b[1]), .Z(mult_13_n27) );
  XOR2_X1 mult_13_U32 ( .A(b[4]), .B(b[2]), .Z(mult_13_n26) );
  OR2_X1 mult_13_U31 ( .A1(mult_13_n30), .A2(mult_13_n33), .ZN(mult_13_n55) );
  AND2_X1 mult_13_U30 ( .A1(mult_13_n44), .A2(mult_13_n13), .ZN(mult_13_n25)
         );
  XNOR2_X1 mult_13_U29 ( .A(mult_13_n25), .B(mult_13_n42), .ZN(s2[5]) );
  OR2_X1 mult_13_U28 ( .A1(mult_13_n20), .A2(mult_13_n29), .ZN(mult_13_n61) );
  AND3_X1 mult_13_U27 ( .A1(mult_13_n22), .A2(mult_13_n23), .A3(mult_13_n24), 
        .ZN(mult_13_n64) );
  NAND2_X1 mult_13_U26 ( .A1(mult_13_n50), .A2(mult_13_n17), .ZN(mult_13_n23)
         );
  NAND2_X1 mult_13_U25 ( .A1(mult_13_n51), .A2(mult_13_n50), .ZN(mult_13_n22)
         );
  XNOR2_X1 mult_13_U24 ( .A(b[3]), .B(b[1]), .ZN(mult_13_n21) );
  AND2_X2 mult_13_U23 ( .A1(b[3]), .A2(b[5]), .ZN(mult_13_n29) );
  NOR2_X1 mult_13_U22 ( .A1(mult_13_n4), .A2(mult_13_n29), .ZN(mult_13_n19) );
  AND2_X1 mult_13_U21 ( .A1(mult_13_n16), .A2(mult_13_n58), .ZN(mult_13_n18)
         );
  AND2_X1 mult_13_U20 ( .A1(mult_13_n12), .A2(mult_13_n29), .ZN(mult_13_n17)
         );
  OR2_X1 mult_13_U19 ( .A1(mult_13_n20), .A2(mult_13_n29), .ZN(mult_13_n16) );
  CLKBUF_X1 mult_13_U18 ( .A(mult_13_n49), .Z(mult_13_n14) );
  CLKBUF_X1 mult_13_U17 ( .A(mult_13_n58), .Z(mult_13_n11) );
  INV_X1 mult_13_U16 ( .A(mult_13_n12), .ZN(mult_13_n10) );
  INV_X1 mult_13_U15 ( .A(mult_13_n29), .ZN(mult_13_n9) );
  NAND3_X1 mult_13_U14 ( .A1(mult_13_n5), .A2(mult_13_n9), .A3(mult_13_n10), 
        .ZN(mult_13_n24) );
  CLKBUF_X1 mult_13_U13 ( .A(mult_13_n52), .Z(mult_13_n13) );
  XOR2_X1 mult_13_U12 ( .A(b[4]), .B(b[2]), .Z(mult_13_n8) );
  INV_X1 mult_13_U11 ( .A(mult_13_n37), .ZN(mult_13_n7) );
  BUF_X1 mult_13_U10 ( .A(b[2]), .Z(mult_13_n6) );
  AND2_X1 mult_13_U9 ( .A1(mult_13_n40), .A2(mult_13_n52), .ZN(mult_13_n39) );
  XOR2_X1 mult_13_U8 ( .A(mult_13_n15), .B(mult_13_n28), .Z(mult_13_n5) );
  OR2_X1 mult_13_U7 ( .A1(mult_13_n26), .A2(mult_13_n31), .ZN(mult_13_n40) );
  INV_X2 mult_13_U6 ( .A(mult_13_n3), .ZN(mult_13_n4) );
  XNOR2_X2 mult_13_U5 ( .A(b[6]), .B(b[4]), .ZN(mult_13_n3) );
  INV_X2 mult_13_U4 ( .A(mult_13_n2), .ZN(mult_13_n12) );
  XNOR2_X2 mult_13_U3 ( .A(b[6]), .B(b[4]), .ZN(mult_13_n2) );
  FA_X1 mult_13_U2 ( .A(1'b0), .B(b[6]), .CI(b[4]), .CO(mult_13_n15), .S(
        mult_13_n20) );
  FA_X1 mult_13_IN16_6 ( .A(1'b0), .B(b[6]), .CI(b[4]), .CO(mult_13_add0_7_), 
        .S(mult_13_add1_6_) );
endmodule

