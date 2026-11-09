/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:05:15 2025
/////////////////////////////////////////////////////////////


module comparator_ds ( SEL, value1, value2, OUT );
  input [2:0] SEL;
  input [7:0] value1;
  input [7:0] value2;
  output OUT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105;

  OAI22_X1 U16 ( .A1(value2[5]), .A2(n18), .B1(value2[4]), .B2(n34), .ZN(n15)
         );
  INV_X1 U17 ( .A(value1[3]), .ZN(n16) );
  INV_X1 U18 ( .A(value2[7]), .ZN(n17) );
  INV_X1 U19 ( .A(value1[5]), .ZN(n18) );
  INV_X1 U20 ( .A(value1[5]), .ZN(n19) );
  INV_X1 U21 ( .A(n58), .ZN(n20) );
  AND2_X1 U22 ( .A1(n66), .A2(n65), .ZN(n21) );
  AND2_X1 U23 ( .A1(n93), .A2(n56), .ZN(n22) );
  CLKBUF_X1 U24 ( .A(n31), .Z(n23) );
  NAND2_X1 U25 ( .A1(value2[4]), .A2(n68), .ZN(n24) );
  AND2_X1 U26 ( .A1(n86), .A2(n52), .ZN(n25) );
  AND2_X1 U27 ( .A1(value2[5]), .A2(n70), .ZN(n26) );
  NAND2_X1 U28 ( .A1(value2[3]), .A2(n16), .ZN(n27) );
  AND2_X1 U29 ( .A1(value1[6]), .A2(n76), .ZN(n28) );
  AND2_X1 U30 ( .A1(value2[1]), .A2(n75), .ZN(n29) );
  NOR3_X1 U31 ( .A1(n28), .A2(n29), .A3(n74), .ZN(n77) );
  INV_X1 U32 ( .A(value1[0]), .ZN(n30) );
  AND3_X1 U33 ( .A1(n43), .A2(n27), .A3(n24), .ZN(n31) );
  INV_X1 U34 ( .A(value2[2]), .ZN(n32) );
  AND2_X1 U35 ( .A1(n46), .A2(n45), .ZN(n33) );
  INV_X1 U36 ( .A(value1[4]), .ZN(n34) );
  INV_X1 U37 ( .A(value1[4]), .ZN(n35) );
  INV_X1 U38 ( .A(value1[1]), .ZN(n36) );
  INV_X1 U39 ( .A(value2[7]), .ZN(n37) );
  AND3_X1 U40 ( .A1(n54), .A2(n85), .A3(n94), .ZN(n97) );
  OAI22_X1 U41 ( .A1(value2[1]), .A2(n75), .B1(value2[0]), .B2(n71), .ZN(n38)
         );
  AND3_X1 U42 ( .A1(n77), .A2(n78), .A3(n79), .ZN(n39) );
  AND3_X1 U43 ( .A1(n54), .A2(n55), .A3(n40), .ZN(n61) );
  NOR2_X1 U44 ( .A1(n28), .A2(n58), .ZN(n40) );
  INV_X1 U45 ( .A(value1[1]), .ZN(n75) );
  INV_X1 U46 ( .A(value1[0]), .ZN(n71) );
  OAI22_X1 U47 ( .A1(value2[1]), .A2(n75), .B1(n30), .B2(value2[0]), .ZN(n86)
         );
  INV_X1 U48 ( .A(value1[5]), .ZN(n70) );
  NAND2_X1 U49 ( .A1(value2[5]), .A2(n19), .ZN(n52) );
  NAND2_X1 U50 ( .A1(n86), .A2(n52), .ZN(n59) );
  INV_X1 U51 ( .A(value2[6]), .ZN(n76) );
  INV_X1 U52 ( .A(value1[7]), .ZN(n41) );
  NAND2_X1 U53 ( .A1(value2[7]), .A2(n41), .ZN(n50) );
  OAI21_X1 U54 ( .B1(value1[6]), .B2(n76), .A(n50), .ZN(n47) );
  NOR2_X1 U55 ( .A1(n59), .A2(n47), .ZN(n49) );
  INV_X1 U56 ( .A(value1[4]), .ZN(n68) );
  NAND2_X1 U57 ( .A1(value2[4]), .A2(n68), .ZN(n46) );
  INV_X1 U58 ( .A(value1[3]), .ZN(n67) );
  NAND2_X1 U59 ( .A1(value2[3]), .A2(n67), .ZN(n45) );
  INV_X1 U60 ( .A(value1[2]), .ZN(n42) );
  AOI22_X1 U61 ( .A1(value2[2]), .A2(n42), .B1(n36), .B2(value2[1]), .ZN(n43)
         );
  INV_X1 U62 ( .A(value2[2]), .ZN(n73) );
  NAND2_X1 U63 ( .A1(value1[2]), .A2(n73), .ZN(n66) );
  INV_X1 U64 ( .A(value2[3]), .ZN(n44) );
  NAND2_X1 U65 ( .A1(value1[3]), .A2(n44), .ZN(n65) );
  NAND2_X1 U66 ( .A1(n66), .A2(n65), .ZN(n53) );
  NAND2_X1 U67 ( .A1(n24), .A2(n27), .ZN(n51) );
  NOR4_X1 U68 ( .A1(n47), .A2(n21), .A3(n51), .A4(n26), .ZN(n48) );
  INV_X1 U69 ( .A(value2[7]), .ZN(n72) );
  NAND2_X1 U70 ( .A1(value1[7]), .A2(n37), .ZN(n56) );
  INV_X1 U71 ( .A(SEL[1]), .ZN(n89) );
  NAND2_X1 U72 ( .A1(n56), .A2(n89), .ZN(n96) );
  AOI211_X1 U73 ( .C1(n49), .C2(n23), .A(n96), .B(n48), .ZN(n64) );
  OAI22_X1 U74 ( .A1(value2[5]), .A2(n18), .B1(value2[4]), .B2(n34), .ZN(n87)
         );
  NAND2_X1 U75 ( .A1(n15), .A2(n52), .ZN(n55) );
  NAND2_X1 U76 ( .A1(value1[6]), .A2(n76), .ZN(n57) );
  NAND2_X1 U77 ( .A1(n55), .A2(n57), .ZN(n95) );
  OAI21_X1 U78 ( .B1(value1[6]), .B2(n76), .A(n50), .ZN(n93) );
  NAND2_X1 U79 ( .A1(n93), .A2(n20), .ZN(n60) );
  NAND2_X1 U80 ( .A1(n95), .A2(n60), .ZN(n63) );
  NAND3_X1 U81 ( .A1(n53), .A2(n52), .A3(n33), .ZN(n54) );
  INV_X1 U82 ( .A(n56), .ZN(n58) );
  NAND2_X1 U83 ( .A1(n25), .A2(n31), .ZN(n98) );
  AOI211_X1 U84 ( .C1(n61), .C2(n98), .A(n22), .B(n89), .ZN(n62) );
  AOI21_X1 U85 ( .B1(n64), .B2(n63), .A(n62), .ZN(n105) );
  INV_X1 U86 ( .A(SEL[0]), .ZN(n85) );
  INV_X1 U87 ( .A(SEL[2]), .ZN(n92) );
  NAND2_X1 U88 ( .A1(n66), .A2(n65), .ZN(n88) );
  INV_X1 U89 ( .A(n88), .ZN(n83) );
  AOI222_X1 U90 ( .A1(value2[4]), .A2(n35), .B1(value2[3]), .B2(n67), .C1(n17), 
        .C2(value1[7]), .ZN(n79) );
  INV_X1 U91 ( .A(value1[6]), .ZN(n69) );
  AOI222_X1 U92 ( .A1(value2[0]), .A2(n71), .B1(value2[5]), .B2(n70), .C1(n69), 
        .C2(value2[6]), .ZN(n78) );
  OAI22_X1 U93 ( .A1(value1[2]), .A2(n32), .B1(n72), .B2(value1[7]), .ZN(n74)
         );
  INV_X1 U94 ( .A(value2[5]), .ZN(n81) );
  INV_X1 U95 ( .A(value2[4]), .ZN(n80) );
  AOI221_X1 U96 ( .B1(value1[5]), .B2(n81), .C1(value1[4]), .C2(n80), .A(n38), 
        .ZN(n82) );
  NAND4_X1 U97 ( .A1(n39), .A2(n83), .A3(n82), .A4(SEL[0]), .ZN(n84) );
  OAI21_X1 U98 ( .B1(n85), .B2(n92), .A(n84), .ZN(n104) );
  INV_X1 U99 ( .A(n38), .ZN(n91) );
  AOI211_X1 U100 ( .C1(n89), .C2(n92), .A(n88), .B(n87), .ZN(n90) );
  NAND3_X1 U101 ( .A1(n39), .A2(n91), .A3(n90), .ZN(n103) );
  INV_X1 U102 ( .A(n96), .ZN(n94) );
  AOI21_X1 U103 ( .B1(n94), .B2(n47), .A(n92), .ZN(n101) );
  INV_X1 U104 ( .A(n95), .ZN(n99) );
  NAND3_X1 U105 ( .A1(n99), .A2(n98), .A3(n97), .ZN(n100) );
  OAI21_X1 U106 ( .B1(SEL[0]), .B2(n101), .A(n100), .ZN(n102) );
  AOI22_X1 U107 ( .A1(n105), .A2(n104), .B1(n103), .B2(n102), .ZN(OUT) );
endmodule

