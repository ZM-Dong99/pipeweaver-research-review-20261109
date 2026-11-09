/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:34:38 2025
/////////////////////////////////////////////////////////////


module addr_calcu_dsr ( address, ptr1, ptr2, b, control, count );
  input [7:0] address;
  input [7:0] ptr1;
  input [7:0] ptr2;
  input [7:0] b;
  output [15:0] count;
  input control;
  wire   offset2_7_, offset2_6_, offset2_5_, offset2_4_, offset2_3_,
         offset2_2_, offset2_1_, offset1_7_, offset1_6_, offset1_5_,
         offset1_4_, offset1_3_, offset1_2_, offset1_1_, address_plus_b_8_,
         address_plus_b_7_, address_plus_b_6_, address_plus_b_5_,
         address_plus_b_4_, address_plus_b_3_, address_plus_b_2_,
         address_plus_b_1_, address_plus_b_0_, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, add_13_n68, add_13_n67, add_13_n66, add_13_n65,
         add_13_n64, add_13_n63, add_13_n62, add_13_n61, add_13_n60,
         add_13_n59, add_13_n58, add_13_n57, add_13_n56, add_13_n55,
         add_13_n54, add_13_n53, add_13_n52, add_13_n51, add_13_n50,
         add_13_n49, add_13_n48, add_13_n47, add_13_n46, add_13_n45,
         add_13_n44, add_13_n43, add_13_n42, add_13_n41, add_13_n40,
         add_13_n39, add_13_n38, add_13_n37, add_13_n36, add_13_n35,
         add_13_n34, add_13_n33, add_13_n32, add_13_n31, add_13_n30,
         add_13_n29, add_13_n28, add_13_n27, add_13_n26, add_13_n25,
         add_13_n24, add_13_n23, add_13_n22, add_13_n21, add_13_n20,
         add_13_n19, add_13_n18, add_13_n17, add_13_n16, add_13_n15,
         add_13_n14, add_13_n13, add_13_n12, add_13_n11, add_13_n10, add_13_n9,
         add_13_n8, add_13_n7, add_13_n6, add_13_n5, add_13_n4, add_13_n3,
         add_13_n2, add_13_n1, sub_15_n85, sub_15_n84, sub_15_n83, sub_15_n82,
         sub_15_n81, sub_15_n80, sub_15_n79, sub_15_n78, sub_15_n77,
         sub_15_n76, sub_15_n75, sub_15_n74, sub_15_n73, sub_15_n72,
         sub_15_n71, sub_15_n70, sub_15_n69, sub_15_n68, sub_15_n67,
         sub_15_n66, sub_15_n65, sub_15_n64, sub_15_n63, sub_15_n62,
         sub_15_n61, sub_15_n60, sub_15_n59, sub_15_n58, sub_15_n57,
         sub_15_n56, sub_15_n55, sub_15_n54, sub_15_n53, sub_15_n52,
         sub_15_n51, sub_15_n50, sub_15_n49, sub_15_n48, sub_15_n47,
         sub_15_n46, sub_15_n45, sub_15_n44, sub_15_n43, sub_15_n42,
         sub_15_n41, sub_15_n40, sub_15_n39, sub_15_n38, sub_15_n37,
         sub_15_n36, sub_15_n35, sub_15_n34, sub_15_n33, sub_15_n32,
         sub_15_n31, sub_15_n30, sub_15_n29, sub_15_n28, sub_15_n27,
         sub_15_n26, sub_15_n25, sub_15_n24, sub_15_n23, sub_15_n22,
         sub_15_n21, sub_15_n20, sub_15_n19, sub_15_n18, sub_15_n17,
         sub_15_n16, sub_15_n15, sub_15_n14, sub_15_n13, sub_15_n12,
         sub_15_n11, sub_15_n10, sub_15_n9, sub_15_n8, sub_15_n7, sub_15_n6,
         sub_15_n5, sub_15_n4, sub_15_n3, sub_15_n2, sub_15_n1, sub_14_n79,
         sub_14_n78, sub_14_n77, sub_14_n76, sub_14_n75, sub_14_n74,
         sub_14_n73, sub_14_n72, sub_14_n71, sub_14_n70, sub_14_n69,
         sub_14_n68, sub_14_n67, sub_14_n66, sub_14_n65, sub_14_n64,
         sub_14_n63, sub_14_n62, sub_14_n61, sub_14_n60, sub_14_n59,
         sub_14_n58, sub_14_n57, sub_14_n56, sub_14_n55, sub_14_n54,
         sub_14_n53, sub_14_n52, sub_14_n51, sub_14_n50, sub_14_n49,
         sub_14_n48, sub_14_n47, sub_14_n46, sub_14_n45, sub_14_n44,
         sub_14_n43, sub_14_n42, sub_14_n41, sub_14_n40, sub_14_n39,
         sub_14_n38, sub_14_n37, sub_14_n36, sub_14_n35, sub_14_n34,
         sub_14_n33, sub_14_n32, sub_14_n31, sub_14_n30, sub_14_n29,
         sub_14_n28, sub_14_n27, sub_14_n26, sub_14_n25, sub_14_n24,
         sub_14_n23, sub_14_n22, sub_14_n21, sub_14_n20, sub_14_n19,
         sub_14_n18, sub_14_n17, sub_14_n16, sub_14_n15, sub_14_n14,
         sub_14_n13, sub_14_n12, sub_14_n11, sub_14_n10, sub_14_n9, sub_14_n8,
         sub_14_n7, sub_14_n6, sub_14_n5, sub_14_n4, sub_14_n3, sub_14_n2,
         sub_14_n1;
  wire   [8:0] count1;
  wire   [8:0] count2;

  INV_X1 U34 ( .A(1'b1), .ZN(count[9]) );
  INV_X1 U36 ( .A(1'b1), .ZN(count[10]) );
  INV_X1 U38 ( .A(1'b1), .ZN(count[11]) );
  INV_X1 U40 ( .A(1'b1), .ZN(count[12]) );
  INV_X1 U42 ( .A(1'b1), .ZN(count[13]) );
  INV_X1 U44 ( .A(1'b1), .ZN(count[14]) );
  INV_X1 U46 ( .A(1'b1), .ZN(count[15]) );
  OR2_X1 U48 ( .A1(n62), .A2(n63), .ZN(n71) );
  OR2_X1 U49 ( .A1(ptr1[6]), .A2(n70), .ZN(n64) );
  NOR2_X1 U50 ( .A1(ptr2[1]), .A2(ptr2[0]), .ZN(n51) );
  INV_X1 U51 ( .A(control), .ZN(n52) );
  MUX2_X1 U52 ( .A(count1[7]), .B(count2[7]), .S(n52), .Z(count[7]) );
  MUX2_X1 U53 ( .A(count1[8]), .B(count2[8]), .S(n52), .Z(count[8]) );
  NAND3_X1 U54 ( .A1(n53), .A2(n54), .A3(n55), .ZN(n70) );
  INV_X1 U55 ( .A(n62), .ZN(n53) );
  INV_X1 U56 ( .A(n63), .ZN(n54) );
  INV_X1 U57 ( .A(ptr1[5]), .ZN(n55) );
  NAND2_X1 U58 ( .A1(n56), .A2(n57), .ZN(n74) );
  INV_X1 U59 ( .A(ptr1[1]), .ZN(n56) );
  INV_X1 U60 ( .A(ptr1[0]), .ZN(n57) );
  NAND4_X1 U61 ( .A1(n51), .A2(n58), .A3(n66), .A4(n59), .ZN(n68) );
  INV_X1 U62 ( .A(ptr2[2]), .ZN(n58) );
  INV_X1 U63 ( .A(ptr2[3]), .ZN(n59) );
  OR2_X2 U64 ( .A1(ptr2[1]), .A2(ptr2[0]), .ZN(n60) );
  OR2_X1 U65 ( .A1(ptr2[6]), .A2(n67), .ZN(n61) );
  XNOR2_X1 U66 ( .A(ptr2[7]), .B(n61), .ZN(offset2_7_) );
  OR2_X1 U67 ( .A1(n74), .A2(ptr1[2]), .ZN(n62) );
  OR2_X1 U68 ( .A1(ptr1[4]), .A2(ptr1[3]), .ZN(n63) );
  OR2_X1 U69 ( .A1(n74), .A2(ptr1[2]), .ZN(n73) );
  OR2_X1 U70 ( .A1(n73), .A2(ptr1[3]), .ZN(n72) );
  XNOR2_X1 U71 ( .A(ptr1[7]), .B(n64), .ZN(offset1_7_) );
  NOR2_X1 U72 ( .A1(n69), .A2(ptr2[3]), .ZN(n65) );
  OR2_X1 U73 ( .A1(n60), .A2(ptr2[2]), .ZN(n69) );
  OR2_X1 U74 ( .A1(n68), .A2(ptr2[5]), .ZN(n67) );
  XNOR2_X1 U75 ( .A(n65), .B(ptr2[4]), .ZN(offset2_4_) );
  INV_X1 U76 ( .A(ptr2[4]), .ZN(n66) );
  XOR2_X1 U77 ( .A(n67), .B(ptr2[6]), .Z(offset2_6_) );
  XOR2_X1 U78 ( .A(n68), .B(ptr2[5]), .Z(offset2_5_) );
  XOR2_X1 U79 ( .A(n69), .B(ptr2[3]), .Z(offset2_3_) );
  XOR2_X1 U80 ( .A(n60), .B(ptr2[2]), .Z(offset2_2_) );
  XOR2_X1 U81 ( .A(ptr2[0]), .B(ptr2[1]), .Z(offset2_1_) );
  XOR2_X1 U82 ( .A(n70), .B(ptr1[6]), .Z(offset1_6_) );
  XOR2_X1 U83 ( .A(n71), .B(ptr1[5]), .Z(offset1_5_) );
  XOR2_X1 U84 ( .A(n72), .B(ptr1[4]), .Z(offset1_4_) );
  XOR2_X1 U85 ( .A(n73), .B(ptr1[3]), .Z(offset1_3_) );
  XOR2_X1 U86 ( .A(n74), .B(ptr1[2]), .Z(offset1_2_) );
  XOR2_X1 U87 ( .A(ptr1[0]), .B(ptr1[1]), .Z(offset1_1_) );
  MUX2_X1 U88 ( .A(count2[0]), .B(count1[0]), .S(control), .Z(count[0]) );
  MUX2_X1 U89 ( .A(count2[1]), .B(count1[1]), .S(control), .Z(count[1]) );
  MUX2_X1 U90 ( .A(count2[2]), .B(count1[2]), .S(control), .Z(count[2]) );
  MUX2_X1 U91 ( .A(count2[3]), .B(count1[3]), .S(control), .Z(count[3]) );
  MUX2_X1 U92 ( .A(count2[4]), .B(count1[4]), .S(control), .Z(count[4]) );
  MUX2_X1 U93 ( .A(count2[5]), .B(count1[5]), .S(control), .Z(count[5]) );
  MUX2_X1 U94 ( .A(count2[6]), .B(count1[6]), .S(control), .Z(count[6]) );
  NAND3_X1 add_13_U78 ( .A1(add_13_n66), .A2(add_13_n49), .A3(add_13_n67), 
        .ZN(add_13_n65) );
  NAND2_X1 add_13_U77 ( .A1(add_13_n65), .A2(add_13_n57), .ZN(add_13_n62) );
  XNOR2_X2 add_13_U76 ( .A(add_13_n39), .B(add_13_n40), .ZN(address_plus_b_5_)
         );
  INV_X1 add_13_U75 ( .A(add_13_n36), .ZN(add_13_n32) );
  INV_X1 add_13_U74 ( .A(add_13_n35), .ZN(add_13_n34) );
  INV_X1 add_13_U73 ( .A(add_13_n28), .ZN(add_13_n24) );
  INV_X1 add_13_U72 ( .A(add_13_n27), .ZN(add_13_n25) );
  INV_X1 add_13_U71 ( .A(add_13_n12), .ZN(add_13_n19) );
  INV_X1 add_13_U70 ( .A(add_13_n22), .ZN(add_13_n21) );
  AOI21_X1 add_13_U69 ( .B1(add_13_n19), .B2(add_13_n20), .A(add_13_n21), .ZN(
        address_plus_b_8_) );
  NAND2_X1 add_13_U68 ( .A1(add_13_n54), .A2(add_13_n48), .ZN(add_13_n63) );
  NAND2_X1 add_13_U67 ( .A1(add_13_n47), .A2(add_13_n11), .ZN(add_13_n52) );
  NAND2_X1 add_13_U66 ( .A1(add_13_n38), .A2(add_13_n37), .ZN(add_13_n41) );
  NAND2_X1 add_13_U65 ( .A1(add_13_n6), .A2(add_13_n44), .ZN(add_13_n38) );
  NOR2_X1 add_13_U64 ( .A1(add_13_n60), .A2(add_13_n61), .ZN(add_13_n55) );
  NOR2_X1 add_13_U63 ( .A1(add_13_n58), .A2(add_13_n59), .ZN(add_13_n56) );
  AOI21_X1 add_13_U62 ( .B1(add_13_n56), .B2(add_13_n55), .A(add_13_n7), .ZN(
        add_13_n53) );
  OAI21_X1 add_13_U61 ( .B1(add_13_n53), .B2(add_13_n9), .A(add_13_n54), .ZN(
        add_13_n51) );
  OAI21_X1 add_13_U60 ( .B1(add_13_n13), .B2(add_13_n46), .A(add_13_n47), .ZN(
        add_13_n45) );
  XNOR2_X1 add_13_U59 ( .A(add_13_n17), .B(add_13_n23), .ZN(address_plus_b_7_)
         );
  NAND2_X1 add_13_U58 ( .A1(add_13_n41), .A2(add_13_n36), .ZN(add_13_n39) );
  OAI21_X1 add_13_U57 ( .B1(add_13_n8), .B2(add_13_n30), .A(add_13_n31), .ZN(
        add_13_n28) );
  NAND2_X1 add_13_U56 ( .A1(b[7]), .A2(address[7]), .ZN(add_13_n20) );
  OR2_X2 add_13_U55 ( .A1(b[7]), .A2(address[7]), .ZN(add_13_n22) );
  NAND2_X1 add_13_U54 ( .A1(b[6]), .A2(address[6]), .ZN(add_13_n26) );
  OR2_X2 add_13_U53 ( .A1(b[6]), .A2(address[6]), .ZN(add_13_n27) );
  NAND2_X1 add_13_U52 ( .A1(b[4]), .A2(address[4]), .ZN(add_13_n36) );
  NAND2_X1 add_13_U51 ( .A1(b[5]), .A2(address[5]), .ZN(add_13_n35) );
  OR2_X2 add_13_U50 ( .A1(b[5]), .A2(address[5]), .ZN(add_13_n33) );
  OR2_X2 add_13_U49 ( .A1(b[4]), .A2(address[4]), .ZN(add_13_n37) );
  NAND2_X1 add_13_U48 ( .A1(b[2]), .A2(address[2]), .ZN(add_13_n54) );
  NAND2_X1 add_13_U47 ( .A1(b[0]), .A2(address[0]), .ZN(add_13_n68) );
  AND2_X1 add_13_U46 ( .A1(address[0]), .A2(b[0]), .ZN(add_13_n67) );
  INV_X1 add_13_U45 ( .A(address[0]), .ZN(add_13_n60) );
  OR2_X1 add_13_U44 ( .A1(b[0]), .A2(address[0]), .ZN(add_13_n66) );
  INV_X1 add_13_U43 ( .A(b[0]), .ZN(add_13_n61) );
  NOR2_X1 add_13_U42 ( .A1(address[1]), .A2(b[1]), .ZN(add_13_n59) );
  NOR2_X1 add_13_U41 ( .A1(address[0]), .A2(b[0]), .ZN(add_13_n58) );
  NAND2_X1 add_13_U40 ( .A1(b[1]), .A2(address[1]), .ZN(add_13_n57) );
  INV_X1 add_13_U39 ( .A(b[2]), .ZN(add_13_n64) );
  NAND2_X1 add_13_U38 ( .A1(add_13_n64), .A2(add_13_n14), .ZN(add_13_n48) );
  NAND2_X1 add_13_U37 ( .A1(address[2]), .A2(b[2]), .ZN(add_13_n46) );
  NAND2_X1 add_13_U36 ( .A1(add_13_n33), .A2(add_13_n37), .ZN(add_13_n30) );
  AOI21_X1 add_13_U35 ( .B1(add_13_n32), .B2(add_13_n33), .A(add_13_n34), .ZN(
        add_13_n31) );
  AND2_X1 add_13_U34 ( .A1(add_13_n68), .A2(add_13_n66), .ZN(address_plus_b_0_) );
  NAND2_X1 add_13_U33 ( .A1(add_13_n36), .A2(add_13_n37), .ZN(add_13_n42) );
  XNOR2_X1 add_13_U32 ( .A(add_13_n51), .B(add_13_n52), .ZN(address_plus_b_3_)
         );
  NAND2_X1 add_13_U31 ( .A1(add_13_n35), .A2(add_13_n33), .ZN(add_13_n40) );
  NAND2_X1 add_13_U30 ( .A1(add_13_n20), .A2(add_13_n22), .ZN(add_13_n23) );
  INV_X1 add_13_U29 ( .A(add_13_n45), .ZN(add_13_n44) );
  OAI21_X1 add_13_U28 ( .B1(add_13_n30), .B2(add_13_n8), .A(add_13_n31), .ZN(
        add_13_n18) );
  NAND2_X1 add_13_U27 ( .A1(add_13_n26), .A2(add_13_n27), .ZN(add_13_n29) );
  OAI21_X1 add_13_U26 ( .B1(add_13_n24), .B2(add_13_n25), .A(add_13_n26), .ZN(
        add_13_n17) );
  CLKBUF_X1 add_13_U25 ( .A(add_13_n38), .Z(add_13_n16) );
  AND2_X1 add_13_U24 ( .A1(address[1]), .A2(b[1]), .ZN(add_13_n15) );
  INV_X1 add_13_U23 ( .A(address[2]), .ZN(add_13_n14) );
  XNOR2_X2 add_13_U22 ( .A(add_13_n16), .B(add_13_n42), .ZN(address_plus_b_4_)
         );
  CLKBUF_X1 add_13_U21 ( .A(add_13_n17), .Z(add_13_n12) );
  OR2_X1 add_13_U20 ( .A1(b[3]), .A2(address[3]), .ZN(add_13_n11) );
  AND2_X1 add_13_U19 ( .A1(add_13_n49), .A2(add_13_n57), .ZN(add_13_n10) );
  XNOR2_X1 add_13_U18 ( .A(add_13_n10), .B(add_13_n68), .ZN(address_plus_b_1_)
         );
  NOR2_X1 add_13_U17 ( .A1(b[2]), .A2(address[2]), .ZN(add_13_n9) );
  AND2_X1 add_13_U16 ( .A1(add_13_n43), .A2(add_13_n44), .ZN(add_13_n8) );
  AND2_X1 add_13_U15 ( .A1(b[1]), .A2(address[1]), .ZN(add_13_n7) );
  XNOR2_X1 add_13_U14 ( .A(add_13_n62), .B(add_13_n63), .ZN(address_plus_b_2_)
         );
  OAI211_X1 add_13_U13 ( .C1(b[1]), .C2(address[1]), .A(address[0]), .B(b[0]), 
        .ZN(add_13_n50) );
  NOR2_X1 add_13_U12 ( .A1(b[3]), .A2(address[3]), .ZN(add_13_n13) );
  OAI222_X1 add_13_U11 ( .A1(add_13_n5), .A2(add_13_n15), .B1(address[3]), 
        .B2(b[3]), .C1(address[2]), .C2(b[2]), .ZN(add_13_n43) );
  NAND2_X1 add_13_U10 ( .A1(b[3]), .A2(address[3]), .ZN(add_13_n47) );
  INV_X1 add_13_U9 ( .A(address[1]), .ZN(add_13_n4) );
  INV_X1 add_13_U8 ( .A(b[1]), .ZN(add_13_n3) );
  NAND2_X1 add_13_U7 ( .A1(add_13_n3), .A2(add_13_n4), .ZN(add_13_n49) );
  INV_X1 add_13_U6 ( .A(add_13_n2), .ZN(add_13_n5) );
  OAI211_X1 add_13_U5 ( .C1(b[1]), .C2(address[1]), .A(address[0]), .B(b[0]), 
        .ZN(add_13_n2) );
  INV_X1 add_13_U4 ( .A(add_13_n50), .ZN(add_13_n1) );
  OAI222_X1 add_13_U3 ( .A1(add_13_n1), .A2(add_13_n15), .B1(address[3]), .B2(
        b[3]), .C1(address[2]), .C2(b[2]), .ZN(add_13_n6) );
  XNOR2_X2 add_13_U2 ( .A(add_13_n18), .B(add_13_n29), .ZN(address_plus_b_6_)
         );
  INV_X1 sub_15_U96 ( .A(sub_15_n78), .ZN(sub_15_n76) );
  INV_X1 sub_15_U95 ( .A(sub_15_n69), .ZN(sub_15_n77) );
  OAI21_X1 sub_15_U94 ( .B1(sub_15_n76), .B2(sub_15_n77), .A(sub_15_n64), .ZN(
        sub_15_n72) );
  XNOR2_X1 sub_15_U93 ( .A(sub_15_n72), .B(sub_15_n73), .ZN(count2[3]) );
  INV_X1 sub_15_U92 ( .A(sub_15_n71), .ZN(sub_15_n70) );
  INV_X1 sub_15_U91 ( .A(sub_15_n32), .ZN(sub_15_n57) );
  INV_X1 sub_15_U90 ( .A(sub_15_n55), .ZN(sub_15_n59) );
  NOR2_X1 sub_15_U89 ( .A1(sub_15_n57), .A2(sub_15_n59), .ZN(sub_15_n58) );
  XNOR2_X1 sub_15_U88 ( .A(sub_15_n15), .B(sub_15_n58), .ZN(count2[4]) );
  NAND2_X1 sub_15_U87 ( .A1(address_plus_b_5_), .A2(sub_15_n36), .ZN(
        sub_15_n39) );
  OAI211_X1 sub_15_U86 ( .C1(sub_15_n19), .C2(sub_15_n36), .A(sub_15_n42), .B(
        address_plus_b_4_), .ZN(sub_15_n41) );
  NOR2_X1 sub_15_U85 ( .A1(sub_15_n19), .A2(sub_15_n36), .ZN(sub_15_n33) );
  XNOR2_X1 sub_15_U84 ( .A(sub_15_n23), .B(sub_15_n24), .ZN(count2[8]) );
  NAND2_X1 sub_15_U83 ( .A1(sub_15_n37), .A2(address_plus_b_6_), .ZN(
        sub_15_n40) );
  NAND2_X1 sub_15_U82 ( .A1(sub_15_n55), .A2(sub_15_n39), .ZN(sub_15_n54) );
  XNOR2_X1 sub_15_U81 ( .A(sub_15_n43), .B(sub_15_n44), .ZN(count2[7]) );
  NOR2_X1 sub_15_U80 ( .A1(sub_15_n35), .A2(address_plus_b_7_), .ZN(sub_15_n34) );
  NAND2_X1 sub_15_U79 ( .A1(sub_15_n22), .A2(sub_15_n35), .ZN(sub_15_n28) );
  INV_X1 sub_15_U78 ( .A(address_plus_b_0_), .ZN(sub_15_n84) );
  NAND2_X1 sub_15_U77 ( .A1(address_plus_b_0_), .A2(sub_15_n85), .ZN(
        sub_15_n62) );
  INV_X1 sub_15_U76 ( .A(offset2_7_), .ZN(sub_15_n35) );
  NAND2_X1 sub_15_U75 ( .A1(address_plus_b_1_), .A2(sub_15_n13), .ZN(
        sub_15_n65) );
  INV_X1 sub_15_U74 ( .A(sub_15_n67), .ZN(sub_15_n63) );
  NAND4_X1 sub_15_U73 ( .A1(sub_15_n70), .A2(sub_15_n69), .A3(sub_15_n16), 
        .A4(sub_15_n67), .ZN(sub_15_n52) );
  NAND2_X1 sub_15_U72 ( .A1(sub_15_n81), .A2(sub_15_n67), .ZN(sub_15_n80) );
  NAND2_X1 sub_15_U71 ( .A1(sub_15_n6), .A2(sub_15_n47), .ZN(sub_15_n45) );
  NAND2_X1 sub_15_U70 ( .A1(sub_15_n65), .A2(sub_15_n67), .ZN(sub_15_n82) );
  NAND2_X1 sub_15_U69 ( .A1(sub_15_n1), .A2(sub_15_n21), .ZN(sub_15_n46) );
  NAND2_X1 sub_15_U68 ( .A1(sub_15_n31), .A2(sub_15_n32), .ZN(sub_15_n30) );
  CLKBUF_X1 sub_15_U67 ( .A(address_plus_b_7_), .Z(sub_15_n22) );
  OR2_X1 sub_15_U66 ( .A1(address_plus_b_7_), .A2(sub_15_n35), .ZN(sub_15_n38)
         );
  INV_X1 sub_15_U65 ( .A(address_plus_b_3_), .ZN(sub_15_n74) );
  NAND2_X1 sub_15_U64 ( .A1(sub_15_n54), .A2(sub_15_n50), .ZN(sub_15_n47) );
  NAND2_X1 sub_15_U63 ( .A1(sub_15_n20), .A2(sub_15_n28), .ZN(sub_15_n44) );
  CLKBUF_X1 sub_15_U62 ( .A(sub_15_n31), .Z(sub_15_n21) );
  NAND2_X1 sub_15_U61 ( .A1(sub_15_n52), .A2(sub_15_n53), .ZN(sub_15_n49) );
  CLKBUF_X1 sub_15_U60 ( .A(sub_15_n38), .Z(sub_15_n20) );
  NAND2_X1 sub_15_U59 ( .A1(address_plus_b_2_), .A2(sub_15_n66), .ZN(
        sub_15_n64) );
  INV_X1 sub_15_U58 ( .A(sub_15_n25), .ZN(sub_15_n24) );
  OAI21_X1 sub_15_U57 ( .B1(sub_15_n15), .B2(sub_15_n57), .A(sub_15_n55), .ZN(
        sub_15_n56) );
  NAND2_X1 sub_15_U56 ( .A1(sub_15_n62), .A2(sub_15_n83), .ZN(count2[0]) );
  XNOR2_X1 sub_15_U55 ( .A(sub_15_n81), .B(sub_15_n82), .ZN(count2[1]) );
  XNOR2_X1 sub_15_U54 ( .A(sub_15_n78), .B(sub_15_n79), .ZN(count2[2]) );
  INV_X1 sub_15_U53 ( .A(ptr2[0]), .ZN(sub_15_n85) );
  NAND2_X1 sub_15_U52 ( .A1(ptr2[0]), .A2(sub_15_n84), .ZN(sub_15_n83) );
  XNOR2_X1 sub_15_U51 ( .A(sub_15_n45), .B(sub_15_n46), .ZN(count2[6]) );
  NAND2_X1 sub_15_U50 ( .A1(sub_15_n71), .A2(sub_15_n62), .ZN(sub_15_n81) );
  INV_X1 sub_15_U49 ( .A(sub_15_n5), .ZN(sub_15_n75) );
  NAND2_X1 sub_15_U48 ( .A1(sub_15_n18), .A2(sub_15_n75), .ZN(sub_15_n53) );
  INV_X1 sub_15_U47 ( .A(offset2_2_), .ZN(sub_15_n66) );
  INV_X1 sub_15_U46 ( .A(sub_15_n83), .ZN(sub_15_n71) );
  INV_X1 sub_15_U45 ( .A(offset2_5_), .ZN(sub_15_n36) );
  INV_X1 sub_15_U44 ( .A(offset2_6_), .ZN(sub_15_n37) );
  INV_X1 sub_15_U43 ( .A(offset2_4_), .ZN(sub_15_n42) );
  AND2_X1 sub_15_U42 ( .A1(sub_15_n68), .A2(sub_15_n69), .ZN(sub_15_n60) );
  OAI211_X1 sub_15_U41 ( .C1(sub_15_n63), .C2(sub_15_n62), .A(sub_15_n64), .B(
        sub_15_n65), .ZN(sub_15_n61) );
  NAND2_X1 sub_15_U40 ( .A1(sub_15_n53), .A2(sub_15_n16), .ZN(sub_15_n73) );
  NAND2_X1 sub_15_U39 ( .A1(sub_15_n69), .A2(sub_15_n64), .ZN(sub_15_n79) );
  NAND2_X1 sub_15_U38 ( .A1(sub_15_n80), .A2(sub_15_n65), .ZN(sub_15_n78) );
  INV_X1 sub_15_U37 ( .A(address_plus_b_8_), .ZN(sub_15_n25) );
  NAND2_X1 sub_15_U36 ( .A1(address_plus_b_4_), .A2(sub_15_n42), .ZN(
        sub_15_n55) );
  OR2_X1 sub_15_U35 ( .A1(sub_15_n37), .A2(address_plus_b_6_), .ZN(sub_15_n31)
         );
  CLKBUF_X1 sub_15_U34 ( .A(address_plus_b_5_), .Z(sub_15_n19) );
  CLKBUF_X1 sub_15_U33 ( .A(address_plus_b_3_), .Z(sub_15_n18) );
  NAND2_X1 sub_15_U32 ( .A1(sub_15_n17), .A2(sub_15_n38), .ZN(sub_15_n27) );
  OR2_X1 sub_15_U31 ( .A1(address_plus_b_6_), .A2(sub_15_n37), .ZN(sub_15_n17)
         );
  AND3_X1 sub_15_U30 ( .A1(sub_15_n51), .A2(sub_15_n52), .A3(sub_15_n53), .ZN(
        sub_15_n29) );
  AND2_X1 sub_15_U29 ( .A1(sub_15_n39), .A2(sub_15_n40), .ZN(sub_15_n14) );
  AND2_X1 sub_15_U28 ( .A1(sub_15_n41), .A2(sub_15_n14), .ZN(sub_15_n26) );
  INV_X1 sub_15_U27 ( .A(offset2_1_), .ZN(sub_15_n13) );
  INV_X1 sub_15_U26 ( .A(offset2_2_), .ZN(sub_15_n12) );
  NAND2_X1 sub_15_U25 ( .A1(sub_15_n74), .A2(sub_15_n5), .ZN(sub_15_n68) );
  OR2_X2 sub_15_U24 ( .A1(address_plus_b_4_), .A2(sub_15_n42), .ZN(sub_15_n32)
         );
  INV_X1 sub_15_U23 ( .A(sub_15_n31), .ZN(sub_15_n11) );
  OAI21_X1 sub_15_U22 ( .B1(sub_15_n10), .B2(sub_15_n11), .A(sub_15_n1), .ZN(
        sub_15_n43) );
  OR2_X1 sub_15_U21 ( .A1(address_plus_b_5_), .A2(sub_15_n36), .ZN(sub_15_n50)
         );
  AND2_X1 sub_15_U20 ( .A1(sub_15_n47), .A2(sub_15_n48), .ZN(sub_15_n10) );
  OAI221_X1 sub_15_U19 ( .B1(sub_15_n27), .B2(sub_15_n26), .C1(sub_15_n9), 
        .C2(sub_15_n2), .A(sub_15_n28), .ZN(sub_15_n23) );
  OAI211_X1 sub_15_U18 ( .C1(sub_15_n7), .C2(sub_15_n49), .A(sub_15_n32), .B(
        sub_15_n50), .ZN(sub_15_n48) );
  NAND2_X1 sub_15_U17 ( .A1(sub_15_n60), .A2(sub_15_n61), .ZN(sub_15_n51) );
  INV_X1 sub_15_U16 ( .A(offset2_3_), .ZN(sub_15_n8) );
  OR2_X1 sub_15_U15 ( .A1(sub_15_n8), .A2(address_plus_b_3_), .ZN(sub_15_n16)
         );
  OR2_X1 sub_15_U14 ( .A1(sub_15_n29), .A2(sub_15_n30), .ZN(sub_15_n9) );
  AND2_X1 sub_15_U13 ( .A1(sub_15_n61), .A2(sub_15_n4), .ZN(sub_15_n7) );
  OAI211_X1 sub_15_U12 ( .C1(sub_15_n7), .C2(sub_15_n49), .A(sub_15_n32), .B(
        sub_15_n50), .ZN(sub_15_n6) );
  BUF_X1 sub_15_U11 ( .A(offset2_3_), .Z(sub_15_n5) );
  OR2_X2 sub_15_U10 ( .A1(address_plus_b_2_), .A2(sub_15_n12), .ZN(sub_15_n69)
         );
  AND2_X1 sub_15_U9 ( .A1(sub_15_n68), .A2(sub_15_n69), .ZN(sub_15_n4) );
  NAND2_X1 sub_15_U8 ( .A1(sub_15_n50), .A2(sub_15_n39), .ZN(sub_15_n3) );
  XNOR2_X1 sub_15_U7 ( .A(sub_15_n56), .B(sub_15_n3), .ZN(count2[5]) );
  OR2_X1 sub_15_U6 ( .A1(sub_15_n34), .A2(sub_15_n33), .ZN(sub_15_n2) );
  OR2_X1 sub_15_U5 ( .A1(address_plus_b_1_), .A2(sub_15_n13), .ZN(sub_15_n67)
         );
  BUF_X1 sub_15_U4 ( .A(sub_15_n40), .Z(sub_15_n1) );
  BUF_X1 sub_15_U3 ( .A(sub_15_n29), .Z(sub_15_n15) );
  INV_X1 sub_14_U90 ( .A(sub_14_n71), .ZN(sub_14_n69) );
  INV_X1 sub_14_U89 ( .A(sub_14_n65), .ZN(sub_14_n70) );
  OAI21_X1 sub_14_U88 ( .B1(sub_14_n69), .B2(sub_14_n70), .A(sub_14_n60), .ZN(
        sub_14_n68) );
  INV_X1 sub_14_U87 ( .A(sub_14_n67), .ZN(sub_14_n66) );
  INV_X1 sub_14_U86 ( .A(sub_14_n27), .ZN(sub_14_n55) );
  INV_X1 sub_14_U85 ( .A(sub_14_n51), .ZN(sub_14_n57) );
  NOR2_X1 sub_14_U84 ( .A1(sub_14_n55), .A2(sub_14_n57), .ZN(sub_14_n56) );
  XNOR2_X1 sub_14_U83 ( .A(sub_14_n25), .B(sub_14_n56), .ZN(count1[4]) );
  XNOR2_X1 sub_14_U82 ( .A(sub_14_n52), .B(sub_14_n53), .ZN(count1[5]) );
  INV_X1 sub_14_U81 ( .A(address_plus_b_5_), .ZN(sub_14_n54) );
  NAND2_X1 sub_14_U80 ( .A1(address_plus_b_5_), .A2(sub_14_n30), .ZN(
        sub_14_n33) );
  OAI211_X1 sub_14_U79 ( .C1(sub_14_n11), .C2(sub_14_n30), .A(sub_14_n6), .B(
        address_plus_b_4_), .ZN(sub_14_n35) );
  NAND2_X1 sub_14_U78 ( .A1(sub_14_n43), .A2(sub_14_n42), .ZN(sub_14_n39) );
  INV_X1 sub_14_U77 ( .A(address_plus_b_6_), .ZN(sub_14_n41) );
  NAND2_X1 sub_14_U76 ( .A1(address_plus_b_6_), .A2(sub_14_n31), .ZN(
        sub_14_n34) );
  XNOR2_X1 sub_14_U75 ( .A(sub_14_n17), .B(sub_14_n18), .ZN(count1[8]) );
  NAND2_X1 sub_14_U74 ( .A1(sub_14_n51), .A2(sub_14_n33), .ZN(sub_14_n50) );
  NAND2_X1 sub_14_U73 ( .A1(sub_14_n46), .A2(sub_14_n9), .ZN(sub_14_n53) );
  NAND2_X1 sub_14_U72 ( .A1(sub_14_n39), .A2(sub_14_n26), .ZN(sub_14_n38) );
  XNOR2_X1 sub_14_U71 ( .A(sub_14_n12), .B(sub_14_n40), .ZN(count1[6]) );
  NAND2_X1 sub_14_U70 ( .A1(sub_14_n2), .A2(sub_14_n29), .ZN(sub_14_n22) );
  NAND2_X1 sub_14_U69 ( .A1(offset1_1_), .A2(sub_14_n75), .ZN(sub_14_n63) );
  NAND4_X1 sub_14_U68 ( .A1(sub_14_n66), .A2(sub_14_n63), .A3(sub_14_n65), 
        .A4(sub_14_n64), .ZN(sub_14_n48) );
  NAND2_X1 sub_14_U67 ( .A1(sub_14_n63), .A2(sub_14_n73), .ZN(sub_14_n72) );
  NAND2_X1 sub_14_U66 ( .A1(sub_14_n61), .A2(sub_14_n63), .ZN(sub_14_n74) );
  OAI211_X1 sub_14_U65 ( .C1(sub_14_n59), .C2(sub_14_n10), .A(sub_14_n60), .B(
        sub_14_n61), .ZN(sub_14_n58) );
  INV_X1 sub_14_U64 ( .A(address_plus_b_0_), .ZN(sub_14_n78) );
  NAND2_X1 sub_14_U63 ( .A1(address_plus_b_0_), .A2(sub_14_n79), .ZN(
        sub_14_n59) );
  NAND2_X1 sub_14_U62 ( .A1(sub_14_n48), .A2(sub_14_n49), .ZN(sub_14_n44) );
  OAI211_X1 sub_14_U61 ( .C1(sub_14_n44), .C2(sub_14_n45), .A(sub_14_n46), .B(
        sub_14_n27), .ZN(sub_14_n43) );
  NAND2_X1 sub_14_U60 ( .A1(sub_14_n50), .A2(sub_14_n46), .ZN(sub_14_n42) );
  INV_X1 sub_14_U59 ( .A(offset1_7_), .ZN(sub_14_n29) );
  OAI211_X1 sub_14_U58 ( .C1(sub_14_n20), .C2(sub_14_n21), .A(sub_14_n23), .B(
        sub_14_n22), .ZN(sub_14_n17) );
  INV_X1 sub_14_U57 ( .A(address_plus_b_1_), .ZN(sub_14_n75) );
  NAND2_X1 sub_14_U56 ( .A1(address_plus_b_1_), .A2(sub_14_n76), .ZN(
        sub_14_n61) );
  INV_X1 sub_14_U55 ( .A(sub_14_n47), .ZN(sub_14_n45) );
  NAND2_X1 sub_14_U54 ( .A1(sub_14_n38), .A2(sub_14_n34), .ZN(sub_14_n36) );
  NAND2_X1 sub_14_U53 ( .A1(offset1_6_), .A2(sub_14_n41), .ZN(sub_14_n26) );
  NAND2_X1 sub_14_U52 ( .A1(sub_14_n34), .A2(sub_14_n26), .ZN(sub_14_n40) );
  INV_X1 sub_14_U51 ( .A(offset1_6_), .ZN(sub_14_n31) );
  NAND2_X1 sub_14_U50 ( .A1(sub_14_n15), .A2(sub_14_n32), .ZN(sub_14_n21) );
  OR2_X1 sub_14_U49 ( .A1(sub_14_n16), .A2(sub_14_n31), .ZN(sub_14_n15) );
  XNOR2_X1 sub_14_U48 ( .A(sub_14_n36), .B(sub_14_n37), .ZN(count1[7]) );
  OR2_X1 sub_14_U47 ( .A1(sub_14_n29), .A2(address_plus_b_7_), .ZN(sub_14_n32)
         );
  NAND2_X1 sub_14_U46 ( .A1(address_plus_b_2_), .A2(sub_14_n62), .ZN(
        sub_14_n60) );
  NAND2_X1 sub_14_U45 ( .A1(ptr1[0]), .A2(sub_14_n78), .ZN(sub_14_n77) );
  INV_X1 sub_14_U44 ( .A(ptr1[0]), .ZN(sub_14_n79) );
  NAND2_X1 sub_14_U43 ( .A1(sub_14_n59), .A2(sub_14_n77), .ZN(count1[0]) );
  XNOR2_X1 sub_14_U42 ( .A(sub_14_n73), .B(sub_14_n74), .ZN(count1[1]) );
  AND2_X1 sub_14_U41 ( .A1(sub_14_n49), .A2(sub_14_n3), .ZN(sub_14_n14) );
  XOR2_X1 sub_14_U40 ( .A(sub_14_n68), .B(sub_14_n14), .Z(count1[3]) );
  NAND2_X1 sub_14_U39 ( .A1(sub_14_n67), .A2(sub_14_n59), .ZN(sub_14_n73) );
  INV_X1 sub_14_U38 ( .A(offset1_1_), .ZN(sub_14_n76) );
  NAND2_X1 sub_14_U37 ( .A1(sub_14_n8), .A2(sub_14_n7), .ZN(sub_14_n49) );
  INV_X1 sub_14_U36 ( .A(offset1_2_), .ZN(sub_14_n62) );
  INV_X1 sub_14_U35 ( .A(sub_14_n77), .ZN(sub_14_n67) );
  INV_X1 sub_14_U34 ( .A(offset1_5_), .ZN(sub_14_n30) );
  NAND2_X1 sub_14_U33 ( .A1(sub_14_n72), .A2(sub_14_n61), .ZN(sub_14_n71) );
  INV_X1 sub_14_U32 ( .A(address_plus_b_8_), .ZN(sub_14_n19) );
  INV_X1 sub_14_U31 ( .A(sub_14_n19), .ZN(sub_14_n18) );
  NAND2_X1 sub_14_U30 ( .A1(sub_14_n32), .A2(sub_14_n22), .ZN(sub_14_n37) );
  NAND2_X1 sub_14_U29 ( .A1(address_plus_b_4_), .A2(sub_14_n6), .ZN(sub_14_n51) );
  OAI21_X1 sub_14_U28 ( .B1(sub_14_n55), .B2(sub_14_n25), .A(sub_14_n51), .ZN(
        sub_14_n52) );
  AND2_X1 sub_14_U27 ( .A1(sub_14_n65), .A2(sub_14_n60), .ZN(sub_14_n13) );
  XOR2_X1 sub_14_U26 ( .A(sub_14_n71), .B(sub_14_n13), .Z(count1[2]) );
  CLKBUF_X1 sub_14_U25 ( .A(sub_14_n39), .Z(sub_14_n12) );
  INV_X1 sub_14_U24 ( .A(sub_14_n54), .ZN(sub_14_n11) );
  CLKBUF_X1 sub_14_U23 ( .A(address_plus_b_6_), .Z(sub_14_n16) );
  OR2_X2 sub_14_U22 ( .A1(address_plus_b_5_), .A2(sub_14_n30), .ZN(sub_14_n46)
         );
  AND2_X1 sub_14_U21 ( .A1(offset1_1_), .A2(sub_14_n75), .ZN(sub_14_n10) );
  BUF_X1 sub_14_U20 ( .A(sub_14_n33), .Z(sub_14_n9) );
  CLKBUF_X1 sub_14_U19 ( .A(address_plus_b_3_), .Z(sub_14_n8) );
  INV_X1 sub_14_U18 ( .A(offset1_3_), .ZN(sub_14_n7) );
  NAND3_X1 sub_14_U17 ( .A1(sub_14_n58), .A2(sub_14_n65), .A3(sub_14_n3), .ZN(
        sub_14_n47) );
  AND3_X1 sub_14_U16 ( .A1(sub_14_n35), .A2(sub_14_n33), .A3(sub_14_n34), .ZN(
        sub_14_n20) );
  INV_X1 sub_14_U15 ( .A(offset1_4_), .ZN(sub_14_n6) );
  AND2_X1 sub_14_U14 ( .A1(offset1_5_), .A2(sub_14_n54), .ZN(sub_14_n28) );
  AND3_X2 sub_14_U13 ( .A1(sub_14_n47), .A2(sub_14_n48), .A3(sub_14_n49), .ZN(
        sub_14_n25) );
  INV_X1 sub_14_U12 ( .A(sub_14_n25), .ZN(sub_14_n5) );
  NAND3_X1 sub_14_U11 ( .A1(sub_14_n24), .A2(sub_14_n5), .A3(sub_14_n1), .ZN(
        sub_14_n23) );
  INV_X1 sub_14_U10 ( .A(address_plus_b_7_), .ZN(sub_14_n4) );
  AOI21_X1 sub_14_U9 ( .B1(sub_14_n4), .B2(offset1_7_), .A(sub_14_n28), .ZN(
        sub_14_n24) );
  OR2_X1 sub_14_U8 ( .A1(address_plus_b_2_), .A2(sub_14_n62), .ZN(sub_14_n65)
         );
  OR2_X1 sub_14_U7 ( .A1(address_plus_b_3_), .A2(sub_14_n7), .ZN(sub_14_n64)
         );
  OR2_X1 sub_14_U6 ( .A1(address_plus_b_3_), .A2(sub_14_n7), .ZN(sub_14_n3) );
  CLKBUF_X1 sub_14_U5 ( .A(address_plus_b_7_), .Z(sub_14_n2) );
  AND2_X1 sub_14_U4 ( .A1(sub_14_n26), .A2(sub_14_n27), .ZN(sub_14_n1) );
  OR2_X1 sub_14_U3 ( .A1(address_plus_b_4_), .A2(sub_14_n6), .ZN(sub_14_n27)
         );
endmodule

