/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Wed May 14 19:08:56 2025
/////////////////////////////////////////////////////////////


module ticket_machine_ref ( clk, clear, ten, twenty, ready, dispense, 
        return_sig, bill );
  input clk, clear, ten, twenty;
  output ready, dispense, return_sig, bill;
  wire   N20, N21, N22, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n48, n50, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n64;
  wire   [2:0] State;

  DFF_X1 State_reg_0_ ( .D(N20), .CK(clk), .Q(State[0]), .QN(n45) );
  DFF_X1 State_reg_2_ ( .D(N22), .CK(clk), .Q(State[2]), .QN(n46) );
  DFF_X1 State_reg_1_ ( .D(N21), .CK(clk), .Q(State[1]), .QN(n44) );
  NAND3_X1 U33 ( .A1(n32), .A2(n43), .A3(n42), .ZN(n55) );
  NAND3_X1 U34 ( .A1(n42), .A2(1'b1), .A3(n28), .ZN(n59) );
  OAI211_X1 U35 ( .C1(n45), .C2(State[2]), .A(n33), .B(1'b1), .ZN(n62) );
  AND4_X1 U36 ( .A1(1'b1), .A2(n45), .A3(n43), .A4(1'b1), .ZN(n36) );
  INV_X2 U37 ( .A(n37), .ZN(n60) );
  NAND2_X1 U38 ( .A1(n46), .A2(1'b1), .ZN(n64) );
  NOR2_X1 U39 ( .A1(n62), .A2(1'b0), .ZN(bill) );
  NOR4_X1 U40 ( .A1(n26), .A2(State[0]), .A3(n64), .A4(1'b0), .ZN(ready) );
  NOR4_X1 U41 ( .A1(n26), .A2(n45), .A3(n64), .A4(1'b0), .ZN(dispense) );
  NOR4_X1 U42 ( .A1(n27), .A2(n64), .A3(n45), .A4(1'b0), .ZN(return_sig) );
  BUF_X1 U45 ( .A(n33), .Z(n26) );
  BUF_X1 U46 ( .A(n44), .Z(n27) );
  AND2_X1 U47 ( .A1(n43), .A2(n38), .ZN(n28) );
  INV_X1 U48 ( .A(ten), .ZN(n29) );
  INV_X1 U49 ( .A(ten), .ZN(n30) );
  OR2_X1 U50 ( .A1(ten), .A2(twenty), .ZN(n56) );
  AND2_X1 U51 ( .A1(n58), .A2(twenty), .ZN(n31) );
  INV_X1 U52 ( .A(clear), .ZN(n48) );
  AND2_X1 U53 ( .A1(n30), .A2(n50), .ZN(n32) );
  INV_X1 U54 ( .A(n44), .ZN(n33) );
  CLKBUF_X1 U55 ( .A(n46), .Z(n34) );
  NAND2_X1 U56 ( .A1(n35), .A2(n36), .ZN(n39) );
  OR2_X1 U57 ( .A1(n40), .A2(n41), .ZN(n35) );
  INV_X1 U58 ( .A(clear), .ZN(n37) );
  INV_X1 U59 ( .A(clear), .ZN(n43) );
  INV_X1 U60 ( .A(ten), .ZN(n38) );
  NAND2_X1 U61 ( .A1(n39), .A2(n59), .ZN(N21) );
  AND2_X1 U62 ( .A1(State[1]), .A2(n57), .ZN(n40) );
  AND2_X1 U63 ( .A1(n46), .A2(n56), .ZN(n41) );
  NAND2_X1 U64 ( .A1(n55), .A2(n54), .ZN(N22) );
  NAND2_X1 U65 ( .A1(n27), .A2(n57), .ZN(n52) );
  OR2_X1 U66 ( .A1(n56), .A2(State[2]), .ZN(n51) );
  AND3_X1 U67 ( .A1(State[2]), .A2(State[0]), .A3(State[1]), .ZN(n42) );
  AOI21_X1 U71 ( .B1(State[2]), .B2(n31), .A(n60), .ZN(n53) );
  NAND4_X1 U72 ( .A1(n53), .A2(n52), .A3(n51), .A4(n45), .ZN(n54) );
  INV_X1 U73 ( .A(ten), .ZN(n58) );
  INV_X1 U74 ( .A(twenty), .ZN(n50) );
  NAND2_X1 U75 ( .A1(n29), .A2(twenty), .ZN(n57) );
  OAI211_X1 U76 ( .C1(State[2]), .C2(n31), .A(State[1]), .B(n48), .ZN(n61) );
  AOI221_X1 U77 ( .B1(State[0]), .B2(n34), .C1(n32), .C2(n45), .A(n61), .ZN(
        N20) );
endmodule

