/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 01:42:53 2025
/////////////////////////////////////////////////////////////


module adder_carry ( a, b, cin, sum, cout );
  input [7:0] a;
  input [7:0] b;
  output [7:0] sum;
  input cin;
  output cout;
  wire   n2, n3, n4, n5, n6, n7, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, p_adder_0_n1, adder_gen_1__p_adder_n1,
         adder_gen_3__p_adder_n3, adder_gen_3__p_adder_n2,
         adder_gen_3__p_adder_n1, adder_gen_4__p_adder_n1,
         adder_gen_5__p_adder_n1;
  wire   [7:1] p;
  wire   [7:0] g;

  CLKBUF_X1 U17 ( .A(p[3]), .Z(n17) );
  CLKBUF_X1 U18 ( .A(p[3]), .Z(n24) );
  BUF_X1 U19 ( .A(n66), .Z(n26) );
  NOR3_X1 U20 ( .A1(g[1]), .A2(g[2]), .A3(g[0]), .ZN(n18) );
  NOR3_X1 U21 ( .A1(g[1]), .A2(g[2]), .A3(g[0]), .ZN(n34) );
  CLKBUF_X1 U22 ( .A(p[2]), .Z(n19) );
  NAND3_X1 U23 ( .A1(n66), .A2(n63), .A3(n65), .ZN(n20) );
  NAND3_X1 U24 ( .A1(n66), .A2(n63), .A3(n65), .ZN(n56) );
  AOI21_X1 U25 ( .B1(n37), .B2(n22), .A(g[6]), .ZN(n21) );
  AOI21_X1 U26 ( .B1(n37), .B2(n22), .A(g[6]), .ZN(n38) );
  AND2_X2 U27 ( .A1(p[6]), .A2(p[4]), .ZN(n27) );
  CLKBUF_X1 U28 ( .A(p[6]), .Z(n22) );
  NAND4_X1 U29 ( .A1(n55), .A2(n56), .A3(n32), .A4(n27), .ZN(n23) );
  OAI221_X1 U30 ( .B1(n41), .B2(n42), .C1(n39), .C2(n40), .A(n21), .ZN(n25) );
  OAI21_X1 U31 ( .B1(n61), .B2(n60), .A(n18), .ZN(n31) );
  NOR2_X1 U32 ( .A1(g[4]), .A2(g[5]), .ZN(n35) );
  CLKBUF_X1 U33 ( .A(g[0]), .Z(n28) );
  INV_X1 U34 ( .A(n26), .ZN(n29) );
  INV_X1 U35 ( .A(n53), .ZN(n30) );
  CLKBUF_X1 U36 ( .A(g[2]), .Z(n33) );
  AOI22_X1 U37 ( .A1(n17), .A2(p[2]), .B1(n24), .B2(n33), .ZN(n40) );
  CLKBUF_X1 U38 ( .A(p[5]), .Z(n32) );
  NOR2_X1 U39 ( .A1(n36), .A2(n35), .ZN(n37) );
  NOR2_X1 U40 ( .A1(p[5]), .A2(g[5]), .ZN(n36) );
  INV_X1 U41 ( .A(n32), .ZN(n42) );
  NAND4_X1 U42 ( .A1(n55), .A2(n56), .A3(n32), .A4(n27), .ZN(n39) );
  OAI221_X1 U43 ( .B1(n41), .B2(n42), .C1(n23), .C2(n40), .A(n38), .ZN(n2) );
  NAND2_X1 U44 ( .A1(g[3]), .A2(n27), .ZN(n41) );
  INV_X1 U45 ( .A(g[1]), .ZN(n65) );
  INV_X1 U46 ( .A(g[2]), .ZN(n63) );
  INV_X1 U47 ( .A(p[1]), .ZN(n66) );
  INV_X1 U48 ( .A(n70), .ZN(n61) );
  INV_X1 U49 ( .A(cin), .ZN(n60) );
  OAI21_X1 U50 ( .B1(n61), .B2(n60), .A(n34), .ZN(n55) );
  OAI21_X1 U51 ( .B1(g[4]), .B2(p[4]), .A(p[5]), .ZN(n43) );
  INV_X1 U52 ( .A(n43), .ZN(n46) );
  OAI21_X1 U53 ( .B1(g[4]), .B2(g[3]), .A(n46), .ZN(n49) );
  INV_X1 U54 ( .A(g[5]), .ZN(n48) );
  INV_X1 U55 ( .A(p[2]), .ZN(n64) );
  INV_X1 U56 ( .A(p[3]), .ZN(n44) );
  OAI22_X1 U57 ( .A1(n64), .A2(n44), .B1(n44), .B2(n63), .ZN(n45) );
  NAND4_X1 U58 ( .A1(n45), .A2(n31), .A3(n20), .A4(n46), .ZN(n47) );
  NAND3_X1 U59 ( .A1(n47), .A2(n48), .A3(n49), .ZN(n3) );
  INV_X1 U60 ( .A(p[4]), .ZN(n53) );
  INV_X1 U61 ( .A(g[3]), .ZN(n58) );
  INV_X1 U62 ( .A(g[4]), .ZN(n52) );
  OAI21_X1 U63 ( .B1(p[2]), .B2(n33), .A(p[3]), .ZN(n50) );
  INV_X1 U64 ( .A(n50), .ZN(n54) );
  NAND4_X1 U65 ( .A1(n31), .A2(n54), .A3(n30), .A4(n20), .ZN(n51) );
  OAI211_X1 U66 ( .C1(n53), .C2(n58), .A(n51), .B(n52), .ZN(n4) );
  NAND3_X1 U67 ( .A1(n54), .A2(n20), .A3(n31), .ZN(n57) );
  NAND2_X1 U68 ( .A1(n57), .A2(n58), .ZN(n5) );
  INV_X1 U69 ( .A(n28), .ZN(n59) );
  OAI21_X1 U70 ( .B1(n61), .B2(n60), .A(n59), .ZN(n69) );
  NAND3_X1 U71 ( .A1(n29), .A2(n19), .A3(n69), .ZN(n62) );
  OAI211_X1 U72 ( .C1(n64), .C2(n65), .A(n62), .B(n63), .ZN(n6) );
  INV_X1 U73 ( .A(n69), .ZN(n67) );
  OAI21_X1 U74 ( .B1(n67), .B2(n26), .A(n65), .ZN(n7) );
  AOI21_X1 U75 ( .B1(n2), .B2(p[7]), .A(g[7]), .ZN(n68) );
  INV_X1 U76 ( .A(n68), .ZN(cout) );
  XOR2_X1 p_adder_0_U4 ( .A(b[0]), .B(a[0]), .Z(n70) );
  XNOR2_X1 p_adder_0_U3 ( .A(b[0]), .B(a[0]), .ZN(p_adder_0_n1) );
  XNOR2_X1 p_adder_0_U2 ( .A(cin), .B(p_adder_0_n1), .ZN(sum[0]) );
  AND2_X1 p_adder_0_U1 ( .A1(a[0]), .A2(b[0]), .ZN(g[0]) );
  XOR2_X1 adder_gen_1__p_adder_U4 ( .A(b[1]), .B(a[1]), .Z(p[1]) );
  XNOR2_X1 adder_gen_1__p_adder_U3 ( .A(b[1]), .B(a[1]), .ZN(
        adder_gen_1__p_adder_n1) );
  XNOR2_X1 adder_gen_1__p_adder_U2 ( .A(n69), .B(adder_gen_1__p_adder_n1), 
        .ZN(sum[1]) );
  AND2_X1 adder_gen_1__p_adder_U1 ( .A1(a[1]), .A2(b[1]), .ZN(g[1]) );
  XOR2_X1 adder_gen_2__p_adder_U3 ( .A(p[2]), .B(n7), .Z(sum[2]) );
  AND2_X2 adder_gen_2__p_adder_U2 ( .A1(a[2]), .A2(b[2]), .ZN(g[2]) );
  XOR2_X2 adder_gen_2__p_adder_U1 ( .A(b[2]), .B(a[2]), .Z(p[2]) );
  AND2_X1 adder_gen_3__p_adder_U6 ( .A1(adder_gen_3__p_adder_n2), .A2(
        adder_gen_3__p_adder_n1), .ZN(g[3]) );
  XNOR2_X1 adder_gen_3__p_adder_U5 ( .A(adder_gen_3__p_adder_n1), .B(
        adder_gen_3__p_adder_n2), .ZN(adder_gen_3__p_adder_n3) );
  XNOR2_X1 adder_gen_3__p_adder_U4 ( .A(n6), .B(adder_gen_3__p_adder_n3), .ZN(
        sum[3]) );
  XOR2_X1 adder_gen_3__p_adder_U3 ( .A(b[3]), .B(a[3]), .Z(p[3]) );
  BUF_X2 adder_gen_3__p_adder_U2 ( .A(a[3]), .Z(adder_gen_3__p_adder_n2) );
  BUF_X1 adder_gen_3__p_adder_U1 ( .A(b[3]), .Z(adder_gen_3__p_adder_n1) );
  AND2_X1 adder_gen_4__p_adder_U4 ( .A1(a[4]), .A2(b[4]), .ZN(g[4]) );
  XNOR2_X1 adder_gen_4__p_adder_U3 ( .A(b[4]), .B(a[4]), .ZN(
        adder_gen_4__p_adder_n1) );
  XNOR2_X1 adder_gen_4__p_adder_U2 ( .A(n5), .B(adder_gen_4__p_adder_n1), .ZN(
        sum[4]) );
  XOR2_X1 adder_gen_4__p_adder_U1 ( .A(b[4]), .B(a[4]), .Z(p[4]) );
  XOR2_X1 adder_gen_5__p_adder_U4 ( .A(a[5]), .B(b[5]), .Z(p[5]) );
  AND2_X1 adder_gen_5__p_adder_U3 ( .A1(a[5]), .A2(b[5]), .ZN(g[5]) );
  XNOR2_X1 adder_gen_5__p_adder_U2 ( .A(a[5]), .B(b[5]), .ZN(
        adder_gen_5__p_adder_n1) );
  XNOR2_X1 adder_gen_5__p_adder_U1 ( .A(n4), .B(adder_gen_5__p_adder_n1), .ZN(
        sum[5]) );
  XOR2_X1 adder_gen_6__p_adder_U3 ( .A(p[6]), .B(n3), .Z(sum[6]) );
  AND2_X1 adder_gen_6__p_adder_U2 ( .A1(a[6]), .A2(b[6]), .ZN(g[6]) );
  XOR2_X1 adder_gen_6__p_adder_U1 ( .A(a[6]), .B(b[6]), .Z(p[6]) );
  XOR2_X1 p_adder_1_U3 ( .A(n25), .B(p[7]), .Z(sum[7]) );
  XOR2_X1 p_adder_1_U2 ( .A(a[7]), .B(b[7]), .Z(p[7]) );
  AND2_X1 p_adder_1_U1 ( .A1(b[7]), .A2(a[7]), .ZN(g[7]) );
endmodule

