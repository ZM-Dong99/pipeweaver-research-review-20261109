/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 01:46:15 2025
/////////////////////////////////////////////////////////////


module sub_8bit ( a, b, diff, overflow );
  input [7:0] a;
  input [7:0] b;
  output [7:0] diff;
  output overflow;
  wire   n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46,
         n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
         n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74,
         n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88,
         n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
         n113, n114, n115, n116, n117, n118, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145,
         n146, n147, n148, n149, n150, n151, n152, n153, n154, n155, n156,
         n157, n158;

  XOR2_X1 U42 ( .A(b[1]), .B(a[1]), .Z(n33) );
  INV_X1 U43 ( .A(n84), .ZN(n34) );
  INV_X1 U44 ( .A(a[0]), .ZN(n35) );
  INV_X1 U45 ( .A(a[0]), .ZN(n36) );
  INV_X1 U46 ( .A(a[1]), .ZN(n37) );
  INV_X1 U47 ( .A(a[1]), .ZN(n38) );
  NOR2_X1 U48 ( .A1(b[1]), .A2(n38), .ZN(n64) );
  INV_X1 U49 ( .A(a[1]), .ZN(n39) );
  INV_X1 U50 ( .A(n124), .ZN(n40) );
  BUF_X1 U51 ( .A(n141), .Z(n41) );
  OAI211_X1 U52 ( .C1(n105), .C2(b[1]), .A(n103), .B(b[0]), .ZN(n42) );
  CLKBUF_X1 U53 ( .A(n81), .Z(n43) );
  INV_X1 U54 ( .A(a[5]), .ZN(n44) );
  INV_X1 U55 ( .A(a[5]), .ZN(n45) );
  AOI22_X1 U56 ( .A1(n37), .A2(b[1]), .B1(n79), .B2(b[2]), .ZN(n46) );
  CLKBUF_X1 U57 ( .A(n103), .Z(n47) );
  CLKBUF_X1 U58 ( .A(n125), .Z(n48) );
  OAI21_X1 U59 ( .B1(n90), .B2(n91), .A(n119), .ZN(n49) );
  OAI21_X1 U60 ( .B1(n90), .B2(n91), .A(n119), .ZN(n93) );
  OR2_X1 U61 ( .A1(n34), .A2(n50), .ZN(n69) );
  NAND2_X1 U62 ( .A1(b[6]), .A2(b[7]), .ZN(n50) );
  INV_X1 U63 ( .A(n60), .ZN(n51) );
  XOR2_X1 U64 ( .A(b[7]), .B(a[7]), .Z(n52) );
  NAND2_X1 U65 ( .A1(b[5]), .A2(n73), .ZN(n53) );
  INV_X1 U66 ( .A(n44), .ZN(n54) );
  INV_X1 U67 ( .A(a[6]), .ZN(n55) );
  INV_X1 U68 ( .A(a[6]), .ZN(n56) );
  INV_X1 U69 ( .A(a[2]), .ZN(n57) );
  NAND2_X1 U70 ( .A1(b[4]), .A2(n114), .ZN(n58) );
  AND2_X1 U71 ( .A1(n74), .A2(n76), .ZN(n59) );
  BUF_X1 U72 ( .A(n82), .Z(n76) );
  XOR2_X1 U73 ( .A(b[7]), .B(a[7]), .Z(n60) );
  AND2_X2 U74 ( .A1(n138), .A2(n137), .ZN(n74) );
  CLKBUF_X1 U75 ( .A(n148), .Z(n61) );
  AND2_X1 U76 ( .A1(n93), .A2(n94), .ZN(n151) );
  AND2_X1 U77 ( .A1(a[3]), .A2(n62), .ZN(n65) );
  INV_X1 U78 ( .A(b[3]), .ZN(n62) );
  OAI211_X1 U79 ( .C1(n63), .C2(b[1]), .A(n77), .B(b[0]), .ZN(n106) );
  INV_X1 U80 ( .A(a[1]), .ZN(n63) );
  NAND3_X1 U81 ( .A1(n134), .A2(n152), .A3(n74), .ZN(n156) );
  OAI22_X1 U82 ( .A1(n96), .A2(b[5]), .B1(n56), .B2(b[6]), .ZN(n81) );
  AOI22_X1 U83 ( .A1(n105), .A2(b[1]), .B1(n79), .B2(b[2]), .ZN(n92) );
  NAND3_X1 U84 ( .A1(n150), .A2(n49), .A3(n94), .ZN(n153) );
  NOR2_X1 U85 ( .A1(n108), .A2(b[2]), .ZN(n90) );
  OAI22_X1 U86 ( .A1(n73), .A2(b[5]), .B1(n95), .B2(b[6]), .ZN(n154) );
  AOI21_X1 U87 ( .B1(n55), .B2(b[6]), .A(b[7]), .ZN(n82) );
  NAND2_X1 U88 ( .A1(n138), .A2(n53), .ZN(n66) );
  NAND3_X1 U89 ( .A1(n134), .A2(n135), .A3(n67), .ZN(n143) );
  INV_X1 U90 ( .A(n66), .ZN(n67) );
  XNOR2_X1 U91 ( .A(a[4]), .B(b[4]), .ZN(n123) );
  NAND2_X1 U92 ( .A1(n81), .A2(n82), .ZN(n68) );
  AND3_X1 U93 ( .A1(n68), .A2(n69), .A3(n52), .ZN(n97) );
  NAND4_X1 U94 ( .A1(n155), .A2(n156), .A3(n157), .A4(n158), .ZN(diff[7]) );
  NOR2_X1 U95 ( .A1(n147), .A2(n146), .ZN(n158) );
  AND2_X1 U96 ( .A1(n106), .A2(n116), .ZN(n70) );
  NOR2_X1 U97 ( .A1(n61), .A2(n149), .ZN(n147) );
  INV_X1 U98 ( .A(n149), .ZN(n152) );
  NOR2_X1 U99 ( .A1(n60), .A2(n87), .ZN(n146) );
  XNOR2_X1 U100 ( .A(n130), .B(n71), .ZN(diff[5]) );
  XNOR2_X1 U101 ( .A(b[5]), .B(n54), .ZN(n71) );
  XNOR2_X1 U102 ( .A(n111), .B(n72), .ZN(diff[3]) );
  XNOR2_X1 U103 ( .A(b[3]), .B(a[3]), .ZN(n72) );
  XOR2_X1 U104 ( .A(b[6]), .B(n84), .Z(n141) );
  XNOR2_X1 U105 ( .A(n33), .B(n104), .ZN(diff[1]) );
  INV_X1 U106 ( .A(a[5]), .ZN(n73) );
  NAND2_X1 U107 ( .A1(b[3]), .A2(n86), .ZN(n75) );
  INV_X1 U108 ( .A(a[0]), .ZN(n77) );
  OAI211_X1 U109 ( .C1(a[3]), .C2(n62), .A(n92), .B(n106), .ZN(n78) );
  INV_X1 U110 ( .A(a[2]), .ZN(n79) );
  INV_X1 U111 ( .A(a[2]), .ZN(n108) );
  NOR2_X1 U112 ( .A1(n85), .A2(b[3]), .ZN(n91) );
  NOR2_X1 U113 ( .A1(b[2]), .A2(n57), .ZN(n80) );
  OAI21_X1 U114 ( .B1(n80), .B2(n65), .A(n75), .ZN(n83) );
  INV_X1 U115 ( .A(a[6]), .ZN(n84) );
  INV_X1 U116 ( .A(a[3]), .ZN(n85) );
  INV_X1 U117 ( .A(a[3]), .ZN(n86) );
  NAND2_X1 U118 ( .A1(b[6]), .A2(n84), .ZN(n87) );
  OR2_X1 U119 ( .A1(n153), .A2(n88), .ZN(n155) );
  OR2_X1 U120 ( .A1(n60), .A2(n43), .ZN(n88) );
  INV_X1 U121 ( .A(a[6]), .ZN(n95) );
  INV_X1 U122 ( .A(a[4]), .ZN(n114) );
  NAND2_X1 U123 ( .A1(b[4]), .A2(n114), .ZN(n138) );
  INV_X1 U124 ( .A(a[5]), .ZN(n96) );
  NAND2_X1 U125 ( .A1(b[5]), .A2(n45), .ZN(n137) );
  NAND2_X1 U126 ( .A1(n74), .A2(n76), .ZN(n98) );
  INV_X1 U127 ( .A(b[4]), .ZN(n89) );
  NAND2_X1 U128 ( .A1(a[4]), .A2(n89), .ZN(n94) );
  INV_X1 U129 ( .A(a[3]), .ZN(n113) );
  NAND2_X1 U130 ( .A1(n113), .A2(b[3]), .ZN(n119) );
  NAND2_X1 U131 ( .A1(n49), .A2(n94), .ZN(n132) );
  INV_X1 U132 ( .A(a[1]), .ZN(n105) );
  INV_X1 U133 ( .A(a[0]), .ZN(n103) );
  NAND2_X1 U134 ( .A1(n36), .A2(b[0]), .ZN(n118) );
  OAI211_X1 U135 ( .C1(a[3]), .C2(n62), .A(n42), .B(n46), .ZN(n150) );
  INV_X1 U136 ( .A(n78), .ZN(n129) );
  NAND2_X1 U137 ( .A1(n83), .A2(n94), .ZN(n128) );
  NOR2_X1 U138 ( .A1(n129), .A2(n128), .ZN(n102) );
  INV_X1 U139 ( .A(n154), .ZN(n148) );
  NAND2_X1 U140 ( .A1(b[7]), .A2(n148), .ZN(n99) );
  INV_X1 U141 ( .A(n99), .ZN(n101) );
  OAI221_X1 U142 ( .B1(n99), .B2(n74), .C1(n98), .C2(n150), .A(n97), .ZN(n100)
         );
  AOI221_X1 U143 ( .B1(n59), .B2(n132), .C1(n102), .C2(n101), .A(n100), .ZN(
        overflow) );
  NAND2_X1 U144 ( .A1(n35), .A2(b[0]), .ZN(n104) );
  OAI21_X1 U145 ( .B1(b[0]), .B2(n47), .A(n118), .ZN(diff[0]) );
  XOR2_X1 U146 ( .A(n108), .B(b[2]), .Z(n107) );
  NAND2_X1 U147 ( .A1(b[1]), .A2(n39), .ZN(n116) );
  XOR2_X1 U148 ( .A(n107), .B(n70), .Z(diff[2]) );
  NAND2_X1 U149 ( .A1(b[2]), .A2(n57), .ZN(n117) );
  INV_X1 U150 ( .A(b[2]), .ZN(n109) );
  NAND2_X1 U151 ( .A1(a[2]), .A2(n109), .ZN(n112) );
  INV_X1 U152 ( .A(n112), .ZN(n110) );
  AOI21_X1 U153 ( .B1(n70), .B2(n117), .A(n110), .ZN(n111) );
  OAI21_X1 U154 ( .B1(b[3]), .B2(n86), .A(n112), .ZN(n120) );
  NAND2_X1 U155 ( .A1(n120), .A2(n119), .ZN(n115) );
  INV_X1 U156 ( .A(n123), .ZN(n121) );
  AOI22_X1 U157 ( .A1(n115), .A2(n121), .B1(n123), .B2(n40), .ZN(n127) );
  OAI211_X1 U158 ( .C1(n118), .C2(n64), .A(n117), .B(n116), .ZN(n125) );
  INV_X1 U159 ( .A(n75), .ZN(n124) );
  INV_X1 U160 ( .A(n125), .ZN(n122) );
  OAI33_X1 U161 ( .A1(n48), .A2(n124), .A3(n123), .B1(n122), .B2(n121), .B3(
        n120), .ZN(n126) );
  OR2_X1 U162 ( .A1(n126), .A2(n127), .ZN(diff[4]) );
  OAI21_X1 U163 ( .B1(n129), .B2(n128), .A(n58), .ZN(n130) );
  INV_X1 U164 ( .A(b[5]), .ZN(n131) );
  NAND2_X1 U165 ( .A1(n54), .A2(n131), .ZN(n136) );
  NAND2_X1 U166 ( .A1(n151), .A2(n78), .ZN(n134) );
  INV_X1 U167 ( .A(n153), .ZN(n133) );
  NAND3_X1 U168 ( .A1(n133), .A2(n136), .A3(n41), .ZN(n144) );
  INV_X1 U169 ( .A(n141), .ZN(n135) );
  INV_X1 U170 ( .A(n136), .ZN(n140) );
  OAI211_X1 U171 ( .C1(n140), .C2(n58), .A(n53), .B(n141), .ZN(n139) );
  OAI21_X1 U172 ( .B1(n41), .B2(n140), .A(n139), .ZN(n142) );
  NAND3_X1 U173 ( .A1(n144), .A2(n143), .A3(n142), .ZN(diff[6]) );
  XOR2_X1 U174 ( .A(a[7]), .B(b[7]), .Z(n145) );
  NAND2_X1 U175 ( .A1(n145), .A2(n87), .ZN(n149) );
  NAND3_X1 U176 ( .A1(n66), .A2(n61), .A3(n51), .ZN(n157) );
endmodule

