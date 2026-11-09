/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:28:50 2025
/////////////////////////////////////////////////////////////


module comparator_4bit_gpt ( A, B, eq, gt, lt );
  input [3:0] A;
  input [3:0] B;
  output eq, gt, lt;
  wire   n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50;

  NAND2_X1 U25 ( .A1(B[3]), .A2(n29), .ZN(n22) );
  OAI211_X1 U26 ( .C1(n24), .C2(A[1]), .A(n25), .B(A[0]), .ZN(n26) );
  OAI211_X1 U27 ( .C1(n23), .C2(B[1]), .A(n30), .B(B[0]), .ZN(n31) );
  INV_X1 U28 ( .A(A[1]), .ZN(n23) );
  INV_X1 U29 ( .A(B[1]), .ZN(n24) );
  INV_X1 U30 ( .A(B[0]), .ZN(n25) );
  INV_X1 U31 ( .A(n26), .ZN(n40) );
  XOR2_X1 U32 ( .A(A[2]), .B(B[2]), .Z(n27) );
  XNOR2_X1 U33 ( .A(A[0]), .B(B[0]), .ZN(n21) );
  INV_X1 U34 ( .A(A[0]), .ZN(n30) );
  AND2_X1 U35 ( .A1(A[3]), .A2(n32), .ZN(n28) );
  NAND2_X1 U36 ( .A1(n31), .A2(n47), .ZN(n33) );
  XNOR2_X1 U37 ( .A(A[2]), .B(B[2]), .ZN(n46) );
  INV_X1 U38 ( .A(A[3]), .ZN(n29) );
  NAND2_X1 U39 ( .A1(B[3]), .A2(n29), .ZN(n44) );
  INV_X1 U40 ( .A(A[2]), .ZN(n34) );
  INV_X1 U41 ( .A(B[1]), .ZN(n38) );
  INV_X1 U42 ( .A(A[1]), .ZN(n39) );
  NAND2_X1 U43 ( .A1(n39), .A2(B[1]), .ZN(n47) );
  INV_X1 U44 ( .A(B[3]), .ZN(n32) );
  NAND2_X1 U45 ( .A1(A[3]), .A2(n32), .ZN(n48) );
  NAND3_X1 U46 ( .A1(n33), .A2(n46), .A3(n48), .ZN(n36) );
  NAND3_X1 U47 ( .A1(n48), .A2(n34), .A3(B[2]), .ZN(n35) );
  NAND3_X1 U48 ( .A1(n36), .A2(n22), .A3(n35), .ZN(lt) );
  INV_X1 U49 ( .A(B[2]), .ZN(n37) );
  NAND3_X1 U50 ( .A1(A[2]), .A2(n44), .A3(n37), .ZN(n43) );
  NAND2_X1 U51 ( .A1(A[1]), .A2(n38), .ZN(n45) );
  INV_X1 U52 ( .A(n45), .ZN(n41) );
  OAI211_X1 U53 ( .C1(n40), .C2(n41), .A(n22), .B(n46), .ZN(n42) );
  NAND3_X1 U54 ( .A1(n42), .A2(n48), .A3(n43), .ZN(gt) );
  NAND3_X1 U55 ( .A1(n21), .A2(n45), .A3(n44), .ZN(n50) );
  INV_X1 U56 ( .A(n47), .ZN(n49) );
  NOR4_X1 U57 ( .A1(n50), .A2(n27), .A3(n49), .A4(n28), .ZN(eq) );
endmodule

