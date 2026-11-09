/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:06:39 2025
/////////////////////////////////////////////////////////////


module mul_ds ( clk, a, b, z );
  input [7:0] a;
  input [7:0] b;
  output [7:0] z;
  input clk;
  wire   N9, N8, N7, N15, N14, N13, N12, N11, N10, n1, n2, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n22, mult_7_n56, mult_7_n55, mult_7_n54, mult_7_n53, mult_7_n52,
         mult_7_n51, mult_7_n50, mult_7_n49, mult_7_n48, mult_7_n47,
         mult_7_n46, mult_7_n45, mult_7_n44, mult_7_n43, mult_7_n42,
         mult_7_n41, mult_7_n40, mult_7_n39, mult_7_n38, mult_7_n37,
         mult_7_n36, mult_7_n35, mult_7_n34, mult_7_n33, mult_7_n32,
         mult_7_n31, mult_7_n30, mult_7_n29, mult_7_n28, mult_7_n27,
         mult_7_n26, mult_7_n25, mult_7_n24, mult_7_n23, mult_7_n22,
         mult_7_n21, mult_7_n20, mult_7_n19, mult_7_n18, mult_7_n17,
         mult_7_n16, mult_7_n15, mult_7_n14, mult_7_n13, mult_7_n12,
         mult_7_n11, mult_7_n10, mult_7_n9, mult_7_n8, mult_7_n7, mult_7_n6,
         mult_7_n5, mult_7_n4, mult_7_n3, mult_7_n2, mult_7_A2_6_,
         mult_7_A2_8_, mult_7_A1_0_, mult_7_A1_1_, mult_7_A1_2_, mult_7_A1_3_,
         mult_7_A1_4_, mult_7_A1_5_, mult_7_A1_7_, mult_7_A1_13_,
         mult_7_SUMB_1__6_, mult_7_SUMB_2__1_, mult_7_SUMB_2__2_,
         mult_7_SUMB_2__3_, mult_7_SUMB_2__4_, mult_7_SUMB_2__5_,
         mult_7_SUMB_2__6_, mult_7_SUMB_3__1_, mult_7_SUMB_3__2_,
         mult_7_SUMB_3__3_, mult_7_SUMB_3__4_, mult_7_SUMB_3__5_,
         mult_7_SUMB_3__6_, mult_7_SUMB_4__1_, mult_7_SUMB_4__2_,
         mult_7_SUMB_4__3_, mult_7_SUMB_4__4_, mult_7_SUMB_4__5_,
         mult_7_SUMB_4__6_, mult_7_SUMB_5__1_, mult_7_SUMB_5__2_,
         mult_7_SUMB_5__3_, mult_7_SUMB_5__4_, mult_7_SUMB_5__5_,
         mult_7_SUMB_5__6_, mult_7_SUMB_6__1_, mult_7_SUMB_6__2_,
         mult_7_SUMB_6__3_, mult_7_SUMB_6__4_, mult_7_SUMB_6__5_,
         mult_7_SUMB_6__6_, mult_7_SUMB_7__0_, mult_7_SUMB_7__1_,
         mult_7_SUMB_7__2_, mult_7_SUMB_7__3_, mult_7_SUMB_7__4_,
         mult_7_SUMB_7__5_, mult_7_SUMB_7__6_, mult_7_SUMB_7__7_,
         mult_7_CARRYB_1__0_, mult_7_CARRYB_1__6_, mult_7_CARRYB_2__0_,
         mult_7_CARRYB_2__1_, mult_7_CARRYB_2__2_, mult_7_CARRYB_2__3_,
         mult_7_CARRYB_2__4_, mult_7_CARRYB_2__5_, mult_7_CARRYB_2__6_,
         mult_7_CARRYB_3__0_, mult_7_CARRYB_3__1_, mult_7_CARRYB_3__2_,
         mult_7_CARRYB_3__3_, mult_7_CARRYB_3__4_, mult_7_CARRYB_3__5_,
         mult_7_CARRYB_3__6_, mult_7_CARRYB_4__0_, mult_7_CARRYB_4__1_,
         mult_7_CARRYB_4__2_, mult_7_CARRYB_4__3_, mult_7_CARRYB_4__4_,
         mult_7_CARRYB_4__5_, mult_7_CARRYB_4__6_, mult_7_CARRYB_5__0_,
         mult_7_CARRYB_5__1_, mult_7_CARRYB_5__2_, mult_7_CARRYB_5__3_,
         mult_7_CARRYB_5__4_, mult_7_CARRYB_5__5_, mult_7_CARRYB_5__6_,
         mult_7_CARRYB_6__0_, mult_7_CARRYB_6__1_, mult_7_CARRYB_6__2_,
         mult_7_CARRYB_6__3_, mult_7_CARRYB_6__4_, mult_7_CARRYB_6__5_,
         mult_7_CARRYB_6__6_, mult_7_CARRYB_7__0_, mult_7_CARRYB_7__1_,
         mult_7_CARRYB_7__2_, mult_7_CARRYB_7__3_, mult_7_CARRYB_7__4_,
         mult_7_CARRYB_7__5_, mult_7_CARRYB_7__6_, mult_7_CARRYB_7__7_,
         mult_7_ab_0__2_, mult_7_ab_0__3_, mult_7_ab_0__4_, mult_7_ab_0__5_,
         mult_7_ab_0__6_, mult_7_ab_0__7_, mult_7_ab_1__2_, mult_7_ab_1__3_,
         mult_7_ab_1__4_, mult_7_ab_1__5_, mult_7_ab_1__6_, mult_7_ab_1__7_,
         mult_7_ab_2__0_, mult_7_ab_2__1_, mult_7_ab_2__2_, mult_7_ab_2__3_,
         mult_7_ab_2__4_, mult_7_ab_2__5_, mult_7_ab_2__6_, mult_7_ab_2__7_,
         mult_7_ab_3__0_, mult_7_ab_3__1_, mult_7_ab_3__2_, mult_7_ab_3__3_,
         mult_7_ab_3__4_, mult_7_ab_3__5_, mult_7_ab_3__6_, mult_7_ab_3__7_,
         mult_7_ab_4__0_, mult_7_ab_4__1_, mult_7_ab_4__2_, mult_7_ab_4__3_,
         mult_7_ab_4__4_, mult_7_ab_4__5_, mult_7_ab_4__6_, mult_7_ab_4__7_,
         mult_7_ab_5__0_, mult_7_ab_5__1_, mult_7_ab_5__2_, mult_7_ab_5__3_,
         mult_7_ab_5__4_, mult_7_ab_5__5_, mult_7_ab_5__6_, mult_7_ab_5__7_,
         mult_7_ab_6__0_, mult_7_ab_6__1_, mult_7_ab_6__2_, mult_7_ab_6__3_,
         mult_7_ab_6__4_, mult_7_ab_6__5_, mult_7_ab_6__6_, mult_7_ab_6__7_,
         mult_7_ab_7__0_, mult_7_ab_7__1_, mult_7_ab_7__2_, mult_7_ab_7__3_,
         mult_7_ab_7__4_, mult_7_ab_7__5_, mult_7_ab_7__6_, mult_7_ab_7__7_,
         mult_7_FS_1_n74, mult_7_FS_1_n73, mult_7_FS_1_n72, mult_7_FS_1_n71,
         mult_7_FS_1_n70, mult_7_FS_1_n69, mult_7_FS_1_n68, mult_7_FS_1_n67,
         mult_7_FS_1_n66, mult_7_FS_1_n65, mult_7_FS_1_n64, mult_7_FS_1_n63,
         mult_7_FS_1_n62, mult_7_FS_1_n61, mult_7_FS_1_n60, mult_7_FS_1_n59,
         mult_7_FS_1_n58, mult_7_FS_1_n57, mult_7_FS_1_n56, mult_7_FS_1_n55,
         mult_7_FS_1_n54, mult_7_FS_1_n53, mult_7_FS_1_n52, mult_7_FS_1_n51,
         mult_7_FS_1_n50, mult_7_FS_1_n49, mult_7_FS_1_n48, mult_7_FS_1_n47,
         mult_7_FS_1_n46, mult_7_FS_1_n45, mult_7_FS_1_n44, mult_7_FS_1_n43,
         mult_7_FS_1_n42, mult_7_FS_1_n41, mult_7_FS_1_n40, mult_7_FS_1_n39,
         mult_7_FS_1_n38, mult_7_FS_1_n37, mult_7_FS_1_n36, mult_7_FS_1_n35,
         mult_7_FS_1_n34, mult_7_FS_1_n33, mult_7_FS_1_n32, mult_7_FS_1_n31,
         mult_7_FS_1_n30, mult_7_FS_1_n29, mult_7_FS_1_n28, mult_7_FS_1_n27,
         mult_7_FS_1_n26, mult_7_FS_1_n25, mult_7_FS_1_n24, mult_7_FS_1_n23,
         mult_7_FS_1_n22, mult_7_FS_1_n21, mult_7_FS_1_n20, mult_7_FS_1_n19,
         mult_7_FS_1_n18, mult_7_FS_1_n17, mult_7_FS_1_n16, mult_7_FS_1_n15,
         mult_7_FS_1_n13, mult_7_FS_1_n12, mult_7_FS_1_n11, mult_7_FS_1_n10,
         mult_7_FS_1_n9, mult_7_FS_1_n8, mult_7_FS_1_n7, mult_7_FS_1_n6,
         mult_7_FS_1_n5, mult_7_FS_1_n4, mult_7_FS_1_n3, mult_7_FS_1_n1;
  wire   [7:0] a_reg;
  wire   [7:0] b_reg;
  wire   [15:8] t;

  DFF_X1 a_reg_reg_7_ ( .D(a[7]), .CK(clk), .Q(a_reg[7]) );
  DFF_X1 a_reg_reg_6_ ( .D(a[6]), .CK(clk), .Q(a_reg[6]) );
  DFF_X1 a_reg_reg_5_ ( .D(a[5]), .CK(clk), .Q(a_reg[5]) );
  DFF_X1 a_reg_reg_4_ ( .D(a[4]), .CK(clk), .Q(a_reg[4]) );
  DFF_X1 a_reg_reg_3_ ( .D(a[3]), .CK(clk), .Q(a_reg[3]) );
  DFF_X1 a_reg_reg_1_ ( .D(a[1]), .CK(clk), .Q(a_reg[1]) );
  DFF_X1 b_reg_reg_7_ ( .D(b[7]), .CK(clk), .Q(b_reg[7]) );
  DFF_X1 b_reg_reg_5_ ( .D(b[5]), .CK(clk), .Q(b_reg[5]) );
  DFF_X1 b_reg_reg_0_ ( .D(b[0]), .CK(clk), .Q(b_reg[0]) );
  DFF_X1 z_reg_2_ ( .D(t[10]), .CK(clk), .Q(z[2]) );
  DFF_X1 z_reg_1_ ( .D(t[9]), .CK(clk), .Q(z[1]) );
  DFF_X1 z_reg_0_ ( .D(t[8]), .CK(clk), .Q(z[0]) );
  DFF_X1 z_reg_3_ ( .D(t[11]), .CK(clk), .Q(z[3]) );
  DFF_X1 z_reg_4_ ( .D(t[12]), .CK(clk), .Q(z[4]) );
  DFF_X1 z_reg_5_ ( .D(t[13]), .CK(clk), .Q(z[5]) );
  DFF_X1 z_reg_7_ ( .D(t[15]), .CK(clk), .Q(z[7]) );
  DFF_X1 z_reg_6_ ( .D(t[14]), .CK(clk), .Q(z[6]) );
  DFF_X1 b_reg_reg_1_ ( .D(b[1]), .CK(clk), .Q(b_reg[1]) );
  DFF_X1 a_reg_reg_2_ ( .D(a[2]), .CK(clk), .Q(a_reg[2]) );
  DFF_X1 b_reg_reg_2_ ( .D(b[2]), .CK(clk), .Q(b_reg[2]) );
  DFF_X1 b_reg_reg_3_ ( .D(b[3]), .CK(clk), .Q(b_reg[3]) );
  DFF_X1 b_reg_reg_4_ ( .D(b[4]), .CK(clk), .Q(b_reg[4]) );
  DFF_X1 a_reg_reg_0_ ( .D(a[0]), .CK(clk), .Q(a_reg[0]) );
  DFF_X1 b_reg_reg_6_ ( .D(b[6]), .CK(clk), .Q(b_reg[6]) );
  INV_X1 U3 ( .A(n13), .ZN(n1) );
  AND3_X1 U4 ( .A1(N9), .A2(N7), .A3(n1), .ZN(n6) );
  OR2_X1 U5 ( .A1(n14), .A2(n13), .ZN(n2) );
  BUF_X1 U6 ( .A(N9), .Z(n3) );
  XNOR2_X1 U7 ( .A(n3), .B(n2), .ZN(t[9]) );
  AND2_X1 U8 ( .A1(n9), .A2(n7), .ZN(n11) );
  BUF_X1 U9 ( .A(n6), .Z(n9) );
  CLKBUF_X1 U10 ( .A(N13), .Z(n4) );
  AND3_X1 U11 ( .A1(N11), .A2(n6), .A3(N10), .ZN(n5) );
  CLKBUF_X1 U12 ( .A(N10), .Z(n7) );
  CLKBUF_X1 U13 ( .A(N12), .Z(n8) );
  CLKBUF_X1 U14 ( .A(N11), .Z(n10) );
  XOR2_X1 U15 ( .A(n10), .B(n11), .Z(t[11]) );
  CLKBUF_X1 U16 ( .A(N14), .Z(n12) );
  NAND4_X1 U17 ( .A1(n20), .A2(N13), .A3(n21), .A4(N12), .ZN(n22) );
  AND2_X1 U18 ( .A1(N11), .A2(N10), .ZN(n20) );
  AND2_X1 U19 ( .A1(N14), .A2(n6), .ZN(n21) );
  XNOR2_X1 U20 ( .A(n22), .B(N15), .ZN(t[15]) );
  XNOR2_X1 U21 ( .A(n19), .B(n12), .ZN(t[14]) );
  XOR2_X1 U22 ( .A(N8), .B(N7), .Z(t[8]) );
  INV_X1 U23 ( .A(N7), .ZN(n14) );
  INV_X1 U24 ( .A(N8), .ZN(n13) );
  XOR2_X1 U25 ( .A(n9), .B(n7), .Z(t[10]) );
  NAND3_X1 U26 ( .A1(N10), .A2(n6), .A3(N11), .ZN(n18) );
  INV_X1 U27 ( .A(n18), .ZN(n15) );
  XOR2_X1 U28 ( .A(n8), .B(n15), .Z(t[12]) );
  INV_X1 U29 ( .A(N12), .ZN(n16) );
  NOR2_X1 U30 ( .A1(n18), .A2(n16), .ZN(n17) );
  XOR2_X1 U31 ( .A(n17), .B(n4), .Z(t[13]) );
  NAND3_X1 U32 ( .A1(n5), .A2(N12), .A3(N13), .ZN(n19) );
  INV_X1 mult_7_U120 ( .A(mult_7_CARRYB_7__7_), .ZN(mult_7_A1_13_) );
  NOR2_X1 mult_7_U119 ( .A1(b_reg[0]), .A2(mult_7_n55), .ZN(mult_7_ab_7__0_)
         );
  NOR2_X1 mult_7_U118 ( .A1(b_reg[1]), .A2(mult_7_n55), .ZN(mult_7_ab_7__1_)
         );
  NOR2_X1 mult_7_U117 ( .A1(b_reg[2]), .A2(mult_7_n55), .ZN(mult_7_ab_7__2_)
         );
  NOR2_X1 mult_7_U116 ( .A1(b_reg[3]), .A2(mult_7_n55), .ZN(mult_7_ab_7__3_)
         );
  NOR2_X1 mult_7_U115 ( .A1(b_reg[4]), .A2(mult_7_n55), .ZN(mult_7_ab_7__4_)
         );
  NOR2_X1 mult_7_U114 ( .A1(b_reg[5]), .A2(mult_7_n55), .ZN(mult_7_ab_7__5_)
         );
  NOR2_X1 mult_7_U113 ( .A1(a_reg[6]), .A2(mult_7_n21), .ZN(mult_7_ab_6__7_)
         );
  NOR2_X1 mult_7_U112 ( .A1(b_reg[6]), .A2(mult_7_n55), .ZN(mult_7_ab_7__6_)
         );
  NOR2_X1 mult_7_U111 ( .A1(mult_7_n21), .A2(mult_7_n55), .ZN(mult_7_ab_7__7_)
         );
  NOR2_X1 mult_7_U110 ( .A1(mult_7_n53), .A2(mult_7_n52), .ZN(mult_7_ab_6__0_)
         );
  NOR2_X1 mult_7_U109 ( .A1(mult_7_n52), .A2(mult_7_n51), .ZN(mult_7_ab_6__1_)
         );
  NOR2_X1 mult_7_U108 ( .A1(mult_7_n52), .A2(mult_7_n50), .ZN(mult_7_ab_6__2_)
         );
  NOR2_X1 mult_7_U107 ( .A1(mult_7_n52), .A2(mult_7_n49), .ZN(mult_7_ab_6__3_)
         );
  NOR2_X1 mult_7_U106 ( .A1(mult_7_n52), .A2(mult_7_n48), .ZN(mult_7_ab_6__4_)
         );
  NOR2_X1 mult_7_U105 ( .A1(mult_7_n52), .A2(mult_7_n47), .ZN(mult_7_ab_6__5_)
         );
  NOR2_X1 mult_7_U104 ( .A1(a_reg[5]), .A2(mult_7_n37), .ZN(mult_7_ab_5__7_)
         );
  NOR2_X1 mult_7_U103 ( .A1(mult_7_n52), .A2(mult_7_n46), .ZN(mult_7_ab_6__6_)
         );
  INV_X1 mult_7_U102 ( .A(a_reg[6]), .ZN(mult_7_n52) );
  NOR2_X1 mult_7_U101 ( .A1(mult_7_n53), .A2(mult_7_n45), .ZN(mult_7_ab_5__0_)
         );
  NOR2_X1 mult_7_U100 ( .A1(mult_7_n51), .A2(mult_7_n45), .ZN(mult_7_ab_5__1_)
         );
  NOR2_X1 mult_7_U99 ( .A1(mult_7_n50), .A2(mult_7_n45), .ZN(mult_7_ab_5__2_)
         );
  NOR2_X1 mult_7_U98 ( .A1(mult_7_n49), .A2(mult_7_n45), .ZN(mult_7_ab_5__3_)
         );
  NOR2_X1 mult_7_U97 ( .A1(mult_7_n48), .A2(mult_7_n45), .ZN(mult_7_ab_5__4_)
         );
  NOR2_X1 mult_7_U96 ( .A1(mult_7_n47), .A2(mult_7_n45), .ZN(mult_7_ab_5__5_)
         );
  NOR2_X1 mult_7_U95 ( .A1(a_reg[4]), .A2(mult_7_n21), .ZN(mult_7_ab_4__7_) );
  NOR2_X1 mult_7_U94 ( .A1(mult_7_n46), .A2(mult_7_n45), .ZN(mult_7_ab_5__6_)
         );
  INV_X1 mult_7_U93 ( .A(a_reg[5]), .ZN(mult_7_n45) );
  NOR2_X1 mult_7_U92 ( .A1(mult_7_n53), .A2(mult_7_n44), .ZN(mult_7_ab_4__0_)
         );
  NOR2_X1 mult_7_U91 ( .A1(mult_7_n51), .A2(mult_7_n44), .ZN(mult_7_ab_4__1_)
         );
  NOR2_X1 mult_7_U90 ( .A1(mult_7_n50), .A2(mult_7_n44), .ZN(mult_7_ab_4__2_)
         );
  NOR2_X1 mult_7_U89 ( .A1(mult_7_n49), .A2(mult_7_n44), .ZN(mult_7_ab_4__3_)
         );
  NOR2_X1 mult_7_U88 ( .A1(mult_7_n48), .A2(mult_7_n44), .ZN(mult_7_ab_4__4_)
         );
  NOR2_X1 mult_7_U87 ( .A1(mult_7_n47), .A2(mult_7_n44), .ZN(mult_7_ab_4__5_)
         );
  NOR2_X1 mult_7_U86 ( .A1(a_reg[3]), .A2(mult_7_n37), .ZN(mult_7_ab_3__7_) );
  NOR2_X1 mult_7_U85 ( .A1(mult_7_n46), .A2(mult_7_n44), .ZN(mult_7_ab_4__6_)
         );
  INV_X1 mult_7_U84 ( .A(a_reg[4]), .ZN(mult_7_n44) );
  NOR2_X1 mult_7_U83 ( .A1(mult_7_n53), .A2(mult_7_n43), .ZN(mult_7_ab_3__0_)
         );
  NOR2_X1 mult_7_U82 ( .A1(mult_7_n51), .A2(mult_7_n43), .ZN(mult_7_ab_3__1_)
         );
  NOR2_X1 mult_7_U81 ( .A1(mult_7_n50), .A2(mult_7_n43), .ZN(mult_7_ab_3__2_)
         );
  NOR2_X1 mult_7_U80 ( .A1(mult_7_n49), .A2(mult_7_n43), .ZN(mult_7_ab_3__3_)
         );
  NOR2_X1 mult_7_U79 ( .A1(mult_7_n48), .A2(mult_7_n43), .ZN(mult_7_ab_3__4_)
         );
  NOR2_X1 mult_7_U78 ( .A1(mult_7_n47), .A2(mult_7_n43), .ZN(mult_7_ab_3__5_)
         );
  NOR2_X1 mult_7_U77 ( .A1(a_reg[2]), .A2(mult_7_n21), .ZN(mult_7_ab_2__7_) );
  NOR2_X1 mult_7_U76 ( .A1(mult_7_n46), .A2(mult_7_n43), .ZN(mult_7_ab_3__6_)
         );
  INV_X1 mult_7_U75 ( .A(a_reg[3]), .ZN(mult_7_n43) );
  NOR3_X1 mult_7_U74 ( .A1(mult_7_n41), .A2(mult_7_n53), .A3(mult_7_n42), .ZN(
        mult_7_CARRYB_1__0_) );
  NOR2_X1 mult_7_U73 ( .A1(mult_7_n53), .A2(mult_7_n40), .ZN(mult_7_ab_2__0_)
         );
  INV_X1 mult_7_U72 ( .A(b_reg[0]), .ZN(mult_7_n53) );
  NOR2_X1 mult_7_U71 ( .A1(mult_7_n51), .A2(mult_7_n40), .ZN(mult_7_ab_2__1_)
         );
  INV_X1 mult_7_U70 ( .A(b_reg[1]), .ZN(mult_7_n51) );
  NOR2_X1 mult_7_U69 ( .A1(mult_7_n50), .A2(mult_7_n40), .ZN(mult_7_ab_2__2_)
         );
  NOR2_X1 mult_7_U68 ( .A1(mult_7_n49), .A2(mult_7_n40), .ZN(mult_7_ab_2__3_)
         );
  NOR2_X1 mult_7_U67 ( .A1(mult_7_n48), .A2(mult_7_n40), .ZN(mult_7_ab_2__4_)
         );
  NOR2_X1 mult_7_U66 ( .A1(mult_7_n47), .A2(mult_7_n40), .ZN(mult_7_ab_2__5_)
         );
  NOR2_X1 mult_7_U65 ( .A1(mult_7_n20), .A2(mult_7_n37), .ZN(mult_7_ab_1__7_)
         );
  NOR2_X1 mult_7_U64 ( .A1(mult_7_n46), .A2(mult_7_n40), .ZN(mult_7_ab_2__6_)
         );
  INV_X1 mult_7_U63 ( .A(a_reg[2]), .ZN(mult_7_n40) );
  INV_X1 mult_7_U62 ( .A(mult_7_n42), .ZN(mult_7_n54) );
  NAND2_X1 mult_7_U61 ( .A1(mult_7_n10), .A2(b_reg[1]), .ZN(mult_7_n42) );
  NOR2_X1 mult_7_U60 ( .A1(mult_7_n50), .A2(mult_7_n41), .ZN(mult_7_ab_0__2_)
         );
  NOR2_X1 mult_7_U59 ( .A1(mult_7_n50), .A2(mult_7_n39), .ZN(mult_7_ab_1__2_)
         );
  INV_X1 mult_7_U58 ( .A(b_reg[2]), .ZN(mult_7_n50) );
  NOR2_X1 mult_7_U57 ( .A1(mult_7_n49), .A2(mult_7_n41), .ZN(mult_7_ab_0__3_)
         );
  NOR2_X1 mult_7_U56 ( .A1(mult_7_n49), .A2(mult_7_n39), .ZN(mult_7_ab_1__3_)
         );
  INV_X1 mult_7_U55 ( .A(b_reg[3]), .ZN(mult_7_n49) );
  NOR2_X1 mult_7_U54 ( .A1(mult_7_n48), .A2(mult_7_n41), .ZN(mult_7_ab_0__4_)
         );
  NOR2_X1 mult_7_U53 ( .A1(mult_7_n48), .A2(mult_7_n39), .ZN(mult_7_ab_1__4_)
         );
  INV_X1 mult_7_U52 ( .A(b_reg[4]), .ZN(mult_7_n48) );
  NOR2_X1 mult_7_U51 ( .A1(mult_7_n47), .A2(mult_7_n41), .ZN(mult_7_ab_0__5_)
         );
  INV_X1 mult_7_U50 ( .A(b_reg[5]), .ZN(mult_7_n47) );
  NOR2_X1 mult_7_U49 ( .A1(mult_7_n46), .A2(mult_7_n41), .ZN(mult_7_ab_0__6_)
         );
  INV_X1 mult_7_U48 ( .A(a_reg[0]), .ZN(mult_7_n41) );
  INV_X1 mult_7_U47 ( .A(a_reg[1]), .ZN(mult_7_n39) );
  NOR2_X1 mult_7_U46 ( .A1(mult_7_n56), .A2(a_reg[0]), .ZN(mult_7_ab_0__7_) );
  INV_X2 mult_7_U45 ( .A(a_reg[7]), .ZN(mult_7_n55) );
  INV_X1 mult_7_U44 ( .A(mult_7_n37), .ZN(mult_7_n38) );
  INV_X1 mult_7_U43 ( .A(b_reg[7]), .ZN(mult_7_n56) );
  INV_X1 mult_7_U42 ( .A(mult_7_n22), .ZN(mult_7_n37) );
  AND2_X1 mult_7_U41 ( .A1(mult_7_CARRYB_7__6_), .A2(mult_7_SUMB_7__7_), .ZN(
        mult_7_n36) );
  XOR2_X1 mult_7_U40 ( .A(mult_7_CARRYB_7__6_), .B(mult_7_SUMB_7__7_), .Z(
        mult_7_n35) );
  AND2_X1 mult_7_U39 ( .A1(mult_7_CARRYB_7__5_), .A2(mult_7_SUMB_7__6_), .ZN(
        mult_7_n34) );
  AND2_X1 mult_7_U38 ( .A1(mult_7_CARRYB_7__4_), .A2(mult_7_SUMB_7__5_), .ZN(
        mult_7_n33) );
  XOR2_X1 mult_7_U37 ( .A(mult_7_CARRYB_7__5_), .B(mult_7_SUMB_7__6_), .Z(
        mult_7_n32) );
  XOR2_X1 mult_7_U36 ( .A(mult_7_CARRYB_7__4_), .B(mult_7_SUMB_7__5_), .Z(
        mult_7_n31) );
  AND2_X1 mult_7_U35 ( .A1(mult_7_CARRYB_7__3_), .A2(mult_7_SUMB_7__4_), .ZN(
        mult_7_n30) );
  AND2_X1 mult_7_U34 ( .A1(mult_7_CARRYB_7__2_), .A2(mult_7_SUMB_7__3_), .ZN(
        mult_7_n29) );
  XOR2_X1 mult_7_U33 ( .A(mult_7_CARRYB_7__2_), .B(mult_7_SUMB_7__3_), .Z(
        mult_7_n28) );
  AND2_X1 mult_7_U32 ( .A1(mult_7_SUMB_7__1_), .A2(mult_7_CARRYB_7__0_), .ZN(
        mult_7_n27) );
  XOR2_X1 mult_7_U31 ( .A(mult_7_SUMB_7__4_), .B(mult_7_CARRYB_7__3_), .Z(
        mult_7_n25) );
  AND2_X1 mult_7_U30 ( .A1(mult_7_ab_0__6_), .A2(mult_7_ab_1__5_), .ZN(
        mult_7_n24) );
  XOR2_X1 mult_7_U29 ( .A(mult_7_n54), .B(mult_7_ab_0__2_), .Z(mult_7_n23) );
  INV_X1 mult_7_U28 ( .A(b_reg[6]), .ZN(mult_7_n46) );
  AND2_X1 mult_7_U27 ( .A1(b_reg[6]), .A2(a_reg[1]), .ZN(mult_7_ab_1__6_) );
  CLKBUF_X1 mult_7_U26 ( .A(b_reg[7]), .Z(mult_7_n22) );
  INV_X1 mult_7_U25 ( .A(mult_7_n22), .ZN(mult_7_n21) );
  INV_X1 mult_7_U24 ( .A(mult_7_n39), .ZN(mult_7_n20) );
  INV_X1 mult_7_U23 ( .A(mult_7_SUMB_7__1_), .ZN(mult_7_n17) );
  INV_X1 mult_7_U22 ( .A(mult_7_CARRYB_7__0_), .ZN(mult_7_n16) );
  NAND2_X1 mult_7_U21 ( .A1(mult_7_n18), .A2(mult_7_n19), .ZN(mult_7_n26) );
  NAND2_X1 mult_7_U20 ( .A1(mult_7_SUMB_7__1_), .A2(mult_7_n16), .ZN(
        mult_7_n19) );
  NAND2_X1 mult_7_U19 ( .A1(mult_7_n17), .A2(mult_7_CARRYB_7__0_), .ZN(
        mult_7_n18) );
  NAND3_X1 mult_7_U18 ( .A1(mult_7_n13), .A2(mult_7_n14), .A3(mult_7_n15), 
        .ZN(mult_7_CARRYB_2__5_) );
  NAND2_X1 mult_7_U17 ( .A1(mult_7_n24), .A2(mult_7_ab_2__5_), .ZN(mult_7_n15)
         );
  NAND2_X1 mult_7_U16 ( .A1(mult_7_SUMB_1__6_), .A2(mult_7_ab_2__5_), .ZN(
        mult_7_n14) );
  NAND2_X1 mult_7_U15 ( .A1(mult_7_SUMB_1__6_), .A2(mult_7_n8), .ZN(mult_7_n13) );
  XOR2_X1 mult_7_U14 ( .A(mult_7_ab_0__6_), .B(mult_7_ab_1__5_), .Z(mult_7_n12) );
  AND2_X1 mult_7_U13 ( .A1(b_reg[5]), .A2(mult_7_n10), .ZN(mult_7_ab_1__5_) );
  XNOR2_X1 mult_7_U12 ( .A(mult_7_n24), .B(mult_7_ab_2__5_), .ZN(mult_7_n11)
         );
  XNOR2_X1 mult_7_U11 ( .A(mult_7_n11), .B(mult_7_SUMB_1__6_), .ZN(
        mult_7_SUMB_2__5_) );
  CLKBUF_X1 mult_7_U10 ( .A(a_reg[1]), .Z(mult_7_n10) );
  XOR2_X1 mult_7_U9 ( .A(mult_7_ab_1__4_), .B(mult_7_ab_0__5_), .Z(mult_7_n9)
         );
  CLKBUF_X1 mult_7_U8 ( .A(mult_7_n24), .Z(mult_7_n8) );
  AND2_X1 mult_7_U7 ( .A1(mult_7_ab_0__2_), .A2(mult_7_n54), .ZN(mult_7_n7) );
  AND2_X1 mult_7_U6 ( .A1(mult_7_ab_0__3_), .A2(mult_7_ab_1__2_), .ZN(
        mult_7_n6) );
  AND2_X1 mult_7_U5 ( .A1(mult_7_ab_0__4_), .A2(mult_7_ab_1__3_), .ZN(
        mult_7_n5) );
  AND2_X1 mult_7_U4 ( .A1(mult_7_ab_0__5_), .A2(mult_7_ab_1__4_), .ZN(
        mult_7_n4) );
  XOR2_X1 mult_7_U3 ( .A(mult_7_ab_1__2_), .B(mult_7_ab_0__3_), .Z(mult_7_n3)
         );
  XOR2_X1 mult_7_U2 ( .A(mult_7_ab_1__3_), .B(mult_7_ab_0__4_), .Z(mult_7_n2)
         );
  FA_X1 mult_7_S14_9 ( .A(1'b0), .B(mult_7_CARRYB_7__1_), .CI(
        mult_7_SUMB_7__2_), .CO(mult_7_A2_8_), .S(mult_7_A1_7_) );
  FA_X1 mult_7_S0_6 ( .A(1'b0), .B(mult_7_ab_1__6_), .CI(mult_7_ab_0__7_), 
        .CO(mult_7_CARRYB_1__6_), .S(mult_7_SUMB_1__6_) );
  FA_X1 mult_7_S3_2_6 ( .A(mult_7_ab_2__6_), .B(mult_7_ab_1__7_), .CI(
        mult_7_CARRYB_1__6_), .CO(mult_7_CARRYB_2__6_), .S(mult_7_SUMB_2__6_)
         );
  FA_X1 mult_7_S2_2_4 ( .A(mult_7_ab_2__4_), .B(mult_7_n4), .CI(mult_7_n12), 
        .CO(mult_7_CARRYB_2__4_), .S(mult_7_SUMB_2__4_) );
  FA_X1 mult_7_S2_2_3 ( .A(mult_7_ab_2__3_), .B(mult_7_n5), .CI(mult_7_n9), 
        .CO(mult_7_CARRYB_2__3_), .S(mult_7_SUMB_2__3_) );
  FA_X1 mult_7_S2_2_2 ( .A(mult_7_ab_2__2_), .B(mult_7_n6), .CI(mult_7_n2), 
        .CO(mult_7_CARRYB_2__2_), .S(mult_7_SUMB_2__2_) );
  FA_X1 mult_7_S2_2_1 ( .A(mult_7_ab_2__1_), .B(mult_7_n7), .CI(mult_7_n3), 
        .CO(mult_7_CARRYB_2__1_), .S(mult_7_SUMB_2__1_) );
  FA_X1 mult_7_S1_2_0 ( .A(mult_7_ab_2__0_), .B(mult_7_CARRYB_1__0_), .CI(
        mult_7_n23), .CO(mult_7_CARRYB_2__0_), .S(mult_7_A1_0_) );
  FA_X1 mult_7_S3_3_6 ( .A(mult_7_ab_3__6_), .B(mult_7_ab_2__7_), .CI(
        mult_7_CARRYB_2__6_), .CO(mult_7_CARRYB_3__6_), .S(mult_7_SUMB_3__6_)
         );
  FA_X1 mult_7_S2_3_5 ( .A(mult_7_ab_3__5_), .B(mult_7_CARRYB_2__5_), .CI(
        mult_7_SUMB_2__6_), .CO(mult_7_CARRYB_3__5_), .S(mult_7_SUMB_3__5_) );
  FA_X1 mult_7_S2_3_4 ( .A(mult_7_ab_3__4_), .B(mult_7_CARRYB_2__4_), .CI(
        mult_7_SUMB_2__5_), .CO(mult_7_CARRYB_3__4_), .S(mult_7_SUMB_3__4_) );
  FA_X1 mult_7_S2_3_3 ( .A(mult_7_ab_3__3_), .B(mult_7_CARRYB_2__3_), .CI(
        mult_7_SUMB_2__4_), .CO(mult_7_CARRYB_3__3_), .S(mult_7_SUMB_3__3_) );
  FA_X1 mult_7_S2_3_2 ( .A(mult_7_ab_3__2_), .B(mult_7_CARRYB_2__2_), .CI(
        mult_7_SUMB_2__3_), .CO(mult_7_CARRYB_3__2_), .S(mult_7_SUMB_3__2_) );
  FA_X1 mult_7_S2_3_1 ( .A(mult_7_ab_3__1_), .B(mult_7_CARRYB_2__1_), .CI(
        mult_7_SUMB_2__2_), .CO(mult_7_CARRYB_3__1_), .S(mult_7_SUMB_3__1_) );
  FA_X1 mult_7_S1_3_0 ( .A(mult_7_ab_3__0_), .B(mult_7_CARRYB_2__0_), .CI(
        mult_7_SUMB_2__1_), .CO(mult_7_CARRYB_3__0_), .S(mult_7_A1_1_) );
  FA_X1 mult_7_S3_4_6 ( .A(mult_7_ab_4__6_), .B(mult_7_CARRYB_3__6_), .CI(
        mult_7_ab_3__7_), .CO(mult_7_CARRYB_4__6_), .S(mult_7_SUMB_4__6_) );
  FA_X1 mult_7_S2_4_5 ( .A(mult_7_ab_4__5_), .B(mult_7_CARRYB_3__5_), .CI(
        mult_7_SUMB_3__6_), .CO(mult_7_CARRYB_4__5_), .S(mult_7_SUMB_4__5_) );
  FA_X1 mult_7_S2_4_4 ( .A(mult_7_CARRYB_3__4_), .B(mult_7_ab_4__4_), .CI(
        mult_7_SUMB_3__5_), .CO(mult_7_CARRYB_4__4_), .S(mult_7_SUMB_4__4_) );
  FA_X1 mult_7_S2_4_3 ( .A(mult_7_CARRYB_3__3_), .B(mult_7_ab_4__3_), .CI(
        mult_7_SUMB_3__4_), .CO(mult_7_CARRYB_4__3_), .S(mult_7_SUMB_4__3_) );
  FA_X1 mult_7_S2_4_2 ( .A(mult_7_ab_4__2_), .B(mult_7_CARRYB_3__2_), .CI(
        mult_7_SUMB_3__3_), .CO(mult_7_CARRYB_4__2_), .S(mult_7_SUMB_4__2_) );
  FA_X1 mult_7_S2_4_1 ( .A(mult_7_ab_4__1_), .B(mult_7_CARRYB_3__1_), .CI(
        mult_7_SUMB_3__2_), .CO(mult_7_CARRYB_4__1_), .S(mult_7_SUMB_4__1_) );
  FA_X1 mult_7_S1_4_0 ( .A(mult_7_ab_4__0_), .B(mult_7_CARRYB_3__0_), .CI(
        mult_7_SUMB_3__1_), .CO(mult_7_CARRYB_4__0_), .S(mult_7_A1_2_) );
  FA_X1 mult_7_S3_5_6 ( .A(mult_7_ab_5__6_), .B(mult_7_CARRYB_4__6_), .CI(
        mult_7_ab_4__7_), .CO(mult_7_CARRYB_5__6_), .S(mult_7_SUMB_5__6_) );
  FA_X1 mult_7_S2_5_5 ( .A(mult_7_ab_5__5_), .B(mult_7_CARRYB_4__5_), .CI(
        mult_7_SUMB_4__6_), .CO(mult_7_CARRYB_5__5_), .S(mult_7_SUMB_5__5_) );
  FA_X1 mult_7_S2_5_4 ( .A(mult_7_CARRYB_4__4_), .B(mult_7_ab_5__4_), .CI(
        mult_7_SUMB_4__5_), .CO(mult_7_CARRYB_5__4_), .S(mult_7_SUMB_5__4_) );
  FA_X1 mult_7_S2_5_3 ( .A(mult_7_ab_5__3_), .B(mult_7_CARRYB_4__3_), .CI(
        mult_7_SUMB_4__4_), .CO(mult_7_CARRYB_5__3_), .S(mult_7_SUMB_5__3_) );
  FA_X1 mult_7_S2_5_2 ( .A(mult_7_ab_5__2_), .B(mult_7_CARRYB_4__2_), .CI(
        mult_7_SUMB_4__3_), .CO(mult_7_CARRYB_5__2_), .S(mult_7_SUMB_5__2_) );
  FA_X1 mult_7_S2_5_1 ( .A(mult_7_ab_5__1_), .B(mult_7_CARRYB_4__1_), .CI(
        mult_7_SUMB_4__2_), .CO(mult_7_CARRYB_5__1_), .S(mult_7_SUMB_5__1_) );
  FA_X1 mult_7_S1_5_0 ( .A(mult_7_ab_5__0_), .B(mult_7_CARRYB_4__0_), .CI(
        mult_7_SUMB_4__1_), .CO(mult_7_CARRYB_5__0_), .S(mult_7_A1_3_) );
  FA_X1 mult_7_S3_6_6 ( .A(mult_7_ab_6__6_), .B(mult_7_CARRYB_5__6_), .CI(
        mult_7_ab_5__7_), .CO(mult_7_CARRYB_6__6_), .S(mult_7_SUMB_6__6_) );
  FA_X1 mult_7_S2_6_5 ( .A(mult_7_ab_6__5_), .B(mult_7_CARRYB_5__5_), .CI(
        mult_7_SUMB_5__6_), .CO(mult_7_CARRYB_6__5_), .S(mult_7_SUMB_6__5_) );
  FA_X1 mult_7_S2_6_4 ( .A(mult_7_ab_6__4_), .B(mult_7_CARRYB_5__4_), .CI(
        mult_7_SUMB_5__5_), .CO(mult_7_CARRYB_6__4_), .S(mult_7_SUMB_6__4_) );
  FA_X1 mult_7_S2_6_3 ( .A(mult_7_ab_6__3_), .B(mult_7_CARRYB_5__3_), .CI(
        mult_7_SUMB_5__4_), .CO(mult_7_CARRYB_6__3_), .S(mult_7_SUMB_6__3_) );
  FA_X1 mult_7_S2_6_2 ( .A(mult_7_CARRYB_5__2_), .B(mult_7_ab_6__2_), .CI(
        mult_7_SUMB_5__3_), .CO(mult_7_CARRYB_6__2_), .S(mult_7_SUMB_6__2_) );
  FA_X1 mult_7_S2_6_1 ( .A(mult_7_CARRYB_5__1_), .B(mult_7_ab_6__1_), .CI(
        mult_7_SUMB_5__2_), .CO(mult_7_CARRYB_6__1_), .S(mult_7_SUMB_6__1_) );
  FA_X1 mult_7_S1_6_0 ( .A(mult_7_ab_6__0_), .B(mult_7_CARRYB_5__0_), .CI(
        mult_7_SUMB_5__1_), .CO(mult_7_CARRYB_6__0_), .S(mult_7_A1_4_) );
  FA_X1 mult_7_S14_7 ( .A(mult_7_n55), .B(mult_7_n37), .CI(mult_7_ab_7__7_), 
        .CO(mult_7_CARRYB_7__7_), .S(mult_7_SUMB_7__7_) );
  FA_X1 mult_7_S5_6 ( .A(mult_7_ab_7__6_), .B(mult_7_CARRYB_6__6_), .CI(
        mult_7_ab_6__7_), .CO(mult_7_CARRYB_7__6_), .S(mult_7_SUMB_7__6_) );
  FA_X1 mult_7_S4_5 ( .A(mult_7_ab_7__5_), .B(mult_7_CARRYB_6__5_), .CI(
        mult_7_SUMB_6__6_), .CO(mult_7_CARRYB_7__5_), .S(mult_7_SUMB_7__5_) );
  FA_X1 mult_7_S4_4 ( .A(mult_7_ab_7__4_), .B(mult_7_CARRYB_6__4_), .CI(
        mult_7_SUMB_6__5_), .CO(mult_7_CARRYB_7__4_), .S(mult_7_SUMB_7__4_) );
  FA_X1 mult_7_S4_3 ( .A(mult_7_ab_7__3_), .B(mult_7_CARRYB_6__3_), .CI(
        mult_7_SUMB_6__4_), .CO(mult_7_CARRYB_7__3_), .S(mult_7_SUMB_7__3_) );
  FA_X1 mult_7_S4_2 ( .A(mult_7_CARRYB_6__2_), .B(mult_7_ab_7__2_), .CI(
        mult_7_SUMB_6__3_), .CO(mult_7_CARRYB_7__2_), .S(mult_7_SUMB_7__2_) );
  FA_X1 mult_7_S4_1 ( .A(mult_7_ab_7__1_), .B(mult_7_CARRYB_6__1_), .CI(
        mult_7_SUMB_6__2_), .CO(mult_7_CARRYB_7__1_), .S(mult_7_SUMB_7__1_) );
  FA_X1 mult_7_S4_0 ( .A(mult_7_ab_7__0_), .B(mult_7_CARRYB_6__0_), .CI(
        mult_7_SUMB_6__1_), .CO(mult_7_CARRYB_7__0_), .S(mult_7_SUMB_7__0_) );
  FA_X1 mult_7_S14_7_0 ( .A(a_reg[7]), .B(mult_7_n38), .CI(mult_7_SUMB_7__0_), 
        .CO(mult_7_A2_6_), .S(mult_7_A1_5_) );
  INV_X1 mult_7_FS_1_U82 ( .A(mult_7_FS_1_n29), .ZN(mult_7_FS_1_n22) );
  NAND3_X1 mult_7_FS_1_U81 ( .A1(mult_7_A2_8_), .A2(mult_7_n28), .A3(
        mult_7_FS_1_n57), .ZN(mult_7_FS_1_n74) );
  INV_X1 mult_7_FS_1_U80 ( .A(mult_7_FS_1_n56), .ZN(mult_7_FS_1_n72) );
  INV_X1 mult_7_FS_1_U79 ( .A(mult_7_FS_1_n58), .ZN(mult_7_FS_1_n55) );
  NAND3_X1 mult_7_FS_1_U78 ( .A1(mult_7_FS_1_n3), .A2(mult_7_FS_1_n58), .A3(
        mult_7_FS_1_n15), .ZN(mult_7_FS_1_n64) );
  NAND2_X1 mult_7_FS_1_U77 ( .A1(mult_7_FS_1_n64), .A2(mult_7_FS_1_n65), .ZN(
        mult_7_FS_1_n63) );
  INV_X1 mult_7_FS_1_U76 ( .A(mult_7_FS_1_n44), .ZN(mult_7_FS_1_n49) );
  INV_X1 mult_7_FS_1_U75 ( .A(mult_7_FS_1_n59), .ZN(mult_7_FS_1_n54) );
  INV_X1 mult_7_FS_1_U74 ( .A(mult_7_FS_1_n57), .ZN(mult_7_FS_1_n19) );
  NOR2_X1 mult_7_FS_1_U73 ( .A1(mult_7_FS_1_n54), .A2(mult_7_FS_1_n55), .ZN(
        mult_7_FS_1_n53) );
  INV_X1 mult_7_FS_1_U72 ( .A(mult_7_FS_1_n50), .ZN(mult_7_FS_1_n41) );
  INV_X1 mult_7_FS_1_U71 ( .A(mult_7_FS_1_n39), .ZN(mult_7_FS_1_n38) );
  NAND3_X1 mult_7_FS_1_U70 ( .A1(mult_7_FS_1_n4), .A2(mult_7_FS_1_n24), .A3(
        mult_7_FS_1_n25), .ZN(mult_7_FS_1_n21) );
  INV_X1 mult_7_FS_1_U69 ( .A(mult_7_FS_1_n20), .ZN(mult_7_FS_1_n18) );
  INV_X1 mult_7_FS_1_U68 ( .A(mult_7_n26), .ZN(mult_7_FS_1_n69) );
  OAI211_X1 mult_7_FS_1_U67 ( .C1(mult_7_A1_7_), .C2(mult_7_n27), .A(
        mult_7_A2_6_), .B(mult_7_n26), .ZN(mult_7_FS_1_n40) );
  NAND2_X1 mult_7_FS_1_U66 ( .A1(mult_7_A2_6_), .A2(mult_7_n26), .ZN(
        mult_7_FS_1_n30) );
  OAI21_X1 mult_7_FS_1_U65 ( .B1(mult_7_FS_1_n47), .B2(mult_7_FS_1_n39), .A(
        mult_7_FS_1_n48), .ZN(mult_7_FS_1_n45) );
  XNOR2_X1 mult_7_FS_1_U64 ( .A(mult_7_FS_1_n45), .B(mult_7_FS_1_n46), .ZN(N14) );
  NAND2_X1 mult_7_FS_1_U63 ( .A1(mult_7_FS_1_n57), .A2(mult_7_FS_1_n23), .ZN(
        mult_7_FS_1_n70) );
  NAND4_X1 mult_7_FS_1_U62 ( .A1(mult_7_FS_1_n58), .A2(mult_7_FS_1_n59), .A3(
        mult_7_FS_1_n57), .A4(mult_7_FS_1_n4), .ZN(mult_7_FS_1_n39) );
  NAND2_X1 mult_7_FS_1_U61 ( .A1(mult_7_FS_1_n29), .A2(mult_7_FS_1_n40), .ZN(
        mult_7_FS_1_n37) );
  NAND2_X1 mult_7_FS_1_U60 ( .A1(mult_7_FS_1_n69), .A2(mult_7_FS_1_n68), .ZN(
        mult_7_FS_1_n27) );
  OAI21_X1 mult_7_FS_1_U59 ( .B1(mult_7_FS_1_n51), .B2(mult_7_FS_1_n52), .A(
        mult_7_FS_1_n53), .ZN(mult_7_FS_1_n50) );
  AOI21_X1 mult_7_FS_1_U58 ( .B1(mult_7_FS_1_n71), .B2(mult_7_FS_1_n58), .A(
        mult_7_FS_1_n72), .ZN(mult_7_FS_1_n67) );
  NAND2_X1 mult_7_FS_1_U57 ( .A1(mult_7_FS_1_n58), .A2(mult_7_FS_1_n56), .ZN(
        mult_7_FS_1_n73) );
  NOR2_X1 mult_7_FS_1_U56 ( .A1(mult_7_FS_1_n1), .A2(mult_7_FS_1_n15), .ZN(
        mult_7_FS_1_n28) );
  INV_X1 mult_7_FS_1_U55 ( .A(mult_7_FS_1_n40), .ZN(mult_7_FS_1_n15) );
  NAND2_X1 mult_7_FS_1_U54 ( .A1(mult_7_A1_7_), .A2(mult_7_n27), .ZN(
        mult_7_FS_1_n29) );
  AND2_X1 mult_7_FS_1_U53 ( .A1(mult_7_A2_6_), .A2(mult_7_n26), .ZN(
        mult_7_FS_1_n25) );
  NAND2_X1 mult_7_FS_1_U52 ( .A1(mult_7_A2_8_), .A2(mult_7_n28), .ZN(
        mult_7_FS_1_n26) );
  NOR2_X1 mult_7_FS_1_U51 ( .A1(mult_7_FS_1_n55), .A2(mult_7_FS_1_n29), .ZN(
        mult_7_FS_1_n66) );
  XNOR2_X1 mult_7_FS_1_U50 ( .A(mult_7_FS_1_n60), .B(mult_7_FS_1_n61), .ZN(N13) );
  BUF_X2 mult_7_FS_1_U49 ( .A(mult_7_A1_5_), .Z(N7) );
  INV_X1 mult_7_FS_1_U48 ( .A(mult_7_A2_6_), .ZN(mult_7_FS_1_n68) );
  NAND2_X1 mult_7_FS_1_U47 ( .A1(mult_7_FS_1_n20), .A2(mult_7_FS_1_n74), .ZN(
        mult_7_FS_1_n71) );
  OR2_X1 mult_7_FS_1_U46 ( .A1(mult_7_n27), .A2(mult_7_A1_7_), .ZN(
        mult_7_FS_1_n24) );
  NAND2_X1 mult_7_FS_1_U45 ( .A1(mult_7_n34), .A2(mult_7_n35), .ZN(
        mult_7_FS_1_n43) );
  OR2_X1 mult_7_FS_1_U44 ( .A1(mult_7_n34), .A2(mult_7_n35), .ZN(
        mult_7_FS_1_n36) );
  NAND2_X1 mult_7_FS_1_U43 ( .A1(mult_7_n33), .A2(mult_7_n32), .ZN(
        mult_7_FS_1_n44) );
  NAND2_X1 mult_7_FS_1_U42 ( .A1(mult_7_n30), .A2(mult_7_n31), .ZN(
        mult_7_FS_1_n56) );
  NAND2_X1 mult_7_FS_1_U41 ( .A1(mult_7_n29), .A2(mult_7_n25), .ZN(
        mult_7_FS_1_n20) );
  OR2_X1 mult_7_FS_1_U40 ( .A1(mult_7_n33), .A2(mult_7_n32), .ZN(
        mult_7_FS_1_n59) );
  AND2_X1 mult_7_FS_1_U39 ( .A1(mult_7_FS_1_n24), .A2(mult_7_FS_1_n29), .ZN(
        mult_7_FS_1_n13) );
  XNOR2_X1 mult_7_FS_1_U38 ( .A(mult_7_FS_1_n13), .B(mult_7_FS_1_n30), .ZN(N9)
         );
  NOR2_X1 mult_7_FS_1_U37 ( .A1(mult_7_FS_1_n19), .A2(mult_7_FS_1_n26), .ZN(
        mult_7_FS_1_n51) );
  XNOR2_X1 mult_7_FS_1_U36 ( .A(mult_7_n36), .B(mult_7_A1_13_), .ZN(
        mult_7_FS_1_n31) );
  XNOR2_X1 mult_7_FS_1_U35 ( .A(mult_7_FS_1_n31), .B(mult_7_FS_1_n32), .ZN(N15) );
  NOR2_X1 mult_7_FS_1_U34 ( .A1(mult_7_FS_1_n18), .A2(mult_7_FS_1_n19), .ZN(
        mult_7_FS_1_n17) );
  XNOR2_X1 mult_7_FS_1_U33 ( .A(mult_7_FS_1_n16), .B(mult_7_FS_1_n17), .ZN(N11) );
  NAND2_X1 mult_7_FS_1_U32 ( .A1(mult_7_FS_1_n43), .A2(mult_7_FS_1_n44), .ZN(
        mult_7_FS_1_n42) );
  NOR2_X1 mult_7_FS_1_U31 ( .A1(mult_7_FS_1_n41), .A2(mult_7_FS_1_n42), .ZN(
        mult_7_FS_1_n33) );
  NAND2_X1 mult_7_FS_1_U30 ( .A1(mult_7_FS_1_n37), .A2(mult_7_FS_1_n38), .ZN(
        mult_7_FS_1_n34) );
  INV_X1 mult_7_FS_1_U29 ( .A(mult_7_FS_1_n36), .ZN(mult_7_FS_1_n35) );
  AOI21_X1 mult_7_FS_1_U28 ( .B1(mult_7_FS_1_n33), .B2(mult_7_FS_1_n34), .A(
        mult_7_FS_1_n35), .ZN(mult_7_FS_1_n32) );
  NAND2_X1 mult_7_FS_1_U27 ( .A1(mult_7_FS_1_n66), .A2(mult_7_FS_1_n3), .ZN(
        mult_7_FS_1_n65) );
  INV_X1 mult_7_FS_1_U26 ( .A(mult_7_FS_1_n67), .ZN(mult_7_FS_1_n62) );
  NOR2_X1 mult_7_FS_1_U25 ( .A1(mult_7_FS_1_n62), .A2(mult_7_FS_1_n63), .ZN(
        mult_7_FS_1_n60) );
  NOR2_X1 mult_7_FS_1_U24 ( .A1(mult_7_FS_1_n49), .A2(mult_7_FS_1_n54), .ZN(
        mult_7_FS_1_n61) );
  NAND2_X1 mult_7_FS_1_U23 ( .A1(mult_7_FS_1_n20), .A2(mult_7_FS_1_n56), .ZN(
        mult_7_FS_1_n52) );
  INV_X1 mult_7_FS_1_U22 ( .A(mult_7_FS_1_n37), .ZN(mult_7_FS_1_n47) );
  NAND2_X1 mult_7_FS_1_U21 ( .A1(mult_7_FS_1_n36), .A2(mult_7_FS_1_n43), .ZN(
        mult_7_FS_1_n46) );
  OR2_X2 mult_7_FS_1_U20 ( .A1(mult_7_n30), .A2(mult_7_n31), .ZN(
        mult_7_FS_1_n58) );
  OR2_X2 mult_7_FS_1_U19 ( .A1(mult_7_n25), .A2(mult_7_n29), .ZN(
        mult_7_FS_1_n57) );
  AND2_X1 mult_7_FS_1_U18 ( .A1(mult_7_FS_1_n26), .A2(mult_7_FS_1_n4), .ZN(
        mult_7_FS_1_n12) );
  XNOR2_X1 mult_7_FS_1_U17 ( .A(mult_7_FS_1_n28), .B(mult_7_FS_1_n12), .ZN(N10) );
  NAND2_X1 mult_7_FS_1_U16 ( .A1(mult_7_FS_1_n21), .A2(mult_7_FS_1_n26), .ZN(
        mult_7_FS_1_n11) );
  AND2_X1 mult_7_FS_1_U15 ( .A1(mult_7_FS_1_n22), .A2(mult_7_FS_1_n4), .ZN(
        mult_7_FS_1_n10) );
  NOR2_X1 mult_7_FS_1_U14 ( .A1(mult_7_FS_1_n11), .A2(mult_7_FS_1_n10), .ZN(
        mult_7_FS_1_n16) );
  INV_X1 mult_7_FS_1_U13 ( .A(mult_7_FS_1_n71), .ZN(mult_7_FS_1_n8) );
  AND2_X1 mult_7_FS_1_U12 ( .A1(mult_7_FS_1_n8), .A2(mult_7_FS_1_n70), .ZN(
        mult_7_FS_1_n7) );
  NOR2_X1 mult_7_FS_1_U11 ( .A1(mult_7_FS_1_n9), .A2(mult_7_FS_1_n15), .ZN(
        mult_7_FS_1_n6) );
  NOR2_X1 mult_7_FS_1_U10 ( .A1(mult_7_FS_1_n6), .A2(mult_7_FS_1_n7), .ZN(
        mult_7_FS_1_n5) );
  XNOR2_X1 mult_7_FS_1_U9 ( .A(mult_7_FS_1_n5), .B(mult_7_FS_1_n73), .ZN(N12)
         );
  NAND2_X1 mult_7_FS_1_U8 ( .A1(mult_7_FS_1_n29), .A2(mult_7_FS_1_n8), .ZN(
        mult_7_FS_1_n9) );
  OR2_X1 mult_7_FS_1_U7 ( .A1(mult_7_A2_8_), .A2(mult_7_n28), .ZN(
        mult_7_FS_1_n23) );
  OR2_X1 mult_7_FS_1_U6 ( .A1(mult_7_n28), .A2(mult_7_A2_8_), .ZN(
        mult_7_FS_1_n4) );
  AND2_X1 mult_7_FS_1_U5 ( .A1(mult_7_FS_1_n44), .A2(mult_7_FS_1_n50), .ZN(
        mult_7_FS_1_n48) );
  AND2_X1 mult_7_FS_1_U4 ( .A1(mult_7_FS_1_n57), .A2(mult_7_FS_1_n23), .ZN(
        mult_7_FS_1_n3) );
  BUF_X1 mult_7_FS_1_U3 ( .A(mult_7_FS_1_n22), .Z(mult_7_FS_1_n1) );
  AND2_X1 mult_7_FS_1_U2 ( .A1(mult_7_FS_1_n27), .A2(mult_7_FS_1_n30), .ZN(N8)
         );
endmodule

