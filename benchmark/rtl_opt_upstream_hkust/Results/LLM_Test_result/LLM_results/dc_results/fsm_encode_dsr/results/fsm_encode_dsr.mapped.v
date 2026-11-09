/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:39:08 2025
/////////////////////////////////////////////////////////////


module fsm_encode_dsr ( clk, rst_n, start, data_in, data_out, done );
  input [7:0] data_in;
  output [7:0] data_out;
  input clk, rst_n, start;
  output done;
  wire   N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49, N50, N51, N52,
         N53, N54, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n113, n115, n117, n119, n121, n123, n125, n127, n128, n129,
         n130, n131, n132, n133, n134, n135, n136, n137, n138, n139, n140,
         n141, n142, n143, n144, n145, n146, n147, n148, n149, n150, n151,
         n152, n153, n154, n155, n156, n157, n158, n159, n160, n161, n162,
         n163, n164, n165, n166, n167, n168, n169, n170, n171, n172, n173,
         n174, n175, n176, n177, n178, n179, n180, n181, n182, n183, n184,
         n185, n186, n187, n188, n189, n190, n191, n192, n193, n194, n195,
         n196, n197, n198, n199, n200, n201, n202, n203, n204, n205, n206,
         n207, n208, n209, n210, n211, n212, n213, n214, n215, n216, n217,
         sub_50_n107, sub_50_n106, sub_50_n105, sub_50_n104, sub_50_n103,
         sub_50_n102, sub_50_n101, sub_50_n100, sub_50_n99, sub_50_n98,
         sub_50_n97, sub_50_n96, sub_50_n95, sub_50_n94, sub_50_n93,
         sub_50_n92, sub_50_n91, sub_50_n90, sub_50_n89, sub_50_n88,
         sub_50_n87, sub_50_n86, sub_50_n85, sub_50_n84, sub_50_n83,
         sub_50_n82, sub_50_n81, sub_50_n80, sub_50_n79, sub_50_n78,
         sub_50_n77, sub_50_n76, sub_50_n75, sub_50_n74, sub_50_n73,
         sub_50_n72, sub_50_n71, sub_50_n70, sub_50_n69, sub_50_n68,
         sub_50_n67, sub_50_n66, sub_50_n65, sub_50_n64, sub_50_n63,
         sub_50_n62, sub_50_n61, sub_50_n60, sub_50_n59, sub_50_n58,
         sub_50_n57, sub_50_n56, sub_50_n55, sub_50_n54, sub_50_n53,
         sub_50_n52, sub_50_n51, sub_50_n50, sub_50_n49, sub_50_n48,
         sub_50_n47, sub_50_n46, sub_50_n45, sub_50_n44, sub_50_n43,
         sub_50_n42, sub_50_n41, sub_50_n40, sub_50_n39, sub_50_n38,
         sub_50_n37, sub_50_n36, sub_50_n35, sub_50_n34, sub_50_n33,
         sub_50_n32, sub_50_n31, sub_50_n30, sub_50_n29, sub_50_n28,
         sub_50_n27, sub_50_n26, sub_50_n25, sub_50_n24, sub_50_n23,
         sub_50_n22, sub_50_n21, sub_50_n20, sub_50_n19, sub_50_n18,
         sub_50_n17, sub_50_n16, sub_50_n15, sub_50_n14, sub_50_n13,
         sub_50_n12, sub_50_n11, sub_50_n10, sub_50_n9, sub_50_n8, sub_50_n7,
         sub_50_n6, sub_50_n5, sub_50_n4, sub_50_n3, sub_50_n2, sub_50_n1,
         add_49_n85, add_49_n84, add_49_n83, add_49_n82, add_49_n81,
         add_49_n80, add_49_n79, add_49_n78, add_49_n77, add_49_n76,
         add_49_n75, add_49_n74, add_49_n73, add_49_n72, add_49_n71,
         add_49_n70, add_49_n69, add_49_n68, add_49_n67, add_49_n66,
         add_49_n65, add_49_n64, add_49_n63, add_49_n62, add_49_n61,
         add_49_n60, add_49_n59, add_49_n58, add_49_n57, add_49_n56,
         add_49_n55, add_49_n54, add_49_n53, add_49_n52, add_49_n51,
         add_49_n50, add_49_n49, add_49_n48, add_49_n47, add_49_n46,
         add_49_n45, add_49_n44, add_49_n43, add_49_n42, add_49_n41,
         add_49_n40, add_49_n39, add_49_n38, add_49_n37, add_49_n36,
         add_49_n35, add_49_n34, add_49_n33, add_49_n32, add_49_n31,
         add_49_n30, add_49_n29, add_49_n28, add_49_n27, add_49_n26,
         add_49_n25, add_49_n24, add_49_n23, add_49_n22, add_49_n21,
         add_49_n20, add_49_n19, add_49_n18, add_49_n17, add_49_n16,
         add_49_n15, add_49_n14, add_49_n13, add_49_n12, add_49_n11,
         add_49_n10, add_49_n9, add_49_n8, add_49_n7, add_49_n6, add_49_n5,
         add_49_n4, add_49_n3, add_49_n1;
  wire   [2:0] current_state;
  wire   [2:0] next_state;
  wire   [7:0] reg1;
  wire   [7:0] reg2;

  DFFR_X1 done_reg ( .D(n217), .CK(clk), .RN(n163), .Q(done) );
  DFFR_X1 reg2_reg_7_ ( .D(n96), .CK(clk), .RN(n162), .Q(reg2[7]), .QN(n102)
         );
  DFFR_X1 reg2_reg_6_ ( .D(n95), .CK(clk), .RN(n162), .Q(reg2[6]), .QN(n143)
         );
  DFFR_X1 reg2_reg_5_ ( .D(n94), .CK(clk), .RN(n162), .Q(reg2[5]), .QN(n139)
         );
  DFFR_X1 reg2_reg_4_ ( .D(n93), .CK(clk), .RN(n162), .Q(reg2[4]), .QN(n151)
         );
  DFFR_X1 reg2_reg_3_ ( .D(n92), .CK(clk), .RN(n162), .Q(reg2[3]), .QN(n149)
         );
  DFFR_X1 reg2_reg_0_ ( .D(n89), .CK(clk), .RN(n162), .Q(reg2[0]), .QN(n133)
         );
  DFFR_X1 reg1_reg_7_ ( .D(n88), .CK(clk), .RN(n162), .Q(reg1[7]), .QN(n215)
         );
  DFFR_X1 reg1_reg_0_ ( .D(n87), .CK(clk), .RN(n162), .Q(reg1[0]), .QN(n147)
         );
  DFFR_X1 out_reg_reg_1_ ( .D(n85), .CK(clk), .RN(n162), .QN(n113) );
  DFFR_X1 out_reg_reg_2_ ( .D(n83), .CK(clk), .RN(n161), .QN(n115) );
  DFFR_X1 reg1_reg_3_ ( .D(n82), .CK(clk), .RN(n161), .Q(reg1[3]), .QN(n155)
         );
  DFFR_X1 out_reg_reg_3_ ( .D(n81), .CK(clk), .RN(n161), .QN(n117) );
  DFFR_X1 reg1_reg_4_ ( .D(n80), .CK(clk), .RN(n161), .Q(reg1[4]), .QN(n153)
         );
  DFFR_X1 out_reg_reg_4_ ( .D(n79), .CK(clk), .RN(n161), .QN(n119) );
  DFFR_X1 reg1_reg_5_ ( .D(n78), .CK(clk), .RN(n161), .Q(reg1[5]), .QN(n135)
         );
  DFFR_X1 out_reg_reg_5_ ( .D(n77), .CK(clk), .RN(n161), .QN(n121) );
  DFFR_X1 reg1_reg_6_ ( .D(n76), .CK(clk), .RN(n161), .Q(reg1[6]), .QN(n145)
         );
  DFFR_X1 out_reg_reg_6_ ( .D(n75), .CK(clk), .RN(n161), .QN(n123) );
  DFFR_X1 out_reg_reg_7_ ( .D(n74), .CK(clk), .RN(n161), .QN(n125) );
  DFFR_X1 out_reg_reg_0_ ( .D(n73), .CK(clk), .RN(n161), .QN(n111) );
  DFFR_X1 reg2_reg_2_ ( .D(n91), .CK(clk), .RN(n162), .Q(reg2[2]), .QN(n159)
         );
  DFFR_X1 reg1_reg_1_ ( .D(n86), .CK(clk), .RN(n162), .Q(reg1[1]), .QN(n157)
         );
  DFFR_X1 reg1_reg_2_ ( .D(n84), .CK(clk), .RN(n161), .Q(reg1[2]), .QN(n142)
         );
  DFFR_X1 reg2_reg_1_ ( .D(n90), .CK(clk), .RN(n162), .Q(reg2[1]), .QN(n137)
         );
  DFFR_X1 current_state_reg_2_ ( .D(next_state[2]), .CK(clk), .RN(n163), .Q(
        current_state[2]), .QN(n104) );
  DFFR_X1 current_state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(n163), .Q(
        current_state[0]), .QN(n103) );
  DFFR_X1 current_state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(n163), .Q(
        current_state[1]), .QN(n108) );
  NAND2_X1 U101 ( .A1(n216), .A2(n213), .ZN(n98) );
  NAND2_X1 U102 ( .A1(n216), .A2(n213), .ZN(n214) );
  INV_X1 U103 ( .A(n192), .ZN(n99) );
  NAND2_X1 U104 ( .A1(current_state[2]), .A2(n110), .ZN(n213) );
  NAND3_X1 U105 ( .A1(current_state[2]), .A2(current_state[1]), .A3(n103), 
        .ZN(n216) );
  INV_X1 U106 ( .A(n139), .ZN(n100) );
  AND3_X2 U107 ( .A1(current_state[1]), .A2(n104), .A3(n103), .ZN(n101) );
  AND2_X1 U108 ( .A1(n108), .A2(n104), .ZN(n105) );
  INV_X1 U109 ( .A(n203), .ZN(n106) );
  NAND4_X1 U110 ( .A1(n184), .A2(n186), .A3(n185), .A4(n187), .ZN(n78) );
  CLKBUF_X1 U111 ( .A(n159), .Z(n107) );
  AND2_X2 U112 ( .A1(n168), .A2(n132), .ZN(n109) );
  INV_X1 U113 ( .A(n192), .ZN(n182) );
  NAND2_X1 U114 ( .A1(N44), .A2(n197), .ZN(n185) );
  AND2_X1 U115 ( .A1(current_state[1]), .A2(current_state[0]), .ZN(n110) );
  BUF_X1 U116 ( .A(rst_n), .Z(n161) );
  BUF_X1 U117 ( .A(rst_n), .Z(n162) );
  BUF_X1 U118 ( .A(rst_n), .Z(n163) );
  INV_X1 U119 ( .A(n111), .ZN(data_out[0]) );
  INV_X1 U120 ( .A(n113), .ZN(data_out[1]) );
  INV_X1 U121 ( .A(n115), .ZN(data_out[2]) );
  INV_X1 U122 ( .A(n117), .ZN(data_out[3]) );
  INV_X1 U123 ( .A(n119), .ZN(data_out[4]) );
  INV_X1 U124 ( .A(n121), .ZN(data_out[5]) );
  INV_X1 U125 ( .A(n123), .ZN(data_out[6]) );
  INV_X1 U126 ( .A(n125), .ZN(data_out[7]) );
  INV_X1 U127 ( .A(n147), .ZN(n127) );
  INV_X1 U128 ( .A(n183), .ZN(n128) );
  INV_X1 U129 ( .A(n196), .ZN(n183) );
  INV_X1 U130 ( .A(n142), .ZN(n129) );
  INV_X1 U131 ( .A(n155), .ZN(n130) );
  INV_X1 U132 ( .A(n204), .ZN(n131) );
  OAI21_X1 U133 ( .B1(current_state[2]), .B2(n103), .A(n166), .ZN(n132) );
  INV_X1 U134 ( .A(n133), .ZN(n134) );
  INV_X1 U135 ( .A(n135), .ZN(n136) );
  INV_X1 U136 ( .A(n137), .ZN(n138) );
  INV_X1 U137 ( .A(n139), .ZN(n140) );
  INV_X1 U138 ( .A(n149), .ZN(n141) );
  INV_X1 U139 ( .A(n143), .ZN(n144) );
  INV_X1 U140 ( .A(n145), .ZN(n146) );
  INV_X1 U141 ( .A(n147), .ZN(n148) );
  INV_X1 U142 ( .A(n149), .ZN(n150) );
  INV_X1 U143 ( .A(n151), .ZN(n152) );
  INV_X1 U144 ( .A(n153), .ZN(n154) );
  INV_X1 U145 ( .A(n155), .ZN(n156) );
  INV_X1 U146 ( .A(n157), .ZN(n158) );
  NAND2_X1 U147 ( .A1(n198), .A2(reg1[5]), .ZN(n186) );
  INV_X1 U148 ( .A(n159), .ZN(n160) );
  AOI22_X1 U149 ( .A1(data_in[5]), .A2(n183), .B1(n182), .B2(n154), .ZN(n187)
         );
  NAND2_X1 U150 ( .A1(N52), .A2(n109), .ZN(n184) );
  XOR2_X1 U151 ( .A(current_state[1]), .B(current_state[0]), .Z(next_state[1])
         );
  NAND2_X1 U152 ( .A1(current_state[2]), .A2(n108), .ZN(n166) );
  NAND2_X1 U153 ( .A1(current_state[2]), .A2(n103), .ZN(n167) );
  NAND2_X1 U154 ( .A1(n110), .A2(n104), .ZN(n169) );
  NAND3_X1 U155 ( .A1(n166), .A2(n167), .A3(n169), .ZN(next_state[2]) );
  NAND2_X1 U156 ( .A1(n108), .A2(n104), .ZN(n165) );
  OAI21_X1 U157 ( .B1(start), .B2(n165), .A(n103), .ZN(n164) );
  INV_X1 U158 ( .A(n164), .ZN(next_state[0]) );
  INV_X1 U159 ( .A(n213), .ZN(n217) );
  OAI21_X1 U160 ( .B1(current_state[2]), .B2(n103), .A(n166), .ZN(n191) );
  NAND2_X1 U161 ( .A1(n105), .A2(n191), .ZN(n196) );
  INV_X1 U162 ( .A(data_in[1]), .ZN(n172) );
  INV_X1 U163 ( .A(n167), .ZN(n168) );
  NAND3_X1 U164 ( .A1(current_state[2]), .A2(current_state[0]), .A3(n191), 
        .ZN(n192) );
  AOI22_X1 U165 ( .A1(N48), .A2(n109), .B1(n182), .B2(n127), .ZN(n171) );
  INV_X1 U166 ( .A(n132), .ZN(n198) );
  INV_X1 U167 ( .A(n169), .ZN(n197) );
  AOI22_X1 U168 ( .A1(n198), .A2(n106), .B1(N40), .B2(n197), .ZN(n170) );
  OAI211_X1 U169 ( .C1(n128), .C2(n172), .A(n171), .B(n170), .ZN(n86) );
  INV_X1 U170 ( .A(data_in[2]), .ZN(n175) );
  AOI22_X1 U171 ( .A1(N49), .A2(n109), .B1(n99), .B2(n106), .ZN(n174) );
  AOI22_X1 U172 ( .A1(n198), .A2(n131), .B1(N41), .B2(n197), .ZN(n173) );
  OAI211_X1 U173 ( .C1(n128), .C2(n175), .A(n174), .B(n173), .ZN(n84) );
  INV_X1 U174 ( .A(data_in[3]), .ZN(n178) );
  AOI22_X1 U175 ( .A1(N50), .A2(n109), .B1(n99), .B2(n131), .ZN(n177) );
  AOI22_X1 U176 ( .A1(n198), .A2(n130), .B1(N42), .B2(n197), .ZN(n176) );
  OAI211_X1 U177 ( .C1(n128), .C2(n178), .A(n177), .B(n176), .ZN(n82) );
  INV_X1 U178 ( .A(data_in[4]), .ZN(n181) );
  AOI22_X1 U179 ( .A1(N51), .A2(n109), .B1(n99), .B2(n130), .ZN(n180) );
  AOI22_X1 U180 ( .A1(n198), .A2(n154), .B1(N43), .B2(n197), .ZN(n179) );
  OAI211_X1 U181 ( .C1(n128), .C2(n181), .A(n179), .B(n180), .ZN(n80) );
  INV_X1 U182 ( .A(data_in[6]), .ZN(n188) );
  INV_X1 U183 ( .A(reg1[5]), .ZN(n210) );
  INV_X1 U184 ( .A(n146), .ZN(n212) );
  OAI222_X1 U185 ( .A1(n196), .A2(n188), .B1(n192), .B2(n210), .C1(n212), .C2(
        n132), .ZN(n189) );
  AOI221_X1 U186 ( .B1(N45), .B2(n197), .C1(N53), .C2(n109), .A(n189), .ZN(
        n190) );
  INV_X1 U187 ( .A(n190), .ZN(n76) );
  MUX2_X1 U188 ( .A(reg2[7]), .B(data_in[7]), .S(n101), .Z(n96) );
  MUX2_X1 U189 ( .A(n144), .B(data_in[6]), .S(n101), .Z(n95) );
  MUX2_X1 U190 ( .A(n140), .B(data_in[5]), .S(n101), .Z(n94) );
  MUX2_X1 U191 ( .A(n152), .B(data_in[4]), .S(n101), .Z(n93) );
  MUX2_X1 U192 ( .A(n141), .B(data_in[3]), .S(n101), .Z(n92) );
  MUX2_X1 U193 ( .A(reg2[2]), .B(data_in[2]), .S(n101), .Z(n91) );
  MUX2_X1 U194 ( .A(reg2[1]), .B(data_in[1]), .S(n101), .Z(n90) );
  MUX2_X1 U195 ( .A(reg2[0]), .B(data_in[0]), .S(n101), .Z(n89) );
  INV_X1 U196 ( .A(data_in[7]), .ZN(n193) );
  OAI222_X1 U197 ( .A1(n196), .A2(n193), .B1(n192), .B2(n212), .C1(n215), .C2(
        n132), .ZN(n194) );
  AOI221_X1 U198 ( .B1(N54), .B2(n109), .C1(N46), .C2(n197), .A(n194), .ZN(
        n195) );
  INV_X1 U199 ( .A(n195), .ZN(n88) );
  AOI22_X1 U200 ( .A1(N47), .A2(n109), .B1(data_in[0]), .B2(n183), .ZN(n200)
         );
  AOI22_X1 U201 ( .A1(n198), .A2(n127), .B1(N39), .B2(n197), .ZN(n199) );
  NAND2_X1 U202 ( .A1(n200), .A2(n199), .ZN(n87) );
  INV_X1 U203 ( .A(reg2[0]), .ZN(n201) );
  OAI222_X1 U204 ( .A1(n216), .A2(n147), .B1(n214), .B2(n111), .C1(n213), .C2(
        n201), .ZN(n73) );
  INV_X1 U205 ( .A(reg1[1]), .ZN(n203) );
  INV_X1 U206 ( .A(reg2[1]), .ZN(n202) );
  OAI222_X1 U207 ( .A1(n216), .A2(n203), .B1(n214), .B2(n113), .C1(n213), .C2(
        n202), .ZN(n85) );
  INV_X1 U208 ( .A(n129), .ZN(n204) );
  OAI222_X1 U209 ( .A1(n216), .A2(n204), .B1(n214), .B2(n115), .C1(n213), .C2(
        n107), .ZN(n83) );
  INV_X1 U210 ( .A(n130), .ZN(n206) );
  INV_X1 U211 ( .A(n141), .ZN(n205) );
  OAI222_X1 U212 ( .A1(n216), .A2(n206), .B1(n214), .B2(n117), .C1(n213), .C2(
        n205), .ZN(n81) );
  INV_X1 U213 ( .A(n154), .ZN(n208) );
  INV_X1 U214 ( .A(n152), .ZN(n207) );
  OAI222_X1 U215 ( .A1(n216), .A2(n208), .B1(n98), .B2(n119), .C1(n213), .C2(
        n207), .ZN(n79) );
  INV_X1 U216 ( .A(n140), .ZN(n209) );
  OAI222_X1 U217 ( .A1(n216), .A2(n210), .B1(n98), .B2(n121), .C1(n213), .C2(
        n209), .ZN(n77) );
  INV_X1 U218 ( .A(n144), .ZN(n211) );
  OAI222_X1 U219 ( .A1(n216), .A2(n212), .B1(n98), .B2(n123), .C1(n213), .C2(
        n211), .ZN(n75) );
  OAI222_X1 U220 ( .A1(n216), .A2(n215), .B1(n98), .B2(n125), .C1(n213), .C2(
        n102), .ZN(n74) );
  INV_X1 sub_50_U117 ( .A(sub_50_n101), .ZN(sub_50_n100) );
  INV_X1 sub_50_U116 ( .A(sub_50_n58), .ZN(sub_50_n69) );
  NOR2_X1 sub_50_U115 ( .A1(sub_50_n22), .A2(sub_50_n69), .ZN(sub_50_n97) );
  NAND3_X1 sub_50_U114 ( .A1(sub_50_n82), .A2(sub_50_n83), .A3(sub_50_n60), 
        .ZN(sub_50_n81) );
  INV_X1 sub_50_U113 ( .A(sub_50_n70), .ZN(sub_50_n73) );
  INV_X1 sub_50_U112 ( .A(sub_50_n38), .ZN(sub_50_n65) );
  OAI211_X1 sub_50_U111 ( .C1(sub_50_n13), .C2(sub_50_n3), .A(sub_50_n46), .B(
        sub_50_n57), .ZN(sub_50_n72) );
  NAND2_X1 sub_50_U110 ( .A1(sub_50_n72), .A2(sub_50_n60), .ZN(sub_50_n67) );
  NAND3_X1 sub_50_U109 ( .A1(sub_50_n32), .A2(sub_50_n59), .A3(sub_50_n26), 
        .ZN(sub_50_n34) );
  NAND3_X1 sub_50_U108 ( .A1(sub_50_n53), .A2(sub_50_n52), .A3(sub_50_n51), 
        .ZN(sub_50_n35) );
  INV_X1 sub_50_U107 ( .A(n158), .ZN(sub_50_n88) );
  NAND2_X1 sub_50_U106 ( .A1(n138), .A2(sub_50_n25), .ZN(sub_50_n46) );
  NAND2_X1 sub_50_U105 ( .A1(sub_50_n80), .A2(sub_50_n74), .ZN(sub_50_n76) );
  XNOR2_X1 sub_50_U104 ( .A(sub_50_n76), .B(sub_50_n77), .ZN(N52) );
  NOR2_X1 sub_50_U103 ( .A1(sub_50_n2), .A2(sub_50_n93), .ZN(sub_50_n92) );
  XNOR2_X1 sub_50_U102 ( .A(sub_50_n33), .B(sub_50_n24), .ZN(N54) );
  XNOR2_X1 sub_50_U101 ( .A(sub_50_n61), .B(sub_50_n62), .ZN(N53) );
  INV_X1 sub_50_U100 ( .A(reg1[2]), .ZN(sub_50_n94) );
  NAND2_X1 sub_50_U99 ( .A1(n160), .A2(sub_50_n94), .ZN(sub_50_n50) );
  OAI21_X1 sub_50_U98 ( .B1(sub_50_n29), .B2(sub_50_n67), .A(sub_50_n68), .ZN(
        sub_50_n66) );
  NAND4_X1 sub_50_U97 ( .A1(sub_50_n35), .A2(sub_50_n34), .A3(sub_50_n36), 
        .A4(sub_50_n37), .ZN(sub_50_n33) );
  NAND2_X1 sub_50_U96 ( .A1(sub_50_n49), .A2(sub_50_n46), .ZN(sub_50_n102) );
  NAND2_X1 sub_50_U95 ( .A1(sub_50_n21), .A2(sub_50_n56), .ZN(sub_50_n105) );
  NAND2_X1 sub_50_U94 ( .A1(sub_50_n66), .A2(sub_50_n65), .ZN(sub_50_n61) );
  INV_X1 sub_50_U93 ( .A(n160), .ZN(sub_50_n90) );
  INV_X1 sub_50_U92 ( .A(reg1[0]), .ZN(sub_50_n55) );
  NAND2_X1 sub_50_U91 ( .A1(sub_50_n30), .A2(sub_50_n27), .ZN(sub_50_n103) );
  NAND2_X1 sub_50_U90 ( .A1(sub_50_n95), .A2(reg2[3]), .ZN(sub_50_n45) );
  NAND2_X1 sub_50_U89 ( .A1(reg2[3]), .A2(sub_50_n8), .ZN(sub_50_n58) );
  INV_X1 sub_50_U88 ( .A(sub_50_n6), .ZN(sub_50_n98) );
  INV_X1 sub_50_U87 ( .A(reg1[4]), .ZN(sub_50_n85) );
  NAND2_X1 sub_50_U86 ( .A1(reg1[4]), .A2(sub_50_n86), .ZN(sub_50_n74) );
  NAND2_X1 sub_50_U85 ( .A1(sub_50_n10), .A2(sub_50_n90), .ZN(sub_50_n101) );
  XNOR2_X1 sub_50_U84 ( .A(sub_50_n84), .B(sub_50_n5), .ZN(N51) );
  NAND2_X1 sub_50_U83 ( .A1(sub_50_n12), .A2(sub_50_n11), .ZN(sub_50_n49) );
  NAND2_X1 sub_50_U82 ( .A1(sub_50_n4), .A2(sub_50_n103), .ZN(sub_50_n87) );
  OAI21_X1 sub_50_U81 ( .B1(sub_50_n12), .B2(sub_50_n11), .A(sub_50_n56), .ZN(
        sub_50_n52) );
  NAND2_X1 sub_50_U80 ( .A1(n134), .A2(sub_50_n55), .ZN(sub_50_n107) );
  INV_X1 sub_50_U79 ( .A(reg1[3]), .ZN(sub_50_n95) );
  NAND2_X1 sub_50_U78 ( .A1(sub_50_n91), .A2(sub_50_n92), .ZN(sub_50_n83) );
  INV_X1 sub_50_U77 ( .A(n152), .ZN(sub_50_n86) );
  INV_X1 sub_50_U76 ( .A(n136), .ZN(sub_50_n78) );
  NAND2_X1 sub_50_U75 ( .A1(sub_50_n17), .A2(sub_50_n79), .ZN(sub_50_n75) );
  INV_X1 sub_50_U74 ( .A(reg2[6]), .ZN(sub_50_n64) );
  NAND2_X1 sub_50_U73 ( .A1(n100), .A2(sub_50_n9), .ZN(sub_50_n70) );
  INV_X1 sub_50_U72 ( .A(n100), .ZN(sub_50_n79) );
  NAND2_X1 sub_50_U71 ( .A1(sub_50_n50), .A2(sub_50_n107), .ZN(sub_50_n48) );
  NAND2_X1 sub_50_U70 ( .A1(reg2[6]), .A2(sub_50_n63), .ZN(sub_50_n39) );
  NAND2_X1 sub_50_U69 ( .A1(sub_50_n43), .A2(sub_50_n26), .ZN(sub_50_n62) );
  NAND2_X1 sub_50_U68 ( .A1(sub_50_n46), .A2(sub_50_n26), .ZN(sub_50_n54) );
  NAND2_X1 sub_50_U67 ( .A1(sub_50_n45), .A2(sub_50_n39), .ZN(sub_50_n44) );
  NAND2_X1 sub_50_U66 ( .A1(sub_50_n38), .A2(sub_50_n26), .ZN(sub_50_n37) );
  AND2_X1 sub_50_U65 ( .A1(sub_50_n58), .A2(sub_50_n89), .ZN(sub_50_n32) );
  NAND2_X1 sub_50_U64 ( .A1(sub_50_n81), .A2(sub_50_n15), .ZN(sub_50_n80) );
  NAND2_X1 sub_50_U63 ( .A1(sub_50_n15), .A2(sub_50_n28), .ZN(sub_50_n47) );
  NOR2_X1 sub_50_U62 ( .A1(sub_50_n69), .A2(sub_50_n31), .ZN(sub_50_n68) );
  INV_X1 sub_50_U61 ( .A(sub_50_n31), .ZN(sub_50_n59) );
  NOR2_X1 sub_50_U60 ( .A1(sub_50_n31), .A2(sub_50_n54), .ZN(sub_50_n53) );
  NOR2_X1 sub_50_U59 ( .A1(sub_50_n48), .A2(sub_50_n47), .ZN(sub_50_n40) );
  INV_X1 sub_50_U58 ( .A(reg1[6]), .ZN(sub_50_n63) );
  NOR2_X1 sub_50_U57 ( .A1(sub_50_n44), .A2(sub_50_n2), .ZN(sub_50_n41) );
  AOI21_X1 sub_50_U56 ( .B1(sub_50_n40), .B2(sub_50_n41), .A(sub_50_n42), .ZN(
        sub_50_n36) );
  NAND2_X1 sub_50_U55 ( .A1(sub_50_n94), .A2(n160), .ZN(sub_50_n57) );
  XNOR2_X1 sub_50_U54 ( .A(sub_50_n96), .B(sub_50_n97), .ZN(N50) );
  NAND2_X1 sub_50_U53 ( .A1(sub_50_n71), .A2(sub_50_n70), .ZN(sub_50_n31) );
  NAND2_X1 sub_50_U52 ( .A1(sub_50_n58), .A2(sub_50_n89), .ZN(sub_50_n60) );
  NAND4_X1 sub_50_U51 ( .A1(sub_50_n87), .A2(sub_50_n21), .A3(sub_50_n57), 
        .A4(sub_50_n58), .ZN(sub_50_n82) );
  BUF_X1 sub_50_U50 ( .A(reg1[0]), .Z(sub_50_n30) );
  AND2_X1 sub_50_U49 ( .A1(sub_50_n92), .A2(sub_50_n91), .ZN(sub_50_n29) );
  NAND2_X1 sub_50_U48 ( .A1(n100), .A2(sub_50_n78), .ZN(sub_50_n28) );
  INV_X1 sub_50_U47 ( .A(n134), .ZN(sub_50_n27) );
  NAND2_X1 sub_50_U46 ( .A1(sub_50_n63), .A2(reg2[6]), .ZN(sub_50_n26) );
  INV_X1 sub_50_U45 ( .A(n158), .ZN(sub_50_n25) );
  NAND2_X1 sub_50_U44 ( .A1(sub_50_n7), .A2(sub_50_n64), .ZN(sub_50_n43) );
  XOR2_X1 sub_50_U43 ( .A(reg2[7]), .B(reg1[7]), .Z(sub_50_n24) );
  NAND2_X1 sub_50_U42 ( .A1(sub_50_n103), .A2(sub_50_n107), .ZN(N47) );
  INV_X1 sub_50_U41 ( .A(sub_50_n49), .ZN(sub_50_n106) );
  NAND2_X1 sub_50_U40 ( .A1(sub_50_n106), .A2(sub_50_n103), .ZN(sub_50_n104)
         );
  XNOR2_X1 sub_50_U39 ( .A(sub_50_n104), .B(sub_50_n105), .ZN(N48) );
  AND2_X1 sub_50_U38 ( .A1(sub_50_n101), .A2(sub_50_n57), .ZN(sub_50_n23) );
  XOR2_X1 sub_50_U37 ( .A(sub_50_n99), .B(sub_50_n23), .Z(N49) );
  NAND2_X1 sub_50_U36 ( .A1(sub_50_n102), .A2(sub_50_n56), .ZN(sub_50_n99) );
  AOI21_X1 sub_50_U35 ( .B1(sub_50_n1), .B2(sub_50_n99), .A(sub_50_n100), .ZN(
        sub_50_n96) );
  AND2_X1 sub_50_U34 ( .A1(sub_50_n57), .A2(sub_50_n58), .ZN(sub_50_n51) );
  NOR2_X1 sub_50_U33 ( .A1(sub_50_n27), .A2(sub_50_n30), .ZN(sub_50_n93) );
  NAND2_X1 sub_50_U32 ( .A1(sub_50_n75), .A2(sub_50_n28), .ZN(sub_50_n77) );
  AND2_X1 sub_50_U31 ( .A1(sub_50_n45), .A2(sub_50_n50), .ZN(sub_50_n91) );
  OAI21_X1 sub_50_U30 ( .B1(sub_50_n73), .B2(sub_50_n74), .A(sub_50_n75), .ZN(
        sub_50_n38) );
  INV_X1 sub_50_U29 ( .A(sub_50_n43), .ZN(sub_50_n42) );
  AND2_X1 sub_50_U28 ( .A1(sub_50_n14), .A2(sub_50_n98), .ZN(sub_50_n22) );
  INV_X1 sub_50_U27 ( .A(sub_50_n2), .ZN(sub_50_n21) );
  INV_X1 sub_50_U26 ( .A(reg1[2]), .ZN(sub_50_n20) );
  INV_X1 sub_50_U25 ( .A(reg1[3]), .ZN(sub_50_n19) );
  OAI22_X1 sub_50_U24 ( .A1(sub_50_n19), .A2(reg2[3]), .B1(sub_50_n20), .B2(
        n160), .ZN(sub_50_n89) );
  NAND2_X1 sub_50_U23 ( .A1(sub_50_n85), .A2(n152), .ZN(sub_50_n71) );
  NOR3_X1 sub_50_U22 ( .A1(sub_50_n16), .A2(sub_50_n32), .A3(sub_50_n29), .ZN(
        sub_50_n84) );
  INV_X1 sub_50_U21 ( .A(n158), .ZN(sub_50_n18) );
  CLKBUF_X1 sub_50_U20 ( .A(n136), .Z(sub_50_n17) );
  AND4_X1 sub_50_U19 ( .A1(sub_50_n87), .A2(sub_50_n46), .A3(sub_50_n57), .A4(
        sub_50_n58), .ZN(sub_50_n16) );
  NAND2_X1 sub_50_U18 ( .A1(sub_50_n85), .A2(n152), .ZN(sub_50_n15) );
  INV_X1 sub_50_U17 ( .A(sub_50_n19), .ZN(sub_50_n14) );
  AND2_X1 sub_50_U16 ( .A1(sub_50_n30), .A2(sub_50_n27), .ZN(sub_50_n13) );
  CLKBUF_X1 sub_50_U15 ( .A(n134), .Z(sub_50_n12) );
  INV_X1 sub_50_U14 ( .A(sub_50_n20), .ZN(sub_50_n10) );
  INV_X1 sub_50_U13 ( .A(n136), .ZN(sub_50_n9) );
  BUF_X1 sub_50_U12 ( .A(sub_50_n55), .Z(sub_50_n11) );
  INV_X1 sub_50_U11 ( .A(reg1[3]), .ZN(sub_50_n8) );
  CLKBUF_X1 sub_50_U10 ( .A(reg1[6]), .Z(sub_50_n7) );
  CLKBUF_X1 sub_50_U9 ( .A(reg2[3]), .Z(sub_50_n6) );
  AND2_X1 sub_50_U8 ( .A1(sub_50_n74), .A2(sub_50_n71), .ZN(sub_50_n5) );
  OR2_X1 sub_50_U7 ( .A1(n138), .A2(sub_50_n18), .ZN(sub_50_n4) );
  NOR2_X1 sub_50_U6 ( .A1(n138), .A2(sub_50_n18), .ZN(sub_50_n3) );
  AND2_X1 sub_50_U5 ( .A1(n138), .A2(sub_50_n88), .ZN(sub_50_n2) );
  OR2_X1 sub_50_U4 ( .A1(sub_50_n18), .A2(n138), .ZN(sub_50_n56) );
  BUF_X1 sub_50_U3 ( .A(sub_50_n57), .Z(sub_50_n1) );
  NAND3_X1 add_49_U93 ( .A1(add_49_n54), .A2(add_49_n75), .A3(add_49_n85), 
        .ZN(add_49_n84) );
  NAND3_X1 add_49_U92 ( .A1(add_49_n12), .A2(add_49_n75), .A3(add_49_n74), 
        .ZN(add_49_n79) );
  NAND3_X1 add_49_U91 ( .A1(add_49_n5), .A2(add_49_n6), .A3(add_49_n72), .ZN(
        add_49_n37) );
  INV_X1 add_49_U90 ( .A(add_49_n39), .ZN(add_49_n71) );
  INV_X1 add_49_U89 ( .A(add_49_n75), .ZN(add_49_n26) );
  NOR2_X1 add_49_U88 ( .A1(add_49_n26), .A2(add_49_n11), .ZN(add_49_n73) );
  NAND3_X1 add_49_U87 ( .A1(add_49_n12), .A2(add_49_n73), .A3(add_49_n74), 
        .ZN(add_49_n66) );
  INV_X1 add_49_U86 ( .A(add_49_n47), .ZN(add_49_n70) );
  NOR2_X1 add_49_U85 ( .A1(add_49_n70), .A2(add_49_n71), .ZN(add_49_n68) );
  NAND2_X1 add_49_U84 ( .A1(reg2[0]), .A2(n148), .ZN(add_49_n57) );
  NAND2_X1 add_49_U83 ( .A1(add_49_n6), .A2(n129), .ZN(add_49_n58) );
  NAND2_X1 add_49_U82 ( .A1(reg1[1]), .A2(add_49_n1), .ZN(add_49_n52) );
  OAI21_X1 add_49_U81 ( .B1(add_49_n13), .B2(add_49_n52), .A(add_49_n36), .ZN(
        add_49_n51) );
  NAND3_X1 add_49_U80 ( .A1(add_49_n38), .A2(add_49_n47), .A3(add_49_n15), 
        .ZN(add_49_n43) );
  NAND3_X1 add_49_U79 ( .A1(n154), .A2(reg2[4]), .A3(add_49_n38), .ZN(
        add_49_n46) );
  INV_X1 add_49_U78 ( .A(add_49_n28), .ZN(add_49_n44) );
  INV_X1 add_49_U77 ( .A(add_49_n32), .ZN(add_49_n21) );
  INV_X1 add_49_U76 ( .A(add_49_n36), .ZN(add_49_n35) );
  INV_X1 add_49_U75 ( .A(add_49_n29), .ZN(add_49_n27) );
  INV_X1 add_49_U74 ( .A(add_49_n31), .ZN(add_49_n30) );
  NOR2_X1 add_49_U73 ( .A1(add_49_n26), .A2(add_49_n27), .ZN(add_49_n22) );
  NAND4_X1 add_49_U72 ( .A1(add_49_n12), .A2(add_49_n21), .A3(add_49_n22), 
        .A4(add_49_n23), .ZN(add_49_n20) );
  XNOR2_X1 add_49_U71 ( .A(add_49_n16), .B(add_49_n17), .ZN(N46) );
  XNOR2_X1 add_49_U70 ( .A(add_49_n76), .B(add_49_n77), .ZN(N43) );
  INV_X1 add_49_U69 ( .A(reg1[1]), .ZN(add_49_n61) );
  NAND2_X1 add_49_U68 ( .A1(reg2[1]), .A2(reg1[1]), .ZN(add_49_n24) );
  INV_X1 add_49_U67 ( .A(reg2[2]), .ZN(add_49_n62) );
  NAND2_X1 add_49_U66 ( .A1(add_49_n83), .A2(add_49_n55), .ZN(add_49_n82) );
  NAND2_X1 add_49_U65 ( .A1(reg2[0]), .A2(n148), .ZN(add_49_n25) );
  NAND2_X1 add_49_U64 ( .A1(n156), .A2(n150), .ZN(add_49_n36) );
  INV_X1 add_49_U63 ( .A(n150), .ZN(add_49_n48) );
  INV_X1 add_49_U62 ( .A(n129), .ZN(add_49_n63) );
  INV_X1 add_49_U61 ( .A(n156), .ZN(add_49_n49) );
  NAND2_X1 add_49_U60 ( .A1(add_49_n38), .A2(add_49_n39), .ZN(add_49_n32) );
  NAND2_X1 add_49_U59 ( .A1(reg2[5]), .A2(reg1[5]), .ZN(add_49_n45) );
  NAND2_X1 add_49_U58 ( .A1(add_49_n45), .A2(add_49_n38), .ZN(add_49_n65) );
  NAND2_X1 add_49_U57 ( .A1(add_49_n63), .A2(add_49_n62), .ZN(add_49_n53) );
  NAND2_X1 add_49_U56 ( .A1(n144), .A2(n146), .ZN(add_49_n31) );
  INV_X1 add_49_U55 ( .A(reg2[1]), .ZN(add_49_n60) );
  NAND2_X1 add_49_U54 ( .A1(add_49_n84), .A2(add_49_n24), .ZN(add_49_n83) );
  OAI21_X1 add_49_U53 ( .B1(add_49_n42), .B2(add_49_n43), .A(add_49_n44), .ZN(
        add_49_n40) );
  NOR2_X1 add_49_U52 ( .A1(add_49_n32), .A2(add_49_n34), .ZN(add_49_n33) );
  XNOR2_X1 add_49_U51 ( .A(add_49_n40), .B(add_49_n41), .ZN(N45) );
  INV_X1 add_49_U50 ( .A(add_49_n71), .ZN(add_49_n15) );
  NAND2_X1 add_49_U49 ( .A1(add_49_n48), .A2(add_49_n49), .ZN(add_49_n72) );
  NAND2_X1 add_49_U48 ( .A1(add_49_n48), .A2(add_49_n49), .ZN(add_49_n47) );
  AND2_X1 add_49_U47 ( .A1(add_49_n62), .A2(add_49_n63), .ZN(add_49_n13) );
  NAND2_X1 add_49_U46 ( .A1(add_49_n24), .A2(add_49_n25), .ZN(add_49_n74) );
  NAND2_X1 add_49_U45 ( .A1(add_49_n24), .A2(add_49_n25), .ZN(add_49_n23) );
  OAI21_X1 add_49_U44 ( .B1(add_49_n56), .B2(add_49_n57), .A(add_49_n58), .ZN(
        add_49_n50) );
  NOR2_X1 add_49_U43 ( .A1(add_49_n14), .A2(add_49_n33), .ZN(add_49_n18) );
  INV_X1 add_49_U42 ( .A(add_49_n13), .ZN(add_49_n55) );
  NOR3_X1 add_49_U41 ( .A1(add_49_n32), .A2(add_49_n27), .A3(add_49_n37), .ZN(
        add_49_n14) );
  INV_X1 add_49_U40 ( .A(add_49_n39), .ZN(add_49_n11) );
  XNOR2_X1 add_49_U39 ( .A(add_49_n80), .B(add_49_n81), .ZN(N42) );
  NAND2_X1 add_49_U38 ( .A1(add_49_n60), .A2(add_49_n61), .ZN(add_49_n59) );
  NAND2_X1 add_49_U37 ( .A1(add_49_n31), .A2(add_49_n29), .ZN(add_49_n41) );
  NAND2_X1 add_49_U36 ( .A1(add_49_n35), .A2(add_49_n29), .ZN(add_49_n34) );
  AOI21_X1 add_49_U35 ( .B1(add_49_n28), .B2(add_49_n29), .A(add_49_n30), .ZN(
        add_49_n19) );
  AOI21_X1 add_49_U34 ( .B1(add_49_n68), .B2(add_49_n69), .A(add_49_n10), .ZN(
        add_49_n67) );
  XNOR2_X1 add_49_U33 ( .A(add_49_n64), .B(add_49_n65), .ZN(N44) );
  NAND3_X1 add_49_U32 ( .A1(add_49_n19), .A2(add_49_n20), .A3(add_49_n18), 
        .ZN(add_49_n16) );
  XNOR2_X1 add_49_U31 ( .A(reg2[7]), .B(reg1[7]), .ZN(add_49_n17) );
  AND2_X1 add_49_U30 ( .A1(reg2[4]), .A2(n154), .ZN(add_49_n10) );
  OR2_X1 add_49_U29 ( .A1(reg2[0]), .A2(n148), .ZN(add_49_n54) );
  NAND2_X1 add_49_U28 ( .A1(add_49_n45), .A2(add_49_n46), .ZN(add_49_n28) );
  OR2_X2 add_49_U27 ( .A1(reg1[5]), .A2(reg2[5]), .ZN(add_49_n38) );
  AND2_X1 add_49_U26 ( .A1(n148), .A2(reg2[0]), .ZN(add_49_n85) );
  AND2_X1 add_49_U25 ( .A1(add_49_n84), .A2(add_49_n24), .ZN(add_49_n9) );
  NAND2_X1 add_49_U24 ( .A1(add_49_n58), .A2(add_49_n36), .ZN(add_49_n69) );
  OR2_X2 add_49_U23 ( .A1(n144), .A2(n146), .ZN(add_49_n29) );
  NAND2_X1 add_49_U22 ( .A1(add_49_n66), .A2(add_49_n67), .ZN(add_49_n64) );
  INV_X1 add_49_U21 ( .A(add_49_n37), .ZN(add_49_n78) );
  NOR2_X1 add_49_U20 ( .A1(add_49_n11), .A2(add_49_n10), .ZN(add_49_n77) );
  NAND2_X1 add_49_U19 ( .A1(add_49_n82), .A2(add_49_n58), .ZN(add_49_n80) );
  NAND2_X1 add_49_U18 ( .A1(add_49_n47), .A2(add_49_n36), .ZN(add_49_n81) );
  NAND2_X1 add_49_U17 ( .A1(add_49_n59), .A2(add_49_n7), .ZN(add_49_n56) );
  NOR2_X1 add_49_U16 ( .A1(add_49_n50), .A2(add_49_n51), .ZN(add_49_n42) );
  NAND2_X1 add_49_U15 ( .A1(add_49_n75), .A2(add_49_n24), .ZN(add_49_n8) );
  XOR2_X1 add_49_U14 ( .A(add_49_n57), .B(add_49_n8), .Z(N40) );
  AND2_X2 add_49_U13 ( .A1(add_49_n53), .A2(add_49_n72), .ZN(add_49_n12) );
  NAND2_X1 add_49_U12 ( .A1(add_49_n63), .A2(add_49_n62), .ZN(add_49_n7) );
  CLKBUF_X1 add_49_U11 ( .A(n129), .Z(add_49_n5) );
  CLKBUF_X1 add_49_U10 ( .A(reg2[2]), .Z(add_49_n6) );
  NOR2_X1 add_49_U9 ( .A1(add_49_n78), .A2(add_49_n35), .ZN(add_49_n4) );
  AND2_X1 add_49_U8 ( .A1(add_49_n4), .A2(add_49_n79), .ZN(add_49_n76) );
  AND2_X1 add_49_U7 ( .A1(add_49_n58), .A2(add_49_n55), .ZN(add_49_n3) );
  XNOR2_X1 add_49_U6 ( .A(add_49_n9), .B(add_49_n3), .ZN(N41) );
  AND2_X1 add_49_U5 ( .A1(add_49_n54), .A2(add_49_n25), .ZN(N39) );
  OR2_X2 add_49_U4 ( .A1(reg1[1]), .A2(reg2[1]), .ZN(add_49_n75) );
  OR2_X2 add_49_U3 ( .A1(reg2[4]), .A2(n154), .ZN(add_49_n39) );
  BUF_X1 add_49_U2 ( .A(reg2[1]), .Z(add_49_n1) );
endmodule

