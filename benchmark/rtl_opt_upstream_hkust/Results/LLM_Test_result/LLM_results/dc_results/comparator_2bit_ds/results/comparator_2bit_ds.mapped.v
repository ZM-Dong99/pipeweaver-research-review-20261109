/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:04:58 2025
/////////////////////////////////////////////////////////////


module comparator_2bit_ds ( A, B, eq, gt, lt );
  input [1:0] A;
  input [1:0] B;
  output eq, gt, lt;
  wire   n1, n2, n4, n6, n7, n8, n9;

  AND2_X1 U9 ( .A1(n9), .A2(B[1]), .ZN(n6) );
  AND2_X1 U10 ( .A1(n7), .A2(n8), .ZN(eq) );
  XNOR2_X1 U11 ( .A(A[1]), .B(B[1]), .ZN(n7) );
  XNOR2_X1 U12 ( .A(A[0]), .B(B[0]), .ZN(n8) );
  OAI22_X1 U13 ( .A1(n1), .A2(B[1]), .B1(n6), .B2(n4), .ZN(gt) );
  INV_X1 U14 ( .A(A[1]), .ZN(n9) );
  NAND2_X1 U15 ( .A1(n2), .A2(A[0]), .ZN(n4) );
  INV_X1 U16 ( .A(B[0]), .ZN(n2) );
  INV_X1 U17 ( .A(A[1]), .ZN(n1) );
  NOR2_X1 U18 ( .A1(gt), .A2(eq), .ZN(lt) );
endmodule

