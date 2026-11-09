/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:07:37 2025
/////////////////////////////////////////////////////////////


module comparator_ref ( SEL, value1, value2, OUT );
  input [2:0] SEL;
  input [7:0] value1;
  input [7:0] value2;
  output OUT;
  wire   n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109;

  AND2_X1 U16 ( .A1(value2[1]), .A2(n69), .ZN(n21) );
  AND2_X1 U17 ( .A1(value2[2]), .A2(n70), .ZN(n22) );
  INV_X1 U18 ( .A(value2[6]), .ZN(n23) );
  AOI222_X2 U19 ( .A1(value1[4]), .A2(n29), .B1(n64), .B2(value1[5]), .C1(n72), 
        .C2(value1[3]), .ZN(n75) );
  OAI211_X1 U20 ( .C1(value2[6]), .C2(n76), .A(n74), .B(n75), .ZN(n24) );
  AND3_X1 U21 ( .A1(n83), .A2(n25), .A3(n77), .ZN(n90) );
  AND4_X1 U22 ( .A1(n85), .A2(SEL[1]), .A3(n96), .A4(n101), .ZN(n25) );
  AND2_X1 U23 ( .A1(n83), .A2(n77), .ZN(n26) );
  INV_X1 U24 ( .A(value2[5]), .ZN(n27) );
  AND2_X1 U25 ( .A1(value1[6]), .A2(n63), .ZN(n28) );
  INV_X1 U26 ( .A(value2[4]), .ZN(n29) );
  INV_X1 U27 ( .A(value2[4]), .ZN(n30) );
  INV_X1 U28 ( .A(value2[3]), .ZN(n31) );
  INV_X1 U29 ( .A(value2[3]), .ZN(n32) );
  OR2_X1 U30 ( .A1(value2[2]), .A2(n70), .ZN(n33) );
  OR2_X1 U31 ( .A1(value2[1]), .A2(n69), .ZN(n34) );
  NAND3_X1 U32 ( .A1(n33), .A2(n34), .A3(n68), .ZN(n71) );
  OR2_X1 U33 ( .A1(value1[2]), .A2(n73), .ZN(n35) );
  OR2_X1 U34 ( .A1(value1[3]), .A2(n31), .ZN(n36) );
  NAND3_X1 U35 ( .A1(n71), .A2(n36), .A3(n35), .ZN(n74) );
  INV_X1 U36 ( .A(n100), .ZN(n81) );
  NOR2_X1 U37 ( .A1(n105), .A2(n104), .ZN(n106) );
  INV_X1 U38 ( .A(n48), .ZN(n49) );
  OAI222_X1 U39 ( .A1(n103), .A2(n102), .B1(n101), .B2(n100), .C1(n101), .C2(
        n99), .ZN(n104) );
  NAND2_X1 U40 ( .A1(n98), .A2(n97), .ZN(n102) );
  NOR2_X1 U41 ( .A1(n96), .A2(n95), .ZN(n105) );
  NAND2_X1 U42 ( .A1(value1[2]), .A2(n41), .ZN(n42) );
  AOI21_X1 U43 ( .B1(value1[3]), .B2(n32), .A(n28), .ZN(n43) );
  INV_X1 U44 ( .A(value2[2]), .ZN(n41) );
  NOR2_X1 U45 ( .A1(SEL[2]), .A2(SEL[0]), .ZN(n85) );
  OAI22_X1 U46 ( .A1(value1[3]), .A2(n31), .B1(value1[4]), .B2(n29), .ZN(n52)
         );
  NOR2_X1 U47 ( .A1(n50), .A2(n49), .ZN(n51) );
  INV_X1 U48 ( .A(n47), .ZN(n50) );
  NOR3_X1 U49 ( .A1(n22), .A2(n40), .A3(n21), .ZN(n57) );
  AOI22_X1 U50 ( .A1(value1[1]), .A2(n67), .B1(value1[0]), .B2(n66), .ZN(n40)
         );
  NAND2_X1 U51 ( .A1(n46), .A2(n53), .ZN(n55) );
  NAND2_X1 U52 ( .A1(n45), .A2(n44), .ZN(n46) );
  NAND2_X1 U53 ( .A1(value2[5]), .A2(n61), .ZN(n45) );
  NAND2_X1 U54 ( .A1(value2[6]), .A2(n76), .ZN(n44) );
  NOR3_X1 U55 ( .A1(n97), .A2(SEL[1]), .A3(n87), .ZN(n89) );
  OAI21_X1 U56 ( .B1(SEL[0]), .B2(n103), .A(n95), .ZN(n93) );
  INV_X1 U57 ( .A(value2[1]), .ZN(n37) );
  NAND2_X1 U58 ( .A1(n94), .A2(n93), .ZN(n107) );
  OAI211_X1 U59 ( .C1(n57), .C2(n56), .A(n55), .B(n54), .ZN(n38) );
  NAND4_X1 U60 ( .A1(n43), .A2(n47), .A3(n42), .A4(n48), .ZN(n56) );
  INV_X1 U61 ( .A(value2[0]), .ZN(n39) );
  AND2_X1 U62 ( .A1(n91), .A2(n101), .ZN(n94) );
  NAND4_X1 U63 ( .A1(n109), .A2(n108), .A3(n107), .A4(n106), .ZN(OUT) );
  AOI22_X1 U64 ( .A1(n82), .A2(n81), .B1(n26), .B2(n80), .ZN(n109) );
  NOR2_X1 U65 ( .A1(n88), .A2(n98), .ZN(n82) );
  OAI22_X1 U66 ( .A1(n90), .A2(n89), .B1(n98), .B2(n38), .ZN(n108) );
  OAI211_X1 U67 ( .C1(n56), .C2(n57), .A(n55), .B(n54), .ZN(n88) );
  INV_X1 U68 ( .A(value1[2]), .ZN(n70) );
  INV_X1 U69 ( .A(value2[1]), .ZN(n67) );
  INV_X1 U70 ( .A(value2[0]), .ZN(n66) );
  INV_X1 U71 ( .A(value1[1]), .ZN(n69) );
  INV_X1 U72 ( .A(value2[3]), .ZN(n72) );
  INV_X1 U73 ( .A(value2[6]), .ZN(n63) );
  NAND2_X1 U74 ( .A1(value1[6]), .A2(n23), .ZN(n53) );
  INV_X1 U75 ( .A(value2[5]), .ZN(n64) );
  NAND2_X1 U76 ( .A1(value1[5]), .A2(n27), .ZN(n47) );
  INV_X1 U77 ( .A(value2[4]), .ZN(n65) );
  NAND2_X1 U78 ( .A1(value1[4]), .A2(n30), .ZN(n48) );
  INV_X1 U79 ( .A(value1[5]), .ZN(n61) );
  INV_X1 U80 ( .A(value1[6]), .ZN(n76) );
  NAND3_X1 U81 ( .A1(n53), .A2(n52), .A3(n51), .ZN(n54) );
  INV_X1 U82 ( .A(value1[7]), .ZN(n58) );
  NAND2_X1 U83 ( .A1(value2[7]), .A2(n58), .ZN(n96) );
  INV_X1 U84 ( .A(n96), .ZN(n98) );
  INV_X1 U85 ( .A(SEL[1]), .ZN(n59) );
  NAND2_X1 U86 ( .A1(SEL[2]), .A2(n59), .ZN(n78) );
  NAND2_X1 U87 ( .A1(SEL[0]), .A2(n78), .ZN(n100) );
  OAI22_X1 U88 ( .A1(n64), .A2(value1[5]), .B1(n65), .B2(value1[4]), .ZN(n60)
         );
  OAI221_X1 U89 ( .B1(value2[5]), .B2(n61), .C1(value2[6]), .C2(n76), .A(n60), 
        .ZN(n62) );
  OAI21_X1 U90 ( .B1(value1[6]), .B2(n63), .A(n62), .ZN(n86) );
  INV_X1 U91 ( .A(n86), .ZN(n77) );
  INV_X1 U92 ( .A(value2[2]), .ZN(n73) );
  OAI22_X1 U93 ( .A1(value1[1]), .A2(n37), .B1(n39), .B2(value1[0]), .ZN(n68)
         );
  OAI211_X1 U94 ( .C1(value2[6]), .C2(n76), .A(n74), .B(n75), .ZN(n83) );
  NAND2_X1 U95 ( .A1(n24), .A2(n77), .ZN(n91) );
  INV_X1 U96 ( .A(SEL[0]), .ZN(n97) );
  INV_X1 U97 ( .A(n78), .ZN(n79) );
  NAND3_X1 U98 ( .A1(n96), .A2(n97), .A3(n79), .ZN(n99) );
  INV_X1 U99 ( .A(n99), .ZN(n80) );
  INV_X1 U100 ( .A(value2[7]), .ZN(n84) );
  NAND2_X1 U101 ( .A1(value1[7]), .A2(n84), .ZN(n101) );
  INV_X1 U102 ( .A(n101), .ZN(n87) );
  NAND2_X1 U103 ( .A1(SEL[1]), .A2(SEL[2]), .ZN(n103) );
  INV_X1 U104 ( .A(SEL[2]), .ZN(n92) );
  NAND2_X1 U105 ( .A1(SEL[0]), .A2(n92), .ZN(n95) );
endmodule

