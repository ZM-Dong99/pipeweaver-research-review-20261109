/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:39:52 2025
/////////////////////////////////////////////////////////////


module mux_dead_dsr ( x, sel, a, b, result );
  input [7:0] a;
  input [7:0] b;
  output [7:0] result;
  input x, sel;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24;

  OAI22_X1 U33 ( .A1(n8), .A2(n16), .B1(x), .B2(n24), .ZN(result[0]) );
  INV_X1 U34 ( .A(a[0]), .ZN(n8) );
  INV_X1 U35 ( .A(b[0]), .ZN(n16) );
  NOR2_X1 U36 ( .A1(a[0]), .A2(b[0]), .ZN(n24) );
  OAI22_X1 U37 ( .A1(n7), .A2(n15), .B1(x), .B2(n23), .ZN(result[1]) );
  INV_X1 U38 ( .A(a[1]), .ZN(n7) );
  INV_X1 U39 ( .A(b[1]), .ZN(n15) );
  NOR2_X1 U40 ( .A1(a[1]), .A2(b[1]), .ZN(n23) );
  OAI22_X1 U41 ( .A1(n6), .A2(n14), .B1(x), .B2(n22), .ZN(result[2]) );
  INV_X1 U42 ( .A(a[2]), .ZN(n6) );
  INV_X1 U43 ( .A(b[2]), .ZN(n14) );
  NOR2_X1 U44 ( .A1(a[2]), .A2(b[2]), .ZN(n22) );
  OAI22_X1 U45 ( .A1(n5), .A2(n13), .B1(x), .B2(n21), .ZN(result[3]) );
  INV_X1 U46 ( .A(a[3]), .ZN(n5) );
  INV_X1 U47 ( .A(b[3]), .ZN(n13) );
  NOR2_X1 U48 ( .A1(a[3]), .A2(b[3]), .ZN(n21) );
  OAI22_X1 U49 ( .A1(n4), .A2(n12), .B1(x), .B2(n20), .ZN(result[4]) );
  INV_X1 U50 ( .A(a[4]), .ZN(n4) );
  INV_X1 U51 ( .A(b[4]), .ZN(n12) );
  NOR2_X1 U52 ( .A1(a[4]), .A2(b[4]), .ZN(n20) );
  OAI22_X1 U53 ( .A1(n3), .A2(n11), .B1(x), .B2(n19), .ZN(result[5]) );
  INV_X1 U54 ( .A(a[5]), .ZN(n3) );
  INV_X1 U55 ( .A(b[5]), .ZN(n11) );
  NOR2_X1 U56 ( .A1(a[5]), .A2(b[5]), .ZN(n19) );
  OAI22_X1 U57 ( .A1(n2), .A2(n10), .B1(x), .B2(n18), .ZN(result[6]) );
  INV_X1 U58 ( .A(a[6]), .ZN(n2) );
  INV_X1 U59 ( .A(b[6]), .ZN(n10) );
  NOR2_X1 U60 ( .A1(a[6]), .A2(b[6]), .ZN(n18) );
  OAI22_X1 U61 ( .A1(n1), .A2(n9), .B1(x), .B2(n17), .ZN(result[7]) );
  INV_X1 U62 ( .A(a[7]), .ZN(n1) );
  INV_X1 U63 ( .A(b[7]), .ZN(n9) );
  NOR2_X1 U64 ( .A1(a[7]), .A2(b[7]), .ZN(n17) );
endmodule

