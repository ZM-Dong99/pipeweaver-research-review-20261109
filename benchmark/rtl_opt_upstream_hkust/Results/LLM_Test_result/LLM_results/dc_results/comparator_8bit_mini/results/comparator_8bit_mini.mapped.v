/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:07:37 2025
/////////////////////////////////////////////////////////////


module comparator_8bit_mini ( A, B, eq, gt, lt );
  input [7:0] A;
  input [7:0] B;
  output eq, gt, lt;
  wire   n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118;

  BUF_X1 U46 ( .A(n67), .Z(n43) );
  BUF_X2 U47 ( .A(B[4]), .Z(n44) );
  NAND2_X1 U48 ( .A1(n50), .A2(A[7]), .ZN(n45) );
  AND2_X1 U49 ( .A1(A[6]), .A2(n96), .ZN(n46) );
  AND4_X2 U50 ( .A1(n65), .A2(n51), .A3(n66), .A4(n64), .ZN(n47) );
  AND4_X1 U51 ( .A1(n65), .A2(n67), .A3(n66), .A4(n64), .ZN(n61) );
  BUF_X2 U52 ( .A(B[5]), .Z(n48) );
  INV_X1 U53 ( .A(n76), .ZN(n49) );
  INV_X1 U54 ( .A(B[7]), .ZN(n50) );
  XNOR2_X1 U55 ( .A(A[6]), .B(B[6]), .ZN(n51) );
  INV_X1 U56 ( .A(B[5]), .ZN(n52) );
  AND2_X1 U57 ( .A1(n63), .A2(n62), .ZN(n53) );
  XNOR2_X1 U58 ( .A(A[7]), .B(B[7]), .ZN(n89) );
  BUF_X1 U59 ( .A(B[6]), .Z(n57) );
  XNOR2_X1 U60 ( .A(A[2]), .B(B[2]), .ZN(n114) );
  NAND2_X1 U61 ( .A1(n113), .A2(n112), .ZN(n117) );
  NAND2_X1 U62 ( .A1(n115), .A2(n114), .ZN(n116) );
  XNOR2_X1 U63 ( .A(A[0]), .B(B[0]), .ZN(n112) );
  XNOR2_X1 U64 ( .A(A[1]), .B(B[1]), .ZN(n113) );
  NOR3_X1 U65 ( .A1(n118), .A2(n117), .A3(n116), .ZN(eq) );
  INV_X1 U66 ( .A(n57), .ZN(n54) );
  AND2_X1 U67 ( .A1(A[7]), .A2(n87), .ZN(n55) );
  XNOR2_X1 U68 ( .A(n44), .B(A[4]), .ZN(n56) );
  XNOR2_X1 U69 ( .A(n48), .B(A[5]), .ZN(n58) );
  INV_X1 U70 ( .A(A[7]), .ZN(n59) );
  XNOR2_X1 U71 ( .A(A[6]), .B(B[6]), .ZN(n67) );
  XNOR2_X1 U72 ( .A(A[4]), .B(B[4]), .ZN(n66) );
  NAND4_X1 U73 ( .A1(n58), .A2(n43), .A3(n89), .A4(n56), .ZN(n118) );
  XNOR2_X1 U74 ( .A(A[3]), .B(B[3]), .ZN(n115) );
  AND2_X1 U75 ( .A1(B[7]), .A2(n69), .ZN(n60) );
  XNOR2_X1 U76 ( .A(A[1]), .B(B[1]), .ZN(n63) );
  XNOR2_X1 U77 ( .A(A[2]), .B(B[2]), .ZN(n62) );
  XNOR2_X1 U78 ( .A(A[5]), .B(B[5]), .ZN(n64) );
  XNOR2_X1 U79 ( .A(A[7]), .B(B[7]), .ZN(n65) );
  INV_X1 U80 ( .A(B[3]), .ZN(n99) );
  INV_X1 U81 ( .A(B[0]), .ZN(n98) );
  AOI211_X1 U82 ( .C1(A[3]), .C2(n99), .A(A[0]), .B(n98), .ZN(n68) );
  INV_X1 U83 ( .A(A[1]), .ZN(n79) );
  INV_X1 U84 ( .A(A[2]), .ZN(n104) );
  NAND3_X1 U85 ( .A1(n47), .A2(n53), .A3(n68), .ZN(n86) );
  INV_X1 U86 ( .A(A[7]), .ZN(n69) );
  NAND2_X1 U87 ( .A1(B[7]), .A2(n59), .ZN(n76) );
  INV_X1 U88 ( .A(n48), .ZN(n71) );
  INV_X1 U89 ( .A(A[6]), .ZN(n74) );
  AOI21_X1 U90 ( .B1(n57), .B2(n74), .A(n60), .ZN(n70) );
  NAND3_X1 U91 ( .A1(n70), .A2(n71), .A3(A[5]), .ZN(n78) );
  INV_X1 U92 ( .A(B[6]), .ZN(n96) );
  INV_X1 U93 ( .A(B[4]), .ZN(n72) );
  OAI22_X1 U94 ( .A1(A[4]), .A2(n72), .B1(n52), .B2(A[5]), .ZN(n73) );
  OAI21_X1 U95 ( .B1(n57), .B2(n74), .A(n73), .ZN(n75) );
  OAI211_X1 U96 ( .C1(A[6]), .C2(n54), .A(n75), .B(n76), .ZN(n77) );
  OAI211_X1 U97 ( .C1(n89), .C2(n49), .A(n78), .B(n77), .ZN(n85) );
  INV_X1 U98 ( .A(A[3]), .ZN(n97) );
  XOR2_X1 U99 ( .A(n97), .B(B[3]), .Z(n107) );
  NAND2_X1 U100 ( .A1(B[3]), .A2(n97), .ZN(n81) );
  INV_X1 U101 ( .A(n81), .ZN(n83) );
  INV_X1 U102 ( .A(B[2]), .ZN(n101) );
  OAI211_X1 U103 ( .C1(B[2]), .C2(n104), .A(B[1]), .B(n79), .ZN(n80) );
  OAI211_X1 U104 ( .C1(A[2]), .C2(n101), .A(n81), .B(n80), .ZN(n82) );
  OAI211_X1 U105 ( .C1(n107), .C2(n83), .A(n47), .B(n82), .ZN(n84) );
  NAND3_X1 U106 ( .A1(n85), .A2(n86), .A3(n84), .ZN(lt) );
  INV_X1 U107 ( .A(B[7]), .ZN(n87) );
  NAND2_X1 U108 ( .A1(n50), .A2(A[7]), .ZN(n90) );
  NAND2_X1 U109 ( .A1(A[6]), .A2(n96), .ZN(n92) );
  INV_X1 U110 ( .A(A[5]), .ZN(n93) );
  NAND4_X1 U111 ( .A1(n48), .A2(n45), .A3(n92), .A4(n93), .ZN(n88) );
  OAI21_X1 U112 ( .B1(n55), .B2(n89), .A(n88), .ZN(n111) );
  INV_X1 U113 ( .A(A[4]), .ZN(n91) );
  OAI21_X1 U114 ( .B1(n44), .B2(n91), .A(n90), .ZN(n95) );
  NOR2_X1 U115 ( .A1(n48), .A2(n93), .ZN(n94) );
  OAI33_X1 U116 ( .A1(n55), .A2(A[6]), .A3(n54), .B1(n95), .B2(n46), .B3(n94), 
        .ZN(n110) );
  NAND4_X1 U117 ( .A1(A[0]), .A2(n98), .A3(n115), .A4(n53), .ZN(n109) );
  NAND2_X1 U118 ( .A1(A[3]), .A2(n99), .ZN(n103) );
  INV_X1 U119 ( .A(n103), .ZN(n106) );
  INV_X1 U120 ( .A(B[1]), .ZN(n100) );
  OAI211_X1 U121 ( .C1(A[2]), .C2(n101), .A(A[1]), .B(n100), .ZN(n102) );
  OAI211_X1 U122 ( .C1(B[2]), .C2(n104), .A(n103), .B(n102), .ZN(n105) );
  OAI211_X1 U123 ( .C1(n107), .C2(n106), .A(n61), .B(n105), .ZN(n108) );
  OAI221_X1 U124 ( .B1(n110), .B2(n111), .C1(n118), .C2(n109), .A(n108), .ZN(
        gt) );
endmodule

