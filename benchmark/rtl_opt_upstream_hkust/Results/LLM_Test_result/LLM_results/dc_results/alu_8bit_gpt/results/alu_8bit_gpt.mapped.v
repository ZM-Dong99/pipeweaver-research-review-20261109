/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:28:34 2025
/////////////////////////////////////////////////////////////


module alu_8bit_gpt ( a, b, Oper, sum );
  input [7:0] a;
  input [7:0] b;
  input [2:0] Oper;
  output [7:0] sum;
  wire   N71, N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84,
         N85, N86, N87, N88, N89, N90, N91, N92, N93, N94, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
         n144, n145, n146, n147, n148, n149, n150, n151, n152, n153, n154,
         n155, n156, add_11_n83, add_11_n82, add_11_n81, add_11_n80,
         add_11_n79, add_11_n78, add_11_n77, add_11_n76, add_11_n75,
         add_11_n74, add_11_n73, add_11_n72, add_11_n71, add_11_n70,
         add_11_n69, add_11_n68, add_11_n67, add_11_n66, add_11_n65,
         add_11_n64, add_11_n63, add_11_n62, add_11_n61, add_11_n60,
         add_11_n59, add_11_n58, add_11_n57, add_11_n56, add_11_n55,
         add_11_n54, add_11_n53, add_11_n52, add_11_n51, add_11_n50,
         add_11_n49, add_11_n48, add_11_n47, add_11_n46, add_11_n45,
         add_11_n44, add_11_n43, add_11_n42, add_11_n41, add_11_n40,
         add_11_n39, add_11_n38, add_11_n37, add_11_n36, add_11_n35,
         add_11_n34, add_11_n33, add_11_n32, add_11_n31, add_11_n30,
         add_11_n29, add_11_n28, add_11_n27, add_11_n26, add_11_n25,
         add_11_n24, add_11_n23, add_11_n22, add_11_n21, add_11_n20,
         add_11_n19, add_11_n18, add_11_n17, add_11_n16, add_11_n15,
         add_11_n14, add_11_n13, add_11_n12, add_11_n11, add_11_n10, add_11_n9,
         add_11_n8, add_11_n7, add_11_n6, add_11_n5, add_11_n4, add_11_n3,
         add_11_n2, sub_13_n95, sub_13_n94, sub_13_n93, sub_13_n92, sub_13_n91,
         sub_13_n90, sub_13_n89, sub_13_n88, sub_13_n87, sub_13_n86,
         sub_13_n85, sub_13_n84, sub_13_n83, sub_13_n82, sub_13_n81,
         sub_13_n80, sub_13_n79, sub_13_n78, sub_13_n77, sub_13_n76,
         sub_13_n75, sub_13_n74, sub_13_n73, sub_13_n72, sub_13_n71,
         sub_13_n70, sub_13_n69, sub_13_n68, sub_13_n67, sub_13_n66,
         sub_13_n65, sub_13_n64, sub_13_n63, sub_13_n62, sub_13_n61,
         sub_13_n60, sub_13_n59, sub_13_n58, sub_13_n57, sub_13_n56,
         sub_13_n55, sub_13_n54, sub_13_n53, sub_13_n52, sub_13_n51,
         sub_13_n50, sub_13_n49, sub_13_n48, sub_13_n47, sub_13_n46,
         sub_13_n45, sub_13_n44, sub_13_n43, sub_13_n42, sub_13_n41,
         sub_13_n40, sub_13_n39, sub_13_n38, sub_13_n37, sub_13_n36,
         sub_13_n35, sub_13_n34, sub_13_n33, sub_13_n32, sub_13_n31,
         sub_13_n30, sub_13_n29, sub_13_n28, sub_13_n27, sub_13_n26,
         sub_13_n25, sub_13_n24, sub_13_n23, sub_13_n22, sub_13_n21,
         sub_13_n19, sub_13_n18, sub_13_n17, sub_13_n16, sub_13_n15,
         sub_13_n14, sub_13_n13, sub_13_n12, sub_13_n11, sub_13_n10, sub_13_n9,
         sub_13_n8, sub_13_n7, sub_13_n6, sub_13_n5, sub_13_n4, sub_13_n3,
         sub_13_n2, sub_13_n1, sub_12_n102, sub_12_n101, sub_12_n100,
         sub_12_n99, sub_12_n98, sub_12_n97, sub_12_n96, sub_12_n95,
         sub_12_n94, sub_12_n93, sub_12_n92, sub_12_n91, sub_12_n90,
         sub_12_n89, sub_12_n88, sub_12_n87, sub_12_n86, sub_12_n85,
         sub_12_n84, sub_12_n83, sub_12_n82, sub_12_n81, sub_12_n80,
         sub_12_n79, sub_12_n78, sub_12_n77, sub_12_n76, sub_12_n75,
         sub_12_n74, sub_12_n73, sub_12_n72, sub_12_n71, sub_12_n70,
         sub_12_n69, sub_12_n68, sub_12_n67, sub_12_n66, sub_12_n65,
         sub_12_n64, sub_12_n63, sub_12_n62, sub_12_n61, sub_12_n60,
         sub_12_n59, sub_12_n58, sub_12_n57, sub_12_n56, sub_12_n55,
         sub_12_n54, sub_12_n53, sub_12_n52, sub_12_n51, sub_12_n50,
         sub_12_n49, sub_12_n48, sub_12_n47, sub_12_n46, sub_12_n45,
         sub_12_n44, sub_12_n43, sub_12_n42, sub_12_n41, sub_12_n40,
         sub_12_n39, sub_12_n38, sub_12_n37, sub_12_n36, sub_12_n35,
         sub_12_n34, sub_12_n33, sub_12_n32, sub_12_n31, sub_12_n30,
         sub_12_n29, sub_12_n28, sub_12_n27, sub_12_n26, sub_12_n25,
         sub_12_n24, sub_12_n23, sub_12_n22, sub_12_n21, sub_12_n20,
         sub_12_n19, sub_12_n18, sub_12_n17, sub_12_n16, sub_12_n15,
         sub_12_n14, sub_12_n13, sub_12_n12, sub_12_n11, sub_12_n10, sub_12_n9,
         sub_12_n8, sub_12_n7, sub_12_n6, sub_12_n5, sub_12_n4, sub_12_n3,
         sub_12_n2, sub_12_n1;

  INV_X1 U73 ( .A(n108), .ZN(n67) );
  BUF_X1 U74 ( .A(b[0]), .Z(n68) );
  AND2_X1 U75 ( .A1(n147), .A2(n146), .ZN(n69) );
  NAND3_X1 U76 ( .A1(Oper[2]), .A2(Oper[0]), .A3(n94), .ZN(n70) );
  NAND3_X1 U77 ( .A1(Oper[2]), .A2(Oper[0]), .A3(n94), .ZN(n71) );
  NAND3_X1 U78 ( .A1(Oper[2]), .A2(Oper[0]), .A3(n94), .ZN(n151) );
  INV_X2 U79 ( .A(Oper[1]), .ZN(n94) );
  BUF_X1 U80 ( .A(b[1]), .Z(n72) );
  CLKBUF_X1 U81 ( .A(n150), .Z(n73) );
  NAND2_X1 U82 ( .A1(Oper[2]), .A2(n92), .ZN(n74) );
  NAND2_X2 U83 ( .A1(n75), .A2(Oper[1]), .ZN(n149) );
  AND2_X1 U84 ( .A1(Oper[2]), .A2(n92), .ZN(n75) );
  INV_X1 U85 ( .A(n89), .ZN(n76) );
  NAND2_X1 U86 ( .A1(N76), .A2(n83), .ZN(n77) );
  NAND2_X1 U87 ( .A1(n87), .A2(n136), .ZN(n78) );
  INV_X1 U88 ( .A(n135), .ZN(n79) );
  AND3_X1 U89 ( .A1(n77), .A2(n78), .A3(n79), .ZN(n137) );
  AND3_X2 U90 ( .A1(n94), .A2(n93), .A3(n92), .ZN(n83) );
  NAND3_X1 U91 ( .A1(n156), .A2(n81), .A3(n82), .ZN(sum[7]) );
  NAND3_X1 U92 ( .A1(n144), .A2(n145), .A3(n69), .ZN(sum[6]) );
  AND3_X1 U93 ( .A1(Oper[0]), .A2(n93), .A3(n94), .ZN(n85) );
  AND3_X1 U94 ( .A1(Oper[1]), .A2(n93), .A3(n92), .ZN(n84) );
  NAND2_X1 U95 ( .A1(N86), .A2(n85), .ZN(n81) );
  NAND2_X1 U96 ( .A1(N94), .A2(n84), .ZN(n82) );
  INV_X1 U97 ( .A(n143), .ZN(n146) );
  NAND2_X1 U98 ( .A1(a[6]), .A2(n140), .ZN(n147) );
  NAND2_X1 U99 ( .A1(n139), .A2(n150), .ZN(n140) );
  OAI21_X1 U100 ( .B1(a[6]), .B2(n151), .A(n150), .ZN(n141) );
  NOR2_X1 U101 ( .A1(a[6]), .A2(n149), .ZN(n142) );
  INV_X1 U102 ( .A(n124), .ZN(n86) );
  BUF_X1 U103 ( .A(a[5]), .Z(n87) );
  NAND2_X1 U104 ( .A1(N77), .A2(n83), .ZN(n145) );
  AOI22_X1 U105 ( .A1(N85), .A2(n85), .B1(N93), .B2(n84), .ZN(n144) );
  OR2_X1 U106 ( .A1(a[7]), .A2(n94), .ZN(n88) );
  NAND3_X2 U107 ( .A1(Oper[0]), .A2(Oper[1]), .A3(n93), .ZN(n150) );
  INV_X1 U108 ( .A(Oper[2]), .ZN(n93) );
  INV_X1 U109 ( .A(Oper[0]), .ZN(n92) );
  MUX2_X1 U110 ( .A(n70), .B(n74), .S(n68), .Z(n90) );
  INV_X1 U111 ( .A(a[0]), .ZN(n89) );
  AOI21_X1 U112 ( .B1(n90), .B2(n150), .A(n89), .ZN(n91) );
  AOI221_X1 U113 ( .B1(N87), .B2(n84), .C1(N79), .C2(n85), .A(n91), .ZN(n99)
         );
  NOR2_X1 U114 ( .A1(n76), .A2(n149), .ZN(n96) );
  OAI21_X1 U115 ( .B1(n76), .B2(n71), .A(n150), .ZN(n95) );
  MUX2_X1 U116 ( .A(n96), .B(n95), .S(n68), .Z(n97) );
  AOI21_X1 U117 ( .B1(N71), .B2(n83), .A(n97), .ZN(n98) );
  NAND2_X1 U118 ( .A1(n99), .A2(n98), .ZN(sum[0]) );
  MUX2_X1 U119 ( .A(n70), .B(n74), .S(n72), .Z(n101) );
  INV_X1 U120 ( .A(a[1]), .ZN(n100) );
  AOI21_X1 U121 ( .B1(n101), .B2(n150), .A(n100), .ZN(n102) );
  AOI221_X1 U122 ( .B1(N88), .B2(n84), .C1(N80), .C2(n85), .A(n102), .ZN(n107)
         );
  NOR2_X1 U123 ( .A1(a[1]), .A2(n149), .ZN(n104) );
  OAI21_X1 U124 ( .B1(a[1]), .B2(n70), .A(n150), .ZN(n103) );
  MUX2_X1 U125 ( .A(n104), .B(n103), .S(n72), .Z(n105) );
  AOI21_X1 U126 ( .B1(N72), .B2(n83), .A(n105), .ZN(n106) );
  NAND2_X1 U127 ( .A1(n107), .A2(n106), .ZN(sum[1]) );
  MUX2_X1 U128 ( .A(n71), .B(n74), .S(b[2]), .Z(n109) );
  INV_X1 U129 ( .A(a[2]), .ZN(n108) );
  AOI21_X1 U130 ( .B1(n109), .B2(n150), .A(n108), .ZN(n110) );
  AOI221_X1 U131 ( .B1(N89), .B2(n84), .C1(N81), .C2(n85), .A(n110), .ZN(n115)
         );
  NOR2_X1 U132 ( .A1(n67), .A2(n149), .ZN(n112) );
  OAI21_X1 U133 ( .B1(a[2]), .B2(n71), .A(n150), .ZN(n111) );
  MUX2_X1 U134 ( .A(n112), .B(n111), .S(b[2]), .Z(n113) );
  AOI21_X1 U135 ( .B1(N73), .B2(n83), .A(n113), .ZN(n114) );
  NAND2_X1 U136 ( .A1(n115), .A2(n114), .ZN(sum[2]) );
  MUX2_X1 U137 ( .A(n70), .B(n74), .S(b[3]), .Z(n117) );
  INV_X1 U138 ( .A(a[3]), .ZN(n116) );
  AOI21_X1 U139 ( .B1(n117), .B2(n150), .A(n116), .ZN(n118) );
  AOI221_X1 U140 ( .B1(N90), .B2(n84), .C1(N82), .C2(n85), .A(n118), .ZN(n123)
         );
  NOR2_X1 U141 ( .A1(a[3]), .A2(n149), .ZN(n120) );
  OAI21_X1 U142 ( .B1(a[3]), .B2(n71), .A(n150), .ZN(n119) );
  MUX2_X1 U143 ( .A(n120), .B(n119), .S(b[3]), .Z(n121) );
  AOI21_X1 U144 ( .B1(N74), .B2(n83), .A(n121), .ZN(n122) );
  NAND2_X1 U145 ( .A1(n123), .A2(n122), .ZN(sum[3]) );
  MUX2_X1 U146 ( .A(n70), .B(n74), .S(b[4]), .Z(n125) );
  INV_X1 U147 ( .A(a[4]), .ZN(n124) );
  AOI21_X1 U148 ( .B1(n125), .B2(n73), .A(n124), .ZN(n126) );
  AOI221_X1 U149 ( .B1(N91), .B2(n84), .C1(N83), .C2(n85), .A(n126), .ZN(n131)
         );
  NOR2_X1 U150 ( .A1(n86), .A2(n149), .ZN(n128) );
  OAI21_X1 U151 ( .B1(n86), .B2(n71), .A(n150), .ZN(n127) );
  MUX2_X1 U152 ( .A(n128), .B(n127), .S(b[4]), .Z(n129) );
  AOI21_X1 U153 ( .B1(N75), .B2(n83), .A(n129), .ZN(n130) );
  NAND2_X1 U154 ( .A1(n131), .A2(n130), .ZN(sum[4]) );
  AOI22_X1 U155 ( .A1(N84), .A2(n85), .B1(N92), .B2(n84), .ZN(n138) );
  MUX2_X1 U156 ( .A(n71), .B(n74), .S(b[5]), .Z(n132) );
  NAND2_X1 U157 ( .A1(n132), .A2(n73), .ZN(n136) );
  NOR2_X1 U158 ( .A1(n87), .A2(n149), .ZN(n134) );
  OAI21_X1 U159 ( .B1(a[5]), .B2(n70), .A(n150), .ZN(n133) );
  MUX2_X1 U160 ( .A(n134), .B(n133), .S(b[5]), .Z(n135) );
  NAND2_X1 U161 ( .A1(n138), .A2(n137), .ZN(sum[5]) );
  MUX2_X1 U162 ( .A(n151), .B(n74), .S(b[6]), .Z(n139) );
  MUX2_X1 U163 ( .A(n142), .B(n141), .S(b[6]), .Z(n143) );
  MUX2_X1 U164 ( .A(n70), .B(n74), .S(b[7]), .Z(n148) );
  NAND2_X1 U165 ( .A1(n148), .A2(n73), .ZN(n155) );
  NOR2_X1 U166 ( .A1(n74), .A2(n88), .ZN(n153) );
  OAI21_X1 U167 ( .B1(a[7]), .B2(n151), .A(n150), .ZN(n152) );
  MUX2_X1 U168 ( .A(n153), .B(n152), .S(b[7]), .Z(n154) );
  AOI221_X1 U169 ( .B1(N78), .B2(n83), .C1(a[7]), .C2(n155), .A(n154), .ZN(
        n156) );
  INV_X1 add_11_U91 ( .A(add_11_n79), .ZN(add_11_n78) );
  INV_X1 add_11_U90 ( .A(add_11_n17), .ZN(add_11_n30) );
  INV_X1 add_11_U89 ( .A(add_11_n74), .ZN(add_11_n71) );
  INV_X1 add_11_U88 ( .A(add_11_n18), .ZN(add_11_n72) );
  OAI21_X1 add_11_U87 ( .B1(add_11_n71), .B2(add_11_n72), .A(add_11_n73), .ZN(
        add_11_n69) );
  XNOR2_X1 add_11_U86 ( .A(add_11_n69), .B(add_11_n70), .ZN(N74) );
  NAND2_X1 add_11_U85 ( .A1(a[2]), .A2(b[2]), .ZN(add_11_n68) );
  INV_X1 add_11_U84 ( .A(add_11_n58), .ZN(add_11_n57) );
  INV_X1 add_11_U83 ( .A(add_11_n49), .ZN(add_11_n55) );
  INV_X1 add_11_U82 ( .A(add_11_n6), .ZN(add_11_n46) );
  INV_X1 add_11_U81 ( .A(add_11_n33), .ZN(add_11_n47) );
  OAI21_X1 add_11_U80 ( .B1(add_11_n46), .B2(add_11_n19), .A(add_11_n47), .ZN(
        add_11_n44) );
  XNOR2_X1 add_11_U79 ( .A(add_11_n44), .B(add_11_n45), .ZN(N77) );
  NAND3_X1 add_11_U78 ( .A1(add_11_n42), .A2(add_11_n21), .A3(add_11_n43), 
        .ZN(add_11_n41) );
  INV_X1 add_11_U77 ( .A(add_11_n36), .ZN(add_11_n35) );
  NAND4_X1 add_11_U76 ( .A1(add_11_n27), .A2(add_11_n16), .A3(add_11_n28), 
        .A4(add_11_n3), .ZN(add_11_n26) );
  XNOR2_X1 add_11_U75 ( .A(add_11_n22), .B(add_11_n23), .ZN(N78) );
  NAND2_X1 add_11_U74 ( .A1(add_11_n10), .A2(add_11_n34), .ZN(add_11_n40) );
  NAND2_X1 add_11_U73 ( .A1(add_11_n51), .A2(add_11_n50), .ZN(add_11_n37) );
  NOR2_X1 add_11_U72 ( .A1(add_11_n40), .A2(add_11_n37), .ZN(add_11_n39) );
  NOR2_X1 add_11_U71 ( .A1(add_11_n41), .A2(add_11_n20), .ZN(add_11_n38) );
  NOR2_X1 add_11_U70 ( .A1(add_11_n38), .A2(add_11_n39), .ZN(add_11_n24) );
  NAND2_X1 add_11_U69 ( .A1(add_11_n76), .A2(add_11_n77), .ZN(add_11_n65) );
  NAND2_X1 add_11_U68 ( .A1(add_11_n73), .A2(add_11_n18), .ZN(add_11_n75) );
  NAND2_X1 add_11_U67 ( .A1(add_11_n65), .A2(add_11_n66), .ZN(add_11_n32) );
  NAND2_X1 add_11_U66 ( .A1(add_11_n9), .A2(add_11_n8), .ZN(add_11_n34) );
  AND2_X1 add_11_U65 ( .A1(add_11_n62), .A2(add_11_n31), .ZN(add_11_n28) );
  XNOR2_X1 add_11_U64 ( .A(add_11_n53), .B(add_11_n54), .ZN(N76) );
  AOI21_X1 add_11_U63 ( .B1(add_11_n52), .B2(add_11_n31), .A(add_11_n57), .ZN(
        add_11_n53) );
  CLKBUF_X1 add_11_U62 ( .A(add_11_n20), .Z(add_11_n19) );
  INV_X1 add_11_U61 ( .A(a[2]), .ZN(add_11_n77) );
  NAND2_X1 add_11_U60 ( .A1(add_11_n76), .A2(add_11_n77), .ZN(add_11_n18) );
  AND2_X1 add_11_U59 ( .A1(add_11_n56), .A2(add_11_n15), .ZN(add_11_n27) );
  INV_X1 add_11_U58 ( .A(b[1]), .ZN(add_11_n81) );
  NAND2_X1 add_11_U57 ( .A1(add_11_n81), .A2(add_11_n82), .ZN(add_11_n62) );
  NAND2_X1 add_11_U56 ( .A1(add_11_n81), .A2(add_11_n82), .ZN(add_11_n17) );
  AND2_X1 add_11_U55 ( .A1(add_11_n65), .A2(add_11_n66), .ZN(add_11_n16) );
  NAND2_X1 add_11_U54 ( .A1(add_11_n36), .A2(add_11_n13), .ZN(add_11_n45) );
  AOI21_X1 add_11_U53 ( .B1(add_11_n33), .B2(add_11_n13), .A(add_11_n35), .ZN(
        add_11_n25) );
  NAND2_X1 add_11_U52 ( .A1(add_11_n67), .A2(add_11_n42), .ZN(add_11_n70) );
  OR2_X1 add_11_U51 ( .A1(b[4]), .A2(a[4]), .ZN(add_11_n51) );
  NOR2_X1 add_11_U50 ( .A1(b[3]), .A2(a[3]), .ZN(add_11_n14) );
  OR2_X1 add_11_U49 ( .A1(b[5]), .A2(a[5]), .ZN(add_11_n50) );
  NOR2_X1 add_11_U48 ( .A1(b[4]), .A2(a[4]), .ZN(add_11_n12) );
  NOR2_X1 add_11_U47 ( .A1(b[5]), .A2(a[5]), .ZN(add_11_n11) );
  NAND2_X1 add_11_U46 ( .A1(b[0]), .A2(a[0]), .ZN(add_11_n64) );
  INV_X1 add_11_U45 ( .A(b[6]), .ZN(add_11_n9) );
  OR2_X1 add_11_U44 ( .A1(b[6]), .A2(a[6]), .ZN(add_11_n21) );
  INV_X1 add_11_U43 ( .A(a[6]), .ZN(add_11_n8) );
  OAI211_X1 add_11_U42 ( .C1(a[5]), .C2(b[5]), .A(a[4]), .B(b[4]), .ZN(
        add_11_n48) );
  NAND2_X1 add_11_U41 ( .A1(b[5]), .A2(a[5]), .ZN(add_11_n49) );
  NOR2_X1 add_11_U40 ( .A1(add_11_n11), .A2(add_11_n55), .ZN(add_11_n54) );
  NAND2_X1 add_11_U39 ( .A1(add_11_n48), .A2(add_11_n49), .ZN(add_11_n33) );
  NAND3_X1 add_11_U38 ( .A1(add_11_n24), .A2(add_11_n25), .A3(add_11_n26), 
        .ZN(add_11_n22) );
  OR2_X1 add_11_U37 ( .A1(b[0]), .A2(a[0]), .ZN(add_11_n83) );
  NAND2_X1 add_11_U36 ( .A1(b[2]), .A2(a[2]), .ZN(add_11_n73) );
  NAND2_X1 add_11_U35 ( .A1(b[4]), .A2(a[4]), .ZN(add_11_n58) );
  XNOR2_X1 add_11_U34 ( .A(b[7]), .B(a[7]), .ZN(add_11_n23) );
  OR2_X1 add_11_U33 ( .A1(b[6]), .A2(a[6]), .ZN(add_11_n13) );
  OR2_X1 add_11_U32 ( .A1(b[5]), .A2(a[5]), .ZN(add_11_n56) );
  OR2_X1 add_11_U31 ( .A1(a[6]), .A2(b[6]), .ZN(add_11_n15) );
  NAND2_X1 add_11_U30 ( .A1(b[6]), .A2(a[6]), .ZN(add_11_n36) );
  OR2_X1 add_11_U29 ( .A1(b[3]), .A2(a[3]), .ZN(add_11_n66) );
  INV_X1 add_11_U28 ( .A(b[2]), .ZN(add_11_n76) );
  INV_X1 add_11_U27 ( .A(a[1]), .ZN(add_11_n82) );
  AND2_X1 add_11_U26 ( .A1(b[3]), .A2(a[3]), .ZN(add_11_n10) );
  OR2_X1 add_11_U25 ( .A1(add_11_n11), .A2(add_11_n12), .ZN(add_11_n20) );
  NAND2_X1 add_11_U24 ( .A1(b[1]), .A2(a[1]), .ZN(add_11_n63) );
  AND2_X1 add_11_U23 ( .A1(b[2]), .A2(a[2]), .ZN(add_11_n43) );
  INV_X1 add_11_U22 ( .A(add_11_n10), .ZN(add_11_n67) );
  NAND2_X1 add_11_U21 ( .A1(add_11_n17), .A2(add_11_n5), .ZN(add_11_n80) );
  XNOR2_X1 add_11_U20 ( .A(add_11_n79), .B(add_11_n80), .ZN(N72) );
  XNOR2_X1 add_11_U19 ( .A(add_11_n74), .B(add_11_n75), .ZN(N73) );
  INV_X1 add_11_U18 ( .A(add_11_n64), .ZN(add_11_n79) );
  OAI21_X1 add_11_U17 ( .B1(add_11_n78), .B2(add_11_n30), .A(add_11_n5), .ZN(
        add_11_n74) );
  NAND2_X1 add_11_U16 ( .A1(add_11_n58), .A2(add_11_n31), .ZN(add_11_n59) );
  XNOR2_X1 add_11_U15 ( .A(add_11_n6), .B(add_11_n59), .ZN(N75) );
  NAND2_X1 add_11_U14 ( .A1(add_11_n29), .A2(add_11_n62), .ZN(add_11_n61) );
  NOR2_X1 add_11_U13 ( .A1(add_11_n61), .A2(add_11_n32), .ZN(add_11_n60) );
  NAND2_X1 add_11_U12 ( .A1(add_11_n63), .A2(add_11_n64), .ZN(add_11_n29) );
  OR2_X1 add_11_U11 ( .A1(add_11_n14), .A2(add_11_n68), .ZN(add_11_n7) );
  OR2_X1 add_11_U10 ( .A1(b[4]), .A2(a[4]), .ZN(add_11_n31) );
  BUF_X1 add_11_U9 ( .A(add_11_n63), .Z(add_11_n5) );
  NAND2_X1 add_11_U8 ( .A1(add_11_n7), .A2(add_11_n67), .ZN(add_11_n4) );
  OR2_X1 add_11_U7 ( .A1(add_11_n60), .A2(add_11_n4), .ZN(add_11_n6) );
  CLKBUF_X1 add_11_U6 ( .A(add_11_n29), .Z(add_11_n3) );
  NAND2_X1 add_11_U5 ( .A1(add_11_n7), .A2(add_11_n67), .ZN(add_11_n2) );
  OR2_X1 add_11_U4 ( .A1(add_11_n60), .A2(add_11_n2), .ZN(add_11_n52) );
  AND2_X1 add_11_U3 ( .A1(add_11_n83), .A2(add_11_n78), .ZN(N71) );
  OR2_X2 add_11_U2 ( .A1(a[3]), .A2(b[3]), .ZN(add_11_n42) );
  INV_X1 sub_13_U104 ( .A(sub_13_n94), .ZN(sub_13_n95) );
  INV_X1 sub_13_U103 ( .A(sub_13_n73), .ZN(sub_13_n35) );
  NOR2_X1 sub_13_U102 ( .A1(sub_13_n21), .A2(sub_13_n13), .ZN(sub_13_n76) );
  NOR2_X1 sub_13_U101 ( .A1(sub_13_n19), .A2(sub_13_n74), .ZN(sub_13_n65) );
  INV_X1 sub_13_U100 ( .A(sub_13_n61), .ZN(sub_13_n60) );
  INV_X1 sub_13_U99 ( .A(sub_13_n6), .ZN(sub_13_n55) );
  INV_X1 sub_13_U98 ( .A(sub_13_n49), .ZN(sub_13_n56) );
  NOR2_X1 sub_13_U97 ( .A1(sub_13_n55), .A2(sub_13_n56), .ZN(sub_13_n54) );
  NAND3_X1 sub_13_U96 ( .A1(sub_13_n51), .A2(sub_13_n50), .A3(sub_13_n5), .ZN(
        sub_13_n48) );
  INV_X1 sub_13_U95 ( .A(sub_13_n45), .ZN(sub_13_n32) );
  NAND2_X1 sub_13_U94 ( .A1(sub_13_n15), .A2(sub_13_n32), .ZN(sub_13_n42) );
  NAND3_X1 sub_13_U93 ( .A1(sub_13_n43), .A2(sub_13_n42), .A3(sub_13_n41), 
        .ZN(sub_13_n37) );
  XNOR2_X1 sub_13_U92 ( .A(sub_13_n37), .B(sub_13_n38), .ZN(N93) );
  NOR2_X1 sub_13_U91 ( .A1(sub_13_n34), .A2(sub_13_n15), .ZN(sub_13_n30) );
  NAND2_X1 sub_13_U90 ( .A1(sub_13_n32), .A2(sub_13_n29), .ZN(sub_13_n31) );
  XNOR2_X1 sub_13_U89 ( .A(sub_13_n53), .B(sub_13_n54), .ZN(N92) );
  NOR3_X1 sub_13_U88 ( .A1(sub_13_n45), .A2(sub_13_n35), .A3(sub_13_n36), .ZN(
        sub_13_n47) );
  NOR2_X1 sub_13_U87 ( .A1(sub_13_n9), .A2(sub_13_n36), .ZN(sub_13_n74) );
  NOR2_X1 sub_13_U86 ( .A1(sub_13_n35), .A2(sub_13_n36), .ZN(sub_13_n34) );
  NAND2_X1 sub_13_U85 ( .A1(a[3]), .A2(sub_13_n80), .ZN(sub_13_n73) );
  INV_X1 sub_13_U84 ( .A(b[3]), .ZN(sub_13_n80) );
  AOI21_X1 sub_13_U83 ( .B1(sub_13_n30), .B2(sub_13_n66), .A(sub_13_n31), .ZN(
        sub_13_n24) );
  AOI21_X1 sub_13_U82 ( .B1(sub_13_n32), .B2(sub_13_n33), .A(sub_13_n44), .ZN(
        sub_13_n43) );
  NOR2_X1 sub_13_U81 ( .A1(sub_13_n24), .A2(sub_13_n25), .ZN(sub_13_n23) );
  XNOR2_X1 sub_13_U80 ( .A(sub_13_n1), .B(sub_13_n62), .ZN(N91) );
  XNOR2_X1 sub_13_U79 ( .A(sub_13_n23), .B(sub_13_n22), .ZN(N94) );
  NAND2_X1 sub_13_U78 ( .A1(sub_13_n65), .A2(sub_13_n66), .ZN(sub_13_n59) );
  AOI21_X1 sub_13_U77 ( .B1(sub_13_n59), .B2(sub_13_n7), .A(sub_13_n60), .ZN(
        sub_13_n53) );
  NAND2_X1 sub_13_U76 ( .A1(a[0]), .A2(sub_13_n89), .ZN(sub_13_n88) );
  INV_X1 sub_13_U75 ( .A(a[0]), .ZN(sub_13_n70) );
  INV_X1 sub_13_U74 ( .A(a[5]), .ZN(sub_13_n57) );
  NAND2_X1 sub_13_U73 ( .A1(sub_13_n58), .A2(a[5]), .ZN(sub_13_n51) );
  NOR2_X1 sub_13_U72 ( .A1(sub_13_n45), .A2(sub_13_n46), .ZN(sub_13_n44) );
  NAND2_X1 sub_13_U71 ( .A1(sub_13_n48), .A2(sub_13_n49), .ZN(sub_13_n28) );
  NAND2_X1 sub_13_U70 ( .A1(b[5]), .A2(sub_13_n57), .ZN(sub_13_n49) );
  NAND2_X1 sub_13_U69 ( .A1(sub_13_n51), .A2(sub_13_n52), .ZN(sub_13_n45) );
  XNOR2_X1 sub_13_U68 ( .A(a[7]), .B(b[7]), .ZN(sub_13_n22) );
  INV_X1 sub_13_U67 ( .A(a[4]), .ZN(sub_13_n64) );
  NAND2_X1 sub_13_U66 ( .A1(sub_13_n5), .A2(sub_13_n64), .ZN(sub_13_n61) );
  INV_X1 sub_13_U65 ( .A(a[6]), .ZN(sub_13_n40) );
  NAND2_X1 sub_13_U64 ( .A1(b[6]), .A2(sub_13_n40), .ZN(sub_13_n27) );
  NAND2_X1 sub_13_U63 ( .A1(b[0]), .A2(sub_13_n70), .ZN(sub_13_n94) );
  NAND2_X1 sub_13_U62 ( .A1(b[2]), .A2(sub_13_n75), .ZN(sub_13_n82) );
  NOR2_X1 sub_13_U61 ( .A1(b[0]), .A2(sub_13_n70), .ZN(sub_13_n93) );
  NAND2_X1 sub_13_U60 ( .A1(sub_13_n8), .A2(sub_13_n87), .ZN(sub_13_n91) );
  NAND2_X1 sub_13_U59 ( .A1(sub_13_n93), .A2(sub_13_n94), .ZN(sub_13_n90) );
  XNOR2_X1 sub_13_U58 ( .A(sub_13_n90), .B(sub_13_n91), .ZN(N88) );
  INV_X1 sub_13_U57 ( .A(b[6]), .ZN(sub_13_n39) );
  NAND2_X1 sub_13_U56 ( .A1(a[6]), .A2(sub_13_n39), .ZN(sub_13_n29) );
  INV_X1 sub_13_U55 ( .A(a[3]), .ZN(sub_13_n81) );
  NAND2_X1 sub_13_U54 ( .A1(b[3]), .A2(sub_13_n81), .ZN(sub_13_n46) );
  INV_X1 sub_13_U53 ( .A(a[2]), .ZN(sub_13_n75) );
  NAND2_X1 sub_13_U52 ( .A1(b[2]), .A2(sub_13_n75), .ZN(sub_13_n36) );
  INV_X1 sub_13_U51 ( .A(a[4]), .ZN(sub_13_n50) );
  INV_X1 sub_13_U50 ( .A(b[5]), .ZN(sub_13_n58) );
  INV_X1 sub_13_U49 ( .A(b[4]), .ZN(sub_13_n63) );
  NAND2_X1 sub_13_U48 ( .A1(sub_13_n63), .A2(a[4]), .ZN(sub_13_n52) );
  INV_X1 sub_13_U47 ( .A(b[2]), .ZN(sub_13_n85) );
  NAND2_X1 sub_13_U46 ( .A1(a[2]), .A2(sub_13_n85), .ZN(sub_13_n72) );
  NAND2_X1 sub_13_U45 ( .A1(sub_13_n77), .A2(sub_13_n88), .ZN(sub_13_n86) );
  NAND2_X1 sub_13_U44 ( .A1(sub_13_n86), .A2(sub_13_n87), .ZN(sub_13_n84) );
  INV_X1 sub_13_U43 ( .A(b[0]), .ZN(sub_13_n89) );
  AND2_X1 sub_13_U42 ( .A1(sub_13_n11), .A2(a[0]), .ZN(sub_13_n21) );
  INV_X1 sub_13_U41 ( .A(a[1]), .ZN(sub_13_n71) );
  INV_X1 sub_13_U40 ( .A(b[1]), .ZN(sub_13_n92) );
  NAND2_X1 sub_13_U39 ( .A1(sub_13_n2), .A2(a[1]), .ZN(sub_13_n77) );
  NAND2_X1 sub_13_U38 ( .A1(sub_13_n17), .A2(b[0]), .ZN(sub_13_n69) );
  NAND2_X1 sub_13_U37 ( .A1(sub_13_n16), .A2(b[1]), .ZN(sub_13_n68) );
  NAND2_X1 sub_13_U36 ( .A1(sub_13_n68), .A2(sub_13_n69), .ZN(sub_13_n67) );
  OR2_X1 sub_13_U35 ( .A1(sub_13_n14), .A2(sub_13_n95), .ZN(N87) );
  NAND2_X1 sub_13_U34 ( .A1(sub_13_n84), .A2(sub_13_n10), .ZN(sub_13_n83) );
  NAND2_X1 sub_13_U33 ( .A1(sub_13_n83), .A2(sub_13_n82), .ZN(sub_13_n78) );
  NAND2_X1 sub_13_U32 ( .A1(sub_13_n73), .A2(sub_13_n46), .ZN(sub_13_n79) );
  XNOR2_X1 sub_13_U31 ( .A(sub_13_n78), .B(sub_13_n79), .ZN(N90) );
  NOR2_X1 sub_13_U30 ( .A1(sub_13_n47), .A2(sub_13_n28), .ZN(sub_13_n41) );
  NAND2_X1 sub_13_U29 ( .A1(sub_13_n27), .A2(sub_13_n29), .ZN(sub_13_n38) );
  NAND2_X1 sub_13_U28 ( .A1(sub_13_n28), .A2(sub_13_n29), .ZN(sub_13_n26) );
  NAND2_X1 sub_13_U27 ( .A1(sub_13_n26), .A2(sub_13_n27), .ZN(sub_13_n25) );
  NAND2_X1 sub_13_U26 ( .A1(sub_13_n61), .A2(sub_13_n52), .ZN(sub_13_n62) );
  AND2_X1 sub_13_U25 ( .A1(sub_13_n82), .A2(sub_13_n72), .ZN(sub_13_n18) );
  XOR2_X1 sub_13_U24 ( .A(sub_13_n84), .B(sub_13_n18), .Z(N89) );
  INV_X1 sub_13_U23 ( .A(a[0]), .ZN(sub_13_n17) );
  INV_X1 sub_13_U22 ( .A(a[1]), .ZN(sub_13_n16) );
  AND3_X1 sub_13_U21 ( .A1(sub_13_n76), .A2(sub_13_n72), .A3(sub_13_n73), .ZN(
        sub_13_n19) );
  AND3_X1 sub_13_U20 ( .A1(sub_13_n76), .A2(sub_13_n72), .A3(sub_13_n73), .ZN(
        sub_13_n15) );
  INV_X1 sub_13_U19 ( .A(sub_13_n88), .ZN(sub_13_n14) );
  NOR2_X1 sub_13_U18 ( .A1(sub_13_n71), .A2(b[1]), .ZN(sub_13_n13) );
  NAND2_X1 sub_13_U17 ( .A1(a[3]), .A2(sub_13_n3), .ZN(sub_13_n12) );
  INV_X1 sub_13_U16 ( .A(b[0]), .ZN(sub_13_n11) );
  CLKBUF_X1 sub_13_U15 ( .A(sub_13_n72), .Z(sub_13_n10) );
  INV_X1 sub_13_U14 ( .A(sub_13_n12), .ZN(sub_13_n9) );
  AND4_X1 sub_13_U13 ( .A1(sub_13_n72), .A2(sub_13_n77), .A3(sub_13_n67), .A4(
        sub_13_n12), .ZN(sub_13_n33) );
  CLKBUF_X1 sub_13_U12 ( .A(sub_13_n52), .Z(sub_13_n7) );
  BUF_X1 sub_13_U11 ( .A(b[4]), .Z(sub_13_n5) );
  CLKBUF_X1 sub_13_U10 ( .A(sub_13_n51), .Z(sub_13_n6) );
  CLKBUF_X1 sub_13_U9 ( .A(sub_13_n77), .Z(sub_13_n8) );
  OR2_X1 sub_13_U8 ( .A1(sub_13_n92), .A2(a[1]), .ZN(sub_13_n87) );
  NAND4_X1 sub_13_U7 ( .A1(sub_13_n67), .A2(sub_13_n72), .A3(sub_13_n12), .A4(
        sub_13_n77), .ZN(sub_13_n4) );
  AND2_X1 sub_13_U6 ( .A1(sub_13_n4), .A2(sub_13_n46), .ZN(sub_13_n66) );
  INV_X1 sub_13_U5 ( .A(b[3]), .ZN(sub_13_n3) );
  INV_X1 sub_13_U4 ( .A(b[1]), .ZN(sub_13_n2) );
  NAND2_X1 sub_13_U3 ( .A1(sub_13_n65), .A2(sub_13_n66), .ZN(sub_13_n1) );
  INV_X1 sub_12_U112 ( .A(sub_12_n93), .ZN(sub_12_n86) );
  INV_X1 sub_12_U111 ( .A(sub_12_n32), .ZN(sub_12_n80) );
  NOR2_X1 sub_12_U110 ( .A1(sub_12_n1), .A2(sub_12_n80), .ZN(sub_12_n90) );
  NAND3_X1 sub_12_U109 ( .A1(sub_12_n31), .A2(sub_12_n30), .A3(sub_12_n35), 
        .ZN(sub_12_n88) );
  NOR2_X1 sub_12_U108 ( .A1(sub_12_n2), .A2(sub_12_n69), .ZN(sub_12_n76) );
  INV_X1 sub_12_U107 ( .A(sub_12_n72), .ZN(sub_12_n82) );
  INV_X1 sub_12_U106 ( .A(sub_12_n55), .ZN(sub_12_n16) );
  INV_X1 sub_12_U105 ( .A(sub_12_n31), .ZN(sub_12_n81) );
  NOR2_X1 sub_12_U104 ( .A1(sub_12_n80), .A2(sub_12_n81), .ZN(sub_12_n79) );
  INV_X1 sub_12_U103 ( .A(sub_12_n50), .ZN(sub_12_n66) );
  NAND2_X1 sub_12_U102 ( .A1(sub_12_n53), .A2(sub_12_n54), .ZN(sub_12_n52) );
  INV_X1 sub_12_U101 ( .A(sub_12_n33), .ZN(sub_12_n14) );
  NAND2_X1 sub_12_U100 ( .A1(sub_12_n14), .A2(sub_12_n32), .ZN(sub_12_n44) );
  INV_X1 sub_12_U99 ( .A(sub_12_n49), .ZN(sub_12_n46) );
  INV_X1 sub_12_U98 ( .A(sub_12_n24), .ZN(sub_12_n45) );
  XNOR2_X1 sub_12_U97 ( .A(sub_12_n39), .B(sub_12_n40), .ZN(N85) );
  INV_X1 sub_12_U96 ( .A(sub_12_n25), .ZN(sub_12_n17) );
  NAND2_X1 sub_12_U95 ( .A1(sub_12_n28), .A2(sub_12_n29), .ZN(sub_12_n10) );
  INV_X1 sub_12_U94 ( .A(sub_12_n27), .ZN(sub_12_n26) );
  NAND3_X1 sub_12_U93 ( .A1(sub_12_n13), .A2(sub_12_n14), .A3(sub_12_n15), 
        .ZN(sub_12_n12) );
  NAND4_X1 sub_12_U92 ( .A1(sub_12_n9), .A2(sub_12_n10), .A3(sub_12_n11), .A4(
        sub_12_n12), .ZN(sub_12_n8) );
  XNOR2_X1 sub_12_U91 ( .A(sub_12_n8), .B(sub_12_n7), .ZN(N86) );
  NAND4_X1 sub_12_U90 ( .A1(a[0]), .A2(sub_12_n55), .A3(sub_12_n31), .A4(
        sub_12_n56), .ZN(sub_12_n54) );
  NAND2_X1 sub_12_U89 ( .A1(a[0]), .A2(sub_12_n56), .ZN(sub_12_n84) );
  NAND2_X1 sub_12_U88 ( .A1(a[0]), .A2(sub_12_n56), .ZN(sub_12_n21) );
  INV_X1 sub_12_U87 ( .A(a[0]), .ZN(sub_12_n98) );
  INV_X1 sub_12_U86 ( .A(a[5]), .ZN(sub_12_n64) );
  NAND2_X1 sub_12_U85 ( .A1(a[5]), .A2(sub_12_n65), .ZN(sub_12_n48) );
  NAND2_X1 sub_12_U84 ( .A1(sub_12_n49), .A2(sub_12_n50), .ZN(sub_12_n33) );
  XNOR2_X1 sub_12_U83 ( .A(sub_12_n62), .B(sub_12_n63), .ZN(N84) );
  AOI21_X1 sub_12_U82 ( .B1(sub_12_n24), .B2(sub_12_n25), .A(sub_12_n26), .ZN(
        sub_12_n11) );
  NAND2_X1 sub_12_U81 ( .A1(b[5]), .A2(sub_12_n64), .ZN(sub_12_n49) );
  NAND2_X1 sub_12_U80 ( .A1(sub_12_n48), .A2(sub_12_n49), .ZN(sub_12_n63) );
  OAI21_X1 sub_12_U79 ( .B1(sub_12_n46), .B2(sub_12_n47), .A(sub_12_n48), .ZN(
        sub_12_n24) );
  NAND3_X1 sub_12_U78 ( .A1(sub_12_n57), .A2(sub_12_n31), .A3(sub_12_n30), 
        .ZN(sub_12_n53) );
  XOR2_X1 sub_12_U77 ( .A(b[7]), .B(a[7]), .Z(sub_12_n7) );
  NAND2_X1 sub_12_U76 ( .A1(b[0]), .A2(sub_12_n98), .ZN(sub_12_n97) );
  INV_X1 sub_12_U75 ( .A(b[5]), .ZN(sub_12_n65) );
  INV_X1 sub_12_U74 ( .A(b[6]), .ZN(sub_12_n42) );
  NAND2_X1 sub_12_U73 ( .A1(a[6]), .A2(sub_12_n42), .ZN(sub_12_n27) );
  INV_X1 sub_12_U72 ( .A(b[4]), .ZN(sub_12_n75) );
  NAND2_X1 sub_12_U71 ( .A1(a[4]), .A2(sub_12_n75), .ZN(sub_12_n47) );
  NOR2_X1 sub_12_U70 ( .A1(a[2]), .A2(sub_12_n23), .ZN(sub_12_n22) );
  AOI21_X1 sub_12_U69 ( .B1(sub_12_n20), .B2(sub_12_n21), .A(sub_12_n22), .ZN(
        sub_12_n13) );
  NAND2_X1 sub_12_U68 ( .A1(a[1]), .A2(sub_12_n85), .ZN(sub_12_n20) );
  NAND2_X1 sub_12_U67 ( .A1(b[1]), .A2(sub_12_n61), .ZN(sub_12_n57) );
  NAND2_X1 sub_12_U66 ( .A1(b[0]), .A2(sub_12_n98), .ZN(sub_12_n30) );
  INV_X1 sub_12_U65 ( .A(b[0]), .ZN(sub_12_n56) );
  NAND2_X1 sub_12_U64 ( .A1(b[1]), .A2(sub_12_n61), .ZN(sub_12_n35) );
  NAND2_X1 sub_12_U63 ( .A1(b[1]), .A2(sub_12_n61), .ZN(sub_12_n55) );
  INV_X1 sub_12_U62 ( .A(a[1]), .ZN(sub_12_n61) );
  NOR2_X1 sub_12_U61 ( .A1(a[3]), .A2(sub_12_n19), .ZN(sub_12_n18) );
  NOR3_X1 sub_12_U60 ( .A1(sub_12_n16), .A2(sub_12_n17), .A3(sub_12_n18), .ZN(
        sub_12_n15) );
  INV_X1 sub_12_U59 ( .A(b[1]), .ZN(sub_12_n85) );
  NAND2_X1 sub_12_U58 ( .A1(a[1]), .A2(sub_12_n85), .ZN(sub_12_n83) );
  NAND2_X1 sub_12_U57 ( .A1(sub_12_n83), .A2(sub_12_n84), .ZN(sub_12_n72) );
  INV_X1 sub_12_U56 ( .A(a[2]), .ZN(sub_12_n95) );
  INV_X1 sub_12_U55 ( .A(a[3]), .ZN(sub_12_n91) );
  INV_X1 sub_12_U54 ( .A(a[4]), .ZN(sub_12_n74) );
  NAND2_X1 sub_12_U53 ( .A1(b[4]), .A2(sub_12_n74), .ZN(sub_12_n50) );
  INV_X1 sub_12_U52 ( .A(b[2]), .ZN(sub_12_n23) );
  NAND2_X1 sub_12_U51 ( .A1(a[2]), .A2(sub_12_n23), .ZN(sub_12_n93) );
  INV_X1 sub_12_U50 ( .A(a[6]), .ZN(sub_12_n41) );
  NAND2_X1 sub_12_U49 ( .A1(b[6]), .A2(sub_12_n41), .ZN(sub_12_n25) );
  NOR2_X1 sub_12_U48 ( .A1(b[1]), .A2(sub_12_n61), .ZN(sub_12_n60) );
  AOI21_X1 sub_12_U47 ( .B1(sub_12_n60), .B2(sub_12_n31), .A(sub_12_n1), .ZN(
        sub_12_n58) );
  NAND2_X1 sub_12_U46 ( .A1(sub_12_n58), .A2(sub_12_n59), .ZN(sub_12_n51) );
  INV_X1 sub_12_U45 ( .A(b[3]), .ZN(sub_12_n19) );
  NAND2_X1 sub_12_U44 ( .A1(sub_12_n27), .A2(sub_12_n25), .ZN(sub_12_n40) );
  AND2_X1 sub_12_U43 ( .A1(sub_12_n30), .A2(sub_12_n21), .ZN(sub_12_n102) );
  INV_X1 sub_12_U42 ( .A(sub_12_n97), .ZN(sub_12_n101) );
  NAND2_X1 sub_12_U41 ( .A1(sub_12_n101), .A2(sub_12_n21), .ZN(sub_12_n99) );
  NAND2_X1 sub_12_U40 ( .A1(sub_12_n57), .A2(sub_12_n20), .ZN(sub_12_n100) );
  XNOR2_X1 sub_12_U39 ( .A(sub_12_n99), .B(sub_12_n100), .ZN(N80) );
  NAND2_X1 sub_12_U38 ( .A1(sub_12_n4), .A2(sub_12_n93), .ZN(sub_12_n94) );
  XNOR2_X1 sub_12_U37 ( .A(sub_12_n92), .B(sub_12_n94), .ZN(N81) );
  NAND2_X1 sub_12_U36 ( .A1(sub_12_n97), .A2(sub_12_n57), .ZN(sub_12_n96) );
  NAND2_X1 sub_12_U35 ( .A1(sub_12_n96), .A2(sub_12_n20), .ZN(sub_12_n92) );
  AOI21_X1 sub_12_U34 ( .B1(sub_12_n4), .B2(sub_12_n92), .A(sub_12_n86), .ZN(
        sub_12_n89) );
  XNOR2_X1 sub_12_U33 ( .A(sub_12_n89), .B(sub_12_n90), .ZN(N82) );
  NAND2_X1 sub_12_U32 ( .A1(sub_12_n35), .A2(sub_12_n25), .ZN(sub_12_n34) );
  NOR2_X1 sub_12_U31 ( .A1(sub_12_n33), .A2(sub_12_n34), .ZN(sub_12_n28) );
  NOR2_X1 sub_12_U30 ( .A1(sub_12_n82), .A2(sub_12_n16), .ZN(sub_12_n78) );
  AOI21_X1 sub_12_U29 ( .B1(sub_12_n78), .B2(sub_12_n79), .A(sub_12_n1), .ZN(
        sub_12_n77) );
  NAND2_X1 sub_12_U28 ( .A1(sub_12_n77), .A2(sub_12_n76), .ZN(sub_12_n73) );
  AND2_X1 sub_12_U27 ( .A1(sub_12_n30), .A2(sub_12_n31), .ZN(sub_12_n6) );
  AND2_X1 sub_12_U26 ( .A1(sub_12_n32), .A2(sub_12_n6), .ZN(sub_12_n29) );
  OAI21_X1 sub_12_U25 ( .B1(sub_12_n67), .B2(sub_12_n66), .A(sub_12_n47), .ZN(
        sub_12_n62) );
  INV_X1 sub_12_U24 ( .A(sub_12_n32), .ZN(sub_12_n87) );
  NOR2_X1 sub_12_U23 ( .A1(sub_12_n87), .A2(sub_12_n88), .ZN(sub_12_n69) );
  NAND2_X1 sub_12_U22 ( .A1(sub_12_n55), .A2(sub_12_n72), .ZN(sub_12_n71) );
  NAND2_X1 sub_12_U21 ( .A1(sub_12_n31), .A2(sub_12_n32), .ZN(sub_12_n70) );
  OAI21_X1 sub_12_U20 ( .B1(sub_12_n70), .B2(sub_12_n71), .A(sub_12_n59), .ZN(
        sub_12_n68) );
  NOR3_X1 sub_12_U19 ( .A1(sub_12_n68), .A2(sub_12_n69), .A3(sub_12_n1), .ZN(
        sub_12_n67) );
  NAND2_X1 sub_12_U18 ( .A1(sub_12_n86), .A2(sub_12_n32), .ZN(sub_12_n59) );
  NOR3_X1 sub_12_U17 ( .A1(sub_12_n33), .A2(sub_12_n17), .A3(sub_12_n38), .ZN(
        sub_12_n37) );
  NOR2_X1 sub_12_U16 ( .A1(sub_12_n17), .A2(sub_12_n33), .ZN(sub_12_n36) );
  AOI21_X1 sub_12_U15 ( .B1(sub_12_n36), .B2(sub_12_n2), .A(sub_12_n37), .ZN(
        sub_12_n9) );
  NOR2_X1 sub_12_U14 ( .A1(sub_12_n51), .A2(sub_12_n52), .ZN(sub_12_n43) );
  OAI21_X1 sub_12_U13 ( .B1(sub_12_n43), .B2(sub_12_n44), .A(sub_12_n45), .ZN(
        sub_12_n39) );
  NAND2_X1 sub_12_U12 ( .A1(sub_12_n47), .A2(sub_12_n50), .ZN(sub_12_n5) );
  XNOR2_X1 sub_12_U11 ( .A(sub_12_n73), .B(sub_12_n5), .ZN(N83) );
  INV_X1 sub_12_U10 ( .A(sub_12_n81), .ZN(sub_12_n4) );
  INV_X1 sub_12_U9 ( .A(b[3]), .ZN(sub_12_n3) );
  AND2_X1 sub_12_U8 ( .A1(sub_12_n86), .A2(sub_12_n32), .ZN(sub_12_n2) );
  INV_X1 sub_12_U7 ( .A(sub_12_n102), .ZN(N79) );
  NAND2_X2 sub_12_U6 ( .A1(b[2]), .A2(sub_12_n95), .ZN(sub_12_n31) );
  NAND2_X2 sub_12_U5 ( .A1(b[3]), .A2(sub_12_n91), .ZN(sub_12_n32) );
  INV_X2 sub_12_U4 ( .A(sub_12_n1), .ZN(sub_12_n38) );
  AND2_X2 sub_12_U3 ( .A1(sub_12_n3), .A2(a[3]), .ZN(sub_12_n1) );
endmodule

