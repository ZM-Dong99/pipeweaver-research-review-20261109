/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:32:42 2025
/////////////////////////////////////////////////////////////


module add_sub_gpt ( a, b, control, result );
  input [15:0] a;
  input [15:0] b;
  output [15:0] result;
  input control;
  wire   N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16, N17,
         N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30, N31,
         N32, N33, N34, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50,
         n51, n52, add_8_n192, add_8_n191, add_8_n190, add_8_n189, add_8_n188,
         add_8_n187, add_8_n186, add_8_n185, add_8_n184, add_8_n183,
         add_8_n182, add_8_n181, add_8_n180, add_8_n179, add_8_n178,
         add_8_n177, add_8_n176, add_8_n175, add_8_n174, add_8_n173,
         add_8_n172, add_8_n171, add_8_n170, add_8_n169, add_8_n168,
         add_8_n167, add_8_n166, add_8_n165, add_8_n164, add_8_n163,
         add_8_n162, add_8_n161, add_8_n160, add_8_n159, add_8_n158,
         add_8_n157, add_8_n156, add_8_n155, add_8_n154, add_8_n153,
         add_8_n152, add_8_n151, add_8_n150, add_8_n149, add_8_n148,
         add_8_n147, add_8_n146, add_8_n145, add_8_n144, add_8_n143,
         add_8_n142, add_8_n141, add_8_n140, add_8_n139, add_8_n138,
         add_8_n137, add_8_n136, add_8_n135, add_8_n134, add_8_n133,
         add_8_n132, add_8_n131, add_8_n130, add_8_n129, add_8_n128,
         add_8_n127, add_8_n126, add_8_n125, add_8_n124, add_8_n123,
         add_8_n122, add_8_n121, add_8_n120, add_8_n119, add_8_n118,
         add_8_n117, add_8_n116, add_8_n115, add_8_n114, add_8_n113,
         add_8_n112, add_8_n111, add_8_n110, add_8_n109, add_8_n108,
         add_8_n107, add_8_n106, add_8_n105, add_8_n104, add_8_n103,
         add_8_n102, add_8_n101, add_8_n100, add_8_n99, add_8_n98, add_8_n97,
         add_8_n96, add_8_n95, add_8_n94, add_8_n93, add_8_n92, add_8_n91,
         add_8_n90, add_8_n89, add_8_n88, add_8_n87, add_8_n86, add_8_n85,
         add_8_n84, add_8_n83, add_8_n82, add_8_n81, add_8_n80, add_8_n79,
         add_8_n78, add_8_n77, add_8_n76, add_8_n75, add_8_n74, add_8_n73,
         add_8_n72, add_8_n71, add_8_n70, add_8_n69, add_8_n68, add_8_n67,
         add_8_n66, add_8_n65, add_8_n64, add_8_n63, add_8_n62, add_8_n61,
         add_8_n60, add_8_n59, add_8_n58, add_8_n57, add_8_n56, add_8_n55,
         add_8_n54, add_8_n53, add_8_n52, add_8_n51, add_8_n50, add_8_n49,
         add_8_n48, add_8_n47, add_8_n46, add_8_n45, add_8_n44, add_8_n43,
         add_8_n42, add_8_n41, add_8_n40, add_8_n39, add_8_n38, add_8_n37,
         add_8_n36, add_8_n35, add_8_n34, add_8_n33, add_8_n32, add_8_n31,
         add_8_n30, add_8_n29, add_8_n28, add_8_n27, add_8_n26, add_8_n25,
         add_8_n24, add_8_n23, add_8_n22, add_8_n21, add_8_n20, add_8_n18,
         add_8_n17, add_8_n16, add_8_n15, add_8_n14, add_8_n13, add_8_n12,
         add_8_n11, add_8_n10, add_8_n9, add_8_n8, add_8_n7, add_8_n6,
         add_8_n5, add_8_n4, add_8_n3, add_8_n2, add_8_n1, sub_8_n243,
         sub_8_n242, sub_8_n241, sub_8_n240, sub_8_n239, sub_8_n238,
         sub_8_n237, sub_8_n236, sub_8_n235, sub_8_n234, sub_8_n233,
         sub_8_n232, sub_8_n231, sub_8_n230, sub_8_n229, sub_8_n228,
         sub_8_n227, sub_8_n226, sub_8_n225, sub_8_n224, sub_8_n223,
         sub_8_n222, sub_8_n221, sub_8_n220, sub_8_n219, sub_8_n218,
         sub_8_n217, sub_8_n216, sub_8_n215, sub_8_n214, sub_8_n213,
         sub_8_n212, sub_8_n211, sub_8_n210, sub_8_n209, sub_8_n208,
         sub_8_n207, sub_8_n206, sub_8_n205, sub_8_n204, sub_8_n203,
         sub_8_n202, sub_8_n201, sub_8_n200, sub_8_n199, sub_8_n198,
         sub_8_n197, sub_8_n196, sub_8_n195, sub_8_n194, sub_8_n193,
         sub_8_n192, sub_8_n191, sub_8_n190, sub_8_n189, sub_8_n188,
         sub_8_n187, sub_8_n186, sub_8_n185, sub_8_n184, sub_8_n183,
         sub_8_n182, sub_8_n181, sub_8_n180, sub_8_n179, sub_8_n178,
         sub_8_n177, sub_8_n176, sub_8_n175, sub_8_n174, sub_8_n173,
         sub_8_n172, sub_8_n171, sub_8_n170, sub_8_n169, sub_8_n168,
         sub_8_n167, sub_8_n166, sub_8_n165, sub_8_n164, sub_8_n163,
         sub_8_n162, sub_8_n161, sub_8_n160, sub_8_n159, sub_8_n158,
         sub_8_n157, sub_8_n156, sub_8_n155, sub_8_n154, sub_8_n153,
         sub_8_n152, sub_8_n151, sub_8_n150, sub_8_n149, sub_8_n148,
         sub_8_n147, sub_8_n146, sub_8_n145, sub_8_n144, sub_8_n143,
         sub_8_n142, sub_8_n141, sub_8_n140, sub_8_n139, sub_8_n138,
         sub_8_n137, sub_8_n136, sub_8_n135, sub_8_n134, sub_8_n133,
         sub_8_n132, sub_8_n131, sub_8_n130, sub_8_n129, sub_8_n128,
         sub_8_n127, sub_8_n126, sub_8_n125, sub_8_n124, sub_8_n123,
         sub_8_n122, sub_8_n121, sub_8_n120, sub_8_n119, sub_8_n118,
         sub_8_n117, sub_8_n116, sub_8_n115, sub_8_n114, sub_8_n113,
         sub_8_n112, sub_8_n111, sub_8_n110, sub_8_n109, sub_8_n108,
         sub_8_n107, sub_8_n106, sub_8_n105, sub_8_n104, sub_8_n103,
         sub_8_n102, sub_8_n101, sub_8_n100, sub_8_n99, sub_8_n98, sub_8_n97,
         sub_8_n96, sub_8_n95, sub_8_n94, sub_8_n93, sub_8_n92, sub_8_n91,
         sub_8_n90, sub_8_n89, sub_8_n88, sub_8_n87, sub_8_n86, sub_8_n85,
         sub_8_n84, sub_8_n83, sub_8_n82, sub_8_n81, sub_8_n80, sub_8_n79,
         sub_8_n78, sub_8_n77, sub_8_n76, sub_8_n75, sub_8_n74, sub_8_n73,
         sub_8_n72, sub_8_n71, sub_8_n70, sub_8_n69, sub_8_n68, sub_8_n67,
         sub_8_n66, sub_8_n65, sub_8_n64, sub_8_n63, sub_8_n62, sub_8_n61,
         sub_8_n60, sub_8_n59, sub_8_n58, sub_8_n57, sub_8_n56, sub_8_n55,
         sub_8_n54, sub_8_n53, sub_8_n52, sub_8_n51, sub_8_n50, sub_8_n49,
         sub_8_n48, sub_8_n47, sub_8_n46, sub_8_n45, sub_8_n44, sub_8_n43,
         sub_8_n42, sub_8_n41, sub_8_n40, sub_8_n39, sub_8_n38, sub_8_n37,
         sub_8_n36, sub_8_n35, sub_8_n34, sub_8_n33, sub_8_n32, sub_8_n31,
         sub_8_n30, sub_8_n29, sub_8_n28, sub_8_n27, sub_8_n26, sub_8_n25,
         sub_8_n24, sub_8_n23, sub_8_n22, sub_8_n21, sub_8_n20, sub_8_n19,
         sub_8_n18, sub_8_n17, sub_8_n16, sub_8_n15, sub_8_n14, sub_8_n13,
         sub_8_n12, sub_8_n11, sub_8_n10, sub_8_n9, sub_8_n8, sub_8_n7,
         sub_8_n6, sub_8_n4, sub_8_n3, sub_8_n2, sub_8_n1;

  MUX2_X1 U38 ( .A(N28), .B(N12), .S(control), .Z(result[9]) );
  NAND2_X1 U39 ( .A1(N15), .A2(control), .ZN(n40) );
  NAND2_X1 U40 ( .A1(N31), .A2(n51), .ZN(n41) );
  NAND2_X1 U41 ( .A1(n40), .A2(n41), .ZN(result[12]) );
  NAND2_X1 U42 ( .A1(N33), .A2(n42), .ZN(n43) );
  NAND2_X1 U43 ( .A1(N17), .A2(control), .ZN(n44) );
  NAND2_X1 U44 ( .A1(n43), .A2(n44), .ZN(result[14]) );
  INV_X1 U45 ( .A(control), .ZN(n42) );
  NAND2_X1 U46 ( .A1(N32), .A2(n42), .ZN(n45) );
  NAND2_X1 U47 ( .A1(N16), .A2(control), .ZN(n46) );
  NAND2_X1 U48 ( .A1(n45), .A2(n46), .ZN(result[13]) );
  NAND2_X1 U49 ( .A1(N34), .A2(n42), .ZN(n47) );
  NAND2_X1 U50 ( .A1(N18), .A2(control), .ZN(n48) );
  NAND2_X1 U51 ( .A1(n48), .A2(n47), .ZN(result[15]) );
  MUX2_X1 U52 ( .A(N19), .B(N3), .S(control), .Z(result[0]) );
  MUX2_X1 U53 ( .A(N20), .B(N4), .S(control), .Z(result[1]) );
  MUX2_X1 U54 ( .A(N21), .B(N5), .S(control), .Z(result[2]) );
  MUX2_X1 U55 ( .A(N22), .B(N6), .S(control), .Z(result[3]) );
  MUX2_X1 U56 ( .A(N23), .B(N7), .S(control), .Z(result[4]) );
  MUX2_X1 U57 ( .A(N24), .B(N8), .S(control), .Z(result[5]) );
  INV_X1 U58 ( .A(control), .ZN(n51) );
  AOI22_X1 U59 ( .A1(N9), .A2(control), .B1(N25), .B2(n51), .ZN(n49) );
  INV_X1 U60 ( .A(n49), .ZN(result[6]) );
  AOI22_X1 U61 ( .A1(N10), .A2(control), .B1(N26), .B2(n51), .ZN(n50) );
  INV_X1 U62 ( .A(n50), .ZN(result[7]) );
  MUX2_X1 U63 ( .A(N27), .B(N11), .S(control), .Z(result[8]) );
  MUX2_X1 U64 ( .A(N29), .B(N13), .S(control), .Z(result[10]) );
  AOI22_X1 U65 ( .A1(N30), .A2(n51), .B1(N14), .B2(control), .ZN(n52) );
  INV_X1 U66 ( .A(n52), .ZN(result[11]) );
  INV_X1 add_8_U208 ( .A(add_8_n63), .ZN(add_8_n187) );
  NAND2_X1 add_8_U207 ( .A1(a[4]), .A2(b[4]), .ZN(add_8_n184) );
  INV_X1 add_8_U206 ( .A(add_8_n182), .ZN(add_8_n127) );
  INV_X1 add_8_U205 ( .A(add_8_n140), .ZN(add_8_n147) );
  INV_X1 add_8_U204 ( .A(add_8_n24), .ZN(add_8_n162) );
  INV_X1 add_8_U203 ( .A(add_8_n27), .ZN(add_8_n163) );
  NAND3_X1 add_8_U202 ( .A1(add_8_n140), .A2(add_8_n24), .A3(add_8_n10), .ZN(
        add_8_n159) );
  NAND2_X1 add_8_U201 ( .A1(add_8_n159), .A2(add_8_n160), .ZN(add_8_n158) );
  INV_X1 add_8_U200 ( .A(add_8_n134), .ZN(add_8_n139) );
  INV_X1 add_8_U199 ( .A(add_8_n138), .ZN(add_8_n156) );
  NAND3_X1 add_8_U198 ( .A1(a[8]), .A2(b[8]), .A3(add_8_n24), .ZN(add_8_n135)
         );
  INV_X1 add_8_U197 ( .A(add_8_n110), .ZN(add_8_n126) );
  INV_X1 add_8_U196 ( .A(add_8_n13), .ZN(add_8_n89) );
  NAND2_X1 add_8_U195 ( .A1(b[1]), .A2(a[1]), .ZN(add_8_n124) );
  NAND2_X1 add_8_U194 ( .A1(add_8_n89), .A2(add_8_n123), .ZN(add_8_n122) );
  NAND2_X1 add_8_U193 ( .A1(add_8_n121), .A2(add_8_n115), .ZN(add_8_n120) );
  NAND2_X1 add_8_U192 ( .A1(add_8_n119), .A2(add_8_n120), .ZN(add_8_n117) );
  XNOR2_X1 add_8_U191 ( .A(add_8_n117), .B(add_8_n118), .ZN(N16) );
  INV_X1 add_8_U190 ( .A(add_8_n103), .ZN(add_8_n109) );
  NAND2_X1 add_8_U189 ( .A1(add_8_n116), .A2(add_8_n18), .ZN(add_8_n111) );
  INV_X1 add_8_U188 ( .A(add_8_n114), .ZN(add_8_n97) );
  INV_X1 add_8_U187 ( .A(add_8_n81), .ZN(add_8_n113) );
  INV_X1 add_8_U186 ( .A(add_8_n82), .ZN(add_8_n106) );
  INV_X1 add_8_U185 ( .A(add_8_n102), .ZN(add_8_n80) );
  NAND2_X1 add_8_U184 ( .A1(add_8_n99), .A2(add_8_n100), .ZN(add_8_n95) );
  INV_X1 add_8_U183 ( .A(add_8_n98), .ZN(add_8_n86) );
  NAND2_X1 add_8_U182 ( .A1(add_8_n95), .A2(add_8_n96), .ZN(add_8_n94) );
  NAND2_X1 add_8_U181 ( .A1(b[1]), .A2(a[1]), .ZN(add_8_n91) );
  NAND2_X1 add_8_U180 ( .A1(add_8_n89), .A2(add_8_n90), .ZN(add_8_n88) );
  INV_X1 add_8_U179 ( .A(add_8_n87), .ZN(add_8_n85) );
  NAND2_X1 add_8_U178 ( .A1(add_8_n76), .A2(add_8_n77), .ZN(add_8_n74) );
  XNOR2_X1 add_8_U177 ( .A(add_8_n74), .B(add_8_n75), .ZN(N18) );
  INV_X1 add_8_U176 ( .A(add_8_n65), .ZN(add_8_n61) );
  INV_X1 add_8_U175 ( .A(add_8_n64), .ZN(add_8_n62) );
  OAI21_X1 add_8_U174 ( .B1(add_8_n61), .B2(add_8_n62), .A(add_8_n63), .ZN(
        add_8_n58) );
  XNOR2_X1 add_8_U173 ( .A(add_8_n58), .B(add_8_n59), .ZN(N6) );
  XNOR2_X1 add_8_U172 ( .A(add_8_n56), .B(add_8_n57), .ZN(N7) );
  INV_X1 add_8_U171 ( .A(add_8_n56), .ZN(add_8_n54) );
  INV_X1 add_8_U170 ( .A(add_8_n55), .ZN(add_8_n43) );
  NAND2_X1 add_8_U169 ( .A1(b[1]), .A2(a[1]), .ZN(add_8_n50) );
  INV_X1 add_8_U168 ( .A(add_8_n44), .ZN(add_8_n42) );
  NOR2_X1 add_8_U167 ( .A1(add_8_n42), .A2(add_8_n43), .ZN(add_8_n41) );
  NAND2_X1 add_8_U166 ( .A1(add_8_n36), .A2(add_8_n5), .ZN(add_8_n38) );
  XNOR2_X1 add_8_U165 ( .A(add_8_n38), .B(add_8_n39), .ZN(N9) );
  NAND2_X1 add_8_U164 ( .A1(add_8_n187), .A2(add_8_n60), .ZN(add_8_n45) );
  INV_X1 add_8_U163 ( .A(add_8_n14), .ZN(add_8_n185) );
  NAND2_X1 add_8_U162 ( .A1(add_8_n11), .A2(add_8_n129), .ZN(add_8_n143) );
  AOI21_X1 add_8_U161 ( .B1(add_8_n11), .B2(add_8_n157), .A(add_8_n158), .ZN(
        add_8_n154) );
  NAND2_X1 add_8_U160 ( .A1(add_8_n14), .A2(add_8_n49), .ZN(add_8_n59) );
  XNOR2_X1 add_8_U159 ( .A(add_8_n16), .B(add_8_n28), .ZN(N11) );
  NOR2_X1 add_8_U158 ( .A1(add_8_n167), .A2(add_8_n6), .ZN(add_8_n166) );
  NOR2_X1 add_8_U157 ( .A1(a[2]), .A2(b[2]), .ZN(add_8_n173) );
  AOI21_X1 add_8_U156 ( .B1(add_8_n166), .B2(add_8_n49), .A(add_8_n87), .ZN(
        add_8_n164) );
  NAND2_X1 add_8_U155 ( .A1(add_8_n188), .A2(add_8_n189), .ZN(add_8_n60) );
  INV_X1 add_8_U154 ( .A(a[3]), .ZN(add_8_n189) );
  INV_X1 add_8_U153 ( .A(b[3]), .ZN(add_8_n188) );
  OAI211_X1 add_8_U152 ( .C1(add_8_n183), .C2(add_8_n184), .A(add_8_n33), .B(
        add_8_n37), .ZN(add_8_n182) );
  INV_X1 add_8_U151 ( .A(add_8_n165), .ZN(add_8_n181) );
  NAND2_X1 add_8_U150 ( .A1(add_8_n5), .A2(add_8_n44), .ZN(add_8_n53) );
  OAI21_X1 add_8_U149 ( .B1(add_8_n176), .B2(add_8_n177), .A(add_8_n25), .ZN(
        add_8_n174) );
  NAND2_X1 add_8_U148 ( .A1(add_8_n12), .A2(add_8_n169), .ZN(add_8_n46) );
  NAND2_X1 add_8_U147 ( .A1(add_8_n170), .A2(add_8_n171), .ZN(add_8_n169) );
  XNOR2_X1 add_8_U146 ( .A(add_8_n22), .B(add_8_n23), .ZN(N12) );
  XNOR2_X1 add_8_U145 ( .A(add_8_n141), .B(add_8_n142), .ZN(N15) );
  NOR2_X1 add_8_U144 ( .A1(add_8_n150), .A2(add_8_n151), .ZN(add_8_n149) );
  NOR2_X1 add_8_U143 ( .A1(add_8_n84), .A2(add_8_n98), .ZN(add_8_n99) );
  NOR2_X1 add_8_U142 ( .A1(add_8_n83), .A2(add_8_n2), .ZN(add_8_n78) );
  NOR2_X1 add_8_U141 ( .A1(add_8_n2), .A2(add_8_n87), .ZN(add_8_n121) );
  NOR2_X1 add_8_U140 ( .A1(add_8_n107), .A2(add_8_n108), .ZN(add_8_n104) );
  XNOR2_X1 add_8_U139 ( .A(add_8_n154), .B(add_8_n155), .ZN(N14) );
  NAND2_X1 add_8_U138 ( .A1(add_8_n143), .A2(add_8_n144), .ZN(add_8_n141) );
  NAND4_X1 add_8_U137 ( .A1(add_8_n135), .A2(add_8_n133), .A3(add_8_n134), 
        .A4(add_8_n25), .ZN(add_8_n132) );
  NAND2_X1 add_8_U136 ( .A1(add_8_n24), .A2(add_8_n27), .ZN(add_8_n177) );
  NAND2_X1 add_8_U135 ( .A1(add_8_n24), .A2(add_8_n25), .ZN(add_8_n23) );
  NOR2_X1 add_8_U134 ( .A1(add_8_n185), .A2(add_8_n87), .ZN(add_8_n179) );
  NOR2_X1 add_8_U133 ( .A1(add_8_n87), .A2(add_8_n109), .ZN(add_8_n116) );
  NOR2_X1 add_8_U132 ( .A1(b[3]), .A2(a[3]), .ZN(add_8_n172) );
  AND2_X1 add_8_U131 ( .A1(add_8_n48), .A2(add_8_n49), .ZN(add_8_n47) );
  NAND2_X1 add_8_U130 ( .A1(b[3]), .A2(a[3]), .ZN(add_8_n49) );
  OAI22_X1 add_8_U129 ( .A1(add_8_n109), .A2(add_8_n110), .B1(add_8_n109), 
        .B2(add_8_n101), .ZN(add_8_n108) );
  XNOR2_X1 add_8_U128 ( .A(add_8_n174), .B(add_8_n175), .ZN(N13) );
  NAND2_X1 add_8_U127 ( .A1(add_8_n35), .A2(add_8_n32), .ZN(add_8_n128) );
  NAND2_X1 add_8_U126 ( .A1(add_8_n35), .A2(add_8_n1), .ZN(add_8_n39) );
  NAND2_X1 add_8_U125 ( .A1(add_8_n35), .A2(add_8_n38), .ZN(add_8_n34) );
  NAND2_X1 add_8_U124 ( .A1(b[6]), .A2(a[6]), .ZN(add_8_n33) );
  NAND3_X1 add_8_U123 ( .A1(add_8_n45), .A2(add_8_n49), .A3(add_8_n88), .ZN(
        add_8_n56) );
  NAND3_X1 add_8_U122 ( .A1(add_8_n186), .A2(add_8_n45), .A3(add_8_n49), .ZN(
        add_8_n178) );
  NAND3_X1 add_8_U121 ( .A1(add_8_n45), .A2(add_8_n49), .A3(add_8_n122), .ZN(
        add_8_n115) );
  OR2_X1 add_8_U120 ( .A1(b[0]), .A2(a[0]), .ZN(add_8_n73) );
  NAND2_X1 add_8_U119 ( .A1(b[1]), .A2(a[1]), .ZN(add_8_n68) );
  NAND2_X1 add_8_U118 ( .A1(add_8_n69), .A2(add_8_n68), .ZN(add_8_n71) );
  XNOR2_X1 add_8_U117 ( .A(add_8_n70), .B(add_8_n71), .ZN(N4) );
  NAND2_X1 add_8_U116 ( .A1(b[14]), .A2(a[14]), .ZN(add_8_n82) );
  NAND2_X1 add_8_U115 ( .A1(b[8]), .A2(a[8]), .ZN(add_8_n26) );
  NAND2_X1 add_8_U114 ( .A1(b[13]), .A2(a[13]), .ZN(add_8_n81) );
  NAND2_X1 add_8_U113 ( .A1(add_8_n64), .A2(add_8_n63), .ZN(add_8_n66) );
  XNOR2_X1 add_8_U112 ( .A(add_8_n65), .B(add_8_n66), .ZN(N5) );
  NAND2_X1 add_8_U111 ( .A1(b[12]), .A2(a[12]), .ZN(add_8_n114) );
  NAND2_X1 add_8_U110 ( .A1(b[0]), .A2(a[0]), .ZN(add_8_n72) );
  NAND2_X1 add_8_U109 ( .A1(b[7]), .A2(a[7]), .ZN(add_8_n31) );
  NAND2_X1 add_8_U108 ( .A1(add_8_n55), .A2(add_8_n48), .ZN(add_8_n57) );
  NAND2_X1 add_8_U107 ( .A1(b[9]), .A2(a[9]), .ZN(add_8_n25) );
  NAND2_X1 add_8_U106 ( .A1(b[10]), .A2(a[10]), .ZN(add_8_n133) );
  NAND2_X1 add_8_U105 ( .A1(b[1]), .A2(a[1]), .ZN(add_8_n192) );
  AND2_X1 add_8_U104 ( .A1(add_8_n69), .A2(add_8_n64), .ZN(add_8_n191) );
  NAND2_X1 add_8_U103 ( .A1(add_8_n192), .A2(add_8_n92), .ZN(add_8_n190) );
  NAND2_X1 add_8_U102 ( .A1(add_8_n190), .A2(add_8_n191), .ZN(add_8_n186) );
  NAND2_X1 add_8_U101 ( .A1(b[0]), .A2(a[0]), .ZN(add_8_n92) );
  NAND2_X1 add_8_U100 ( .A1(add_8_n26), .A2(add_8_n27), .ZN(add_8_n28) );
  OR2_X1 add_8_U99 ( .A1(b[14]), .A2(a[14]), .ZN(add_8_n102) );
  NAND2_X1 add_8_U98 ( .A1(b[4]), .A2(a[4]), .ZN(add_8_n48) );
  NAND2_X1 add_8_U97 ( .A1(add_8_n91), .A2(add_8_n92), .ZN(add_8_n90) );
  NAND2_X1 add_8_U96 ( .A1(b[11]), .A2(a[11]), .ZN(add_8_n134) );
  OR2_X2 add_8_U95 ( .A1(b[13]), .A2(a[13]), .ZN(add_8_n103) );
  AND2_X1 add_8_U94 ( .A1(add_8_n50), .A2(add_8_n51), .ZN(add_8_n21) );
  NAND2_X1 add_8_U93 ( .A1(b[0]), .A2(a[0]), .ZN(add_8_n51) );
  NAND2_X1 add_8_U92 ( .A1(add_8_n124), .A2(add_8_n92), .ZN(add_8_n123) );
  OR2_X2 add_8_U91 ( .A1(b[10]), .A2(a[10]), .ZN(add_8_n140) );
  XNOR2_X1 add_8_U90 ( .A(add_8_n52), .B(add_8_n53), .ZN(N8) );
  NAND2_X1 add_8_U89 ( .A1(b[5]), .A2(a[5]), .ZN(add_8_n37) );
  NOR2_X1 add_8_U88 ( .A1(b[5]), .A2(a[5]), .ZN(add_8_n183) );
  OR2_X2 add_8_U87 ( .A1(b[6]), .A2(a[6]), .ZN(add_8_n35) );
  NAND2_X1 add_8_U86 ( .A1(b[2]), .A2(a[2]), .ZN(add_8_n63) );
  XNOR2_X1 add_8_U85 ( .A(add_8_n104), .B(add_8_n105), .ZN(N17) );
  NOR2_X1 add_8_U84 ( .A1(a[8]), .A2(b[8]), .ZN(add_8_n151) );
  OR2_X2 add_8_U83 ( .A1(b[7]), .A2(a[7]), .ZN(add_8_n32) );
  OR2_X2 add_8_U82 ( .A1(b[9]), .A2(a[9]), .ZN(add_8_n24) );
  NOR2_X1 add_8_U81 ( .A1(a[9]), .A2(b[9]), .ZN(add_8_n152) );
  INV_X1 add_8_U80 ( .A(b[1]), .ZN(add_8_n170) );
  NOR2_X1 add_8_U79 ( .A1(a[10]), .A2(b[10]), .ZN(add_8_n150) );
  NOR2_X1 add_8_U78 ( .A1(add_8_n152), .A2(add_8_n153), .ZN(add_8_n148) );
  NOR2_X1 add_8_U77 ( .A1(a[11]), .A2(b[11]), .ZN(add_8_n153) );
  XNOR2_X1 add_8_U76 ( .A(b[15]), .B(a[15]), .ZN(add_8_n75) );
  XNOR2_X1 add_8_U75 ( .A(add_8_n29), .B(add_8_n30), .ZN(N10) );
  INV_X1 add_8_U74 ( .A(a[1]), .ZN(add_8_n171) );
  NAND2_X1 add_8_U73 ( .A1(b[1]), .A2(a[1]), .ZN(add_8_n168) );
  NAND2_X1 add_8_U72 ( .A1(add_8_n114), .A2(add_8_n130), .ZN(add_8_n142) );
  NAND2_X1 add_8_U71 ( .A1(add_8_n81), .A2(add_8_n103), .ZN(add_8_n118) );
  NAND2_X1 add_8_U70 ( .A1(add_8_n140), .A2(add_8_n133), .ZN(add_8_n175) );
  NAND2_X1 add_8_U69 ( .A1(add_8_n31), .A2(add_8_n32), .ZN(add_8_n30) );
  NOR2_X1 add_8_U68 ( .A1(add_8_n139), .A2(add_8_n156), .ZN(add_8_n155) );
  NOR2_X1 add_8_U67 ( .A1(add_8_n106), .A2(add_8_n80), .ZN(add_8_n105) );
  NAND2_X1 add_8_U66 ( .A1(add_8_n25), .A2(add_8_n133), .ZN(add_8_n161) );
  NAND2_X1 add_8_U65 ( .A1(add_8_n161), .A2(add_8_n140), .ZN(add_8_n160) );
  INV_X1 add_8_U64 ( .A(add_8_n72), .ZN(add_8_n70) );
  NAND2_X1 add_8_U63 ( .A1(add_8_n69), .A2(add_8_n70), .ZN(add_8_n67) );
  NAND2_X1 add_8_U62 ( .A1(add_8_n67), .A2(add_8_n68), .ZN(add_8_n65) );
  NAND2_X1 add_8_U61 ( .A1(add_8_n170), .A2(add_8_n171), .ZN(add_8_n69) );
  AND2_X1 add_8_U60 ( .A1(add_8_n25), .A2(add_8_n133), .ZN(add_8_n20) );
  AND2_X1 add_8_U59 ( .A1(add_8_n135), .A2(add_8_n20), .ZN(add_8_n146) );
  OAI21_X1 add_8_U58 ( .B1(add_8_n54), .B2(add_8_n43), .A(add_8_n48), .ZN(
        add_8_n52) );
  NAND2_X1 add_8_U57 ( .A1(add_8_n102), .A2(add_8_n103), .ZN(add_8_n98) );
  NAND2_X1 add_8_U56 ( .A1(add_8_n3), .A2(add_8_n34), .ZN(add_8_n29) );
  OAI21_X1 add_8_U55 ( .B1(add_8_n21), .B2(add_8_n13), .A(add_8_n47), .ZN(
        add_8_n40) );
  OAI21_X1 add_8_U54 ( .B1(add_8_n40), .B2(add_8_n6), .A(add_8_n41), .ZN(
        add_8_n36) );
  OAI21_X1 add_8_U53 ( .B1(add_8_n127), .B2(add_8_n128), .A(add_8_n31), .ZN(
        add_8_n100) );
  NOR2_X1 add_8_U52 ( .A1(add_8_n139), .A2(add_8_n140), .ZN(add_8_n136) );
  NAND2_X1 add_8_U51 ( .A1(add_8_n181), .A2(add_8_n26), .ZN(add_8_n180) );
  OAI21_X1 add_8_U50 ( .B1(add_8_n127), .B2(add_8_n128), .A(add_8_n31), .ZN(
        add_8_n165) );
  AOI21_X1 add_8_U49 ( .B1(add_8_n178), .B2(add_8_n179), .A(add_8_n180), .ZN(
        add_8_n176) );
  AOI21_X1 add_8_U48 ( .B1(add_8_n97), .B2(add_8_n103), .A(add_8_n113), .ZN(
        add_8_n112) );
  OAI21_X1 add_8_U47 ( .B1(add_8_n111), .B2(add_8_n4), .A(add_8_n112), .ZN(
        add_8_n107) );
  OAI21_X1 add_8_U46 ( .B1(add_8_n80), .B2(add_8_n81), .A(add_8_n82), .ZN(
        add_8_n79) );
  NOR2_X1 add_8_U45 ( .A1(add_8_n93), .A2(add_8_n94), .ZN(add_8_n76) );
  AOI21_X1 add_8_U44 ( .B1(add_8_n56), .B2(add_8_n78), .A(add_8_n79), .ZN(
        add_8_n77) );
  OAI21_X1 add_8_U43 ( .B1(add_8_n146), .B2(add_8_n147), .A(add_8_n134), .ZN(
        add_8_n145) );
  NAND2_X1 add_8_U42 ( .A1(add_8_n145), .A2(add_8_n138), .ZN(add_8_n144) );
  NAND2_X1 add_8_U41 ( .A1(add_8_n101), .A2(add_8_n114), .ZN(add_8_n125) );
  NAND2_X1 add_8_U40 ( .A1(add_8_n130), .A2(add_8_n138), .ZN(add_8_n137) );
  NOR2_X1 add_8_U39 ( .A1(add_8_n136), .A2(add_8_n137), .ZN(add_8_n131) );
  NAND2_X1 add_8_U38 ( .A1(add_8_n132), .A2(add_8_n131), .ZN(add_8_n101) );
  NOR2_X1 add_8_U37 ( .A1(add_8_n125), .A2(add_8_n126), .ZN(add_8_n119) );
  NAND2_X1 add_8_U36 ( .A1(add_8_n129), .A2(add_8_n130), .ZN(add_8_n84) );
  NOR3_X1 add_8_U35 ( .A1(add_8_n147), .A2(add_8_n162), .A3(add_8_n163), .ZN(
        add_8_n157) );
  NAND2_X1 add_8_U34 ( .A1(add_8_n85), .A2(add_8_n86), .ZN(add_8_n83) );
  NAND2_X1 add_8_U33 ( .A1(add_8_n97), .A2(add_8_n86), .ZN(add_8_n96) );
  NOR2_X1 add_8_U32 ( .A1(add_8_n98), .A2(add_8_n101), .ZN(add_8_n93) );
  NAND2_X1 add_8_U31 ( .A1(add_8_n18), .A2(add_8_n165), .ZN(add_8_n110) );
  AND2_X1 add_8_U30 ( .A1(add_8_n72), .A2(add_8_n73), .ZN(N3) );
  OR2_X1 add_8_U29 ( .A1(b[11]), .A2(a[11]), .ZN(add_8_n138) );
  OR2_X1 add_8_U28 ( .A1(b[4]), .A2(a[4]), .ZN(add_8_n55) );
  OR2_X2 add_8_U27 ( .A1(b[12]), .A2(a[12]), .ZN(add_8_n130) );
  AND2_X1 add_8_U26 ( .A1(add_8_n129), .A2(add_8_n130), .ZN(add_8_n18) );
  NOR2_X1 add_8_U25 ( .A1(add_8_n46), .A2(add_8_n17), .ZN(add_8_n167) );
  AND2_X1 add_8_U24 ( .A1(add_8_n168), .A2(add_8_n51), .ZN(add_8_n17) );
  OR2_X1 add_8_U23 ( .A1(add_8_n15), .A2(add_8_n100), .ZN(add_8_n16) );
  OR2_X2 add_8_U22 ( .A1(b[8]), .A2(a[8]), .ZN(add_8_n27) );
  NAND2_X1 add_8_U21 ( .A1(add_8_n188), .A2(add_8_n189), .ZN(add_8_n14) );
  NAND2_X1 add_8_U20 ( .A1(add_8_n12), .A2(add_8_n169), .ZN(add_8_n13) );
  NOR2_X1 add_8_U19 ( .A1(add_8_n172), .A2(add_8_n173), .ZN(add_8_n12) );
  OR2_X2 add_8_U18 ( .A1(b[5]), .A2(a[5]), .ZN(add_8_n44) );
  OR2_X1 add_8_U17 ( .A1(add_8_n164), .A2(add_8_n100), .ZN(add_8_n11) );
  NAND4_X2 add_8_U16 ( .A1(add_8_n55), .A2(add_8_n44), .A3(add_8_n35), .A4(
        add_8_n32), .ZN(add_8_n87) );
  INV_X1 add_8_U15 ( .A(add_8_n26), .ZN(add_8_n10) );
  OR2_X1 add_8_U14 ( .A1(add_8_n100), .A2(add_8_n10), .ZN(add_8_n9) );
  AND2_X1 add_8_U13 ( .A1(add_8_n26), .A2(add_8_n163), .ZN(add_8_n8) );
  NOR2_X1 add_8_U12 ( .A1(add_8_n7), .A2(add_8_n8), .ZN(add_8_n22) );
  NOR2_X1 add_8_U11 ( .A1(add_8_n15), .A2(add_8_n9), .ZN(add_8_n7) );
  OR2_X1 add_8_U10 ( .A1(b[2]), .A2(a[2]), .ZN(add_8_n64) );
  BUF_X1 add_8_U9 ( .A(add_8_n164), .Z(add_8_n15) );
  AND2_X1 add_8_U8 ( .A1(add_8_n187), .A2(add_8_n60), .ZN(add_8_n6) );
  BUF_X1 add_8_U7 ( .A(add_8_n37), .Z(add_8_n5) );
  AND3_X1 add_8_U6 ( .A1(add_8_n122), .A2(add_8_n49), .A3(add_8_n45), .ZN(
        add_8_n4) );
  AND2_X2 add_8_U5 ( .A1(add_8_n148), .A2(add_8_n149), .ZN(add_8_n129) );
  NAND2_X1 add_8_U4 ( .A1(b[6]), .A2(a[6]), .ZN(add_8_n3) );
  NAND2_X1 add_8_U3 ( .A1(add_8_n129), .A2(add_8_n130), .ZN(add_8_n2) );
  BUF_X1 add_8_U2 ( .A(add_8_n33), .Z(add_8_n1) );
  INV_X1 sub_8_U260 ( .A(sub_8_n99), .ZN(sub_8_n242) );
  INV_X1 sub_8_U259 ( .A(sub_8_n33), .ZN(sub_8_n239) );
  INV_X1 sub_8_U258 ( .A(sub_8_n192), .ZN(sub_8_n168) );
  NAND2_X1 sub_8_U257 ( .A1(sub_8_n168), .A2(sub_8_n234), .ZN(sub_8_n209) );
  INV_X1 sub_8_U256 ( .A(sub_8_n107), .ZN(sub_8_n230) );
  NAND3_X1 sub_8_U255 ( .A1(sub_8_n227), .A2(sub_8_n24), .A3(sub_8_n96), .ZN(
        sub_8_n222) );
  NAND3_X1 sub_8_U254 ( .A1(sub_8_n224), .A2(sub_8_n108), .A3(sub_8_n223), 
        .ZN(sub_8_n103) );
  INV_X1 sub_8_U253 ( .A(sub_8_n29), .ZN(sub_8_n196) );
  INV_X1 sub_8_U252 ( .A(sub_8_n197), .ZN(sub_8_n56) );
  INV_X1 sub_8_U251 ( .A(sub_8_n205), .ZN(sub_8_n204) );
  INV_X1 sub_8_U250 ( .A(sub_8_n198), .ZN(sub_8_n186) );
  OAI21_X1 sub_8_U249 ( .B1(sub_8_n204), .B2(sub_8_n186), .A(sub_8_n183), .ZN(
        sub_8_n200) );
  XNOR2_X1 sub_8_U248 ( .A(sub_8_n200), .B(sub_8_n201), .ZN(N30) );
  NAND3_X1 sub_8_U247 ( .A1(sub_8_n61), .A2(sub_8_n183), .A3(sub_8_n57), .ZN(
        sub_8_n182) );
  NAND3_X1 sub_8_U246 ( .A1(sub_8_n180), .A2(sub_8_n181), .A3(sub_8_n182), 
        .ZN(sub_8_n144) );
  NAND2_X1 sub_8_U245 ( .A1(sub_8_n144), .A2(sub_8_n169), .ZN(sub_8_n179) );
  NOR2_X1 sub_8_U244 ( .A1(sub_8_n39), .A2(sub_8_n9), .ZN(sub_8_n157) );
  NAND2_X1 sub_8_U243 ( .A1(sub_8_n126), .A2(sub_8_n159), .ZN(sub_8_n158) );
  NAND3_X1 sub_8_U242 ( .A1(sub_8_n158), .A2(sub_8_n157), .A3(sub_8_n156), 
        .ZN(sub_8_n152) );
  XNOR2_X1 sub_8_U241 ( .A(sub_8_n152), .B(sub_8_n153), .ZN(N32) );
  INV_X1 sub_8_U240 ( .A(sub_8_n135), .ZN(sub_8_n149) );
  INV_X1 sub_8_U239 ( .A(sub_8_n151), .ZN(sub_8_n132) );
  AOI21_X1 sub_8_U238 ( .B1(sub_8_n150), .B2(sub_8_n18), .A(sub_8_n132), .ZN(
        sub_8_n140) );
  NAND3_X1 sub_8_U237 ( .A1(sub_8_n126), .A2(sub_8_n148), .A3(sub_8_n18), .ZN(
        sub_8_n141) );
  NAND2_X1 sub_8_U236 ( .A1(sub_8_n134), .A2(sub_8_n135), .ZN(sub_8_n146) );
  NAND3_X1 sub_8_U235 ( .A1(sub_8_n141), .A2(sub_8_n142), .A3(sub_8_n140), 
        .ZN(sub_8_n136) );
  XNOR2_X1 sub_8_U234 ( .A(sub_8_n136), .B(sub_8_n137), .ZN(N33) );
  INV_X1 sub_8_U233 ( .A(sub_8_n125), .ZN(sub_8_n121) );
  INV_X1 sub_8_U232 ( .A(sub_8_n134), .ZN(sub_8_n130) );
  NAND2_X1 sub_8_U231 ( .A1(sub_8_n132), .A2(sub_8_n133), .ZN(sub_8_n131) );
  AOI21_X1 sub_8_U230 ( .B1(sub_8_n39), .B2(sub_8_n121), .A(sub_8_n129), .ZN(
        sub_8_n117) );
  NAND3_X1 sub_8_U229 ( .A1(sub_8_n126), .A2(sub_8_n127), .A3(sub_8_n18), .ZN(
        sub_8_n118) );
  NAND3_X1 sub_8_U228 ( .A1(sub_8_n118), .A2(sub_8_n119), .A3(sub_8_n117), 
        .ZN(sub_8_n116) );
  XNOR2_X1 sub_8_U227 ( .A(sub_8_n116), .B(sub_8_n45), .ZN(N34) );
  INV_X1 sub_8_U226 ( .A(sub_8_n112), .ZN(sub_8_n111) );
  INV_X1 sub_8_U225 ( .A(sub_8_n109), .ZN(sub_8_n106) );
  INV_X1 sub_8_U224 ( .A(sub_8_n108), .ZN(sub_8_n97) );
  OAI21_X1 sub_8_U223 ( .B1(sub_8_n106), .B2(sub_8_n97), .A(sub_8_n21), .ZN(
        sub_8_n104) );
  XNOR2_X1 sub_8_U222 ( .A(sub_8_n104), .B(sub_8_n105), .ZN(N22) );
  INV_X1 sub_8_U221 ( .A(sub_8_n75), .ZN(sub_8_n78) );
  XNOR2_X1 sub_8_U220 ( .A(sub_8_n76), .B(sub_8_n77), .ZN(N25) );
  INV_X1 sub_8_U219 ( .A(sub_8_n74), .ZN(sub_8_n70) );
  INV_X1 sub_8_U218 ( .A(sub_8_n73), .ZN(sub_8_n72) );
  XNOR2_X1 sub_8_U217 ( .A(sub_8_n63), .B(sub_8_n64), .ZN(N26) );
  XNOR2_X1 sub_8_U216 ( .A(sub_8_n58), .B(sub_8_n62), .ZN(N27) );
  INV_X1 sub_8_U215 ( .A(sub_8_n61), .ZN(sub_8_n60) );
  INV_X1 sub_8_U214 ( .A(sub_8_n57), .ZN(sub_8_n55) );
  NOR2_X1 sub_8_U213 ( .A1(sub_8_n55), .A2(sub_8_n56), .ZN(sub_8_n54) );
  NOR2_X1 sub_8_U212 ( .A1(sub_8_n38), .A2(sub_8_n212), .ZN(sub_8_n211) );
  OAI21_X1 sub_8_U211 ( .B1(sub_8_n210), .B2(sub_8_n209), .A(sub_8_n211), .ZN(
        sub_8_n205) );
  INV_X1 sub_8_U210 ( .A(a[6]), .ZN(sub_8_n241) );
  OAI21_X1 sub_8_U209 ( .B1(sub_8_n25), .B2(sub_8_n78), .A(sub_8_n74), .ZN(
        sub_8_n76) );
  NAND2_X1 sub_8_U208 ( .A1(b[3]), .A2(sub_8_n231), .ZN(sub_8_n223) );
  INV_X1 sub_8_U207 ( .A(a[3]), .ZN(sub_8_n231) );
  OAI21_X1 sub_8_U206 ( .B1(sub_8_n67), .B2(sub_8_n68), .A(sub_8_n69), .ZN(
        sub_8_n63) );
  NAND2_X1 sub_8_U205 ( .A1(sub_8_n223), .A2(sub_8_n96), .ZN(sub_8_n105) );
  NAND2_X1 sub_8_U204 ( .A1(sub_8_n230), .A2(sub_8_n17), .ZN(sub_8_n102) );
  AND2_X1 sub_8_U203 ( .A1(sub_8_n103), .A2(sub_8_n102), .ZN(sub_8_n91) );
  INV_X1 sub_8_U202 ( .A(sub_8_n48), .ZN(sub_8_n52) );
  XNOR2_X1 sub_8_U201 ( .A(sub_8_n46), .B(sub_8_n206), .ZN(N29) );
  XNOR2_X1 sub_8_U200 ( .A(sub_8_n49), .B(sub_8_n88), .ZN(N23) );
  NAND2_X1 sub_8_U199 ( .A1(sub_8_n49), .A2(sub_8_n82), .ZN(sub_8_n87) );
  NAND2_X1 sub_8_U198 ( .A1(sub_8_n81), .A2(sub_8_n82), .ZN(sub_8_n79) );
  INV_X1 sub_8_U197 ( .A(a[4]), .ZN(sub_8_n89) );
  INV_X1 sub_8_U196 ( .A(b[4]), .ZN(sub_8_n90) );
  AND2_X1 sub_8_U195 ( .A1(sub_8_n19), .A2(a[4]), .ZN(sub_8_n221) );
  INV_X1 sub_8_U194 ( .A(a[5]), .ZN(sub_8_n86) );
  NAND2_X1 sub_8_U193 ( .A1(b[5]), .A2(sub_8_n23), .ZN(sub_8_n236) );
  NOR2_X1 sub_8_U192 ( .A1(sub_8_n86), .A2(b[5]), .ZN(sub_8_n220) );
  NAND2_X1 sub_8_U191 ( .A1(b[5]), .A2(sub_8_n23), .ZN(sub_8_n75) );
  OAI211_X1 sub_8_U190 ( .C1(sub_8_n221), .C2(sub_8_n220), .A(sub_8_n236), .B(
        sub_8_n71), .ZN(sub_8_n172) );
  NAND2_X1 sub_8_U189 ( .A1(sub_8_n172), .A2(sub_8_n73), .ZN(sub_8_n218) );
  INV_X1 sub_8_U188 ( .A(a[1]), .ZN(sub_8_n225) );
  OAI211_X1 sub_8_U187 ( .C1(sub_8_n20), .C2(sub_8_n13), .A(sub_8_n75), .B(
        sub_8_n32), .ZN(sub_8_n51) );
  INV_X1 sub_8_U186 ( .A(a[8]), .ZN(sub_8_n240) );
  NAND2_X1 sub_8_U185 ( .A1(b[8]), .A2(sub_8_n11), .ZN(sub_8_n59) );
  NAND2_X1 sub_8_U184 ( .A1(b[8]), .A2(sub_8_n240), .ZN(sub_8_n50) );
  NOR2_X1 sub_8_U183 ( .A1(sub_8_n222), .A2(sub_8_n26), .ZN(sub_8_n210) );
  NAND2_X1 sub_8_U182 ( .A1(sub_8_n225), .A2(b[1]), .ZN(sub_8_n114) );
  NAND2_X1 sub_8_U181 ( .A1(sub_8_n91), .A2(sub_8_n92), .ZN(sub_8_n81) );
  NAND2_X1 sub_8_U180 ( .A1(sub_8_n59), .A2(sub_8_n216), .ZN(sub_8_n213) );
  NOR2_X1 sub_8_U179 ( .A1(sub_8_n239), .A2(sub_8_n213), .ZN(sub_8_n234) );
  NOR2_X1 sub_8_U178 ( .A1(sub_8_n213), .A2(sub_8_n196), .ZN(sub_8_n217) );
  OAI221_X1 sub_8_U177 ( .B1(sub_8_n56), .B2(sub_8_n61), .C1(sub_8_n66), .C2(
        sub_8_n213), .A(sub_8_n57), .ZN(sub_8_n212) );
  NAND2_X1 sub_8_U176 ( .A1(sub_8_n188), .A2(sub_8_n189), .ZN(sub_8_n58) );
  AOI21_X1 sub_8_U175 ( .B1(sub_8_n2), .B2(sub_8_n58), .A(sub_8_n179), .ZN(
        sub_8_n175) );
  OAI211_X1 sub_8_U174 ( .C1(sub_8_n40), .C2(sub_8_n193), .A(sub_8_n102), .B(
        sub_8_n96), .ZN(sub_8_n190) );
  OAI21_X1 sub_8_U173 ( .B1(sub_8_n190), .B2(sub_8_n26), .A(sub_8_n191), .ZN(
        sub_8_n189) );
  INV_X1 sub_8_U172 ( .A(a[0]), .ZN(sub_8_n243) );
  NAND2_X1 sub_8_U171 ( .A1(sub_8_n228), .A2(sub_8_n229), .ZN(sub_8_n227) );
  AOI21_X1 sub_8_U170 ( .B1(sub_8_n93), .B2(sub_8_n94), .A(sub_8_n95), .ZN(
        sub_8_n92) );
  INV_X1 sub_8_U169 ( .A(a[2]), .ZN(sub_8_n226) );
  NAND2_X1 sub_8_U168 ( .A1(sub_8_n36), .A2(b[2]), .ZN(sub_8_n165) );
  NAND2_X1 sub_8_U167 ( .A1(b[2]), .A2(sub_8_n226), .ZN(sub_8_n108) );
  NAND2_X1 sub_8_U166 ( .A1(sub_8_n96), .A2(sub_8_n24), .ZN(sub_8_n162) );
  NAND2_X1 sub_8_U165 ( .A1(b[1]), .A2(sub_8_n27), .ZN(sub_8_n48) );
  NAND2_X1 sub_8_U164 ( .A1(sub_8_n133), .A2(sub_8_n135), .ZN(sub_8_n125) );
  NAND2_X1 sub_8_U163 ( .A1(sub_8_n135), .A2(sub_8_n147), .ZN(sub_8_n145) );
  OAI21_X1 sub_8_U162 ( .B1(sub_8_n130), .B2(sub_8_n125), .A(sub_8_n131), .ZN(
        sub_8_n129) );
  NOR2_X1 sub_8_U161 ( .A1(sub_8_n128), .A2(sub_8_n125), .ZN(sub_8_n127) );
  AOI21_X1 sub_8_U160 ( .B1(sub_8_n15), .B2(sub_8_n135), .A(sub_8_n143), .ZN(
        sub_8_n142) );
  NAND2_X1 sub_8_U159 ( .A1(sub_8_n151), .A2(sub_8_n135), .ZN(sub_8_n153) );
  NAND2_X1 sub_8_U158 ( .A1(sub_8_n2), .A2(sub_8_n147), .ZN(sub_8_n123) );
  NOR2_X1 sub_8_U157 ( .A1(sub_8_n7), .A2(sub_8_n66), .ZN(sub_8_n171) );
  OAI21_X1 sub_8_U156 ( .B1(sub_8_n123), .B2(sub_8_n41), .A(sub_8_n124), .ZN(
        sub_8_n122) );
  NAND4_X1 sub_8_U155 ( .A1(sub_8_n197), .A2(sub_8_n198), .A3(sub_8_n187), 
        .A4(sub_8_n3), .ZN(sub_8_n174) );
  NAND2_X1 sub_8_U154 ( .A1(b[3]), .A2(sub_8_n12), .ZN(sub_8_n237) );
  NAND2_X1 sub_8_U153 ( .A1(sub_8_n87), .A2(sub_8_n80), .ZN(sub_8_n83) );
  NOR2_X1 sub_8_U152 ( .A1(sub_8_n163), .A2(sub_8_n164), .ZN(sub_8_n161) );
  NAND2_X1 sub_8_U151 ( .A1(a[1]), .A2(sub_8_n101), .ZN(sub_8_n98) );
  NAND2_X1 sub_8_U150 ( .A1(a[1]), .A2(sub_8_n101), .ZN(sub_8_n166) );
  INV_X1 sub_8_U149 ( .A(b[1]), .ZN(sub_8_n101) );
  AND2_X1 sub_8_U148 ( .A1(b[0]), .A2(sub_8_n243), .ZN(sub_8_n47) );
  INV_X1 sub_8_U147 ( .A(sub_8_n96), .ZN(sub_8_n95) );
  NAND2_X1 sub_8_U146 ( .A1(sub_8_n233), .A2(a[3]), .ZN(sub_8_n96) );
  CLKBUF_X1 sub_8_U145 ( .A(sub_8_n205), .Z(sub_8_n46) );
  NAND2_X1 sub_8_U144 ( .A1(sub_8_n37), .A2(sub_8_n160), .ZN(sub_8_n126) );
  AOI21_X1 sub_8_U143 ( .B1(sub_8_n58), .B2(sub_8_n50), .A(sub_8_n60), .ZN(
        sub_8_n53) );
  NAND2_X1 sub_8_U142 ( .A1(b[7]), .A2(sub_8_n238), .ZN(sub_8_n65) );
  NAND4_X1 sub_8_U141 ( .A1(sub_8_n236), .A2(sub_8_n235), .A3(sub_8_n237), 
        .A4(sub_8_n65), .ZN(sub_8_n192) );
  NAND2_X1 sub_8_U140 ( .A1(sub_8_n147), .A2(sub_8_n30), .ZN(sub_8_n173) );
  NAND2_X1 sub_8_U139 ( .A1(sub_8_n29), .A2(sub_8_n66), .ZN(sub_8_n64) );
  NAND2_X1 sub_8_U138 ( .A1(sub_8_n108), .A2(sub_8_n48), .ZN(sub_8_n193) );
  AND2_X1 sub_8_U137 ( .A1(sub_8_n79), .A2(sub_8_n80), .ZN(sub_8_n67) );
  XOR2_X1 sub_8_U136 ( .A(b[15]), .B(a[15]), .Z(sub_8_n45) );
  XNOR2_X1 sub_8_U135 ( .A(sub_8_n112), .B(sub_8_n113), .ZN(N20) );
  NAND2_X1 sub_8_U134 ( .A1(a[4]), .A2(sub_8_n90), .ZN(sub_8_n80) );
  INV_X1 sub_8_U133 ( .A(b[5]), .ZN(sub_8_n85) );
  NAND2_X1 sub_8_U132 ( .A1(a[5]), .A2(sub_8_n85), .ZN(sub_8_n74) );
  INV_X1 sub_8_U131 ( .A(b[14]), .ZN(sub_8_n138) );
  NAND2_X1 sub_8_U130 ( .A1(a[14]), .A2(sub_8_n138), .ZN(sub_8_n124) );
  NAND2_X1 sub_8_U129 ( .A1(b[4]), .A2(sub_8_n89), .ZN(sub_8_n82) );
  XNOR2_X1 sub_8_U128 ( .A(sub_8_n6), .B(sub_8_n110), .ZN(N21) );
  INV_X1 sub_8_U127 ( .A(b[13]), .ZN(sub_8_n155) );
  NAND2_X1 sub_8_U126 ( .A1(a[13]), .A2(sub_8_n155), .ZN(sub_8_n151) );
  INV_X1 sub_8_U125 ( .A(b[7]), .ZN(sub_8_n214) );
  NAND2_X1 sub_8_U124 ( .A1(sub_8_n100), .A2(a[0]), .ZN(sub_8_n115) );
  INV_X1 sub_8_U123 ( .A(b[12]), .ZN(sub_8_n177) );
  NAND2_X1 sub_8_U122 ( .A1(a[12]), .A2(sub_8_n177), .ZN(sub_8_n170) );
  INV_X1 sub_8_U121 ( .A(b[11]), .ZN(sub_8_n202) );
  NAND2_X1 sub_8_U120 ( .A1(a[11]), .A2(sub_8_n202), .ZN(sub_8_n169) );
  INV_X1 sub_8_U119 ( .A(b[6]), .ZN(sub_8_n219) );
  INV_X1 sub_8_U118 ( .A(a[14]), .ZN(sub_8_n139) );
  NAND2_X1 sub_8_U117 ( .A1(b[14]), .A2(sub_8_n139), .ZN(sub_8_n133) );
  INV_X1 sub_8_U116 ( .A(b[3]), .ZN(sub_8_n233) );
  INV_X1 sub_8_U115 ( .A(a[13]), .ZN(sub_8_n154) );
  NAND2_X1 sub_8_U114 ( .A1(a[9]), .A2(sub_8_n185), .ZN(sub_8_n57) );
  INV_X1 sub_8_U113 ( .A(b[8]), .ZN(sub_8_n215) );
  NAND2_X1 sub_8_U112 ( .A1(a[8]), .A2(sub_8_n215), .ZN(sub_8_n61) );
  INV_X1 sub_8_U111 ( .A(b[9]), .ZN(sub_8_n185) );
  NOR2_X1 sub_8_U110 ( .A1(a[9]), .A2(sub_8_n185), .ZN(sub_8_n184) );
  INV_X1 sub_8_U109 ( .A(a[12]), .ZN(sub_8_n178) );
  XNOR2_X1 sub_8_U108 ( .A(sub_8_n83), .B(sub_8_n84), .ZN(N24) );
  NAND2_X1 sub_8_U107 ( .A1(sub_8_n10), .A2(sub_8_n183), .ZN(sub_8_n206) );
  INV_X1 sub_8_U106 ( .A(b[10]), .ZN(sub_8_n207) );
  NAND2_X1 sub_8_U105 ( .A1(a[10]), .A2(sub_8_n207), .ZN(sub_8_n183) );
  INV_X1 sub_8_U104 ( .A(a[7]), .ZN(sub_8_n238) );
  NAND2_X1 sub_8_U103 ( .A1(b[4]), .A2(sub_8_n89), .ZN(sub_8_n235) );
  INV_X1 sub_8_U102 ( .A(a[11]), .ZN(sub_8_n203) );
  NAND2_X1 sub_8_U101 ( .A1(sub_8_n203), .A2(b[11]), .ZN(sub_8_n187) );
  NAND2_X1 sub_8_U100 ( .A1(b[9]), .A2(sub_8_n199), .ZN(sub_8_n197) );
  NAND2_X1 sub_8_U99 ( .A1(b[9]), .A2(sub_8_n199), .ZN(sub_8_n216) );
  INV_X1 sub_8_U98 ( .A(a[9]), .ZN(sub_8_n199) );
  NAND2_X1 sub_8_U97 ( .A1(sub_8_n133), .A2(sub_8_n124), .ZN(sub_8_n137) );
  INV_X1 sub_8_U96 ( .A(b[0]), .ZN(sub_8_n100) );
  NAND2_X1 sub_8_U95 ( .A1(sub_8_n100), .A2(a[0]), .ZN(sub_8_n167) );
  NAND2_X1 sub_8_U94 ( .A1(sub_8_n100), .A2(a[0]), .ZN(sub_8_n99) );
  AOI21_X1 sub_8_U93 ( .B1(sub_8_n98), .B2(sub_8_n167), .A(sub_8_n14), .ZN(
        sub_8_n93) );
  INV_X1 sub_8_U92 ( .A(b[2]), .ZN(sub_8_n232) );
  NAND2_X1 sub_8_U91 ( .A1(a[2]), .A2(sub_8_n232), .ZN(sub_8_n107) );
  INV_X1 sub_8_U90 ( .A(a[10]), .ZN(sub_8_n208) );
  NAND2_X1 sub_8_U89 ( .A1(b[10]), .A2(sub_8_n208), .ZN(sub_8_n198) );
  NAND2_X1 sub_8_U88 ( .A1(sub_8_n22), .A2(b[0]), .ZN(sub_8_n44) );
  AND2_X1 sub_8_U87 ( .A1(sub_8_n44), .A2(sub_8_n114), .ZN(sub_8_n224) );
  NAND2_X1 sub_8_U86 ( .A1(sub_8_n80), .A2(sub_8_n82), .ZN(sub_8_n88) );
  NAND2_X1 sub_8_U85 ( .A1(sub_8_n187), .A2(sub_8_n169), .ZN(sub_8_n201) );
  NAND2_X1 sub_8_U84 ( .A1(sub_8_n61), .A2(sub_8_n50), .ZN(sub_8_n62) );
  NAND2_X1 sub_8_U83 ( .A1(sub_8_n108), .A2(sub_8_n21), .ZN(sub_8_n110) );
  NAND2_X1 sub_8_U82 ( .A1(sub_8_n75), .A2(sub_8_n74), .ZN(sub_8_n84) );
  NAND2_X1 sub_8_U81 ( .A1(sub_8_n32), .A2(sub_8_n73), .ZN(sub_8_n77) );
  NAND2_X1 sub_8_U80 ( .A1(sub_8_n48), .A2(sub_8_n98), .ZN(sub_8_n113) );
  NAND2_X1 sub_8_U79 ( .A1(sub_8_n147), .A2(sub_8_n170), .ZN(sub_8_n176) );
  NOR2_X1 sub_8_U78 ( .A1(sub_8_n149), .A2(sub_8_n66), .ZN(sub_8_n150) );
  NAND2_X1 sub_8_U77 ( .A1(sub_8_n47), .A2(sub_8_n115), .ZN(sub_8_n112) );
  OAI21_X1 sub_8_U76 ( .B1(sub_8_n111), .B2(sub_8_n52), .A(sub_8_n98), .ZN(
        sub_8_n109) );
  NOR2_X1 sub_8_U75 ( .A1(sub_8_n192), .A2(sub_8_n239), .ZN(sub_8_n191) );
  NAND2_X1 sub_8_U74 ( .A1(sub_8_n48), .A2(sub_8_n108), .ZN(sub_8_n164) );
  AND2_X1 sub_8_U73 ( .A1(sub_8_n51), .A2(sub_8_n73), .ZN(sub_8_n43) );
  OR2_X1 sub_8_U72 ( .A1(sub_8_n174), .A2(sub_8_n173), .ZN(sub_8_n42) );
  NOR2_X1 sub_8_U71 ( .A1(sub_8_n42), .A2(sub_8_n43), .ZN(sub_8_n120) );
  AOI21_X1 sub_8_U70 ( .B1(sub_8_n51), .B2(sub_8_n73), .A(sub_8_n196), .ZN(
        sub_8_n194) );
  AND2_X1 sub_8_U69 ( .A1(sub_8_n115), .A2(sub_8_n166), .ZN(sub_8_n163) );
  OAI21_X1 sub_8_U68 ( .B1(sub_8_n144), .B2(sub_8_n145), .A(sub_8_n146), .ZN(
        sub_8_n143) );
  OAI21_X1 sub_8_U67 ( .B1(sub_8_n8), .B2(sub_8_n169), .A(sub_8_n170), .ZN(
        sub_8_n134) );
  NAND2_X1 sub_8_U66 ( .A1(sub_8_n168), .A2(sub_8_n33), .ZN(sub_8_n128) );
  OR2_X1 sub_8_U65 ( .A1(sub_8_n125), .A2(sub_8_n66), .ZN(sub_8_n41) );
  NAND2_X1 sub_8_U64 ( .A1(sub_8_n166), .A2(sub_8_n167), .ZN(sub_8_n229) );
  INV_X1 sub_8_U63 ( .A(sub_8_n66), .ZN(sub_8_n195) );
  NOR2_X1 sub_8_U62 ( .A1(sub_8_n194), .A2(sub_8_n195), .ZN(sub_8_n188) );
  AND2_X1 sub_8_U61 ( .A1(sub_8_n166), .A2(sub_8_n99), .ZN(sub_8_n40) );
  XOR2_X1 sub_8_U60 ( .A(sub_8_n175), .B(sub_8_n176), .Z(N31) );
  XNOR2_X1 sub_8_U59 ( .A(sub_8_n53), .B(sub_8_n54), .ZN(N28) );
  NOR2_X1 sub_8_U58 ( .A1(sub_8_n161), .A2(sub_8_n162), .ZN(sub_8_n160) );
  AND2_X1 sub_8_U57 ( .A1(sub_8_n28), .A2(sub_8_n147), .ZN(sub_8_n39) );
  NAND2_X1 sub_8_U56 ( .A1(sub_8_n184), .A2(sub_8_n183), .ZN(sub_8_n181) );
  AOI21_X1 sub_8_U55 ( .B1(sub_8_n70), .B2(sub_8_n32), .A(sub_8_n72), .ZN(
        sub_8_n69) );
  NAND2_X1 sub_8_U54 ( .A1(sub_8_n75), .A2(sub_8_n33), .ZN(sub_8_n68) );
  AND2_X1 sub_8_U53 ( .A1(sub_8_n218), .A2(sub_8_n217), .ZN(sub_8_n38) );
  NOR2_X1 sub_8_U52 ( .A1(sub_8_n7), .A2(sub_8_n128), .ZN(sub_8_n159) );
  NOR2_X1 sub_8_U51 ( .A1(sub_8_n128), .A2(sub_8_n149), .ZN(sub_8_n148) );
  NOR2_X1 sub_8_U50 ( .A1(sub_8_n171), .A2(sub_8_n16), .ZN(sub_8_n156) );
  AOI21_X1 sub_8_U49 ( .B1(sub_8_n120), .B2(sub_8_n121), .A(sub_8_n122), .ZN(
        sub_8_n119) );
  INV_X1 sub_8_U48 ( .A(sub_8_n26), .ZN(sub_8_n37) );
  AND2_X1 sub_8_U47 ( .A1(sub_8_n237), .A2(sub_8_n165), .ZN(sub_8_n94) );
  INV_X1 sub_8_U46 ( .A(a[2]), .ZN(sub_8_n36) );
  NAND2_X1 sub_8_U45 ( .A1(sub_8_n241), .A2(b[6]), .ZN(sub_8_n71) );
  INV_X1 sub_8_U44 ( .A(a[6]), .ZN(sub_8_n35) );
  INV_X1 sub_8_U43 ( .A(a[6]), .ZN(sub_8_n34) );
  NAND2_X1 sub_8_U42 ( .A1(sub_8_n35), .A2(b[6]), .ZN(sub_8_n33) );
  NAND2_X1 sub_8_U41 ( .A1(sub_8_n34), .A2(b[6]), .ZN(sub_8_n32) );
  INV_X1 sub_8_U40 ( .A(a[7]), .ZN(sub_8_n31) );
  NAND2_X1 sub_8_U39 ( .A1(b[7]), .A2(sub_8_n238), .ZN(sub_8_n30) );
  NAND2_X1 sub_8_U38 ( .A1(b[7]), .A2(sub_8_n31), .ZN(sub_8_n29) );
  AND2_X1 sub_8_U37 ( .A1(sub_8_n187), .A2(sub_8_n10), .ZN(sub_8_n180) );
  AND3_X1 sub_8_U36 ( .A1(sub_8_n180), .A2(sub_8_n181), .A3(sub_8_n182), .ZN(
        sub_8_n28) );
  INV_X1 sub_8_U35 ( .A(a[1]), .ZN(sub_8_n27) );
  AND3_X1 sub_8_U34 ( .A1(sub_8_n1), .A2(sub_8_n108), .A3(sub_8_n17), .ZN(
        sub_8_n26) );
  AND2_X1 sub_8_U33 ( .A1(sub_8_n79), .A2(sub_8_n80), .ZN(sub_8_n25) );
  CLKBUF_X1 sub_8_U32 ( .A(sub_8_n81), .Z(sub_8_n49) );
  NAND2_X1 sub_8_U31 ( .A1(sub_8_n230), .A2(sub_8_n17), .ZN(sub_8_n24) );
  INV_X1 sub_8_U30 ( .A(a[5]), .ZN(sub_8_n23) );
  INV_X1 sub_8_U29 ( .A(a[0]), .ZN(sub_8_n22) );
  BUF_X1 sub_8_U28 ( .A(sub_8_n107), .Z(sub_8_n21) );
  AND2_X1 sub_8_U27 ( .A1(sub_8_n90), .A2(a[4]), .ZN(sub_8_n20) );
  INV_X1 sub_8_U26 ( .A(b[4]), .ZN(sub_8_n19) );
  AND2_X1 sub_8_U25 ( .A1(sub_8_n2), .A2(sub_8_n147), .ZN(sub_8_n18) );
  NAND2_X1 sub_8_U24 ( .A1(b[3]), .A2(sub_8_n231), .ZN(sub_8_n17) );
  NOR2_X1 sub_8_U23 ( .A1(sub_8_n42), .A2(sub_8_n43), .ZN(sub_8_n16) );
  NOR2_X1 sub_8_U22 ( .A1(sub_8_n42), .A2(sub_8_n43), .ZN(sub_8_n15) );
  AND2_X1 sub_8_U21 ( .A1(b[1]), .A2(sub_8_n27), .ZN(sub_8_n14) );
  NOR2_X1 sub_8_U20 ( .A1(b[5]), .A2(sub_8_n86), .ZN(sub_8_n13) );
  INV_X1 sub_8_U19 ( .A(a[3]), .ZN(sub_8_n12) );
  INV_X1 sub_8_U18 ( .A(a[8]), .ZN(sub_8_n11) );
  NAND2_X1 sub_8_U17 ( .A1(b[10]), .A2(sub_8_n208), .ZN(sub_8_n10) );
  INV_X1 sub_8_U16 ( .A(sub_8_n130), .ZN(sub_8_n9) );
  NAND2_X2 sub_8_U15 ( .A1(b[12]), .A2(sub_8_n178), .ZN(sub_8_n147) );
  AND2_X1 sub_8_U14 ( .A1(b[12]), .A2(sub_8_n178), .ZN(sub_8_n8) );
  NAND2_X1 sub_8_U13 ( .A1(sub_8_n2), .A2(sub_8_n147), .ZN(sub_8_n7) );
  OAI21_X1 sub_8_U12 ( .B1(sub_8_n111), .B2(sub_8_n52), .A(sub_8_n98), .ZN(
        sub_8_n6) );
  OR2_X1 sub_8_U11 ( .A1(sub_8_n47), .A2(sub_8_n242), .ZN(N19) );
  NAND2_X1 sub_8_U10 ( .A1(a[7]), .A2(sub_8_n214), .ZN(sub_8_n66) );
  NAND2_X1 sub_8_U9 ( .A1(a[6]), .A2(sub_8_n219), .ZN(sub_8_n73) );
  NAND2_X1 sub_8_U8 ( .A1(b[1]), .A2(sub_8_n27), .ZN(sub_8_n4) );
  AND2_X1 sub_8_U7 ( .A1(sub_8_n165), .A2(sub_8_n4), .ZN(sub_8_n228) );
  NAND2_X1 sub_8_U6 ( .A1(b[8]), .A2(sub_8_n11), .ZN(sub_8_n3) );
  NAND2_X2 sub_8_U5 ( .A1(b[13]), .A2(sub_8_n154), .ZN(sub_8_n135) );
  AND4_X2 sub_8_U4 ( .A1(sub_8_n197), .A2(sub_8_n198), .A3(sub_8_n187), .A4(
        sub_8_n3), .ZN(sub_8_n2) );
  AND2_X1 sub_8_U3 ( .A1(sub_8_n44), .A2(sub_8_n114), .ZN(sub_8_n1) );
endmodule

