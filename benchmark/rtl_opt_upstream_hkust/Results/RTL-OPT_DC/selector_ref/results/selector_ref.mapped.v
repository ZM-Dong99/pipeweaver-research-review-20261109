/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 02:41:51 2025
/////////////////////////////////////////////////////////////


module selector_ref ( clk, sel, dout );
  input [3:0] sel;
  output [6:0] dout;
  input clk;
  wire   N63, N64, N65, N66, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37;

  DFF_X1 dout_reg_5_ ( .D(n21), .CK(clk), .Q(dout[5]) );
  DFF_X1 dout_reg_1_ ( .D(N63), .CK(clk), .Q(dout[1]) );
  DFF_X1 dout_reg_0_ ( .D(sel[0]), .CK(clk), .Q(dout[0]) );
  DFF_X1 dout_reg_2_ ( .D(N64), .CK(clk), .Q(dout[2]) );
  DFF_X1 dout_reg_4_ ( .D(N66), .CK(clk), .Q(dout[4]) );
  DFF_X1 dout_reg_3_ ( .D(N65), .CK(clk), .Q(dout[3]) );
  INV_X1 U23 ( .A(1'b1), .ZN(dout[6]) );
  BUF_X2 U25 ( .A(sel[3]), .Z(n21) );
  INV_X1 U26 ( .A(sel[0]), .ZN(n19) );
  CLKBUF_X1 U27 ( .A(n22), .Z(n20) );
  XNOR2_X1 U28 ( .A(sel[0]), .B(sel[1]), .ZN(N63) );
  BUF_X2 U30 ( .A(sel[2]), .Z(n22) );
  INV_X1 U31 ( .A(sel[2]), .ZN(n23) );
  INV_X1 U32 ( .A(sel[1]), .ZN(n24) );
  INV_X1 U33 ( .A(sel[1]), .ZN(n25) );
  INV_X1 U34 ( .A(sel[3]), .ZN(n26) );
  INV_X1 U35 ( .A(sel[3]), .ZN(n27) );
  OAI221_X1 U36 ( .B1(n26), .B2(sel[1]), .C1(sel[1]), .C2(n29), .A(n22), .ZN(
        n28) );
  INV_X1 U37 ( .A(sel[1]), .ZN(n35) );
  NAND2_X1 U38 ( .A1(sel[0]), .A2(n35), .ZN(n36) );
  INV_X1 U39 ( .A(sel[0]), .ZN(n29) );
  NAND4_X1 U40 ( .A1(n22), .A2(n21), .A3(n25), .A4(n29), .ZN(n31) );
  INV_X1 U41 ( .A(sel[3]), .ZN(n30) );
  OAI221_X1 U42 ( .B1(n30), .B2(sel[1]), .C1(sel[1]), .C2(n19), .A(n22), .ZN(
        n34) );
  OAI211_X1 U43 ( .C1(n20), .C2(n36), .A(n31), .B(n28), .ZN(N64) );
  INV_X1 U44 ( .A(sel[2]), .ZN(n37) );
  AOI21_X1 U45 ( .B1(sel[1]), .B2(n37), .A(n27), .ZN(n33) );
  OAI33_X1 U46 ( .A1(n24), .A2(sel[2]), .A3(sel[3]), .B1(n23), .B2(sel[0]), 
        .B3(sel[1]), .ZN(n32) );
  OAI21_X1 U47 ( .B1(n32), .B2(n33), .A(n31), .ZN(N65) );
  OAI221_X1 U48 ( .B1(n37), .B2(n36), .C1(n21), .C2(n24), .A(n34), .ZN(N66) );
endmodule

