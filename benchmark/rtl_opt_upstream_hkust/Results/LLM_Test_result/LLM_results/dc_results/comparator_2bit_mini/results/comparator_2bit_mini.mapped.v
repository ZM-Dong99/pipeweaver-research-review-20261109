/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:07:29 2025
/////////////////////////////////////////////////////////////


module comparator_2bit_mini ( A, B, eq, gt, lt );
  input [1:0] A;
  input [1:0] B;
  output eq, gt, lt;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22;

  AND3_X1 U13 ( .A1(n10), .A2(n11), .A3(n12), .ZN(eq) );
  XNOR2_X1 U14 ( .A(B[0]), .B(A[0]), .ZN(n10) );
  NAND2_X1 U15 ( .A1(B[1]), .A2(n15), .ZN(n11) );
  NAND2_X1 U16 ( .A1(A[1]), .A2(n13), .ZN(n12) );
  INV_X1 U17 ( .A(B[1]), .ZN(n13) );
  INV_X1 U18 ( .A(A[1]), .ZN(n14) );
  INV_X1 U19 ( .A(B[0]), .ZN(n22) );
  INV_X1 U20 ( .A(A[1]), .ZN(n15) );
  NAND2_X1 U21 ( .A1(n14), .A2(B[1]), .ZN(n20) );
  INV_X1 U22 ( .A(B[1]), .ZN(n16) );
  NAND2_X1 U23 ( .A1(n16), .A2(A[1]), .ZN(n21) );
  INV_X1 U24 ( .A(A[0]), .ZN(n17) );
  NAND3_X1 U25 ( .A1(n21), .A2(B[0]), .A3(n17), .ZN(n18) );
  NAND2_X1 U26 ( .A1(n18), .A2(n20), .ZN(lt) );
  NAND3_X1 U27 ( .A1(n20), .A2(n22), .A3(A[0]), .ZN(n19) );
  NAND2_X1 U28 ( .A1(n19), .A2(n21), .ZN(gt) );
endmodule

