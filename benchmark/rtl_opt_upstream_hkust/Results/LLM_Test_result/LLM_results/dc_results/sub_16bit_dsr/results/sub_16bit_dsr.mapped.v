/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:40:06 2025
/////////////////////////////////////////////////////////////


module sub_16bit_dsr ( a, b, diff, overflow );
  input [15:0] a;
  input [15:0] b;
  output [15:0] diff;
  output overflow;
  wire   n5, n6, sub_8_n246, sub_8_n245, sub_8_n244, sub_8_n243, sub_8_n242,
         sub_8_n241, sub_8_n240, sub_8_n239, sub_8_n238, sub_8_n237,
         sub_8_n236, sub_8_n235, sub_8_n234, sub_8_n233, sub_8_n232,
         sub_8_n231, sub_8_n230, sub_8_n229, sub_8_n228, sub_8_n227,
         sub_8_n226, sub_8_n225, sub_8_n224, sub_8_n223, sub_8_n222,
         sub_8_n221, sub_8_n220, sub_8_n219, sub_8_n218, sub_8_n217,
         sub_8_n216, sub_8_n215, sub_8_n214, sub_8_n213, sub_8_n212,
         sub_8_n211, sub_8_n210, sub_8_n209, sub_8_n208, sub_8_n207,
         sub_8_n206, sub_8_n205, sub_8_n204, sub_8_n203, sub_8_n202,
         sub_8_n201, sub_8_n200, sub_8_n199, sub_8_n198, sub_8_n197,
         sub_8_n196, sub_8_n195, sub_8_n194, sub_8_n193, sub_8_n192,
         sub_8_n191, sub_8_n190, sub_8_n189, sub_8_n188, sub_8_n187,
         sub_8_n186, sub_8_n185, sub_8_n184, sub_8_n183, sub_8_n182,
         sub_8_n181, sub_8_n180, sub_8_n179, sub_8_n178, sub_8_n177,
         sub_8_n176, sub_8_n175, sub_8_n174, sub_8_n173, sub_8_n172,
         sub_8_n171, sub_8_n170, sub_8_n169, sub_8_n168, sub_8_n167,
         sub_8_n166, sub_8_n165, sub_8_n164, sub_8_n163, sub_8_n162,
         sub_8_n161, sub_8_n160, sub_8_n159, sub_8_n158, sub_8_n157,
         sub_8_n156, sub_8_n155, sub_8_n154, sub_8_n153, sub_8_n152,
         sub_8_n151, sub_8_n150, sub_8_n149, sub_8_n148, sub_8_n147,
         sub_8_n146, sub_8_n145, sub_8_n144, sub_8_n143, sub_8_n142,
         sub_8_n141, sub_8_n140, sub_8_n139, sub_8_n138, sub_8_n137,
         sub_8_n136, sub_8_n135, sub_8_n134, sub_8_n133, sub_8_n132,
         sub_8_n131, sub_8_n130, sub_8_n129, sub_8_n128, sub_8_n127,
         sub_8_n126, sub_8_n125, sub_8_n124, sub_8_n123, sub_8_n122,
         sub_8_n121, sub_8_n120, sub_8_n119, sub_8_n118, sub_8_n117,
         sub_8_n116, sub_8_n115, sub_8_n114, sub_8_n113, sub_8_n112,
         sub_8_n111, sub_8_n110, sub_8_n109, sub_8_n108, sub_8_n107,
         sub_8_n106, sub_8_n105, sub_8_n104, sub_8_n103, sub_8_n102,
         sub_8_n101, sub_8_n100, sub_8_n99, sub_8_n98, sub_8_n97, sub_8_n96,
         sub_8_n95, sub_8_n94, sub_8_n93, sub_8_n92, sub_8_n91, sub_8_n90,
         sub_8_n89, sub_8_n88, sub_8_n87, sub_8_n86, sub_8_n85, sub_8_n84,
         sub_8_n83, sub_8_n82, sub_8_n81, sub_8_n80, sub_8_n79, sub_8_n78,
         sub_8_n77, sub_8_n76, sub_8_n75, sub_8_n74, sub_8_n73, sub_8_n72,
         sub_8_n71, sub_8_n70, sub_8_n69, sub_8_n68, sub_8_n67, sub_8_n66,
         sub_8_n65, sub_8_n64, sub_8_n63, sub_8_n62, sub_8_n61, sub_8_n60,
         sub_8_n59, sub_8_n58, sub_8_n57, sub_8_n56, sub_8_n55, sub_8_n54,
         sub_8_n53, sub_8_n52, sub_8_n50, sub_8_n49, sub_8_n48, sub_8_n47,
         sub_8_n46, sub_8_n45, sub_8_n44, sub_8_n43, sub_8_n42, sub_8_n41,
         sub_8_n40, sub_8_n39, sub_8_n38, sub_8_n37, sub_8_n36, sub_8_n35,
         sub_8_n34, sub_8_n33, sub_8_n32, sub_8_n31, sub_8_n30, sub_8_n29,
         sub_8_n28, sub_8_n27, sub_8_n26, sub_8_n25, sub_8_n24, sub_8_n23,
         sub_8_n22, sub_8_n21, sub_8_n20, sub_8_n19, sub_8_n18, sub_8_n17,
         sub_8_n16, sub_8_n15, sub_8_n14, sub_8_n13, sub_8_n12, sub_8_n11,
         sub_8_n10, sub_8_n9, sub_8_n8, sub_8_n7, sub_8_n6, sub_8_n5, sub_8_n4,
         sub_8_n3, sub_8_n2, sub_8_n1;

  XNOR2_X1 U6 ( .A(a[15]), .B(b[15]), .ZN(n5) );
  NOR2_X1 U7 ( .A1(n6), .A2(n5), .ZN(overflow) );
  XNOR2_X1 U8 ( .A(diff[15]), .B(a[15]), .ZN(n6) );
  INV_X1 sub_8_U264 ( .A(sub_8_n115), .ZN(sub_8_n238) );
  INV_X1 sub_8_U263 ( .A(sub_8_n211), .ZN(sub_8_n195) );
  INV_X1 sub_8_U262 ( .A(sub_8_n21), .ZN(sub_8_n221) );
  INV_X1 sub_8_U261 ( .A(sub_8_n186), .ZN(sub_8_n79) );
  NOR2_X1 sub_8_U260 ( .A1(sub_8_n221), .A2(sub_8_n79), .ZN(sub_8_n220) );
  OAI21_X1 sub_8_U259 ( .B1(sub_8_n195), .B2(sub_8_n219), .A(sub_8_n220), .ZN(
        sub_8_n217) );
  XNOR2_X1 sub_8_U258 ( .A(sub_8_n213), .B(sub_8_n214), .ZN(diff[10]) );
  INV_X1 sub_8_U257 ( .A(sub_8_n206), .ZN(sub_8_n212) );
  NAND2_X1 sub_8_U256 ( .A1(sub_8_n212), .A2(sub_8_n20), .ZN(sub_8_n202) );
  INV_X1 sub_8_U255 ( .A(sub_8_n88), .ZN(sub_8_n168) );
  NAND2_X1 sub_8_U254 ( .A1(sub_8_n168), .A2(sub_8_n20), .ZN(sub_8_n207) );
  INV_X1 sub_8_U253 ( .A(sub_8_n189), .ZN(sub_8_n78) );
  INV_X1 sub_8_U252 ( .A(sub_8_n15), .ZN(sub_8_n82) );
  NAND3_X1 sub_8_U251 ( .A1(sub_8_n187), .A2(sub_8_n186), .A3(sub_8_n82), .ZN(
        sub_8_n209) );
  XNOR2_X1 sub_8_U250 ( .A(sub_8_n198), .B(sub_8_n199), .ZN(diff[11]) );
  INV_X1 sub_8_U249 ( .A(sub_8_n178), .ZN(sub_8_n182) );
  INV_X1 sub_8_U248 ( .A(sub_8_n167), .ZN(sub_8_n136) );
  INV_X1 sub_8_U247 ( .A(sub_8_n146), .ZN(sub_8_n169) );
  NOR2_X1 sub_8_U246 ( .A1(sub_8_n136), .A2(sub_8_n169), .ZN(sub_8_n180) );
  NOR2_X1 sub_8_U245 ( .A1(sub_8_n63), .A2(sub_8_n9), .ZN(sub_8_n176) );
  INV_X1 sub_8_U244 ( .A(sub_8_n52), .ZN(sub_8_n139) );
  NAND3_X1 sub_8_U243 ( .A1(sub_8_n170), .A2(sub_8_n22), .A3(sub_8_n139), .ZN(
        sub_8_n164) );
  AOI21_X1 sub_8_U242 ( .B1(sub_8_n168), .B2(sub_8_n139), .A(sub_8_n169), .ZN(
        sub_8_n165) );
  XNOR2_X1 sub_8_U241 ( .A(sub_8_n159), .B(sub_8_n160), .ZN(diff[13]) );
  NOR2_X1 sub_8_U240 ( .A1(sub_8_n63), .A2(sub_8_n72), .ZN(sub_8_n152) );
  NAND2_X1 sub_8_U239 ( .A1(sub_8_n152), .A2(sub_8_n153), .ZN(sub_8_n148) );
  NAND2_X1 sub_8_U238 ( .A1(sub_8_n150), .A2(sub_8_n46), .ZN(sub_8_n149) );
  NAND3_X1 sub_8_U237 ( .A1(sub_8_n129), .A2(sub_8_n128), .A3(sub_8_n127), 
        .ZN(sub_8_n126) );
  XNOR2_X1 sub_8_U236 ( .A(sub_8_n126), .B(sub_8_n50), .ZN(diff[15]) );
  INV_X1 sub_8_U235 ( .A(sub_8_n116), .ZN(sub_8_n113) );
  INV_X1 sub_8_U234 ( .A(sub_8_n48), .ZN(sub_8_n114) );
  OAI21_X1 sub_8_U233 ( .B1(sub_8_n113), .B2(sub_8_n114), .A(sub_8_n16), .ZN(
        sub_8_n111) );
  XNOR2_X1 sub_8_U232 ( .A(sub_8_n111), .B(sub_8_n112), .ZN(diff[3]) );
  XNOR2_X1 sub_8_U231 ( .A(sub_8_n229), .B(sub_8_n106), .ZN(diff[4]) );
  INV_X1 sub_8_U230 ( .A(sub_8_n229), .ZN(sub_8_n104) );
  INV_X1 sub_8_U229 ( .A(sub_8_n97), .ZN(sub_8_n105) );
  XNOR2_X1 sub_8_U228 ( .A(sub_8_n101), .B(sub_8_n102), .ZN(diff[5]) );
  NAND3_X1 sub_8_U227 ( .A1(sub_8_n96), .A2(sub_8_n97), .A3(sub_8_n93), .ZN(
        sub_8_n90) );
  INV_X1 sub_8_U226 ( .A(sub_8_n69), .ZN(sub_8_n92) );
  INV_X1 sub_8_U225 ( .A(sub_8_n95), .ZN(sub_8_n94) );
  NOR2_X1 sub_8_U224 ( .A1(sub_8_n78), .A2(sub_8_n79), .ZN(sub_8_n77) );
  NAND2_X1 sub_8_U223 ( .A1(sub_8_n58), .A2(b[13]), .ZN(sub_8_n151) );
  OAI21_X1 sub_8_U222 ( .B1(sub_8_n27), .B2(sub_8_n146), .A(sub_8_n147), .ZN(
        sub_8_n144) );
  NOR2_X1 sub_8_U221 ( .A1(sub_8_n136), .A2(sub_8_n74), .ZN(sub_8_n130) );
  NOR2_X1 sub_8_U220 ( .A1(sub_8_n74), .A2(sub_8_n141), .ZN(sub_8_n140) );
  NAND2_X1 sub_8_U219 ( .A1(sub_8_n159), .A2(sub_8_n67), .ZN(sub_8_n158) );
  NAND2_X1 sub_8_U218 ( .A1(sub_8_n147), .A2(sub_8_n67), .ZN(sub_8_n160) );
  NAND2_X1 sub_8_U217 ( .A1(sub_8_n75), .A2(sub_8_n108), .ZN(sub_8_n138) );
  NAND2_X1 sub_8_U216 ( .A1(sub_8_n19), .A2(sub_8_n108), .ZN(sub_8_n194) );
  NAND4_X1 sub_8_U215 ( .A1(sub_8_n59), .A2(sub_8_n19), .A3(sub_8_n108), .A4(
        sub_8_n110), .ZN(sub_8_n229) );
  NAND4_X1 sub_8_U214 ( .A1(sub_8_n163), .A2(sub_8_n164), .A3(sub_8_n165), 
        .A4(sub_8_n166), .ZN(sub_8_n159) );
  OAI21_X1 sub_8_U213 ( .B1(sub_8_n133), .B2(sub_8_n60), .A(sub_8_n134), .ZN(
        sub_8_n132) );
  NAND2_X1 sub_8_U212 ( .A1(sub_8_n158), .A2(sub_8_n147), .ZN(sub_8_n154) );
  AOI21_X1 sub_8_U211 ( .B1(sub_8_n78), .B2(sub_8_n187), .A(sub_8_n18), .ZN(
        sub_8_n208) );
  NAND2_X1 sub_8_U210 ( .A1(sub_8_n187), .A2(sub_8_n186), .ZN(sub_8_n206) );
  NAND4_X1 sub_8_U209 ( .A1(sub_8_n186), .A2(sub_8_n81), .A3(sub_8_n54), .A4(
        sub_8_n188), .ZN(sub_8_n178) );
  INV_X1 sub_8_U208 ( .A(a[10]), .ZN(sub_8_n215) );
  AOI21_X1 sub_8_U207 ( .B1(sub_8_n80), .B2(sub_8_n182), .A(sub_8_n71), .ZN(
        sub_8_n179) );
  XNOR2_X1 sub_8_U206 ( .A(sub_8_n179), .B(sub_8_n180), .ZN(diff[12]) );
  AOI21_X1 sub_8_U205 ( .B1(sub_8_n142), .B2(sub_8_n139), .A(sub_8_n143), .ZN(
        sub_8_n127) );
  INV_X1 sub_8_U204 ( .A(a[9]), .ZN(sub_8_n197) );
  NAND2_X1 sub_8_U203 ( .A1(sub_8_n17), .A2(sub_8_n125), .ZN(diff[0]) );
  OAI211_X1 sub_8_U202 ( .C1(a[10]), .C2(sub_8_n171), .A(sub_8_n173), .B(
        sub_8_n172), .ZN(sub_8_n133) );
  INV_X1 sub_8_U201 ( .A(a[8]), .ZN(sub_8_n196) );
  NAND2_X1 sub_8_U200 ( .A1(sub_8_n184), .A2(sub_8_n183), .ZN(sub_8_n131) );
  AOI21_X1 sub_8_U199 ( .B1(sub_8_n131), .B2(sub_8_n130), .A(sub_8_n132), .ZN(
        sub_8_n129) );
  NAND4_X1 sub_8_U198 ( .A1(sub_8_n28), .A2(sub_8_n87), .A3(sub_8_n93), .A4(
        sub_8_n22), .ZN(sub_8_n211) );
  AOI21_X1 sub_8_U197 ( .B1(sub_8_n1), .B2(sub_8_n21), .A(sub_8_n82), .ZN(
        sub_8_n76) );
  XNOR2_X1 sub_8_U196 ( .A(sub_8_n76), .B(sub_8_n77), .ZN(diff[9]) );
  NAND2_X1 sub_8_U195 ( .A1(sub_8_n109), .A2(sub_8_n110), .ZN(sub_8_n137) );
  NAND2_X1 sub_8_U194 ( .A1(b[14]), .A2(sub_8_n56), .ZN(sub_8_n145) );
  INV_X1 sub_8_U193 ( .A(sub_8_n46), .ZN(sub_8_n74) );
  NAND2_X1 sub_8_U192 ( .A1(sub_8_n59), .A2(sub_8_n110), .ZN(sub_8_n193) );
  INV_X1 sub_8_U191 ( .A(sub_8_n133), .ZN(sub_8_n73) );
  NOR2_X1 sub_8_U190 ( .A1(sub_8_n148), .A2(sub_8_n149), .ZN(sub_8_n142) );
  INV_X1 sub_8_U189 ( .A(b[1]), .ZN(sub_8_n122) );
  INV_X1 sub_8_U188 ( .A(a[1]), .ZN(sub_8_n236) );
  NAND2_X1 sub_8_U187 ( .A1(sub_8_n57), .A2(sub_8_n167), .ZN(sub_8_n166) );
  NAND2_X1 sub_8_U186 ( .A1(sub_8_n187), .A2(sub_8_n210), .ZN(sub_8_n214) );
  NAND2_X1 sub_8_U185 ( .A1(sub_8_n32), .A2(sub_8_n110), .ZN(sub_8_n112) );
  INV_X1 sub_8_U184 ( .A(a[2]), .ZN(sub_8_n237) );
  INV_X1 sub_8_U183 ( .A(a[14]), .ZN(sub_8_n157) );
  NAND2_X1 sub_8_U182 ( .A1(sub_8_n55), .A2(sub_8_n120), .ZN(sub_8_n118) );
  NAND2_X1 sub_8_U181 ( .A1(sub_8_n55), .A2(sub_8_n26), .ZN(sub_8_n121) );
  INV_X1 sub_8_U180 ( .A(a[6]), .ZN(sub_8_n228) );
  AND2_X1 sub_8_U179 ( .A1(b[6]), .A2(sub_8_n228), .ZN(sub_8_n72) );
  INV_X1 sub_8_U178 ( .A(a[3]), .ZN(sub_8_n239) );
  INV_X1 sub_8_U177 ( .A(a[13]), .ZN(sub_8_n161) );
  AOI21_X1 sub_8_U176 ( .B1(sub_8_n124), .B2(sub_8_n119), .A(sub_8_n233), .ZN(
        sub_8_n231) );
  NAND2_X1 sub_8_U175 ( .A1(sub_8_n123), .A2(sub_8_n124), .ZN(sub_8_n120) );
  XNOR2_X1 sub_8_U174 ( .A(sub_8_n154), .B(sub_8_n155), .ZN(diff[14]) );
  CLKBUF_X1 sub_8_U173 ( .A(sub_8_n57), .Z(sub_8_n71) );
  NOR2_X1 sub_8_U172 ( .A1(sub_8_n211), .A2(sub_8_n202), .ZN(sub_8_n204) );
  NAND2_X1 sub_8_U171 ( .A1(sub_8_n190), .A2(sub_8_n188), .ZN(sub_8_n199) );
  AOI21_X1 sub_8_U170 ( .B1(sub_8_n18), .B2(sub_8_n188), .A(sub_8_n25), .ZN(
        sub_8_n183) );
  INV_X1 sub_8_U169 ( .A(a[8]), .ZN(sub_8_n70) );
  NAND2_X1 sub_8_U168 ( .A1(sub_8_n48), .A2(sub_8_n16), .ZN(sub_8_n117) );
  NAND2_X1 sub_8_U167 ( .A1(sub_8_n65), .A2(sub_8_n134), .ZN(sub_8_n155) );
  NAND2_X1 sub_8_U166 ( .A1(a[1]), .A2(sub_8_n122), .ZN(sub_8_n119) );
  AND2_X1 sub_8_U165 ( .A1(sub_8_n211), .A2(sub_8_n5), .ZN(sub_8_n191) );
  NAND2_X1 sub_8_U164 ( .A1(sub_8_n238), .A2(sub_8_n32), .ZN(sub_8_n108) );
  INV_X1 sub_8_U163 ( .A(b[5]), .ZN(sub_8_n224) );
  NAND2_X1 sub_8_U162 ( .A1(a[5]), .A2(sub_8_n14), .ZN(sub_8_n69) );
  NAND2_X1 sub_8_U161 ( .A1(a[5]), .A2(sub_8_n14), .ZN(sub_8_n68) );
  NAND2_X1 sub_8_U160 ( .A1(b[13]), .A2(sub_8_n161), .ZN(sub_8_n67) );
  NAND2_X1 sub_8_U159 ( .A1(sub_8_n237), .A2(b[2]), .ZN(sub_8_n66) );
  INV_X1 sub_8_U158 ( .A(a[11]), .ZN(sub_8_n200) );
  NAND2_X1 sub_8_U157 ( .A1(b[14]), .A2(sub_8_n157), .ZN(sub_8_n65) );
  NAND2_X1 sub_8_U156 ( .A1(a[8]), .A2(sub_8_n223), .ZN(sub_8_n84) );
  NAND2_X1 sub_8_U155 ( .A1(sub_8_n30), .A2(sub_8_n5), .ZN(sub_8_n219) );
  NAND2_X1 sub_8_U154 ( .A1(sub_8_n189), .A2(sub_8_n84), .ZN(sub_8_n185) );
  NAND2_X1 sub_8_U153 ( .A1(sub_8_n20), .A2(sub_8_n30), .ZN(sub_8_n83) );
  INV_X1 sub_8_U152 ( .A(a[0]), .ZN(sub_8_n245) );
  INV_X1 sub_8_U151 ( .A(b[0]), .ZN(sub_8_n246) );
  INV_X1 sub_8_U150 ( .A(b[12]), .ZN(sub_8_n174) );
  NAND2_X1 sub_8_U149 ( .A1(b[3]), .A2(sub_8_n13), .ZN(sub_8_n64) );
  INV_X1 sub_8_U148 ( .A(b[11]), .ZN(sub_8_n175) );
  INV_X1 sub_8_U147 ( .A(a[7]), .ZN(sub_8_n244) );
  AND2_X1 sub_8_U146 ( .A1(b[7]), .A2(sub_8_n244), .ZN(sub_8_n63) );
  NAND2_X1 sub_8_U145 ( .A1(sub_8_n232), .A2(sub_8_n231), .ZN(sub_8_n109) );
  NOR2_X1 sub_8_U144 ( .A1(sub_8_n62), .A2(sub_8_n229), .ZN(sub_8_n89) );
  OAI21_X1 sub_8_U143 ( .B1(sub_8_n89), .B2(sub_8_n90), .A(sub_8_n91), .ZN(
        sub_8_n85) );
  NAND2_X1 sub_8_U142 ( .A1(sub_8_n95), .A2(sub_8_n226), .ZN(sub_8_n150) );
  AND2_X1 sub_8_U141 ( .A1(sub_8_n28), .A2(sub_8_n176), .ZN(sub_8_n170) );
  INV_X1 sub_8_U140 ( .A(b[4]), .ZN(sub_8_n225) );
  INV_X1 sub_8_U139 ( .A(a[9]), .ZN(sub_8_n61) );
  OR2_X1 sub_8_U138 ( .A1(sub_8_n135), .A2(sub_8_n88), .ZN(sub_8_n60) );
  INV_X1 sub_8_U137 ( .A(b[6]), .ZN(sub_8_n227) );
  NAND2_X1 sub_8_U136 ( .A1(sub_8_n7), .A2(sub_8_n31), .ZN(sub_8_n59) );
  INV_X1 sub_8_U135 ( .A(a[13]), .ZN(sub_8_n58) );
  NAND2_X1 sub_8_U134 ( .A1(sub_8_n184), .A2(sub_8_n53), .ZN(sub_8_n57) );
  NAND2_X1 sub_8_U133 ( .A1(a[11]), .A2(sub_8_n175), .ZN(sub_8_n190) );
  OAI211_X1 sub_8_U132 ( .C1(sub_8_n193), .C2(sub_8_n194), .A(sub_8_n177), .B(
        sub_8_n11), .ZN(sub_8_n163) );
  INV_X1 sub_8_U131 ( .A(a[14]), .ZN(sub_8_n56) );
  NAND2_X1 sub_8_U130 ( .A1(a[4]), .A2(sub_8_n225), .ZN(sub_8_n100) );
  NAND2_X1 sub_8_U129 ( .A1(sub_8_n97), .A2(sub_8_n100), .ZN(sub_8_n106) );
  OAI21_X1 sub_8_U128 ( .B1(sub_8_n104), .B2(sub_8_n105), .A(sub_8_n100), .ZN(
        sub_8_n101) );
  NAND2_X1 sub_8_U127 ( .A1(b[7]), .A2(sub_8_n244), .ZN(sub_8_n87) );
  NAND4_X1 sub_8_U126 ( .A1(sub_8_n87), .A2(sub_8_n242), .A3(sub_8_n243), .A4(
        sub_8_n241), .ZN(sub_8_n141) );
  NAND2_X1 sub_8_U125 ( .A1(b[1]), .A2(sub_8_n236), .ZN(sub_8_n55) );
  NAND2_X1 sub_8_U124 ( .A1(b[10]), .A2(sub_8_n215), .ZN(sub_8_n54) );
  AOI21_X1 sub_8_U123 ( .B1(sub_8_n18), .B2(sub_8_n188), .A(sub_8_n25), .ZN(
        sub_8_n53) );
  NAND2_X1 sub_8_U122 ( .A1(a[9]), .A2(sub_8_n218), .ZN(sub_8_n189) );
  OAI211_X1 sub_8_U121 ( .C1(a[10]), .C2(sub_8_n171), .A(sub_8_n29), .B(
        sub_8_n45), .ZN(sub_8_n52) );
  INV_X1 sub_8_U120 ( .A(b[2]), .ZN(sub_8_n240) );
  NAND2_X1 sub_8_U119 ( .A1(a[2]), .A2(sub_8_n240), .ZN(sub_8_n115) );
  AND2_X1 sub_8_U117 ( .A1(a[4]), .A2(sub_8_n225), .ZN(sub_8_n62) );
  NAND2_X1 sub_8_U116 ( .A1(b[4]), .A2(sub_8_n107), .ZN(sub_8_n97) );
  NAND2_X1 sub_8_U115 ( .A1(b[5]), .A2(sub_8_n103), .ZN(sub_8_n96) );
  INV_X1 sub_8_U114 ( .A(b[14]), .ZN(sub_8_n156) );
  NAND2_X1 sub_8_U113 ( .A1(a[14]), .A2(sub_8_n156), .ZN(sub_8_n134) );
  NAND2_X1 sub_8_U112 ( .A1(b[6]), .A2(sub_8_n38), .ZN(sub_8_n93) );
  INV_X1 sub_8_U111 ( .A(b[3]), .ZN(sub_8_n230) );
  NAND2_X1 sub_8_U110 ( .A1(sub_8_n96), .A2(sub_8_n68), .ZN(sub_8_n102) );
  INV_X1 sub_8_U109 ( .A(a[12]), .ZN(sub_8_n181) );
  NAND2_X1 sub_8_U108 ( .A1(b[12]), .A2(sub_8_n181), .ZN(sub_8_n167) );
  NAND2_X1 sub_8_U107 ( .A1(a[12]), .A2(sub_8_n174), .ZN(sub_8_n146) );
  NAND2_X1 sub_8_U106 ( .A1(b[4]), .A2(sub_8_n107), .ZN(sub_8_n241) );
  INV_X1 sub_8_U105 ( .A(a[4]), .ZN(sub_8_n107) );
  NAND2_X1 sub_8_U104 ( .A1(b[6]), .A2(sub_8_n228), .ZN(sub_8_n242) );
  INV_X1 sub_8_U103 ( .A(b[9]), .ZN(sub_8_n218) );
  NAND2_X1 sub_8_U102 ( .A1(b[5]), .A2(sub_8_n103), .ZN(sub_8_n243) );
  INV_X1 sub_8_U101 ( .A(a[5]), .ZN(sub_8_n103) );
  NAND2_X1 sub_8_U100 ( .A1(b[10]), .A2(sub_8_n215), .ZN(sub_8_n187) );
  INV_X1 sub_8_U99 ( .A(b[7]), .ZN(sub_8_n222) );
  NAND2_X1 sub_8_U98 ( .A1(sub_8_n222), .A2(a[7]), .ZN(sub_8_n88) );
  INV_X1 sub_8_U97 ( .A(b[13]), .ZN(sub_8_n162) );
  NAND2_X1 sub_8_U96 ( .A1(a[13]), .A2(sub_8_n162), .ZN(sub_8_n147) );
  INV_X1 sub_8_U95 ( .A(b[8]), .ZN(sub_8_n223) );
  INV_X1 sub_8_U94 ( .A(b[10]), .ZN(sub_8_n171) );
  NOR2_X1 sub_8_U93 ( .A1(sub_8_n224), .A2(a[5]), .ZN(sub_8_n226) );
  XOR2_X1 sub_8_U92 ( .A(b[15]), .B(a[15]), .Z(sub_8_n50) );
  XNOR2_X1 sub_8_U91 ( .A(sub_8_n120), .B(sub_8_n121), .ZN(diff[1]) );
  AOI21_X1 sub_8_U90 ( .B1(sub_8_n92), .B2(sub_8_n93), .A(sub_8_n94), .ZN(
        sub_8_n91) );
  XNOR2_X1 sub_8_U89 ( .A(sub_8_n116), .B(sub_8_n117), .ZN(diff[2]) );
  NAND2_X1 sub_8_U88 ( .A1(sub_8_n118), .A2(sub_8_n119), .ZN(sub_8_n116) );
  XNOR2_X1 sub_8_U87 ( .A(sub_8_n1), .B(sub_8_n83), .ZN(diff[8]) );
  NAND2_X1 sub_8_U86 ( .A1(sub_8_n186), .A2(sub_8_n21), .ZN(sub_8_n216) );
  OAI211_X1 sub_8_U85 ( .C1(sub_8_n201), .C2(sub_8_n216), .A(sub_8_n217), .B(
        sub_8_n6), .ZN(sub_8_n213) );
  NAND2_X1 sub_8_U84 ( .A1(sub_8_n11), .A2(sub_8_n229), .ZN(sub_8_n201) );
  OAI21_X1 sub_8_U83 ( .B1(sub_8_n201), .B2(sub_8_n202), .A(sub_8_n203), .ZN(
        sub_8_n198) );
  OAI211_X1 sub_8_U82 ( .C1(sub_8_n206), .C2(sub_8_n207), .A(sub_8_n208), .B(
        sub_8_n209), .ZN(sub_8_n205) );
  NOR2_X1 sub_8_U81 ( .A1(sub_8_n204), .A2(sub_8_n205), .ZN(sub_8_n203) );
  NAND2_X1 sub_8_U80 ( .A1(sub_8_n87), .A2(sub_8_n5), .ZN(sub_8_n86) );
  XNOR2_X1 sub_8_U79 ( .A(sub_8_n85), .B(sub_8_n86), .ZN(diff[7]) );
  OAI21_X1 sub_8_U78 ( .B1(sub_8_n194), .B2(sub_8_n193), .A(sub_8_n11), .ZN(
        sub_8_n192) );
  NAND2_X1 sub_8_U77 ( .A1(sub_8_n191), .A2(sub_8_n192), .ZN(sub_8_n80) );
  NAND2_X1 sub_8_U76 ( .A1(sub_8_n97), .A2(sub_8_n96), .ZN(sub_8_n99) );
  OAI21_X1 sub_8_U75 ( .B1(sub_8_n89), .B2(sub_8_n99), .A(sub_8_n69), .ZN(
        sub_8_n98) );
  NOR2_X1 sub_8_U74 ( .A1(sub_8_n178), .A2(sub_8_n136), .ZN(sub_8_n177) );
  INV_X1 sub_8_U73 ( .A(a[2]), .ZN(sub_8_n49) );
  NAND2_X1 sub_8_U72 ( .A1(b[2]), .A2(sub_8_n49), .ZN(sub_8_n48) );
  INV_X1 sub_8_U71 ( .A(a[3]), .ZN(sub_8_n47) );
  AND2_X1 sub_8_U70 ( .A1(sub_8_n145), .A2(sub_8_n151), .ZN(sub_8_n46) );
  AOI22_X1 sub_8_U69 ( .A1(sub_8_n70), .A2(b[8]), .B1(sub_8_n10), .B2(b[9]), 
        .ZN(sub_8_n173) );
  INV_X1 sub_8_U68 ( .A(a[12]), .ZN(sub_8_n44) );
  INV_X1 sub_8_U67 ( .A(a[11]), .ZN(sub_8_n43) );
  INV_X1 sub_8_U66 ( .A(b[13]), .ZN(sub_8_n42) );
  INV_X1 sub_8_U65 ( .A(b[14]), .ZN(sub_8_n41) );
  OAI22_X1 sub_8_U64 ( .A1(sub_8_n41), .A2(a[14]), .B1(sub_8_n162), .B2(a[13]), 
        .ZN(sub_8_n135) );
  NAND2_X1 sub_8_U63 ( .A1(sub_8_n227), .A2(a[6]), .ZN(sub_8_n95) );
  AND2_X1 sub_8_U62 ( .A1(sub_8_n144), .A2(sub_8_n65), .ZN(sub_8_n143) );
  INV_X1 sub_8_U61 ( .A(a[5]), .ZN(sub_8_n40) );
  INV_X1 sub_8_U60 ( .A(a[4]), .ZN(sub_8_n39) );
  INV_X1 sub_8_U59 ( .A(a[6]), .ZN(sub_8_n38) );
  OAI211_X1 sub_8_U58 ( .C1(sub_8_n138), .C2(sub_8_n137), .A(sub_8_n140), .B(
        sub_8_n73), .ZN(sub_8_n128) );
  NAND4_X1 sub_8_U57 ( .A1(sub_8_n185), .A2(sub_8_n186), .A3(sub_8_n54), .A4(
        sub_8_n188), .ZN(sub_8_n184) );
  NAND2_X1 sub_8_U56 ( .A1(sub_8_n245), .A2(b[0]), .ZN(sub_8_n125) );
  INV_X1 sub_8_U55 ( .A(b[0]), .ZN(sub_8_n37) );
  INV_X1 sub_8_U54 ( .A(b[1]), .ZN(sub_8_n36) );
  OAI22_X1 sub_8_U53 ( .A1(sub_8_n4), .A2(a[1]), .B1(sub_8_n37), .B2(a[0]), 
        .ZN(sub_8_n235) );
  AOI22_X1 sub_8_U52 ( .A1(sub_8_n197), .A2(b[9]), .B1(sub_8_n70), .B2(b[8]), 
        .ZN(sub_8_n45) );
  NAND2_X1 sub_8_U51 ( .A1(sub_8_n246), .A2(a[0]), .ZN(sub_8_n124) );
  INV_X1 sub_8_U50 ( .A(b[1]), .ZN(sub_8_n35) );
  NOR2_X1 sub_8_U49 ( .A1(sub_8_n35), .A2(a[1]), .ZN(sub_8_n233) );
  AND2_X1 sub_8_U48 ( .A1(sub_8_n47), .A2(b[3]), .ZN(sub_8_n33) );
  NOR2_X1 sub_8_U47 ( .A1(sub_8_n33), .A2(sub_8_n34), .ZN(sub_8_n232) );
  NAND2_X1 sub_8_U46 ( .A1(sub_8_n239), .A2(b[3]), .ZN(sub_8_n32) );
  AOI21_X1 sub_8_U45 ( .B1(sub_8_n26), .B2(sub_8_n17), .A(sub_8_n23), .ZN(
        sub_8_n31) );
  CLKBUF_X1 sub_8_U44 ( .A(sub_8_n15), .Z(sub_8_n30) );
  AOI22_X1 sub_8_U43 ( .A1(sub_8_n43), .A2(b[11]), .B1(sub_8_n8), .B2(b[12]), 
        .ZN(sub_8_n172) );
  AOI22_X1 sub_8_U42 ( .A1(sub_8_n43), .A2(b[11]), .B1(sub_8_n44), .B2(b[12]), 
        .ZN(sub_8_n29) );
  OAI22_X1 sub_8_U41 ( .A1(sub_8_n41), .A2(a[14]), .B1(sub_8_n42), .B2(a[13]), 
        .ZN(sub_8_n27) );
  NAND2_X1 sub_8_U40 ( .A1(a[1]), .A2(sub_8_n36), .ZN(sub_8_n26) );
  AND2_X1 sub_8_U39 ( .A1(a[11]), .A2(sub_8_n175), .ZN(sub_8_n25) );
  INV_X1 sub_8_U38 ( .A(a[2]), .ZN(sub_8_n24) );
  NOR2_X1 sub_8_U37 ( .A1(sub_8_n3), .A2(a[1]), .ZN(sub_8_n23) );
  NAND2_X1 sub_8_U36 ( .A1(b[8]), .A2(sub_8_n196), .ZN(sub_8_n81) );
  NAND2_X1 sub_8_U35 ( .A1(b[8]), .A2(sub_8_n196), .ZN(sub_8_n21) );
  NAND2_X1 sub_8_U34 ( .A1(b[8]), .A2(sub_8_n196), .ZN(sub_8_n20) );
  BUF_X1 sub_8_U33 ( .A(sub_8_n150), .Z(sub_8_n28) );
  OR2_X1 sub_8_U32 ( .A1(sub_8_n234), .A2(sub_8_n235), .ZN(sub_8_n75) );
  OR2_X1 sub_8_U31 ( .A1(sub_8_n234), .A2(sub_8_n235), .ZN(sub_8_n19) );
  AND2_X2 sub_8_U30 ( .A1(a[10]), .A2(sub_8_n171), .ZN(sub_8_n18) );
  NAND2_X1 sub_8_U29 ( .A1(sub_8_n246), .A2(a[0]), .ZN(sub_8_n17) );
  OAI222_X1 sub_8_U28 ( .A1(sub_8_n38), .A2(b[6]), .B1(sub_8_n39), .B2(b[4]), 
        .C1(sub_8_n40), .C2(b[5]), .ZN(sub_8_n153) );
  CLKBUF_X1 sub_8_U27 ( .A(sub_8_n115), .Z(sub_8_n16) );
  NAND2_X1 sub_8_U26 ( .A1(a[8]), .A2(sub_8_n223), .ZN(sub_8_n15) );
  INV_X1 sub_8_U25 ( .A(b[5]), .ZN(sub_8_n14) );
  INV_X1 sub_8_U24 ( .A(a[3]), .ZN(sub_8_n13) );
  AND2_X1 sub_8_U23 ( .A1(sub_8_n93), .A2(sub_8_n95), .ZN(sub_8_n12) );
  XOR2_X1 sub_8_U22 ( .A(sub_8_n98), .B(sub_8_n12), .Z(diff[6]) );
  AND4_X1 sub_8_U21 ( .A1(sub_8_n241), .A2(sub_8_n242), .A3(sub_8_n243), .A4(
        sub_8_n87), .ZN(sub_8_n11) );
  INV_X1 sub_8_U20 ( .A(sub_8_n18), .ZN(sub_8_n210) );
  NAND2_X1 sub_8_U19 ( .A1(a[3]), .A2(sub_8_n230), .ZN(sub_8_n110) );
  OAI222_X1 sub_8_U18 ( .A1(sub_8_n38), .A2(b[6]), .B1(sub_8_n39), .B2(b[4]), 
        .C1(sub_8_n40), .C2(b[5]), .ZN(sub_8_n22) );
  INV_X1 sub_8_U17 ( .A(a[9]), .ZN(sub_8_n10) );
  INV_X1 sub_8_U16 ( .A(sub_8_n242), .ZN(sub_8_n9) );
  INV_X1 sub_8_U15 ( .A(a[12]), .ZN(sub_8_n8) );
  NOR2_X1 sub_8_U14 ( .A1(sub_8_n33), .A2(sub_8_n2), .ZN(sub_8_n7) );
  NAND2_X2 sub_8_U13 ( .A1(b[9]), .A2(sub_8_n61), .ZN(sub_8_n186) );
  INV_X1 sub_8_U12 ( .A(sub_8_n78), .ZN(sub_8_n6) );
  CLKBUF_X1 sub_8_U11 ( .A(sub_8_n88), .Z(sub_8_n5) );
  INV_X1 sub_8_U10 ( .A(b[1]), .ZN(sub_8_n4) );
  INV_X1 sub_8_U9 ( .A(b[1]), .ZN(sub_8_n3) );
  AND2_X1 sub_8_U8 ( .A1(sub_8_n24), .A2(b[2]), .ZN(sub_8_n34) );
  AND2_X1 sub_8_U7 ( .A1(sub_8_n24), .A2(b[2]), .ZN(sub_8_n2) );
  NAND2_X2 sub_8_U6 ( .A1(sub_8_n200), .A2(b[11]), .ZN(sub_8_n188) );
  NAND2_X1 sub_8_U5 ( .A1(sub_8_n191), .A2(sub_8_n192), .ZN(sub_8_n1) );
  NAND3_X1 sub_8_U4 ( .A1(sub_8_n64), .A2(sub_8_n66), .A3(1'b1), .ZN(
        sub_8_n234) );
  INV_X2 sub_8_U3 ( .A(sub_8_n125), .ZN(sub_8_n123) );
endmodule

