/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:31:02 2025
/////////////////////////////////////////////////////////////


module sub_16bit_gpt ( a, b, diff, overflow );
  input [15:0] a;
  input [15:0] b;
  output [15:0] diff;
  output overflow;
  wire   n5, n6, sub_12_n246, sub_12_n245, sub_12_n244, sub_12_n243,
         sub_12_n242, sub_12_n241, sub_12_n240, sub_12_n239, sub_12_n238,
         sub_12_n237, sub_12_n236, sub_12_n235, sub_12_n234, sub_12_n233,
         sub_12_n232, sub_12_n231, sub_12_n230, sub_12_n229, sub_12_n228,
         sub_12_n227, sub_12_n226, sub_12_n225, sub_12_n224, sub_12_n223,
         sub_12_n222, sub_12_n221, sub_12_n220, sub_12_n219, sub_12_n218,
         sub_12_n217, sub_12_n216, sub_12_n215, sub_12_n214, sub_12_n213,
         sub_12_n212, sub_12_n211, sub_12_n210, sub_12_n209, sub_12_n208,
         sub_12_n207, sub_12_n206, sub_12_n205, sub_12_n204, sub_12_n203,
         sub_12_n202, sub_12_n201, sub_12_n200, sub_12_n199, sub_12_n198,
         sub_12_n197, sub_12_n196, sub_12_n195, sub_12_n194, sub_12_n193,
         sub_12_n192, sub_12_n191, sub_12_n190, sub_12_n189, sub_12_n188,
         sub_12_n187, sub_12_n186, sub_12_n185, sub_12_n184, sub_12_n183,
         sub_12_n182, sub_12_n181, sub_12_n180, sub_12_n179, sub_12_n178,
         sub_12_n177, sub_12_n176, sub_12_n175, sub_12_n174, sub_12_n173,
         sub_12_n172, sub_12_n171, sub_12_n170, sub_12_n169, sub_12_n168,
         sub_12_n167, sub_12_n166, sub_12_n165, sub_12_n164, sub_12_n163,
         sub_12_n162, sub_12_n161, sub_12_n160, sub_12_n159, sub_12_n158,
         sub_12_n157, sub_12_n156, sub_12_n155, sub_12_n154, sub_12_n153,
         sub_12_n152, sub_12_n151, sub_12_n150, sub_12_n149, sub_12_n148,
         sub_12_n147, sub_12_n146, sub_12_n145, sub_12_n144, sub_12_n143,
         sub_12_n142, sub_12_n141, sub_12_n140, sub_12_n139, sub_12_n138,
         sub_12_n137, sub_12_n136, sub_12_n135, sub_12_n134, sub_12_n133,
         sub_12_n132, sub_12_n131, sub_12_n130, sub_12_n129, sub_12_n128,
         sub_12_n127, sub_12_n126, sub_12_n125, sub_12_n124, sub_12_n123,
         sub_12_n122, sub_12_n121, sub_12_n120, sub_12_n119, sub_12_n118,
         sub_12_n117, sub_12_n116, sub_12_n115, sub_12_n114, sub_12_n113,
         sub_12_n112, sub_12_n111, sub_12_n110, sub_12_n109, sub_12_n108,
         sub_12_n107, sub_12_n106, sub_12_n105, sub_12_n104, sub_12_n103,
         sub_12_n102, sub_12_n101, sub_12_n100, sub_12_n99, sub_12_n98,
         sub_12_n97, sub_12_n96, sub_12_n95, sub_12_n94, sub_12_n93,
         sub_12_n92, sub_12_n91, sub_12_n90, sub_12_n89, sub_12_n88,
         sub_12_n87, sub_12_n86, sub_12_n85, sub_12_n84, sub_12_n83,
         sub_12_n82, sub_12_n81, sub_12_n80, sub_12_n79, sub_12_n78,
         sub_12_n77, sub_12_n76, sub_12_n75, sub_12_n74, sub_12_n73,
         sub_12_n72, sub_12_n71, sub_12_n70, sub_12_n69, sub_12_n68,
         sub_12_n67, sub_12_n66, sub_12_n65, sub_12_n64, sub_12_n63,
         sub_12_n62, sub_12_n61, sub_12_n60, sub_12_n59, sub_12_n58,
         sub_12_n57, sub_12_n56, sub_12_n55, sub_12_n54, sub_12_n53,
         sub_12_n52, sub_12_n50, sub_12_n49, sub_12_n48, sub_12_n47,
         sub_12_n46, sub_12_n45, sub_12_n44, sub_12_n43, sub_12_n42,
         sub_12_n41, sub_12_n40, sub_12_n39, sub_12_n38, sub_12_n37,
         sub_12_n36, sub_12_n35, sub_12_n34, sub_12_n33, sub_12_n32,
         sub_12_n31, sub_12_n30, sub_12_n29, sub_12_n28, sub_12_n27,
         sub_12_n26, sub_12_n25, sub_12_n24, sub_12_n23, sub_12_n22,
         sub_12_n21, sub_12_n20, sub_12_n19, sub_12_n18, sub_12_n17,
         sub_12_n16, sub_12_n15, sub_12_n14, sub_12_n13, sub_12_n12,
         sub_12_n11, sub_12_n10, sub_12_n9, sub_12_n8, sub_12_n7, sub_12_n6,
         sub_12_n5, sub_12_n4, sub_12_n3, sub_12_n2, sub_12_n1;

  XNOR2_X1 U6 ( .A(a[15]), .B(b[15]), .ZN(n5) );
  NOR2_X1 U7 ( .A1(n6), .A2(n5), .ZN(overflow) );
  XNOR2_X1 U8 ( .A(diff[15]), .B(a[15]), .ZN(n6) );
  INV_X1 sub_12_U264 ( .A(sub_12_n115), .ZN(sub_12_n238) );
  INV_X1 sub_12_U263 ( .A(sub_12_n211), .ZN(sub_12_n195) );
  INV_X1 sub_12_U262 ( .A(sub_12_n21), .ZN(sub_12_n221) );
  INV_X1 sub_12_U261 ( .A(sub_12_n186), .ZN(sub_12_n79) );
  NOR2_X1 sub_12_U260 ( .A1(sub_12_n221), .A2(sub_12_n79), .ZN(sub_12_n220) );
  OAI21_X1 sub_12_U259 ( .B1(sub_12_n195), .B2(sub_12_n219), .A(sub_12_n220), 
        .ZN(sub_12_n217) );
  XNOR2_X1 sub_12_U258 ( .A(sub_12_n213), .B(sub_12_n214), .ZN(diff[10]) );
  INV_X1 sub_12_U257 ( .A(sub_12_n206), .ZN(sub_12_n212) );
  NAND2_X1 sub_12_U256 ( .A1(sub_12_n212), .A2(sub_12_n20), .ZN(sub_12_n202)
         );
  INV_X1 sub_12_U255 ( .A(sub_12_n88), .ZN(sub_12_n168) );
  NAND2_X1 sub_12_U254 ( .A1(sub_12_n168), .A2(sub_12_n20), .ZN(sub_12_n207)
         );
  INV_X1 sub_12_U253 ( .A(sub_12_n189), .ZN(sub_12_n78) );
  INV_X1 sub_12_U252 ( .A(sub_12_n15), .ZN(sub_12_n82) );
  NAND3_X1 sub_12_U251 ( .A1(sub_12_n187), .A2(sub_12_n186), .A3(sub_12_n82), 
        .ZN(sub_12_n209) );
  XNOR2_X1 sub_12_U250 ( .A(sub_12_n198), .B(sub_12_n199), .ZN(diff[11]) );
  INV_X1 sub_12_U249 ( .A(sub_12_n178), .ZN(sub_12_n182) );
  INV_X1 sub_12_U248 ( .A(sub_12_n167), .ZN(sub_12_n136) );
  INV_X1 sub_12_U247 ( .A(sub_12_n146), .ZN(sub_12_n169) );
  NOR2_X1 sub_12_U246 ( .A1(sub_12_n136), .A2(sub_12_n169), .ZN(sub_12_n180)
         );
  NOR2_X1 sub_12_U245 ( .A1(sub_12_n63), .A2(sub_12_n9), .ZN(sub_12_n176) );
  INV_X1 sub_12_U244 ( .A(sub_12_n52), .ZN(sub_12_n139) );
  NAND3_X1 sub_12_U243 ( .A1(sub_12_n170), .A2(sub_12_n22), .A3(sub_12_n139), 
        .ZN(sub_12_n164) );
  AOI21_X1 sub_12_U242 ( .B1(sub_12_n168), .B2(sub_12_n139), .A(sub_12_n169), 
        .ZN(sub_12_n165) );
  XNOR2_X1 sub_12_U241 ( .A(sub_12_n159), .B(sub_12_n160), .ZN(diff[13]) );
  NOR2_X1 sub_12_U240 ( .A1(sub_12_n63), .A2(sub_12_n72), .ZN(sub_12_n152) );
  NAND2_X1 sub_12_U239 ( .A1(sub_12_n152), .A2(sub_12_n153), .ZN(sub_12_n148)
         );
  NAND2_X1 sub_12_U238 ( .A1(sub_12_n150), .A2(sub_12_n46), .ZN(sub_12_n149)
         );
  NAND3_X1 sub_12_U237 ( .A1(sub_12_n129), .A2(sub_12_n128), .A3(sub_12_n127), 
        .ZN(sub_12_n126) );
  XNOR2_X1 sub_12_U236 ( .A(sub_12_n126), .B(sub_12_n50), .ZN(diff[15]) );
  INV_X1 sub_12_U235 ( .A(sub_12_n116), .ZN(sub_12_n113) );
  INV_X1 sub_12_U234 ( .A(sub_12_n48), .ZN(sub_12_n114) );
  OAI21_X1 sub_12_U233 ( .B1(sub_12_n113), .B2(sub_12_n114), .A(sub_12_n16), 
        .ZN(sub_12_n111) );
  XNOR2_X1 sub_12_U232 ( .A(sub_12_n111), .B(sub_12_n112), .ZN(diff[3]) );
  XNOR2_X1 sub_12_U231 ( .A(sub_12_n229), .B(sub_12_n106), .ZN(diff[4]) );
  INV_X1 sub_12_U230 ( .A(sub_12_n229), .ZN(sub_12_n104) );
  INV_X1 sub_12_U229 ( .A(sub_12_n97), .ZN(sub_12_n105) );
  XNOR2_X1 sub_12_U228 ( .A(sub_12_n101), .B(sub_12_n102), .ZN(diff[5]) );
  NAND3_X1 sub_12_U227 ( .A1(sub_12_n96), .A2(sub_12_n97), .A3(sub_12_n93), 
        .ZN(sub_12_n90) );
  INV_X1 sub_12_U226 ( .A(sub_12_n69), .ZN(sub_12_n92) );
  INV_X1 sub_12_U225 ( .A(sub_12_n95), .ZN(sub_12_n94) );
  NOR2_X1 sub_12_U224 ( .A1(sub_12_n78), .A2(sub_12_n79), .ZN(sub_12_n77) );
  NAND2_X1 sub_12_U223 ( .A1(sub_12_n58), .A2(b[13]), .ZN(sub_12_n151) );
  OAI21_X1 sub_12_U222 ( .B1(sub_12_n27), .B2(sub_12_n146), .A(sub_12_n147), 
        .ZN(sub_12_n144) );
  NOR2_X1 sub_12_U221 ( .A1(sub_12_n136), .A2(sub_12_n74), .ZN(sub_12_n130) );
  NOR2_X1 sub_12_U220 ( .A1(sub_12_n74), .A2(sub_12_n141), .ZN(sub_12_n140) );
  NAND2_X1 sub_12_U219 ( .A1(sub_12_n159), .A2(sub_12_n67), .ZN(sub_12_n158)
         );
  NAND2_X1 sub_12_U218 ( .A1(sub_12_n147), .A2(sub_12_n67), .ZN(sub_12_n160)
         );
  NAND2_X1 sub_12_U217 ( .A1(sub_12_n75), .A2(sub_12_n108), .ZN(sub_12_n138)
         );
  NAND2_X1 sub_12_U216 ( .A1(sub_12_n19), .A2(sub_12_n108), .ZN(sub_12_n194)
         );
  NAND4_X1 sub_12_U215 ( .A1(sub_12_n59), .A2(sub_12_n19), .A3(sub_12_n108), 
        .A4(sub_12_n110), .ZN(sub_12_n229) );
  NAND4_X1 sub_12_U214 ( .A1(sub_12_n163), .A2(sub_12_n164), .A3(sub_12_n165), 
        .A4(sub_12_n166), .ZN(sub_12_n159) );
  OAI21_X1 sub_12_U213 ( .B1(sub_12_n133), .B2(sub_12_n60), .A(sub_12_n134), 
        .ZN(sub_12_n132) );
  NAND2_X1 sub_12_U212 ( .A1(sub_12_n158), .A2(sub_12_n147), .ZN(sub_12_n154)
         );
  AOI21_X1 sub_12_U211 ( .B1(sub_12_n78), .B2(sub_12_n187), .A(sub_12_n18), 
        .ZN(sub_12_n208) );
  NAND2_X1 sub_12_U210 ( .A1(sub_12_n187), .A2(sub_12_n186), .ZN(sub_12_n206)
         );
  NAND4_X1 sub_12_U209 ( .A1(sub_12_n186), .A2(sub_12_n81), .A3(sub_12_n54), 
        .A4(sub_12_n188), .ZN(sub_12_n178) );
  INV_X1 sub_12_U208 ( .A(a[10]), .ZN(sub_12_n215) );
  AOI21_X1 sub_12_U207 ( .B1(sub_12_n80), .B2(sub_12_n182), .A(sub_12_n71), 
        .ZN(sub_12_n179) );
  XNOR2_X1 sub_12_U206 ( .A(sub_12_n179), .B(sub_12_n180), .ZN(diff[12]) );
  AOI21_X1 sub_12_U205 ( .B1(sub_12_n142), .B2(sub_12_n139), .A(sub_12_n143), 
        .ZN(sub_12_n127) );
  INV_X1 sub_12_U204 ( .A(a[9]), .ZN(sub_12_n197) );
  NAND2_X1 sub_12_U203 ( .A1(sub_12_n17), .A2(sub_12_n125), .ZN(diff[0]) );
  OAI211_X1 sub_12_U202 ( .C1(a[10]), .C2(sub_12_n171), .A(sub_12_n173), .B(
        sub_12_n172), .ZN(sub_12_n133) );
  INV_X1 sub_12_U201 ( .A(a[8]), .ZN(sub_12_n196) );
  NAND2_X1 sub_12_U200 ( .A1(sub_12_n184), .A2(sub_12_n183), .ZN(sub_12_n131)
         );
  AOI21_X1 sub_12_U199 ( .B1(sub_12_n131), .B2(sub_12_n130), .A(sub_12_n132), 
        .ZN(sub_12_n129) );
  NAND4_X1 sub_12_U198 ( .A1(sub_12_n28), .A2(sub_12_n87), .A3(sub_12_n93), 
        .A4(sub_12_n22), .ZN(sub_12_n211) );
  AOI21_X1 sub_12_U197 ( .B1(sub_12_n1), .B2(sub_12_n21), .A(sub_12_n82), .ZN(
        sub_12_n76) );
  XNOR2_X1 sub_12_U196 ( .A(sub_12_n76), .B(sub_12_n77), .ZN(diff[9]) );
  NAND2_X1 sub_12_U195 ( .A1(sub_12_n109), .A2(sub_12_n110), .ZN(sub_12_n137)
         );
  NAND2_X1 sub_12_U194 ( .A1(b[14]), .A2(sub_12_n56), .ZN(sub_12_n145) );
  INV_X1 sub_12_U193 ( .A(sub_12_n46), .ZN(sub_12_n74) );
  NAND2_X1 sub_12_U192 ( .A1(sub_12_n59), .A2(sub_12_n110), .ZN(sub_12_n193)
         );
  INV_X1 sub_12_U191 ( .A(sub_12_n133), .ZN(sub_12_n73) );
  NOR2_X1 sub_12_U190 ( .A1(sub_12_n148), .A2(sub_12_n149), .ZN(sub_12_n142)
         );
  INV_X1 sub_12_U189 ( .A(b[1]), .ZN(sub_12_n122) );
  INV_X1 sub_12_U188 ( .A(a[1]), .ZN(sub_12_n236) );
  NAND2_X1 sub_12_U187 ( .A1(sub_12_n57), .A2(sub_12_n167), .ZN(sub_12_n166)
         );
  NAND2_X1 sub_12_U186 ( .A1(sub_12_n187), .A2(sub_12_n210), .ZN(sub_12_n214)
         );
  NAND2_X1 sub_12_U185 ( .A1(sub_12_n32), .A2(sub_12_n110), .ZN(sub_12_n112)
         );
  INV_X1 sub_12_U184 ( .A(a[2]), .ZN(sub_12_n237) );
  INV_X1 sub_12_U183 ( .A(a[14]), .ZN(sub_12_n157) );
  NAND2_X1 sub_12_U182 ( .A1(sub_12_n55), .A2(sub_12_n120), .ZN(sub_12_n118)
         );
  NAND2_X1 sub_12_U181 ( .A1(sub_12_n55), .A2(sub_12_n26), .ZN(sub_12_n121) );
  INV_X1 sub_12_U180 ( .A(a[6]), .ZN(sub_12_n228) );
  AND2_X1 sub_12_U179 ( .A1(b[6]), .A2(sub_12_n228), .ZN(sub_12_n72) );
  INV_X1 sub_12_U178 ( .A(a[3]), .ZN(sub_12_n239) );
  INV_X1 sub_12_U177 ( .A(a[13]), .ZN(sub_12_n161) );
  AOI21_X1 sub_12_U176 ( .B1(sub_12_n124), .B2(sub_12_n119), .A(sub_12_n233), 
        .ZN(sub_12_n231) );
  NAND2_X1 sub_12_U175 ( .A1(sub_12_n123), .A2(sub_12_n124), .ZN(sub_12_n120)
         );
  XNOR2_X1 sub_12_U174 ( .A(sub_12_n154), .B(sub_12_n155), .ZN(diff[14]) );
  CLKBUF_X1 sub_12_U173 ( .A(sub_12_n57), .Z(sub_12_n71) );
  NOR2_X1 sub_12_U172 ( .A1(sub_12_n211), .A2(sub_12_n202), .ZN(sub_12_n204)
         );
  NAND2_X1 sub_12_U171 ( .A1(sub_12_n190), .A2(sub_12_n188), .ZN(sub_12_n199)
         );
  AOI21_X1 sub_12_U170 ( .B1(sub_12_n18), .B2(sub_12_n188), .A(sub_12_n25), 
        .ZN(sub_12_n183) );
  INV_X1 sub_12_U169 ( .A(a[8]), .ZN(sub_12_n70) );
  NAND2_X1 sub_12_U168 ( .A1(sub_12_n48), .A2(sub_12_n16), .ZN(sub_12_n117) );
  NAND2_X1 sub_12_U167 ( .A1(sub_12_n65), .A2(sub_12_n134), .ZN(sub_12_n155)
         );
  NAND2_X1 sub_12_U166 ( .A1(a[1]), .A2(sub_12_n122), .ZN(sub_12_n119) );
  AND2_X1 sub_12_U165 ( .A1(sub_12_n211), .A2(sub_12_n5), .ZN(sub_12_n191) );
  NAND2_X1 sub_12_U164 ( .A1(sub_12_n238), .A2(sub_12_n32), .ZN(sub_12_n108)
         );
  INV_X1 sub_12_U163 ( .A(b[5]), .ZN(sub_12_n224) );
  NAND2_X1 sub_12_U162 ( .A1(a[5]), .A2(sub_12_n14), .ZN(sub_12_n69) );
  NAND2_X1 sub_12_U161 ( .A1(a[5]), .A2(sub_12_n14), .ZN(sub_12_n68) );
  NAND2_X1 sub_12_U160 ( .A1(b[13]), .A2(sub_12_n161), .ZN(sub_12_n67) );
  NAND2_X1 sub_12_U159 ( .A1(sub_12_n237), .A2(b[2]), .ZN(sub_12_n66) );
  INV_X1 sub_12_U158 ( .A(a[11]), .ZN(sub_12_n200) );
  NAND2_X1 sub_12_U157 ( .A1(b[14]), .A2(sub_12_n157), .ZN(sub_12_n65) );
  NAND2_X1 sub_12_U156 ( .A1(a[8]), .A2(sub_12_n223), .ZN(sub_12_n84) );
  NAND2_X1 sub_12_U155 ( .A1(sub_12_n30), .A2(sub_12_n5), .ZN(sub_12_n219) );
  NAND2_X1 sub_12_U154 ( .A1(sub_12_n189), .A2(sub_12_n84), .ZN(sub_12_n185)
         );
  NAND2_X1 sub_12_U153 ( .A1(sub_12_n20), .A2(sub_12_n30), .ZN(sub_12_n83) );
  INV_X1 sub_12_U152 ( .A(a[0]), .ZN(sub_12_n245) );
  INV_X1 sub_12_U151 ( .A(b[0]), .ZN(sub_12_n246) );
  INV_X1 sub_12_U150 ( .A(b[12]), .ZN(sub_12_n174) );
  NAND2_X1 sub_12_U149 ( .A1(b[3]), .A2(sub_12_n13), .ZN(sub_12_n64) );
  INV_X1 sub_12_U148 ( .A(b[11]), .ZN(sub_12_n175) );
  INV_X1 sub_12_U147 ( .A(a[7]), .ZN(sub_12_n244) );
  AND2_X1 sub_12_U146 ( .A1(b[7]), .A2(sub_12_n244), .ZN(sub_12_n63) );
  NAND2_X1 sub_12_U145 ( .A1(sub_12_n232), .A2(sub_12_n231), .ZN(sub_12_n109)
         );
  NOR2_X1 sub_12_U144 ( .A1(sub_12_n62), .A2(sub_12_n229), .ZN(sub_12_n89) );
  OAI21_X1 sub_12_U143 ( .B1(sub_12_n89), .B2(sub_12_n90), .A(sub_12_n91), 
        .ZN(sub_12_n85) );
  NAND2_X1 sub_12_U142 ( .A1(sub_12_n95), .A2(sub_12_n226), .ZN(sub_12_n150)
         );
  AND2_X1 sub_12_U141 ( .A1(sub_12_n28), .A2(sub_12_n176), .ZN(sub_12_n170) );
  INV_X1 sub_12_U140 ( .A(b[4]), .ZN(sub_12_n225) );
  INV_X1 sub_12_U139 ( .A(a[9]), .ZN(sub_12_n61) );
  OR2_X1 sub_12_U138 ( .A1(sub_12_n135), .A2(sub_12_n88), .ZN(sub_12_n60) );
  INV_X1 sub_12_U137 ( .A(b[6]), .ZN(sub_12_n227) );
  NAND2_X1 sub_12_U136 ( .A1(sub_12_n7), .A2(sub_12_n31), .ZN(sub_12_n59) );
  INV_X1 sub_12_U135 ( .A(a[13]), .ZN(sub_12_n58) );
  NAND2_X1 sub_12_U134 ( .A1(sub_12_n184), .A2(sub_12_n53), .ZN(sub_12_n57) );
  NAND2_X1 sub_12_U133 ( .A1(a[11]), .A2(sub_12_n175), .ZN(sub_12_n190) );
  OAI211_X1 sub_12_U132 ( .C1(sub_12_n193), .C2(sub_12_n194), .A(sub_12_n177), 
        .B(sub_12_n11), .ZN(sub_12_n163) );
  INV_X1 sub_12_U131 ( .A(a[14]), .ZN(sub_12_n56) );
  NAND2_X1 sub_12_U130 ( .A1(a[4]), .A2(sub_12_n225), .ZN(sub_12_n100) );
  NAND2_X1 sub_12_U129 ( .A1(sub_12_n97), .A2(sub_12_n100), .ZN(sub_12_n106)
         );
  OAI21_X1 sub_12_U128 ( .B1(sub_12_n104), .B2(sub_12_n105), .A(sub_12_n100), 
        .ZN(sub_12_n101) );
  NAND2_X1 sub_12_U127 ( .A1(b[7]), .A2(sub_12_n244), .ZN(sub_12_n87) );
  NAND4_X1 sub_12_U126 ( .A1(sub_12_n87), .A2(sub_12_n242), .A3(sub_12_n243), 
        .A4(sub_12_n241), .ZN(sub_12_n141) );
  NAND2_X1 sub_12_U125 ( .A1(b[1]), .A2(sub_12_n236), .ZN(sub_12_n55) );
  NAND2_X1 sub_12_U124 ( .A1(b[10]), .A2(sub_12_n215), .ZN(sub_12_n54) );
  AOI21_X1 sub_12_U123 ( .B1(sub_12_n18), .B2(sub_12_n188), .A(sub_12_n25), 
        .ZN(sub_12_n53) );
  NAND2_X1 sub_12_U122 ( .A1(a[9]), .A2(sub_12_n218), .ZN(sub_12_n189) );
  OAI211_X1 sub_12_U121 ( .C1(a[10]), .C2(sub_12_n171), .A(sub_12_n29), .B(
        sub_12_n45), .ZN(sub_12_n52) );
  INV_X1 sub_12_U120 ( .A(b[2]), .ZN(sub_12_n240) );
  NAND2_X1 sub_12_U119 ( .A1(a[2]), .A2(sub_12_n240), .ZN(sub_12_n115) );
  AND2_X1 sub_12_U117 ( .A1(a[4]), .A2(sub_12_n225), .ZN(sub_12_n62) );
  NAND2_X1 sub_12_U116 ( .A1(b[4]), .A2(sub_12_n107), .ZN(sub_12_n97) );
  NAND2_X1 sub_12_U115 ( .A1(b[5]), .A2(sub_12_n103), .ZN(sub_12_n96) );
  INV_X1 sub_12_U114 ( .A(b[14]), .ZN(sub_12_n156) );
  NAND2_X1 sub_12_U113 ( .A1(a[14]), .A2(sub_12_n156), .ZN(sub_12_n134) );
  NAND2_X1 sub_12_U112 ( .A1(b[6]), .A2(sub_12_n38), .ZN(sub_12_n93) );
  INV_X1 sub_12_U111 ( .A(b[3]), .ZN(sub_12_n230) );
  NAND2_X1 sub_12_U110 ( .A1(sub_12_n96), .A2(sub_12_n68), .ZN(sub_12_n102) );
  INV_X1 sub_12_U109 ( .A(a[12]), .ZN(sub_12_n181) );
  NAND2_X1 sub_12_U108 ( .A1(b[12]), .A2(sub_12_n181), .ZN(sub_12_n167) );
  NAND2_X1 sub_12_U107 ( .A1(a[12]), .A2(sub_12_n174), .ZN(sub_12_n146) );
  NAND2_X1 sub_12_U106 ( .A1(b[4]), .A2(sub_12_n107), .ZN(sub_12_n241) );
  INV_X1 sub_12_U105 ( .A(a[4]), .ZN(sub_12_n107) );
  NAND2_X1 sub_12_U104 ( .A1(b[6]), .A2(sub_12_n228), .ZN(sub_12_n242) );
  INV_X1 sub_12_U103 ( .A(b[9]), .ZN(sub_12_n218) );
  NAND2_X1 sub_12_U102 ( .A1(b[5]), .A2(sub_12_n103), .ZN(sub_12_n243) );
  INV_X1 sub_12_U101 ( .A(a[5]), .ZN(sub_12_n103) );
  NAND2_X1 sub_12_U100 ( .A1(b[10]), .A2(sub_12_n215), .ZN(sub_12_n187) );
  INV_X1 sub_12_U99 ( .A(b[7]), .ZN(sub_12_n222) );
  NAND2_X1 sub_12_U98 ( .A1(sub_12_n222), .A2(a[7]), .ZN(sub_12_n88) );
  INV_X1 sub_12_U97 ( .A(b[13]), .ZN(sub_12_n162) );
  NAND2_X1 sub_12_U96 ( .A1(a[13]), .A2(sub_12_n162), .ZN(sub_12_n147) );
  INV_X1 sub_12_U95 ( .A(b[8]), .ZN(sub_12_n223) );
  INV_X1 sub_12_U94 ( .A(b[10]), .ZN(sub_12_n171) );
  NOR2_X1 sub_12_U93 ( .A1(sub_12_n224), .A2(a[5]), .ZN(sub_12_n226) );
  XOR2_X1 sub_12_U92 ( .A(b[15]), .B(a[15]), .Z(sub_12_n50) );
  XNOR2_X1 sub_12_U91 ( .A(sub_12_n120), .B(sub_12_n121), .ZN(diff[1]) );
  AOI21_X1 sub_12_U90 ( .B1(sub_12_n92), .B2(sub_12_n93), .A(sub_12_n94), .ZN(
        sub_12_n91) );
  XNOR2_X1 sub_12_U89 ( .A(sub_12_n116), .B(sub_12_n117), .ZN(diff[2]) );
  NAND2_X1 sub_12_U88 ( .A1(sub_12_n118), .A2(sub_12_n119), .ZN(sub_12_n116)
         );
  XNOR2_X1 sub_12_U87 ( .A(sub_12_n1), .B(sub_12_n83), .ZN(diff[8]) );
  NAND2_X1 sub_12_U86 ( .A1(sub_12_n186), .A2(sub_12_n21), .ZN(sub_12_n216) );
  OAI211_X1 sub_12_U85 ( .C1(sub_12_n201), .C2(sub_12_n216), .A(sub_12_n217), 
        .B(sub_12_n6), .ZN(sub_12_n213) );
  NAND2_X1 sub_12_U84 ( .A1(sub_12_n11), .A2(sub_12_n229), .ZN(sub_12_n201) );
  OAI21_X1 sub_12_U83 ( .B1(sub_12_n201), .B2(sub_12_n202), .A(sub_12_n203), 
        .ZN(sub_12_n198) );
  OAI211_X1 sub_12_U82 ( .C1(sub_12_n206), .C2(sub_12_n207), .A(sub_12_n208), 
        .B(sub_12_n209), .ZN(sub_12_n205) );
  NOR2_X1 sub_12_U81 ( .A1(sub_12_n204), .A2(sub_12_n205), .ZN(sub_12_n203) );
  NAND2_X1 sub_12_U80 ( .A1(sub_12_n87), .A2(sub_12_n5), .ZN(sub_12_n86) );
  XNOR2_X1 sub_12_U79 ( .A(sub_12_n85), .B(sub_12_n86), .ZN(diff[7]) );
  OAI21_X1 sub_12_U78 ( .B1(sub_12_n194), .B2(sub_12_n193), .A(sub_12_n11), 
        .ZN(sub_12_n192) );
  NAND2_X1 sub_12_U77 ( .A1(sub_12_n191), .A2(sub_12_n192), .ZN(sub_12_n80) );
  NAND2_X1 sub_12_U76 ( .A1(sub_12_n97), .A2(sub_12_n96), .ZN(sub_12_n99) );
  OAI21_X1 sub_12_U75 ( .B1(sub_12_n89), .B2(sub_12_n99), .A(sub_12_n69), .ZN(
        sub_12_n98) );
  NOR2_X1 sub_12_U74 ( .A1(sub_12_n178), .A2(sub_12_n136), .ZN(sub_12_n177) );
  INV_X1 sub_12_U73 ( .A(a[2]), .ZN(sub_12_n49) );
  NAND2_X1 sub_12_U72 ( .A1(b[2]), .A2(sub_12_n49), .ZN(sub_12_n48) );
  INV_X1 sub_12_U71 ( .A(a[3]), .ZN(sub_12_n47) );
  AND2_X1 sub_12_U70 ( .A1(sub_12_n145), .A2(sub_12_n151), .ZN(sub_12_n46) );
  AOI22_X1 sub_12_U69 ( .A1(sub_12_n70), .A2(b[8]), .B1(sub_12_n10), .B2(b[9]), 
        .ZN(sub_12_n173) );
  INV_X1 sub_12_U68 ( .A(a[12]), .ZN(sub_12_n44) );
  INV_X1 sub_12_U67 ( .A(a[11]), .ZN(sub_12_n43) );
  INV_X1 sub_12_U66 ( .A(b[13]), .ZN(sub_12_n42) );
  INV_X1 sub_12_U65 ( .A(b[14]), .ZN(sub_12_n41) );
  OAI22_X1 sub_12_U64 ( .A1(sub_12_n41), .A2(a[14]), .B1(sub_12_n162), .B2(
        a[13]), .ZN(sub_12_n135) );
  NAND2_X1 sub_12_U63 ( .A1(sub_12_n227), .A2(a[6]), .ZN(sub_12_n95) );
  AND2_X1 sub_12_U62 ( .A1(sub_12_n144), .A2(sub_12_n65), .ZN(sub_12_n143) );
  INV_X1 sub_12_U61 ( .A(a[5]), .ZN(sub_12_n40) );
  INV_X1 sub_12_U60 ( .A(a[4]), .ZN(sub_12_n39) );
  INV_X1 sub_12_U59 ( .A(a[6]), .ZN(sub_12_n38) );
  OAI211_X1 sub_12_U58 ( .C1(sub_12_n138), .C2(sub_12_n137), .A(sub_12_n140), 
        .B(sub_12_n73), .ZN(sub_12_n128) );
  NAND4_X1 sub_12_U57 ( .A1(sub_12_n185), .A2(sub_12_n186), .A3(sub_12_n54), 
        .A4(sub_12_n188), .ZN(sub_12_n184) );
  NAND2_X1 sub_12_U56 ( .A1(sub_12_n245), .A2(b[0]), .ZN(sub_12_n125) );
  INV_X1 sub_12_U55 ( .A(b[0]), .ZN(sub_12_n37) );
  INV_X1 sub_12_U54 ( .A(b[1]), .ZN(sub_12_n36) );
  OAI22_X1 sub_12_U53 ( .A1(sub_12_n4), .A2(a[1]), .B1(sub_12_n37), .B2(a[0]), 
        .ZN(sub_12_n235) );
  AOI22_X1 sub_12_U52 ( .A1(sub_12_n197), .A2(b[9]), .B1(sub_12_n70), .B2(b[8]), .ZN(sub_12_n45) );
  NAND2_X1 sub_12_U51 ( .A1(sub_12_n246), .A2(a[0]), .ZN(sub_12_n124) );
  INV_X1 sub_12_U50 ( .A(b[1]), .ZN(sub_12_n35) );
  NOR2_X1 sub_12_U49 ( .A1(sub_12_n35), .A2(a[1]), .ZN(sub_12_n233) );
  AND2_X1 sub_12_U48 ( .A1(sub_12_n47), .A2(b[3]), .ZN(sub_12_n33) );
  NOR2_X1 sub_12_U47 ( .A1(sub_12_n33), .A2(sub_12_n34), .ZN(sub_12_n232) );
  NAND2_X1 sub_12_U46 ( .A1(sub_12_n239), .A2(b[3]), .ZN(sub_12_n32) );
  AOI21_X1 sub_12_U45 ( .B1(sub_12_n26), .B2(sub_12_n17), .A(sub_12_n23), .ZN(
        sub_12_n31) );
  CLKBUF_X1 sub_12_U44 ( .A(sub_12_n15), .Z(sub_12_n30) );
  AOI22_X1 sub_12_U43 ( .A1(sub_12_n43), .A2(b[11]), .B1(sub_12_n8), .B2(b[12]), .ZN(sub_12_n172) );
  AOI22_X1 sub_12_U42 ( .A1(sub_12_n43), .A2(b[11]), .B1(sub_12_n44), .B2(
        b[12]), .ZN(sub_12_n29) );
  OAI22_X1 sub_12_U41 ( .A1(sub_12_n41), .A2(a[14]), .B1(sub_12_n42), .B2(
        a[13]), .ZN(sub_12_n27) );
  NAND2_X1 sub_12_U40 ( .A1(a[1]), .A2(sub_12_n36), .ZN(sub_12_n26) );
  AND2_X1 sub_12_U39 ( .A1(a[11]), .A2(sub_12_n175), .ZN(sub_12_n25) );
  INV_X1 sub_12_U38 ( .A(a[2]), .ZN(sub_12_n24) );
  NOR2_X1 sub_12_U37 ( .A1(sub_12_n3), .A2(a[1]), .ZN(sub_12_n23) );
  NAND2_X1 sub_12_U36 ( .A1(b[8]), .A2(sub_12_n196), .ZN(sub_12_n81) );
  NAND2_X1 sub_12_U35 ( .A1(b[8]), .A2(sub_12_n196), .ZN(sub_12_n21) );
  NAND2_X1 sub_12_U34 ( .A1(b[8]), .A2(sub_12_n196), .ZN(sub_12_n20) );
  BUF_X1 sub_12_U33 ( .A(sub_12_n150), .Z(sub_12_n28) );
  OR2_X1 sub_12_U32 ( .A1(sub_12_n234), .A2(sub_12_n235), .ZN(sub_12_n75) );
  OR2_X1 sub_12_U31 ( .A1(sub_12_n234), .A2(sub_12_n235), .ZN(sub_12_n19) );
  AND2_X2 sub_12_U30 ( .A1(a[10]), .A2(sub_12_n171), .ZN(sub_12_n18) );
  NAND2_X1 sub_12_U29 ( .A1(sub_12_n246), .A2(a[0]), .ZN(sub_12_n17) );
  OAI222_X1 sub_12_U28 ( .A1(sub_12_n38), .A2(b[6]), .B1(sub_12_n39), .B2(b[4]), .C1(sub_12_n40), .C2(b[5]), .ZN(sub_12_n153) );
  CLKBUF_X1 sub_12_U27 ( .A(sub_12_n115), .Z(sub_12_n16) );
  NAND2_X1 sub_12_U26 ( .A1(a[8]), .A2(sub_12_n223), .ZN(sub_12_n15) );
  INV_X1 sub_12_U25 ( .A(b[5]), .ZN(sub_12_n14) );
  INV_X1 sub_12_U24 ( .A(a[3]), .ZN(sub_12_n13) );
  AND2_X1 sub_12_U23 ( .A1(sub_12_n93), .A2(sub_12_n95), .ZN(sub_12_n12) );
  XOR2_X1 sub_12_U22 ( .A(sub_12_n98), .B(sub_12_n12), .Z(diff[6]) );
  AND4_X1 sub_12_U21 ( .A1(sub_12_n241), .A2(sub_12_n242), .A3(sub_12_n243), 
        .A4(sub_12_n87), .ZN(sub_12_n11) );
  INV_X1 sub_12_U20 ( .A(sub_12_n18), .ZN(sub_12_n210) );
  NAND2_X1 sub_12_U19 ( .A1(a[3]), .A2(sub_12_n230), .ZN(sub_12_n110) );
  OAI222_X1 sub_12_U18 ( .A1(sub_12_n38), .A2(b[6]), .B1(sub_12_n39), .B2(b[4]), .C1(sub_12_n40), .C2(b[5]), .ZN(sub_12_n22) );
  INV_X1 sub_12_U17 ( .A(a[9]), .ZN(sub_12_n10) );
  INV_X1 sub_12_U16 ( .A(sub_12_n242), .ZN(sub_12_n9) );
  INV_X1 sub_12_U15 ( .A(a[12]), .ZN(sub_12_n8) );
  NOR2_X1 sub_12_U14 ( .A1(sub_12_n33), .A2(sub_12_n2), .ZN(sub_12_n7) );
  NAND2_X2 sub_12_U13 ( .A1(b[9]), .A2(sub_12_n61), .ZN(sub_12_n186) );
  INV_X1 sub_12_U12 ( .A(sub_12_n78), .ZN(sub_12_n6) );
  CLKBUF_X1 sub_12_U11 ( .A(sub_12_n88), .Z(sub_12_n5) );
  INV_X1 sub_12_U10 ( .A(b[1]), .ZN(sub_12_n4) );
  INV_X1 sub_12_U9 ( .A(b[1]), .ZN(sub_12_n3) );
  AND2_X1 sub_12_U8 ( .A1(sub_12_n24), .A2(b[2]), .ZN(sub_12_n34) );
  AND2_X1 sub_12_U7 ( .A1(sub_12_n24), .A2(b[2]), .ZN(sub_12_n2) );
  NAND2_X2 sub_12_U6 ( .A1(sub_12_n200), .A2(b[11]), .ZN(sub_12_n188) );
  NAND2_X1 sub_12_U5 ( .A1(sub_12_n191), .A2(sub_12_n192), .ZN(sub_12_n1) );
  NAND3_X1 sub_12_U4 ( .A1(sub_12_n64), .A2(sub_12_n66), .A3(1'b1), .ZN(
        sub_12_n234) );
  INV_X2 sub_12_U3 ( .A(sub_12_n125), .ZN(sub_12_n123) );
endmodule

