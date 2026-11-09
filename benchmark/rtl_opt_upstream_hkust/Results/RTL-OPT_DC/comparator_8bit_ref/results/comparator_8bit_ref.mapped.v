/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 02:39:34 2025
/////////////////////////////////////////////////////////////


module comparator_8bit_ref ( A, B, gt, eq, lt );
  input [7:0] A;
  input [7:0] B;
  output gt, eq, lt;
  wire   n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45,
         n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59,
         n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73,
         n74, n75, n76, n77, n78, n79, n80;

  AND2_X1 U3 ( .A1(n19), .A2(n68), .ZN(n3) );
  AND3_X1 U4 ( .A1(n47), .A2(n14), .A3(n13), .ZN(n4) );
  NAND3_X1 U5 ( .A1(n29), .A2(n28), .A3(n30), .ZN(n38) );
  INV_X1 U6 ( .A(A[7]), .ZN(n5) );
  INV_X1 U7 ( .A(A[0]), .ZN(n6) );
  NAND3_X1 U8 ( .A1(n29), .A2(n30), .A3(n28), .ZN(n7) );
  CLKBUF_X1 U9 ( .A(n54), .Z(n8) );
  INV_X1 U10 ( .A(A[1]), .ZN(n9) );
  INV_X1 U11 ( .A(B[7]), .ZN(n10) );
  INV_X1 U12 ( .A(B[7]), .ZN(n11) );
  AND3_X1 U13 ( .A1(n38), .A2(n37), .A3(n36), .ZN(n12) );
  OR2_X1 U14 ( .A1(B[2]), .A2(n49), .ZN(n13) );
  OR2_X1 U15 ( .A1(B[3]), .A2(n48), .ZN(n14) );
  INV_X1 U16 ( .A(B[4]), .ZN(n15) );
  NOR2_X1 U17 ( .A1(n16), .A2(n17), .ZN(n18) );
  NOR2_X1 U18 ( .A1(n76), .A2(n18), .ZN(n79) );
  INV_X1 U19 ( .A(n78), .ZN(n16) );
  INV_X1 U20 ( .A(n77), .ZN(n17) );
  AOI21_X1 U21 ( .B1(n70), .B2(n69), .A(n75), .ZN(n80) );
  AND3_X1 U22 ( .A1(n61), .A2(n60), .A3(n59), .ZN(n70) );
  AND3_X1 U23 ( .A1(n35), .A2(n34), .A3(n66), .ZN(n36) );
  AND2_X1 U24 ( .A1(n59), .A2(n31), .ZN(n28) );
  INV_X1 U25 ( .A(n64), .ZN(n32) );
  NAND2_X1 U26 ( .A1(n25), .A2(n24), .ZN(n29) );
  NAND2_X1 U27 ( .A1(A[2]), .A2(n23), .ZN(n24) );
  INV_X1 U28 ( .A(B[2]), .ZN(n23) );
  NAND2_X1 U29 ( .A1(B[1]), .A2(n20), .ZN(n21) );
  INV_X1 U30 ( .A(A[1]), .ZN(n20) );
  NAND2_X1 U31 ( .A1(A[7]), .A2(n51), .ZN(n34) );
  NOR2_X1 U32 ( .A1(B[3]), .A2(n48), .ZN(n33) );
  AOI22_X1 U33 ( .A1(B[3]), .A2(n48), .B1(B[2]), .B2(n49), .ZN(n30) );
  NAND2_X1 U34 ( .A1(A[6]), .A2(n50), .ZN(n35) );
  OAI22_X1 U35 ( .A1(A[3]), .A2(n63), .B1(A[4]), .B2(n15), .ZN(n65) );
  INV_X1 U36 ( .A(B[3]), .ZN(n63) );
  NAND2_X1 U37 ( .A1(B[6]), .A2(n58), .ZN(n60) );
  AOI21_X1 U38 ( .B1(B[1]), .B2(n74), .A(n73), .ZN(n78) );
  NOR2_X1 U39 ( .A1(A[2]), .A2(n72), .ZN(n73) );
  INV_X1 U40 ( .A(B[0]), .ZN(n71) );
  INV_X1 U41 ( .A(B[2]), .ZN(n72) );
  OAI211_X1 U42 ( .C1(n33), .C2(n32), .A(n59), .B(n31), .ZN(n37) );
  OAI211_X1 U43 ( .C1(A[7]), .C2(n51), .A(A[6]), .B(n50), .ZN(n19) );
  NAND2_X1 U44 ( .A1(n22), .A2(n21), .ZN(n25) );
  OAI211_X1 U45 ( .C1(n9), .C2(B[1]), .A(n6), .B(B[0]), .ZN(n22) );
  NAND2_X1 U46 ( .A1(n4), .A2(n3), .ZN(n76) );
  NOR2_X1 U47 ( .A1(n79), .A2(n80), .ZN(gt) );
  INV_X1 U48 ( .A(A[3]), .ZN(n48) );
  INV_X1 U49 ( .A(A[2]), .ZN(n49) );
  INV_X1 U50 ( .A(A[0]), .ZN(n43) );
  INV_X1 U51 ( .A(A[5]), .ZN(n26) );
  NAND2_X1 U52 ( .A1(B[5]), .A2(n26), .ZN(n59) );
  INV_X1 U53 ( .A(A[4]), .ZN(n27) );
  NAND2_X1 U54 ( .A1(B[4]), .A2(n27), .ZN(n31) );
  INV_X1 U55 ( .A(B[4]), .ZN(n62) );
  NAND2_X1 U56 ( .A1(A[4]), .A2(n15), .ZN(n64) );
  INV_X1 U57 ( .A(B[6]), .ZN(n50) );
  INV_X1 U58 ( .A(B[7]), .ZN(n51) );
  INV_X1 U59 ( .A(B[5]), .ZN(n46) );
  NAND2_X1 U60 ( .A1(A[5]), .A2(n46), .ZN(n66) );
  NAND3_X1 U61 ( .A1(n7), .A2(n37), .A3(n36), .ZN(n42) );
  INV_X1 U62 ( .A(A[7]), .ZN(n39) );
  INV_X1 U63 ( .A(A[6]), .ZN(n58) );
  OAI211_X1 U64 ( .C1(B[7]), .C2(n5), .A(B[6]), .B(n58), .ZN(n40) );
  NAND2_X1 U65 ( .A1(B[7]), .A2(n39), .ZN(n61) );
  NAND2_X1 U66 ( .A1(n40), .A2(n61), .ZN(n54) );
  INV_X1 U67 ( .A(n8), .ZN(n41) );
  NAND2_X1 U68 ( .A1(n42), .A2(n41), .ZN(lt) );
  OAI21_X1 U69 ( .B1(B[0]), .B2(n43), .A(n20), .ZN(n77) );
  INV_X1 U70 ( .A(B[0]), .ZN(n45) );
  INV_X1 U71 ( .A(B[1]), .ZN(n44) );
  AOI21_X1 U72 ( .B1(A[0]), .B2(n45), .A(n44), .ZN(n56) );
  AOI22_X1 U73 ( .A1(A[5]), .A2(n46), .B1(n62), .B2(A[4]), .ZN(n47) );
  OAI211_X1 U74 ( .C1(A[7]), .C2(n10), .A(A[6]), .B(n50), .ZN(n67) );
  INV_X1 U75 ( .A(n67), .ZN(n53) );
  NAND2_X1 U76 ( .A1(A[7]), .A2(n11), .ZN(n68) );
  INV_X1 U77 ( .A(n68), .ZN(n52) );
  NOR3_X1 U78 ( .A1(n54), .A2(n53), .A3(n52), .ZN(n55) );
  OAI211_X1 U79 ( .C1(n17), .C2(n56), .A(n4), .B(n55), .ZN(n57) );
  NOR2_X1 U80 ( .A1(n57), .A2(n12), .ZN(eq) );
  NAND3_X1 U81 ( .A1(n66), .A2(n65), .A3(n64), .ZN(n69) );
  NAND2_X1 U82 ( .A1(n19), .A2(n68), .ZN(n75) );
  NAND3_X1 U83 ( .A1(n71), .A2(A[1]), .A3(A[0]), .ZN(n74) );
endmodule

