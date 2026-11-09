/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:09:29 2025
/////////////////////////////////////////////////////////////


module fsm_encode ( clk, rst_n, start, data_in, data_out, done );
  input [7:0] data_in;
  output [7:0] data_out;
  input clk, rst_n, start;
  output done;
  wire   N169, N170, N171, N172, N173, N174, N175, N176, N177, N178, N179,
         N180, N181, N182, N183, N184, n72, n73, n74, n75, n76, n78, n79, n80,
         n81, n82, n83, n84, n85, n86, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101, n102, n103, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
         n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149,
         n150, n151, n152, n153, n154, n155, n156, n157, n158, n159, n160,
         n161, n162, n163, n164, n165, n166, n167, n168, n169, n170, n171,
         n172, n173, n174, n175, n176, n177, n178, n179, n180, n181, n182,
         n183, n184, n185, n186, n187, n188, n189, n190, n191, n192, n193,
         n194, n195, n196, n197, n198, n199, n200, n201, n202, n203, n204,
         n205, n206, n207, n208, n209, n210, n211, n212, n213, n214, n215,
         n216, n217, n218, n219, n220, n221, n222, n223, n224, n225, n226,
         n227, n228, n229, n230, n231, n232, n233, n234, n235, n236, n237,
         n238, n239, add_64_n73, add_64_n72, add_64_n71, add_64_n70,
         add_64_n69, add_64_n68, add_64_n67, add_64_n66, add_64_n65,
         add_64_n64, add_64_n63, add_64_n62, add_64_n61, add_64_n60,
         add_64_n59, add_64_n58, add_64_n57, add_64_n56, add_64_n55,
         add_64_n54, add_64_n53, add_64_n52, add_64_n51, add_64_n50,
         add_64_n49, add_64_n48, add_64_n47, add_64_n46, add_64_n45,
         add_64_n44, add_64_n43, add_64_n42, add_64_n41, add_64_n40,
         add_64_n39, add_64_n38, add_64_n37, add_64_n36, add_64_n35,
         add_64_n34, add_64_n33, add_64_n32, add_64_n31, add_64_n30,
         add_64_n29, add_64_n28, add_64_n27, add_64_n26, add_64_n25,
         add_64_n24, add_64_n23, add_64_n22, add_64_n21, add_64_n20,
         add_64_n19, add_64_n18, add_64_n17, add_64_n16, add_64_n15,
         add_64_n14, add_64_n13, add_64_n12, add_64_n11, add_64_n10, add_64_n9,
         add_64_n8, add_64_n6, add_64_n5, add_64_n4, add_64_n3, add_64_n2,
         add_64_n1, sub_67_n106, sub_67_n105, sub_67_n104, sub_67_n103,
         sub_67_n102, sub_67_n101, sub_67_n100, sub_67_n99, sub_67_n98,
         sub_67_n97, sub_67_n96, sub_67_n95, sub_67_n94, sub_67_n93,
         sub_67_n92, sub_67_n91, sub_67_n90, sub_67_n89, sub_67_n88,
         sub_67_n87, sub_67_n86, sub_67_n85, sub_67_n84, sub_67_n83,
         sub_67_n82, sub_67_n81, sub_67_n80, sub_67_n79, sub_67_n78,
         sub_67_n77, sub_67_n76, sub_67_n75, sub_67_n74, sub_67_n73,
         sub_67_n72, sub_67_n71, sub_67_n70, sub_67_n69, sub_67_n68,
         sub_67_n67, sub_67_n66, sub_67_n65, sub_67_n64, sub_67_n63,
         sub_67_n62, sub_67_n61, sub_67_n60, sub_67_n59, sub_67_n58,
         sub_67_n57, sub_67_n56, sub_67_n55, sub_67_n54, sub_67_n53,
         sub_67_n52, sub_67_n51, sub_67_n50, sub_67_n49, sub_67_n48,
         sub_67_n47, sub_67_n46, sub_67_n45, sub_67_n44, sub_67_n43,
         sub_67_n42, sub_67_n41, sub_67_n40, sub_67_n39, sub_67_n38,
         sub_67_n37, sub_67_n36, sub_67_n35, sub_67_n34, sub_67_n33,
         sub_67_n32, sub_67_n31, sub_67_n30, sub_67_n29, sub_67_n28,
         sub_67_n27, sub_67_n26, sub_67_n25, sub_67_n24, sub_67_n23,
         sub_67_n22, sub_67_n21, sub_67_n20, sub_67_n18, sub_67_n17,
         sub_67_n16, sub_67_n15, sub_67_n14, sub_67_n13, sub_67_n12,
         sub_67_n11, sub_67_n10, sub_67_n9, sub_67_n8, sub_67_n7, sub_67_n6,
         sub_67_n5, sub_67_n4, sub_67_n3, sub_67_n2, sub_67_n1;
  wire   [7:0] current_state;
  wire   [1:0] next_state;
  wire   [7:0] reg1;
  wire   [7:0] reg2;

  DFFS_X1 current_state_reg_0_ ( .D(next_state[0]), .CK(clk), .SN(n184), .Q(
        current_state[0]), .QN(n143) );
  DFFR_X1 current_state_reg_3_ ( .D(n117), .CK(clk), .RN(n184), .Q(
        current_state[3]), .QN(n152) );
  DFFR_X1 current_state_reg_4_ ( .D(n237), .CK(clk), .RN(n184), .Q(
        current_state[4]), .QN(n153) );
  DFFR_X1 current_state_reg_5_ ( .D(n99), .CK(clk), .RN(n184), .Q(
        current_state[5]), .QN(n161) );
  DFFR_X1 current_state_reg_2_ ( .D(n123), .CK(clk), .RN(n184), .Q(
        current_state[2]), .QN(n144) );
  DFFR_X1 done_reg ( .D(n96), .CK(clk), .RN(n184), .Q(done), .QN(n193) );
  DFFR_X1 reg2_reg_7_ ( .D(n95), .CK(clk), .RN(n183), .Q(reg2[7]), .QN(n103)
         );
  DFFR_X1 reg2_reg_5_ ( .D(n93), .CK(clk), .RN(n183), .Q(n151), .QN(n102) );
  DFFR_X1 reg2_reg_4_ ( .D(n92), .CK(clk), .RN(n183), .Q(n154), .QN(n101) );
  DFFR_X1 reg2_reg_3_ ( .D(n91), .CK(clk), .RN(n183), .Q(reg2[3]), .QN(n171)
         );
  DFFR_X1 reg2_reg_2_ ( .D(n90), .CK(clk), .RN(n183), .Q(reg2[2]), .QN(n169)
         );
  DFFR_X1 reg2_reg_1_ ( .D(n89), .CK(clk), .RN(n183), .Q(reg2[1]), .QN(n175)
         );
  DFFR_X1 reg2_reg_0_ ( .D(n88), .CK(clk), .RN(n183), .Q(reg2[0]), .QN(n166)
         );
  DFFR_X1 reg1_reg_7_ ( .D(n130), .CK(clk), .RN(n183), .Q(reg1[7]), .QN(n235)
         );
  DFFR_X1 reg1_reg_1_ ( .D(n85), .CK(clk), .RN(n183), .Q(reg1[1]), .QN(n164)
         );
  DFFR_X1 out_reg_reg_1_ ( .D(n84), .CK(clk), .RN(n183), .Q(data_out[1]), .QN(
        n218) );
  DFFR_X1 reg1_reg_2_ ( .D(n83), .CK(clk), .RN(n182), .Q(reg1[2]), .QN(n159)
         );
  DFFR_X1 out_reg_reg_2_ ( .D(n82), .CK(clk), .RN(n182), .Q(data_out[2]), .QN(
        n221) );
  DFFR_X1 reg1_reg_3_ ( .D(n81), .CK(clk), .RN(n182), .Q(reg1[3]), .QN(n177)
         );
  DFFR_X1 out_reg_reg_3_ ( .D(n80), .CK(clk), .RN(n182), .Q(data_out[3]), .QN(
        n224) );
  DFFR_X1 reg1_reg_4_ ( .D(n79), .CK(clk), .RN(n182), .Q(reg1[4]), .QN(n173)
         );
  DFFR_X1 out_reg_reg_4_ ( .D(n78), .CK(clk), .RN(n182), .Q(data_out[4]), .QN(
        n226) );
  DFFR_X1 reg1_reg_5_ ( .D(n129), .CK(clk), .RN(n182), .Q(reg1[5]), .QN(n162)
         );
  DFFR_X1 out_reg_reg_5_ ( .D(n76), .CK(clk), .RN(n182), .Q(data_out[5]), .QN(
        n228) );
  DFFR_X1 reg1_reg_6_ ( .D(n75), .CK(clk), .RN(n182), .Q(reg1[6]), .QN(n231)
         );
  DFFR_X1 out_reg_reg_6_ ( .D(n74), .CK(clk), .RN(n182), .Q(data_out[6]), .QN(
        n230) );
  DFFR_X1 out_reg_reg_7_ ( .D(n73), .CK(clk), .RN(n182), .Q(data_out[7]), .QN(
        n233) );
  DFFR_X1 out_reg_reg_0_ ( .D(n72), .CK(clk), .RN(n182), .Q(data_out[0]), .QN(
        n216) );
  DFFR_X1 reg1_reg_0_ ( .D(n86), .CK(clk), .RN(n183), .Q(reg1[0]), .QN(n155)
         );
  DFFR_X1 current_state_reg_7_ ( .D(n239), .CK(clk), .RN(n184), .Q(
        current_state[7]), .QN(n137) );
  DFFR_X1 reg2_reg_6_ ( .D(n94), .CK(clk), .RN(n183), .Q(reg2[6]), .QN(n100)
         );
  DFFR_X1 current_state_reg_6_ ( .D(n238), .CK(clk), .RN(n184), .Q(
        current_state[6]), .QN(n168) );
  DFFR_X2 current_state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(n184), .Q(
        current_state[1]), .QN(n142) );
  NAND3_X2 U105 ( .A1(n113), .A2(current_state[6]), .A3(n98), .ZN(n236) );
  AND3_X2 U106 ( .A1(n140), .A2(current_state[2]), .A3(n97), .ZN(n139) );
  AND3_X2 U107 ( .A1(n140), .A2(current_state[2]), .A3(n97), .ZN(n116) );
  INV_X1 U108 ( .A(current_state[0]), .ZN(n97) );
  AND2_X1 U109 ( .A1(n161), .A2(n137), .ZN(n98) );
  AND4_X2 U110 ( .A1(n168), .A2(n138), .A3(n114), .A4(n98), .ZN(n99) );
  AND2_X2 U111 ( .A1(n138), .A2(n115), .ZN(n113) );
  BUF_X1 U112 ( .A(current_state[4]), .Z(n114) );
  INV_X1 U113 ( .A(n114), .ZN(n115) );
  AND4_X2 U114 ( .A1(n187), .A2(n210), .A3(n189), .A4(n188), .ZN(n181) );
  AND4_X2 U115 ( .A1(current_state[1]), .A2(n157), .A3(n121), .A4(n152), .ZN(
        n123) );
  AND3_X2 U116 ( .A1(n140), .A2(current_state[2]), .A3(n143), .ZN(n117) );
  AND3_X2 U117 ( .A1(n158), .A2(n142), .A3(n122), .ZN(n140) );
  INV_X1 U118 ( .A(n150), .ZN(n118) );
  INV_X1 U119 ( .A(n150), .ZN(n119) );
  INV_X1 U120 ( .A(n150), .ZN(n237) );
  BUF_X1 U121 ( .A(n189), .Z(n150) );
  NAND3_X2 U122 ( .A1(n113), .A2(current_state[7]), .A3(n148), .ZN(n120) );
  NAND3_X1 U123 ( .A1(current_state[7]), .A2(n113), .A3(n148), .ZN(n232) );
  BUF_X1 U124 ( .A(n141), .Z(n121) );
  INV_X1 U125 ( .A(current_state[3]), .ZN(n122) );
  AND3_X1 U126 ( .A1(n138), .A2(n114), .A3(n168), .ZN(n124) );
  BUF_X2 U127 ( .A(n236), .Z(n125) );
  OAI222_X1 U128 ( .A1(n125), .A2(n127), .B1(n234), .B2(n216), .C1(n120), .C2(
        n215), .ZN(n72) );
  INV_X1 U129 ( .A(n215), .ZN(n126) );
  BUF_X1 U130 ( .A(n155), .Z(n127) );
  CLKBUF_X1 U131 ( .A(n178), .Z(n128) );
  NAND3_X1 U132 ( .A1(n131), .A2(n132), .A3(n133), .ZN(n129) );
  NAND3_X1 U133 ( .A1(n134), .A2(n135), .A3(n136), .ZN(n130) );
  NAND2_X1 U134 ( .A1(N182), .A2(n99), .ZN(n131) );
  NAND2_X1 U135 ( .A1(N174), .A2(n118), .ZN(n132) );
  INV_X1 U136 ( .A(n204), .ZN(n133) );
  NAND2_X1 U137 ( .A1(N184), .A2(n99), .ZN(n134) );
  NAND2_X1 U138 ( .A1(N176), .A2(n119), .ZN(n135) );
  INV_X1 U139 ( .A(n212), .ZN(n136) );
  NAND2_X1 U140 ( .A1(n124), .A2(n98), .ZN(n188) );
  AND4_X2 U141 ( .A1(n144), .A2(n143), .A3(n142), .A4(n152), .ZN(n138) );
  INV_X1 U142 ( .A(n164), .ZN(n165) );
  AND2_X1 U143 ( .A1(n144), .A2(n143), .ZN(n141) );
  BUF_X1 U144 ( .A(rst_n), .Z(n182) );
  BUF_X1 U145 ( .A(rst_n), .Z(n183) );
  BUF_X1 U146 ( .A(rst_n), .Z(n184) );
  INV_X1 U147 ( .A(n173), .ZN(n145) );
  INV_X1 U148 ( .A(n238), .ZN(n146) );
  AND2_X1 U149 ( .A1(n168), .A2(n161), .ZN(n147) );
  AND2_X1 U150 ( .A1(n168), .A2(n161), .ZN(n148) );
  NAND2_X1 U151 ( .A1(n232), .A2(n236), .ZN(n149) );
  AND4_X1 U152 ( .A1(n152), .A2(n153), .A3(n168), .A4(n141), .ZN(n186) );
  INV_X1 U153 ( .A(n155), .ZN(n156) );
  AND3_X1 U154 ( .A1(n147), .A2(n137), .A3(n153), .ZN(n157) );
  AND3_X1 U155 ( .A1(n147), .A2(n137), .A3(n153), .ZN(n158) );
  INV_X1 U156 ( .A(n159), .ZN(n160) );
  OR4_X2 U157 ( .A1(n185), .A2(n161), .A3(current_state[6]), .A4(
        current_state[7]), .ZN(n211) );
  INV_X1 U158 ( .A(n162), .ZN(n163) );
  INV_X1 U159 ( .A(n166), .ZN(n167) );
  INV_X1 U160 ( .A(n169), .ZN(n170) );
  INV_X1 U161 ( .A(n171), .ZN(n172) );
  INV_X1 U162 ( .A(n173), .ZN(n174) );
  INV_X1 U163 ( .A(n175), .ZN(n176) );
  INV_X1 U164 ( .A(n177), .ZN(n178) );
  INV_X1 U165 ( .A(n123), .ZN(n179) );
  NAND4_X1 U166 ( .A1(current_state[1]), .A2(n157), .A3(n121), .A4(n152), .ZN(
        n210) );
  INV_X1 U167 ( .A(n181), .ZN(n180) );
  INV_X1 U168 ( .A(start), .ZN(n191) );
  NAND3_X1 U169 ( .A1(n140), .A2(current_state[0]), .A3(n144), .ZN(n190) );
  NOR2_X1 U170 ( .A1(n191), .A2(n190), .ZN(next_state[1]) );
  NAND2_X1 U171 ( .A1(n138), .A2(n115), .ZN(n185) );
  INV_X1 U172 ( .A(n236), .ZN(n239) );
  NAND4_X1 U173 ( .A1(n158), .A2(current_state[3]), .A3(n121), .A4(n142), .ZN(
        n189) );
  INV_X1 U174 ( .A(n211), .ZN(n238) );
  NAND4_X1 U175 ( .A1(n186), .A2(n137), .A3(n142), .A4(current_state[5]), .ZN(
        n187) );
  NAND4_X1 U176 ( .A1(n189), .A2(n210), .A3(n187), .A4(n188), .ZN(n208) );
  NOR3_X1 U177 ( .A1(n180), .A2(n239), .A3(n117), .ZN(n192) );
  INV_X1 U178 ( .A(n190), .ZN(n194) );
  MUX2_X1 U179 ( .A(n192), .B(n191), .S(n194), .Z(next_state[0]) );
  OAI21_X1 U180 ( .B1(n194), .B2(n193), .A(n120), .ZN(n96) );
  AOI22_X1 U181 ( .A1(n181), .A2(n165), .B1(N178), .B2(n99), .ZN(n196) );
  AOI22_X1 U182 ( .A1(data_in[1]), .A2(n123), .B1(N170), .B2(n119), .ZN(n195)
         );
  OAI211_X1 U183 ( .C1(n127), .C2(n211), .A(n195), .B(n196), .ZN(n85) );
  INV_X1 U184 ( .A(n165), .ZN(n219) );
  AOI22_X1 U185 ( .A1(n181), .A2(n160), .B1(N179), .B2(n99), .ZN(n198) );
  AOI22_X1 U186 ( .A1(data_in[2]), .A2(n123), .B1(N171), .B2(n118), .ZN(n197)
         );
  OAI211_X1 U187 ( .C1(n219), .C2(n211), .A(n197), .B(n198), .ZN(n83) );
  INV_X1 U188 ( .A(n160), .ZN(n222) );
  AOI22_X1 U189 ( .A1(n181), .A2(n128), .B1(N180), .B2(n99), .ZN(n200) );
  AOI22_X1 U190 ( .A1(data_in[3]), .A2(n123), .B1(N172), .B2(n237), .ZN(n199)
         );
  OAI211_X1 U191 ( .C1(n222), .C2(n146), .A(n199), .B(n200), .ZN(n81) );
  INV_X1 U192 ( .A(n128), .ZN(n225) );
  AOI22_X1 U193 ( .A1(n181), .A2(n174), .B1(N181), .B2(n99), .ZN(n202) );
  AOI22_X1 U194 ( .A1(data_in[4]), .A2(n123), .B1(N173), .B2(n118), .ZN(n201)
         );
  OAI211_X1 U195 ( .C1(n225), .C2(n146), .A(n201), .B(n202), .ZN(n79) );
  INV_X1 U196 ( .A(data_in[5]), .ZN(n203) );
  INV_X1 U197 ( .A(n174), .ZN(n227) );
  INV_X1 U198 ( .A(n163), .ZN(n229) );
  OAI222_X1 U199 ( .A1(n179), .A2(n203), .B1(n227), .B2(n211), .C1(n208), .C2(
        n229), .ZN(n204) );
  INV_X1 U200 ( .A(data_in[6]), .ZN(n205) );
  OAI222_X1 U201 ( .A1(n229), .A2(n211), .B1(n208), .B2(n231), .C1(n179), .C2(
        n205), .ZN(n206) );
  AOI221_X1 U202 ( .B1(N175), .B2(n119), .C1(N183), .C2(n99), .A(n206), .ZN(
        n207) );
  INV_X1 U203 ( .A(n207), .ZN(n75) );
  MUX2_X1 U204 ( .A(reg2[7]), .B(data_in[7]), .S(n117), .Z(n95) );
  MUX2_X1 U205 ( .A(reg2[6]), .B(data_in[6]), .S(n117), .Z(n94) );
  MUX2_X1 U206 ( .A(n151), .B(data_in[5]), .S(n116), .Z(n93) );
  MUX2_X1 U207 ( .A(n154), .B(data_in[4]), .S(n139), .Z(n92) );
  MUX2_X1 U208 ( .A(reg2[3]), .B(data_in[3]), .S(n139), .Z(n91) );
  MUX2_X1 U209 ( .A(n170), .B(data_in[2]), .S(n139), .Z(n90) );
  MUX2_X1 U210 ( .A(n176), .B(data_in[1]), .S(n116), .Z(n89) );
  MUX2_X1 U211 ( .A(n126), .B(data_in[0]), .S(n116), .Z(n88) );
  INV_X1 U212 ( .A(data_in[7]), .ZN(n209) );
  OAI222_X1 U213 ( .A1(n231), .A2(n211), .B1(n179), .B2(n209), .C1(n208), .C2(
        n235), .ZN(n212) );
  AOI22_X1 U214 ( .A1(n181), .A2(n156), .B1(N177), .B2(n99), .ZN(n214) );
  AOI22_X1 U215 ( .A1(data_in[0]), .A2(n123), .B1(N169), .B2(n237), .ZN(n213)
         );
  NAND2_X1 U216 ( .A1(n213), .A2(n214), .ZN(n86) );
  NAND2_X1 U217 ( .A1(n232), .A2(n236), .ZN(n234) );
  INV_X1 U218 ( .A(reg2[0]), .ZN(n215) );
  INV_X1 U219 ( .A(n176), .ZN(n217) );
  OAI222_X1 U220 ( .A1(n125), .A2(n219), .B1(n149), .B2(n218), .C1(n120), .C2(
        n217), .ZN(n84) );
  INV_X1 U221 ( .A(n170), .ZN(n220) );
  OAI222_X1 U222 ( .A1(n125), .A2(n222), .B1(n234), .B2(n221), .C1(n120), .C2(
        n220), .ZN(n82) );
  INV_X1 U223 ( .A(reg2[3]), .ZN(n223) );
  OAI222_X1 U224 ( .A1(n125), .A2(n225), .B1(n149), .B2(n224), .C1(n120), .C2(
        n223), .ZN(n80) );
  OAI222_X1 U225 ( .A1(n125), .A2(n227), .B1(n234), .B2(n226), .C1(n120), .C2(
        n101), .ZN(n78) );
  OAI222_X1 U226 ( .A1(n125), .A2(n229), .B1(n149), .B2(n228), .C1(n120), .C2(
        n102), .ZN(n76) );
  OAI222_X1 U227 ( .A1(n125), .A2(n231), .B1(n234), .B2(n230), .C1(n120), .C2(
        n100), .ZN(n74) );
  OAI222_X1 U228 ( .A1(n125), .A2(n235), .B1(n149), .B2(n233), .C1(n120), .C2(
        n103), .ZN(n73) );
  INV_X1 add_64_U81 ( .A(add_64_n50), .ZN(add_64_n69) );
  OAI21_X1 add_64_U80 ( .B1(add_64_n1), .B2(add_64_n69), .A(add_64_n65), .ZN(
        add_64_n67) );
  XNOR2_X1 add_64_U79 ( .A(add_64_n67), .B(add_64_n68), .ZN(N172) );
  NAND2_X1 add_64_U78 ( .A1(n176), .A2(n165), .ZN(add_64_n66) );
  INV_X1 add_64_U77 ( .A(add_64_n65), .ZN(add_64_n64) );
  INV_X1 add_64_U76 ( .A(add_64_n37), .ZN(add_64_n53) );
  INV_X1 add_64_U75 ( .A(add_64_n25), .ZN(add_64_n33) );
  NAND3_X1 add_64_U74 ( .A1(add_64_n42), .A2(add_64_n43), .A3(add_64_n44), 
        .ZN(add_64_n41) );
  NAND2_X1 add_64_U73 ( .A1(add_64_n34), .A2(add_64_n33), .ZN(add_64_n31) );
  XNOR2_X1 add_64_U72 ( .A(add_64_n31), .B(add_64_n32), .ZN(N175) );
  NAND3_X1 add_64_U71 ( .A1(add_64_n16), .A2(add_64_n27), .A3(add_64_n28), 
        .ZN(add_64_n21) );
  INV_X1 add_64_U70 ( .A(add_64_n16), .ZN(add_64_n19) );
  NAND3_X1 add_64_U69 ( .A1(add_64_n6), .A2(add_64_n16), .A3(add_64_n9), .ZN(
        add_64_n15) );
  INV_X1 add_64_U68 ( .A(n176), .ZN(add_64_n48) );
  AND2_X1 add_64_U67 ( .A1(n176), .A2(n165), .ZN(add_64_n44) );
  NAND2_X1 add_64_U66 ( .A1(n176), .A2(n165), .ZN(add_64_n29) );
  NAND2_X1 add_64_U65 ( .A1(add_64_n18), .A2(add_64_n6), .ZN(add_64_n14) );
  NAND2_X1 add_64_U64 ( .A1(add_64_n3), .A2(add_64_n6), .ZN(add_64_n22) );
  OAI21_X1 add_64_U63 ( .B1(add_64_n35), .B2(add_64_n36), .A(add_64_n6), .ZN(
        add_64_n34) );
  NAND2_X1 add_64_U62 ( .A1(reg2[3]), .A2(n178), .ZN(add_64_n20) );
  XNOR2_X1 add_64_U61 ( .A(add_64_n56), .B(add_64_n57), .ZN(N174) );
  INV_X1 add_64_U60 ( .A(n170), .ZN(add_64_n45) );
  NAND2_X1 add_64_U59 ( .A1(n160), .A2(n170), .ZN(add_64_n65) );
  NAND2_X1 add_64_U58 ( .A1(add_64_n64), .A2(add_64_n51), .ZN(add_64_n17) );
  NAND2_X1 add_64_U57 ( .A1(add_64_n50), .A2(add_64_n51), .ZN(add_64_n26) );
  NAND2_X1 add_64_U56 ( .A1(add_64_n20), .A2(add_64_n51), .ZN(add_64_n68) );
  NAND2_X1 add_64_U55 ( .A1(reg2[0]), .A2(n156), .ZN(add_64_n30) );
  NAND2_X1 add_64_U54 ( .A1(add_64_n29), .A2(add_64_n10), .ZN(add_64_n28) );
  NAND2_X1 add_64_U53 ( .A1(add_64_n66), .A2(add_64_n30), .ZN(add_64_n62) );
  INV_X1 add_64_U52 ( .A(n165), .ZN(add_64_n49) );
  NAND2_X1 add_64_U51 ( .A1(n154), .A2(n145), .ZN(add_64_n54) );
  NOR2_X1 add_64_U50 ( .A1(add_64_n26), .A2(add_64_n61), .ZN(add_64_n59) );
  OAI21_X1 add_64_U49 ( .B1(add_64_n26), .B2(add_64_n61), .A(add_64_n20), .ZN(
        add_64_n63) );
  OAI211_X1 add_64_U48 ( .C1(add_64_n21), .C2(add_64_n22), .A(add_64_n23), .B(
        add_64_n24), .ZN(add_64_n12) );
  NOR2_X1 add_64_U47 ( .A1(add_64_n12), .A2(add_64_n13), .ZN(add_64_n11) );
  NAND2_X1 add_64_U46 ( .A1(n151), .A2(n163), .ZN(add_64_n55) );
  XNOR2_X1 add_64_U45 ( .A(add_64_n11), .B(add_64_n8), .ZN(N176) );
  NAND2_X1 add_64_U44 ( .A1(add_64_n27), .A2(add_64_n29), .ZN(add_64_n73) );
  NAND2_X1 add_64_U43 ( .A1(add_64_n62), .A2(add_64_n27), .ZN(add_64_n61) );
  INV_X1 add_64_U42 ( .A(n160), .ZN(add_64_n46) );
  NAND2_X1 add_64_U41 ( .A1(reg2[6]), .A2(reg1[6]), .ZN(add_64_n24) );
  NAND2_X1 add_64_U40 ( .A1(add_64_n25), .A2(add_64_n16), .ZN(add_64_n23) );
  NAND2_X1 add_64_U39 ( .A1(reg2[0]), .A2(n156), .ZN(add_64_n10) );
  AND2_X1 add_64_U38 ( .A1(add_64_n64), .A2(add_64_n51), .ZN(add_64_n9) );
  NAND2_X1 add_64_U37 ( .A1(add_64_n72), .A2(add_64_n29), .ZN(add_64_n70) );
  NAND2_X1 add_64_U36 ( .A1(add_64_n48), .A2(add_64_n49), .ZN(add_64_n47) );
  NAND3_X1 add_64_U35 ( .A1(add_64_n27), .A2(add_64_n52), .A3(add_64_n4), .ZN(
        add_64_n72) );
  XOR2_X1 add_64_U34 ( .A(reg2[7]), .B(reg1[7]), .Z(add_64_n8) );
  OR2_X1 add_64_U33 ( .A1(reg2[0]), .A2(n156), .ZN(add_64_n52) );
  OR2_X1 add_64_U32 ( .A1(reg2[3]), .A2(n178), .ZN(add_64_n43) );
  OR2_X2 add_64_U31 ( .A1(reg2[6]), .A2(reg1[6]), .ZN(add_64_n16) );
  AND2_X1 add_64_U30 ( .A1(add_64_n52), .A2(add_64_n10), .ZN(N169) );
  NAND2_X1 add_64_U29 ( .A1(add_64_n55), .A2(add_64_n37), .ZN(add_64_n57) );
  XOR2_X1 add_64_U28 ( .A(add_64_n10), .B(add_64_n73), .Z(N170) );
  NAND2_X1 add_64_U27 ( .A1(add_64_n24), .A2(add_64_n16), .ZN(add_64_n32) );
  OAI21_X1 add_64_U26 ( .B1(add_64_n53), .B2(add_64_n54), .A(add_64_n55), .ZN(
        add_64_n25) );
  NOR2_X1 add_64_U25 ( .A1(add_64_n19), .A2(add_64_n20), .ZN(add_64_n18) );
  NAND2_X1 add_64_U24 ( .A1(add_64_n17), .A2(add_64_n20), .ZN(add_64_n60) );
  OAI21_X1 add_64_U23 ( .B1(add_64_n59), .B2(add_64_n60), .A(add_64_n38), .ZN(
        add_64_n58) );
  NAND2_X1 add_64_U22 ( .A1(add_64_n54), .A2(add_64_n58), .ZN(add_64_n56) );
  NAND2_X1 add_64_U21 ( .A1(add_64_n17), .A2(add_64_n20), .ZN(add_64_n35) );
  NAND2_X1 add_64_U20 ( .A1(add_64_n4), .A2(add_64_n42), .ZN(add_64_n40) );
  NAND2_X1 add_64_U19 ( .A1(add_64_n43), .A2(add_64_n47), .ZN(add_64_n39) );
  OAI21_X1 add_64_U18 ( .B1(add_64_n39), .B2(add_64_n40), .A(add_64_n41), .ZN(
        add_64_n36) );
  AND2_X1 add_64_U17 ( .A1(add_64_n37), .A2(add_64_n38), .ZN(add_64_n6) );
  NAND2_X1 add_64_U16 ( .A1(add_64_n14), .A2(add_64_n15), .ZN(add_64_n13) );
  NAND2_X1 add_64_U15 ( .A1(add_64_n65), .A2(add_64_n50), .ZN(add_64_n71) );
  XNOR2_X1 add_64_U14 ( .A(add_64_n70), .B(add_64_n71), .ZN(N171) );
  NAND2_X1 add_64_U13 ( .A1(add_64_n45), .A2(add_64_n46), .ZN(add_64_n50) );
  NAND2_X1 add_64_U12 ( .A1(add_64_n45), .A2(add_64_n46), .ZN(add_64_n42) );
  OR2_X1 add_64_U11 ( .A1(n151), .A2(n163), .ZN(add_64_n37) );
  OR2_X1 add_64_U10 ( .A1(n154), .A2(n145), .ZN(add_64_n38) );
  NOR2_X1 add_64_U9 ( .A1(add_64_n63), .A2(add_64_n9), .ZN(add_64_n5) );
  OR2_X1 add_64_U8 ( .A1(n165), .A2(n176), .ZN(add_64_n27) );
  OR2_X2 add_64_U7 ( .A1(reg2[3]), .A2(n178), .ZN(add_64_n51) );
  AND2_X1 add_64_U6 ( .A1(reg2[0]), .A2(n156), .ZN(add_64_n4) );
  AND2_X1 add_64_U5 ( .A1(add_64_n50), .A2(add_64_n51), .ZN(add_64_n3) );
  AND2_X1 add_64_U4 ( .A1(add_64_n54), .A2(add_64_n38), .ZN(add_64_n2) );
  XNOR2_X1 add_64_U3 ( .A(add_64_n5), .B(add_64_n2), .ZN(N173) );
  AND2_X1 add_64_U2 ( .A1(add_64_n72), .A2(add_64_n29), .ZN(add_64_n1) );
  INV_X1 sub_67_U116 ( .A(sub_67_n52), .ZN(sub_67_n73) );
  NAND3_X1 sub_67_U115 ( .A1(sub_67_n73), .A2(sub_67_n13), .A3(sub_67_n51), 
        .ZN(sub_67_n78) );
  XNOR2_X1 sub_67_U114 ( .A(sub_67_n64), .B(sub_67_n74), .ZN(N181) );
  NAND2_X1 sub_67_U113 ( .A1(sub_67_n72), .A2(sub_67_n73), .ZN(sub_67_n71) );
  NAND3_X1 sub_67_U112 ( .A1(sub_67_n22), .A2(sub_67_n2), .A3(sub_67_n71), 
        .ZN(sub_67_n70) );
  NAND2_X1 sub_67_U111 ( .A1(sub_67_n70), .A2(sub_67_n1), .ZN(sub_67_n69) );
  NAND2_X1 sub_67_U110 ( .A1(sub_67_n69), .A2(sub_67_n60), .ZN(sub_67_n65) );
  XNOR2_X1 sub_67_U109 ( .A(sub_67_n65), .B(sub_67_n66), .ZN(N182) );
  INV_X1 sub_67_U108 ( .A(sub_67_n62), .ZN(sub_67_n59) );
  INV_X1 sub_67_U107 ( .A(sub_67_n53), .ZN(sub_67_n58) );
  XNOR2_X1 sub_67_U106 ( .A(sub_67_n54), .B(sub_67_n55), .ZN(N183) );
  NAND2_X1 sub_67_U105 ( .A1(sub_67_n53), .A2(sub_67_n28), .ZN(sub_67_n45) );
  NAND2_X1 sub_67_U104 ( .A1(sub_67_n49), .A2(sub_67_n48), .ZN(sub_67_n47) );
  NAND3_X1 sub_67_U103 ( .A1(sub_67_n45), .A2(sub_67_n46), .A3(sub_67_n47), 
        .ZN(sub_67_n35) );
  NAND2_X1 sub_67_U102 ( .A1(sub_67_n21), .A2(sub_67_n28), .ZN(sub_67_n38) );
  INV_X1 sub_67_U101 ( .A(sub_67_n44), .ZN(sub_67_n43) );
  INV_X1 sub_67_U100 ( .A(sub_67_n42), .ZN(sub_67_n41) );
  NAND2_X1 sub_67_U99 ( .A1(sub_67_n40), .A2(sub_67_n41), .ZN(sub_67_n39) );
  OAI21_X1 sub_67_U98 ( .B1(sub_67_n22), .B2(sub_67_n38), .A(sub_67_n39), .ZN(
        sub_67_n36) );
  INV_X1 sub_67_U97 ( .A(reg2[1]), .ZN(sub_67_n94) );
  NAND2_X1 sub_67_U96 ( .A1(sub_67_n15), .A2(sub_67_n104), .ZN(sub_67_n51) );
  AOI21_X1 sub_67_U95 ( .B1(sub_67_n91), .B2(sub_67_n92), .A(sub_67_n93), .ZN(
        sub_67_n88) );
  NAND2_X1 sub_67_U94 ( .A1(sub_67_n88), .A2(sub_67_n89), .ZN(sub_67_n37) );
  NAND2_X1 sub_67_U93 ( .A1(sub_67_n51), .A2(sub_67_n30), .ZN(sub_67_n103) );
  XNOR2_X1 sub_67_U92 ( .A(sub_67_n34), .B(sub_67_n33), .ZN(N184) );
  NAND2_X1 sub_67_U91 ( .A1(sub_67_n51), .A2(sub_67_n44), .ZN(sub_67_n50) );
  OAI21_X1 sub_67_U90 ( .B1(sub_67_n4), .B2(sub_67_n106), .A(sub_67_n14), .ZN(
        sub_67_n100) );
  INV_X1 sub_67_U89 ( .A(n172), .ZN(sub_67_n95) );
  NAND2_X1 sub_67_U88 ( .A1(sub_67_n3), .A2(n172), .ZN(sub_67_n85) );
  NAND2_X1 sub_67_U87 ( .A1(n172), .A2(sub_67_n3), .ZN(sub_67_n80) );
  AND2_X1 sub_67_U86 ( .A1(sub_67_n37), .A2(sub_67_n32), .ZN(sub_67_n77) );
  INV_X1 sub_67_U85 ( .A(n167), .ZN(sub_67_n84) );
  NAND2_X1 sub_67_U84 ( .A1(reg1[0]), .A2(sub_67_n84), .ZN(sub_67_n92) );
  NAND2_X1 sub_67_U83 ( .A1(sub_67_n4), .A2(sub_67_n106), .ZN(sub_67_n101) );
  INV_X1 sub_67_U82 ( .A(n167), .ZN(sub_67_n106) );
  OAI21_X1 sub_67_U81 ( .B1(sub_67_n27), .B2(sub_67_n23), .A(sub_67_n9), .ZN(
        sub_67_n42) );
  OAI21_X1 sub_67_U80 ( .B1(sub_67_n27), .B2(sub_67_n11), .A(sub_67_n9), .ZN(
        sub_67_n32) );
  NOR2_X1 sub_67_U79 ( .A1(sub_67_n36), .A2(sub_67_n35), .ZN(sub_67_n34) );
  NAND2_X1 sub_67_U78 ( .A1(reg2[2]), .A2(sub_67_n81), .ZN(sub_67_n79) );
  NAND2_X1 sub_67_U77 ( .A1(reg2[2]), .A2(sub_67_n81), .ZN(sub_67_n90) );
  INV_X1 sub_67_U76 ( .A(reg2[2]), .ZN(sub_67_n99) );
  OAI21_X1 sub_67_U75 ( .B1(sub_67_n27), .B2(sub_67_n11), .A(sub_67_n9), .ZN(
        sub_67_n31) );
  INV_X1 sub_67_U74 ( .A(reg1[1]), .ZN(sub_67_n104) );
  NAND2_X1 sub_67_U73 ( .A1(reg1[1]), .A2(sub_67_n94), .ZN(sub_67_n91) );
  NOR2_X1 sub_67_U72 ( .A1(sub_67_n94), .A2(reg1[1]), .ZN(sub_67_n93) );
  NAND2_X1 sub_67_U71 ( .A1(sub_67_n97), .A2(sub_67_n12), .ZN(sub_67_n96) );
  XNOR2_X1 sub_67_U70 ( .A(sub_67_n97), .B(sub_67_n98), .ZN(N179) );
  INV_X1 sub_67_U69 ( .A(reg1[4]), .ZN(sub_67_n75) );
  NAND2_X1 sub_67_U68 ( .A1(reg1[4]), .A2(sub_67_n76), .ZN(sub_67_n60) );
  INV_X1 sub_67_U67 ( .A(reg1[5]), .ZN(sub_67_n67) );
  NAND2_X1 sub_67_U66 ( .A1(reg1[5]), .A2(sub_67_n68), .ZN(sub_67_n61) );
  BUF_X1 sub_67_U65 ( .A(sub_67_n91), .Z(sub_67_n30) );
  INV_X1 sub_67_U64 ( .A(reg1[2]), .ZN(sub_67_n81) );
  OAI21_X1 sub_67_U63 ( .B1(sub_67_n25), .B2(sub_67_n26), .A(sub_67_n58), .ZN(
        sub_67_n54) );
  INV_X1 sub_67_U62 ( .A(n154), .ZN(sub_67_n76) );
  NAND2_X1 sub_67_U61 ( .A1(sub_67_n75), .A2(n154), .ZN(sub_67_n63) );
  INV_X1 sub_67_U60 ( .A(reg1[6]), .ZN(sub_67_n56) );
  NAND2_X1 sub_67_U59 ( .A1(reg2[6]), .A2(sub_67_n56), .ZN(sub_67_n44) );
  AND2_X1 sub_67_U58 ( .A1(sub_67_n85), .A2(sub_67_n90), .ZN(sub_67_n89) );
  NAND2_X1 sub_67_U57 ( .A1(sub_67_n87), .A2(sub_67_n12), .ZN(sub_67_n98) );
  NAND2_X1 sub_67_U56 ( .A1(reg1[6]), .A2(sub_67_n57), .ZN(sub_67_n46) );
  NAND2_X1 sub_67_U55 ( .A1(sub_67_n46), .A2(sub_67_n28), .ZN(sub_67_n55) );
  NAND2_X1 sub_67_U54 ( .A1(sub_67_n67), .A2(n151), .ZN(sub_67_n62) );
  INV_X1 sub_67_U53 ( .A(n151), .ZN(sub_67_n68) );
  OAI21_X1 sub_67_U52 ( .B1(sub_67_n7), .B2(sub_67_n106), .A(sub_67_n101), 
        .ZN(N177) );
  NAND2_X1 sub_67_U51 ( .A1(sub_67_n29), .A2(sub_67_n95), .ZN(sub_67_n86) );
  NOR2_X1 sub_67_U50 ( .A1(sub_67_n43), .A2(sub_67_n24), .ZN(sub_67_n40) );
  CLKBUF_X1 sub_67_U49 ( .A(sub_67_n44), .Z(sub_67_n28) );
  AND2_X2 sub_67_U48 ( .A1(sub_67_n8), .A2(sub_67_n99), .ZN(sub_67_n27) );
  NAND2_X1 sub_67_U47 ( .A1(sub_67_n20), .A2(sub_67_n78), .ZN(sub_67_n64) );
  NOR2_X1 sub_67_U46 ( .A1(sub_67_n16), .A2(sub_67_n50), .ZN(sub_67_n49) );
  INV_X1 sub_67_U45 ( .A(sub_67_n21), .ZN(sub_67_n26) );
  AND2_X1 sub_67_U44 ( .A1(sub_67_n77), .A2(sub_67_n78), .ZN(sub_67_n25) );
  NAND2_X1 sub_67_U43 ( .A1(sub_67_n62), .A2(sub_67_n63), .ZN(sub_67_n24) );
  AND2_X1 sub_67_U42 ( .A1(sub_67_n95), .A2(sub_67_n29), .ZN(sub_67_n23) );
  INV_X1 sub_67_U41 ( .A(reg2[6]), .ZN(sub_67_n57) );
  NAND2_X1 sub_67_U40 ( .A1(sub_67_n79), .A2(sub_67_n80), .ZN(sub_67_n52) );
  NAND2_X1 sub_67_U39 ( .A1(sub_67_n10), .A2(sub_67_n5), .ZN(sub_67_n22) );
  AND2_X1 sub_67_U38 ( .A1(sub_67_n62), .A2(sub_67_n63), .ZN(sub_67_n21) );
  AND2_X1 sub_67_U37 ( .A1(sub_67_n37), .A2(sub_67_n31), .ZN(sub_67_n20) );
  NAND2_X1 sub_67_U35 ( .A1(sub_67_n105), .A2(sub_67_n101), .ZN(sub_67_n102)
         );
  XNOR2_X1 sub_67_U34 ( .A(sub_67_n102), .B(sub_67_n103), .ZN(N178) );
  NAND2_X1 sub_67_U33 ( .A1(sub_67_n100), .A2(sub_67_n30), .ZN(sub_67_n97) );
  XNOR2_X1 sub_67_U32 ( .A(reg2[7]), .B(reg1[7]), .ZN(sub_67_n33) );
  NAND2_X1 sub_67_U31 ( .A1(sub_67_n60), .A2(sub_67_n63), .ZN(sub_67_n74) );
  INV_X1 sub_67_U30 ( .A(sub_67_n27), .ZN(sub_67_n87) );
  AND2_X1 sub_67_U29 ( .A1(sub_67_n9), .A2(sub_67_n86), .ZN(sub_67_n18) );
  AND2_X1 sub_67_U28 ( .A1(sub_67_n96), .A2(sub_67_n87), .ZN(sub_67_n17) );
  XNOR2_X1 sub_67_U27 ( .A(sub_67_n17), .B(sub_67_n18), .ZN(N180) );
  OAI21_X1 sub_67_U26 ( .B1(sub_67_n59), .B2(sub_67_n60), .A(sub_67_n61), .ZN(
        sub_67_n53) );
  NOR2_X1 sub_67_U25 ( .A1(sub_67_n24), .A2(sub_67_n52), .ZN(sub_67_n48) );
  NAND2_X1 sub_67_U24 ( .A1(sub_67_n61), .A2(sub_67_n62), .ZN(sub_67_n66) );
  AND2_X1 sub_67_U23 ( .A1(sub_67_n83), .A2(sub_67_n82), .ZN(sub_67_n16) );
  CLKBUF_X1 sub_67_U22 ( .A(reg2[1]), .Z(sub_67_n15) );
  NAND2_X1 sub_67_U21 ( .A1(sub_67_n104), .A2(sub_67_n15), .ZN(sub_67_n14) );
  NAND2_X1 sub_67_U20 ( .A1(sub_67_n83), .A2(sub_67_n82), .ZN(sub_67_n13) );
  AND2_X1 sub_67_U19 ( .A1(sub_67_n13), .A2(sub_67_n14), .ZN(sub_67_n72) );
  CLKBUF_X1 sub_67_U18 ( .A(sub_67_n90), .Z(sub_67_n12) );
  BUF_X1 sub_67_U17 ( .A(reg1[3]), .Z(sub_67_n29) );
  AND2_X1 sub_67_U16 ( .A1(sub_67_n6), .A2(sub_67_n29), .ZN(sub_67_n11) );
  CLKBUF_X1 sub_67_U15 ( .A(sub_67_n88), .Z(sub_67_n10) );
  NAND2_X1 sub_67_U14 ( .A1(n172), .A2(sub_67_n3), .ZN(sub_67_n9) );
  CLKBUF_X1 sub_67_U13 ( .A(reg1[2]), .Z(sub_67_n8) );
  CLKBUF_X1 sub_67_U12 ( .A(reg1[0]), .Z(sub_67_n7) );
  INV_X1 sub_67_U11 ( .A(n172), .ZN(sub_67_n6) );
  AND2_X1 sub_67_U10 ( .A1(sub_67_n85), .A2(sub_67_n90), .ZN(sub_67_n5) );
  CLKBUF_X1 sub_67_U9 ( .A(reg1[0]), .Z(sub_67_n4) );
  INV_X1 sub_67_U8 ( .A(reg1[3]), .ZN(sub_67_n3) );
  BUF_X1 sub_67_U7 ( .A(sub_67_n31), .Z(sub_67_n2) );
  CLKBUF_X1 sub_67_U6 ( .A(sub_67_n63), .Z(sub_67_n1) );
  NAND2_X1 sub_67_U5 ( .A1(reg1[0]), .A2(1'b1), .ZN(sub_67_n83) );
  NAND2_X1 sub_67_U4 ( .A1(sub_67_n84), .A2(1'b1), .ZN(sub_67_n82) );
  OAI21_X1 sub_67_U3 ( .B1(reg1[0]), .B2(sub_67_n106), .A(1'b1), .ZN(
        sub_67_n105) );
endmodule

