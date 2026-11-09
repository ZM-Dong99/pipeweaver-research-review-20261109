/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:30:03 2025
/////////////////////////////////////////////////////////////


module fsm_encode_gpt ( clk, rst_n, start, data_in, data_out, done );
  input [7:0] data_in;
  output [7:0] data_out;
  input clk, rst_n, start;
  output done;
  wire   N163, N164, N165, N166, N167, N168, N169, N170, N171, N172, N173,
         N174, N175, N176, N177, N178, n99, n100, n101, n102, n103, n104, n105,
         n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n139,
         n140, n141, n142, n143, n144, n145, n146, n147, n148, n149, n150,
         n151, n152, n153, n154, n155, n156, n157, n158, n159, n160, n161,
         n162, n163, n165, n167, n169, n171, n173, n175, n177, n179, n180,
         n181, n182, n183, n184, n185, n186, n187, n188, n189, n190, n191,
         n192, n193, n194, n195, n196, n197, n198, n199, n200, n201, n202,
         n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, n213,
         n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, n224,
         n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235,
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246,
         n247, n248, n249, n250, n251, n252, n253, n254, n255, n256, n257,
         n258, n259, n260, n261, n262, n263, n264, n265, n266, n267, n268,
         n269, n270, n271, n272, n273, n274, n275, n276, n277, n278, n279,
         n280, n281, n282, n283, n284, n285, n286, n287, n288, n289, n290,
         n291, n292, n293, n294, n295, n296, n297, n298, n299, n300, n301,
         n302, n303, n304, n305, n306, n307, n308, n309, n310, n311, n312,
         n313, n314, n315, sub_66_n78, sub_66_n77, sub_66_n76, sub_66_n75,
         sub_66_n74, sub_66_n73, sub_66_n72, sub_66_n71, sub_66_n70,
         sub_66_n69, sub_66_n68, sub_66_n67, sub_66_n66, sub_66_n65,
         sub_66_n64, sub_66_n63, sub_66_n62, sub_66_n61, sub_66_n60,
         sub_66_n59, sub_66_n58, sub_66_n57, sub_66_n56, sub_66_n55,
         sub_66_n54, sub_66_n53, sub_66_n52, sub_66_n51, sub_66_n50,
         sub_66_n49, sub_66_n48, sub_66_n47, sub_66_n46, sub_66_n45,
         sub_66_n44, sub_66_n43, sub_66_n42, sub_66_n41, sub_66_n40,
         sub_66_n39, sub_66_n38, sub_66_n37, sub_66_n36, sub_66_n35,
         sub_66_n34, sub_66_n33, sub_66_n32, sub_66_n31, sub_66_n30,
         sub_66_n29, sub_66_n28, sub_66_n27, sub_66_n26, sub_66_n25,
         sub_66_n24, sub_66_n23, sub_66_n22, sub_66_n21, sub_66_n20,
         sub_66_n19, sub_66_n18, sub_66_n17, sub_66_n16, sub_66_n14,
         sub_66_n13, sub_66_n12, sub_66_n11, sub_66_n10, sub_66_n9, sub_66_n8,
         sub_66_n7, sub_66_n6, sub_66_n5, sub_66_n4, sub_66_n3, sub_66_n2,
         sub_66_n1, add_63_n78, add_63_n77, add_63_n76, add_63_n75, add_63_n74,
         add_63_n73, add_63_n72, add_63_n71, add_63_n70, add_63_n69,
         add_63_n68, add_63_n67, add_63_n66, add_63_n65, add_63_n64,
         add_63_n63, add_63_n62, add_63_n61, add_63_n60, add_63_n59,
         add_63_n58, add_63_n57, add_63_n56, add_63_n55, add_63_n54,
         add_63_n53, add_63_n52, add_63_n51, add_63_n50, add_63_n49,
         add_63_n48, add_63_n47, add_63_n46, add_63_n45, add_63_n44,
         add_63_n43, add_63_n42, add_63_n41, add_63_n40, add_63_n39,
         add_63_n38, add_63_n37, add_63_n36, add_63_n35, add_63_n34,
         add_63_n33, add_63_n32, add_63_n31, add_63_n30, add_63_n29,
         add_63_n28, add_63_n27, add_63_n26, add_63_n25, add_63_n24,
         add_63_n23, add_63_n22, add_63_n21, add_63_n20, add_63_n19,
         add_63_n18, add_63_n17, add_63_n16, add_63_n15, add_63_n14,
         add_63_n13, add_63_n12, add_63_n11, add_63_n10, add_63_n8, add_63_n7,
         add_63_n6, add_63_n5, add_63_n4, add_63_n3, add_63_n2, add_63_n1;
  wire   [7:0] current_state;
  wire   [7:0] reg1;
  wire   [7:0] reg2;

  DFFS_X1 current_state_reg_0_ ( .D(n131), .CK(clk), .SN(n238), .Q(
        current_state[0]), .QN(n213) );
  DFFR_X1 current_state_reg_1_ ( .D(n130), .CK(clk), .RN(n238), .Q(
        current_state[1]), .QN(n225) );
  DFFR_X1 current_state_reg_2_ ( .D(n129), .CK(clk), .RN(n238), .Q(
        current_state[2]), .QN(n220) );
  DFFR_X1 current_state_reg_3_ ( .D(n128), .CK(clk), .RN(n238), .Q(
        current_state[3]), .QN(n222) );
  DFFR_X1 current_state_reg_4_ ( .D(n127), .CK(clk), .RN(n238), .Q(
        current_state[4]), .QN(n221) );
  DFFR_X1 current_state_reg_6_ ( .D(n126), .CK(clk), .RN(n238), .Q(
        current_state[6]), .QN(n231) );
  DFFR_X1 current_state_reg_7_ ( .D(n125), .CK(clk), .RN(n238), .Q(
        current_state[7]), .QN(n227) );
  DFFR_X1 current_state_reg_5_ ( .D(n124), .CK(clk), .RN(n238), .Q(
        current_state[5]), .QN(n219) );
  DFFR_X1 done_reg ( .D(n123), .CK(clk), .RN(n238), .Q(done), .QN(n258) );
  DFFR_X1 reg2_reg_7_ ( .D(n122), .CK(clk), .RN(n237), .Q(reg2[7]), .QN(n135)
         );
  DFFR_X1 reg2_reg_6_ ( .D(n121), .CK(clk), .RN(n237), .Q(reg2[6]), .QN(n186)
         );
  DFFR_X1 reg2_reg_5_ ( .D(n120), .CK(clk), .RN(n237), .Q(reg2[5]), .QN(n188)
         );
  DFFR_X1 reg2_reg_4_ ( .D(n119), .CK(clk), .RN(n237), .Q(reg2[4]), .QN(n192)
         );
  DFFR_X1 reg2_reg_3_ ( .D(n118), .CK(clk), .RN(n237), .Q(reg2[3]), .QN(n211)
         );
  DFFR_X1 reg2_reg_2_ ( .D(n117), .CK(clk), .RN(n237), .Q(reg2[2]), .QN(n207)
         );
  DFFR_X1 reg2_reg_1_ ( .D(n116), .CK(clk), .RN(n237), .Q(reg2[1]), .QN(n209)
         );
  DFFR_X1 reg2_reg_0_ ( .D(n115), .CK(clk), .RN(n237), .Q(reg2[0]), .QN(n205)
         );
  DFFR_X1 reg1_reg_7_ ( .D(n114), .CK(clk), .RN(n237), .Q(reg1[7]), .QN(n136)
         );
  DFFR_X1 reg1_reg_1_ ( .D(n112), .CK(clk), .RN(n237), .Q(reg1[1]), .QN(n217)
         );
  DFFR_X1 out_reg_reg_1_ ( .D(n111), .CK(clk), .RN(n237), .QN(n165) );
  DFFR_X1 reg1_reg_2_ ( .D(n110), .CK(clk), .RN(n236), .Q(reg1[2]), .QN(n196)
         );
  DFFR_X1 out_reg_reg_2_ ( .D(n109), .CK(clk), .RN(n236), .QN(n167) );
  DFFR_X1 out_reg_reg_3_ ( .D(n107), .CK(clk), .RN(n236), .QN(n169) );
  DFFR_X1 reg1_reg_4_ ( .D(n106), .CK(clk), .RN(n236), .Q(reg1[4]), .QN(n201)
         );
  DFFR_X1 out_reg_reg_4_ ( .D(n105), .CK(clk), .RN(n236), .QN(n171) );
  DFFR_X1 reg1_reg_5_ ( .D(n104), .CK(clk), .RN(n236), .Q(reg1[5]), .QN(n198)
         );
  DFFR_X1 out_reg_reg_5_ ( .D(n103), .CK(clk), .RN(n236), .QN(n173) );
  DFFR_X1 reg1_reg_6_ ( .D(n102), .CK(clk), .RN(n236), .Q(reg1[6]), .QN(n190)
         );
  DFFR_X1 out_reg_reg_6_ ( .D(n101), .CK(clk), .RN(n236), .QN(n175) );
  DFFR_X1 out_reg_reg_7_ ( .D(n100), .CK(clk), .RN(n236), .QN(n177) );
  DFFR_X1 out_reg_reg_0_ ( .D(n99), .CK(clk), .RN(n236), .QN(n163) );
  DFFR_X1 reg1_reg_0_ ( .D(n113), .CK(clk), .RN(n237), .Q(reg1[0]), .QN(n214)
         );
  DFFR_X1 reg1_reg_3_ ( .D(n108), .CK(clk), .RN(n236), .Q(reg1[3]), .QN(n203)
         );
  BUF_X1 U132 ( .A(n221), .Z(n149) );
  INV_X1 U133 ( .A(n303), .ZN(n132) );
  NAND2_X1 U134 ( .A1(n271), .A2(n229), .ZN(n133) );
  AND2_X2 U135 ( .A1(n184), .A2(n159), .ZN(n229) );
  CLKBUF_X1 U136 ( .A(n265), .Z(n134) );
  CLKBUF_X1 U137 ( .A(n181), .Z(n148) );
  AND2_X1 U138 ( .A1(n247), .A2(n213), .ZN(n137) );
  AND4_X2 U139 ( .A1(current_state[2]), .A2(n252), .A3(n161), .A4(n156), .ZN(
        n139) );
  INV_X1 U140 ( .A(n139), .ZN(n260) );
  NAND3_X1 U141 ( .A1(n260), .A2(n298), .A3(n242), .ZN(n140) );
  INV_X1 U142 ( .A(n252), .ZN(n141) );
  AND2_X2 U143 ( .A1(n142), .A2(n213), .ZN(n161) );
  AND2_X1 U144 ( .A1(n227), .A2(n231), .ZN(n142) );
  AOI211_X1 U145 ( .C1(current_state[6]), .C2(current_state[7]), .A(n230), .B(
        n240), .ZN(n143) );
  BUF_X2 U146 ( .A(n313), .Z(n144) );
  NAND2_X2 U147 ( .A1(n313), .A2(current_state[6]), .ZN(n315) );
  INV_X1 U148 ( .A(n259), .ZN(n145) );
  NAND2_X1 U149 ( .A1(n313), .A2(n216), .ZN(n146) );
  AND2_X2 U150 ( .A1(n143), .A2(n137), .ZN(n313) );
  NAND2_X1 U151 ( .A1(n313), .A2(n216), .ZN(n314) );
  CLKBUF_X1 U152 ( .A(n133), .Z(n147) );
  BUF_X1 U153 ( .A(reg2[1]), .Z(n152) );
  NAND2_X1 U154 ( .A1(n228), .A2(n226), .ZN(n293) );
  OAI221_X1 U155 ( .B1(n275), .B2(n293), .C1(n214), .C2(n147), .A(n274), .ZN(
        n112) );
  AND2_X1 U156 ( .A1(n228), .A2(n226), .ZN(n150) );
  CLKBUF_X1 U157 ( .A(n295), .Z(n162) );
  NAND3_X1 U158 ( .A1(n260), .A2(n298), .A3(n242), .ZN(n151) );
  CLKBUF_X1 U159 ( .A(reg2[3]), .Z(n153) );
  INV_X1 U160 ( .A(n272), .ZN(n154) );
  AND2_X2 U161 ( .A1(n184), .A2(n195), .ZN(n155) );
  AND2_X1 U162 ( .A1(n194), .A2(n195), .ZN(n183) );
  INV_X1 U163 ( .A(n195), .ZN(n156) );
  NAND2_X1 U164 ( .A1(n271), .A2(n229), .ZN(n157) );
  CLKBUF_X1 U165 ( .A(n206), .Z(n158) );
  NAND2_X1 U166 ( .A1(n271), .A2(n229), .ZN(n291) );
  AND2_X2 U167 ( .A1(n161), .A2(n247), .ZN(n159) );
  AND2_X1 U168 ( .A1(n270), .A2(n269), .ZN(n160) );
  OR2_X1 U169 ( .A1(n149), .A2(n225), .ZN(n270) );
  BUF_X1 U170 ( .A(rst_n), .Z(n236) );
  BUF_X1 U171 ( .A(rst_n), .Z(n237) );
  BUF_X1 U172 ( .A(rst_n), .Z(n238) );
  INV_X1 U173 ( .A(n163), .ZN(data_out[0]) );
  INV_X1 U174 ( .A(n165), .ZN(data_out[1]) );
  INV_X1 U175 ( .A(n167), .ZN(data_out[2]) );
  INV_X1 U176 ( .A(n169), .ZN(data_out[3]) );
  INV_X1 U177 ( .A(n171), .ZN(data_out[4]) );
  INV_X1 U178 ( .A(n173), .ZN(data_out[5]) );
  INV_X1 U179 ( .A(n175), .ZN(data_out[6]) );
  INV_X1 U180 ( .A(n177), .ZN(data_out[7]) );
  INV_X1 U181 ( .A(n291), .ZN(n282) );
  INV_X1 U182 ( .A(n204), .ZN(n179) );
  BUF_X1 U183 ( .A(current_state[4]), .Z(n204) );
  INV_X1 U184 ( .A(n304), .ZN(n180) );
  INV_X1 U185 ( .A(n203), .ZN(n181) );
  INV_X1 U186 ( .A(n300), .ZN(n182) );
  AND2_X1 U187 ( .A1(n273), .A2(n160), .ZN(n184) );
  NAND2_X1 U188 ( .A1(n194), .A2(n185), .ZN(n272) );
  AND2_X1 U189 ( .A1(n204), .A2(n159), .ZN(n185) );
  INV_X1 U190 ( .A(n186), .ZN(n187) );
  INV_X1 U191 ( .A(n188), .ZN(n189) );
  INV_X1 U192 ( .A(n190), .ZN(n191) );
  INV_X1 U193 ( .A(n192), .ZN(n193) );
  AND2_X1 U194 ( .A1(n273), .A2(n160), .ZN(n194) );
  INV_X1 U195 ( .A(current_state[5]), .ZN(n262) );
  INV_X1 U196 ( .A(n222), .ZN(n195) );
  INV_X1 U197 ( .A(n196), .ZN(n197) );
  INV_X1 U198 ( .A(n198), .ZN(n199) );
  INV_X1 U199 ( .A(current_state[7]), .ZN(n200) );
  INV_X1 U200 ( .A(n201), .ZN(n202) );
  INV_X1 U201 ( .A(n205), .ZN(n206) );
  INV_X1 U202 ( .A(n207), .ZN(n208) );
  INV_X1 U203 ( .A(n209), .ZN(n210) );
  INV_X1 U204 ( .A(n211), .ZN(n212) );
  INV_X1 U205 ( .A(n214), .ZN(n215) );
  INV_X1 U206 ( .A(current_state[6]), .ZN(n216) );
  INV_X1 U207 ( .A(n217), .ZN(n218) );
  OR2_X1 U208 ( .A1(n293), .A2(n292), .ZN(n223) );
  OR2_X1 U209 ( .A1(n312), .A2(n291), .ZN(n224) );
  NAND3_X1 U210 ( .A1(n223), .A2(n224), .A3(n290), .ZN(n114) );
  INV_X1 U211 ( .A(n225), .ZN(n226) );
  AOI22_X1 U212 ( .A1(n282), .A2(n202), .B1(n162), .B2(n199), .ZN(n283) );
  AND2_X1 U213 ( .A1(n194), .A2(n159), .ZN(n228) );
  AOI21_X1 U214 ( .B1(n263), .B2(n262), .A(n261), .ZN(n267) );
  INV_X1 U215 ( .A(n268), .ZN(n273) );
  AOI22_X1 U216 ( .A1(data_in[5]), .A2(n150), .B1(N168), .B2(n155), .ZN(n285)
         );
  NOR2_X1 U217 ( .A1(current_state[1]), .A2(current_state[4]), .ZN(n263) );
  NOR3_X1 U218 ( .A1(n265), .A2(n264), .A3(current_state[1]), .ZN(n266) );
  AND2_X1 U219 ( .A1(n227), .A2(n231), .ZN(n230) );
  OR2_X1 U220 ( .A1(n293), .A2(n279), .ZN(n232) );
  OR2_X1 U221 ( .A1(n304), .A2(n133), .ZN(n233) );
  NAND3_X1 U222 ( .A1(n232), .A2(n233), .A3(n278), .ZN(n108) );
  OR2_X1 U223 ( .A1(n293), .A2(n281), .ZN(n234) );
  OR2_X1 U224 ( .A1(n306), .A2(n291), .ZN(n235) );
  NAND3_X1 U225 ( .A1(n234), .A2(n235), .A3(n280), .ZN(n106) );
  NAND2_X1 U226 ( .A1(N176), .A2(n154), .ZN(n284) );
  OAI21_X1 U227 ( .B1(n267), .B2(n266), .A(n161), .ZN(n268) );
  NAND3_X1 U228 ( .A1(n149), .A2(n219), .A3(n225), .ZN(n240) );
  INV_X1 U229 ( .A(n240), .ZN(n252) );
  INV_X1 U230 ( .A(current_state[2]), .ZN(n251) );
  NAND2_X1 U231 ( .A1(n222), .A2(n220), .ZN(n261) );
  INV_X1 U232 ( .A(n261), .ZN(n247) );
  NAND3_X1 U233 ( .A1(n247), .A2(n213), .A3(n143), .ZN(n298) );
  NAND4_X1 U234 ( .A1(current_state[0]), .A2(n252), .A3(n230), .A4(n247), .ZN(
        n244) );
  INV_X1 U235 ( .A(n244), .ZN(n259) );
  NAND2_X1 U236 ( .A1(current_state[3]), .A2(n220), .ZN(n265) );
  NAND2_X1 U237 ( .A1(n221), .A2(n225), .ZN(n245) );
  NAND2_X1 U238 ( .A1(current_state[5]), .A2(n245), .ZN(n269) );
  NAND3_X1 U239 ( .A1(n161), .A2(n269), .A3(n270), .ZN(n239) );
  AOI221_X1 U240 ( .B1(n252), .B2(n134), .C1(n261), .C2(n141), .A(n239), .ZN(
        n241) );
  OAI22_X1 U241 ( .A1(start), .A2(n244), .B1(n259), .B2(n241), .ZN(n242) );
  NAND3_X1 U242 ( .A1(n242), .A2(n298), .A3(n260), .ZN(n256) );
  INV_X1 U243 ( .A(start), .ZN(n243) );
  OAI22_X1 U244 ( .A1(n256), .A2(n225), .B1(n145), .B2(n243), .ZN(n130) );
  INV_X1 U245 ( .A(n245), .ZN(n271) );
  NAND3_X1 U246 ( .A1(n159), .A2(current_state[5]), .A3(n271), .ZN(n246) );
  OAI21_X1 U247 ( .B1(n151), .B2(n216), .A(n246), .ZN(n126) );
  NAND3_X1 U248 ( .A1(n247), .A2(n252), .A3(n213), .ZN(n255) );
  INV_X1 U249 ( .A(n255), .ZN(n248) );
  NAND3_X1 U250 ( .A1(n248), .A2(current_state[7]), .A3(n216), .ZN(n257) );
  OAI21_X1 U251 ( .B1(n213), .B2(n151), .A(n257), .ZN(n131) );
  NAND2_X1 U252 ( .A1(n221), .A2(n219), .ZN(n264) );
  INV_X1 U253 ( .A(n264), .ZN(n249) );
  NAND3_X1 U254 ( .A1(n159), .A2(n226), .A3(n249), .ZN(n250) );
  OAI21_X1 U255 ( .B1(n151), .B2(n251), .A(n250), .ZN(n129) );
  OAI21_X1 U256 ( .B1(n140), .B2(n156), .A(n260), .ZN(n128) );
  NAND4_X1 U257 ( .A1(n195), .A2(n161), .A3(n252), .A4(n251), .ZN(n253) );
  OAI21_X1 U258 ( .B1(n140), .B2(n179), .A(n253), .ZN(n127) );
  NAND3_X1 U259 ( .A1(n159), .A2(n204), .A3(n225), .ZN(n254) );
  OAI21_X1 U260 ( .B1(n140), .B2(n219), .A(n254), .ZN(n124) );
  OAI22_X1 U261 ( .A1(n256), .A2(n200), .B1(n216), .B2(n255), .ZN(n125) );
  OAI21_X1 U262 ( .B1(n258), .B2(n259), .A(n257), .ZN(n123) );
  MUX2_X1 U263 ( .A(n158), .B(data_in[0]), .S(n139), .Z(n115) );
  MUX2_X1 U264 ( .A(reg2[7]), .B(data_in[7]), .S(n139), .Z(n122) );
  MUX2_X1 U265 ( .A(n187), .B(data_in[6]), .S(n139), .Z(n121) );
  MUX2_X1 U266 ( .A(n189), .B(data_in[5]), .S(n139), .Z(n120) );
  MUX2_X1 U267 ( .A(n193), .B(data_in[4]), .S(n139), .Z(n119) );
  MUX2_X1 U268 ( .A(n153), .B(data_in[3]), .S(n139), .Z(n118) );
  MUX2_X1 U269 ( .A(n132), .B(data_in[2]), .S(n139), .Z(n117) );
  MUX2_X1 U270 ( .A(n152), .B(data_in[1]), .S(n139), .Z(n116) );
  INV_X1 U271 ( .A(data_in[1]), .ZN(n275) );
  INV_X1 U272 ( .A(reg1[0]), .ZN(n300) );
  INV_X1 U273 ( .A(n272), .ZN(n294) );
  NAND2_X1 U274 ( .A1(n273), .A2(n160), .ZN(n295) );
  AOI222_X1 U275 ( .A1(N172), .A2(n294), .B1(N164), .B2(n183), .C1(reg1[1]), 
        .C2(n295), .ZN(n274) );
  INV_X1 U276 ( .A(data_in[2]), .ZN(n277) );
  INV_X1 U277 ( .A(n218), .ZN(n302) );
  AOI222_X1 U278 ( .A1(N173), .A2(n294), .B1(N165), .B2(n183), .C1(n180), .C2(
        n295), .ZN(n276) );
  OAI221_X1 U279 ( .B1(n293), .B2(n277), .C1(n302), .C2(n147), .A(n276), .ZN(
        n110) );
  INV_X1 U280 ( .A(data_in[3]), .ZN(n279) );
  INV_X1 U281 ( .A(reg1[2]), .ZN(n304) );
  AOI222_X1 U282 ( .A1(n154), .A2(N174), .B1(N166), .B2(n155), .C1(n148), .C2(
        n295), .ZN(n278) );
  INV_X1 U283 ( .A(data_in[4]), .ZN(n281) );
  INV_X1 U284 ( .A(n148), .ZN(n306) );
  AOI222_X1 U285 ( .A1(N175), .A2(n154), .B1(N167), .B2(n155), .C1(n202), .C2(
        n295), .ZN(n280) );
  NAND3_X1 U286 ( .A1(n283), .A2(n284), .A3(n285), .ZN(n104) );
  INV_X1 U287 ( .A(data_in[6]), .ZN(n289) );
  INV_X1 U288 ( .A(n157), .ZN(n286) );
  AOI22_X1 U289 ( .A1(n191), .A2(n162), .B1(n286), .B2(n199), .ZN(n288) );
  AOI22_X1 U290 ( .A1(N169), .A2(n155), .B1(N177), .B2(n154), .ZN(n287) );
  OAI211_X1 U291 ( .C1(n293), .C2(n289), .A(n288), .B(n287), .ZN(n102) );
  INV_X1 U292 ( .A(data_in[7]), .ZN(n292) );
  INV_X1 U293 ( .A(n191), .ZN(n312) );
  AOI222_X1 U294 ( .A1(N178), .A2(n154), .B1(N170), .B2(n155), .C1(reg1[7]), 
        .C2(n295), .ZN(n290) );
  AOI22_X1 U295 ( .A1(data_in[0]), .A2(n150), .B1(N171), .B2(n154), .ZN(n297)
         );
  AOI22_X1 U296 ( .A1(N163), .A2(n155), .B1(n182), .B2(n162), .ZN(n296) );
  NAND2_X1 U297 ( .A1(n297), .A2(n296), .ZN(n113) );
  INV_X1 U298 ( .A(n158), .ZN(n299) );
  OAI222_X1 U299 ( .A1(n315), .A2(n300), .B1(n314), .B2(n299), .C1(n313), .C2(
        n163), .ZN(n99) );
  INV_X1 U300 ( .A(n152), .ZN(n301) );
  OAI222_X1 U301 ( .A1(n315), .A2(n302), .B1(n314), .B2(n301), .C1(n144), .C2(
        n165), .ZN(n111) );
  INV_X1 U302 ( .A(reg2[2]), .ZN(n303) );
  OAI222_X1 U303 ( .A1(n315), .A2(n304), .B1(n314), .B2(n303), .C1(n144), .C2(
        n167), .ZN(n109) );
  INV_X1 U304 ( .A(n153), .ZN(n305) );
  OAI222_X1 U305 ( .A1(n315), .A2(n306), .B1(n314), .B2(n305), .C1(n144), .C2(
        n169), .ZN(n107) );
  INV_X1 U306 ( .A(n202), .ZN(n308) );
  INV_X1 U307 ( .A(n193), .ZN(n307) );
  OAI222_X1 U308 ( .A1(n315), .A2(n308), .B1(n146), .B2(n307), .C1(n144), .C2(
        n171), .ZN(n105) );
  INV_X1 U309 ( .A(n199), .ZN(n310) );
  INV_X1 U310 ( .A(n189), .ZN(n309) );
  OAI222_X1 U311 ( .A1(n315), .A2(n310), .B1(n146), .B2(n309), .C1(n144), .C2(
        n173), .ZN(n103) );
  INV_X1 U312 ( .A(n187), .ZN(n311) );
  OAI222_X1 U313 ( .A1(n315), .A2(n312), .B1(n146), .B2(n311), .C1(n144), .C2(
        n175), .ZN(n101) );
  OAI222_X1 U314 ( .A1(n315), .A2(n136), .B1(n146), .B2(n135), .C1(n144), .C2(
        n177), .ZN(n100) );
  INV_X1 sub_66_U88 ( .A(sub_66_n7), .ZN(sub_66_n68) );
  OAI21_X1 sub_66_U87 ( .B1(sub_66_n11), .B2(sub_66_n68), .A(sub_66_n64), .ZN(
        sub_66_n65) );
  XNOR2_X1 sub_66_U86 ( .A(sub_66_n65), .B(sub_66_n66), .ZN(N174) );
  NAND3_X1 sub_66_U85 ( .A1(sub_66_n54), .A2(sub_66_n55), .A3(sub_66_n56), 
        .ZN(sub_66_n28) );
  NAND3_X1 sub_66_U84 ( .A1(sub_66_n47), .A2(sub_66_n48), .A3(sub_66_n49), 
        .ZN(sub_66_n29) );
  INV_X1 sub_66_U83 ( .A(sub_66_n39), .ZN(sub_66_n44) );
  XNOR2_X1 sub_66_U82 ( .A(sub_66_n40), .B(sub_66_n41), .ZN(N176) );
  INV_X1 sub_66_U81 ( .A(sub_66_n38), .ZN(sub_66_n35) );
  INV_X1 sub_66_U80 ( .A(sub_66_n21), .ZN(sub_66_n34) );
  XNOR2_X1 sub_66_U79 ( .A(sub_66_n30), .B(sub_66_n31), .ZN(N177) );
  INV_X1 sub_66_U78 ( .A(sub_66_n26), .ZN(sub_66_n25) );
  INV_X1 sub_66_U77 ( .A(sub_66_n24), .ZN(sub_66_n23) );
  XNOR2_X1 sub_66_U76 ( .A(sub_66_n18), .B(sub_66_n14), .ZN(N178) );
  NAND2_X1 sub_66_U75 ( .A1(n202), .A2(sub_66_n46), .ZN(sub_66_n36) );
  INV_X1 sub_66_U74 ( .A(n202), .ZN(sub_66_n45) );
  INV_X1 sub_66_U73 ( .A(reg1[1]), .ZN(sub_66_n57) );
  NAND2_X1 sub_66_U72 ( .A1(reg1[1]), .A2(sub_66_n60), .ZN(sub_66_n58) );
  NAND2_X1 sub_66_U71 ( .A1(reg1[1]), .A2(sub_66_n60), .ZN(sub_66_n73) );
  NAND2_X1 sub_66_U70 ( .A1(n199), .A2(sub_66_n43), .ZN(sub_66_n37) );
  INV_X1 sub_66_U69 ( .A(n199), .ZN(sub_66_n42) );
  NAND2_X1 sub_66_U68 ( .A1(n191), .A2(sub_66_n32), .ZN(sub_66_n24) );
  INV_X1 sub_66_U67 ( .A(n191), .ZN(sub_66_n33) );
  NAND2_X1 sub_66_U66 ( .A1(reg1[0]), .A2(sub_66_n3), .ZN(sub_66_n59) );
  INV_X1 sub_66_U65 ( .A(reg1[0]), .ZN(sub_66_n78) );
  INV_X1 sub_66_U64 ( .A(n210), .ZN(sub_66_n60) );
  NAND2_X1 sub_66_U63 ( .A1(n210), .A2(sub_66_n57), .ZN(sub_66_n56) );
  INV_X1 sub_66_U62 ( .A(n181), .ZN(sub_66_n67) );
  NOR2_X1 sub_66_U61 ( .A1(sub_66_n53), .A2(n181), .ZN(sub_66_n50) );
  NAND2_X1 sub_66_U60 ( .A1(sub_66_n58), .A2(sub_66_n59), .ZN(sub_66_n55) );
  NAND2_X1 sub_66_U59 ( .A1(sub_66_n76), .A2(sub_66_n8), .ZN(sub_66_n74) );
  NAND2_X1 sub_66_U58 ( .A1(sub_66_n8), .A2(sub_66_n49), .ZN(N171) );
  NAND2_X1 sub_66_U57 ( .A1(n208), .A2(sub_66_n71), .ZN(sub_66_n62) );
  INV_X1 sub_66_U56 ( .A(n208), .ZN(sub_66_n52) );
  INV_X1 sub_66_U55 ( .A(n212), .ZN(sub_66_n53) );
  NAND2_X1 sub_66_U54 ( .A1(n206), .A2(sub_66_n78), .ZN(sub_66_n49) );
  INV_X1 sub_66_U53 ( .A(n206), .ZN(sub_66_n77) );
  NAND2_X1 sub_66_U52 ( .A1(sub_66_n10), .A2(sub_66_n52), .ZN(sub_66_n64) );
  INV_X1 sub_66_U51 ( .A(n197), .ZN(sub_66_n71) );
  NAND2_X1 sub_66_U50 ( .A1(n193), .A2(sub_66_n45), .ZN(sub_66_n39) );
  INV_X1 sub_66_U49 ( .A(n193), .ZN(sub_66_n46) );
  NAND2_X1 sub_66_U48 ( .A1(n189), .A2(sub_66_n42), .ZN(sub_66_n38) );
  INV_X1 sub_66_U47 ( .A(n189), .ZN(sub_66_n43) );
  NAND2_X1 sub_66_U46 ( .A1(n187), .A2(sub_66_n33), .ZN(sub_66_n22) );
  INV_X1 sub_66_U45 ( .A(n187), .ZN(sub_66_n32) );
  NOR2_X1 sub_66_U44 ( .A1(sub_66_n50), .A2(sub_66_n51), .ZN(sub_66_n47) );
  OAI21_X1 sub_66_U43 ( .B1(sub_66_n12), .B2(sub_66_n26), .A(sub_66_n34), .ZN(
        sub_66_n30) );
  AND2_X1 sub_66_U42 ( .A1(sub_66_n10), .A2(sub_66_n52), .ZN(sub_66_n17) );
  XNOR2_X1 sub_66_U41 ( .A(sub_66_n74), .B(sub_66_n75), .ZN(N172) );
  NAND2_X1 sub_66_U40 ( .A1(sub_66_n48), .A2(sub_66_n74), .ZN(sub_66_n72) );
  OAI21_X1 sub_66_U39 ( .B1(sub_66_n16), .B2(sub_66_n19), .A(sub_66_n20), .ZN(
        sub_66_n18) );
  OAI21_X1 sub_66_U38 ( .B1(sub_66_n44), .B2(sub_66_n1), .A(sub_66_n36), .ZN(
        sub_66_n40) );
  NAND2_X1 sub_66_U37 ( .A1(sub_66_n72), .A2(sub_66_n73), .ZN(sub_66_n69) );
  XNOR2_X1 sub_66_U36 ( .A(sub_66_n69), .B(sub_66_n70), .ZN(N173) );
  NAND2_X1 sub_66_U35 ( .A1(sub_66_n64), .A2(sub_66_n7), .ZN(sub_66_n70) );
  AND2_X1 sub_66_U34 ( .A1(sub_66_n61), .A2(sub_66_n62), .ZN(sub_66_n54) );
  XOR2_X1 sub_66_U32 ( .A(reg2[7]), .B(reg1[7]), .Z(sub_66_n14) );
  NAND2_X1 sub_66_U31 ( .A1(sub_66_n48), .A2(sub_66_n73), .ZN(sub_66_n75) );
  OAI21_X1 sub_66_U30 ( .B1(sub_66_n17), .B2(sub_66_n9), .A(sub_66_n61), .ZN(
        sub_66_n27) );
  NAND2_X1 sub_66_U29 ( .A1(sub_66_n4), .A2(sub_66_n63), .ZN(sub_66_n66) );
  NAND2_X1 sub_66_U28 ( .A1(sub_66_n37), .A2(sub_66_n38), .ZN(sub_66_n41) );
  NAND2_X1 sub_66_U27 ( .A1(sub_66_n25), .A2(sub_66_n22), .ZN(sub_66_n19) );
  NAND2_X1 sub_66_U26 ( .A1(sub_66_n38), .A2(sub_66_n39), .ZN(sub_66_n26) );
  AOI21_X1 sub_66_U25 ( .B1(sub_66_n21), .B2(sub_66_n22), .A(sub_66_n23), .ZN(
        sub_66_n20) );
  OAI21_X1 sub_66_U24 ( .B1(sub_66_n35), .B2(sub_66_n36), .A(sub_66_n37), .ZN(
        sub_66_n21) );
  NAND2_X1 sub_66_U23 ( .A1(sub_66_n22), .A2(sub_66_n24), .ZN(sub_66_n31) );
  NAND2_X1 sub_66_U22 ( .A1(sub_66_n36), .A2(sub_66_n39), .ZN(sub_66_n13) );
  XOR2_X1 sub_66_U21 ( .A(sub_66_n1), .B(sub_66_n13), .Z(N175) );
  AND3_X1 sub_66_U20 ( .A1(sub_66_n27), .A2(sub_66_n28), .A3(sub_66_n29), .ZN(
        sub_66_n16) );
  AND2_X1 sub_66_U19 ( .A1(n181), .A2(sub_66_n53), .ZN(sub_66_n9) );
  NAND2_X1 sub_66_U18 ( .A1(sub_66_n77), .A2(reg1[0]), .ZN(sub_66_n8) );
  AND2_X1 sub_66_U17 ( .A1(sub_66_n71), .A2(n208), .ZN(sub_66_n51) );
  NAND2_X1 sub_66_U16 ( .A1(sub_66_n2), .A2(sub_66_n5), .ZN(sub_66_n7) );
  NAND2_X1 sub_66_U15 ( .A1(sub_66_n67), .A2(n212), .ZN(sub_66_n61) );
  INV_X1 sub_66_U14 ( .A(sub_66_n73), .ZN(sub_66_n6) );
  AOI21_X1 sub_66_U13 ( .B1(sub_66_n74), .B2(sub_66_n48), .A(sub_66_n6), .ZN(
        sub_66_n11) );
  NAND2_X1 sub_66_U12 ( .A1(sub_66_n57), .A2(n210), .ZN(sub_66_n48) );
  INV_X1 sub_66_U11 ( .A(sub_66_n9), .ZN(sub_66_n63) );
  BUF_X1 sub_66_U10 ( .A(n197), .Z(sub_66_n10) );
  INV_X1 sub_66_U9 ( .A(sub_66_n10), .ZN(sub_66_n5) );
  CLKBUF_X1 sub_66_U8 ( .A(sub_66_n61), .Z(sub_66_n4) );
  INV_X1 sub_66_U7 ( .A(n206), .ZN(sub_66_n3) );
  INV_X1 sub_66_U6 ( .A(sub_66_n52), .ZN(sub_66_n2) );
  AND3_X1 sub_66_U5 ( .A1(sub_66_n28), .A2(sub_66_n27), .A3(sub_66_n29), .ZN(
        sub_66_n12) );
  AND3_X1 sub_66_U4 ( .A1(sub_66_n28), .A2(sub_66_n27), .A3(sub_66_n29), .ZN(
        sub_66_n1) );
  OAI21_X1 sub_66_U3 ( .B1(reg1[0]), .B2(sub_66_n77), .A(1'b1), .ZN(sub_66_n76) );
  INV_X1 add_63_U86 ( .A(add_63_n19), .ZN(add_63_n74) );
  INV_X1 add_63_U85 ( .A(add_63_n60), .ZN(add_63_n33) );
  INV_X1 add_63_U84 ( .A(add_63_n72), .ZN(add_63_n70) );
  INV_X1 add_63_U83 ( .A(add_63_n63), .ZN(add_63_n71) );
  OAI21_X1 add_63_U82 ( .B1(add_63_n70), .B2(add_63_n71), .A(add_63_n1), .ZN(
        add_63_n68) );
  XNOR2_X1 add_63_U81 ( .A(add_63_n68), .B(add_63_n69), .ZN(N166) );
  INV_X1 add_63_U80 ( .A(add_63_n67), .ZN(add_63_n66) );
  INV_X1 add_63_U79 ( .A(add_63_n44), .ZN(add_63_n54) );
  INV_X1 add_63_U78 ( .A(add_63_n45), .ZN(add_63_n51) );
  INV_X1 add_63_U77 ( .A(add_63_n35), .ZN(add_63_n43) );
  XNOR2_X1 add_63_U76 ( .A(add_63_n41), .B(add_63_n42), .ZN(N169) );
  INV_X1 add_63_U75 ( .A(add_63_n17), .ZN(add_63_n34) );
  INV_X1 add_63_U74 ( .A(add_63_n38), .ZN(add_63_n37) );
  INV_X1 add_63_U73 ( .A(add_63_n20), .ZN(add_63_n30) );
  NOR2_X1 add_63_U72 ( .A1(add_63_n33), .A2(add_63_n12), .ZN(add_63_n31) );
  NAND4_X1 add_63_U71 ( .A1(add_63_n8), .A2(add_63_n30), .A3(add_63_n31), .A4(
        add_63_n18), .ZN(add_63_n29) );
  XNOR2_X1 add_63_U70 ( .A(add_63_n25), .B(add_63_n26), .ZN(N170) );
  NAND2_X1 add_63_U69 ( .A1(add_63_n59), .A2(add_63_n58), .ZN(add_63_n48) );
  AOI21_X1 add_63_U68 ( .B1(add_63_n10), .B2(add_63_n23), .A(add_63_n54), .ZN(
        add_63_n49) );
  XNOR2_X1 add_63_U67 ( .A(add_63_n49), .B(add_63_n50), .ZN(N168) );
  OAI21_X1 add_63_U66 ( .B1(add_63_n24), .B2(add_63_n15), .A(add_63_n43), .ZN(
        add_63_n41) );
  NAND2_X1 add_63_U65 ( .A1(add_63_n7), .A2(add_63_n14), .ZN(add_63_n44) );
  INV_X1 add_63_U64 ( .A(reg1[4]), .ZN(add_63_n57) );
  NAND2_X1 add_63_U63 ( .A1(reg2[1]), .A2(n218), .ZN(add_63_n61) );
  XNOR2_X1 add_63_U62 ( .A(add_63_n48), .B(add_63_n55), .ZN(N167) );
  NAND2_X1 add_63_U61 ( .A1(reg2[5]), .A2(add_63_n4), .ZN(add_63_n45) );
  INV_X1 add_63_U60 ( .A(reg1[5]), .ZN(add_63_n53) );
  NAND2_X1 add_63_U59 ( .A1(reg2[6]), .A2(add_63_n2), .ZN(add_63_n38) );
  INV_X1 add_63_U58 ( .A(n215), .ZN(add_63_n78) );
  NAND2_X1 add_63_U57 ( .A1(reg2[0]), .A2(n215), .ZN(add_63_n62) );
  NAND2_X1 add_63_U56 ( .A1(add_63_n61), .A2(add_63_n62), .ZN(add_63_n32) );
  OAI21_X1 add_63_U55 ( .B1(add_63_n74), .B2(add_63_n33), .A(add_63_n16), .ZN(
        add_63_n72) );
  NAND2_X1 add_63_U54 ( .A1(add_63_n11), .A2(add_63_n16), .ZN(add_63_n75) );
  NAND2_X1 add_63_U53 ( .A1(reg2[3]), .A2(add_63_n3), .ZN(add_63_n65) );
  NAND2_X1 add_63_U52 ( .A1(add_63_n65), .A2(add_63_n64), .ZN(add_63_n69) );
  NAND2_X1 add_63_U51 ( .A1(reg2[2]), .A2(reg1[2]), .ZN(add_63_n67) );
  NOR2_X1 add_63_U50 ( .A1(add_63_n34), .A2(add_63_n20), .ZN(add_63_n39) );
  INV_X1 add_63_U49 ( .A(reg2[0]), .ZN(add_63_n77) );
  INV_X1 add_63_U48 ( .A(reg2[4]), .ZN(add_63_n56) );
  NAND2_X1 add_63_U47 ( .A1(add_63_n56), .A2(add_63_n57), .ZN(add_63_n47) );
  AND2_X1 add_63_U46 ( .A1(add_63_n59), .A2(add_63_n58), .ZN(add_63_n24) );
  INV_X1 add_63_U45 ( .A(reg2[5]), .ZN(add_63_n52) );
  AOI21_X1 add_63_U44 ( .B1(add_63_n39), .B2(add_63_n22), .A(add_63_n40), .ZN(
        add_63_n27) );
  OAI21_X1 add_63_U43 ( .B1(add_63_n21), .B2(add_63_n44), .A(add_63_n45), .ZN(
        add_63_n35) );
  AOI21_X1 add_63_U42 ( .B1(add_63_n35), .B2(add_63_n17), .A(add_63_n37), .ZN(
        add_63_n28) );
  NAND2_X1 add_63_U41 ( .A1(add_63_n52), .A2(add_63_n53), .ZN(add_63_n46) );
  XNOR2_X1 add_63_U40 ( .A(add_63_n5), .B(add_63_n73), .ZN(N165) );
  AND2_X1 add_63_U39 ( .A1(add_63_n66), .A2(add_63_n64), .ZN(add_63_n22) );
  AND2_X1 add_63_U38 ( .A1(add_63_n52), .A2(add_63_n53), .ZN(add_63_n21) );
  NAND2_X1 add_63_U37 ( .A1(add_63_n38), .A2(add_63_n17), .ZN(add_63_n42) );
  NAND3_X1 add_63_U36 ( .A1(add_63_n27), .A2(add_63_n29), .A3(add_63_n28), 
        .ZN(add_63_n25) );
  XNOR2_X1 add_63_U35 ( .A(reg2[7]), .B(reg1[7]), .ZN(add_63_n26) );
  NAND2_X1 add_63_U34 ( .A1(add_63_n77), .A2(add_63_n78), .ZN(add_63_n76) );
  OR2_X2 add_63_U33 ( .A1(reg2[3]), .A2(reg1[3]), .ZN(add_63_n64) );
  XNOR2_X1 add_63_U32 ( .A(add_63_n19), .B(add_63_n75), .ZN(N164) );
  OR2_X2 add_63_U31 ( .A1(reg2[2]), .A2(reg1[2]), .ZN(add_63_n63) );
  NAND2_X1 add_63_U30 ( .A1(add_63_n1), .A2(add_63_n63), .ZN(add_63_n73) );
  NOR2_X1 add_63_U29 ( .A1(add_63_n21), .A2(add_63_n51), .ZN(add_63_n50) );
  NAND2_X1 add_63_U28 ( .A1(add_63_n44), .A2(add_63_n23), .ZN(add_63_n55) );
  INV_X1 add_63_U27 ( .A(add_63_n22), .ZN(add_63_n58) );
  NAND2_X1 add_63_U26 ( .A1(add_63_n56), .A2(add_63_n57), .ZN(add_63_n23) );
  NAND2_X1 add_63_U25 ( .A1(add_63_n47), .A2(add_63_n46), .ZN(add_63_n20) );
  AND2_X1 add_63_U24 ( .A1(reg2[0]), .A2(n215), .ZN(add_63_n19) );
  CLKBUF_X1 add_63_U23 ( .A(add_63_n32), .Z(add_63_n18) );
  OR2_X1 add_63_U22 ( .A1(reg2[6]), .A2(reg1[6]), .ZN(add_63_n36) );
  OR2_X2 add_63_U21 ( .A1(reg2[6]), .A2(reg1[6]), .ZN(add_63_n17) );
  INV_X1 add_63_U20 ( .A(add_63_n30), .ZN(add_63_n15) );
  CLKBUF_X1 add_63_U19 ( .A(reg1[4]), .Z(add_63_n14) );
  AND4_X1 add_63_U18 ( .A1(add_63_n46), .A2(add_63_n47), .A3(add_63_n36), .A4(
        add_63_n6), .ZN(add_63_n40) );
  NAND4_X1 add_63_U17 ( .A1(add_63_n32), .A2(add_63_n64), .A3(add_63_n63), 
        .A4(add_63_n60), .ZN(add_63_n13) );
  AND2_X1 add_63_U16 ( .A1(add_63_n13), .A2(add_63_n65), .ZN(add_63_n59) );
  OR2_X2 add_63_U15 ( .A1(n218), .A2(reg2[1]), .ZN(add_63_n60) );
  INV_X1 add_63_U14 ( .A(add_63_n17), .ZN(add_63_n12) );
  CLKBUF_X1 add_63_U13 ( .A(add_63_n60), .Z(add_63_n11) );
  BUF_X1 add_63_U12 ( .A(add_63_n61), .Z(add_63_n16) );
  NAND2_X1 add_63_U11 ( .A1(add_63_n59), .A2(add_63_n58), .ZN(add_63_n10) );
  AND2_X1 add_63_U10 ( .A1(add_63_n62), .A2(add_63_n76), .ZN(N163) );
  AND2_X1 add_63_U9 ( .A1(add_63_n63), .A2(add_63_n64), .ZN(add_63_n8) );
  CLKBUF_X1 add_63_U8 ( .A(reg2[4]), .Z(add_63_n7) );
  AND2_X1 add_63_U7 ( .A1(reg2[3]), .A2(reg1[3]), .ZN(add_63_n6) );
  CLKBUF_X1 add_63_U6 ( .A(add_63_n72), .Z(add_63_n5) );
  CLKBUF_X1 add_63_U5 ( .A(reg1[5]), .Z(add_63_n4) );
  CLKBUF_X1 add_63_U4 ( .A(reg1[3]), .Z(add_63_n3) );
  CLKBUF_X1 add_63_U3 ( .A(reg1[6]), .Z(add_63_n2) );
  BUF_X1 add_63_U2 ( .A(add_63_n67), .Z(add_63_n1) );
endmodule

