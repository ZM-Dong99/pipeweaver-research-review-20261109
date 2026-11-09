/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:34:41 2025
/////////////////////////////////////////////////////////////


module mult_if_dsr ( A, C, CTRL_is_late_arriving, Z );
  input [7:0] A;
  input [4:0] C;
  input CTRL_is_late_arriving;
  output Z;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23;

  NAND2_X1 U11 ( .A1(A[0]), .A2(C[0]), .ZN(n19) );
  NAND2_X1 U12 ( .A1(n22), .A2(n23), .ZN(Z) );
  NAND2_X1 U13 ( .A1(n21), .A2(n20), .ZN(n22) );
  NAND2_X1 U14 ( .A1(n10), .A2(n15), .ZN(n23) );
  AND2_X1 U15 ( .A1(n14), .A2(A[3]), .ZN(n10) );
  NAND2_X1 U16 ( .A1(C[1]), .A2(C[3]), .ZN(n11) );
  INV_X1 U17 ( .A(C[2]), .ZN(n17) );
  INV_X1 U18 ( .A(C[0]), .ZN(n16) );
  NOR2_X1 U19 ( .A1(CTRL_is_late_arriving), .A2(n11), .ZN(n12) );
  NAND2_X1 U20 ( .A1(C[1]), .A2(C[3]), .ZN(n13) );
  NAND2_X1 U21 ( .A1(n18), .A2(n19), .ZN(n21) );
  OAI221_X1 U22 ( .B1(A[1]), .B2(C[2]), .C1(n17), .C2(A[2]), .A(n16), .ZN(n18)
         );
  NOR2_X1 U23 ( .A1(C[2]), .A2(C[0]), .ZN(n14) );
  NAND2_X1 U24 ( .A1(n12), .A2(n14), .ZN(n20) );
  NOR2_X1 U25 ( .A1(CTRL_is_late_arriving), .A2(n13), .ZN(n15) );
endmodule

