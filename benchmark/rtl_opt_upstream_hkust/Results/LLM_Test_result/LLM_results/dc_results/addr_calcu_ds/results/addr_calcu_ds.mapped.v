/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:31:27 2025
/////////////////////////////////////////////////////////////


module addr_calcu_ds ( address, ptr1, ptr2, b, control, count );
  input [7:0] address;
  input [7:0] ptr1;
  input [7:0] ptr2;
  input [7:0] b;
  output [15:0] count;
  input control;
  wire   addr_15, addr_7_, addr_6_, addr_5_, addr_4_, addr_3_, addr_2_,
         addr_1_, addr_0_, n25, n26, n27, n28, n29, n30, n31, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n48, n49, n50,
         n51, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69,
         n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83,
         n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97,
         n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109,
         n110, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120,
         n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, n131,
         n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142,
         n143, n144, n145, sub_12_n81, sub_12_n80, sub_12_n79, sub_12_n78,
         sub_12_n77, sub_12_n76, sub_12_n75, sub_12_n74, sub_12_n73,
         sub_12_n72, sub_12_n71, sub_12_n70, sub_12_n69, sub_12_n68,
         sub_12_n67, sub_12_n66, sub_12_n65, sub_12_n64, sub_12_n63,
         sub_12_n62, sub_12_n61, sub_12_n60, sub_12_n59, sub_12_n58,
         sub_12_n57, sub_12_n56, sub_12_n55, sub_12_n54, sub_12_n53,
         sub_12_n52, sub_12_n51, sub_12_n50, sub_12_n49, sub_12_n48,
         sub_12_n47, sub_12_n46, sub_12_n45, sub_12_n44, sub_12_n43,
         sub_12_n42, sub_12_n41, sub_12_n40, sub_12_n39, sub_12_n38,
         sub_12_n37, sub_12_n36, sub_12_n35, sub_12_n34, sub_12_n33,
         sub_12_n32, sub_12_n31, sub_12_n30, sub_12_n29, sub_12_n28,
         sub_12_n27, sub_12_n26, sub_12_n25, sub_12_n24, sub_12_n23,
         sub_12_n22, sub_12_n21, sub_12_n20, sub_12_n19, sub_12_n18,
         sub_12_n17, sub_12_n16, sub_12_n15, sub_12_n14, sub_12_n13,
         sub_12_n12, sub_12_n11, sub_12_n10, sub_12_n9, sub_12_n7, sub_12_n5,
         sub_12_n4, sub_12_n3, sub_12_n2, sub_12_n1;
  wire   [7:0] offset;

  CLKBUF_X1 U24 ( .A(count[14]), .Z(count[12]) );
  CLKBUF_X1 U25 ( .A(count[14]), .Z(count[11]) );
  AND3_X1 U26 ( .A1(n107), .A2(n26), .A3(n108), .ZN(n25) );
  CLKBUF_X1 U27 ( .A(n127), .Z(n26) );
  BUF_X2 U28 ( .A(addr_7_), .Z(n62) );
  CLKBUF_X1 U29 ( .A(count[13]), .Z(count[15]) );
  CLKBUF_X1 U30 ( .A(count[13]), .Z(count[9]) );
  CLKBUF_X1 U31 ( .A(count[13]), .Z(count[10]) );
  AND3_X1 U32 ( .A1(n81), .A2(n76), .A3(n70), .ZN(n44) );
  AND2_X1 U33 ( .A1(addr_15), .A2(n142), .ZN(n27) );
  INV_X1 U34 ( .A(b[5]), .ZN(n28) );
  OR2_X1 U35 ( .A1(addr_2_), .A2(b[2]), .ZN(n124) );
  XNOR2_X1 U36 ( .A(n134), .B(n28), .ZN(n109) );
  CLKBUF_X1 U37 ( .A(addr_2_), .Z(n29) );
  INV_X1 U38 ( .A(ptr2[1]), .ZN(n30) );
  OR2_X2 U39 ( .A1(addr_3_), .A2(b[3]), .ZN(n119) );
  BUF_X2 U40 ( .A(control), .Z(n31) );
  AND2_X1 U41 ( .A1(n145), .A2(n27), .ZN(count[14]) );
  AND2_X1 U42 ( .A1(n145), .A2(n27), .ZN(count[13]) );
  XNOR2_X1 U43 ( .A(n118), .B(n33), .ZN(count[7]) );
  XNOR2_X1 U44 ( .A(n62), .B(b[7]), .ZN(n33) );
  NAND2_X1 U45 ( .A1(addr_6_), .A2(b[6]), .ZN(n41) );
  INV_X1 U46 ( .A(b[6]), .ZN(n135) );
  BUF_X1 U47 ( .A(addr_3_), .Z(n34) );
  NAND2_X1 U48 ( .A1(addr_5_), .A2(b[5]), .ZN(n40) );
  OR2_X1 U49 ( .A1(addr_15), .A2(n142), .ZN(n35) );
  OR2_X1 U50 ( .A1(n141), .A2(n140), .ZN(n36) );
  NAND3_X1 U51 ( .A1(n139), .A2(n36), .A3(n35), .ZN(count[8]) );
  OR2_X1 U52 ( .A1(b[1]), .A2(addr_1_), .ZN(n37) );
  OR2_X1 U53 ( .A1(n126), .A2(n125), .ZN(n38) );
  NAND3_X1 U54 ( .A1(n37), .A2(n38), .A3(n124), .ZN(n128) );
  AOI22_X2 U55 ( .A1(ptr1[3]), .A2(control), .B1(n87), .B2(ptr2[3]), .ZN(n81)
         );
  INV_X1 U56 ( .A(n64), .ZN(n39) );
  NAND3_X1 U57 ( .A1(n133), .A2(n41), .A3(n40), .ZN(n143) );
  XOR2_X1 U58 ( .A(n42), .B(n46), .Z(count[3]) );
  XOR2_X1 U59 ( .A(n63), .B(b[3]), .Z(n42) );
  OAI221_X1 U60 ( .B1(n134), .B2(n28), .C1(n136), .C2(n135), .A(n133), .ZN(n43) );
  INV_X1 U61 ( .A(addr_15), .ZN(n137) );
  XOR2_X1 U62 ( .A(n73), .B(n74), .Z(offset[6]) );
  XNOR2_X1 U63 ( .A(n45), .B(n81), .ZN(offset[3]) );
  AND2_X1 U64 ( .A1(n79), .A2(n80), .ZN(n45) );
  AND2_X1 U65 ( .A1(n103), .A2(n129), .ZN(n46) );
  OAI211_X1 U66 ( .C1(n91), .C2(n84), .A(n89), .B(n88), .ZN(offset[1]) );
  XNOR2_X1 U67 ( .A(ptr1[1]), .B(ptr1[0]), .ZN(n91) );
  XNOR2_X1 U68 ( .A(n48), .B(n72), .ZN(offset[7]) );
  OR2_X1 U69 ( .A1(n73), .A2(n74), .ZN(n48) );
  XNOR2_X1 U70 ( .A(n111), .B(n49), .ZN(count[6]) );
  XNOR2_X1 U71 ( .A(b[6]), .B(n64), .ZN(n49) );
  XNOR2_X1 U72 ( .A(n50), .B(n100), .ZN(count[4]) );
  XNOR2_X1 U73 ( .A(n66), .B(b[4]), .ZN(n50) );
  XOR2_X1 U74 ( .A(n51), .B(n99), .Z(count[2]) );
  XNOR2_X1 U75 ( .A(n98), .B(b[2]), .ZN(n51) );
  NOR2_X1 U76 ( .A1(n61), .A2(ptr2[1]), .ZN(n85) );
  BUF_X1 U77 ( .A(ptr2[1]), .Z(n57) );
  INV_X1 U78 ( .A(control), .ZN(n58) );
  INV_X1 U79 ( .A(control), .ZN(n59) );
  INV_X1 U80 ( .A(ptr2[0]), .ZN(n60) );
  INV_X1 U81 ( .A(ptr2[0]), .ZN(n61) );
  INV_X1 U82 ( .A(ptr2[0]), .ZN(n86) );
  NAND2_X1 U83 ( .A1(n85), .A2(n87), .ZN(n89) );
  INV_X1 U84 ( .A(control), .ZN(n87) );
  INV_X1 U85 ( .A(control), .ZN(n90) );
  INV_X1 U86 ( .A(control), .ZN(n84) );
  INV_X1 U87 ( .A(n34), .ZN(n63) );
  CLKBUF_X1 U88 ( .A(addr_6_), .Z(n64) );
  OAI211_X1 U89 ( .C1(n62), .C2(b[7]), .A(n137), .B(n144), .ZN(n140) );
  INV_X1 U90 ( .A(n134), .ZN(n65) );
  INV_X1 U91 ( .A(n101), .ZN(n66) );
  NAND2_X1 U92 ( .A1(n138), .A2(n27), .ZN(n139) );
  OAI211_X1 U93 ( .C1(n62), .C2(b[7]), .A(n144), .B(n43), .ZN(n138) );
  MUX2_X1 U94 ( .A(ptr2[6]), .B(ptr1[6]), .S(n31), .Z(n73) );
  MUX2_X1 U95 ( .A(ptr2[4]), .B(ptr1[4]), .S(control), .Z(n77) );
  INV_X1 U96 ( .A(n77), .ZN(n70) );
  INV_X1 U97 ( .A(ptr2[0]), .ZN(n92) );
  INV_X1 U98 ( .A(ptr2[2]), .ZN(n67) );
  NAND4_X1 U99 ( .A1(n59), .A2(n92), .A3(n30), .A4(n67), .ZN(n80) );
  INV_X1 U100 ( .A(ptr1[0]), .ZN(n93) );
  INV_X1 U101 ( .A(ptr1[1]), .ZN(n69) );
  INV_X1 U102 ( .A(ptr1[2]), .ZN(n68) );
  NAND4_X1 U103 ( .A1(n93), .A2(control), .A3(n69), .A4(n68), .ZN(n79) );
  NAND2_X1 U104 ( .A1(n80), .A2(n79), .ZN(n76) );
  MUX2_X1 U105 ( .A(ptr2[5]), .B(ptr1[5]), .S(n31), .Z(n71) );
  INV_X1 U106 ( .A(n71), .ZN(n75) );
  NAND2_X1 U107 ( .A1(n44), .A2(n75), .ZN(n74) );
  MUX2_X1 U108 ( .A(ptr2[7]), .B(ptr1[7]), .S(n31), .Z(n72) );
  XOR2_X1 U109 ( .A(n75), .B(n44), .Z(offset[5]) );
  NAND2_X1 U110 ( .A1(n81), .A2(n76), .ZN(n78) );
  XOR2_X1 U111 ( .A(n78), .B(n77), .Z(offset[4]) );
  OAI33_X1 U112 ( .A1(n57), .A2(control), .A3(ptr2[0]), .B1(n90), .B2(ptr1[1]), 
        .B3(ptr1[0]), .ZN(n83) );
  AOI22_X1 U113 ( .A1(ptr1[2]), .A2(control), .B1(ptr2[2]), .B2(n84), .ZN(n82)
         );
  XOR2_X1 U114 ( .A(n83), .B(n82), .Z(offset[2]) );
  NAND3_X1 U115 ( .A1(n58), .A2(n86), .A3(n57), .ZN(n88) );
  OAI22_X1 U116 ( .A1(n58), .A2(n93), .B1(n31), .B2(n60), .ZN(offset[0]) );
  XOR2_X1 U117 ( .A(b[0]), .B(addr_0_), .Z(count[0]) );
  NAND2_X1 U118 ( .A1(b[0]), .A2(addr_0_), .ZN(n96) );
  INV_X1 U119 ( .A(n96), .ZN(n125) );
  XOR2_X1 U120 ( .A(b[1]), .B(addr_1_), .Z(n94) );
  XOR2_X1 U121 ( .A(n125), .B(n94), .Z(count[1]) );
  INV_X1 U122 ( .A(addr_2_), .ZN(n98) );
  INV_X1 U123 ( .A(b[1]), .ZN(n97) );
  INV_X1 U124 ( .A(addr_1_), .ZN(n95) );
  NAND2_X1 U125 ( .A1(b[1]), .A2(addr_1_), .ZN(n123) );
  OAI221_X1 U126 ( .B1(n97), .B2(n96), .C1(n95), .C2(n96), .A(n123), .ZN(n99)
         );
  NAND2_X1 U127 ( .A1(n99), .A2(n124), .ZN(n103) );
  NAND2_X1 U128 ( .A1(b[2]), .A2(n29), .ZN(n129) );
  INV_X1 U129 ( .A(n119), .ZN(n122) );
  NAND2_X1 U130 ( .A1(b[3]), .A2(n34), .ZN(n130) );
  OAI21_X1 U131 ( .B1(n46), .B2(n122), .A(n130), .ZN(n100) );
  INV_X1 U132 ( .A(addr_5_), .ZN(n134) );
  INV_X1 U133 ( .A(n129), .ZN(n102) );
  INV_X1 U134 ( .A(addr_4_), .ZN(n101) );
  INV_X1 U135 ( .A(b[4]), .ZN(n121) );
  NAND2_X1 U136 ( .A1(n101), .A2(n121), .ZN(n104) );
  NAND3_X1 U137 ( .A1(n104), .A2(n119), .A3(n102), .ZN(n108) );
  NAND2_X1 U138 ( .A1(addr_4_), .A2(b[4]), .ZN(n127) );
  INV_X1 U139 ( .A(n130), .ZN(n106) );
  INV_X1 U140 ( .A(n103), .ZN(n105) );
  OAI211_X1 U141 ( .C1(n106), .C2(n105), .A(n104), .B(n119), .ZN(n107) );
  NAND3_X1 U142 ( .A1(n107), .A2(n26), .A3(n108), .ZN(n112) );
  XOR2_X1 U143 ( .A(n25), .B(n109), .Z(count[5]) );
  NAND2_X1 U144 ( .A1(n134), .A2(n28), .ZN(n113) );
  INV_X1 U145 ( .A(n113), .ZN(n110) );
  NAND2_X1 U146 ( .A1(b[5]), .A2(n65), .ZN(n116) );
  OAI21_X1 U147 ( .B1(n25), .B2(n110), .A(n116), .ZN(n111) );
  INV_X1 U148 ( .A(addr_6_), .ZN(n136) );
  NAND2_X1 U149 ( .A1(n136), .A2(n135), .ZN(n114) );
  INV_X1 U150 ( .A(n114), .ZN(n117) );
  NAND3_X1 U151 ( .A1(n112), .A2(n113), .A3(n114), .ZN(n115) );
  OAI221_X1 U152 ( .B1(n39), .B2(n135), .C1(n117), .C2(n116), .A(n115), .ZN(
        n118) );
  NAND2_X1 U153 ( .A1(addr_7_), .A2(b[7]), .ZN(n142) );
  OAI21_X1 U154 ( .B1(b[4]), .B2(n119), .A(addr_4_), .ZN(n120) );
  OAI21_X1 U155 ( .B1(n122), .B2(n121), .A(n120), .ZN(n132) );
  INV_X1 U156 ( .A(n123), .ZN(n126) );
  NAND4_X1 U157 ( .A1(n127), .A2(n129), .A3(n128), .A4(n130), .ZN(n131) );
  OAI211_X1 U158 ( .C1(addr_5_), .C2(b[5]), .A(n131), .B(n132), .ZN(n133) );
  INV_X1 U159 ( .A(n43), .ZN(n141) );
  NAND2_X1 U160 ( .A1(n136), .A2(n135), .ZN(n144) );
  OAI211_X1 U161 ( .C1(n62), .C2(b[7]), .A(n143), .B(n144), .ZN(n145) );
  INV_X1 sub_12_U91 ( .A(sub_12_n57), .ZN(sub_12_n75) );
  INV_X1 sub_12_U90 ( .A(sub_12_n65), .ZN(sub_12_n80) );
  INV_X1 sub_12_U89 ( .A(sub_12_n62), .ZN(sub_12_n72) );
  NAND3_X1 sub_12_U88 ( .A1(sub_12_n67), .A2(sub_12_n66), .A3(sub_12_n65), 
        .ZN(sub_12_n63) );
  INV_X1 sub_12_U87 ( .A(sub_12_n23), .ZN(sub_12_n42) );
  NAND3_X1 sub_12_U86 ( .A1(sub_12_n16), .A2(sub_12_n34), .A3(sub_12_n10), 
        .ZN(sub_12_n33) );
  NAND3_X1 sub_12_U85 ( .A1(sub_12_n20), .A2(sub_12_n32), .A3(sub_12_n33), 
        .ZN(sub_12_n28) );
  INV_X1 sub_12_U84 ( .A(sub_12_n24), .ZN(sub_12_n22) );
  NAND2_X1 sub_12_U83 ( .A1(offset[3]), .A2(sub_12_n70), .ZN(sub_12_n67) );
  INV_X1 sub_12_U82 ( .A(offset[3]), .ZN(sub_12_n69) );
  NAND2_X1 sub_12_U81 ( .A1(sub_12_n78), .A2(offset[2]), .ZN(sub_12_n55) );
  NAND2_X1 sub_12_U80 ( .A1(sub_12_n27), .A2(sub_12_n2), .ZN(sub_12_n47) );
  INV_X1 sub_12_U79 ( .A(sub_12_n10), .ZN(sub_12_n41) );
  XNOR2_X1 sub_12_U78 ( .A(sub_12_n2), .B(sub_12_n48), .ZN(addr_4_) );
  AOI21_X1 sub_12_U77 ( .B1(sub_12_n10), .B2(sub_12_n11), .A(sub_12_n12), .ZN(
        addr_15) );
  NAND2_X1 sub_12_U76 ( .A1(sub_12_n62), .A2(sub_12_n9), .ZN(sub_12_n73) );
  AOI21_X1 sub_12_U75 ( .B1(sub_12_n9), .B2(sub_12_n71), .A(sub_12_n72), .ZN(
        sub_12_n68) );
  OAI211_X1 sub_12_U74 ( .C1(sub_12_n41), .C2(sub_12_n25), .A(sub_12_n21), .B(
        sub_12_n36), .ZN(sub_12_n37) );
  NOR2_X1 sub_12_U73 ( .A1(sub_12_n1), .A2(sub_12_n62), .ZN(sub_12_n61) );
  NAND2_X1 sub_12_U72 ( .A1(sub_12_n51), .A2(sub_12_n52), .ZN(sub_12_n10) );
  INV_X1 sub_12_U71 ( .A(offset[6]), .ZN(sub_12_n39) );
  XNOR2_X1 sub_12_U70 ( .A(sub_12_n37), .B(sub_12_n38), .ZN(addr_6_) );
  AOI21_X1 sub_12_U69 ( .B1(sub_12_n54), .B2(sub_12_n53), .A(sub_12_n7), .ZN(
        sub_12_n52) );
  NOR2_X1 sub_12_U68 ( .A1(sub_12_n60), .A2(sub_12_n61), .ZN(sub_12_n51) );
  NAND2_X1 sub_12_U67 ( .A1(sub_12_n74), .A2(sub_12_n56), .ZN(sub_12_n71) );
  AOI21_X1 sub_12_U66 ( .B1(sub_12_n56), .B2(sub_12_n57), .A(sub_12_n58), .ZN(
        sub_12_n53) );
  INV_X1 sub_12_U65 ( .A(offset[5]), .ZN(sub_12_n45) );
  NAND2_X1 sub_12_U64 ( .A1(sub_12_n46), .A2(offset[5]), .ZN(sub_12_n24) );
  XNOR2_X1 sub_12_U63 ( .A(sub_12_n28), .B(sub_12_n29), .ZN(addr_7_) );
  NAND2_X1 sub_12_U62 ( .A1(sub_12_n47), .A2(sub_12_n23), .ZN(sub_12_n43) );
  NOR2_X1 sub_12_U61 ( .A1(sub_12_n64), .A2(sub_12_n63), .ZN(sub_12_n60) );
  INV_X1 sub_12_U60 ( .A(address[2]), .ZN(sub_12_n78) );
  OR2_X1 sub_12_U59 ( .A1(sub_12_n78), .A2(offset[2]), .ZN(sub_12_n62) );
  INV_X1 sub_12_U57 ( .A(address[0]), .ZN(sub_12_n77) );
  INV_X1 sub_12_U56 ( .A(address[4]), .ZN(sub_12_n50) );
  NAND2_X1 sub_12_U55 ( .A1(offset[4]), .A2(sub_12_n50), .ZN(sub_12_n27) );
  INV_X1 sub_12_U54 ( .A(offset[0]), .ZN(sub_12_n81) );
  NAND2_X1 sub_12_U53 ( .A1(address[0]), .A2(sub_12_n81), .ZN(sub_12_n57) );
  NAND2_X1 sub_12_U52 ( .A1(address[5]), .A2(sub_12_n45), .ZN(sub_12_n21) );
  INV_X1 sub_12_U51 ( .A(offset[7]), .ZN(sub_12_n31) );
  NAND2_X1 sub_12_U50 ( .A1(address[7]), .A2(sub_12_n31), .ZN(sub_12_n15) );
  INV_X1 sub_12_U49 ( .A(offset[4]), .ZN(sub_12_n49) );
  NAND2_X1 sub_12_U48 ( .A1(address[4]), .A2(sub_12_n49), .ZN(sub_12_n23) );
  NOR2_X1 sub_12_U47 ( .A1(address[1]), .A2(sub_12_n59), .ZN(sub_12_n58) );
  INV_X1 sub_12_U46 ( .A(address[6]), .ZN(sub_12_n40) );
  NAND2_X1 sub_12_U45 ( .A1(offset[6]), .A2(sub_12_n40), .ZN(sub_12_n16) );
  INV_X1 sub_12_U44 ( .A(address[1]), .ZN(sub_12_n79) );
  NAND2_X1 sub_12_U43 ( .A1(offset[1]), .A2(sub_12_n79), .ZN(sub_12_n66) );
  INV_X1 sub_12_U42 ( .A(address[7]), .ZN(sub_12_n30) );
  NAND2_X1 sub_12_U41 ( .A1(offset[7]), .A2(sub_12_n30), .ZN(sub_12_n17) );
  NAND2_X1 sub_12_U40 ( .A1(address[1]), .A2(sub_12_n59), .ZN(sub_12_n56) );
  INV_X1 sub_12_U39 ( .A(address[5]), .ZN(sub_12_n46) );
  AND2_X1 sub_12_U38 ( .A1(address[3]), .A2(sub_12_n69), .ZN(sub_12_n7) );
  INV_X1 sub_12_U37 ( .A(address[3]), .ZN(sub_12_n70) );
  NAND2_X1 sub_12_U36 ( .A1(address[6]), .A2(sub_12_n39), .ZN(sub_12_n20) );
  NAND2_X1 sub_12_U35 ( .A1(offset[0]), .A2(sub_12_n77), .ZN(sub_12_n65) );
  OR2_X1 sub_12_U34 ( .A1(sub_12_n75), .A2(sub_12_n80), .ZN(addr_0_) );
  NAND2_X1 sub_12_U33 ( .A1(sub_12_n17), .A2(sub_12_n16), .ZN(sub_12_n26) );
  NAND2_X1 sub_12_U32 ( .A1(sub_12_n16), .A2(sub_12_n17), .ZN(sub_12_n14) );
  INV_X1 sub_12_U31 ( .A(offset[1]), .ZN(sub_12_n59) );
  NAND2_X1 sub_12_U30 ( .A1(offset[0]), .A2(sub_12_n77), .ZN(sub_12_n76) );
  NAND2_X1 sub_12_U29 ( .A1(sub_12_n76), .A2(sub_12_n66), .ZN(sub_12_n74) );
  NAND2_X1 sub_12_U28 ( .A1(sub_12_n16), .A2(sub_12_n20), .ZN(sub_12_n38) );
  NAND2_X1 sub_12_U27 ( .A1(sub_12_n36), .A2(sub_12_n21), .ZN(sub_12_n35) );
  NAND2_X1 sub_12_U26 ( .A1(sub_12_n35), .A2(sub_12_n16), .ZN(sub_12_n32) );
  NAND2_X1 sub_12_U25 ( .A1(sub_12_n42), .A2(sub_12_n24), .ZN(sub_12_n36) );
  NAND2_X1 sub_12_U24 ( .A1(sub_12_n15), .A2(sub_12_n17), .ZN(sub_12_n29) );
  NAND2_X1 sub_12_U23 ( .A1(sub_12_n24), .A2(sub_12_n21), .ZN(sub_12_n44) );
  NAND2_X1 sub_12_U22 ( .A1(sub_12_n27), .A2(sub_12_n23), .ZN(sub_12_n48) );
  NAND2_X1 sub_12_U21 ( .A1(sub_12_n20), .A2(sub_12_n21), .ZN(sub_12_n19) );
  NOR2_X1 sub_12_U20 ( .A1(sub_12_n22), .A2(sub_12_n23), .ZN(sub_12_n18) );
  NOR2_X1 sub_12_U19 ( .A1(sub_12_n18), .A2(sub_12_n19), .ZN(sub_12_n13) );
  NAND2_X1 sub_12_U18 ( .A1(sub_12_n27), .A2(sub_12_n24), .ZN(sub_12_n25) );
  OAI21_X1 sub_12_U17 ( .B1(sub_12_n13), .B2(sub_12_n14), .A(sub_12_n15), .ZN(
        sub_12_n12) );
  NOR2_X1 sub_12_U16 ( .A1(sub_12_n25), .A2(sub_12_n26), .ZN(sub_12_n11) );
  INV_X1 sub_12_U15 ( .A(sub_12_n25), .ZN(sub_12_n34) );
  XNOR2_X1 sub_12_U14 ( .A(sub_12_n73), .B(sub_12_n71), .ZN(addr_2_) );
  NAND2_X1 sub_12_U13 ( .A1(sub_12_n66), .A2(sub_12_n56), .ZN(sub_12_n5) );
  NAND2_X1 sub_12_U12 ( .A1(sub_12_n80), .A2(sub_12_n57), .ZN(sub_12_n4) );
  XNOR2_X1 sub_12_U11 ( .A(sub_12_n4), .B(sub_12_n5), .ZN(addr_1_) );
  NOR2_X1 sub_12_U10 ( .A1(sub_12_n1), .A2(sub_12_n7), .ZN(sub_12_n3) );
  XNOR2_X1 sub_12_U9 ( .A(sub_12_n68), .B(sub_12_n3), .ZN(addr_3_) );
  NAND2_X1 sub_12_U8 ( .A1(sub_12_n51), .A2(sub_12_n52), .ZN(sub_12_n2) );
  AND2_X1 sub_12_U7 ( .A1(sub_12_n55), .A2(sub_12_n67), .ZN(sub_12_n54) );
  AND2_X1 sub_12_U6 ( .A1(offset[3]), .A2(sub_12_n70), .ZN(sub_12_n1) );
  CLKBUF_X1 sub_12_U5 ( .A(sub_12_n55), .Z(sub_12_n9) );
  XNOR2_X1 sub_12_U4 ( .A(sub_12_n43), .B(sub_12_n44), .ZN(addr_5_) );
  NAND2_X1 sub_12_U3 ( .A1(sub_12_n55), .A2(1'b1), .ZN(sub_12_n64) );
endmodule

