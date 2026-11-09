/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:05:10 2025
/////////////////////////////////////////////////////////////


module comparator_16bit_ds ( A, B, gt, eq, lt );
  input [15:0] A;
  input [15:0] B;
  output gt, eq, lt;
  wire   n15, diff_9_, diff_8_, diff_7_, diff_6_, diff_5_, diff_4_, diff_3_,
         diff_2_, diff_1_, diff_14_, diff_13_, diff_12_, diff_11_, diff_10_,
         diff_0_, n7, n9, n10, n11, n12, n13, n14, sub_9_n254, sub_9_n253,
         sub_9_n252, sub_9_n251, sub_9_n250, sub_9_n249, sub_9_n248,
         sub_9_n247, sub_9_n246, sub_9_n245, sub_9_n244, sub_9_n243,
         sub_9_n242, sub_9_n241, sub_9_n240, sub_9_n239, sub_9_n238,
         sub_9_n237, sub_9_n236, sub_9_n235, sub_9_n234, sub_9_n233,
         sub_9_n232, sub_9_n231, sub_9_n230, sub_9_n229, sub_9_n228,
         sub_9_n227, sub_9_n226, sub_9_n225, sub_9_n224, sub_9_n223,
         sub_9_n222, sub_9_n221, sub_9_n220, sub_9_n219, sub_9_n218,
         sub_9_n217, sub_9_n216, sub_9_n215, sub_9_n214, sub_9_n213,
         sub_9_n212, sub_9_n211, sub_9_n210, sub_9_n209, sub_9_n208,
         sub_9_n207, sub_9_n206, sub_9_n205, sub_9_n204, sub_9_n203,
         sub_9_n202, sub_9_n201, sub_9_n200, sub_9_n199, sub_9_n198,
         sub_9_n197, sub_9_n196, sub_9_n195, sub_9_n194, sub_9_n193,
         sub_9_n192, sub_9_n191, sub_9_n190, sub_9_n189, sub_9_n188,
         sub_9_n187, sub_9_n186, sub_9_n185, sub_9_n184, sub_9_n183,
         sub_9_n182, sub_9_n181, sub_9_n180, sub_9_n179, sub_9_n178,
         sub_9_n177, sub_9_n176, sub_9_n175, sub_9_n174, sub_9_n173,
         sub_9_n172, sub_9_n171, sub_9_n170, sub_9_n169, sub_9_n168,
         sub_9_n167, sub_9_n166, sub_9_n165, sub_9_n164, sub_9_n163,
         sub_9_n162, sub_9_n161, sub_9_n160, sub_9_n159, sub_9_n158,
         sub_9_n157, sub_9_n156, sub_9_n155, sub_9_n154, sub_9_n153,
         sub_9_n152, sub_9_n151, sub_9_n150, sub_9_n149, sub_9_n148,
         sub_9_n147, sub_9_n146, sub_9_n145, sub_9_n144, sub_9_n143,
         sub_9_n142, sub_9_n141, sub_9_n140, sub_9_n139, sub_9_n138,
         sub_9_n137, sub_9_n136, sub_9_n135, sub_9_n134, sub_9_n133,
         sub_9_n132, sub_9_n131, sub_9_n130, sub_9_n129, sub_9_n128,
         sub_9_n127, sub_9_n126, sub_9_n125, sub_9_n124, sub_9_n123,
         sub_9_n122, sub_9_n121, sub_9_n120, sub_9_n119, sub_9_n118,
         sub_9_n117, sub_9_n116, sub_9_n115, sub_9_n114, sub_9_n113,
         sub_9_n112, sub_9_n111, sub_9_n110, sub_9_n109, sub_9_n108,
         sub_9_n107, sub_9_n106, sub_9_n105, sub_9_n104, sub_9_n103,
         sub_9_n102, sub_9_n101, sub_9_n100, sub_9_n99, sub_9_n98, sub_9_n97,
         sub_9_n96, sub_9_n95, sub_9_n94, sub_9_n93, sub_9_n92, sub_9_n91,
         sub_9_n90, sub_9_n89, sub_9_n88, sub_9_n87, sub_9_n86, sub_9_n85,
         sub_9_n84, sub_9_n83, sub_9_n82, sub_9_n81, sub_9_n80, sub_9_n79,
         sub_9_n78, sub_9_n77, sub_9_n76, sub_9_n75, sub_9_n74, sub_9_n73,
         sub_9_n72, sub_9_n71, sub_9_n70, sub_9_n69, sub_9_n68, sub_9_n67,
         sub_9_n66, sub_9_n65, sub_9_n64, sub_9_n63, sub_9_n62, sub_9_n61,
         sub_9_n60, sub_9_n59, sub_9_n58, sub_9_n57, sub_9_n56, sub_9_n55,
         sub_9_n54, sub_9_n53, sub_9_n52, sub_9_n51, sub_9_n50, sub_9_n49,
         sub_9_n48, sub_9_n47, sub_9_n46, sub_9_n45, sub_9_n44, sub_9_n43,
         sub_9_n42, sub_9_n41, sub_9_n39, sub_9_n38, sub_9_n37, sub_9_n36,
         sub_9_n35, sub_9_n34, sub_9_n33, sub_9_n32, sub_9_n31, sub_9_n30,
         sub_9_n29, sub_9_n28, sub_9_n27, sub_9_n25, sub_9_n24, sub_9_n23,
         sub_9_n22, sub_9_n21, sub_9_n20, sub_9_n19, sub_9_n18, sub_9_n17,
         sub_9_n16, sub_9_n15, sub_9_n14, sub_9_n13, sub_9_n12, sub_9_n11,
         sub_9_n10, sub_9_n9, sub_9_n8, sub_9_n7, sub_9_n6, sub_9_n5, sub_9_n4,
         sub_9_n3, sub_9_n2, sub_9_n1;

  CLKBUF_X1 U8 ( .A(n15), .Z(lt) );
  AND2_X1 U9 ( .A1(n13), .A2(n12), .ZN(n7) );
  AND3_X1 U10 ( .A1(n7), .A2(n14), .A3(n11), .ZN(eq) );
  OR4_X2 U11 ( .A1(diff_3_), .A2(diff_2_), .A3(diff_1_), .A4(diff_0_), .ZN(n9)
         );
  OR3_X2 U12 ( .A1(diff_13_), .A2(diff_10_), .A3(diff_8_), .ZN(n10) );
  NOR3_X1 U13 ( .A1(diff_5_), .A2(diff_4_), .A3(n9), .ZN(n14) );
  NOR2_X1 U14 ( .A1(diff_14_), .A2(diff_9_), .ZN(n13) );
  NOR2_X1 U15 ( .A1(diff_7_), .A2(diff_11_), .ZN(n12) );
  NOR4_X1 U16 ( .A1(n10), .A2(diff_6_), .A3(diff_12_), .A4(n15), .ZN(n11) );
  NOR2_X1 U17 ( .A1(eq), .A2(lt), .ZN(gt) );
  INV_X1 sub_9_U271 ( .A(sub_9_n128), .ZN(sub_9_n253) );
  NAND2_X2 sub_9_U270 ( .A1(A[3]), .A2(sub_9_n244), .ZN(sub_9_n80) );
  INV_X1 sub_9_U269 ( .A(sub_9_n22), .ZN(sub_9_n96) );
  INV_X1 sub_9_U268 ( .A(sub_9_n213), .ZN(sub_9_n231) );
  NAND2_X1 sub_9_U267 ( .A1(sub_9_n53), .A2(sub_9_n231), .ZN(sub_9_n217) );
  INV_X1 sub_9_U266 ( .A(sub_9_n52), .ZN(sub_9_n229) );
  INV_X1 sub_9_U265 ( .A(sub_9_n84), .ZN(sub_9_n225) );
  XNOR2_X1 sub_9_U264 ( .A(sub_9_n215), .B(sub_9_n214), .ZN(diff_10_) );
  INV_X1 sub_9_U263 ( .A(sub_9_n16), .ZN(sub_9_n208) );
  NAND3_X1 sub_9_U262 ( .A1(sub_9_n66), .A2(sub_9_n196), .A3(sub_9_n194), .ZN(
        sub_9_n195) );
  INV_X1 sub_9_U261 ( .A(sub_9_n41), .ZN(sub_9_n188) );
  XNOR2_X1 sub_9_U260 ( .A(sub_9_n183), .B(sub_9_n184), .ZN(diff_12_) );
  NAND3_X1 sub_9_U259 ( .A1(sub_9_n172), .A2(sub_9_n173), .A3(sub_9_n174), 
        .ZN(sub_9_n168) );
  NAND3_X1 sub_9_U258 ( .A1(sub_9_n169), .A2(sub_9_n168), .A3(sub_9_n81), .ZN(
        sub_9_n158) );
  NAND2_X1 sub_9_U257 ( .A1(sub_9_n158), .A2(sub_9_n37), .ZN(sub_9_n162) );
  AOI21_X1 sub_9_U256 ( .B1(sub_9_n48), .B2(sub_9_n35), .A(sub_9_n159), .ZN(
        sub_9_n163) );
  NAND3_X1 sub_9_U255 ( .A1(sub_9_n162), .A2(sub_9_n157), .A3(sub_9_n163), 
        .ZN(sub_9_n161) );
  XNOR2_X1 sub_9_U254 ( .A(sub_9_n161), .B(sub_9_n160), .ZN(diff_13_) );
  INV_X1 sub_9_U253 ( .A(sub_9_n159), .ZN(sub_9_n154) );
  NOR2_X1 sub_9_U252 ( .A1(sub_9_n20), .A2(sub_9_n38), .ZN(sub_9_n155) );
  NAND3_X1 sub_9_U251 ( .A1(sub_9_n154), .A2(sub_9_n31), .A3(sub_9_n155), .ZN(
        sub_9_n152) );
  INV_X1 sub_9_U250 ( .A(sub_9_n145), .ZN(sub_9_n153) );
  INV_X1 sub_9_U249 ( .A(sub_9_n136), .ZN(sub_9_n133) );
  INV_X1 sub_9_U248 ( .A(sub_9_n147), .ZN(sub_9_n144) );
  AOI21_X1 sub_9_U247 ( .B1(sub_9_n20), .B2(sub_9_n133), .A(sub_9_n143), .ZN(
        sub_9_n130) );
  INV_X1 sub_9_U246 ( .A(sub_9_n142), .ZN(sub_9_n137) );
  INV_X1 sub_9_U245 ( .A(sub_9_n141), .ZN(sub_9_n138) );
  INV_X1 sub_9_U244 ( .A(sub_9_n140), .ZN(sub_9_n139) );
  AOI21_X1 sub_9_U243 ( .B1(sub_9_n137), .B2(sub_9_n138), .A(sub_9_n139), .ZN(
        sub_9_n135) );
  AOI21_X1 sub_9_U242 ( .B1(sub_9_n38), .B2(sub_9_n133), .A(sub_9_n134), .ZN(
        sub_9_n132) );
  NAND3_X1 sub_9_U241 ( .A1(sub_9_n132), .A2(sub_9_n131), .A3(sub_9_n130), 
        .ZN(sub_9_n129) );
  XNOR2_X1 sub_9_U240 ( .A(sub_9_n129), .B(sub_9_n39), .ZN(n15) );
  INV_X1 sub_9_U239 ( .A(sub_9_n125), .ZN(sub_9_n121) );
  INV_X1 sub_9_U238 ( .A(sub_9_n174), .ZN(sub_9_n122) );
  XNOR2_X1 sub_9_U237 ( .A(sub_9_n119), .B(sub_9_n120), .ZN(diff_2_) );
  INV_X1 sub_9_U236 ( .A(sub_9_n119), .ZN(sub_9_n115) );
  INV_X1 sub_9_U235 ( .A(sub_9_n61), .ZN(sub_9_n116) );
  OAI21_X1 sub_9_U234 ( .B1(sub_9_n115), .B2(sub_9_n116), .A(sub_9_n117), .ZN(
        sub_9_n112) );
  XNOR2_X1 sub_9_U233 ( .A(sub_9_n112), .B(sub_9_n113), .ZN(diff_3_) );
  XNOR2_X1 sub_9_U232 ( .A(sub_9_n3), .B(sub_9_n109), .ZN(diff_4_) );
  INV_X1 sub_9_U231 ( .A(sub_9_n97), .ZN(sub_9_n87) );
  NOR2_X1 sub_9_U230 ( .A1(sub_9_n96), .A2(sub_9_n47), .ZN(sub_9_n90) );
  INV_X1 sub_9_U229 ( .A(sub_9_n1), .ZN(sub_9_n93) );
  NOR2_X1 sub_9_U228 ( .A1(sub_9_n93), .A2(sub_9_n94), .ZN(sub_9_n91) );
  INV_X1 sub_9_U227 ( .A(sub_9_n75), .ZN(sub_9_n73) );
  NOR2_X1 sub_9_U226 ( .A1(sub_9_n171), .A2(sub_9_n170), .ZN(sub_9_n169) );
  NOR2_X1 sub_9_U225 ( .A1(sub_9_n240), .A2(sub_9_n241), .ZN(sub_9_n171) );
  NAND2_X1 sub_9_U224 ( .A1(sub_9_n124), .A2(sub_9_n242), .ZN(sub_9_n241) );
  NAND2_X1 sub_9_U223 ( .A1(sub_9_n45), .A2(B[1]), .ZN(sub_9_n124) );
  NOR2_X1 sub_9_U222 ( .A1(sub_9_n235), .A2(sub_9_n236), .ZN(sub_9_n234) );
  NOR2_X1 sub_9_U221 ( .A1(sub_9_n201), .A2(sub_9_n74), .ZN(sub_9_n199) );
  NOR2_X1 sub_9_U220 ( .A1(sub_9_n213), .A2(sub_9_n74), .ZN(sub_9_n209) );
  NOR2_X1 sub_9_U219 ( .A1(sub_9_n73), .A2(sub_9_n74), .ZN(sub_9_n68) );
  XNOR2_X1 sub_9_U218 ( .A(sub_9_n77), .B(sub_9_n76), .ZN(diff_8_) );
  AND2_X1 sub_9_U217 ( .A1(sub_9_n59), .A2(sub_9_n61), .ZN(sub_9_n172) );
  NAND2_X1 sub_9_U216 ( .A1(sub_9_n60), .A2(sub_9_n117), .ZN(sub_9_n120) );
  OAI211_X1 sub_9_U215 ( .C1(sub_9_n216), .C2(sub_9_n217), .A(sub_9_n211), .B(
        sub_9_n212), .ZN(sub_9_n215) );
  NOR2_X1 sub_9_U214 ( .A1(sub_9_n238), .A2(sub_9_n237), .ZN(sub_9_n233) );
  OAI211_X1 sub_9_U213 ( .C1(A[9]), .C2(sub_9_n178), .A(sub_9_n70), .B(
        sub_9_n165), .ZN(sub_9_n177) );
  NAND4_X1 sub_9_U212 ( .A1(sub_9_n70), .A2(sub_9_n180), .A3(sub_9_n179), .A4(
        sub_9_n197), .ZN(sub_9_n142) );
  NAND2_X1 sub_9_U211 ( .A1(sub_9_n65), .A2(sub_9_n52), .ZN(sub_9_n213) );
  NAND2_X1 sub_9_U210 ( .A1(sub_9_n52), .A2(sub_9_n66), .ZN(sub_9_n76) );
  OAI21_X1 sub_9_U209 ( .B1(sub_9_n68), .B2(sub_9_n69), .A(sub_9_n52), .ZN(
        sub_9_n67) );
  NOR3_X1 sub_9_U208 ( .A1(sub_9_n96), .A2(sub_9_n202), .A3(sub_9_n47), .ZN(
        sub_9_n216) );
  NOR3_X1 sub_9_U207 ( .A1(sub_9_n96), .A2(sub_9_n202), .A3(sub_9_n47), .ZN(
        sub_9_n201) );
  NOR2_X1 sub_9_U206 ( .A1(sub_9_n199), .A2(sub_9_n200), .ZN(sub_9_n187) );
  OAI211_X1 sub_9_U205 ( .C1(sub_9_n221), .C2(sub_9_n222), .A(sub_9_n223), .B(
        sub_9_n89), .ZN(sub_9_n219) );
  NAND2_X1 sub_9_U204 ( .A1(sub_9_n36), .A2(sub_9_n86), .ZN(sub_9_n156) );
  NAND2_X1 sub_9_U203 ( .A1(sub_9_n156), .A2(sub_9_n84), .ZN(sub_9_n71) );
  NAND2_X1 sub_9_U202 ( .A1(sub_9_n218), .A2(sub_9_n35), .ZN(sub_9_n212) );
  OAI21_X1 sub_9_U201 ( .B1(sub_9_n187), .B2(sub_9_n5), .A(sub_9_n188), .ZN(
        sub_9_n183) );
  NAND2_X1 sub_9_U200 ( .A1(sub_9_n15), .A2(sub_9_n7), .ZN(sub_9_n81) );
  NAND2_X1 sub_9_U199 ( .A1(sub_9_n7), .A2(sub_9_n80), .ZN(sub_9_n113) );
  NOR2_X1 sub_9_U198 ( .A1(A[7]), .A2(sub_9_n58), .ZN(sub_9_n236) );
  NOR2_X1 sub_9_U197 ( .A1(A[4]), .A2(sub_9_n57), .ZN(sub_9_n235) );
  INV_X1 sub_9_U196 ( .A(A[2]), .ZN(sub_9_n247) );
  NAND2_X1 sub_9_U195 ( .A1(sub_9_n54), .A2(B[2]), .ZN(sub_9_n118) );
  NAND2_X1 sub_9_U194 ( .A1(B[2]), .A2(sub_9_n247), .ZN(sub_9_n61) );
  NAND2_X1 sub_9_U193 ( .A1(B[2]), .A2(sub_9_n247), .ZN(sub_9_n60) );
  NOR2_X1 sub_9_U192 ( .A1(A[5]), .A2(sub_9_n56), .ZN(sub_9_n237) );
  NOR2_X1 sub_9_U191 ( .A1(A[6]), .A2(sub_9_n55), .ZN(sub_9_n238) );
  NAND2_X1 sub_9_U190 ( .A1(B[1]), .A2(sub_9_n243), .ZN(sub_9_n174) );
  INV_X1 sub_9_U189 ( .A(A[3]), .ZN(sub_9_n246) );
  NAND2_X1 sub_9_U188 ( .A1(B[3]), .A2(sub_9_n44), .ZN(sub_9_n114) );
  INV_X1 sub_9_U187 ( .A(B[7]), .ZN(sub_9_n230) );
  INV_X1 sub_9_U186 ( .A(B[5]), .ZN(sub_9_n106) );
  NAND2_X1 sub_9_U185 ( .A1(sub_9_n71), .A2(sub_9_n72), .ZN(sub_9_n200) );
  NAND2_X1 sub_9_U184 ( .A1(sub_9_n71), .A2(sub_9_n72), .ZN(sub_9_n69) );
  INV_X1 sub_9_U183 ( .A(B[4]), .ZN(sub_9_n110) );
  NAND2_X1 sub_9_U182 ( .A1(sub_9_n17), .A2(sub_9_n194), .ZN(sub_9_n214) );
  NAND2_X1 sub_9_U181 ( .A1(sub_9_n192), .A2(sub_9_n17), .ZN(sub_9_n190) );
  NAND2_X1 sub_9_U180 ( .A1(sub_9_n9), .A2(sub_9_n16), .ZN(sub_9_n176) );
  NOR2_X1 sub_9_U179 ( .A1(sub_9_n177), .A2(sub_9_n176), .ZN(sub_9_n167) );
  INV_X1 sub_9_U178 ( .A(B[6]), .ZN(sub_9_n220) );
  NAND2_X1 sub_9_U177 ( .A1(sub_9_n34), .A2(sub_9_n80), .ZN(sub_9_n202) );
  INV_X1 sub_9_U176 ( .A(B[7]), .ZN(sub_9_n58) );
  INV_X1 sub_9_U175 ( .A(B[4]), .ZN(sub_9_n57) );
  XNOR2_X1 sub_9_U174 ( .A(sub_9_n104), .B(sub_9_n105), .ZN(diff_5_) );
  NAND2_X1 sub_9_U173 ( .A1(sub_9_n43), .A2(B[0]), .ZN(sub_9_n242) );
  INV_X1 sub_9_U172 ( .A(A[0]), .ZN(sub_9_n254) );
  INV_X1 sub_9_U171 ( .A(B[5]), .ZN(sub_9_n56) );
  INV_X1 sub_9_U170 ( .A(A[1]), .ZN(sub_9_n243) );
  INV_X1 sub_9_U169 ( .A(B[6]), .ZN(sub_9_n55) );
  NAND2_X1 sub_9_U168 ( .A1(B[6]), .A2(sub_9_n224), .ZN(sub_9_n89) );
  NOR2_X1 sub_9_U167 ( .A1(B[5]), .A2(sub_9_n107), .ZN(sub_9_n221) );
  OAI21_X1 sub_9_U166 ( .B1(sub_9_n141), .B2(sub_9_n142), .A(sub_9_n140), .ZN(
        sub_9_n159) );
  INV_X1 sub_9_U165 ( .A(A[2]), .ZN(sub_9_n54) );
  NAND2_X1 sub_9_U164 ( .A1(sub_9_n127), .A2(A[1]), .ZN(sub_9_n248) );
  NAND2_X1 sub_9_U163 ( .A1(A[1]), .A2(sub_9_n32), .ZN(sub_9_n175) );
  NAND2_X1 sub_9_U162 ( .A1(A[1]), .A2(sub_9_n33), .ZN(sub_9_n123) );
  NOR2_X1 sub_9_U161 ( .A1(sub_9_n42), .A2(sub_9_n103), .ZN(sub_9_n100) );
  AOI21_X1 sub_9_U160 ( .B1(sub_9_n209), .B2(sub_9_n29), .A(sub_9_n210), .ZN(
        sub_9_n207) );
  NAND2_X1 sub_9_U159 ( .A1(sub_9_n101), .A2(sub_9_n3), .ZN(sub_9_n108) );
  NAND2_X1 sub_9_U158 ( .A1(sub_9_n23), .A2(sub_9_n67), .ZN(sub_9_n62) );
  INV_X1 sub_9_U157 ( .A(A[8]), .ZN(sub_9_n232) );
  NAND2_X1 sub_9_U156 ( .A1(B[8]), .A2(sub_9_n2), .ZN(sub_9_n70) );
  NAND2_X1 sub_9_U155 ( .A1(sub_9_n185), .A2(B[12]), .ZN(sub_9_n165) );
  NAND2_X1 sub_9_U154 ( .A1(sub_9_n140), .A2(sub_9_n4), .ZN(sub_9_n184) );
  NAND2_X1 sub_9_U153 ( .A1(sub_9_n30), .A2(sub_9_n4), .ZN(sub_9_n157) );
  NAND2_X1 sub_9_U152 ( .A1(sub_9_n164), .A2(sub_9_n28), .ZN(sub_9_n141) );
  NAND2_X1 sub_9_U151 ( .A1(B[8]), .A2(sub_9_n232), .ZN(sub_9_n52) );
  INV_X1 sub_9_U150 ( .A(sub_9_n80), .ZN(sub_9_n170) );
  NAND2_X1 sub_9_U149 ( .A1(sub_9_n95), .A2(sub_9_n80), .ZN(sub_9_n94) );
  INV_X1 sub_9_U148 ( .A(A[5]), .ZN(sub_9_n107) );
  INV_X1 sub_9_U147 ( .A(A[5]), .ZN(sub_9_n51) );
  INV_X1 sub_9_U146 ( .A(A[5]), .ZN(sub_9_n50) );
  INV_X1 sub_9_U145 ( .A(A[6]), .ZN(sub_9_n224) );
  NAND2_X1 sub_9_U144 ( .A1(B[6]), .A2(sub_9_n224), .ZN(sub_9_n49) );
  NAND2_X1 sub_9_U143 ( .A1(sub_9_n9), .A2(sub_9_n195), .ZN(sub_9_n189) );
  INV_X1 sub_9_U142 ( .A(A[12]), .ZN(sub_9_n185) );
  AND2_X1 sub_9_U141 ( .A1(sub_9_n167), .A2(sub_9_n84), .ZN(sub_9_n48) );
  AND2_X1 sub_9_U140 ( .A1(sub_9_n15), .A2(sub_9_n7), .ZN(sub_9_n47) );
  INV_X1 sub_9_U139 ( .A(A[4]), .ZN(sub_9_n111) );
  AND2_X1 sub_9_U138 ( .A1(sub_9_n57), .A2(A[4]), .ZN(sub_9_n222) );
  AND2_X1 sub_9_U137 ( .A1(B[0]), .A2(sub_9_n254), .ZN(sub_9_n46) );
  INV_X1 sub_9_U136 ( .A(A[1]), .ZN(sub_9_n45) );
  INV_X1 sub_9_U135 ( .A(A[3]), .ZN(sub_9_n44) );
  INV_X1 sub_9_U134 ( .A(A[0]), .ZN(sub_9_n43) );
  NOR2_X1 sub_9_U133 ( .A1(sub_9_n135), .A2(sub_9_n136), .ZN(sub_9_n134) );
  NAND4_X1 sub_9_U132 ( .A1(sub_9_n79), .A2(sub_9_n14), .A3(sub_9_n81), .A4(
        sub_9_n80), .ZN(sub_9_n75) );
  BUF_X1 sub_9_U131 ( .A(sub_9_n75), .Z(sub_9_n42) );
  INV_X1 sub_9_U130 ( .A(B[0]), .ZN(sub_9_n250) );
  CLKBUF_X1 sub_9_U129 ( .A(sub_9_n30), .Z(sub_9_n41) );
  INV_X1 sub_9_U128 ( .A(B[8]), .ZN(sub_9_n228) );
  NAND2_X1 sub_9_U127 ( .A1(A[8]), .A2(sub_9_n228), .ZN(sub_9_n66) );
  INV_X1 sub_9_U126 ( .A(B[3]), .ZN(sub_9_n244) );
  NAND2_X1 sub_9_U125 ( .A1(sub_9_n18), .A2(A[0]), .ZN(sub_9_n249) );
  NAND2_X1 sub_9_U124 ( .A1(A[0]), .A2(sub_9_n250), .ZN(sub_9_n128) );
  NAND2_X1 sub_9_U123 ( .A1(sub_9_n175), .A2(sub_9_n128), .ZN(sub_9_n173) );
  NAND2_X1 sub_9_U122 ( .A1(sub_9_n251), .A2(A[10]), .ZN(sub_9_n194) );
  OAI21_X1 sub_9_U121 ( .B1(sub_9_n207), .B2(sub_9_n208), .A(sub_9_n19), .ZN(
        sub_9_n203) );
  INV_X1 sub_9_U120 ( .A(B[9]), .ZN(sub_9_n178) );
  NAND2_X1 sub_9_U119 ( .A1(A[9]), .A2(sub_9_n178), .ZN(sub_9_n64) );
  NAND2_X1 sub_9_U118 ( .A1(A[9]), .A2(sub_9_n178), .ZN(sub_9_n196) );
  NAND2_X1 sub_9_U116 ( .A1(A[5]), .A2(sub_9_n106), .ZN(sub_9_n97) );
  NAND2_X1 sub_9_U115 ( .A1(B[5]), .A2(sub_9_n51), .ZN(sub_9_n102) );
  NAND2_X1 sub_9_U114 ( .A1(B[4]), .A2(sub_9_n111), .ZN(sub_9_n101) );
  INV_X1 sub_9_U113 ( .A(B[14]), .ZN(sub_9_n150) );
  NAND2_X1 sub_9_U112 ( .A1(A[14]), .A2(sub_9_n150), .ZN(sub_9_n146) );
  INV_X1 sub_9_U111 ( .A(B[13]), .ZN(sub_9_n182) );
  NAND2_X1 sub_9_U110 ( .A1(A[13]), .A2(sub_9_n182), .ZN(sub_9_n145) );
  NAND2_X1 sub_9_U109 ( .A1(A[4]), .A2(sub_9_n110), .ZN(sub_9_n95) );
  INV_X1 sub_9_U108 ( .A(A[14]), .ZN(sub_9_n151) );
  NAND2_X1 sub_9_U107 ( .A1(B[14]), .A2(sub_9_n151), .ZN(sub_9_n147) );
  INV_X1 sub_9_U106 ( .A(A[13]), .ZN(sub_9_n181) );
  NAND2_X1 sub_9_U105 ( .A1(B[13]), .A2(sub_9_n181), .ZN(sub_9_n148) );
  INV_X1 sub_9_U104 ( .A(B[11]), .ZN(sub_9_n206) );
  NAND2_X1 sub_9_U103 ( .A1(A[11]), .A2(sub_9_n206), .ZN(sub_9_n191) );
  NAND2_X1 sub_9_U102 ( .A1(A[7]), .A2(sub_9_n230), .ZN(sub_9_n72) );
  INV_X1 sub_9_U101 ( .A(B[12]), .ZN(sub_9_n186) );
  NAND2_X1 sub_9_U100 ( .A1(A[12]), .A2(sub_9_n186), .ZN(sub_9_n140) );
  NAND2_X1 sub_9_U99 ( .A1(B[7]), .A2(sub_9_n166), .ZN(sub_9_n84) );
  NAND2_X1 sub_9_U98 ( .A1(A[6]), .A2(sub_9_n220), .ZN(sub_9_n86) );
  INV_X1 sub_9_U97 ( .A(A[7]), .ZN(sub_9_n166) );
  NOR2_X1 sub_9_U96 ( .A1(B[7]), .A2(sub_9_n166), .ZN(sub_9_n164) );
  NAND2_X1 sub_9_U95 ( .A1(B[9]), .A2(sub_9_n198), .ZN(sub_9_n65) );
  INV_X1 sub_9_U94 ( .A(B[2]), .ZN(sub_9_n239) );
  NAND2_X1 sub_9_U93 ( .A1(B[5]), .A2(sub_9_n50), .ZN(sub_9_n223) );
  INV_X1 sub_9_U92 ( .A(A[9]), .ZN(sub_9_n198) );
  INV_X1 sub_9_U91 ( .A(B[1]), .ZN(sub_9_n127) );
  NAND2_X1 sub_9_U90 ( .A1(sub_9_n248), .A2(sub_9_n249), .ZN(sub_9_n245) );
  NAND4_X1 sub_9_U89 ( .A1(sub_9_n245), .A2(sub_9_n174), .A3(sub_9_n60), .A4(
        sub_9_n59), .ZN(sub_9_n79) );
  AND2_X1 sub_9_U88 ( .A1(sub_9_n233), .A2(sub_9_n234), .ZN(sub_9_n53) );
  INV_X1 sub_9_U87 ( .A(A[9]), .ZN(sub_9_n193) );
  INV_X1 sub_9_U86 ( .A(B[10]), .ZN(sub_9_n251) );
  INV_X1 sub_9_U85 ( .A(A[11]), .ZN(sub_9_n205) );
  NAND2_X1 sub_9_U84 ( .A1(B[11]), .A2(sub_9_n205), .ZN(sub_9_n179) );
  NAND2_X1 sub_9_U83 ( .A1(B[9]), .A2(sub_9_n198), .ZN(sub_9_n197) );
  INV_X1 sub_9_U82 ( .A(A[10]), .ZN(sub_9_n252) );
  XOR2_X1 sub_9_U81 ( .A(B[15]), .B(A[15]), .Z(sub_9_n39) );
  NAND2_X1 sub_9_U80 ( .A1(sub_9_n49), .A2(sub_9_n86), .ZN(sub_9_n99) );
  NAND2_X1 sub_9_U79 ( .A1(sub_9_n101), .A2(sub_9_n102), .ZN(sub_9_n92) );
  NAND2_X1 sub_9_U78 ( .A1(sub_9_n6), .A2(sub_9_n123), .ZN(sub_9_n126) );
  NAND2_X1 sub_9_U77 ( .A1(sub_9_n101), .A2(sub_9_n95), .ZN(sub_9_n109) );
  NAND2_X1 sub_9_U76 ( .A1(sub_9_n147), .A2(sub_9_n148), .ZN(sub_9_n136) );
  INV_X1 sub_9_U75 ( .A(sub_9_n53), .ZN(sub_9_n74) );
  NOR2_X1 sub_9_U74 ( .A1(sub_9_n229), .A2(sub_9_n72), .ZN(sub_9_n226) );
  NAND2_X1 sub_9_U73 ( .A1(sub_9_n64), .A2(sub_9_n23), .ZN(sub_9_n227) );
  OAI21_X1 sub_9_U72 ( .B1(sub_9_n226), .B2(sub_9_n227), .A(sub_9_n65), .ZN(
        sub_9_n211) );
  NAND2_X1 sub_9_U71 ( .A1(sub_9_n46), .A2(sub_9_n128), .ZN(sub_9_n125) );
  OAI21_X1 sub_9_U70 ( .B1(sub_9_n121), .B2(sub_9_n122), .A(sub_9_n123), .ZN(
        sub_9_n119) );
  NAND2_X1 sub_9_U69 ( .A1(sub_9_n191), .A2(sub_9_n8), .ZN(sub_9_n204) );
  XNOR2_X1 sub_9_U68 ( .A(sub_9_n203), .B(sub_9_n204), .ZN(diff_11_) );
  NOR2_X1 sub_9_U67 ( .A1(sub_9_n225), .A2(sub_9_n213), .ZN(sub_9_n218) );
  NAND2_X1 sub_9_U66 ( .A1(sub_9_n95), .A2(sub_9_n108), .ZN(sub_9_n104) );
  NAND2_X1 sub_9_U65 ( .A1(sub_9_n102), .A2(sub_9_n97), .ZN(sub_9_n105) );
  OAI21_X1 sub_9_U64 ( .B1(sub_9_n88), .B2(sub_9_n87), .A(sub_9_n49), .ZN(
        sub_9_n85) );
  NAND2_X1 sub_9_U63 ( .A1(sub_9_n85), .A2(sub_9_n86), .ZN(sub_9_n82) );
  NAND2_X1 sub_9_U62 ( .A1(sub_9_n84), .A2(sub_9_n72), .ZN(sub_9_n83) );
  XNOR2_X1 sub_9_U61 ( .A(sub_9_n82), .B(sub_9_n83), .ZN(diff_7_) );
  AOI21_X1 sub_9_U60 ( .B1(sub_9_n90), .B2(sub_9_n91), .A(sub_9_n92), .ZN(
        sub_9_n88) );
  NAND2_X1 sub_9_U59 ( .A1(sub_9_n64), .A2(sub_9_n65), .ZN(sub_9_n63) );
  XNOR2_X1 sub_9_U58 ( .A(sub_9_n62), .B(sub_9_n63), .ZN(diff_9_) );
  INV_X1 sub_9_U57 ( .A(sub_9_n95), .ZN(sub_9_n103) );
  OAI21_X1 sub_9_U56 ( .B1(sub_9_n100), .B2(sub_9_n92), .A(sub_9_n97), .ZN(
        sub_9_n98) );
  AOI21_X1 sub_9_U55 ( .B1(sub_9_n152), .B2(sub_9_n148), .A(sub_9_n153), .ZN(
        sub_9_n149) );
  XNOR2_X1 sub_9_U54 ( .A(sub_9_n149), .B(sub_9_n27), .ZN(diff_14_) );
  OAI21_X1 sub_9_U53 ( .B1(sub_9_n144), .B2(sub_9_n145), .A(sub_9_n146), .ZN(
        sub_9_n143) );
  NAND2_X1 sub_9_U52 ( .A1(sub_9_n145), .A2(sub_9_n148), .ZN(sub_9_n160) );
  AND2_X1 sub_9_U51 ( .A1(sub_9_n167), .A2(sub_9_n53), .ZN(sub_9_n37) );
  XNOR2_X1 sub_9_U50 ( .A(sub_9_n98), .B(sub_9_n99), .ZN(diff_6_) );
  XNOR2_X1 sub_9_U49 ( .A(sub_9_n125), .B(sub_9_n126), .ZN(diff_1_) );
  NAND2_X1 sub_9_U48 ( .A1(sub_9_n211), .A2(sub_9_n212), .ZN(sub_9_n210) );
  OR2_X1 sub_9_U47 ( .A1(sub_9_n162), .A2(sub_9_n136), .ZN(sub_9_n131) );
  OAI211_X1 sub_9_U46 ( .C1(sub_9_n221), .C2(sub_9_n222), .A(sub_9_n223), .B(
        sub_9_n89), .ZN(sub_9_n36) );
  NAND2_X1 sub_9_U45 ( .A1(sub_9_n219), .A2(sub_9_n86), .ZN(sub_9_n35) );
  NAND4_X1 sub_9_U44 ( .A1(sub_9_n245), .A2(sub_9_n174), .A3(sub_9_n60), .A4(
        sub_9_n59), .ZN(sub_9_n34) );
  INV_X1 sub_9_U43 ( .A(B[1]), .ZN(sub_9_n33) );
  INV_X1 sub_9_U42 ( .A(B[1]), .ZN(sub_9_n32) );
  CLKBUF_X1 sub_9_U41 ( .A(sub_9_n162), .Z(sub_9_n31) );
  OAI21_X1 sub_9_U40 ( .B1(sub_9_n189), .B2(sub_9_n190), .A(sub_9_n191), .ZN(
        sub_9_n30) );
  NAND2_X1 sub_9_U39 ( .A1(sub_9_n19), .A2(sub_9_n24), .ZN(sub_9_n192) );
  CLKBUF_X1 sub_9_U38 ( .A(sub_9_n75), .Z(sub_9_n29) );
  NAND2_X1 sub_9_U37 ( .A1(sub_9_n185), .A2(B[12]), .ZN(sub_9_n28) );
  AND2_X1 sub_9_U36 ( .A1(sub_9_n147), .A2(sub_9_n146), .ZN(sub_9_n27) );
  OR2_X1 sub_9_U35 ( .A1(sub_9_n46), .A2(sub_9_n253), .ZN(diff_0_) );
  AND4_X1 sub_9_U34 ( .A1(sub_9_n22), .A2(sub_9_n79), .A3(sub_9_n80), .A4(
        sub_9_n81), .ZN(sub_9_n25) );
  AND2_X1 sub_9_U33 ( .A1(sub_9_n193), .A2(B[9]), .ZN(sub_9_n24) );
  NAND2_X1 sub_9_U32 ( .A1(A[8]), .A2(sub_9_n228), .ZN(sub_9_n23) );
  NAND2_X1 sub_9_U31 ( .A1(sub_9_n21), .A2(sub_9_n78), .ZN(sub_9_n77) );
  OR2_X1 sub_9_U30 ( .A1(sub_9_n25), .A2(sub_9_n74), .ZN(sub_9_n21) );
  AND2_X1 sub_9_U29 ( .A1(sub_9_n30), .A2(sub_9_n4), .ZN(sub_9_n20) );
  NAND2_X1 sub_9_U28 ( .A1(sub_9_n251), .A2(A[10]), .ZN(sub_9_n19) );
  INV_X1 sub_9_U27 ( .A(B[0]), .ZN(sub_9_n18) );
  NAND2_X1 sub_9_U26 ( .A1(sub_9_n252), .A2(B[10]), .ZN(sub_9_n180) );
  NAND2_X1 sub_9_U25 ( .A1(sub_9_n252), .A2(B[10]), .ZN(sub_9_n17) );
  NAND2_X1 sub_9_U24 ( .A1(sub_9_n252), .A2(B[10]), .ZN(sub_9_n16) );
  INV_X4 sub_9_U23 ( .A(sub_9_n15), .ZN(sub_9_n117) );
  AND2_X2 sub_9_U22 ( .A1(A[2]), .A2(sub_9_n239), .ZN(sub_9_n15) );
  OR2_X1 sub_9_U21 ( .A1(sub_9_n240), .A2(sub_9_n241), .ZN(sub_9_n22) );
  INV_X1 sub_9_U20 ( .A(sub_9_n171), .ZN(sub_9_n14) );
  AND2_X1 sub_9_U19 ( .A1(sub_9_n86), .A2(sub_9_n72), .ZN(sub_9_n13) );
  INV_X1 sub_9_U18 ( .A(sub_9_n72), .ZN(sub_9_n12) );
  OR2_X1 sub_9_U17 ( .A1(sub_9_n12), .A2(sub_9_n84), .ZN(sub_9_n11) );
  NAND2_X1 sub_9_U16 ( .A1(sub_9_n10), .A2(sub_9_n11), .ZN(sub_9_n78) );
  NAND2_X1 sub_9_U15 ( .A1(sub_9_n36), .A2(sub_9_n13), .ZN(sub_9_n10) );
  NAND2_X1 sub_9_U14 ( .A1(B[11]), .A2(sub_9_n205), .ZN(sub_9_n9) );
  NAND2_X1 sub_9_U13 ( .A1(B[11]), .A2(sub_9_n205), .ZN(sub_9_n8) );
  NAND2_X1 sub_9_U12 ( .A1(sub_9_n246), .A2(B[3]), .ZN(sub_9_n59) );
  NAND2_X1 sub_9_U11 ( .A1(sub_9_n246), .A2(B[3]), .ZN(sub_9_n7) );
  AND2_X2 sub_9_U10 ( .A1(sub_9_n48), .A2(sub_9_n35), .ZN(sub_9_n38) );
  INV_X1 sub_9_U9 ( .A(sub_9_n122), .ZN(sub_9_n6) );
  CLKBUF_X1 sub_9_U8 ( .A(sub_9_n142), .Z(sub_9_n5) );
  CLKBUF_X1 sub_9_U7 ( .A(sub_9_n28), .Z(sub_9_n4) );
  BUF_X1 sub_9_U6 ( .A(sub_9_n42), .Z(sub_9_n3) );
  INV_X1 sub_9_U5 ( .A(A[8]), .ZN(sub_9_n2) );
  CLKBUF_X1 sub_9_U4 ( .A(sub_9_n79), .Z(sub_9_n1) );
  NAND3_X1 sub_9_U3 ( .A1(sub_9_n114), .A2(sub_9_n118), .A3(1'b1), .ZN(
        sub_9_n240) );
endmodule

