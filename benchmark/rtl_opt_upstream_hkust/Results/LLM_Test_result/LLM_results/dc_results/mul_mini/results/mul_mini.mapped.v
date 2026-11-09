/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:08:53 2025
/////////////////////////////////////////////////////////////


module mul_mini ( clk, a, b, z );
  input [7:0] a;
  input [7:0] b;
  output [7:0] z;
  input clk;
  wire   N9, N8, N7, N15, N14, N13, N12, N11, N10, n1, n2, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n22, mult_8_n73, mult_8_n72, mult_8_n71, mult_8_n70, mult_8_n69,
         mult_8_n68, mult_8_n67, mult_8_n66, mult_8_n65, mult_8_n64,
         mult_8_n63, mult_8_n62, mult_8_n61, mult_8_n60, mult_8_n59,
         mult_8_n58, mult_8_n57, mult_8_n56, mult_8_n55, mult_8_n54,
         mult_8_n53, mult_8_n52, mult_8_n51, mult_8_n50, mult_8_n49,
         mult_8_n48, mult_8_n47, mult_8_n46, mult_8_n45, mult_8_n44,
         mult_8_n43, mult_8_n42, mult_8_n41, mult_8_n40, mult_8_n39,
         mult_8_n38, mult_8_n37, mult_8_n36, mult_8_n35, mult_8_n34,
         mult_8_n33, mult_8_n32, mult_8_n31, mult_8_n30, mult_8_n29,
         mult_8_n28, mult_8_n27, mult_8_n26, mult_8_n25, mult_8_n24,
         mult_8_n23, mult_8_n22, mult_8_n21, mult_8_n20, mult_8_n19,
         mult_8_n18, mult_8_n17, mult_8_n16, mult_8_n15, mult_8_n14,
         mult_8_n13, mult_8_n12, mult_8_n11, mult_8_n10, mult_8_n9, mult_8_n8,
         mult_8_n7, mult_8_n6, mult_8_n5, mult_8_n4, mult_8_n3, mult_8_n2,
         mult_8_A2_6_, mult_8_A1_0_, mult_8_A1_1_, mult_8_A1_2_, mult_8_A1_3_,
         mult_8_A1_4_, mult_8_A1_5_, mult_8_A1_13_, mult_8_SUMB_1__6_,
         mult_8_SUMB_2__1_, mult_8_SUMB_2__2_, mult_8_SUMB_2__3_,
         mult_8_SUMB_2__4_, mult_8_SUMB_2__5_, mult_8_SUMB_2__6_,
         mult_8_SUMB_3__1_, mult_8_SUMB_3__2_, mult_8_SUMB_3__3_,
         mult_8_SUMB_3__4_, mult_8_SUMB_3__5_, mult_8_SUMB_3__6_,
         mult_8_SUMB_4__1_, mult_8_SUMB_4__2_, mult_8_SUMB_4__3_,
         mult_8_SUMB_4__4_, mult_8_SUMB_4__5_, mult_8_SUMB_4__6_,
         mult_8_SUMB_5__1_, mult_8_SUMB_5__2_, mult_8_SUMB_5__3_,
         mult_8_SUMB_5__4_, mult_8_SUMB_5__5_, mult_8_SUMB_5__6_,
         mult_8_SUMB_6__1_, mult_8_SUMB_6__2_, mult_8_SUMB_6__3_,
         mult_8_SUMB_6__4_, mult_8_SUMB_6__5_, mult_8_SUMB_6__6_,
         mult_8_SUMB_7__0_, mult_8_SUMB_7__1_, mult_8_SUMB_7__2_,
         mult_8_SUMB_7__3_, mult_8_SUMB_7__4_, mult_8_SUMB_7__5_,
         mult_8_SUMB_7__6_, mult_8_SUMB_7__7_, mult_8_CARRYB_1__0_,
         mult_8_CARRYB_1__6_, mult_8_CARRYB_2__0_, mult_8_CARRYB_2__1_,
         mult_8_CARRYB_2__2_, mult_8_CARRYB_2__3_, mult_8_CARRYB_2__4_,
         mult_8_CARRYB_2__5_, mult_8_CARRYB_2__6_, mult_8_CARRYB_3__0_,
         mult_8_CARRYB_3__1_, mult_8_CARRYB_3__2_, mult_8_CARRYB_3__3_,
         mult_8_CARRYB_3__4_, mult_8_CARRYB_3__5_, mult_8_CARRYB_3__6_,
         mult_8_CARRYB_4__0_, mult_8_CARRYB_4__1_, mult_8_CARRYB_4__2_,
         mult_8_CARRYB_4__3_, mult_8_CARRYB_4__4_, mult_8_CARRYB_4__5_,
         mult_8_CARRYB_4__6_, mult_8_CARRYB_5__0_, mult_8_CARRYB_5__1_,
         mult_8_CARRYB_5__2_, mult_8_CARRYB_5__3_, mult_8_CARRYB_5__4_,
         mult_8_CARRYB_5__5_, mult_8_CARRYB_5__6_, mult_8_CARRYB_6__0_,
         mult_8_CARRYB_6__1_, mult_8_CARRYB_6__2_, mult_8_CARRYB_6__3_,
         mult_8_CARRYB_6__4_, mult_8_CARRYB_6__5_, mult_8_CARRYB_6__6_,
         mult_8_CARRYB_7__0_, mult_8_CARRYB_7__1_, mult_8_CARRYB_7__2_,
         mult_8_CARRYB_7__3_, mult_8_CARRYB_7__4_, mult_8_CARRYB_7__5_,
         mult_8_CARRYB_7__6_, mult_8_CARRYB_7__7_, mult_8_ab_0__2_,
         mult_8_ab_0__3_, mult_8_ab_0__4_, mult_8_ab_0__5_, mult_8_ab_0__6_,
         mult_8_ab_0__7_, mult_8_ab_1__2_, mult_8_ab_1__3_, mult_8_ab_1__4_,
         mult_8_ab_1__5_, mult_8_ab_1__6_, mult_8_ab_1__7_, mult_8_ab_2__0_,
         mult_8_ab_2__1_, mult_8_ab_2__2_, mult_8_ab_2__3_, mult_8_ab_2__4_,
         mult_8_ab_2__5_, mult_8_ab_2__6_, mult_8_ab_2__7_, mult_8_ab_3__0_,
         mult_8_ab_3__1_, mult_8_ab_3__2_, mult_8_ab_3__3_, mult_8_ab_3__4_,
         mult_8_ab_3__5_, mult_8_ab_3__6_, mult_8_ab_3__7_, mult_8_ab_4__0_,
         mult_8_ab_4__1_, mult_8_ab_4__2_, mult_8_ab_4__3_, mult_8_ab_4__4_,
         mult_8_ab_4__5_, mult_8_ab_4__6_, mult_8_ab_4__7_, mult_8_ab_5__0_,
         mult_8_ab_5__1_, mult_8_ab_5__2_, mult_8_ab_5__3_, mult_8_ab_5__4_,
         mult_8_ab_5__5_, mult_8_ab_5__6_, mult_8_ab_5__7_, mult_8_ab_6__0_,
         mult_8_ab_6__1_, mult_8_ab_6__2_, mult_8_ab_6__3_, mult_8_ab_6__4_,
         mult_8_ab_6__5_, mult_8_ab_6__6_, mult_8_ab_6__7_, mult_8_ab_7__0_,
         mult_8_ab_7__1_, mult_8_ab_7__2_, mult_8_ab_7__3_, mult_8_ab_7__4_,
         mult_8_ab_7__5_, mult_8_ab_7__6_, mult_8_ab_7__7_, mult_8_FS_1_n79,
         mult_8_FS_1_n78, mult_8_FS_1_n77, mult_8_FS_1_n76, mult_8_FS_1_n75,
         mult_8_FS_1_n74, mult_8_FS_1_n73, mult_8_FS_1_n72, mult_8_FS_1_n71,
         mult_8_FS_1_n70, mult_8_FS_1_n69, mult_8_FS_1_n68, mult_8_FS_1_n67,
         mult_8_FS_1_n66, mult_8_FS_1_n65, mult_8_FS_1_n64, mult_8_FS_1_n63,
         mult_8_FS_1_n62, mult_8_FS_1_n61, mult_8_FS_1_n60, mult_8_FS_1_n59,
         mult_8_FS_1_n58, mult_8_FS_1_n57, mult_8_FS_1_n56, mult_8_FS_1_n55,
         mult_8_FS_1_n54, mult_8_FS_1_n53, mult_8_FS_1_n52, mult_8_FS_1_n51,
         mult_8_FS_1_n50, mult_8_FS_1_n49, mult_8_FS_1_n48, mult_8_FS_1_n47,
         mult_8_FS_1_n46, mult_8_FS_1_n45, mult_8_FS_1_n44, mult_8_FS_1_n43,
         mult_8_FS_1_n42, mult_8_FS_1_n41, mult_8_FS_1_n40, mult_8_FS_1_n39,
         mult_8_FS_1_n38, mult_8_FS_1_n37, mult_8_FS_1_n36, mult_8_FS_1_n35,
         mult_8_FS_1_n34, mult_8_FS_1_n33, mult_8_FS_1_n32, mult_8_FS_1_n31,
         mult_8_FS_1_n30, mult_8_FS_1_n29, mult_8_FS_1_n28, mult_8_FS_1_n27,
         mult_8_FS_1_n26, mult_8_FS_1_n25, mult_8_FS_1_n24, mult_8_FS_1_n23,
         mult_8_FS_1_n22, mult_8_FS_1_n21, mult_8_FS_1_n20, mult_8_FS_1_n19,
         mult_8_FS_1_n18, mult_8_FS_1_n17, mult_8_FS_1_n15, mult_8_FS_1_n14,
         mult_8_FS_1_n13, mult_8_FS_1_n12, mult_8_FS_1_n11, mult_8_FS_1_n10,
         mult_8_FS_1_n9, mult_8_FS_1_n8, mult_8_FS_1_n7, mult_8_FS_1_n6,
         mult_8_FS_1_n5, mult_8_FS_1_n4, mult_8_FS_1_n3, mult_8_FS_1_n1;
  wire   [15:8] t;

  DFF_X1 z_reg_2_ ( .D(t[10]), .CK(clk), .Q(z[2]) );
  DFF_X1 z_reg_1_ ( .D(t[9]), .CK(clk), .Q(z[1]) );
  DFF_X1 z_reg_0_ ( .D(t[8]), .CK(clk), .Q(z[0]) );
  DFF_X1 z_reg_3_ ( .D(t[11]), .CK(clk), .Q(z[3]) );
  DFF_X1 z_reg_4_ ( .D(t[12]), .CK(clk), .Q(z[4]) );
  DFF_X1 z_reg_7_ ( .D(t[15]), .CK(clk), .Q(z[7]) );
  DFF_X1 z_reg_6_ ( .D(t[14]), .CK(clk), .Q(z[6]) );
  DFF_X1 z_reg_5_ ( .D(t[13]), .CK(clk), .Q(z[5]) );
  XNOR2_X1 U3 ( .A(N8), .B(n12), .ZN(t[8]) );
  BUF_X1 U4 ( .A(n10), .Z(n1) );
  XNOR2_X1 U5 ( .A(n14), .B(n1), .ZN(t[10]) );
  AND3_X1 U6 ( .A1(N10), .A2(n10), .A3(N11), .ZN(n2) );
  CLKBUF_X1 U7 ( .A(N13), .Z(n3) );
  CLKBUF_X1 U8 ( .A(N9), .Z(n4) );
  CLKBUF_X1 U9 ( .A(N11), .Z(n5) );
  CLKBUF_X1 U10 ( .A(N12), .Z(n6) );
  AND3_X1 U11 ( .A1(N10), .A2(n10), .A3(N11), .ZN(n7) );
  CLKBUF_X1 U12 ( .A(N14), .Z(n8) );
  NAND3_X1 U13 ( .A1(n4), .A2(N7), .A3(N8), .ZN(n9) );
  AND3_X2 U14 ( .A1(N9), .A2(N7), .A3(N8), .ZN(n10) );
  XNOR2_X1 U15 ( .A(n22), .B(N15), .ZN(t[15]) );
  AND2_X1 U16 ( .A1(N10), .A2(N11), .ZN(n20) );
  NAND4_X1 U17 ( .A1(n21), .A2(n20), .A3(N12), .A4(N13), .ZN(n22) );
  AND2_X1 U18 ( .A1(N14), .A2(n10), .ZN(n21) );
  XNOR2_X1 U19 ( .A(n19), .B(n8), .ZN(t[14]) );
  INV_X1 U20 ( .A(N7), .ZN(n12) );
  INV_X1 U21 ( .A(N8), .ZN(n11) );
  NOR2_X1 U22 ( .A1(n12), .A2(n11), .ZN(n13) );
  XOR2_X1 U23 ( .A(n4), .B(n13), .Z(t[9]) );
  INV_X1 U24 ( .A(N10), .ZN(n14) );
  NOR2_X1 U25 ( .A1(n14), .A2(n9), .ZN(n15) );
  XOR2_X1 U26 ( .A(n15), .B(n5), .Z(t[11]) );
  NAND3_X1 U27 ( .A1(N10), .A2(n10), .A3(N11), .ZN(n18) );
  XOR2_X1 U28 ( .A(n6), .B(n2), .Z(t[12]) );
  INV_X1 U29 ( .A(N12), .ZN(n16) );
  NOR2_X1 U30 ( .A1(n16), .A2(n18), .ZN(n17) );
  XOR2_X1 U31 ( .A(n3), .B(n17), .Z(t[13]) );
  NAND3_X1 U32 ( .A1(n7), .A2(N12), .A3(N13), .ZN(n19) );
  INV_X1 mult_8_U145 ( .A(mult_8_CARRYB_7__7_), .ZN(mult_8_A1_13_) );
  NOR2_X1 mult_8_U144 ( .A1(b[0]), .A2(mult_8_n72), .ZN(mult_8_ab_7__0_) );
  NOR2_X1 mult_8_U143 ( .A1(b[1]), .A2(mult_8_n72), .ZN(mult_8_ab_7__1_) );
  NOR2_X1 mult_8_U142 ( .A1(b[2]), .A2(mult_8_n72), .ZN(mult_8_ab_7__2_) );
  NOR2_X1 mult_8_U141 ( .A1(b[3]), .A2(mult_8_n72), .ZN(mult_8_ab_7__3_) );
  NOR2_X1 mult_8_U140 ( .A1(b[4]), .A2(mult_8_n72), .ZN(mult_8_ab_7__4_) );
  NOR2_X1 mult_8_U139 ( .A1(b[5]), .A2(mult_8_n72), .ZN(mult_8_ab_7__5_) );
  NOR2_X1 mult_8_U138 ( .A1(a[6]), .A2(mult_8_n39), .ZN(mult_8_ab_6__7_) );
  NOR2_X1 mult_8_U137 ( .A1(b[6]), .A2(mult_8_n72), .ZN(mult_8_ab_7__6_) );
  NOR2_X1 mult_8_U136 ( .A1(mult_8_n38), .A2(mult_8_n72), .ZN(mult_8_ab_7__7_)
         );
  NOR2_X1 mult_8_U135 ( .A1(mult_8_n70), .A2(mult_8_n69), .ZN(mult_8_ab_6__0_)
         );
  NOR2_X1 mult_8_U134 ( .A1(mult_8_n69), .A2(mult_8_n68), .ZN(mult_8_ab_6__1_)
         );
  NOR2_X1 mult_8_U133 ( .A1(mult_8_n69), .A2(mult_8_n67), .ZN(mult_8_ab_6__2_)
         );
  NOR2_X1 mult_8_U132 ( .A1(mult_8_n69), .A2(mult_8_n66), .ZN(mult_8_ab_6__3_)
         );
  NOR2_X1 mult_8_U131 ( .A1(mult_8_n69), .A2(mult_8_n9), .ZN(mult_8_ab_6__4_)
         );
  NOR2_X1 mult_8_U130 ( .A1(mult_8_n69), .A2(mult_8_n64), .ZN(mult_8_ab_6__5_)
         );
  NOR2_X1 mult_8_U129 ( .A1(a[5]), .A2(mult_8_n38), .ZN(mult_8_ab_5__7_) );
  NOR2_X1 mult_8_U128 ( .A1(mult_8_n69), .A2(mult_8_n63), .ZN(mult_8_ab_6__6_)
         );
  INV_X1 mult_8_U127 ( .A(a[6]), .ZN(mult_8_n69) );
  NOR2_X1 mult_8_U126 ( .A1(mult_8_n70), .A2(mult_8_n62), .ZN(mult_8_ab_5__0_)
         );
  NOR2_X1 mult_8_U125 ( .A1(mult_8_n68), .A2(mult_8_n62), .ZN(mult_8_ab_5__1_)
         );
  NOR2_X1 mult_8_U124 ( .A1(mult_8_n67), .A2(mult_8_n62), .ZN(mult_8_ab_5__2_)
         );
  NOR2_X1 mult_8_U123 ( .A1(mult_8_n66), .A2(mult_8_n62), .ZN(mult_8_ab_5__3_)
         );
  NOR2_X1 mult_8_U122 ( .A1(mult_8_n9), .A2(mult_8_n62), .ZN(mult_8_ab_5__4_)
         );
  NOR2_X1 mult_8_U121 ( .A1(mult_8_n64), .A2(mult_8_n62), .ZN(mult_8_ab_5__5_)
         );
  NOR2_X1 mult_8_U120 ( .A1(a[4]), .A2(mult_8_n39), .ZN(mult_8_ab_4__7_) );
  NOR2_X1 mult_8_U119 ( .A1(mult_8_n63), .A2(mult_8_n62), .ZN(mult_8_ab_5__6_)
         );
  INV_X1 mult_8_U118 ( .A(a[5]), .ZN(mult_8_n62) );
  NOR2_X1 mult_8_U117 ( .A1(mult_8_n70), .A2(mult_8_n61), .ZN(mult_8_ab_4__0_)
         );
  NOR2_X1 mult_8_U116 ( .A1(mult_8_n68), .A2(mult_8_n61), .ZN(mult_8_ab_4__1_)
         );
  NOR2_X1 mult_8_U115 ( .A1(mult_8_n67), .A2(mult_8_n61), .ZN(mult_8_ab_4__2_)
         );
  NOR2_X1 mult_8_U114 ( .A1(mult_8_n66), .A2(mult_8_n61), .ZN(mult_8_ab_4__3_)
         );
  NOR2_X1 mult_8_U113 ( .A1(mult_8_n9), .A2(mult_8_n61), .ZN(mult_8_ab_4__4_)
         );
  NOR2_X1 mult_8_U112 ( .A1(mult_8_n64), .A2(mult_8_n61), .ZN(mult_8_ab_4__5_)
         );
  NOR2_X1 mult_8_U111 ( .A1(a[3]), .A2(mult_8_n38), .ZN(mult_8_ab_3__7_) );
  NOR2_X1 mult_8_U110 ( .A1(mult_8_n63), .A2(mult_8_n61), .ZN(mult_8_ab_4__6_)
         );
  INV_X1 mult_8_U109 ( .A(a[4]), .ZN(mult_8_n61) );
  NOR2_X1 mult_8_U108 ( .A1(mult_8_n70), .A2(mult_8_n60), .ZN(mult_8_ab_3__0_)
         );
  NOR2_X1 mult_8_U107 ( .A1(mult_8_n68), .A2(mult_8_n60), .ZN(mult_8_ab_3__1_)
         );
  NOR2_X1 mult_8_U106 ( .A1(mult_8_n67), .A2(mult_8_n60), .ZN(mult_8_ab_3__2_)
         );
  NOR2_X1 mult_8_U105 ( .A1(mult_8_n66), .A2(mult_8_n60), .ZN(mult_8_ab_3__3_)
         );
  NOR2_X1 mult_8_U104 ( .A1(mult_8_n9), .A2(mult_8_n60), .ZN(mult_8_ab_3__4_)
         );
  NOR2_X1 mult_8_U103 ( .A1(mult_8_n64), .A2(mult_8_n60), .ZN(mult_8_ab_3__5_)
         );
  NOR2_X1 mult_8_U102 ( .A1(a[2]), .A2(mult_8_n39), .ZN(mult_8_ab_2__7_) );
  NOR2_X1 mult_8_U101 ( .A1(mult_8_n63), .A2(mult_8_n60), .ZN(mult_8_ab_3__6_)
         );
  INV_X1 mult_8_U100 ( .A(a[3]), .ZN(mult_8_n60) );
  NOR3_X1 mult_8_U99 ( .A1(mult_8_n59), .A2(mult_8_n70), .A3(mult_8_n58), .ZN(
        mult_8_CARRYB_1__0_) );
  NOR2_X1 mult_8_U98 ( .A1(mult_8_n70), .A2(mult_8_n57), .ZN(mult_8_ab_2__0_)
         );
  INV_X1 mult_8_U97 ( .A(b[0]), .ZN(mult_8_n70) );
  NOR2_X1 mult_8_U96 ( .A1(mult_8_n68), .A2(mult_8_n57), .ZN(mult_8_ab_2__1_)
         );
  INV_X1 mult_8_U95 ( .A(b[1]), .ZN(mult_8_n68) );
  NOR2_X1 mult_8_U94 ( .A1(mult_8_n67), .A2(mult_8_n57), .ZN(mult_8_ab_2__2_)
         );
  NOR2_X1 mult_8_U93 ( .A1(mult_8_n66), .A2(mult_8_n57), .ZN(mult_8_ab_2__3_)
         );
  NOR2_X1 mult_8_U92 ( .A1(mult_8_n65), .A2(mult_8_n57), .ZN(mult_8_ab_2__4_)
         );
  NOR2_X1 mult_8_U91 ( .A1(mult_8_n64), .A2(mult_8_n57), .ZN(mult_8_ab_2__5_)
         );
  NOR2_X1 mult_8_U90 ( .A1(mult_8_n7), .A2(mult_8_n38), .ZN(mult_8_ab_1__7_)
         );
  INV_X1 mult_8_U89 ( .A(mult_8_n59), .ZN(mult_8_n71) );
  NAND2_X1 mult_8_U88 ( .A1(mult_8_n7), .A2(b[1]), .ZN(mult_8_n59) );
  NOR2_X1 mult_8_U87 ( .A1(mult_8_n67), .A2(mult_8_n58), .ZN(mult_8_ab_0__2_)
         );
  NOR2_X1 mult_8_U86 ( .A1(mult_8_n67), .A2(mult_8_n56), .ZN(mult_8_ab_1__2_)
         );
  INV_X1 mult_8_U85 ( .A(b[2]), .ZN(mult_8_n67) );
  NOR2_X1 mult_8_U84 ( .A1(mult_8_n66), .A2(mult_8_n58), .ZN(mult_8_ab_0__3_)
         );
  NOR2_X1 mult_8_U83 ( .A1(mult_8_n66), .A2(mult_8_n56), .ZN(mult_8_ab_1__3_)
         );
  NOR2_X1 mult_8_U82 ( .A1(mult_8_n65), .A2(mult_8_n58), .ZN(mult_8_ab_0__4_)
         );
  NOR2_X1 mult_8_U81 ( .A1(mult_8_n65), .A2(mult_8_n56), .ZN(mult_8_ab_1__4_)
         );
  INV_X1 mult_8_U80 ( .A(a[0]), .ZN(mult_8_n58) );
  INV_X1 mult_8_U79 ( .A(a[1]), .ZN(mult_8_n56) );
  NOR2_X1 mult_8_U78 ( .A1(mult_8_n73), .A2(a[0]), .ZN(mult_8_ab_0__7_) );
  INV_X2 mult_8_U77 ( .A(a[7]), .ZN(mult_8_n72) );
  INV_X1 mult_8_U76 ( .A(mult_8_n38), .ZN(mult_8_n55) );
  AND2_X1 mult_8_U75 ( .A1(mult_8_CARRYB_7__6_), .A2(mult_8_SUMB_7__7_), .ZN(
        mult_8_n54) );
  XOR2_X1 mult_8_U74 ( .A(mult_8_CARRYB_7__6_), .B(mult_8_SUMB_7__7_), .Z(
        mult_8_n53) );
  AND2_X1 mult_8_U73 ( .A1(mult_8_CARRYB_7__5_), .A2(mult_8_SUMB_7__6_), .ZN(
        mult_8_n52) );
  AND2_X1 mult_8_U72 ( .A1(mult_8_CARRYB_7__4_), .A2(mult_8_SUMB_7__5_), .ZN(
        mult_8_n51) );
  XOR2_X1 mult_8_U71 ( .A(mult_8_CARRYB_7__5_), .B(mult_8_SUMB_7__6_), .Z(
        mult_8_n50) );
  AND2_X1 mult_8_U70 ( .A1(mult_8_CARRYB_7__1_), .A2(mult_8_SUMB_7__2_), .ZN(
        mult_8_n49) );
  AND2_X1 mult_8_U69 ( .A1(mult_8_CARRYB_7__2_), .A2(mult_8_SUMB_7__3_), .ZN(
        mult_8_n48) );
  XOR2_X1 mult_8_U68 ( .A(mult_8_CARRYB_7__4_), .B(mult_8_SUMB_7__5_), .Z(
        mult_8_n47) );
  AND2_X1 mult_8_U67 ( .A1(mult_8_CARRYB_7__3_), .A2(mult_8_SUMB_7__4_), .ZN(
        mult_8_n46) );
  XOR2_X1 mult_8_U66 ( .A(mult_8_SUMB_7__3_), .B(mult_8_CARRYB_7__2_), .Z(
        mult_8_n45) );
  XOR2_X1 mult_8_U65 ( .A(mult_8_SUMB_7__4_), .B(mult_8_CARRYB_7__3_), .Z(
        mult_8_n44) );
  XOR2_X1 mult_8_U64 ( .A(mult_8_CARRYB_7__0_), .B(mult_8_SUMB_7__1_), .Z(
        mult_8_n43) );
  AND2_X1 mult_8_U63 ( .A1(mult_8_ab_0__6_), .A2(mult_8_ab_1__5_), .ZN(
        mult_8_n42) );
  XOR2_X1 mult_8_U62 ( .A(mult_8_CARRYB_7__1_), .B(mult_8_SUMB_7__2_), .Z(
        mult_8_n41) );
  XOR2_X1 mult_8_U61 ( .A(mult_8_n71), .B(mult_8_ab_0__2_), .Z(mult_8_n40) );
  INV_X1 mult_8_U60 ( .A(b[7]), .ZN(mult_8_n73) );
  INV_X1 mult_8_U59 ( .A(mult_8_n27), .ZN(mult_8_n39) );
  INV_X1 mult_8_U58 ( .A(b[6]), .ZN(mult_8_n63) );
  AND2_X1 mult_8_U57 ( .A1(b[6]), .A2(a[1]), .ZN(mult_8_ab_1__6_) );
  NAND3_X1 mult_8_U56 ( .A1(mult_8_n34), .A2(mult_8_n35), .A3(mult_8_n36), 
        .ZN(mult_8_CARRYB_2__5_) );
  NAND2_X1 mult_8_U55 ( .A1(mult_8_n42), .A2(mult_8_ab_2__5_), .ZN(mult_8_n36)
         );
  NAND2_X1 mult_8_U54 ( .A1(mult_8_SUMB_1__6_), .A2(mult_8_ab_2__5_), .ZN(
        mult_8_n35) );
  NAND2_X1 mult_8_U53 ( .A1(mult_8_SUMB_1__6_), .A2(mult_8_n42), .ZN(
        mult_8_n34) );
  XNOR2_X1 mult_8_U52 ( .A(mult_8_n42), .B(mult_8_ab_2__5_), .ZN(mult_8_n33)
         );
  XNOR2_X1 mult_8_U51 ( .A(mult_8_SUMB_1__6_), .B(mult_8_n33), .ZN(
        mult_8_SUMB_2__5_) );
  NAND3_X1 mult_8_U50 ( .A1(mult_8_n30), .A2(mult_8_n31), .A3(mult_8_n32), 
        .ZN(mult_8_CARRYB_2__6_) );
  NAND2_X1 mult_8_U49 ( .A1(mult_8_ab_2__6_), .A2(mult_8_n25), .ZN(mult_8_n32)
         );
  NAND2_X1 mult_8_U48 ( .A1(mult_8_CARRYB_1__6_), .A2(mult_8_n25), .ZN(
        mult_8_n31) );
  NAND2_X1 mult_8_U47 ( .A1(mult_8_CARRYB_1__6_), .A2(mult_8_ab_2__6_), .ZN(
        mult_8_n30) );
  XOR2_X1 mult_8_U46 ( .A(mult_8_CARRYB_1__6_), .B(mult_8_n29), .Z(
        mult_8_SUMB_2__6_) );
  XOR2_X1 mult_8_U45 ( .A(mult_8_ab_2__6_), .B(mult_8_ab_1__7_), .Z(mult_8_n29) );
  AND2_X2 mult_8_U44 ( .A1(b[6]), .A2(a[0]), .ZN(mult_8_ab_0__6_) );
  XOR2_X1 mult_8_U43 ( .A(mult_8_ab_1__4_), .B(mult_8_ab_0__5_), .Z(mult_8_n28) );
  INV_X1 mult_8_U42 ( .A(mult_8_n38), .ZN(mult_8_n27) );
  INV_X1 mult_8_U41 ( .A(a[2]), .ZN(mult_8_n57) );
  AND2_X2 mult_8_U40 ( .A1(b[6]), .A2(a[2]), .ZN(mult_8_ab_2__6_) );
  AND2_X1 mult_8_U39 ( .A1(mult_8_ab_0__5_), .A2(mult_8_ab_1__4_), .ZN(
        mult_8_n26) );
  INV_X2 mult_8_U38 ( .A(b[7]), .ZN(mult_8_n38) );
  NOR2_X1 mult_8_U37 ( .A1(mult_8_n7), .A2(mult_8_n38), .ZN(mult_8_n25) );
  NAND2_X1 mult_8_U36 ( .A1(mult_8_n55), .A2(a[7]), .ZN(mult_8_n24) );
  NAND2_X1 mult_8_U35 ( .A1(mult_8_SUMB_7__0_), .A2(a[7]), .ZN(mult_8_n23) );
  NAND2_X1 mult_8_U34 ( .A1(mult_8_SUMB_7__0_), .A2(mult_8_n55), .ZN(
        mult_8_n22) );
  XOR2_X1 mult_8_U33 ( .A(mult_8_n10), .B(mult_8_n21), .Z(mult_8_A1_5_) );
  XOR2_X1 mult_8_U32 ( .A(mult_8_n55), .B(a[7]), .Z(mult_8_n21) );
  NAND3_X1 mult_8_U31 ( .A1(mult_8_n18), .A2(mult_8_n19), .A3(mult_8_n20), 
        .ZN(mult_8_CARRYB_3__6_) );
  NAND2_X1 mult_8_U30 ( .A1(mult_8_ab_2__7_), .A2(mult_8_ab_3__6_), .ZN(
        mult_8_n20) );
  NAND2_X1 mult_8_U29 ( .A1(mult_8_CARRYB_2__6_), .A2(mult_8_ab_3__6_), .ZN(
        mult_8_n19) );
  NAND2_X1 mult_8_U28 ( .A1(mult_8_CARRYB_2__6_), .A2(mult_8_ab_2__7_), .ZN(
        mult_8_n18) );
  XOR2_X1 mult_8_U27 ( .A(mult_8_CARRYB_2__6_), .B(mult_8_n17), .Z(
        mult_8_SUMB_3__6_) );
  XOR2_X1 mult_8_U26 ( .A(mult_8_ab_2__7_), .B(mult_8_ab_3__6_), .Z(mult_8_n17) );
  XOR2_X1 mult_8_U25 ( .A(mult_8_ab_1__3_), .B(mult_8_ab_0__4_), .Z(mult_8_n16) );
  NAND3_X1 mult_8_U24 ( .A1(mult_8_n22), .A2(mult_8_n23), .A3(mult_8_n24), 
        .ZN(mult_8_A2_6_) );
  NAND3_X1 mult_8_U23 ( .A1(mult_8_n13), .A2(mult_8_n14), .A3(mult_8_n15), 
        .ZN(mult_8_CARRYB_4__4_) );
  NAND2_X1 mult_8_U22 ( .A1(mult_8_n11), .A2(mult_8_ab_4__4_), .ZN(mult_8_n15)
         );
  NAND2_X1 mult_8_U21 ( .A1(mult_8_SUMB_3__5_), .A2(mult_8_ab_4__4_), .ZN(
        mult_8_n14) );
  NAND2_X1 mult_8_U20 ( .A1(mult_8_SUMB_3__5_), .A2(mult_8_n11), .ZN(
        mult_8_n13) );
  XOR2_X1 mult_8_U19 ( .A(mult_8_n12), .B(mult_8_SUMB_3__5_), .Z(
        mult_8_SUMB_4__4_) );
  XOR2_X1 mult_8_U18 ( .A(mult_8_CARRYB_3__4_), .B(mult_8_ab_4__4_), .Z(
        mult_8_n12) );
  AND2_X1 mult_8_U17 ( .A1(b[5]), .A2(a[1]), .ZN(mult_8_ab_1__5_) );
  CLKBUF_X1 mult_8_U16 ( .A(mult_8_CARRYB_3__4_), .Z(mult_8_n11) );
  CLKBUF_X1 mult_8_U15 ( .A(mult_8_SUMB_7__0_), .Z(mult_8_n10) );
  INV_X1 mult_8_U14 ( .A(b[4]), .ZN(mult_8_n65) );
  INV_X1 mult_8_U13 ( .A(b[4]), .ZN(mult_8_n9) );
  INV_X1 mult_8_U12 ( .A(b[5]), .ZN(mult_8_n64) );
  AND2_X1 mult_8_U11 ( .A1(b[5]), .A2(a[0]), .ZN(mult_8_ab_0__5_) );
  BUF_X2 mult_8_U10 ( .A(a[1]), .Z(mult_8_n7) );
  INV_X2 mult_8_U9 ( .A(b[3]), .ZN(mult_8_n66) );
  AND2_X2 mult_8_U8 ( .A1(mult_8_n8), .A2(mult_8_CARRYB_7__0_), .ZN(mult_8_n37) );
  CLKBUF_X1 mult_8_U7 ( .A(mult_8_SUMB_7__1_), .Z(mult_8_n8) );
  AND2_X1 mult_8_U6 ( .A1(mult_8_ab_0__2_), .A2(mult_8_n71), .ZN(mult_8_n6) );
  AND2_X1 mult_8_U5 ( .A1(mult_8_ab_0__3_), .A2(mult_8_ab_1__2_), .ZN(
        mult_8_n5) );
  XOR2_X1 mult_8_U4 ( .A(mult_8_ab_1__5_), .B(mult_8_ab_0__6_), .Z(mult_8_n4)
         );
  AND2_X1 mult_8_U3 ( .A1(mult_8_ab_0__4_), .A2(mult_8_ab_1__3_), .ZN(
        mult_8_n3) );
  XOR2_X1 mult_8_U2 ( .A(mult_8_ab_1__2_), .B(mult_8_ab_0__3_), .Z(mult_8_n2)
         );
  FA_X1 mult_8_S0_6 ( .A(mult_8_ab_1__6_), .B(1'b0), .CI(mult_8_ab_0__7_), 
        .CO(mult_8_CARRYB_1__6_), .S(mult_8_SUMB_1__6_) );
  FA_X1 mult_8_S2_2_4 ( .A(mult_8_ab_2__4_), .B(mult_8_n26), .CI(mult_8_n4), 
        .CO(mult_8_CARRYB_2__4_), .S(mult_8_SUMB_2__4_) );
  FA_X1 mult_8_S2_2_3 ( .A(mult_8_ab_2__3_), .B(mult_8_n3), .CI(mult_8_n28), 
        .CO(mult_8_CARRYB_2__3_), .S(mult_8_SUMB_2__3_) );
  FA_X1 mult_8_S2_2_2 ( .A(mult_8_ab_2__2_), .B(mult_8_n5), .CI(mult_8_n16), 
        .CO(mult_8_CARRYB_2__2_), .S(mult_8_SUMB_2__2_) );
  FA_X1 mult_8_S2_2_1 ( .A(mult_8_ab_2__1_), .B(mult_8_n6), .CI(mult_8_n2), 
        .CO(mult_8_CARRYB_2__1_), .S(mult_8_SUMB_2__1_) );
  FA_X1 mult_8_S1_2_0 ( .A(mult_8_ab_2__0_), .B(mult_8_CARRYB_1__0_), .CI(
        mult_8_n40), .CO(mult_8_CARRYB_2__0_), .S(mult_8_A1_0_) );
  FA_X1 mult_8_S2_3_5 ( .A(mult_8_ab_3__5_), .B(mult_8_SUMB_2__6_), .CI(
        mult_8_CARRYB_2__5_), .CO(mult_8_CARRYB_3__5_), .S(mult_8_SUMB_3__5_)
         );
  FA_X1 mult_8_S2_3_4 ( .A(mult_8_CARRYB_2__4_), .B(mult_8_ab_3__4_), .CI(
        mult_8_SUMB_2__5_), .CO(mult_8_CARRYB_3__4_), .S(mult_8_SUMB_3__4_) );
  FA_X1 mult_8_S2_3_3 ( .A(mult_8_ab_3__3_), .B(mult_8_CARRYB_2__3_), .CI(
        mult_8_SUMB_2__4_), .CO(mult_8_CARRYB_3__3_), .S(mult_8_SUMB_3__3_) );
  FA_X1 mult_8_S2_3_2 ( .A(mult_8_ab_3__2_), .B(mult_8_CARRYB_2__2_), .CI(
        mult_8_SUMB_2__3_), .CO(mult_8_CARRYB_3__2_), .S(mult_8_SUMB_3__2_) );
  FA_X1 mult_8_S2_3_1 ( .A(mult_8_ab_3__1_), .B(mult_8_CARRYB_2__1_), .CI(
        mult_8_SUMB_2__2_), .CO(mult_8_CARRYB_3__1_), .S(mult_8_SUMB_3__1_) );
  FA_X1 mult_8_S1_3_0 ( .A(mult_8_ab_3__0_), .B(mult_8_CARRYB_2__0_), .CI(
        mult_8_SUMB_2__1_), .CO(mult_8_CARRYB_3__0_), .S(mult_8_A1_1_) );
  FA_X1 mult_8_S3_4_6 ( .A(mult_8_ab_4__6_), .B(mult_8_CARRYB_3__6_), .CI(
        mult_8_ab_3__7_), .CO(mult_8_CARRYB_4__6_), .S(mult_8_SUMB_4__6_) );
  FA_X1 mult_8_S2_4_5 ( .A(mult_8_ab_4__5_), .B(mult_8_CARRYB_3__5_), .CI(
        mult_8_SUMB_3__6_), .CO(mult_8_CARRYB_4__5_), .S(mult_8_SUMB_4__5_) );
  FA_X1 mult_8_S2_4_3 ( .A(mult_8_CARRYB_3__3_), .B(mult_8_ab_4__3_), .CI(
        mult_8_SUMB_3__4_), .CO(mult_8_CARRYB_4__3_), .S(mult_8_SUMB_4__3_) );
  FA_X1 mult_8_S2_4_2 ( .A(mult_8_CARRYB_3__2_), .B(mult_8_ab_4__2_), .CI(
        mult_8_SUMB_3__3_), .CO(mult_8_CARRYB_4__2_), .S(mult_8_SUMB_4__2_) );
  FA_X1 mult_8_S2_4_1 ( .A(mult_8_ab_4__1_), .B(mult_8_CARRYB_3__1_), .CI(
        mult_8_SUMB_3__2_), .CO(mult_8_CARRYB_4__1_), .S(mult_8_SUMB_4__1_) );
  FA_X1 mult_8_S1_4_0 ( .A(mult_8_ab_4__0_), .B(mult_8_CARRYB_3__0_), .CI(
        mult_8_SUMB_3__1_), .CO(mult_8_CARRYB_4__0_), .S(mult_8_A1_2_) );
  FA_X1 mult_8_S3_5_6 ( .A(mult_8_ab_5__6_), .B(mult_8_CARRYB_4__6_), .CI(
        mult_8_ab_4__7_), .CO(mult_8_CARRYB_5__6_), .S(mult_8_SUMB_5__6_) );
  FA_X1 mult_8_S2_5_5 ( .A(mult_8_ab_5__5_), .B(mult_8_CARRYB_4__5_), .CI(
        mult_8_SUMB_4__6_), .CO(mult_8_CARRYB_5__5_), .S(mult_8_SUMB_5__5_) );
  FA_X1 mult_8_S2_5_4 ( .A(mult_8_ab_5__4_), .B(mult_8_CARRYB_4__4_), .CI(
        mult_8_SUMB_4__5_), .CO(mult_8_CARRYB_5__4_), .S(mult_8_SUMB_5__4_) );
  FA_X1 mult_8_S2_5_3 ( .A(mult_8_ab_5__3_), .B(mult_8_CARRYB_4__3_), .CI(
        mult_8_SUMB_4__4_), .CO(mult_8_CARRYB_5__3_), .S(mult_8_SUMB_5__3_) );
  FA_X1 mult_8_S2_5_2 ( .A(mult_8_CARRYB_4__2_), .B(mult_8_ab_5__2_), .CI(
        mult_8_SUMB_4__3_), .CO(mult_8_CARRYB_5__2_), .S(mult_8_SUMB_5__2_) );
  FA_X1 mult_8_S2_5_1 ( .A(mult_8_ab_5__1_), .B(mult_8_CARRYB_4__1_), .CI(
        mult_8_SUMB_4__2_), .CO(mult_8_CARRYB_5__1_), .S(mult_8_SUMB_5__1_) );
  FA_X1 mult_8_S1_5_0 ( .A(mult_8_ab_5__0_), .B(mult_8_CARRYB_4__0_), .CI(
        mult_8_SUMB_4__1_), .CO(mult_8_CARRYB_5__0_), .S(mult_8_A1_3_) );
  FA_X1 mult_8_S3_6_6 ( .A(mult_8_ab_6__6_), .B(mult_8_CARRYB_5__6_), .CI(
        mult_8_ab_5__7_), .CO(mult_8_CARRYB_6__6_), .S(mult_8_SUMB_6__6_) );
  FA_X1 mult_8_S2_6_5 ( .A(mult_8_ab_6__5_), .B(mult_8_CARRYB_5__5_), .CI(
        mult_8_SUMB_5__6_), .CO(mult_8_CARRYB_6__5_), .S(mult_8_SUMB_6__5_) );
  FA_X1 mult_8_S2_6_4 ( .A(mult_8_ab_6__4_), .B(mult_8_CARRYB_5__4_), .CI(
        mult_8_SUMB_5__5_), .CO(mult_8_CARRYB_6__4_), .S(mult_8_SUMB_6__4_) );
  FA_X1 mult_8_S2_6_3 ( .A(mult_8_ab_6__3_), .B(mult_8_CARRYB_5__3_), .CI(
        mult_8_SUMB_5__4_), .CO(mult_8_CARRYB_6__3_), .S(mult_8_SUMB_6__3_) );
  FA_X1 mult_8_S2_6_2 ( .A(mult_8_ab_6__2_), .B(mult_8_CARRYB_5__2_), .CI(
        mult_8_SUMB_5__3_), .CO(mult_8_CARRYB_6__2_), .S(mult_8_SUMB_6__2_) );
  FA_X1 mult_8_S2_6_1 ( .A(mult_8_CARRYB_5__1_), .B(mult_8_ab_6__1_), .CI(
        mult_8_SUMB_5__2_), .CO(mult_8_CARRYB_6__1_), .S(mult_8_SUMB_6__1_) );
  FA_X1 mult_8_S1_6_0 ( .A(mult_8_CARRYB_5__0_), .B(mult_8_ab_6__0_), .CI(
        mult_8_SUMB_5__1_), .CO(mult_8_CARRYB_6__0_), .S(mult_8_A1_4_) );
  FA_X1 mult_8_S14_7 ( .A(mult_8_n72), .B(mult_8_n39), .CI(mult_8_ab_7__7_), 
        .CO(mult_8_CARRYB_7__7_), .S(mult_8_SUMB_7__7_) );
  FA_X1 mult_8_S5_6 ( .A(mult_8_ab_7__6_), .B(mult_8_CARRYB_6__6_), .CI(
        mult_8_ab_6__7_), .CO(mult_8_CARRYB_7__6_), .S(mult_8_SUMB_7__6_) );
  FA_X1 mult_8_S4_5 ( .A(mult_8_ab_7__5_), .B(mult_8_SUMB_6__6_), .CI(
        mult_8_CARRYB_6__5_), .CO(mult_8_CARRYB_7__5_), .S(mult_8_SUMB_7__5_)
         );
  FA_X1 mult_8_S4_4 ( .A(mult_8_ab_7__4_), .B(mult_8_CARRYB_6__4_), .CI(
        mult_8_SUMB_6__5_), .CO(mult_8_CARRYB_7__4_), .S(mult_8_SUMB_7__4_) );
  FA_X1 mult_8_S4_3 ( .A(mult_8_CARRYB_6__3_), .B(mult_8_ab_7__3_), .CI(
        mult_8_SUMB_6__4_), .CO(mult_8_CARRYB_7__3_), .S(mult_8_SUMB_7__3_) );
  FA_X1 mult_8_S4_2 ( .A(mult_8_ab_7__2_), .B(mult_8_CARRYB_6__2_), .CI(
        mult_8_SUMB_6__3_), .CO(mult_8_CARRYB_7__2_), .S(mult_8_SUMB_7__2_) );
  FA_X1 mult_8_S4_1 ( .A(mult_8_ab_7__1_), .B(mult_8_CARRYB_6__1_), .CI(
        mult_8_SUMB_6__2_), .CO(mult_8_CARRYB_7__1_), .S(mult_8_SUMB_7__1_) );
  FA_X1 mult_8_S4_0 ( .A(mult_8_CARRYB_6__0_), .B(mult_8_ab_7__0_), .CI(
        mult_8_SUMB_6__1_), .CO(mult_8_CARRYB_7__0_), .S(mult_8_SUMB_7__0_) );
  INV_X1 mult_8_FS_1_U87 ( .A(mult_8_FS_1_n41), .ZN(mult_8_FS_1_n30) );
  NAND3_X1 mult_8_FS_1_U86 ( .A1(mult_8_FS_1_n4), .A2(mult_8_n49), .A3(
        mult_8_FS_1_n5), .ZN(mult_8_FS_1_n78) );
  INV_X1 mult_8_FS_1_U85 ( .A(mult_8_FS_1_n57), .ZN(mult_8_FS_1_n75) );
  INV_X1 mult_8_FS_1_U84 ( .A(mult_8_FS_1_n73), .ZN(mult_8_FS_1_n69) );
  INV_X1 mult_8_FS_1_U83 ( .A(mult_8_FS_1_n59), .ZN(mult_8_FS_1_n56) );
  NAND3_X1 mult_8_FS_1_U82 ( .A1(mult_8_FS_1_n69), .A2(mult_8_FS_1_n59), .A3(
        mult_8_FS_1_n30), .ZN(mult_8_FS_1_n66) );
  NAND2_X1 mult_8_FS_1_U81 ( .A1(mult_8_FS_1_n66), .A2(mult_8_FS_1_n67), .ZN(
        mult_8_FS_1_n65) );
  INV_X1 mult_8_FS_1_U80 ( .A(mult_8_FS_1_n45), .ZN(mult_8_FS_1_n50) );
  INV_X1 mult_8_FS_1_U79 ( .A(mult_8_FS_1_n60), .ZN(mult_8_FS_1_n55) );
  INV_X1 mult_8_FS_1_U78 ( .A(mult_8_FS_1_n58), .ZN(mult_8_FS_1_n20) );
  NOR2_X1 mult_8_FS_1_U77 ( .A1(mult_8_FS_1_n55), .A2(mult_8_FS_1_n56), .ZN(
        mult_8_FS_1_n54) );
  INV_X1 mult_8_FS_1_U76 ( .A(mult_8_FS_1_n9), .ZN(mult_8_FS_1_n42) );
  INV_X1 mult_8_FS_1_U75 ( .A(mult_8_FS_1_n40), .ZN(mult_8_FS_1_n39) );
  INV_X1 mult_8_FS_1_U74 ( .A(mult_8_FS_1_n21), .ZN(mult_8_FS_1_n19) );
  INV_X1 mult_8_FS_1_U73 ( .A(mult_8_n43), .ZN(mult_8_FS_1_n72) );
  OAI211_X1 mult_8_FS_1_U72 ( .C1(mult_8_n41), .C2(mult_8_n37), .A(
        mult_8_A2_6_), .B(mult_8_n43), .ZN(mult_8_FS_1_n41) );
  NAND2_X1 mult_8_FS_1_U71 ( .A1(mult_8_FS_1_n10), .A2(mult_8_FS_1_n13), .ZN(
        mult_8_FS_1_n32) );
  XNOR2_X1 mult_8_FS_1_U70 ( .A(mult_8_FS_1_n46), .B(mult_8_FS_1_n47), .ZN(N14) );
  OAI21_X1 mult_8_FS_1_U69 ( .B1(mult_8_FS_1_n48), .B2(mult_8_FS_1_n40), .A(
        mult_8_FS_1_n49), .ZN(mult_8_FS_1_n46) );
  NAND2_X1 mult_8_FS_1_U68 ( .A1(mult_8_FS_1_n5), .A2(mult_8_FS_1_n24), .ZN(
        mult_8_FS_1_n73) );
  NAND2_X1 mult_8_FS_1_U67 ( .A1(mult_8_FS_1_n11), .A2(mult_8_FS_1_n24), .ZN(
        mult_8_FS_1_n23) );
  NAND4_X1 mult_8_FS_1_U66 ( .A1(mult_8_FS_1_n59), .A2(mult_8_FS_1_n60), .A3(
        mult_8_FS_1_n5), .A4(mult_8_FS_1_n24), .ZN(mult_8_FS_1_n40) );
  NAND2_X1 mult_8_FS_1_U65 ( .A1(mult_8_FS_1_n68), .A2(mult_8_FS_1_n69), .ZN(
        mult_8_FS_1_n67) );
  NAND2_X1 mult_8_FS_1_U64 ( .A1(mult_8_FS_1_n24), .A2(mult_8_FS_1_n6), .ZN(
        mult_8_FS_1_n29) );
  NAND2_X1 mult_8_FS_1_U63 ( .A1(mult_8_FS_1_n71), .A2(mult_8_FS_1_n72), .ZN(
        mult_8_FS_1_n28) );
  NOR2_X1 mult_8_FS_1_U62 ( .A1(mult_8_FS_1_n27), .A2(mult_8_FS_1_n20), .ZN(
        mult_8_FS_1_n52) );
  NOR2_X1 mult_8_FS_1_U61 ( .A1(mult_8_FS_1_n19), .A2(mult_8_FS_1_n20), .ZN(
        mult_8_FS_1_n18) );
  XNOR2_X2 mult_8_FS_1_U60 ( .A(mult_8_FS_1_n14), .B(mult_8_FS_1_n29), .ZN(N10) );
  AND2_X1 mult_8_FS_1_U59 ( .A1(mult_8_n43), .A2(mult_8_A2_6_), .ZN(
        mult_8_FS_1_n26) );
  XNOR2_X1 mult_8_FS_1_U58 ( .A(mult_8_FS_1_n17), .B(mult_8_FS_1_n18), .ZN(N11) );
  OAI21_X1 mult_8_FS_1_U57 ( .B1(mult_8_FS_1_n52), .B2(mult_8_FS_1_n53), .A(
        mult_8_FS_1_n54), .ZN(mult_8_FS_1_n51) );
  INV_X1 mult_8_FS_1_U56 ( .A(mult_8_A2_6_), .ZN(mult_8_FS_1_n71) );
  NAND2_X1 mult_8_FS_1_U55 ( .A1(mult_8_n52), .A2(mult_8_n53), .ZN(
        mult_8_FS_1_n44) );
  OR2_X1 mult_8_FS_1_U54 ( .A1(mult_8_n52), .A2(mult_8_n53), .ZN(
        mult_8_FS_1_n38) );
  NAND2_X1 mult_8_FS_1_U53 ( .A1(mult_8_n51), .A2(mult_8_n50), .ZN(
        mult_8_FS_1_n45) );
  NAND2_X1 mult_8_FS_1_U52 ( .A1(mult_8_n46), .A2(mult_8_n47), .ZN(
        mult_8_FS_1_n57) );
  NAND2_X1 mult_8_FS_1_U51 ( .A1(mult_8_n49), .A2(mult_8_n45), .ZN(
        mult_8_FS_1_n27) );
  OR2_X1 mult_8_FS_1_U50 ( .A1(mult_8_n51), .A2(mult_8_n50), .ZN(
        mult_8_FS_1_n60) );
  NAND2_X1 mult_8_FS_1_U49 ( .A1(mult_8_n48), .A2(mult_8_n44), .ZN(
        mult_8_FS_1_n21) );
  NAND2_X1 mult_8_FS_1_U48 ( .A1(mult_8_FS_1_n41), .A2(mult_8_FS_1_n31), .ZN(
        mult_8_FS_1_n61) );
  AND2_X1 mult_8_FS_1_U47 ( .A1(mult_8_FS_1_n25), .A2(mult_8_FS_1_n31), .ZN(
        mult_8_FS_1_n15) );
  OR2_X1 mult_8_FS_1_U46 ( .A1(mult_8_n41), .A2(mult_8_n37), .ZN(
        mult_8_FS_1_n25) );
  NAND2_X1 mult_8_FS_1_U45 ( .A1(mult_8_FS_1_n21), .A2(mult_8_FS_1_n78), .ZN(
        mult_8_FS_1_n74) );
  NAND2_X1 mult_8_FS_1_U44 ( .A1(mult_8_n41), .A2(mult_8_n37), .ZN(
        mult_8_FS_1_n31) );
  XNOR2_X1 mult_8_FS_1_U43 ( .A(mult_8_n54), .B(mult_8_A1_13_), .ZN(
        mult_8_FS_1_n33) );
  XNOR2_X1 mult_8_FS_1_U42 ( .A(mult_8_FS_1_n33), .B(mult_8_FS_1_n34), .ZN(N15) );
  NAND2_X1 mult_8_FS_1_U41 ( .A1(mult_8_FS_1_n44), .A2(mult_8_FS_1_n45), .ZN(
        mult_8_FS_1_n43) );
  INV_X1 mult_8_FS_1_U40 ( .A(mult_8_FS_1_n27), .ZN(mult_8_FS_1_n22) );
  NOR2_X1 mult_8_FS_1_U39 ( .A1(mult_8_FS_1_n42), .A2(mult_8_FS_1_n43), .ZN(
        mult_8_FS_1_n35) );
  NAND2_X1 mult_8_FS_1_U38 ( .A1(mult_8_FS_1_n3), .A2(mult_8_FS_1_n39), .ZN(
        mult_8_FS_1_n36) );
  INV_X1 mult_8_FS_1_U37 ( .A(mult_8_FS_1_n38), .ZN(mult_8_FS_1_n37) );
  AOI21_X1 mult_8_FS_1_U36 ( .B1(mult_8_FS_1_n35), .B2(mult_8_FS_1_n36), .A(
        mult_8_FS_1_n37), .ZN(mult_8_FS_1_n34) );
  NOR2_X1 mult_8_FS_1_U35 ( .A1(mult_8_FS_1_n56), .A2(mult_8_FS_1_n31), .ZN(
        mult_8_FS_1_n68) );
  AOI21_X1 mult_8_FS_1_U34 ( .B1(mult_8_FS_1_n74), .B2(mult_8_FS_1_n59), .A(
        mult_8_FS_1_n75), .ZN(mult_8_FS_1_n70) );
  INV_X1 mult_8_FS_1_U33 ( .A(mult_8_FS_1_n70), .ZN(mult_8_FS_1_n64) );
  NAND2_X1 mult_8_FS_1_U32 ( .A1(mult_8_FS_1_n21), .A2(mult_8_FS_1_n57), .ZN(
        mult_8_FS_1_n53) );
  INV_X1 mult_8_FS_1_U31 ( .A(mult_8_FS_1_n61), .ZN(mult_8_FS_1_n48) );
  NAND2_X1 mult_8_FS_1_U30 ( .A1(mult_8_FS_1_n38), .A2(mult_8_FS_1_n44), .ZN(
        mult_8_FS_1_n47) );
  NOR2_X1 mult_8_FS_1_U29 ( .A1(mult_8_FS_1_n77), .A2(mult_8_FS_1_n74), .ZN(
        mult_8_FS_1_n76) );
  XNOR2_X1 mult_8_FS_1_U28 ( .A(mult_8_FS_1_n76), .B(mult_8_FS_1_n1), .ZN(N12)
         );
  NOR2_X1 mult_8_FS_1_U27 ( .A1(mult_8_FS_1_n65), .A2(mult_8_FS_1_n64), .ZN(
        mult_8_FS_1_n62) );
  NOR2_X1 mult_8_FS_1_U26 ( .A1(mult_8_FS_1_n50), .A2(mult_8_FS_1_n55), .ZN(
        mult_8_FS_1_n63) );
  XNOR2_X1 mult_8_FS_1_U25 ( .A(mult_8_FS_1_n62), .B(mult_8_FS_1_n63), .ZN(N13) );
  NOR2_X1 mult_8_FS_1_U24 ( .A1(mult_8_FS_1_n79), .A2(mult_8_FS_1_n73), .ZN(
        mult_8_FS_1_n77) );
  OR2_X2 mult_8_FS_1_U23 ( .A1(mult_8_n47), .A2(mult_8_n46), .ZN(
        mult_8_FS_1_n59) );
  OR2_X1 mult_8_FS_1_U22 ( .A1(mult_8_FS_1_n30), .A2(mult_8_FS_1_n11), .ZN(
        mult_8_FS_1_n14) );
  INV_X1 mult_8_FS_1_U21 ( .A(mult_8_FS_1_n72), .ZN(mult_8_FS_1_n13) );
  AND2_X1 mult_8_FS_1_U20 ( .A1(mult_8_FS_1_n41), .A2(mult_8_FS_1_n31), .ZN(
        mult_8_FS_1_n79) );
  AND2_X1 mult_8_FS_1_U19 ( .A1(mult_8_FS_1_n51), .A2(mult_8_FS_1_n45), .ZN(
        mult_8_FS_1_n49) );
  NAND2_X1 mult_8_FS_1_U18 ( .A1(mult_8_FS_1_n10), .A2(mult_8_FS_1_n13), .ZN(
        mult_8_FS_1_n12) );
  XNOR2_X1 mult_8_FS_1_U17 ( .A(mult_8_FS_1_n12), .B(mult_8_FS_1_n15), .ZN(N9)
         );
  AND2_X1 mult_8_FS_1_U16 ( .A1(mult_8_n41), .A2(mult_8_n37), .ZN(
        mult_8_FS_1_n11) );
  CLKBUF_X1 mult_8_FS_1_U15 ( .A(mult_8_FS_1_n51), .Z(mult_8_FS_1_n9) );
  NAND2_X1 mult_8_FS_1_U14 ( .A1(mult_8_FS_1_n23), .A2(mult_8_FS_1_n6), .ZN(
        mult_8_FS_1_n8) );
  AND3_X1 mult_8_FS_1_U13 ( .A1(mult_8_FS_1_n24), .A2(mult_8_FS_1_n25), .A3(
        mult_8_FS_1_n26), .ZN(mult_8_FS_1_n7) );
  NOR2_X1 mult_8_FS_1_U12 ( .A1(mult_8_FS_1_n7), .A2(mult_8_FS_1_n8), .ZN(
        mult_8_FS_1_n17) );
  INV_X1 mult_8_FS_1_U11 ( .A(mult_8_FS_1_n22), .ZN(mult_8_FS_1_n6) );
  OR2_X2 mult_8_FS_1_U10 ( .A1(mult_8_n49), .A2(mult_8_n45), .ZN(
        mult_8_FS_1_n24) );
  OR2_X1 mult_8_FS_1_U9 ( .A1(mult_8_n44), .A2(mult_8_n48), .ZN(
        mult_8_FS_1_n58) );
  OR2_X1 mult_8_FS_1_U8 ( .A1(mult_8_n44), .A2(mult_8_n48), .ZN(mult_8_FS_1_n5) );
  CLKBUF_X1 mult_8_FS_1_U7 ( .A(mult_8_n45), .Z(mult_8_FS_1_n4) );
  CLKBUF_X1 mult_8_FS_1_U6 ( .A(mult_8_FS_1_n61), .Z(mult_8_FS_1_n3) );
  AND2_X2 mult_8_FS_1_U5 ( .A1(mult_8_FS_1_n32), .A2(mult_8_FS_1_n28), .ZN(N8)
         );
  CLKBUF_X1 mult_8_FS_1_U4 ( .A(mult_8_A2_6_), .Z(mult_8_FS_1_n10) );
  AND2_X1 mult_8_FS_1_U3 ( .A1(mult_8_FS_1_n59), .A2(mult_8_FS_1_n57), .ZN(
        mult_8_FS_1_n1) );
  BUF_X1 mult_8_FS_1_U2 ( .A(mult_8_A1_5_), .Z(N7) );
endmodule

