/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:09:56 2025
/////////////////////////////////////////////////////////////


module mux_dead ( x, sel, a, b, result );
  input [7:0] a;
  input [7:0] b;
  output [7:0] result;
  input x, sel;
  wire   or_module_n16, or_module_n15, or_module_n14, or_module_n13,
         or_module_n12, or_module_n11, or_module_n10, or_module_n9,
         or_module_n8, or_module_n7, or_module_n6, or_module_n5, or_module_n4,
         or_module_n3, or_module_n2, or_module_n1;
  wire   [7:0] and_result;
  wire   [7:0] or_result;

  MUX2_X1 U18 ( .A(or_result[0]), .B(and_result[0]), .S(x), .Z(result[0]) );
  MUX2_X1 U19 ( .A(or_result[1]), .B(and_result[1]), .S(x), .Z(result[1]) );
  MUX2_X1 U20 ( .A(or_result[2]), .B(and_result[2]), .S(x), .Z(result[2]) );
  MUX2_X1 U21 ( .A(or_result[3]), .B(and_result[3]), .S(x), .Z(result[3]) );
  MUX2_X1 U22 ( .A(or_result[5]), .B(and_result[5]), .S(x), .Z(result[5]) );
  MUX2_X1 U23 ( .A(or_result[4]), .B(and_result[4]), .S(x), .Z(result[4]) );
  MUX2_X1 U24 ( .A(or_result[6]), .B(and_result[6]), .S(x), .Z(result[6]) );
  MUX2_X1 U25 ( .A(or_result[7]), .B(and_result[7]), .S(x), .Z(result[7]) );
  AND2_X1 and_module_U8 ( .A1(b[7]), .A2(a[7]), .ZN(and_result[7]) );
  AND2_X1 and_module_U7 ( .A1(b[6]), .A2(a[6]), .ZN(and_result[6]) );
  AND2_X1 and_module_U6 ( .A1(b[5]), .A2(a[5]), .ZN(and_result[5]) );
  AND2_X1 and_module_U5 ( .A1(b[4]), .A2(a[4]), .ZN(and_result[4]) );
  AND2_X1 and_module_U4 ( .A1(b[3]), .A2(a[3]), .ZN(and_result[3]) );
  AND2_X1 and_module_U3 ( .A1(b[2]), .A2(a[2]), .ZN(and_result[2]) );
  AND2_X1 and_module_U2 ( .A1(b[1]), .A2(a[1]), .ZN(and_result[1]) );
  AND2_X1 and_module_U1 ( .A1(b[0]), .A2(a[0]), .ZN(and_result[0]) );
  INV_X1 or_module_U24 ( .A(b[7]), .ZN(or_module_n16) );
  INV_X1 or_module_U23 ( .A(a[7]), .ZN(or_module_n15) );
  NAND2_X1 or_module_U22 ( .A1(or_module_n15), .A2(or_module_n16), .ZN(
        or_result[7]) );
  INV_X1 or_module_U21 ( .A(b[6]), .ZN(or_module_n14) );
  INV_X1 or_module_U20 ( .A(a[6]), .ZN(or_module_n13) );
  NAND2_X1 or_module_U19 ( .A1(or_module_n13), .A2(or_module_n14), .ZN(
        or_result[6]) );
  INV_X1 or_module_U18 ( .A(b[5]), .ZN(or_module_n12) );
  INV_X1 or_module_U17 ( .A(a[5]), .ZN(or_module_n11) );
  NAND2_X1 or_module_U16 ( .A1(or_module_n11), .A2(or_module_n12), .ZN(
        or_result[5]) );
  INV_X1 or_module_U15 ( .A(b[4]), .ZN(or_module_n10) );
  INV_X1 or_module_U14 ( .A(a[4]), .ZN(or_module_n9) );
  NAND2_X1 or_module_U13 ( .A1(or_module_n9), .A2(or_module_n10), .ZN(
        or_result[4]) );
  INV_X1 or_module_U12 ( .A(b[3]), .ZN(or_module_n8) );
  INV_X1 or_module_U11 ( .A(a[3]), .ZN(or_module_n7) );
  NAND2_X1 or_module_U10 ( .A1(or_module_n7), .A2(or_module_n8), .ZN(
        or_result[3]) );
  INV_X1 or_module_U9 ( .A(b[2]), .ZN(or_module_n6) );
  INV_X1 or_module_U8 ( .A(a[2]), .ZN(or_module_n5) );
  NAND2_X1 or_module_U7 ( .A1(or_module_n5), .A2(or_module_n6), .ZN(
        or_result[2]) );
  INV_X1 or_module_U6 ( .A(b[1]), .ZN(or_module_n4) );
  INV_X1 or_module_U5 ( .A(a[1]), .ZN(or_module_n3) );
  NAND2_X1 or_module_U4 ( .A1(or_module_n3), .A2(or_module_n4), .ZN(
        or_result[1]) );
  INV_X1 or_module_U3 ( .A(b[0]), .ZN(or_module_n2) );
  INV_X1 or_module_U2 ( .A(a[0]), .ZN(or_module_n1) );
  NAND2_X1 or_module_U1 ( .A1(or_module_n1), .A2(or_module_n2), .ZN(
        or_result[0]) );
endmodule

