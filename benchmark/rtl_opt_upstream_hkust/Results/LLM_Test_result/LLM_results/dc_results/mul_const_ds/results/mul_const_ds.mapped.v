/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:06:52 2025
/////////////////////////////////////////////////////////////


module mul_const_ds ( a, b, c, s1, s2, s3 );
  input [7:0] a;
  input [7:0] b;
  input [7:0] c;
  output [7:0] s1;
  output [7:0] s2;
  output [7:0] s3;
  wire   n10, n11, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24,
         n34, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112;

  INV_X1 U7 ( .A(1'b1), .ZN(s1[0]) );
  INV_X1 U9 ( .A(1'b1), .ZN(s1[1]) );
  CLKBUF_X1 U11 ( .A(n39), .Z(n11) );
  BUF_X1 U12 ( .A(n45), .Z(n10) );
  BUF_X1 U13 ( .A(c[1]), .Z(s3[1]) );
  XNOR2_X1 U14 ( .A(n13), .B(n74), .ZN(s2[4]) );
  XNOR2_X1 U15 ( .A(n11), .B(b[4]), .ZN(n13) );
  OR2_X1 U16 ( .A1(n107), .A2(n19), .ZN(n110) );
  CLKBUF_X1 U17 ( .A(n100), .Z(n41) );
  XOR2_X1 U18 ( .A(c[3]), .B(c[6]), .Z(n14) );
  INV_X1 U19 ( .A(n55), .ZN(n15) );
  XOR2_X1 U20 ( .A(c[3]), .B(c[6]), .Z(n16) );
  AND2_X1 U21 ( .A1(n51), .A2(n50), .ZN(n17) );
  OR2_X1 U22 ( .A1(b[1]), .A2(b[3]), .ZN(n18) );
  NAND2_X1 U23 ( .A1(n45), .A2(n18), .ZN(n75) );
  XNOR2_X1 U24 ( .A(n10), .B(n23), .ZN(s2[3]) );
  XOR2_X1 U25 ( .A(c[3]), .B(c[6]), .Z(n42) );
  NAND2_X1 U26 ( .A1(n109), .A2(n108), .ZN(n19) );
  OAI21_X1 U27 ( .B1(b[1]), .B2(b[3]), .A(n45), .ZN(n20) );
  AND2_X2 U28 ( .A1(b[2]), .A2(b[0]), .ZN(n45) );
  NAND4_X1 U29 ( .A1(n61), .A2(n60), .A3(n59), .A4(n14), .ZN(n62) );
  NAND2_X1 U30 ( .A1(n57), .A2(n58), .ZN(n63) );
  INV_X1 U31 ( .A(n59), .ZN(n56) );
  INV_X1 U32 ( .A(n61), .ZN(n52) );
  INV_X1 U33 ( .A(n60), .ZN(n57) );
  XNOR2_X1 U34 ( .A(n49), .B(n21), .ZN(s3[5]) );
  XNOR2_X1 U35 ( .A(c[2]), .B(c[5]), .ZN(n21) );
  XOR2_X1 U36 ( .A(c[4]), .B(c[7]), .Z(n72) );
  OAI211_X1 U37 ( .C1(c[1]), .C2(c[4]), .A(c[3]), .B(c[0]), .ZN(n68) );
  NOR2_X1 U38 ( .A1(n67), .A2(n66), .ZN(n71) );
  NOR2_X1 U39 ( .A1(c[2]), .A2(c[5]), .ZN(n67) );
  NOR2_X1 U40 ( .A1(c[6]), .A2(c[3]), .ZN(n66) );
  AND2_X1 U41 ( .A1(c[6]), .A2(c[3]), .ZN(n22) );
  XNOR2_X1 U42 ( .A(b[1]), .B(b[3]), .ZN(n23) );
  XNOR2_X1 U43 ( .A(n48), .B(n24), .ZN(s3[4]) );
  OR2_X1 U44 ( .A1(n54), .A2(n47), .ZN(n24) );
  BUF_X1 U45 ( .A(a[5]), .Z(s1[7]) );
  BUF_X1 U46 ( .A(a[4]), .Z(s1[6]) );
  BUF_X1 U47 ( .A(a[3]), .Z(s1[5]) );
  BUF_X1 U48 ( .A(a[2]), .Z(s1[4]) );
  BUF_X1 U49 ( .A(a[1]), .Z(s1[3]) );
  BUF_X1 U50 ( .A(a[0]), .Z(s1[2]) );
  BUF_X1 U51 ( .A(b[1]), .Z(s2[1]) );
  BUF_X1 U52 ( .A(c[2]), .Z(s3[2]) );
  BUF_X1 U53 ( .A(c[0]), .Z(s3[0]) );
  XNOR2_X1 U54 ( .A(n73), .B(n72), .ZN(s3[7]) );
  AOI21_X1 U55 ( .B1(n70), .B2(n71), .A(n22), .ZN(n73) );
  AND2_X1 U56 ( .A1(n86), .A2(n95), .ZN(n34) );
  BUF_X1 U57 ( .A(b[0]), .Z(s2[0]) );
  NAND2_X1 U58 ( .A1(n39), .A2(b[4]), .ZN(n36) );
  BUF_X2 U59 ( .A(b[2]), .Z(n39) );
  INV_X1 U60 ( .A(b[4]), .ZN(n37) );
  INV_X1 U61 ( .A(b[4]), .ZN(n38) );
  XNOR2_X1 U62 ( .A(n91), .B(n40), .ZN(s2[6]) );
  XNOR2_X1 U63 ( .A(b[6]), .B(b[4]), .ZN(n40) );
  XNOR2_X1 U64 ( .A(b[5]), .B(b[7]), .ZN(n109) );
  INV_X1 U65 ( .A(b[4]), .ZN(n43) );
  INV_X1 U66 ( .A(b[4]), .ZN(n44) );
  XNOR2_X1 U67 ( .A(b[3]), .B(b[5]), .ZN(n78) );
  NAND2_X1 U68 ( .A1(n69), .A2(n68), .ZN(n70) );
  AOI22_X1 U69 ( .A1(c[2]), .A2(c[5]), .B1(c[4]), .B2(c[1]), .ZN(n69) );
  NOR2_X1 U70 ( .A1(n42), .A2(n17), .ZN(n53) );
  OAI22_X1 U71 ( .A1(n88), .A2(n87), .B1(n86), .B2(n43), .ZN(n46) );
  AND3_X1 U72 ( .A1(n75), .A2(n77), .A3(n76), .ZN(n79) );
  NAND4_X1 U73 ( .A1(n65), .A2(n64), .A3(n63), .A4(n62), .ZN(s3[6]) );
  AOI22_X1 U74 ( .A1(n53), .A2(n52), .B1(n15), .B2(n16), .ZN(n65) );
  XNOR2_X1 U75 ( .A(c[3]), .B(c[6]), .ZN(n58) );
  XOR2_X1 U76 ( .A(s3[1]), .B(c[4]), .Z(n48) );
  INV_X1 U77 ( .A(c[3]), .ZN(n54) );
  INV_X1 U78 ( .A(c[0]), .ZN(n47) );
  NAND2_X1 U79 ( .A1(c[1]), .A2(c[4]), .ZN(n61) );
  OAI211_X1 U80 ( .C1(c[1]), .C2(c[4]), .A(c[0]), .B(c[3]), .ZN(n59) );
  NAND2_X1 U81 ( .A1(n61), .A2(n59), .ZN(n49) );
  INV_X1 U82 ( .A(c[5]), .ZN(n51) );
  INV_X1 U83 ( .A(c[2]), .ZN(n50) );
  NAND2_X1 U84 ( .A1(n51), .A2(n50), .ZN(n55) );
  NAND3_X1 U85 ( .A1(n56), .A2(n55), .A3(n58), .ZN(n64) );
  NAND2_X1 U86 ( .A1(c[2]), .A2(c[5]), .ZN(n60) );
  NAND2_X1 U87 ( .A1(b[1]), .A2(b[3]), .ZN(n76) );
  NAND2_X1 U88 ( .A1(n76), .A2(n20), .ZN(n74) );
  INV_X1 U89 ( .A(n20), .ZN(n82) );
  INV_X1 U90 ( .A(b[3]), .ZN(n88) );
  INV_X1 U91 ( .A(n78), .ZN(n81) );
  INV_X1 U92 ( .A(b[2]), .ZN(n86) );
  INV_X1 U93 ( .A(b[4]), .ZN(n95) );
  NAND2_X1 U94 ( .A1(n39), .A2(b[4]), .ZN(n77) );
  OAI21_X1 U95 ( .B1(n34), .B2(n76), .A(n36), .ZN(n80) );
  OAI33_X1 U96 ( .A1(n82), .A2(n81), .A3(n80), .B1(n79), .B2(n34), .B3(n78), 
        .ZN(n83) );
  INV_X1 U97 ( .A(n83), .ZN(s2[5]) );
  OAI211_X1 U98 ( .C1(b[1]), .C2(b[3]), .A(b[2]), .B(b[0]), .ZN(n84) );
  INV_X1 U99 ( .A(n84), .ZN(n103) );
  NAND2_X1 U100 ( .A1(b[5]), .A2(b[3]), .ZN(n106) );
  INV_X1 U101 ( .A(n106), .ZN(n85) );
  NOR2_X1 U102 ( .A1(n103), .A2(n85), .ZN(n90) );
  INV_X1 U103 ( .A(b[1]), .ZN(n87) );
  OAI22_X1 U104 ( .A1(n88), .A2(n87), .B1(n86), .B2(n44), .ZN(n102) );
  INV_X1 U105 ( .A(n46), .ZN(n89) );
  OAI22_X1 U106 ( .A1(b[4]), .A2(b[2]), .B1(b[5]), .B2(b[3]), .ZN(n100) );
  AOI22_X1 U107 ( .A1(n89), .A2(n90), .B1(n106), .B2(n41), .ZN(n91) );
  NAND2_X1 U108 ( .A1(b[6]), .A2(b[4]), .ZN(n105) );
  INV_X1 U109 ( .A(n105), .ZN(n99) );
  INV_X1 U110 ( .A(b[6]), .ZN(n94) );
  NAND2_X1 U111 ( .A1(n38), .A2(n94), .ZN(n108) );
  INV_X1 U112 ( .A(n108), .ZN(n98) );
  XOR2_X1 U113 ( .A(b[7]), .B(b[5]), .Z(n97) );
  NAND2_X1 U114 ( .A1(b[5]), .A2(b[3]), .ZN(n93) );
  INV_X1 U115 ( .A(b[7]), .ZN(n92) );
  AOI211_X1 U116 ( .C1(n37), .C2(n94), .A(n93), .B(n92), .ZN(n96) );
  AOI221_X1 U117 ( .B1(n99), .B2(n109), .C1(n98), .C2(n97), .A(n96), .ZN(n112)
         );
  INV_X1 U118 ( .A(n109), .ZN(n104) );
  INV_X1 U119 ( .A(n100), .ZN(n101) );
  OAI21_X1 U120 ( .B1(n103), .B2(n102), .A(n101), .ZN(n107) );
  NAND4_X1 U121 ( .A1(n107), .A2(n105), .A3(n104), .A4(n106), .ZN(n111) );
  NAND3_X1 U122 ( .A1(n111), .A2(n110), .A3(n112), .ZN(s2[7]) );
  XOR2_X1 U123 ( .A(c[0]), .B(c[3]), .Z(s3[3]) );
  XOR2_X1 U124 ( .A(n39), .B(s2[0]), .Z(s2[2]) );
endmodule

