/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:40:20 2025
/////////////////////////////////////////////////////////////


module sub_8bit_dsr ( a, b, diff, overflow );
  input [7:0] a;
  input [7:0] b;
  output [7:0] diff;
  output overflow;
  wire   n3, n4, sub_0_root_sub_1_root_add_7_2_n109,
         sub_0_root_sub_1_root_add_7_2_n108,
         sub_0_root_sub_1_root_add_7_2_n107,
         sub_0_root_sub_1_root_add_7_2_n106,
         sub_0_root_sub_1_root_add_7_2_n105,
         sub_0_root_sub_1_root_add_7_2_n104,
         sub_0_root_sub_1_root_add_7_2_n103,
         sub_0_root_sub_1_root_add_7_2_n102,
         sub_0_root_sub_1_root_add_7_2_n101,
         sub_0_root_sub_1_root_add_7_2_n100, sub_0_root_sub_1_root_add_7_2_n99,
         sub_0_root_sub_1_root_add_7_2_n98, sub_0_root_sub_1_root_add_7_2_n97,
         sub_0_root_sub_1_root_add_7_2_n96, sub_0_root_sub_1_root_add_7_2_n95,
         sub_0_root_sub_1_root_add_7_2_n94, sub_0_root_sub_1_root_add_7_2_n93,
         sub_0_root_sub_1_root_add_7_2_n92, sub_0_root_sub_1_root_add_7_2_n91,
         sub_0_root_sub_1_root_add_7_2_n90, sub_0_root_sub_1_root_add_7_2_n89,
         sub_0_root_sub_1_root_add_7_2_n88, sub_0_root_sub_1_root_add_7_2_n87,
         sub_0_root_sub_1_root_add_7_2_n86, sub_0_root_sub_1_root_add_7_2_n85,
         sub_0_root_sub_1_root_add_7_2_n84, sub_0_root_sub_1_root_add_7_2_n83,
         sub_0_root_sub_1_root_add_7_2_n82, sub_0_root_sub_1_root_add_7_2_n81,
         sub_0_root_sub_1_root_add_7_2_n80, sub_0_root_sub_1_root_add_7_2_n79,
         sub_0_root_sub_1_root_add_7_2_n78, sub_0_root_sub_1_root_add_7_2_n77,
         sub_0_root_sub_1_root_add_7_2_n76, sub_0_root_sub_1_root_add_7_2_n75,
         sub_0_root_sub_1_root_add_7_2_n74, sub_0_root_sub_1_root_add_7_2_n73,
         sub_0_root_sub_1_root_add_7_2_n72, sub_0_root_sub_1_root_add_7_2_n71,
         sub_0_root_sub_1_root_add_7_2_n70, sub_0_root_sub_1_root_add_7_2_n69,
         sub_0_root_sub_1_root_add_7_2_n68, sub_0_root_sub_1_root_add_7_2_n67,
         sub_0_root_sub_1_root_add_7_2_n66, sub_0_root_sub_1_root_add_7_2_n65,
         sub_0_root_sub_1_root_add_7_2_n64, sub_0_root_sub_1_root_add_7_2_n63,
         sub_0_root_sub_1_root_add_7_2_n62, sub_0_root_sub_1_root_add_7_2_n61,
         sub_0_root_sub_1_root_add_7_2_n60, sub_0_root_sub_1_root_add_7_2_n59,
         sub_0_root_sub_1_root_add_7_2_n58, sub_0_root_sub_1_root_add_7_2_n57,
         sub_0_root_sub_1_root_add_7_2_n56, sub_0_root_sub_1_root_add_7_2_n55,
         sub_0_root_sub_1_root_add_7_2_n54, sub_0_root_sub_1_root_add_7_2_n53,
         sub_0_root_sub_1_root_add_7_2_n52, sub_0_root_sub_1_root_add_7_2_n51,
         sub_0_root_sub_1_root_add_7_2_n50, sub_0_root_sub_1_root_add_7_2_n49,
         sub_0_root_sub_1_root_add_7_2_n48, sub_0_root_sub_1_root_add_7_2_n47,
         sub_0_root_sub_1_root_add_7_2_n46, sub_0_root_sub_1_root_add_7_2_n45,
         sub_0_root_sub_1_root_add_7_2_n44, sub_0_root_sub_1_root_add_7_2_n43,
         sub_0_root_sub_1_root_add_7_2_n42, sub_0_root_sub_1_root_add_7_2_n41,
         sub_0_root_sub_1_root_add_7_2_n40, sub_0_root_sub_1_root_add_7_2_n39,
         sub_0_root_sub_1_root_add_7_2_n38, sub_0_root_sub_1_root_add_7_2_n37,
         sub_0_root_sub_1_root_add_7_2_n36, sub_0_root_sub_1_root_add_7_2_n35,
         sub_0_root_sub_1_root_add_7_2_n34, sub_0_root_sub_1_root_add_7_2_n33,
         sub_0_root_sub_1_root_add_7_2_n32, sub_0_root_sub_1_root_add_7_2_n31,
         sub_0_root_sub_1_root_add_7_2_n30, sub_0_root_sub_1_root_add_7_2_n29,
         sub_0_root_sub_1_root_add_7_2_n28, sub_0_root_sub_1_root_add_7_2_n27,
         sub_0_root_sub_1_root_add_7_2_n26, sub_0_root_sub_1_root_add_7_2_n25,
         sub_0_root_sub_1_root_add_7_2_n24, sub_0_root_sub_1_root_add_7_2_n23,
         sub_0_root_sub_1_root_add_7_2_n22, sub_0_root_sub_1_root_add_7_2_n21,
         sub_0_root_sub_1_root_add_7_2_n20, sub_0_root_sub_1_root_add_7_2_n19,
         sub_0_root_sub_1_root_add_7_2_n18, sub_0_root_sub_1_root_add_7_2_n17,
         sub_0_root_sub_1_root_add_7_2_n16, sub_0_root_sub_1_root_add_7_2_n15,
         sub_0_root_sub_1_root_add_7_2_n14, sub_0_root_sub_1_root_add_7_2_n13,
         sub_0_root_sub_1_root_add_7_2_n12, sub_0_root_sub_1_root_add_7_2_n11,
         sub_0_root_sub_1_root_add_7_2_n10, sub_0_root_sub_1_root_add_7_2_n9,
         sub_0_root_sub_1_root_add_7_2_n8, sub_0_root_sub_1_root_add_7_2_n7,
         sub_0_root_sub_1_root_add_7_2_n6, sub_0_root_sub_1_root_add_7_2_n5,
         sub_0_root_sub_1_root_add_7_2_n4, sub_0_root_sub_1_root_add_7_2_n3,
         sub_0_root_sub_1_root_add_7_2_n2, sub_0_root_sub_1_root_add_7_2_n1;

  XNOR2_X1 U5 ( .A(a[7]), .B(b[7]), .ZN(n3) );
  NOR2_X1 U6 ( .A1(n4), .A2(n3), .ZN(overflow) );
  XNOR2_X1 U7 ( .A(diff[7]), .B(a[7]), .ZN(n4) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U119 ( .A(
        sub_0_root_sub_1_root_add_7_2_n103), .ZN(
        sub_0_root_sub_1_root_add_7_2_n101) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U118 ( .A(
        sub_0_root_sub_1_root_add_7_2_n24), .ZN(
        sub_0_root_sub_1_root_add_7_2_n92) );
  OAI21_X1 sub_0_root_sub_1_root_add_7_2_U117 ( .B1(
        sub_0_root_sub_1_root_add_7_2_n101), .B2(
        sub_0_root_sub_1_root_add_7_2_n92), .A(
        sub_0_root_sub_1_root_add_7_2_n25), .ZN(
        sub_0_root_sub_1_root_add_7_2_n98) );
  XNOR2_X1 sub_0_root_sub_1_root_add_7_2_U116 ( .A(
        sub_0_root_sub_1_root_add_7_2_n98), .B(
        sub_0_root_sub_1_root_add_7_2_n99), .ZN(diff[3]) );
  NAND3_X1 sub_0_root_sub_1_root_add_7_2_U115 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n28), .A2(
        sub_0_root_sub_1_root_add_7_2_n96), .A3(
        sub_0_root_sub_1_root_add_7_2_n97), .ZN(
        sub_0_root_sub_1_root_add_7_2_n95) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U114 ( .A(
        sub_0_root_sub_1_root_add_7_2_n71), .ZN(
        sub_0_root_sub_1_root_add_7_2_n91) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U113 ( .A(
        sub_0_root_sub_1_root_add_7_2_n29), .ZN(
        sub_0_root_sub_1_root_add_7_2_n75) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U112 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n58), .A2(
        sub_0_root_sub_1_root_add_7_2_n59), .ZN(
        sub_0_root_sub_1_root_add_7_2_n41) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U111 ( .A(
        sub_0_root_sub_1_root_add_7_2_n57), .ZN(
        sub_0_root_sub_1_root_add_7_2_n56) );
  NAND3_X1 sub_0_root_sub_1_root_add_7_2_U110 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n46), .A2(
        sub_0_root_sub_1_root_add_7_2_n45), .A3(
        sub_0_root_sub_1_root_add_7_2_n44), .ZN(
        sub_0_root_sub_1_root_add_7_2_n43) );
  NAND4_X1 sub_0_root_sub_1_root_add_7_2_U109 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n40), .A2(
        sub_0_root_sub_1_root_add_7_2_n41), .A3(
        sub_0_root_sub_1_root_add_7_2_n43), .A4(
        sub_0_root_sub_1_root_add_7_2_n42), .ZN(
        sub_0_root_sub_1_root_add_7_2_n39) );
  XNOR2_X1 sub_0_root_sub_1_root_add_7_2_U108 ( .A(
        sub_0_root_sub_1_root_add_7_2_n39), .B(
        sub_0_root_sub_1_root_add_7_2_n22), .ZN(diff[7]) );
  NOR3_X1 sub_0_root_sub_1_root_add_7_2_U107 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n69), .A2(
        sub_0_root_sub_1_root_add_7_2_n102), .A3(
        sub_0_root_sub_1_root_add_7_2_n38), .ZN(
        sub_0_root_sub_1_root_add_7_2_n68) );
  NOR2_X1 sub_0_root_sub_1_root_add_7_2_U106 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n68), .A2(
        sub_0_root_sub_1_root_add_7_2_n67), .ZN(
        sub_0_root_sub_1_root_add_7_2_n40) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U105 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n77), .A2(
        sub_0_root_sub_1_root_add_7_2_n45), .ZN(
        sub_0_root_sub_1_root_add_7_2_n76) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U104 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n77), .A2(
        sub_0_root_sub_1_root_add_7_2_n30), .ZN(
        sub_0_root_sub_1_root_add_7_2_n83) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U103 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n71), .A2(
        sub_0_root_sub_1_root_add_7_2_n70), .ZN(
        sub_0_root_sub_1_root_add_7_2_n99) );
  XNOR2_X1 sub_0_root_sub_1_root_add_7_2_U102 ( .A(
        sub_0_root_sub_1_root_add_7_2_n77), .B(
        sub_0_root_sub_1_root_add_7_2_n85), .ZN(diff[4]) );
  NOR3_X1 sub_0_root_sub_1_root_add_7_2_U101 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n62), .A2(
        sub_0_root_sub_1_root_add_7_2_n71), .A3(
        sub_0_root_sub_1_root_add_7_2_n23), .ZN(
        sub_0_root_sub_1_root_add_7_2_n67) );
  NOR2_X1 sub_0_root_sub_1_root_add_7_2_U100 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n2), .A2(
        sub_0_root_sub_1_root_add_7_2_n102), .ZN(
        sub_0_root_sub_1_root_add_7_2_n94) );
  NOR2_X1 sub_0_root_sub_1_root_add_7_2_U99 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n93), .A2(
        sub_0_root_sub_1_root_add_7_2_n94), .ZN(
        sub_0_root_sub_1_root_add_7_2_n87) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U98 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n87), .A2(
        sub_0_root_sub_1_root_add_7_2_n88), .ZN(
        sub_0_root_sub_1_root_add_7_2_n77) );
  AOI21_X1 sub_0_root_sub_1_root_add_7_2_U97 ( .B1(
        sub_0_root_sub_1_root_add_7_2_n55), .B2(
        sub_0_root_sub_1_root_add_7_2_n33), .A(
        sub_0_root_sub_1_root_add_7_2_n56), .ZN(
        sub_0_root_sub_1_root_add_7_2_n42) );
  NOR2_X1 sub_0_root_sub_1_root_add_7_2_U96 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n63), .A2(
        sub_0_root_sub_1_root_add_7_2_n11), .ZN(
        sub_0_root_sub_1_root_add_7_2_n58) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U95 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n78), .A2(
        sub_0_root_sub_1_root_add_7_2_n79), .ZN(
        sub_0_root_sub_1_root_add_7_2_n55) );
  AOI21_X1 sub_0_root_sub_1_root_add_7_2_U94 ( .B1(
        sub_0_root_sub_1_root_add_7_2_n89), .B2(
        sub_0_root_sub_1_root_add_7_2_n90), .A(
        sub_0_root_sub_1_root_add_7_2_n91), .ZN(
        sub_0_root_sub_1_root_add_7_2_n88) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U93 ( .A(a[1]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n66) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U92 ( .A(a[1]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n37) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U91 ( .A(a[1]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n36) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U90 ( .A(a[3]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n50) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U89 ( .A(a[3]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n35) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U88 ( .A(a[3]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n34) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U87 ( .A(a[6]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n73) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U86 ( .A1(b[6]), .A2(
        sub_0_root_sub_1_root_add_7_2_n26), .ZN(
        sub_0_root_sub_1_root_add_7_2_n33) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U85 ( .A1(b[6]), .A2(
        sub_0_root_sub_1_root_add_7_2_n73), .ZN(
        sub_0_root_sub_1_root_add_7_2_n32) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U84 ( .A(a[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n86) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U83 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n8), .A2(
        sub_0_root_sub_1_root_add_7_2_n16), .ZN(
        sub_0_root_sub_1_root_add_7_2_n31) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U82 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n28), .A2(
        sub_0_root_sub_1_root_add_7_2_n7), .ZN(diff[0]) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U81 ( .A1(b[4]), .A2(
        sub_0_root_sub_1_root_add_7_2_n86), .ZN(
        sub_0_root_sub_1_root_add_7_2_n30) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U80 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n76), .A2(
        sub_0_root_sub_1_root_add_7_2_n75), .ZN(
        sub_0_root_sub_1_root_add_7_2_n72) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U79 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n61), .A2(
        sub_0_root_sub_1_root_add_7_2_n33), .ZN(
        sub_0_root_sub_1_root_add_7_2_n60) );
  NOR2_X1 sub_0_root_sub_1_root_add_7_2_U78 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n95), .A2(
        sub_0_root_sub_1_root_add_7_2_n2), .ZN(
        sub_0_root_sub_1_root_add_7_2_n93) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U77 ( .A1(b[2]), .A2(
        sub_0_root_sub_1_root_add_7_2_n9), .ZN(
        sub_0_root_sub_1_root_add_7_2_n97) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U76 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n25), .A2(
        sub_0_root_sub_1_root_add_7_2_n24), .ZN(
        sub_0_root_sub_1_root_add_7_2_n104) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U75 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n48), .A2(
        sub_0_root_sub_1_root_add_7_2_n49), .ZN(
        sub_0_root_sub_1_root_add_7_2_n47) );
  NOR2_X1 sub_0_root_sub_1_root_add_7_2_U74 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n23), .A2(
        sub_0_root_sub_1_root_add_7_2_n47), .ZN(
        sub_0_root_sub_1_root_add_7_2_n46) );
  CLKBUF_X1 sub_0_root_sub_1_root_add_7_2_U73 ( .A(
        sub_0_root_sub_1_root_add_7_2_n55), .Z(
        sub_0_root_sub_1_root_add_7_2_n29) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U72 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n97), .A2(
        sub_0_root_sub_1_root_add_7_2_n64), .ZN(
        sub_0_root_sub_1_root_add_7_2_n63) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U71 ( .A(a[0]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n108) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U70 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n108), .A2(b[0]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n28) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U69 ( .A(a[6]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n27) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U68 ( .A(a[6]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n26) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U67 ( .A1(a[2]), .A2(
        sub_0_root_sub_1_root_add_7_2_n54), .ZN(
        sub_0_root_sub_1_root_add_7_2_n102) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U66 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n34), .A2(b[3]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n70) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U65 ( .A1(a[0]), .A2(
        sub_0_root_sub_1_root_add_7_2_n109), .ZN(
        sub_0_root_sub_1_root_add_7_2_n52) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U64 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n52), .A2(
        sub_0_root_sub_1_root_add_7_2_n1), .ZN(
        sub_0_root_sub_1_root_add_7_2_n106) );
  AOI21_X1 sub_0_root_sub_1_root_add_7_2_U63 ( .B1(
        sub_0_root_sub_1_root_add_7_2_n51), .B2(
        sub_0_root_sub_1_root_add_7_2_n7), .A(
        sub_0_root_sub_1_root_add_7_2_n10), .ZN(
        sub_0_root_sub_1_root_add_7_2_n89) );
  AOI21_X1 sub_0_root_sub_1_root_add_7_2_U62 ( .B1(
        sub_0_root_sub_1_root_add_7_2_n51), .B2(
        sub_0_root_sub_1_root_add_7_2_n52), .A(
        sub_0_root_sub_1_root_add_7_2_n53), .ZN(
        sub_0_root_sub_1_root_add_7_2_n44) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U61 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n83), .A2(
        sub_0_root_sub_1_root_add_7_2_n84), .ZN(
        sub_0_root_sub_1_root_add_7_2_n81) );
  NOR2_X1 sub_0_root_sub_1_root_add_7_2_U60 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n3), .A2(
        sub_0_root_sub_1_root_add_7_2_n60), .ZN(
        sub_0_root_sub_1_root_add_7_2_n59) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U59 ( .A(a[2]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n65) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U58 ( .A1(b[2]), .A2(
        sub_0_root_sub_1_root_add_7_2_n65), .ZN(
        sub_0_root_sub_1_root_add_7_2_n24) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U57 ( .A1(a[5]), .A2(
        sub_0_root_sub_1_root_add_7_2_n19), .ZN(
        sub_0_root_sub_1_root_add_7_2_n79) );
  OR2_X1 sub_0_root_sub_1_root_add_7_2_U56 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n86), .A2(b[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n84) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U55 ( .A(b[5]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n82) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U54 ( .A1(b[3]), .A2(
        sub_0_root_sub_1_root_add_7_2_n35), .ZN(
        sub_0_root_sub_1_root_add_7_2_n61) );
  AND2_X1 sub_0_root_sub_1_root_add_7_2_U53 ( .A1(b[6]), .A2(
        sub_0_root_sub_1_root_add_7_2_n27), .ZN(
        sub_0_root_sub_1_root_add_7_2_n23) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U52 ( .A1(b[1]), .A2(
        sub_0_root_sub_1_root_add_7_2_n37), .ZN(
        sub_0_root_sub_1_root_add_7_2_n64) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U51 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n36), .A2(b[1]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n96) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U50 ( .A(b[0]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n109) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U49 ( .A1(b[3]), .A2(
        sub_0_root_sub_1_root_add_7_2_n50), .ZN(
        sub_0_root_sub_1_root_add_7_2_n49) );
  NOR2_X1 sub_0_root_sub_1_root_add_7_2_U48 ( .A1(a[2]), .A2(
        sub_0_root_sub_1_root_add_7_2_n54), .ZN(
        sub_0_root_sub_1_root_add_7_2_n53) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U47 ( .A(b[2]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n54) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U46 ( .A(b[6]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n74) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U45 ( .A1(a[6]), .A2(
        sub_0_root_sub_1_root_add_7_2_n74), .ZN(
        sub_0_root_sub_1_root_add_7_2_n57) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U44 ( .A1(b[1]), .A2(
        sub_0_root_sub_1_root_add_7_2_n66), .ZN(
        sub_0_root_sub_1_root_add_7_2_n48) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U43 ( .A(b[1]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n107) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U42 ( .A1(a[1]), .A2(
        sub_0_root_sub_1_root_add_7_2_n107), .ZN(
        sub_0_root_sub_1_root_add_7_2_n51) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U41 ( .A(b[3]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n100) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U40 ( .A1(a[3]), .A2(
        sub_0_root_sub_1_root_add_7_2_n100), .ZN(
        sub_0_root_sub_1_root_add_7_2_n71) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U39 ( .A(b[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n80) );
  XOR2_X1 sub_0_root_sub_1_root_add_7_2_U38 ( .A(b[7]), .B(a[7]), .Z(
        sub_0_root_sub_1_root_add_7_2_n22) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U37 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n84), .A2(
        sub_0_root_sub_1_root_add_7_2_n30), .ZN(
        sub_0_root_sub_1_root_add_7_2_n85) );
  XNOR2_X1 sub_0_root_sub_1_root_add_7_2_U36 ( .A(
        sub_0_root_sub_1_root_add_7_2_n103), .B(
        sub_0_root_sub_1_root_add_7_2_n104), .ZN(diff[2]) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U35 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n106), .A2(
        sub_0_root_sub_1_root_add_7_2_n96), .ZN(
        sub_0_root_sub_1_root_add_7_2_n105) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U34 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n105), .A2(
        sub_0_root_sub_1_root_add_7_2_n51), .ZN(
        sub_0_root_sub_1_root_add_7_2_n103) );
  AND2_X1 sub_0_root_sub_1_root_add_7_2_U33 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n96), .A2(
        sub_0_root_sub_1_root_add_7_2_n51), .ZN(
        sub_0_root_sub_1_root_add_7_2_n21) );
  XOR2_X1 sub_0_root_sub_1_root_add_7_2_U32 ( .A(
        sub_0_root_sub_1_root_add_7_2_n106), .B(
        sub_0_root_sub_1_root_add_7_2_n21), .Z(diff[1]) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U31 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n57), .A2(
        sub_0_root_sub_1_root_add_7_2_n32), .ZN(
        sub_0_root_sub_1_root_add_7_2_n20) );
  XNOR2_X1 sub_0_root_sub_1_root_add_7_2_U30 ( .A(
        sub_0_root_sub_1_root_add_7_2_n72), .B(
        sub_0_root_sub_1_root_add_7_2_n20), .ZN(diff[6]) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U29 ( .A(b[5]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n19) );
  OAI211_X1 sub_0_root_sub_1_root_add_7_2_U28 ( .C1(
        sub_0_root_sub_1_root_add_7_2_n13), .C2(a[5]), .A(
        sub_0_root_sub_1_root_add_7_2_n80), .B(a[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n78) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U27 ( .A(b[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n18) );
  OAI22_X1 sub_0_root_sub_1_root_add_7_2_U26 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n19), .A2(a[5]), .B1(
        sub_0_root_sub_1_root_add_7_2_n18), .B2(a[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n62) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U25 ( .A(a[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n17) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U24 ( .A(a[5]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n16) );
  AOI22_X1 sub_0_root_sub_1_root_add_7_2_U23 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n16), .A2(b[5]), .B1(
        sub_0_root_sub_1_root_add_7_2_n17), .B2(b[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n45) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U22 ( .A(b[3]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n15) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U21 ( .A(b[6]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n14) );
  OAI22_X1 sub_0_root_sub_1_root_add_7_2_U20 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n14), .A2(a[6]), .B1(
        sub_0_root_sub_1_root_add_7_2_n15), .B2(a[3]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n69) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U19 ( .A(b[5]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n13) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U18 ( .A(b[4]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n12) );
  OAI22_X1 sub_0_root_sub_1_root_add_7_2_U17 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n12), .A2(a[4]), .B1(
        sub_0_root_sub_1_root_add_7_2_n82), .B2(a[5]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n38) );
  OAI22_X1 sub_0_root_sub_1_root_add_7_2_U16 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n12), .A2(a[4]), .B1(
        sub_0_root_sub_1_root_add_7_2_n19), .B2(a[5]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n11) );
  AND2_X1 sub_0_root_sub_1_root_add_7_2_U15 ( .A1(b[1]), .A2(
        sub_0_root_sub_1_root_add_7_2_n37), .ZN(
        sub_0_root_sub_1_root_add_7_2_n10) );
  CLKBUF_X1 sub_0_root_sub_1_root_add_7_2_U14 ( .A(
        sub_0_root_sub_1_root_add_7_2_n102), .Z(
        sub_0_root_sub_1_root_add_7_2_n25) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U13 ( .A(a[2]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n9) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U12 ( .A(
        sub_0_root_sub_1_root_add_7_2_n82), .ZN(
        sub_0_root_sub_1_root_add_7_2_n8) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U11 ( .A1(a[0]), .A2(
        sub_0_root_sub_1_root_add_7_2_n109), .ZN(
        sub_0_root_sub_1_root_add_7_2_n7) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U10 ( .A1(a[5]), .A2(
        sub_0_root_sub_1_root_add_7_2_n19), .ZN(
        sub_0_root_sub_1_root_add_7_2_n6) );
  AND2_X1 sub_0_root_sub_1_root_add_7_2_U9 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n70), .A2(
        sub_0_root_sub_1_root_add_7_2_n24), .ZN(
        sub_0_root_sub_1_root_add_7_2_n90) );
  NAND2_X1 sub_0_root_sub_1_root_add_7_2_U8 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n6), .A2(
        sub_0_root_sub_1_root_add_7_2_n31), .ZN(
        sub_0_root_sub_1_root_add_7_2_n5) );
  XNOR2_X1 sub_0_root_sub_1_root_add_7_2_U7 ( .A(
        sub_0_root_sub_1_root_add_7_2_n81), .B(
        sub_0_root_sub_1_root_add_7_2_n5), .ZN(diff[5]) );
  INV_X1 sub_0_root_sub_1_root_add_7_2_U6 ( .A(a[0]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n4) );
  AND2_X1 sub_0_root_sub_1_root_add_7_2_U5 ( .A1(b[0]), .A2(
        sub_0_root_sub_1_root_add_7_2_n4), .ZN(
        sub_0_root_sub_1_root_add_7_2_n3) );
  AND2_X1 sub_0_root_sub_1_root_add_7_2_U4 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n34), .A2(b[3]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n2) );
  AND2_X1 sub_0_root_sub_1_root_add_7_2_U3 ( .A1(
        sub_0_root_sub_1_root_add_7_2_n108), .A2(b[0]), .ZN(
        sub_0_root_sub_1_root_add_7_2_n1) );
endmodule

