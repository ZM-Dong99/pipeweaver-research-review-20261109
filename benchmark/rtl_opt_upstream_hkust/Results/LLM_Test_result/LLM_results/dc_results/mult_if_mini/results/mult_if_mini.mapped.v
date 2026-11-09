/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:34:14 2025
/////////////////////////////////////////////////////////////


module mult_if_mini ( A, C, CTRL_is_late_arriving, Z );
  input [7:0] A;
  input [4:0] C;
  input CTRL_is_late_arriving;
  output Z;
  wire   n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27,
         n28, n29;

  INV_X1 U15 ( .A(C[1]), .ZN(n14) );
  INV_X1 U16 ( .A(C[1]), .ZN(n15) );
  INV_X1 U17 ( .A(CTRL_is_late_arriving), .ZN(n16) );
  AND3_X1 U18 ( .A1(n16), .A2(C[3]), .A3(C[1]), .ZN(n18) );
  INV_X1 U19 ( .A(C[1]), .ZN(n20) );
  NOR2_X1 U20 ( .A1(C[0]), .A2(C[2]), .ZN(n17) );
  AOI22_X1 U21 ( .A1(n18), .A2(n17), .B1(A[0]), .B2(C[0]), .ZN(n29) );
  NOR2_X1 U22 ( .A1(A[3]), .A2(C[0]), .ZN(n28) );
  INV_X1 U23 ( .A(C[2]), .ZN(n25) );
  NOR2_X1 U24 ( .A1(n14), .A2(n25), .ZN(n19) );
  AOI22_X1 U25 ( .A1(A[1]), .A2(n15), .B1(n19), .B2(A[2]), .ZN(n27) );
  INV_X1 U26 ( .A(C[0]), .ZN(n24) );
  INV_X1 U27 ( .A(CTRL_is_late_arriving), .ZN(n21) );
  AOI21_X1 U28 ( .B1(C[3]), .B2(n21), .A(n20), .ZN(n23) );
  MUX2_X1 U29 ( .A(A[4]), .B(A[5]), .S(C[4]), .Z(n22) );
  NAND4_X1 U30 ( .A1(n23), .A2(n24), .A3(n25), .A4(n22), .ZN(n26) );
  OAI221_X1 U31 ( .B1(n29), .B2(n28), .C1(C[0]), .C2(n27), .A(n26), .ZN(Z) );
endmodule

