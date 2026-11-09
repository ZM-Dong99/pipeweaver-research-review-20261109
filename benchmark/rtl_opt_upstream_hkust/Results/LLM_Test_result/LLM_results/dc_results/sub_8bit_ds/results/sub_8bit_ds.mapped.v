/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:07:38 2025
/////////////////////////////////////////////////////////////


module sub_8bit_ds ( a, b, diff, overflow );
  input [7:0] a;
  input [7:0] b;
  output [7:0] diff;
  output overflow;
  wire   n5, n6, sub_7_n109, sub_7_n108, sub_7_n107, sub_7_n106, sub_7_n105,
         sub_7_n104, sub_7_n103, sub_7_n102, sub_7_n101, sub_7_n100, sub_7_n99,
         sub_7_n98, sub_7_n97, sub_7_n96, sub_7_n95, sub_7_n94, sub_7_n93,
         sub_7_n92, sub_7_n91, sub_7_n90, sub_7_n89, sub_7_n88, sub_7_n87,
         sub_7_n86, sub_7_n85, sub_7_n84, sub_7_n83, sub_7_n82, sub_7_n81,
         sub_7_n80, sub_7_n79, sub_7_n78, sub_7_n77, sub_7_n76, sub_7_n75,
         sub_7_n74, sub_7_n73, sub_7_n72, sub_7_n71, sub_7_n70, sub_7_n69,
         sub_7_n68, sub_7_n67, sub_7_n66, sub_7_n65, sub_7_n64, sub_7_n63,
         sub_7_n62, sub_7_n61, sub_7_n60, sub_7_n59, sub_7_n58, sub_7_n57,
         sub_7_n56, sub_7_n55, sub_7_n54, sub_7_n53, sub_7_n52, sub_7_n51,
         sub_7_n50, sub_7_n49, sub_7_n48, sub_7_n47, sub_7_n46, sub_7_n45,
         sub_7_n44, sub_7_n43, sub_7_n42, sub_7_n41, sub_7_n40, sub_7_n39,
         sub_7_n38, sub_7_n37, sub_7_n36, sub_7_n35, sub_7_n34, sub_7_n33,
         sub_7_n32, sub_7_n31, sub_7_n30, sub_7_n29, sub_7_n28, sub_7_n27,
         sub_7_n26, sub_7_n25, sub_7_n24, sub_7_n23, sub_7_n22, sub_7_n21,
         sub_7_n20, sub_7_n19, sub_7_n18, sub_7_n17, sub_7_n16, sub_7_n15,
         sub_7_n14, sub_7_n13, sub_7_n12, sub_7_n11, sub_7_n10, sub_7_n9,
         sub_7_n8, sub_7_n7, sub_7_n6, sub_7_n5, sub_7_n4, sub_7_n3, sub_7_n2,
         sub_7_n1;

  XNOR2_X1 U6 ( .A(a[7]), .B(b[7]), .ZN(n5) );
  NOR2_X1 U7 ( .A1(n6), .A2(n5), .ZN(overflow) );
  XNOR2_X1 U8 ( .A(diff[7]), .B(a[7]), .ZN(n6) );
  INV_X1 sub_7_U119 ( .A(sub_7_n103), .ZN(sub_7_n101) );
  INV_X1 sub_7_U118 ( .A(sub_7_n24), .ZN(sub_7_n92) );
  OAI21_X1 sub_7_U117 ( .B1(sub_7_n101), .B2(sub_7_n92), .A(sub_7_n25), .ZN(
        sub_7_n98) );
  XNOR2_X1 sub_7_U116 ( .A(sub_7_n98), .B(sub_7_n99), .ZN(diff[3]) );
  NAND3_X1 sub_7_U115 ( .A1(sub_7_n28), .A2(sub_7_n96), .A3(sub_7_n97), .ZN(
        sub_7_n95) );
  INV_X1 sub_7_U114 ( .A(sub_7_n71), .ZN(sub_7_n91) );
  INV_X1 sub_7_U113 ( .A(sub_7_n29), .ZN(sub_7_n75) );
  NAND2_X1 sub_7_U112 ( .A1(sub_7_n58), .A2(sub_7_n59), .ZN(sub_7_n41) );
  INV_X1 sub_7_U111 ( .A(sub_7_n57), .ZN(sub_7_n56) );
  NAND3_X1 sub_7_U110 ( .A1(sub_7_n46), .A2(sub_7_n45), .A3(sub_7_n44), .ZN(
        sub_7_n43) );
  NAND4_X1 sub_7_U109 ( .A1(sub_7_n40), .A2(sub_7_n41), .A3(sub_7_n43), .A4(
        sub_7_n42), .ZN(sub_7_n39) );
  XNOR2_X1 sub_7_U108 ( .A(sub_7_n39), .B(sub_7_n22), .ZN(diff[7]) );
  NOR3_X1 sub_7_U107 ( .A1(sub_7_n69), .A2(sub_7_n102), .A3(sub_7_n38), .ZN(
        sub_7_n68) );
  NOR2_X1 sub_7_U106 ( .A1(sub_7_n68), .A2(sub_7_n67), .ZN(sub_7_n40) );
  NAND2_X1 sub_7_U105 ( .A1(sub_7_n77), .A2(sub_7_n45), .ZN(sub_7_n76) );
  NAND2_X1 sub_7_U104 ( .A1(sub_7_n77), .A2(sub_7_n30), .ZN(sub_7_n83) );
  NAND2_X1 sub_7_U103 ( .A1(sub_7_n71), .A2(sub_7_n70), .ZN(sub_7_n99) );
  XNOR2_X1 sub_7_U102 ( .A(sub_7_n77), .B(sub_7_n85), .ZN(diff[4]) );
  NOR3_X1 sub_7_U101 ( .A1(sub_7_n62), .A2(sub_7_n71), .A3(sub_7_n23), .ZN(
        sub_7_n67) );
  NOR2_X1 sub_7_U100 ( .A1(sub_7_n2), .A2(sub_7_n102), .ZN(sub_7_n94) );
  NOR2_X1 sub_7_U99 ( .A1(sub_7_n93), .A2(sub_7_n94), .ZN(sub_7_n87) );
  NAND2_X1 sub_7_U98 ( .A1(sub_7_n87), .A2(sub_7_n88), .ZN(sub_7_n77) );
  AOI21_X1 sub_7_U97 ( .B1(sub_7_n55), .B2(sub_7_n33), .A(sub_7_n56), .ZN(
        sub_7_n42) );
  NOR2_X1 sub_7_U96 ( .A1(sub_7_n63), .A2(sub_7_n11), .ZN(sub_7_n58) );
  NAND2_X1 sub_7_U95 ( .A1(sub_7_n78), .A2(sub_7_n79), .ZN(sub_7_n55) );
  AOI21_X1 sub_7_U94 ( .B1(sub_7_n89), .B2(sub_7_n90), .A(sub_7_n91), .ZN(
        sub_7_n88) );
  INV_X1 sub_7_U93 ( .A(a[1]), .ZN(sub_7_n66) );
  INV_X1 sub_7_U92 ( .A(a[1]), .ZN(sub_7_n37) );
  INV_X1 sub_7_U91 ( .A(a[1]), .ZN(sub_7_n36) );
  INV_X1 sub_7_U90 ( .A(a[3]), .ZN(sub_7_n50) );
  INV_X1 sub_7_U89 ( .A(a[3]), .ZN(sub_7_n35) );
  INV_X1 sub_7_U88 ( .A(a[3]), .ZN(sub_7_n34) );
  INV_X1 sub_7_U87 ( .A(a[6]), .ZN(sub_7_n73) );
  NAND2_X1 sub_7_U86 ( .A1(b[6]), .A2(sub_7_n26), .ZN(sub_7_n33) );
  NAND2_X1 sub_7_U85 ( .A1(b[6]), .A2(sub_7_n73), .ZN(sub_7_n32) );
  INV_X1 sub_7_U84 ( .A(a[4]), .ZN(sub_7_n86) );
  NAND2_X1 sub_7_U83 ( .A1(sub_7_n8), .A2(sub_7_n16), .ZN(sub_7_n31) );
  NAND2_X1 sub_7_U82 ( .A1(sub_7_n28), .A2(sub_7_n7), .ZN(diff[0]) );
  NAND2_X1 sub_7_U81 ( .A1(b[4]), .A2(sub_7_n86), .ZN(sub_7_n30) );
  NAND2_X1 sub_7_U80 ( .A1(sub_7_n76), .A2(sub_7_n75), .ZN(sub_7_n72) );
  NAND2_X1 sub_7_U79 ( .A1(sub_7_n61), .A2(sub_7_n33), .ZN(sub_7_n60) );
  NOR2_X1 sub_7_U78 ( .A1(sub_7_n95), .A2(sub_7_n2), .ZN(sub_7_n93) );
  NAND2_X1 sub_7_U77 ( .A1(b[2]), .A2(sub_7_n9), .ZN(sub_7_n97) );
  NAND2_X1 sub_7_U76 ( .A1(sub_7_n25), .A2(sub_7_n24), .ZN(sub_7_n104) );
  NAND2_X1 sub_7_U75 ( .A1(sub_7_n48), .A2(sub_7_n49), .ZN(sub_7_n47) );
  NOR2_X1 sub_7_U74 ( .A1(sub_7_n23), .A2(sub_7_n47), .ZN(sub_7_n46) );
  CLKBUF_X1 sub_7_U73 ( .A(sub_7_n55), .Z(sub_7_n29) );
  NAND2_X1 sub_7_U72 ( .A1(sub_7_n97), .A2(sub_7_n64), .ZN(sub_7_n63) );
  INV_X1 sub_7_U71 ( .A(a[0]), .ZN(sub_7_n108) );
  NAND2_X1 sub_7_U70 ( .A1(sub_7_n108), .A2(b[0]), .ZN(sub_7_n28) );
  INV_X1 sub_7_U69 ( .A(a[6]), .ZN(sub_7_n27) );
  INV_X1 sub_7_U68 ( .A(a[6]), .ZN(sub_7_n26) );
  NAND2_X1 sub_7_U67 ( .A1(a[2]), .A2(sub_7_n54), .ZN(sub_7_n102) );
  NAND2_X1 sub_7_U66 ( .A1(sub_7_n34), .A2(b[3]), .ZN(sub_7_n70) );
  NAND2_X1 sub_7_U65 ( .A1(a[0]), .A2(sub_7_n109), .ZN(sub_7_n52) );
  NAND2_X1 sub_7_U64 ( .A1(sub_7_n52), .A2(sub_7_n1), .ZN(sub_7_n106) );
  AOI21_X1 sub_7_U63 ( .B1(sub_7_n51), .B2(sub_7_n7), .A(sub_7_n10), .ZN(
        sub_7_n89) );
  AOI21_X1 sub_7_U62 ( .B1(sub_7_n51), .B2(sub_7_n52), .A(sub_7_n53), .ZN(
        sub_7_n44) );
  NAND2_X1 sub_7_U61 ( .A1(sub_7_n83), .A2(sub_7_n84), .ZN(sub_7_n81) );
  NOR2_X1 sub_7_U60 ( .A1(sub_7_n3), .A2(sub_7_n60), .ZN(sub_7_n59) );
  INV_X1 sub_7_U59 ( .A(a[2]), .ZN(sub_7_n65) );
  NAND2_X1 sub_7_U58 ( .A1(b[2]), .A2(sub_7_n65), .ZN(sub_7_n24) );
  NAND2_X1 sub_7_U57 ( .A1(a[5]), .A2(sub_7_n19), .ZN(sub_7_n79) );
  OR2_X1 sub_7_U56 ( .A1(sub_7_n86), .A2(b[4]), .ZN(sub_7_n84) );
  INV_X1 sub_7_U55 ( .A(b[5]), .ZN(sub_7_n82) );
  NAND2_X1 sub_7_U54 ( .A1(b[3]), .A2(sub_7_n35), .ZN(sub_7_n61) );
  AND2_X1 sub_7_U53 ( .A1(b[6]), .A2(sub_7_n27), .ZN(sub_7_n23) );
  NAND2_X1 sub_7_U52 ( .A1(b[1]), .A2(sub_7_n37), .ZN(sub_7_n64) );
  NAND2_X1 sub_7_U51 ( .A1(sub_7_n36), .A2(b[1]), .ZN(sub_7_n96) );
  INV_X1 sub_7_U50 ( .A(b[0]), .ZN(sub_7_n109) );
  NAND2_X1 sub_7_U49 ( .A1(b[3]), .A2(sub_7_n50), .ZN(sub_7_n49) );
  NOR2_X1 sub_7_U48 ( .A1(a[2]), .A2(sub_7_n54), .ZN(sub_7_n53) );
  INV_X1 sub_7_U47 ( .A(b[2]), .ZN(sub_7_n54) );
  INV_X1 sub_7_U46 ( .A(b[6]), .ZN(sub_7_n74) );
  NAND2_X1 sub_7_U45 ( .A1(a[6]), .A2(sub_7_n74), .ZN(sub_7_n57) );
  NAND2_X1 sub_7_U44 ( .A1(b[1]), .A2(sub_7_n66), .ZN(sub_7_n48) );
  INV_X1 sub_7_U43 ( .A(b[1]), .ZN(sub_7_n107) );
  NAND2_X1 sub_7_U42 ( .A1(a[1]), .A2(sub_7_n107), .ZN(sub_7_n51) );
  INV_X1 sub_7_U41 ( .A(b[3]), .ZN(sub_7_n100) );
  NAND2_X1 sub_7_U40 ( .A1(a[3]), .A2(sub_7_n100), .ZN(sub_7_n71) );
  INV_X1 sub_7_U39 ( .A(b[4]), .ZN(sub_7_n80) );
  XOR2_X1 sub_7_U38 ( .A(b[7]), .B(a[7]), .Z(sub_7_n22) );
  NAND2_X1 sub_7_U37 ( .A1(sub_7_n84), .A2(sub_7_n30), .ZN(sub_7_n85) );
  XNOR2_X1 sub_7_U36 ( .A(sub_7_n103), .B(sub_7_n104), .ZN(diff[2]) );
  NAND2_X1 sub_7_U35 ( .A1(sub_7_n106), .A2(sub_7_n96), .ZN(sub_7_n105) );
  NAND2_X1 sub_7_U34 ( .A1(sub_7_n105), .A2(sub_7_n51), .ZN(sub_7_n103) );
  AND2_X1 sub_7_U33 ( .A1(sub_7_n96), .A2(sub_7_n51), .ZN(sub_7_n21) );
  XOR2_X1 sub_7_U32 ( .A(sub_7_n106), .B(sub_7_n21), .Z(diff[1]) );
  NAND2_X1 sub_7_U31 ( .A1(sub_7_n57), .A2(sub_7_n32), .ZN(sub_7_n20) );
  XNOR2_X1 sub_7_U30 ( .A(sub_7_n72), .B(sub_7_n20), .ZN(diff[6]) );
  INV_X1 sub_7_U29 ( .A(b[5]), .ZN(sub_7_n19) );
  OAI211_X1 sub_7_U28 ( .C1(sub_7_n13), .C2(a[5]), .A(sub_7_n80), .B(a[4]), 
        .ZN(sub_7_n78) );
  INV_X1 sub_7_U27 ( .A(b[4]), .ZN(sub_7_n18) );
  OAI22_X1 sub_7_U26 ( .A1(sub_7_n19), .A2(a[5]), .B1(sub_7_n18), .B2(a[4]), 
        .ZN(sub_7_n62) );
  INV_X1 sub_7_U25 ( .A(a[4]), .ZN(sub_7_n17) );
  INV_X1 sub_7_U24 ( .A(a[5]), .ZN(sub_7_n16) );
  AOI22_X1 sub_7_U23 ( .A1(sub_7_n16), .A2(b[5]), .B1(sub_7_n17), .B2(b[4]), 
        .ZN(sub_7_n45) );
  INV_X1 sub_7_U22 ( .A(b[3]), .ZN(sub_7_n15) );
  INV_X1 sub_7_U21 ( .A(b[6]), .ZN(sub_7_n14) );
  OAI22_X1 sub_7_U20 ( .A1(sub_7_n14), .A2(a[6]), .B1(sub_7_n15), .B2(a[3]), 
        .ZN(sub_7_n69) );
  INV_X1 sub_7_U19 ( .A(b[5]), .ZN(sub_7_n13) );
  INV_X1 sub_7_U18 ( .A(b[4]), .ZN(sub_7_n12) );
  OAI22_X1 sub_7_U17 ( .A1(sub_7_n12), .A2(a[4]), .B1(sub_7_n82), .B2(a[5]), 
        .ZN(sub_7_n38) );
  OAI22_X1 sub_7_U16 ( .A1(sub_7_n12), .A2(a[4]), .B1(sub_7_n19), .B2(a[5]), 
        .ZN(sub_7_n11) );
  AND2_X1 sub_7_U15 ( .A1(b[1]), .A2(sub_7_n37), .ZN(sub_7_n10) );
  CLKBUF_X1 sub_7_U14 ( .A(sub_7_n102), .Z(sub_7_n25) );
  INV_X1 sub_7_U13 ( .A(a[2]), .ZN(sub_7_n9) );
  INV_X1 sub_7_U12 ( .A(sub_7_n82), .ZN(sub_7_n8) );
  NAND2_X1 sub_7_U11 ( .A1(a[0]), .A2(sub_7_n109), .ZN(sub_7_n7) );
  NAND2_X1 sub_7_U10 ( .A1(a[5]), .A2(sub_7_n19), .ZN(sub_7_n6) );
  AND2_X1 sub_7_U9 ( .A1(sub_7_n70), .A2(sub_7_n24), .ZN(sub_7_n90) );
  NAND2_X1 sub_7_U8 ( .A1(sub_7_n6), .A2(sub_7_n31), .ZN(sub_7_n5) );
  XNOR2_X1 sub_7_U7 ( .A(sub_7_n81), .B(sub_7_n5), .ZN(diff[5]) );
  INV_X1 sub_7_U6 ( .A(a[0]), .ZN(sub_7_n4) );
  AND2_X1 sub_7_U5 ( .A1(b[0]), .A2(sub_7_n4), .ZN(sub_7_n3) );
  AND2_X1 sub_7_U4 ( .A1(sub_7_n34), .A2(b[3]), .ZN(sub_7_n2) );
  AND2_X1 sub_7_U3 ( .A1(sub_7_n108), .A2(b[0]), .ZN(sub_7_n1) );
endmodule

