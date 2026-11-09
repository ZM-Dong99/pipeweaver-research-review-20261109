/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 01:44:26 2025
/////////////////////////////////////////////////////////////


module divider_4bit ( A, B, result, odd );
  input [3:0] A;
  input [1:0] B;
  output [3:0] result;
  output [3:0] odd;
  wire   n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107,
         n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, n118,
         n119, n120, n121, n122, n123, n124, n125, n126, n127, n128, n129,
         n130, n131, n132, n133, n134, n135, n136, n137, n138, n139, n140,
         n141, n142, n143, n144;

  OAI22_X1 U58 ( .A1(n88), .A2(n115), .B1(n72), .B2(n81), .ZN(n68) );
  NOR2_X1 U59 ( .A1(n75), .A2(n76), .ZN(n69) );
  OAI22_X1 U60 ( .A1(n88), .A2(n115), .B1(n72), .B2(n81), .ZN(n130) );
  XNOR2_X1 U61 ( .A(n100), .B(n103), .ZN(odd[0]) );
  NAND2_X1 U62 ( .A1(n117), .A2(n118), .ZN(n124) );
  AND2_X1 U63 ( .A1(n73), .A2(n103), .ZN(n70) );
  XNOR2_X1 U64 ( .A(n137), .B(n139), .ZN(n141) );
  INV_X1 U65 ( .A(B[1]), .ZN(n113) );
  OAI221_X1 U66 ( .B1(A[2]), .B2(B[1]), .C1(A[1]), .C2(A[2]), .A(n89), .ZN(
        n104) );
  BUF_X1 U67 ( .A(B[0]), .Z(n73) );
  INV_X1 U68 ( .A(n74), .ZN(n71) );
  BUF_X1 U69 ( .A(n138), .Z(n72) );
  INV_X1 U70 ( .A(A[0]), .ZN(n74) );
  NAND2_X1 U71 ( .A1(n118), .A2(n117), .ZN(n120) );
  NOR2_X1 U72 ( .A1(n75), .A2(n76), .ZN(n134) );
  AND2_X1 U73 ( .A1(n84), .A2(n85), .ZN(n75) );
  NOR2_X1 U74 ( .A1(n115), .A2(n130), .ZN(n76) );
  INV_X1 U75 ( .A(A[1]), .ZN(n77) );
  CLKBUF_X1 U76 ( .A(n97), .Z(n80) );
  XNOR2_X1 U77 ( .A(n108), .B(B[1]), .ZN(n78) );
  AND2_X1 U78 ( .A1(n84), .A2(n104), .ZN(n79) );
  INV_X1 U79 ( .A(n71), .ZN(n81) );
  INV_X1 U80 ( .A(A[0]), .ZN(n82) );
  CLKBUF_X1 U81 ( .A(n123), .Z(n83) );
  NAND2_X1 U82 ( .A1(n94), .A2(n93), .ZN(n84) );
  AND2_X1 U83 ( .A1(n104), .A2(B[1]), .ZN(n85) );
  AOI21_X1 U84 ( .B1(n102), .B2(n101), .A(n134), .ZN(n128) );
  NAND2_X1 U85 ( .A1(n78), .A2(n122), .ZN(n125) );
  OAI211_X1 U86 ( .C1(n78), .C2(n140), .A(n119), .B(n120), .ZN(n121) );
  INV_X1 U87 ( .A(n106), .ZN(n127) );
  XNOR2_X1 U88 ( .A(n86), .B(A[2]), .ZN(n93) );
  XNOR2_X1 U89 ( .A(B[0]), .B(B[1]), .ZN(n86) );
  OAI221_X1 U90 ( .B1(n125), .B2(n124), .C1(n83), .C2(n122), .A(n121), .ZN(
        n126) );
  NAND2_X1 U91 ( .A1(n123), .A2(n140), .ZN(n119) );
  XNOR2_X1 U92 ( .A(n114), .B(n113), .ZN(n123) );
  OAI221_X1 U93 ( .B1(A[1]), .B2(B[0]), .C1(A[1]), .C2(n82), .A(n111), .ZN(
        n114) );
  CLKBUF_X1 U94 ( .A(n132), .Z(n87) );
  OAI211_X1 U95 ( .C1(n105), .C2(n104), .A(n132), .B(n70), .ZN(n106) );
  INV_X1 U96 ( .A(A[1]), .ZN(n90) );
  NAND2_X1 U97 ( .A1(n77), .A2(B[0]), .ZN(n116) );
  OAI21_X1 U98 ( .B1(B[0]), .B2(n90), .A(n116), .ZN(n97) );
  INV_X1 U99 ( .A(n97), .ZN(n88) );
  INV_X1 U100 ( .A(B[1]), .ZN(n115) );
  INV_X1 U101 ( .A(B[0]), .ZN(n138) );
  INV_X1 U102 ( .A(A[0]), .ZN(n112) );
  OAI21_X1 U103 ( .B1(A[1]), .B2(B[1]), .A(A[2]), .ZN(n89) );
  NAND3_X1 U104 ( .A1(A[2]), .A2(A[1]), .A3(A[3]), .ZN(n92) );
  INV_X1 U105 ( .A(A[2]), .ZN(n143) );
  AOI21_X1 U106 ( .B1(n143), .B2(n90), .A(n138), .ZN(n91) );
  OAI211_X1 U107 ( .C1(A[3]), .C2(A[1]), .A(n92), .B(n91), .ZN(n94) );
  NAND2_X1 U108 ( .A1(n93), .A2(n94), .ZN(n129) );
  NAND2_X1 U109 ( .A1(n129), .A2(n104), .ZN(n96) );
  NAND2_X1 U110 ( .A1(n96), .A2(n68), .ZN(n132) );
  NAND2_X1 U111 ( .A1(A[2]), .A2(B[0]), .ZN(n137) );
  INV_X1 U112 ( .A(A[3]), .ZN(n144) );
  NAND3_X1 U113 ( .A1(B[1]), .A2(n143), .A3(n144), .ZN(n122) );
  NAND2_X1 U114 ( .A1(A[1]), .A2(B[0]), .ZN(n110) );
  XOR2_X1 U115 ( .A(A[2]), .B(B[0]), .Z(n95) );
  NAND2_X1 U116 ( .A1(B[1]), .A2(n95), .ZN(n109) );
  NAND2_X1 U117 ( .A1(n110), .A2(n109), .ZN(n136) );
  OAI211_X1 U118 ( .C1(n115), .C2(n137), .A(n122), .B(n136), .ZN(n105) );
  INV_X1 U119 ( .A(n105), .ZN(n102) );
  NOR3_X1 U120 ( .A1(A[3]), .A2(B[1]), .A3(n73), .ZN(n98) );
  NAND2_X1 U121 ( .A1(B[0]), .A2(n74), .ZN(n99) );
  OAI21_X1 U122 ( .B1(n115), .B2(n80), .A(n99), .ZN(n131) );
  NAND2_X1 U123 ( .A1(n79), .A2(n131), .ZN(n101) );
  OAI21_X1 U124 ( .B1(n102), .B2(n98), .A(n101), .ZN(n133) );
  NAND3_X1 U125 ( .A1(n133), .A2(n87), .A3(n73), .ZN(n100) );
  OAI21_X1 U126 ( .B1(B[0]), .B2(n82), .A(n99), .ZN(n103) );
  NAND3_X1 U127 ( .A1(A[1]), .A2(B[0]), .A3(A[0]), .ZN(n107) );
  OAI221_X1 U128 ( .B1(A[1]), .B2(n71), .C1(A[1]), .C2(B[0]), .A(n107), .ZN(
        n108) );
  NAND2_X1 U129 ( .A1(A[3]), .A2(A[2]), .ZN(n117) );
  NAND2_X1 U130 ( .A1(n110), .A2(n109), .ZN(n118) );
  NAND3_X1 U131 ( .A1(n112), .A2(A[1]), .A3(B[0]), .ZN(n111) );
  NAND2_X1 U132 ( .A1(n116), .A2(n115), .ZN(n140) );
  FA_X1 U133 ( .A(n127), .B(n126), .CI(n128), .S(odd[1]) );
  NOR3_X1 U134 ( .A1(n131), .A2(n84), .A3(n68), .ZN(odd[2]) );
  NAND2_X1 U135 ( .A1(n133), .A2(n87), .ZN(result[0]) );
  INV_X1 U136 ( .A(n69), .ZN(n135) );
  NOR3_X1 U137 ( .A1(result[0]), .A2(n135), .A3(n70), .ZN(odd[3]) );
  INV_X1 U138 ( .A(n136), .ZN(n142) );
  NOR2_X1 U139 ( .A1(A[3]), .A2(n72), .ZN(n139) );
  OAI21_X1 U140 ( .B1(n142), .B2(n141), .A(n140), .ZN(result[1]) );
  AOI22_X1 U141 ( .A1(B[1]), .A2(n144), .B1(n73), .B2(n143), .ZN(result[2]) );
  AOI21_X1 U142 ( .B1(n73), .B2(n144), .A(B[1]), .ZN(result[3]) );
endmodule

