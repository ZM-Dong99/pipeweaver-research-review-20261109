/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:31:30 2025
/////////////////////////////////////////////////////////////


module mult_if_ds ( A, C, CTRL_is_late_arriving, Z );
  input [7:0] A;
  input [4:0] C;
  input CTRL_is_late_arriving;
  output Z;
  wire   n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28;

  INV_X1 U13 ( .A(n14), .ZN(n12) );
  NAND4_X1 U14 ( .A1(n18), .A2(C[3]), .A3(n17), .A4(A[3]), .ZN(n28) );
  OAI21_X1 U15 ( .B1(C[4]), .B2(n19), .A(n21), .ZN(n26) );
  INV_X1 U16 ( .A(A[5]), .ZN(n19) );
  NAND2_X1 U17 ( .A1(C[4]), .A2(A[2]), .ZN(n20) );
  NOR2_X1 U18 ( .A1(A[1]), .A2(C[1]), .ZN(n22) );
  NAND2_X1 U19 ( .A1(n20), .A2(n12), .ZN(n25) );
  NOR2_X1 U20 ( .A1(C[2]), .A2(C[0]), .ZN(n13) );
  OAI21_X1 U21 ( .B1(n22), .B2(C[0]), .A(n21), .ZN(n24) );
  INV_X1 U22 ( .A(C[1]), .ZN(n14) );
  NAND2_X1 U23 ( .A1(n27), .A2(n28), .ZN(Z) );
  OAI211_X1 U24 ( .C1(n26), .C2(n25), .A(n23), .B(n24), .ZN(n27) );
  NOR2_X1 U25 ( .A1(n16), .A2(CTRL_is_late_arriving), .ZN(n15) );
  INV_X1 U26 ( .A(C[1]), .ZN(n16) );
  NOR2_X1 U27 ( .A1(n14), .A2(CTRL_is_late_arriving), .ZN(n18) );
  NOR2_X1 U28 ( .A1(C[2]), .A2(C[0]), .ZN(n17) );
  NAND3_X1 U29 ( .A1(n15), .A2(C[3]), .A3(n13), .ZN(n23) );
  NAND2_X1 U30 ( .A1(A[0]), .A2(C[0]), .ZN(n21) );
endmodule

