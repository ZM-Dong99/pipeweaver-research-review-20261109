/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:07:48 2025
/////////////////////////////////////////////////////////////


module fsm_encode_ref ( clk, rst_n, start, data_in, data_out, done );
  input [7:0] data_in;
  output [7:0] data_out;
  input clk, rst_n, start;
  output done;
  wire   n244, N65, N66, N67, N68, N69, N70, N71, N72, N73, N74, N75, N76, N77,
         N78, N79, N80, n73, n74, n75, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n90, n91, n92, n93, n94, n95, n96, n97, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n132, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n146, n148, n150, n152, n154, n156, n158, n160, n162, n163, n164,
         n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197,
         n198, n199, n200, n201, n202, n203, n204, n205, n206, n207, n208,
         n209, n210, n211, n212, n213, n214, n215, n216, n217, n218, n219,
         n220, n221, n222, n223, n224, n225, n226, n227, n228, n229, n230,
         n231, n232, n233, n234, n235, n236, n237, n238, n239, n240, n241,
         n242, n243, sub_68_n76, sub_68_n75, sub_68_n74, sub_68_n73,
         sub_68_n72, sub_68_n71, sub_68_n70, sub_68_n69, sub_68_n68,
         sub_68_n67, sub_68_n66, sub_68_n65, sub_68_n64, sub_68_n63,
         sub_68_n62, sub_68_n61, sub_68_n60, sub_68_n59, sub_68_n58,
         sub_68_n57, sub_68_n56, sub_68_n55, sub_68_n54, sub_68_n53,
         sub_68_n52, sub_68_n51, sub_68_n50, sub_68_n49, sub_68_n48,
         sub_68_n47, sub_68_n46, sub_68_n45, sub_68_n44, sub_68_n43,
         sub_68_n42, sub_68_n41, sub_68_n40, sub_68_n39, sub_68_n38,
         sub_68_n37, sub_68_n36, sub_68_n35, sub_68_n34, sub_68_n33,
         sub_68_n32, sub_68_n31, sub_68_n30, sub_68_n29, sub_68_n28,
         sub_68_n27, sub_68_n26, sub_68_n25, sub_68_n24, sub_68_n23,
         sub_68_n22, sub_68_n21, sub_68_n20, sub_68_n19, sub_68_n18,
         sub_68_n17, sub_68_n16, sub_68_n15, sub_68_n14, sub_68_n13,
         sub_68_n12, sub_68_n11, sub_68_n10, sub_68_n9, sub_68_n8, sub_68_n7,
         sub_68_n6, sub_68_n5, sub_68_n4, sub_68_n3, sub_68_n2, sub_68_n1,
         add_65_n72, add_65_n71, add_65_n70, add_65_n69, add_65_n68,
         add_65_n67, add_65_n66, add_65_n65, add_65_n64, add_65_n63,
         add_65_n62, add_65_n61, add_65_n60, add_65_n59, add_65_n58,
         add_65_n57, add_65_n56, add_65_n55, add_65_n54, add_65_n53,
         add_65_n52, add_65_n51, add_65_n50, add_65_n49, add_65_n48,
         add_65_n47, add_65_n46, add_65_n45, add_65_n44, add_65_n43,
         add_65_n42, add_65_n41, add_65_n40, add_65_n39, add_65_n38,
         add_65_n37, add_65_n36, add_65_n35, add_65_n34, add_65_n33,
         add_65_n32, add_65_n31, add_65_n30, add_65_n29, add_65_n28,
         add_65_n27, add_65_n26, add_65_n25, add_65_n24, add_65_n23,
         add_65_n22, add_65_n21, add_65_n20, add_65_n19, add_65_n18,
         add_65_n16, add_65_n15, add_65_n14, add_65_n13, add_65_n12,
         add_65_n11, add_65_n10, add_65_n9, add_65_n8, add_65_n7, add_65_n6,
         add_65_n5, add_65_n4, add_65_n3, add_65_n2, add_65_n1;
  wire   [2:0] current_state;
  wire   [2:1] next_state;
  wire   [7:0] reg1;
  wire   [7:0] reg2;

  DFFR_X1 current_state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(n191), .Q(
        current_state[1]), .QN(n106) );
  DFFR_X1 current_state_reg_2_ ( .D(next_state[2]), .CK(clk), .RN(n191), .Q(
        current_state[2]), .QN(n102) );
  DFFR_X1 done_reg ( .D(n97), .CK(clk), .RN(n191), .Q(n244), .QN(n144) );
  DFFR_X1 reg2_reg_7_ ( .D(n96), .CK(clk), .RN(n190), .Q(reg2[7]), .QN(n101)
         );
  DFFR_X1 reg2_reg_4_ ( .D(n93), .CK(clk), .RN(n190), .Q(reg2[4]), .QN(n166)
         );
  DFFR_X1 reg2_reg_3_ ( .D(n92), .CK(clk), .RN(n190), .Q(reg2[3]), .QN(n168)
         );
  DFFR_X1 reg2_reg_2_ ( .D(n91), .CK(clk), .RN(n190), .Q(reg2[2]), .QN(n170)
         );
  DFFR_X1 reg2_reg_1_ ( .D(n90), .CK(clk), .RN(n190), .Q(reg2[1]), .QN(n178)
         );
  DFFR_X1 reg2_reg_0_ ( .D(n243), .CK(clk), .RN(n190), .Q(reg2[0]), .QN(n176)
         );
  DFFR_X1 reg1_reg_0_ ( .D(n87), .CK(clk), .RN(n190), .Q(reg1[0]), .QN(n182)
         );
  DFFR_X1 reg1_reg_1_ ( .D(n86), .CK(clk), .RN(n190), .Q(reg1[1]), .QN(n180)
         );
  DFFR_X1 out_reg_reg_1_ ( .D(n85), .CK(clk), .RN(n190), .QN(n148) );
  DFFR_X1 reg1_reg_2_ ( .D(n84), .CK(clk), .RN(n189), .Q(reg1[2]), .QN(n174)
         );
  DFFR_X1 out_reg_reg_2_ ( .D(n83), .CK(clk), .RN(n189), .QN(n150) );
  DFFR_X1 reg1_reg_3_ ( .D(n82), .CK(clk), .RN(n189), .Q(reg1[3]), .QN(n172)
         );
  DFFR_X1 out_reg_reg_3_ ( .D(n81), .CK(clk), .RN(n189), .QN(n152) );
  DFFR_X1 reg1_reg_4_ ( .D(n80), .CK(clk), .RN(n189), .Q(reg1[4]), .QN(n164)
         );
  DFFR_X1 out_reg_reg_4_ ( .D(n79), .CK(clk), .RN(n189), .QN(n154) );
  DFFR_X1 out_reg_reg_5_ ( .D(n77), .CK(clk), .RN(n189), .QN(n156) );
  DFFR_X1 out_reg_reg_6_ ( .D(n75), .CK(clk), .RN(n189), .QN(n158) );
  DFFR_X1 out_reg_reg_7_ ( .D(n74), .CK(clk), .RN(n189), .QN(n160) );
  DFFR_X1 out_reg_reg_0_ ( .D(n73), .CK(clk), .RN(n189), .QN(n146) );
  DFFR_X1 reg2_reg_6_ ( .D(n95), .CK(clk), .RN(n190), .Q(reg2[6]), .QN(n113)
         );
  DFFR_X1 reg2_reg_5_ ( .D(n94), .CK(clk), .RN(n190), .Q(reg2[5]), .QN(n122)
         );
  DFFR_X1 current_state_reg_0_ ( .D(n242), .CK(clk), .RN(n191), .Q(
        current_state[0]), .QN(n142) );
  DFFR_X1 reg1_reg_5_ ( .D(n78), .CK(clk), .RN(n189), .Q(reg1[5]), .QN(n132)
         );
  DFFR_X2 reg1_reg_6_ ( .D(n163), .CK(clk), .RN(n189), .Q(reg1[6]), .QN(n238)
         );
  DFFR_X1 reg1_reg_7_ ( .D(n120), .CK(clk), .RN(n190), .Q(reg1[7]), .QN(n240)
         );
  INV_X1 U101 ( .A(n102), .ZN(n99) );
  INV_X1 U102 ( .A(n196), .ZN(n100) );
  AND2_X1 U103 ( .A1(n214), .A2(n213), .ZN(n103) );
  AND2_X1 U104 ( .A1(n184), .A2(n185), .ZN(n104) );
  AND2_X1 U105 ( .A1(n139), .A2(n140), .ZN(n105) );
  INV_X1 U106 ( .A(n106), .ZN(n107) );
  OR2_X1 U107 ( .A1(current_state[1]), .A2(n142), .ZN(n108) );
  OR2_X1 U108 ( .A1(n107), .A2(n99), .ZN(n195) );
  AND2_X2 U109 ( .A1(n196), .A2(n142), .ZN(n109) );
  INV_X1 U110 ( .A(n180), .ZN(n110) );
  INV_X1 U111 ( .A(n238), .ZN(n111) );
  NAND3_X1 U112 ( .A1(n212), .A2(n211), .A3(n103), .ZN(n78) );
  CLKBUF_X1 U113 ( .A(n171), .Z(n112) );
  INV_X1 U114 ( .A(n113), .ZN(n114) );
  CLKBUF_X1 U115 ( .A(n179), .Z(n115) );
  INV_X1 U116 ( .A(n162), .ZN(n116) );
  NAND2_X1 U117 ( .A1(N76), .A2(n109), .ZN(n117) );
  NAND2_X1 U118 ( .A1(n222), .A2(n162), .ZN(n118) );
  NAND2_X1 U119 ( .A1(N68), .A2(n221), .ZN(n119) );
  AND3_X1 U120 ( .A1(n119), .A2(n118), .A3(n117), .ZN(n203) );
  NAND3_X1 U121 ( .A1(n136), .A2(n137), .A3(n138), .ZN(n120) );
  CLKBUF_X1 U122 ( .A(reg1[2]), .Z(n121) );
  INV_X1 U123 ( .A(n122), .ZN(n123) );
  OR2_X1 U124 ( .A1(n229), .A2(n219), .ZN(n124) );
  OR2_X1 U125 ( .A1(n223), .A2(n202), .ZN(n125) );
  NAND3_X1 U126 ( .A1(n201), .A2(n125), .A3(n124), .ZN(n84) );
  AND2_X1 U127 ( .A1(N75), .A2(n109), .ZN(n126) );
  AND2_X1 U128 ( .A1(n222), .A2(n121), .ZN(n127) );
  AND2_X1 U129 ( .A1(N67), .A2(n221), .ZN(n128) );
  NOR3_X1 U130 ( .A1(n128), .A2(n126), .A3(n127), .ZN(n201) );
  NAND2_X1 U131 ( .A1(n203), .A2(n104), .ZN(n82) );
  NAND2_X1 U132 ( .A1(n206), .A2(n105), .ZN(n80) );
  NAND2_X1 U133 ( .A1(N77), .A2(n109), .ZN(n129) );
  NAND2_X1 U134 ( .A1(n208), .A2(n165), .ZN(n130) );
  NAND2_X1 U135 ( .A1(N69), .A2(n221), .ZN(n131) );
  AND3_X1 U136 ( .A1(n131), .A2(n130), .A3(n129), .ZN(n206) );
  INV_X1 U137 ( .A(n132), .ZN(n133) );
  CLKBUF_X1 U138 ( .A(n183), .Z(n134) );
  CLKBUF_X1 U139 ( .A(n169), .Z(n135) );
  NAND2_X1 U140 ( .A1(N80), .A2(n109), .ZN(n136) );
  NAND2_X1 U141 ( .A1(N72), .A2(n221), .ZN(n137) );
  INV_X1 U142 ( .A(n220), .ZN(n138) );
  OR2_X1 U143 ( .A1(n116), .A2(n219), .ZN(n139) );
  OR2_X1 U144 ( .A1(n223), .A2(n207), .ZN(n140) );
  NAND2_X1 U145 ( .A1(n196), .A2(current_state[0]), .ZN(n219) );
  CLKBUF_X1 U146 ( .A(n177), .Z(n141) );
  NAND2_X1 U147 ( .A1(N70), .A2(n221), .ZN(n212) );
  INV_X1 U148 ( .A(n218), .ZN(n208) );
  INV_X1 U149 ( .A(n223), .ZN(n209) );
  INV_X1 U150 ( .A(n198), .ZN(n221) );
  INV_X1 U151 ( .A(n219), .ZN(n210) );
  OR2_X2 U152 ( .A1(n108), .A2(n99), .ZN(n223) );
  AND2_X2 U153 ( .A1(n99), .A2(n107), .ZN(n143) );
  BUF_X1 U154 ( .A(rst_n), .Z(n189) );
  BUF_X1 U155 ( .A(rst_n), .Z(n190) );
  BUF_X1 U156 ( .A(rst_n), .Z(n191) );
  INV_X1 U157 ( .A(n144), .ZN(done) );
  INV_X1 U158 ( .A(n146), .ZN(data_out[0]) );
  INV_X1 U159 ( .A(n148), .ZN(data_out[1]) );
  INV_X1 U160 ( .A(n150), .ZN(data_out[2]) );
  INV_X1 U161 ( .A(n152), .ZN(data_out[3]) );
  INV_X1 U162 ( .A(n154), .ZN(data_out[4]) );
  INV_X1 U163 ( .A(n156), .ZN(data_out[5]) );
  INV_X1 U164 ( .A(n158), .ZN(data_out[6]) );
  INV_X1 U165 ( .A(n160), .ZN(data_out[7]) );
  INV_X1 U166 ( .A(n172), .ZN(n162) );
  NAND3_X1 U167 ( .A1(n187), .A2(n186), .A3(n188), .ZN(n163) );
  INV_X1 U168 ( .A(n164), .ZN(n165) );
  INV_X1 U169 ( .A(n166), .ZN(n167) );
  AOI22_X1 U170 ( .A1(data_in[5]), .A2(n209), .B1(n208), .B2(n133), .ZN(n214)
         );
  INV_X1 U171 ( .A(n168), .ZN(n169) );
  INV_X1 U172 ( .A(n170), .ZN(n171) );
  NAND2_X1 U173 ( .A1(n210), .A2(n165), .ZN(n213) );
  INV_X1 U174 ( .A(n172), .ZN(n173) );
  INV_X1 U175 ( .A(n174), .ZN(n175) );
  INV_X1 U176 ( .A(n176), .ZN(n177) );
  INV_X1 U177 ( .A(n178), .ZN(n179) );
  INV_X1 U178 ( .A(n180), .ZN(n181) );
  INV_X1 U179 ( .A(n182), .ZN(n183) );
  NAND2_X1 U180 ( .A1(N78), .A2(n109), .ZN(n211) );
  OR2_X1 U181 ( .A1(n231), .A2(n219), .ZN(n184) );
  OR2_X1 U182 ( .A1(n223), .A2(n204), .ZN(n185) );
  NAND2_X1 U183 ( .A1(N71), .A2(n221), .ZN(n186) );
  NAND2_X1 U184 ( .A1(N79), .A2(n109), .ZN(n187) );
  INV_X1 U185 ( .A(n216), .ZN(n188) );
  OAI21_X1 U186 ( .B1(start), .B2(n195), .A(n142), .ZN(n192) );
  INV_X1 U187 ( .A(n192), .ZN(n242) );
  XOR2_X1 U188 ( .A(n107), .B(current_state[0]), .Z(next_state[1]) );
  NAND3_X1 U189 ( .A1(current_state[0]), .A2(n107), .A3(n102), .ZN(n198) );
  NAND2_X1 U190 ( .A1(current_state[2]), .A2(n106), .ZN(n197) );
  OAI211_X1 U191 ( .C1(current_state[0]), .C2(n102), .A(n198), .B(n100), .ZN(
        next_state[2]) );
  NAND2_X1 U192 ( .A1(current_state[0]), .A2(n143), .ZN(n239) );
  OAI21_X1 U193 ( .B1(current_state[0]), .B2(n195), .A(n244), .ZN(n193) );
  NAND2_X1 U194 ( .A1(n239), .A2(n193), .ZN(n97) );
  NAND3_X1 U195 ( .A1(n107), .A2(n102), .A3(n142), .ZN(n194) );
  INV_X1 U196 ( .A(n194), .ZN(n205) );
  MUX2_X1 U197 ( .A(n141), .B(data_in[0]), .S(n205), .Z(n243) );
  INV_X1 U198 ( .A(n134), .ZN(n227) );
  INV_X1 U199 ( .A(n197), .ZN(n196) );
  INV_X1 U200 ( .A(data_in[1]), .ZN(n200) );
  OAI21_X1 U201 ( .B1(current_state[2]), .B2(n142), .A(n197), .ZN(n218) );
  INV_X1 U202 ( .A(n218), .ZN(n222) );
  AOI222_X1 U203 ( .A1(N74), .A2(n109), .B1(n208), .B2(n181), .C1(N66), .C2(
        n221), .ZN(n199) );
  OAI221_X1 U204 ( .B1(n227), .B2(n219), .C1(n223), .C2(n200), .A(n199), .ZN(
        n86) );
  INV_X1 U205 ( .A(n181), .ZN(n229) );
  INV_X1 U206 ( .A(data_in[2]), .ZN(n202) );
  INV_X1 U207 ( .A(n121), .ZN(n231) );
  INV_X1 U208 ( .A(data_in[3]), .ZN(n204) );
  MUX2_X1 U209 ( .A(reg2[7]), .B(data_in[7]), .S(n205), .Z(n96) );
  MUX2_X1 U210 ( .A(n114), .B(data_in[6]), .S(n205), .Z(n95) );
  MUX2_X1 U211 ( .A(n123), .B(data_in[5]), .S(n205), .Z(n94) );
  MUX2_X1 U212 ( .A(n167), .B(data_in[4]), .S(n205), .Z(n93) );
  MUX2_X1 U213 ( .A(n135), .B(data_in[3]), .S(n205), .Z(n92) );
  MUX2_X1 U214 ( .A(n112), .B(data_in[2]), .S(n205), .Z(n91) );
  MUX2_X1 U215 ( .A(n115), .B(data_in[1]), .S(n205), .Z(n90) );
  INV_X1 U216 ( .A(data_in[4]), .ZN(n207) );
  INV_X1 U217 ( .A(n133), .ZN(n236) );
  INV_X1 U218 ( .A(data_in[6]), .ZN(n215) );
  OAI222_X1 U219 ( .A1(n236), .A2(n219), .B1(n238), .B2(n218), .C1(n223), .C2(
        n215), .ZN(n216) );
  INV_X1 U220 ( .A(data_in[7]), .ZN(n217) );
  OAI222_X1 U221 ( .A1(n238), .A2(n219), .B1(n240), .B2(n218), .C1(n223), .C2(
        n217), .ZN(n220) );
  AOI22_X1 U222 ( .A1(n222), .A2(n134), .B1(N65), .B2(n221), .ZN(n225) );
  AOI22_X1 U223 ( .A1(N73), .A2(n109), .B1(data_in[0]), .B2(n209), .ZN(n224)
         );
  NAND2_X1 U224 ( .A1(n224), .A2(n225), .ZN(n87) );
  NAND2_X1 U225 ( .A1(n143), .A2(n142), .ZN(n241) );
  INV_X1 U226 ( .A(n141), .ZN(n226) );
  OAI222_X1 U227 ( .A1(n241), .A2(n227), .B1(n239), .B2(n226), .C1(n143), .C2(
        n146), .ZN(n73) );
  INV_X1 U228 ( .A(n115), .ZN(n228) );
  OAI222_X1 U229 ( .A1(n241), .A2(n229), .B1(n239), .B2(n228), .C1(n143), .C2(
        n148), .ZN(n85) );
  INV_X1 U230 ( .A(n112), .ZN(n230) );
  OAI222_X1 U231 ( .A1(n241), .A2(n231), .B1(n239), .B2(n230), .C1(n143), .C2(
        n150), .ZN(n83) );
  INV_X1 U232 ( .A(n135), .ZN(n232) );
  OAI222_X1 U233 ( .A1(n241), .A2(n116), .B1(n239), .B2(n232), .C1(n143), .C2(
        n152), .ZN(n81) );
  INV_X1 U234 ( .A(n165), .ZN(n234) );
  INV_X1 U235 ( .A(n167), .ZN(n233) );
  OAI222_X1 U236 ( .A1(n241), .A2(n234), .B1(n239), .B2(n233), .C1(n143), .C2(
        n154), .ZN(n79) );
  INV_X1 U237 ( .A(n123), .ZN(n235) );
  OAI222_X1 U238 ( .A1(n241), .A2(n236), .B1(n239), .B2(n235), .C1(n143), .C2(
        n156), .ZN(n77) );
  INV_X1 U239 ( .A(n114), .ZN(n237) );
  OAI222_X1 U240 ( .A1(n241), .A2(n238), .B1(n239), .B2(n237), .C1(n143), .C2(
        n158), .ZN(n75) );
  OAI222_X1 U241 ( .A1(n241), .A2(n240), .B1(n239), .B2(n101), .C1(n143), .C2(
        n160), .ZN(n74) );
  INV_X1 sub_68_U86 ( .A(sub_68_n62), .ZN(sub_68_n68) );
  OAI21_X1 sub_68_U85 ( .B1(sub_68_n6), .B2(sub_68_n3), .A(sub_68_n64), .ZN(
        sub_68_n65) );
  XNOR2_X1 sub_68_U84 ( .A(sub_68_n65), .B(sub_68_n66), .ZN(N76) );
  NAND3_X1 sub_68_U83 ( .A1(sub_68_n54), .A2(sub_68_n55), .A3(sub_68_n47), 
        .ZN(sub_68_n27) );
  NAND3_X1 sub_68_U82 ( .A1(sub_68_n46), .A2(sub_68_n56), .A3(sub_68_n48), 
        .ZN(sub_68_n28) );
  INV_X1 sub_68_U81 ( .A(sub_68_n38), .ZN(sub_68_n43) );
  XNOR2_X1 sub_68_U80 ( .A(sub_68_n39), .B(sub_68_n40), .ZN(N78) );
  INV_X1 sub_68_U79 ( .A(sub_68_n37), .ZN(sub_68_n34) );
  INV_X1 sub_68_U78 ( .A(sub_68_n20), .ZN(sub_68_n33) );
  XNOR2_X1 sub_68_U77 ( .A(sub_68_n29), .B(sub_68_n30), .ZN(N79) );
  INV_X1 sub_68_U76 ( .A(sub_68_n25), .ZN(sub_68_n24) );
  INV_X1 sub_68_U75 ( .A(sub_68_n23), .ZN(sub_68_n22) );
  XNOR2_X1 sub_68_U74 ( .A(sub_68_n17), .B(sub_68_n12), .ZN(N80) );
  INV_X1 sub_68_U73 ( .A(reg1[0]), .ZN(sub_68_n76) );
  NAND2_X1 sub_68_U72 ( .A1(sub_68_n4), .A2(sub_68_n75), .ZN(sub_68_n59) );
  INV_X1 sub_68_U71 ( .A(reg1[3]), .ZN(sub_68_n67) );
  NOR2_X1 sub_68_U70 ( .A1(sub_68_n10), .A2(sub_68_n53), .ZN(sub_68_n50) );
  NAND2_X1 sub_68_U69 ( .A1(n110), .A2(sub_68_n60), .ZN(sub_68_n73) );
  NAND2_X1 sub_68_U68 ( .A1(n110), .A2(sub_68_n60), .ZN(sub_68_n58) );
  INV_X1 sub_68_U67 ( .A(n110), .ZN(sub_68_n57) );
  NAND2_X1 sub_68_U66 ( .A1(n179), .A2(sub_68_n57), .ZN(sub_68_n56) );
  INV_X1 sub_68_U65 ( .A(n179), .ZN(sub_68_n60) );
  NAND2_X1 sub_68_U64 ( .A1(n179), .A2(sub_68_n57), .ZN(sub_68_n47) );
  INV_X1 sub_68_U63 ( .A(n177), .ZN(sub_68_n75) );
  NAND2_X1 sub_68_U62 ( .A1(sub_68_n59), .A2(sub_68_n58), .ZN(sub_68_n55) );
  NAND2_X1 sub_68_U61 ( .A1(sub_68_n9), .A2(sub_68_n49), .ZN(N73) );
  INV_X1 sub_68_U60 ( .A(n175), .ZN(sub_68_n71) );
  OAI21_X1 sub_68_U59 ( .B1(sub_68_n8), .B2(sub_68_n25), .A(sub_68_n33), .ZN(
        sub_68_n29) );
  INV_X1 sub_68_U58 ( .A(n169), .ZN(sub_68_n53) );
  NAND2_X1 sub_68_U57 ( .A1(n171), .A2(sub_68_n71), .ZN(sub_68_n62) );
  INV_X1 sub_68_U56 ( .A(n171), .ZN(sub_68_n52) );
  OAI21_X1 sub_68_U55 ( .B1(sub_68_n13), .B2(sub_68_n43), .A(sub_68_n35), .ZN(
        sub_68_n39) );
  NAND2_X1 sub_68_U54 ( .A1(sub_68_n67), .A2(n169), .ZN(sub_68_n61) );
  INV_X1 sub_68_U53 ( .A(n165), .ZN(sub_68_n44) );
  NAND2_X1 sub_68_U52 ( .A1(n165), .A2(sub_68_n45), .ZN(sub_68_n35) );
  INV_X1 sub_68_U51 ( .A(n133), .ZN(sub_68_n41) );
  NAND2_X1 sub_68_U50 ( .A1(n133), .A2(sub_68_n42), .ZN(sub_68_n36) );
  AND2_X1 sub_68_U49 ( .A1(sub_68_n61), .A2(sub_68_n62), .ZN(sub_68_n54) );
  NAND2_X1 sub_68_U48 ( .A1(sub_68_n15), .A2(sub_68_n63), .ZN(sub_68_n66) );
  INV_X1 sub_68_U47 ( .A(n114), .ZN(sub_68_n31) );
  NAND2_X1 sub_68_U46 ( .A1(n114), .A2(sub_68_n32), .ZN(sub_68_n21) );
  INV_X1 sub_68_U45 ( .A(n111), .ZN(sub_68_n32) );
  NAND2_X1 sub_68_U44 ( .A1(n111), .A2(sub_68_n31), .ZN(sub_68_n23) );
  XNOR2_X1 sub_68_U43 ( .A(sub_68_n49), .B(sub_68_n74), .ZN(N74) );
  NAND2_X1 sub_68_U42 ( .A1(sub_68_n1), .A2(sub_68_n47), .ZN(sub_68_n72) );
  NAND2_X1 sub_68_U41 ( .A1(n123), .A2(sub_68_n41), .ZN(sub_68_n37) );
  INV_X1 sub_68_U40 ( .A(n123), .ZN(sub_68_n42) );
  NOR2_X1 sub_68_U39 ( .A1(sub_68_n50), .A2(sub_68_n51), .ZN(sub_68_n46) );
  NAND2_X1 sub_68_U38 ( .A1(sub_68_n64), .A2(sub_68_n11), .ZN(sub_68_n70) );
  OAI21_X1 sub_68_U37 ( .B1(sub_68_n8), .B2(sub_68_n18), .A(sub_68_n19), .ZN(
        sub_68_n17) );
  CLKBUF_X1 sub_68_U36 ( .A(sub_68_n61), .Z(sub_68_n15) );
  XOR2_X1 sub_68_U35 ( .A(reg2[7]), .B(reg1[7]), .Z(sub_68_n12) );
  NAND2_X1 sub_68_U34 ( .A1(sub_68_n21), .A2(sub_68_n23), .ZN(sub_68_n30) );
  NAND2_X1 sub_68_U33 ( .A1(n167), .A2(sub_68_n44), .ZN(sub_68_n38) );
  INV_X1 sub_68_U32 ( .A(n167), .ZN(sub_68_n45) );
  NAND2_X1 sub_68_U31 ( .A1(sub_68_n36), .A2(sub_68_n37), .ZN(sub_68_n40) );
  AOI21_X1 sub_68_U30 ( .B1(sub_68_n20), .B2(sub_68_n21), .A(sub_68_n22), .ZN(
        sub_68_n19) );
  OAI21_X1 sub_68_U29 ( .B1(sub_68_n34), .B2(sub_68_n35), .A(sub_68_n36), .ZN(
        sub_68_n20) );
  NAND2_X1 sub_68_U28 ( .A1(sub_68_n24), .A2(sub_68_n21), .ZN(sub_68_n18) );
  NAND2_X1 sub_68_U27 ( .A1(sub_68_n37), .A2(sub_68_n38), .ZN(sub_68_n25) );
  INV_X1 sub_68_U26 ( .A(sub_68_n16), .ZN(sub_68_n49) );
  NAND2_X1 sub_68_U25 ( .A1(sub_68_n56), .A2(sub_68_n73), .ZN(sub_68_n74) );
  INV_X1 sub_68_U24 ( .A(sub_68_n14), .ZN(sub_68_n64) );
  XNOR2_X1 sub_68_U23 ( .A(sub_68_n69), .B(sub_68_n70), .ZN(N75) );
  INV_X1 sub_68_U22 ( .A(sub_68_n16), .ZN(sub_68_n48) );
  NAND2_X1 sub_68_U21 ( .A1(sub_68_n72), .A2(sub_68_n73), .ZN(sub_68_n69) );
  INV_X1 sub_68_U20 ( .A(sub_68_n68), .ZN(sub_68_n11) );
  BUF_X1 sub_68_U19 ( .A(reg1[3]), .Z(sub_68_n10) );
  AND3_X1 sub_68_U18 ( .A1(sub_68_n28), .A2(sub_68_n27), .A3(sub_68_n26), .ZN(
        sub_68_n13) );
  CLKBUF_X1 sub_68_U17 ( .A(sub_68_n59), .Z(sub_68_n9) );
  AND2_X1 sub_68_U16 ( .A1(sub_68_n35), .A2(sub_68_n38), .ZN(sub_68_n7) );
  XNOR2_X1 sub_68_U15 ( .A(sub_68_n2), .B(sub_68_n7), .ZN(N77) );
  AND2_X1 sub_68_U14 ( .A1(sub_68_n76), .A2(n177), .ZN(sub_68_n16) );
  AND2_X1 sub_68_U13 ( .A1(sub_68_n72), .A2(sub_68_n73), .ZN(sub_68_n6) );
  OAI21_X1 sub_68_U12 ( .B1(sub_68_n5), .B2(sub_68_n14), .A(sub_68_n61), .ZN(
        sub_68_n26) );
  NOR2_X1 sub_68_U11 ( .A1(sub_68_n52), .A2(n175), .ZN(sub_68_n51) );
  NOR2_X1 sub_68_U10 ( .A1(sub_68_n71), .A2(n171), .ZN(sub_68_n14) );
  AND2_X1 sub_68_U9 ( .A1(sub_68_n10), .A2(sub_68_n53), .ZN(sub_68_n5) );
  INV_X1 sub_68_U8 ( .A(sub_68_n5), .ZN(sub_68_n63) );
  CLKBUF_X1 sub_68_U7 ( .A(reg1[0]), .Z(sub_68_n4) );
  BUF_X1 sub_68_U6 ( .A(sub_68_n68), .Z(sub_68_n3) );
  AND3_X1 sub_68_U5 ( .A1(sub_68_n27), .A2(sub_68_n28), .A3(sub_68_n26), .ZN(
        sub_68_n8) );
  AND3_X1 sub_68_U4 ( .A1(sub_68_n27), .A2(sub_68_n28), .A3(sub_68_n26), .ZN(
        sub_68_n2) );
  NAND2_X1 sub_68_U3 ( .A1(sub_68_n76), .A2(n177), .ZN(sub_68_n1) );
  INV_X1 add_65_U80 ( .A(add_65_n13), .ZN(add_65_n69) );
  INV_X1 add_65_U79 ( .A(add_65_n68), .ZN(add_65_n66) );
  INV_X1 add_65_U78 ( .A(add_65_n60), .ZN(add_65_n67) );
  OAI21_X1 add_65_U77 ( .B1(add_65_n66), .B2(add_65_n67), .A(add_65_n61), .ZN(
        add_65_n62) );
  XNOR2_X1 add_65_U76 ( .A(add_65_n62), .B(add_65_n63), .ZN(N68) );
  INV_X1 add_65_U75 ( .A(add_65_n44), .ZN(add_65_n52) );
  INV_X1 add_65_U74 ( .A(add_65_n46), .ZN(add_65_n43) );
  INV_X1 add_65_U73 ( .A(add_65_n45), .ZN(add_65_n51) );
  INV_X1 add_65_U72 ( .A(add_65_n33), .ZN(add_65_n42) );
  XNOR2_X1 add_65_U71 ( .A(add_65_n40), .B(add_65_n41), .ZN(N71) );
  INV_X1 add_65_U70 ( .A(add_65_n34), .ZN(add_65_n31) );
  INV_X1 add_65_U69 ( .A(add_65_n36), .ZN(add_65_n35) );
  INV_X1 add_65_U68 ( .A(add_65_n32), .ZN(add_65_n28) );
  NOR2_X1 add_65_U67 ( .A1(add_65_n10), .A2(add_65_n31), .ZN(add_65_n29) );
  NAND4_X1 add_65_U66 ( .A1(add_65_n19), .A2(add_65_n28), .A3(add_65_n29), 
        .A4(add_65_n8), .ZN(add_65_n27) );
  XNOR2_X1 add_65_U65 ( .A(add_65_n23), .B(add_65_n24), .ZN(N72) );
  INV_X1 add_65_U64 ( .A(add_65_n21), .ZN(add_65_n72) );
  NAND2_X1 add_65_U63 ( .A1(reg2[0]), .A2(n183), .ZN(add_65_n59) );
  NAND2_X1 add_65_U62 ( .A1(add_65_n58), .A2(add_65_n59), .ZN(add_65_n30) );
  NAND2_X1 add_65_U61 ( .A1(reg1[1]), .A2(reg2[1]), .ZN(add_65_n58) );
  OAI21_X1 add_65_U60 ( .B1(add_65_n15), .B2(add_65_n32), .A(add_65_n42), .ZN(
        add_65_n40) );
  NOR2_X1 add_65_U59 ( .A1(add_65_n56), .A2(add_65_n1), .ZN(add_65_n55) );
  NAND2_X1 add_65_U58 ( .A1(add_65_n55), .A2(add_65_n54), .ZN(add_65_n48) );
  XNOR2_X1 add_65_U57 ( .A(add_65_n48), .B(add_65_n53), .ZN(N69) );
  INV_X1 add_65_U56 ( .A(n173), .ZN(add_65_n65) );
  NAND2_X1 add_65_U55 ( .A1(add_65_n7), .A2(add_65_n12), .ZN(add_65_n63) );
  AOI21_X1 add_65_U54 ( .B1(add_65_n48), .B2(add_65_n47), .A(add_65_n52), .ZN(
        add_65_n49) );
  OAI21_X1 add_65_U53 ( .B1(add_65_n69), .B2(add_65_n10), .A(add_65_n6), .ZN(
        add_65_n68) );
  INV_X1 add_65_U52 ( .A(add_65_n20), .ZN(add_65_n71) );
  NAND2_X1 add_65_U51 ( .A1(reg2[2]), .A2(reg1[2]), .ZN(add_65_n61) );
  NAND2_X1 add_65_U50 ( .A1(reg2[4]), .A2(reg1[4]), .ZN(add_65_n44) );
  NOR2_X1 add_65_U49 ( .A1(add_65_n14), .A2(add_65_n39), .ZN(add_65_n38) );
  NOR2_X1 add_65_U48 ( .A1(add_65_n31), .A2(add_65_n14), .ZN(add_65_n37) );
  INV_X1 add_65_U47 ( .A(reg2[3]), .ZN(add_65_n64) );
  NAND2_X1 add_65_U46 ( .A1(reg2[5]), .A2(reg1[5]), .ZN(add_65_n45) );
  NAND2_X1 add_65_U45 ( .A1(reg2[6]), .A2(reg1[6]), .ZN(add_65_n36) );
  OR2_X2 add_65_U44 ( .A1(reg1[2]), .A2(reg2[2]), .ZN(add_65_n60) );
  CLKBUF_X1 add_65_U43 ( .A(n183), .Z(add_65_n21) );
  CLKBUF_X1 add_65_U42 ( .A(reg2[0]), .Z(add_65_n20) );
  AND2_X1 add_65_U41 ( .A1(add_65_n60), .A2(add_65_n12), .ZN(add_65_n19) );
  NAND2_X1 add_65_U40 ( .A1(add_65_n65), .A2(add_65_n64), .ZN(add_65_n18) );
  NAND3_X1 add_65_U39 ( .A1(add_65_n25), .A2(add_65_n27), .A3(add_65_n26), 
        .ZN(add_65_n23) );
  XNOR2_X1 add_65_U38 ( .A(reg2[7]), .B(reg1[7]), .ZN(add_65_n24) );
  OR2_X2 add_65_U37 ( .A1(reg2[4]), .A2(reg1[4]), .ZN(add_65_n47) );
  OR2_X2 add_65_U36 ( .A1(reg1[6]), .A2(reg2[6]), .ZN(add_65_n34) );
  OR2_X1 add_65_U35 ( .A1(reg2[5]), .A2(reg1[5]), .ZN(add_65_n46) );
  AND2_X1 add_65_U34 ( .A1(add_65_n69), .A2(add_65_n70), .ZN(N65) );
  OAI21_X1 add_65_U33 ( .B1(add_65_n43), .B2(add_65_n44), .A(add_65_n45), .ZN(
        add_65_n33) );
  AOI21_X1 add_65_U32 ( .B1(add_65_n33), .B2(add_65_n34), .A(add_65_n35), .ZN(
        add_65_n26) );
  NAND2_X1 add_65_U31 ( .A1(add_65_n46), .A2(add_65_n47), .ZN(add_65_n32) );
  NAND2_X1 add_65_U30 ( .A1(add_65_n1), .A2(add_65_n34), .ZN(add_65_n39) );
  NAND2_X1 add_65_U29 ( .A1(add_65_n36), .A2(add_65_n34), .ZN(add_65_n41) );
  AND2_X1 add_65_U28 ( .A1(add_65_n64), .A2(add_65_n65), .ZN(add_65_n16) );
  NOR2_X1 add_65_U27 ( .A1(add_65_n16), .A2(add_65_n61), .ZN(add_65_n22) );
  NOR2_X1 add_65_U26 ( .A1(add_65_n43), .A2(add_65_n51), .ZN(add_65_n50) );
  XNOR2_X1 add_65_U25 ( .A(add_65_n49), .B(add_65_n50), .ZN(N70) );
  NAND2_X1 add_65_U24 ( .A1(add_65_n44), .A2(add_65_n47), .ZN(add_65_n53) );
  INV_X1 add_65_U23 ( .A(add_65_n22), .ZN(add_65_n54) );
  AND2_X1 add_65_U22 ( .A1(add_65_n55), .A2(add_65_n54), .ZN(add_65_n15) );
  NAND2_X1 add_65_U21 ( .A1(add_65_n46), .A2(add_65_n47), .ZN(add_65_n14) );
  AND2_X1 add_65_U20 ( .A1(reg2[0]), .A2(n183), .ZN(add_65_n13) );
  INV_X1 add_65_U19 ( .A(add_65_n16), .ZN(add_65_n12) );
  CLKBUF_X1 add_65_U18 ( .A(n173), .Z(add_65_n11) );
  INV_X1 add_65_U17 ( .A(add_65_n57), .ZN(add_65_n10) );
  NOR2_X1 add_65_U16 ( .A1(add_65_n9), .A2(add_65_n38), .ZN(add_65_n25) );
  AND2_X1 add_65_U15 ( .A1(add_65_n37), .A2(add_65_n22), .ZN(add_65_n9) );
  CLKBUF_X1 add_65_U14 ( .A(add_65_n30), .Z(add_65_n8) );
  INV_X1 add_65_U13 ( .A(add_65_n1), .ZN(add_65_n7) );
  CLKBUF_X1 add_65_U12 ( .A(add_65_n58), .Z(add_65_n6) );
  AND4_X1 add_65_U11 ( .A1(add_65_n30), .A2(add_65_n60), .A3(add_65_n18), .A4(
        add_65_n57), .ZN(add_65_n56) );
  AND2_X1 add_65_U10 ( .A1(add_65_n61), .A2(add_65_n60), .ZN(add_65_n5) );
  XNOR2_X1 add_65_U9 ( .A(add_65_n66), .B(add_65_n5), .ZN(N67) );
  NAND2_X1 add_65_U8 ( .A1(add_65_n6), .A2(add_65_n57), .ZN(add_65_n4) );
  XNOR2_X1 add_65_U7 ( .A(add_65_n4), .B(add_65_n3), .ZN(N66) );
  OR2_X1 add_65_U6 ( .A1(reg2[1]), .A2(reg1[1]), .ZN(add_65_n57) );
  INV_X1 add_65_U5 ( .A(add_65_n69), .ZN(add_65_n3) );
  CLKBUF_X1 add_65_U4 ( .A(reg2[3]), .Z(add_65_n2) );
  AND2_X1 add_65_U3 ( .A1(add_65_n2), .A2(add_65_n11), .ZN(add_65_n1) );
  NAND2_X1 add_65_U2 ( .A1(add_65_n71), .A2(add_65_n72), .ZN(add_65_n70) );
endmodule

