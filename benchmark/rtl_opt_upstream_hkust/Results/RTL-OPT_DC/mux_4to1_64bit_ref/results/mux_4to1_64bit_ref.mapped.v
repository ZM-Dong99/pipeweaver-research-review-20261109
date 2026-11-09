/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:08:11 2025
/////////////////////////////////////////////////////////////


module mux_4to1_64bit_ref ( data0, data1, data2, data3, sel, out );
  input [63:0] data0;
  input [63:0] data1;
  input [63:0] data2;
  input [63:0] data3;
  input [1:0] sel;
  output [63:0] out;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72,
         n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86,
         n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n132, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n160, n161, n162, n163, n164, n165, n166,
         n167, n168;

  NOR2_X1 U1 ( .A1(sel[1]), .A2(sel[0]), .ZN(n160) );
  NOR2_X4 U2 ( .A1(sel[1]), .A2(sel[0]), .ZN(n3) );
  INV_X1 U3 ( .A(sel[0]), .ZN(n1) );
  INV_X1 U4 ( .A(sel[0]), .ZN(n2) );
  CLKBUF_X3 U5 ( .A(n160), .Z(n161) );
  CLKBUF_X3 U6 ( .A(n160), .Z(n162) );
  AND2_X1 U7 ( .A1(sel[1]), .A2(sel[0]), .ZN(n6) );
  INV_X1 U8 ( .A(n145), .ZN(n166) );
  INV_X1 U9 ( .A(n145), .ZN(n164) );
  AND2_X2 U10 ( .A1(sel[1]), .A2(sel[0]), .ZN(n4) );
  BUF_X1 U11 ( .A(n6), .Z(n154) );
  AND2_X2 U12 ( .A1(n13), .A2(sel[1]), .ZN(n5) );
  AND2_X4 U13 ( .A1(n2), .A2(sel[1]), .ZN(n167) );
  AND2_X2 U14 ( .A1(n1), .A2(sel[1]), .ZN(n8) );
  AND2_X2 U15 ( .A1(n144), .A2(sel[1]), .ZN(n7) );
  INV_X1 U16 ( .A(n145), .ZN(n163) );
  INV_X1 U17 ( .A(sel[1]), .ZN(n9) );
  AND2_X2 U18 ( .A1(n9), .A2(sel[0]), .ZN(n10) );
  CLKBUF_X1 U19 ( .A(n4), .Z(n14) );
  BUF_X2 U20 ( .A(n4), .Z(n153) );
  INV_X1 U21 ( .A(n145), .ZN(n11) );
  INV_X1 U22 ( .A(n145), .ZN(n12) );
  INV_X1 U23 ( .A(sel[0]), .ZN(n13) );
  BUF_X1 U24 ( .A(n4), .Z(n15) );
  BUF_X1 U25 ( .A(n6), .Z(n156) );
  BUF_X1 U26 ( .A(n6), .Z(n152) );
  INV_X1 U27 ( .A(n145), .ZN(n165) );
  NAND2_X1 U28 ( .A1(n16), .A2(n17), .ZN(out[0]) );
  AOI22_X1 U29 ( .A1(data3[0]), .A2(n156), .B1(data2[0]), .B2(n167), .ZN(n17)
         );
  AOI22_X1 U30 ( .A1(data1[0]), .A2(n151), .B1(data0[0]), .B2(n165), .ZN(n16)
         );
  NAND2_X1 U31 ( .A1(n18), .A2(n19), .ZN(out[1]) );
  AOI22_X1 U32 ( .A1(data3[1]), .A2(n159), .B1(data2[1]), .B2(n7), .ZN(n19) );
  AOI22_X1 U33 ( .A1(n147), .A2(data1[1]), .B1(data0[1]), .B2(n3), .ZN(n18) );
  NAND2_X1 U34 ( .A1(n20), .A2(n21), .ZN(out[2]) );
  AOI22_X1 U35 ( .A1(data3[2]), .A2(n157), .B1(data2[2]), .B2(n8), .ZN(n21) );
  AOI22_X1 U36 ( .A1(n168), .A2(data1[2]), .B1(data0[2]), .B2(n3), .ZN(n20) );
  NAND2_X1 U37 ( .A1(n23), .A2(n22), .ZN(out[3]) );
  AOI22_X1 U38 ( .A1(data3[3]), .A2(n153), .B1(data2[3]), .B2(n5), .ZN(n23) );
  AOI22_X1 U39 ( .A1(n149), .A2(data1[3]), .B1(data0[3]), .B2(n162), .ZN(n22)
         );
  NAND2_X1 U40 ( .A1(n24), .A2(n25), .ZN(out[4]) );
  AOI22_X1 U41 ( .A1(data3[4]), .A2(n159), .B1(data2[4]), .B2(n5), .ZN(n25) );
  AOI22_X1 U42 ( .A1(n149), .A2(data1[4]), .B1(data0[4]), .B2(n163), .ZN(n24)
         );
  NAND2_X1 U43 ( .A1(n26), .A2(n27), .ZN(out[5]) );
  AOI22_X1 U44 ( .A1(data3[5]), .A2(n153), .B1(data2[5]), .B2(n8), .ZN(n27) );
  AOI22_X1 U45 ( .A1(n168), .A2(data1[5]), .B1(data0[5]), .B2(n3), .ZN(n26) );
  NAND2_X1 U46 ( .A1(n28), .A2(n29), .ZN(out[6]) );
  AOI22_X1 U47 ( .A1(data3[6]), .A2(n155), .B1(data2[6]), .B2(n5), .ZN(n29) );
  AOI22_X1 U48 ( .A1(n148), .A2(data1[6]), .B1(data0[6]), .B2(n162), .ZN(n28)
         );
  NAND2_X1 U49 ( .A1(n30), .A2(n31), .ZN(out[7]) );
  AOI22_X1 U50 ( .A1(data3[7]), .A2(n152), .B1(data2[7]), .B2(n8), .ZN(n31) );
  AOI22_X1 U51 ( .A1(data1[7]), .A2(n151), .B1(data0[7]), .B2(n161), .ZN(n30)
         );
  NAND2_X1 U52 ( .A1(n32), .A2(n33), .ZN(out[8]) );
  AOI22_X1 U53 ( .A1(data3[8]), .A2(n157), .B1(data2[8]), .B2(n167), .ZN(n33)
         );
  AOI22_X1 U54 ( .A1(n151), .A2(data1[8]), .B1(data0[8]), .B2(n12), .ZN(n32)
         );
  NAND2_X1 U55 ( .A1(n34), .A2(n35), .ZN(out[9]) );
  AOI22_X1 U56 ( .A1(data3[9]), .A2(n154), .B1(data2[9]), .B2(n167), .ZN(n35)
         );
  AOI22_X1 U57 ( .A1(n148), .A2(data1[9]), .B1(data0[9]), .B2(n11), .ZN(n34)
         );
  NAND2_X1 U58 ( .A1(n36), .A2(n37), .ZN(out[10]) );
  AOI22_X1 U59 ( .A1(data3[10]), .A2(n159), .B1(data2[10]), .B2(n167), .ZN(n37) );
  AOI22_X1 U60 ( .A1(n168), .A2(data1[10]), .B1(data0[10]), .B2(n166), .ZN(n36) );
  NAND2_X1 U61 ( .A1(n38), .A2(n39), .ZN(out[11]) );
  AOI22_X1 U62 ( .A1(data3[11]), .A2(n153), .B1(data2[11]), .B2(n8), .ZN(n39)
         );
  AOI22_X1 U63 ( .A1(n150), .A2(data1[11]), .B1(data0[11]), .B2(n162), .ZN(n38) );
  NAND2_X1 U64 ( .A1(n40), .A2(n41), .ZN(out[12]) );
  AOI22_X1 U65 ( .A1(data3[12]), .A2(n152), .B1(data2[12]), .B2(n5), .ZN(n41)
         );
  AOI22_X1 U66 ( .A1(n168), .A2(data1[12]), .B1(data0[12]), .B2(n3), .ZN(n40)
         );
  NAND2_X1 U67 ( .A1(n42), .A2(n43), .ZN(out[13]) );
  AOI22_X1 U68 ( .A1(data3[13]), .A2(n154), .B1(data2[13]), .B2(n167), .ZN(n43) );
  AOI22_X1 U69 ( .A1(data1[13]), .A2(n150), .B1(data0[13]), .B2(n162), .ZN(n42) );
  NAND2_X1 U70 ( .A1(n44), .A2(n45), .ZN(out[14]) );
  AOI22_X1 U71 ( .A1(data3[14]), .A2(n14), .B1(data2[14]), .B2(n167), .ZN(n45)
         );
  AOI22_X1 U72 ( .A1(data1[14]), .A2(n150), .B1(data0[14]), .B2(n161), .ZN(n44) );
  NAND2_X1 U73 ( .A1(n46), .A2(n47), .ZN(out[15]) );
  AOI22_X1 U74 ( .A1(data3[15]), .A2(n152), .B1(data2[15]), .B2(n8), .ZN(n47)
         );
  AOI22_X1 U75 ( .A1(n151), .A2(data1[15]), .B1(data0[15]), .B2(n165), .ZN(n46) );
  NAND2_X1 U76 ( .A1(n48), .A2(n49), .ZN(out[16]) );
  AOI22_X1 U77 ( .A1(data3[16]), .A2(n14), .B1(data2[16]), .B2(n5), .ZN(n49)
         );
  AOI22_X1 U78 ( .A1(data1[16]), .A2(n150), .B1(data0[16]), .B2(n166), .ZN(n48) );
  NAND2_X1 U79 ( .A1(n50), .A2(n51), .ZN(out[17]) );
  AOI22_X1 U80 ( .A1(data3[17]), .A2(n15), .B1(data2[17]), .B2(n7), .ZN(n51)
         );
  AOI22_X1 U81 ( .A1(n149), .A2(data1[17]), .B1(data0[17]), .B2(n161), .ZN(n50) );
  NAND2_X1 U82 ( .A1(n52), .A2(n53), .ZN(out[18]) );
  AOI22_X1 U83 ( .A1(data3[18]), .A2(n155), .B1(data2[18]), .B2(n8), .ZN(n53)
         );
  AOI22_X1 U84 ( .A1(data1[18]), .A2(n150), .B1(data0[18]), .B2(n162), .ZN(n52) );
  NAND2_X1 U85 ( .A1(n54), .A2(n55), .ZN(out[19]) );
  AOI22_X1 U86 ( .A1(data3[19]), .A2(n156), .B1(data2[19]), .B2(n167), .ZN(n55) );
  AOI22_X1 U87 ( .A1(n168), .A2(data1[19]), .B1(data0[19]), .B2(n11), .ZN(n54)
         );
  NAND2_X1 U88 ( .A1(n56), .A2(n57), .ZN(out[20]) );
  AOI22_X1 U89 ( .A1(data3[20]), .A2(n157), .B1(data2[20]), .B2(n167), .ZN(n57) );
  AOI22_X1 U90 ( .A1(n151), .A2(data1[20]), .B1(data0[20]), .B2(n12), .ZN(n56)
         );
  NAND2_X1 U91 ( .A1(n59), .A2(n58), .ZN(out[21]) );
  AOI22_X1 U92 ( .A1(data3[21]), .A2(n153), .B1(data2[21]), .B2(n8), .ZN(n59)
         );
  AOI22_X1 U93 ( .A1(n149), .A2(data1[21]), .B1(data0[21]), .B2(n161), .ZN(n58) );
  NAND2_X1 U94 ( .A1(n60), .A2(n61), .ZN(out[22]) );
  AOI22_X1 U95 ( .A1(data3[22]), .A2(n157), .B1(data2[22]), .B2(n7), .ZN(n61)
         );
  AOI22_X1 U96 ( .A1(n168), .A2(data1[22]), .B1(data0[22]), .B2(n161), .ZN(n60) );
  NAND2_X1 U97 ( .A1(n62), .A2(n63), .ZN(out[23]) );
  AOI22_X1 U98 ( .A1(data3[23]), .A2(n15), .B1(data2[23]), .B2(n7), .ZN(n63)
         );
  AOI22_X1 U99 ( .A1(n148), .A2(data1[23]), .B1(data0[23]), .B2(n164), .ZN(n62) );
  NAND2_X1 U100 ( .A1(n64), .A2(n65), .ZN(out[24]) );
  AOI22_X1 U101 ( .A1(data3[24]), .A2(n157), .B1(data2[24]), .B2(n167), .ZN(
        n65) );
  AOI22_X1 U102 ( .A1(n168), .A2(data1[24]), .B1(data0[24]), .B2(n164), .ZN(
        n64) );
  NAND2_X1 U103 ( .A1(n66), .A2(n67), .ZN(out[25]) );
  AOI22_X1 U104 ( .A1(data3[25]), .A2(n159), .B1(data2[25]), .B2(n5), .ZN(n67)
         );
  AOI22_X1 U105 ( .A1(n148), .A2(data1[25]), .B1(data0[25]), .B2(n11), .ZN(n66) );
  NAND2_X1 U106 ( .A1(n68), .A2(n69), .ZN(out[26]) );
  AOI22_X1 U107 ( .A1(data3[26]), .A2(n159), .B1(data2[26]), .B2(n7), .ZN(n69)
         );
  AOI22_X1 U108 ( .A1(n151), .A2(data1[26]), .B1(data0[26]), .B2(n166), .ZN(
        n68) );
  NAND2_X1 U109 ( .A1(n70), .A2(n71), .ZN(out[27]) );
  AOI22_X1 U110 ( .A1(data3[27]), .A2(n155), .B1(data2[27]), .B2(n7), .ZN(n71)
         );
  AOI22_X1 U111 ( .A1(data1[27]), .A2(n150), .B1(data0[27]), .B2(n3), .ZN(n70)
         );
  NAND2_X1 U112 ( .A1(n72), .A2(n73), .ZN(out[28]) );
  AOI22_X1 U113 ( .A1(data3[28]), .A2(n153), .B1(data2[28]), .B2(n167), .ZN(
        n73) );
  AOI22_X1 U114 ( .A1(n147), .A2(data1[28]), .B1(data0[28]), .B2(n164), .ZN(
        n72) );
  NAND2_X1 U115 ( .A1(n74), .A2(n75), .ZN(out[29]) );
  AOI22_X1 U116 ( .A1(data3[29]), .A2(n154), .B1(data2[29]), .B2(n5), .ZN(n75)
         );
  AOI22_X1 U117 ( .A1(data1[29]), .A2(n147), .B1(data0[29]), .B2(n166), .ZN(
        n74) );
  NAND2_X1 U118 ( .A1(n76), .A2(n77), .ZN(out[30]) );
  AOI22_X1 U119 ( .A1(data3[30]), .A2(n153), .B1(data2[30]), .B2(n7), .ZN(n77)
         );
  AOI22_X1 U120 ( .A1(n148), .A2(data1[30]), .B1(data0[30]), .B2(n12), .ZN(n76) );
  NAND2_X1 U121 ( .A1(n78), .A2(n79), .ZN(out[31]) );
  AOI22_X1 U122 ( .A1(data3[31]), .A2(n153), .B1(data2[31]), .B2(n167), .ZN(
        n79) );
  AOI22_X1 U123 ( .A1(n147), .A2(data1[31]), .B1(data0[31]), .B2(n163), .ZN(
        n78) );
  NAND2_X1 U124 ( .A1(n80), .A2(n81), .ZN(out[32]) );
  AOI22_X1 U125 ( .A1(data3[32]), .A2(n156), .B1(data2[32]), .B2(n5), .ZN(n81)
         );
  AOI22_X1 U126 ( .A1(data1[32]), .A2(n168), .B1(data0[32]), .B2(n12), .ZN(n80) );
  NAND2_X1 U127 ( .A1(n82), .A2(n83), .ZN(out[33]) );
  AOI22_X1 U128 ( .A1(data3[33]), .A2(n156), .B1(data2[33]), .B2(n8), .ZN(n83)
         );
  AOI22_X1 U129 ( .A1(data1[33]), .A2(n147), .B1(data0[33]), .B2(n166), .ZN(
        n82) );
  NAND2_X1 U130 ( .A1(n84), .A2(n85), .ZN(out[34]) );
  AOI22_X1 U131 ( .A1(data3[34]), .A2(n15), .B1(data2[34]), .B2(n167), .ZN(n85) );
  AOI22_X1 U132 ( .A1(n151), .A2(data1[34]), .B1(n161), .B2(data0[34]), .ZN(
        n84) );
  NAND2_X1 U133 ( .A1(n86), .A2(n87), .ZN(out[35]) );
  AOI22_X1 U134 ( .A1(data3[35]), .A2(n159), .B1(data2[35]), .B2(n167), .ZN(
        n87) );
  AOI22_X1 U135 ( .A1(n147), .A2(data1[35]), .B1(data0[35]), .B2(n11), .ZN(n86) );
  NAND2_X1 U136 ( .A1(n88), .A2(n89), .ZN(out[36]) );
  AOI22_X1 U137 ( .A1(data3[36]), .A2(n153), .B1(data2[36]), .B2(n8), .ZN(n89)
         );
  AOI22_X1 U138 ( .A1(n149), .A2(data1[36]), .B1(data0[36]), .B2(n3), .ZN(n88)
         );
  NAND2_X1 U139 ( .A1(n90), .A2(n91), .ZN(out[37]) );
  AOI22_X1 U140 ( .A1(data3[37]), .A2(n14), .B1(data2[37]), .B2(n5), .ZN(n91)
         );
  AOI22_X1 U141 ( .A1(data1[37]), .A2(n147), .B1(data0[37]), .B2(n161), .ZN(
        n90) );
  NAND2_X1 U142 ( .A1(n92), .A2(n93), .ZN(out[38]) );
  AOI22_X1 U143 ( .A1(data3[38]), .A2(n154), .B1(data2[38]), .B2(n5), .ZN(n93)
         );
  AOI22_X1 U144 ( .A1(data1[38]), .A2(n168), .B1(data0[38]), .B2(n11), .ZN(n92) );
  NAND2_X1 U145 ( .A1(n94), .A2(n95), .ZN(out[39]) );
  AOI22_X1 U146 ( .A1(data3[39]), .A2(n159), .B1(data2[39]), .B2(n167), .ZN(
        n95) );
  AOI22_X1 U147 ( .A1(n147), .A2(data1[39]), .B1(data0[39]), .B2(n12), .ZN(n94) );
  NAND2_X1 U148 ( .A1(n96), .A2(n97), .ZN(out[40]) );
  AOI22_X1 U149 ( .A1(data3[40]), .A2(n157), .B1(data2[40]), .B2(n5), .ZN(n97)
         );
  AOI22_X1 U150 ( .A1(n151), .A2(data1[40]), .B1(data0[40]), .B2(n3), .ZN(n96)
         );
  NAND2_X1 U151 ( .A1(n98), .A2(n99), .ZN(out[41]) );
  AOI22_X1 U152 ( .A1(data3[41]), .A2(n155), .B1(data2[41]), .B2(n8), .ZN(n99)
         );
  AOI22_X1 U153 ( .A1(data1[41]), .A2(n150), .B1(data0[41]), .B2(n161), .ZN(
        n98) );
  NAND2_X1 U154 ( .A1(n100), .A2(n101), .ZN(out[42]) );
  AOI22_X1 U155 ( .A1(data3[42]), .A2(n157), .B1(data2[42]), .B2(n8), .ZN(n101) );
  AOI22_X1 U156 ( .A1(n168), .A2(data1[42]), .B1(data0[42]), .B2(n3), .ZN(n100) );
  NAND2_X1 U157 ( .A1(n102), .A2(n103), .ZN(out[43]) );
  AOI22_X1 U158 ( .A1(data3[43]), .A2(n152), .B1(data2[43]), .B2(n8), .ZN(n103) );
  AOI22_X1 U159 ( .A1(n149), .A2(data1[43]), .B1(data0[43]), .B2(n162), .ZN(
        n102) );
  NAND2_X1 U160 ( .A1(n104), .A2(n105), .ZN(out[44]) );
  AOI22_X1 U161 ( .A1(data3[44]), .A2(n157), .B1(data2[44]), .B2(n167), .ZN(
        n105) );
  AOI22_X1 U162 ( .A1(n148), .A2(data1[44]), .B1(data0[44]), .B2(n163), .ZN(
        n104) );
  NAND2_X1 U163 ( .A1(n106), .A2(n107), .ZN(out[45]) );
  AOI22_X1 U164 ( .A1(data3[45]), .A2(n152), .B1(data2[45]), .B2(n167), .ZN(
        n107) );
  AOI22_X1 U165 ( .A1(n148), .A2(data1[45]), .B1(data0[45]), .B2(n3), .ZN(n106) );
  NAND2_X1 U166 ( .A1(n108), .A2(n109), .ZN(out[46]) );
  AOI22_X1 U167 ( .A1(data3[46]), .A2(n157), .B1(data2[46]), .B2(n7), .ZN(n109) );
  AOI22_X1 U168 ( .A1(n147), .A2(data1[46]), .B1(data0[46]), .B2(n164), .ZN(
        n108) );
  NAND2_X1 U169 ( .A1(n110), .A2(n111), .ZN(out[47]) );
  AOI22_X1 U170 ( .A1(data3[47]), .A2(n159), .B1(data2[47]), .B2(n5), .ZN(n111) );
  AOI22_X1 U171 ( .A1(n150), .A2(data1[47]), .B1(data0[47]), .B2(n163), .ZN(
        n110) );
  NAND2_X1 U172 ( .A1(n112), .A2(n113), .ZN(out[48]) );
  AOI22_X1 U173 ( .A1(data3[48]), .A2(n154), .B1(data2[48]), .B2(n167), .ZN(
        n113) );
  AOI22_X1 U174 ( .A1(n149), .A2(data1[48]), .B1(data0[48]), .B2(n162), .ZN(
        n112) );
  NAND2_X1 U175 ( .A1(n114), .A2(n115), .ZN(out[49]) );
  AOI22_X1 U176 ( .A1(data3[49]), .A2(n155), .B1(data2[49]), .B2(n167), .ZN(
        n115) );
  AOI22_X1 U177 ( .A1(n148), .A2(data1[49]), .B1(data0[49]), .B2(n165), .ZN(
        n114) );
  NAND2_X1 U178 ( .A1(n116), .A2(n117), .ZN(out[50]) );
  AOI22_X1 U179 ( .A1(data3[50]), .A2(n152), .B1(data2[50]), .B2(n5), .ZN(n117) );
  AOI22_X1 U180 ( .A1(data1[50]), .A2(n147), .B1(data0[50]), .B2(n162), .ZN(
        n116) );
  NAND2_X1 U181 ( .A1(n118), .A2(n119), .ZN(out[51]) );
  AOI22_X1 U182 ( .A1(data3[51]), .A2(n159), .B1(data2[51]), .B2(n7), .ZN(n119) );
  AOI22_X1 U183 ( .A1(n149), .A2(data1[51]), .B1(data0[51]), .B2(n163), .ZN(
        n118) );
  NAND2_X1 U184 ( .A1(n120), .A2(n121), .ZN(out[52]) );
  AOI22_X1 U185 ( .A1(data3[52]), .A2(n156), .B1(data2[52]), .B2(n8), .ZN(n121) );
  AOI22_X1 U186 ( .A1(n151), .A2(data1[52]), .B1(data0[52]), .B2(n162), .ZN(
        n120) );
  NAND2_X1 U187 ( .A1(n122), .A2(n123), .ZN(out[53]) );
  AOI22_X1 U188 ( .A1(data3[53]), .A2(n154), .B1(data2[53]), .B2(n167), .ZN(
        n123) );
  AOI22_X1 U189 ( .A1(data1[53]), .A2(n150), .B1(data0[53]), .B2(n161), .ZN(
        n122) );
  NAND2_X1 U190 ( .A1(n124), .A2(n125), .ZN(out[54]) );
  AOI22_X1 U191 ( .A1(data3[54]), .A2(n15), .B1(data2[54]), .B2(n7), .ZN(n125)
         );
  AOI22_X1 U192 ( .A1(n148), .A2(data1[54]), .B1(data0[54]), .B2(n162), .ZN(
        n124) );
  NAND2_X1 U193 ( .A1(n126), .A2(n127), .ZN(out[55]) );
  AOI22_X1 U194 ( .A1(data3[55]), .A2(n159), .B1(data2[55]), .B2(n167), .ZN(
        n127) );
  AOI22_X1 U195 ( .A1(n148), .A2(data1[55]), .B1(data0[55]), .B2(n166), .ZN(
        n126) );
  NAND2_X1 U196 ( .A1(n128), .A2(n129), .ZN(out[56]) );
  AOI22_X1 U197 ( .A1(data3[56]), .A2(n155), .B1(data2[56]), .B2(n7), .ZN(n129) );
  AOI22_X1 U198 ( .A1(data1[56]), .A2(n168), .B1(data0[56]), .B2(n3), .ZN(n128) );
  NAND2_X1 U199 ( .A1(n130), .A2(n131), .ZN(out[57]) );
  AOI22_X1 U200 ( .A1(data3[57]), .A2(n156), .B1(data2[57]), .B2(n5), .ZN(n131) );
  AOI22_X1 U201 ( .A1(data1[57]), .A2(n150), .B1(data0[57]), .B2(n164), .ZN(
        n130) );
  NAND2_X1 U202 ( .A1(n132), .A2(n133), .ZN(out[58]) );
  AOI22_X1 U203 ( .A1(data3[58]), .A2(n15), .B1(data2[58]), .B2(n8), .ZN(n133)
         );
  AOI22_X1 U204 ( .A1(data1[58]), .A2(n150), .B1(data0[58]), .B2(n164), .ZN(
        n132) );
  NAND2_X1 U205 ( .A1(n134), .A2(n135), .ZN(out[59]) );
  AOI22_X1 U206 ( .A1(data3[59]), .A2(n153), .B1(data2[59]), .B2(n7), .ZN(n135) );
  AOI22_X1 U207 ( .A1(n148), .A2(data1[59]), .B1(data0[59]), .B2(n3), .ZN(n134) );
  NAND2_X1 U208 ( .A1(n136), .A2(n137), .ZN(out[60]) );
  AOI22_X1 U209 ( .A1(data3[60]), .A2(n157), .B1(data2[60]), .B2(n7), .ZN(n137) );
  AOI22_X1 U210 ( .A1(n149), .A2(data1[60]), .B1(data0[60]), .B2(n165), .ZN(
        n136) );
  NAND2_X1 U211 ( .A1(n138), .A2(n139), .ZN(out[61]) );
  AOI22_X1 U212 ( .A1(data3[61]), .A2(n153), .B1(data2[61]), .B2(n7), .ZN(n139) );
  AOI22_X1 U213 ( .A1(n147), .A2(data1[61]), .B1(data0[61]), .B2(n162), .ZN(
        n138) );
  NAND2_X1 U214 ( .A1(n140), .A2(n141), .ZN(out[62]) );
  AOI22_X1 U215 ( .A1(data3[62]), .A2(n157), .B1(data2[62]), .B2(n167), .ZN(
        n141) );
  AOI22_X1 U216 ( .A1(n151), .A2(data1[62]), .B1(data0[62]), .B2(n165), .ZN(
        n140) );
  NAND2_X1 U217 ( .A1(n142), .A2(n143), .ZN(out[63]) );
  AOI22_X1 U218 ( .A1(data3[63]), .A2(n159), .B1(data2[63]), .B2(n167), .ZN(
        n143) );
  AOI22_X1 U219 ( .A1(n151), .A2(data1[63]), .B1(data0[63]), .B2(n3), .ZN(n142) );
  INV_X1 U220 ( .A(sel[0]), .ZN(n144) );
  INV_X1 U221 ( .A(sel[1]), .ZN(n146) );
  BUF_X2 U222 ( .A(n10), .Z(n147) );
  BUF_X2 U223 ( .A(n10), .Z(n148) );
  BUF_X1 U224 ( .A(n4), .Z(n155) );
  BUF_X2 U225 ( .A(n158), .Z(n149) );
  BUF_X2 U226 ( .A(n158), .Z(n150) );
  BUF_X2 U227 ( .A(n4), .Z(n157) );
  AND2_X2 U228 ( .A1(n146), .A2(sel[0]), .ZN(n158) );
  OR2_X2 U229 ( .A1(sel[0]), .A2(sel[1]), .ZN(n145) );
  BUF_X2 U230 ( .A(n6), .Z(n159) );
  BUF_X2 U231 ( .A(n10), .Z(n151) );
  BUF_X2 U232 ( .A(n158), .Z(n168) );
endmodule

