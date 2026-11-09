/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:06:22 2025
/////////////////////////////////////////////////////////////


module fsm_encode_ds ( clk, rst_n, start, data_in, data_out, done );
  input [7:0] data_in;
  output [7:0] data_out;
  input clk, rst_n, start;
  output done;
  wire   n249, N43, N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55,
         N56, N57, N58, n74, n76, n78, n79, n80, n81, n82, n83, n84, n85, n86,
         n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n141, n142,
         n143, n144, n145, n146, n147, n148, n149, n150, n151, n152, n153,
         n154, n155, n156, n157, n158, n159, n160, n161, n162, n163, n164,
         n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197,
         n198, n199, n200, n201, n202, n203, n204, n205, n206, n207, n208,
         n209, n210, n211, n212, n213, n214, n215, n216, n217, n218, n219,
         n220, n221, n222, n223, n224, n225, n226, n227, n228, n229, n230,
         n231, n232, n233, n234, n235, n236, n237, n238, n239, n240, n241,
         n242, n243, n244, n245, n246, n247, n248, sub_37_n116, sub_37_n115,
         sub_37_n114, sub_37_n113, sub_37_n112, sub_37_n111, sub_37_n110,
         sub_37_n109, sub_37_n108, sub_37_n107, sub_37_n106, sub_37_n105,
         sub_37_n104, sub_37_n103, sub_37_n102, sub_37_n101, sub_37_n100,
         sub_37_n99, sub_37_n98, sub_37_n97, sub_37_n96, sub_37_n95,
         sub_37_n94, sub_37_n93, sub_37_n92, sub_37_n91, sub_37_n90,
         sub_37_n89, sub_37_n88, sub_37_n87, sub_37_n86, sub_37_n85,
         sub_37_n84, sub_37_n83, sub_37_n82, sub_37_n81, sub_37_n80,
         sub_37_n79, sub_37_n78, sub_37_n77, sub_37_n76, sub_37_n75,
         sub_37_n74, sub_37_n73, sub_37_n72, sub_37_n71, sub_37_n70,
         sub_37_n69, sub_37_n68, sub_37_n67, sub_37_n66, sub_37_n65,
         sub_37_n64, sub_37_n63, sub_37_n62, sub_37_n61, sub_37_n60,
         sub_37_n59, sub_37_n58, sub_37_n57, sub_37_n56, sub_37_n55,
         sub_37_n54, sub_37_n53, sub_37_n52, sub_37_n51, sub_37_n50,
         sub_37_n49, sub_37_n48, sub_37_n47, sub_37_n46, sub_37_n45,
         sub_37_n44, sub_37_n43, sub_37_n42, sub_37_n41, sub_37_n40,
         sub_37_n39, sub_37_n38, sub_37_n37, sub_37_n36, sub_37_n35,
         sub_37_n34, sub_37_n33, sub_37_n32, sub_37_n31, sub_37_n30,
         sub_37_n29, sub_37_n28, sub_37_n27, sub_37_n26, sub_37_n25,
         sub_37_n24, sub_37_n23, sub_37_n22, sub_37_n21, sub_37_n20,
         sub_37_n19, sub_37_n18, sub_37_n17, sub_37_n16, sub_37_n15,
         sub_37_n13, sub_37_n12, sub_37_n11, sub_37_n10, sub_37_n9, sub_37_n8,
         sub_37_n7, sub_37_n6, sub_37_n5, sub_37_n4, sub_37_n3, sub_37_n2,
         sub_37_n1, add_36_n75, add_36_n74, add_36_n73, add_36_n72, add_36_n71,
         add_36_n70, add_36_n69, add_36_n68, add_36_n67, add_36_n66,
         add_36_n65, add_36_n64, add_36_n63, add_36_n62, add_36_n61,
         add_36_n60, add_36_n59, add_36_n58, add_36_n57, add_36_n56,
         add_36_n55, add_36_n54, add_36_n53, add_36_n52, add_36_n51,
         add_36_n50, add_36_n49, add_36_n48, add_36_n47, add_36_n46,
         add_36_n45, add_36_n44, add_36_n43, add_36_n42, add_36_n41,
         add_36_n40, add_36_n39, add_36_n38, add_36_n37, add_36_n36,
         add_36_n35, add_36_n34, add_36_n33, add_36_n32, add_36_n31,
         add_36_n30, add_36_n29, add_36_n28, add_36_n27, add_36_n26,
         add_36_n25, add_36_n24, add_36_n23, add_36_n22, add_36_n21,
         add_36_n20, add_36_n19, add_36_n18, add_36_n17, add_36_n16,
         add_36_n15, add_36_n14, add_36_n13, add_36_n12, add_36_n11,
         add_36_n10, add_36_n8, add_36_n7, add_36_n6, add_36_n5, add_36_n4,
         add_36_n3, add_36_n2, add_36_n1;
  wire   [7:0] reg1;
  wire   [7:0] reg2;
  wire   [2:0] current_state;

  DFFR_X1 current_state_reg_0_ ( .D(n172), .CK(clk), .RN(n195), .Q(
        current_state[0]), .QN(n182) );
  DFFR_X1 current_state_reg_1_ ( .D(n191), .CK(clk), .RN(n195), .Q(
        current_state[1]), .QN(n192) );
  DFFR_X1 current_state_reg_2_ ( .D(n183), .CK(clk), .RN(n195), .Q(
        current_state[2]), .QN(n176) );
  DFFR_X1 done_reg ( .D(n98), .CK(clk), .RN(n195), .Q(n249), .QN(n131) );
  DFFR_X1 reg2_reg_7_ ( .D(n97), .CK(clk), .RN(n194), .Q(reg2[7]), .QN(n103)
         );
  DFFR_X1 reg2_reg_6_ ( .D(n96), .CK(clk), .RN(n194), .Q(n152), .QN(n105) );
  DFFR_X1 reg2_reg_5_ ( .D(n95), .CK(clk), .RN(n194), .Q(reg2[5]), .QN(n155)
         );
  DFFR_X1 reg2_reg_4_ ( .D(n94), .CK(clk), .RN(n194), .Q(reg2[4]), .QN(n170)
         );
  DFFR_X1 reg2_reg_3_ ( .D(n93), .CK(clk), .RN(n194), .Q(reg2[3]), .QN(n153)
         );
  DFFR_X1 reg2_reg_2_ ( .D(n92), .CK(clk), .RN(n194), .Q(reg2[2]), .QN(n164)
         );
  DFFR_X1 reg2_reg_1_ ( .D(n91), .CK(clk), .RN(n194), .Q(reg2[1]), .QN(n180)
         );
  DFFR_X1 out_reg_reg_0_ ( .D(n88), .CK(clk), .RN(n194), .Q(data_out[0]), .QN(
        n225) );
  DFFR_X1 reg1_reg_1_ ( .D(n87), .CK(clk), .RN(n194), .Q(reg1[1]), .QN(n162)
         );
  DFFR_X1 out_reg_reg_1_ ( .D(n86), .CK(clk), .RN(n194), .Q(data_out[1]), .QN(
        n227) );
  DFFR_X1 reg1_reg_2_ ( .D(n85), .CK(clk), .RN(n193), .Q(reg1[2]), .QN(n169)
         );
  DFFR_X1 out_reg_reg_2_ ( .D(n84), .CK(clk), .RN(n193), .Q(data_out[2]), .QN(
        n230) );
  DFFR_X1 reg1_reg_3_ ( .D(n83), .CK(clk), .RN(n193), .Q(reg1[3]), .QN(n167)
         );
  DFFR_X1 out_reg_reg_3_ ( .D(n82), .CK(clk), .RN(n193), .Q(data_out[3]), .QN(
        n232) );
  DFFR_X1 reg1_reg_4_ ( .D(n81), .CK(clk), .RN(n193), .Q(reg1[4]), .QN(n184)
         );
  DFFR_X1 out_reg_reg_4_ ( .D(n80), .CK(clk), .RN(n193), .Q(data_out[4]), .QN(
        n235) );
  DFFR_X1 reg1_reg_5_ ( .D(n79), .CK(clk), .RN(n193), .Q(reg1[5]), .QN(n158)
         );
  DFFR_X1 out_reg_reg_5_ ( .D(n78), .CK(clk), .RN(n193), .Q(data_out[5]), .QN(
        n238) );
  DFFR_X1 reg1_reg_6_ ( .D(n123), .CK(clk), .RN(n193), .Q(reg1[6]), .QN(n150)
         );
  DFFR_X1 out_reg_reg_6_ ( .D(n76), .CK(clk), .RN(n193), .Q(data_out[6]), .QN(
        n241) );
  DFFR_X1 reg1_reg_7_ ( .D(n130), .CK(clk), .RN(n193), .Q(reg1[7]), .QN(n247)
         );
  DFFR_X1 out_reg_reg_7_ ( .D(n74), .CK(clk), .RN(n193), .Q(data_out[7]), .QN(
        n244) );
  DFFR_X1 reg2_reg_0_ ( .D(n90), .CK(clk), .RN(n194), .Q(reg2[0]), .QN(n178)
         );
  DFFR_X1 reg1_reg_0_ ( .D(n89), .CK(clk), .RN(n194), .Q(reg1[0]), .QN(n174)
         );
  BUF_X1 U102 ( .A(n221), .Z(n173) );
  BUF_X1 U103 ( .A(n223), .Z(n99) );
  NAND2_X1 U104 ( .A1(n100), .A2(n192), .ZN(n196) );
  AND2_X1 U105 ( .A1(n112), .A2(n176), .ZN(n100) );
  INV_X1 U106 ( .A(n231), .ZN(n101) );
  OR2_X1 U107 ( .A1(current_state[2]), .A2(current_state[0]), .ZN(n102) );
  OR2_X1 U108 ( .A1(n177), .A2(current_state[0]), .ZN(n187) );
  BUF_X1 U109 ( .A(n122), .Z(n120) );
  BUF_X2 U110 ( .A(n118), .Z(n119) );
  AND3_X2 U111 ( .A1(n191), .A2(n157), .A3(n160), .ZN(n104) );
  INV_X1 U112 ( .A(n105), .ZN(n106) );
  CLKBUF_X1 U113 ( .A(n121), .Z(n107) );
  BUF_X1 U114 ( .A(n182), .Z(n108) );
  CLKBUF_X1 U115 ( .A(n157), .Z(n109) );
  NAND2_X1 U116 ( .A1(n245), .A2(n172), .ZN(n110) );
  NAND2_X1 U117 ( .A1(n172), .A2(n118), .ZN(n246) );
  INV_X1 U118 ( .A(n153), .ZN(n111) );
  OR2_X2 U119 ( .A1(current_state[2]), .A2(current_state[1]), .ZN(n186) );
  INV_X1 U120 ( .A(start), .ZN(n112) );
  CLKBUF_X1 U121 ( .A(n178), .Z(n113) );
  AND3_X1 U122 ( .A1(n148), .A2(n191), .A3(n124), .ZN(n114) );
  AND3_X1 U123 ( .A1(n148), .A2(n191), .A3(n124), .ZN(n122) );
  AND3_X1 U124 ( .A1(n172), .A2(n183), .A3(n166), .ZN(n115) );
  CLKBUF_X1 U125 ( .A(n129), .Z(n116) );
  CLKBUF_X1 U126 ( .A(n114), .Z(n117) );
  INV_X1 U127 ( .A(n121), .ZN(n223) );
  INV_X1 U128 ( .A(n149), .ZN(n118) );
  BUF_X1 U129 ( .A(n201), .Z(n149) );
  AND3_X2 U130 ( .A1(n203), .A2(n166), .A3(n160), .ZN(n121) );
  NAND3_X1 U131 ( .A1(n127), .A2(n128), .A3(n126), .ZN(n123) );
  NAND2_X1 U132 ( .A1(n224), .A2(n202), .ZN(n124) );
  INV_X1 U133 ( .A(n166), .ZN(n125) );
  NAND2_X1 U134 ( .A1(N49), .A2(n117), .ZN(n126) );
  NAND2_X1 U135 ( .A1(N57), .A2(n116), .ZN(n127) );
  INV_X1 U136 ( .A(n216), .ZN(n128) );
  AND2_X2 U137 ( .A1(n200), .A2(n183), .ZN(n129) );
  NAND3_X1 U138 ( .A1(n190), .A2(n188), .A3(n189), .ZN(n130) );
  XOR2_X1 U139 ( .A(n192), .B(n182), .Z(n191) );
  BUF_X1 U140 ( .A(rst_n), .Z(n193) );
  BUF_X1 U141 ( .A(rst_n), .Z(n194) );
  BUF_X1 U142 ( .A(rst_n), .Z(n195) );
  INV_X1 U143 ( .A(n131), .ZN(done) );
  INV_X1 U144 ( .A(n180), .ZN(n141) );
  AND3_X1 U145 ( .A1(n186), .A2(n187), .A3(n197), .ZN(n142) );
  INV_X1 U146 ( .A(n234), .ZN(n143) );
  INV_X1 U147 ( .A(n158), .ZN(n144) );
  INV_X1 U148 ( .A(n169), .ZN(n145) );
  INV_X1 U149 ( .A(n178), .ZN(n146) );
  INV_X1 U150 ( .A(n115), .ZN(n147) );
  NAND2_X1 U151 ( .A1(n142), .A2(n125), .ZN(n148) );
  INV_X1 U152 ( .A(n150), .ZN(n151) );
  INV_X1 U153 ( .A(n153), .ZN(n154) );
  INV_X1 U154 ( .A(n155), .ZN(n156) );
  NAND2_X1 U155 ( .A1(n196), .A2(n108), .ZN(n157) );
  NAND2_X1 U156 ( .A1(n196), .A2(n108), .ZN(n224) );
  AND2_X1 U157 ( .A1(n196), .A2(n108), .ZN(n172) );
  INV_X1 U158 ( .A(n158), .ZN(n159) );
  NAND3_X1 U159 ( .A1(n197), .A2(n186), .A3(n187), .ZN(n160) );
  NAND3_X1 U160 ( .A1(n197), .A2(n102), .A3(n186), .ZN(n202) );
  INV_X1 U161 ( .A(n237), .ZN(n161) );
  INV_X1 U162 ( .A(n162), .ZN(n163) );
  INV_X1 U163 ( .A(n164), .ZN(n165) );
  XNOR2_X1 U164 ( .A(n192), .B(n182), .ZN(n166) );
  INV_X1 U165 ( .A(n167), .ZN(n168) );
  INV_X1 U166 ( .A(n149), .ZN(n245) );
  INV_X1 U167 ( .A(n170), .ZN(n171) );
  AOI22_X1 U168 ( .A1(data_in[5]), .A2(n107), .B1(n115), .B2(n161), .ZN(n214)
         );
  INV_X1 U169 ( .A(n174), .ZN(n175) );
  INV_X1 U170 ( .A(n176), .ZN(n177) );
  INV_X1 U171 ( .A(n113), .ZN(n179) );
  INV_X1 U172 ( .A(n180), .ZN(n181) );
  NAND2_X1 U173 ( .A1(N56), .A2(n116), .ZN(n211) );
  NAND2_X1 U174 ( .A1(n159), .A2(n210), .ZN(n213) );
  INV_X1 U175 ( .A(n160), .ZN(n183) );
  INV_X1 U176 ( .A(n184), .ZN(n185) );
  NAND2_X1 U177 ( .A1(N50), .A2(n117), .ZN(n188) );
  NAND2_X1 U178 ( .A1(N58), .A2(n116), .ZN(n189) );
  INV_X1 U179 ( .A(n219), .ZN(n190) );
  NAND4_X1 U180 ( .A1(n211), .A2(n212), .A3(n213), .A4(n214), .ZN(n79) );
  NAND2_X1 U181 ( .A1(N48), .A2(n117), .ZN(n212) );
  NAND3_X1 U182 ( .A1(current_state[0]), .A2(current_state[1]), .A3(n177), 
        .ZN(n197) );
  NAND2_X1 U183 ( .A1(n142), .A2(n191), .ZN(n201) );
  NAND2_X1 U184 ( .A1(n224), .A2(n166), .ZN(n199) );
  OAI21_X1 U185 ( .B1(n183), .B2(n199), .A(n249), .ZN(n198) );
  NAND2_X1 U186 ( .A1(n110), .A2(n198), .ZN(n98) );
  MUX2_X1 U187 ( .A(n179), .B(data_in[0]), .S(n104), .Z(n90) );
  INV_X1 U188 ( .A(reg1[0]), .ZN(n226) );
  NAND3_X1 U189 ( .A1(n172), .A2(n183), .A3(n166), .ZN(n218) );
  NAND2_X1 U190 ( .A1(n157), .A2(n202), .ZN(n203) );
  NAND2_X1 U191 ( .A1(n124), .A2(n201), .ZN(n210) );
  INV_X1 U192 ( .A(n210), .ZN(n221) );
  INV_X1 U193 ( .A(n163), .ZN(n229) );
  INV_X1 U194 ( .A(n199), .ZN(n200) );
  AOI222_X1 U195 ( .A1(N52), .A2(n129), .B1(n114), .B2(N44), .C1(n121), .C2(
        data_in[1]), .ZN(n204) );
  OAI221_X1 U196 ( .B1(n226), .B2(n147), .C1(n173), .C2(n229), .A(n204), .ZN(
        n87) );
  INV_X1 U197 ( .A(n145), .ZN(n231) );
  AOI222_X1 U198 ( .A1(N53), .A2(n129), .B1(n122), .B2(N45), .C1(n121), .C2(
        data_in[2]), .ZN(n205) );
  OAI221_X1 U199 ( .B1(n229), .B2(n147), .C1(n173), .C2(n231), .A(n205), .ZN(
        n85) );
  AOI222_X1 U200 ( .A1(N46), .A2(n120), .B1(n115), .B2(n101), .C1(n143), .C2(
        n210), .ZN(n207) );
  AOI22_X1 U201 ( .A1(data_in[3]), .A2(n107), .B1(N54), .B2(n129), .ZN(n206)
         );
  NAND2_X1 U202 ( .A1(n207), .A2(n206), .ZN(n83) );
  MUX2_X1 U203 ( .A(reg2[7]), .B(data_in[7]), .S(n104), .Z(n97) );
  MUX2_X1 U204 ( .A(n106), .B(data_in[6]), .S(n104), .Z(n96) );
  MUX2_X1 U205 ( .A(n156), .B(data_in[5]), .S(n104), .Z(n95) );
  MUX2_X1 U206 ( .A(n171), .B(data_in[4]), .S(n104), .Z(n94) );
  MUX2_X1 U207 ( .A(n154), .B(data_in[3]), .S(n104), .Z(n93) );
  MUX2_X1 U208 ( .A(reg2[2]), .B(data_in[2]), .S(n104), .Z(n92) );
  MUX2_X1 U209 ( .A(n181), .B(data_in[1]), .S(n104), .Z(n91) );
  AOI222_X1 U210 ( .A1(N55), .A2(n129), .B1(n115), .B2(n143), .C1(n161), .C2(
        n210), .ZN(n209) );
  AOI22_X1 U211 ( .A1(N47), .A2(n117), .B1(data_in[4]), .B2(n107), .ZN(n208)
         );
  NAND2_X1 U212 ( .A1(n208), .A2(n209), .ZN(n81) );
  INV_X1 U213 ( .A(n151), .ZN(n243) );
  INV_X1 U214 ( .A(n159), .ZN(n240) );
  INV_X1 U215 ( .A(data_in[6]), .ZN(n215) );
  OAI222_X1 U216 ( .A1(n221), .A2(n243), .B1(n240), .B2(n218), .C1(n223), .C2(
        n215), .ZN(n216) );
  INV_X1 U217 ( .A(data_in[7]), .ZN(n217) );
  OAI222_X1 U218 ( .A1(n221), .A2(n247), .B1(n243), .B2(n218), .C1(n223), .C2(
        n217), .ZN(n219) );
  INV_X1 U219 ( .A(data_in[0]), .ZN(n222) );
  AOI22_X1 U220 ( .A1(n120), .A2(N43), .B1(N51), .B2(n129), .ZN(n220) );
  OAI221_X1 U221 ( .B1(n99), .B2(n222), .C1(n173), .C2(n226), .A(n220), .ZN(
        n89) );
  NAND2_X1 U222 ( .A1(n245), .A2(n109), .ZN(n248) );
  OAI222_X1 U223 ( .A1(n248), .A2(n226), .B1(n246), .B2(n113), .C1(n119), .C2(
        n225), .ZN(n88) );
  INV_X1 U224 ( .A(n181), .ZN(n228) );
  OAI222_X1 U225 ( .A1(n248), .A2(n229), .B1(n246), .B2(n228), .C1(n119), .C2(
        n227), .ZN(n86) );
  OAI222_X1 U226 ( .A1(n248), .A2(n231), .B1(n246), .B2(n164), .C1(n119), .C2(
        n230), .ZN(n84) );
  INV_X1 U227 ( .A(reg1[3]), .ZN(n234) );
  INV_X1 U228 ( .A(n154), .ZN(n233) );
  OAI222_X1 U229 ( .A1(n248), .A2(n234), .B1(n110), .B2(n233), .C1(n119), .C2(
        n232), .ZN(n82) );
  INV_X1 U230 ( .A(reg1[4]), .ZN(n237) );
  INV_X1 U231 ( .A(n171), .ZN(n236) );
  OAI222_X1 U232 ( .A1(n248), .A2(n237), .B1(n110), .B2(n236), .C1(n119), .C2(
        n235), .ZN(n80) );
  INV_X1 U233 ( .A(n156), .ZN(n239) );
  OAI222_X1 U234 ( .A1(n248), .A2(n240), .B1(n110), .B2(n239), .C1(n119), .C2(
        n238), .ZN(n78) );
  INV_X1 U235 ( .A(n106), .ZN(n242) );
  OAI222_X1 U236 ( .A1(n248), .A2(n243), .B1(n246), .B2(n242), .C1(n119), .C2(
        n241), .ZN(n76) );
  OAI222_X1 U237 ( .A1(n248), .A2(n247), .B1(n110), .B2(n103), .C1(n119), .C2(
        n244), .ZN(n74) );
  INV_X1 sub_37_U126 ( .A(sub_37_n40), .ZN(sub_37_n86) );
  NOR2_X1 sub_37_U125 ( .A1(sub_37_n16), .A2(sub_37_n86), .ZN(sub_37_n113) );
  INV_X1 sub_37_U124 ( .A(sub_37_n2), .ZN(sub_37_n110) );
  INV_X1 sub_37_U123 ( .A(sub_37_n95), .ZN(sub_37_n36) );
  NOR2_X1 sub_37_U122 ( .A1(sub_37_n110), .A2(sub_37_n15), .ZN(sub_37_n109) );
  INV_X1 sub_37_U121 ( .A(sub_37_n107), .ZN(sub_37_n104) );
  NAND2_X1 sub_37_U120 ( .A1(sub_37_n86), .A2(sub_37_n88), .ZN(sub_37_n106) );
  OAI211_X1 sub_37_U119 ( .C1(sub_37_n104), .C2(sub_37_n105), .A(sub_37_n106), 
        .B(sub_37_n1), .ZN(sub_37_n102) );
  XNOR2_X1 sub_37_U118 ( .A(sub_37_n102), .B(sub_37_n103), .ZN(N54) );
  NOR2_X1 sub_37_U117 ( .A1(sub_37_n4), .A2(sub_37_n36), .ZN(sub_37_n99) );
  NAND3_X1 sub_37_U116 ( .A1(sub_37_n33), .A2(sub_37_n99), .A3(sub_37_n43), 
        .ZN(sub_37_n92) );
  INV_X1 sub_37_U115 ( .A(sub_37_n94), .ZN(sub_37_n81) );
  NAND3_X1 sub_37_U114 ( .A1(sub_37_n5), .A2(sub_37_n57), .A3(sub_37_n81), 
        .ZN(sub_37_n93) );
  NAND3_X1 sub_37_U113 ( .A1(sub_37_n93), .A2(sub_37_n92), .A3(sub_37_n91), 
        .ZN(sub_37_n89) );
  XNOR2_X1 sub_37_U112 ( .A(sub_37_n89), .B(sub_37_n90), .ZN(N55) );
  NAND3_X1 sub_37_U111 ( .A1(sub_37_n88), .A2(sub_37_n61), .A3(sub_37_n68), 
        .ZN(sub_37_n83) );
  OAI21_X1 sub_37_U110 ( .B1(sub_37_n86), .B2(sub_37_n87), .A(sub_37_n57), 
        .ZN(sub_37_n84) );
  INV_X1 sub_37_U109 ( .A(sub_37_n62), .ZN(sub_37_n37) );
  NOR2_X1 sub_37_U108 ( .A1(sub_37_n4), .A2(sub_37_n37), .ZN(sub_37_n82) );
  NOR2_X1 sub_37_U107 ( .A1(sub_37_n37), .A2(sub_37_n16), .ZN(sub_37_n80) );
  NAND3_X1 sub_37_U106 ( .A1(sub_37_n80), .A2(sub_37_n5), .A3(sub_37_n81), 
        .ZN(sub_37_n79) );
  NAND2_X1 sub_37_U105 ( .A1(sub_37_n78), .A2(sub_37_n79), .ZN(sub_37_n77) );
  INV_X1 sub_37_U104 ( .A(sub_37_n59), .ZN(sub_37_n38) );
  INV_X1 sub_37_U103 ( .A(sub_37_n70), .ZN(sub_37_n75) );
  NOR2_X1 sub_37_U102 ( .A1(sub_37_n38), .A2(sub_37_n75), .ZN(sub_37_n74) );
  INV_X1 sub_37_U101 ( .A(sub_37_n29), .ZN(sub_37_n50) );
  NOR2_X1 sub_37_U100 ( .A1(sub_37_n4), .A2(sub_37_n15), .ZN(sub_37_n65) );
  NAND3_X1 sub_37_U99 ( .A1(sub_37_n66), .A2(sub_37_n33), .A3(sub_37_n65), 
        .ZN(sub_37_n51) );
  NAND3_X1 sub_37_U98 ( .A1(sub_37_n7), .A2(sub_37_n61), .A3(sub_37_n23), .ZN(
        sub_37_n52) );
  NAND2_X1 sub_37_U97 ( .A1(sub_37_n54), .A2(sub_37_n55), .ZN(sub_37_n53) );
  NAND4_X1 sub_37_U96 ( .A1(sub_37_n50), .A2(sub_37_n51), .A3(sub_37_n52), 
        .A4(sub_37_n53), .ZN(sub_37_n46) );
  XNOR2_X1 sub_37_U95 ( .A(sub_37_n46), .B(sub_37_n47), .ZN(N57) );
  INV_X1 sub_37_U94 ( .A(sub_37_n28), .ZN(sub_37_n42) );
  NOR2_X1 sub_37_U93 ( .A1(sub_37_n4), .A2(sub_37_n42), .ZN(sub_37_n45) );
  NAND3_X1 sub_37_U92 ( .A1(sub_37_n23), .A2(sub_37_n7), .A3(sub_37_n45), .ZN(
        sub_37_n18) );
  NAND4_X1 sub_37_U91 ( .A1(sub_37_n32), .A2(sub_37_n33), .A3(sub_37_n34), 
        .A4(sub_37_n35), .ZN(sub_37_n19) );
  INV_X1 sub_37_U90 ( .A(sub_37_n31), .ZN(sub_37_n30) );
  INV_X1 sub_37_U89 ( .A(sub_37_n27), .ZN(sub_37_n25) );
  NAND3_X1 sub_37_U88 ( .A1(sub_37_n24), .A2(sub_37_n23), .A3(sub_37_n22), 
        .ZN(sub_37_n21) );
  NAND4_X1 sub_37_U87 ( .A1(sub_37_n21), .A2(sub_37_n20), .A3(sub_37_n18), 
        .A4(sub_37_n19), .ZN(sub_37_n17) );
  INV_X1 sub_37_U86 ( .A(n141), .ZN(sub_37_n114) );
  NAND2_X1 sub_37_U85 ( .A1(n141), .A2(sub_37_n8), .ZN(sub_37_n43) );
  NOR2_X1 sub_37_U84 ( .A1(sub_37_n6), .A2(sub_37_n56), .ZN(sub_37_n55) );
  NAND2_X1 sub_37_U83 ( .A1(sub_37_n82), .A2(sub_37_n7), .ZN(sub_37_n78) );
  INV_X1 sub_37_U82 ( .A(reg2[0]), .ZN(sub_37_n41) );
  NAND2_X1 sub_37_U81 ( .A1(sub_37_n12), .A2(sub_37_n60), .ZN(sub_37_n27) );
  NOR2_X1 sub_37_U80 ( .A1(sub_37_n12), .A2(sub_37_n60), .ZN(sub_37_n87) );
  NAND2_X1 sub_37_U79 ( .A1(sub_37_n12), .A2(sub_37_n9), .ZN(sub_37_n115) );
  NOR2_X1 sub_37_U78 ( .A1(sub_37_n12), .A2(sub_37_n9), .ZN(sub_37_n116) );
  OAI21_X1 sub_37_U77 ( .B1(sub_37_n12), .B2(sub_37_n9), .A(sub_37_n115), .ZN(
        N51) );
  INV_X1 sub_37_U76 ( .A(n185), .ZN(sub_37_n63) );
  NAND2_X1 sub_37_U75 ( .A1(n171), .A2(sub_37_n63), .ZN(sub_37_n62) );
  NAND2_X1 sub_37_U74 ( .A1(n171), .A2(sub_37_n63), .ZN(sub_37_n68) );
  INV_X1 sub_37_U73 ( .A(n168), .ZN(sub_37_n97) );
  INV_X1 sub_37_U72 ( .A(n165), .ZN(sub_37_n111) );
  NAND2_X1 sub_37_U71 ( .A1(n165), .A2(sub_37_n98), .ZN(sub_37_n88) );
  NOR2_X1 sub_37_U70 ( .A1(sub_37_n16), .A2(sub_37_n42), .ZN(sub_37_n22) );
  AOI21_X1 sub_37_U69 ( .B1(sub_37_n107), .B2(sub_37_n57), .A(sub_37_n86), 
        .ZN(sub_37_n108) );
  NAND2_X1 sub_37_U68 ( .A1(sub_37_n88), .A2(sub_37_n43), .ZN(sub_37_n105) );
  INV_X1 sub_37_U67 ( .A(reg1[0]), .ZN(sub_37_n60) );
  NAND2_X1 sub_37_U66 ( .A1(reg1[0]), .A2(sub_37_n41), .ZN(sub_37_n39) );
  NAND2_X1 sub_37_U65 ( .A1(sub_37_n114), .A2(reg1[1]), .ZN(sub_37_n40) );
  INV_X1 sub_37_U64 ( .A(n171), .ZN(sub_37_n72) );
  NAND2_X1 sub_37_U63 ( .A1(n156), .A2(sub_37_n64), .ZN(sub_37_n59) );
  NAND2_X1 sub_37_U62 ( .A1(n111), .A2(sub_37_n97), .ZN(sub_37_n96) );
  INV_X1 sub_37_U61 ( .A(n144), .ZN(sub_37_n64) );
  OAI211_X1 sub_37_U60 ( .C1(n144), .C2(sub_37_n71), .A(sub_37_n72), .B(
        sub_37_n3), .ZN(sub_37_n69) );
  NAND2_X1 sub_37_U59 ( .A1(n144), .A2(sub_37_n71), .ZN(sub_37_n70) );
  NAND2_X1 sub_37_U58 ( .A1(sub_37_n27), .A2(sub_37_n59), .ZN(sub_37_n58) );
  NAND2_X1 sub_37_U57 ( .A1(sub_37_n95), .A2(sub_37_n96), .ZN(sub_37_n26) );
  XNOR2_X1 sub_37_U56 ( .A(sub_37_n73), .B(sub_37_n74), .ZN(N56) );
  INV_X1 sub_37_U55 ( .A(n145), .ZN(sub_37_n98) );
  NAND2_X1 sub_37_U54 ( .A1(n111), .A2(sub_37_n13), .ZN(sub_37_n61) );
  INV_X1 sub_37_U53 ( .A(n156), .ZN(sub_37_n71) );
  NAND2_X1 sub_37_U52 ( .A1(sub_37_n69), .A2(sub_37_n70), .ZN(sub_37_n29) );
  INV_X1 sub_37_U51 ( .A(n106), .ZN(sub_37_n48) );
  NAND2_X1 sub_37_U50 ( .A1(sub_37_n10), .A2(sub_37_n111), .ZN(sub_37_n101) );
  NAND2_X1 sub_37_U49 ( .A1(n141), .A2(sub_37_n8), .ZN(sub_37_n57) );
  AND2_X1 sub_37_U48 ( .A1(n141), .A2(sub_37_n8), .ZN(sub_37_n16) );
  INV_X1 sub_37_U47 ( .A(n151), .ZN(sub_37_n49) );
  NAND2_X1 sub_37_U46 ( .A1(n106), .A2(sub_37_n49), .ZN(sub_37_n28) );
  NAND2_X1 sub_37_U45 ( .A1(n151), .A2(sub_37_n48), .ZN(sub_37_n31) );
  AOI21_X1 sub_37_U44 ( .B1(sub_37_n29), .B2(sub_37_n28), .A(sub_37_n30), .ZN(
        sub_37_n20) );
  NAND2_X1 sub_37_U43 ( .A1(sub_37_n28), .A2(sub_37_n31), .ZN(sub_37_n47) );
  INV_X1 sub_37_U42 ( .A(sub_37_n88), .ZN(sub_37_n15) );
  NOR2_X1 sub_37_U41 ( .A1(sub_37_n58), .A2(sub_37_n26), .ZN(sub_37_n54) );
  NOR2_X1 sub_37_U40 ( .A1(sub_37_n25), .A2(sub_37_n26), .ZN(sub_37_n24) );
  NAND2_X1 sub_37_U39 ( .A1(sub_37_n40), .A2(sub_37_n39), .ZN(sub_37_n33) );
  NAND2_X1 sub_37_U38 ( .A1(sub_37_n61), .A2(sub_37_n100), .ZN(sub_37_n103) );
  NAND2_X1 sub_37_U37 ( .A1(sub_37_n44), .A2(sub_37_n61), .ZN(sub_37_n91) );
  NOR2_X1 sub_37_U36 ( .A1(sub_37_n76), .A2(sub_37_n77), .ZN(sub_37_n73) );
  AND2_X1 sub_37_U35 ( .A1(sub_37_n88), .A2(sub_37_n61), .ZN(sub_37_n35) );
  AND2_X1 sub_37_U34 ( .A1(sub_37_n62), .A2(sub_37_n59), .ZN(sub_37_n34) );
  NOR2_X1 sub_37_U32 ( .A1(sub_37_n115), .A2(sub_37_n116), .ZN(sub_37_n112) );
  OR2_X1 sub_37_U31 ( .A1(reg1[0]), .A2(sub_37_n41), .ZN(sub_37_n107) );
  OAI21_X1 sub_37_U30 ( .B1(sub_37_n83), .B2(sub_37_n84), .A(sub_37_n85), .ZN(
        sub_37_n76) );
  XNOR2_X1 sub_37_U29 ( .A(sub_37_n112), .B(sub_37_n113), .ZN(N52) );
  XNOR2_X1 sub_37_U28 ( .A(sub_37_n108), .B(sub_37_n109), .ZN(N53) );
  NAND2_X1 sub_37_U27 ( .A1(sub_37_n3), .A2(sub_37_n72), .ZN(sub_37_n85) );
  AND2_X1 sub_37_U26 ( .A1(sub_37_n59), .A2(sub_37_n62), .ZN(sub_37_n23) );
  INV_X1 sub_37_U25 ( .A(n168), .ZN(sub_37_n13) );
  OR2_X1 sub_37_U24 ( .A1(sub_37_n13), .A2(n111), .ZN(sub_37_n100) );
  NAND2_X1 sub_37_U23 ( .A1(sub_37_n85), .A2(sub_37_n68), .ZN(sub_37_n90) );
  NAND2_X1 sub_37_U22 ( .A1(sub_37_n100), .A2(sub_37_n1), .ZN(sub_37_n44) );
  INV_X1 sub_37_U21 ( .A(sub_37_n57), .ZN(sub_37_n56) );
  NAND2_X1 sub_37_U20 ( .A1(sub_37_n43), .A2(sub_37_n68), .ZN(sub_37_n67) );
  NOR2_X1 sub_37_U19 ( .A1(sub_37_n38), .A2(sub_37_n67), .ZN(sub_37_n66) );
  BUF_X2 sub_37_U18 ( .A(reg2[0]), .Z(sub_37_n12) );
  XOR2_X1 sub_37_U17 ( .A(reg2[7]), .B(reg1[7]), .Z(sub_37_n11) );
  XNOR2_X1 sub_37_U16 ( .A(sub_37_n17), .B(sub_37_n11), .ZN(N58) );
  CLKBUF_X1 sub_37_U15 ( .A(n145), .Z(sub_37_n10) );
  INV_X1 sub_37_U14 ( .A(reg1[0]), .ZN(sub_37_n9) );
  NAND2_X1 sub_37_U13 ( .A1(sub_37_n98), .A2(n165), .ZN(sub_37_n95) );
  INV_X1 sub_37_U12 ( .A(reg1[1]), .ZN(sub_37_n8) );
  NAND2_X1 sub_37_U11 ( .A1(sub_37_n100), .A2(sub_37_n101), .ZN(sub_37_n7) );
  INV_X1 sub_37_U10 ( .A(sub_37_n68), .ZN(sub_37_n6) );
  AND2_X1 sub_37_U9 ( .A1(sub_37_n95), .A2(sub_37_n96), .ZN(sub_37_n5) );
  AND2_X1 sub_37_U8 ( .A1(n111), .A2(sub_37_n97), .ZN(sub_37_n4) );
  CLKBUF_X1 sub_37_U7 ( .A(n185), .Z(sub_37_n3) );
  NAND2_X1 sub_37_U6 ( .A1(sub_37_n10), .A2(sub_37_n111), .ZN(sub_37_n2) );
  NAND2_X1 sub_37_U5 ( .A1(sub_37_n10), .A2(sub_37_n111), .ZN(sub_37_n1) );
  AND2_X1 sub_37_U4 ( .A1(sub_37_n28), .A2(sub_37_n43), .ZN(sub_37_n32) );
  OAI21_X1 sub_37_U3 ( .B1(reg1[0]), .B2(sub_37_n41), .A(1'b1), .ZN(sub_37_n94) );
  INV_X1 add_36_U83 ( .A(add_36_n71), .ZN(add_36_n70) );
  INV_X1 add_36_U82 ( .A(add_36_n49), .ZN(add_36_n26) );
  INV_X1 add_36_U81 ( .A(add_36_n68), .ZN(add_36_n66) );
  INV_X1 add_36_U80 ( .A(add_36_n60), .ZN(add_36_n67) );
  OAI21_X1 add_36_U79 ( .B1(add_36_n66), .B2(add_36_n67), .A(add_36_n63), .ZN(
        add_36_n64) );
  XNOR2_X1 add_36_U78 ( .A(add_36_n64), .B(add_36_n65), .ZN(N46) );
  INV_X1 add_36_U77 ( .A(add_36_n63), .ZN(add_36_n62) );
  INV_X1 add_36_U76 ( .A(add_36_n48), .ZN(add_36_n35) );
  INV_X1 add_36_U75 ( .A(add_36_n41), .ZN(add_36_n54) );
  INV_X1 add_36_U74 ( .A(add_36_n43), .ZN(add_36_n40) );
  INV_X1 add_36_U73 ( .A(add_36_n42), .ZN(add_36_n52) );
  INV_X1 add_36_U72 ( .A(add_36_n28), .ZN(add_36_n39) );
  XNOR2_X1 add_36_U71 ( .A(add_36_n36), .B(add_36_n37), .ZN(N49) );
  INV_X1 add_36_U70 ( .A(add_36_n31), .ZN(add_36_n30) );
  INV_X1 add_36_U69 ( .A(add_36_n16), .ZN(add_36_n23) );
  NOR2_X1 add_36_U68 ( .A1(add_36_n26), .A2(add_36_n10), .ZN(add_36_n24) );
  NAND4_X1 add_36_U67 ( .A1(add_36_n15), .A2(add_36_n23), .A3(add_36_n24), 
        .A4(add_36_n5), .ZN(add_36_n22) );
  XNOR2_X1 add_36_U66 ( .A(add_36_n18), .B(add_36_n19), .ZN(N50) );
  NAND2_X1 add_36_U65 ( .A1(n146), .A2(n175), .ZN(add_36_n59) );
  NAND2_X1 add_36_U64 ( .A1(add_36_n58), .A2(add_36_n47), .ZN(add_36_n53) );
  AOI21_X1 add_36_U63 ( .B1(add_36_n53), .B2(add_36_n13), .A(add_36_n54), .ZN(
        add_36_n50) );
  XNOR2_X1 add_36_U62 ( .A(add_36_n50), .B(add_36_n51), .ZN(N48) );
  NAND2_X1 add_36_U61 ( .A1(add_36_n8), .A2(add_36_n4), .ZN(add_36_n25) );
  OAI21_X1 add_36_U60 ( .B1(add_36_n70), .B2(add_36_n26), .A(add_36_n17), .ZN(
        add_36_n68) );
  NAND2_X1 add_36_U59 ( .A1(add_36_n49), .A2(add_36_n17), .ZN(add_36_n72) );
  INV_X1 add_36_U58 ( .A(add_36_n11), .ZN(add_36_n74) );
  NAND2_X1 add_36_U57 ( .A1(add_36_n25), .A2(add_36_n49), .ZN(add_36_n46) );
  NOR2_X1 add_36_U56 ( .A1(add_36_n27), .A2(add_36_n34), .ZN(add_36_n33) );
  NOR2_X1 add_36_U55 ( .A1(add_36_n10), .A2(add_36_n27), .ZN(add_36_n32) );
  OAI21_X1 add_36_U54 ( .B1(add_36_n38), .B2(add_36_n16), .A(add_36_n39), .ZN(
        add_36_n36) );
  NAND2_X1 add_36_U53 ( .A1(reg1[3]), .A2(reg2[3]), .ZN(add_36_n48) );
  NAND2_X1 add_36_U52 ( .A1(add_36_n62), .A2(add_36_n61), .ZN(add_36_n47) );
  NAND2_X1 add_36_U51 ( .A1(add_36_n48), .A2(add_36_n61), .ZN(add_36_n65) );
  NAND2_X1 add_36_U50 ( .A1(reg2[2]), .A2(reg1[2]), .ZN(add_36_n63) );
  OAI211_X1 add_36_U49 ( .C1(add_36_n3), .C2(add_36_n46), .A(add_36_n47), .B(
        add_36_n48), .ZN(add_36_n45) );
  INV_X1 add_36_U48 ( .A(n175), .ZN(add_36_n75) );
  INV_X1 add_36_U47 ( .A(reg2[4]), .ZN(add_36_n56) );
  NAND2_X1 add_36_U46 ( .A1(reg2[4]), .A2(reg1[4]), .ZN(add_36_n41) );
  AOI21_X1 add_36_U45 ( .B1(add_36_n32), .B2(add_36_n12), .A(add_36_n33), .ZN(
        add_36_n20) );
  NAND2_X1 add_36_U44 ( .A1(reg2[5]), .A2(reg1[5]), .ZN(add_36_n42) );
  NAND2_X1 add_36_U43 ( .A1(n152), .A2(reg1[6]), .ZN(add_36_n31) );
  NAND2_X1 add_36_U42 ( .A1(add_36_n35), .A2(add_36_n29), .ZN(add_36_n34) );
  AOI21_X1 add_36_U41 ( .B1(add_36_n28), .B2(add_36_n29), .A(add_36_n30), .ZN(
        add_36_n21) );
  NAND2_X1 add_36_U40 ( .A1(add_36_n31), .A2(add_36_n29), .ZN(add_36_n37) );
  INV_X1 add_36_U39 ( .A(reg1[4]), .ZN(add_36_n57) );
  XNOR2_X1 add_36_U38 ( .A(add_36_n7), .B(add_36_n55), .ZN(N47) );
  OAI21_X1 add_36_U37 ( .B1(add_36_n40), .B2(add_36_n41), .A(add_36_n42), .ZN(
        add_36_n28) );
  OR2_X2 add_36_U36 ( .A1(reg1[3]), .A2(reg2[3]), .ZN(add_36_n61) );
  NAND2_X1 add_36_U35 ( .A1(add_36_n43), .A2(add_36_n44), .ZN(add_36_n27) );
  NAND2_X1 add_36_U34 ( .A1(add_36_n56), .A2(add_36_n57), .ZN(add_36_n44) );
  NAND2_X1 add_36_U33 ( .A1(add_36_n43), .A2(add_36_n44), .ZN(add_36_n16) );
  AND2_X1 add_36_U32 ( .A1(add_36_n60), .A2(add_36_n61), .ZN(add_36_n15) );
  NAND2_X1 add_36_U31 ( .A1(add_36_n4), .A2(add_36_n59), .ZN(add_36_n14) );
  XNOR2_X1 add_36_U30 ( .A(add_36_n6), .B(add_36_n69), .ZN(N45) );
  OR2_X2 add_36_U29 ( .A1(reg2[2]), .A2(reg1[2]), .ZN(add_36_n60) );
  NAND2_X1 add_36_U28 ( .A1(add_36_n56), .A2(add_36_n57), .ZN(add_36_n13) );
  AND2_X1 add_36_U27 ( .A1(add_36_n62), .A2(add_36_n61), .ZN(add_36_n12) );
  CLKBUF_X1 add_36_U26 ( .A(n146), .Z(add_36_n11) );
  INV_X1 add_36_U25 ( .A(add_36_n29), .ZN(add_36_n10) );
  NAND3_X1 add_36_U24 ( .A1(add_36_n20), .A2(add_36_n22), .A3(add_36_n21), 
        .ZN(add_36_n18) );
  OR2_X2 add_36_U23 ( .A1(reg2[5]), .A2(reg1[5]), .ZN(add_36_n43) );
  XNOR2_X1 add_36_U22 ( .A(reg2[7]), .B(reg1[7]), .ZN(add_36_n19) );
  OR2_X2 add_36_U21 ( .A1(n152), .A2(reg1[6]), .ZN(add_36_n29) );
  XNOR2_X1 add_36_U20 ( .A(add_36_n71), .B(add_36_n72), .ZN(N44) );
  AND2_X1 add_36_U19 ( .A1(add_36_n73), .A2(add_36_n8), .ZN(N43) );
  NAND2_X1 add_36_U18 ( .A1(add_36_n41), .A2(add_36_n13), .ZN(add_36_n55) );
  NAND2_X1 add_36_U17 ( .A1(add_36_n63), .A2(add_36_n60), .ZN(add_36_n69) );
  INV_X1 add_36_U16 ( .A(add_36_n45), .ZN(add_36_n38) );
  NOR2_X1 add_36_U15 ( .A1(add_36_n40), .A2(add_36_n52), .ZN(add_36_n51) );
  NAND2_X1 add_36_U14 ( .A1(n146), .A2(n175), .ZN(add_36_n8) );
  OAI21_X1 add_36_U13 ( .B1(add_36_n70), .B2(add_36_n1), .A(add_36_n17), .ZN(
        add_36_n6) );
  CLKBUF_X1 add_36_U12 ( .A(add_36_n14), .Z(add_36_n5) );
  OR2_X2 add_36_U11 ( .A1(n163), .A2(reg2[1]), .ZN(add_36_n49) );
  CLKBUF_X1 add_36_U10 ( .A(add_36_n4), .Z(add_36_n17) );
  AND2_X1 add_36_U9 ( .A1(n146), .A2(n175), .ZN(add_36_n71) );
  NAND2_X1 add_36_U8 ( .A1(reg2[1]), .A2(n163), .ZN(add_36_n4) );
  NAND2_X1 add_36_U7 ( .A1(add_36_n60), .A2(add_36_n61), .ZN(add_36_n3) );
  NAND4_X1 add_36_U6 ( .A1(add_36_n14), .A2(add_36_n61), .A3(add_36_n60), .A4(
        add_36_n49), .ZN(add_36_n2) );
  AND2_X1 add_36_U5 ( .A1(add_36_n2), .A2(add_36_n48), .ZN(add_36_n58) );
  CLKBUF_X1 add_36_U4 ( .A(add_36_n53), .Z(add_36_n7) );
  INV_X1 add_36_U3 ( .A(add_36_n49), .ZN(add_36_n1) );
  NAND2_X1 add_36_U2 ( .A1(add_36_n74), .A2(add_36_n75), .ZN(add_36_n73) );
endmodule

