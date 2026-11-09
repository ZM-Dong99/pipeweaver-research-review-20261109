/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:38:40 2025
/////////////////////////////////////////////////////////////


module comparator_dsr ( SEL, value1, value2, OUT );
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
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123;

  AND3_X1 U16 ( .A1(n69), .A2(n70), .A3(SEL[0]), .ZN(n15) );
  AND2_X1 U17 ( .A1(n29), .A2(n25), .ZN(n16) );
  AND2_X1 U18 ( .A1(SEL[0]), .A2(n99), .ZN(n17) );
  OAI22_X1 U19 ( .A1(n23), .A2(value2[4]), .B1(n20), .B2(value2[3]), .ZN(n84)
         );
  AOI21_X1 U20 ( .B1(n50), .B2(n109), .A(n107), .ZN(n88) );
  AOI22_X1 U21 ( .A1(n87), .A2(value2[5]), .B1(n52), .B2(value2[4]), .ZN(n73)
         );
  OAI222_X1 U22 ( .A1(n58), .A2(value2[7]), .B1(n39), .B2(value2[6]), .C1(n47), 
        .C2(value2[3]), .ZN(n44) );
  NAND2_X1 U23 ( .A1(n18), .A2(value2[5]), .ZN(n42) );
  INV_X1 U24 ( .A(value1[5]), .ZN(n18) );
  BUF_X1 U25 ( .A(value2[5]), .Z(n19) );
  NAND2_X1 U26 ( .A1(value2[4]), .A2(n24), .ZN(n43) );
  INV_X1 U27 ( .A(value1[3]), .ZN(n20) );
  INV_X1 U28 ( .A(value1[7]), .ZN(n21) );
  INV_X1 U29 ( .A(value1[7]), .ZN(n22) );
  INV_X1 U30 ( .A(value1[4]), .ZN(n23) );
  INV_X1 U31 ( .A(value1[4]), .ZN(n24) );
  NAND2_X1 U32 ( .A1(value1[5]), .A2(n85), .ZN(n25) );
  INV_X1 U33 ( .A(value2[1]), .ZN(n26) );
  INV_X1 U34 ( .A(value2[1]), .ZN(n27) );
  OAI22_X1 U35 ( .A1(value1[1]), .A2(n27), .B1(value1[0]), .B2(n76), .ZN(n28)
         );
  NAND2_X1 U36 ( .A1(value1[1]), .A2(n26), .ZN(n29) );
  AOI22_X1 U37 ( .A1(n19), .A2(n87), .B1(value2[4]), .B2(n83), .ZN(n30) );
  CLKBUF_X1 U38 ( .A(n25), .Z(n31) );
  BUF_X1 U39 ( .A(n90), .Z(n51) );
  AND2_X1 U40 ( .A1(n41), .A2(n86), .ZN(n32) );
  NAND3_X1 U41 ( .A1(n36), .A2(n37), .A3(n78), .ZN(n33) );
  NAND2_X1 U42 ( .A1(n68), .A2(n15), .ZN(n71) );
  AND3_X1 U43 ( .A1(n67), .A2(n46), .A3(n45), .ZN(n34) );
  AOI22_X1 U44 ( .A1(value1[0]), .A2(n76), .B1(n38), .B2(value2[6]), .ZN(n35)
         );
  OR2_X1 U45 ( .A1(value2[1]), .A2(n80), .ZN(n36) );
  OR2_X1 U46 ( .A1(value2[2]), .A2(n79), .ZN(n37) );
  NAND3_X1 U47 ( .A1(n36), .A2(n37), .A3(n28), .ZN(n109) );
  INV_X1 U48 ( .A(value1[6]), .ZN(n38) );
  INV_X1 U49 ( .A(value1[6]), .ZN(n39) );
  AND3_X1 U50 ( .A1(n93), .A2(n91), .A3(n65), .ZN(n40) );
  AND2_X1 U51 ( .A1(n48), .A2(n40), .ZN(n57) );
  OR2_X1 U52 ( .A1(n19), .A2(n87), .ZN(n41) );
  NAND2_X1 U53 ( .A1(n86), .A2(n41), .ZN(n108) );
  NAND3_X1 U54 ( .A1(n42), .A2(n43), .A3(n84), .ZN(n86) );
  OR2_X1 U55 ( .A1(value2[4]), .A2(n24), .ZN(n45) );
  OR2_X1 U56 ( .A1(value2[2]), .A2(n79), .ZN(n46) );
  NAND3_X1 U57 ( .A1(n35), .A2(n46), .A3(n45), .ZN(n102) );
  NAND3_X1 U58 ( .A1(n34), .A2(n51), .A3(n16), .ZN(n68) );
  NAND2_X1 U59 ( .A1(n106), .A2(n114), .ZN(n112) );
  INV_X1 U60 ( .A(n107), .ZN(n111) );
  NAND2_X1 U61 ( .A1(n95), .A2(n94), .ZN(n96) );
  NAND4_X1 U62 ( .A1(n63), .A2(n62), .A3(SEL[2]), .A4(n61), .ZN(n72) );
  INV_X1 U63 ( .A(SEL[0]), .ZN(n63) );
  NAND2_X1 U64 ( .A1(n117), .A2(n116), .ZN(n118) );
  NAND2_X1 U65 ( .A1(n115), .A2(n114), .ZN(n117) );
  AND2_X1 U66 ( .A1(n92), .A2(SEL[1]), .ZN(n69) );
  INV_X1 U67 ( .A(SEL[1]), .ZN(n62) );
  INV_X1 U68 ( .A(value1[3]), .ZN(n47) );
  INV_X1 U69 ( .A(n66), .ZN(n48) );
  AND3_X1 U70 ( .A1(n73), .A2(n56), .A3(n55), .ZN(n49) );
  AND3_X1 U71 ( .A1(n30), .A2(n56), .A3(n55), .ZN(n50) );
  NAND2_X1 U72 ( .A1(n119), .A2(n118), .ZN(n120) );
  INV_X1 U73 ( .A(value1[4]), .ZN(n52) );
  AOI21_X1 U74 ( .B1(n50), .B2(n33), .A(n108), .ZN(n110) );
  INV_X1 U75 ( .A(value1[6]), .ZN(n53) );
  INV_X1 U76 ( .A(value1[6]), .ZN(n54) );
  NAND2_X1 U77 ( .A1(n104), .A2(n17), .ZN(n94) );
  OR2_X1 U78 ( .A1(value1[2]), .A2(n75), .ZN(n55) );
  OR2_X1 U79 ( .A1(value1[3]), .A2(n74), .ZN(n56) );
  NAND2_X1 U80 ( .A1(value2[7]), .A2(n22), .ZN(n92) );
  NAND4_X1 U81 ( .A1(n90), .A2(n92), .A3(n29), .A4(n31), .ZN(n101) );
  INV_X1 U82 ( .A(value1[7]), .ZN(n58) );
  INV_X1 U83 ( .A(value1[7]), .ZN(n59) );
  NAND2_X1 U84 ( .A1(n71), .A2(n72), .ZN(n98) );
  NAND2_X1 U85 ( .A1(n88), .A2(n32), .ZN(n97) );
  NAND2_X1 U86 ( .A1(n57), .A2(n34), .ZN(n103) );
  NAND2_X1 U87 ( .A1(n122), .A2(n123), .ZN(OUT) );
  AOI21_X1 U88 ( .B1(n98), .B2(n97), .A(n96), .ZN(n123) );
  OAI21_X1 U89 ( .B1(n101), .B2(n102), .A(n17), .ZN(n95) );
  NOR2_X1 U90 ( .A1(n121), .A2(n120), .ZN(n122) );
  AOI211_X1 U91 ( .C1(n105), .C2(n114), .A(n104), .B(n103), .ZN(n121) );
  INV_X1 U92 ( .A(value1[7]), .ZN(n89) );
  OAI211_X1 U93 ( .C1(value2[7]), .C2(n21), .A(value2[6]), .B(n38), .ZN(n60)
         );
  NAND2_X1 U94 ( .A1(value2[7]), .A2(n89), .ZN(n65) );
  NAND2_X1 U95 ( .A1(n60), .A2(n92), .ZN(n116) );
  INV_X1 U96 ( .A(n116), .ZN(n61) );
  INV_X1 U97 ( .A(value2[7]), .ZN(n64) );
  NAND2_X1 U98 ( .A1(value1[7]), .A2(n64), .ZN(n81) );
  NAND3_X1 U99 ( .A1(value2[6]), .A2(n54), .A3(n81), .ZN(n70) );
  INV_X1 U100 ( .A(value2[1]), .ZN(n77) );
  NAND2_X1 U101 ( .A1(value1[1]), .A2(n77), .ZN(n91) );
  INV_X1 U102 ( .A(value2[5]), .ZN(n85) );
  NAND2_X1 U103 ( .A1(value1[5]), .A2(n85), .ZN(n93) );
  INV_X1 U104 ( .A(value1[3]), .ZN(n82) );
  OAI222_X1 U105 ( .A1(value2[7]), .A2(n59), .B1(value2[6]), .B2(n53), .C1(n82), .C2(value2[3]), .ZN(n66) );
  INV_X1 U106 ( .A(n44), .ZN(n90) );
  INV_X1 U107 ( .A(value1[4]), .ZN(n83) );
  INV_X1 U108 ( .A(value1[2]), .ZN(n79) );
  INV_X1 U109 ( .A(value2[0]), .ZN(n76) );
  AOI22_X1 U110 ( .A1(value1[0]), .A2(n76), .B1(n54), .B2(value2[6]), .ZN(n67)
         );
  INV_X1 U111 ( .A(value2[2]), .ZN(n75) );
  INV_X1 U112 ( .A(value2[3]), .ZN(n74) );
  INV_X1 U113 ( .A(value1[5]), .ZN(n87) );
  INV_X1 U114 ( .A(value1[1]), .ZN(n80) );
  OAI22_X1 U115 ( .A1(value1[1]), .A2(n26), .B1(value1[0]), .B2(n76), .ZN(n78)
         );
  NAND2_X1 U116 ( .A1(n49), .A2(n33), .ZN(n104) );
  OAI21_X1 U117 ( .B1(value2[6]), .B2(n38), .A(n81), .ZN(n107) );
  INV_X1 U118 ( .A(SEL[2]), .ZN(n99) );
  INV_X1 U119 ( .A(SEL[0]), .ZN(n113) );
  NAND3_X1 U120 ( .A1(n113), .A2(n99), .A3(SEL[1]), .ZN(n105) );
  INV_X1 U121 ( .A(SEL[1]), .ZN(n100) );
  NAND2_X1 U122 ( .A1(SEL[0]), .A2(n100), .ZN(n114) );
  NAND3_X1 U123 ( .A1(n113), .A2(SEL[2]), .A3(SEL[1]), .ZN(n106) );
  NAND3_X1 U124 ( .A1(n110), .A2(n111), .A3(n112), .ZN(n119) );
  NAND3_X1 U125 ( .A1(SEL[1]), .A2(n113), .A3(SEL[2]), .ZN(n115) );
endmodule

