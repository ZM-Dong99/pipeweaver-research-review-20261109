/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:34:10 2025
/////////////////////////////////////////////////////////////


module addr_calcu_mini ( address, ptr1, ptr2, b, control, count );
  input [7:0] address;
  input [7:0] ptr1;
  input [7:0] ptr2;
  input [7:0] b;
  output [15:0] count;
  input control;
  wire   diff2_15, diff2_8_, diff2_7_, diff2_6_, diff2_5_, diff2_4_, diff2_3_,
         diff2_2_, diff2_1_, diff2_0_, diff1_15, diff1_8_, diff1_7_, diff1_6_,
         diff1_5_, diff1_4_, diff1_3_, diff1_2_, diff1_1_, diff1_0_, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n70, n71, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101, n102, n103, n104, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
         n144, n145, n146, n147, n148, n149, n150, n151, n152, n153, n154,
         n155, n156, n157, n158, n159, n160, n161, n162, n163, n164, n165,
         n166, n167, n168, n169, n170, n171, n172, n173, n174, n175, n176,
         n177, n178, n179, n180, n181, n182, n183, n184, n185, n186, n187,
         n188, n189, n190, n191, n192, n193, n194, n195, n196, n197, n198,
         n199, n200, n201, n202, n203, n204, n205, n206, n207, n208, n209,
         n210, n211, n212, n213, n214, n215, n216, n217, n218, n219, n220,
         n221, n222, n223, n224, n225, n226, n227, n228, n229, n230, n231,
         n232, n233, n234, n235, n236, n237, n238, n239, n240, n241, n242,
         n243, n244, n245, n246, n247, n248, n249, n250, n251, n252, n253,
         n254, n255, n256, n257, n258, n259, n260, n261, n262, n263, n264,
         n266, add_17_n87, add_17_n86, add_17_n85, add_17_n84, add_17_n83,
         add_17_n82, add_17_n81, add_17_n80, add_17_n79, add_17_n78,
         add_17_n77, add_17_n76, add_17_n75, add_17_n74, add_17_n73,
         add_17_n72, add_17_n71, add_17_n70, add_17_n69, add_17_n68,
         add_17_n67, add_17_n66, add_17_n65, add_17_n64, add_17_n63,
         add_17_n62, add_17_n61, add_17_n60, add_17_n59, add_17_n58,
         add_17_n57, add_17_n56, add_17_n55, add_17_n54, add_17_n53,
         add_17_n52, add_17_n51, add_17_n50, add_17_n49, add_17_n48,
         add_17_n47, add_17_n46, add_17_n45, add_17_n44, add_17_n43,
         add_17_n42, add_17_n41, add_17_n40, add_17_n39, add_17_n38,
         add_17_n37, add_17_n36, add_17_n35, add_17_n34, add_17_n33,
         add_17_n32, add_17_n31, add_17_n30, add_17_n29, add_17_n28,
         add_17_n27, add_17_n26, add_17_n25, add_17_n24, add_17_n23,
         add_17_n22, add_17_n21, add_17_n19, add_17_n18, add_17_n17,
         add_17_n16, add_17_n15, add_17_n14, add_17_n13, add_17_n12,
         add_17_n11, add_17_n10, add_17_n9, add_17_n8, add_17_n7, add_17_n6,
         add_17_n5, add_17_n4, add_17_n3, add_17_n2, add_17_n1, add_16_n77,
         add_16_n76, add_16_n75, add_16_n74, add_16_n73, add_16_n72,
         add_16_n71, add_16_n70, add_16_n69, add_16_n68, add_16_n67,
         add_16_n66, add_16_n65, add_16_n64, add_16_n63, add_16_n62,
         add_16_n61, add_16_n60, add_16_n59, add_16_n58, add_16_n57,
         add_16_n56, add_16_n55, add_16_n54, add_16_n53, add_16_n52,
         add_16_n51, add_16_n50, add_16_n49, add_16_n48, add_16_n47,
         add_16_n46, add_16_n45, add_16_n44, add_16_n43, add_16_n42,
         add_16_n41, add_16_n40, add_16_n39, add_16_n38, add_16_n37,
         add_16_n36, add_16_n35, add_16_n34, add_16_n33, add_16_n32,
         add_16_n31, add_16_n30, add_16_n29, add_16_n28, add_16_n27,
         add_16_n26, add_16_n25, add_16_n24, add_16_n23, add_16_n22,
         add_16_n21, add_16_n20, add_16_n19, add_16_n18, add_16_n16,
         add_16_n15, add_16_n14, add_16_n13, add_16_n12, add_16_n11,
         add_16_n10, add_16_n9, add_16_n8, add_16_n7, add_16_n6, add_16_n5,
         add_16_n4, add_16_n3, add_16_n2, add_16_n1;

  CLKBUF_X1 U48 ( .A(n150), .Z(n51) );
  NOR2_X1 U49 ( .A1(n65), .A2(b[2]), .ZN(n90) );
  XNOR2_X1 U50 ( .A(n137), .B(n52), .ZN(n138) );
  XNOR2_X1 U51 ( .A(n70), .B(b[4]), .ZN(n52) );
  XNOR2_X1 U52 ( .A(n133), .B(n53), .ZN(n139) );
  XOR2_X1 U53 ( .A(b[4]), .B(n148), .Z(n53) );
  CLKBUF_X1 U54 ( .A(count[12]), .Z(count[13]) );
  BUF_X1 U55 ( .A(n257), .Z(n54) );
  CLKBUF_X1 U56 ( .A(count[15]), .Z(count[11]) );
  CLKBUF_X1 U57 ( .A(count[15]), .Z(count[14]) );
  NAND2_X1 U58 ( .A1(diff1_15), .A2(control), .ZN(n55) );
  NAND3_X1 U59 ( .A1(n256), .A2(n54), .A3(n56), .ZN(n264) );
  INV_X1 U60 ( .A(n55), .ZN(n56) );
  NAND2_X1 U61 ( .A1(n57), .A2(n58), .ZN(n59) );
  NAND2_X1 U62 ( .A1(n175), .A2(n59), .ZN(n78) );
  INV_X1 U63 ( .A(diff1_5_), .ZN(n57) );
  INV_X1 U64 ( .A(b[5]), .ZN(n58) );
  INV_X1 U65 ( .A(n67), .ZN(n147) );
  AND2_X1 U66 ( .A1(diff2_7_), .A2(b[7]), .ZN(n87) );
  INV_X1 U67 ( .A(n87), .ZN(n246) );
  AND2_X1 U68 ( .A1(diff1_8_), .A2(n247), .ZN(n60) );
  AND2_X1 U69 ( .A1(n249), .A2(n213), .ZN(n61) );
  XNOR2_X1 U70 ( .A(n135), .B(n62), .ZN(n128) );
  XNOR2_X1 U71 ( .A(n134), .B(n93), .ZN(n62) );
  XNOR2_X1 U72 ( .A(n131), .B(n63), .ZN(n129) );
  XNOR2_X1 U73 ( .A(n130), .B(b[3]), .ZN(n63) );
  INV_X1 U74 ( .A(n66), .ZN(n140) );
  CLKBUF_X1 U75 ( .A(n223), .Z(n95) );
  XNOR2_X1 U76 ( .A(n95), .B(n64), .ZN(n163) );
  XOR2_X1 U77 ( .A(n91), .B(b[5]), .Z(n64) );
  OR2_X2 U78 ( .A1(b[3]), .A2(diff1_3_), .ZN(n152) );
  AND2_X1 U79 ( .A1(n88), .A2(n192), .ZN(n195) );
  CLKBUF_X1 U80 ( .A(diff2_2_), .Z(n65) );
  AND2_X1 U81 ( .A1(diff2_2_), .A2(b[2]), .ZN(n66) );
  OR2_X2 U82 ( .A1(diff2_6_), .A2(b[6]), .ZN(n243) );
  AND2_X1 U83 ( .A1(diff2_3_), .A2(b[3]), .ZN(n67) );
  NAND4_X1 U84 ( .A1(n256), .A2(n54), .A3(diff1_15), .A4(control), .ZN(n68) );
  OAI211_X1 U85 ( .C1(diff1_4_), .C2(b[4]), .A(diff1_3_), .B(b[3]), .ZN(n156)
         );
  OAI21_X1 U86 ( .B1(diff1_1_), .B2(b[1]), .A(n104), .ZN(n69) );
  INV_X1 U87 ( .A(n159), .ZN(n70) );
  OR2_X1 U88 ( .A1(diff2_5_), .A2(b[5]), .ZN(n71) );
  OR2_X1 U89 ( .A1(diff2_5_), .A2(b[5]), .ZN(n204) );
  NAND2_X1 U90 ( .A1(n263), .A2(n264), .ZN(count[15]) );
  CLKBUF_X1 U91 ( .A(diff1_1_), .Z(n73) );
  AOI21_X1 U92 ( .B1(n69), .B2(n150), .A(n112), .ZN(n74) );
  INV_X1 U93 ( .A(n204), .ZN(n75) );
  INV_X1 U94 ( .A(n71), .ZN(n76) );
  OAI21_X1 U95 ( .B1(n83), .B2(b[5]), .A(n108), .ZN(n77) );
  CLKBUF_X1 U96 ( .A(diff2_1_), .Z(n79) );
  AND3_X1 U97 ( .A1(n261), .A2(diff2_15), .A3(n262), .ZN(n80) );
  NAND2_X1 U98 ( .A1(n81), .A2(n110), .ZN(n214) );
  AND2_X1 U99 ( .A1(n78), .A2(n60), .ZN(n81) );
  NAND3_X1 U100 ( .A1(n94), .A2(n255), .A3(n61), .ZN(n215) );
  INV_X1 U101 ( .A(n88), .ZN(n190) );
  AND2_X2 U102 ( .A1(n211), .A2(n210), .ZN(n110) );
  BUF_X1 U103 ( .A(n211), .Z(n82) );
  BUF_X1 U104 ( .A(n165), .Z(n96) );
  XNOR2_X1 U105 ( .A(n192), .B(n167), .ZN(n173) );
  BUF_X1 U106 ( .A(diff1_5_), .Z(n83) );
  CLKBUF_X1 U107 ( .A(n141), .Z(n84) );
  OAI21_X1 U108 ( .B1(n96), .B2(n166), .A(n71), .ZN(n85) );
  CLKBUF_X1 U109 ( .A(diff1_2_), .Z(n86) );
  XOR2_X1 U110 ( .A(b[7]), .B(diff2_7_), .Z(n88) );
  NOR2_X1 U111 ( .A1(diff2_2_), .A2(b[2]), .ZN(n99) );
  OAI211_X1 U112 ( .C1(n76), .C2(n223), .A(n222), .B(n221), .ZN(n89) );
  OAI211_X1 U113 ( .C1(n223), .C2(n75), .A(n222), .B(n221), .ZN(n258) );
  NAND2_X1 U114 ( .A1(n260), .A2(n80), .ZN(n263) );
  CLKBUF_X1 U115 ( .A(diff2_5_), .Z(n91) );
  CLKBUF_X1 U116 ( .A(n212), .Z(n92) );
  CLKBUF_X1 U117 ( .A(diff1_3_), .Z(n93) );
  NAND2_X1 U118 ( .A1(n212), .A2(n110), .ZN(n94) );
  OAI221_X1 U119 ( .B1(diff1_4_), .B2(b[4]), .C1(n74), .C2(n153), .A(n152), 
        .ZN(n97) );
  XOR2_X1 U120 ( .A(n126), .B(n86), .Z(n121) );
  AND2_X1 U121 ( .A1(diff2_8_), .A2(n243), .ZN(n98) );
  AND2_X1 U122 ( .A1(diff1_8_), .A2(n249), .ZN(n100) );
  AND2_X1 U123 ( .A1(n209), .A2(n101), .ZN(n217) );
  XOR2_X1 U124 ( .A(diff1_8_), .B(n231), .Z(n101) );
  AND2_X1 U125 ( .A1(n142), .A2(n84), .ZN(n102) );
  AND2_X1 U126 ( .A1(n51), .A2(n69), .ZN(n103) );
  INV_X1 U127 ( .A(n151), .ZN(n153) );
  AOI21_X1 U128 ( .B1(n202), .B2(n201), .A(control), .ZN(n220) );
  INV_X1 U129 ( .A(diff1_8_), .ZN(n213) );
  AND2_X1 U130 ( .A1(diff1_0_), .A2(b[0]), .ZN(n104) );
  INV_X1 U131 ( .A(b[4]), .ZN(n158) );
  AND2_X1 U132 ( .A1(b[0]), .A2(diff2_0_), .ZN(n115) );
  OAI211_X1 U133 ( .C1(n159), .C2(n158), .A(n156), .B(n97), .ZN(n108) );
  AND2_X1 U134 ( .A1(n141), .A2(n142), .ZN(n109) );
  NOR2_X1 U135 ( .A1(n109), .A2(n99), .ZN(n144) );
  INV_X1 U136 ( .A(diff1_4_), .ZN(n159) );
  OR2_X2 U137 ( .A1(diff1_6_), .A2(b[6]), .ZN(n249) );
  CLKBUF_X1 U138 ( .A(diff2_8_), .Z(n111) );
  NOR2_X1 U139 ( .A1(diff1_2_), .A2(b[2]), .ZN(n112) );
  NAND2_X1 U140 ( .A1(n111), .A2(n246), .ZN(n206) );
  XNOR2_X1 U141 ( .A(n246), .B(diff2_8_), .ZN(n202) );
  INV_X1 U142 ( .A(diff2_8_), .ZN(n203) );
  AOI21_X1 U143 ( .B1(n219), .B2(n220), .A(n218), .ZN(count[8]) );
  NOR2_X1 U144 ( .A1(n216), .A2(n217), .ZN(n218) );
  OAI211_X1 U145 ( .C1(n158), .C2(n159), .A(n156), .B(n157), .ZN(n175) );
  OAI221_X1 U146 ( .B1(diff1_4_), .B2(b[4]), .C1(n154), .C2(n153), .A(n152), 
        .ZN(n157) );
  AOI21_X1 U147 ( .B1(n150), .B2(n149), .A(n112), .ZN(n154) );
  INV_X2 U148 ( .A(control), .ZN(n262) );
  INV_X1 U149 ( .A(address[7]), .ZN(n266) );
  XOR2_X1 U150 ( .A(b[0]), .B(diff2_0_), .Z(n114) );
  XOR2_X1 U151 ( .A(diff1_0_), .B(b[0]), .Z(n113) );
  MUX2_X1 U152 ( .A(n114), .B(n113), .S(control), .Z(count[0]) );
  XOR2_X1 U153 ( .A(n79), .B(b[1]), .Z(n116) );
  XOR2_X1 U154 ( .A(n116), .B(n115), .Z(n119) );
  XOR2_X1 U155 ( .A(n73), .B(b[1]), .Z(n117) );
  XOR2_X1 U156 ( .A(n104), .B(n117), .Z(n118) );
  MUX2_X1 U157 ( .A(n119), .B(n118), .S(control), .Z(count[1]) );
  INV_X1 U158 ( .A(n65), .ZN(n124) );
  XOR2_X1 U159 ( .A(n124), .B(b[2]), .Z(n120) );
  NAND2_X1 U160 ( .A1(diff2_1_), .A2(b[1]), .ZN(n142) );
  OAI211_X1 U161 ( .C1(diff2_1_), .C2(b[1]), .A(diff2_0_), .B(b[0]), .ZN(n141)
         );
  XOR2_X1 U162 ( .A(n120), .B(n102), .Z(n123) );
  INV_X1 U163 ( .A(b[2]), .ZN(n126) );
  NAND2_X1 U164 ( .A1(b[1]), .A2(diff1_1_), .ZN(n150) );
  OAI21_X1 U165 ( .B1(b[1]), .B2(diff1_1_), .A(n104), .ZN(n149) );
  XOR2_X1 U166 ( .A(n103), .B(n121), .Z(n122) );
  MUX2_X1 U167 ( .A(n123), .B(n122), .S(control), .Z(count[2]) );
  INV_X1 U168 ( .A(diff2_3_), .ZN(n130) );
  OAI21_X1 U169 ( .B1(n90), .B2(n102), .A(n140), .ZN(n125) );
  INV_X1 U170 ( .A(n125), .ZN(n131) );
  INV_X1 U171 ( .A(b[3]), .ZN(n134) );
  NAND2_X1 U172 ( .A1(diff1_2_), .A2(b[2]), .ZN(n151) );
  OAI21_X1 U173 ( .B1(n103), .B2(n112), .A(n151), .ZN(n127) );
  INV_X1 U174 ( .A(n127), .ZN(n135) );
  MUX2_X1 U175 ( .A(n129), .B(n128), .S(control), .Z(count[3]) );
  NAND2_X1 U176 ( .A1(n130), .A2(n134), .ZN(n143) );
  INV_X1 U177 ( .A(n143), .ZN(n132) );
  OAI21_X1 U178 ( .B1(n131), .B2(n132), .A(n147), .ZN(n133) );
  INV_X1 U179 ( .A(n152), .ZN(n136) );
  NAND2_X1 U180 ( .A1(n93), .A2(b[3]), .ZN(n155) );
  OAI21_X1 U181 ( .B1(n135), .B2(n136), .A(n155), .ZN(n137) );
  MUX2_X1 U182 ( .A(n139), .B(n138), .S(control), .Z(count[4]) );
  INV_X1 U183 ( .A(diff2_4_), .ZN(n148) );
  AOI22_X1 U184 ( .A1(diff2_4_), .A2(b[4]), .B1(n67), .B2(b[4]), .ZN(n146) );
  OAI221_X1 U185 ( .B1(diff2_4_), .B2(b[4]), .C1(n144), .C2(n66), .A(n143), 
        .ZN(n145) );
  OAI211_X1 U186 ( .C1(n148), .C2(n147), .A(n146), .B(n145), .ZN(n165) );
  INV_X1 U187 ( .A(n165), .ZN(n223) );
  INV_X1 U188 ( .A(b[5]), .ZN(n164) );
  XOR2_X1 U189 ( .A(n164), .B(n83), .Z(n161) );
  INV_X1 U190 ( .A(n108), .ZN(n160) );
  XOR2_X1 U191 ( .A(n161), .B(n160), .Z(n162) );
  MUX2_X1 U192 ( .A(n163), .B(n162), .S(control), .Z(count[5]) );
  INV_X1 U193 ( .A(diff2_6_), .ZN(n184) );
  XOR2_X1 U194 ( .A(n184), .B(b[6]), .Z(n167) );
  NAND2_X1 U195 ( .A1(diff2_5_), .A2(b[5]), .ZN(n221) );
  INV_X1 U196 ( .A(n221), .ZN(n166) );
  OAI21_X1 U197 ( .B1(n166), .B2(n96), .A(n71), .ZN(n192) );
  INV_X1 U198 ( .A(b[6]), .ZN(n183) );
  XOR2_X1 U199 ( .A(diff1_6_), .B(n183), .Z(n171) );
  OAI21_X1 U200 ( .B1(n83), .B2(b[5]), .A(n108), .ZN(n230) );
  NAND2_X1 U201 ( .A1(diff1_5_), .A2(b[5]), .ZN(n210) );
  NAND3_X1 U202 ( .A1(n171), .A2(n210), .A3(n77), .ZN(n170) );
  INV_X1 U203 ( .A(n210), .ZN(n178) );
  INV_X1 U204 ( .A(n171), .ZN(n168) );
  AOI21_X1 U205 ( .B1(n178), .B2(n168), .A(n262), .ZN(n169) );
  OAI211_X1 U206 ( .C1(n171), .C2(n77), .A(n170), .B(n169), .ZN(n172) );
  OAI21_X1 U207 ( .B1(n173), .B2(control), .A(n172), .ZN(count[6]) );
  NAND2_X1 U208 ( .A1(diff1_6_), .A2(b[6]), .ZN(n211) );
  NAND2_X1 U209 ( .A1(control), .A2(n82), .ZN(n182) );
  INV_X1 U210 ( .A(n182), .ZN(n174) );
  INV_X1 U211 ( .A(diff1_7_), .ZN(n208) );
  XOR2_X1 U212 ( .A(n208), .B(b[7]), .Z(n180) );
  INV_X1 U213 ( .A(n180), .ZN(n181) );
  NAND4_X1 U214 ( .A1(n77), .A2(n210), .A3(n174), .A4(n181), .ZN(n199) );
  OAI21_X1 U215 ( .B1(n83), .B2(b[5]), .A(n175), .ZN(n212) );
  INV_X1 U216 ( .A(n92), .ZN(n179) );
  INV_X1 U217 ( .A(n249), .ZN(n176) );
  NOR3_X1 U218 ( .A1(n181), .A2(n176), .A3(n262), .ZN(n177) );
  OAI21_X1 U219 ( .B1(n179), .B2(n178), .A(n177), .ZN(n198) );
  OAI21_X1 U220 ( .B1(n262), .B2(n82), .A(n180), .ZN(n188) );
  OAI21_X1 U221 ( .B1(n182), .B2(n249), .A(n181), .ZN(n187) );
  INV_X1 U222 ( .A(n243), .ZN(n186) );
  INV_X1 U223 ( .A(b[7]), .ZN(n207) );
  NAND2_X1 U224 ( .A1(diff2_6_), .A2(b[6]), .ZN(n222) );
  NAND2_X1 U225 ( .A1(n222), .A2(n262), .ZN(n189) );
  NOR2_X1 U226 ( .A1(n190), .A2(n189), .ZN(n185) );
  AOI22_X1 U227 ( .A1(n188), .A2(n187), .B1(n186), .B2(n185), .ZN(n197) );
  INV_X1 U228 ( .A(n189), .ZN(n194) );
  NAND2_X1 U229 ( .A1(n243), .A2(n262), .ZN(n191) );
  OAI33_X1 U230 ( .A1(n85), .A2(n88), .A3(n191), .B1(n222), .B2(control), .B3(
        n88), .ZN(n193) );
  AOI21_X1 U231 ( .B1(n195), .B2(n194), .A(n193), .ZN(n196) );
  NAND4_X1 U232 ( .A1(n196), .A2(n198), .A3(n197), .A4(n199), .ZN(count[7]) );
  INV_X1 U233 ( .A(diff2_7_), .ZN(n200) );
  NAND2_X1 U234 ( .A1(n207), .A2(n200), .ZN(n259) );
  NAND3_X1 U235 ( .A1(n259), .A2(n243), .A3(n111), .ZN(n201) );
  NAND3_X1 U236 ( .A1(n259), .A2(n203), .A3(n243), .ZN(n205) );
  MUX2_X1 U237 ( .A(n206), .B(n205), .S(n89), .Z(n219) );
  NAND2_X1 U238 ( .A1(n208), .A2(n207), .ZN(n255) );
  NAND3_X1 U239 ( .A1(n255), .A2(n249), .A3(diff1_8_), .ZN(n209) );
  NAND2_X1 U240 ( .A1(diff1_7_), .A2(b[7]), .ZN(n247) );
  INV_X1 U241 ( .A(n247), .ZN(n231) );
  NAND2_X1 U242 ( .A1(n78), .A2(n110), .ZN(n254) );
  NAND3_X1 U243 ( .A1(n215), .A2(n214), .A3(control), .ZN(n216) );
  NAND2_X1 U244 ( .A1(n98), .A2(n259), .ZN(n227) );
  OAI211_X1 U245 ( .C1(n223), .C2(n75), .A(n222), .B(n221), .ZN(n225) );
  INV_X1 U246 ( .A(n258), .ZN(n226) );
  INV_X1 U247 ( .A(diff2_15), .ZN(n229) );
  NAND2_X1 U248 ( .A1(diff2_8_), .A2(n87), .ZN(n261) );
  INV_X1 U249 ( .A(n261), .ZN(n224) );
  OAI33_X1 U250 ( .A1(n226), .A2(n227), .A3(n229), .B1(n89), .B2(diff2_15), 
        .B3(n224), .ZN(n241) );
  NAND3_X1 U251 ( .A1(n261), .A2(n229), .A3(n227), .ZN(n228) );
  OAI211_X1 U252 ( .C1(n229), .C2(n261), .A(n262), .B(n228), .ZN(n240) );
  NAND2_X1 U253 ( .A1(n230), .A2(n110), .ZN(n233) );
  INV_X1 U254 ( .A(n233), .ZN(n234) );
  INV_X1 U255 ( .A(diff1_15), .ZN(n237) );
  NAND2_X1 U256 ( .A1(n100), .A2(n255), .ZN(n235) );
  NAND2_X1 U257 ( .A1(diff1_8_), .A2(n231), .ZN(n257) );
  INV_X1 U258 ( .A(n257), .ZN(n232) );
  OAI33_X1 U259 ( .A1(n234), .A2(n237), .A3(n235), .B1(n233), .B2(diff1_15), 
        .B3(n232), .ZN(n239) );
  NAND3_X1 U260 ( .A1(n257), .A2(n237), .A3(n235), .ZN(n236) );
  OAI211_X1 U261 ( .C1(n237), .C2(n54), .A(control), .B(n236), .ZN(n238) );
  OAI22_X1 U262 ( .A1(n241), .A2(n240), .B1(n238), .B2(n239), .ZN(count[9]) );
  NAND2_X1 U263 ( .A1(control), .A2(diff1_8_), .ZN(n248) );
  NAND2_X1 U264 ( .A1(diff2_8_), .A2(n262), .ZN(n245) );
  INV_X1 U265 ( .A(n245), .ZN(n242) );
  NAND4_X1 U266 ( .A1(n258), .A2(n259), .A3(n242), .A4(n243), .ZN(n244) );
  OAI221_X1 U267 ( .B1(n247), .B2(n248), .C1(n246), .C2(n245), .A(n244), .ZN(
        n253) );
  INV_X1 U268 ( .A(n248), .ZN(n250) );
  NAND4_X1 U269 ( .A1(n94), .A2(n255), .A3(n249), .A4(n250), .ZN(n251) );
  OAI221_X1 U270 ( .B1(diff1_15), .B2(n262), .C1(diff2_15), .C2(control), .A(
        n251), .ZN(n252) );
  NOR2_X1 U271 ( .A1(n253), .A2(n252), .ZN(count[10]) );
  NAND3_X1 U272 ( .A1(n254), .A2(n255), .A3(n100), .ZN(n256) );
  NAND3_X1 U273 ( .A1(n225), .A2(n259), .A3(n98), .ZN(n260) );
  NAND2_X1 U274 ( .A1(n263), .A2(n68), .ZN(count[12]) );
  NAND2_X1 add_17_U97 ( .A1(ptr2[0]), .A2(address[0]), .ZN(add_17_n80) );
  XNOR2_X1 add_17_U96 ( .A(add_17_n77), .B(add_17_n78), .ZN(diff2_3_) );
  INV_X1 add_17_U95 ( .A(add_17_n39), .ZN(add_17_n76) );
  INV_X1 add_17_U94 ( .A(add_17_n45), .ZN(add_17_n65) );
  NAND2_X1 add_17_U93 ( .A1(ptr2[0]), .A2(address[0]), .ZN(add_17_n73) );
  INV_X1 add_17_U92 ( .A(add_17_n71), .ZN(add_17_n69) );
  XNOR2_X1 add_17_U91 ( .A(add_17_n63), .B(add_17_n64), .ZN(diff2_5_) );
  NAND3_X1 add_17_U90 ( .A1(add_17_n42), .A2(add_17_n43), .A3(add_17_n45), 
        .ZN(add_17_n50) );
  INV_X1 add_17_U89 ( .A(add_17_n41), .ZN(add_17_n52) );
  INV_X1 add_17_U88 ( .A(add_17_n40), .ZN(add_17_n53) );
  INV_X1 add_17_U87 ( .A(add_17_n42), .ZN(add_17_n38) );
  INV_X1 add_17_U86 ( .A(add_17_n37), .ZN(add_17_n36) );
  MUX2_X1 add_17_U85 ( .A(add_17_n26), .B(add_17_n27), .S(add_17_n28), .Z(
        diff2_15) );
  OAI211_X1 add_17_U84 ( .C1(add_17_n14), .C2(add_17_n11), .A(add_17_n70), .B(
        add_17_n72), .ZN(add_17_n62) );
  NAND2_X1 add_17_U83 ( .A1(add_17_n8), .A2(add_17_n6), .ZN(add_17_n82) );
  NAND2_X1 add_17_U82 ( .A1(add_17_n16), .A2(add_17_n9), .ZN(add_17_n79) );
  OAI21_X1 add_17_U81 ( .B1(add_17_n62), .B2(add_17_n7), .A(add_17_n24), .ZN(
        add_17_n61) );
  XNOR2_X1 add_17_U80 ( .A(add_17_n46), .B(add_17_n47), .ZN(diff2_7_) );
  OAI21_X1 add_17_U79 ( .B1(add_17_n49), .B2(add_17_n50), .A(add_17_n51), .ZN(
        add_17_n46) );
  XNOR2_X2 add_17_U78 ( .A(add_17_n29), .B(add_17_n27), .ZN(diff2_8_) );
  XNOR2_X1 add_17_U77 ( .A(add_17_n81), .B(add_17_n82), .ZN(diff2_2_) );
  AND2_X1 add_17_U76 ( .A1(add_17_n39), .A2(add_17_n54), .ZN(add_17_n25) );
  AND3_X1 add_17_U75 ( .A1(add_17_n12), .A2(add_17_n55), .A3(add_17_n25), .ZN(
        add_17_n49) );
  NAND2_X1 add_17_U74 ( .A1(address[1]), .A2(ptr2[1]), .ZN(add_17_n74) );
  XNOR2_X1 add_17_U73 ( .A(add_17_n67), .B(add_17_n66), .ZN(diff2_4_) );
  OAI21_X1 add_17_U72 ( .B1(add_17_n22), .B2(add_17_n65), .A(add_17_n39), .ZN(
        add_17_n63) );
  NOR2_X1 add_17_U71 ( .A1(add_17_n61), .A2(add_17_n68), .ZN(add_17_n67) );
  NAND2_X1 add_17_U70 ( .A1(ptr2[7]), .A2(n266), .ZN(add_17_n37) );
  NAND2_X1 add_17_U69 ( .A1(ptr2[6]), .A2(address[6]), .ZN(add_17_n40) );
  OR2_X2 add_17_U68 ( .A1(ptr2[6]), .A2(address[6]), .ZN(add_17_n43) );
  OR2_X2 add_17_U67 ( .A1(ptr2[5]), .A2(address[5]), .ZN(add_17_n42) );
  NAND2_X1 add_17_U66 ( .A1(ptr2[4]), .A2(address[4]), .ZN(add_17_n39) );
  INV_X1 add_17_U65 ( .A(ptr2[7]), .ZN(add_17_n48) );
  NAND2_X1 add_17_U64 ( .A1(add_17_n48), .A2(add_17_n31), .ZN(add_17_n44) );
  INV_X1 add_17_U63 ( .A(ptr2[0]), .ZN(add_17_n84) );
  OR2_X2 add_17_U62 ( .A1(ptr2[4]), .A2(address[4]), .ZN(add_17_n45) );
  INV_X1 add_17_U61 ( .A(address[0]), .ZN(add_17_n85) );
  NAND2_X1 add_17_U60 ( .A1(add_17_n84), .A2(add_17_n85), .ZN(add_17_n75) );
  NAND2_X1 add_17_U59 ( .A1(ptr2[0]), .A2(address[0]), .ZN(add_17_n87) );
  NAND2_X1 add_17_U58 ( .A1(ptr2[2]), .A2(address[2]), .ZN(add_17_n71) );
  AND2_X1 add_17_U57 ( .A1(add_17_n80), .A2(add_17_n17), .ZN(add_17_n23) );
  NAND2_X1 add_17_U56 ( .A1(add_17_n83), .A2(add_17_n18), .ZN(add_17_n81) );
  OAI211_X1 add_17_U55 ( .C1(add_17_n38), .C2(add_17_n39), .A(add_17_n40), .B(
        add_17_n41), .ZN(add_17_n35) );
  INV_X1 add_17_U54 ( .A(add_17_n54), .ZN(add_17_n68) );
  INV_X1 add_17_U53 ( .A(n266), .ZN(add_17_n31) );
  AND2_X1 add_17_U52 ( .A1(add_17_n44), .A2(add_17_n43), .ZN(add_17_n34) );
  AOI21_X1 add_17_U51 ( .B1(add_17_n34), .B2(add_17_n35), .A(add_17_n36), .ZN(
        add_17_n33) );
  NAND4_X1 add_17_U50 ( .A1(add_17_n44), .A2(add_17_n43), .A3(add_17_n45), 
        .A4(add_17_n42), .ZN(add_17_n32) );
  OAI21_X1 add_17_U49 ( .B1(add_17_n32), .B2(add_17_n22), .A(add_17_n33), .ZN(
        add_17_n29) );
  AOI21_X1 add_17_U48 ( .B1(add_17_n52), .B2(add_17_n43), .A(add_17_n53), .ZN(
        add_17_n51) );
  NAND2_X1 add_17_U47 ( .A1(add_17_n37), .A2(add_17_n44), .ZN(add_17_n47) );
  NAND2_X1 add_17_U46 ( .A1(add_17_n39), .A2(add_17_n54), .ZN(add_17_n60) );
  NOR2_X1 add_17_U45 ( .A1(add_17_n60), .A2(add_17_n13), .ZN(add_17_n58) );
  NAND2_X1 add_17_U44 ( .A1(add_17_n45), .A2(add_17_n42), .ZN(add_17_n59) );
  OAI21_X1 add_17_U43 ( .B1(add_17_n58), .B2(add_17_n59), .A(add_17_n41), .ZN(
        add_17_n56) );
  NAND2_X1 add_17_U42 ( .A1(add_17_n43), .A2(add_17_n40), .ZN(add_17_n57) );
  XNOR2_X1 add_17_U41 ( .A(add_17_n56), .B(add_17_n57), .ZN(diff2_6_) );
  NAND2_X1 add_17_U40 ( .A1(add_17_n69), .A2(add_17_n19), .ZN(add_17_n24) );
  NAND2_X1 add_17_U39 ( .A1(add_17_n42), .A2(add_17_n41), .ZN(add_17_n64) );
  OAI21_X1 add_17_U38 ( .B1(add_17_n23), .B2(add_17_n79), .A(add_17_n8), .ZN(
        add_17_n77) );
  NAND2_X1 add_17_U37 ( .A1(add_17_n54), .A2(add_17_n1), .ZN(add_17_n78) );
  NOR2_X1 add_17_U36 ( .A1(add_17_n76), .A2(add_17_n65), .ZN(add_17_n66) );
  INV_X1 add_17_U35 ( .A(add_17_n31), .ZN(add_17_n30) );
  INV_X1 add_17_U34 ( .A(add_17_n31), .ZN(add_17_n26) );
  INV_X1 add_17_U33 ( .A(add_17_n30), .ZN(add_17_n27) );
  AND2_X1 add_17_U32 ( .A1(ptr2[0]), .A2(address[0]), .ZN(add_17_n21) );
  XNOR2_X1 add_17_U31 ( .A(add_17_n86), .B(add_17_n21), .ZN(diff2_1_) );
  AND2_X1 add_17_U30 ( .A1(add_17_n75), .A2(add_17_n87), .ZN(diff2_0_) );
  NAND2_X1 add_17_U29 ( .A1(add_17_n16), .A2(add_17_n10), .ZN(add_17_n83) );
  NAND2_X1 add_17_U28 ( .A1(ptr2[3]), .A2(address[3]), .ZN(add_17_n54) );
  CLKBUF_X1 add_17_U27 ( .A(add_17_n17), .Z(add_17_n18) );
  NAND2_X1 add_17_U26 ( .A1(address[1]), .A2(ptr2[1]), .ZN(add_17_n17) );
  OAI211_X1 add_17_U25 ( .C1(add_17_n14), .C2(add_17_n11), .A(add_17_n5), .B(
        add_17_n2), .ZN(add_17_n15) );
  BUF_X1 add_17_U24 ( .A(address[1]), .Z(add_17_n14) );
  OAI21_X1 add_17_U23 ( .B1(add_17_n7), .B2(add_17_n3), .A(add_17_n12), .ZN(
        add_17_n13) );
  XNOR2_X1 add_17_U22 ( .A(address[1]), .B(ptr2[1]), .ZN(add_17_n86) );
  AND2_X1 add_17_U21 ( .A1(n266), .A2(add_17_n29), .ZN(add_17_n28) );
  AND3_X1 add_17_U20 ( .A1(add_17_n55), .A2(add_17_n54), .A3(add_17_n12), .ZN(
        add_17_n22) );
  NAND2_X1 add_17_U19 ( .A1(add_17_n69), .A2(add_17_n1), .ZN(add_17_n12) );
  OR2_X2 add_17_U18 ( .A1(ptr2[3]), .A2(address[3]), .ZN(add_17_n19) );
  OR2_X2 add_17_U17 ( .A1(address[1]), .A2(ptr2[1]), .ZN(add_17_n16) );
  BUF_X1 add_17_U16 ( .A(ptr2[1]), .Z(add_17_n11) );
  AND2_X1 add_17_U15 ( .A1(ptr2[0]), .A2(address[0]), .ZN(add_17_n10) );
  NAND2_X1 add_17_U14 ( .A1(ptr2[5]), .A2(address[5]), .ZN(add_17_n41) );
  CLKBUF_X1 add_17_U13 ( .A(add_17_n71), .Z(add_17_n8) );
  AND2_X1 add_17_U12 ( .A1(add_17_n74), .A2(add_17_n73), .ZN(add_17_n7) );
  OR2_X1 add_17_U11 ( .A1(address[2]), .A2(ptr2[2]), .ZN(add_17_n9) );
  OR2_X1 add_17_U10 ( .A1(address[2]), .A2(ptr2[2]), .ZN(add_17_n6) );
  OR2_X1 add_17_U9 ( .A1(address[2]), .A2(ptr2[2]), .ZN(add_17_n5) );
  AND2_X1 add_17_U8 ( .A1(add_17_n74), .A2(add_17_n73), .ZN(add_17_n4) );
  OR2_X1 add_17_U7 ( .A1(add_17_n15), .A2(add_17_n4), .ZN(add_17_n55) );
  OR2_X1 add_17_U6 ( .A1(address[3]), .A2(ptr2[3]), .ZN(add_17_n70) );
  OAI211_X1 add_17_U5 ( .C1(add_17_n14), .C2(add_17_n11), .A(add_17_n70), .B(
        add_17_n72), .ZN(add_17_n3) );
  OR2_X1 add_17_U4 ( .A1(address[3]), .A2(ptr2[3]), .ZN(add_17_n2) );
  OR2_X2 add_17_U3 ( .A1(address[2]), .A2(ptr2[2]), .ZN(add_17_n72) );
  OR2_X2 add_17_U2 ( .A1(ptr2[3]), .A2(address[3]), .ZN(add_17_n1) );
  NAND2_X1 add_16_U87 ( .A1(ptr1[0]), .A2(address[0]), .ZN(add_16_n70) );
  XNOR2_X1 add_16_U86 ( .A(add_16_n67), .B(add_16_n68), .ZN(diff1_3_) );
  NAND3_X1 add_16_U85 ( .A1(add_16_n61), .A2(add_16_n12), .A3(add_16_n66), 
        .ZN(add_16_n58) );
  INV_X1 add_16_U84 ( .A(add_16_n64), .ZN(add_16_n63) );
  XNOR2_X1 add_16_U83 ( .A(add_16_n29), .B(add_16_n57), .ZN(diff1_4_) );
  INV_X1 add_16_U82 ( .A(add_16_n30), .ZN(add_16_n56) );
  OAI21_X1 add_16_U81 ( .B1(add_16_n8), .B2(add_16_n56), .A(add_16_n38), .ZN(
        add_16_n54) );
  OAI21_X1 add_16_U80 ( .B1(add_16_n50), .B2(add_16_n8), .A(add_16_n49), .ZN(
        add_16_n51) );
  INV_X1 add_16_U79 ( .A(add_16_n49), .ZN(add_16_n47) );
  INV_X1 add_16_U78 ( .A(add_16_n41), .ZN(add_16_n48) );
  OAI21_X1 add_16_U77 ( .B1(add_16_n45), .B2(add_16_n8), .A(add_16_n46), .ZN(
        add_16_n42) );
  XNOR2_X1 add_16_U76 ( .A(add_16_n42), .B(add_16_n43), .ZN(diff1_7_) );
  NAND3_X1 add_16_U75 ( .A1(add_16_n27), .A2(add_16_n29), .A3(add_16_n28), 
        .ZN(add_16_n26) );
  XNOR2_X2 add_16_U74 ( .A(add_16_n22), .B(add_16_n19), .ZN(diff1_8_) );
  INV_X1 add_16_U73 ( .A(add_16_n22), .ZN(add_16_n21) );
  NOR2_X1 add_16_U72 ( .A1(add_16_n19), .A2(add_16_n21), .ZN(add_16_n20) );
  MUX2_X1 add_16_U71 ( .A(add_16_n18), .B(add_16_n19), .S(add_16_n20), .Z(
        diff1_15) );
  XNOR2_X1 add_16_U70 ( .A(add_16_n73), .B(add_16_n72), .ZN(diff1_2_) );
  OAI21_X1 add_16_U69 ( .B1(add_16_n69), .B2(add_16_n5), .A(add_16_n1), .ZN(
        add_16_n67) );
  NAND2_X1 add_16_U68 ( .A1(add_16_n64), .A2(add_16_n3), .ZN(add_16_n73) );
  NAND2_X1 add_16_U67 ( .A1(add_16_n2), .A2(add_16_n16), .ZN(add_16_n69) );
  NAND4_X1 add_16_U66 ( .A1(add_16_n61), .A2(add_16_n12), .A3(add_16_n65), 
        .A4(add_16_n16), .ZN(add_16_n59) );
  AOI21_X1 add_16_U65 ( .B1(add_16_n63), .B2(add_16_n62), .A(add_16_n9), .ZN(
        add_16_n60) );
  NAND2_X1 add_16_U64 ( .A1(ptr1[1]), .A2(address[1]), .ZN(add_16_n71) );
  AND2_X1 add_16_U63 ( .A1(ptr1[1]), .A2(address[1]), .ZN(add_16_n66) );
  NAND2_X1 add_16_U62 ( .A1(add_16_n74), .A2(add_16_n75), .ZN(add_16_n77) );
  NAND2_X1 add_16_U61 ( .A1(add_16_n11), .A2(add_16_n12), .ZN(add_16_n68) );
  NAND3_X1 add_16_U60 ( .A1(add_16_n60), .A2(add_16_n59), .A3(add_16_n58), 
        .ZN(add_16_n29) );
  NAND2_X1 add_16_U59 ( .A1(ptr1[6]), .A2(address[6]), .ZN(add_16_n41) );
  NAND2_X1 add_16_U58 ( .A1(ptr1[7]), .A2(n266), .ZN(add_16_n37) );
  OR2_X2 add_16_U57 ( .A1(ptr1[6]), .A2(address[6]), .ZN(add_16_n33) );
  OR2_X1 add_16_U56 ( .A1(ptr1[4]), .A2(address[4]), .ZN(add_16_n30) );
  NAND2_X1 add_16_U55 ( .A1(ptr1[5]), .A2(address[5]), .ZN(add_16_n40) );
  NAND2_X1 add_16_U54 ( .A1(ptr1[4]), .A2(address[4]), .ZN(add_16_n38) );
  NAND2_X1 add_16_U53 ( .A1(ptr1[0]), .A2(address[0]), .ZN(add_16_n76) );
  AND2_X1 add_16_U52 ( .A1(ptr1[0]), .A2(address[0]), .ZN(add_16_n65) );
  INV_X1 add_16_U51 ( .A(ptr1[7]), .ZN(add_16_n44) );
  NAND2_X1 add_16_U50 ( .A1(add_16_n44), .A2(add_16_n24), .ZN(add_16_n32) );
  INV_X1 add_16_U49 ( .A(address[0]), .ZN(add_16_n75) );
  AND2_X1 add_16_U48 ( .A1(add_16_n76), .A2(add_16_n77), .ZN(diff1_0_) );
  OR2_X2 add_16_U47 ( .A1(ptr1[5]), .A2(address[5]), .ZN(add_16_n31) );
  NAND2_X1 add_16_U46 ( .A1(address[2]), .A2(ptr1[2]), .ZN(add_16_n64) );
  INV_X1 add_16_U45 ( .A(add_16_n37), .ZN(add_16_n36) );
  NAND2_X1 add_16_U44 ( .A1(add_16_n38), .A2(add_16_n40), .ZN(add_16_n53) );
  NAND2_X1 add_16_U43 ( .A1(add_16_n53), .A2(add_16_n31), .ZN(add_16_n49) );
  NAND2_X1 add_16_U42 ( .A1(add_16_n33), .A2(add_16_n28), .ZN(add_16_n45) );
  NAND2_X1 add_16_U41 ( .A1(add_16_n30), .A2(add_16_n31), .ZN(add_16_n50) );
  AOI21_X1 add_16_U40 ( .B1(add_16_n47), .B2(add_16_n33), .A(add_16_n48), .ZN(
        add_16_n46) );
  NAND2_X1 add_16_U39 ( .A1(add_16_n32), .A2(add_16_n37), .ZN(add_16_n43) );
  AND2_X1 add_16_U38 ( .A1(add_16_n32), .A2(add_16_n33), .ZN(add_16_n34) );
  AND2_X1 add_16_U37 ( .A1(add_16_n32), .A2(add_16_n33), .ZN(add_16_n27) );
  INV_X1 add_16_U36 ( .A(n266), .ZN(add_16_n24) );
  AND2_X1 add_16_U35 ( .A1(add_16_n30), .A2(add_16_n31), .ZN(add_16_n28) );
  AOI21_X1 add_16_U34 ( .B1(add_16_n34), .B2(add_16_n35), .A(add_16_n36), .ZN(
        add_16_n25) );
  NAND2_X1 add_16_U33 ( .A1(add_16_n25), .A2(add_16_n26), .ZN(add_16_n22) );
  INV_X1 add_16_U32 ( .A(add_16_n31), .ZN(add_16_n39) );
  OAI211_X1 add_16_U31 ( .C1(add_16_n38), .C2(add_16_n39), .A(add_16_n40), .B(
        add_16_n41), .ZN(add_16_n35) );
  NAND2_X1 add_16_U30 ( .A1(add_16_n33), .A2(add_16_n41), .ZN(add_16_n52) );
  NAND2_X1 add_16_U29 ( .A1(add_16_n30), .A2(add_16_n38), .ZN(add_16_n57) );
  NAND2_X1 add_16_U28 ( .A1(add_16_n31), .A2(add_16_n40), .ZN(add_16_n55) );
  INV_X1 add_16_U27 ( .A(add_16_n24), .ZN(add_16_n23) );
  INV_X1 add_16_U26 ( .A(add_16_n24), .ZN(add_16_n18) );
  INV_X1 add_16_U25 ( .A(add_16_n23), .ZN(add_16_n19) );
  INV_X1 add_16_U24 ( .A(ptr1[0]), .ZN(add_16_n74) );
  XNOR2_X1 add_16_U23 ( .A(add_16_n54), .B(add_16_n55), .ZN(diff1_5_) );
  NAND2_X1 add_16_U22 ( .A1(ptr1[0]), .A2(address[0]), .ZN(add_16_n15) );
  NOR2_X1 add_16_U21 ( .A1(ptr1[1]), .A2(address[1]), .ZN(add_16_n14) );
  OR2_X1 add_16_U20 ( .A1(ptr1[1]), .A2(address[1]), .ZN(add_16_n13) );
  OR2_X2 add_16_U19 ( .A1(address[3]), .A2(ptr1[3]), .ZN(add_16_n12) );
  INV_X1 add_16_U18 ( .A(add_16_n9), .ZN(add_16_n11) );
  AND2_X1 add_16_U17 ( .A1(add_16_n13), .A2(add_16_n71), .ZN(add_16_n10) );
  XNOR2_X1 add_16_U16 ( .A(add_16_n10), .B(add_16_n76), .ZN(diff1_1_) );
  AND2_X1 add_16_U15 ( .A1(ptr1[3]), .A2(address[3]), .ZN(add_16_n9) );
  AND3_X1 add_16_U14 ( .A1(add_16_n59), .A2(add_16_n4), .A3(add_16_n58), .ZN(
        add_16_n8) );
  INV_X1 add_16_U13 ( .A(address[1]), .ZN(add_16_n7) );
  INV_X1 add_16_U12 ( .A(ptr1[1]), .ZN(add_16_n6) );
  OAI22_X1 add_16_U11 ( .A1(add_16_n14), .A2(add_16_n15), .B1(add_16_n6), .B2(
        add_16_n7), .ZN(add_16_n72) );
  AND2_X1 add_16_U10 ( .A1(add_16_n70), .A2(add_16_n71), .ZN(add_16_n5) );
  OR2_X2 add_16_U9 ( .A1(address[3]), .A2(ptr1[3]), .ZN(add_16_n62) );
  AOI21_X1 add_16_U8 ( .B1(add_16_n63), .B2(add_16_n62), .A(add_16_n9), .ZN(
        add_16_n4) );
  OR2_X1 add_16_U7 ( .A1(address[2]), .A2(ptr1[2]), .ZN(add_16_n61) );
  OR2_X1 add_16_U6 ( .A1(address[2]), .A2(ptr1[2]), .ZN(add_16_n3) );
  OR2_X1 add_16_U5 ( .A1(address[2]), .A2(ptr1[2]), .ZN(add_16_n2) );
  XNOR2_X1 add_16_U4 ( .A(add_16_n51), .B(add_16_n52), .ZN(diff1_6_) );
  OR2_X2 add_16_U3 ( .A1(ptr1[1]), .A2(address[1]), .ZN(add_16_n16) );
  NAND2_X1 add_16_U2 ( .A1(address[2]), .A2(ptr1[2]), .ZN(add_16_n1) );
endmodule

