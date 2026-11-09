/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:38:36 2025
/////////////////////////////////////////////////////////////


module comparator_16bit_dsr ( A, B, gt, eq, lt );
  input [15:0] A;
  input [15:0] B;
  output gt, eq, lt;
  wire   n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45,
         n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59,
         n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73,
         n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87,
         n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121;

  INV_X1 U4 ( .A(A[13]), .ZN(n3) );
  INV_X1 U5 ( .A(A[13]), .ZN(n4) );
  CLKBUF_X1 U6 ( .A(n104), .Z(n5) );
  OR2_X1 U7 ( .A1(A[11]), .A2(n49), .ZN(n18) );
  AND3_X1 U8 ( .A1(n111), .A2(n112), .A3(n113), .ZN(n6) );
  INV_X1 U9 ( .A(A[8]), .ZN(n7) );
  AND3_X1 U10 ( .A1(n108), .A2(n106), .A3(n107), .ZN(n8) );
  AND3_X1 U11 ( .A1(n17), .A2(n18), .A3(n43), .ZN(n9) );
  AND4_X1 U12 ( .A1(n32), .A2(n31), .A3(n74), .A4(n69), .ZN(n10) );
  BUF_X1 U13 ( .A(B[9]), .Z(n11) );
  OAI22_X1 U14 ( .A1(n87), .A2(A[10]), .B1(n86), .B2(A[9]), .ZN(n104) );
  NAND3_X1 U15 ( .A1(n121), .A2(n16), .A3(n21), .ZN(gt) );
  AND2_X1 U16 ( .A1(n22), .A2(n114), .ZN(n16) );
  AND2_X1 U17 ( .A1(n47), .A2(n46), .ZN(n12) );
  AND2_X1 U18 ( .A1(B[10]), .A2(n50), .ZN(n13) );
  AND2_X1 U19 ( .A1(n11), .A2(n54), .ZN(n14) );
  NOR3_X1 U20 ( .A1(n13), .A2(n14), .A3(n105), .ZN(n60) );
  AND3_X1 U21 ( .A1(n40), .A2(n20), .A3(n19), .ZN(n15) );
  OR2_X1 U22 ( .A1(A[12]), .A2(n48), .ZN(n17) );
  NAND3_X1 U23 ( .A1(n17), .A2(n18), .A3(n43), .ZN(n46) );
  OR2_X1 U24 ( .A1(B[5]), .A2(n42), .ZN(n19) );
  OR2_X1 U25 ( .A1(B[4]), .A2(n41), .ZN(n20) );
  NAND3_X1 U26 ( .A1(n40), .A2(n20), .A3(n19), .ZN(n97) );
  NAND2_X1 U27 ( .A1(n117), .A2(n116), .ZN(n21) );
  NAND2_X1 U28 ( .A1(n115), .A2(n6), .ZN(n22) );
  NAND4_X1 U29 ( .A1(n90), .A2(n92), .A3(n110), .A4(n91), .ZN(n99) );
  NOR2_X1 U30 ( .A1(n71), .A2(n57), .ZN(n92) );
  AOI221_X1 U31 ( .B1(B[7]), .B2(n89), .C1(B[8]), .C2(n88), .A(n104), .ZN(n90)
         );
  NOR2_X1 U32 ( .A1(n85), .A2(n84), .ZN(n91) );
  NAND4_X1 U33 ( .A1(n83), .A2(n82), .A3(n81), .A4(n80), .ZN(n84) );
  NAND2_X1 U34 ( .A1(B[1]), .A2(n78), .ZN(n83) );
  NAND2_X1 U35 ( .A1(B[12]), .A2(n79), .ZN(n82) );
  NAND2_X1 U36 ( .A1(B[14]), .A2(n101), .ZN(n81) );
  NAND2_X1 U37 ( .A1(B[13]), .A2(n100), .ZN(n80) );
  INV_X1 U38 ( .A(A[12]), .ZN(n79) );
  OAI211_X1 U39 ( .C1(A[15]), .C2(n70), .A(n114), .B(n69), .ZN(n71) );
  NAND4_X1 U40 ( .A1(n77), .A2(n76), .A3(n75), .A4(n74), .ZN(n85) );
  NAND2_X1 U41 ( .A1(B[11]), .A2(n72), .ZN(n77) );
  NAND2_X1 U42 ( .A1(B[0]), .A2(n73), .ZN(n76) );
  NAND2_X1 U43 ( .A1(B[2]), .A2(n25), .ZN(n75) );
  NAND4_X1 U44 ( .A1(n32), .A2(n31), .A3(n74), .A4(n69), .ZN(n98) );
  NAND2_X1 U45 ( .A1(B[1]), .A2(n30), .ZN(n31) );
  AOI22_X1 U46 ( .A1(n29), .A2(n28), .B1(B[2]), .B2(n25), .ZN(n32) );
  INV_X1 U47 ( .A(A[1]), .ZN(n30) );
  NAND2_X1 U48 ( .A1(A[1]), .A2(n27), .ZN(n28) );
  NAND2_X1 U49 ( .A1(A[0]), .A2(n26), .ZN(n29) );
  INV_X1 U50 ( .A(B[0]), .ZN(n26) );
  INV_X1 U51 ( .A(A[1]), .ZN(n78) );
  INV_X1 U52 ( .A(A[0]), .ZN(n73) );
  INV_X1 U53 ( .A(A[3]), .ZN(n23) );
  CLKBUF_X1 U54 ( .A(n116), .Z(n24) );
  INV_X1 U55 ( .A(A[2]), .ZN(n25) );
  INV_X1 U56 ( .A(B[1]), .ZN(n27) );
  INV_X1 U57 ( .A(A[2]), .ZN(n35) );
  INV_X1 U58 ( .A(A[4]), .ZN(n41) );
  NAND2_X1 U59 ( .A1(B[4]), .A2(n41), .ZN(n74) );
  INV_X1 U60 ( .A(A[3]), .ZN(n36) );
  NAND2_X1 U61 ( .A1(B[3]), .A2(n36), .ZN(n69) );
  INV_X1 U62 ( .A(A[7]), .ZN(n89) );
  INV_X1 U63 ( .A(A[6]), .ZN(n55) );
  OAI22_X1 U64 ( .A1(B[7]), .A2(n89), .B1(B[6]), .B2(n55), .ZN(n33) );
  INV_X1 U65 ( .A(n33), .ZN(n56) );
  INV_X1 U66 ( .A(A[8]), .ZN(n88) );
  INV_X1 U67 ( .A(A[9]), .ZN(n54) );
  OAI22_X1 U68 ( .A1(B[8]), .A2(n88), .B1(n11), .B2(n54), .ZN(n34) );
  INV_X1 U69 ( .A(n34), .ZN(n58) );
  NAND2_X1 U70 ( .A1(n56), .A2(n58), .ZN(n120) );
  NOR2_X1 U71 ( .A1(n10), .A2(n120), .ZN(n63) );
  INV_X1 U72 ( .A(A[5]), .ZN(n42) );
  INV_X1 U73 ( .A(B[4]), .ZN(n39) );
  INV_X1 U74 ( .A(B[3]), .ZN(n38) );
  OAI22_X1 U75 ( .A1(n23), .A2(B[3]), .B1(n35), .B2(B[2]), .ZN(n37) );
  OAI221_X1 U76 ( .B1(A[4]), .B2(n39), .C1(A[3]), .C2(n38), .A(n37), .ZN(n40)
         );
  INV_X1 U77 ( .A(B[12]), .ZN(n48) );
  INV_X1 U78 ( .A(B[11]), .ZN(n49) );
  INV_X1 U79 ( .A(A[11]), .ZN(n72) );
  INV_X1 U80 ( .A(A[10]), .ZN(n50) );
  OAI22_X1 U81 ( .A1(B[11]), .A2(n72), .B1(B[10]), .B2(n50), .ZN(n43) );
  INV_X1 U82 ( .A(A[12]), .ZN(n44) );
  INV_X1 U83 ( .A(A[13]), .ZN(n100) );
  OAI22_X1 U84 ( .A1(B[12]), .A2(n44), .B1(B[13]), .B2(n3), .ZN(n45) );
  NOR3_X1 U85 ( .A1(n97), .A2(n9), .A3(n45), .ZN(n62) );
  INV_X1 U86 ( .A(n45), .ZN(n47) );
  NAND2_X1 U87 ( .A1(n47), .A2(n46), .ZN(n119) );
  OAI22_X1 U88 ( .A1(A[11]), .A2(n49), .B1(A[12]), .B2(n48), .ZN(n105) );
  INV_X1 U89 ( .A(B[8]), .ZN(n52) );
  INV_X1 U90 ( .A(B[7]), .ZN(n51) );
  OAI22_X1 U91 ( .A1(A[8]), .A2(n52), .B1(n51), .B2(A[7]), .ZN(n53) );
  OAI221_X1 U92 ( .B1(B[8]), .B2(n7), .C1(n11), .C2(n54), .A(n53), .ZN(n106)
         );
  INV_X1 U93 ( .A(B[5]), .ZN(n68) );
  NAND2_X1 U94 ( .A1(B[6]), .A2(n55), .ZN(n67) );
  OAI21_X1 U95 ( .B1(A[5]), .B2(n68), .A(n67), .ZN(n57) );
  NAND3_X1 U96 ( .A1(n58), .A2(n57), .A3(n56), .ZN(n59) );
  NAND3_X1 U97 ( .A1(n60), .A2(n106), .A3(n59), .ZN(n61) );
  AOI22_X1 U98 ( .A1(n63), .A2(n62), .B1(n61), .B2(n12), .ZN(n96) );
  INV_X1 U99 ( .A(A[15]), .ZN(n64) );
  NAND2_X1 U100 ( .A1(B[15]), .A2(n64), .ZN(n113) );
  INV_X1 U101 ( .A(n113), .ZN(n93) );
  INV_X1 U102 ( .A(A[14]), .ZN(n101) );
  NAND2_X1 U103 ( .A1(B[14]), .A2(n101), .ZN(n112) );
  INV_X1 U104 ( .A(n112), .ZN(n65) );
  AOI211_X1 U105 ( .C1(B[13]), .C2(n100), .A(n93), .B(n65), .ZN(n95) );
  INV_X1 U106 ( .A(B[14]), .ZN(n66) );
  NAND2_X1 U107 ( .A1(A[14]), .A2(n66), .ZN(n110) );
  INV_X1 U108 ( .A(B[15]), .ZN(n70) );
  NAND2_X1 U109 ( .A1(A[15]), .A2(n70), .ZN(n114) );
  OAI21_X1 U110 ( .B1(A[5]), .B2(n68), .A(n67), .ZN(n102) );
  INV_X1 U111 ( .A(B[10]), .ZN(n87) );
  INV_X1 U112 ( .A(B[9]), .ZN(n86) );
  OAI211_X1 U113 ( .C1(n93), .C2(n110), .A(n99), .B(n114), .ZN(n94) );
  AOI21_X1 U114 ( .B1(n96), .B2(n95), .A(n94), .ZN(lt) );
  NAND2_X1 U115 ( .A1(n15), .A2(n98), .ZN(n116) );
  NOR4_X1 U116 ( .A1(n24), .A2(n99), .A3(n120), .A4(n119), .ZN(eq) );
  OAI211_X1 U117 ( .C1(B[14]), .C2(n101), .A(B[13]), .B(n4), .ZN(n111) );
  INV_X1 U118 ( .A(n102), .ZN(n103) );
  NAND4_X1 U119 ( .A1(n103), .A2(n112), .A3(n111), .A4(n113), .ZN(n109) );
  INV_X1 U120 ( .A(n5), .ZN(n108) );
  INV_X1 U121 ( .A(n105), .ZN(n107) );
  NAND3_X1 U122 ( .A1(n106), .A2(n107), .A3(n108), .ZN(n118) );
  NOR2_X1 U123 ( .A1(n118), .A2(n109), .ZN(n117) );
  INV_X1 U124 ( .A(n110), .ZN(n115) );
  OAI221_X1 U125 ( .B1(n119), .B2(n120), .C1(n8), .C2(n119), .A(n6), .ZN(n121)
         );
endmodule

