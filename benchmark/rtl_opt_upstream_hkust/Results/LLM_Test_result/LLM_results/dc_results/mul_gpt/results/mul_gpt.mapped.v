/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:30:20 2025
/////////////////////////////////////////////////////////////


module mul_gpt ( clk, a, b, z );
  input [7:0] a;
  input [7:0] b;
  output [7:0] z;
  input clk;
  wire   n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, mult_9_n73, mult_9_n72, mult_9_n71,
         mult_9_n70, mult_9_n69, mult_9_n68, mult_9_n67, mult_9_n66,
         mult_9_n65, mult_9_n64, mult_9_n63, mult_9_n62, mult_9_n61,
         mult_9_n60, mult_9_n59, mult_9_n58, mult_9_n57, mult_9_n56,
         mult_9_n55, mult_9_n54, mult_9_n53, mult_9_n52, mult_9_n51,
         mult_9_n50, mult_9_n49, mult_9_n48, mult_9_n47, mult_9_n46,
         mult_9_n45, mult_9_n44, mult_9_n43, mult_9_n42, mult_9_n41,
         mult_9_n40, mult_9_n39, mult_9_n38, mult_9_n37, mult_9_n36,
         mult_9_n35, mult_9_n34, mult_9_n33, mult_9_n32, mult_9_n31,
         mult_9_n30, mult_9_n29, mult_9_n28, mult_9_n27, mult_9_n26,
         mult_9_n25, mult_9_n24, mult_9_n23, mult_9_n22, mult_9_n21,
         mult_9_n20, mult_9_n19, mult_9_n18, mult_9_n17, mult_9_n16,
         mult_9_n15, mult_9_n14, mult_9_n13, mult_9_n12, mult_9_n11,
         mult_9_n10, mult_9_n9, mult_9_n8, mult_9_n7, mult_9_n6, mult_9_n5,
         mult_9_n4, mult_9_n3, mult_9_n2, mult_9_A2_6_, mult_9_A1_0_,
         mult_9_A1_1_, mult_9_A1_2_, mult_9_A1_3_, mult_9_A1_4_, mult_9_A1_5_,
         mult_9_A1_13_, mult_9_SUMB_1__6_, mult_9_SUMB_2__1_,
         mult_9_SUMB_2__2_, mult_9_SUMB_2__3_, mult_9_SUMB_2__4_,
         mult_9_SUMB_2__5_, mult_9_SUMB_2__6_, mult_9_SUMB_3__1_,
         mult_9_SUMB_3__2_, mult_9_SUMB_3__3_, mult_9_SUMB_3__4_,
         mult_9_SUMB_3__5_, mult_9_SUMB_3__6_, mult_9_SUMB_4__1_,
         mult_9_SUMB_4__2_, mult_9_SUMB_4__3_, mult_9_SUMB_4__4_,
         mult_9_SUMB_4__5_, mult_9_SUMB_4__6_, mult_9_SUMB_5__1_,
         mult_9_SUMB_5__2_, mult_9_SUMB_5__3_, mult_9_SUMB_5__4_,
         mult_9_SUMB_5__5_, mult_9_SUMB_5__6_, mult_9_SUMB_6__1_,
         mult_9_SUMB_6__2_, mult_9_SUMB_6__3_, mult_9_SUMB_6__4_,
         mult_9_SUMB_6__5_, mult_9_SUMB_6__6_, mult_9_SUMB_7__0_,
         mult_9_SUMB_7__1_, mult_9_SUMB_7__2_, mult_9_SUMB_7__3_,
         mult_9_SUMB_7__4_, mult_9_SUMB_7__5_, mult_9_SUMB_7__6_,
         mult_9_SUMB_7__7_, mult_9_CARRYB_1__0_, mult_9_CARRYB_1__6_,
         mult_9_CARRYB_2__0_, mult_9_CARRYB_2__1_, mult_9_CARRYB_2__2_,
         mult_9_CARRYB_2__3_, mult_9_CARRYB_2__4_, mult_9_CARRYB_2__5_,
         mult_9_CARRYB_2__6_, mult_9_CARRYB_3__0_, mult_9_CARRYB_3__1_,
         mult_9_CARRYB_3__2_, mult_9_CARRYB_3__3_, mult_9_CARRYB_3__4_,
         mult_9_CARRYB_3__5_, mult_9_CARRYB_3__6_, mult_9_CARRYB_4__0_,
         mult_9_CARRYB_4__1_, mult_9_CARRYB_4__2_, mult_9_CARRYB_4__3_,
         mult_9_CARRYB_4__4_, mult_9_CARRYB_4__5_, mult_9_CARRYB_4__6_,
         mult_9_CARRYB_5__0_, mult_9_CARRYB_5__1_, mult_9_CARRYB_5__2_,
         mult_9_CARRYB_5__3_, mult_9_CARRYB_5__4_, mult_9_CARRYB_5__5_,
         mult_9_CARRYB_5__6_, mult_9_CARRYB_6__0_, mult_9_CARRYB_6__1_,
         mult_9_CARRYB_6__2_, mult_9_CARRYB_6__3_, mult_9_CARRYB_6__4_,
         mult_9_CARRYB_6__5_, mult_9_CARRYB_6__6_, mult_9_CARRYB_7__0_,
         mult_9_CARRYB_7__1_, mult_9_CARRYB_7__2_, mult_9_CARRYB_7__3_,
         mult_9_CARRYB_7__4_, mult_9_CARRYB_7__5_, mult_9_CARRYB_7__6_,
         mult_9_CARRYB_7__7_, mult_9_ab_0__2_, mult_9_ab_0__3_,
         mult_9_ab_0__4_, mult_9_ab_0__5_, mult_9_ab_0__6_, mult_9_ab_0__7_,
         mult_9_ab_1__2_, mult_9_ab_1__3_, mult_9_ab_1__4_, mult_9_ab_1__5_,
         mult_9_ab_1__6_, mult_9_ab_1__7_, mult_9_ab_2__0_, mult_9_ab_2__1_,
         mult_9_ab_2__2_, mult_9_ab_2__3_, mult_9_ab_2__4_, mult_9_ab_2__5_,
         mult_9_ab_2__6_, mult_9_ab_2__7_, mult_9_ab_3__0_, mult_9_ab_3__1_,
         mult_9_ab_3__2_, mult_9_ab_3__3_, mult_9_ab_3__4_, mult_9_ab_3__5_,
         mult_9_ab_3__6_, mult_9_ab_3__7_, mult_9_ab_4__0_, mult_9_ab_4__1_,
         mult_9_ab_4__2_, mult_9_ab_4__3_, mult_9_ab_4__4_, mult_9_ab_4__5_,
         mult_9_ab_4__6_, mult_9_ab_4__7_, mult_9_ab_5__0_, mult_9_ab_5__1_,
         mult_9_ab_5__2_, mult_9_ab_5__3_, mult_9_ab_5__4_, mult_9_ab_5__5_,
         mult_9_ab_5__6_, mult_9_ab_5__7_, mult_9_ab_6__0_, mult_9_ab_6__1_,
         mult_9_ab_6__2_, mult_9_ab_6__3_, mult_9_ab_6__4_, mult_9_ab_6__5_,
         mult_9_ab_6__6_, mult_9_ab_6__7_, mult_9_ab_7__0_, mult_9_ab_7__1_,
         mult_9_ab_7__2_, mult_9_ab_7__3_, mult_9_ab_7__4_, mult_9_ab_7__5_,
         mult_9_ab_7__6_, mult_9_ab_7__7_, mult_9_FS_1_n79, mult_9_FS_1_n78,
         mult_9_FS_1_n77, mult_9_FS_1_n76, mult_9_FS_1_n75, mult_9_FS_1_n74,
         mult_9_FS_1_n73, mult_9_FS_1_n72, mult_9_FS_1_n71, mult_9_FS_1_n70,
         mult_9_FS_1_n69, mult_9_FS_1_n68, mult_9_FS_1_n67, mult_9_FS_1_n66,
         mult_9_FS_1_n65, mult_9_FS_1_n64, mult_9_FS_1_n63, mult_9_FS_1_n62,
         mult_9_FS_1_n61, mult_9_FS_1_n60, mult_9_FS_1_n59, mult_9_FS_1_n58,
         mult_9_FS_1_n57, mult_9_FS_1_n56, mult_9_FS_1_n55, mult_9_FS_1_n54,
         mult_9_FS_1_n53, mult_9_FS_1_n52, mult_9_FS_1_n51, mult_9_FS_1_n50,
         mult_9_FS_1_n49, mult_9_FS_1_n48, mult_9_FS_1_n47, mult_9_FS_1_n46,
         mult_9_FS_1_n45, mult_9_FS_1_n44, mult_9_FS_1_n43, mult_9_FS_1_n42,
         mult_9_FS_1_n41, mult_9_FS_1_n40, mult_9_FS_1_n39, mult_9_FS_1_n38,
         mult_9_FS_1_n37, mult_9_FS_1_n36, mult_9_FS_1_n35, mult_9_FS_1_n34,
         mult_9_FS_1_n33, mult_9_FS_1_n32, mult_9_FS_1_n31, mult_9_FS_1_n30,
         mult_9_FS_1_n29, mult_9_FS_1_n28, mult_9_FS_1_n27, mult_9_FS_1_n26,
         mult_9_FS_1_n25, mult_9_FS_1_n24, mult_9_FS_1_n23, mult_9_FS_1_n22,
         mult_9_FS_1_n21, mult_9_FS_1_n20, mult_9_FS_1_n19, mult_9_FS_1_n18,
         mult_9_FS_1_n17, mult_9_FS_1_n15, mult_9_FS_1_n14, mult_9_FS_1_n13,
         mult_9_FS_1_n12, mult_9_FS_1_n11, mult_9_FS_1_n10, mult_9_FS_1_n9,
         mult_9_FS_1_n8, mult_9_FS_1_n7, mult_9_FS_1_n6, mult_9_FS_1_n5,
         mult_9_FS_1_n4, mult_9_FS_1_n3, mult_9_FS_1_n1;
  wire   [15:7] product;
  wire   [15:8] adjusted;

  DFF_X1 z_reg_2_ ( .D(adjusted[10]), .CK(clk), .Q(z[2]) );
  DFF_X1 z_reg_1_ ( .D(adjusted[9]), .CK(clk), .Q(z[1]) );
  DFF_X1 z_reg_0_ ( .D(adjusted[8]), .CK(clk), .Q(z[0]) );
  DFF_X1 z_reg_3_ ( .D(adjusted[11]), .CK(clk), .Q(z[3]) );
  DFF_X1 z_reg_4_ ( .D(adjusted[12]), .CK(clk), .Q(z[4]) );
  DFF_X1 z_reg_7_ ( .D(adjusted[15]), .CK(clk), .Q(z[7]) );
  DFF_X1 z_reg_6_ ( .D(adjusted[14]), .CK(clk), .Q(z[6]) );
  DFF_X1 z_reg_5_ ( .D(adjusted[13]), .CK(clk), .Q(z[5]) );
  XNOR2_X1 U4 ( .A(product[8]), .B(n13), .ZN(adjusted[8]) );
  BUF_X1 U5 ( .A(n11), .Z(n2) );
  XNOR2_X1 U6 ( .A(n15), .B(n2), .ZN(adjusted[10]) );
  AND3_X1 U7 ( .A1(product[10]), .A2(n11), .A3(product[11]), .ZN(n3) );
  CLKBUF_X1 U8 ( .A(product[13]), .Z(n4) );
  CLKBUF_X1 U9 ( .A(product[9]), .Z(n5) );
  CLKBUF_X1 U10 ( .A(product[11]), .Z(n6) );
  CLKBUF_X1 U11 ( .A(product[12]), .Z(n7) );
  AND3_X1 U12 ( .A1(product[10]), .A2(n11), .A3(product[11]), .ZN(n8) );
  CLKBUF_X1 U13 ( .A(product[14]), .Z(n9) );
  NAND3_X1 U14 ( .A1(n5), .A2(product[7]), .A3(product[8]), .ZN(n10) );
  AND3_X2 U15 ( .A1(product[9]), .A2(product[7]), .A3(product[8]), .ZN(n11) );
  XNOR2_X1 U16 ( .A(n23), .B(product[15]), .ZN(adjusted[15]) );
  AND2_X1 U17 ( .A1(product[10]), .A2(product[11]), .ZN(n21) );
  NAND4_X1 U18 ( .A1(n22), .A2(n21), .A3(product[12]), .A4(product[13]), .ZN(
        n23) );
  AND2_X1 U19 ( .A1(product[14]), .A2(n11), .ZN(n22) );
  XNOR2_X1 U20 ( .A(n20), .B(n9), .ZN(adjusted[14]) );
  INV_X1 U21 ( .A(product[7]), .ZN(n13) );
  INV_X1 U22 ( .A(product[8]), .ZN(n12) );
  NOR2_X1 U23 ( .A1(n13), .A2(n12), .ZN(n14) );
  XOR2_X1 U24 ( .A(n5), .B(n14), .Z(adjusted[9]) );
  INV_X1 U25 ( .A(product[10]), .ZN(n15) );
  NOR2_X1 U26 ( .A1(n15), .A2(n10), .ZN(n16) );
  XOR2_X1 U27 ( .A(n16), .B(n6), .Z(adjusted[11]) );
  NAND3_X1 U28 ( .A1(product[10]), .A2(n11), .A3(product[11]), .ZN(n19) );
  XOR2_X1 U29 ( .A(n7), .B(n3), .Z(adjusted[12]) );
  INV_X1 U30 ( .A(product[12]), .ZN(n17) );
  NOR2_X1 U31 ( .A1(n17), .A2(n19), .ZN(n18) );
  XOR2_X1 U32 ( .A(n4), .B(n18), .Z(adjusted[13]) );
  NAND3_X1 U33 ( .A1(n8), .A2(product[12]), .A3(product[13]), .ZN(n20) );
  INV_X1 mult_9_U145 ( .A(mult_9_CARRYB_7__7_), .ZN(mult_9_A1_13_) );
  NOR2_X1 mult_9_U144 ( .A1(b[0]), .A2(mult_9_n72), .ZN(mult_9_ab_7__0_) );
  NOR2_X1 mult_9_U143 ( .A1(b[1]), .A2(mult_9_n72), .ZN(mult_9_ab_7__1_) );
  NOR2_X1 mult_9_U142 ( .A1(b[2]), .A2(mult_9_n72), .ZN(mult_9_ab_7__2_) );
  NOR2_X1 mult_9_U141 ( .A1(b[3]), .A2(mult_9_n72), .ZN(mult_9_ab_7__3_) );
  NOR2_X1 mult_9_U140 ( .A1(b[4]), .A2(mult_9_n72), .ZN(mult_9_ab_7__4_) );
  NOR2_X1 mult_9_U139 ( .A1(b[5]), .A2(mult_9_n72), .ZN(mult_9_ab_7__5_) );
  NOR2_X1 mult_9_U138 ( .A1(a[6]), .A2(mult_9_n39), .ZN(mult_9_ab_6__7_) );
  NOR2_X1 mult_9_U137 ( .A1(b[6]), .A2(mult_9_n72), .ZN(mult_9_ab_7__6_) );
  NOR2_X1 mult_9_U136 ( .A1(mult_9_n38), .A2(mult_9_n72), .ZN(mult_9_ab_7__7_)
         );
  NOR2_X1 mult_9_U135 ( .A1(mult_9_n70), .A2(mult_9_n69), .ZN(mult_9_ab_6__0_)
         );
  NOR2_X1 mult_9_U134 ( .A1(mult_9_n69), .A2(mult_9_n68), .ZN(mult_9_ab_6__1_)
         );
  NOR2_X1 mult_9_U133 ( .A1(mult_9_n69), .A2(mult_9_n67), .ZN(mult_9_ab_6__2_)
         );
  NOR2_X1 mult_9_U132 ( .A1(mult_9_n69), .A2(mult_9_n66), .ZN(mult_9_ab_6__3_)
         );
  NOR2_X1 mult_9_U131 ( .A1(mult_9_n69), .A2(mult_9_n9), .ZN(mult_9_ab_6__4_)
         );
  NOR2_X1 mult_9_U130 ( .A1(mult_9_n69), .A2(mult_9_n64), .ZN(mult_9_ab_6__5_)
         );
  NOR2_X1 mult_9_U129 ( .A1(a[5]), .A2(mult_9_n38), .ZN(mult_9_ab_5__7_) );
  NOR2_X1 mult_9_U128 ( .A1(mult_9_n69), .A2(mult_9_n63), .ZN(mult_9_ab_6__6_)
         );
  INV_X1 mult_9_U127 ( .A(a[6]), .ZN(mult_9_n69) );
  NOR2_X1 mult_9_U126 ( .A1(mult_9_n70), .A2(mult_9_n62), .ZN(mult_9_ab_5__0_)
         );
  NOR2_X1 mult_9_U125 ( .A1(mult_9_n68), .A2(mult_9_n62), .ZN(mult_9_ab_5__1_)
         );
  NOR2_X1 mult_9_U124 ( .A1(mult_9_n67), .A2(mult_9_n62), .ZN(mult_9_ab_5__2_)
         );
  NOR2_X1 mult_9_U123 ( .A1(mult_9_n66), .A2(mult_9_n62), .ZN(mult_9_ab_5__3_)
         );
  NOR2_X1 mult_9_U122 ( .A1(mult_9_n9), .A2(mult_9_n62), .ZN(mult_9_ab_5__4_)
         );
  NOR2_X1 mult_9_U121 ( .A1(mult_9_n64), .A2(mult_9_n62), .ZN(mult_9_ab_5__5_)
         );
  NOR2_X1 mult_9_U120 ( .A1(a[4]), .A2(mult_9_n39), .ZN(mult_9_ab_4__7_) );
  NOR2_X1 mult_9_U119 ( .A1(mult_9_n63), .A2(mult_9_n62), .ZN(mult_9_ab_5__6_)
         );
  INV_X1 mult_9_U118 ( .A(a[5]), .ZN(mult_9_n62) );
  NOR2_X1 mult_9_U117 ( .A1(mult_9_n70), .A2(mult_9_n61), .ZN(mult_9_ab_4__0_)
         );
  NOR2_X1 mult_9_U116 ( .A1(mult_9_n68), .A2(mult_9_n61), .ZN(mult_9_ab_4__1_)
         );
  NOR2_X1 mult_9_U115 ( .A1(mult_9_n67), .A2(mult_9_n61), .ZN(mult_9_ab_4__2_)
         );
  NOR2_X1 mult_9_U114 ( .A1(mult_9_n66), .A2(mult_9_n61), .ZN(mult_9_ab_4__3_)
         );
  NOR2_X1 mult_9_U113 ( .A1(mult_9_n9), .A2(mult_9_n61), .ZN(mult_9_ab_4__4_)
         );
  NOR2_X1 mult_9_U112 ( .A1(mult_9_n64), .A2(mult_9_n61), .ZN(mult_9_ab_4__5_)
         );
  NOR2_X1 mult_9_U111 ( .A1(a[3]), .A2(mult_9_n38), .ZN(mult_9_ab_3__7_) );
  NOR2_X1 mult_9_U110 ( .A1(mult_9_n63), .A2(mult_9_n61), .ZN(mult_9_ab_4__6_)
         );
  INV_X1 mult_9_U109 ( .A(a[4]), .ZN(mult_9_n61) );
  NOR2_X1 mult_9_U108 ( .A1(mult_9_n70), .A2(mult_9_n60), .ZN(mult_9_ab_3__0_)
         );
  NOR2_X1 mult_9_U107 ( .A1(mult_9_n68), .A2(mult_9_n60), .ZN(mult_9_ab_3__1_)
         );
  NOR2_X1 mult_9_U106 ( .A1(mult_9_n67), .A2(mult_9_n60), .ZN(mult_9_ab_3__2_)
         );
  NOR2_X1 mult_9_U105 ( .A1(mult_9_n66), .A2(mult_9_n60), .ZN(mult_9_ab_3__3_)
         );
  NOR2_X1 mult_9_U104 ( .A1(mult_9_n9), .A2(mult_9_n60), .ZN(mult_9_ab_3__4_)
         );
  NOR2_X1 mult_9_U103 ( .A1(mult_9_n64), .A2(mult_9_n60), .ZN(mult_9_ab_3__5_)
         );
  NOR2_X1 mult_9_U102 ( .A1(a[2]), .A2(mult_9_n39), .ZN(mult_9_ab_2__7_) );
  NOR2_X1 mult_9_U101 ( .A1(mult_9_n63), .A2(mult_9_n60), .ZN(mult_9_ab_3__6_)
         );
  INV_X1 mult_9_U100 ( .A(a[3]), .ZN(mult_9_n60) );
  NOR3_X1 mult_9_U99 ( .A1(mult_9_n59), .A2(mult_9_n70), .A3(mult_9_n58), .ZN(
        mult_9_CARRYB_1__0_) );
  NOR2_X1 mult_9_U98 ( .A1(mult_9_n70), .A2(mult_9_n57), .ZN(mult_9_ab_2__0_)
         );
  INV_X1 mult_9_U97 ( .A(b[0]), .ZN(mult_9_n70) );
  NOR2_X1 mult_9_U96 ( .A1(mult_9_n68), .A2(mult_9_n57), .ZN(mult_9_ab_2__1_)
         );
  INV_X1 mult_9_U95 ( .A(b[1]), .ZN(mult_9_n68) );
  NOR2_X1 mult_9_U94 ( .A1(mult_9_n67), .A2(mult_9_n57), .ZN(mult_9_ab_2__2_)
         );
  NOR2_X1 mult_9_U93 ( .A1(mult_9_n66), .A2(mult_9_n57), .ZN(mult_9_ab_2__3_)
         );
  NOR2_X1 mult_9_U92 ( .A1(mult_9_n65), .A2(mult_9_n57), .ZN(mult_9_ab_2__4_)
         );
  NOR2_X1 mult_9_U91 ( .A1(mult_9_n64), .A2(mult_9_n57), .ZN(mult_9_ab_2__5_)
         );
  NOR2_X1 mult_9_U90 ( .A1(mult_9_n7), .A2(mult_9_n38), .ZN(mult_9_ab_1__7_)
         );
  INV_X1 mult_9_U89 ( .A(mult_9_n59), .ZN(mult_9_n71) );
  NAND2_X1 mult_9_U88 ( .A1(mult_9_n7), .A2(b[1]), .ZN(mult_9_n59) );
  NOR2_X1 mult_9_U87 ( .A1(mult_9_n67), .A2(mult_9_n58), .ZN(mult_9_ab_0__2_)
         );
  NOR2_X1 mult_9_U86 ( .A1(mult_9_n67), .A2(mult_9_n56), .ZN(mult_9_ab_1__2_)
         );
  INV_X1 mult_9_U85 ( .A(b[2]), .ZN(mult_9_n67) );
  NOR2_X1 mult_9_U84 ( .A1(mult_9_n66), .A2(mult_9_n58), .ZN(mult_9_ab_0__3_)
         );
  NOR2_X1 mult_9_U83 ( .A1(mult_9_n66), .A2(mult_9_n56), .ZN(mult_9_ab_1__3_)
         );
  NOR2_X1 mult_9_U82 ( .A1(mult_9_n65), .A2(mult_9_n58), .ZN(mult_9_ab_0__4_)
         );
  NOR2_X1 mult_9_U81 ( .A1(mult_9_n65), .A2(mult_9_n56), .ZN(mult_9_ab_1__4_)
         );
  INV_X1 mult_9_U80 ( .A(a[0]), .ZN(mult_9_n58) );
  INV_X1 mult_9_U79 ( .A(a[1]), .ZN(mult_9_n56) );
  NOR2_X1 mult_9_U78 ( .A1(mult_9_n73), .A2(a[0]), .ZN(mult_9_ab_0__7_) );
  INV_X2 mult_9_U77 ( .A(a[7]), .ZN(mult_9_n72) );
  INV_X1 mult_9_U76 ( .A(mult_9_n38), .ZN(mult_9_n55) );
  AND2_X1 mult_9_U75 ( .A1(mult_9_CARRYB_7__6_), .A2(mult_9_SUMB_7__7_), .ZN(
        mult_9_n54) );
  XOR2_X1 mult_9_U74 ( .A(mult_9_CARRYB_7__6_), .B(mult_9_SUMB_7__7_), .Z(
        mult_9_n53) );
  AND2_X1 mult_9_U73 ( .A1(mult_9_CARRYB_7__5_), .A2(mult_9_SUMB_7__6_), .ZN(
        mult_9_n52) );
  AND2_X1 mult_9_U72 ( .A1(mult_9_CARRYB_7__4_), .A2(mult_9_SUMB_7__5_), .ZN(
        mult_9_n51) );
  XOR2_X1 mult_9_U71 ( .A(mult_9_CARRYB_7__5_), .B(mult_9_SUMB_7__6_), .Z(
        mult_9_n50) );
  AND2_X1 mult_9_U70 ( .A1(mult_9_CARRYB_7__1_), .A2(mult_9_SUMB_7__2_), .ZN(
        mult_9_n49) );
  AND2_X1 mult_9_U69 ( .A1(mult_9_CARRYB_7__2_), .A2(mult_9_SUMB_7__3_), .ZN(
        mult_9_n48) );
  XOR2_X1 mult_9_U68 ( .A(mult_9_CARRYB_7__4_), .B(mult_9_SUMB_7__5_), .Z(
        mult_9_n47) );
  AND2_X1 mult_9_U67 ( .A1(mult_9_CARRYB_7__3_), .A2(mult_9_SUMB_7__4_), .ZN(
        mult_9_n46) );
  XOR2_X1 mult_9_U66 ( .A(mult_9_SUMB_7__3_), .B(mult_9_CARRYB_7__2_), .Z(
        mult_9_n45) );
  XOR2_X1 mult_9_U65 ( .A(mult_9_SUMB_7__4_), .B(mult_9_CARRYB_7__3_), .Z(
        mult_9_n44) );
  XOR2_X1 mult_9_U64 ( .A(mult_9_CARRYB_7__0_), .B(mult_9_SUMB_7__1_), .Z(
        mult_9_n43) );
  AND2_X1 mult_9_U63 ( .A1(mult_9_ab_0__6_), .A2(mult_9_ab_1__5_), .ZN(
        mult_9_n42) );
  XOR2_X1 mult_9_U62 ( .A(mult_9_CARRYB_7__1_), .B(mult_9_SUMB_7__2_), .Z(
        mult_9_n41) );
  XOR2_X1 mult_9_U61 ( .A(mult_9_n71), .B(mult_9_ab_0__2_), .Z(mult_9_n40) );
  INV_X1 mult_9_U60 ( .A(b[7]), .ZN(mult_9_n73) );
  INV_X1 mult_9_U59 ( .A(mult_9_n27), .ZN(mult_9_n39) );
  INV_X1 mult_9_U58 ( .A(b[6]), .ZN(mult_9_n63) );
  AND2_X1 mult_9_U57 ( .A1(b[6]), .A2(a[1]), .ZN(mult_9_ab_1__6_) );
  NAND3_X1 mult_9_U56 ( .A1(mult_9_n34), .A2(mult_9_n35), .A3(mult_9_n36), 
        .ZN(mult_9_CARRYB_2__5_) );
  NAND2_X1 mult_9_U55 ( .A1(mult_9_n42), .A2(mult_9_ab_2__5_), .ZN(mult_9_n36)
         );
  NAND2_X1 mult_9_U54 ( .A1(mult_9_SUMB_1__6_), .A2(mult_9_ab_2__5_), .ZN(
        mult_9_n35) );
  NAND2_X1 mult_9_U53 ( .A1(mult_9_SUMB_1__6_), .A2(mult_9_n42), .ZN(
        mult_9_n34) );
  XNOR2_X1 mult_9_U52 ( .A(mult_9_n42), .B(mult_9_ab_2__5_), .ZN(mult_9_n33)
         );
  XNOR2_X1 mult_9_U51 ( .A(mult_9_SUMB_1__6_), .B(mult_9_n33), .ZN(
        mult_9_SUMB_2__5_) );
  NAND3_X1 mult_9_U50 ( .A1(mult_9_n30), .A2(mult_9_n31), .A3(mult_9_n32), 
        .ZN(mult_9_CARRYB_2__6_) );
  NAND2_X1 mult_9_U49 ( .A1(mult_9_ab_2__6_), .A2(mult_9_n25), .ZN(mult_9_n32)
         );
  NAND2_X1 mult_9_U48 ( .A1(mult_9_CARRYB_1__6_), .A2(mult_9_n25), .ZN(
        mult_9_n31) );
  NAND2_X1 mult_9_U47 ( .A1(mult_9_CARRYB_1__6_), .A2(mult_9_ab_2__6_), .ZN(
        mult_9_n30) );
  XOR2_X1 mult_9_U46 ( .A(mult_9_CARRYB_1__6_), .B(mult_9_n29), .Z(
        mult_9_SUMB_2__6_) );
  XOR2_X1 mult_9_U45 ( .A(mult_9_ab_2__6_), .B(mult_9_ab_1__7_), .Z(mult_9_n29) );
  AND2_X2 mult_9_U44 ( .A1(b[6]), .A2(a[0]), .ZN(mult_9_ab_0__6_) );
  XOR2_X1 mult_9_U43 ( .A(mult_9_ab_1__4_), .B(mult_9_ab_0__5_), .Z(mult_9_n28) );
  INV_X1 mult_9_U42 ( .A(mult_9_n38), .ZN(mult_9_n27) );
  INV_X1 mult_9_U41 ( .A(a[2]), .ZN(mult_9_n57) );
  AND2_X2 mult_9_U40 ( .A1(b[6]), .A2(a[2]), .ZN(mult_9_ab_2__6_) );
  AND2_X1 mult_9_U39 ( .A1(mult_9_ab_0__5_), .A2(mult_9_ab_1__4_), .ZN(
        mult_9_n26) );
  INV_X2 mult_9_U38 ( .A(b[7]), .ZN(mult_9_n38) );
  NOR2_X1 mult_9_U37 ( .A1(mult_9_n7), .A2(mult_9_n38), .ZN(mult_9_n25) );
  NAND2_X1 mult_9_U36 ( .A1(mult_9_n55), .A2(a[7]), .ZN(mult_9_n24) );
  NAND2_X1 mult_9_U35 ( .A1(mult_9_SUMB_7__0_), .A2(a[7]), .ZN(mult_9_n23) );
  NAND2_X1 mult_9_U34 ( .A1(mult_9_SUMB_7__0_), .A2(mult_9_n55), .ZN(
        mult_9_n22) );
  XOR2_X1 mult_9_U33 ( .A(mult_9_n10), .B(mult_9_n21), .Z(mult_9_A1_5_) );
  XOR2_X1 mult_9_U32 ( .A(mult_9_n55), .B(a[7]), .Z(mult_9_n21) );
  NAND3_X1 mult_9_U31 ( .A1(mult_9_n18), .A2(mult_9_n19), .A3(mult_9_n20), 
        .ZN(mult_9_CARRYB_3__6_) );
  NAND2_X1 mult_9_U30 ( .A1(mult_9_ab_2__7_), .A2(mult_9_ab_3__6_), .ZN(
        mult_9_n20) );
  NAND2_X1 mult_9_U29 ( .A1(mult_9_CARRYB_2__6_), .A2(mult_9_ab_3__6_), .ZN(
        mult_9_n19) );
  NAND2_X1 mult_9_U28 ( .A1(mult_9_CARRYB_2__6_), .A2(mult_9_ab_2__7_), .ZN(
        mult_9_n18) );
  XOR2_X1 mult_9_U27 ( .A(mult_9_CARRYB_2__6_), .B(mult_9_n17), .Z(
        mult_9_SUMB_3__6_) );
  XOR2_X1 mult_9_U26 ( .A(mult_9_ab_2__7_), .B(mult_9_ab_3__6_), .Z(mult_9_n17) );
  XOR2_X1 mult_9_U25 ( .A(mult_9_ab_1__3_), .B(mult_9_ab_0__4_), .Z(mult_9_n16) );
  NAND3_X1 mult_9_U24 ( .A1(mult_9_n22), .A2(mult_9_n23), .A3(mult_9_n24), 
        .ZN(mult_9_A2_6_) );
  NAND3_X1 mult_9_U23 ( .A1(mult_9_n13), .A2(mult_9_n14), .A3(mult_9_n15), 
        .ZN(mult_9_CARRYB_4__4_) );
  NAND2_X1 mult_9_U22 ( .A1(mult_9_n11), .A2(mult_9_ab_4__4_), .ZN(mult_9_n15)
         );
  NAND2_X1 mult_9_U21 ( .A1(mult_9_SUMB_3__5_), .A2(mult_9_ab_4__4_), .ZN(
        mult_9_n14) );
  NAND2_X1 mult_9_U20 ( .A1(mult_9_SUMB_3__5_), .A2(mult_9_n11), .ZN(
        mult_9_n13) );
  XOR2_X1 mult_9_U19 ( .A(mult_9_n12), .B(mult_9_SUMB_3__5_), .Z(
        mult_9_SUMB_4__4_) );
  XOR2_X1 mult_9_U18 ( .A(mult_9_CARRYB_3__4_), .B(mult_9_ab_4__4_), .Z(
        mult_9_n12) );
  AND2_X1 mult_9_U17 ( .A1(b[5]), .A2(a[1]), .ZN(mult_9_ab_1__5_) );
  CLKBUF_X1 mult_9_U16 ( .A(mult_9_CARRYB_3__4_), .Z(mult_9_n11) );
  CLKBUF_X1 mult_9_U15 ( .A(mult_9_SUMB_7__0_), .Z(mult_9_n10) );
  INV_X1 mult_9_U14 ( .A(b[4]), .ZN(mult_9_n65) );
  INV_X1 mult_9_U13 ( .A(b[4]), .ZN(mult_9_n9) );
  INV_X1 mult_9_U12 ( .A(b[5]), .ZN(mult_9_n64) );
  AND2_X1 mult_9_U11 ( .A1(b[5]), .A2(a[0]), .ZN(mult_9_ab_0__5_) );
  BUF_X2 mult_9_U10 ( .A(a[1]), .Z(mult_9_n7) );
  INV_X2 mult_9_U9 ( .A(b[3]), .ZN(mult_9_n66) );
  AND2_X2 mult_9_U8 ( .A1(mult_9_n8), .A2(mult_9_CARRYB_7__0_), .ZN(mult_9_n37) );
  CLKBUF_X1 mult_9_U7 ( .A(mult_9_SUMB_7__1_), .Z(mult_9_n8) );
  AND2_X1 mult_9_U6 ( .A1(mult_9_ab_0__2_), .A2(mult_9_n71), .ZN(mult_9_n6) );
  AND2_X1 mult_9_U5 ( .A1(mult_9_ab_0__3_), .A2(mult_9_ab_1__2_), .ZN(
        mult_9_n5) );
  XOR2_X1 mult_9_U4 ( .A(mult_9_ab_1__5_), .B(mult_9_ab_0__6_), .Z(mult_9_n4)
         );
  AND2_X1 mult_9_U3 ( .A1(mult_9_ab_0__4_), .A2(mult_9_ab_1__3_), .ZN(
        mult_9_n3) );
  XOR2_X1 mult_9_U2 ( .A(mult_9_ab_1__2_), .B(mult_9_ab_0__3_), .Z(mult_9_n2)
         );
  FA_X1 mult_9_S0_6 ( .A(mult_9_ab_1__6_), .B(1'b0), .CI(mult_9_ab_0__7_), 
        .CO(mult_9_CARRYB_1__6_), .S(mult_9_SUMB_1__6_) );
  FA_X1 mult_9_S2_2_4 ( .A(mult_9_ab_2__4_), .B(mult_9_n26), .CI(mult_9_n4), 
        .CO(mult_9_CARRYB_2__4_), .S(mult_9_SUMB_2__4_) );
  FA_X1 mult_9_S2_2_3 ( .A(mult_9_ab_2__3_), .B(mult_9_n3), .CI(mult_9_n28), 
        .CO(mult_9_CARRYB_2__3_), .S(mult_9_SUMB_2__3_) );
  FA_X1 mult_9_S2_2_2 ( .A(mult_9_ab_2__2_), .B(mult_9_n5), .CI(mult_9_n16), 
        .CO(mult_9_CARRYB_2__2_), .S(mult_9_SUMB_2__2_) );
  FA_X1 mult_9_S2_2_1 ( .A(mult_9_ab_2__1_), .B(mult_9_n6), .CI(mult_9_n2), 
        .CO(mult_9_CARRYB_2__1_), .S(mult_9_SUMB_2__1_) );
  FA_X1 mult_9_S1_2_0 ( .A(mult_9_ab_2__0_), .B(mult_9_CARRYB_1__0_), .CI(
        mult_9_n40), .CO(mult_9_CARRYB_2__0_), .S(mult_9_A1_0_) );
  FA_X1 mult_9_S2_3_5 ( .A(mult_9_ab_3__5_), .B(mult_9_SUMB_2__6_), .CI(
        mult_9_CARRYB_2__5_), .CO(mult_9_CARRYB_3__5_), .S(mult_9_SUMB_3__5_)
         );
  FA_X1 mult_9_S2_3_4 ( .A(mult_9_CARRYB_2__4_), .B(mult_9_ab_3__4_), .CI(
        mult_9_SUMB_2__5_), .CO(mult_9_CARRYB_3__4_), .S(mult_9_SUMB_3__4_) );
  FA_X1 mult_9_S2_3_3 ( .A(mult_9_ab_3__3_), .B(mult_9_CARRYB_2__3_), .CI(
        mult_9_SUMB_2__4_), .CO(mult_9_CARRYB_3__3_), .S(mult_9_SUMB_3__3_) );
  FA_X1 mult_9_S2_3_2 ( .A(mult_9_ab_3__2_), .B(mult_9_CARRYB_2__2_), .CI(
        mult_9_SUMB_2__3_), .CO(mult_9_CARRYB_3__2_), .S(mult_9_SUMB_3__2_) );
  FA_X1 mult_9_S2_3_1 ( .A(mult_9_ab_3__1_), .B(mult_9_CARRYB_2__1_), .CI(
        mult_9_SUMB_2__2_), .CO(mult_9_CARRYB_3__1_), .S(mult_9_SUMB_3__1_) );
  FA_X1 mult_9_S1_3_0 ( .A(mult_9_ab_3__0_), .B(mult_9_CARRYB_2__0_), .CI(
        mult_9_SUMB_2__1_), .CO(mult_9_CARRYB_3__0_), .S(mult_9_A1_1_) );
  FA_X1 mult_9_S3_4_6 ( .A(mult_9_ab_4__6_), .B(mult_9_CARRYB_3__6_), .CI(
        mult_9_ab_3__7_), .CO(mult_9_CARRYB_4__6_), .S(mult_9_SUMB_4__6_) );
  FA_X1 mult_9_S2_4_5 ( .A(mult_9_ab_4__5_), .B(mult_9_CARRYB_3__5_), .CI(
        mult_9_SUMB_3__6_), .CO(mult_9_CARRYB_4__5_), .S(mult_9_SUMB_4__5_) );
  FA_X1 mult_9_S2_4_3 ( .A(mult_9_CARRYB_3__3_), .B(mult_9_ab_4__3_), .CI(
        mult_9_SUMB_3__4_), .CO(mult_9_CARRYB_4__3_), .S(mult_9_SUMB_4__3_) );
  FA_X1 mult_9_S2_4_2 ( .A(mult_9_CARRYB_3__2_), .B(mult_9_ab_4__2_), .CI(
        mult_9_SUMB_3__3_), .CO(mult_9_CARRYB_4__2_), .S(mult_9_SUMB_4__2_) );
  FA_X1 mult_9_S2_4_1 ( .A(mult_9_ab_4__1_), .B(mult_9_CARRYB_3__1_), .CI(
        mult_9_SUMB_3__2_), .CO(mult_9_CARRYB_4__1_), .S(mult_9_SUMB_4__1_) );
  FA_X1 mult_9_S1_4_0 ( .A(mult_9_ab_4__0_), .B(mult_9_CARRYB_3__0_), .CI(
        mult_9_SUMB_3__1_), .CO(mult_9_CARRYB_4__0_), .S(mult_9_A1_2_) );
  FA_X1 mult_9_S3_5_6 ( .A(mult_9_ab_5__6_), .B(mult_9_CARRYB_4__6_), .CI(
        mult_9_ab_4__7_), .CO(mult_9_CARRYB_5__6_), .S(mult_9_SUMB_5__6_) );
  FA_X1 mult_9_S2_5_5 ( .A(mult_9_ab_5__5_), .B(mult_9_CARRYB_4__5_), .CI(
        mult_9_SUMB_4__6_), .CO(mult_9_CARRYB_5__5_), .S(mult_9_SUMB_5__5_) );
  FA_X1 mult_9_S2_5_4 ( .A(mult_9_ab_5__4_), .B(mult_9_CARRYB_4__4_), .CI(
        mult_9_SUMB_4__5_), .CO(mult_9_CARRYB_5__4_), .S(mult_9_SUMB_5__4_) );
  FA_X1 mult_9_S2_5_3 ( .A(mult_9_ab_5__3_), .B(mult_9_CARRYB_4__3_), .CI(
        mult_9_SUMB_4__4_), .CO(mult_9_CARRYB_5__3_), .S(mult_9_SUMB_5__3_) );
  FA_X1 mult_9_S2_5_2 ( .A(mult_9_CARRYB_4__2_), .B(mult_9_ab_5__2_), .CI(
        mult_9_SUMB_4__3_), .CO(mult_9_CARRYB_5__2_), .S(mult_9_SUMB_5__2_) );
  FA_X1 mult_9_S2_5_1 ( .A(mult_9_ab_5__1_), .B(mult_9_CARRYB_4__1_), .CI(
        mult_9_SUMB_4__2_), .CO(mult_9_CARRYB_5__1_), .S(mult_9_SUMB_5__1_) );
  FA_X1 mult_9_S1_5_0 ( .A(mult_9_ab_5__0_), .B(mult_9_CARRYB_4__0_), .CI(
        mult_9_SUMB_4__1_), .CO(mult_9_CARRYB_5__0_), .S(mult_9_A1_3_) );
  FA_X1 mult_9_S3_6_6 ( .A(mult_9_ab_6__6_), .B(mult_9_CARRYB_5__6_), .CI(
        mult_9_ab_5__7_), .CO(mult_9_CARRYB_6__6_), .S(mult_9_SUMB_6__6_) );
  FA_X1 mult_9_S2_6_5 ( .A(mult_9_ab_6__5_), .B(mult_9_CARRYB_5__5_), .CI(
        mult_9_SUMB_5__6_), .CO(mult_9_CARRYB_6__5_), .S(mult_9_SUMB_6__5_) );
  FA_X1 mult_9_S2_6_4 ( .A(mult_9_ab_6__4_), .B(mult_9_CARRYB_5__4_), .CI(
        mult_9_SUMB_5__5_), .CO(mult_9_CARRYB_6__4_), .S(mult_9_SUMB_6__4_) );
  FA_X1 mult_9_S2_6_3 ( .A(mult_9_ab_6__3_), .B(mult_9_CARRYB_5__3_), .CI(
        mult_9_SUMB_5__4_), .CO(mult_9_CARRYB_6__3_), .S(mult_9_SUMB_6__3_) );
  FA_X1 mult_9_S2_6_2 ( .A(mult_9_ab_6__2_), .B(mult_9_CARRYB_5__2_), .CI(
        mult_9_SUMB_5__3_), .CO(mult_9_CARRYB_6__2_), .S(mult_9_SUMB_6__2_) );
  FA_X1 mult_9_S2_6_1 ( .A(mult_9_CARRYB_5__1_), .B(mult_9_ab_6__1_), .CI(
        mult_9_SUMB_5__2_), .CO(mult_9_CARRYB_6__1_), .S(mult_9_SUMB_6__1_) );
  FA_X1 mult_9_S1_6_0 ( .A(mult_9_CARRYB_5__0_), .B(mult_9_ab_6__0_), .CI(
        mult_9_SUMB_5__1_), .CO(mult_9_CARRYB_6__0_), .S(mult_9_A1_4_) );
  FA_X1 mult_9_S14_7 ( .A(mult_9_n72), .B(mult_9_n39), .CI(mult_9_ab_7__7_), 
        .CO(mult_9_CARRYB_7__7_), .S(mult_9_SUMB_7__7_) );
  FA_X1 mult_9_S5_6 ( .A(mult_9_ab_7__6_), .B(mult_9_CARRYB_6__6_), .CI(
        mult_9_ab_6__7_), .CO(mult_9_CARRYB_7__6_), .S(mult_9_SUMB_7__6_) );
  FA_X1 mult_9_S4_5 ( .A(mult_9_ab_7__5_), .B(mult_9_SUMB_6__6_), .CI(
        mult_9_CARRYB_6__5_), .CO(mult_9_CARRYB_7__5_), .S(mult_9_SUMB_7__5_)
         );
  FA_X1 mult_9_S4_4 ( .A(mult_9_ab_7__4_), .B(mult_9_CARRYB_6__4_), .CI(
        mult_9_SUMB_6__5_), .CO(mult_9_CARRYB_7__4_), .S(mult_9_SUMB_7__4_) );
  FA_X1 mult_9_S4_3 ( .A(mult_9_CARRYB_6__3_), .B(mult_9_ab_7__3_), .CI(
        mult_9_SUMB_6__4_), .CO(mult_9_CARRYB_7__3_), .S(mult_9_SUMB_7__3_) );
  FA_X1 mult_9_S4_2 ( .A(mult_9_ab_7__2_), .B(mult_9_CARRYB_6__2_), .CI(
        mult_9_SUMB_6__3_), .CO(mult_9_CARRYB_7__2_), .S(mult_9_SUMB_7__2_) );
  FA_X1 mult_9_S4_1 ( .A(mult_9_ab_7__1_), .B(mult_9_CARRYB_6__1_), .CI(
        mult_9_SUMB_6__2_), .CO(mult_9_CARRYB_7__1_), .S(mult_9_SUMB_7__1_) );
  FA_X1 mult_9_S4_0 ( .A(mult_9_CARRYB_6__0_), .B(mult_9_ab_7__0_), .CI(
        mult_9_SUMB_6__1_), .CO(mult_9_CARRYB_7__0_), .S(mult_9_SUMB_7__0_) );
  INV_X1 mult_9_FS_1_U87 ( .A(mult_9_FS_1_n41), .ZN(mult_9_FS_1_n30) );
  NAND3_X1 mult_9_FS_1_U86 ( .A1(mult_9_FS_1_n4), .A2(mult_9_n49), .A3(
        mult_9_FS_1_n5), .ZN(mult_9_FS_1_n78) );
  INV_X1 mult_9_FS_1_U85 ( .A(mult_9_FS_1_n57), .ZN(mult_9_FS_1_n75) );
  INV_X1 mult_9_FS_1_U84 ( .A(mult_9_FS_1_n73), .ZN(mult_9_FS_1_n69) );
  INV_X1 mult_9_FS_1_U83 ( .A(mult_9_FS_1_n59), .ZN(mult_9_FS_1_n56) );
  NAND3_X1 mult_9_FS_1_U82 ( .A1(mult_9_FS_1_n69), .A2(mult_9_FS_1_n59), .A3(
        mult_9_FS_1_n30), .ZN(mult_9_FS_1_n66) );
  NAND2_X1 mult_9_FS_1_U81 ( .A1(mult_9_FS_1_n66), .A2(mult_9_FS_1_n67), .ZN(
        mult_9_FS_1_n65) );
  INV_X1 mult_9_FS_1_U80 ( .A(mult_9_FS_1_n45), .ZN(mult_9_FS_1_n50) );
  INV_X1 mult_9_FS_1_U79 ( .A(mult_9_FS_1_n60), .ZN(mult_9_FS_1_n55) );
  INV_X1 mult_9_FS_1_U78 ( .A(mult_9_FS_1_n58), .ZN(mult_9_FS_1_n20) );
  NOR2_X1 mult_9_FS_1_U77 ( .A1(mult_9_FS_1_n55), .A2(mult_9_FS_1_n56), .ZN(
        mult_9_FS_1_n54) );
  INV_X1 mult_9_FS_1_U76 ( .A(mult_9_FS_1_n9), .ZN(mult_9_FS_1_n42) );
  INV_X1 mult_9_FS_1_U75 ( .A(mult_9_FS_1_n40), .ZN(mult_9_FS_1_n39) );
  INV_X1 mult_9_FS_1_U74 ( .A(mult_9_FS_1_n21), .ZN(mult_9_FS_1_n19) );
  INV_X1 mult_9_FS_1_U73 ( .A(mult_9_n43), .ZN(mult_9_FS_1_n72) );
  OAI211_X1 mult_9_FS_1_U72 ( .C1(mult_9_n41), .C2(mult_9_n37), .A(
        mult_9_A2_6_), .B(mult_9_n43), .ZN(mult_9_FS_1_n41) );
  NAND2_X1 mult_9_FS_1_U71 ( .A1(mult_9_FS_1_n10), .A2(mult_9_FS_1_n13), .ZN(
        mult_9_FS_1_n32) );
  XNOR2_X1 mult_9_FS_1_U70 ( .A(mult_9_FS_1_n46), .B(mult_9_FS_1_n47), .ZN(
        product[14]) );
  OAI21_X1 mult_9_FS_1_U69 ( .B1(mult_9_FS_1_n48), .B2(mult_9_FS_1_n40), .A(
        mult_9_FS_1_n49), .ZN(mult_9_FS_1_n46) );
  NAND2_X1 mult_9_FS_1_U68 ( .A1(mult_9_FS_1_n5), .A2(mult_9_FS_1_n24), .ZN(
        mult_9_FS_1_n73) );
  NAND2_X1 mult_9_FS_1_U67 ( .A1(mult_9_FS_1_n11), .A2(mult_9_FS_1_n24), .ZN(
        mult_9_FS_1_n23) );
  NAND4_X1 mult_9_FS_1_U66 ( .A1(mult_9_FS_1_n59), .A2(mult_9_FS_1_n60), .A3(
        mult_9_FS_1_n5), .A4(mult_9_FS_1_n24), .ZN(mult_9_FS_1_n40) );
  NAND2_X1 mult_9_FS_1_U65 ( .A1(mult_9_FS_1_n68), .A2(mult_9_FS_1_n69), .ZN(
        mult_9_FS_1_n67) );
  NAND2_X1 mult_9_FS_1_U64 ( .A1(mult_9_FS_1_n24), .A2(mult_9_FS_1_n6), .ZN(
        mult_9_FS_1_n29) );
  NAND2_X1 mult_9_FS_1_U63 ( .A1(mult_9_FS_1_n71), .A2(mult_9_FS_1_n72), .ZN(
        mult_9_FS_1_n28) );
  NOR2_X1 mult_9_FS_1_U62 ( .A1(mult_9_FS_1_n27), .A2(mult_9_FS_1_n20), .ZN(
        mult_9_FS_1_n52) );
  NOR2_X1 mult_9_FS_1_U61 ( .A1(mult_9_FS_1_n19), .A2(mult_9_FS_1_n20), .ZN(
        mult_9_FS_1_n18) );
  XNOR2_X2 mult_9_FS_1_U60 ( .A(mult_9_FS_1_n14), .B(mult_9_FS_1_n29), .ZN(
        product[10]) );
  AND2_X1 mult_9_FS_1_U59 ( .A1(mult_9_n43), .A2(mult_9_A2_6_), .ZN(
        mult_9_FS_1_n26) );
  XNOR2_X1 mult_9_FS_1_U58 ( .A(mult_9_FS_1_n17), .B(mult_9_FS_1_n18), .ZN(
        product[11]) );
  OAI21_X1 mult_9_FS_1_U57 ( .B1(mult_9_FS_1_n52), .B2(mult_9_FS_1_n53), .A(
        mult_9_FS_1_n54), .ZN(mult_9_FS_1_n51) );
  INV_X1 mult_9_FS_1_U56 ( .A(mult_9_A2_6_), .ZN(mult_9_FS_1_n71) );
  NAND2_X1 mult_9_FS_1_U55 ( .A1(mult_9_n52), .A2(mult_9_n53), .ZN(
        mult_9_FS_1_n44) );
  OR2_X1 mult_9_FS_1_U54 ( .A1(mult_9_n52), .A2(mult_9_n53), .ZN(
        mult_9_FS_1_n38) );
  NAND2_X1 mult_9_FS_1_U53 ( .A1(mult_9_n51), .A2(mult_9_n50), .ZN(
        mult_9_FS_1_n45) );
  NAND2_X1 mult_9_FS_1_U52 ( .A1(mult_9_n46), .A2(mult_9_n47), .ZN(
        mult_9_FS_1_n57) );
  NAND2_X1 mult_9_FS_1_U51 ( .A1(mult_9_n49), .A2(mult_9_n45), .ZN(
        mult_9_FS_1_n27) );
  OR2_X1 mult_9_FS_1_U50 ( .A1(mult_9_n51), .A2(mult_9_n50), .ZN(
        mult_9_FS_1_n60) );
  NAND2_X1 mult_9_FS_1_U49 ( .A1(mult_9_n48), .A2(mult_9_n44), .ZN(
        mult_9_FS_1_n21) );
  NAND2_X1 mult_9_FS_1_U48 ( .A1(mult_9_FS_1_n41), .A2(mult_9_FS_1_n31), .ZN(
        mult_9_FS_1_n61) );
  AND2_X1 mult_9_FS_1_U47 ( .A1(mult_9_FS_1_n25), .A2(mult_9_FS_1_n31), .ZN(
        mult_9_FS_1_n15) );
  OR2_X1 mult_9_FS_1_U46 ( .A1(mult_9_n41), .A2(mult_9_n37), .ZN(
        mult_9_FS_1_n25) );
  NAND2_X1 mult_9_FS_1_U45 ( .A1(mult_9_FS_1_n21), .A2(mult_9_FS_1_n78), .ZN(
        mult_9_FS_1_n74) );
  NAND2_X1 mult_9_FS_1_U44 ( .A1(mult_9_n41), .A2(mult_9_n37), .ZN(
        mult_9_FS_1_n31) );
  XNOR2_X1 mult_9_FS_1_U43 ( .A(mult_9_n54), .B(mult_9_A1_13_), .ZN(
        mult_9_FS_1_n33) );
  XNOR2_X1 mult_9_FS_1_U42 ( .A(mult_9_FS_1_n33), .B(mult_9_FS_1_n34), .ZN(
        product[15]) );
  NAND2_X1 mult_9_FS_1_U41 ( .A1(mult_9_FS_1_n44), .A2(mult_9_FS_1_n45), .ZN(
        mult_9_FS_1_n43) );
  INV_X1 mult_9_FS_1_U40 ( .A(mult_9_FS_1_n27), .ZN(mult_9_FS_1_n22) );
  NOR2_X1 mult_9_FS_1_U39 ( .A1(mult_9_FS_1_n42), .A2(mult_9_FS_1_n43), .ZN(
        mult_9_FS_1_n35) );
  NAND2_X1 mult_9_FS_1_U38 ( .A1(mult_9_FS_1_n3), .A2(mult_9_FS_1_n39), .ZN(
        mult_9_FS_1_n36) );
  INV_X1 mult_9_FS_1_U37 ( .A(mult_9_FS_1_n38), .ZN(mult_9_FS_1_n37) );
  AOI21_X1 mult_9_FS_1_U36 ( .B1(mult_9_FS_1_n35), .B2(mult_9_FS_1_n36), .A(
        mult_9_FS_1_n37), .ZN(mult_9_FS_1_n34) );
  NOR2_X1 mult_9_FS_1_U35 ( .A1(mult_9_FS_1_n56), .A2(mult_9_FS_1_n31), .ZN(
        mult_9_FS_1_n68) );
  AOI21_X1 mult_9_FS_1_U34 ( .B1(mult_9_FS_1_n74), .B2(mult_9_FS_1_n59), .A(
        mult_9_FS_1_n75), .ZN(mult_9_FS_1_n70) );
  INV_X1 mult_9_FS_1_U33 ( .A(mult_9_FS_1_n70), .ZN(mult_9_FS_1_n64) );
  NAND2_X1 mult_9_FS_1_U32 ( .A1(mult_9_FS_1_n21), .A2(mult_9_FS_1_n57), .ZN(
        mult_9_FS_1_n53) );
  INV_X1 mult_9_FS_1_U31 ( .A(mult_9_FS_1_n61), .ZN(mult_9_FS_1_n48) );
  NAND2_X1 mult_9_FS_1_U30 ( .A1(mult_9_FS_1_n38), .A2(mult_9_FS_1_n44), .ZN(
        mult_9_FS_1_n47) );
  NOR2_X1 mult_9_FS_1_U29 ( .A1(mult_9_FS_1_n77), .A2(mult_9_FS_1_n74), .ZN(
        mult_9_FS_1_n76) );
  XNOR2_X1 mult_9_FS_1_U28 ( .A(mult_9_FS_1_n76), .B(mult_9_FS_1_n1), .ZN(
        product[12]) );
  NOR2_X1 mult_9_FS_1_U27 ( .A1(mult_9_FS_1_n65), .A2(mult_9_FS_1_n64), .ZN(
        mult_9_FS_1_n62) );
  NOR2_X1 mult_9_FS_1_U26 ( .A1(mult_9_FS_1_n50), .A2(mult_9_FS_1_n55), .ZN(
        mult_9_FS_1_n63) );
  XNOR2_X1 mult_9_FS_1_U25 ( .A(mult_9_FS_1_n62), .B(mult_9_FS_1_n63), .ZN(
        product[13]) );
  NOR2_X1 mult_9_FS_1_U24 ( .A1(mult_9_FS_1_n79), .A2(mult_9_FS_1_n73), .ZN(
        mult_9_FS_1_n77) );
  OR2_X2 mult_9_FS_1_U23 ( .A1(mult_9_n47), .A2(mult_9_n46), .ZN(
        mult_9_FS_1_n59) );
  OR2_X1 mult_9_FS_1_U22 ( .A1(mult_9_FS_1_n30), .A2(mult_9_FS_1_n11), .ZN(
        mult_9_FS_1_n14) );
  INV_X1 mult_9_FS_1_U21 ( .A(mult_9_FS_1_n72), .ZN(mult_9_FS_1_n13) );
  AND2_X1 mult_9_FS_1_U20 ( .A1(mult_9_FS_1_n41), .A2(mult_9_FS_1_n31), .ZN(
        mult_9_FS_1_n79) );
  AND2_X1 mult_9_FS_1_U19 ( .A1(mult_9_FS_1_n51), .A2(mult_9_FS_1_n45), .ZN(
        mult_9_FS_1_n49) );
  NAND2_X1 mult_9_FS_1_U18 ( .A1(mult_9_FS_1_n10), .A2(mult_9_FS_1_n13), .ZN(
        mult_9_FS_1_n12) );
  XNOR2_X1 mult_9_FS_1_U17 ( .A(mult_9_FS_1_n12), .B(mult_9_FS_1_n15), .ZN(
        product[9]) );
  AND2_X1 mult_9_FS_1_U16 ( .A1(mult_9_n41), .A2(mult_9_n37), .ZN(
        mult_9_FS_1_n11) );
  CLKBUF_X1 mult_9_FS_1_U15 ( .A(mult_9_FS_1_n51), .Z(mult_9_FS_1_n9) );
  NAND2_X1 mult_9_FS_1_U14 ( .A1(mult_9_FS_1_n23), .A2(mult_9_FS_1_n6), .ZN(
        mult_9_FS_1_n8) );
  AND3_X1 mult_9_FS_1_U13 ( .A1(mult_9_FS_1_n24), .A2(mult_9_FS_1_n25), .A3(
        mult_9_FS_1_n26), .ZN(mult_9_FS_1_n7) );
  NOR2_X1 mult_9_FS_1_U12 ( .A1(mult_9_FS_1_n7), .A2(mult_9_FS_1_n8), .ZN(
        mult_9_FS_1_n17) );
  INV_X1 mult_9_FS_1_U11 ( .A(mult_9_FS_1_n22), .ZN(mult_9_FS_1_n6) );
  OR2_X2 mult_9_FS_1_U10 ( .A1(mult_9_n49), .A2(mult_9_n45), .ZN(
        mult_9_FS_1_n24) );
  OR2_X1 mult_9_FS_1_U9 ( .A1(mult_9_n44), .A2(mult_9_n48), .ZN(
        mult_9_FS_1_n58) );
  OR2_X1 mult_9_FS_1_U8 ( .A1(mult_9_n44), .A2(mult_9_n48), .ZN(mult_9_FS_1_n5) );
  CLKBUF_X1 mult_9_FS_1_U7 ( .A(mult_9_n45), .Z(mult_9_FS_1_n4) );
  CLKBUF_X1 mult_9_FS_1_U6 ( .A(mult_9_FS_1_n61), .Z(mult_9_FS_1_n3) );
  AND2_X2 mult_9_FS_1_U5 ( .A1(mult_9_FS_1_n32), .A2(mult_9_FS_1_n28), .ZN(
        product[8]) );
  CLKBUF_X1 mult_9_FS_1_U4 ( .A(mult_9_A2_6_), .Z(mult_9_FS_1_n10) );
  AND2_X1 mult_9_FS_1_U3 ( .A1(mult_9_FS_1_n59), .A2(mult_9_FS_1_n57), .ZN(
        mult_9_FS_1_n1) );
  BUF_X1 mult_9_FS_1_U2 ( .A(mult_9_A1_5_), .Z(product[7]) );
endmodule

