/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:05:05 2025
/////////////////////////////////////////////////////////////


module comparator_8bit_ds ( A, B, eq, gt, lt );
  input [7:0] A;
  input [7:0] B;
  output eq, gt, lt;
  wire   n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112;

  AND2_X1 U46 ( .A1(n107), .A2(n48), .ZN(n43) );
  AND3_X1 U47 ( .A1(n62), .A2(n61), .A3(n108), .ZN(n44) );
  XNOR2_X1 U48 ( .A(A[5]), .B(B[5]), .ZN(n107) );
  XNOR2_X1 U49 ( .A(A[7]), .B(B[7]), .ZN(n45) );
  OR2_X1 U50 ( .A1(n90), .A2(n50), .ZN(n46) );
  XNOR2_X1 U51 ( .A(A[6]), .B(B[6]), .ZN(n47) );
  AND2_X1 U52 ( .A1(n60), .A2(n59), .ZN(n48) );
  XOR2_X1 U53 ( .A(A[7]), .B(B[7]), .Z(n54) );
  NOR2_X1 U54 ( .A1(n49), .A2(A[4]), .ZN(n50) );
  INV_X1 U55 ( .A(B[4]), .ZN(n49) );
  XNOR2_X1 U56 ( .A(A[2]), .B(B[2]), .ZN(n108) );
  AOI21_X1 U57 ( .B1(n91), .B2(n92), .A(n46), .ZN(n93) );
  OAI21_X1 U58 ( .B1(n101), .B2(B[3]), .A(n81), .ZN(n82) );
  AOI211_X1 U59 ( .C1(A[4]), .C2(n89), .A(A[3]), .B(n88), .ZN(n90) );
  NAND2_X1 U60 ( .A1(n93), .A2(n43), .ZN(n100) );
  AND2_X1 U61 ( .A1(n60), .A2(n59), .ZN(n51) );
  XNOR2_X1 U62 ( .A(A[6]), .B(B[6]), .ZN(n59) );
  AND2_X1 U63 ( .A1(A[4]), .A2(n89), .ZN(n52) );
  AND2_X1 U64 ( .A1(n83), .A2(A[2]), .ZN(n53) );
  NOR3_X1 U65 ( .A1(n82), .A2(n53), .A3(n52), .ZN(n92) );
  OAI211_X1 U66 ( .C1(n71), .C2(n44), .A(n70), .B(n107), .ZN(n78) );
  NOR3_X1 U67 ( .A1(n76), .A2(n75), .A3(n55), .ZN(n77) );
  NAND4_X1 U68 ( .A1(n67), .A2(n66), .A3(n65), .A4(n64), .ZN(n71) );
  XNOR2_X1 U69 ( .A(A[7]), .B(B[7]), .ZN(n60) );
  NOR3_X1 U70 ( .A1(n73), .A2(n54), .A3(A[6]), .ZN(n75) );
  INV_X1 U71 ( .A(B[6]), .ZN(n73) );
  INV_X1 U72 ( .A(B[5]), .ZN(n72) );
  NOR2_X1 U73 ( .A1(A[0]), .A2(n87), .ZN(n62) );
  AOI22_X1 U74 ( .A1(n69), .A2(n68), .B1(A[4]), .B2(n89), .ZN(n70) );
  NOR2_X1 U75 ( .A1(B[3]), .A2(n101), .ZN(n69) );
  NAND2_X1 U76 ( .A1(B[4]), .A2(n102), .ZN(n68) );
  NAND2_X1 U77 ( .A1(B[4]), .A2(n102), .ZN(n64) );
  NAND2_X1 U78 ( .A1(B[3]), .A2(n63), .ZN(n66) );
  INV_X1 U79 ( .A(A[3]), .ZN(n63) );
  AND2_X1 U80 ( .A1(B[7]), .A2(n74), .ZN(n55) );
  NAND2_X1 U81 ( .A1(n57), .A2(n85), .ZN(n65) );
  OAI211_X1 U82 ( .C1(n57), .C2(n85), .A(n84), .B(B[1]), .ZN(n67) );
  INV_X1 U83 ( .A(B[1]), .ZN(n56) );
  INV_X1 U84 ( .A(n83), .ZN(n57) );
  INV_X1 U85 ( .A(B[2]), .ZN(n58) );
  NAND2_X1 U86 ( .A1(A[1]), .A2(n80), .ZN(n61) );
  OAI21_X1 U87 ( .B1(n78), .B2(n79), .A(n77), .ZN(lt) );
  NOR3_X1 U88 ( .A1(n79), .A2(A[5]), .A3(n72), .ZN(n76) );
  INV_X1 U89 ( .A(A[7]), .ZN(n74) );
  INV_X1 U90 ( .A(A[6]), .ZN(n95) );
  NAND2_X1 U91 ( .A1(n45), .A2(n47), .ZN(n79) );
  INV_X1 U92 ( .A(B[0]), .ZN(n87) );
  INV_X1 U93 ( .A(B[1]), .ZN(n80) );
  INV_X1 U94 ( .A(A[2]), .ZN(n85) );
  INV_X1 U95 ( .A(A[1]), .ZN(n84) );
  INV_X1 U96 ( .A(A[4]), .ZN(n102) );
  INV_X1 U97 ( .A(A[3]), .ZN(n101) );
  INV_X1 U98 ( .A(B[4]), .ZN(n89) );
  INV_X1 U99 ( .A(A[5]), .ZN(n94) );
  INV_X1 U100 ( .A(B[2]), .ZN(n83) );
  OAI211_X1 U101 ( .C1(n58), .C2(A[2]), .A(A[1]), .B(n56), .ZN(n81) );
  AOI22_X1 U102 ( .A1(B[2]), .A2(n85), .B1(B[1]), .B2(n84), .ZN(n86) );
  NAND3_X1 U103 ( .A1(A[0]), .A2(n87), .A3(n86), .ZN(n91) );
  INV_X1 U104 ( .A(B[3]), .ZN(n88) );
  NOR2_X1 U105 ( .A1(B[5]), .A2(n94), .ZN(n98) );
  INV_X1 U106 ( .A(B[7]), .ZN(n97) );
  NOR3_X1 U107 ( .A1(n54), .A2(B[6]), .A3(n95), .ZN(n96) );
  AOI221_X1 U108 ( .B1(n98), .B2(n51), .C1(A[7]), .C2(n97), .A(n96), .ZN(n99)
         );
  NAND2_X1 U109 ( .A1(n100), .A2(n99), .ZN(gt) );
  XOR2_X1 U110 ( .A(n101), .B(B[3]), .Z(n106) );
  XOR2_X1 U111 ( .A(n102), .B(B[4]), .Z(n105) );
  INV_X1 U112 ( .A(A[0]), .ZN(n103) );
  XOR2_X1 U113 ( .A(n103), .B(B[0]), .Z(n104) );
  NAND4_X1 U114 ( .A1(n48), .A2(n105), .A3(n106), .A4(n104), .ZN(n112) );
  XOR2_X1 U115 ( .A(B[1]), .B(A[1]), .Z(n111) );
  INV_X1 U116 ( .A(n107), .ZN(n110) );
  INV_X1 U117 ( .A(n108), .ZN(n109) );
  NOR4_X1 U118 ( .A1(n112), .A2(n111), .A3(n110), .A4(n109), .ZN(eq) );
endmodule

