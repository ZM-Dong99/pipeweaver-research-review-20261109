/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:07:46 2025
/////////////////////////////////////////////////////////////


module comparator_mini ( SEL, value1, value2, OUT );
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
         n111, n112, n113, n114;

  AND2_X1 U16 ( .A1(n23), .A2(n81), .ZN(n16) );
  NAND4_X1 U17 ( .A1(n17), .A2(n18), .A3(n113), .A4(n114), .ZN(OUT) );
  INV_X1 U18 ( .A(n112), .ZN(n17) );
  INV_X1 U19 ( .A(n111), .ZN(n18) );
  INV_X1 U20 ( .A(n87), .ZN(n19) );
  AND3_X1 U21 ( .A1(n74), .A2(n73), .A3(n105), .ZN(n20) );
  INV_X1 U22 ( .A(value2[5]), .ZN(n21) );
  INV_X1 U23 ( .A(value2[5]), .ZN(n22) );
  AND4_X1 U24 ( .A1(n39), .A2(n43), .A3(n47), .A4(n86), .ZN(n23) );
  INV_X1 U25 ( .A(n51), .ZN(n46) );
  AND4_X1 U26 ( .A1(n75), .A2(n74), .A3(n73), .A4(n72), .ZN(n24) );
  INV_X1 U27 ( .A(n110), .ZN(n104) );
  AND2_X1 U28 ( .A1(n109), .A2(n98), .ZN(n67) );
  OR2_X1 U29 ( .A1(value1[5]), .A2(n91), .ZN(n31) );
  AOI21_X1 U30 ( .B1(n109), .B2(SEL[1]), .A(n76), .ZN(n79) );
  NOR2_X1 U31 ( .A1(value2[3]), .A2(n87), .ZN(n41) );
  AOI22_X1 U32 ( .A1(n94), .A2(n93), .B1(value2[6]), .B2(n37), .ZN(n25) );
  OAI22_X1 U33 ( .A1(value1[2]), .A2(n65), .B1(n19), .B2(n54), .ZN(n55) );
  INV_X1 U34 ( .A(value1[1]), .ZN(n26) );
  INV_X1 U35 ( .A(value1[1]), .ZN(n60) );
  INV_X1 U36 ( .A(value1[0]), .ZN(n27) );
  INV_X1 U37 ( .A(value1[0]), .ZN(n28) );
  INV_X1 U38 ( .A(value2[6]), .ZN(n29) );
  OR2_X1 U39 ( .A1(value2[6]), .A2(n36), .ZN(n30) );
  NAND2_X1 U40 ( .A1(n30), .A2(n49), .ZN(n50) );
  NAND2_X1 U41 ( .A1(n31), .A2(n48), .ZN(n49) );
  AND2_X1 U42 ( .A1(value1[5]), .A2(n21), .ZN(n32) );
  INV_X1 U43 ( .A(value1[3]), .ZN(n33) );
  AND2_X1 U44 ( .A1(value1[6]), .A2(n29), .ZN(n34) );
  NAND2_X1 U45 ( .A1(n75), .A2(n104), .ZN(n106) );
  OAI21_X1 U46 ( .B1(n24), .B2(n79), .A(n78), .ZN(n113) );
  NAND2_X1 U47 ( .A1(n20), .A2(n83), .ZN(n78) );
  AND3_X1 U48 ( .A1(n95), .A2(n109), .A3(n96), .ZN(n35) );
  INV_X1 U49 ( .A(value1[6]), .ZN(n36) );
  INV_X1 U50 ( .A(value1[6]), .ZN(n37) );
  NOR4_X1 U51 ( .A1(n80), .A2(SEL[2]), .A3(n83), .A4(SEL[0]), .ZN(n66) );
  NAND2_X1 U52 ( .A1(value2[5]), .A2(n85), .ZN(n40) );
  NAND2_X1 U53 ( .A1(value2[5]), .A2(n85), .ZN(n53) );
  NAND2_X1 U54 ( .A1(n69), .A2(n68), .ZN(n75) );
  NOR2_X1 U55 ( .A1(n56), .A2(n55), .ZN(n69) );
  NAND2_X1 U56 ( .A1(n52), .A2(n32), .ZN(n44) );
  OAI221_X1 U57 ( .B1(n110), .B2(n109), .C1(n108), .C2(n107), .A(n106), .ZN(
        n111) );
  OAI21_X1 U58 ( .B1(n100), .B2(n16), .A(n99), .ZN(n112) );
  OAI211_X1 U59 ( .C1(SEL[1]), .C2(n101), .A(n35), .B(n97), .ZN(n100) );
  NAND4_X1 U60 ( .A1(n67), .A2(n66), .A3(n77), .A4(n81), .ZN(n114) );
  INV_X1 U61 ( .A(n70), .ZN(n74) );
  OAI211_X1 U62 ( .C1(n46), .C2(n45), .A(n44), .B(n98), .ZN(n70) );
  NAND2_X1 U63 ( .A1(n103), .A2(n102), .ZN(n107) );
  OAI211_X1 U64 ( .C1(value1[6]), .C2(n42), .A(n41), .B(n40), .ZN(n45) );
  INV_X1 U65 ( .A(value1[7]), .ZN(n38) );
  NAND2_X1 U66 ( .A1(value2[7]), .A2(n38), .ZN(n109) );
  INV_X1 U67 ( .A(value2[7]), .ZN(n82) );
  NAND2_X1 U68 ( .A1(value1[7]), .A2(n82), .ZN(n98) );
  INV_X1 U69 ( .A(value2[4]), .ZN(n90) );
  NAND2_X1 U70 ( .A1(value1[4]), .A2(n90), .ZN(n47) );
  INV_X1 U71 ( .A(value2[5]), .ZN(n91) );
  NAND2_X1 U72 ( .A1(value1[5]), .A2(n22), .ZN(n43) );
  INV_X1 U73 ( .A(value2[2]), .ZN(n65) );
  INV_X1 U74 ( .A(value2[3]), .ZN(n54) );
  AOI22_X1 U75 ( .A1(value1[2]), .A2(n65), .B1(n54), .B2(value1[3]), .ZN(n39)
         );
  INV_X1 U76 ( .A(value2[6]), .ZN(n42) );
  NAND2_X1 U77 ( .A1(value1[6]), .A2(n42), .ZN(n86) );
  NAND4_X1 U78 ( .A1(n39), .A2(n43), .A3(n47), .A4(n86), .ZN(n80) );
  INV_X1 U79 ( .A(SEL[1]), .ZN(n83) );
  INV_X1 U80 ( .A(value1[4]), .ZN(n88) );
  NAND2_X1 U81 ( .A1(value2[4]), .A2(n88), .ZN(n51) );
  INV_X1 U82 ( .A(value1[3]), .ZN(n87) );
  INV_X1 U83 ( .A(value1[5]), .ZN(n85) );
  INV_X1 U84 ( .A(value1[6]), .ZN(n92) );
  NAND2_X1 U85 ( .A1(value2[6]), .A2(n92), .ZN(n52) );
  INV_X1 U86 ( .A(n47), .ZN(n48) );
  NAND2_X1 U87 ( .A1(n50), .A2(n52), .ZN(n73) );
  NAND3_X1 U88 ( .A1(n53), .A2(n52), .A3(n51), .ZN(n56) );
  INV_X1 U89 ( .A(value1[2]), .ZN(n59) );
  INV_X1 U90 ( .A(value2[1]), .ZN(n63) );
  INV_X1 U91 ( .A(value1[0]), .ZN(n61) );
  OAI211_X1 U92 ( .C1(value2[1]), .C2(n26), .A(value2[0]), .B(n61), .ZN(n57)
         );
  OAI21_X1 U93 ( .B1(value1[1]), .B2(n63), .A(n57), .ZN(n58) );
  OAI21_X1 U94 ( .B1(value2[2]), .B2(n59), .A(n58), .ZN(n68) );
  NAND2_X1 U95 ( .A1(n69), .A2(n68), .ZN(n105) );
  NAND3_X1 U96 ( .A1(n74), .A2(n73), .A3(n105), .ZN(n77) );
  NOR3_X1 U97 ( .A1(n60), .A2(value2[0]), .A3(n27), .ZN(n64) );
  OAI21_X1 U98 ( .B1(value2[0]), .B2(n28), .A(n60), .ZN(n62) );
  OAI221_X1 U99 ( .B1(value1[2]), .B2(n65), .C1(n64), .C2(n63), .A(n62), .ZN(
        n81) );
  INV_X1 U100 ( .A(SEL[0]), .ZN(n71) );
  OAI211_X1 U101 ( .C1(SEL[1]), .C2(n109), .A(SEL[2]), .B(n71), .ZN(n76) );
  INV_X1 U102 ( .A(n76), .ZN(n72) );
  INV_X1 U103 ( .A(SEL[2]), .ZN(n101) );
  NAND4_X1 U104 ( .A1(SEL[2]), .A2(n83), .A3(value1[7]), .A4(n82), .ZN(n84) );
  NAND2_X1 U105 ( .A1(SEL[0]), .A2(n84), .ZN(n108) );
  INV_X1 U106 ( .A(n108), .ZN(n97) );
  OAI211_X1 U107 ( .C1(value2[6]), .C2(n37), .A(value2[5]), .B(n85), .ZN(n96)
         );
  AOI22_X1 U108 ( .A1(value2[4]), .A2(n88), .B1(n33), .B2(value2[3]), .ZN(n89)
         );
  NOR2_X1 U109 ( .A1(n89), .A2(n34), .ZN(n94) );
  AOI22_X1 U110 ( .A1(value1[5]), .A2(n91), .B1(value1[4]), .B2(n90), .ZN(n93)
         );
  AOI22_X1 U111 ( .A1(n94), .A2(n93), .B1(value2[6]), .B2(n37), .ZN(n95) );
  NAND3_X1 U112 ( .A1(n25), .A2(n109), .A3(n96), .ZN(n102) );
  NAND2_X1 U113 ( .A1(SEL[1]), .A2(n98), .ZN(n103) );
  NAND3_X1 U114 ( .A1(n97), .A2(n16), .A3(n103), .ZN(n99) );
  NAND2_X1 U115 ( .A1(SEL[0]), .A2(n101), .ZN(n110) );
endmodule

