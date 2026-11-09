/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 02:39:13 2025
/////////////////////////////////////////////////////////////


module alu_8bit_ref ( a, b, Oper, sum );
  input [7:0] a;
  input [7:0] b;
  input [2:0] Oper;
  output [7:0] sum;
  wire   carry, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69,
         n70, n71, n72, n73, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
         n144, n145, n146, n147, n148, n149, n150, n151, n152, n153, n154,
         n155, n156, n157, n158, n159, n160, n161, n162, n163, n164, n165,
         n166, n167, n168, n169, n170, n171, n172, n173, n174, n175, n176,
         n177, n178, n179, n180, n181, n182, add_1_root_add_10_2_n87,
         add_1_root_add_10_2_n86, add_1_root_add_10_2_n85,
         add_1_root_add_10_2_n84, add_1_root_add_10_2_n83,
         add_1_root_add_10_2_n82, add_1_root_add_10_2_n81,
         add_1_root_add_10_2_n80, add_1_root_add_10_2_n79,
         add_1_root_add_10_2_n78, add_1_root_add_10_2_n77,
         add_1_root_add_10_2_n76, add_1_root_add_10_2_n75,
         add_1_root_add_10_2_n74, add_1_root_add_10_2_n73,
         add_1_root_add_10_2_n72, add_1_root_add_10_2_n71,
         add_1_root_add_10_2_n70, add_1_root_add_10_2_n69,
         add_1_root_add_10_2_n68, add_1_root_add_10_2_n67,
         add_1_root_add_10_2_n66, add_1_root_add_10_2_n65,
         add_1_root_add_10_2_n64, add_1_root_add_10_2_n63,
         add_1_root_add_10_2_n62, add_1_root_add_10_2_n61,
         add_1_root_add_10_2_n60, add_1_root_add_10_2_n59,
         add_1_root_add_10_2_n58, add_1_root_add_10_2_n57,
         add_1_root_add_10_2_n56, add_1_root_add_10_2_n55,
         add_1_root_add_10_2_n54, add_1_root_add_10_2_n53,
         add_1_root_add_10_2_n52, add_1_root_add_10_2_n51,
         add_1_root_add_10_2_n50, add_1_root_add_10_2_n49,
         add_1_root_add_10_2_n48, add_1_root_add_10_2_n47,
         add_1_root_add_10_2_n46, add_1_root_add_10_2_n45,
         add_1_root_add_10_2_n44, add_1_root_add_10_2_n43,
         add_1_root_add_10_2_n42, add_1_root_add_10_2_n41,
         add_1_root_add_10_2_n40, add_1_root_add_10_2_n39,
         add_1_root_add_10_2_n38, add_1_root_add_10_2_n37,
         add_1_root_add_10_2_n36, add_1_root_add_10_2_n35,
         add_1_root_add_10_2_n34, add_1_root_add_10_2_n33,
         add_1_root_add_10_2_n32, add_1_root_add_10_2_n31,
         add_1_root_add_10_2_n30, add_1_root_add_10_2_n29,
         add_1_root_add_10_2_n28, add_1_root_add_10_2_n27,
         add_1_root_add_10_2_n26, add_1_root_add_10_2_n25,
         add_1_root_add_10_2_n24, add_1_root_add_10_2_n23,
         add_1_root_add_10_2_n22, add_1_root_add_10_2_n21,
         add_1_root_add_10_2_n20, add_1_root_add_10_2_n19,
         add_1_root_add_10_2_n18, add_1_root_add_10_2_n17,
         add_1_root_add_10_2_n16, add_1_root_add_10_2_n15,
         add_1_root_add_10_2_n14, add_1_root_add_10_2_n13,
         add_1_root_add_10_2_n12, add_1_root_add_10_2_n11,
         add_1_root_add_10_2_n10, add_1_root_add_10_2_n9,
         add_1_root_add_10_2_n8, add_1_root_add_10_2_n7,
         add_1_root_add_10_2_n6, add_1_root_add_10_2_n5,
         add_1_root_add_10_2_n4, add_1_root_add_10_2_n3,
         add_1_root_add_10_2_n2, add_1_root_add_10_2_n1;
  wire   [7:0] op_a;
  wire   [7:0] op_b;
  wire   [7:0] adder_result;

  OR2_X4 U83 ( .A1(n129), .A2(n69), .ZN(n176) );
  BUF_X1 U84 ( .A(n58), .Z(n64) );
  BUF_X1 U85 ( .A(b[5]), .Z(n63) );
  INV_X1 U86 ( .A(Oper[2]), .ZN(n99) );
  BUF_X1 U87 ( .A(Oper[0]), .Z(n58) );
  NAND2_X1 U88 ( .A1(n59), .A2(n60), .ZN(n97) );
  INV_X1 U89 ( .A(Oper[0]), .ZN(n59) );
  INV_X1 U90 ( .A(Oper[2]), .ZN(n60) );
  BUF_X1 U91 ( .A(n70), .Z(n62) );
  INV_X1 U92 ( .A(b[5]), .ZN(n61) );
  NAND2_X1 U93 ( .A1(Oper[0]), .A2(n66), .ZN(n67) );
  NAND2_X1 U94 ( .A1(n65), .A2(b[4]), .ZN(n68) );
  NAND2_X1 U95 ( .A1(n67), .A2(n68), .ZN(n109) );
  INV_X1 U96 ( .A(Oper[0]), .ZN(n65) );
  INV_X1 U97 ( .A(b[4]), .ZN(n66) );
  XNOR2_X1 U98 ( .A(n58), .B(b[2]), .ZN(n116) );
  BUF_X1 U99 ( .A(Oper[2]), .Z(n69) );
  XNOR2_X1 U100 ( .A(n80), .B(n92), .ZN(n113) );
  INV_X2 U101 ( .A(Oper[0]), .ZN(n130) );
  NAND2_X1 U102 ( .A1(n73), .A2(Oper[1]), .ZN(n70) );
  NAND2_X1 U103 ( .A1(n73), .A2(Oper[1]), .ZN(n125) );
  XNOR2_X1 U104 ( .A(n61), .B(Oper[0]), .ZN(n107) );
  BUF_X1 U105 ( .A(n82), .Z(n71) );
  BUF_X1 U106 ( .A(n79), .Z(n72) );
  NOR2_X1 U107 ( .A1(Oper[0]), .A2(Oper[2]), .ZN(n73) );
  NAND3_X1 U108 ( .A1(n75), .A2(n76), .A3(n77), .ZN(sum[5]) );
  AND2_X1 U109 ( .A1(n129), .A2(n83), .ZN(n78) );
  NAND2_X1 U110 ( .A1(adder_result[5]), .A2(n78), .ZN(n75) );
  NAND2_X1 U111 ( .A1(a[5]), .A2(n164), .ZN(n76) );
  INV_X1 U112 ( .A(n163), .ZN(n77) );
  NAND2_X1 U113 ( .A1(a[6]), .A2(n166), .ZN(n172) );
  INV_X1 U114 ( .A(n169), .ZN(n171) );
  NAND2_X1 U115 ( .A1(n101), .A2(n100), .ZN(op_a[0]) );
  NOR2_X1 U116 ( .A1(a[6]), .A2(n175), .ZN(n168) );
  OAI21_X1 U117 ( .B1(a[6]), .B2(n177), .A(n176), .ZN(n167) );
  NAND2_X1 U118 ( .A1(n165), .A2(n176), .ZN(n166) );
  INV_X1 U119 ( .A(Oper[2]), .ZN(n128) );
  INV_X1 U120 ( .A(Oper[0]), .ZN(n79) );
  INV_X1 U121 ( .A(Oper[0]), .ZN(n80) );
  INV_X1 U122 ( .A(Oper[1]), .ZN(n81) );
  INV_X1 U123 ( .A(Oper[1]), .ZN(n126) );
  INV_X1 U124 ( .A(Oper[0]), .ZN(n82) );
  INV_X1 U125 ( .A(Oper[2]), .ZN(n83) );
  INV_X1 U126 ( .A(Oper[1]), .ZN(n98) );
  OR2_X2 U127 ( .A1(Oper[1]), .A2(Oper[2]), .ZN(n95) );
  OR2_X1 U128 ( .A1(Oper[0]), .A2(Oper[2]), .ZN(n93) );
  NAND2_X1 U129 ( .A1(adder_result[6]), .A2(n78), .ZN(n170) );
  NAND4_X1 U130 ( .A1(n72), .A2(n83), .A3(Oper[1]), .A4(b[0]), .ZN(n100) );
  NAND3_X2 U131 ( .A1(n64), .A2(Oper[2]), .A3(n126), .ZN(n177) );
  INV_X1 U132 ( .A(a[7]), .ZN(n85) );
  INV_X1 U133 ( .A(b[7]), .ZN(n84) );
  OAI22_X1 U134 ( .A1(n85), .A2(n95), .B1(n62), .B2(n84), .ZN(op_a[7]) );
  INV_X1 U135 ( .A(a[6]), .ZN(n87) );
  NAND4_X1 U136 ( .A1(b[6]), .A2(Oper[1]), .A3(n130), .A4(n99), .ZN(n86) );
  OAI21_X1 U137 ( .B1(n87), .B2(n95), .A(n86), .ZN(op_a[6]) );
  INV_X1 U138 ( .A(a[5]), .ZN(n89) );
  INV_X1 U139 ( .A(b[5]), .ZN(n88) );
  OAI22_X1 U140 ( .A1(n89), .A2(n95), .B1(n125), .B2(n88), .ZN(op_a[5]) );
  INV_X1 U141 ( .A(a[4]), .ZN(n91) );
  INV_X1 U142 ( .A(b[4]), .ZN(n90) );
  OAI22_X1 U143 ( .A1(n91), .A2(n95), .B1(n125), .B2(n90), .ZN(op_a[4]) );
  INV_X1 U144 ( .A(a[3]), .ZN(n111) );
  INV_X1 U145 ( .A(b[3]), .ZN(n92) );
  OAI33_X1 U146 ( .A1(Oper[1]), .A2(Oper[2]), .A3(n111), .B1(n93), .B2(n81), 
        .B3(n92), .ZN(op_a[3]) );
  INV_X1 U147 ( .A(a[2]), .ZN(n114) );
  NAND4_X1 U148 ( .A1(n71), .A2(Oper[1]), .A3(b[2]), .A4(n99), .ZN(n94) );
  OAI21_X1 U149 ( .B1(n114), .B2(n95), .A(n94), .ZN(op_a[2]) );
  INV_X1 U150 ( .A(a[1]), .ZN(n117) );
  INV_X1 U151 ( .A(b[1]), .ZN(n96) );
  OAI33_X1 U152 ( .A1(Oper[1]), .A2(Oper[2]), .A3(n117), .B1(n97), .B2(n98), 
        .B3(n96), .ZN(op_a[1]) );
  NAND3_X1 U153 ( .A1(n128), .A2(n81), .A3(a[0]), .ZN(n101) );
  NAND3_X1 U154 ( .A1(n64), .A2(n128), .A3(n126), .ZN(n124) );
  NAND2_X1 U155 ( .A1(n126), .A2(n99), .ZN(n105) );
  INV_X1 U156 ( .A(n105), .ZN(n102) );
  NAND2_X1 U157 ( .A1(n102), .A2(n130), .ZN(n103) );
  MUX2_X1 U158 ( .A(n124), .B(n103), .S(b[7]), .Z(n104) );
  OAI21_X1 U159 ( .B1(a[7]), .B2(n62), .A(n104), .ZN(op_b[7]) );
  XOR2_X1 U160 ( .A(n82), .B(b[6]), .Z(n106) );
  OAI22_X1 U161 ( .A1(a[6]), .A2(n125), .B1(n106), .B2(n105), .ZN(op_b[6]) );
  NAND3_X1 U162 ( .A1(n107), .A2(n126), .A3(n99), .ZN(n108) );
  OAI21_X1 U163 ( .B1(a[5]), .B2(n70), .A(n108), .ZN(op_b[5]) );
  NAND3_X1 U164 ( .A1(n109), .A2(n126), .A3(n128), .ZN(n110) );
  OAI21_X1 U165 ( .B1(a[4]), .B2(n70), .A(n110), .ZN(op_b[4]) );
  NAND2_X1 U166 ( .A1(n98), .A2(n83), .ZN(n122) );
  NAND4_X1 U167 ( .A1(n130), .A2(n111), .A3(Oper[1]), .A4(n128), .ZN(n112) );
  OAI21_X1 U168 ( .B1(n113), .B2(n122), .A(n112), .ZN(op_b[3]) );
  NAND4_X1 U169 ( .A1(Oper[1]), .A2(n114), .A3(n130), .A4(n128), .ZN(n115) );
  OAI21_X1 U170 ( .B1(n116), .B2(n122), .A(n115), .ZN(op_b[2]) );
  XOR2_X1 U171 ( .A(n80), .B(b[1]), .Z(n119) );
  NAND4_X1 U172 ( .A1(n72), .A2(n117), .A3(Oper[1]), .A4(n128), .ZN(n118) );
  OAI21_X1 U173 ( .B1(n119), .B2(n122), .A(n118), .ZN(op_b[1]) );
  XOR2_X1 U174 ( .A(n79), .B(b[0]), .Z(n123) );
  INV_X1 U175 ( .A(a[0]), .ZN(n120) );
  NAND4_X1 U176 ( .A1(Oper[1]), .A2(n120), .A3(n130), .A4(n99), .ZN(n121) );
  OAI21_X1 U177 ( .B1(n123), .B2(n122), .A(n121), .ZN(op_b[0]) );
  NAND2_X1 U178 ( .A1(n70), .A2(n124), .ZN(carry) );
  NAND2_X1 U179 ( .A1(n69), .A2(n71), .ZN(n173) );
  MUX2_X1 U180 ( .A(n177), .B(n173), .S(b[0]), .Z(n127) );
  NAND2_X1 U181 ( .A1(n64), .A2(Oper[1]), .ZN(n129) );
  NAND2_X1 U182 ( .A1(n127), .A2(n176), .ZN(n134) );
  NAND3_X1 U183 ( .A1(n69), .A2(Oper[1]), .A3(n130), .ZN(n175) );
  NOR2_X1 U184 ( .A1(a[0]), .A2(n175), .ZN(n132) );
  OAI21_X1 U185 ( .B1(a[0]), .B2(n177), .A(n176), .ZN(n131) );
  MUX2_X1 U186 ( .A(n132), .B(n131), .S(b[0]), .Z(n133) );
  AOI221_X1 U187 ( .B1(a[0]), .B2(n134), .C1(adder_result[0]), .C2(n78), .A(
        n133), .ZN(n135) );
  INV_X1 U188 ( .A(n135), .ZN(sum[0]) );
  MUX2_X1 U189 ( .A(n177), .B(n173), .S(b[1]), .Z(n136) );
  NAND2_X1 U190 ( .A1(n136), .A2(n176), .ZN(n140) );
  NOR2_X1 U191 ( .A1(a[1]), .A2(n175), .ZN(n138) );
  OAI21_X1 U192 ( .B1(a[1]), .B2(n177), .A(n176), .ZN(n137) );
  MUX2_X1 U193 ( .A(n138), .B(n137), .S(b[1]), .Z(n139) );
  AOI221_X1 U194 ( .B1(a[1]), .B2(n140), .C1(adder_result[1]), .C2(n78), .A(
        n139), .ZN(n141) );
  INV_X1 U195 ( .A(n141), .ZN(sum[1]) );
  MUX2_X1 U196 ( .A(n177), .B(n173), .S(b[2]), .Z(n142) );
  NAND2_X1 U197 ( .A1(n142), .A2(n176), .ZN(n146) );
  NOR2_X1 U198 ( .A1(a[2]), .A2(n175), .ZN(n144) );
  OAI21_X1 U199 ( .B1(a[2]), .B2(n177), .A(n176), .ZN(n143) );
  MUX2_X1 U200 ( .A(n144), .B(n143), .S(b[2]), .Z(n145) );
  AOI221_X1 U201 ( .B1(a[2]), .B2(n146), .C1(adder_result[2]), .C2(n78), .A(
        n145), .ZN(n147) );
  INV_X1 U202 ( .A(n147), .ZN(sum[2]) );
  MUX2_X1 U203 ( .A(n177), .B(n173), .S(b[3]), .Z(n148) );
  NAND2_X1 U204 ( .A1(n148), .A2(n176), .ZN(n152) );
  NOR2_X1 U205 ( .A1(a[3]), .A2(n175), .ZN(n150) );
  OAI21_X1 U206 ( .B1(a[3]), .B2(n177), .A(n176), .ZN(n149) );
  MUX2_X1 U207 ( .A(n150), .B(n149), .S(b[3]), .Z(n151) );
  AOI221_X1 U208 ( .B1(adder_result[3]), .B2(n78), .C1(a[3]), .C2(n152), .A(
        n151), .ZN(n153) );
  INV_X1 U209 ( .A(n153), .ZN(sum[3]) );
  MUX2_X1 U210 ( .A(n177), .B(n173), .S(b[4]), .Z(n154) );
  NAND2_X1 U211 ( .A1(n154), .A2(n176), .ZN(n158) );
  NOR2_X1 U212 ( .A1(a[4]), .A2(n175), .ZN(n156) );
  OAI21_X1 U213 ( .B1(a[4]), .B2(n177), .A(n176), .ZN(n155) );
  MUX2_X1 U214 ( .A(n156), .B(n155), .S(b[4]), .Z(n157) );
  AOI221_X1 U215 ( .B1(a[4]), .B2(n158), .C1(adder_result[4]), .C2(n78), .A(
        n157), .ZN(n159) );
  INV_X1 U216 ( .A(n159), .ZN(sum[4]) );
  MUX2_X1 U217 ( .A(n177), .B(n173), .S(n63), .Z(n160) );
  NAND2_X1 U218 ( .A1(n160), .A2(n176), .ZN(n164) );
  NOR2_X1 U219 ( .A1(a[5]), .A2(n175), .ZN(n162) );
  OAI21_X1 U220 ( .B1(a[5]), .B2(n177), .A(n176), .ZN(n161) );
  MUX2_X1 U221 ( .A(n162), .B(n161), .S(n63), .Z(n163) );
  MUX2_X1 U222 ( .A(n177), .B(n173), .S(b[6]), .Z(n165) );
  MUX2_X1 U223 ( .A(n168), .B(n167), .S(b[6]), .Z(n169) );
  NAND3_X1 U224 ( .A1(n170), .A2(n171), .A3(n172), .ZN(sum[6]) );
  MUX2_X1 U225 ( .A(n177), .B(n173), .S(b[7]), .Z(n174) );
  NAND2_X1 U226 ( .A1(n174), .A2(n176), .ZN(n181) );
  NOR2_X1 U227 ( .A1(a[7]), .A2(n175), .ZN(n179) );
  OAI21_X1 U228 ( .B1(a[7]), .B2(n177), .A(n176), .ZN(n178) );
  MUX2_X1 U229 ( .A(n179), .B(n178), .S(b[7]), .Z(n180) );
  AOI221_X1 U230 ( .B1(adder_result[7]), .B2(n78), .C1(a[7]), .C2(n181), .A(
        n180), .ZN(n182) );
  INV_X1 U231 ( .A(n182), .ZN(sum[7]) );
  INV_X1 add_1_root_add_10_2_U96 ( .A(add_1_root_add_10_2_n77), .ZN(
        add_1_root_add_10_2_n41) );
  INV_X1 add_1_root_add_10_2_U95 ( .A(add_1_root_add_10_2_n84), .ZN(
        add_1_root_add_10_2_n82) );
  INV_X1 add_1_root_add_10_2_U94 ( .A(add_1_root_add_10_2_n72), .ZN(
        add_1_root_add_10_2_n83) );
  OAI21_X1 add_1_root_add_10_2_U93 ( .B1(add_1_root_add_10_2_n82), .B2(
        add_1_root_add_10_2_n83), .A(add_1_root_add_10_2_n76), .ZN(
        add_1_root_add_10_2_n80) );
  XNOR2_X1 add_1_root_add_10_2_U92 ( .A(add_1_root_add_10_2_n80), .B(
        add_1_root_add_10_2_n81), .ZN(adder_result[3]) );
  INV_X1 add_1_root_add_10_2_U91 ( .A(add_1_root_add_10_2_n76), .ZN(
        add_1_root_add_10_2_n75) );
  INV_X1 add_1_root_add_10_2_U90 ( .A(add_1_root_add_10_2_n74), .ZN(
        add_1_root_add_10_2_n50) );
  INV_X1 add_1_root_add_10_2_U89 ( .A(add_1_root_add_10_2_n54), .ZN(
        add_1_root_add_10_2_n64) );
  INV_X1 add_1_root_add_10_2_U88 ( .A(add_1_root_add_10_2_n55), .ZN(
        add_1_root_add_10_2_n61) );
  INV_X1 add_1_root_add_10_2_U87 ( .A(add_1_root_add_10_2_n27), .ZN(
        add_1_root_add_10_2_n53) );
  XNOR2_X1 add_1_root_add_10_2_U86 ( .A(add_1_root_add_10_2_n51), .B(
        add_1_root_add_10_2_n52), .ZN(adder_result[6]) );
  INV_X1 add_1_root_add_10_2_U85 ( .A(add_1_root_add_10_2_n12), .ZN(
        add_1_root_add_10_2_n42) );
  NAND3_X1 add_1_root_add_10_2_U84 ( .A1(add_1_root_add_10_2_n47), .A2(
        add_1_root_add_10_2_n22), .A3(add_1_root_add_10_2_n11), .ZN(
        add_1_root_add_10_2_n36) );
  INV_X1 add_1_root_add_10_2_U83 ( .A(add_1_root_add_10_2_n46), .ZN(
        add_1_root_add_10_2_n45) );
  NAND4_X1 add_1_root_add_10_2_U82 ( .A1(add_1_root_add_10_2_n3), .A2(
        add_1_root_add_10_2_n24), .A3(add_1_root_add_10_2_n39), .A4(
        add_1_root_add_10_2_n30), .ZN(add_1_root_add_10_2_n38) );
  XNOR2_X1 add_1_root_add_10_2_U81 ( .A(add_1_root_add_10_2_n33), .B(
        add_1_root_add_10_2_n34), .ZN(adder_result[7]) );
  NAND2_X1 add_1_root_add_10_2_U80 ( .A1(op_a[1]), .A2(op_b[1]), .ZN(
        add_1_root_add_10_2_n70) );
  INV_X1 add_1_root_add_10_2_U79 ( .A(op_a[1]), .ZN(add_1_root_add_10_2_n79)
         );
  XNOR2_X1 add_1_root_add_10_2_U78 ( .A(add_1_root_add_10_2_n59), .B(
        add_1_root_add_10_2_n60), .ZN(adder_result[5]) );
  NAND2_X1 add_1_root_add_10_2_U77 ( .A1(add_1_root_add_10_2_n74), .A2(
        add_1_root_add_10_2_n8), .ZN(add_1_root_add_10_2_n81) );
  NOR2_X1 add_1_root_add_10_2_U76 ( .A1(add_1_root_add_10_2_n10), .A2(
        add_1_root_add_10_2_n42), .ZN(add_1_root_add_10_2_n48) );
  OAI21_X1 add_1_root_add_10_2_U75 ( .B1(add_1_root_add_10_2_n32), .B2(
        add_1_root_add_10_2_n29), .A(add_1_root_add_10_2_n53), .ZN(
        add_1_root_add_10_2_n51) );
  NAND2_X1 add_1_root_add_10_2_U74 ( .A1(add_1_root_add_10_2_n70), .A2(
        add_1_root_add_10_2_n71), .ZN(add_1_root_add_10_2_n40) );
  OAI21_X1 add_1_root_add_10_2_U73 ( .B1(add_1_root_add_10_2_n28), .B2(
        add_1_root_add_10_2_n41), .A(add_1_root_add_10_2_n18), .ZN(
        add_1_root_add_10_2_n84) );
  NAND2_X1 add_1_root_add_10_2_U72 ( .A1(add_1_root_add_10_2_n78), .A2(
        add_1_root_add_10_2_n79), .ZN(add_1_root_add_10_2_n77) );
  NAND2_X1 add_1_root_add_10_2_U71 ( .A1(add_1_root_add_10_2_n79), .A2(
        add_1_root_add_10_2_n78), .ZN(add_1_root_add_10_2_n69) );
  NAND2_X1 add_1_root_add_10_2_U70 ( .A1(op_b[0]), .A2(op_a[0]), .ZN(
        add_1_root_add_10_2_n71) );
  AOI21_X1 add_1_root_add_10_2_U69 ( .B1(add_1_root_add_10_2_n58), .B2(
        add_1_root_add_10_2_n31), .A(add_1_root_add_10_2_n64), .ZN(
        add_1_root_add_10_2_n59) );
  NAND4_X1 add_1_root_add_10_2_U68 ( .A1(add_1_root_add_10_2_n35), .A2(
        add_1_root_add_10_2_n37), .A3(add_1_root_add_10_2_n36), .A4(
        add_1_root_add_10_2_n38), .ZN(add_1_root_add_10_2_n33) );
  NAND2_X1 add_1_root_add_10_2_U67 ( .A1(op_b[2]), .A2(op_a[2]), .ZN(
        add_1_root_add_10_2_n76) );
  AOI21_X1 add_1_root_add_10_2_U66 ( .B1(add_1_root_add_10_2_n48), .B2(
        add_1_root_add_10_2_n20), .A(add_1_root_add_10_2_n49), .ZN(
        add_1_root_add_10_2_n35) );
  NAND2_X1 add_1_root_add_10_2_U65 ( .A1(op_a[3]), .A2(op_b[3]), .ZN(
        add_1_root_add_10_2_n74) );
  NOR2_X1 add_1_root_add_10_2_U64 ( .A1(add_1_root_add_10_2_n68), .A2(
        add_1_root_add_10_2_n50), .ZN(add_1_root_add_10_2_n67) );
  INV_X1 add_1_root_add_10_2_U63 ( .A(op_a[5]), .ZN(add_1_root_add_10_2_n63)
         );
  NAND2_X1 add_1_root_add_10_2_U62 ( .A1(add_1_root_add_10_2_n16), .A2(op_a[5]), .ZN(add_1_root_add_10_2_n55) );
  XNOR2_X1 add_1_root_add_10_2_U61 ( .A(add_1_root_add_10_2_n9), .B(
        add_1_root_add_10_2_n85), .ZN(adder_result[2]) );
  AOI21_X1 add_1_root_add_10_2_U60 ( .B1(add_1_root_add_10_2_n43), .B2(
        add_1_root_add_10_2_n2), .A(add_1_root_add_10_2_n45), .ZN(
        add_1_root_add_10_2_n37) );
  AOI21_X1 add_1_root_add_10_2_U59 ( .B1(add_1_root_add_10_2_n19), .B2(
        add_1_root_add_10_2_n22), .A(add_1_root_add_10_2_n20), .ZN(
        add_1_root_add_10_2_n66) );
  NAND2_X1 add_1_root_add_10_2_U58 ( .A1(add_1_root_add_10_2_n67), .A2(
        add_1_root_add_10_2_n66), .ZN(add_1_root_add_10_2_n58) );
  NAND2_X1 add_1_root_add_10_2_U57 ( .A1(add_1_root_add_10_2_n17), .A2(op_a[6]), .ZN(add_1_root_add_10_2_n46) );
  AND2_X1 add_1_root_add_10_2_U56 ( .A1(add_1_root_add_10_2_n67), .A2(
        add_1_root_add_10_2_n66), .ZN(add_1_root_add_10_2_n32) );
  CLKBUF_X1 add_1_root_add_10_2_U55 ( .A(add_1_root_add_10_2_n57), .Z(
        add_1_root_add_10_2_n31) );
  CLKBUF_X1 add_1_root_add_10_2_U54 ( .A(add_1_root_add_10_2_n40), .Z(
        add_1_root_add_10_2_n30) );
  INV_X1 add_1_root_add_10_2_U53 ( .A(op_b[5]), .ZN(add_1_root_add_10_2_n62)
         );
  NAND2_X1 add_1_root_add_10_2_U52 ( .A1(add_1_root_add_10_2_n13), .A2(
        add_1_root_add_10_2_n63), .ZN(add_1_root_add_10_2_n56) );
  INV_X1 add_1_root_add_10_2_U51 ( .A(add_1_root_add_10_2_n24), .ZN(
        add_1_root_add_10_2_n29) );
  NAND2_X1 add_1_root_add_10_2_U50 ( .A1(add_1_root_add_10_2_n54), .A2(
        add_1_root_add_10_2_n31), .ZN(add_1_root_add_10_2_n65) );
  OAI21_X1 add_1_root_add_10_2_U49 ( .B1(add_1_root_add_10_2_n15), .B2(
        add_1_root_add_10_2_n54), .A(add_1_root_add_10_2_n55), .ZN(
        add_1_root_add_10_2_n43) );
  OAI21_X1 add_1_root_add_10_2_U48 ( .B1(add_1_root_add_10_2_n23), .B2(
        add_1_root_add_10_2_n54), .A(add_1_root_add_10_2_n5), .ZN(
        add_1_root_add_10_2_n27) );
  NAND2_X1 add_1_root_add_10_2_U47 ( .A1(add_1_root_add_10_2_n62), .A2(
        add_1_root_add_10_2_n63), .ZN(add_1_root_add_10_2_n26) );
  INV_X1 add_1_root_add_10_2_U46 ( .A(op_b[1]), .ZN(add_1_root_add_10_2_n78)
         );
  CLKBUF_X1 add_1_root_add_10_2_U45 ( .A(add_1_root_add_10_2_n71), .Z(
        add_1_root_add_10_2_n25) );
  AND2_X1 add_1_root_add_10_2_U44 ( .A1(add_1_root_add_10_2_n69), .A2(
        add_1_root_add_10_2_n12), .ZN(add_1_root_add_10_2_n39) );
  AND2_X1 add_1_root_add_10_2_U43 ( .A1(add_1_root_add_10_2_n26), .A2(
        add_1_root_add_10_2_n14), .ZN(add_1_root_add_10_2_n24) );
  AND2_X1 add_1_root_add_10_2_U42 ( .A1(carry), .A2(add_1_root_add_10_2_n86), 
        .ZN(add_1_root_add_10_2_n22) );
  NAND2_X1 add_1_root_add_10_2_U41 ( .A1(add_1_root_add_10_2_n46), .A2(
        add_1_root_add_10_2_n2), .ZN(add_1_root_add_10_2_n52) );
  OR2_X2 add_1_root_add_10_2_U40 ( .A1(op_a[2]), .A2(op_b[2]), .ZN(
        add_1_root_add_10_2_n72) );
  OR2_X2 add_1_root_add_10_2_U39 ( .A1(op_b[3]), .A2(op_a[3]), .ZN(
        add_1_root_add_10_2_n73) );
  XNOR2_X1 add_1_root_add_10_2_U38 ( .A(op_b[7]), .B(op_a[7]), .ZN(
        add_1_root_add_10_2_n34) );
  AND2_X1 add_1_root_add_10_2_U37 ( .A1(add_1_root_add_10_2_n6), .A2(
        add_1_root_add_10_2_n18), .ZN(add_1_root_add_10_2_n21) );
  NAND2_X1 add_1_root_add_10_2_U36 ( .A1(add_1_root_add_10_2_n25), .A2(
        add_1_root_add_10_2_n86), .ZN(add_1_root_add_10_2_n87) );
  XNOR2_X1 add_1_root_add_10_2_U35 ( .A(add_1_root_add_10_2_n87), .B(carry), 
        .ZN(adder_result[0]) );
  NAND2_X1 add_1_root_add_10_2_U34 ( .A1(add_1_root_add_10_2_n76), .A2(
        add_1_root_add_10_2_n72), .ZN(add_1_root_add_10_2_n85) );
  AND2_X1 add_1_root_add_10_2_U33 ( .A1(add_1_root_add_10_2_n75), .A2(
        add_1_root_add_10_2_n73), .ZN(add_1_root_add_10_2_n20) );
  NOR2_X1 add_1_root_add_10_2_U32 ( .A1(add_1_root_add_10_2_n23), .A2(
        add_1_root_add_10_2_n61), .ZN(add_1_root_add_10_2_n60) );
  AND3_X1 add_1_root_add_10_2_U31 ( .A1(add_1_root_add_10_2_n69), .A2(
        add_1_root_add_10_2_n73), .A3(add_1_root_add_10_2_n72), .ZN(
        add_1_root_add_10_2_n19) );
  CLKBUF_X1 add_1_root_add_10_2_U30 ( .A(op_b[6]), .Z(add_1_root_add_10_2_n17)
         );
  OR2_X1 add_1_root_add_10_2_U29 ( .A1(op_b[4]), .A2(op_a[4]), .ZN(
        add_1_root_add_10_2_n57) );
  OR2_X1 add_1_root_add_10_2_U28 ( .A1(op_b[4]), .A2(op_a[4]), .ZN(
        add_1_root_add_10_2_n14) );
  INV_X1 add_1_root_add_10_2_U27 ( .A(op_b[5]), .ZN(add_1_root_add_10_2_n13)
         );
  OR2_X1 add_1_root_add_10_2_U26 ( .A1(op_b[6]), .A2(op_a[6]), .ZN(
        add_1_root_add_10_2_n44) );
  AND3_X1 add_1_root_add_10_2_U25 ( .A1(add_1_root_add_10_2_n69), .A2(
        add_1_root_add_10_2_n73), .A3(add_1_root_add_10_2_n72), .ZN(
        add_1_root_add_10_2_n11) );
  NAND2_X1 add_1_root_add_10_2_U24 ( .A1(add_1_root_add_10_2_n56), .A2(
        add_1_root_add_10_2_n14), .ZN(add_1_root_add_10_2_n10) );
  CLKBUF_X1 add_1_root_add_10_2_U23 ( .A(add_1_root_add_10_2_n84), .Z(
        add_1_root_add_10_2_n9) );
  CLKBUF_X1 add_1_root_add_10_2_U22 ( .A(add_1_root_add_10_2_n70), .Z(
        add_1_root_add_10_2_n18) );
  CLKBUF_X1 add_1_root_add_10_2_U21 ( .A(add_1_root_add_10_2_n73), .Z(
        add_1_root_add_10_2_n8) );
  AND4_X1 add_1_root_add_10_2_U20 ( .A1(add_1_root_add_10_2_n40), .A2(
        add_1_root_add_10_2_n77), .A3(add_1_root_add_10_2_n72), .A4(
        add_1_root_add_10_2_n73), .ZN(add_1_root_add_10_2_n68) );
  XNOR2_X1 add_1_root_add_10_2_U19 ( .A(add_1_root_add_10_2_n58), .B(
        add_1_root_add_10_2_n65), .ZN(adder_result[4]) );
  AND4_X1 add_1_root_add_10_2_U18 ( .A1(add_1_root_add_10_2_n56), .A2(
        add_1_root_add_10_2_n57), .A3(add_1_root_add_10_2_n44), .A4(
        add_1_root_add_10_2_n50), .ZN(add_1_root_add_10_2_n49) );
  AND3_X1 add_1_root_add_10_2_U17 ( .A1(add_1_root_add_10_2_n2), .A2(
        add_1_root_add_10_2_n26), .A3(add_1_root_add_10_2_n14), .ZN(
        add_1_root_add_10_2_n47) );
  NAND2_X1 add_1_root_add_10_2_U16 ( .A1(op_b[4]), .A2(op_a[4]), .ZN(
        add_1_root_add_10_2_n54) );
  INV_X1 add_1_root_add_10_2_U15 ( .A(add_1_root_add_10_2_n71), .ZN(
        add_1_root_add_10_2_n7) );
  AOI21_X1 add_1_root_add_10_2_U14 ( .B1(carry), .B2(add_1_root_add_10_2_n86), 
        .A(add_1_root_add_10_2_n7), .ZN(add_1_root_add_10_2_n28) );
  CLKBUF_X1 add_1_root_add_10_2_U13 ( .A(add_1_root_add_10_2_n69), .Z(
        add_1_root_add_10_2_n6) );
  BUF_X1 add_1_root_add_10_2_U12 ( .A(op_b[5]), .Z(add_1_root_add_10_2_n16) );
  INV_X1 add_1_root_add_10_2_U11 ( .A(add_1_root_add_10_2_n61), .ZN(
        add_1_root_add_10_2_n5) );
  BUF_X1 add_1_root_add_10_2_U10 ( .A(add_1_root_add_10_2_n15), .Z(
        add_1_root_add_10_2_n23) );
  AND2_X1 add_1_root_add_10_2_U9 ( .A1(add_1_root_add_10_2_n62), .A2(
        add_1_root_add_10_2_n63), .ZN(add_1_root_add_10_2_n15) );
  AND2_X1 add_1_root_add_10_2_U8 ( .A1(add_1_root_add_10_2_n1), .A2(
        add_1_root_add_10_2_n25), .ZN(add_1_root_add_10_2_n4) );
  XNOR2_X1 add_1_root_add_10_2_U7 ( .A(add_1_root_add_10_2_n4), .B(
        add_1_root_add_10_2_n21), .ZN(adder_result[1]) );
  AND2_X1 add_1_root_add_10_2_U6 ( .A1(add_1_root_add_10_2_n72), .A2(
        add_1_root_add_10_2_n73), .ZN(add_1_root_add_10_2_n3) );
  OR2_X1 add_1_root_add_10_2_U5 ( .A1(op_b[6]), .A2(op_a[6]), .ZN(
        add_1_root_add_10_2_n12) );
  OR2_X1 add_1_root_add_10_2_U4 ( .A1(op_b[6]), .A2(op_a[6]), .ZN(
        add_1_root_add_10_2_n2) );
  OR2_X2 add_1_root_add_10_2_U3 ( .A1(op_b[0]), .A2(op_a[0]), .ZN(
        add_1_root_add_10_2_n86) );
  NAND2_X1 add_1_root_add_10_2_U2 ( .A1(carry), .A2(add_1_root_add_10_2_n86), 
        .ZN(add_1_root_add_10_2_n1) );
endmodule

