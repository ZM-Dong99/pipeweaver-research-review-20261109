/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:32:37 2025
/////////////////////////////////////////////////////////////


module ticket_machine_ds ( clk, clear, ten, twenty, ready, dispense, 
        return_sig, bill );
  input clk, clear, ten, twenty;
  output ready, dispense, return_sig, bill;
  wire   n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26,
         n27, n28, n29, n30, n31, n32, n33, n34;
  wire   [2:0] State;

  DFF_X1 State_reg_0_ ( .D(n15), .CK(clk), .Q(State[0]), .QN(n20) );
  DFF_X1 State_reg_1_ ( .D(n14), .CK(clk), .Q(State[1]), .QN(n19) );
  DFF_X1 State_reg_2_ ( .D(n13), .CK(clk), .Q(State[2]), .QN(n21) );
  CLKBUF_X1 U22 ( .A(n19), .Z(n16) );
  AND3_X1 U23 ( .A1(n21), .A2(n20), .A3(n19), .ZN(ready) );
  XNOR2_X1 U24 ( .A(n20), .B(ten), .ZN(n23) );
  INV_X1 U25 ( .A(clear), .ZN(n24) );
  AOI211_X1 U26 ( .C1(n22), .C2(n32), .A(n16), .B(clear), .ZN(n13) );
  OR2_X1 U27 ( .A1(n17), .A2(n21), .ZN(n25) );
  NOR2_X1 U28 ( .A1(n20), .A2(n19), .ZN(n17) );
  INV_X1 U29 ( .A(n21), .ZN(n18) );
  NOR2_X1 U30 ( .A1(n26), .A2(n27), .ZN(n15) );
  NAND2_X1 U31 ( .A1(n25), .A2(n24), .ZN(n26) );
  NOR2_X1 U32 ( .A1(n18), .A2(n23), .ZN(n27) );
  AOI21_X1 U33 ( .B1(ten), .B2(State[0]), .A(n18), .ZN(n22) );
  INV_X1 U34 ( .A(ten), .ZN(n31) );
  NAND2_X1 U35 ( .A1(twenty), .A2(n31), .ZN(n32) );
  INV_X1 U36 ( .A(twenty), .ZN(n28) );
  AOI21_X1 U37 ( .B1(n31), .B2(n28), .A(State[2]), .ZN(n30) );
  NAND4_X1 U38 ( .A1(State[1]), .A2(ten), .A3(State[0]), .A4(n21), .ZN(n29) );
  OAI21_X1 U39 ( .B1(n30), .B2(State[1]), .A(n29), .ZN(n34) );
  OAI33_X1 U40 ( .A1(n18), .A2(n32), .A3(n19), .B1(State[1]), .B2(State[0]), 
        .B3(n31), .ZN(n33) );
  NOR3_X1 U41 ( .A1(n33), .A2(n34), .A3(clear), .ZN(n14) );
  AOI21_X1 U42 ( .B1(n19), .B2(n20), .A(State[2]), .ZN(bill) );
  NOR3_X1 U43 ( .A1(State[1]), .A2(n21), .A3(n20), .ZN(return_sig) );
  NOR3_X1 U44 ( .A1(State[1]), .A2(State[0]), .A3(n21), .ZN(dispense) );
endmodule

