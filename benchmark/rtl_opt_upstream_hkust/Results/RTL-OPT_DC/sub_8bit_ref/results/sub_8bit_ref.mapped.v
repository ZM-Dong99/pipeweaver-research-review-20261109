/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 02:42:10 2025
/////////////////////////////////////////////////////////////


module sub_8bit_ref ( a, b, diff, overflow );
  input [7:0] a;
  input [7:0] b;
  output [7:0] diff;
  output overflow;
  wire   extended_diff_8_, sub_8_n118, sub_8_n117, sub_8_n116, sub_8_n115,
         sub_8_n114, sub_8_n113, sub_8_n112, sub_8_n111, sub_8_n110,
         sub_8_n109, sub_8_n108, sub_8_n107, sub_8_n106, sub_8_n105,
         sub_8_n104, sub_8_n103, sub_8_n102, sub_8_n101, sub_8_n100, sub_8_n99,
         sub_8_n98, sub_8_n97, sub_8_n96, sub_8_n95, sub_8_n94, sub_8_n93,
         sub_8_n92, sub_8_n91, sub_8_n90, sub_8_n89, sub_8_n88, sub_8_n87,
         sub_8_n86, sub_8_n85, sub_8_n84, sub_8_n83, sub_8_n82, sub_8_n81,
         sub_8_n80, sub_8_n79, sub_8_n78, sub_8_n77, sub_8_n76, sub_8_n75,
         sub_8_n74, sub_8_n73, sub_8_n72, sub_8_n71, sub_8_n70, sub_8_n69,
         sub_8_n68, sub_8_n67, sub_8_n66, sub_8_n65, sub_8_n64, sub_8_n63,
         sub_8_n62, sub_8_n61, sub_8_n60, sub_8_n59, sub_8_n58, sub_8_n57,
         sub_8_n56, sub_8_n55, sub_8_n54, sub_8_n53, sub_8_n52, sub_8_n51,
         sub_8_n50, sub_8_n49, sub_8_n48, sub_8_n47, sub_8_n46, sub_8_n45,
         sub_8_n44, sub_8_n43, sub_8_n42, sub_8_n41, sub_8_n40, sub_8_n39,
         sub_8_n38, sub_8_n37, sub_8_n36, sub_8_n35, sub_8_n34, sub_8_n33,
         sub_8_n32, sub_8_n31, sub_8_n30, sub_8_n29, sub_8_n28, sub_8_n27,
         sub_8_n26, sub_8_n25, sub_8_n24, sub_8_n23, sub_8_n22, sub_8_n21,
         sub_8_n20, sub_8_n19, sub_8_n18, sub_8_n17, sub_8_n16, sub_8_n15,
         sub_8_n14, sub_8_n13, sub_8_n12, sub_8_n11, sub_8_n10, sub_8_n9,
         sub_8_n8, sub_8_n7, sub_8_n6, sub_8_n5, sub_8_n4, sub_8_n3, sub_8_n2,
         sub_8_n1;

  XOR2_X1 U4 ( .A(extended_diff_8_), .B(diff[7]), .Z(overflow) );
  INV_X1 sub_8_U129 ( .A(sub_8_n111), .ZN(sub_8_n109) );
  INV_X1 sub_8_U128 ( .A(sub_8_n40), .ZN(sub_8_n110) );
  OAI21_X1 sub_8_U127 ( .B1(sub_8_n109), .B2(sub_8_n110), .A(sub_8_n101), .ZN(
        sub_8_n106) );
  XNOR2_X1 sub_8_U126 ( .A(sub_8_n106), .B(sub_8_n107), .ZN(diff[3]) );
  INV_X1 sub_8_U125 ( .A(sub_8_n65), .ZN(sub_8_n92) );
  INV_X1 sub_8_U124 ( .A(sub_8_n64), .ZN(sub_8_n90) );
  NOR2_X1 sub_8_U123 ( .A1(sub_8_n90), .A2(sub_8_n34), .ZN(sub_8_n89) );
  NAND3_X1 sub_8_U122 ( .A1(sub_8_n80), .A2(sub_8_n40), .A3(sub_8_n79), .ZN(
        sub_8_n77) );
  INV_X1 sub_8_U121 ( .A(sub_8_n76), .ZN(sub_8_n55) );
  XNOR2_X1 sub_8_U120 ( .A(sub_8_n69), .B(sub_8_n43), .ZN(diff[7]) );
  NAND3_X1 sub_8_U119 ( .A1(sub_8_n35), .A2(sub_8_n58), .A3(sub_8_n59), .ZN(
        sub_8_n54) );
  INV_X1 sub_8_U118 ( .A(sub_8_n54), .ZN(sub_8_n50) );
  NAND3_X1 sub_8_U117 ( .A1(sub_8_n50), .A2(sub_8_n36), .A3(sub_8_n49), .ZN(
        sub_8_n53) );
  MUX2_X1 sub_8_U116 ( .A(sub_8_n43), .B(sub_8_n44), .S(sub_8_n45), .Z(
        extended_diff_8_) );
  NAND2_X1 sub_8_U115 ( .A1(sub_8_n29), .A2(sub_8_n41), .ZN(sub_8_n79) );
  NAND2_X1 sub_8_U114 ( .A1(sub_8_n116), .A2(sub_8_n41), .ZN(sub_8_n114) );
  NOR2_X1 sub_8_U113 ( .A1(sub_8_n46), .A2(sub_8_n47), .ZN(sub_8_n45) );
  NAND2_X1 sub_8_U112 ( .A1(sub_8_n41), .A2(sub_8_n7), .ZN(diff[0]) );
  OAI21_X1 sub_8_U111 ( .B1(sub_8_n72), .B2(sub_8_n73), .A(sub_8_n74), .ZN(
        sub_8_n69) );
  INV_X1 sub_8_U110 ( .A(b[1]), .ZN(sub_8_n115) );
  AND2_X1 sub_8_U109 ( .A1(sub_8_n31), .A2(sub_8_n76), .ZN(sub_8_n96) );
  NAND2_X1 sub_8_U108 ( .A1(sub_8_n113), .A2(sub_8_n38), .ZN(sub_8_n111) );
  AOI21_X1 sub_8_U107 ( .B1(sub_8_n75), .B2(sub_8_n57), .A(sub_8_n62), .ZN(
        sub_8_n74) );
  NAND2_X1 sub_8_U106 ( .A1(sub_8_n21), .A2(sub_8_n57), .ZN(sub_8_n73) );
  NAND2_X1 sub_8_U105 ( .A1(b[2]), .A2(sub_8_n2), .ZN(sub_8_n98) );
  INV_X1 sub_8_U104 ( .A(b[0]), .ZN(sub_8_n118) );
  OAI211_X1 sub_8_U103 ( .C1(sub_8_n51), .C2(sub_8_n33), .A(sub_8_n52), .B(
        sub_8_n53), .ZN(sub_8_n46) );
  NAND2_X1 sub_8_U102 ( .A1(sub_8_n96), .A2(sub_8_n95), .ZN(sub_8_n87) );
  AOI21_X1 sub_8_U101 ( .B1(sub_8_n87), .B2(sub_8_n21), .A(sub_8_n75), .ZN(
        sub_8_n84) );
  INV_X1 sub_8_U100 ( .A(a[3]), .ZN(sub_8_n108) );
  NAND2_X1 sub_8_U99 ( .A1(b[1]), .A2(sub_8_n100), .ZN(sub_8_n81) );
  OR2_X1 sub_8_U98 ( .A1(sub_8_n28), .A2(a[3]), .ZN(sub_8_n42) );
  AND2_X1 sub_8_U97 ( .A1(sub_8_n42), .A2(sub_8_n81), .ZN(sub_8_n80) );
  NAND2_X1 sub_8_U96 ( .A1(sub_8_n27), .A2(b[7]), .ZN(sub_8_n58) );
  NAND2_X1 sub_8_U95 ( .A1(b[7]), .A2(sub_8_n68), .ZN(sub_8_n44) );
  INV_X1 sub_8_U94 ( .A(b[2]), .ZN(sub_8_n112) );
  NAND2_X1 sub_8_U93 ( .A1(a[2]), .A2(sub_8_n112), .ZN(sub_8_n101) );
  NAND2_X1 sub_8_U92 ( .A1(a[0]), .A2(sub_8_n118), .ZN(sub_8_n41) );
  INV_X1 sub_8_U91 ( .A(a[2]), .ZN(sub_8_n82) );
  NAND2_X1 sub_8_U90 ( .A1(b[2]), .A2(sub_8_n82), .ZN(sub_8_n40) );
  NAND2_X1 sub_8_U89 ( .A1(b[2]), .A2(sub_8_n82), .ZN(sub_8_n39) );
  NAND2_X1 sub_8_U88 ( .A1(b[5]), .A2(sub_8_n23), .ZN(sub_8_n59) );
  AND2_X1 sub_8_U87 ( .A1(a[2]), .A2(sub_8_n112), .ZN(sub_8_n37) );
  NOR2_X1 sub_8_U86 ( .A1(sub_8_n66), .A2(sub_8_n26), .ZN(sub_8_n60) );
  AOI21_X1 sub_8_U85 ( .B1(sub_8_n60), .B2(sub_8_n61), .A(sub_8_n62), .ZN(
        sub_8_n51) );
  INV_X1 sub_8_U84 ( .A(a[6]), .ZN(sub_8_n86) );
  NAND2_X1 sub_8_U83 ( .A1(b[6]), .A2(sub_8_n24), .ZN(sub_8_n57) );
  NAND2_X1 sub_8_U82 ( .A1(b[3]), .A2(sub_8_n108), .ZN(sub_8_n99) );
  NAND2_X1 sub_8_U81 ( .A1(sub_8_n76), .A2(sub_8_n25), .ZN(sub_8_n107) );
  NAND2_X1 sub_8_U80 ( .A1(sub_8_n99), .A2(sub_8_n37), .ZN(sub_8_n78) );
  AND2_X1 sub_8_U79 ( .A1(sub_8_n81), .A2(sub_8_n104), .ZN(sub_8_n102) );
  AND4_X1 sub_8_U78 ( .A1(sub_8_n97), .A2(sub_8_n105), .A3(sub_8_n98), .A4(
        sub_8_n99), .ZN(sub_8_n36) );
  NAND2_X1 sub_8_U77 ( .A1(sub_8_n86), .A2(b[6]), .ZN(sub_8_n35) );
  INV_X1 sub_8_U76 ( .A(a[5]), .ZN(sub_8_n91) );
  INV_X1 sub_8_U75 ( .A(a[7]), .ZN(sub_8_n68) );
  AND2_X1 sub_8_U74 ( .A1(b[7]), .A2(sub_8_n68), .ZN(sub_8_n33) );
  NAND4_X1 sub_8_U73 ( .A1(sub_8_n25), .A2(sub_8_n105), .A3(sub_8_n39), .A4(
        sub_8_n6), .ZN(sub_8_n31) );
  AND2_X2 sub_8_U72 ( .A1(b[5]), .A2(sub_8_n91), .ZN(sub_8_n34) );
  INV_X1 sub_8_U71 ( .A(sub_8_n34), .ZN(sub_8_n30) );
  NAND2_X1 sub_8_U70 ( .A1(a[1]), .A2(sub_8_n115), .ZN(sub_8_n29) );
  NAND2_X1 sub_8_U69 ( .A1(sub_8_n64), .A2(sub_8_n65), .ZN(sub_8_n61) );
  INV_X1 sub_8_U68 ( .A(b[3]), .ZN(sub_8_n28) );
  INV_X1 sub_8_U67 ( .A(a[7]), .ZN(sub_8_n27) );
  AND2_X1 sub_8_U66 ( .A1(b[6]), .A2(sub_8_n24), .ZN(sub_8_n26) );
  INV_X1 sub_8_U65 ( .A(sub_8_n32), .ZN(sub_8_n25) );
  INV_X1 sub_8_U64 ( .A(a[1]), .ZN(sub_8_n100) );
  INV_X1 sub_8_U63 ( .A(a[6]), .ZN(sub_8_n24) );
  INV_X1 sub_8_U62 ( .A(a[5]), .ZN(sub_8_n23) );
  INV_X1 sub_8_U61 ( .A(sub_8_n63), .ZN(sub_8_n62) );
  INV_X1 sub_8_U60 ( .A(b[7]), .ZN(sub_8_n71) );
  NAND2_X1 sub_8_U59 ( .A1(sub_8_n9), .A2(sub_8_n71), .ZN(sub_8_n70) );
  NAND2_X1 sub_8_U58 ( .A1(sub_8_n44), .A2(sub_8_n70), .ZN(sub_8_n43) );
  INV_X1 sub_8_U57 ( .A(a[4]), .ZN(sub_8_n93) );
  NOR2_X1 sub_8_U56 ( .A1(a[5]), .A2(sub_8_n67), .ZN(sub_8_n66) );
  INV_X1 sub_8_U55 ( .A(b[6]), .ZN(sub_8_n85) );
  NAND2_X1 sub_8_U54 ( .A1(a[6]), .A2(sub_8_n85), .ZN(sub_8_n63) );
  INV_X1 sub_8_U53 ( .A(b[4]), .ZN(sub_8_n94) );
  NAND2_X1 sub_8_U52 ( .A1(a[4]), .A2(sub_8_n94), .ZN(sub_8_n65) );
  INV_X1 sub_8_U51 ( .A(b[5]), .ZN(sub_8_n67) );
  NAND2_X1 sub_8_U50 ( .A1(a[5]), .A2(sub_8_n67), .ZN(sub_8_n64) );
  INV_X1 sub_8_U49 ( .A(a[0]), .ZN(sub_8_n117) );
  AND2_X1 sub_8_U48 ( .A1(sub_8_n12), .A2(sub_8_n83), .ZN(sub_8_n22) );
  XOR2_X1 sub_8_U47 ( .A(sub_8_n114), .B(sub_8_n22), .Z(diff[1]) );
  OAI21_X1 sub_8_U46 ( .B1(sub_8_n34), .B2(sub_8_n65), .A(sub_8_n64), .ZN(
        sub_8_n75) );
  NAND2_X1 sub_8_U45 ( .A1(sub_8_n12), .A2(sub_8_n114), .ZN(sub_8_n113) );
  INV_X1 sub_8_U44 ( .A(sub_8_n7), .ZN(sub_8_n116) );
  AND2_X1 sub_8_U43 ( .A1(sub_8_n49), .A2(sub_8_n30), .ZN(sub_8_n21) );
  AOI21_X1 sub_8_U42 ( .B1(sub_8_n1), .B2(sub_8_n49), .A(sub_8_n92), .ZN(
        sub_8_n88) );
  XNOR2_X1 sub_8_U41 ( .A(sub_8_n88), .B(sub_8_n89), .ZN(diff[5]) );
  INV_X1 sub_8_U40 ( .A(sub_8_n32), .ZN(sub_8_n103) );
  AND2_X1 sub_8_U39 ( .A1(sub_8_n101), .A2(sub_8_n39), .ZN(sub_8_n20) );
  XOR2_X1 sub_8_U38 ( .A(sub_8_n111), .B(sub_8_n20), .Z(diff[2]) );
  AND2_X1 sub_8_U37 ( .A1(sub_8_n65), .A2(sub_8_n49), .ZN(sub_8_n19) );
  XOR2_X1 sub_8_U36 ( .A(sub_8_n87), .B(sub_8_n19), .Z(diff[4]) );
  AND4_X1 sub_8_U35 ( .A1(sub_8_n10), .A2(sub_8_n76), .A3(sub_8_n78), .A4(
        sub_8_n77), .ZN(sub_8_n72) );
  INV_X1 sub_8_U34 ( .A(sub_8_n49), .ZN(sub_8_n18) );
  AOI211_X1 sub_8_U33 ( .C1(sub_8_n78), .C2(sub_8_n10), .A(sub_8_n18), .B(
        sub_8_n11), .ZN(sub_8_n47) );
  NAND2_X1 sub_8_U32 ( .A1(sub_8_n115), .A2(a[1]), .ZN(sub_8_n83) );
  NAND3_X1 sub_8_U31 ( .A1(sub_8_n103), .A2(sub_8_n102), .A3(sub_8_n39), .ZN(
        sub_8_n48) );
  INV_X1 sub_8_U30 ( .A(a[0]), .ZN(sub_8_n17) );
  INV_X1 sub_8_U29 ( .A(a[1]), .ZN(sub_8_n16) );
  OAI22_X1 sub_8_U28 ( .A1(sub_8_n4), .A2(b[1]), .B1(sub_8_n17), .B2(b[0]), 
        .ZN(sub_8_n97) );
  NAND3_X1 sub_8_U27 ( .A1(sub_8_n56), .A2(sub_8_n55), .A3(sub_8_n49), .ZN(
        sub_8_n52) );
  INV_X1 sub_8_U26 ( .A(a[3]), .ZN(sub_8_n15) );
  OR2_X2 sub_8_U25 ( .A1(b[3]), .A2(sub_8_n15), .ZN(sub_8_n76) );
  INV_X1 sub_8_U24 ( .A(sub_8_n14), .ZN(sub_8_n56) );
  INV_X1 sub_8_U23 ( .A(b[5]), .ZN(sub_8_n13) );
  OAI211_X1 sub_8_U22 ( .C1(a[5]), .C2(sub_8_n13), .A(sub_8_n35), .B(sub_8_n58), .ZN(sub_8_n14) );
  NAND2_X1 sub_8_U21 ( .A1(sub_8_n117), .A2(b[0]), .ZN(sub_8_n104) );
  NAND2_X1 sub_8_U20 ( .A1(sub_8_n16), .A2(b[1]), .ZN(sub_8_n105) );
  CLKBUF_X1 sub_8_U19 ( .A(sub_8_n105), .Z(sub_8_n12) );
  BUF_X1 sub_8_U18 ( .A(sub_8_n54), .Z(sub_8_n11) );
  NAND3_X1 sub_8_U17 ( .A1(sub_8_n103), .A2(sub_8_n102), .A3(sub_8_n39), .ZN(
        sub_8_n10) );
  INV_X1 sub_8_U16 ( .A(sub_8_n68), .ZN(sub_8_n9) );
  AND2_X1 sub_8_U15 ( .A1(sub_8_n57), .A2(sub_8_n63), .ZN(sub_8_n8) );
  XNOR2_X1 sub_8_U14 ( .A(sub_8_n84), .B(sub_8_n8), .ZN(diff[6]) );
  AND2_X1 sub_8_U13 ( .A1(sub_8_n48), .A2(sub_8_n78), .ZN(sub_8_n95) );
  NAND2_X1 sub_8_U12 ( .A1(sub_8_n117), .A2(b[0]), .ZN(sub_8_n7) );
  OAI22_X1 sub_8_U11 ( .A1(sub_8_n5), .A2(b[1]), .B1(sub_8_n17), .B2(b[0]), 
        .ZN(sub_8_n6) );
  INV_X1 sub_8_U10 ( .A(a[1]), .ZN(sub_8_n5) );
  INV_X1 sub_8_U9 ( .A(a[1]), .ZN(sub_8_n4) );
  INV_X1 sub_8_U8 ( .A(a[3]), .ZN(sub_8_n3) );
  BUF_X1 sub_8_U7 ( .A(sub_8_n83), .Z(sub_8_n38) );
  NAND2_X1 sub_8_U6 ( .A1(b[4]), .A2(sub_8_n93), .ZN(sub_8_n49) );
  INV_X1 sub_8_U5 ( .A(a[2]), .ZN(sub_8_n2) );
  NAND2_X1 sub_8_U4 ( .A1(sub_8_n96), .A2(sub_8_n95), .ZN(sub_8_n1) );
  AND2_X2 sub_8_U3 ( .A1(b[3]), .A2(sub_8_n3), .ZN(sub_8_n32) );
endmodule

