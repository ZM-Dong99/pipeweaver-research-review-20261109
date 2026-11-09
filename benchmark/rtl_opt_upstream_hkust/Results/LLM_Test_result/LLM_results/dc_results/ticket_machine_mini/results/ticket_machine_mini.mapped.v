/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:34:26 2025
/////////////////////////////////////////////////////////////


module ticket_machine_mini ( clk, clear, ten, twenty, ready, dispense, 
        return_sig, bill );
  input clk, clear, ten, twenty;
  output ready, dispense, return_sig, bill;
  wire   n11, n12, n13, net341, net349, net348, net351, net352, net344, net346,
         net343, net342, net357, n14, n15, n16, n17;
  wire   [2:0] State;

  DFF_X1 State_reg_0_ ( .D(n13), .CK(clk), .Q(State[0]), .QN(net348) );
  DFF_X1 State_reg_1_ ( .D(n12), .CK(clk), .Q(State[1]), .QN(net352) );
  DFF_X2 State_reg_2_ ( .D(n11), .CK(clk), .Q(State[2]), .QN(net351) );
  OR2_X2 U20 ( .A1(State[2]), .A2(clear), .ZN(net341) );
  NOR3_X1 U21 ( .A1(net357), .A2(net351), .A3(State[1]), .ZN(return_sig) );
  BUF_X1 U22 ( .A(net348), .Z(net357) );
  AOI21_X1 U23 ( .B1(net357), .B2(net352), .A(State[2]), .ZN(bill) );
  MUX2_X1 U24 ( .A(net343), .B(net357), .S(ten), .Z(net342) );
  NOR3_X1 U25 ( .A1(net342), .A2(net341), .A3(net352), .ZN(n11) );
  INV_X1 U26 ( .A(twenty), .ZN(net343) );
  NAND2_X1 U27 ( .A1(n15), .A2(n16), .ZN(n14) );
  NAND2_X1 U28 ( .A1(State[0]), .A2(ten), .ZN(n15) );
  OR2_X1 U29 ( .A1(ten), .A2(net346), .ZN(n16) );
  INV_X1 U30 ( .A(twenty), .ZN(net346) );
  XNOR2_X1 U31 ( .A(n14), .B(State[1]), .ZN(net344) );
  NOR2_X1 U32 ( .A1(net344), .A2(net341), .ZN(n12) );
  XNOR2_X1 U33 ( .A(net349), .B(ten), .ZN(n17) );
  NOR2_X1 U34 ( .A1(n17), .A2(net341), .ZN(n13) );
  INV_X1 U35 ( .A(net348), .ZN(net349) );
  NOR3_X1 U36 ( .A1(net349), .A2(State[1]), .A3(net351), .ZN(dispense) );
  NOR3_X1 U37 ( .A1(net349), .A2(State[1]), .A3(State[2]), .ZN(ready) );
endmodule

