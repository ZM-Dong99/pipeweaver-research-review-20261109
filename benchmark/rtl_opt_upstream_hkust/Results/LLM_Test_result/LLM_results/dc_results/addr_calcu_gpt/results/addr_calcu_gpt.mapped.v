/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:32:48 2025
/////////////////////////////////////////////////////////////


module addr_calcu_gpt ( address, ptr1, ptr2, b, control, count );
  input [7:0] address;
  input [7:0] ptr1;
  input [7:0] ptr2;
  input [7:0] b;
  output [15:0] count;
  input control;
  wire   offset1_7_, offset1_6_, offset1_5_, offset1_4_, offset1_3_,
         offset1_2_, offset1_1_, offset2_7_, offset2_6_, offset2_5_,
         offset2_4_, offset2_3_, offset2_2_, offset2_1_, addr2_15, addr2_7_,
         addr2_6_, addr2_5_, addr2_4_, addr2_3_, addr2_2_, addr2_1_, addr2_0_,
         addr1_15, addr1_7_, addr1_6_, addr1_5_, addr1_4_, addr1_3_, addr1_2_,
         addr1_1_, addr1_0_, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55,
         n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69,
         n70, n71, n72, n74, n75, n76, n77, n78, n79, n80, n81, n83, n84, n85,
         n86, n87, n88, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136,
         n137, n138, n139, n140, n141, n142, n143, n144, n145, n146, n147,
         n148, n149, n150, n151, n152, n153, n154, n155, n156, n157, n158,
         n159, n160, n161, n162, n163, n164, n165, n166, n167, n168, n169,
         n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180,
         n181, n182, n183, n184, n185, n186, n187, n188, n189, n190, n191,
         n192, n193, n194, n195, n196, n197, n198, n199, n200, n201, n202,
         n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, n213,
         n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, n224,
         n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235,
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246,
         sub_14_n82, sub_14_n81, sub_14_n80, sub_14_n79, sub_14_n78,
         sub_14_n77, sub_14_n76, sub_14_n75, sub_14_n74, sub_14_n73,
         sub_14_n72, sub_14_n71, sub_14_n70, sub_14_n69, sub_14_n68,
         sub_14_n67, sub_14_n66, sub_14_n65, sub_14_n64, sub_14_n63,
         sub_14_n62, sub_14_n61, sub_14_n60, sub_14_n59, sub_14_n58,
         sub_14_n57, sub_14_n56, sub_14_n55, sub_14_n54, sub_14_n53,
         sub_14_n52, sub_14_n51, sub_14_n50, sub_14_n49, sub_14_n48,
         sub_14_n47, sub_14_n46, sub_14_n45, sub_14_n44, sub_14_n43,
         sub_14_n42, sub_14_n41, sub_14_n40, sub_14_n39, sub_14_n38,
         sub_14_n37, sub_14_n36, sub_14_n35, sub_14_n34, sub_14_n33,
         sub_14_n32, sub_14_n31, sub_14_n30, sub_14_n29, sub_14_n28,
         sub_14_n27, sub_14_n26, sub_14_n25, sub_14_n24, sub_14_n23,
         sub_14_n22, sub_14_n21, sub_14_n20, sub_14_n19, sub_14_n18,
         sub_14_n17, sub_14_n16, sub_14_n15, sub_14_n14, sub_14_n13,
         sub_14_n12, sub_14_n11, sub_14_n10, sub_14_n9, sub_14_n8, sub_14_n7,
         sub_14_n6, sub_14_n5, sub_14_n4, sub_14_n3, sub_14_n2, sub_14_n1,
         sub_13_n77, sub_13_n76, sub_13_n75, sub_13_n74, sub_13_n73,
         sub_13_n72, sub_13_n71, sub_13_n70, sub_13_n69, sub_13_n68,
         sub_13_n67, sub_13_n66, sub_13_n65, sub_13_n64, sub_13_n63,
         sub_13_n62, sub_13_n61, sub_13_n60, sub_13_n59, sub_13_n58,
         sub_13_n57, sub_13_n56, sub_13_n55, sub_13_n54, sub_13_n53,
         sub_13_n52, sub_13_n51, sub_13_n50, sub_13_n49, sub_13_n48,
         sub_13_n47, sub_13_n46, sub_13_n45, sub_13_n44, sub_13_n43,
         sub_13_n42, sub_13_n41, sub_13_n40, sub_13_n39, sub_13_n38,
         sub_13_n37, sub_13_n36, sub_13_n35, sub_13_n34, sub_13_n33,
         sub_13_n32, sub_13_n31, sub_13_n30, sub_13_n29, sub_13_n28,
         sub_13_n27, sub_13_n26, sub_13_n25, sub_13_n24, sub_13_n23,
         sub_13_n22, sub_13_n21, sub_13_n20, sub_13_n19, sub_13_n18,
         sub_13_n17, sub_13_n16, sub_13_n15, sub_13_n14, sub_13_n13,
         sub_13_n12, sub_13_n11, sub_13_n10, sub_13_n9, sub_13_n8, sub_13_n7,
         sub_13_n6, sub_13_n5, sub_13_n4, sub_13_n3, sub_13_n2, sub_13_n1;

  INV_X1 U42 ( .A(ptr1[2]), .ZN(n46) );
  CLKBUF_X1 U43 ( .A(n173), .Z(n47) );
  MUX2_X1 U44 ( .A(n162), .B(n163), .S(n48), .Z(count[5]) );
  INV_X32 U45 ( .A(control), .ZN(n48) );
  AND2_X1 U46 ( .A1(addr2_15), .A2(n239), .ZN(n49) );
  INV_X1 U47 ( .A(ptr2[3]), .ZN(n105) );
  OR2_X1 U48 ( .A1(n112), .A2(ptr1[5]), .ZN(n111) );
  AND2_X1 U49 ( .A1(n232), .A2(n233), .ZN(n50) );
  INV_X1 U50 ( .A(b[4]), .ZN(n51) );
  XNOR2_X1 U51 ( .A(n68), .B(n51), .ZN(n52) );
  XNOR2_X1 U52 ( .A(n52), .B(n56), .ZN(n158) );
  AND2_X1 U53 ( .A1(n173), .A2(n172), .ZN(n53) );
  AND2_X1 U54 ( .A1(n182), .A2(n181), .ZN(n81) );
  CLKBUF_X1 U55 ( .A(addr1_2_), .Z(n54) );
  BUF_X1 U56 ( .A(ptr1[0]), .Z(n55) );
  AND2_X1 U57 ( .A1(n166), .A2(n165), .ZN(n56) );
  OR2_X2 U58 ( .A1(addr2_4_), .A2(b[4]), .ZN(n194) );
  XNOR2_X1 U59 ( .A(n80), .B(b[5]), .ZN(n58) );
  CLKBUF_X1 U60 ( .A(addr2_3_), .Z(n57) );
  XNOR2_X1 U61 ( .A(n161), .B(n58), .ZN(n162) );
  XNOR2_X1 U62 ( .A(n59), .B(n159), .ZN(n163) );
  XNOR2_X1 U63 ( .A(n94), .B(b[5]), .ZN(n59) );
  XOR2_X1 U64 ( .A(n60), .B(ptr1[3]), .Z(offset1_3_) );
  NAND3_X1 U65 ( .A1(n116), .A2(n114), .A3(n115), .ZN(n60) );
  AND2_X1 U66 ( .A1(n79), .A2(n180), .ZN(n61) );
  XNOR2_X1 U67 ( .A(b[7]), .B(addr2_7_), .ZN(n201) );
  INV_X1 U68 ( .A(ptr2[1]), .ZN(n62) );
  AND2_X1 U69 ( .A1(n101), .A2(n194), .ZN(n168) );
  AND2_X1 U70 ( .A1(n193), .A2(n194), .ZN(n63) );
  INV_X1 U71 ( .A(ptr2[0]), .ZN(n64) );
  XNOR2_X1 U72 ( .A(n187), .B(n65), .ZN(n203) );
  XNOR2_X1 U73 ( .A(addr1_7_), .B(b[7]), .ZN(n65) );
  NAND2_X1 U74 ( .A1(n216), .A2(n215), .ZN(n66) );
  OAI21_X1 U75 ( .B1(n192), .B2(n191), .A(n190), .ZN(n67) );
  CLKBUF_X1 U76 ( .A(addr2_4_), .Z(n68) );
  NAND2_X1 U77 ( .A1(n209), .A2(n208), .ZN(n69) );
  CLKBUF_X1 U78 ( .A(addr1_6_), .Z(n70) );
  INV_X1 U79 ( .A(n220), .ZN(n71) );
  XNOR2_X1 U80 ( .A(n107), .B(n105), .ZN(offset2_3_) );
  CLKBUF_X1 U81 ( .A(addr2_5_), .Z(n94) );
  XNOR2_X1 U82 ( .A(n169), .B(n72), .ZN(n179) );
  XOR2_X1 U83 ( .A(addr2_6_), .B(b[6]), .Z(n72) );
  AND3_X1 U84 ( .A1(n245), .A2(n246), .A3(n244), .ZN(count[14]) );
  AND3_X1 U85 ( .A1(n245), .A2(n246), .A3(n244), .ZN(count[13]) );
  NOR2_X1 U86 ( .A1(ptr1[0]), .A2(ptr1[1]), .ZN(n75) );
  INV_X1 U87 ( .A(ptr1[0]), .ZN(n74) );
  XNOR2_X1 U88 ( .A(n75), .B(ptr1[2]), .ZN(offset1_2_) );
  BUF_X1 U89 ( .A(count[13]), .Z(count[12]) );
  BUF_X1 U90 ( .A(count[13]), .Z(count[11]) );
  BUF_X1 U91 ( .A(count[14]), .Z(count[10]) );
  BUF_X1 U92 ( .A(count[14]), .Z(count[9]) );
  BUF_X1 U93 ( .A(count[14]), .Z(count[15]) );
  BUF_X1 U94 ( .A(ptr2[0]), .Z(n76) );
  CLKBUF_X1 U95 ( .A(addr1_3_), .Z(n77) );
  CLKBUF_X1 U96 ( .A(n57), .Z(n78) );
  OR2_X1 U97 ( .A1(addr1_6_), .A2(b[6]), .ZN(n79) );
  NAND2_X1 U98 ( .A1(n79), .A2(n180), .ZN(n213) );
  INV_X1 U99 ( .A(n96), .ZN(n80) );
  INV_X1 U100 ( .A(n224), .ZN(n226) );
  NAND2_X1 U101 ( .A1(n231), .A2(n230), .ZN(n232) );
  NOR2_X1 U102 ( .A1(n229), .A2(n212), .ZN(n217) );
  AND3_X1 U103 ( .A1(n98), .A2(n108), .A3(n106), .ZN(n83) );
  XNOR2_X1 U104 ( .A(n84), .B(ptr2[4]), .ZN(offset2_4_) );
  AND2_X1 U105 ( .A1(n83), .A2(n105), .ZN(n84) );
  OR2_X1 U106 ( .A1(n104), .A2(ptr2[5]), .ZN(n103) );
  XNOR2_X1 U107 ( .A(ptr2[7]), .B(n85), .ZN(offset2_7_) );
  OR2_X1 U108 ( .A1(ptr2[6]), .A2(n103), .ZN(n85) );
  XNOR2_X1 U109 ( .A(n109), .B(n106), .ZN(offset2_2_) );
  OR2_X1 U110 ( .A1(n113), .A2(ptr1[4]), .ZN(n112) );
  NAND2_X1 U111 ( .A1(b[7]), .A2(n229), .ZN(n230) );
  XNOR2_X1 U112 ( .A(ptr1[7]), .B(n86), .ZN(offset1_7_) );
  OR2_X1 U113 ( .A1(ptr1[6]), .A2(n111), .ZN(n86) );
  AOI21_X1 U114 ( .B1(n221), .B2(n220), .A(n224), .ZN(n223) );
  INV_X1 U115 ( .A(b[7]), .ZN(n221) );
  AND2_X1 U116 ( .A1(b[0]), .A2(addr2_0_), .ZN(n87) );
  AND2_X1 U117 ( .A1(addr1_0_), .A2(b[0]), .ZN(n88) );
  AOI22_X1 U118 ( .A1(n227), .A2(n226), .B1(n225), .B2(n49), .ZN(n233) );
  NOR2_X1 U119 ( .A1(n220), .A2(n240), .ZN(n227) );
  NOR2_X1 U120 ( .A1(addr2_7_), .A2(b[7]), .ZN(n225) );
  INV_X1 U121 ( .A(addr2_7_), .ZN(n220) );
  OAI21_X1 U122 ( .B1(addr1_7_), .B2(n242), .A(n228), .ZN(n231) );
  INV_X1 U123 ( .A(ptr2[1]), .ZN(n95) );
  NAND3_X1 U124 ( .A1(n235), .A2(n234), .A3(n50), .ZN(count[8]) );
  INV_X1 U125 ( .A(addr1_5_), .ZN(n96) );
  INV_X1 U126 ( .A(ptr2[2]), .ZN(n97) );
  INV_X1 U127 ( .A(n237), .ZN(n212) );
  INV_X1 U128 ( .A(ptr2[1]), .ZN(n98) );
  AND2_X1 U129 ( .A1(n191), .A2(n96), .ZN(n99) );
  INV_X1 U130 ( .A(ptr2[0]), .ZN(n100) );
  OR2_X1 U131 ( .A1(n94), .A2(b[5]), .ZN(n101) );
  OR2_X1 U132 ( .A1(addr2_5_), .A2(b[5]), .ZN(n188) );
  NAND2_X1 U133 ( .A1(n209), .A2(n208), .ZN(n238) );
  OAI21_X1 U134 ( .B1(n67), .B2(n63), .A(n206), .ZN(n209) );
  NOR3_X1 U135 ( .A1(n66), .A2(n242), .A3(n243), .ZN(n222) );
  AOI21_X1 U136 ( .B1(n223), .B2(n69), .A(n222), .ZN(n234) );
  AOI22_X1 U137 ( .A1(n218), .A2(n49), .B1(n66), .B2(n217), .ZN(n235) );
  AOI21_X1 U138 ( .B1(n71), .B2(b[7]), .A(n69), .ZN(n218) );
  INV_X1 U139 ( .A(ptr2[0]), .ZN(n108) );
  INV_X1 U140 ( .A(ptr2[2]), .ZN(n106) );
  INV_X1 U141 ( .A(ptr2[4]), .ZN(n102) );
  NAND3_X1 U142 ( .A1(n83), .A2(n105), .A3(n102), .ZN(n104) );
  XOR2_X1 U143 ( .A(n103), .B(ptr2[6]), .Z(offset2_6_) );
  XOR2_X1 U144 ( .A(n104), .B(ptr2[5]), .Z(offset2_5_) );
  NAND3_X1 U145 ( .A1(n100), .A2(n95), .A3(n97), .ZN(n107) );
  NAND2_X1 U146 ( .A1(n62), .A2(n64), .ZN(n109) );
  XOR2_X1 U147 ( .A(ptr2[0]), .B(ptr2[1]), .Z(offset2_1_) );
  INV_X1 U148 ( .A(ptr1[1]), .ZN(n116) );
  INV_X1 U149 ( .A(ptr1[0]), .ZN(n115) );
  INV_X1 U150 ( .A(ptr1[2]), .ZN(n114) );
  INV_X1 U151 ( .A(ptr1[3]), .ZN(n110) );
  NAND4_X1 U152 ( .A1(n116), .A2(n74), .A3(n46), .A4(n110), .ZN(n113) );
  XOR2_X1 U153 ( .A(n111), .B(ptr1[6]), .Z(offset1_6_) );
  XOR2_X1 U154 ( .A(n112), .B(ptr1[5]), .Z(offset1_5_) );
  XOR2_X1 U155 ( .A(n113), .B(ptr1[4]), .Z(offset1_4_) );
  XOR2_X1 U156 ( .A(ptr1[0]), .B(ptr1[1]), .Z(offset1_1_) );
  XOR2_X1 U157 ( .A(b[0]), .B(addr2_0_), .Z(n118) );
  XOR2_X1 U158 ( .A(addr1_0_), .B(b[0]), .Z(n117) );
  MUX2_X1 U159 ( .A(n118), .B(n117), .S(control), .Z(count[0]) );
  XOR2_X1 U160 ( .A(b[1]), .B(addr2_1_), .Z(n119) );
  XOR2_X1 U161 ( .A(n87), .B(n119), .Z(n122) );
  XOR2_X1 U162 ( .A(addr1_1_), .B(b[1]), .Z(n120) );
  XOR2_X1 U163 ( .A(n88), .B(n120), .Z(n121) );
  MUX2_X1 U164 ( .A(n122), .B(n121), .S(control), .Z(count[1]) );
  INV_X1 U165 ( .A(addr2_2_), .ZN(n132) );
  XOR2_X1 U166 ( .A(n132), .B(b[2]), .Z(n125) );
  INV_X1 U167 ( .A(addr2_1_), .ZN(n124) );
  INV_X1 U168 ( .A(b[1]), .ZN(n128) );
  OAI21_X1 U169 ( .B1(b[1]), .B2(addr2_1_), .A(n87), .ZN(n123) );
  OAI21_X1 U170 ( .B1(n124), .B2(n128), .A(n123), .ZN(n149) );
  INV_X1 U171 ( .A(n149), .ZN(n133) );
  XOR2_X1 U172 ( .A(n125), .B(n133), .Z(n131) );
  INV_X1 U173 ( .A(b[2]), .ZN(n138) );
  XOR2_X1 U174 ( .A(n138), .B(n54), .Z(n129) );
  INV_X1 U175 ( .A(addr1_1_), .ZN(n127) );
  OAI21_X1 U176 ( .B1(addr1_1_), .B2(b[1]), .A(n88), .ZN(n126) );
  OAI21_X1 U177 ( .B1(n128), .B2(n127), .A(n126), .ZN(n155) );
  INV_X1 U178 ( .A(n155), .ZN(n139) );
  XOR2_X1 U179 ( .A(n129), .B(n139), .Z(n130) );
  MUX2_X1 U180 ( .A(n131), .B(n130), .S(control), .Z(count[2]) );
  NAND2_X1 U181 ( .A1(n132), .A2(n138), .ZN(n148) );
  INV_X1 U182 ( .A(n148), .ZN(n134) );
  NAND2_X1 U183 ( .A1(b[2]), .A2(addr2_2_), .ZN(n146) );
  OAI21_X1 U184 ( .B1(n134), .B2(n133), .A(n146), .ZN(n136) );
  XOR2_X1 U185 ( .A(b[3]), .B(n78), .Z(n135) );
  XOR2_X1 U186 ( .A(n136), .B(n135), .Z(n144) );
  INV_X1 U187 ( .A(addr1_2_), .ZN(n137) );
  NAND2_X1 U188 ( .A1(n138), .A2(n137), .ZN(n154) );
  INV_X1 U189 ( .A(n154), .ZN(n140) );
  NAND2_X1 U190 ( .A1(b[2]), .A2(addr1_2_), .ZN(n151) );
  OAI21_X1 U191 ( .B1(n140), .B2(n139), .A(n151), .ZN(n142) );
  XOR2_X1 U192 ( .A(n77), .B(b[3]), .Z(n141) );
  XOR2_X1 U193 ( .A(n142), .B(n141), .Z(n143) );
  MUX2_X1 U194 ( .A(n144), .B(n143), .S(control), .Z(count[3]) );
  INV_X1 U195 ( .A(b[3]), .ZN(n152) );
  INV_X1 U196 ( .A(addr2_3_), .ZN(n145) );
  OAI222_X1 U197 ( .A1(n152), .A2(n146), .B1(n145), .B2(n152), .C1(n145), .C2(
        n146), .ZN(n147) );
  INV_X1 U198 ( .A(n147), .ZN(n166) );
  OAI211_X1 U199 ( .C1(b[3]), .C2(n57), .A(n149), .B(n148), .ZN(n165) );
  NAND2_X1 U200 ( .A1(n166), .A2(n165), .ZN(n193) );
  XOR2_X1 U201 ( .A(n51), .B(addr1_4_), .Z(n156) );
  INV_X1 U202 ( .A(addr1_3_), .ZN(n150) );
  OAI222_X1 U203 ( .A1(n152), .A2(n151), .B1(n150), .B2(n152), .C1(n150), .C2(
        n151), .ZN(n153) );
  INV_X1 U204 ( .A(n153), .ZN(n173) );
  OAI211_X1 U205 ( .C1(n77), .C2(b[3]), .A(n155), .B(n154), .ZN(n172) );
  NAND2_X1 U206 ( .A1(n173), .A2(n172), .ZN(n181) );
  XOR2_X1 U207 ( .A(n156), .B(n53), .Z(n157) );
  MUX2_X1 U208 ( .A(n158), .B(n157), .S(control), .Z(count[4]) );
  INV_X1 U209 ( .A(n194), .ZN(n164) );
  NAND2_X1 U210 ( .A1(addr2_4_), .A2(b[4]), .ZN(n190) );
  OAI21_X1 U211 ( .B1(n56), .B2(n164), .A(n190), .ZN(n159) );
  INV_X1 U212 ( .A(addr1_4_), .ZN(n160) );
  NAND2_X1 U213 ( .A1(n51), .A2(n160), .ZN(n182) );
  INV_X1 U214 ( .A(n182), .ZN(n171) );
  NAND2_X1 U215 ( .A1(addr1_4_), .A2(b[4]), .ZN(n183) );
  OAI21_X1 U216 ( .B1(n53), .B2(n171), .A(n183), .ZN(n161) );
  INV_X1 U217 ( .A(addr2_5_), .ZN(n192) );
  INV_X1 U218 ( .A(b[5]), .ZN(n191) );
  NAND3_X1 U219 ( .A1(n166), .A2(n165), .A3(n190), .ZN(n167) );
  AOI22_X1 U220 ( .A1(n168), .A2(n167), .B1(n94), .B2(b[5]), .ZN(n169) );
  INV_X1 U221 ( .A(b[6]), .ZN(n170) );
  XOR2_X1 U222 ( .A(n170), .B(n70), .Z(n177) );
  INV_X1 U223 ( .A(addr1_5_), .ZN(n184) );
  NAND2_X1 U224 ( .A1(n191), .A2(n184), .ZN(n180) );
  NOR2_X1 U225 ( .A1(n171), .A2(n99), .ZN(n175) );
  NAND3_X1 U226 ( .A1(n47), .A2(n172), .A3(n183), .ZN(n174) );
  AOI22_X1 U227 ( .A1(n175), .A2(n174), .B1(n80), .B2(b[5]), .ZN(n176) );
  XOR2_X1 U228 ( .A(n177), .B(n176), .Z(n178) );
  MUX2_X1 U229 ( .A(n179), .B(n178), .S(control), .Z(count[6]) );
  NAND2_X1 U230 ( .A1(addr1_6_), .A2(b[6]), .ZN(n215) );
  INV_X1 U231 ( .A(n215), .ZN(n185) );
  OAI21_X1 U232 ( .B1(n191), .B2(n96), .A(n183), .ZN(n214) );
  NOR3_X1 U233 ( .A1(n185), .A2(n81), .A3(n214), .ZN(n186) );
  AOI21_X1 U234 ( .B1(n213), .B2(n215), .A(n186), .ZN(n187) );
  INV_X1 U235 ( .A(b[7]), .ZN(n240) );
  NAND2_X1 U236 ( .A1(b[6]), .A2(addr2_6_), .ZN(n208) );
  INV_X1 U237 ( .A(n208), .ZN(n197) );
  OAI21_X1 U238 ( .B1(b[6]), .B2(addr2_6_), .A(n188), .ZN(n189) );
  INV_X1 U239 ( .A(n189), .ZN(n206) );
  OAI21_X1 U240 ( .B1(n192), .B2(n191), .A(n190), .ZN(n207) );
  INV_X1 U241 ( .A(n207), .ZN(n195) );
  NAND2_X1 U242 ( .A1(n193), .A2(n194), .ZN(n205) );
  NAND3_X1 U243 ( .A1(n195), .A2(n205), .A3(n208), .ZN(n196) );
  OAI21_X1 U244 ( .B1(n197), .B2(n206), .A(n196), .ZN(n198) );
  INV_X1 U245 ( .A(n198), .ZN(n200) );
  XOR2_X1 U246 ( .A(addr2_7_), .B(b[7]), .Z(n199) );
  OAI33_X1 U247 ( .A1(n200), .A2(control), .A3(n201), .B1(n198), .B2(control), 
        .B3(n199), .ZN(n202) );
  AOI21_X1 U248 ( .B1(control), .B2(n203), .A(n202), .ZN(n204) );
  INV_X1 U249 ( .A(n204), .ZN(count[7]) );
  INV_X1 U250 ( .A(control), .ZN(n239) );
  INV_X1 U251 ( .A(addr1_15), .ZN(n210) );
  NAND2_X1 U252 ( .A1(control), .A2(n210), .ZN(n229) );
  INV_X1 U253 ( .A(addr1_7_), .ZN(n211) );
  NAND2_X1 U254 ( .A1(n240), .A2(n211), .ZN(n237) );
  OAI21_X1 U255 ( .B1(n81), .B2(n214), .A(n61), .ZN(n216) );
  NAND2_X1 U256 ( .A1(n216), .A2(n215), .ZN(n236) );
  INV_X1 U257 ( .A(addr2_15), .ZN(n219) );
  NAND2_X1 U258 ( .A1(n239), .A2(n219), .ZN(n224) );
  NAND2_X1 U259 ( .A1(addr1_15), .A2(control), .ZN(n242) );
  NAND2_X1 U260 ( .A1(addr1_7_), .A2(b[7]), .ZN(n228) );
  INV_X1 U261 ( .A(n228), .ZN(n243) );
  NAND3_X1 U262 ( .A1(n236), .A2(n237), .A3(control), .ZN(n246) );
  OAI211_X1 U263 ( .C1(n71), .C2(b[7]), .A(n238), .B(n239), .ZN(n245) );
  OAI21_X1 U264 ( .B1(n240), .B2(n220), .A(n49), .ZN(n241) );
  OAI21_X1 U265 ( .B1(n243), .B2(n242), .A(n241), .ZN(n244) );
  INV_X1 sub_14_U93 ( .A(sub_14_n68), .ZN(sub_14_n55) );
  NOR2_X1 sub_14_U92 ( .A1(sub_14_n55), .A2(sub_14_n5), .ZN(sub_14_n59) );
  NOR2_X1 sub_14_U91 ( .A1(sub_14_n55), .A2(sub_14_n5), .ZN(sub_14_n52) );
  INV_X1 sub_14_U90 ( .A(sub_14_n54), .ZN(sub_14_n53) );
  NAND3_X1 sub_14_U89 ( .A1(sub_14_n42), .A2(sub_14_n26), .A3(sub_14_n41), 
        .ZN(sub_14_n40) );
  INV_X1 sub_14_U88 ( .A(sub_14_n35), .ZN(sub_14_n33) );
  INV_X1 sub_14_U87 ( .A(sub_14_n19), .ZN(sub_14_n34) );
  OAI21_X1 sub_14_U86 ( .B1(sub_14_n33), .B2(sub_14_n34), .A(sub_14_n23), .ZN(
        sub_14_n29) );
  NAND3_X1 sub_14_U85 ( .A1(sub_14_n19), .A2(sub_14_n26), .A3(sub_14_n20), 
        .ZN(sub_14_n28) );
  INV_X1 sub_14_U84 ( .A(offset2_3_), .ZN(sub_14_n67) );
  AOI21_X1 sub_14_U83 ( .B1(sub_14_n59), .B2(sub_14_n58), .A(sub_14_n60), .ZN(
        sub_14_n49) );
  NAND2_X1 sub_14_U82 ( .A1(sub_14_n49), .A2(sub_14_n50), .ZN(sub_14_n42) );
  NAND2_X1 sub_14_U81 ( .A1(sub_14_n42), .A2(sub_14_n41), .ZN(sub_14_n27) );
  XNOR2_X1 sub_14_U80 ( .A(sub_14_n11), .B(sub_14_n46), .ZN(addr2_4_) );
  NAND2_X1 sub_14_U79 ( .A1(offset2_2_), .A2(sub_14_n71), .ZN(sub_14_n68) );
  INV_X1 sub_14_U78 ( .A(offset2_2_), .ZN(sub_14_n72) );
  NOR2_X1 sub_14_U77 ( .A1(sub_14_n5), .A2(sub_14_n61), .ZN(sub_14_n60) );
  NAND2_X1 sub_14_U76 ( .A1(sub_14_n3), .A2(sub_14_n4), .ZN(sub_14_n70) );
  OAI21_X1 sub_14_U75 ( .B1(sub_14_n1), .B2(sub_14_n6), .A(sub_14_n4), .ZN(
        sub_14_n64) );
  NOR2_X1 sub_14_U74 ( .A1(sub_14_n8), .A2(sub_14_n28), .ZN(sub_14_n14) );
  NAND2_X1 sub_14_U73 ( .A1(offset2_1_), .A2(sub_14_n76), .ZN(sub_14_n75) );
  XNOR2_X1 sub_14_U72 ( .A(sub_14_n64), .B(sub_14_n65), .ZN(addr2_3_) );
  NAND2_X1 sub_14_U71 ( .A1(sub_14_n54), .A2(sub_14_n62), .ZN(sub_14_n65) );
  AOI21_X1 sub_14_U70 ( .B1(sub_14_n52), .B2(sub_14_n51), .A(sub_14_n53), .ZN(
        sub_14_n50) );
  NAND2_X1 sub_14_U69 ( .A1(address[1]), .A2(sub_14_n9), .ZN(sub_14_n56) );
  NOR2_X1 sub_14_U68 ( .A1(address[1]), .A2(sub_14_n9), .ZN(sub_14_n63) );
  NAND2_X1 sub_14_U67 ( .A1(sub_14_n7), .A2(sub_14_n78), .ZN(addr2_0_) );
  NAND2_X1 sub_14_U66 ( .A1(n76), .A2(sub_14_n81), .ZN(sub_14_n78) );
  INV_X1 sub_14_U65 ( .A(address[0]), .ZN(sub_14_n81) );
  INV_X1 sub_14_U64 ( .A(n76), .ZN(sub_14_n82) );
  NAND2_X1 sub_14_U63 ( .A1(sub_14_n75), .A2(sub_14_n10), .ZN(sub_14_n80) );
  NAND2_X1 sub_14_U62 ( .A1(sub_14_n73), .A2(sub_14_n56), .ZN(sub_14_n69) );
  AOI21_X1 sub_14_U61 ( .B1(sub_14_n10), .B2(sub_14_n7), .A(sub_14_n63), .ZN(
        sub_14_n51) );
  INV_X1 sub_14_U60 ( .A(offset2_5_), .ZN(sub_14_n44) );
  INV_X1 sub_14_U59 ( .A(address[1]), .ZN(sub_14_n76) );
  INV_X1 sub_14_U58 ( .A(address[4]), .ZN(sub_14_n47) );
  NAND2_X1 sub_14_U57 ( .A1(offset2_4_), .A2(sub_14_n47), .ZN(sub_14_n41) );
  INV_X1 sub_14_U56 ( .A(address[6]), .ZN(sub_14_n38) );
  NAND2_X1 sub_14_U55 ( .A1(offset2_6_), .A2(sub_14_n38), .ZN(sub_14_n19) );
  NOR2_X1 sub_14_U54 ( .A1(sub_14_n63), .A2(sub_14_n77), .ZN(sub_14_n58) );
  NAND2_X1 sub_14_U53 ( .A1(address[0]), .A2(sub_14_n82), .ZN(sub_14_n57) );
  INV_X1 sub_14_U52 ( .A(offset2_7_), .ZN(sub_14_n32) );
  NAND2_X1 sub_14_U51 ( .A1(address[7]), .A2(sub_14_n32), .ZN(sub_14_n18) );
  NAND2_X1 sub_14_U50 ( .A1(address[3]), .A2(sub_14_n67), .ZN(sub_14_n54) );
  NAND2_X1 sub_14_U49 ( .A1(address[5]), .A2(sub_14_n44), .ZN(sub_14_n24) );
  INV_X1 sub_14_U48 ( .A(address[2]), .ZN(sub_14_n71) );
  NAND2_X1 sub_14_U47 ( .A1(sub_14_n72), .A2(address[2]), .ZN(sub_14_n61) );
  INV_X1 sub_14_U46 ( .A(address[7]), .ZN(sub_14_n31) );
  NAND2_X1 sub_14_U45 ( .A1(offset2_7_), .A2(sub_14_n31), .ZN(sub_14_n20) );
  INV_X1 sub_14_U44 ( .A(offset2_6_), .ZN(sub_14_n37) );
  NAND2_X1 sub_14_U43 ( .A1(address[6]), .A2(sub_14_n37), .ZN(sub_14_n23) );
  INV_X1 sub_14_U42 ( .A(offset2_4_), .ZN(sub_14_n48) );
  NAND2_X1 sub_14_U41 ( .A1(address[4]), .A2(sub_14_n48), .ZN(sub_14_n25) );
  INV_X1 sub_14_U40 ( .A(address[3]), .ZN(sub_14_n66) );
  INV_X1 sub_14_U39 ( .A(address[5]), .ZN(sub_14_n45) );
  NAND2_X1 sub_14_U38 ( .A1(sub_14_n77), .A2(sub_14_n7), .ZN(sub_14_n79) );
  XNOR2_X1 sub_14_U37 ( .A(sub_14_n79), .B(sub_14_n80), .ZN(addr2_1_) );
  NAND2_X1 sub_14_U36 ( .A1(sub_14_n25), .A2(sub_14_n41), .ZN(sub_14_n46) );
  XNOR2_X1 sub_14_U35 ( .A(sub_14_n69), .B(sub_14_n70), .ZN(addr2_2_) );
  INV_X1 sub_14_U34 ( .A(sub_14_n78), .ZN(sub_14_n77) );
  NAND2_X1 sub_14_U33 ( .A1(sub_14_n19), .A2(sub_14_n20), .ZN(sub_14_n17) );
  NAND2_X1 sub_14_U32 ( .A1(sub_14_n77), .A2(sub_14_n57), .ZN(sub_14_n74) );
  NAND2_X1 sub_14_U31 ( .A1(sub_14_n74), .A2(sub_14_n75), .ZN(sub_14_n73) );
  NAND2_X1 sub_14_U30 ( .A1(sub_14_n19), .A2(sub_14_n23), .ZN(sub_14_n36) );
  XNOR2_X1 sub_14_U29 ( .A(sub_14_n35), .B(sub_14_n36), .ZN(addr2_6_) );
  NAND2_X1 sub_14_U28 ( .A1(sub_14_n23), .A2(sub_14_n24), .ZN(sub_14_n22) );
  NOR2_X1 sub_14_U27 ( .A1(sub_14_n2), .A2(sub_14_n25), .ZN(sub_14_n21) );
  NOR2_X1 sub_14_U26 ( .A1(sub_14_n21), .A2(sub_14_n22), .ZN(sub_14_n16) );
  OAI21_X1 sub_14_U25 ( .B1(sub_14_n16), .B2(sub_14_n17), .A(sub_14_n18), .ZN(
        sub_14_n15) );
  NOR2_X1 sub_14_U24 ( .A1(sub_14_n14), .A2(sub_14_n15), .ZN(addr2_15) );
  AND2_X1 sub_14_U23 ( .A1(sub_14_n26), .A2(sub_14_n24), .ZN(sub_14_n13) );
  AND2_X1 sub_14_U22 ( .A1(sub_14_n27), .A2(sub_14_n25), .ZN(sub_14_n12) );
  XNOR2_X1 sub_14_U21 ( .A(sub_14_n12), .B(sub_14_n13), .ZN(addr2_5_) );
  INV_X1 sub_14_U20 ( .A(sub_14_n24), .ZN(sub_14_n43) );
  NOR2_X1 sub_14_U19 ( .A1(sub_14_n21), .A2(sub_14_n43), .ZN(sub_14_n39) );
  NAND2_X1 sub_14_U18 ( .A1(sub_14_n39), .A2(sub_14_n40), .ZN(sub_14_n35) );
  NAND2_X1 sub_14_U17 ( .A1(sub_14_n18), .A2(sub_14_n20), .ZN(sub_14_n30) );
  CLKBUF_X1 sub_14_U16 ( .A(sub_14_n42), .Z(sub_14_n11) );
  NAND2_X1 sub_14_U15 ( .A1(address[1]), .A2(sub_14_n9), .ZN(sub_14_n10) );
  INV_X1 sub_14_U14 ( .A(offset2_1_), .ZN(sub_14_n9) );
  CLKBUF_X1 sub_14_U13 ( .A(sub_14_n27), .Z(sub_14_n8) );
  NAND2_X1 sub_14_U12 ( .A1(address[0]), .A2(sub_14_n82), .ZN(sub_14_n7) );
  AND2_X1 sub_14_U11 ( .A1(sub_14_n73), .A2(sub_14_n56), .ZN(sub_14_n6) );
  INV_X1 sub_14_U10 ( .A(sub_14_n5), .ZN(sub_14_n62) );
  AND2_X2 sub_14_U9 ( .A1(offset2_3_), .A2(sub_14_n66), .ZN(sub_14_n5) );
  NAND2_X1 sub_14_U8 ( .A1(sub_14_n72), .A2(address[2]), .ZN(sub_14_n4) );
  XNOR2_X1 sub_14_U7 ( .A(sub_14_n29), .B(sub_14_n30), .ZN(addr2_7_) );
  BUF_X1 sub_14_U6 ( .A(sub_14_n68), .Z(sub_14_n3) );
  INV_X1 sub_14_U5 ( .A(sub_14_n3), .ZN(sub_14_n1) );
  INV_X1 sub_14_U4 ( .A(sub_14_n2), .ZN(sub_14_n26) );
  AND2_X1 sub_14_U3 ( .A1(offset2_5_), .A2(sub_14_n45), .ZN(sub_14_n2) );
  INV_X1 sub_13_U88 ( .A(sub_13_n61), .ZN(sub_13_n52) );
  NAND3_X1 sub_13_U87 ( .A1(sub_13_n45), .A2(sub_13_n46), .A3(sub_13_n47), 
        .ZN(sub_13_n44) );
  INV_X1 sub_13_U86 ( .A(sub_13_n22), .ZN(sub_13_n38) );
  INV_X1 sub_13_U85 ( .A(sub_13_n21), .ZN(sub_13_n39) );
  NAND2_X1 sub_13_U84 ( .A1(sub_13_n37), .A2(sub_13_n10), .ZN(sub_13_n36) );
  INV_X1 sub_13_U83 ( .A(sub_13_n31), .ZN(sub_13_n29) );
  INV_X1 sub_13_U82 ( .A(sub_13_n16), .ZN(sub_13_n30) );
  INV_X1 sub_13_U81 ( .A(offset1_2_), .ZN(sub_13_n70) );
  NAND2_X1 sub_13_U80 ( .A1(sub_13_n44), .A2(sub_13_n23), .ZN(sub_13_n43) );
  NAND2_X1 sub_13_U79 ( .A1(offset1_3_), .A2(sub_13_n63), .ZN(sub_13_n51) );
  INV_X1 sub_13_U78 ( .A(offset1_3_), .ZN(sub_13_n64) );
  NAND2_X1 sub_13_U77 ( .A1(sub_13_n8), .A2(sub_13_n51), .ZN(sub_13_n54) );
  NAND4_X1 sub_13_U76 ( .A1(sub_13_n52), .A2(sub_13_n49), .A3(sub_13_n50), 
        .A4(sub_13_n51), .ZN(sub_13_n58) );
  NAND4_X1 sub_13_U75 ( .A1(sub_13_n48), .A2(sub_13_n49), .A3(sub_13_n50), 
        .A4(sub_13_n7), .ZN(sub_13_n47) );
  NAND4_X1 sub_13_U74 ( .A1(sub_13_n52), .A2(sub_13_n49), .A3(sub_13_n50), 
        .A4(sub_13_n7), .ZN(sub_13_n46) );
  NAND2_X1 sub_13_U73 ( .A1(sub_13_n62), .A2(sub_13_n50), .ZN(sub_13_n68) );
  AND2_X1 sub_13_U72 ( .A1(sub_13_n54), .A2(sub_13_n53), .ZN(sub_13_n45) );
  NAND2_X1 sub_13_U71 ( .A1(sub_13_n43), .A2(sub_13_n22), .ZN(sub_13_n40) );
  OAI21_X1 sub_13_U70 ( .B1(sub_13_n29), .B2(sub_13_n30), .A(sub_13_n20), .ZN(
        sub_13_n25) );
  XNOR2_X1 sub_13_U69 ( .A(sub_13_n25), .B(sub_13_n26), .ZN(addr1_7_) );
  NAND2_X1 sub_13_U68 ( .A1(offset1_7_), .A2(sub_13_n27), .ZN(sub_13_n17) );
  INV_X1 sub_13_U67 ( .A(offset1_7_), .ZN(sub_13_n28) );
  NAND2_X1 sub_13_U66 ( .A1(sub_13_n35), .A2(sub_13_n36), .ZN(sub_13_n31) );
  XNOR2_X1 sub_13_U65 ( .A(sub_13_n31), .B(sub_13_n32), .ZN(addr1_6_) );
  OAI211_X1 sub_13_U64 ( .C1(sub_13_n1), .C2(sub_13_n66), .A(sub_13_n49), .B(
        sub_13_n50), .ZN(sub_13_n65) );
  INV_X1 sub_13_U63 ( .A(offset1_6_), .ZN(sub_13_n33) );
  XNOR2_X1 sub_13_U62 ( .A(sub_13_n67), .B(sub_13_n68), .ZN(addr1_2_) );
  NAND2_X1 sub_13_U61 ( .A1(sub_13_n42), .A2(offset1_5_), .ZN(sub_13_n24) );
  NAND2_X1 sub_13_U60 ( .A1(sub_13_n5), .A2(sub_13_n21), .ZN(sub_13_n41) );
  AND4_X1 sub_13_U59 ( .A1(sub_13_n23), .A2(sub_13_n5), .A3(sub_13_n16), .A4(
        sub_13_n17), .ZN(sub_13_n11) );
  INV_X1 sub_13_U58 ( .A(offset1_1_), .ZN(sub_13_n73) );
  NAND2_X1 sub_13_U57 ( .A1(address[1]), .A2(sub_13_n73), .ZN(sub_13_n59) );
  NAND2_X1 sub_13_U56 ( .A1(address[2]), .A2(sub_13_n70), .ZN(sub_13_n62) );
  NAND2_X1 sub_13_U55 ( .A1(n55), .A2(sub_13_n76), .ZN(sub_13_n75) );
  INV_X1 sub_13_U54 ( .A(n55), .ZN(sub_13_n77) );
  INV_X1 sub_13_U53 ( .A(address[4]), .ZN(sub_13_n56) );
  NAND2_X1 sub_13_U52 ( .A1(offset1_4_), .A2(sub_13_n56), .ZN(sub_13_n23) );
  INV_X1 sub_13_U51 ( .A(offset1_4_), .ZN(sub_13_n57) );
  NAND2_X1 sub_13_U50 ( .A1(address[4]), .A2(sub_13_n57), .ZN(sub_13_n22) );
  NAND2_X1 sub_13_U49 ( .A1(address[0]), .A2(sub_13_n77), .ZN(sub_13_n60) );
  NAND2_X1 sub_13_U48 ( .A1(address[7]), .A2(sub_13_n28), .ZN(sub_13_n15) );
  INV_X1 sub_13_U47 ( .A(address[6]), .ZN(sub_13_n34) );
  NAND2_X1 sub_13_U46 ( .A1(offset1_6_), .A2(sub_13_n34), .ZN(sub_13_n16) );
  NAND2_X1 sub_13_U45 ( .A1(sub_13_n64), .A2(address[3]), .ZN(sub_13_n53) );
  INV_X1 sub_13_U44 ( .A(address[1]), .ZN(sub_13_n74) );
  NAND2_X1 sub_13_U43 ( .A1(offset1_1_), .A2(sub_13_n74), .ZN(sub_13_n49) );
  INV_X1 sub_13_U42 ( .A(address[0]), .ZN(sub_13_n76) );
  INV_X1 sub_13_U41 ( .A(address[7]), .ZN(sub_13_n27) );
  INV_X1 sub_13_U40 ( .A(address[5]), .ZN(sub_13_n42) );
  NAND2_X1 sub_13_U39 ( .A1(address[6]), .A2(sub_13_n33), .ZN(sub_13_n20) );
  INV_X1 sub_13_U38 ( .A(address[2]), .ZN(sub_13_n69) );
  INV_X1 sub_13_U37 ( .A(address[3]), .ZN(sub_13_n63) );
  NAND2_X1 sub_13_U36 ( .A1(sub_13_n60), .A2(sub_13_n75), .ZN(addr1_0_) );
  NAND2_X1 sub_13_U35 ( .A1(sub_13_n49), .A2(sub_13_n59), .ZN(sub_13_n72) );
  XNOR2_X1 sub_13_U34 ( .A(sub_13_n66), .B(sub_13_n72), .ZN(addr1_1_) );
  NAND2_X1 sub_13_U33 ( .A1(sub_13_n22), .A2(sub_13_n23), .ZN(sub_13_n55) );
  XNOR2_X1 sub_13_U32 ( .A(sub_13_n6), .B(sub_13_n55), .ZN(addr1_4_) );
  INV_X1 sub_13_U31 ( .A(sub_13_n75), .ZN(sub_13_n61) );
  NAND2_X1 sub_13_U30 ( .A1(sub_13_n61), .A2(sub_13_n60), .ZN(sub_13_n66) );
  NAND2_X1 sub_13_U29 ( .A1(sub_13_n59), .A2(sub_13_n60), .ZN(sub_13_n48) );
  NAND4_X1 sub_13_U28 ( .A1(sub_13_n47), .A2(sub_13_n54), .A3(sub_13_n58), 
        .A4(sub_13_n53), .ZN(sub_13_n10) );
  NAND2_X1 sub_13_U27 ( .A1(sub_13_n15), .A2(sub_13_n17), .ZN(sub_13_n26) );
  NAND2_X1 sub_13_U26 ( .A1(sub_13_n49), .A2(sub_13_n66), .ZN(sub_13_n71) );
  NAND2_X1 sub_13_U25 ( .A1(sub_13_n71), .A2(sub_13_n59), .ZN(sub_13_n67) );
  NAND2_X1 sub_13_U24 ( .A1(sub_13_n16), .A2(sub_13_n20), .ZN(sub_13_n32) );
  NAND2_X1 sub_13_U23 ( .A1(sub_13_n20), .A2(sub_13_n21), .ZN(sub_13_n19) );
  NOR2_X1 sub_13_U22 ( .A1(sub_13_n4), .A2(sub_13_n22), .ZN(sub_13_n18) );
  NOR2_X1 sub_13_U21 ( .A1(sub_13_n18), .A2(sub_13_n19), .ZN(sub_13_n13) );
  NAND2_X1 sub_13_U20 ( .A1(sub_13_n16), .A2(sub_13_n17), .ZN(sub_13_n14) );
  OAI21_X1 sub_13_U19 ( .B1(sub_13_n13), .B2(sub_13_n14), .A(sub_13_n15), .ZN(
        sub_13_n12) );
  AOI21_X1 sub_13_U18 ( .B1(sub_13_n6), .B2(sub_13_n11), .A(sub_13_n12), .ZN(
        addr1_15) );
  XNOR2_X1 sub_13_U17 ( .A(sub_13_n40), .B(sub_13_n41), .ZN(addr1_5_) );
  NOR2_X1 sub_13_U16 ( .A1(sub_13_n9), .A2(sub_13_n39), .ZN(sub_13_n35) );
  AND2_X1 sub_13_U15 ( .A1(sub_13_n38), .A2(sub_13_n24), .ZN(sub_13_n9) );
  AND2_X1 sub_13_U14 ( .A1(sub_13_n23), .A2(sub_13_n24), .ZN(sub_13_n37) );
  AND2_X1 sub_13_U13 ( .A1(address[2]), .A2(sub_13_n70), .ZN(sub_13_n8) );
  NAND2_X1 sub_13_U12 ( .A1(offset1_3_), .A2(sub_13_n63), .ZN(sub_13_n7) );
  OR2_X1 sub_13_U11 ( .A1(offset1_5_), .A2(sub_13_n42), .ZN(sub_13_n21) );
  INV_X1 sub_13_U10 ( .A(sub_13_n4), .ZN(sub_13_n5) );
  AND2_X1 sub_13_U9 ( .A1(sub_13_n42), .A2(offset1_5_), .ZN(sub_13_n4) );
  NAND2_X1 sub_13_U8 ( .A1(sub_13_n53), .A2(sub_13_n7), .ZN(sub_13_n3) );
  NAND2_X1 sub_13_U7 ( .A1(sub_13_n65), .A2(sub_13_n62), .ZN(sub_13_n2) );
  XNOR2_X1 sub_13_U6 ( .A(sub_13_n2), .B(sub_13_n3), .ZN(addr1_3_) );
  NAND2_X1 sub_13_U5 ( .A1(offset1_2_), .A2(sub_13_n69), .ZN(sub_13_n50) );
  BUF_X1 sub_13_U4 ( .A(sub_13_n10), .Z(sub_13_n6) );
  AND2_X1 sub_13_U3 ( .A1(address[1]), .A2(sub_13_n73), .ZN(sub_13_n1) );
endmodule

