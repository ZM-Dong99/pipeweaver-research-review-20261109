/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:34:47 2025
/////////////////////////////////////////////////////////////


module mux_large_dsr ( block_a, block_b, block_c, block_d, block_e, block_f, 
        block_g, block_h, block_i, block_j, sel, block_out );
  input [7:0] block_a;
  input [7:0] block_b;
  input [7:0] block_c;
  input [7:0] block_d;
  input [7:0] block_e;
  input [7:0] block_f;
  input [7:0] block_g;
  input [7:0] block_h;
  input [7:0] block_i;
  input [7:0] block_j;
  input [3:0] sel;
  output [7:0] block_out;
  wire   n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80,
         n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94,
         n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106,
         n107, n108, n109, n110, n111, n112, n113, n114, n115, n116, n117,
         n118, n119, n120, n121, n122, n123, n124, n125, n126, n127, n128,
         n129, n130, n131, n132, n133, n134, n135, n136, n137, n138, n139,
         n140, n141, n142, n143, n144, n145, n146, n147, n148, n149, n150,
         n151, n152, n153, n154, n155, n156, n157, n158, n159, n160, n161,
         n162, n163, n164, n165, n166, n167, n168, n169, n170, n171, n172,
         n173, n174, n175, n176, n177, n178, n179, n180, n181, n182, n183,
         n184, n185, n186, n187, n188, n189, n190, n191, n192, n193, n194,
         n195, n196, n197, n198, n199, n200, n201, n202, n203, n204, n205,
         n206, n207, n208, n209, n210, n211, n212, n213, n214, n215, n216,
         n217, n218, n219, n220, n221, n222, n223, n224, n225, n226, n227,
         n228, n229, n230, n231;

  AND2_X1 U75 ( .A1(sel[1]), .A2(block_h[0]), .ZN(n67) );
  AND2_X1 U76 ( .A1(sel[3]), .A2(block_j[6]), .ZN(n68) );
  CLKBUF_X1 U77 ( .A(n123), .Z(n81) );
  INV_X1 U78 ( .A(sel[1]), .ZN(n69) );
  BUF_X1 U79 ( .A(sel[1]), .Z(n70) );
  BUF_X1 U80 ( .A(sel[1]), .Z(n75) );
  INV_X1 U81 ( .A(sel[3]), .ZN(n71) );
  INV_X1 U82 ( .A(sel[3]), .ZN(n72) );
  INV_X1 U83 ( .A(n74), .ZN(n73) );
  INV_X1 U84 ( .A(sel[0]), .ZN(n74) );
  NOR2_X1 U85 ( .A1(n104), .A2(sel[1]), .ZN(n148) );
  INV_X2 U86 ( .A(sel[0]), .ZN(n108) );
  NAND2_X1 U87 ( .A1(n95), .A2(n68), .ZN(n202) );
  NAND3_X1 U88 ( .A1(n94), .A2(sel[2]), .A3(n67), .ZN(n116) );
  AND2_X2 U89 ( .A1(sel[3]), .A2(n81), .ZN(n76) );
  INV_X1 U90 ( .A(sel[1]), .ZN(n77) );
  INV_X1 U91 ( .A(sel[1]), .ZN(n78) );
  INV_X1 U92 ( .A(sel[1]), .ZN(n79) );
  INV_X1 U93 ( .A(sel[1]), .ZN(n80) );
  INV_X1 U94 ( .A(sel[0]), .ZN(n102) );
  INV_X1 U95 ( .A(sel[0]), .ZN(n105) );
  OR2_X1 U96 ( .A1(sel[1]), .A2(sel[2]), .ZN(n123) );
  INV_X1 U97 ( .A(n106), .ZN(n82) );
  INV_X1 U98 ( .A(sel[0]), .ZN(n106) );
  INV_X1 U99 ( .A(sel[0]), .ZN(n104) );
  INV_X1 U100 ( .A(sel[3]), .ZN(n83) );
  INV_X1 U101 ( .A(sel[3]), .ZN(n222) );
  OAI21_X1 U102 ( .B1(n125), .B2(n71), .A(n124), .ZN(n84) );
  NAND4_X1 U103 ( .A1(block_e[2]), .A2(sel[2]), .A3(n80), .A4(n103), .ZN(n151)
         );
  INV_X1 U104 ( .A(sel[2]), .ZN(n85) );
  INV_X1 U105 ( .A(sel[2]), .ZN(n86) );
  INV_X1 U106 ( .A(sel[2]), .ZN(n87) );
  INV_X1 U107 ( .A(sel[2]), .ZN(n88) );
  INV_X1 U108 ( .A(sel[2]), .ZN(n89) );
  INV_X1 U109 ( .A(sel[2]), .ZN(n90) );
  INV_X1 U110 ( .A(sel[2]), .ZN(n91) );
  INV_X1 U111 ( .A(sel[2]), .ZN(n92) );
  INV_X1 U112 ( .A(sel[2]), .ZN(n93) );
  INV_X1 U113 ( .A(sel[2]), .ZN(n110) );
  INV_X1 U114 ( .A(n103), .ZN(n94) );
  INV_X1 U115 ( .A(n104), .ZN(n95) );
  INV_X1 U116 ( .A(n106), .ZN(n96) );
  INV_X1 U117 ( .A(n74), .ZN(n97) );
  INV_X1 U118 ( .A(n109), .ZN(n98) );
  INV_X1 U119 ( .A(n100), .ZN(n99) );
  INV_X1 U120 ( .A(sel[0]), .ZN(n100) );
  INV_X1 U121 ( .A(sel[0]), .ZN(n101) );
  INV_X1 U122 ( .A(sel[0]), .ZN(n103) );
  INV_X1 U123 ( .A(sel[0]), .ZN(n107) );
  INV_X1 U124 ( .A(sel[0]), .ZN(n109) );
  NAND4_X1 U125 ( .A1(block_f[0]), .A2(sel[2]), .A3(n73), .A4(n80), .ZN(n114)
         );
  NAND4_X1 U126 ( .A1(n96), .A2(sel[1]), .A3(block_d[0]), .A4(n85), .ZN(n113)
         );
  NAND3_X1 U127 ( .A1(block_j[0]), .A2(sel[3]), .A3(n99), .ZN(n112) );
  NAND3_X1 U128 ( .A1(n107), .A2(sel[3]), .A3(block_i[0]), .ZN(n111) );
  NAND4_X1 U129 ( .A1(n114), .A2(n112), .A3(n113), .A4(n111), .ZN(n122) );
  NAND4_X1 U130 ( .A1(block_g[0]), .A2(sel[2]), .A3(sel[1]), .A4(n108), .ZN(
        n115) );
  NAND2_X1 U131 ( .A1(n116), .A2(n115), .ZN(n121) );
  NAND4_X1 U132 ( .A1(block_e[0]), .A2(sel[2]), .A3(n78), .A4(n102), .ZN(n119)
         );
  NAND4_X1 U133 ( .A1(n107), .A2(sel[1]), .A3(block_c[0]), .A4(n92), .ZN(n118)
         );
  NAND4_X1 U134 ( .A1(n163), .A2(block_b[0]), .A3(n110), .A4(n72), .ZN(n117)
         );
  NAND3_X1 U135 ( .A1(n117), .A2(n118), .A3(n119), .ZN(n120) );
  NOR3_X1 U136 ( .A1(n122), .A2(n121), .A3(n120), .ZN(n127) );
  INV_X1 U137 ( .A(n123), .ZN(n125) );
  NAND4_X1 U138 ( .A1(n77), .A2(n88), .A3(n105), .A4(n83), .ZN(n124) );
  OAI21_X1 U139 ( .B1(n125), .B2(n222), .A(n124), .ZN(n229) );
  NAND2_X1 U140 ( .A1(block_a[0]), .A2(n229), .ZN(n126) );
  OAI21_X1 U141 ( .B1(n127), .B2(n76), .A(n126), .ZN(block_out[0]) );
  NAND4_X1 U142 ( .A1(block_f[1]), .A2(sel[2]), .A3(n73), .A4(n79), .ZN(n131)
         );
  NAND4_X1 U143 ( .A1(n98), .A2(sel[1]), .A3(block_d[1]), .A4(n86), .ZN(n130)
         );
  NAND3_X1 U144 ( .A1(block_j[1]), .A2(sel[3]), .A3(n96), .ZN(n129) );
  NAND3_X1 U145 ( .A1(n108), .A2(sel[3]), .A3(block_i[1]), .ZN(n128) );
  NAND4_X1 U146 ( .A1(n131), .A2(n130), .A3(n129), .A4(n128), .ZN(n139) );
  NAND4_X1 U147 ( .A1(block_h[1]), .A2(sel[2]), .A3(n70), .A4(n82), .ZN(n133)
         );
  NAND4_X1 U148 ( .A1(block_g[1]), .A2(sel[2]), .A3(sel[1]), .A4(n102), .ZN(
        n132) );
  NAND2_X1 U149 ( .A1(n133), .A2(n132), .ZN(n138) );
  NAND4_X1 U150 ( .A1(block_e[1]), .A2(sel[2]), .A3(n78), .A4(n102), .ZN(n136)
         );
  NAND4_X1 U151 ( .A1(n108), .A2(sel[1]), .A3(block_c[1]), .A4(n91), .ZN(n135)
         );
  NAND4_X1 U152 ( .A1(n163), .A2(block_b[1]), .A3(n87), .A4(n222), .ZN(n134)
         );
  NAND3_X1 U153 ( .A1(n134), .A2(n135), .A3(n136), .ZN(n137) );
  NOR3_X1 U154 ( .A1(n139), .A2(n138), .A3(n137), .ZN(n141) );
  NAND2_X1 U155 ( .A1(block_a[1]), .A2(n84), .ZN(n140) );
  OAI21_X1 U156 ( .B1(n141), .B2(n76), .A(n140), .ZN(block_out[1]) );
  NAND4_X1 U157 ( .A1(n98), .A2(sel[2]), .A3(block_f[2]), .A4(n79), .ZN(n145)
         );
  NAND4_X1 U158 ( .A1(block_d[2]), .A2(sel[1]), .A3(n82), .A4(n92), .ZN(n144)
         );
  NAND3_X1 U159 ( .A1(block_j[2]), .A2(sel[3]), .A3(n95), .ZN(n143) );
  NAND3_X1 U160 ( .A1(block_i[2]), .A2(sel[3]), .A3(n101), .ZN(n142) );
  NAND4_X1 U161 ( .A1(n144), .A2(n145), .A3(n143), .A4(n142), .ZN(n154) );
  NAND4_X1 U162 ( .A1(block_h[2]), .A2(sel[2]), .A3(n70), .A4(n94), .ZN(n147)
         );
  NAND4_X1 U163 ( .A1(block_g[2]), .A2(sel[2]), .A3(sel[1]), .A4(n108), .ZN(
        n146) );
  NAND2_X1 U164 ( .A1(n147), .A2(n146), .ZN(n153) );
  NAND4_X1 U165 ( .A1(block_c[2]), .A2(sel[1]), .A3(n107), .A4(n86), .ZN(n150)
         );
  NAND4_X1 U166 ( .A1(n148), .A2(block_b[2]), .A3(n86), .A4(n72), .ZN(n149) );
  NAND3_X1 U167 ( .A1(n149), .A2(n150), .A3(n151), .ZN(n152) );
  NOR3_X1 U168 ( .A1(n154), .A2(n153), .A3(n152), .ZN(n156) );
  NAND2_X1 U169 ( .A1(block_a[2]), .A2(n229), .ZN(n155) );
  OAI21_X1 U170 ( .B1(n156), .B2(n76), .A(n155), .ZN(block_out[2]) );
  NAND4_X1 U171 ( .A1(block_f[3]), .A2(sel[2]), .A3(n95), .A4(n69), .ZN(n160)
         );
  NAND4_X1 U172 ( .A1(n96), .A2(sel[1]), .A3(block_d[3]), .A4(n91), .ZN(n159)
         );
  NAND3_X1 U173 ( .A1(n99), .A2(sel[3]), .A3(block_j[3]), .ZN(n158) );
  NAND3_X1 U174 ( .A1(block_i[3]), .A2(sel[3]), .A3(n108), .ZN(n157) );
  NAND4_X1 U175 ( .A1(n160), .A2(n159), .A3(n158), .A4(n157), .ZN(n169) );
  NAND4_X1 U176 ( .A1(block_h[3]), .A2(sel[2]), .A3(n70), .A4(n82), .ZN(n162)
         );
  NAND4_X1 U177 ( .A1(block_g[3]), .A2(sel[2]), .A3(sel[1]), .A4(n102), .ZN(
        n161) );
  NAND2_X1 U178 ( .A1(n162), .A2(n161), .ZN(n168) );
  NAND4_X1 U179 ( .A1(block_e[3]), .A2(sel[2]), .A3(n80), .A4(n101), .ZN(n166)
         );
  NAND4_X1 U180 ( .A1(n108), .A2(sel[1]), .A3(block_c[3]), .A4(n110), .ZN(n165) );
  NOR2_X1 U181 ( .A1(n100), .A2(sel[1]), .ZN(n163) );
  NAND4_X1 U182 ( .A1(n178), .A2(block_b[3]), .A3(n93), .A4(n71), .ZN(n164) );
  NAND3_X1 U183 ( .A1(n164), .A2(n165), .A3(n166), .ZN(n167) );
  NOR3_X1 U184 ( .A1(n169), .A2(n168), .A3(n167), .ZN(n171) );
  NAND2_X1 U185 ( .A1(block_a[3]), .A2(n84), .ZN(n170) );
  OAI21_X1 U186 ( .B1(n171), .B2(n76), .A(n170), .ZN(block_out[3]) );
  NAND4_X1 U187 ( .A1(block_f[4]), .A2(sel[2]), .A3(n82), .A4(n80), .ZN(n175)
         );
  NAND4_X1 U188 ( .A1(n98), .A2(sel[1]), .A3(block_d[4]), .A4(n87), .ZN(n174)
         );
  NAND3_X1 U189 ( .A1(block_j[4]), .A2(sel[3]), .A3(n99), .ZN(n173) );
  NAND3_X1 U190 ( .A1(block_i[4]), .A2(sel[3]), .A3(n102), .ZN(n172) );
  NAND4_X1 U191 ( .A1(n175), .A2(n174), .A3(n173), .A4(n172), .ZN(n184) );
  NAND4_X1 U192 ( .A1(block_h[4]), .A2(sel[2]), .A3(n70), .A4(n97), .ZN(n177)
         );
  NAND4_X1 U193 ( .A1(n107), .A2(sel[2]), .A3(sel[1]), .A4(block_g[4]), .ZN(
        n176) );
  NAND2_X1 U194 ( .A1(n177), .A2(n176), .ZN(n183) );
  NAND4_X1 U195 ( .A1(block_e[4]), .A2(sel[2]), .A3(n79), .A4(n105), .ZN(n181)
         );
  NAND4_X1 U196 ( .A1(block_c[4]), .A2(sel[1]), .A3(n107), .A4(n93), .ZN(n180)
         );
  NOR2_X1 U197 ( .A1(sel[1]), .A2(n105), .ZN(n178) );
  NAND4_X1 U198 ( .A1(n148), .A2(block_b[4]), .A3(n90), .A4(n222), .ZN(n179)
         );
  NAND3_X1 U199 ( .A1(n179), .A2(n180), .A3(n181), .ZN(n182) );
  NOR3_X1 U200 ( .A1(n184), .A2(n183), .A3(n182), .ZN(n186) );
  NAND2_X1 U201 ( .A1(block_a[4]), .A2(n229), .ZN(n185) );
  OAI21_X1 U202 ( .B1(n186), .B2(n76), .A(n185), .ZN(block_out[4]) );
  NAND4_X1 U203 ( .A1(block_f[5]), .A2(sel[2]), .A3(n95), .A4(n80), .ZN(n190)
         );
  NAND4_X1 U204 ( .A1(n97), .A2(sel[1]), .A3(block_d[5]), .A4(n89), .ZN(n189)
         );
  NAND3_X1 U205 ( .A1(block_j[5]), .A2(sel[3]), .A3(n97), .ZN(n188) );
  NAND3_X1 U206 ( .A1(n101), .A2(sel[3]), .A3(block_i[5]), .ZN(n187) );
  NAND4_X1 U207 ( .A1(n190), .A2(n189), .A3(n188), .A4(n187), .ZN(n198) );
  NAND4_X1 U208 ( .A1(block_h[5]), .A2(sel[2]), .A3(n75), .A4(n98), .ZN(n192)
         );
  NAND4_X1 U209 ( .A1(block_g[5]), .A2(sel[2]), .A3(n75), .A4(n101), .ZN(n191)
         );
  NAND2_X1 U210 ( .A1(n192), .A2(n191), .ZN(n197) );
  NAND4_X1 U211 ( .A1(block_e[5]), .A2(sel[2]), .A3(n79), .A4(n101), .ZN(n195)
         );
  NAND4_X1 U212 ( .A1(n108), .A2(sel[1]), .A3(block_c[5]), .A4(n90), .ZN(n194)
         );
  NAND4_X1 U213 ( .A1(n207), .A2(block_b[5]), .A3(n89), .A4(n72), .ZN(n193) );
  NAND3_X1 U214 ( .A1(n193), .A2(n194), .A3(n195), .ZN(n196) );
  NOR3_X1 U215 ( .A1(n198), .A2(n197), .A3(n196), .ZN(n200) );
  NAND2_X1 U216 ( .A1(block_a[5]), .A2(n84), .ZN(n199) );
  OAI21_X1 U217 ( .B1(n200), .B2(n76), .A(n199), .ZN(block_out[5]) );
  NAND4_X1 U218 ( .A1(block_f[6]), .A2(sel[2]), .A3(n73), .A4(n69), .ZN(n204)
         );
  NAND4_X1 U219 ( .A1(n96), .A2(sel[1]), .A3(block_d[6]), .A4(n91), .ZN(n203)
         );
  NAND3_X1 U220 ( .A1(block_i[6]), .A2(sel[3]), .A3(n102), .ZN(n201) );
  NAND4_X1 U221 ( .A1(n204), .A2(n203), .A3(n202), .A4(n201), .ZN(n213) );
  NAND4_X1 U222 ( .A1(block_h[6]), .A2(sel[2]), .A3(n70), .A4(n82), .ZN(n206)
         );
  NAND4_X1 U223 ( .A1(block_g[6]), .A2(sel[2]), .A3(n75), .A4(n108), .ZN(n205)
         );
  NAND2_X1 U224 ( .A1(n206), .A2(n205), .ZN(n212) );
  NAND4_X1 U225 ( .A1(block_e[6]), .A2(sel[2]), .A3(n79), .A4(n101), .ZN(n210)
         );
  NAND4_X1 U226 ( .A1(n107), .A2(sel[1]), .A3(block_c[6]), .A4(n85), .ZN(n209)
         );
  NOR2_X1 U227 ( .A1(sel[1]), .A2(n109), .ZN(n207) );
  NAND4_X1 U228 ( .A1(n207), .A2(block_b[6]), .A3(n92), .A4(n71), .ZN(n208) );
  NAND3_X1 U229 ( .A1(n208), .A2(n209), .A3(n210), .ZN(n211) );
  NOR3_X1 U230 ( .A1(n213), .A2(n212), .A3(n211), .ZN(n215) );
  NAND2_X1 U231 ( .A1(block_a[6]), .A2(n229), .ZN(n214) );
  OAI21_X1 U232 ( .B1(n215), .B2(n76), .A(n214), .ZN(block_out[6]) );
  NAND4_X1 U233 ( .A1(block_f[7]), .A2(sel[2]), .A3(n98), .A4(n69), .ZN(n219)
         );
  NAND4_X1 U234 ( .A1(n97), .A2(sel[1]), .A3(block_d[7]), .A4(n93), .ZN(n218)
         );
  NAND3_X1 U235 ( .A1(n73), .A2(sel[3]), .A3(block_j[7]), .ZN(n217) );
  NAND3_X1 U236 ( .A1(block_i[7]), .A2(sel[3]), .A3(n108), .ZN(n216) );
  NAND4_X1 U237 ( .A1(n219), .A2(n218), .A3(n217), .A4(n216), .ZN(n228) );
  NAND4_X1 U238 ( .A1(n99), .A2(sel[2]), .A3(n75), .A4(block_h[7]), .ZN(n221)
         );
  NAND4_X1 U239 ( .A1(block_g[7]), .A2(sel[2]), .A3(sel[1]), .A4(n108), .ZN(
        n220) );
  NAND2_X1 U240 ( .A1(n221), .A2(n220), .ZN(n227) );
  NAND4_X1 U241 ( .A1(block_e[7]), .A2(sel[2]), .A3(n78), .A4(n103), .ZN(n225)
         );
  NAND4_X1 U242 ( .A1(n108), .A2(sel[1]), .A3(block_c[7]), .A4(n87), .ZN(n224)
         );
  NAND4_X1 U243 ( .A1(n148), .A2(block_b[7]), .A3(n89), .A4(n222), .ZN(n223)
         );
  NAND3_X1 U244 ( .A1(n223), .A2(n225), .A3(n224), .ZN(n226) );
  NOR3_X1 U245 ( .A1(n228), .A2(n227), .A3(n226), .ZN(n231) );
  NAND2_X1 U246 ( .A1(block_a[7]), .A2(n84), .ZN(n230) );
  OAI21_X1 U247 ( .B1(n231), .B2(n76), .A(n230), .ZN(block_out[7]) );
endmodule

