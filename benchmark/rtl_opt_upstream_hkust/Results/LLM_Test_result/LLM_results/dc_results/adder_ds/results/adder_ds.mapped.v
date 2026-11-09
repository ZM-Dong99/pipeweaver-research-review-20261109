/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:04:13 2025
/////////////////////////////////////////////////////////////


module adder_ds ( DATA_1, DATA_2, SEL_0, SEL_1, clk, reg_0 );
  input [31:0] DATA_1;
  input [31:0] DATA_2;
  output [31:0] reg_0;
  input SEL_0, SEL_1, clk;
  wire   n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83,
         n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97,
         n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109,
         n110, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120,
         n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, n131,
         n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142,
         n143, n144, n145, n146, n147, n148, n149, n150, n151, n152, n153,
         n154, n155, n156, n157, n158, n159, n160, n161, n162, n163, n164,
         n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197,
         n198, n199, n200, n201, n202, n203, n204, n205, n206, n207, n208,
         add_10_n327, add_10_n326, add_10_n325, add_10_n324, add_10_n323,
         add_10_n322, add_10_n321, add_10_n320, add_10_n319, add_10_n318,
         add_10_n317, add_10_n316, add_10_n315, add_10_n314, add_10_n313,
         add_10_n312, add_10_n311, add_10_n310, add_10_n309, add_10_n308,
         add_10_n307, add_10_n306, add_10_n305, add_10_n304, add_10_n303,
         add_10_n302, add_10_n301, add_10_n300, add_10_n299, add_10_n298,
         add_10_n297, add_10_n296, add_10_n295, add_10_n294, add_10_n293,
         add_10_n292, add_10_n291, add_10_n290, add_10_n289, add_10_n288,
         add_10_n287, add_10_n286, add_10_n285, add_10_n284, add_10_n283,
         add_10_n282, add_10_n281, add_10_n280, add_10_n279, add_10_n278,
         add_10_n277, add_10_n276, add_10_n275, add_10_n274, add_10_n273,
         add_10_n272, add_10_n271, add_10_n270, add_10_n269, add_10_n268,
         add_10_n267, add_10_n266, add_10_n265, add_10_n264, add_10_n263,
         add_10_n262, add_10_n261, add_10_n260, add_10_n259, add_10_n258,
         add_10_n257, add_10_n256, add_10_n255, add_10_n254, add_10_n253,
         add_10_n252, add_10_n251, add_10_n250, add_10_n249, add_10_n248,
         add_10_n247, add_10_n246, add_10_n245, add_10_n244, add_10_n243,
         add_10_n242, add_10_n241, add_10_n240, add_10_n239, add_10_n238,
         add_10_n237, add_10_n236, add_10_n235, add_10_n234, add_10_n233,
         add_10_n232, add_10_n231, add_10_n230, add_10_n229, add_10_n228,
         add_10_n227, add_10_n226, add_10_n225, add_10_n224, add_10_n223,
         add_10_n222, add_10_n221, add_10_n220, add_10_n219, add_10_n218,
         add_10_n217, add_10_n216, add_10_n215, add_10_n214, add_10_n213,
         add_10_n212, add_10_n211, add_10_n210, add_10_n209, add_10_n208,
         add_10_n207, add_10_n206, add_10_n205, add_10_n204, add_10_n203,
         add_10_n202, add_10_n201, add_10_n200, add_10_n199, add_10_n198,
         add_10_n197, add_10_n196, add_10_n195, add_10_n194, add_10_n193,
         add_10_n192, add_10_n191, add_10_n190, add_10_n189, add_10_n188,
         add_10_n187, add_10_n186, add_10_n185, add_10_n184, add_10_n183,
         add_10_n182, add_10_n181, add_10_n180, add_10_n179, add_10_n178,
         add_10_n177, add_10_n176, add_10_n175, add_10_n174, add_10_n173,
         add_10_n172, add_10_n171, add_10_n170, add_10_n169, add_10_n168,
         add_10_n167, add_10_n166, add_10_n165, add_10_n164, add_10_n163,
         add_10_n162, add_10_n161, add_10_n160, add_10_n159, add_10_n158,
         add_10_n157, add_10_n156, add_10_n155, add_10_n154, add_10_n153,
         add_10_n152, add_10_n151, add_10_n150, add_10_n149, add_10_n148,
         add_10_n147, add_10_n146, add_10_n145, add_10_n144, add_10_n143,
         add_10_n142, add_10_n141, add_10_n140, add_10_n139, add_10_n138,
         add_10_n137, add_10_n136, add_10_n135, add_10_n134, add_10_n133,
         add_10_n132, add_10_n131, add_10_n130, add_10_n129, add_10_n128,
         add_10_n127, add_10_n126, add_10_n125, add_10_n124, add_10_n123,
         add_10_n122, add_10_n121, add_10_n120, add_10_n119, add_10_n118,
         add_10_n117, add_10_n116, add_10_n115, add_10_n114, add_10_n113,
         add_10_n112, add_10_n111, add_10_n110, add_10_n109, add_10_n108,
         add_10_n107, add_10_n106, add_10_n105, add_10_n104, add_10_n103,
         add_10_n102, add_10_n101, add_10_n100, add_10_n99, add_10_n98,
         add_10_n97, add_10_n96, add_10_n95, add_10_n94, add_10_n93,
         add_10_n92, add_10_n91, add_10_n90, add_10_n89, add_10_n88,
         add_10_n87, add_10_n86, add_10_n85, add_10_n84, add_10_n83,
         add_10_n82, add_10_n81, add_10_n80, add_10_n79, add_10_n78,
         add_10_n77, add_10_n76, add_10_n75, add_10_n74, add_10_n73,
         add_10_n72, add_10_n71, add_10_n70, add_10_n69, add_10_n68,
         add_10_n67, add_10_n66, add_10_n65, add_10_n64, add_10_n63,
         add_10_n62, add_10_n61, add_10_n60, add_10_n59, add_10_n58,
         add_10_n57, add_10_n56, add_10_n55, add_10_n54, add_10_n53,
         add_10_n52, add_10_n51, add_10_n50, add_10_n49, add_10_n48,
         add_10_n47, add_10_n46, add_10_n45, add_10_n44, add_10_n43,
         add_10_n42, add_10_n41, add_10_n40, add_10_n39, add_10_n38,
         add_10_n37, add_10_n36, add_10_n35, add_10_n34, add_10_n33,
         add_10_n32, add_10_n31, add_10_n30, add_10_n29, add_10_n28,
         add_10_n27, add_10_n26, add_10_n25, add_10_n24, add_10_n23,
         add_10_n22, add_10_n21, add_10_n19, add_10_n18, add_10_n17,
         add_10_n16, add_10_n15, add_10_n14, add_10_n13, add_10_n12,
         add_10_n11, add_10_n10, add_10_n9, add_10_n8, add_10_n7, add_10_n6,
         add_10_n5, add_10_n4, add_10_n3, add_10_n2, add_10_n1;
  wire   [31:0] Add_0;

  DFF_X1 reg_0_reg_26_ ( .D(n182), .CK(clk), .Q(reg_0[26]) );
  DFF_X1 reg_0_reg_23_ ( .D(n185), .CK(clk), .Q(reg_0[23]) );
  DFF_X1 reg_0_reg_28_ ( .D(n180), .CK(clk), .Q(reg_0[28]) );
  DFF_X1 reg_0_reg_24_ ( .D(n184), .CK(clk), .Q(reg_0[24]) );
  DFF_X1 reg_0_reg_21_ ( .D(n187), .CK(clk), .Q(reg_0[21]) );
  DFF_X1 reg_0_reg_18_ ( .D(n190), .CK(clk), .Q(reg_0[18]) );
  DFF_X1 reg_0_reg_17_ ( .D(n191), .CK(clk), .Q(reg_0[17]) );
  DFF_X1 reg_0_reg_16_ ( .D(n192), .CK(clk), .Q(reg_0[16]) );
  DFF_X1 reg_0_reg_4_ ( .D(n204), .CK(clk), .Q(reg_0[4]) );
  DFF_X1 reg_0_reg_2_ ( .D(n206), .CK(clk), .Q(reg_0[2]) );
  DFF_X1 reg_0_reg_0_ ( .D(n208), .CK(clk), .Q(reg_0[0]) );
  DFF_X1 reg_0_reg_14_ ( .D(n194), .CK(clk), .Q(reg_0[14]) );
  DFF_X1 reg_0_reg_12_ ( .D(n196), .CK(clk), .Q(reg_0[12]) );
  DFF_X1 reg_0_reg_10_ ( .D(n198), .CK(clk), .Q(reg_0[10]) );
  DFF_X1 reg_0_reg_8_ ( .D(n200), .CK(clk), .Q(reg_0[8]) );
  DFF_X1 reg_0_reg_3_ ( .D(n205), .CK(clk), .Q(reg_0[3]) );
  DFF_X1 reg_0_reg_27_ ( .D(n181), .CK(clk), .Q(reg_0[27]) );
  DFF_X1 reg_0_reg_25_ ( .D(n183), .CK(clk), .Q(reg_0[25]) );
  DFF_X1 reg_0_reg_20_ ( .D(n188), .CK(clk), .Q(reg_0[20]) );
  DFF_X1 reg_0_reg_9_ ( .D(n199), .CK(clk), .Q(reg_0[9]) );
  DFF_X1 reg_0_reg_1_ ( .D(n207), .CK(clk), .Q(reg_0[1]) );
  DFF_X1 reg_0_reg_31_ ( .D(n177), .CK(clk), .Q(reg_0[31]) );
  DFF_X1 reg_0_reg_29_ ( .D(n179), .CK(clk), .Q(reg_0[29]) );
  DFF_X1 reg_0_reg_15_ ( .D(n193), .CK(clk), .Q(reg_0[15]) );
  DFF_X1 reg_0_reg_13_ ( .D(n195), .CK(clk), .Q(reg_0[13]) );
  DFF_X1 reg_0_reg_11_ ( .D(n197), .CK(clk), .Q(reg_0[11]) );
  DFF_X1 reg_0_reg_7_ ( .D(n201), .CK(clk), .Q(reg_0[7]) );
  DFF_X1 reg_0_reg_6_ ( .D(n202), .CK(clk), .Q(reg_0[6]) );
  DFF_X1 reg_0_reg_5_ ( .D(n203), .CK(clk), .Q(reg_0[5]) );
  DFF_X1 reg_0_reg_30_ ( .D(n178), .CK(clk), .Q(reg_0[30]) );
  DFF_X1 reg_0_reg_22_ ( .D(n186), .CK(clk), .Q(reg_0[22]) );
  DFF_X1 reg_0_reg_19_ ( .D(n189), .CK(clk), .Q(reg_0[19]) );
  OAI222_X1 U71 ( .A1(n95), .A2(n142), .B1(n70), .B2(n172), .C1(n71), .C2(n108), .ZN(n191) );
  INV_X1 U72 ( .A(DATA_1[17]), .ZN(n70) );
  INV_X1 U73 ( .A(Add_0[17]), .ZN(n71) );
  BUF_X2 U74 ( .A(n97), .Z(n95) );
  OAI222_X1 U75 ( .A1(n97), .A2(n123), .B1(n72), .B2(n172), .C1(n73), .C2(n108), .ZN(n201) );
  INV_X1 U76 ( .A(DATA_1[7]), .ZN(n72) );
  INV_X1 U77 ( .A(Add_0[7]), .ZN(n73) );
  BUF_X2 U78 ( .A(n106), .Z(n97) );
  OAI222_X1 U79 ( .A1(n95), .A2(n148), .B1(n74), .B2(n172), .C1(n75), .C2(n108), .ZN(n188) );
  INV_X1 U80 ( .A(DATA_1[20]), .ZN(n74) );
  INV_X1 U81 ( .A(Add_0[20]), .ZN(n75) );
  OAI221_X1 U82 ( .B1(n76), .B2(n172), .C1(n77), .C2(n108), .A(n98), .ZN(n181)
         );
  INV_X1 U83 ( .A(DATA_1[27]), .ZN(n76) );
  INV_X1 U84 ( .A(Add_0[27]), .ZN(n77) );
  OAI221_X1 U85 ( .B1(n78), .B2(n172), .C1(n79), .C2(n108), .A(n84), .ZN(n177)
         );
  INV_X1 U86 ( .A(DATA_1[31]), .ZN(n78) );
  INV_X1 U87 ( .A(Add_0[31]), .ZN(n79) );
  OR2_X1 U88 ( .A1(n95), .A2(n160), .ZN(n80) );
  NAND2_X1 U89 ( .A1(n159), .A2(n80), .ZN(n183) );
  OR2_X1 U90 ( .A1(n95), .A2(n168), .ZN(n81) );
  NAND2_X1 U91 ( .A1(n167), .A2(n81), .ZN(n179) );
  OR2_X1 U92 ( .A1(n172), .A2(n171), .ZN(n82) );
  CLKBUF_X1 U93 ( .A(n97), .Z(n96) );
  OR2_X1 U94 ( .A1(n96), .A2(n170), .ZN(n83) );
  NAND3_X1 U95 ( .A1(n169), .A2(n83), .A3(n82), .ZN(n178) );
  OR2_X1 U96 ( .A1(n96), .A2(n163), .ZN(n86) );
  OR2_X1 U97 ( .A1(n95), .A2(n175), .ZN(n84) );
  OR2_X1 U98 ( .A1(n94), .A2(n139), .ZN(n85) );
  NAND2_X1 U99 ( .A1(n138), .A2(n85), .ZN(n193) );
  BUF_X2 U100 ( .A(n97), .Z(n94) );
  OR2_X1 U101 ( .A1(n172), .A2(n162), .ZN(n87) );
  NAND3_X1 U102 ( .A1(n161), .A2(n87), .A3(n86), .ZN(n182) );
  OR2_X1 U103 ( .A1(n172), .A2(n147), .ZN(n88) );
  OR2_X1 U104 ( .A1(n96), .A2(n146), .ZN(n89) );
  NAND3_X1 U105 ( .A1(n145), .A2(n89), .A3(n88), .ZN(n189) );
  BUF_X1 U106 ( .A(n176), .Z(n106) );
  OR2_X1 U107 ( .A1(n172), .A2(n153), .ZN(n90) );
  OR2_X1 U108 ( .A1(n96), .A2(n152), .ZN(n91) );
  NAND3_X1 U109 ( .A1(n151), .A2(n91), .A3(n90), .ZN(n186) );
  BUF_X2 U110 ( .A(n174), .Z(n104) );
  BUF_X2 U111 ( .A(n174), .Z(n103) );
  CLKBUF_X1 U112 ( .A(n174), .Z(n105) );
  INV_X1 U113 ( .A(n108), .ZN(n92) );
  INV_X1 U114 ( .A(n108), .ZN(n93) );
  INV_X1 U115 ( .A(n108), .ZN(n101) );
  INV_X1 U116 ( .A(n108), .ZN(n102) );
  OR2_X1 U117 ( .A1(n96), .A2(n164), .ZN(n98) );
  OR2_X1 U118 ( .A1(n172), .A2(n156), .ZN(n99) );
  OR2_X1 U119 ( .A1(n96), .A2(n155), .ZN(n100) );
  NAND3_X1 U120 ( .A1(n154), .A2(n100), .A3(n99), .ZN(n185) );
  INV_X1 U121 ( .A(SEL_1), .ZN(n176) );
  INV_X1 U122 ( .A(DATA_2[0]), .ZN(n110) );
  INV_X1 U123 ( .A(SEL_0), .ZN(n107) );
  NAND2_X1 U124 ( .A1(n176), .A2(n107), .ZN(n172) );
  INV_X1 U125 ( .A(n172), .ZN(n174) );
  NAND2_X1 U126 ( .A1(SEL_0), .A2(n94), .ZN(n108) );
  INV_X1 U127 ( .A(n108), .ZN(n173) );
  AOI22_X1 U128 ( .A1(DATA_1[0]), .A2(n103), .B1(Add_0[0]), .B2(n101), .ZN(
        n109) );
  OAI21_X1 U129 ( .B1(n96), .B2(n110), .A(n109), .ZN(n208) );
  INV_X1 U130 ( .A(DATA_2[1]), .ZN(n112) );
  AOI22_X1 U131 ( .A1(DATA_1[1]), .A2(n103), .B1(Add_0[1]), .B2(n93), .ZN(n111) );
  OAI21_X1 U132 ( .B1(n95), .B2(n112), .A(n111), .ZN(n207) );
  INV_X1 U133 ( .A(DATA_2[2]), .ZN(n114) );
  AOI22_X1 U134 ( .A1(DATA_1[2]), .A2(n103), .B1(Add_0[2]), .B2(n101), .ZN(
        n113) );
  OAI21_X1 U135 ( .B1(n96), .B2(n114), .A(n113), .ZN(n206) );
  INV_X1 U136 ( .A(DATA_2[3]), .ZN(n116) );
  AOI22_X1 U137 ( .A1(DATA_1[3]), .A2(n103), .B1(Add_0[3]), .B2(n173), .ZN(
        n115) );
  OAI21_X1 U138 ( .B1(n94), .B2(n116), .A(n115), .ZN(n205) );
  INV_X1 U139 ( .A(DATA_2[4]), .ZN(n118) );
  AOI22_X1 U140 ( .A1(DATA_1[4]), .A2(n103), .B1(Add_0[4]), .B2(n173), .ZN(
        n117) );
  OAI21_X1 U141 ( .B1(n96), .B2(n118), .A(n117), .ZN(n204) );
  INV_X1 U142 ( .A(DATA_2[5]), .ZN(n120) );
  AOI22_X1 U143 ( .A1(DATA_1[5]), .A2(n103), .B1(Add_0[5]), .B2(n92), .ZN(n119) );
  OAI21_X1 U144 ( .B1(n94), .B2(n120), .A(n119), .ZN(n203) );
  INV_X1 U145 ( .A(DATA_2[6]), .ZN(n122) );
  AOI22_X1 U146 ( .A1(DATA_1[6]), .A2(n103), .B1(Add_0[6]), .B2(n92), .ZN(n121) );
  OAI21_X1 U147 ( .B1(n94), .B2(n122), .A(n121), .ZN(n202) );
  INV_X1 U148 ( .A(DATA_2[7]), .ZN(n123) );
  INV_X1 U149 ( .A(DATA_2[8]), .ZN(n125) );
  AOI22_X1 U150 ( .A1(n103), .A2(DATA_1[8]), .B1(Add_0[8]), .B2(n102), .ZN(
        n124) );
  OAI21_X1 U151 ( .B1(n94), .B2(n125), .A(n124), .ZN(n200) );
  INV_X1 U152 ( .A(DATA_2[9]), .ZN(n127) );
  AOI22_X1 U153 ( .A1(DATA_1[9]), .A2(n103), .B1(Add_0[9]), .B2(n93), .ZN(n126) );
  OAI21_X1 U154 ( .B1(n95), .B2(n127), .A(n126), .ZN(n199) );
  INV_X1 U155 ( .A(DATA_2[10]), .ZN(n129) );
  AOI22_X1 U156 ( .A1(DATA_1[10]), .A2(n103), .B1(Add_0[10]), .B2(n102), .ZN(
        n128) );
  OAI21_X1 U157 ( .B1(n94), .B2(n129), .A(n128), .ZN(n198) );
  INV_X1 U158 ( .A(DATA_2[11]), .ZN(n131) );
  AOI22_X1 U159 ( .A1(DATA_1[11]), .A2(n103), .B1(Add_0[11]), .B2(n92), .ZN(
        n130) );
  OAI21_X1 U160 ( .B1(n94), .B2(n131), .A(n130), .ZN(n197) );
  INV_X1 U161 ( .A(DATA_2[12]), .ZN(n133) );
  AOI22_X1 U162 ( .A1(DATA_1[12]), .A2(n104), .B1(Add_0[12]), .B2(n173), .ZN(
        n132) );
  OAI21_X1 U163 ( .B1(n94), .B2(n133), .A(n132), .ZN(n196) );
  INV_X1 U164 ( .A(DATA_2[13]), .ZN(n135) );
  AOI22_X1 U165 ( .A1(DATA_1[13]), .A2(n104), .B1(Add_0[13]), .B2(n92), .ZN(
        n134) );
  OAI21_X1 U166 ( .B1(n94), .B2(n135), .A(n134), .ZN(n195) );
  INV_X1 U167 ( .A(DATA_2[14]), .ZN(n137) );
  AOI22_X1 U168 ( .A1(DATA_1[14]), .A2(n104), .B1(Add_0[14]), .B2(n101), .ZN(
        n136) );
  OAI21_X1 U169 ( .B1(n94), .B2(n137), .A(n136), .ZN(n194) );
  INV_X1 U170 ( .A(DATA_2[15]), .ZN(n139) );
  AOI22_X1 U171 ( .A1(DATA_1[15]), .A2(n104), .B1(Add_0[15]), .B2(n92), .ZN(
        n138) );
  INV_X1 U172 ( .A(DATA_2[16]), .ZN(n141) );
  AOI22_X1 U173 ( .A1(DATA_1[16]), .A2(n104), .B1(Add_0[16]), .B2(n173), .ZN(
        n140) );
  OAI21_X1 U174 ( .B1(n95), .B2(n141), .A(n140), .ZN(n192) );
  INV_X1 U175 ( .A(DATA_2[17]), .ZN(n142) );
  INV_X1 U176 ( .A(DATA_2[18]), .ZN(n144) );
  AOI22_X1 U177 ( .A1(DATA_1[18]), .A2(n104), .B1(Add_0[18]), .B2(n102), .ZN(
        n143) );
  OAI21_X1 U178 ( .B1(n95), .B2(n144), .A(n143), .ZN(n190) );
  INV_X1 U179 ( .A(DATA_1[19]), .ZN(n147) );
  INV_X1 U180 ( .A(DATA_2[19]), .ZN(n146) );
  NAND2_X1 U181 ( .A1(Add_0[19]), .A2(n101), .ZN(n145) );
  INV_X1 U182 ( .A(DATA_2[20]), .ZN(n148) );
  INV_X1 U183 ( .A(DATA_2[21]), .ZN(n150) );
  AOI22_X1 U184 ( .A1(DATA_1[21]), .A2(n104), .B1(Add_0[21]), .B2(n173), .ZN(
        n149) );
  OAI21_X1 U185 ( .B1(n95), .B2(n150), .A(n149), .ZN(n187) );
  INV_X1 U186 ( .A(DATA_1[22]), .ZN(n153) );
  INV_X1 U187 ( .A(DATA_2[22]), .ZN(n152) );
  NAND2_X1 U188 ( .A1(Add_0[22]), .A2(n92), .ZN(n151) );
  INV_X1 U189 ( .A(DATA_1[23]), .ZN(n156) );
  INV_X1 U190 ( .A(DATA_2[23]), .ZN(n155) );
  NAND2_X1 U191 ( .A1(Add_0[23]), .A2(n93), .ZN(n154) );
  INV_X1 U192 ( .A(DATA_2[24]), .ZN(n158) );
  AOI22_X1 U193 ( .A1(DATA_1[24]), .A2(n104), .B1(Add_0[24]), .B2(n102), .ZN(
        n157) );
  OAI21_X1 U194 ( .B1(n95), .B2(n158), .A(n157), .ZN(n184) );
  INV_X1 U195 ( .A(DATA_2[25]), .ZN(n160) );
  AOI22_X1 U196 ( .A1(DATA_1[25]), .A2(n104), .B1(Add_0[25]), .B2(n92), .ZN(
        n159) );
  INV_X1 U197 ( .A(DATA_2[26]), .ZN(n163) );
  INV_X1 U198 ( .A(DATA_1[26]), .ZN(n162) );
  NAND2_X1 U199 ( .A1(Add_0[26]), .A2(n102), .ZN(n161) );
  INV_X1 U200 ( .A(DATA_2[27]), .ZN(n164) );
  INV_X1 U201 ( .A(DATA_2[28]), .ZN(n166) );
  AOI22_X1 U202 ( .A1(DATA_1[28]), .A2(n105), .B1(Add_0[28]), .B2(n101), .ZN(
        n165) );
  OAI21_X1 U203 ( .B1(n95), .B2(n166), .A(n165), .ZN(n180) );
  INV_X1 U204 ( .A(DATA_2[29]), .ZN(n168) );
  AOI22_X1 U205 ( .A1(DATA_1[29]), .A2(n105), .B1(Add_0[29]), .B2(n93), .ZN(
        n167) );
  INV_X1 U206 ( .A(DATA_1[30]), .ZN(n171) );
  INV_X1 U207 ( .A(DATA_2[30]), .ZN(n170) );
  NAND2_X1 U208 ( .A1(Add_0[30]), .A2(n173), .ZN(n169) );
  INV_X1 U209 ( .A(DATA_2[31]), .ZN(n175) );
  NAND2_X1 add_10_U359 ( .A1(DATA_1[5]), .A2(DATA_2[5]), .ZN(add_10_n327) );
  NAND3_X1 add_10_U358 ( .A1(add_10_n323), .A2(add_10_n324), .A3(add_10_n325), 
        .ZN(add_10_n322) );
  INV_X1 add_10_U357 ( .A(add_10_n109), .ZN(add_10_n102) );
  NAND3_X1 add_10_U356 ( .A1(add_10_n135), .A2(add_10_n132), .A3(add_10_n317), 
        .ZN(add_10_n106) );
  NAND3_X1 add_10_U355 ( .A1(add_10_n305), .A2(add_10_n79), .A3(add_10_n36), 
        .ZN(add_10_n303) );
  INV_X1 add_10_U354 ( .A(add_10_n34), .ZN(add_10_n296) );
  INV_X1 add_10_U353 ( .A(add_10_n3), .ZN(add_10_n292) );
  INV_X1 add_10_U352 ( .A(add_10_n283), .ZN(add_10_n291) );
  NAND3_X1 add_10_U351 ( .A1(add_10_n288), .A2(add_10_n82), .A3(add_10_n81), 
        .ZN(add_10_n287) );
  XNOR2_X1 add_10_U350 ( .A(add_10_n280), .B(add_10_n281), .ZN(Add_0[14]) );
  INV_X1 add_10_U349 ( .A(add_10_n261), .ZN(add_10_n279) );
  NAND3_X1 add_10_U348 ( .A1(add_10_n284), .A2(add_10_n262), .A3(add_10_n8), 
        .ZN(add_10_n278) );
  NAND3_X1 add_10_U347 ( .A1(add_10_n278), .A2(add_10_n277), .A3(add_10_n260), 
        .ZN(add_10_n275) );
  NAND3_X1 add_10_U346 ( .A1(add_10_n272), .A2(add_10_n271), .A3(add_10_n273), 
        .ZN(add_10_n270) );
  NAND3_X1 add_10_U345 ( .A1(add_10_n270), .A2(add_10_n269), .A3(add_10_n105), 
        .ZN(add_10_n268) );
  NAND3_X1 add_10_U344 ( .A1(add_10_n268), .A2(add_10_n109), .A3(add_10_n71), 
        .ZN(add_10_n264) );
  NAND2_X1 add_10_U343 ( .A1(DATA_1[12]), .A2(DATA_2[12]), .ZN(add_10_n259) );
  INV_X1 add_10_U342 ( .A(add_10_n258), .ZN(add_10_n257) );
  INV_X1 add_10_U341 ( .A(add_10_n223), .ZN(add_10_n237) );
  OAI21_X1 add_10_U340 ( .B1(add_10_n57), .B2(add_10_n237), .A(add_10_n5), 
        .ZN(add_10_n235) );
  XNOR2_X1 add_10_U339 ( .A(add_10_n235), .B(add_10_n236), .ZN(Add_0[17]) );
  INV_X1 add_10_U338 ( .A(add_10_n219), .ZN(add_10_n234) );
  XNOR2_X1 add_10_U337 ( .A(add_10_n230), .B(add_10_n231), .ZN(Add_0[18]) );
  INV_X1 add_10_U336 ( .A(add_10_n230), .ZN(add_10_n228) );
  INV_X1 add_10_U335 ( .A(add_10_n217), .ZN(add_10_n229) );
  OAI21_X1 add_10_U334 ( .B1(add_10_n228), .B2(add_10_n229), .A(add_10_n222), 
        .ZN(add_10_n226) );
  XNOR2_X1 add_10_U333 ( .A(add_10_n226), .B(add_10_n227), .ZN(Add_0[19]) );
  NAND3_X1 add_10_U332 ( .A1(add_10_n216), .A2(add_10_n217), .A3(add_10_n218), 
        .ZN(add_10_n215) );
  OAI21_X1 add_10_U331 ( .B1(add_10_n57), .B2(add_10_n202), .A(add_10_n211), 
        .ZN(add_10_n212) );
  XNOR2_X1 add_10_U330 ( .A(add_10_n212), .B(add_10_n213), .ZN(Add_0[20]) );
  INV_X1 add_10_U329 ( .A(add_10_n202), .ZN(add_10_n162) );
  INV_X1 add_10_U328 ( .A(add_10_n208), .ZN(add_10_n206) );
  INV_X1 add_10_U327 ( .A(add_10_n187), .ZN(add_10_n207) );
  OAI21_X1 add_10_U326 ( .B1(add_10_n206), .B2(add_10_n207), .A(add_10_n195), 
        .ZN(add_10_n204) );
  XNOR2_X1 add_10_U325 ( .A(add_10_n204), .B(add_10_n205), .ZN(Add_0[22]) );
  NAND3_X1 add_10_U324 ( .A1(add_10_n195), .A2(add_10_n196), .A3(add_10_n203), 
        .ZN(add_10_n200) );
  XNOR2_X1 add_10_U323 ( .A(add_10_n178), .B(add_10_n182), .ZN(Add_0[24]) );
  INV_X1 add_10_U322 ( .A(add_10_n156), .ZN(add_10_n181) );
  NAND3_X1 add_10_U321 ( .A1(add_10_n169), .A2(add_10_n159), .A3(add_10_n173), 
        .ZN(add_10_n170) );
  NAND3_X1 add_10_U320 ( .A1(add_10_n65), .A2(add_10_n160), .A3(add_10_n161), 
        .ZN(add_10_n158) );
  INV_X1 add_10_U319 ( .A(add_10_n143), .ZN(add_10_n142) );
  NAND2_X1 add_10_U318 ( .A1(add_10_n139), .A2(add_10_n140), .ZN(add_10_n137)
         );
  INV_X1 add_10_U317 ( .A(add_10_n130), .ZN(add_10_n128) );
  INV_X1 add_10_U316 ( .A(add_10_n118), .ZN(add_10_n129) );
  OAI21_X1 add_10_U315 ( .B1(add_10_n128), .B2(add_10_n129), .A(add_10_n123), 
        .ZN(add_10_n126) );
  XNOR2_X1 add_10_U314 ( .A(add_10_n126), .B(add_10_n127), .ZN(Add_0[30]) );
  NAND3_X1 add_10_U313 ( .A1(add_10_n123), .A2(add_10_n124), .A3(add_10_n125), 
        .ZN(add_10_n119) );
  INV_X1 add_10_U312 ( .A(add_10_n111), .ZN(add_10_n110) );
  OAI21_X1 add_10_U311 ( .B1(add_10_n110), .B2(add_10_n26), .A(add_10_n48), 
        .ZN(add_10_n107) );
  XNOR2_X1 add_10_U310 ( .A(add_10_n107), .B(add_10_n108), .ZN(Add_0[3]) );
  XNOR2_X1 add_10_U309 ( .A(add_10_n99), .B(add_10_n101), .ZN(Add_0[4]) );
  INV_X1 add_10_U308 ( .A(add_10_n94), .ZN(add_10_n96) );
  XNOR2_X1 add_10_U307 ( .A(add_10_n64), .B(add_10_n95), .ZN(Add_0[5]) );
  XNOR2_X1 add_10_U306 ( .A(add_10_n39), .B(add_10_n93), .ZN(Add_0[6]) );
  OAI21_X1 add_10_U305 ( .B1(add_10_n245), .B2(add_10_n246), .A(add_10_n72), 
        .ZN(add_10_n244) );
  AOI21_X1 add_10_U304 ( .B1(add_10_n11), .B2(add_10_n2), .A(add_10_n33), .ZN(
        add_10_n286) );
  NAND2_X1 add_10_U303 ( .A1(add_10_n122), .A2(add_10_n185), .ZN(add_10_n184)
         );
  AOI21_X1 add_10_U302 ( .B1(add_10_n122), .B2(add_10_n61), .A(add_10_n141), 
        .ZN(add_10_n146) );
  AOI21_X1 add_10_U301 ( .B1(add_10_n40), .B2(add_10_n81), .A(add_10_n11), 
        .ZN(add_10_n293) );
  NAND2_X1 add_10_U300 ( .A1(add_10_n32), .A2(add_10_n72), .ZN(add_10_n301) );
  XNOR2_X1 add_10_U299 ( .A(add_10_n50), .B(add_10_n238), .ZN(Add_0[16]) );
  NAND2_X1 add_10_U298 ( .A1(add_10_n47), .A2(add_10_n295), .ZN(add_10_n251)
         );
  OAI211_X1 add_10_U297 ( .C1(add_10_n58), .C2(add_10_n121), .A(add_10_n125), 
        .B(add_10_n124), .ZN(add_10_n130) );
  OAI21_X1 add_10_U296 ( .B1(add_10_n58), .B2(add_10_n232), .A(add_10_n233), 
        .ZN(add_10_n230) );
  OAI21_X1 add_10_U295 ( .B1(add_10_n209), .B2(add_10_n58), .A(add_10_n210), 
        .ZN(add_10_n208) );
  OAI21_X1 add_10_U294 ( .B1(add_10_n114), .B2(add_10_n115), .A(add_10_n116), 
        .ZN(add_10_n112) );
  XNOR2_X1 add_10_U293 ( .A(add_10_n112), .B(add_10_n113), .ZN(Add_0[31]) );
  XNOR2_X1 add_10_U292 ( .A(add_10_n163), .B(add_10_n164), .ZN(Add_0[27]) );
  NOR2_X1 add_10_U291 ( .A1(add_10_n264), .A2(add_10_n265), .ZN(add_10_n252)
         );
  NOR2_X1 add_10_U290 ( .A1(add_10_n252), .A2(add_10_n253), .ZN(add_10_n239)
         );
  OAI211_X1 add_10_U289 ( .C1(add_10_n69), .C2(add_10_n259), .A(add_10_n260), 
        .B(add_10_n261), .ZN(add_10_n256) );
  NAND2_X1 add_10_U288 ( .A1(add_10_n46), .A2(add_10_n67), .ZN(add_10_n247) );
  AND2_X1 add_10_U287 ( .A1(add_10_n74), .A2(add_10_n247), .ZN(add_10_n294) );
  NAND2_X1 add_10_U286 ( .A1(add_10_n308), .A2(add_10_n70), .ZN(add_10_n305)
         );
  NAND2_X1 add_10_U285 ( .A1(add_10_n79), .A2(add_10_n70), .ZN(add_10_n84) );
  NAND2_X1 add_10_U284 ( .A1(add_10_n83), .A2(add_10_n70), .ZN(add_10_n80) );
  NAND2_X1 add_10_U283 ( .A1(add_10_n49), .A2(add_10_n260), .ZN(add_10_n281)
         );
  NAND2_X1 add_10_U282 ( .A1(add_10_n279), .A2(add_10_n14), .ZN(add_10_n277)
         );
  AOI21_X1 add_10_U281 ( .B1(add_10_n255), .B2(add_10_n256), .A(add_10_n257), 
        .ZN(add_10_n254) );
  NAND2_X1 add_10_U280 ( .A1(add_10_n38), .A2(add_10_n250), .ZN(add_10_n81) );
  NAND4_X1 add_10_U279 ( .A1(add_10_n100), .A2(add_10_n97), .A3(add_10_n13), 
        .A4(add_10_n38), .ZN(add_10_n274) );
  NAND2_X1 add_10_U278 ( .A1(add_10_n87), .A2(add_10_n9), .ZN(add_10_n86) );
  AOI21_X1 add_10_U277 ( .B1(add_10_n37), .B2(add_10_n242), .A(add_10_n243), 
        .ZN(add_10_n240) );
  NAND2_X1 add_10_U276 ( .A1(DATA_2[6]), .A2(DATA_1[6]), .ZN(add_10_n89) );
  NAND2_X1 add_10_U275 ( .A1(add_10_n13), .A2(add_10_n89), .ZN(add_10_n93) );
  NAND2_X1 add_10_U274 ( .A1(add_10_n90), .A2(add_10_n89), .ZN(add_10_n85) );
  AND2_X1 add_10_U273 ( .A1(add_10_n250), .A2(add_10_n9), .ZN(add_10_n242) );
  AND4_X1 add_10_U272 ( .A1(add_10_n100), .A2(add_10_n91), .A3(add_10_n97), 
        .A4(add_10_n88), .ZN(add_10_n71) );
  INV_X1 add_10_U271 ( .A(DATA_1[2]), .ZN(add_10_n316) );
  XNOR2_X1 add_10_U270 ( .A(add_10_n85), .B(add_10_n86), .ZN(Add_0[7]) );
  NAND4_X1 add_10_U269 ( .A1(add_10_n43), .A2(add_10_n267), .A3(add_10_n49), 
        .A4(add_10_n266), .ZN(add_10_n68) );
  INV_X1 add_10_U268 ( .A(DATA_1[11]), .ZN(add_10_n67) );
  NAND2_X1 add_10_U267 ( .A1(add_10_n78), .A2(add_10_n79), .ZN(add_10_n297) );
  NAND2_X1 add_10_U266 ( .A1(add_10_n80), .A2(add_10_n79), .ZN(add_10_n75) );
  OR2_X1 add_10_U265 ( .A1(DATA_2[8]), .A2(DATA_1[8]), .ZN(add_10_n70) );
  OAI21_X1 add_10_U264 ( .B1(add_10_n63), .B2(add_10_n200), .A(add_10_n201), 
        .ZN(add_10_n199) );
  NAND2_X1 add_10_U263 ( .A1(add_10_n199), .A2(add_10_n194), .ZN(add_10_n197)
         );
  OAI21_X1 add_10_U262 ( .B1(add_10_n165), .B2(add_10_n166), .A(add_10_n151), 
        .ZN(add_10_n163) );
  NOR2_X1 add_10_U261 ( .A1(add_10_n120), .A2(add_10_n119), .ZN(add_10_n114)
         );
  OAI21_X1 add_10_U260 ( .B1(add_10_n176), .B2(add_10_n168), .A(add_10_n169), 
        .ZN(add_10_n174) );
  XNOR2_X1 add_10_U259 ( .A(add_10_n174), .B(add_10_n175), .ZN(Add_0[26]) );
  OAI22_X1 add_10_U258 ( .A1(DATA_1[10]), .A2(DATA_2[10]), .B1(DATA_1[9]), 
        .B2(DATA_2[9]), .ZN(add_10_n249) );
  NAND2_X1 add_10_U257 ( .A1(DATA_2[10]), .A2(DATA_1[10]), .ZN(add_10_n299) );
  NAND3_X1 add_10_U256 ( .A1(add_10_n106), .A2(add_10_n105), .A3(add_10_n311), 
        .ZN(add_10_n310) );
  XNOR2_X1 add_10_U255 ( .A(DATA_2[31]), .B(DATA_1[31]), .ZN(add_10_n113) );
  NAND2_X1 add_10_U254 ( .A1(DATA_2[30]), .A2(DATA_1[30]), .ZN(add_10_n116) );
  OR2_X1 add_10_U253 ( .A1(DATA_2[0]), .A2(DATA_1[0]), .ZN(add_10_n312) );
  NAND2_X1 add_10_U252 ( .A1(DATA_2[29]), .A2(DATA_1[29]), .ZN(add_10_n123) );
  NAND2_X1 add_10_U251 ( .A1(add_10_n35), .A2(DATA_2[1]), .ZN(add_10_n134) );
  OR2_X2 add_10_U250 ( .A1(DATA_2[29]), .A2(DATA_1[29]), .ZN(add_10_n118) );
  NAND2_X1 add_10_U249 ( .A1(DATA_2[5]), .A2(DATA_1[5]), .ZN(add_10_n94) );
  NAND2_X1 add_10_U248 ( .A1(DATA_2[12]), .A2(DATA_1[12]), .ZN(add_10_n283) );
  OR2_X1 add_10_U247 ( .A1(DATA_2[10]), .A2(DATA_1[10]), .ZN(add_10_n73) );
  OR2_X1 add_10_U246 ( .A1(DATA_2[9]), .A2(DATA_1[9]), .ZN(add_10_n77) );
  NAND2_X1 add_10_U245 ( .A1(DATA_2[28]), .A2(DATA_1[28]), .ZN(add_10_n140) );
  NAND2_X1 add_10_U244 ( .A1(DATA_2[0]), .A2(DATA_1[0]), .ZN(add_10_n225) );
  NAND2_X1 add_10_U243 ( .A1(DATA_2[4]), .A2(DATA_1[4]), .ZN(add_10_n98) );
  OR2_X2 add_10_U242 ( .A1(DATA_2[28]), .A2(DATA_1[28]), .ZN(add_10_n138) );
  NAND2_X1 add_10_U241 ( .A1(DATA_2[27]), .A2(DATA_1[27]), .ZN(add_10_n150) );
  NAND2_X1 add_10_U240 ( .A1(DATA_2[26]), .A2(DATA_1[26]), .ZN(add_10_n151) );
  NAND2_X1 add_10_U239 ( .A1(DATA_2[23]), .A2(DATA_1[23]), .ZN(add_10_n193) );
  NAND2_X1 add_10_U238 ( .A1(DATA_2[22]), .A2(DATA_1[22]), .ZN(add_10_n194) );
  NAND2_X1 add_10_U237 ( .A1(DATA_2[19]), .A2(DATA_1[19]), .ZN(add_10_n221) );
  NAND2_X1 add_10_U236 ( .A1(DATA_2[25]), .A2(DATA_1[25]), .ZN(add_10_n155) );
  NAND2_X1 add_10_U235 ( .A1(DATA_2[18]), .A2(DATA_1[18]), .ZN(add_10_n222) );
  NAND2_X1 add_10_U234 ( .A1(DATA_2[24]), .A2(DATA_1[24]), .ZN(add_10_n156) );
  NAND2_X1 add_10_U233 ( .A1(DATA_2[21]), .A2(DATA_1[21]), .ZN(add_10_n195) );
  NAND2_X1 add_10_U232 ( .A1(DATA_2[9]), .A2(DATA_1[9]), .ZN(add_10_n78) );
  NAND2_X1 add_10_U231 ( .A1(DATA_2[15]), .A2(DATA_1[15]), .ZN(add_10_n258) );
  NAND2_X1 add_10_U230 ( .A1(DATA_2[20]), .A2(DATA_1[20]), .ZN(add_10_n196) );
  OR2_X2 add_10_U229 ( .A1(DATA_2[26]), .A2(DATA_1[26]), .ZN(add_10_n154) );
  OR2_X2 add_10_U228 ( .A1(DATA_2[25]), .A2(DATA_1[25]), .ZN(add_10_n153) );
  NAND2_X1 add_10_U227 ( .A1(DATA_2[14]), .A2(DATA_1[14]), .ZN(add_10_n260) );
  NAND2_X1 add_10_U226 ( .A1(DATA_2[11]), .A2(DATA_1[11]), .ZN(add_10_n298) );
  NAND2_X1 add_10_U225 ( .A1(DATA_2[17]), .A2(DATA_1[17]), .ZN(add_10_n219) );
  NAND2_X1 add_10_U224 ( .A1(DATA_2[13]), .A2(DATA_1[13]), .ZN(add_10_n261) );
  NAND2_X1 add_10_U223 ( .A1(DATA_2[3]), .A2(DATA_1[3]), .ZN(add_10_n103) );
  OR2_X1 add_10_U222 ( .A1(DATA_2[18]), .A2(DATA_1[18]), .ZN(add_10_n217) );
  NAND2_X1 add_10_U221 ( .A1(DATA_2[2]), .A2(DATA_1[2]), .ZN(add_10_n104) );
  NAND2_X1 add_10_U220 ( .A1(DATA_2[7]), .A2(DATA_1[7]), .ZN(add_10_n87) );
  OR2_X2 add_10_U219 ( .A1(DATA_2[19]), .A2(DATA_1[19]), .ZN(add_10_n160) );
  NAND2_X1 add_10_U218 ( .A1(DATA_2[16]), .A2(DATA_1[16]), .ZN(add_10_n220) );
  INV_X1 add_10_U217 ( .A(DATA_2[5]), .ZN(add_10_n320) );
  INV_X1 add_10_U216 ( .A(DATA_1[5]), .ZN(add_10_n321) );
  OR2_X2 add_10_U215 ( .A1(DATA_2[7]), .A2(DATA_1[7]), .ZN(add_10_n88) );
  INV_X1 add_10_U214 ( .A(DATA_2[1]), .ZN(add_10_n313) );
  INV_X1 add_10_U213 ( .A(DATA_2[2]), .ZN(add_10_n315) );
  INV_X1 add_10_U212 ( .A(DATA_2[6]), .ZN(add_10_n318) );
  INV_X1 add_10_U211 ( .A(DATA_1[1]), .ZN(add_10_n314) );
  AND2_X1 add_10_U210 ( .A1(DATA_2[0]), .A2(DATA_1[0]), .ZN(add_10_n317) );
  AND2_X1 add_10_U209 ( .A1(DATA_2[0]), .A2(DATA_1[0]), .ZN(add_10_n273) );
  INV_X1 add_10_U208 ( .A(DATA_1[6]), .ZN(add_10_n319) );
  XNOR2_X1 add_10_U207 ( .A(add_10_n144), .B(add_10_n145), .ZN(Add_0[28]) );
  XNOR2_X1 add_10_U206 ( .A(add_10_n111), .B(add_10_n131), .ZN(Add_0[2]) );
  XNOR2_X1 add_10_U205 ( .A(add_10_n289), .B(add_10_n290), .ZN(Add_0[12]) );
  XNOR2_X1 add_10_U204 ( .A(add_10_n306), .B(add_10_n307), .ZN(Add_0[10]) );
  XNOR2_X1 add_10_U203 ( .A(add_10_n83), .B(add_10_n84), .ZN(Add_0[8]) );
  NOR2_X1 add_10_U202 ( .A1(DATA_1[6]), .A2(DATA_2[6]), .ZN(add_10_n326) );
  XNOR2_X1 add_10_U201 ( .A(add_10_n179), .B(add_10_n180), .ZN(Add_0[25]) );
  XNOR2_X1 add_10_U200 ( .A(add_10_n75), .B(add_10_n76), .ZN(Add_0[9]) );
  XNOR2_X1 add_10_U199 ( .A(add_10_n136), .B(add_10_n224), .ZN(Add_0[1]) );
  XNOR2_X1 add_10_U198 ( .A(add_10_n275), .B(add_10_n276), .ZN(Add_0[15]) );
  XNOR2_X1 add_10_U197 ( .A(add_10_n284), .B(add_10_n285), .ZN(Add_0[13]) );
  XNOR2_X1 add_10_U196 ( .A(add_10_n300), .B(add_10_n301), .ZN(Add_0[11]) );
  NAND2_X1 add_10_U195 ( .A1(add_10_n73), .A2(add_10_n44), .ZN(add_10_n307) );
  NAND2_X1 add_10_U194 ( .A1(add_10_n109), .A2(add_10_n45), .ZN(add_10_n108)
         );
  NAND2_X1 add_10_U193 ( .A1(add_10_n217), .A2(add_10_n222), .ZN(add_10_n231)
         );
  NAND2_X1 add_10_U192 ( .A1(add_10_n24), .A2(add_10_n48), .ZN(add_10_n131) );
  NAND2_X1 add_10_U191 ( .A1(add_10_n98), .A2(add_10_n100), .ZN(add_10_n101)
         );
  NAND2_X1 add_10_U190 ( .A1(add_10_n223), .A2(add_10_n5), .ZN(add_10_n238) );
  NAND2_X1 add_10_U189 ( .A1(add_10_n157), .A2(add_10_n156), .ZN(add_10_n182)
         );
  NAND2_X1 add_10_U188 ( .A1(add_10_n7), .A2(add_10_n134), .ZN(add_10_n224) );
  NAND2_X1 add_10_U187 ( .A1(add_10_n186), .A2(add_10_n196), .ZN(add_10_n213)
         );
  NAND2_X1 add_10_U186 ( .A1(add_10_n216), .A2(add_10_n219), .ZN(add_10_n236)
         );
  NAND2_X1 add_10_U185 ( .A1(add_10_n8), .A2(add_10_n15), .ZN(add_10_n285) );
  NAND2_X1 add_10_U184 ( .A1(add_10_n138), .A2(add_10_n140), .ZN(add_10_n145)
         );
  NAND2_X1 add_10_U183 ( .A1(add_10_n77), .A2(add_10_n78), .ZN(add_10_n76) );
  NAND2_X1 add_10_U182 ( .A1(add_10_n258), .A2(add_10_n42), .ZN(add_10_n276)
         );
  NOR2_X1 add_10_U181 ( .A1(add_10_n33), .A2(add_10_n291), .ZN(add_10_n290) );
  AND2_X1 add_10_U180 ( .A1(add_10_n155), .A2(add_10_n153), .ZN(add_10_n180)
         );
  NOR2_X1 add_10_U179 ( .A1(add_10_n96), .A2(add_10_n12), .ZN(add_10_n95) );
  AND2_X1 add_10_U178 ( .A1(add_10_n187), .A2(add_10_n188), .ZN(add_10_n201)
         );
  NAND2_X1 add_10_U177 ( .A1(add_10_n314), .A2(add_10_n313), .ZN(add_10_n135)
         );
  INV_X1 add_10_U176 ( .A(add_10_n225), .ZN(add_10_n136) );
  NAND2_X1 add_10_U175 ( .A1(add_10_n7), .A2(add_10_n136), .ZN(add_10_n133) );
  NAND2_X1 add_10_U174 ( .A1(add_10_n133), .A2(add_10_n134), .ZN(add_10_n111)
         );
  NAND2_X1 add_10_U173 ( .A1(add_10_n157), .A2(add_10_n153), .ZN(add_10_n168)
         );
  NAND2_X1 add_10_U172 ( .A1(add_10_n155), .A2(add_10_n156), .ZN(add_10_n177)
         );
  NAND2_X1 add_10_U171 ( .A1(add_10_n177), .A2(add_10_n153), .ZN(add_10_n169)
         );
  NAND2_X1 add_10_U170 ( .A1(add_10_n282), .A2(add_10_n283), .ZN(add_10_n284)
         );
  NAND2_X1 add_10_U169 ( .A1(add_10_n153), .A2(add_10_n154), .ZN(add_10_n152)
         );
  NAND2_X1 add_10_U168 ( .A1(add_10_n137), .A2(add_10_n138), .ZN(add_10_n124)
         );
  NOR2_X1 add_10_U167 ( .A1(add_10_n18), .A2(add_10_n152), .ZN(add_10_n147) );
  NAND2_X1 add_10_U166 ( .A1(add_10_n150), .A2(add_10_n151), .ZN(add_10_n148)
         );
  OAI21_X1 add_10_U165 ( .B1(add_10_n147), .B2(add_10_n148), .A(add_10_n149), 
        .ZN(add_10_n139) );
  NAND2_X1 add_10_U164 ( .A1(add_10_n187), .A2(add_10_n188), .ZN(add_10_n191)
         );
  AND2_X1 add_10_U163 ( .A1(add_10_n193), .A2(add_10_n194), .ZN(add_10_n192)
         );
  OAI21_X1 add_10_U162 ( .B1(add_10_n19), .B2(add_10_n191), .A(add_10_n192), 
        .ZN(add_10_n190) );
  NAND2_X1 add_10_U161 ( .A1(add_10_n190), .A2(add_10_n189), .ZN(add_10_n159)
         );
  NAND4_X1 add_10_U160 ( .A1(add_10_n157), .A2(add_10_n153), .A3(add_10_n154), 
        .A4(add_10_n149), .ZN(add_10_n143) );
  NAND2_X1 add_10_U159 ( .A1(add_10_n158), .A2(add_10_n159), .ZN(add_10_n141)
         );
  NAND2_X1 add_10_U158 ( .A1(add_10_n27), .A2(add_10_n23), .ZN(add_10_n306) );
  AND4_X1 add_10_U157 ( .A1(add_10_n186), .A2(add_10_n187), .A3(add_10_n188), 
        .A4(add_10_n189), .ZN(add_10_n65) );
  NAND2_X1 add_10_U156 ( .A1(add_10_n6), .A2(add_10_n186), .ZN(add_10_n203) );
  AND2_X1 add_10_U155 ( .A1(add_10_n73), .A2(add_10_n77), .ZN(add_10_n304) );
  NAND2_X1 add_10_U154 ( .A1(add_10_n303), .A2(add_10_n304), .ZN(add_10_n302)
         );
  NAND2_X1 add_10_U153 ( .A1(add_10_n302), .A2(add_10_n44), .ZN(add_10_n300)
         );
  NAND2_X1 add_10_U152 ( .A1(add_10_n82), .A2(add_10_n81), .ZN(add_10_n308) );
  AND2_X1 add_10_U151 ( .A1(add_10_n104), .A2(add_10_n103), .ZN(add_10_n269)
         );
  OAI21_X1 add_10_U150 ( .B1(add_10_n17), .B2(add_10_n10), .A(add_10_n15), 
        .ZN(add_10_n280) );
  NAND2_X1 add_10_U149 ( .A1(add_10_n318), .A2(add_10_n319), .ZN(add_10_n324)
         );
  NAND4_X1 add_10_U148 ( .A1(add_10_n223), .A2(add_10_n216), .A3(add_10_n217), 
        .A4(add_10_n160), .ZN(add_10_n202) );
  NAND2_X1 add_10_U147 ( .A1(add_10_n320), .A2(add_10_n321), .ZN(add_10_n323)
         );
  NAND2_X1 add_10_U146 ( .A1(add_10_n219), .A2(add_10_n220), .ZN(add_10_n218)
         );
  AND2_X1 add_10_U145 ( .A1(add_10_n221), .A2(add_10_n222), .ZN(add_10_n214)
         );
  NAND2_X1 add_10_U144 ( .A1(add_10_n215), .A2(add_10_n214), .ZN(add_10_n161)
         );
  NAND2_X1 add_10_U143 ( .A1(add_10_n298), .A2(add_10_n299), .ZN(add_10_n246)
         );
  AND2_X1 add_10_U142 ( .A1(add_10_n104), .A2(add_10_n45), .ZN(add_10_n311) );
  NOR2_X1 add_10_U141 ( .A1(add_10_n102), .A2(add_10_n274), .ZN(add_10_n309)
         );
  NAND2_X1 add_10_U140 ( .A1(add_10_n310), .A2(add_10_n309), .ZN(add_10_n82)
         );
  NAND2_X1 add_10_U139 ( .A1(add_10_n154), .A2(add_10_n151), .ZN(add_10_n175)
         );
  NAND2_X1 add_10_U138 ( .A1(add_10_n51), .A2(add_10_n52), .ZN(add_10_n271) );
  NAND2_X1 add_10_U137 ( .A1(add_10_n92), .A2(add_10_n91), .ZN(add_10_n90) );
  AOI21_X1 add_10_U136 ( .B1(add_10_n100), .B2(add_10_n99), .A(add_10_n325), 
        .ZN(add_10_n64) );
  OAI21_X1 add_10_U135 ( .B1(add_10_n64), .B2(add_10_n12), .A(add_10_n94), 
        .ZN(add_10_n92) );
  AOI21_X1 add_10_U134 ( .B1(add_10_n178), .B2(add_10_n157), .A(add_10_n181), 
        .ZN(add_10_n179) );
  NAND2_X1 add_10_U133 ( .A1(add_10_n315), .A2(add_10_n316), .ZN(add_10_n272)
         );
  AND3_X1 add_10_U132 ( .A1(add_10_n122), .A2(add_10_n162), .A3(add_10_n186), 
        .ZN(add_10_n63) );
  NAND2_X1 add_10_U131 ( .A1(add_10_n189), .A2(add_10_n193), .ZN(add_10_n198)
         );
  XNOR2_X1 add_10_U130 ( .A(add_10_n197), .B(add_10_n198), .ZN(Add_0[23]) );
  NOR2_X1 add_10_U129 ( .A1(add_10_n249), .A2(add_10_n248), .ZN(add_10_n245)
         );
  AND4_X1 add_10_U128 ( .A1(add_10_n267), .A2(add_10_n266), .A3(add_10_n262), 
        .A4(add_10_n43), .ZN(add_10_n62) );
  NAND2_X1 add_10_U127 ( .A1(add_10_n167), .A2(add_10_n154), .ZN(add_10_n166)
         );
  NAND2_X1 add_10_U126 ( .A1(add_10_n149), .A2(add_10_n150), .ZN(add_10_n164)
         );
  NAND2_X1 add_10_U125 ( .A1(add_10_n160), .A2(add_10_n221), .ZN(add_10_n227)
         );
  NAND2_X1 add_10_U124 ( .A1(add_10_n216), .A2(add_10_n223), .ZN(add_10_n232)
         );
  AOI21_X1 add_10_U123 ( .B1(add_10_n16), .B2(add_10_n216), .A(add_10_n234), 
        .ZN(add_10_n233) );
  NAND2_X1 add_10_U122 ( .A1(add_10_n188), .A2(add_10_n194), .ZN(add_10_n205)
         );
  NAND2_X1 add_10_U121 ( .A1(add_10_n186), .A2(add_10_n162), .ZN(add_10_n209)
         );
  NAND2_X1 add_10_U120 ( .A1(add_10_n117), .A2(add_10_n118), .ZN(add_10_n115)
         );
  INV_X1 add_10_U119 ( .A(add_10_n254), .ZN(add_10_n253) );
  AND2_X1 add_10_U118 ( .A1(add_10_n263), .A2(add_10_n41), .ZN(add_10_n255) );
  NAND2_X1 add_10_U117 ( .A1(add_10_n116), .A2(add_10_n117), .ZN(add_10_n127)
         );
  NAND2_X1 add_10_U116 ( .A1(add_10_n168), .A2(add_10_n169), .ZN(add_10_n167)
         );
  NAND2_X1 add_10_U115 ( .A1(add_10_n40), .A2(add_10_n81), .ZN(add_10_n83) );
  NOR2_X1 add_10_U114 ( .A1(add_10_n292), .A2(add_10_n293), .ZN(add_10_n289)
         );
  NAND2_X1 add_10_U113 ( .A1(add_10_n66), .A2(add_10_n141), .ZN(add_10_n125)
         );
  OAI21_X1 add_10_U112 ( .B1(add_10_n146), .B2(add_10_n143), .A(add_10_n139), 
        .ZN(add_10_n144) );
  NAND2_X1 add_10_U111 ( .A1(add_10_n162), .A2(add_10_n65), .ZN(add_10_n172)
         );
  NAND2_X1 add_10_U110 ( .A1(add_10_n61), .A2(add_10_n66), .ZN(add_10_n121) );
  AND2_X1 add_10_U109 ( .A1(add_10_n162), .A2(add_10_n65), .ZN(add_10_n61) );
  NAND2_X1 add_10_U108 ( .A1(add_10_n6), .A2(add_10_n65), .ZN(add_10_n173) );
  INV_X1 add_10_U107 ( .A(add_10_n172), .ZN(add_10_n185) );
  AND2_X1 add_10_U106 ( .A1(add_10_n159), .A2(add_10_n173), .ZN(add_10_n183)
         );
  NOR2_X1 add_10_U105 ( .A1(add_10_n172), .A2(add_10_n58), .ZN(add_10_n171) );
  NOR2_X1 add_10_U104 ( .A1(add_10_n171), .A2(add_10_n170), .ZN(add_10_n165)
         );
  NAND2_X1 add_10_U103 ( .A1(add_10_n239), .A2(add_10_n240), .ZN(add_10_n122)
         );
  NOR2_X1 add_10_U102 ( .A1(add_10_n121), .A2(add_10_n58), .ZN(add_10_n120) );
  NOR2_X1 add_10_U101 ( .A1(DATA_2[10]), .A2(DATA_1[10]), .ZN(add_10_n60) );
  NOR2_X1 add_10_U100 ( .A1(DATA_2[8]), .A2(DATA_1[8]), .ZN(add_10_n59) );
  OR2_X1 add_10_U99 ( .A1(DATA_2[30]), .A2(DATA_1[30]), .ZN(add_10_n117) );
  OR2_X1 add_10_U98 ( .A1(DATA_2[24]), .A2(DATA_1[24]), .ZN(add_10_n157) );
  OR2_X1 add_10_U97 ( .A1(DATA_2[27]), .A2(DATA_1[27]), .ZN(add_10_n149) );
  OR2_X1 add_10_U96 ( .A1(DATA_2[20]), .A2(DATA_1[20]), .ZN(add_10_n186) );
  OR2_X1 add_10_U95 ( .A1(DATA_2[23]), .A2(DATA_1[23]), .ZN(add_10_n189) );
  OR2_X1 add_10_U94 ( .A1(DATA_2[16]), .A2(DATA_1[16]), .ZN(add_10_n223) );
  OR2_X1 add_10_U93 ( .A1(DATA_2[22]), .A2(DATA_1[22]), .ZN(add_10_n188) );
  OR2_X1 add_10_U92 ( .A1(DATA_2[21]), .A2(DATA_1[21]), .ZN(add_10_n187) );
  OR2_X1 add_10_U91 ( .A1(DATA_2[3]), .A2(DATA_1[3]), .ZN(add_10_n109) );
  AND2_X1 add_10_U90 ( .A1(DATA_2[4]), .A2(DATA_1[4]), .ZN(add_10_n325) );
  AND2_X1 add_10_U89 ( .A1(add_10_n142), .A2(add_10_n138), .ZN(add_10_n66) );
  AND2_X2 add_10_U88 ( .A1(add_10_n239), .A2(add_10_n53), .ZN(add_10_n58) );
  OR2_X2 add_10_U87 ( .A1(DATA_2[6]), .A2(DATA_1[6]), .ZN(add_10_n91) );
  OR2_X2 add_10_U86 ( .A1(DATA_2[4]), .A2(DATA_1[4]), .ZN(add_10_n100) );
  NOR2_X1 add_10_U85 ( .A1(add_10_n59), .A2(add_10_n60), .ZN(add_10_n295) );
  CLKBUF_X1 add_10_U84 ( .A(add_10_n58), .Z(add_10_n57) );
  INV_X1 add_10_U83 ( .A(add_10_n72), .ZN(add_10_n56) );
  OR2_X1 add_10_U82 ( .A1(add_10_n56), .A2(add_10_n4), .ZN(add_10_n55) );
  AOI21_X1 add_10_U81 ( .B1(add_10_n242), .B2(add_10_n241), .A(add_10_n243), 
        .ZN(add_10_n53) );
  INV_X1 add_10_U80 ( .A(DATA_1[1]), .ZN(add_10_n52) );
  INV_X1 add_10_U79 ( .A(DATA_2[1]), .ZN(add_10_n51) );
  CLKBUF_X1 add_10_U78 ( .A(add_10_n122), .Z(add_10_n50) );
  AND2_X1 add_10_U77 ( .A1(add_10_n74), .A2(add_10_n247), .ZN(add_10_n47) );
  INV_X1 add_10_U76 ( .A(DATA_2[11]), .ZN(add_10_n46) );
  NAND3_X1 add_10_U75 ( .A1(add_10_n62), .A2(add_10_n295), .A3(add_10_n294), 
        .ZN(add_10_n265) );
  NOR2_X1 add_10_U74 ( .A1(add_10_n244), .A2(add_10_n68), .ZN(add_10_n243) );
  NAND2_X1 add_10_U73 ( .A1(add_10_n184), .A2(add_10_n183), .ZN(add_10_n178)
         );
  OR2_X2 add_10_U72 ( .A1(DATA_2[5]), .A2(DATA_1[5]), .ZN(add_10_n97) );
  OR2_X2 add_10_U71 ( .A1(DATA_2[17]), .A2(DATA_1[17]), .ZN(add_10_n216) );
  AND2_X1 add_10_U70 ( .A1(add_10_n196), .A2(add_10_n203), .ZN(add_10_n210) );
  AND2_X1 add_10_U69 ( .A1(add_10_n184), .A2(add_10_n183), .ZN(add_10_n176) );
  NAND2_X1 add_10_U68 ( .A1(add_10_n287), .A2(add_10_n286), .ZN(add_10_n282)
         );
  AOI22_X1 add_10_U67 ( .A1(DATA_2[9]), .A2(DATA_1[9]), .B1(DATA_2[8]), .B2(
        DATA_1[8]), .ZN(add_10_n248) );
  NOR2_X1 add_10_U66 ( .A1(add_10_n251), .A2(add_10_n68), .ZN(add_10_n241) );
  NAND3_X1 add_10_U65 ( .A1(add_10_n297), .A2(add_10_n296), .A3(add_10_n72), 
        .ZN(add_10_n54) );
  NAND2_X1 add_10_U64 ( .A1(DATA_2[8]), .A2(DATA_1[8]), .ZN(add_10_n79) );
  NAND3_X1 add_10_U63 ( .A1(add_10_n22), .A2(add_10_n21), .A3(add_10_n322), 
        .ZN(add_10_n250) );
  NAND2_X1 add_10_U62 ( .A1(DATA_2[3]), .A2(DATA_1[3]), .ZN(add_10_n45) );
  NAND2_X1 add_10_U61 ( .A1(DATA_2[10]), .A2(DATA_1[10]), .ZN(add_10_n44) );
  OR2_X1 add_10_U60 ( .A1(DATA_2[15]), .A2(DATA_1[15]), .ZN(add_10_n263) );
  OR2_X1 add_10_U59 ( .A1(DATA_2[15]), .A2(DATA_1[15]), .ZN(add_10_n43) );
  OR2_X1 add_10_U58 ( .A1(DATA_2[15]), .A2(DATA_1[15]), .ZN(add_10_n42) );
  OR2_X1 add_10_U57 ( .A1(DATA_2[14]), .A2(DATA_1[14]), .ZN(add_10_n49) );
  OR2_X2 add_10_U56 ( .A1(DATA_2[14]), .A2(DATA_1[14]), .ZN(add_10_n41) );
  NAND2_X1 add_10_U55 ( .A1(add_10_n310), .A2(add_10_n309), .ZN(add_10_n40) );
  OR2_X2 add_10_U54 ( .A1(DATA_2[7]), .A2(DATA_1[7]), .ZN(add_10_n38) );
  NOR2_X1 add_10_U53 ( .A1(DATA_2[13]), .A2(DATA_1[13]), .ZN(add_10_n69) );
  NOR2_X1 add_10_U52 ( .A1(add_10_n251), .A2(add_10_n68), .ZN(add_10_n37) );
  CLKBUF_X1 add_10_U51 ( .A(add_10_n78), .Z(add_10_n36) );
  INV_X1 add_10_U50 ( .A(add_10_n314), .ZN(add_10_n35) );
  OAI22_X1 add_10_U49 ( .A1(DATA_1[10]), .A2(DATA_2[10]), .B1(DATA_1[9]), .B2(
        DATA_2[9]), .ZN(add_10_n34) );
  NOR2_X1 add_10_U48 ( .A1(DATA_2[12]), .A2(DATA_1[12]), .ZN(add_10_n33) );
  CLKBUF_X1 add_10_U47 ( .A(add_10_n298), .Z(add_10_n32) );
  OR2_X1 add_10_U46 ( .A1(DATA_1[9]), .A2(DATA_2[9]), .ZN(add_10_n74) );
  OAI21_X1 add_10_U45 ( .B1(add_10_n31), .B2(add_10_n102), .A(add_10_n103), 
        .ZN(add_10_n99) );
  BUF_X1 add_10_U44 ( .A(add_10_n92), .Z(add_10_n39) );
  AND3_X1 add_10_U43 ( .A1(add_10_n106), .A2(add_10_n105), .A3(add_10_n48), 
        .ZN(add_10_n31) );
  AND2_X1 add_10_U42 ( .A1(add_10_n70), .A2(add_10_n77), .ZN(add_10_n30) );
  INV_X1 add_10_U41 ( .A(add_10_n77), .ZN(add_10_n29) );
  OR2_X1 add_10_U40 ( .A1(add_10_n29), .A2(add_10_n79), .ZN(add_10_n28) );
  NAND2_X1 add_10_U39 ( .A1(add_10_n308), .A2(add_10_n30), .ZN(add_10_n27) );
  NOR2_X1 add_10_U38 ( .A1(DATA_2[2]), .A2(DATA_1[2]), .ZN(add_10_n26) );
  AND2_X1 add_10_U37 ( .A1(add_10_n187), .A2(add_10_n195), .ZN(add_10_n25) );
  XNOR2_X1 add_10_U36 ( .A(add_10_n206), .B(add_10_n25), .ZN(Add_0[21]) );
  BUF_X1 add_10_U35 ( .A(add_10_n132), .Z(add_10_n24) );
  AND2_X1 add_10_U34 ( .A1(add_10_n78), .A2(add_10_n28), .ZN(add_10_n23) );
  AND2_X1 add_10_U33 ( .A1(add_10_n87), .A2(add_10_n89), .ZN(add_10_n22) );
  OR2_X1 add_10_U32 ( .A1(add_10_n326), .A2(add_10_n327), .ZN(add_10_n21) );
  AND2_X1 add_10_U31 ( .A1(add_10_n225), .A2(add_10_n312), .ZN(Add_0[0]) );
  AND2_X1 add_10_U30 ( .A1(add_10_n195), .A2(add_10_n196), .ZN(add_10_n19) );
  AND2_X1 add_10_U29 ( .A1(add_10_n155), .A2(add_10_n156), .ZN(add_10_n18) );
  AND2_X1 add_10_U28 ( .A1(add_10_n282), .A2(add_10_n283), .ZN(add_10_n17) );
  OAI211_X1 add_10_U27 ( .C1(DATA_1[2]), .C2(DATA_2[2]), .A(DATA_1[1]), .B(
        DATA_2[1]), .ZN(add_10_n105) );
  OR2_X1 add_10_U26 ( .A1(DATA_2[12]), .A2(DATA_1[12]), .ZN(add_10_n266) );
  OR2_X1 add_10_U25 ( .A1(DATA_2[14]), .A2(DATA_1[14]), .ZN(add_10_n262) );
  AND2_X1 add_10_U24 ( .A1(DATA_2[16]), .A2(DATA_1[16]), .ZN(add_10_n16) );
  CLKBUF_X1 add_10_U23 ( .A(add_10_n261), .Z(add_10_n15) );
  OR2_X1 add_10_U22 ( .A1(DATA_2[14]), .A2(DATA_1[14]), .ZN(add_10_n14) );
  OR2_X2 add_10_U21 ( .A1(DATA_2[6]), .A2(DATA_1[6]), .ZN(add_10_n13) );
  CLKBUF_X1 add_10_U20 ( .A(add_10_n104), .Z(add_10_n48) );
  NOR2_X1 add_10_U19 ( .A1(DATA_2[5]), .A2(DATA_1[5]), .ZN(add_10_n12) );
  CLKBUF_X1 add_10_U18 ( .A(add_10_n251), .Z(add_10_n11) );
  BUF_X1 add_10_U17 ( .A(add_10_n69), .Z(add_10_n10) );
  OR2_X2 add_10_U16 ( .A1(DATA_2[7]), .A2(DATA_1[7]), .ZN(add_10_n9) );
  OR2_X1 add_10_U15 ( .A1(DATA_2[13]), .A2(DATA_1[13]), .ZN(add_10_n267) );
  OR2_X2 add_10_U14 ( .A1(DATA_2[13]), .A2(DATA_1[13]), .ZN(add_10_n8) );
  NAND2_X1 add_10_U13 ( .A1(add_10_n314), .A2(add_10_n313), .ZN(add_10_n7) );
  INV_X4 add_10_U12 ( .A(add_10_n6), .ZN(add_10_n211) );
  AND2_X2 add_10_U11 ( .A1(add_10_n161), .A2(add_10_n160), .ZN(add_10_n6) );
  NAND2_X1 add_10_U10 ( .A1(DATA_2[16]), .A2(DATA_1[16]), .ZN(add_10_n5) );
  AND2_X1 add_10_U9 ( .A1(add_10_n298), .A2(add_10_n299), .ZN(add_10_n4) );
  AND2_X1 add_10_U8 ( .A1(add_10_n54), .A2(add_10_n55), .ZN(add_10_n288) );
  AND2_X1 add_10_U7 ( .A1(add_10_n54), .A2(add_10_n55), .ZN(add_10_n3) );
  AND2_X1 add_10_U6 ( .A1(add_10_n54), .A2(add_10_n55), .ZN(add_10_n2) );
  OR2_X2 add_10_U5 ( .A1(DATA_2[11]), .A2(DATA_1[11]), .ZN(add_10_n72) );
  OR2_X2 add_10_U4 ( .A1(DATA_2[2]), .A2(DATA_1[2]), .ZN(add_10_n132) );
  AND2_X1 add_10_U3 ( .A1(add_10_n118), .A2(add_10_n123), .ZN(add_10_n1) );
  XNOR2_X1 add_10_U2 ( .A(add_10_n128), .B(add_10_n1), .ZN(Add_0[29]) );
endmodule

