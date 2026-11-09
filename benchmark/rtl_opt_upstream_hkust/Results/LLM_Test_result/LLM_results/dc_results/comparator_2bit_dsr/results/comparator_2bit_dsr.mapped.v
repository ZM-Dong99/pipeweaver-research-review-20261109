/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:38:27 2025
/////////////////////////////////////////////////////////////


module comparator_2bit_dsr ( A, B, eq, gt, lt );
  input [1:0] A;
  input [1:0] B;
  output eq, gt, lt;
  wire   n13, n14, n15, n16, n17, n19, n20, n21, n22, n23;

  OAI211_X1 U14 ( .C1(n20), .C2(A[1]), .A(n13), .B(A[0]), .ZN(n21) );
  INV_X1 U15 ( .A(B[0]), .ZN(n13) );
  OR2_X1 U16 ( .A1(n22), .A2(B[1]), .ZN(n14) );
  NAND2_X1 U17 ( .A1(n21), .A2(n14), .ZN(gt) );
  AND3_X1 U18 ( .A1(n15), .A2(n16), .A3(n17), .ZN(eq) );
  XNOR2_X1 U19 ( .A(A[1]), .B(B[1]), .ZN(n15) );
  NAND2_X1 U20 ( .A1(B[0]), .A2(n23), .ZN(n16) );
  NAND2_X1 U21 ( .A1(A[0]), .A2(n19), .ZN(n17) );
  INV_X1 U22 ( .A(A[0]), .ZN(n23) );
  INV_X1 U23 ( .A(A[1]), .ZN(n22) );
  INV_X1 U24 ( .A(B[1]), .ZN(n20) );
  INV_X1 U25 ( .A(B[0]), .ZN(n19) );
  NOR2_X1 U26 ( .A1(eq), .A2(gt), .ZN(lt) );
endmodule

