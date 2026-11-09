/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:07:33 2025
/////////////////////////////////////////////////////////////


module comparator_4bit_mini ( A, B, eq, gt, lt );
  input [3:0] A;
  input [3:0] B;
  output eq, gt, lt;
  wire   n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44;

  INV_X1 U22 ( .A(A[1]), .ZN(n22) );
  INV_X1 U23 ( .A(B[1]), .ZN(n35) );
  INV_X1 U24 ( .A(B[0]), .ZN(n33) );
  NAND2_X1 U25 ( .A1(A[1]), .A2(n35), .ZN(n37) );
  NOR2_X1 U26 ( .A1(n42), .A2(A[2]), .ZN(n36) );
  OAI211_X1 U27 ( .C1(n34), .C2(A[1]), .A(n33), .B(A[0]), .ZN(n38) );
  AND2_X1 U28 ( .A1(A[3]), .A2(n26), .ZN(n19) );
  INV_X1 U29 ( .A(A[1]), .ZN(n21) );
  INV_X1 U30 ( .A(A[0]), .ZN(n20) );
  NAND2_X1 U31 ( .A1(B[1]), .A2(n22), .ZN(n24) );
  NOR2_X1 U32 ( .A1(B[2]), .A2(n30), .ZN(n23) );
  AOI21_X1 U33 ( .B1(n38), .B2(n37), .A(n36), .ZN(n40) );
  NAND2_X1 U34 ( .A1(n32), .A2(n31), .ZN(lt) );
  NAND2_X1 U35 ( .A1(n44), .A2(n43), .ZN(gt) );
  AOI21_X1 U36 ( .B1(n29), .B2(n39), .A(n28), .ZN(n32) );
  AOI21_X1 U37 ( .B1(n40), .B2(n41), .A(n19), .ZN(n44) );
  INV_X1 U38 ( .A(n41), .ZN(n28) );
  AOI21_X1 U39 ( .B1(n25), .B2(n24), .A(n23), .ZN(n29) );
  OAI211_X1 U40 ( .C1(n21), .C2(B[1]), .A(n20), .B(B[0]), .ZN(n25) );
  INV_X1 U41 ( .A(A[2]), .ZN(n30) );
  INV_X1 U42 ( .A(B[3]), .ZN(n26) );
  NAND2_X1 U43 ( .A1(A[3]), .A2(n26), .ZN(n39) );
  INV_X1 U44 ( .A(A[3]), .ZN(n27) );
  NAND2_X1 U45 ( .A1(B[3]), .A2(n27), .ZN(n41) );
  NAND3_X1 U46 ( .A1(n30), .A2(n39), .A3(B[2]), .ZN(n31) );
  INV_X1 U47 ( .A(B[1]), .ZN(n34) );
  INV_X1 U48 ( .A(B[2]), .ZN(n42) );
  NAND3_X1 U49 ( .A1(n42), .A2(n41), .A3(A[2]), .ZN(n43) );
  NOR2_X1 U50 ( .A1(lt), .A2(gt), .ZN(eq) );
endmodule

