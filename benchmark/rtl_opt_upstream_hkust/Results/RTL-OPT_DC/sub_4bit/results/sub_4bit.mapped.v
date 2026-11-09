/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:10:00 2025
/////////////////////////////////////////////////////////////


module sub_4bit ( a, b, diff, overflow );
  input [3:0] a;
  input [3:0] b;
  output [3:0] diff;
  output overflow;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46;

  INV_X1 U20 ( .A(a[2]), .ZN(n15) );
  XNOR2_X1 U21 ( .A(n16), .B(n41), .ZN(diff[2]) );
  XNOR2_X1 U22 ( .A(n36), .B(a[2]), .ZN(n16) );
  XOR2_X1 U23 ( .A(n17), .B(n35), .Z(diff[1]) );
  XNOR2_X1 U24 ( .A(n18), .B(a[1]), .ZN(n17) );
  BUF_X1 U25 ( .A(b[1]), .Z(n18) );
  INV_X1 U26 ( .A(b[2]), .ZN(n19) );
  INV_X1 U27 ( .A(n38), .ZN(n20) );
  INV_X1 U28 ( .A(b[1]), .ZN(n21) );
  XNOR2_X1 U29 ( .A(n22), .B(n25), .ZN(diff[3]) );
  AND3_X1 U30 ( .A1(n44), .A2(n45), .A3(n46), .ZN(n22) );
  CLKBUF_X1 U31 ( .A(n44), .Z(n23) );
  INV_X1 U32 ( .A(a[2]), .ZN(n24) );
  XOR2_X1 U33 ( .A(b[3]), .B(a[3]), .Z(n25) );
  INV_X1 U34 ( .A(a[2]), .ZN(n43) );
  INV_X1 U35 ( .A(a[1]), .ZN(n42) );
  OAI211_X1 U36 ( .C1(b[2]), .C2(n43), .A(n42), .B(b[1]), .ZN(n26) );
  NAND2_X1 U37 ( .A1(b[2]), .A2(n24), .ZN(n45) );
  NAND2_X1 U38 ( .A1(n46), .A2(n45), .ZN(n34) );
  INV_X1 U39 ( .A(n26), .ZN(n27) );
  AOI211_X1 U40 ( .C1(b[2]), .C2(n24), .A(b[3]), .B(n27), .ZN(n33) );
  INV_X1 U41 ( .A(a[0]), .ZN(n39) );
  INV_X1 U42 ( .A(b[2]), .ZN(n36) );
  INV_X1 U43 ( .A(b[1]), .ZN(n38) );
  AOI22_X1 U44 ( .A1(a[2]), .A2(n19), .B1(n21), .B2(a[1]), .ZN(n28) );
  NAND3_X1 U45 ( .A1(n28), .A2(n39), .A3(b[0]), .ZN(n44) );
  INV_X1 U46 ( .A(b[0]), .ZN(n37) );
  INV_X1 U47 ( .A(b[3]), .ZN(n30) );
  NOR3_X1 U48 ( .A1(a[0]), .A2(n37), .A3(n30), .ZN(n29) );
  OAI221_X1 U49 ( .B1(b[2]), .B2(n15), .C1(n18), .C2(n42), .A(n29), .ZN(n31)
         );
  NAND2_X1 U50 ( .A1(n31), .A2(n25), .ZN(n32) );
  AOI221_X1 U51 ( .B1(b[3]), .B2(n34), .C1(n23), .C2(n33), .A(n32), .ZN(
        overflow) );
  NAND2_X1 U52 ( .A1(b[0]), .A2(n39), .ZN(n35) );
  OAI21_X1 U53 ( .B1(b[0]), .B2(n39), .A(n35), .ZN(diff[0]) );
  AOI21_X1 U54 ( .B1(a[1]), .B2(n38), .A(n37), .ZN(n40) );
  AOI22_X1 U55 ( .A1(n40), .A2(n39), .B1(n20), .B2(n42), .ZN(n41) );
  OAI211_X1 U56 ( .C1(b[2]), .C2(n15), .A(n18), .B(n42), .ZN(n46) );
endmodule

