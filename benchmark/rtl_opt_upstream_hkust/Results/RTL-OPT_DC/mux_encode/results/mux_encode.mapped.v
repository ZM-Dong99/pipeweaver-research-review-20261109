/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 01:45:46 2025
/////////////////////////////////////////////////////////////


module mux_encode ( sel, data, out );
  input [2:0] sel;
  input [63:0] data;
  output [7:0] out;
  wire   n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
         n144, n145, n146, n147, n148, n149, n150, n151, n152, n153, n154,
         n155, n156, n157, n158, n159;

  INV_X1 U51 ( .A(sel[2]), .ZN(n43) );
  INV_X1 U52 ( .A(sel[2]), .ZN(n44) );
  INV_X1 U53 ( .A(sel[0]), .ZN(n45) );
  INV_X1 U54 ( .A(sel[0]), .ZN(n46) );
  BUF_X2 U55 ( .A(sel[1]), .Z(n47) );
  INV_X2 U56 ( .A(sel[1]), .ZN(n91) );
  INV_X1 U57 ( .A(sel[2]), .ZN(n48) );
  INV_X1 U58 ( .A(sel[2]), .ZN(n49) );
  BUF_X2 U59 ( .A(sel[1]), .Z(n59) );
  INV_X1 U60 ( .A(sel[0]), .ZN(n50) );
  INV_X1 U61 ( .A(sel[0]), .ZN(n51) );
  BUF_X2 U62 ( .A(sel[1]), .Z(n52) );
  INV_X2 U63 ( .A(sel[1]), .ZN(n89) );
  INV_X2 U64 ( .A(sel[1]), .ZN(n68) );
  INV_X1 U65 ( .A(sel[0]), .ZN(n53) );
  INV_X1 U66 ( .A(sel[0]), .ZN(n54) );
  INV_X1 U67 ( .A(sel[2]), .ZN(n55) );
  INV_X1 U68 ( .A(sel[2]), .ZN(n56) );
  NAND2_X1 U69 ( .A1(n57), .A2(n58), .ZN(out[1]) );
  AND4_X1 U70 ( .A1(n107), .A2(n106), .A3(n105), .A4(n104), .ZN(n57) );
  AND4_X1 U71 ( .A1(n108), .A2(n110), .A3(n111), .A4(n109), .ZN(n58) );
  INV_X1 U72 ( .A(sel[1]), .ZN(n87) );
  NAND2_X1 U73 ( .A1(n61), .A2(n60), .ZN(out[7]) );
  AND4_X1 U74 ( .A1(n156), .A2(n158), .A3(n159), .A4(n157), .ZN(n60) );
  AND4_X1 U75 ( .A1(n154), .A2(n152), .A3(n153), .A4(n155), .ZN(n61) );
  NAND2_X1 U76 ( .A1(n63), .A2(n62), .ZN(out[2]) );
  AND4_X1 U77 ( .A1(n115), .A2(n114), .A3(n112), .A4(n113), .ZN(n62) );
  AND4_X1 U78 ( .A1(n119), .A2(n118), .A3(n116), .A4(n117), .ZN(n63) );
  NAND2_X1 U79 ( .A1(n64), .A2(n65), .ZN(out[5]) );
  AND4_X1 U80 ( .A1(n136), .A2(n138), .A3(n137), .A4(n139), .ZN(n64) );
  AND4_X1 U81 ( .A1(n140), .A2(n142), .A3(n141), .A4(n143), .ZN(n65) );
  NAND4_X1 U82 ( .A1(n51), .A2(n95), .A3(data[26]), .A4(sel[2]), .ZN(n116) );
  NAND4_X1 U83 ( .A1(n45), .A2(n87), .A3(sel[2]), .A4(data[27]), .ZN(n124) );
  NAND4_X1 U84 ( .A1(n89), .A2(n67), .A3(n50), .A4(data[61]), .ZN(n136) );
  INV_X1 U85 ( .A(sel[0]), .ZN(n66) );
  INV_X1 U86 ( .A(sel[2]), .ZN(n67) );
  INV_X1 U87 ( .A(sel[0]), .ZN(n69) );
  INV_X1 U88 ( .A(sel[0]), .ZN(n70) );
  BUF_X2 U89 ( .A(sel[1]), .Z(n71) );
  INV_X1 U90 ( .A(sel[2]), .ZN(n72) );
  INV_X1 U91 ( .A(sel[2]), .ZN(n73) );
  INV_X1 U92 ( .A(sel[2]), .ZN(n81) );
  NAND2_X1 U93 ( .A1(n74), .A2(n75), .ZN(out[0]) );
  AND4_X1 U94 ( .A1(n99), .A2(n97), .A3(n96), .A4(n98), .ZN(n74) );
  AND4_X1 U95 ( .A1(n100), .A2(n102), .A3(n101), .A4(n103), .ZN(n75) );
  NAND2_X1 U96 ( .A1(n77), .A2(n76), .ZN(out[4]) );
  AND4_X1 U97 ( .A1(n128), .A2(n130), .A3(n131), .A4(n129), .ZN(n76) );
  AND4_X1 U98 ( .A1(n135), .A2(n132), .A3(n133), .A4(n134), .ZN(n77) );
  OR2_X1 U99 ( .A1(n78), .A2(n79), .ZN(out[3]) );
  NAND4_X1 U100 ( .A1(n123), .A2(n122), .A3(n121), .A4(n120), .ZN(n78) );
  NAND4_X1 U101 ( .A1(n127), .A2(n126), .A3(n124), .A4(n125), .ZN(n79) );
  INV_X1 U102 ( .A(sel[0]), .ZN(n88) );
  INV_X1 U103 ( .A(sel[2]), .ZN(n80) );
  INV_X1 U104 ( .A(sel[2]), .ZN(n82) );
  INV_X1 U105 ( .A(sel[2]), .ZN(n83) );
  INV_X2 U106 ( .A(sel[1]), .ZN(n95) );
  NAND2_X1 U107 ( .A1(n84), .A2(n85), .ZN(out[6]) );
  AND4_X1 U108 ( .A1(n147), .A2(n144), .A3(n146), .A4(n145), .ZN(n84) );
  AND4_X1 U109 ( .A1(n148), .A2(n150), .A3(n151), .A4(n149), .ZN(n85) );
  BUF_X2 U110 ( .A(sel[1]), .Z(n86) );
  INV_X1 U111 ( .A(sel[0]), .ZN(n90) );
  INV_X1 U112 ( .A(sel[0]), .ZN(n92) );
  NAND4_X1 U113 ( .A1(data[31]), .A2(sel[2]), .A3(n92), .A4(n95), .ZN(n156) );
  NAND4_X1 U114 ( .A1(data[15]), .A2(sel[2]), .A3(n71), .A4(n51), .ZN(n158) );
  INV_X1 U115 ( .A(sel[0]), .ZN(n93) );
  BUF_X2 U116 ( .A(sel[1]), .Z(n94) );
  NAND4_X1 U117 ( .A1(data[29]), .A2(sel[2]), .A3(n95), .A4(n88), .ZN(n140) );
  NAND4_X1 U118 ( .A1(data[32]), .A2(n81), .A3(n71), .A4(sel[0]), .ZN(n99) );
  NAND4_X1 U119 ( .A1(n80), .A2(n52), .A3(data[40]), .A4(n69), .ZN(n98) );
  NAND4_X1 U120 ( .A1(data[48]), .A2(sel[0]), .A3(n82), .A4(n91), .ZN(n97) );
  NAND4_X1 U121 ( .A1(data[56]), .A2(n90), .A3(n73), .A4(n68), .ZN(n96) );
  NAND4_X1 U122 ( .A1(data[0]), .A2(sel[2]), .A3(sel[0]), .A4(n94), .ZN(n103)
         );
  NAND4_X1 U123 ( .A1(data[8]), .A2(sel[2]), .A3(n52), .A4(n53), .ZN(n102) );
  NAND4_X1 U124 ( .A1(data[16]), .A2(sel[2]), .A3(sel[0]), .A4(n91), .ZN(n101)
         );
  NAND4_X1 U125 ( .A1(n45), .A2(sel[2]), .A3(data[24]), .A4(n68), .ZN(n100) );
  NAND4_X1 U126 ( .A1(data[33]), .A2(n86), .A3(sel[0]), .A4(n72), .ZN(n107) );
  NAND4_X1 U127 ( .A1(data[41]), .A2(n71), .A3(n56), .A4(n92), .ZN(n106) );
  NAND4_X1 U128 ( .A1(data[49]), .A2(sel[0]), .A3(n48), .A4(n89), .ZN(n105) );
  NAND4_X1 U129 ( .A1(n89), .A2(n93), .A3(data[57]), .A4(n56), .ZN(n104) );
  NAND4_X1 U130 ( .A1(data[1]), .A2(sel[2]), .A3(sel[0]), .A4(n94), .ZN(n111)
         );
  NAND4_X1 U131 ( .A1(data[9]), .A2(sel[2]), .A3(n59), .A4(n53), .ZN(n110) );
  NAND4_X1 U132 ( .A1(n89), .A2(sel[2]), .A3(sel[0]), .A4(data[17]), .ZN(n109)
         );
  NAND4_X1 U133 ( .A1(n89), .A2(sel[2]), .A3(n53), .A4(data[25]), .ZN(n108) );
  NAND4_X1 U134 ( .A1(n59), .A2(data[34]), .A3(sel[0]), .A4(n44), .ZN(n115) );
  NAND4_X1 U135 ( .A1(n86), .A2(data[42]), .A3(n72), .A4(n51), .ZN(n114) );
  NAND4_X1 U136 ( .A1(n89), .A2(sel[0]), .A3(n82), .A4(data[50]), .ZN(n113) );
  NAND4_X1 U137 ( .A1(n49), .A2(n70), .A3(data[58]), .A4(n91), .ZN(n112) );
  NAND4_X1 U138 ( .A1(data[2]), .A2(sel[2]), .A3(sel[0]), .A4(n59), .ZN(n119)
         );
  NAND4_X1 U139 ( .A1(data[10]), .A2(sel[2]), .A3(n86), .A4(n50), .ZN(n118) );
  NAND4_X1 U140 ( .A1(data[18]), .A2(sel[2]), .A3(sel[0]), .A4(n68), .ZN(n117)
         );
  NAND4_X1 U141 ( .A1(n47), .A2(data[35]), .A3(sel[0]), .A4(n48), .ZN(n123) );
  NAND4_X1 U142 ( .A1(data[43]), .A2(n52), .A3(n80), .A4(n66), .ZN(n122) );
  NAND4_X1 U143 ( .A1(n72), .A2(sel[0]), .A3(data[51]), .A4(n87), .ZN(n121) );
  NAND4_X1 U144 ( .A1(n67), .A2(n88), .A3(data[59]), .A4(n87), .ZN(n120) );
  NAND4_X1 U145 ( .A1(n86), .A2(sel[2]), .A3(data[3]), .A4(sel[0]), .ZN(n127)
         );
  NAND4_X1 U146 ( .A1(n94), .A2(n46), .A3(sel[2]), .A4(data[11]), .ZN(n126) );
  NAND4_X1 U147 ( .A1(n87), .A2(sel[2]), .A3(sel[0]), .A4(data[19]), .ZN(n125)
         );
  NAND4_X1 U148 ( .A1(data[36]), .A2(n86), .A3(sel[0]), .A4(n43), .ZN(n131) );
  NAND4_X1 U149 ( .A1(n86), .A2(data[44]), .A3(n81), .A4(n92), .ZN(n130) );
  NAND4_X1 U150 ( .A1(data[52]), .A2(sel[0]), .A3(n44), .A4(n91), .ZN(n129) );
  NAND4_X1 U151 ( .A1(data[60]), .A2(n54), .A3(n43), .A4(n91), .ZN(n128) );
  NAND4_X1 U152 ( .A1(data[4]), .A2(sel[2]), .A3(sel[0]), .A4(n52), .ZN(n135)
         );
  NAND4_X1 U153 ( .A1(n59), .A2(sel[2]), .A3(data[12]), .A4(n90), .ZN(n134) );
  NAND4_X1 U154 ( .A1(n95), .A2(sel[2]), .A3(sel[0]), .A4(data[20]), .ZN(n133)
         );
  NAND4_X1 U155 ( .A1(data[28]), .A2(sel[2]), .A3(n69), .A4(n95), .ZN(n132) );
  NAND4_X1 U156 ( .A1(n47), .A2(data[37]), .A3(sel[0]), .A4(n49), .ZN(n139) );
  NAND4_X1 U157 ( .A1(data[45]), .A2(n59), .A3(n55), .A4(n54), .ZN(n138) );
  NAND4_X1 U158 ( .A1(data[53]), .A2(sel[0]), .A3(n83), .A4(n95), .ZN(n137) );
  NAND4_X1 U159 ( .A1(n59), .A2(sel[2]), .A3(sel[0]), .A4(data[5]), .ZN(n143)
         );
  NAND4_X1 U160 ( .A1(data[13]), .A2(sel[2]), .A3(n47), .A4(n54), .ZN(n142) );
  NAND4_X1 U161 ( .A1(n89), .A2(sel[2]), .A3(sel[0]), .A4(data[21]), .ZN(n141)
         );
  NAND4_X1 U162 ( .A1(data[38]), .A2(n52), .A3(sel[0]), .A4(n73), .ZN(n147) );
  NAND4_X1 U163 ( .A1(n52), .A2(data[46]), .A3(n81), .A4(n50), .ZN(n146) );
  NAND4_X1 U164 ( .A1(data[54]), .A2(n73), .A3(sel[0]), .A4(n68), .ZN(n145) );
  NAND4_X1 U165 ( .A1(n48), .A2(n70), .A3(data[62]), .A4(n68), .ZN(n144) );
  NAND4_X1 U166 ( .A1(data[6]), .A2(sel[2]), .A3(sel[0]), .A4(n71), .ZN(n151)
         );
  NAND4_X1 U167 ( .A1(n47), .A2(sel[2]), .A3(data[14]), .A4(n70), .ZN(n150) );
  NAND4_X1 U168 ( .A1(n87), .A2(sel[2]), .A3(sel[0]), .A4(data[22]), .ZN(n149)
         );
  NAND4_X1 U169 ( .A1(data[30]), .A2(sel[2]), .A3(n93), .A4(n87), .ZN(n148) );
  NAND4_X1 U170 ( .A1(data[39]), .A2(n71), .A3(sel[0]), .A4(n55), .ZN(n155) );
  NAND4_X1 U171 ( .A1(n47), .A2(data[47]), .A3(n83), .A4(n46), .ZN(n154) );
  NAND4_X1 U172 ( .A1(data[55]), .A2(sel[0]), .A3(n83), .A4(n91), .ZN(n153) );
  NAND4_X1 U173 ( .A1(n95), .A2(n66), .A3(n67), .A4(data[63]), .ZN(n152) );
  NAND4_X1 U174 ( .A1(data[7]), .A2(sel[2]), .A3(sel[0]), .A4(n94), .ZN(n159)
         );
  NAND4_X1 U175 ( .A1(data[23]), .A2(sel[2]), .A3(sel[0]), .A4(n68), .ZN(n157)
         );
endmodule

