/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:46:23 2025
/////////////////////////////////////////////////////////////


module mux_encode_dsr ( sel, data, out );
  input [2:0] sel;
  input [63:0] data;
  output [7:0] out;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72,
         n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86,
         n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105;

  BUF_X2 U1 ( .A(sel[1]), .Z(n13) );
  BUF_X2 U2 ( .A(sel[1]), .Z(n18) );
  BUF_X2 U3 ( .A(sel[1]), .Z(n7) );
  BUF_X2 U4 ( .A(sel[1]), .Z(n5) );
  BUF_X2 U5 ( .A(sel[1]), .Z(n6) );
  BUF_X2 U6 ( .A(sel[1]), .Z(n1) );
  BUF_X2 U7 ( .A(sel[1]), .Z(n2) );
  INV_X1 U8 ( .A(sel[2]), .ZN(n3) );
  INV_X1 U9 ( .A(sel[2]), .ZN(n4) );
  INV_X1 U10 ( .A(sel[2]), .ZN(n8) );
  INV_X1 U11 ( .A(sel[2]), .ZN(n9) );
  INV_X1 U12 ( .A(sel[1]), .ZN(n10) );
  INV_X1 U13 ( .A(sel[2]), .ZN(n11) );
  INV_X1 U14 ( .A(sel[2]), .ZN(n12) );
  BUF_X1 U15 ( .A(sel[1]), .Z(n102) );
  INV_X1 U16 ( .A(sel[1]), .ZN(n14) );
  INV_X1 U17 ( .A(sel[1]), .ZN(n15) );
  INV_X1 U18 ( .A(sel[2]), .ZN(n16) );
  INV_X1 U19 ( .A(sel[2]), .ZN(n17) );
  INV_X1 U20 ( .A(sel[2]), .ZN(n105) );
  INV_X1 U21 ( .A(sel[2]), .ZN(n104) );
  MUX2_X1 U22 ( .A(n19), .B(n20), .S(sel[0]), .Z(out[0]) );
  NAND4_X1 U23 ( .A1(n23), .A2(n22), .A3(n21), .A4(n24), .ZN(n20) );
  NAND3_X1 U24 ( .A1(n4), .A2(n102), .A3(data[32]), .ZN(n24) );
  NAND3_X1 U25 ( .A1(n2), .A2(sel[2]), .A3(data[0]), .ZN(n23) );
  NAND3_X1 U26 ( .A1(data[48]), .A2(n103), .A3(n15), .ZN(n22) );
  NAND3_X1 U27 ( .A1(data[16]), .A2(sel[2]), .A3(n14), .ZN(n21) );
  NAND4_X1 U28 ( .A1(n25), .A2(n28), .A3(n27), .A4(n26), .ZN(n19) );
  NAND3_X1 U29 ( .A1(data[40]), .A2(n1), .A3(n16), .ZN(n28) );
  NAND3_X1 U30 ( .A1(n7), .A2(sel[2]), .A3(data[8]), .ZN(n27) );
  NAND3_X1 U31 ( .A1(n4), .A2(data[56]), .A3(n15), .ZN(n26) );
  NAND3_X1 U32 ( .A1(data[24]), .A2(sel[2]), .A3(n100), .ZN(n25) );
  MUX2_X1 U33 ( .A(n29), .B(n30), .S(sel[0]), .Z(out[1]) );
  NAND4_X1 U34 ( .A1(n33), .A2(n32), .A3(n31), .A4(n34), .ZN(n30) );
  NAND3_X1 U35 ( .A1(data[33]), .A2(n102), .A3(n105), .ZN(n34) );
  NAND3_X1 U36 ( .A1(n5), .A2(sel[2]), .A3(data[1]), .ZN(n33) );
  NAND3_X1 U37 ( .A1(data[49]), .A2(n104), .A3(n101), .ZN(n32) );
  NAND3_X1 U38 ( .A1(data[17]), .A2(sel[2]), .A3(n101), .ZN(n31) );
  NAND4_X1 U39 ( .A1(n38), .A2(n36), .A3(n37), .A4(n35), .ZN(n29) );
  NAND3_X1 U40 ( .A1(data[41]), .A2(n1), .A3(n11), .ZN(n38) );
  NAND3_X1 U41 ( .A1(n7), .A2(sel[2]), .A3(data[9]), .ZN(n37) );
  NAND3_X1 U42 ( .A1(data[57]), .A2(n4), .A3(n15), .ZN(n36) );
  NAND3_X1 U43 ( .A1(data[25]), .A2(sel[2]), .A3(n101), .ZN(n35) );
  MUX2_X1 U44 ( .A(n39), .B(n40), .S(sel[0]), .Z(out[2]) );
  NAND4_X1 U45 ( .A1(n44), .A2(n42), .A3(n43), .A4(n41), .ZN(n40) );
  NAND3_X1 U46 ( .A1(data[34]), .A2(n18), .A3(n103), .ZN(n44) );
  NAND3_X1 U47 ( .A1(n6), .A2(sel[2]), .A3(data[2]), .ZN(n43) );
  NAND3_X1 U48 ( .A1(data[50]), .A2(n12), .A3(n14), .ZN(n42) );
  NAND3_X1 U49 ( .A1(data[18]), .A2(sel[2]), .A3(n10), .ZN(n41) );
  NAND4_X1 U50 ( .A1(n48), .A2(n46), .A3(n47), .A4(n45), .ZN(n39) );
  NAND3_X1 U51 ( .A1(data[42]), .A2(n13), .A3(n12), .ZN(n48) );
  NAND3_X1 U52 ( .A1(n7), .A2(sel[2]), .A3(data[10]), .ZN(n47) );
  NAND3_X1 U53 ( .A1(data[58]), .A2(n17), .A3(n99), .ZN(n46) );
  NAND3_X1 U54 ( .A1(data[26]), .A2(sel[2]), .A3(n14), .ZN(n45) );
  MUX2_X1 U55 ( .A(n49), .B(n50), .S(sel[0]), .Z(out[3]) );
  NAND4_X1 U56 ( .A1(n54), .A2(n52), .A3(n53), .A4(n51), .ZN(n50) );
  NAND3_X1 U57 ( .A1(data[35]), .A2(n13), .A3(n12), .ZN(n54) );
  NAND3_X1 U58 ( .A1(n5), .A2(sel[2]), .A3(data[3]), .ZN(n53) );
  NAND3_X1 U59 ( .A1(data[51]), .A2(n9), .A3(n14), .ZN(n52) );
  NAND3_X1 U60 ( .A1(data[19]), .A2(sel[2]), .A3(n10), .ZN(n51) );
  NAND4_X1 U61 ( .A1(n58), .A2(n56), .A3(n57), .A4(n55), .ZN(n49) );
  NAND3_X1 U62 ( .A1(data[43]), .A2(n13), .A3(n8), .ZN(n58) );
  NAND3_X1 U63 ( .A1(n6), .A2(sel[2]), .A3(data[11]), .ZN(n57) );
  NAND3_X1 U64 ( .A1(data[59]), .A2(n3), .A3(n99), .ZN(n56) );
  NAND3_X1 U65 ( .A1(n99), .A2(sel[2]), .A3(data[27]), .ZN(n55) );
  MUX2_X1 U66 ( .A(n59), .B(n60), .S(sel[0]), .Z(out[4]) );
  NAND4_X1 U67 ( .A1(n64), .A2(n62), .A3(n63), .A4(n61), .ZN(n60) );
  NAND3_X1 U68 ( .A1(data[36]), .A2(n13), .A3(n11), .ZN(n64) );
  NAND3_X1 U69 ( .A1(n6), .A2(sel[2]), .A3(data[4]), .ZN(n63) );
  NAND3_X1 U70 ( .A1(data[52]), .A2(n16), .A3(n100), .ZN(n62) );
  NAND3_X1 U71 ( .A1(data[20]), .A2(sel[2]), .A3(n10), .ZN(n61) );
  NAND4_X1 U72 ( .A1(n68), .A2(n66), .A3(n67), .A4(n65), .ZN(n59) );
  NAND3_X1 U73 ( .A1(data[44]), .A2(n18), .A3(n104), .ZN(n68) );
  NAND3_X1 U74 ( .A1(n6), .A2(sel[2]), .A3(data[12]), .ZN(n67) );
  NAND3_X1 U75 ( .A1(data[60]), .A2(n17), .A3(n14), .ZN(n66) );
  NAND3_X1 U76 ( .A1(n100), .A2(sel[2]), .A3(data[28]), .ZN(n65) );
  MUX2_X1 U77 ( .A(n69), .B(n70), .S(sel[0]), .Z(out[5]) );
  NAND4_X1 U78 ( .A1(n74), .A2(n72), .A3(n73), .A4(n71), .ZN(n70) );
  NAND3_X1 U79 ( .A1(data[37]), .A2(n13), .A3(n16), .ZN(n74) );
  NAND3_X1 U80 ( .A1(n5), .A2(sel[2]), .A3(data[5]), .ZN(n73) );
  NAND3_X1 U81 ( .A1(data[53]), .A2(n11), .A3(n101), .ZN(n72) );
  NAND3_X1 U82 ( .A1(data[21]), .A2(sel[2]), .A3(n10), .ZN(n71) );
  NAND4_X1 U83 ( .A1(n78), .A2(n76), .A3(n77), .A4(n75), .ZN(n69) );
  NAND3_X1 U84 ( .A1(data[45]), .A2(n1), .A3(n9), .ZN(n78) );
  NAND3_X1 U85 ( .A1(n7), .A2(sel[2]), .A3(data[13]), .ZN(n77) );
  NAND3_X1 U86 ( .A1(data[61]), .A2(n3), .A3(n100), .ZN(n76) );
  NAND3_X1 U87 ( .A1(data[29]), .A2(sel[2]), .A3(n15), .ZN(n75) );
  MUX2_X1 U88 ( .A(n79), .B(n80), .S(sel[0]), .Z(out[6]) );
  NAND4_X1 U89 ( .A1(n84), .A2(n82), .A3(n83), .A4(n81), .ZN(n80) );
  NAND3_X1 U90 ( .A1(data[38]), .A2(n18), .A3(n8), .ZN(n84) );
  NAND3_X1 U91 ( .A1(n5), .A2(sel[2]), .A3(data[6]), .ZN(n83) );
  NAND3_X1 U92 ( .A1(data[54]), .A2(n8), .A3(n99), .ZN(n82) );
  NAND3_X1 U93 ( .A1(data[22]), .A2(sel[2]), .A3(n10), .ZN(n81) );
  NAND4_X1 U94 ( .A1(n85), .A2(n88), .A3(n86), .A4(n87), .ZN(n79) );
  NAND3_X1 U95 ( .A1(data[46]), .A2(n2), .A3(n3), .ZN(n88) );
  NAND3_X1 U96 ( .A1(n2), .A2(sel[2]), .A3(data[14]), .ZN(n87) );
  NAND3_X1 U97 ( .A1(data[62]), .A2(n103), .A3(n99), .ZN(n86) );
  NAND3_X1 U98 ( .A1(data[30]), .A2(sel[2]), .A3(n99), .ZN(n85) );
  MUX2_X1 U99 ( .A(n89), .B(n90), .S(sel[0]), .Z(out[7]) );
  NAND4_X1 U100 ( .A1(n91), .A2(n92), .A3(n93), .A4(n94), .ZN(n90) );
  NAND3_X1 U101 ( .A1(data[39]), .A2(n102), .A3(n105), .ZN(n94) );
  NAND3_X1 U102 ( .A1(n2), .A2(sel[2]), .A3(data[7]), .ZN(n93) );
  NAND3_X1 U103 ( .A1(data[55]), .A2(n17), .A3(n100), .ZN(n92) );
  NAND3_X1 U104 ( .A1(data[23]), .A2(sel[2]), .A3(n15), .ZN(n91) );
  NAND4_X1 U105 ( .A1(n95), .A2(n98), .A3(n96), .A4(n97), .ZN(n89) );
  NAND3_X1 U106 ( .A1(data[47]), .A2(n18), .A3(n104), .ZN(n98) );
  NAND3_X1 U107 ( .A1(n1), .A2(sel[2]), .A3(data[15]), .ZN(n97) );
  NAND3_X1 U108 ( .A1(data[63]), .A2(n9), .A3(n101), .ZN(n96) );
  NAND3_X1 U109 ( .A1(data[31]), .A2(sel[2]), .A3(n100), .ZN(n95) );
  INV_X1 U110 ( .A(sel[2]), .ZN(n103) );
  INV_X1 U111 ( .A(sel[1]), .ZN(n99) );
  INV_X1 U112 ( .A(sel[1]), .ZN(n101) );
  INV_X1 U113 ( .A(sel[1]), .ZN(n100) );
endmodule

