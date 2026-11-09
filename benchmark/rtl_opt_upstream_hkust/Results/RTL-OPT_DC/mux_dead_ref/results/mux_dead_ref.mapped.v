/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:08:15 2025
/////////////////////////////////////////////////////////////


module mux_dead_ref ( x, sel, a, b, result );
  input [7:0] a;
  input [7:0] b;
  output [7:0] result;
  input x, sel;
  wire   subtract_module_diff_result_0_, subtract_module_diff_result_1_,
         subtract_module_diff_result_2_, subtract_module_diff_result_3_,
         subtract_module_diff_result_4_, subtract_module_diff_result_5_,
         subtract_module_diff_result_6_, subtract_module_diff_result_7_,
         alu_module_alu_result_0_, alu_module_alu_result_1_,
         alu_module_alu_result_2_, alu_module_alu_result_3_,
         alu_module_alu_result_4_, alu_module_alu_result_5_,
         alu_module_alu_result_6_, alu_module_alu_result_7_;
  wire   [7:0] and_result;
  wire   [7:0] or_result;
  tri   [7:0] a;
  tri   [7:0] b;

  adder add_module ( .a(a), .b(b) );
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
  OR2_X1 or_module_U8 ( .A1(a[7]), .A2(b[7]), .ZN(or_result[7]) );
  OR2_X1 or_module_U7 ( .A1(a[6]), .A2(b[6]), .ZN(or_result[6]) );
  OR2_X1 or_module_U6 ( .A1(a[5]), .A2(b[5]), .ZN(or_result[5]) );
  OR2_X1 or_module_U5 ( .A1(a[4]), .A2(b[4]), .ZN(or_result[4]) );
  OR2_X1 or_module_U4 ( .A1(a[3]), .A2(b[3]), .ZN(or_result[3]) );
  OR2_X1 or_module_U3 ( .A1(a[2]), .A2(b[2]), .ZN(or_result[2]) );
  OR2_X1 or_module_U2 ( .A1(a[1]), .A2(b[1]), .ZN(or_result[1]) );
  OR2_X1 or_module_U1 ( .A1(a[0]), .A2(b[0]), .ZN(or_result[0]) );
endmodule

