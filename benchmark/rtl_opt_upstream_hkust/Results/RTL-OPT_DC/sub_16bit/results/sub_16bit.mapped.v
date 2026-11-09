/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 23:43:43 2025
/////////////////////////////////////////////////////////////


module sub_16bit ( a, b, diff, overflow );
  input [15:0] a;
  input [15:0] b;
  output [15:0] diff;
  output overflow;
  wire   extended_diff_16_, sub_8_n284, sub_8_n283, sub_8_n282, sub_8_n281,
         sub_8_n280, sub_8_n279, sub_8_n278, sub_8_n277, sub_8_n276,
         sub_8_n275, sub_8_n274, sub_8_n273, sub_8_n272, sub_8_n271,
         sub_8_n270, sub_8_n269, sub_8_n268, sub_8_n267, sub_8_n266,
         sub_8_n265, sub_8_n264, sub_8_n263, sub_8_n262, sub_8_n261,
         sub_8_n260, sub_8_n259, sub_8_n258, sub_8_n257, sub_8_n256,
         sub_8_n255, sub_8_n254, sub_8_n253, sub_8_n252, sub_8_n251,
         sub_8_n250, sub_8_n249, sub_8_n248, sub_8_n247, sub_8_n246,
         sub_8_n245, sub_8_n244, sub_8_n243, sub_8_n242, sub_8_n241,
         sub_8_n240, sub_8_n239, sub_8_n238, sub_8_n237, sub_8_n236,
         sub_8_n235, sub_8_n234, sub_8_n233, sub_8_n232, sub_8_n231,
         sub_8_n230, sub_8_n229, sub_8_n228, sub_8_n227, sub_8_n226,
         sub_8_n225, sub_8_n224, sub_8_n223, sub_8_n222, sub_8_n221,
         sub_8_n220, sub_8_n219, sub_8_n218, sub_8_n217, sub_8_n216,
         sub_8_n215, sub_8_n214, sub_8_n213, sub_8_n212, sub_8_n211,
         sub_8_n210, sub_8_n209, sub_8_n208, sub_8_n207, sub_8_n206,
         sub_8_n205, sub_8_n204, sub_8_n203, sub_8_n202, sub_8_n201,
         sub_8_n200, sub_8_n199, sub_8_n198, sub_8_n197, sub_8_n196,
         sub_8_n195, sub_8_n194, sub_8_n193, sub_8_n192, sub_8_n191,
         sub_8_n190, sub_8_n189, sub_8_n188, sub_8_n187, sub_8_n186,
         sub_8_n185, sub_8_n184, sub_8_n183, sub_8_n182, sub_8_n181,
         sub_8_n180, sub_8_n179, sub_8_n178, sub_8_n177, sub_8_n176,
         sub_8_n175, sub_8_n174, sub_8_n173, sub_8_n172, sub_8_n171,
         sub_8_n170, sub_8_n169, sub_8_n168, sub_8_n167, sub_8_n166,
         sub_8_n165, sub_8_n164, sub_8_n163, sub_8_n162, sub_8_n161,
         sub_8_n160, sub_8_n159, sub_8_n158, sub_8_n157, sub_8_n156,
         sub_8_n155, sub_8_n154, sub_8_n153, sub_8_n152, sub_8_n151,
         sub_8_n150, sub_8_n149, sub_8_n148, sub_8_n147, sub_8_n146,
         sub_8_n145, sub_8_n144, sub_8_n143, sub_8_n142, sub_8_n141,
         sub_8_n140, sub_8_n139, sub_8_n138, sub_8_n137, sub_8_n136,
         sub_8_n135, sub_8_n134, sub_8_n133, sub_8_n132, sub_8_n131,
         sub_8_n130, sub_8_n129, sub_8_n128, sub_8_n127, sub_8_n126,
         sub_8_n125, sub_8_n124, sub_8_n123, sub_8_n122, sub_8_n121,
         sub_8_n120, sub_8_n119, sub_8_n118, sub_8_n117, sub_8_n116,
         sub_8_n115, sub_8_n114, sub_8_n113, sub_8_n112, sub_8_n111,
         sub_8_n110, sub_8_n109, sub_8_n108, sub_8_n107, sub_8_n106,
         sub_8_n105, sub_8_n104, sub_8_n103, sub_8_n102, sub_8_n101,
         sub_8_n100, sub_8_n99, sub_8_n98, sub_8_n97, sub_8_n96, sub_8_n95,
         sub_8_n94, sub_8_n93, sub_8_n92, sub_8_n91, sub_8_n90, sub_8_n89,
         sub_8_n88, sub_8_n87, sub_8_n86, sub_8_n85, sub_8_n84, sub_8_n83,
         sub_8_n82, sub_8_n81, sub_8_n79, sub_8_n78, sub_8_n77, sub_8_n76,
         sub_8_n75, sub_8_n74, sub_8_n73, sub_8_n72, sub_8_n71, sub_8_n70,
         sub_8_n69, sub_8_n68, sub_8_n67, sub_8_n66, sub_8_n65, sub_8_n64,
         sub_8_n63, sub_8_n62, sub_8_n61, sub_8_n60, sub_8_n59, sub_8_n58,
         sub_8_n57, sub_8_n56, sub_8_n55, sub_8_n54, sub_8_n53, sub_8_n52,
         sub_8_n51, sub_8_n50, sub_8_n49, sub_8_n48, sub_8_n47, sub_8_n46,
         sub_8_n45, sub_8_n44, sub_8_n43, sub_8_n42, sub_8_n41, sub_8_n40,
         sub_8_n39, sub_8_n38, sub_8_n37, sub_8_n36, sub_8_n35, sub_8_n34,
         sub_8_n33, sub_8_n32, sub_8_n31, sub_8_n30, sub_8_n29, sub_8_n28,
         sub_8_n27, sub_8_n26, sub_8_n25, sub_8_n24, sub_8_n23, sub_8_n22,
         sub_8_n21, sub_8_n20, sub_8_n19, sub_8_n18, sub_8_n17, sub_8_n16,
         sub_8_n15, sub_8_n14, sub_8_n13, sub_8_n12, sub_8_n11, sub_8_n10,
         sub_8_n9, sub_8_n8, sub_8_n7, sub_8_n6, sub_8_n5, sub_8_n4, sub_8_n3,
         sub_8_n2, sub_8_n1;

  XOR2_X1 U4 ( .A(extended_diff_16_), .B(diff[15]), .Z(overflow) );
  INV_X1 sub_8_U302 ( .A(sub_8_n142), .ZN(sub_8_n283) );
  NOR2_X1 sub_8_U301 ( .A1(sub_8_n36), .A2(sub_8_n35), .ZN(sub_8_n274) );
  NAND3_X1 sub_8_U300 ( .A1(sub_8_n154), .A2(sub_8_n50), .A3(sub_8_n83), .ZN(
        sub_8_n275) );
  NAND3_X1 sub_8_U299 ( .A1(sub_8_n155), .A2(sub_8_n274), .A3(sub_8_n275), 
        .ZN(sub_8_n272) );
  NOR2_X1 sub_8_U298 ( .A1(sub_8_n89), .A2(sub_8_n260), .ZN(sub_8_n259) );
  NAND3_X1 sub_8_U297 ( .A1(sub_8_n62), .A2(sub_8_n43), .A3(sub_8_n126), .ZN(
        sub_8_n172) );
  NAND3_X1 sub_8_U296 ( .A1(sub_8_n251), .A2(sub_8_n88), .A3(sub_8_n40), .ZN(
        sub_8_n254) );
  NAND3_X1 sub_8_U295 ( .A1(sub_8_n71), .A2(sub_8_n88), .A3(sub_8_n69), .ZN(
        sub_8_n248) );
  INV_X1 sub_8_U294 ( .A(sub_8_n20), .ZN(sub_8_n250) );
  NOR2_X1 sub_8_U293 ( .A1(sub_8_n36), .A2(sub_8_n35), .ZN(sub_8_n232) );
  NAND3_X1 sub_8_U292 ( .A1(sub_8_n154), .A2(sub_8_n51), .A3(sub_8_n83), .ZN(
        sub_8_n233) );
  NAND3_X1 sub_8_U291 ( .A1(sub_8_n232), .A2(sub_8_n155), .A3(sub_8_n233), 
        .ZN(sub_8_n191) );
  INV_X1 sub_8_U290 ( .A(sub_8_n88), .ZN(sub_8_n99) );
  NOR2_X1 sub_8_U289 ( .A1(sub_8_n90), .A2(sub_8_n91), .ZN(sub_8_n231) );
  INV_X1 sub_8_U288 ( .A(sub_8_n65), .ZN(sub_8_n195) );
  NAND3_X1 sub_8_U287 ( .A1(sub_8_n33), .A2(sub_8_n127), .A3(sub_8_n218), .ZN(
        sub_8_n217) );
  NAND2_X1 sub_8_U286 ( .A1(sub_8_n216), .A2(sub_8_n217), .ZN(sub_8_n215) );
  NOR2_X1 sub_8_U285 ( .A1(sub_8_n21), .A2(sub_8_n90), .ZN(sub_8_n200) );
  NAND2_X1 sub_8_U284 ( .A1(sub_8_n41), .A2(sub_8_n200), .ZN(sub_8_n194) );
  INV_X1 sub_8_U283 ( .A(sub_8_n178), .ZN(sub_8_n197) );
  NAND2_X1 sub_8_U282 ( .A1(sub_8_n191), .A2(sub_8_n48), .ZN(sub_8_n189) );
  NAND2_X1 sub_8_U281 ( .A1(sub_8_n73), .A2(sub_8_n41), .ZN(sub_8_n190) );
  INV_X1 sub_8_U280 ( .A(sub_8_n94), .ZN(sub_8_n188) );
  NAND3_X1 sub_8_U279 ( .A1(a[4]), .A2(sub_8_n157), .A3(sub_8_n50), .ZN(
        sub_8_n156) );
  NAND3_X1 sub_8_U278 ( .A1(sub_8_n150), .A2(sub_8_n148), .A3(sub_8_n149), 
        .ZN(sub_8_n147) );
  MUX2_X1 sub_8_U277 ( .A(sub_8_n143), .B(sub_8_n169), .S(sub_8_n145), .Z(
        extended_diff_16_) );
  INV_X1 sub_8_U276 ( .A(sub_8_n138), .ZN(sub_8_n134) );
  INV_X1 sub_8_U275 ( .A(sub_8_n137), .ZN(sub_8_n135) );
  INV_X1 sub_8_U274 ( .A(sub_8_n132), .ZN(sub_8_n128) );
  INV_X1 sub_8_U273 ( .A(sub_8_n43), .ZN(sub_8_n129) );
  OAI21_X1 sub_8_U272 ( .B1(sub_8_n128), .B2(sub_8_n129), .A(sub_8_n130), .ZN(
        sub_8_n124) );
  XNOR2_X1 sub_8_U271 ( .A(sub_8_n124), .B(sub_8_n125), .ZN(diff[3]) );
  INV_X1 sub_8_U270 ( .A(sub_8_n112), .ZN(sub_8_n108) );
  INV_X1 sub_8_U269 ( .A(sub_8_n111), .ZN(sub_8_n109) );
  NAND2_X1 sub_8_U268 ( .A1(sub_8_n47), .A2(sub_8_n126), .ZN(sub_8_n202) );
  NAND4_X1 sub_8_U267 ( .A1(sub_8_n203), .A2(sub_8_n164), .A3(sub_8_n131), 
        .A4(sub_8_n63), .ZN(sub_8_n201) );
  NAND2_X1 sub_8_U266 ( .A1(sub_8_n131), .A2(sub_8_n63), .ZN(sub_8_n220) );
  NAND4_X1 sub_8_U265 ( .A1(sub_8_n53), .A2(sub_8_n4), .A3(sub_8_n54), .A4(
        sub_8_n160), .ZN(sub_8_n159) );
  NAND2_X1 sub_8_U264 ( .A1(sub_8_n117), .A2(sub_8_n78), .ZN(sub_8_n116) );
  NAND2_X1 sub_8_U263 ( .A1(sub_8_n44), .A2(sub_8_n54), .ZN(sub_8_n243) );
  NAND2_X1 sub_8_U262 ( .A1(sub_8_n117), .A2(sub_8_n54), .ZN(sub_8_n256) );
  NAND2_X1 sub_8_U261 ( .A1(sub_8_n44), .A2(sub_8_n118), .ZN(sub_8_n120) );
  NAND2_X1 sub_8_U260 ( .A1(sub_8_n126), .A2(sub_8_n127), .ZN(sub_8_n125) );
  XNOR2_X1 sub_8_U259 ( .A(sub_8_n44), .B(sub_8_n121), .ZN(diff[4]) );
  NAND2_X1 sub_8_U258 ( .A1(sub_8_n94), .A2(sub_8_n169), .ZN(sub_8_n175) );
  NAND2_X1 sub_8_U257 ( .A1(sub_8_n87), .A2(sub_8_n27), .ZN(sub_8_n150) );
  NAND2_X1 sub_8_U256 ( .A1(sub_8_n182), .A2(sub_8_n169), .ZN(sub_8_n143) );
  OAI21_X1 sub_8_U255 ( .B1(sub_8_n70), .B2(sub_8_n170), .A(sub_8_n151), .ZN(
        sub_8_n234) );
  NOR2_X1 sub_8_U254 ( .A1(sub_8_n92), .A2(sub_8_n165), .ZN(sub_8_n158) );
  NAND2_X1 sub_8_U253 ( .A1(sub_8_n158), .A2(sub_8_n159), .ZN(sub_8_n146) );
  XNOR2_X1 sub_8_U252 ( .A(sub_8_n234), .B(sub_8_n235), .ZN(diff[12]) );
  OAI211_X1 sub_8_U251 ( .C1(sub_8_n113), .C2(sub_8_n114), .A(sub_8_n116), .B(
        sub_8_n115), .ZN(sub_8_n112) );
  OAI21_X1 sub_8_U250 ( .B1(sub_8_n70), .B2(sub_8_n99), .A(sub_8_n42), .ZN(
        sub_8_n95) );
  XNOR2_X1 sub_8_U249 ( .A(sub_8_n95), .B(sub_8_n96), .ZN(diff[9]) );
  INV_X1 sub_8_U248 ( .A(a[3]), .ZN(sub_8_n266) );
  NAND2_X1 sub_8_U247 ( .A1(sub_8_n256), .A2(sub_8_n255), .ZN(sub_8_n251) );
  NAND2_X1 sub_8_U246 ( .A1(sub_8_n184), .A2(sub_8_n185), .ZN(sub_8_n181) );
  XNOR2_X1 sub_8_U245 ( .A(sub_8_n181), .B(sub_8_n143), .ZN(diff[15]) );
  OAI21_X1 sub_8_U244 ( .B1(sub_8_n108), .B2(sub_8_n109), .A(sub_8_n110), .ZN(
        sub_8_n104) );
  XNOR2_X1 sub_8_U243 ( .A(sub_8_n104), .B(sub_8_n105), .ZN(diff[7]) );
  NAND2_X1 sub_8_U242 ( .A1(sub_8_n59), .A2(sub_8_n29), .ZN(sub_8_n151) );
  AND2_X1 sub_8_U241 ( .A1(sub_8_n242), .A2(sub_8_n100), .ZN(sub_8_n255) );
  NOR2_X1 sub_8_U240 ( .A1(sub_8_n146), .A2(sub_8_n147), .ZN(sub_8_n145) );
  NAND2_X1 sub_8_U239 ( .A1(sub_8_n88), .A2(sub_8_n100), .ZN(sub_8_n102) );
  AND2_X1 sub_8_U238 ( .A1(sub_8_n84), .A2(sub_8_n127), .ZN(sub_8_n258) );
  NAND2_X1 sub_8_U237 ( .A1(sub_8_n230), .A2(sub_8_n71), .ZN(sub_8_n238) );
  INV_X1 sub_8_U236 ( .A(a[9]), .ZN(sub_8_n281) );
  NAND2_X1 sub_8_U235 ( .A1(sub_8_n52), .A2(sub_8_n93), .ZN(sub_8_n199) );
  NAND2_X1 sub_8_U234 ( .A1(sub_8_n167), .A2(sub_8_n176), .ZN(sub_8_n174) );
  NAND2_X1 sub_8_U233 ( .A1(sub_8_n210), .A2(sub_8_n38), .ZN(sub_8_n209) );
  NAND2_X1 sub_8_U232 ( .A1(sub_8_n167), .A2(sub_8_n179), .ZN(sub_8_n211) );
  AOI21_X1 sub_8_U231 ( .B1(sub_8_n46), .B2(sub_8_n22), .A(sub_8_n250), .ZN(
        sub_8_n249) );
  NOR2_X1 sub_8_U230 ( .A1(sub_8_n263), .A2(sub_8_n220), .ZN(sub_8_n262) );
  OAI211_X1 sub_8_U229 ( .C1(sub_8_n283), .C2(sub_8_n163), .A(sub_8_n43), .B(
        sub_8_n164), .ZN(sub_8_n162) );
  OAI21_X1 sub_8_U228 ( .B1(sub_8_n264), .B2(sub_8_n82), .A(sub_8_n164), .ZN(
        sub_8_n263) );
  INV_X1 sub_8_U227 ( .A(a[15]), .ZN(sub_8_n180) );
  NAND2_X1 sub_8_U226 ( .A1(b[15]), .A2(sub_8_n180), .ZN(sub_8_n169) );
  NAND2_X1 sub_8_U225 ( .A1(b[15]), .A2(sub_8_n180), .ZN(sub_8_n144) );
  INV_X1 sub_8_U224 ( .A(a[14]), .ZN(sub_8_n208) );
  NAND2_X1 sub_8_U223 ( .A1(b[14]), .A2(sub_8_n208), .ZN(sub_8_n168) );
  NAND2_X1 sub_8_U222 ( .A1(b[14]), .A2(sub_8_n7), .ZN(sub_8_n94) );
  NAND2_X1 sub_8_U221 ( .A1(b[14]), .A2(sub_8_n6), .ZN(sub_8_n93) );
  NOR2_X1 sub_8_U220 ( .A1(sub_8_n74), .A2(sub_8_n34), .ZN(sub_8_n216) );
  NOR2_X1 sub_8_U219 ( .A1(sub_8_n77), .A2(sub_8_n225), .ZN(sub_8_n214) );
  NAND2_X1 sub_8_U218 ( .A1(sub_8_n215), .A2(sub_8_n214), .ZN(sub_8_n210) );
  NAND2_X1 sub_8_U217 ( .A1(sub_8_n242), .A2(sub_8_n243), .ZN(sub_8_n101) );
  INV_X1 sub_8_U216 ( .A(a[12]), .ZN(sub_8_n236) );
  OAI21_X1 sub_8_U215 ( .B1(sub_8_n13), .B2(sub_8_n248), .A(sub_8_n249), .ZN(
        sub_8_n244) );
  XNOR2_X1 sub_8_U214 ( .A(sub_8_n244), .B(sub_8_n245), .ZN(diff[11]) );
  NOR2_X1 sub_8_U213 ( .A1(sub_8_n58), .A2(sub_8_n219), .ZN(sub_8_n218) );
  NOR2_X1 sub_8_U212 ( .A1(sub_8_n262), .A2(sub_8_n58), .ZN(sub_8_n257) );
  INV_X1 sub_8_U211 ( .A(a[11]), .ZN(sub_8_n247) );
  AND2_X1 sub_8_U210 ( .A1(b[11]), .A2(sub_8_n247), .ZN(sub_8_n90) );
  XNOR2_X1 sub_8_U209 ( .A(sub_8_n101), .B(sub_8_n102), .ZN(diff[8]) );
  NOR2_X1 sub_8_U208 ( .A1(sub_8_n192), .A2(sub_8_n193), .ZN(sub_8_n184) );
  INV_X1 sub_8_U207 ( .A(a[8]), .ZN(sub_8_n280) );
  NAND2_X1 sub_8_U206 ( .A1(b[8]), .A2(sub_8_n11), .ZN(sub_8_n103) );
  NAND2_X1 sub_8_U205 ( .A1(b[8]), .A2(sub_8_n280), .ZN(sub_8_n88) );
  OAI21_X1 sub_8_U204 ( .B1(sub_8_n60), .B2(sub_8_n238), .A(sub_8_n239), .ZN(
        sub_8_n228) );
  NAND2_X1 sub_8_U203 ( .A1(b[11]), .A2(sub_8_n14), .ZN(sub_8_n227) );
  AND2_X1 sub_8_U202 ( .A1(sub_8_n228), .A2(sub_8_n59), .ZN(sub_8_n87) );
  NOR2_X1 sub_8_U201 ( .A1(sub_8_n186), .A2(sub_8_n187), .ZN(sub_8_n185) );
  NAND2_X1 sub_8_U200 ( .A1(sub_8_n59), .A2(sub_8_n23), .ZN(sub_8_n245) );
  NAND2_X1 sub_8_U199 ( .A1(sub_8_n59), .A2(sub_8_n5), .ZN(sub_8_n226) );
  INV_X1 sub_8_U198 ( .A(a[10]), .ZN(sub_8_n253) );
  NAND2_X1 sub_8_U197 ( .A1(b[10]), .A2(sub_8_n17), .ZN(sub_8_n230) );
  NAND2_X1 sub_8_U196 ( .A1(a[3]), .A2(sub_8_n261), .ZN(sub_8_n127) );
  AND2_X1 sub_8_U195 ( .A1(sub_8_n201), .A2(sub_8_n202), .ZN(sub_8_n86) );
  NAND3_X1 sub_8_U194 ( .A1(sub_8_n259), .A2(sub_8_n43), .A3(sub_8_n4), .ZN(
        sub_8_n84) );
  NAND2_X1 sub_8_U193 ( .A1(sub_8_n161), .A2(sub_8_n162), .ZN(sub_8_n160) );
  NAND4_X1 sub_8_U192 ( .A1(sub_8_n268), .A2(sub_8_n269), .A3(sub_8_n119), 
        .A4(sub_8_n106), .ZN(sub_8_n171) );
  NOR2_X1 sub_8_U191 ( .A1(sub_8_n199), .A2(sub_8_n171), .ZN(sub_8_n204) );
  INV_X1 sub_8_U190 ( .A(b[15]), .ZN(sub_8_n183) );
  NAND2_X1 sub_8_U189 ( .A1(a[15]), .A2(sub_8_n183), .ZN(sub_8_n182) );
  NAND2_X1 sub_8_U188 ( .A1(a[1]), .A2(sub_8_n140), .ZN(sub_8_n136) );
  NAND2_X1 sub_8_U187 ( .A1(a[4]), .A2(sub_8_n122), .ZN(sub_8_n114) );
  NAND2_X1 sub_8_U186 ( .A1(sub_8_n31), .A2(sub_8_n67), .ZN(sub_8_n137) );
  NAND2_X1 sub_8_U185 ( .A1(a[0]), .A2(sub_8_n45), .ZN(sub_8_n142) );
  NAND2_X1 sub_8_U184 ( .A1(b[4]), .A2(sub_8_n123), .ZN(sub_8_n118) );
  INV_X1 sub_8_U183 ( .A(b[3]), .ZN(sub_8_n261) );
  INV_X1 sub_8_U182 ( .A(b[14]), .ZN(sub_8_n207) );
  NAND2_X1 sub_8_U181 ( .A1(a[14]), .A2(sub_8_n207), .ZN(sub_8_n178) );
  INV_X1 sub_8_U180 ( .A(b[13]), .ZN(sub_8_n212) );
  NAND2_X1 sub_8_U179 ( .A1(a[13]), .A2(sub_8_n212), .ZN(sub_8_n179) );
  NOR2_X1 sub_8_U178 ( .A1(sub_8_n31), .A2(sub_8_n68), .ZN(sub_8_n163) );
  NAND2_X1 sub_8_U177 ( .A1(b[6]), .A2(sub_8_n270), .ZN(sub_8_n154) );
  INV_X1 sub_8_U176 ( .A(b[4]), .ZN(sub_8_n157) );
  NAND2_X1 sub_8_U175 ( .A1(sub_8_n156), .A2(sub_8_n110), .ZN(sub_8_n152) );
  INV_X1 sub_8_U174 ( .A(a[4]), .ZN(sub_8_n123) );
  AND2_X1 sub_8_U173 ( .A1(a[4]), .A2(sub_8_n122), .ZN(sub_8_n83) );
  INV_X1 sub_8_U172 ( .A(b[4]), .ZN(sub_8_n122) );
  INV_X1 sub_8_U171 ( .A(b[12]), .ZN(sub_8_n237) );
  INV_X1 sub_8_U170 ( .A(b[11]), .ZN(sub_8_n246) );
  NAND2_X1 sub_8_U169 ( .A1(sub_8_n246), .A2(a[11]), .ZN(sub_8_n240) );
  INV_X1 sub_8_U168 ( .A(a[2]), .ZN(sub_8_n265) );
  INV_X1 sub_8_U167 ( .A(b[10]), .ZN(sub_8_n252) );
  NAND2_X1 sub_8_U166 ( .A1(a[10]), .A2(sub_8_n252), .ZN(sub_8_n241) );
  INV_X1 sub_8_U165 ( .A(b[7]), .ZN(sub_8_n277) );
  INV_X1 sub_8_U164 ( .A(a[5]), .ZN(sub_8_n276) );
  INV_X1 sub_8_U163 ( .A(a[7]), .ZN(sub_8_n273) );
  NAND2_X1 sub_8_U162 ( .A1(b[6]), .A2(sub_8_n270), .ZN(sub_8_n269) );
  NAND2_X1 sub_8_U161 ( .A1(b[4]), .A2(sub_8_n123), .ZN(sub_8_n268) );
  INV_X1 sub_8_U160 ( .A(b[6]), .ZN(sub_8_n278) );
  NAND2_X1 sub_8_U159 ( .A1(a[6]), .A2(sub_8_n278), .ZN(sub_8_n110) );
  INV_X1 sub_8_U158 ( .A(b[5]), .ZN(sub_8_n279) );
  NAND2_X1 sub_8_U157 ( .A1(a[5]), .A2(sub_8_n279), .ZN(sub_8_n115) );
  INV_X1 sub_8_U156 ( .A(a[0]), .ZN(sub_8_n284) );
  INV_X1 sub_8_U155 ( .A(a[6]), .ZN(sub_8_n270) );
  NAND2_X1 sub_8_U154 ( .A1(b[6]), .A2(sub_8_n270), .ZN(sub_8_n111) );
  AND2_X1 sub_8_U153 ( .A1(sub_8_n45), .A2(a[0]), .ZN(sub_8_n82) );
  INV_X1 sub_8_U152 ( .A(b[2]), .ZN(sub_8_n267) );
  INV_X1 sub_8_U151 ( .A(b[9]), .ZN(sub_8_n282) );
  NAND2_X1 sub_8_U150 ( .A1(a[9]), .A2(sub_8_n282), .ZN(sub_8_n98) );
  INV_X1 sub_8_U149 ( .A(b[0]), .ZN(sub_8_n224) );
  INV_X1 sub_8_U148 ( .A(b[8]), .ZN(sub_8_n271) );
  NAND2_X1 sub_8_U147 ( .A1(a[8]), .A2(sub_8_n25), .ZN(sub_8_n100) );
  NOR2_X1 sub_8_U146 ( .A1(sub_8_n57), .A2(a[1]), .ZN(sub_8_n260) );
  NAND2_X1 sub_8_U145 ( .A1(b[1]), .A2(sub_8_n141), .ZN(sub_8_n164) );
  NOR2_X1 sub_8_U144 ( .A1(sub_8_n31), .A2(sub_8_n68), .ZN(sub_8_n264) );
  INV_X1 sub_8_U143 ( .A(a[1]), .ZN(sub_8_n141) );
  NAND2_X1 sub_8_U142 ( .A1(sub_8_n56), .A2(a[1]), .ZN(sub_8_n222) );
  NAND2_X1 sub_8_U141 ( .A1(sub_8_n224), .A2(a[0]), .ZN(sub_8_n223) );
  NAND2_X1 sub_8_U140 ( .A1(sub_8_n222), .A2(sub_8_n223), .ZN(sub_8_n203) );
  INV_X1 sub_8_U139 ( .A(sub_8_n31), .ZN(sub_8_n140) );
  NAND2_X1 sub_8_U138 ( .A1(b[12]), .A2(sub_8_n236), .ZN(sub_8_n166) );
  INV_X1 sub_8_U137 ( .A(a[13]), .ZN(sub_8_n213) );
  NAND2_X1 sub_8_U136 ( .A1(b[13]), .A2(sub_8_n213), .ZN(sub_8_n167) );
  OR2_X1 sub_8_U135 ( .A1(sub_8_n12), .A2(sub_8_n82), .ZN(diff[0]) );
  NAND2_X1 sub_8_U134 ( .A1(sub_8_n137), .A2(sub_8_n136), .ZN(sub_8_n139) );
  XNOR2_X1 sub_8_U133 ( .A(sub_8_n138), .B(sub_8_n139), .ZN(diff[1]) );
  NAND2_X1 sub_8_U132 ( .A1(sub_8_n43), .A2(sub_8_n130), .ZN(sub_8_n133) );
  XNOR2_X1 sub_8_U131 ( .A(sub_8_n132), .B(sub_8_n133), .ZN(diff[2]) );
  NAND2_X1 sub_8_U130 ( .A1(sub_8_n118), .A2(sub_8_n114), .ZN(sub_8_n121) );
  NOR2_X1 sub_8_U129 ( .A1(sub_8_n188), .A2(sub_8_n179), .ZN(sub_8_n187) );
  NAND2_X1 sub_8_U128 ( .A1(sub_8_n12), .A2(sub_8_n142), .ZN(sub_8_n138) );
  OAI21_X1 sub_8_U127 ( .B1(sub_8_n134), .B2(sub_8_n135), .A(sub_8_n136), .ZN(
        sub_8_n132) );
  AND2_X1 sub_8_U126 ( .A1(sub_8_n49), .A2(sub_8_n154), .ZN(sub_8_n153) );
  XNOR2_X1 sub_8_U125 ( .A(sub_8_n3), .B(sub_8_n211), .ZN(diff[13]) );
  NAND2_X1 sub_8_U124 ( .A1(sub_8_n272), .A2(sub_8_n49), .ZN(sub_8_n242) );
  INV_X1 sub_8_U123 ( .A(sub_8_n177), .ZN(sub_8_n176) );
  AND2_X1 sub_8_U122 ( .A1(sub_8_n178), .A2(sub_8_n179), .ZN(sub_8_n173) );
  AOI21_X1 sub_8_U121 ( .B1(sub_8_n173), .B2(sub_8_n174), .A(sub_8_n175), .ZN(
        sub_8_n165) );
  NAND2_X1 sub_8_U120 ( .A1(sub_8_n2), .A2(sub_8_n111), .ZN(sub_8_n155) );
  NOR2_X1 sub_8_U119 ( .A1(sub_8_n197), .A2(sub_8_n198), .ZN(sub_8_n196) );
  OAI21_X1 sub_8_U118 ( .B1(sub_8_n194), .B2(sub_8_n195), .A(sub_8_n196), .ZN(
        sub_8_n193) );
  NOR2_X1 sub_8_U117 ( .A1(sub_8_n177), .A2(sub_8_n199), .ZN(sub_8_n198) );
  OAI211_X1 sub_8_U116 ( .C1(sub_8_n152), .C2(sub_8_n26), .A(sub_8_n153), .B(
        sub_8_n85), .ZN(sub_8_n149) );
  NAND2_X1 sub_8_U115 ( .A1(sub_8_n35), .A2(sub_8_n53), .ZN(sub_8_n148) );
  NAND2_X1 sub_8_U114 ( .A1(sub_8_n254), .A2(sub_8_n37), .ZN(sub_8_n79) );
  NAND2_X1 sub_8_U113 ( .A1(sub_8_n40), .A2(sub_8_n37), .ZN(sub_8_n96) );
  OAI21_X1 sub_8_U112 ( .B1(sub_8_n195), .B2(sub_8_n226), .A(sub_8_n177), .ZN(
        sub_8_n225) );
  AND2_X1 sub_8_U111 ( .A1(sub_8_n240), .A2(sub_8_n241), .ZN(sub_8_n239) );
  NAND2_X1 sub_8_U110 ( .A1(sub_8_n177), .A2(sub_8_n5), .ZN(sub_8_n235) );
  NAND2_X1 sub_8_U109 ( .A1(sub_8_n48), .A2(sub_8_n107), .ZN(sub_8_n105) );
  NAND2_X1 sub_8_U108 ( .A1(sub_8_n257), .A2(sub_8_n258), .ZN(sub_8_n117) );
  INV_X1 sub_8_U107 ( .A(sub_8_n78), .ZN(sub_8_n113) );
  AND2_X1 sub_8_U106 ( .A1(sub_8_n118), .A2(sub_8_n51), .ZN(sub_8_n78) );
  NAND2_X1 sub_8_U105 ( .A1(sub_8_n203), .A2(sub_8_n164), .ZN(sub_8_n221) );
  NOR2_X1 sub_8_U104 ( .A1(sub_8_n220), .A2(sub_8_n221), .ZN(sub_8_n219) );
  NOR2_X1 sub_8_U103 ( .A1(sub_8_n189), .A2(sub_8_n190), .ZN(sub_8_n186) );
  AND3_X1 sub_8_U102 ( .A1(sub_8_n191), .A2(sub_8_n49), .A3(sub_8_n28), .ZN(
        sub_8_n77) );
  NAND2_X1 sub_8_U101 ( .A1(sub_8_n209), .A2(sub_8_n179), .ZN(sub_8_n205) );
  NAND2_X1 sub_8_U100 ( .A1(sub_8_n94), .A2(sub_8_n178), .ZN(sub_8_n206) );
  XNOR2_X1 sub_8_U99 ( .A(sub_8_n205), .B(sub_8_n206), .ZN(diff[14]) );
  NOR3_X1 sub_8_U98 ( .A1(sub_8_n76), .A2(sub_8_n172), .A3(sub_8_n24), .ZN(
        sub_8_n92) );
  NAND2_X1 sub_8_U97 ( .A1(sub_8_n66), .A2(sub_8_n55), .ZN(sub_8_n76) );
  AND2_X1 sub_8_U96 ( .A1(sub_8_n50), .A2(sub_8_n115), .ZN(sub_8_n75) );
  INV_X1 sub_8_U95 ( .A(sub_8_n73), .ZN(sub_8_n74) );
  AND4_X1 sub_8_U94 ( .A1(sub_8_n52), .A2(sub_8_n166), .A3(sub_8_n168), .A4(
        sub_8_n144), .ZN(sub_8_n81) );
  NAND2_X1 sub_8_U93 ( .A1(sub_8_n72), .A2(b[9]), .ZN(sub_8_n97) );
  INV_X1 sub_8_U92 ( .A(a[9]), .ZN(sub_8_n72) );
  NAND2_X1 sub_8_U91 ( .A1(sub_8_n281), .A2(b[9]), .ZN(sub_8_n71) );
  AND2_X1 sub_8_U90 ( .A1(sub_8_n243), .A2(sub_8_n242), .ZN(sub_8_n70) );
  NAND2_X1 sub_8_U89 ( .A1(sub_8_n253), .A2(b[10]), .ZN(sub_8_n69) );
  INV_X1 sub_8_U88 ( .A(a[1]), .ZN(sub_8_n68) );
  INV_X1 sub_8_U87 ( .A(a[1]), .ZN(sub_8_n67) );
  AND4_X2 sub_8_U86 ( .A1(sub_8_n103), .A2(sub_8_n230), .A3(sub_8_n97), .A4(
        sub_8_n227), .ZN(sub_8_n66) );
  OAI21_X1 sub_8_U85 ( .B1(sub_8_n61), .B2(sub_8_n39), .A(sub_8_n32), .ZN(
        sub_8_n65) );
  NAND2_X1 sub_8_U84 ( .A1(sub_8_n64), .A2(b[3]), .ZN(sub_8_n126) );
  INV_X1 sub_8_U83 ( .A(a[3]), .ZN(sub_8_n64) );
  NAND2_X1 sub_8_U82 ( .A1(sub_8_n266), .A2(b[3]), .ZN(sub_8_n63) );
  NOR2_X1 sub_8_U81 ( .A1(sub_8_n89), .A2(sub_8_n260), .ZN(sub_8_n62) );
  AND2_X1 sub_8_U80 ( .A1(sub_8_n98), .A2(sub_8_n42), .ZN(sub_8_n61) );
  AND2_X1 sub_8_U79 ( .A1(sub_8_n98), .A2(sub_8_n100), .ZN(sub_8_n60) );
  NAND2_X1 sub_8_U78 ( .A1(b[11]), .A2(sub_8_n15), .ZN(sub_8_n59) );
  AND2_X1 sub_8_U77 ( .A1(sub_8_n47), .A2(sub_8_n4), .ZN(sub_8_n58) );
  INV_X1 sub_8_U76 ( .A(b[1]), .ZN(sub_8_n57) );
  INV_X1 sub_8_U75 ( .A(b[1]), .ZN(sub_8_n56) );
  AND4_X1 sub_8_U74 ( .A1(sub_8_n52), .A2(sub_8_n166), .A3(sub_8_n168), .A4(
        sub_8_n144), .ZN(sub_8_n55) );
  AND4_X1 sub_8_U73 ( .A1(sub_8_n268), .A2(sub_8_n269), .A3(sub_8_n51), .A4(
        sub_8_n48), .ZN(sub_8_n54) );
  AND2_X1 sub_8_U72 ( .A1(sub_8_n66), .A2(sub_8_n81), .ZN(sub_8_n85) );
  AND2_X1 sub_8_U71 ( .A1(sub_8_n66), .A2(sub_8_n81), .ZN(sub_8_n53) );
  NAND2_X1 sub_8_U70 ( .A1(b[13]), .A2(sub_8_n213), .ZN(sub_8_n52) );
  NAND2_X1 sub_8_U69 ( .A1(b[5]), .A2(sub_8_n276), .ZN(sub_8_n119) );
  NAND2_X1 sub_8_U68 ( .A1(b[5]), .A2(sub_8_n276), .ZN(sub_8_n51) );
  NAND2_X1 sub_8_U67 ( .A1(b[5]), .A2(sub_8_n276), .ZN(sub_8_n50) );
  NAND2_X1 sub_8_U66 ( .A1(sub_8_n273), .A2(b[7]), .ZN(sub_8_n106) );
  NAND2_X1 sub_8_U65 ( .A1(sub_8_n273), .A2(b[7]), .ZN(sub_8_n49) );
  NAND2_X1 sub_8_U64 ( .A1(sub_8_n273), .A2(b[7]), .ZN(sub_8_n48) );
  AND2_X1 sub_8_U63 ( .A1(sub_8_n103), .A2(sub_8_n97), .ZN(sub_8_n229) );
  AND2_X2 sub_8_U62 ( .A1(sub_8_n267), .A2(a[2]), .ZN(sub_8_n47) );
  AND2_X1 sub_8_U61 ( .A1(a[9]), .A2(sub_8_n282), .ZN(sub_8_n46) );
  INV_X1 sub_8_U60 ( .A(b[0]), .ZN(sub_8_n45) );
  NAND2_X1 sub_8_U59 ( .A1(sub_8_n257), .A2(sub_8_n258), .ZN(sub_8_n44) );
  NAND2_X1 sub_8_U58 ( .A1(sub_8_n265), .A2(b[2]), .ZN(sub_8_n131) );
  NAND2_X1 sub_8_U57 ( .A1(sub_8_n265), .A2(b[2]), .ZN(sub_8_n43) );
  INV_X1 sub_8_U56 ( .A(sub_8_n66), .ZN(sub_8_n170) );
  NAND2_X1 sub_8_U55 ( .A1(a[8]), .A2(sub_8_n271), .ZN(sub_8_n42) );
  AND2_X1 sub_8_U54 ( .A1(sub_8_n167), .A2(sub_8_n93), .ZN(sub_8_n41) );
  CLKBUF_X1 sub_8_U53 ( .A(sub_8_n71), .Z(sub_8_n40) );
  NAND2_X1 sub_8_U52 ( .A1(sub_8_n69), .A2(sub_8_n71), .ZN(sub_8_n39) );
  CLKBUF_X1 sub_8_U51 ( .A(sub_8_n167), .Z(sub_8_n38) );
  CLKBUF_X1 sub_8_U50 ( .A(sub_8_n98), .Z(sub_8_n37) );
  AND2_X1 sub_8_U49 ( .A1(a[6]), .A2(sub_8_n278), .ZN(sub_8_n36) );
  AND2_X2 sub_8_U48 ( .A1(a[7]), .A2(sub_8_n277), .ZN(sub_8_n35) );
  CLKBUF_X1 sub_8_U47 ( .A(sub_8_n24), .Z(sub_8_n34) );
  CLKBUF_X1 sub_8_U46 ( .A(sub_8_n172), .Z(sub_8_n33) );
  AND2_X1 sub_8_U45 ( .A1(sub_8_n241), .A2(sub_8_n240), .ZN(sub_8_n32) );
  BUF_X2 sub_8_U44 ( .A(b[1]), .Z(sub_8_n31) );
  NAND2_X1 sub_8_U43 ( .A1(sub_8_n47), .A2(sub_8_n63), .ZN(sub_8_n30) );
  AND2_X1 sub_8_U42 ( .A1(sub_8_n30), .A2(sub_8_n127), .ZN(sub_8_n161) );
  CLKBUF_X1 sub_8_U41 ( .A(sub_8_n65), .Z(sub_8_n29) );
  AND3_X1 sub_8_U40 ( .A1(sub_8_n231), .A2(sub_8_n69), .A3(sub_8_n229), .ZN(
        sub_8_n73) );
  AND3_X1 sub_8_U39 ( .A1(sub_8_n18), .A2(sub_8_n229), .A3(sub_8_n69), .ZN(
        sub_8_n28) );
  BUF_X1 sub_8_U38 ( .A(sub_8_n55), .Z(sub_8_n27) );
  AND2_X1 sub_8_U37 ( .A1(sub_8_n2), .A2(sub_8_n111), .ZN(sub_8_n26) );
  INV_X1 sub_8_U36 ( .A(b[8]), .ZN(sub_8_n25) );
  NAND4_X1 sub_8_U35 ( .A1(sub_8_n268), .A2(sub_8_n269), .A3(sub_8_n119), .A4(
        sub_8_n106), .ZN(sub_8_n24) );
  CLKBUF_X1 sub_8_U34 ( .A(sub_8_n240), .Z(sub_8_n23) );
  CLKBUF_X1 sub_8_U33 ( .A(sub_8_n69), .Z(sub_8_n22) );
  CLKBUF_X1 sub_8_U32 ( .A(sub_8_n241), .Z(sub_8_n20) );
  NAND2_X1 sub_8_U31 ( .A1(sub_8_n22), .A2(sub_8_n20), .ZN(sub_8_n19) );
  XNOR2_X1 sub_8_U30 ( .A(sub_8_n79), .B(sub_8_n19), .ZN(diff[10]) );
  NOR2_X1 sub_8_U29 ( .A1(sub_8_n90), .A2(sub_8_n91), .ZN(sub_8_n18) );
  INV_X1 sub_8_U28 ( .A(a[10]), .ZN(sub_8_n17) );
  INV_X1 sub_8_U27 ( .A(a[12]), .ZN(sub_8_n16) );
  INV_X1 sub_8_U26 ( .A(a[11]), .ZN(sub_8_n15) );
  INV_X1 sub_8_U25 ( .A(a[11]), .ZN(sub_8_n14) );
  AND2_X1 sub_8_U24 ( .A1(sub_8_n256), .A2(sub_8_n255), .ZN(sub_8_n13) );
  CLKBUF_X1 sub_8_U23 ( .A(sub_8_n89), .Z(sub_8_n12) );
  INV_X1 sub_8_U22 ( .A(a[8]), .ZN(sub_8_n11) );
  AND2_X1 sub_8_U21 ( .A1(sub_8_n154), .A2(sub_8_n110), .ZN(sub_8_n10) );
  XNOR2_X1 sub_8_U20 ( .A(sub_8_n108), .B(sub_8_n10), .ZN(diff[6]) );
  INV_X1 sub_8_U19 ( .A(sub_8_n35), .ZN(sub_8_n107) );
  NAND2_X1 sub_8_U18 ( .A1(a[12]), .A2(sub_8_n237), .ZN(sub_8_n177) );
  INV_X1 sub_8_U17 ( .A(sub_8_n47), .ZN(sub_8_n130) );
  AND2_X1 sub_8_U16 ( .A1(sub_8_n28), .A2(sub_8_n204), .ZN(sub_8_n9) );
  NAND3_X1 sub_8_U15 ( .A1(sub_8_n86), .A2(sub_8_n127), .A3(sub_8_n172), .ZN(
        sub_8_n8) );
  AND2_X1 sub_8_U14 ( .A1(sub_8_n8), .A2(sub_8_n9), .ZN(sub_8_n192) );
  INV_X1 sub_8_U13 ( .A(a[14]), .ZN(sub_8_n7) );
  INV_X1 sub_8_U12 ( .A(a[14]), .ZN(sub_8_n6) );
  NAND2_X1 sub_8_U11 ( .A1(b[12]), .A2(sub_8_n236), .ZN(sub_8_n5) );
  AND2_X2 sub_8_U10 ( .A1(sub_8_n284), .A2(b[0]), .ZN(sub_8_n89) );
  NAND2_X1 sub_8_U9 ( .A1(sub_8_n64), .A2(b[3]), .ZN(sub_8_n4) );
  NAND2_X1 sub_8_U8 ( .A1(sub_8_n215), .A2(sub_8_n214), .ZN(sub_8_n3) );
  AND2_X1 sub_8_U7 ( .A1(a[5]), .A2(sub_8_n279), .ZN(sub_8_n2) );
  AND2_X2 sub_8_U6 ( .A1(sub_8_n16), .A2(b[12]), .ZN(sub_8_n91) );
  BUF_X1 sub_8_U5 ( .A(sub_8_n91), .Z(sub_8_n21) );
  AND2_X1 sub_8_U4 ( .A1(sub_8_n114), .A2(sub_8_n120), .ZN(sub_8_n1) );
  XNOR2_X1 sub_8_U3 ( .A(sub_8_n1), .B(sub_8_n75), .ZN(diff[5]) );
endmodule

