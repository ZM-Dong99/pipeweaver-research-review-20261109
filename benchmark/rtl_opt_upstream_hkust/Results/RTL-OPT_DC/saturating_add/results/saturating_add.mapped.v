/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 01:45:51 2025
/////////////////////////////////////////////////////////////


module saturating_add ( clk, a, b, z );
  input [7:0] a;
  input [7:0] b;
  output [7:0] z;
  input clk;
  wire   N1, N2, overflow, N5, N6, N7, N8, N9, N10, N11, N12, n13, n14, n15,
         n16, n17, n18, n19, n20, n21, n22, n23, n24, add_7_n119, add_7_n118,
         add_7_n117, add_7_n116, add_7_n115, add_7_n114, add_7_n113,
         add_7_n112, add_7_n111, add_7_n110, add_7_n109, add_7_n108,
         add_7_n107, add_7_n106, add_7_n105, add_7_n104, add_7_n103,
         add_7_n102, add_7_n101, add_7_n100, add_7_n99, add_7_n98, add_7_n97,
         add_7_n96, add_7_n95, add_7_n94, add_7_n93, add_7_n92, add_7_n91,
         add_7_n90, add_7_n89, add_7_n88, add_7_n87, add_7_n86, add_7_n85,
         add_7_n84, add_7_n83, add_7_n82, add_7_n81, add_7_n80, add_7_n79,
         add_7_n78, add_7_n77, add_7_n76, add_7_n75, add_7_n74, add_7_n73,
         add_7_n72, add_7_n71, add_7_n70, add_7_n69, add_7_n68, add_7_n67,
         add_7_n66, add_7_n65, add_7_n64, add_7_n63, add_7_n62, add_7_n61,
         add_7_n60, add_7_n59, add_7_n58, add_7_n57, add_7_n56, add_7_n55,
         add_7_n54, add_7_n53, add_7_n52, add_7_n51, add_7_n50, add_7_n49,
         add_7_n48, add_7_n47, add_7_n46, add_7_n45, add_7_n44, add_7_n43,
         add_7_n42, add_7_n41, add_7_n40, add_7_n39, add_7_n37, add_7_n36,
         add_7_n35, add_7_n34, add_7_n33, add_7_n32, add_7_n31, add_7_n30,
         add_7_n29, add_7_n28, add_7_n27, add_7_n26, add_7_n25, add_7_n24,
         add_7_n23, add_7_n22, add_7_n21, add_7_n20, add_7_n19, add_7_n18,
         add_7_n17, add_7_n16, add_7_n15, add_7_n14, add_7_n13, add_7_n12,
         add_7_n11, add_7_n10, add_7_n9, add_7_n8, add_7_n7, add_7_n6,
         add_7_n5, add_7_n4, add_7_n3, add_7_n2, add_7_n1;
  wire   [8:0] sum;

  DFF_X1 z_reg_4_ ( .D(N9), .CK(clk), .Q(z[4]) );
  DFF_X1 z_reg_3_ ( .D(N8), .CK(clk), .Q(z[3]) );
  DFF_X1 z_reg_2_ ( .D(N7), .CK(clk), .Q(z[2]) );
  DFF_X1 z_reg_1_ ( .D(N6), .CK(clk), .Q(z[1]) );
  DFF_X1 z_reg_0_ ( .D(N5), .CK(clk), .Q(z[0]) );
  DFF_X1 z_reg_7_ ( .D(N12), .CK(clk), .Q(z[7]) );
  DFF_X1 z_reg_6_ ( .D(N11), .CK(clk), .Q(z[6]) );
  DFF_X1 z_reg_5_ ( .D(N10), .CK(clk), .Q(z[5]) );
  DFF_X1 overflow_reg ( .D(N1), .CK(clk), .Q(overflow) );
  DFF_X1 underflow_reg ( .D(N2), .CK(clk), .QN(n23) );
  AOI21_X1 U24 ( .B1(n13), .B2(n23), .A(overflow), .ZN(N12) );
  INV_X1 U25 ( .A(sum[7]), .ZN(n13) );
  OR2_X1 U26 ( .A1(n15), .A2(n16), .ZN(n14) );
  NOR2_X1 U27 ( .A1(sum[8]), .A2(n14), .ZN(N2) );
  AND3_X1 U28 ( .A1(sum[8]), .A2(n15), .A3(n16), .ZN(N1) );
  INV_X1 U29 ( .A(b[7]), .ZN(n16) );
  INV_X1 U30 ( .A(a[7]), .ZN(n15) );
  AOI21_X1 U31 ( .B1(sum[0]), .B2(n23), .A(overflow), .ZN(n17) );
  INV_X1 U32 ( .A(n17), .ZN(N5) );
  AOI21_X1 U33 ( .B1(sum[1]), .B2(n23), .A(overflow), .ZN(n18) );
  INV_X1 U34 ( .A(n18), .ZN(N6) );
  AOI21_X1 U35 ( .B1(sum[2]), .B2(n23), .A(overflow), .ZN(n19) );
  INV_X1 U36 ( .A(n19), .ZN(N7) );
  AOI21_X1 U37 ( .B1(sum[3]), .B2(n23), .A(overflow), .ZN(n20) );
  INV_X1 U38 ( .A(n20), .ZN(N8) );
  AOI21_X1 U39 ( .B1(sum[4]), .B2(n23), .A(overflow), .ZN(n21) );
  INV_X1 U40 ( .A(n21), .ZN(N9) );
  AOI21_X1 U41 ( .B1(sum[5]), .B2(n23), .A(overflow), .ZN(n22) );
  INV_X1 U42 ( .A(n22), .ZN(N10) );
  AOI21_X1 U43 ( .B1(sum[6]), .B2(n23), .A(overflow), .ZN(n24) );
  INV_X1 U44 ( .A(n24), .ZN(N11) );
  NAND3_X1 add_7_U128 ( .A1(add_7_n77), .A2(b[0]), .A3(a[0]), .ZN(add_7_n117)
         );
  OAI21_X1 add_7_U127 ( .B1(add_7_n4), .B2(add_7_n20), .A(add_7_n115), .ZN(
        add_7_n114) );
  NAND2_X1 add_7_U126 ( .A1(b[0]), .A2(a[0]), .ZN(add_7_n107) );
  NAND2_X1 add_7_U125 ( .A1(a[2]), .A2(b[2]), .ZN(add_7_n105) );
  OAI21_X1 add_7_U124 ( .B1(add_7_n29), .B2(add_7_n9), .A(add_7_n98), .ZN(
        add_7_n96) );
  XNOR2_X1 add_7_U123 ( .A(add_7_n96), .B(add_7_n97), .ZN(sum[5]) );
  INV_X1 add_7_U122 ( .A(add_7_n17), .ZN(add_7_n88) );
  OAI21_X1 add_7_U121 ( .B1(add_7_n29), .B2(add_7_n83), .A(add_7_n88), .ZN(
        add_7_n84) );
  XNOR2_X1 add_7_U120 ( .A(add_7_n84), .B(add_7_n85), .ZN(sum[6]) );
  NAND3_X1 add_7_U119 ( .A1(add_7_n82), .A2(add_7_n33), .A3(add_7_n15), .ZN(
        add_7_n79) );
  NAND3_X1 add_7_U118 ( .A1(add_7_n81), .A2(add_7_n33), .A3(add_7_n82), .ZN(
        add_7_n80) );
  NAND2_X1 add_7_U117 ( .A1(b[7]), .A2(a[7]), .ZN(add_7_n69) );
  INV_X1 add_7_U116 ( .A(add_7_n65), .ZN(add_7_n64) );
  NOR2_X1 add_7_U115 ( .A1(add_7_n32), .A2(add_7_n19), .ZN(add_7_n58) );
  NAND3_X1 add_7_U114 ( .A1(add_7_n58), .A2(add_7_n59), .A3(add_7_n60), .ZN(
        add_7_n50) );
  NAND3_X1 add_7_U113 ( .A1(add_7_n56), .A2(add_7_n54), .A3(add_7_n55), .ZN(
        add_7_n51) );
  NAND4_X1 add_7_U112 ( .A1(add_7_n44), .A2(add_7_n53), .A3(add_7_n22), .A4(
        add_7_n54), .ZN(add_7_n52) );
  OAI211_X1 add_7_U111 ( .C1(add_7_n50), .C2(add_7_n49), .A(add_7_n51), .B(
        add_7_n52), .ZN(add_7_n42) );
  NAND2_X1 add_7_U110 ( .A1(add_7_n46), .A2(add_7_n32), .ZN(add_7_n43) );
  NOR2_X1 add_7_U109 ( .A1(add_7_n28), .A2(add_7_n26), .ZN(add_7_n44) );
  NAND2_X1 add_7_U108 ( .A1(b[4]), .A2(a[4]), .ZN(add_7_n47) );
  NAND3_X1 add_7_U107 ( .A1(add_7_n46), .A2(add_7_n47), .A3(add_7_n48), .ZN(
        add_7_n45) );
  MUX2_X1 add_7_U106 ( .A(add_7_n39), .B(add_7_n40), .S(add_7_n41), .Z(sum[8])
         );
  XNOR2_X1 add_7_U105 ( .A(add_7_n68), .B(add_7_n39), .ZN(sum[7]) );
  INV_X1 add_7_U104 ( .A(a[5]), .ZN(add_7_n93) );
  INV_X1 add_7_U103 ( .A(b[5]), .ZN(add_7_n92) );
  NAND2_X1 add_7_U102 ( .A1(add_7_n16), .A2(add_7_n21), .ZN(add_7_n91) );
  NOR2_X1 add_7_U101 ( .A1(add_7_n42), .A2(add_7_n36), .ZN(add_7_n41) );
  NAND2_X1 add_7_U100 ( .A1(add_7_n70), .A2(add_7_n35), .ZN(add_7_n68) );
  NAND2_X1 add_7_U99 ( .A1(add_7_n75), .A2(add_7_n10), .ZN(add_7_n74) );
  NAND2_X1 add_7_U98 ( .A1(add_7_n33), .A2(add_7_n46), .ZN(add_7_n85) );
  NAND2_X1 add_7_U97 ( .A1(add_7_n64), .A2(add_7_n22), .ZN(add_7_n49) );
  NAND2_X1 add_7_U96 ( .A1(add_7_n6), .A2(add_7_n8), .ZN(add_7_n63) );
  AND2_X1 add_7_U95 ( .A1(add_7_n63), .A2(add_7_n31), .ZN(add_7_n59) );
  NOR2_X1 add_7_U94 ( .A1(add_7_n34), .A2(add_7_n57), .ZN(add_7_n56) );
  INV_X1 add_7_U93 ( .A(a[6]), .ZN(add_7_n87) );
  NAND2_X1 add_7_U92 ( .A1(b[6]), .A2(a[6]), .ZN(add_7_n46) );
  INV_X1 add_7_U91 ( .A(add_7_n83), .ZN(add_7_n82) );
  NAND2_X1 add_7_U90 ( .A1(add_7_n90), .A2(add_7_n91), .ZN(add_7_n83) );
  INV_X1 add_7_U89 ( .A(b[6]), .ZN(add_7_n86) );
  NAND2_X1 add_7_U88 ( .A1(add_7_n94), .A2(add_7_n95), .ZN(add_7_n90) );
  INV_X1 add_7_U87 ( .A(a[4]), .ZN(add_7_n95) );
  OAI211_X1 add_7_U86 ( .C1(a[5]), .C2(b[5]), .A(a[4]), .B(b[4]), .ZN(
        add_7_n89) );
  NAND2_X1 add_7_U85 ( .A1(b[4]), .A2(a[4]), .ZN(add_7_n98) );
  NAND2_X1 add_7_U84 ( .A1(add_7_n74), .A2(add_7_n46), .ZN(add_7_n73) );
  AOI21_X1 add_7_U83 ( .B1(add_7_n71), .B2(add_7_n72), .A(add_7_n73), .ZN(
        add_7_n70) );
  INV_X1 add_7_U82 ( .A(b[4]), .ZN(add_7_n94) );
  AND2_X1 add_7_U81 ( .A1(add_7_n62), .A2(add_7_n119), .ZN(sum[0]) );
  OR2_X1 add_7_U80 ( .A1(b[0]), .A2(a[0]), .ZN(add_7_n119) );
  NAND2_X1 add_7_U79 ( .A1(b[2]), .A2(a[2]), .ZN(add_7_n115) );
  NAND2_X1 add_7_U78 ( .A1(add_7_n63), .A2(add_7_n69), .ZN(add_7_n39) );
  XOR2_X1 add_7_U77 ( .A(add_7_n62), .B(add_7_n118), .Z(sum[1]) );
  AND2_X1 add_7_U76 ( .A1(add_7_n115), .A2(add_7_n18), .ZN(add_7_n37) );
  XOR2_X1 add_7_U75 ( .A(add_7_n116), .B(add_7_n37), .Z(sum[2]) );
  NAND2_X1 add_7_U74 ( .A1(b[1]), .A2(a[1]), .ZN(add_7_n78) );
  NAND2_X1 add_7_U73 ( .A1(b[1]), .A2(a[1]), .ZN(add_7_n61) );
  NAND2_X1 add_7_U72 ( .A1(add_7_n117), .A2(add_7_n61), .ZN(add_7_n116) );
  NAND2_X1 add_7_U71 ( .A1(b[0]), .A2(a[0]), .ZN(add_7_n62) );
  NAND2_X1 add_7_U70 ( .A1(add_7_n89), .A2(add_7_n48), .ZN(add_7_n75) );
  NAND2_X1 add_7_U69 ( .A1(b[5]), .A2(a[5]), .ZN(add_7_n48) );
  NAND2_X1 add_7_U68 ( .A1(b[3]), .A2(a[3]), .ZN(add_7_n57) );
  NOR2_X1 add_7_U67 ( .A1(a[2]), .A2(b[2]), .ZN(add_7_n109) );
  NOR2_X1 add_7_U66 ( .A1(a[1]), .A2(b[1]), .ZN(add_7_n108) );
  NOR2_X1 add_7_U65 ( .A1(add_7_n108), .A2(add_7_n109), .ZN(add_7_n101) );
  NOR2_X1 add_7_U64 ( .A1(a[2]), .A2(b[2]), .ZN(add_7_n113) );
  NOR2_X1 add_7_U63 ( .A1(a[3]), .A2(b[3]), .ZN(add_7_n112) );
  NOR2_X1 add_7_U62 ( .A1(add_7_n112), .A2(add_7_n113), .ZN(add_7_n111) );
  NOR2_X1 add_7_U61 ( .A1(a[3]), .A2(b[3]), .ZN(add_7_n106) );
  NOR2_X1 add_7_U60 ( .A1(add_7_n106), .A2(add_7_n107), .ZN(add_7_n102) );
  OR2_X2 add_7_U59 ( .A1(b[1]), .A2(a[1]), .ZN(add_7_n77) );
  NAND2_X1 add_7_U58 ( .A1(add_7_n54), .A2(add_7_n48), .ZN(add_7_n97) );
  AND2_X1 add_7_U57 ( .A1(b[1]), .A2(a[1]), .ZN(add_7_n110) );
  AOI21_X1 add_7_U56 ( .B1(add_7_n101), .B2(add_7_n102), .A(add_7_n103), .ZN(
        add_7_n100) );
  AOI21_X1 add_7_U55 ( .B1(add_7_n110), .B2(add_7_n111), .A(add_7_n81), .ZN(
        add_7_n99) );
  NOR2_X1 add_7_U54 ( .A1(a[3]), .A2(b[3]), .ZN(add_7_n104) );
  NOR2_X1 add_7_U53 ( .A1(add_7_n104), .A2(add_7_n105), .ZN(add_7_n103) );
  INV_X1 add_7_U52 ( .A(b[7]), .ZN(add_7_n67) );
  INV_X1 add_7_U51 ( .A(a[7]), .ZN(add_7_n66) );
  NAND2_X1 add_7_U50 ( .A1(add_7_n61), .A2(add_7_n77), .ZN(add_7_n118) );
  INV_X1 add_7_U49 ( .A(add_7_n57), .ZN(add_7_n81) );
  NAND2_X1 add_7_U48 ( .A1(add_7_n61), .A2(add_7_n62), .ZN(add_7_n60) );
  AND3_X1 add_7_U47 ( .A1(add_7_n55), .A2(add_7_n43), .A3(add_7_n45), .ZN(
        add_7_n36) );
  NAND2_X1 add_7_U46 ( .A1(add_7_n66), .A2(add_7_n67), .ZN(add_7_n40) );
  NAND2_X1 add_7_U45 ( .A1(add_7_n92), .A2(add_7_n93), .ZN(add_7_n54) );
  NOR2_X1 add_7_U44 ( .A1(add_7_n34), .A2(add_7_n65), .ZN(add_7_n72) );
  AND2_X1 add_7_U43 ( .A1(add_7_n79), .A2(add_7_n80), .ZN(add_7_n35) );
  INV_X1 add_7_U42 ( .A(add_7_n26), .ZN(add_7_n33) );
  AND2_X1 add_7_U41 ( .A1(add_7_n93), .A2(add_7_n92), .ZN(add_7_n32) );
  NAND2_X1 add_7_U40 ( .A1(add_7_n86), .A2(add_7_n87), .ZN(add_7_n31) );
  AND2_X1 add_7_U39 ( .A1(add_7_n100), .A2(add_7_n30), .ZN(add_7_n29) );
  AOI21_X1 add_7_U38 ( .B1(add_7_n101), .B2(add_7_n102), .A(add_7_n103), .ZN(
        add_7_n27) );
  AND2_X1 add_7_U37 ( .A1(b[2]), .A2(a[2]), .ZN(add_7_n25) );
  NAND3_X1 add_7_U36 ( .A1(add_7_n10), .A2(add_7_n54), .A3(add_7_n77), .ZN(
        add_7_n24) );
  AND2_X1 add_7_U35 ( .A1(add_7_n78), .A2(add_7_n62), .ZN(add_7_n23) );
  NOR2_X1 add_7_U34 ( .A1(add_7_n23), .A2(add_7_n24), .ZN(add_7_n71) );
  OR2_X2 add_7_U33 ( .A1(b[4]), .A2(a[4]), .ZN(add_7_n22) );
  INV_X1 add_7_U32 ( .A(a[5]), .ZN(add_7_n21) );
  NOR2_X1 add_7_U31 ( .A1(b[7]), .A2(a[7]), .ZN(add_7_n28) );
  NOR2_X1 add_7_U30 ( .A1(b[2]), .A2(a[2]), .ZN(add_7_n20) );
  NOR2_X1 add_7_U29 ( .A1(b[1]), .A2(a[1]), .ZN(add_7_n19) );
  INV_X1 add_7_U28 ( .A(add_7_n20), .ZN(add_7_n18) );
  CLKBUF_X1 add_7_U27 ( .A(add_7_n75), .Z(add_7_n17) );
  INV_X1 add_7_U26 ( .A(b[5]), .ZN(add_7_n16) );
  AND2_X1 add_7_U25 ( .A1(add_7_n76), .A2(add_7_n25), .ZN(add_7_n15) );
  INV_X1 add_7_U24 ( .A(a[3]), .ZN(add_7_n14) );
  INV_X1 add_7_U23 ( .A(b[3]), .ZN(add_7_n13) );
  NAND2_X1 add_7_U22 ( .A1(add_7_n13), .A2(add_7_n14), .ZN(add_7_n76) );
  OAI22_X1 add_7_U21 ( .A1(b[2]), .A2(a[2]), .B1(b[3]), .B2(a[3]), .ZN(
        add_7_n65) );
  INV_X1 add_7_U20 ( .A(add_7_n12), .ZN(add_7_n55) );
  OAI22_X1 add_7_U19 ( .A1(b[7]), .A2(a[7]), .B1(b[6]), .B2(a[6]), .ZN(
        add_7_n12) );
  INV_X1 add_7_U18 ( .A(add_7_n11), .ZN(add_7_n53) );
  OAI211_X1 add_7_U17 ( .C1(b[3]), .C2(a[3]), .A(b[2]), .B(a[2]), .ZN(
        add_7_n11) );
  AOI22_X1 add_7_U16 ( .A1(add_7_n110), .A2(add_7_n111), .B1(add_7_n7), .B2(
        add_7_n1), .ZN(add_7_n30) );
  NAND2_X1 add_7_U15 ( .A1(add_7_n86), .A2(add_7_n87), .ZN(add_7_n10) );
  NOR2_X1 add_7_U14 ( .A1(b[6]), .A2(a[6]), .ZN(add_7_n26) );
  BUF_X1 add_7_U13 ( .A(add_7_n34), .Z(add_7_n9) );
  INV_X1 add_7_U12 ( .A(a[7]), .ZN(add_7_n8) );
  INV_X1 add_7_U11 ( .A(add_7_n13), .ZN(add_7_n7) );
  INV_X1 add_7_U10 ( .A(b[7]), .ZN(add_7_n6) );
  NAND2_X1 add_7_U9 ( .A1(add_7_n57), .A2(add_7_n76), .ZN(add_7_n5) );
  XNOR2_X1 add_7_U8 ( .A(add_7_n114), .B(add_7_n5), .ZN(sum[3]) );
  AND2_X1 add_7_U7 ( .A1(add_7_n117), .A2(add_7_n61), .ZN(add_7_n4) );
  AND2_X1 add_7_U6 ( .A1(add_7_n98), .A2(add_7_n22), .ZN(add_7_n3) );
  AND2_X1 add_7_U5 ( .A1(add_7_n27), .A2(add_7_n99), .ZN(add_7_n2) );
  XNOR2_X1 add_7_U4 ( .A(add_7_n2), .B(add_7_n3), .ZN(sum[4]) );
  INV_X1 add_7_U3 ( .A(add_7_n14), .ZN(add_7_n1) );
  NOR2_X1 add_7_U2 ( .A1(b[4]), .A2(a[4]), .ZN(add_7_n34) );
endmodule

