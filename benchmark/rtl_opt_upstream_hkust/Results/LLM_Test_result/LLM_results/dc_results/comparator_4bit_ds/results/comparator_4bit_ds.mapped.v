/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:05:01 2025
/////////////////////////////////////////////////////////////


module comparator_4bit_ds ( A, B, eq, gt, lt );
  input [3:0] A;
  input [3:0] B;
  output eq, gt, lt;
  wire   n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n35, n36, n37, n38, n39, n40;

  AND2_X1 U22 ( .A1(B[1]), .A2(n30), .ZN(n19) );
  NOR2_X1 U23 ( .A1(n22), .A2(n19), .ZN(n27) );
  AND2_X1 U24 ( .A1(A[1]), .A2(n32), .ZN(n20) );
  NOR2_X1 U25 ( .A1(n31), .A2(n20), .ZN(n36) );
  XNOR2_X1 U26 ( .A(A[3]), .B(B[3]), .ZN(n33) );
  XNOR2_X1 U27 ( .A(A[2]), .B(B[2]), .ZN(n24) );
  XNOR2_X1 U28 ( .A(A[3]), .B(B[3]), .ZN(n23) );
  INV_X1 U29 ( .A(B[3]), .ZN(n28) );
  INV_X1 U30 ( .A(A[1]), .ZN(n30) );
  INV_X1 U31 ( .A(B[1]), .ZN(n32) );
  INV_X1 U32 ( .A(B[0]), .ZN(n21) );
  AOI211_X1 U33 ( .C1(A[1]), .C2(n32), .A(A[0]), .B(n21), .ZN(n22) );
  INV_X1 U34 ( .A(A[2]), .ZN(n25) );
  INV_X1 U35 ( .A(A[3]), .ZN(n37) );
  NAND2_X1 U36 ( .A1(n23), .A2(n24), .ZN(n38) );
  NAND3_X1 U37 ( .A1(B[2]), .A2(n25), .A3(n33), .ZN(n26) );
  OAI221_X1 U38 ( .B1(A[3]), .B2(n28), .C1(n27), .C2(n38), .A(n26), .ZN(lt) );
  INV_X1 U39 ( .A(A[0]), .ZN(n29) );
  AOI211_X1 U40 ( .C1(B[1]), .C2(n30), .A(B[0]), .B(n29), .ZN(n31) );
  INV_X1 U41 ( .A(B[2]), .ZN(n34) );
  NAND3_X1 U42 ( .A1(A[2]), .A2(n34), .A3(n33), .ZN(n35) );
  OAI221_X1 U43 ( .B1(B[3]), .B2(n37), .C1(n36), .C2(n38), .A(n35), .ZN(gt) );
  XOR2_X1 U44 ( .A(B[1]), .B(A[1]), .Z(n40) );
  XOR2_X1 U45 ( .A(B[0]), .B(A[0]), .Z(n39) );
  NOR3_X1 U46 ( .A1(n38), .A2(n39), .A3(n40), .ZN(eq) );
endmodule

