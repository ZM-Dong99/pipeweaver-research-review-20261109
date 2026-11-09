/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:35:51 2025
/////////////////////////////////////////////////////////////


module ticket_machine_dsr ( clk, clear, ten, twenty, ready, dispense, 
        return_sig, bill );
  input clk, clear, ten, twenty;
  output ready, dispense, return_sig, bill;
  wire   n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50,
         n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n66, n67, n68, n69, n70, n71, n72, n73;
  wire   [2:0] State;

  DFF_X1 State_reg_0_ ( .D(n25), .CK(clk), .Q(State[0]), .QN(n45) );
  DFF_X1 State_reg_1_ ( .D(n24), .CK(clk), .Q(State[1]), .QN(n43) );
  DFF_X1 State_reg_2_ ( .D(n23), .CK(clk), .Q(State[2]), .QN(n44) );
  BUF_X1 U32 ( .A(n42), .Z(n28) );
  OR2_X1 U33 ( .A1(State[0]), .A2(n35), .ZN(n63) );
  BUF_X1 U34 ( .A(n43), .Z(n30) );
  CLKBUF_X1 U35 ( .A(n44), .Z(n31) );
  BUF_X1 U36 ( .A(n72), .Z(n26) );
  BUF_X1 U37 ( .A(State[1]), .Z(n41) );
  NAND2_X1 U38 ( .A1(n39), .A2(State[1]), .ZN(n27) );
  BUF_X1 U39 ( .A(n45), .Z(n29) );
  NAND3_X1 U40 ( .A1(State[0]), .A2(n60), .A3(State[1]), .ZN(n61) );
  AND3_X1 U41 ( .A1(State[0]), .A2(n31), .A3(n30), .ZN(dispense) );
  NOR2_X1 U42 ( .A1(n45), .A2(n43), .ZN(n72) );
  NOR2_X1 U43 ( .A1(n32), .A2(n33), .ZN(n54) );
  NOR3_X1 U44 ( .A1(ten), .A2(clear), .A3(twenty), .ZN(n32) );
  NAND2_X1 U45 ( .A1(n67), .A2(n35), .ZN(n33) );
  AND2_X1 U46 ( .A1(n40), .A2(n67), .ZN(n34) );
  OR3_X2 U47 ( .A1(ten), .A2(clear), .A3(twenty), .ZN(n40) );
  INV_X1 U48 ( .A(ten), .ZN(n35) );
  OR3_X2 U49 ( .A1(ten), .A2(clear), .A3(twenty), .ZN(n36) );
  NAND2_X1 U50 ( .A1(n38), .A2(n50), .ZN(n49) );
  INV_X1 U51 ( .A(n73), .ZN(ready) );
  INV_X1 U52 ( .A(n36), .ZN(n50) );
  NAND2_X1 U53 ( .A1(n26), .A2(n50), .ZN(n58) );
  NAND2_X1 U54 ( .A1(n53), .A2(n54), .ZN(n56) );
  INV_X1 U55 ( .A(clear), .ZN(n52) );
  BUF_X1 U56 ( .A(State[2]), .Z(n38) );
  NAND4_X1 U57 ( .A1(n57), .A2(n58), .A3(n56), .A4(n55), .ZN(n24) );
  INV_X1 U58 ( .A(n65), .ZN(n66) );
  INV_X1 U59 ( .A(n44), .ZN(n37) );
  NOR2_X1 U60 ( .A1(n59), .A2(n31), .ZN(n53) );
  INV_X1 U61 ( .A(n45), .ZN(n39) );
  NAND2_X1 U62 ( .A1(n64), .A2(n52), .ZN(n70) );
  OAI211_X1 U63 ( .C1(n63), .C2(n41), .A(n61), .B(n62), .ZN(n64) );
  INV_X1 U64 ( .A(n29), .ZN(n42) );
  INV_X1 U65 ( .A(n39), .ZN(n59) );
  NAND3_X1 U66 ( .A1(n45), .A2(n44), .A3(n43), .ZN(n73) );
  INV_X1 U67 ( .A(ten), .ZN(n60) );
  NAND2_X1 U68 ( .A1(State[1]), .A2(State[0]), .ZN(n71) );
  NAND3_X1 U69 ( .A1(n73), .A2(n60), .A3(n71), .ZN(n47) );
  NAND3_X1 U70 ( .A1(n37), .A2(n45), .A3(n43), .ZN(n65) );
  NAND3_X1 U71 ( .A1(n65), .A2(n27), .A3(ten), .ZN(n46) );
  INV_X1 U72 ( .A(clear), .ZN(n67) );
  NAND3_X1 U73 ( .A1(n46), .A2(n47), .A3(n34), .ZN(n48) );
  NAND3_X1 U74 ( .A1(n38), .A2(n41), .A3(n67), .ZN(n55) );
  NAND3_X1 U75 ( .A1(n48), .A2(n49), .A3(n55), .ZN(n23) );
  NAND3_X1 U76 ( .A1(ready), .A2(n52), .A3(ten), .ZN(n57) );
  NAND3_X1 U77 ( .A1(State[0]), .A2(n37), .A3(ten), .ZN(n62) );
  NAND3_X1 U78 ( .A1(n28), .A2(n32), .A3(n38), .ZN(n69) );
  NAND3_X1 U79 ( .A1(n67), .A2(n36), .A3(n66), .ZN(n68) );
  NAND3_X1 U80 ( .A1(n69), .A2(n70), .A3(n68), .ZN(n25) );
  MUX2_X1 U81 ( .A(n72), .B(n43), .S(State[2]), .Z(bill) );
  NOR3_X1 U82 ( .A1(n42), .A2(n38), .A3(n30), .ZN(return_sig) );
endmodule

