/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Wed May 14 19:07:44 2025
/////////////////////////////////////////////////////////////


module mux_large_ref ( block_a, block_b, block_c, block_d, block_e, block_f, 
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
  wire   n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,
         n103, n104, n105, n106, n107, n108, n109, n110, n111, n112, n113,
         n114, n115, n116, n117, n118, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n130, n131, n132, n133, n134, n135, n136, n137,
         n138, n139, n140, n141, n142, n143, n144, n145, n146, n147, n148,
         n149, n150, n151, n152, n153, n154, n155, n156, n157, n158, n159,
         n160, n161, n162, n163, n164, n165, n166, n167, n168, n169, n170,
         n171, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181,
         n182, n183, n184, n185, n186, n187, n188, n189, n190, n191, n192,
         n193, n194, n195, n196, n197, n198, n199, n200, n201, n202, n203,
         n204, n205, n206, n207, n208, n209, n210, n211, n212, n213, n214,
         n215, n216, n217, n218, n219, n220, n221, n222, n223, n224, n225,
         n226, n227, n228, n229, n230, n231, n232, n233, n234, n235, n236,
         n237, n238, n239, n240, n241, n242, n243, n244, n245, n246, n247;

  INV_X2 U84 ( .A(sel[1]), .ZN(n136) );
  BUF_X1 U85 ( .A(n152), .Z(n90) );
  BUF_X1 U86 ( .A(sel[0]), .Z(n91) );
  BUF_X1 U87 ( .A(n153), .Z(n126) );
  BUF_X2 U88 ( .A(sel[0]), .Z(n108) );
  BUF_X2 U89 ( .A(sel[0]), .Z(n93) );
  BUF_X1 U90 ( .A(sel[1]), .Z(n92) );
  BUF_X1 U91 ( .A(sel[1]), .Z(n94) );
  CLKBUF_X1 U92 ( .A(n225), .Z(n95) );
  INV_X1 U93 ( .A(n148), .ZN(n96) );
  BUF_X1 U94 ( .A(sel[1]), .Z(n97) );
  INV_X1 U95 ( .A(sel[0]), .ZN(n98) );
  BUF_X1 U96 ( .A(sel[0]), .Z(n111) );
  AND4_X1 U97 ( .A1(n208), .A2(n207), .A3(n206), .A4(n205), .ZN(n131) );
  AND4_X1 U98 ( .A1(n199), .A2(n198), .A3(n197), .A4(n196), .ZN(n99) );
  AND4_X1 U99 ( .A1(n216), .A2(n215), .A3(n214), .A4(n213), .ZN(n100) );
  AND4_X1 U100 ( .A1(n191), .A2(n190), .A3(n189), .A4(n188), .ZN(n101) );
  INV_X1 U101 ( .A(n227), .ZN(n102) );
  INV_X1 U102 ( .A(sel[2]), .ZN(n148) );
  AND4_X1 U103 ( .A1(n186), .A2(n187), .A3(n185), .A4(n184), .ZN(n103) );
  AND4_X1 U104 ( .A1(n194), .A2(n195), .A3(n193), .A4(n192), .ZN(n104) );
  AND4_X1 U105 ( .A1(n211), .A2(n212), .A3(n210), .A4(n209), .ZN(n105) );
  NAND3_X1 U106 ( .A1(n125), .A2(n113), .A3(block_a[2]), .ZN(n106) );
  NAND3_X1 U107 ( .A1(block_a[5]), .A2(n113), .A3(n125), .ZN(n107) );
  BUF_X2 U108 ( .A(sel[1]), .Z(n109) );
  INV_X1 U109 ( .A(n239), .ZN(n110) );
  NAND3_X1 U110 ( .A1(n95), .A2(block_a[3]), .A3(n126), .ZN(n112) );
  BUF_X1 U111 ( .A(n236), .Z(n113) );
  INV_X1 U112 ( .A(n116), .ZN(n114) );
  OAI221_X1 U113 ( .B1(n104), .B2(n118), .C1(n99), .C2(sel[3]), .A(n112), .ZN(
        block_out[3]) );
  NAND3_X1 U114 ( .A1(n140), .A2(n148), .A3(n146), .ZN(n167) );
  INV_X1 U115 ( .A(sel[1]), .ZN(n115) );
  INV_X1 U116 ( .A(sel[2]), .ZN(n116) );
  INV_X1 U117 ( .A(sel[0]), .ZN(n117) );
  OAI221_X1 U118 ( .B1(n105), .B2(n118), .C1(n100), .C2(sel[3]), .A(n107), 
        .ZN(block_out[5]) );
  OAI221_X1 U119 ( .B1(n103), .B2(n118), .C1(n101), .C2(sel[3]), .A(n106), 
        .ZN(block_out[2]) );
  INV_X1 U120 ( .A(n200), .ZN(n118) );
  OAI221_X1 U121 ( .B1(n120), .B2(n102), .C1(n121), .C2(sel[3]), .A(n122), 
        .ZN(block_out[6]) );
  AND4_X1 U122 ( .A1(n219), .A2(n220), .A3(n218), .A4(n217), .ZN(n120) );
  AND4_X1 U123 ( .A1(n224), .A2(n223), .A3(n222), .A4(n221), .ZN(n121) );
  NAND3_X1 U124 ( .A1(block_a[6]), .A2(n126), .A3(n125), .ZN(n122) );
  BUF_X2 U125 ( .A(sel[0]), .Z(n123) );
  BUF_X1 U126 ( .A(sel[0]), .Z(n134) );
  INV_X2 U127 ( .A(sel[2]), .ZN(n154) );
  BUF_X2 U128 ( .A(sel[1]), .Z(n124) );
  NAND2_X1 U129 ( .A1(n167), .A2(n150), .ZN(n125) );
  INV_X1 U130 ( .A(n93), .ZN(n127) );
  INV_X1 U131 ( .A(sel[0]), .ZN(n128) );
  OAI221_X1 U132 ( .B1(n130), .B2(n102), .C1(n131), .C2(sel[3]), .A(n132), 
        .ZN(block_out[4]) );
  AND4_X1 U133 ( .A1(n203), .A2(n204), .A3(n202), .A4(n201), .ZN(n130) );
  NAND3_X1 U134 ( .A1(block_a[4]), .A2(n126), .A3(n125), .ZN(n132) );
  INV_X1 U135 ( .A(sel[1]), .ZN(n133) );
  OR3_X1 U136 ( .A1(sel[1]), .A2(sel[0]), .A3(sel[2]), .ZN(n135) );
  INV_X1 U137 ( .A(sel[0]), .ZN(n137) );
  INV_X1 U138 ( .A(n93), .ZN(n138) );
  BUF_X1 U139 ( .A(n117), .Z(n139) );
  INV_X1 U140 ( .A(sel[0]), .ZN(n140) );
  INV_X1 U141 ( .A(sel[1]), .ZN(n141) );
  INV_X1 U142 ( .A(sel[1]), .ZN(n146) );
  INV_X1 U143 ( .A(sel[1]), .ZN(n142) );
  INV_X1 U144 ( .A(sel[0]), .ZN(n143) );
  INV_X1 U145 ( .A(n93), .ZN(n144) );
  INV_X1 U146 ( .A(n93), .ZN(n145) );
  BUF_X2 U147 ( .A(sel[2]), .Z(n147) );
  BUF_X1 U148 ( .A(n149), .Z(n158) );
  NAND2_X1 U149 ( .A1(n135), .A2(n244), .ZN(n225) );
  INV_X1 U150 ( .A(sel[2]), .ZN(n149) );
  INV_X1 U151 ( .A(sel[3]), .ZN(n150) );
  INV_X1 U152 ( .A(sel[3]), .ZN(n244) );
  BUF_X1 U153 ( .A(n152), .Z(n151) );
  BUF_X1 U154 ( .A(n148), .Z(n156) );
  INV_X1 U155 ( .A(sel[2]), .ZN(n152) );
  NAND3_X1 U156 ( .A1(n115), .A2(n152), .A3(sel[3]), .ZN(n153) );
  INV_X1 U157 ( .A(sel[2]), .ZN(n155) );
  OAI211_X1 U158 ( .C1(sel[1]), .C2(sel[0]), .A(sel[2]), .B(n244), .ZN(n157)
         );
  NAND3_X1 U159 ( .A1(block_h[0]), .A2(n92), .A3(sel[0]), .ZN(n162) );
  INV_X1 U160 ( .A(sel[2]), .ZN(n239) );
  OAI221_X1 U161 ( .B1(sel[0]), .B2(block_i[0]), .C1(n137), .C2(block_j[0]), 
        .A(n116), .ZN(n161) );
  NAND3_X1 U162 ( .A1(n92), .A2(n140), .A3(block_g[0]), .ZN(n160) );
  NAND3_X1 U163 ( .A1(n147), .A2(n142), .A3(block_f[0]), .ZN(n159) );
  NAND4_X1 U164 ( .A1(n161), .A2(n162), .A3(n160), .A4(n159), .ZN(n170) );
  NAND2_X1 U165 ( .A1(n153), .A2(n157), .ZN(n200) );
  NAND4_X1 U166 ( .A1(block_e[0]), .A2(n110), .A3(n128), .A4(n146), .ZN(n166)
         );
  NAND4_X1 U167 ( .A1(block_d[0]), .A2(n109), .A3(n108), .A4(n116), .ZN(n165)
         );
  NAND4_X1 U168 ( .A1(block_b[0]), .A2(n123), .A3(n151), .A4(n136), .ZN(n164)
         );
  NAND4_X1 U169 ( .A1(block_c[0]), .A2(n109), .A3(n149), .A4(n98), .ZN(n163)
         );
  NAND4_X1 U170 ( .A1(n166), .A2(n165), .A3(n164), .A4(n163), .ZN(n169) );
  NAND3_X1 U171 ( .A1(n133), .A2(n155), .A3(sel[3]), .ZN(n226) );
  AND3_X1 U172 ( .A1(n225), .A2(block_a[0]), .A3(n236), .ZN(n168) );
  AOI221_X1 U173 ( .B1(n170), .B2(n227), .C1(n169), .C2(n150), .A(n168), .ZN(
        n171) );
  INV_X1 U174 ( .A(n171), .ZN(block_out[0]) );
  NAND3_X1 U175 ( .A1(block_h[1]), .A2(n94), .A3(n91), .ZN(n175) );
  OAI221_X1 U176 ( .B1(block_i[1]), .B2(sel[0]), .C1(n137), .C2(block_j[1]), 
        .A(n149), .ZN(n174) );
  NAND3_X1 U177 ( .A1(n92), .A2(n128), .A3(block_g[1]), .ZN(n173) );
  NAND3_X1 U178 ( .A1(n147), .A2(n142), .A3(block_f[1]), .ZN(n172) );
  NAND4_X1 U179 ( .A1(n174), .A2(n175), .A3(n173), .A4(n172), .ZN(n182) );
  NAND4_X1 U180 ( .A1(block_e[1]), .A2(n110), .A3(n139), .A4(n142), .ZN(n179)
         );
  NAND4_X1 U181 ( .A1(block_d[1]), .A2(n124), .A3(n123), .A4(n149), .ZN(n178)
         );
  NAND4_X1 U182 ( .A1(block_b[1]), .A2(n108), .A3(n148), .A4(n136), .ZN(n177)
         );
  NAND4_X1 U183 ( .A1(block_c[1]), .A2(n124), .A3(n116), .A4(n143), .ZN(n176)
         );
  NAND4_X1 U184 ( .A1(n179), .A2(n178), .A3(n177), .A4(n176), .ZN(n181) );
  AND3_X1 U185 ( .A1(n225), .A2(block_a[1]), .A3(n236), .ZN(n180) );
  AOI221_X1 U186 ( .B1(n182), .B2(n200), .C1(n181), .C2(n150), .A(n180), .ZN(
        n183) );
  INV_X1 U187 ( .A(n183), .ZN(block_out[1]) );
  NAND3_X1 U188 ( .A1(block_h[2]), .A2(n97), .A3(n123), .ZN(n187) );
  OAI221_X1 U189 ( .B1(n108), .B2(block_i[2]), .C1(block_j[2]), .C2(n98), .A(
        n149), .ZN(n186) );
  NAND3_X1 U190 ( .A1(n97), .A2(n140), .A3(block_g[2]), .ZN(n185) );
  NAND3_X1 U191 ( .A1(n110), .A2(n136), .A3(block_f[2]), .ZN(n184) );
  NAND4_X1 U192 ( .A1(block_e[2]), .A2(n96), .A3(n138), .A4(n141), .ZN(n191)
         );
  NAND4_X1 U193 ( .A1(block_d[2]), .A2(n109), .A3(n93), .A4(n154), .ZN(n190)
         );
  NAND4_X1 U194 ( .A1(block_b[2]), .A2(n108), .A3(n154), .A4(n141), .ZN(n189)
         );
  NAND4_X1 U195 ( .A1(n154), .A2(n124), .A3(block_c[2]), .A4(n138), .ZN(n188)
         );
  NAND3_X1 U196 ( .A1(block_h[3]), .A2(n97), .A3(n111), .ZN(n195) );
  OAI221_X1 U197 ( .B1(n108), .B2(block_i[3]), .C1(n143), .C2(block_j[3]), .A(
        n151), .ZN(n194) );
  NAND3_X1 U198 ( .A1(n109), .A2(n117), .A3(block_g[3]), .ZN(n193) );
  NAND3_X1 U199 ( .A1(n114), .A2(n136), .A3(block_f[3]), .ZN(n192) );
  NAND4_X1 U200 ( .A1(block_e[3]), .A2(n96), .A3(n144), .A4(n141), .ZN(n199)
         );
  NAND4_X1 U201 ( .A1(block_d[3]), .A2(n124), .A3(n123), .A4(n154), .ZN(n198)
         );
  NAND4_X1 U202 ( .A1(block_b[3]), .A2(n123), .A3(n90), .A4(n146), .ZN(n197)
         );
  NAND4_X1 U203 ( .A1(block_c[3]), .A2(n109), .A3(n116), .A4(n98), .ZN(n196)
         );
  NAND3_X1 U204 ( .A1(block_h[4]), .A2(n109), .A3(n123), .ZN(n204) );
  OAI221_X1 U205 ( .B1(block_i[4]), .B2(n134), .C1(block_j[4]), .C2(n143), .A(
        n158), .ZN(n203) );
  NAND3_X1 U206 ( .A1(n124), .A2(n98), .A3(block_g[4]), .ZN(n202) );
  NAND3_X1 U207 ( .A1(n114), .A2(n136), .A3(block_f[4]), .ZN(n201) );
  NAND2_X1 U208 ( .A1(n153), .A2(n157), .ZN(n227) );
  NAND4_X1 U209 ( .A1(block_e[4]), .A2(n110), .A3(n127), .A4(n136), .ZN(n208)
         );
  NAND4_X1 U210 ( .A1(block_d[4]), .A2(n124), .A3(n123), .A4(n154), .ZN(n207)
         );
  NAND4_X1 U211 ( .A1(n154), .A2(n111), .A3(block_b[4]), .A4(n146), .ZN(n206)
         );
  NAND4_X1 U212 ( .A1(block_c[4]), .A2(n109), .A3(n90), .A4(n145), .ZN(n205)
         );
  NAND3_X1 U213 ( .A1(block_h[5]), .A2(n97), .A3(n111), .ZN(n212) );
  OAI221_X1 U214 ( .B1(n108), .B2(block_i[5]), .C1(n128), .C2(block_j[5]), .A(
        n90), .ZN(n211) );
  NAND3_X1 U215 ( .A1(n97), .A2(n128), .A3(block_g[5]), .ZN(n210) );
  NAND3_X1 U216 ( .A1(n114), .A2(n141), .A3(block_f[5]), .ZN(n209) );
  NAND4_X1 U217 ( .A1(block_e[5]), .A2(n110), .A3(n145), .A4(n142), .ZN(n216)
         );
  NAND4_X1 U218 ( .A1(block_d[5]), .A2(n124), .A3(n123), .A4(n154), .ZN(n215)
         );
  NAND4_X1 U219 ( .A1(block_b[5]), .A2(n111), .A3(n154), .A4(n136), .ZN(n214)
         );
  NAND4_X1 U220 ( .A1(block_c[5]), .A2(n109), .A3(n156), .A4(n144), .ZN(n213)
         );
  NAND3_X1 U221 ( .A1(block_h[6]), .A2(n124), .A3(n111), .ZN(n220) );
  OAI221_X1 U222 ( .B1(n111), .B2(block_i[6]), .C1(block_j[6]), .C2(n143), .A(
        n154), .ZN(n219) );
  NAND3_X1 U223 ( .A1(n109), .A2(n143), .A3(block_g[6]), .ZN(n218) );
  NAND3_X1 U224 ( .A1(n110), .A2(n136), .A3(block_f[6]), .ZN(n217) );
  NAND4_X1 U225 ( .A1(block_e[6]), .A2(n96), .A3(n98), .A4(n146), .ZN(n224) );
  NAND4_X1 U226 ( .A1(n109), .A2(block_d[6]), .A3(n123), .A4(n154), .ZN(n223)
         );
  NAND4_X1 U227 ( .A1(block_b[6]), .A2(n123), .A3(n154), .A4(n142), .ZN(n222)
         );
  NAND4_X1 U228 ( .A1(block_c[6]), .A2(n124), .A3(n156), .A4(n127), .ZN(n221)
         );
  AND2_X1 U229 ( .A1(block_i[7]), .A2(n136), .ZN(n233) );
  NOR2_X1 U230 ( .A1(n108), .A2(n136), .ZN(n232) );
  NAND3_X1 U231 ( .A1(block_h[7]), .A2(n94), .A3(n134), .ZN(n230) );
  NAND3_X1 U232 ( .A1(block_j[7]), .A2(n134), .A3(n148), .ZN(n229) );
  NAND3_X1 U233 ( .A1(n147), .A2(n146), .A3(block_f[7]), .ZN(n228) );
  NAND3_X1 U234 ( .A1(n230), .A2(n229), .A3(n228), .ZN(n231) );
  AOI221_X1 U235 ( .B1(n233), .B2(n139), .C1(n232), .C2(block_g[7]), .A(n231), 
        .ZN(n247) );
  NAND4_X1 U236 ( .A1(block_b[7]), .A2(n123), .A3(n158), .A4(n136), .ZN(n235)
         );
  NAND4_X1 U237 ( .A1(block_c[7]), .A2(n124), .A3(n154), .A4(n117), .ZN(n234)
         );
  NAND2_X1 U238 ( .A1(n235), .A2(n234), .ZN(n245) );
  NOR3_X1 U239 ( .A1(sel[2]), .A2(sel[1]), .A3(sel[0]), .ZN(n237) );
  NAND3_X1 U240 ( .A1(n115), .A2(n239), .A3(sel[3]), .ZN(n236) );
  OAI211_X1 U241 ( .C1(sel[3]), .C2(n237), .A(n226), .B(block_a[7]), .ZN(n238)
         );
  INV_X1 U242 ( .A(n238), .ZN(n243) );
  NAND4_X1 U243 ( .A1(n147), .A2(block_e[7]), .A3(n140), .A4(n141), .ZN(n241)
         );
  NAND4_X1 U244 ( .A1(block_d[7]), .A2(n94), .A3(n91), .A4(n148), .ZN(n240) );
  AOI21_X1 U245 ( .B1(n240), .B2(n241), .A(sel[3]), .ZN(n242) );
  AOI211_X1 U246 ( .C1(n245), .C2(n150), .A(n242), .B(n243), .ZN(n246) );
  OAI21_X1 U247 ( .B1(n247), .B2(n102), .A(n246), .ZN(block_out[7]) );
endmodule

