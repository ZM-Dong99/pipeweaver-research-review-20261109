/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:29:03 2025
/////////////////////////////////////////////////////////////


module comparator_gpt ( SEL, value1, value2, OUT );
  input [2:0] SEL;
  input [7:0] value1;
  input [7:0] value2;
  output OUT;
  wire   n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45,
         n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59,
         n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73,
         n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87,
         n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112;

  CLKBUF_X1 U18 ( .A(n95), .Z(n18) );
  AND2_X1 U19 ( .A1(n93), .A2(n22), .ZN(n19) );
  AND2_X1 U20 ( .A1(n51), .A2(n52), .ZN(n20) );
  CLKBUF_X1 U21 ( .A(n93), .Z(n21) );
  NAND2_X1 U22 ( .A1(n50), .A2(value1[4]), .ZN(n22) );
  NOR3_X1 U23 ( .A1(n29), .A2(n34), .A3(value2[0]), .ZN(n80) );
  NAND2_X1 U24 ( .A1(n53), .A2(value1[5]), .ZN(n93) );
  NOR2_X1 U25 ( .A1(n23), .A2(value1[4]), .ZN(n38) );
  INV_X1 U26 ( .A(value2[4]), .ZN(n23) );
  OR2_X1 U27 ( .A1(value2[2]), .A2(n47), .ZN(n24) );
  NAND2_X1 U28 ( .A1(n24), .A2(n43), .ZN(n84) );
  OR2_X1 U29 ( .A1(value1[1]), .A2(n79), .ZN(n25) );
  NAND2_X1 U30 ( .A1(n42), .A2(n25), .ZN(n43) );
  CLKBUF_X1 U31 ( .A(n22), .Z(n26) );
  AND2_X1 U32 ( .A1(n20), .A2(n48), .ZN(n85) );
  NAND3_X1 U33 ( .A1(n81), .A2(n82), .A3(n19), .ZN(n95) );
  INV_X1 U34 ( .A(value1[3]), .ZN(n27) );
  INV_X1 U35 ( .A(value1[5]), .ZN(n28) );
  INV_X1 U36 ( .A(value1[1]), .ZN(n29) );
  AND2_X1 U37 ( .A1(value2[3]), .A2(n46), .ZN(n30) );
  AND2_X1 U38 ( .A1(n49), .A2(value1[3]), .ZN(n31) );
  INV_X1 U39 ( .A(n51), .ZN(n32) );
  AND2_X1 U40 ( .A1(value2[5]), .A2(n44), .ZN(n33) );
  INV_X1 U41 ( .A(value1[0]), .ZN(n34) );
  INV_X1 U42 ( .A(value1[1]), .ZN(n35) );
  AND2_X1 U43 ( .A1(n27), .A2(value2[3]), .ZN(n36) );
  AND2_X1 U44 ( .A1(n28), .A2(value2[5]), .ZN(n37) );
  AND2_X1 U45 ( .A1(value2[2]), .A2(n47), .ZN(n39) );
  NOR2_X1 U46 ( .A1(n39), .A2(n36), .ZN(n48) );
  INV_X1 U47 ( .A(value1[6]), .ZN(n92) );
  NAND2_X1 U48 ( .A1(value2[6]), .A2(n92), .ZN(n99) );
  INV_X1 U49 ( .A(n99), .ZN(n41) );
  INV_X1 U50 ( .A(value1[7]), .ZN(n91) );
  NAND2_X1 U51 ( .A1(value2[7]), .A2(n91), .ZN(n100) );
  INV_X1 U52 ( .A(n100), .ZN(n40) );
  INV_X1 U53 ( .A(SEL[0]), .ZN(n66) );
  INV_X1 U54 ( .A(SEL[2]), .ZN(n105) );
  NAND2_X1 U55 ( .A1(n66), .A2(n105), .ZN(n70) );
  INV_X1 U56 ( .A(n70), .ZN(n87) );
  NOR4_X1 U57 ( .A1(n41), .A2(SEL[1]), .A3(n40), .A4(n87), .ZN(n65) );
  INV_X1 U58 ( .A(value1[2]), .ZN(n47) );
  INV_X1 U59 ( .A(value2[1]), .ZN(n79) );
  INV_X1 U60 ( .A(value1[1]), .ZN(n75) );
  INV_X1 U61 ( .A(value1[0]), .ZN(n76) );
  OAI211_X1 U62 ( .C1(n35), .C2(value2[1]), .A(value2[0]), .B(n76), .ZN(n42)
         );
  INV_X1 U63 ( .A(n84), .ZN(n57) );
  INV_X1 U64 ( .A(value1[5]), .ZN(n44) );
  NAND2_X1 U65 ( .A1(value2[5]), .A2(n44), .ZN(n52) );
  INV_X1 U66 ( .A(value1[4]), .ZN(n45) );
  NAND2_X1 U67 ( .A1(value2[4]), .A2(n45), .ZN(n51) );
  INV_X1 U68 ( .A(value1[3]), .ZN(n46) );
  NAND3_X1 U69 ( .A1(n48), .A2(n51), .A3(n52), .ZN(n83) );
  INV_X1 U70 ( .A(value2[6]), .ZN(n67) );
  INV_X1 U71 ( .A(value2[3]), .ZN(n49) );
  NAND2_X1 U72 ( .A1(n49), .A2(value1[3]), .ZN(n74) );
  INV_X1 U73 ( .A(value2[4]), .ZN(n50) );
  NAND2_X1 U74 ( .A1(n50), .A2(value1[4]), .ZN(n94) );
  AOI211_X1 U75 ( .C1(n74), .C2(n94), .A(n38), .B(n37), .ZN(n55) );
  INV_X1 U76 ( .A(value2[5]), .ZN(n53) );
  INV_X1 U77 ( .A(n93), .ZN(n54) );
  AOI211_X1 U78 ( .C1(value1[6]), .C2(n67), .A(n54), .B(n55), .ZN(n56) );
  OAI21_X1 U79 ( .B1(n57), .B2(n83), .A(n56), .ZN(n64) );
  INV_X1 U80 ( .A(n64), .ZN(n106) );
  NAND2_X1 U81 ( .A1(SEL[1]), .A2(n70), .ZN(n61) );
  INV_X1 U82 ( .A(n61), .ZN(n59) );
  INV_X1 U83 ( .A(value2[7]), .ZN(n58) );
  NAND2_X1 U84 ( .A1(value1[7]), .A2(n58), .ZN(n69) );
  NAND2_X1 U85 ( .A1(n59), .A2(n69), .ZN(n60) );
  INV_X1 U86 ( .A(n60), .ZN(n63) );
  OAI22_X1 U87 ( .A1(n61), .A2(n100), .B1(n60), .B2(n99), .ZN(n62) );
  AOI221_X1 U88 ( .B1(n64), .B2(n65), .C1(n106), .C2(n63), .A(n62), .ZN(n112)
         );
  NAND2_X1 U89 ( .A1(SEL[2]), .A2(n66), .ZN(n90) );
  NAND3_X1 U90 ( .A1(value1[6]), .A2(n100), .A3(n67), .ZN(n68) );
  NAND2_X1 U91 ( .A1(n68), .A2(n69), .ZN(n102) );
  OAI21_X1 U92 ( .B1(value2[6]), .B2(n92), .A(n69), .ZN(n73) );
  INV_X1 U93 ( .A(n90), .ZN(n72) );
  AOI21_X1 U94 ( .B1(SEL[1]), .B2(n100), .A(n70), .ZN(n71) );
  AOI221_X1 U95 ( .B1(n87), .B2(n73), .C1(n72), .C2(SEL[1]), .A(n71), .ZN(n89)
         );
  INV_X1 U96 ( .A(value2[2]), .ZN(n78) );
  AOI21_X1 U97 ( .B1(value1[2]), .B2(n78), .A(n31), .ZN(n82) );
  OAI21_X1 U98 ( .B1(value2[0]), .B2(n76), .A(n75), .ZN(n77) );
  OAI221_X1 U99 ( .B1(n80), .B2(n79), .C1(value1[2]), .C2(n78), .A(n77), .ZN(
        n81) );
  NAND3_X1 U100 ( .A1(n85), .A2(n99), .A3(n84), .ZN(n86) );
  AOI22_X1 U101 ( .A1(n87), .A2(n18), .B1(n86), .B2(n87), .ZN(n88) );
  OAI211_X1 U102 ( .C1(n90), .C2(n102), .A(n89), .B(n88), .ZN(n111) );
  NOR2_X1 U103 ( .A1(SEL[1]), .A2(n102), .ZN(n103) );
  AOI221_X1 U104 ( .B1(value2[6]), .B2(n92), .C1(value2[7]), .C2(n91), .A(n33), 
        .ZN(n97) );
  OAI211_X1 U105 ( .C1(n30), .C2(n32), .A(n26), .B(n21), .ZN(n96) );
  NAND3_X1 U106 ( .A1(n95), .A2(n96), .A3(n97), .ZN(n104) );
  INV_X1 U107 ( .A(SEL[1]), .ZN(n98) );
  NAND2_X1 U108 ( .A1(SEL[2]), .A2(n98), .ZN(n107) );
  OAI221_X1 U109 ( .B1(SEL[2]), .B2(n100), .C1(SEL[2]), .C2(n99), .A(SEL[0]), 
        .ZN(n101) );
  AOI221_X1 U110 ( .B1(n104), .B2(n103), .C1(n107), .C2(n102), .A(n101), .ZN(
        n110) );
  INV_X1 U111 ( .A(n104), .ZN(n108) );
  AOI22_X1 U112 ( .A1(n108), .A2(n107), .B1(n106), .B2(n105), .ZN(n109) );
  AOI22_X1 U113 ( .A1(n111), .A2(n112), .B1(n109), .B2(n110), .ZN(OUT) );
endmodule

