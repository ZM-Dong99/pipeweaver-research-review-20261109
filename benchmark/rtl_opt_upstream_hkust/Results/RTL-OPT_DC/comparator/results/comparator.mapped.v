/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:09:18 2025
/////////////////////////////////////////////////////////////


module comparator ( SEL, value1, value2, OUT );
  input [2:0] SEL;
  input [7:0] value1;
  input [7:0] value2;
  output OUT;
  wire   n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43,
         n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57,
         n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71,
         n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123;

  AND2_X1 U17 ( .A1(value2[7]), .A2(n76), .ZN(n16) );
  INV_X1 U18 ( .A(n29), .ZN(n17) );
  INV_X1 U19 ( .A(value1[2]), .ZN(n18) );
  INV_X1 U20 ( .A(value1[2]), .ZN(n19) );
  NAND3_X1 U21 ( .A1(n61), .A2(n60), .A3(n101), .ZN(n20) );
  INV_X1 U22 ( .A(value1[6]), .ZN(n21) );
  INV_X1 U23 ( .A(value1[6]), .ZN(n22) );
  OR2_X1 U24 ( .A1(value1[1]), .A2(n57), .ZN(n23) );
  OR2_X1 U25 ( .A1(value1[2]), .A2(n94), .ZN(n24) );
  NAND3_X1 U26 ( .A1(n23), .A2(n24), .A3(n56), .ZN(n102) );
  AND2_X1 U27 ( .A1(n112), .A2(n101), .ZN(n25) );
  AND2_X1 U28 ( .A1(n112), .A2(n96), .ZN(n26) );
  AND2_X1 U29 ( .A1(n78), .A2(n77), .ZN(n27) );
  NAND2_X1 U30 ( .A1(value1[4]), .A2(n51), .ZN(n61) );
  NAND2_X1 U31 ( .A1(value1[5]), .A2(n49), .ZN(n60) );
  NAND2_X1 U32 ( .A1(value1[5]), .A2(n62), .ZN(n53) );
  NOR2_X1 U33 ( .A1(value1[4]), .A2(n50), .ZN(n58) );
  NOR2_X1 U34 ( .A1(value1[3]), .A2(n72), .ZN(n59) );
  NOR2_X1 U35 ( .A1(value1[5]), .A2(n48), .ZN(n65) );
  INV_X1 U36 ( .A(value1[3]), .ZN(n28) );
  INV_X1 U37 ( .A(value1[3]), .ZN(n29) );
  OAI221_X1 U38 ( .B1(value1[7]), .B2(n32), .C1(n68), .C2(n20), .A(n40), .ZN(
        n30) );
  INV_X1 U39 ( .A(value2[7]), .ZN(n31) );
  INV_X1 U40 ( .A(value2[7]), .ZN(n32) );
  NAND2_X1 U41 ( .A1(value2[3]), .A2(n29), .ZN(n33) );
  OAI22_X1 U42 ( .A1(value2[2]), .A2(n18), .B1(value2[3]), .B2(n104), .ZN(n54)
         );
  INV_X1 U43 ( .A(value1[1]), .ZN(n34) );
  INV_X1 U44 ( .A(value1[4]), .ZN(n35) );
  CLKBUF_X1 U45 ( .A(n84), .Z(n36) );
  NAND2_X1 U46 ( .A1(value2[4]), .A2(n105), .ZN(n37) );
  NAND2_X1 U47 ( .A1(n53), .A2(n52), .ZN(n38) );
  NAND2_X1 U48 ( .A1(value1[4]), .A2(n71), .ZN(n52) );
  INV_X1 U49 ( .A(n113), .ZN(n39) );
  AOI22_X1 U50 ( .A1(n65), .A2(n64), .B1(value2[6]), .B2(n21), .ZN(n40) );
  NAND2_X1 U51 ( .A1(value1[6]), .A2(n63), .ZN(n64) );
  INV_X1 U52 ( .A(value1[3]), .ZN(n41) );
  INV_X1 U53 ( .A(value1[0]), .ZN(n42) );
  OAI221_X1 U54 ( .B1(value1[7]), .B2(n32), .C1(n68), .C2(n20), .A(n40), .ZN(
        n43) );
  NOR2_X1 U55 ( .A1(n55), .A2(n54), .ZN(n44) );
  NOR2_X1 U56 ( .A1(n55), .A2(n54), .ZN(n45) );
  NOR2_X1 U57 ( .A1(n38), .A2(n54), .ZN(n100) );
  NAND2_X1 U58 ( .A1(n53), .A2(n52), .ZN(n55) );
  OAI221_X1 U59 ( .B1(value1[7]), .B2(n31), .C1(n68), .C2(n67), .A(n66), .ZN(
        n116) );
  AOI22_X1 U60 ( .A1(n64), .A2(n65), .B1(value2[6]), .B2(n22), .ZN(n66) );
  AND3_X1 U61 ( .A1(n100), .A2(n101), .A3(n102), .ZN(n46) );
  AND2_X1 U62 ( .A1(value2[2]), .A2(n70), .ZN(n47) );
  INV_X1 U63 ( .A(value2[5]), .ZN(n48) );
  INV_X1 U64 ( .A(value2[5]), .ZN(n49) );
  INV_X1 U65 ( .A(value2[4]), .ZN(n50) );
  INV_X1 U66 ( .A(value2[4]), .ZN(n51) );
  INV_X1 U67 ( .A(value2[5]), .ZN(n62) );
  INV_X1 U68 ( .A(value2[4]), .ZN(n71) );
  INV_X1 U69 ( .A(value1[2]), .ZN(n70) );
  INV_X1 U70 ( .A(value1[3]), .ZN(n104) );
  INV_X1 U71 ( .A(value2[1]), .ZN(n57) );
  INV_X1 U72 ( .A(value2[2]), .ZN(n94) );
  INV_X1 U73 ( .A(value1[1]), .ZN(n87) );
  INV_X1 U74 ( .A(value1[0]), .ZN(n88) );
  OAI22_X1 U75 ( .A1(value2[1]), .A2(n87), .B1(n42), .B2(value2[0]), .ZN(n56)
         );
  INV_X1 U76 ( .A(value2[7]), .ZN(n106) );
  NAND2_X1 U77 ( .A1(value1[7]), .A2(n32), .ZN(n112) );
  INV_X1 U78 ( .A(value2[6]), .ZN(n63) );
  NAND2_X1 U79 ( .A1(value1[6]), .A2(n63), .ZN(n101) );
  NAND3_X1 U80 ( .A1(n102), .A2(n44), .A3(n25), .ZN(n84) );
  INV_X1 U81 ( .A(value2[3]), .ZN(n72) );
  NOR2_X2 U82 ( .A1(n59), .A2(n58), .ZN(n68) );
  NAND3_X1 U83 ( .A1(n61), .A2(n60), .A3(n101), .ZN(n67) );
  INV_X1 U84 ( .A(value1[6]), .ZN(n109) );
  NAND2_X1 U85 ( .A1(n39), .A2(n43), .ZN(n83) );
  INV_X1 U86 ( .A(value1[5]), .ZN(n108) );
  AOI22_X1 U87 ( .A1(value2[5]), .A2(n108), .B1(value2[6]), .B2(n109), .ZN(n69) );
  OAI211_X1 U88 ( .C1(value1[7]), .C2(n31), .A(SEL[1]), .B(n69), .ZN(n74) );
  NAND2_X1 U89 ( .A1(value2[2]), .A2(n19), .ZN(n103) );
  OAI221_X1 U90 ( .B1(n17), .B2(n72), .C1(value1[4]), .C2(n71), .A(n103), .ZN(
        n73) );
  NOR2_X1 U91 ( .A1(n74), .A2(n73), .ZN(n75) );
  NAND2_X1 U92 ( .A1(value2[1]), .A2(n87), .ZN(n78) );
  NAND2_X1 U93 ( .A1(value2[0]), .A2(n88), .ZN(n77) );
  AOI21_X1 U94 ( .B1(n75), .B2(n27), .A(SEL[0]), .ZN(n82) );
  INV_X1 U95 ( .A(value1[7]), .ZN(n76) );
  NAND2_X1 U96 ( .A1(value2[7]), .A2(n76), .ZN(n95) );
  NAND2_X1 U97 ( .A1(value2[6]), .A2(n22), .ZN(n90) );
  INV_X1 U98 ( .A(value1[4]), .ZN(n105) );
  NAND2_X1 U99 ( .A1(n35), .A2(value2[4]), .ZN(n93) );
  NAND2_X1 U100 ( .A1(value2[5]), .A2(n108), .ZN(n91) );
  NAND4_X1 U101 ( .A1(n95), .A2(n90), .A3(n37), .A4(n91), .ZN(n80) );
  NAND2_X1 U102 ( .A1(n41), .A2(value2[3]), .ZN(n92) );
  NAND4_X1 U103 ( .A1(n103), .A2(n33), .A3(n78), .A4(n77), .ZN(n79) );
  INV_X1 U104 ( .A(SEL[1]), .ZN(n96) );
  OAI21_X1 U105 ( .B1(n80), .B2(n79), .A(n96), .ZN(n81) );
  AOI22_X1 U106 ( .A1(n36), .A2(n83), .B1(n82), .B2(n81), .ZN(n123) );
  INV_X1 U107 ( .A(SEL[0]), .ZN(n86) );
  NAND3_X1 U108 ( .A1(n84), .A2(n86), .A3(SEL[1]), .ZN(n85) );
  AOI21_X1 U109 ( .B1(n39), .B2(n30), .A(n85), .ZN(n122) );
  OAI21_X1 U110 ( .B1(SEL[1]), .B2(n86), .A(SEL[2]), .ZN(n121) );
  INV_X1 U111 ( .A(SEL[2]), .ZN(n117) );
  AOI22_X1 U112 ( .A1(value2[0]), .A2(n88), .B1(n34), .B2(value2[1]), .ZN(n89)
         );
  NAND3_X1 U113 ( .A1(n89), .A2(n90), .A3(n91), .ZN(n98) );
  OAI211_X1 U114 ( .C1(value1[2]), .C2(n94), .A(n93), .B(n92), .ZN(n97) );
  NOR4_X1 U115 ( .A1(n98), .A2(n97), .A3(n16), .A4(n96), .ZN(n99) );
  OAI222_X1 U116 ( .A1(n26), .A2(n117), .B1(SEL[0]), .B2(n39), .C1(n99), .C2(
        SEL[0]), .ZN(n120) );
  NAND3_X1 U117 ( .A1(n102), .A2(n101), .A3(n45), .ZN(n115) );
  AOI221_X1 U118 ( .B1(value2[4]), .B2(n105), .C1(value2[3]), .C2(n28), .A(n47), .ZN(n111) );
  OAI21_X1 U119 ( .B1(value1[7]), .B2(n106), .A(SEL[0]), .ZN(n107) );
  AOI221_X1 U120 ( .B1(value2[6]), .B2(n21), .C1(value2[5]), .C2(n108), .A(
        n107), .ZN(n110) );
  NAND3_X1 U121 ( .A1(n111), .A2(n27), .A3(n110), .ZN(n114) );
  INV_X1 U122 ( .A(n112), .ZN(n113) );
  NOR4_X1 U123 ( .A1(n114), .A2(n115), .A3(n113), .A4(n26), .ZN(n119) );
  AOI211_X1 U124 ( .C1(SEL[0]), .C2(n117), .A(n116), .B(n46), .ZN(n118) );
  OAI33_X1 U125 ( .A1(n123), .A2(n122), .A3(n121), .B1(n120), .B2(n119), .B3(
        n118), .ZN(OUT) );
endmodule

