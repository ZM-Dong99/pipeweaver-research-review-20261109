/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:33:58 2025
/////////////////////////////////////////////////////////////


module ticket_machine_gpt ( clk, clear, ten, twenty, ready, dispense, 
        return_sig, bill );
  input clk, clear, ten, twenty;
  output ready, dispense, return_sig, bill;
  wire   n24, n25, n26, n27, n28, n29, n30, n31, n32, n34, n35, n36, n37, n38,
         n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n70, n71, n72, n73;
  wire   [5:0] State;
  wire   [5:0] NextState;

  DFFR_X1 State_reg_4_ ( .D(NextState[4]), .CK(clk), .RN(n73), .Q(State[4]), 
        .QN(n43) );
  DFFR_X1 State_reg_1_ ( .D(NextState[1]), .CK(clk), .RN(n73), .Q(State[1]), 
        .QN(n45) );
  DFFR_X1 State_reg_5_ ( .D(NextState[5]), .CK(clk), .RN(n73), .Q(State[5]), 
        .QN(n42) );
  DFFR_X1 State_reg_2_ ( .D(NextState[2]), .CK(clk), .RN(n73), .Q(State[2]), 
        .QN(n44) );
  DFFS_X1 State_reg_0_ ( .D(NextState[0]), .CK(clk), .SN(n73), .Q(State[0]), 
        .QN(n46) );
  DFFR_X1 State_reg_3_ ( .D(NextState[3]), .CK(clk), .RN(n73), .Q(State[3]), 
        .QN(n41) );
  NOR2_X2 U36 ( .A1(twenty), .A2(ten), .ZN(n24) );
  INV_X4 U37 ( .A(n24), .ZN(n60) );
  INV_X1 U38 ( .A(n68), .ZN(n25) );
  AND2_X1 U39 ( .A1(n42), .A2(n43), .ZN(n26) );
  INV_X1 U40 ( .A(n42), .ZN(n27) );
  NAND2_X1 U41 ( .A1(n44), .A2(n45), .ZN(n28) );
  BUF_X1 U42 ( .A(State[2]), .Z(n29) );
  CLKBUF_X1 U43 ( .A(n66), .Z(n30) );
  AND2_X1 U44 ( .A1(n46), .A2(n41), .ZN(n31) );
  AND2_X1 U45 ( .A1(n27), .A2(n43), .ZN(n32) );
  XNOR2_X1 U46 ( .A(n28), .B(n46), .ZN(n69) );
  AND3_X1 U47 ( .A1(n57), .A2(n58), .A3(n26), .ZN(ready) );
  CLKBUF_X1 U48 ( .A(n43), .Z(n34) );
  AND4_X1 U49 ( .A1(n47), .A2(n48), .A3(n34), .A4(State[3]), .ZN(n35) );
  AND4_X2 U50 ( .A1(n42), .A2(State[4]), .A3(n41), .A4(n46), .ZN(n36) );
  CLKBUF_X1 U51 ( .A(n44), .Z(n37) );
  CLKBUF_X1 U52 ( .A(n45), .Z(n38) );
  NAND4_X1 U53 ( .A1(n47), .A2(n48), .A3(n34), .A4(State[3]), .ZN(n39) );
  XNOR2_X1 U54 ( .A(State[5]), .B(State[4]), .ZN(n61) );
  NOR2_X1 U55 ( .A1(State[5]), .A2(State[1]), .ZN(n47) );
  INV_X1 U56 ( .A(n46), .ZN(n40) );
  NOR3_X1 U57 ( .A1(n40), .A2(n61), .A3(State[3]), .ZN(n67) );
  NOR2_X1 U58 ( .A1(State[2]), .A2(State[0]), .ZN(n48) );
  AOI211_X1 U59 ( .C1(n67), .C2(n30), .A(n65), .B(n35), .ZN(NextState[0]) );
  NOR4_X1 U60 ( .A1(n62), .A2(n64), .A3(n63), .A4(n24), .ZN(n65) );
  INV_X1 U61 ( .A(ten), .ZN(n59) );
  NAND2_X1 U62 ( .A1(twenty), .A2(n59), .ZN(n55) );
  INV_X1 U63 ( .A(n55), .ZN(n51) );
  NAND2_X1 U64 ( .A1(State[0]), .A2(n44), .ZN(n62) );
  INV_X1 U65 ( .A(n62), .ZN(n57) );
  NAND2_X1 U66 ( .A1(n42), .A2(n43), .ZN(n63) );
  NAND2_X1 U67 ( .A1(n45), .A2(n41), .ZN(n64) );
  INV_X1 U68 ( .A(n64), .ZN(n58) );
  NAND4_X1 U69 ( .A1(n51), .A2(n57), .A3(n26), .A4(n58), .ZN(n50) );
  NAND2_X1 U70 ( .A1(n44), .A2(n45), .ZN(n68) );
  INV_X1 U71 ( .A(n68), .ZN(n66) );
  NAND3_X1 U72 ( .A1(n36), .A2(n24), .A3(n25), .ZN(n49) );
  OAI211_X1 U73 ( .C1(n39), .C2(n59), .A(n49), .B(n50), .ZN(NextState[4]) );
  INV_X1 U74 ( .A(clear), .ZN(n73) );
  NAND3_X1 U75 ( .A1(n32), .A2(n31), .A3(n66), .ZN(n56) );
  NAND3_X1 U76 ( .A1(n36), .A2(n25), .A3(n51), .ZN(n52) );
  OAI21_X1 U77 ( .B1(n56), .B2(n59), .A(n52), .ZN(NextState[1]) );
  NAND4_X1 U78 ( .A1(n25), .A2(n32), .A3(n31), .A4(n24), .ZN(n54) );
  NAND3_X1 U79 ( .A1(n36), .A2(ten), .A3(n25), .ZN(n53) );
  OAI211_X1 U80 ( .C1(n39), .C2(n55), .A(n53), .B(n54), .ZN(NextState[5]) );
  NOR2_X1 U81 ( .A1(n56), .A2(n55), .ZN(NextState[2]) );
  NAND3_X1 U82 ( .A1(n26), .A2(n58), .A3(n57), .ZN(n72) );
  OAI22_X1 U83 ( .A1(n39), .A2(n60), .B1(n72), .B2(n59), .ZN(NextState[3]) );
  NAND3_X1 U84 ( .A1(n42), .A2(n43), .A3(n41), .ZN(n71) );
  INV_X1 U85 ( .A(n71), .ZN(n70) );
  OAI211_X1 U86 ( .C1(n38), .C2(n37), .A(n70), .B(n69), .ZN(bill) );
  NOR4_X1 U87 ( .A1(n40), .A2(n71), .A3(State[1]), .A4(n37), .ZN(return_sig)
         );
  NOR4_X1 U88 ( .A1(n40), .A2(n71), .A3(n29), .A4(n38), .ZN(dispense) );
endmodule

