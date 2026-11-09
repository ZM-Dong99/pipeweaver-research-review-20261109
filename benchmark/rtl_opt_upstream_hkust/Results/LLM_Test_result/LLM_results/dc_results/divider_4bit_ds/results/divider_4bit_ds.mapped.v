/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:05:38 2025
/////////////////////////////////////////////////////////////


module divider_4bit_ds ( A, B, result, odd );
  input [3:0] A;
  input [1:0] B;
  output [3:0] result;
  output [3:0] odd;
  wire   n28, n29, n30, n31;

  INV_X1 U7 ( .A(1'b1), .ZN(result[0]) );
  AND3_X1 U9 ( .A1(A[3]), .A2(B[0]), .A3(n29), .ZN(odd[3]) );
  AND3_X1 U10 ( .A1(A[3]), .A2(B[0]), .A3(n29), .ZN(odd[2]) );
  BUF_X1 U11 ( .A(A[1]), .Z(result[2]) );
  BUF_X1 U12 ( .A(A[0]), .Z(result[1]) );
  BUF_X1 U13 ( .A(A[3]), .Z(odd[1]) );
  INV_X1 U14 ( .A(B[0]), .ZN(n28) );
  INV_X1 U15 ( .A(B[1]), .ZN(n29) );
  NAND2_X1 U16 ( .A1(n28), .A2(n29), .ZN(n31) );
  NAND3_X1 U17 ( .A1(A[3]), .A2(B[0]), .A3(n29), .ZN(n30) );
  NAND2_X1 U18 ( .A1(n31), .A2(n30), .ZN(odd[0]) );
  INV_X1 U19 ( .A(n31), .ZN(result[3]) );
endmodule

