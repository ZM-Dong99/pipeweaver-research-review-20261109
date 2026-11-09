/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:34:19 2025
/////////////////////////////////////////////////////////////


module mux_large_mini ( block_a, block_b, block_c, block_d, block_e, block_f, 
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
  wire   n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
         n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74,
         n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88,
         n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
         n113, n114, n115, n116, n117, n118, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145,
         n146, n147, n148, n149, n150, n151, n152, n153, n154, n155, n156,
         n157, n158, n159, n160, n161, n162, n163, n164, n165, n166, n167,
         n168, n169, n170, n171, n172, n173, n174, n175, n176, n177, n178,
         n179, n180, n181, n182, n183, n184, n185, n186, n187, n188, n189,
         n190, n191, n192, n193, n194, n195, n196, n197;

  OR4_X2 U55 ( .A1(n85), .A2(n78), .A3(n76), .A4(sel[0]), .ZN(n191) );
  INV_X1 U56 ( .A(n90), .ZN(n47) );
  BUF_X2 U57 ( .A(sel[1]), .Z(n50) );
  INV_X1 U58 ( .A(sel[3]), .ZN(n48) );
  INV_X2 U59 ( .A(sel[0]), .ZN(n56) );
  BUF_X2 U60 ( .A(sel[0]), .Z(n87) );
  BUF_X1 U61 ( .A(n54), .Z(n49) );
  BUF_X1 U62 ( .A(n73), .Z(n51) );
  BUF_X1 U63 ( .A(n75), .Z(n52) );
  BUF_X2 U64 ( .A(sel[0]), .Z(n58) );
  OR4_X2 U65 ( .A1(sel[2]), .A2(n72), .A3(n84), .A4(n53), .ZN(n192) );
  BUF_X2 U66 ( .A(sel[0]), .Z(n63) );
  OAI211_X1 U67 ( .C1(n62), .C2(block_b[2]), .A(n79), .B(n48), .ZN(n122) );
  OAI211_X1 U68 ( .C1(n57), .C2(block_b[5]), .A(n80), .B(n48), .ZN(n161) );
  OAI211_X1 U69 ( .C1(n59), .C2(block_b[7]), .A(n92), .B(n184), .ZN(n188) );
  OAI211_X1 U70 ( .C1(n59), .C2(block_b[1]), .A(n83), .B(n184), .ZN(n109) );
  OAI211_X1 U71 ( .C1(n59), .C2(block_b[4]), .A(n79), .B(n184), .ZN(n148) );
  OAI211_X1 U72 ( .C1(n56), .C2(block_b[6]), .A(n82), .B(n184), .ZN(n174) );
  INV_X1 U73 ( .A(sel[0]), .ZN(n53) );
  INV_X1 U74 ( .A(sel[1]), .ZN(n54) );
  INV_X1 U75 ( .A(sel[1]), .ZN(n55) );
  BUF_X2 U76 ( .A(sel[0]), .Z(n86) );
  INV_X1 U77 ( .A(sel[0]), .ZN(n57) );
  BUF_X2 U78 ( .A(sel[0]), .Z(n64) );
  INV_X1 U79 ( .A(sel[0]), .ZN(n59) );
  INV_X1 U80 ( .A(n87), .ZN(n88) );
  INV_X1 U81 ( .A(sel[2]), .ZN(n60) );
  INV_X1 U82 ( .A(sel[2]), .ZN(n61) );
  INV_X1 U83 ( .A(sel[0]), .ZN(n62) );
  NAND4_X1 U84 ( .A1(block_g[3]), .A2(sel[2]), .A3(n50), .A4(n56), .ZN(n138)
         );
  INV_X1 U85 ( .A(block_d[7]), .ZN(n84) );
  NAND4_X1 U86 ( .A1(sel[2]), .A2(block_g[2]), .A3(n50), .A4(n59), .ZN(n125)
         );
  INV_X1 U87 ( .A(block_g[7]), .ZN(n85) );
  INV_X1 U88 ( .A(n75), .ZN(n65) );
  INV_X1 U89 ( .A(n55), .ZN(n66) );
  INV_X1 U90 ( .A(n73), .ZN(n67) );
  INV_X1 U91 ( .A(n71), .ZN(n68) );
  INV_X1 U92 ( .A(n89), .ZN(n69) );
  INV_X1 U93 ( .A(n54), .ZN(n70) );
  INV_X1 U94 ( .A(sel[1]), .ZN(n71) );
  INV_X1 U95 ( .A(sel[1]), .ZN(n72) );
  INV_X1 U96 ( .A(sel[1]), .ZN(n73) );
  INV_X1 U97 ( .A(sel[1]), .ZN(n74) );
  INV_X1 U98 ( .A(sel[1]), .ZN(n75) );
  INV_X1 U99 ( .A(sel[1]), .ZN(n76) );
  INV_X1 U100 ( .A(sel[1]), .ZN(n90) );
  INV_X1 U101 ( .A(sel[1]), .ZN(n89) );
  INV_X1 U102 ( .A(sel[2]), .ZN(n77) );
  INV_X1 U103 ( .A(sel[2]), .ZN(n78) );
  INV_X1 U104 ( .A(sel[2]), .ZN(n79) );
  INV_X1 U105 ( .A(sel[2]), .ZN(n80) );
  INV_X1 U106 ( .A(sel[2]), .ZN(n81) );
  INV_X1 U107 ( .A(sel[2]), .ZN(n82) );
  INV_X1 U108 ( .A(sel[2]), .ZN(n83) );
  INV_X1 U109 ( .A(sel[2]), .ZN(n92) );
  INV_X1 U110 ( .A(sel[2]), .ZN(n91) );
  INV_X1 U111 ( .A(sel[3]), .ZN(n184) );
  OAI211_X1 U112 ( .C1(block_b[0]), .C2(n56), .A(n60), .B(n184), .ZN(n96) );
  OAI21_X1 U113 ( .B1(block_a[0]), .B2(n64), .A(n72), .ZN(n95) );
  NAND3_X1 U114 ( .A1(block_j[0]), .A2(sel[3]), .A3(n63), .ZN(n94) );
  NAND3_X1 U115 ( .A1(block_i[0]), .A2(sel[3]), .A3(n57), .ZN(n93) );
  OAI211_X1 U116 ( .C1(n96), .C2(n95), .A(n94), .B(n93), .ZN(n105) );
  NAND4_X1 U117 ( .A1(block_c[0]), .A2(n50), .A3(n79), .A4(n57), .ZN(n98) );
  NAND4_X1 U118 ( .A1(block_e[0]), .A2(sel[2]), .A3(n51), .A4(n57), .ZN(n97)
         );
  NAND2_X1 U119 ( .A1(n98), .A2(n97), .ZN(n104) );
  NAND4_X1 U120 ( .A1(block_f[0]), .A2(sel[2]), .A3(n58), .A4(n74), .ZN(n102)
         );
  NAND4_X1 U121 ( .A1(block_h[0]), .A2(sel[2]), .A3(n64), .A4(n65), .ZN(n101)
         );
  NAND4_X1 U122 ( .A1(block_d[0]), .A2(n65), .A3(n63), .A4(n61), .ZN(n100) );
  NAND4_X1 U123 ( .A1(block_g[0]), .A2(sel[2]), .A3(n66), .A4(n56), .ZN(n99)
         );
  NAND4_X1 U124 ( .A1(n102), .A2(n101), .A3(n100), .A4(n99), .ZN(n103) );
  OR3_X1 U125 ( .A1(n105), .A2(n103), .A3(n104), .ZN(block_out[0]) );
  OAI21_X1 U126 ( .B1(block_a[1]), .B2(n87), .A(n51), .ZN(n108) );
  NAND3_X1 U127 ( .A1(block_j[1]), .A2(sel[3]), .A3(n64), .ZN(n107) );
  NAND3_X1 U128 ( .A1(block_i[1]), .A2(sel[3]), .A3(n56), .ZN(n106) );
  OAI211_X1 U129 ( .C1(n108), .C2(n109), .A(n107), .B(n106), .ZN(n118) );
  NAND4_X1 U130 ( .A1(block_c[1]), .A2(n67), .A3(n77), .A4(n57), .ZN(n111) );
  NAND4_X1 U131 ( .A1(block_e[1]), .A2(n62), .A3(n76), .A4(sel[2]), .ZN(n110)
         );
  NAND2_X1 U132 ( .A1(n111), .A2(n110), .ZN(n117) );
  NAND4_X1 U133 ( .A1(block_f[1]), .A2(sel[2]), .A3(n86), .A4(n71), .ZN(n115)
         );
  NAND4_X1 U134 ( .A1(block_h[1]), .A2(sel[2]), .A3(n86), .A4(n70), .ZN(n114)
         );
  NAND4_X1 U135 ( .A1(block_d[1]), .A2(n50), .A3(n58), .A4(n91), .ZN(n113) );
  NAND4_X1 U136 ( .A1(block_g[1]), .A2(sel[2]), .A3(n47), .A4(n88), .ZN(n112)
         );
  NAND4_X1 U137 ( .A1(n112), .A2(n114), .A3(n113), .A4(n115), .ZN(n116) );
  OR3_X1 U138 ( .A1(n116), .A2(n118), .A3(n117), .ZN(block_out[1]) );
  OAI21_X1 U139 ( .B1(block_a[2]), .B2(n58), .A(n74), .ZN(n121) );
  NAND3_X1 U140 ( .A1(block_j[2]), .A2(sel[3]), .A3(n63), .ZN(n120) );
  NAND3_X1 U141 ( .A1(block_i[2]), .A2(sel[3]), .A3(n62), .ZN(n119) );
  OAI211_X1 U142 ( .C1(n122), .C2(n121), .A(n120), .B(n119), .ZN(n131) );
  NAND4_X1 U143 ( .A1(block_c[2]), .A2(n68), .A3(n91), .A4(n59), .ZN(n124) );
  NAND4_X1 U144 ( .A1(block_e[2]), .A2(sel[2]), .A3(n57), .A4(n76), .ZN(n123)
         );
  NAND2_X1 U145 ( .A1(n124), .A2(n123), .ZN(n130) );
  NAND4_X1 U146 ( .A1(n86), .A2(block_f[2]), .A3(sel[2]), .A4(n89), .ZN(n128)
         );
  NAND4_X1 U147 ( .A1(n69), .A2(block_h[2]), .A3(n64), .A4(sel[2]), .ZN(n127)
         );
  NAND4_X1 U148 ( .A1(n69), .A2(block_d[2]), .A3(n86), .A4(n81), .ZN(n126) );
  NAND4_X1 U149 ( .A1(n125), .A2(n127), .A3(n126), .A4(n128), .ZN(n129) );
  OR3_X1 U150 ( .A1(n131), .A2(n129), .A3(n130), .ZN(block_out[2]) );
  OAI211_X1 U151 ( .C1(n57), .C2(block_b[3]), .A(n92), .B(n184), .ZN(n135) );
  OAI21_X1 U152 ( .B1(block_a[3]), .B2(n87), .A(n49), .ZN(n134) );
  NAND3_X1 U153 ( .A1(block_j[3]), .A2(sel[3]), .A3(n63), .ZN(n133) );
  NAND3_X1 U154 ( .A1(block_i[3]), .A2(sel[3]), .A3(n56), .ZN(n132) );
  OAI211_X1 U155 ( .C1(n134), .C2(n135), .A(n133), .B(n132), .ZN(n144) );
  NAND4_X1 U156 ( .A1(n66), .A2(block_c[3]), .A3(n83), .A4(n62), .ZN(n137) );
  NAND4_X1 U157 ( .A1(block_e[3]), .A2(sel[2]), .A3(n72), .A4(n62), .ZN(n136)
         );
  NAND2_X1 U158 ( .A1(n137), .A2(n136), .ZN(n143) );
  NAND4_X1 U159 ( .A1(n64), .A2(sel[2]), .A3(block_f[3]), .A4(n72), .ZN(n141)
         );
  NAND4_X1 U160 ( .A1(block_h[3]), .A2(sel[2]), .A3(n58), .A4(n67), .ZN(n140)
         );
  NAND4_X1 U161 ( .A1(block_d[3]), .A2(n63), .A3(n70), .A4(n77), .ZN(n139) );
  NAND4_X1 U162 ( .A1(n140), .A2(n138), .A3(n139), .A4(n141), .ZN(n142) );
  OR3_X1 U163 ( .A1(n142), .A2(n144), .A3(n143), .ZN(block_out[3]) );
  OAI21_X1 U164 ( .B1(block_a[4]), .B2(n87), .A(n74), .ZN(n147) );
  NAND3_X1 U165 ( .A1(n63), .A2(sel[3]), .A3(block_j[4]), .ZN(n146) );
  NAND3_X1 U166 ( .A1(block_i[4]), .A2(sel[3]), .A3(n56), .ZN(n145) );
  OAI211_X1 U167 ( .C1(n147), .C2(n148), .A(n145), .B(n146), .ZN(n157) );
  NAND4_X1 U168 ( .A1(block_c[4]), .A2(n50), .A3(n77), .A4(n59), .ZN(n150) );
  NAND4_X1 U169 ( .A1(block_e[4]), .A2(sel[2]), .A3(n74), .A4(n59), .ZN(n149)
         );
  NAND2_X1 U170 ( .A1(n150), .A2(n149), .ZN(n156) );
  NAND4_X1 U171 ( .A1(n58), .A2(sel[2]), .A3(block_f[4]), .A4(n90), .ZN(n154)
         );
  NAND4_X1 U172 ( .A1(block_h[4]), .A2(sel[2]), .A3(n58), .A4(n68), .ZN(n153)
         );
  NAND4_X1 U173 ( .A1(block_d[4]), .A2(n65), .A3(n63), .A4(n80), .ZN(n152) );
  NAND4_X1 U174 ( .A1(n69), .A2(sel[2]), .A3(block_g[4]), .A4(n56), .ZN(n151)
         );
  NAND4_X1 U175 ( .A1(n153), .A2(n151), .A3(n152), .A4(n154), .ZN(n155) );
  OR3_X1 U176 ( .A1(n155), .A2(n157), .A3(n156), .ZN(block_out[4]) );
  OAI21_X1 U177 ( .B1(block_a[5]), .B2(n86), .A(n74), .ZN(n160) );
  NAND3_X1 U178 ( .A1(block_j[5]), .A2(sel[3]), .A3(n86), .ZN(n159) );
  NAND3_X1 U179 ( .A1(block_i[5]), .A2(sel[3]), .A3(n57), .ZN(n158) );
  OAI211_X1 U180 ( .C1(n161), .C2(n160), .A(n159), .B(n158), .ZN(n170) );
  NAND4_X1 U181 ( .A1(block_c[5]), .A2(n50), .A3(n91), .A4(n59), .ZN(n163) );
  NAND4_X1 U182 ( .A1(block_e[5]), .A2(sel[2]), .A3(n49), .A4(n56), .ZN(n162)
         );
  NAND2_X1 U183 ( .A1(n163), .A2(n162), .ZN(n169) );
  NAND4_X1 U184 ( .A1(n63), .A2(block_f[5]), .A3(sel[2]), .A4(n76), .ZN(n167)
         );
  NAND4_X1 U185 ( .A1(block_h[5]), .A2(n70), .A3(n64), .A4(sel[2]), .ZN(n166)
         );
  NAND4_X1 U186 ( .A1(n60), .A2(n66), .A3(n86), .A4(block_d[5]), .ZN(n165) );
  NAND4_X1 U187 ( .A1(block_g[5]), .A2(n50), .A3(sel[2]), .A4(n53), .ZN(n164)
         );
  NAND4_X1 U188 ( .A1(n165), .A2(n166), .A3(n164), .A4(n167), .ZN(n168) );
  OR3_X1 U189 ( .A1(n170), .A2(n168), .A3(n169), .ZN(block_out[5]) );
  OAI21_X1 U190 ( .B1(block_a[6]), .B2(n87), .A(n52), .ZN(n173) );
  NAND3_X1 U191 ( .A1(block_j[6]), .A2(sel[3]), .A3(n58), .ZN(n172) );
  NAND3_X1 U192 ( .A1(block_i[6]), .A2(sel[3]), .A3(n57), .ZN(n171) );
  OAI211_X1 U193 ( .C1(n173), .C2(n174), .A(n172), .B(n171), .ZN(n183) );
  NAND4_X1 U194 ( .A1(block_c[6]), .A2(n82), .A3(n50), .A4(n62), .ZN(n176) );
  NAND4_X1 U195 ( .A1(n59), .A2(sel[2]), .A3(n71), .A4(block_e[6]), .ZN(n175)
         );
  NAND2_X1 U196 ( .A1(n176), .A2(n175), .ZN(n182) );
  NAND4_X1 U197 ( .A1(n64), .A2(sel[2]), .A3(block_f[6]), .A4(n74), .ZN(n180)
         );
  NAND4_X1 U198 ( .A1(block_h[6]), .A2(sel[2]), .A3(n86), .A4(n50), .ZN(n179)
         );
  NAND4_X1 U199 ( .A1(block_d[6]), .A2(n50), .A3(n64), .A4(n80), .ZN(n178) );
  NAND4_X1 U200 ( .A1(block_g[6]), .A2(sel[2]), .A3(n47), .A4(n88), .ZN(n177)
         );
  NAND4_X1 U201 ( .A1(n177), .A2(n179), .A3(n178), .A4(n180), .ZN(n181) );
  OR3_X1 U202 ( .A1(n181), .A2(n183), .A3(n182), .ZN(block_out[6]) );
  OAI21_X1 U203 ( .B1(block_a[7]), .B2(n64), .A(n52), .ZN(n187) );
  NAND3_X1 U204 ( .A1(block_j[7]), .A2(sel[3]), .A3(n64), .ZN(n186) );
  NAND3_X1 U205 ( .A1(block_i[7]), .A2(sel[3]), .A3(n59), .ZN(n185) );
  OAI211_X1 U206 ( .C1(n188), .C2(n187), .A(n186), .B(n185), .ZN(n197) );
  NAND4_X1 U207 ( .A1(block_c[7]), .A2(n50), .A3(n80), .A4(n56), .ZN(n190) );
  NAND4_X1 U208 ( .A1(block_e[7]), .A2(sel[2]), .A3(n90), .A4(n56), .ZN(n189)
         );
  NAND2_X1 U209 ( .A1(n190), .A2(n189), .ZN(n196) );
  NAND4_X1 U210 ( .A1(n64), .A2(sel[2]), .A3(block_f[7]), .A4(n74), .ZN(n194)
         );
  NAND4_X1 U211 ( .A1(block_h[7]), .A2(sel[2]), .A3(n58), .A4(n66), .ZN(n193)
         );
  NAND4_X1 U212 ( .A1(n191), .A2(n193), .A3(n192), .A4(n194), .ZN(n195) );
  OR3_X1 U213 ( .A1(n197), .A2(n195), .A3(n196), .ZN(block_out[7]) );
endmodule

