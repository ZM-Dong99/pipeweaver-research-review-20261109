/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:30:33 2025
/////////////////////////////////////////////////////////////


module mul_const_gpt ( a, b, c, s1, s2, s3 );
  input [7:0] a;
  input [7:0] b;
  input [7:0] c;
  output [7:0] s1;
  output [7:0] s2;
  output [7:0] s3;
  wire   n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77,
         n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91,
         n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104,
         n105, n106, n107, n108, n109, n110, n111;

  INV_X1 U7 ( .A(1'b1), .ZN(s3[0]) );
  INV_X1 U9 ( .A(1'b1), .ZN(s1[0]) );
  INV_X1 U11 ( .A(1'b1), .ZN(s1[1]) );
  BUF_X2 U13 ( .A(b[4]), .Z(n34) );
  BUF_X1 U14 ( .A(b[0]), .Z(s2[0]) );
  INV_X1 U15 ( .A(b[4]), .ZN(n13) );
  INV_X1 U16 ( .A(n99), .ZN(n14) );
  AND2_X1 U17 ( .A1(b[6]), .A2(n34), .ZN(n15) );
  AND2_X1 U18 ( .A1(b[0]), .A2(b[2]), .ZN(n16) );
  AND2_X1 U19 ( .A1(b[0]), .A2(b[2]), .ZN(n17) );
  NAND2_X1 U20 ( .A1(n57), .A2(n56), .ZN(n18) );
  NAND2_X1 U21 ( .A1(n44), .A2(n38), .ZN(n19) );
  INV_X1 U22 ( .A(n55), .ZN(n20) );
  AND3_X1 U23 ( .A1(n20), .A2(n19), .A3(n18), .ZN(n58) );
  OAI22_X1 U24 ( .A1(n87), .A2(n86), .B1(n35), .B2(n13), .ZN(n21) );
  AND2_X1 U25 ( .A1(b[2]), .A2(b[0]), .ZN(n45) );
  NOR2_X1 U26 ( .A1(n82), .A2(n37), .ZN(s2[5]) );
  XNOR2_X1 U27 ( .A(n72), .B(n71), .ZN(s3[7]) );
  XNOR2_X1 U28 ( .A(n70), .B(c[6]), .ZN(n71) );
  AOI21_X1 U29 ( .B1(n68), .B2(n69), .A(n67), .ZN(n72) );
  INV_X1 U30 ( .A(c[4]), .ZN(n70) );
  OAI211_X1 U31 ( .C1(c[1]), .C2(c[3]), .A(c[2]), .B(c[0]), .ZN(n64) );
  NOR2_X1 U32 ( .A1(c[2]), .A2(c[4]), .ZN(n44) );
  NOR2_X1 U33 ( .A1(n63), .A2(n62), .ZN(n69) );
  NOR2_X1 U34 ( .A1(c[5]), .A2(c[3]), .ZN(n62) );
  NOR2_X1 U35 ( .A1(c[4]), .A2(c[2]), .ZN(n63) );
  XNOR2_X1 U36 ( .A(n74), .B(n22), .ZN(s2[4]) );
  XNOR2_X1 U37 ( .A(b[4]), .B(b[2]), .ZN(n22) );
  AND2_X1 U38 ( .A1(c[3]), .A2(c[5]), .ZN(n67) );
  XNOR2_X1 U39 ( .A(n51), .B(n23), .ZN(s3[5]) );
  XNOR2_X1 U40 ( .A(c[4]), .B(c[2]), .ZN(n23) );
  XNOR2_X1 U41 ( .A(n24), .B(n50), .ZN(s3[4]) );
  XNOR2_X1 U42 ( .A(c[1]), .B(c[3]), .ZN(n24) );
  BUF_X1 U43 ( .A(a[5]), .Z(s1[7]) );
  BUF_X1 U44 ( .A(a[4]), .Z(s1[6]) );
  BUF_X1 U45 ( .A(a[3]), .Z(s1[5]) );
  BUF_X1 U46 ( .A(a[2]), .Z(s1[4]) );
  BUF_X1 U47 ( .A(a[1]), .Z(s1[3]) );
  BUF_X1 U48 ( .A(a[0]), .Z(s1[2]) );
  BUF_X1 U49 ( .A(b[1]), .Z(s2[1]) );
  BUF_X1 U50 ( .A(c[1]), .Z(s3[2]) );
  BUF_X1 U51 ( .A(c[0]), .Z(s3[1]) );
  INV_X1 U52 ( .A(b[2]), .ZN(n35) );
  NOR2_X1 U53 ( .A1(n81), .A2(n48), .ZN(n82) );
  INV_X1 U54 ( .A(c[5]), .ZN(n36) );
  AND3_X1 U55 ( .A1(n75), .A2(n76), .A3(n48), .ZN(n37) );
  AND2_X1 U56 ( .A1(c[3]), .A2(n36), .ZN(n38) );
  OAI211_X1 U57 ( .C1(c[1]), .C2(c[3]), .A(c[0]), .B(c[2]), .ZN(n39) );
  XNOR2_X1 U58 ( .A(b[5]), .B(b[7]), .ZN(n108) );
  XNOR2_X1 U59 ( .A(n90), .B(n40), .ZN(s2[6]) );
  XNOR2_X1 U60 ( .A(b[6]), .B(n34), .ZN(n40) );
  OAI211_X1 U61 ( .C1(n80), .C2(n79), .A(n78), .B(n46), .ZN(n81) );
  NAND2_X1 U62 ( .A1(n65), .A2(n64), .ZN(n68) );
  AOI22_X1 U63 ( .A1(c[4]), .A2(c[2]), .B1(c[1]), .B2(c[3]), .ZN(n65) );
  XNOR2_X1 U64 ( .A(c[3]), .B(c[5]), .ZN(n56) );
  AND2_X1 U65 ( .A1(n66), .A2(c[3]), .ZN(n41) );
  INV_X1 U66 ( .A(b[4]), .ZN(n42) );
  INV_X1 U67 ( .A(b[4]), .ZN(n43) );
  OAI21_X1 U68 ( .B1(b[1]), .B2(b[3]), .A(n45), .ZN(n46) );
  OAI21_X1 U69 ( .B1(b[1]), .B2(b[3]), .A(n17), .ZN(n47) );
  XOR2_X1 U70 ( .A(b[3]), .B(b[5]), .Z(n48) );
  INV_X1 U71 ( .A(c[2]), .ZN(n53) );
  INV_X1 U72 ( .A(c[0]), .ZN(n49) );
  NOR2_X1 U73 ( .A1(n53), .A2(n49), .ZN(n50) );
  NAND2_X1 U74 ( .A1(c[1]), .A2(c[3]), .ZN(n54) );
  OAI211_X1 U75 ( .C1(c[1]), .C2(c[3]), .A(c[0]), .B(c[2]), .ZN(n52) );
  NAND2_X1 U76 ( .A1(n54), .A2(n39), .ZN(n51) );
  INV_X1 U77 ( .A(n56), .ZN(n61) );
  NAND2_X1 U78 ( .A1(c[4]), .A2(c[2]), .ZN(n60) );
  NAND4_X1 U79 ( .A1(n54), .A2(n60), .A3(n39), .A4(n61), .ZN(n59) );
  INV_X1 U80 ( .A(n52), .ZN(n57) );
  INV_X1 U81 ( .A(c[5]), .ZN(n66) );
  NOR3_X1 U82 ( .A1(n41), .A2(n54), .A3(n44), .ZN(n55) );
  OAI211_X1 U83 ( .C1(n61), .C2(n60), .A(n58), .B(n59), .ZN(s3[6]) );
  XOR2_X1 U84 ( .A(b[1]), .B(b[3]), .Z(n73) );
  XOR2_X1 U85 ( .A(n45), .B(n73), .Z(s2[3]) );
  NAND2_X1 U86 ( .A1(b[1]), .A2(b[3]), .ZN(n79) );
  OAI21_X1 U87 ( .B1(b[1]), .B2(b[3]), .A(n16), .ZN(n77) );
  NAND2_X1 U88 ( .A1(n79), .A2(n47), .ZN(n74) );
  INV_X1 U89 ( .A(b[2]), .ZN(n85) );
  INV_X1 U90 ( .A(b[4]), .ZN(n94) );
  NAND2_X1 U91 ( .A1(n85), .A2(n42), .ZN(n76) );
  NAND2_X1 U92 ( .A1(n34), .A2(b[2]), .ZN(n78) );
  NAND3_X1 U93 ( .A1(n78), .A2(n77), .A3(n79), .ZN(n75) );
  INV_X1 U94 ( .A(b[3]), .ZN(n87) );
  INV_X1 U95 ( .A(n76), .ZN(n80) );
  OAI211_X1 U96 ( .C1(b[1]), .C2(b[3]), .A(b[2]), .B(b[0]), .ZN(n83) );
  INV_X1 U97 ( .A(n83), .ZN(n101) );
  NAND2_X1 U98 ( .A1(b[5]), .A2(b[3]), .ZN(n104) );
  INV_X1 U99 ( .A(n104), .ZN(n84) );
  NOR2_X1 U100 ( .A1(n101), .A2(n84), .ZN(n89) );
  INV_X1 U101 ( .A(b[1]), .ZN(n86) );
  OAI22_X1 U102 ( .A1(n87), .A2(n86), .B1(n35), .B2(n94), .ZN(n100) );
  INV_X1 U103 ( .A(n21), .ZN(n88) );
  OAI22_X1 U104 ( .A1(b[4]), .A2(b[2]), .B1(b[5]), .B2(b[3]), .ZN(n98) );
  AOI22_X1 U105 ( .A1(n88), .A2(n89), .B1(n104), .B2(n14), .ZN(n90) );
  NAND2_X1 U106 ( .A1(b[6]), .A2(n34), .ZN(n103) );
  INV_X1 U107 ( .A(b[6]), .ZN(n93) );
  NAND2_X1 U108 ( .A1(n43), .A2(n93), .ZN(n107) );
  INV_X1 U109 ( .A(n107), .ZN(n97) );
  XOR2_X1 U110 ( .A(b[7]), .B(b[5]), .Z(n96) );
  NAND2_X1 U111 ( .A1(b[5]), .A2(b[3]), .ZN(n92) );
  INV_X1 U112 ( .A(b[7]), .ZN(n91) );
  AOI211_X1 U113 ( .C1(n42), .C2(n93), .A(n92), .B(n91), .ZN(n95) );
  AOI221_X1 U114 ( .B1(n15), .B2(n108), .C1(n97), .C2(n96), .A(n95), .ZN(n111)
         );
  INV_X1 U115 ( .A(n108), .ZN(n102) );
  INV_X1 U116 ( .A(n98), .ZN(n99) );
  OAI21_X1 U117 ( .B1(n101), .B2(n100), .A(n99), .ZN(n105) );
  NAND4_X1 U118 ( .A1(n105), .A2(n103), .A3(n102), .A4(n104), .ZN(n110) );
  INV_X1 U119 ( .A(n105), .ZN(n106) );
  NAND3_X1 U120 ( .A1(n106), .A2(n107), .A3(n108), .ZN(n109) );
  NAND3_X1 U121 ( .A1(n109), .A2(n110), .A3(n111), .ZN(s2[7]) );
  XOR2_X1 U122 ( .A(c[2]), .B(c[0]), .Z(s3[3]) );
  XOR2_X1 U123 ( .A(s2[0]), .B(b[2]), .Z(s2[2]) );
endmodule

