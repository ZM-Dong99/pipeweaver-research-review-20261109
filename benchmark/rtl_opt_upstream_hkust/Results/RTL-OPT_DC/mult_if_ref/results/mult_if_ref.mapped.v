/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Wed May 14 19:07:37 2025
/////////////////////////////////////////////////////////////


module mult_if_ref ( A, C, CTRL_is_late_arriving, Z );
  input [7:0] A;
  input [4:0] C;
  input CTRL_is_late_arriving;
  output Z;
  wire   n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29;

  NOR2_X1 U16 ( .A1(n16), .A2(CTRL_is_late_arriving), .ZN(n18) );
  INV_X1 U17 ( .A(C[3]), .ZN(n16) );
  OR2_X1 U18 ( .A1(C[0]), .A2(n29), .ZN(n17) );
  NAND2_X1 U19 ( .A1(n28), .A2(n17), .ZN(Z) );
  AND2_X1 U20 ( .A1(A[2]), .A2(C[1]), .ZN(n19) );
  INV_X1 U21 ( .A(C[1]), .ZN(n21) );
  AOI22_X1 U22 ( .A1(C[2]), .A2(n19), .B1(A[1]), .B2(n21), .ZN(n29) );
  INV_X1 U23 ( .A(CTRL_is_late_arriving), .ZN(n20) );
  NAND2_X1 U24 ( .A1(C[3]), .A2(n20), .ZN(n23) );
  NOR4_X1 U25 ( .A1(n18), .A2(n21), .A3(C[0]), .A4(C[2]), .ZN(n27) );
  MUX2_X1 U26 ( .A(A[4]), .B(A[5]), .S(C[4]), .Z(n26) );
  INV_X1 U27 ( .A(C[0]), .ZN(n22) );
  NAND3_X1 U28 ( .A1(A[3]), .A2(C[1]), .A3(n22), .ZN(n24) );
  NOR3_X1 U29 ( .A1(n24), .A2(C[2]), .A3(n23), .ZN(n25) );
  AOI221_X1 U30 ( .B1(n27), .B2(n26), .C1(A[0]), .C2(C[0]), .A(n25), .ZN(n28)
         );
endmodule

