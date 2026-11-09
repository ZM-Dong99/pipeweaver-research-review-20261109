/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Wed May 14 19:04:00 2025
/////////////////////////////////////////////////////////////


module ticket_machine ( clk, clear, ten, twenty, ready, dispense, return_sig, 
        bill );
  input clk, clear, ten, twenty;
  output ready, dispense, return_sig, bill;
  wire   N16, N17, N18, N19, N20, N21, n29, n30, n31, n32, n33, n35, n36, n37,
         n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51,
         n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n66, n67, n68, n69, n70, n71, n72;
  wire   [5:0] State;

  DFF_X1 State_reg_0_ ( .D(N16), .CK(clk), .Q(State[0]), .QN(n50) );
  DFF_X1 State_reg_4_ ( .D(N20), .CK(clk), .Q(State[4]), .QN(n49) );
  DFF_X1 State_reg_5_ ( .D(N21), .CK(clk), .Q(State[5]), .QN(n46) );
  DFF_X1 State_reg_3_ ( .D(N19), .CK(clk), .Q(State[3]), .QN(n30) );
  DFF_X1 State_reg_1_ ( .D(N17), .CK(clk), .Q(State[1]), .QN(n47) );
  DFF_X1 State_reg_2_ ( .D(N18), .CK(clk), .Q(State[2]), .QN(n48) );
  CLKBUF_X1 U41 ( .A(n50), .Z(n29) );
  CLKBUF_X1 U42 ( .A(n53), .Z(n31) );
  XNOR2_X1 U43 ( .A(n32), .B(State[3]), .ZN(n57) );
  NAND2_X1 U44 ( .A1(n49), .A2(n46), .ZN(n32) );
  BUF_X1 U45 ( .A(State[3]), .Z(n33) );
  AND3_X1 U46 ( .A1(n52), .A2(n35), .A3(n51), .ZN(ready) );
  CLKBUF_X1 U47 ( .A(n47), .Z(n35) );
  BUF_X1 U48 ( .A(State[4]), .Z(n36) );
  CLKBUF_X1 U49 ( .A(n66), .Z(n37) );
  AND2_X1 U50 ( .A1(n59), .A2(n60), .ZN(n38) );
  AND3_X1 U51 ( .A1(n50), .A2(n48), .A3(n47), .ZN(n39) );
  XOR2_X1 U52 ( .A(State[5]), .B(n44), .Z(n40) );
  CLKBUF_X1 U53 ( .A(n46), .Z(n41) );
  INV_X1 U54 ( .A(n41), .ZN(n42) );
  CLKBUF_X1 U55 ( .A(n48), .Z(n43) );
  NOR2_X1 U56 ( .A1(State[2]), .A2(n29), .ZN(n51) );
  INV_X1 U57 ( .A(n49), .ZN(n44) );
  INV_X1 U58 ( .A(State[4]), .ZN(n45) );
  NOR3_X1 U59 ( .A1(State[3]), .A2(State[4]), .A3(State[5]), .ZN(n52) );
  INV_X1 U60 ( .A(State[5]), .ZN(n70) );
  INV_X1 U61 ( .A(State[1]), .ZN(n71) );
  NAND4_X1 U62 ( .A1(n70), .A2(n45), .A3(n33), .A4(n39), .ZN(n68) );
  INV_X1 U63 ( .A(clear), .ZN(n60) );
  NAND2_X1 U64 ( .A1(ten), .A2(n60), .ZN(n65) );
  NAND3_X1 U65 ( .A1(n51), .A2(n35), .A3(n52), .ZN(n64) );
  INV_X1 U66 ( .A(ten), .ZN(n59) );
  NAND2_X1 U67 ( .A1(twenty), .A2(n38), .ZN(n55) );
  INV_X1 U68 ( .A(twenty), .ZN(n58) );
  NAND2_X1 U69 ( .A1(n38), .A2(n58), .ZN(n63) );
  NAND4_X1 U70 ( .A1(n70), .A2(n30), .A3(n36), .A4(n39), .ZN(n54) );
  OAI222_X1 U71 ( .A1(n68), .A2(n65), .B1(n64), .B2(n55), .C1(n54), .C2(n63), 
        .ZN(N20) );
  NAND3_X1 U72 ( .A1(n48), .A2(n47), .A3(n50), .ZN(n56) );
  INV_X1 U73 ( .A(n56), .ZN(n66) );
  NAND4_X1 U74 ( .A1(n66), .A2(n30), .A3(n45), .A4(n42), .ZN(n53) );
  NOR2_X1 U75 ( .A1(n31), .A2(n55), .ZN(N18) );
  OAI22_X1 U76 ( .A1(n54), .A2(n55), .B1(n53), .B2(n65), .ZN(N17) );
  OAI222_X1 U77 ( .A1(n68), .A2(n55), .B1(n65), .B2(n54), .C1(n53), .C2(n63), 
        .ZN(N21) );
  AOI211_X1 U78 ( .C1(n42), .C2(n36), .A(n56), .B(n57), .ZN(n62) );
  NAND3_X1 U79 ( .A1(n59), .A2(n58), .A3(State[0]), .ZN(n61) );
  OAI211_X1 U80 ( .C1(n62), .C2(ready), .A(n61), .B(n60), .ZN(N16) );
  OAI22_X1 U81 ( .A1(n65), .A2(n64), .B1(n68), .B2(n63), .ZN(N19) );
  NAND3_X1 U82 ( .A1(n37), .A2(n30), .A3(n40), .ZN(n67) );
  NAND2_X1 U83 ( .A1(n68), .A2(n67), .ZN(bill) );
  NAND3_X1 U84 ( .A1(n30), .A2(State[2]), .A3(n45), .ZN(n69) );
  NOR4_X1 U85 ( .A1(n69), .A2(n40), .A3(State[1]), .A4(State[0]), .ZN(
        return_sig) );
  NAND3_X1 U86 ( .A1(n43), .A2(n45), .A3(n70), .ZN(n72) );
  NOR4_X1 U87 ( .A1(n72), .A2(n33), .A3(State[0]), .A4(n71), .ZN(dispense) );
endmodule

