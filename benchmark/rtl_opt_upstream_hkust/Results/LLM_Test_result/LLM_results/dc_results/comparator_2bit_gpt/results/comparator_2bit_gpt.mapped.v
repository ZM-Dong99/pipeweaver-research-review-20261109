/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:28:46 2025
/////////////////////////////////////////////////////////////


module comparator_2bit_gpt ( A, B, eq, gt, lt );
  input [1:0] A;
  input [1:0] B;
  output eq, gt, lt;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18;

  XOR2_X1 U12 ( .A(A[1]), .B(B[1]), .Z(n9) );
  OR2_X1 U13 ( .A1(A[1]), .A2(n15), .ZN(n10) );
  NAND2_X1 U14 ( .A1(n14), .A2(n10), .ZN(lt) );
  NAND2_X1 U15 ( .A1(n15), .A2(A[1]), .ZN(n11) );
  NAND2_X1 U16 ( .A1(n16), .A2(n11), .ZN(gt) );
  XNOR2_X1 U17 ( .A(n18), .B(A[0]), .ZN(n8) );
  XNOR2_X1 U18 ( .A(A[1]), .B(B[1]), .ZN(n12) );
  XNOR2_X1 U19 ( .A(A[1]), .B(B[1]), .ZN(n17) );
  INV_X1 U20 ( .A(B[0]), .ZN(n18) );
  INV_X1 U21 ( .A(B[1]), .ZN(n15) );
  INV_X1 U22 ( .A(A[0]), .ZN(n13) );
  NAND3_X1 U23 ( .A1(n17), .A2(n13), .A3(B[0]), .ZN(n14) );
  NAND3_X1 U24 ( .A1(n12), .A2(n18), .A3(A[0]), .ZN(n16) );
  NOR2_X1 U25 ( .A1(n8), .A2(n9), .ZN(eq) );
endmodule

