/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:30:15 2025
/////////////////////////////////////////////////////////////


module mac_gpt ( clk, a, b, reset, z );
  input [7:0] a;
  input [7:0] b;
  output [15:0] z;
  input clk, reset;
  wire   N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30,
         N31, N32, N9, N8, N7, N6, N5, N4, N3, N2, N16, N15, N14, N13, N12,
         N11, N10, N1, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, mult_18_n67, mult_18_n66, mult_18_n65, mult_18_n64,
         mult_18_n63, mult_18_n62, mult_18_n61, mult_18_n60, mult_18_n59,
         mult_18_n58, mult_18_n57, mult_18_n56, mult_18_n55, mult_18_n54,
         mult_18_n53, mult_18_n52, mult_18_n51, mult_18_n50, mult_18_n49,
         mult_18_n48, mult_18_n47, mult_18_n46, mult_18_n45, mult_18_n44,
         mult_18_n43, mult_18_n42, mult_18_n41, mult_18_n40, mult_18_n39,
         mult_18_n38, mult_18_n37, mult_18_n36, mult_18_n35, mult_18_n33,
         mult_18_n32, mult_18_n31, mult_18_n30, mult_18_n29, mult_18_n28,
         mult_18_n27, mult_18_n26, mult_18_n25, mult_18_n24, mult_18_n23,
         mult_18_n22, mult_18_n21, mult_18_n20, mult_18_n19, mult_18_n18,
         mult_18_n17, mult_18_n16, mult_18_n15, mult_18_n14, mult_18_n13,
         mult_18_n12, mult_18_n11, mult_18_n10, mult_18_n9, mult_18_n8,
         mult_18_n7, mult_18_n6, mult_18_n5, mult_18_n4, mult_18_n3,
         mult_18_n2, mult_18_A2_6_, mult_18_A1_0_, mult_18_A1_1_,
         mult_18_A1_2_, mult_18_A1_3_, mult_18_A1_4_, mult_18_A1_5_,
         mult_18_A1_13_, mult_18_SUMB_1__5_, mult_18_SUMB_1__6_,
         mult_18_SUMB_2__1_, mult_18_SUMB_2__2_, mult_18_SUMB_2__3_,
         mult_18_SUMB_2__4_, mult_18_SUMB_2__5_, mult_18_SUMB_2__6_,
         mult_18_SUMB_3__1_, mult_18_SUMB_3__2_, mult_18_SUMB_3__3_,
         mult_18_SUMB_3__4_, mult_18_SUMB_3__5_, mult_18_SUMB_3__6_,
         mult_18_SUMB_4__1_, mult_18_SUMB_4__2_, mult_18_SUMB_4__3_,
         mult_18_SUMB_4__4_, mult_18_SUMB_4__5_, mult_18_SUMB_4__6_,
         mult_18_SUMB_5__1_, mult_18_SUMB_5__2_, mult_18_SUMB_5__3_,
         mult_18_SUMB_5__4_, mult_18_SUMB_5__5_, mult_18_SUMB_5__6_,
         mult_18_SUMB_6__1_, mult_18_SUMB_6__2_, mult_18_SUMB_6__3_,
         mult_18_SUMB_6__4_, mult_18_SUMB_6__5_, mult_18_SUMB_6__6_,
         mult_18_SUMB_7__0_, mult_18_SUMB_7__1_, mult_18_SUMB_7__2_,
         mult_18_SUMB_7__3_, mult_18_SUMB_7__4_, mult_18_SUMB_7__5_,
         mult_18_SUMB_7__6_, mult_18_SUMB_7__7_, mult_18_CARRYB_1__5_,
         mult_18_CARRYB_1__6_, mult_18_CARRYB_2__0_, mult_18_CARRYB_2__1_,
         mult_18_CARRYB_2__2_, mult_18_CARRYB_2__3_, mult_18_CARRYB_2__4_,
         mult_18_CARRYB_2__5_, mult_18_CARRYB_2__6_, mult_18_CARRYB_3__0_,
         mult_18_CARRYB_3__1_, mult_18_CARRYB_3__2_, mult_18_CARRYB_3__3_,
         mult_18_CARRYB_3__4_, mult_18_CARRYB_3__5_, mult_18_CARRYB_3__6_,
         mult_18_CARRYB_4__0_, mult_18_CARRYB_4__1_, mult_18_CARRYB_4__2_,
         mult_18_CARRYB_4__3_, mult_18_CARRYB_4__4_, mult_18_CARRYB_4__5_,
         mult_18_CARRYB_4__6_, mult_18_CARRYB_5__0_, mult_18_CARRYB_5__1_,
         mult_18_CARRYB_5__2_, mult_18_CARRYB_5__3_, mult_18_CARRYB_5__4_,
         mult_18_CARRYB_5__5_, mult_18_CARRYB_5__6_, mult_18_CARRYB_6__0_,
         mult_18_CARRYB_6__1_, mult_18_CARRYB_6__2_, mult_18_CARRYB_6__3_,
         mult_18_CARRYB_6__4_, mult_18_CARRYB_6__5_, mult_18_CARRYB_6__6_,
         mult_18_CARRYB_7__0_, mult_18_CARRYB_7__1_, mult_18_CARRYB_7__2_,
         mult_18_CARRYB_7__3_, mult_18_CARRYB_7__4_, mult_18_CARRYB_7__5_,
         mult_18_CARRYB_7__6_, mult_18_CARRYB_7__7_, mult_18_ab_0__1_,
         mult_18_ab_0__2_, mult_18_ab_0__3_, mult_18_ab_0__4_,
         mult_18_ab_0__5_, mult_18_ab_0__6_, mult_18_ab_0__7_,
         mult_18_ab_1__0_, mult_18_ab_1__1_, mult_18_ab_1__2_,
         mult_18_ab_1__3_, mult_18_ab_1__4_, mult_18_ab_1__5_,
         mult_18_ab_1__6_, mult_18_ab_1__7_, mult_18_ab_2__0_,
         mult_18_ab_2__1_, mult_18_ab_2__2_, mult_18_ab_2__3_,
         mult_18_ab_2__4_, mult_18_ab_2__5_, mult_18_ab_2__6_,
         mult_18_ab_2__7_, mult_18_ab_3__0_, mult_18_ab_3__1_,
         mult_18_ab_3__2_, mult_18_ab_3__3_, mult_18_ab_3__4_,
         mult_18_ab_3__5_, mult_18_ab_3__6_, mult_18_ab_3__7_,
         mult_18_ab_4__0_, mult_18_ab_4__1_, mult_18_ab_4__2_,
         mult_18_ab_4__3_, mult_18_ab_4__4_, mult_18_ab_4__5_,
         mult_18_ab_4__6_, mult_18_ab_4__7_, mult_18_ab_5__0_,
         mult_18_ab_5__1_, mult_18_ab_5__2_, mult_18_ab_5__3_,
         mult_18_ab_5__4_, mult_18_ab_5__5_, mult_18_ab_5__6_,
         mult_18_ab_5__7_, mult_18_ab_6__0_, mult_18_ab_6__1_,
         mult_18_ab_6__2_, mult_18_ab_6__3_, mult_18_ab_6__4_,
         mult_18_ab_6__5_, mult_18_ab_6__6_, mult_18_ab_6__7_,
         mult_18_ab_7__0_, mult_18_ab_7__1_, mult_18_ab_7__2_,
         mult_18_ab_7__3_, mult_18_ab_7__4_, mult_18_ab_7__5_,
         mult_18_ab_7__6_, mult_18_ab_7__7_, mult_18_FS_1_n62,
         mult_18_FS_1_n61, mult_18_FS_1_n60, mult_18_FS_1_n59,
         mult_18_FS_1_n58, mult_18_FS_1_n57, mult_18_FS_1_n56,
         mult_18_FS_1_n55, mult_18_FS_1_n54, mult_18_FS_1_n53,
         mult_18_FS_1_n52, mult_18_FS_1_n51, mult_18_FS_1_n50,
         mult_18_FS_1_n49, mult_18_FS_1_n48, mult_18_FS_1_n47,
         mult_18_FS_1_n46, mult_18_FS_1_n45, mult_18_FS_1_n44,
         mult_18_FS_1_n43, mult_18_FS_1_n42, mult_18_FS_1_n41,
         mult_18_FS_1_n40, mult_18_FS_1_n39, mult_18_FS_1_n38,
         mult_18_FS_1_n37, mult_18_FS_1_n36, mult_18_FS_1_n35,
         mult_18_FS_1_n34, mult_18_FS_1_n33, mult_18_FS_1_n32,
         mult_18_FS_1_n31, mult_18_FS_1_n30, mult_18_FS_1_n29,
         mult_18_FS_1_n28, mult_18_FS_1_n27, mult_18_FS_1_n26,
         mult_18_FS_1_n25, mult_18_FS_1_n24, mult_18_FS_1_n23,
         mult_18_FS_1_n22, mult_18_FS_1_n21, mult_18_FS_1_n20,
         mult_18_FS_1_n19, mult_18_FS_1_n18, mult_18_FS_1_n17,
         mult_18_FS_1_n16, mult_18_FS_1_n15, mult_18_FS_1_n8, mult_18_FS_1_n7,
         mult_18_FS_1_n6, mult_18_FS_1_n5, mult_18_FS_1_n4, mult_18_FS_1_n3,
         mult_18_FS_1_n2, mult_18_FS_1_n1, add_18_n131, add_18_n130,
         add_18_n129, add_18_n128, add_18_n127, add_18_n126, add_18_n125,
         add_18_n124, add_18_n123, add_18_n122, add_18_n121, add_18_n120,
         add_18_n119, add_18_n118, add_18_n117, add_18_n116, add_18_n115,
         add_18_n114, add_18_n113, add_18_n112, add_18_n111, add_18_n110,
         add_18_n109, add_18_n108, add_18_n107, add_18_n106, add_18_n105,
         add_18_n104, add_18_n103, add_18_n102, add_18_n101, add_18_n100,
         add_18_n99, add_18_n98, add_18_n97, add_18_n96, add_18_n95,
         add_18_n94, add_18_n93, add_18_n92, add_18_n91, add_18_n90,
         add_18_n89, add_18_n88, add_18_n87, add_18_n86, add_18_n85,
         add_18_n84, add_18_n83, add_18_n82, add_18_n81, add_18_n80,
         add_18_n79, add_18_n78, add_18_n77, add_18_n76, add_18_n75,
         add_18_n74, add_18_n73, add_18_n72, add_18_n71, add_18_n70,
         add_18_n69, add_18_n68, add_18_n67, add_18_n66, add_18_n65,
         add_18_n64, add_18_n63, add_18_n62, add_18_n61, add_18_n60,
         add_18_n59, add_18_n58, add_18_n57, add_18_n56, add_18_n55,
         add_18_n54, add_18_n53, add_18_n52, add_18_n51, add_18_n50,
         add_18_n49, add_18_n48, add_18_n47, add_18_n46, add_18_n45,
         add_18_n44, add_18_n43, add_18_n42, add_18_n41, add_18_n40,
         add_18_n39, add_18_n38, add_18_n37, add_18_n36, add_18_n35,
         add_18_n34, add_18_n33, add_18_n32, add_18_n31, add_18_n30,
         add_18_n29, add_18_n28, add_18_n27, add_18_n26, add_18_n25,
         add_18_n24, add_18_n23, add_18_n22, add_18_n21, add_18_n19,
         add_18_n18, add_18_n17, add_18_n16, add_18_n15, add_18_n14,
         add_18_n13, add_18_n12, add_18_n11, add_18_n10, add_18_n9, add_18_n8,
         add_18_n7, add_18_n6, add_18_n5, add_18_n4, add_18_n3, add_18_n2,
         add_18_n1;
  wire   [15:0] acc;
  wire   [7:0] a_reg;
  wire   [6:0] b_reg;

  DFF_X1 a_reg_reg_7_ ( .D(n45), .CK(clk), .Q(a_reg[7]) );
  DFF_X1 a_reg_reg_6_ ( .D(n46), .CK(clk), .Q(a_reg[6]) );
  DFF_X1 a_reg_reg_5_ ( .D(n47), .CK(clk), .Q(a_reg[5]) );
  DFF_X1 a_reg_reg_4_ ( .D(n48), .CK(clk), .Q(a_reg[4]) );
  DFF_X1 a_reg_reg_3_ ( .D(n49), .CK(clk), .Q(a_reg[3]) );
  DFFR_X1 z_reg_15_ ( .D(acc[15]), .CK(clk), .RN(n41), .Q(z[15]) );
  DFFR_X1 z_reg_14_ ( .D(acc[14]), .CK(clk), .RN(n41), .Q(z[14]) );
  DFFR_X1 z_reg_13_ ( .D(acc[13]), .CK(clk), .RN(n41), .Q(z[13]) );
  DFFR_X1 acc_reg_12_ ( .D(N29), .CK(clk), .RN(n43), .Q(acc[12]) );
  DFFR_X1 z_reg_12_ ( .D(acc[12]), .CK(clk), .RN(n41), .Q(z[12]) );
  DFFR_X1 z_reg_11_ ( .D(acc[11]), .CK(clk), .RN(n41), .Q(z[11]) );
  DFFR_X1 acc_reg_10_ ( .D(N27), .CK(clk), .RN(n43), .Q(acc[10]) );
  DFFR_X1 z_reg_10_ ( .D(acc[10]), .CK(clk), .RN(n41), .Q(z[10]) );
  DFFR_X1 acc_reg_9_ ( .D(N26), .CK(clk), .RN(n43), .Q(acc[9]) );
  DFFR_X1 z_reg_9_ ( .D(acc[9]), .CK(clk), .RN(n41), .Q(z[9]) );
  DFFR_X1 acc_reg_8_ ( .D(N25), .CK(clk), .RN(n43), .Q(acc[8]) );
  DFFR_X1 z_reg_8_ ( .D(acc[8]), .CK(clk), .RN(n41), .Q(z[8]) );
  DFFR_X1 z_reg_7_ ( .D(acc[7]), .CK(clk), .RN(n41), .Q(z[7]) );
  DFFR_X1 acc_reg_6_ ( .D(N23), .CK(clk), .RN(n42), .Q(acc[6]) );
  DFFR_X1 z_reg_6_ ( .D(acc[6]), .CK(clk), .RN(n41), .Q(z[6]) );
  DFFR_X1 acc_reg_5_ ( .D(N22), .CK(clk), .RN(n42), .Q(acc[5]) );
  DFFR_X1 z_reg_5_ ( .D(acc[5]), .CK(clk), .RN(n41), .Q(z[5]) );
  DFFR_X1 acc_reg_4_ ( .D(N21), .CK(clk), .RN(n42), .Q(acc[4]) );
  DFFR_X1 z_reg_4_ ( .D(acc[4]), .CK(clk), .RN(n41), .Q(z[4]) );
  DFFR_X1 acc_reg_3_ ( .D(N20), .CK(clk), .RN(n42), .Q(acc[3]) );
  DFFR_X1 z_reg_3_ ( .D(acc[3]), .CK(clk), .RN(n42), .Q(z[3]) );
  DFFR_X1 acc_reg_2_ ( .D(N19), .CK(clk), .RN(n42), .Q(acc[2]) );
  DFFR_X1 z_reg_2_ ( .D(acc[2]), .CK(clk), .RN(n42), .Q(z[2]) );
  DFFR_X1 acc_reg_1_ ( .D(N18), .CK(clk), .RN(n42), .Q(acc[1]) );
  DFFR_X1 z_reg_1_ ( .D(acc[1]), .CK(clk), .RN(n42), .Q(z[1]) );
  DFFR_X1 acc_reg_0_ ( .D(N17), .CK(clk), .RN(n42), .Q(acc[0]) );
  DFFR_X1 z_reg_0_ ( .D(acc[0]), .CK(clk), .RN(n42), .Q(z[0]) );
  DFF_X1 b_reg_reg_7_ ( .D(n53), .CK(clk), .Q(n40), .QN(n36) );
  DFF_X1 b_reg_reg_5_ ( .D(n55), .CK(clk), .Q(b_reg[5]) );
  DFF_X1 b_reg_reg_4_ ( .D(n56), .CK(clk), .Q(b_reg[4]) );
  DFF_X1 b_reg_reg_3_ ( .D(n57), .CK(clk), .Q(b_reg[3]) );
  DFF_X1 b_reg_reg_2_ ( .D(n58), .CK(clk), .Q(b_reg[2]) );
  DFF_X1 b_reg_reg_1_ ( .D(n59), .CK(clk), .Q(b_reg[1]) );
  DFF_X1 b_reg_reg_0_ ( .D(n60), .CK(clk), .Q(b_reg[0]) );
  DFF_X1 a_reg_reg_2_ ( .D(n50), .CK(clk), .Q(a_reg[2]) );
  DFF_X1 a_reg_reg_0_ ( .D(n52), .CK(clk), .Q(a_reg[0]) );
  DFF_X1 b_reg_reg_6_ ( .D(n54), .CK(clk), .Q(b_reg[6]), .QN(n38) );
  DFF_X1 a_reg_reg_1_ ( .D(n51), .CK(clk), .Q(a_reg[1]), .QN(n34) );
  DFFR_X1 acc_reg_14_ ( .D(N31), .CK(clk), .RN(n43), .Q(acc[14]) );
  DFFR_X1 acc_reg_11_ ( .D(N28), .CK(clk), .RN(n43), .Q(acc[11]) );
  DFFR_X2 acc_reg_13_ ( .D(N30), .CK(clk), .RN(n43), .Q(acc[13]) );
  DFFR_X2 acc_reg_7_ ( .D(N24), .CK(clk), .RN(n42), .Q(acc[7]) );
  DFFR_X2 acc_reg_15_ ( .D(N32), .CK(clk), .RN(n43), .Q(acc[15]) );
  INV_X1 U36 ( .A(n34), .ZN(n35) );
  INV_X1 U37 ( .A(n36), .ZN(n37) );
  INV_X1 U38 ( .A(n38), .ZN(n39) );
  BUF_X1 U39 ( .A(n44), .Z(n42) );
  BUF_X1 U40 ( .A(n44), .Z(n41) );
  BUF_X1 U41 ( .A(n44), .Z(n43) );
  MUX2_X1 U42 ( .A(b[0]), .B(b_reg[0]), .S(reset), .Z(n60) );
  MUX2_X1 U43 ( .A(b[1]), .B(b_reg[1]), .S(reset), .Z(n59) );
  MUX2_X1 U44 ( .A(b[2]), .B(b_reg[2]), .S(reset), .Z(n58) );
  MUX2_X1 U45 ( .A(b[3]), .B(b_reg[3]), .S(reset), .Z(n57) );
  MUX2_X1 U46 ( .A(b[4]), .B(b_reg[4]), .S(reset), .Z(n56) );
  MUX2_X1 U47 ( .A(b[5]), .B(b_reg[5]), .S(reset), .Z(n55) );
  MUX2_X1 U48 ( .A(b[6]), .B(n39), .S(reset), .Z(n54) );
  MUX2_X1 U49 ( .A(b[7]), .B(n37), .S(reset), .Z(n53) );
  MUX2_X1 U50 ( .A(a[0]), .B(a_reg[0]), .S(reset), .Z(n52) );
  MUX2_X1 U51 ( .A(a[1]), .B(n35), .S(reset), .Z(n51) );
  MUX2_X1 U52 ( .A(a[2]), .B(a_reg[2]), .S(reset), .Z(n50) );
  MUX2_X1 U53 ( .A(a[3]), .B(a_reg[3]), .S(reset), .Z(n49) );
  MUX2_X1 U54 ( .A(a[4]), .B(a_reg[4]), .S(reset), .Z(n48) );
  MUX2_X1 U55 ( .A(a[5]), .B(a_reg[5]), .S(reset), .Z(n47) );
  MUX2_X1 U56 ( .A(a[6]), .B(a_reg[6]), .S(reset), .Z(n46) );
  MUX2_X1 U57 ( .A(a[7]), .B(a_reg[7]), .S(reset), .Z(n45) );
  INV_X1 U58 ( .A(reset), .ZN(n44) );
  INV_X1 mult_18_U140 ( .A(mult_18_CARRYB_7__7_), .ZN(mult_18_A1_13_) );
  NOR2_X1 mult_18_U139 ( .A1(mult_18_n65), .A2(mult_18_n64), .ZN(N1) );
  NOR2_X1 mult_18_U138 ( .A1(b_reg[0]), .A2(mult_18_n66), .ZN(mult_18_ab_7__0_) );
  NOR2_X1 mult_18_U137 ( .A1(b_reg[1]), .A2(mult_18_n66), .ZN(mult_18_ab_7__1_) );
  NOR2_X1 mult_18_U136 ( .A1(b_reg[2]), .A2(mult_18_n66), .ZN(mult_18_ab_7__2_) );
  NOR2_X1 mult_18_U135 ( .A1(b_reg[3]), .A2(mult_18_n66), .ZN(mult_18_ab_7__3_) );
  NOR2_X1 mult_18_U134 ( .A1(b_reg[4]), .A2(mult_18_n66), .ZN(mult_18_ab_7__4_) );
  NOR2_X1 mult_18_U133 ( .A1(b_reg[5]), .A2(mult_18_n66), .ZN(mult_18_ab_7__5_) );
  NOR2_X1 mult_18_U132 ( .A1(a_reg[6]), .A2(mult_18_n51), .ZN(mult_18_ab_6__7_) );
  NOR2_X1 mult_18_U131 ( .A1(mult_18_n11), .A2(mult_18_n66), .ZN(
        mult_18_ab_7__6_) );
  NOR2_X1 mult_18_U130 ( .A1(mult_18_n51), .A2(mult_18_n66), .ZN(
        mult_18_ab_7__7_) );
  NOR2_X1 mult_18_U129 ( .A1(mult_18_n64), .A2(mult_18_n63), .ZN(
        mult_18_ab_6__0_) );
  NOR2_X1 mult_18_U128 ( .A1(mult_18_n63), .A2(mult_18_n62), .ZN(
        mult_18_ab_6__1_) );
  NOR2_X1 mult_18_U127 ( .A1(mult_18_n63), .A2(mult_18_n61), .ZN(
        mult_18_ab_6__2_) );
  NOR2_X1 mult_18_U126 ( .A1(mult_18_n63), .A2(mult_18_n60), .ZN(
        mult_18_ab_6__3_) );
  NOR2_X1 mult_18_U125 ( .A1(mult_18_n63), .A2(mult_18_n59), .ZN(
        mult_18_ab_6__4_) );
  NOR2_X1 mult_18_U124 ( .A1(mult_18_n63), .A2(mult_18_n32), .ZN(
        mult_18_ab_6__5_) );
  NOR2_X1 mult_18_U123 ( .A1(a_reg[5]), .A2(mult_18_n50), .ZN(mult_18_ab_5__7_) );
  NOR2_X1 mult_18_U122 ( .A1(mult_18_n63), .A2(mult_18_n57), .ZN(
        mult_18_ab_6__6_) );
  INV_X1 mult_18_U121 ( .A(a_reg[6]), .ZN(mult_18_n63) );
  NOR2_X1 mult_18_U120 ( .A1(mult_18_n64), .A2(mult_18_n56), .ZN(
        mult_18_ab_5__0_) );
  NOR2_X1 mult_18_U119 ( .A1(mult_18_n62), .A2(mult_18_n56), .ZN(
        mult_18_ab_5__1_) );
  NOR2_X1 mult_18_U118 ( .A1(mult_18_n61), .A2(mult_18_n56), .ZN(
        mult_18_ab_5__2_) );
  NOR2_X1 mult_18_U117 ( .A1(mult_18_n60), .A2(mult_18_n56), .ZN(
        mult_18_ab_5__3_) );
  NOR2_X1 mult_18_U116 ( .A1(mult_18_n59), .A2(mult_18_n56), .ZN(
        mult_18_ab_5__4_) );
  NOR2_X1 mult_18_U115 ( .A1(mult_18_n32), .A2(mult_18_n56), .ZN(
        mult_18_ab_5__5_) );
  NOR2_X1 mult_18_U114 ( .A1(a_reg[4]), .A2(mult_18_n51), .ZN(mult_18_ab_4__7_) );
  NOR2_X1 mult_18_U113 ( .A1(mult_18_n57), .A2(mult_18_n56), .ZN(
        mult_18_ab_5__6_) );
  INV_X1 mult_18_U112 ( .A(a_reg[5]), .ZN(mult_18_n56) );
  NOR2_X1 mult_18_U111 ( .A1(mult_18_n64), .A2(mult_18_n55), .ZN(
        mult_18_ab_4__0_) );
  NOR2_X1 mult_18_U110 ( .A1(mult_18_n62), .A2(mult_18_n55), .ZN(
        mult_18_ab_4__1_) );
  NOR2_X1 mult_18_U109 ( .A1(mult_18_n61), .A2(mult_18_n55), .ZN(
        mult_18_ab_4__2_) );
  NOR2_X1 mult_18_U108 ( .A1(mult_18_n60), .A2(mult_18_n55), .ZN(
        mult_18_ab_4__3_) );
  NOR2_X1 mult_18_U107 ( .A1(mult_18_n59), .A2(mult_18_n55), .ZN(
        mult_18_ab_4__4_) );
  NOR2_X1 mult_18_U106 ( .A1(mult_18_n32), .A2(mult_18_n55), .ZN(
        mult_18_ab_4__5_) );
  NOR2_X1 mult_18_U105 ( .A1(a_reg[3]), .A2(mult_18_n50), .ZN(mult_18_ab_3__7_) );
  NOR2_X1 mult_18_U104 ( .A1(mult_18_n57), .A2(mult_18_n55), .ZN(
        mult_18_ab_4__6_) );
  INV_X1 mult_18_U103 ( .A(a_reg[4]), .ZN(mult_18_n55) );
  NOR2_X1 mult_18_U102 ( .A1(mult_18_n64), .A2(mult_18_n54), .ZN(
        mult_18_ab_3__0_) );
  NOR2_X1 mult_18_U101 ( .A1(mult_18_n62), .A2(mult_18_n54), .ZN(
        mult_18_ab_3__1_) );
  NOR2_X1 mult_18_U100 ( .A1(mult_18_n61), .A2(mult_18_n54), .ZN(
        mult_18_ab_3__2_) );
  NOR2_X1 mult_18_U99 ( .A1(mult_18_n60), .A2(mult_18_n54), .ZN(
        mult_18_ab_3__3_) );
  NOR2_X1 mult_18_U98 ( .A1(mult_18_n59), .A2(mult_18_n54), .ZN(
        mult_18_ab_3__4_) );
  NOR2_X1 mult_18_U97 ( .A1(mult_18_n58), .A2(mult_18_n54), .ZN(
        mult_18_ab_3__5_) );
  NOR2_X1 mult_18_U96 ( .A1(a_reg[2]), .A2(mult_18_n51), .ZN(mult_18_ab_2__7_)
         );
  NOR2_X1 mult_18_U95 ( .A1(mult_18_n57), .A2(mult_18_n54), .ZN(
        mult_18_ab_3__6_) );
  INV_X1 mult_18_U94 ( .A(a_reg[3]), .ZN(mult_18_n54) );
  NOR2_X1 mult_18_U93 ( .A1(mult_18_n64), .A2(mult_18_n53), .ZN(
        mult_18_ab_2__0_) );
  NOR2_X1 mult_18_U92 ( .A1(mult_18_n62), .A2(mult_18_n53), .ZN(
        mult_18_ab_2__1_) );
  NOR2_X1 mult_18_U91 ( .A1(mult_18_n61), .A2(mult_18_n53), .ZN(
        mult_18_ab_2__2_) );
  NOR2_X1 mult_18_U90 ( .A1(mult_18_n60), .A2(mult_18_n53), .ZN(
        mult_18_ab_2__3_) );
  NOR2_X1 mult_18_U89 ( .A1(mult_18_n59), .A2(mult_18_n53), .ZN(
        mult_18_ab_2__4_) );
  NOR2_X1 mult_18_U88 ( .A1(mult_18_n58), .A2(mult_18_n53), .ZN(
        mult_18_ab_2__5_) );
  NOR2_X1 mult_18_U87 ( .A1(mult_18_n17), .A2(mult_18_n50), .ZN(
        mult_18_ab_1__7_) );
  NOR2_X1 mult_18_U86 ( .A1(mult_18_n57), .A2(mult_18_n53), .ZN(
        mult_18_ab_2__6_) );
  INV_X1 mult_18_U85 ( .A(a_reg[2]), .ZN(mult_18_n53) );
  NOR2_X1 mult_18_U84 ( .A1(mult_18_n64), .A2(mult_18_n30), .ZN(
        mult_18_ab_1__0_) );
  INV_X1 mult_18_U83 ( .A(b_reg[0]), .ZN(mult_18_n64) );
  NOR2_X1 mult_18_U82 ( .A1(mult_18_n65), .A2(mult_18_n62), .ZN(
        mult_18_ab_0__1_) );
  NOR2_X1 mult_18_U81 ( .A1(mult_18_n62), .A2(mult_18_n30), .ZN(
        mult_18_ab_1__1_) );
  INV_X1 mult_18_U80 ( .A(b_reg[1]), .ZN(mult_18_n62) );
  NOR2_X1 mult_18_U79 ( .A1(mult_18_n65), .A2(mult_18_n61), .ZN(
        mult_18_ab_0__2_) );
  NOR2_X1 mult_18_U78 ( .A1(mult_18_n61), .A2(mult_18_n30), .ZN(
        mult_18_ab_1__2_) );
  INV_X1 mult_18_U77 ( .A(b_reg[2]), .ZN(mult_18_n61) );
  NOR2_X1 mult_18_U76 ( .A1(mult_18_n65), .A2(mult_18_n60), .ZN(
        mult_18_ab_0__3_) );
  NOR2_X1 mult_18_U75 ( .A1(mult_18_n60), .A2(mult_18_n52), .ZN(
        mult_18_ab_1__3_) );
  INV_X1 mult_18_U74 ( .A(b_reg[3]), .ZN(mult_18_n60) );
  NOR2_X1 mult_18_U73 ( .A1(mult_18_n65), .A2(mult_18_n59), .ZN(
        mult_18_ab_0__4_) );
  NOR2_X1 mult_18_U72 ( .A1(mult_18_n59), .A2(mult_18_n52), .ZN(
        mult_18_ab_1__4_) );
  INV_X1 mult_18_U71 ( .A(b_reg[4]), .ZN(mult_18_n59) );
  NOR2_X1 mult_18_U70 ( .A1(mult_18_n65), .A2(mult_18_n58), .ZN(
        mult_18_ab_0__5_) );
  INV_X1 mult_18_U69 ( .A(b_reg[5]), .ZN(mult_18_n58) );
  INV_X1 mult_18_U68 ( .A(a_reg[0]), .ZN(mult_18_n65) );
  NOR2_X1 mult_18_U67 ( .A1(mult_18_n67), .A2(a_reg[0]), .ZN(mult_18_ab_0__7_)
         );
  INV_X2 mult_18_U66 ( .A(a_reg[7]), .ZN(mult_18_n66) );
  INV_X1 mult_18_U65 ( .A(n40), .ZN(mult_18_n67) );
  CLKBUF_X1 mult_18_U64 ( .A(mult_18_n31), .Z(mult_18_n51) );
  AND2_X1 mult_18_U63 ( .A1(mult_18_CARRYB_7__6_), .A2(mult_18_SUMB_7__7_), 
        .ZN(mult_18_n49) );
  XOR2_X1 mult_18_U62 ( .A(mult_18_CARRYB_7__6_), .B(mult_18_SUMB_7__7_), .Z(
        mult_18_n48) );
  AND2_X1 mult_18_U61 ( .A1(mult_18_CARRYB_7__5_), .A2(mult_18_SUMB_7__6_), 
        .ZN(mult_18_n47) );
  AND2_X1 mult_18_U60 ( .A1(mult_18_CARRYB_7__4_), .A2(mult_18_SUMB_7__5_), 
        .ZN(mult_18_n46) );
  XOR2_X1 mult_18_U59 ( .A(mult_18_CARRYB_7__5_), .B(mult_18_SUMB_7__6_), .Z(
        mult_18_n45) );
  AND2_X1 mult_18_U58 ( .A1(mult_18_CARRYB_7__3_), .A2(mult_18_SUMB_7__4_), 
        .ZN(mult_18_n44) );
  XOR2_X1 mult_18_U57 ( .A(mult_18_CARRYB_7__4_), .B(mult_18_SUMB_7__5_), .Z(
        mult_18_n43) );
  AND2_X2 mult_18_U56 ( .A1(mult_18_CARRYB_7__2_), .A2(mult_18_SUMB_7__3_), 
        .ZN(mult_18_n42) );
  AND2_X1 mult_18_U55 ( .A1(mult_18_CARRYB_7__0_), .A2(mult_18_SUMB_7__1_), 
        .ZN(mult_18_n41) );
  XOR2_X1 mult_18_U54 ( .A(mult_18_CARRYB_7__3_), .B(mult_18_SUMB_7__4_), .Z(
        mult_18_n40) );
  AND2_X1 mult_18_U53 ( .A1(mult_18_SUMB_7__2_), .A2(mult_18_CARRYB_7__1_), 
        .ZN(mult_18_n39) );
  XOR2_X1 mult_18_U52 ( .A(mult_18_CARRYB_7__2_), .B(mult_18_SUMB_7__3_), .Z(
        mult_18_n38) );
  AND2_X1 mult_18_U51 ( .A1(mult_18_ab_0__5_), .A2(mult_18_ab_1__4_), .ZN(
        mult_18_n37) );
  XOR2_X1 mult_18_U50 ( .A(mult_18_SUMB_7__2_), .B(mult_18_CARRYB_7__1_), .Z(
        mult_18_n36) );
  XOR2_X1 mult_18_U49 ( .A(mult_18_ab_1__0_), .B(mult_18_ab_0__1_), .Z(N2) );
  INV_X1 mult_18_U48 ( .A(a_reg[1]), .ZN(mult_18_n52) );
  INV_X1 mult_18_U47 ( .A(mult_18_n11), .ZN(mult_18_n57) );
  AND2_X1 mult_18_U46 ( .A1(a_reg[1]), .A2(b_reg[6]), .ZN(mult_18_ab_1__6_) );
  BUF_X1 mult_18_U45 ( .A(mult_18_n31), .Z(mult_18_n50) );
  INV_X1 mult_18_U44 ( .A(mult_18_n50), .ZN(mult_18_n33) );
  INV_X1 mult_18_U43 ( .A(b_reg[5]), .ZN(mult_18_n32) );
  CLKBUF_X1 mult_18_U42 ( .A(mult_18_n67), .Z(mult_18_n31) );
  INV_X1 mult_18_U41 ( .A(a_reg[1]), .ZN(mult_18_n30) );
  NAND3_X1 mult_18_U40 ( .A1(mult_18_n27), .A2(mult_18_n28), .A3(mult_18_n29), 
        .ZN(mult_18_CARRYB_2__4_) );
  NAND2_X1 mult_18_U39 ( .A1(mult_18_n37), .A2(mult_18_SUMB_1__5_), .ZN(
        mult_18_n29) );
  NAND2_X1 mult_18_U38 ( .A1(mult_18_ab_2__4_), .A2(mult_18_SUMB_1__5_), .ZN(
        mult_18_n28) );
  NAND2_X1 mult_18_U37 ( .A1(mult_18_ab_2__4_), .A2(mult_18_n37), .ZN(
        mult_18_n27) );
  NAND2_X1 mult_18_U36 ( .A1(mult_18_ab_0__6_), .A2(mult_18_ab_1__5_), .ZN(
        mult_18_n26) );
  XOR2_X1 mult_18_U35 ( .A(mult_18_n25), .B(mult_18_SUMB_1__5_), .Z(
        mult_18_SUMB_2__4_) );
  XOR2_X1 mult_18_U34 ( .A(mult_18_ab_2__4_), .B(mult_18_n37), .Z(mult_18_n25)
         );
  XOR2_X1 mult_18_U33 ( .A(mult_18_ab_0__6_), .B(mult_18_n12), .Z(
        mult_18_SUMB_1__5_) );
  INV_X1 mult_18_U32 ( .A(mult_18_CARRYB_7__0_), .ZN(mult_18_n22) );
  NAND2_X1 mult_18_U31 ( .A1(mult_18_n23), .A2(mult_18_n24), .ZN(mult_18_n35)
         );
  NAND2_X1 mult_18_U30 ( .A1(mult_18_n22), .A2(mult_18_SUMB_7__1_), .ZN(
        mult_18_n24) );
  NAND3_X1 mult_18_U29 ( .A1(mult_18_n20), .A2(mult_18_n19), .A3(mult_18_n21), 
        .ZN(mult_18_A2_6_) );
  NAND2_X1 mult_18_U28 ( .A1(mult_18_n33), .A2(a_reg[7]), .ZN(mult_18_n21) );
  NAND2_X1 mult_18_U27 ( .A1(mult_18_SUMB_7__0_), .A2(a_reg[7]), .ZN(
        mult_18_n20) );
  NAND2_X1 mult_18_U26 ( .A1(mult_18_SUMB_7__0_), .A2(mult_18_n33), .ZN(
        mult_18_n19) );
  CLKBUF_X1 mult_18_U25 ( .A(mult_18_SUMB_7__0_), .Z(mult_18_n18) );
  INV_X1 mult_18_U24 ( .A(mult_18_n52), .ZN(mult_18_n17) );
  NAND3_X1 mult_18_U23 ( .A1(mult_18_n14), .A2(mult_18_n15), .A3(mult_18_n16), 
        .ZN(mult_18_CARRYB_3__6_) );
  NAND2_X1 mult_18_U22 ( .A1(mult_18_ab_2__7_), .A2(mult_18_ab_3__6_), .ZN(
        mult_18_n16) );
  NAND2_X1 mult_18_U21 ( .A1(mult_18_CARRYB_2__6_), .A2(mult_18_ab_3__6_), 
        .ZN(mult_18_n15) );
  NAND2_X1 mult_18_U20 ( .A1(mult_18_CARRYB_2__6_), .A2(mult_18_ab_2__7_), 
        .ZN(mult_18_n14) );
  XOR2_X1 mult_18_U19 ( .A(mult_18_CARRYB_2__6_), .B(mult_18_n13), .Z(
        mult_18_SUMB_3__6_) );
  XOR2_X1 mult_18_U18 ( .A(mult_18_ab_2__7_), .B(mult_18_ab_3__6_), .Z(
        mult_18_n13) );
  NOR2_X1 mult_18_U17 ( .A1(mult_18_n58), .A2(mult_18_n52), .ZN(
        mult_18_ab_1__5_) );
  NOR2_X1 mult_18_U16 ( .A1(mult_18_n58), .A2(mult_18_n52), .ZN(mult_18_n12)
         );
  AND2_X2 mult_18_U15 ( .A1(a_reg[0]), .A2(b_reg[6]), .ZN(mult_18_ab_0__6_) );
  CLKBUF_X1 mult_18_U14 ( .A(b_reg[6]), .Z(mult_18_n11) );
  OR2_X1 mult_18_U13 ( .A1(mult_18_SUMB_7__1_), .A2(mult_18_n22), .ZN(
        mult_18_n23) );
  AND2_X1 mult_18_U12 ( .A1(mult_18_ab_0__1_), .A2(mult_18_ab_1__0_), .ZN(
        mult_18_n10) );
  AND2_X1 mult_18_U11 ( .A1(mult_18_ab_0__2_), .A2(mult_18_ab_1__1_), .ZN(
        mult_18_n9) );
  AND2_X1 mult_18_U10 ( .A1(mult_18_ab_0__3_), .A2(mult_18_ab_1__2_), .ZN(
        mult_18_n8) );
  AND2_X1 mult_18_U9 ( .A1(mult_18_ab_0__4_), .A2(mult_18_ab_1__3_), .ZN(
        mult_18_n7) );
  XOR2_X1 mult_18_U8 ( .A(mult_18_ab_1__1_), .B(mult_18_ab_0__2_), .Z(
        mult_18_n6) );
  XOR2_X1 mult_18_U7 ( .A(mult_18_ab_1__2_), .B(mult_18_ab_0__3_), .Z(
        mult_18_n5) );
  XOR2_X1 mult_18_U6 ( .A(mult_18_ab_1__3_), .B(mult_18_ab_0__4_), .Z(
        mult_18_n4) );
  XOR2_X1 mult_18_U5 ( .A(mult_18_ab_1__4_), .B(mult_18_ab_0__5_), .Z(
        mult_18_n3) );
  XNOR2_X1 mult_18_U4 ( .A(mult_18_n33), .B(a_reg[7]), .ZN(mult_18_n2) );
  XNOR2_X1 mult_18_U3 ( .A(mult_18_n18), .B(mult_18_n2), .ZN(mult_18_A1_5_) );
  INV_X2 mult_18_U2 ( .A(mult_18_n26), .ZN(mult_18_CARRYB_1__5_) );
  FA_X1 mult_18_S0_6 ( .A(mult_18_ab_1__6_), .B(1'b0), .CI(mult_18_ab_0__7_), 
        .CO(mult_18_CARRYB_1__6_), .S(mult_18_SUMB_1__6_) );
  FA_X1 mult_18_S3_2_6 ( .A(mult_18_CARRYB_1__6_), .B(mult_18_ab_2__6_), .CI(
        mult_18_ab_1__7_), .CO(mult_18_CARRYB_2__6_), .S(mult_18_SUMB_2__6_)
         );
  FA_X1 mult_18_S2_2_5 ( .A(mult_18_CARRYB_1__5_), .B(mult_18_ab_2__5_), .CI(
        mult_18_SUMB_1__6_), .CO(mult_18_CARRYB_2__5_), .S(mult_18_SUMB_2__5_)
         );
  FA_X1 mult_18_S2_2_3 ( .A(mult_18_ab_2__3_), .B(mult_18_n7), .CI(mult_18_n3), 
        .CO(mult_18_CARRYB_2__3_), .S(mult_18_SUMB_2__3_) );
  FA_X1 mult_18_S2_2_2 ( .A(mult_18_ab_2__2_), .B(mult_18_n8), .CI(mult_18_n4), 
        .CO(mult_18_CARRYB_2__2_), .S(mult_18_SUMB_2__2_) );
  FA_X1 mult_18_S2_2_1 ( .A(mult_18_ab_2__1_), .B(mult_18_n9), .CI(mult_18_n5), 
        .CO(mult_18_CARRYB_2__1_), .S(mult_18_SUMB_2__1_) );
  FA_X1 mult_18_S1_2_0 ( .A(mult_18_ab_2__0_), .B(mult_18_n10), .CI(mult_18_n6), .CO(mult_18_CARRYB_2__0_), .S(mult_18_A1_0_) );
  FA_X1 mult_18_S2_3_5 ( .A(mult_18_ab_3__5_), .B(mult_18_CARRYB_2__5_), .CI(
        mult_18_SUMB_2__6_), .CO(mult_18_CARRYB_3__5_), .S(mult_18_SUMB_3__5_)
         );
  FA_X1 mult_18_S2_3_4 ( .A(mult_18_CARRYB_2__4_), .B(mult_18_ab_3__4_), .CI(
        mult_18_SUMB_2__5_), .CO(mult_18_CARRYB_3__4_), .S(mult_18_SUMB_3__4_)
         );
  FA_X1 mult_18_S2_3_3 ( .A(mult_18_ab_3__3_), .B(mult_18_CARRYB_2__3_), .CI(
        mult_18_SUMB_2__4_), .CO(mult_18_CARRYB_3__3_), .S(mult_18_SUMB_3__3_)
         );
  FA_X1 mult_18_S2_3_2 ( .A(mult_18_ab_3__2_), .B(mult_18_CARRYB_2__2_), .CI(
        mult_18_SUMB_2__3_), .CO(mult_18_CARRYB_3__2_), .S(mult_18_SUMB_3__2_)
         );
  FA_X1 mult_18_S2_3_1 ( .A(mult_18_ab_3__1_), .B(mult_18_CARRYB_2__1_), .CI(
        mult_18_SUMB_2__2_), .CO(mult_18_CARRYB_3__1_), .S(mult_18_SUMB_3__1_)
         );
  FA_X1 mult_18_S1_3_0 ( .A(mult_18_ab_3__0_), .B(mult_18_CARRYB_2__0_), .CI(
        mult_18_SUMB_2__1_), .CO(mult_18_CARRYB_3__0_), .S(mult_18_A1_1_) );
  FA_X1 mult_18_S3_4_6 ( .A(mult_18_ab_4__6_), .B(mult_18_CARRYB_3__6_), .CI(
        mult_18_ab_3__7_), .CO(mult_18_CARRYB_4__6_), .S(mult_18_SUMB_4__6_)
         );
  FA_X1 mult_18_S2_4_5 ( .A(mult_18_ab_4__5_), .B(mult_18_CARRYB_3__5_), .CI(
        mult_18_SUMB_3__6_), .CO(mult_18_CARRYB_4__5_), .S(mult_18_SUMB_4__5_)
         );
  FA_X1 mult_18_S2_4_4 ( .A(mult_18_ab_4__4_), .B(mult_18_CARRYB_3__4_), .CI(
        mult_18_SUMB_3__5_), .CO(mult_18_CARRYB_4__4_), .S(mult_18_SUMB_4__4_)
         );
  FA_X1 mult_18_S2_4_3 ( .A(mult_18_ab_4__3_), .B(mult_18_CARRYB_3__3_), .CI(
        mult_18_SUMB_3__4_), .CO(mult_18_CARRYB_4__3_), .S(mult_18_SUMB_4__3_)
         );
  FA_X1 mult_18_S2_4_2 ( .A(mult_18_ab_4__2_), .B(mult_18_CARRYB_3__2_), .CI(
        mult_18_SUMB_3__3_), .CO(mult_18_CARRYB_4__2_), .S(mult_18_SUMB_4__2_)
         );
  FA_X1 mult_18_S2_4_1 ( .A(mult_18_ab_4__1_), .B(mult_18_CARRYB_3__1_), .CI(
        mult_18_SUMB_3__2_), .CO(mult_18_CARRYB_4__1_), .S(mult_18_SUMB_4__1_)
         );
  FA_X1 mult_18_S1_4_0 ( .A(mult_18_ab_4__0_), .B(mult_18_CARRYB_3__0_), .CI(
        mult_18_SUMB_3__1_), .CO(mult_18_CARRYB_4__0_), .S(mult_18_A1_2_) );
  FA_X1 mult_18_S3_5_6 ( .A(mult_18_ab_5__6_), .B(mult_18_CARRYB_4__6_), .CI(
        mult_18_ab_4__7_), .CO(mult_18_CARRYB_5__6_), .S(mult_18_SUMB_5__6_)
         );
  FA_X1 mult_18_S2_5_5 ( .A(mult_18_ab_5__5_), .B(mult_18_CARRYB_4__5_), .CI(
        mult_18_SUMB_4__6_), .CO(mult_18_CARRYB_5__5_), .S(mult_18_SUMB_5__5_)
         );
  FA_X1 mult_18_S2_5_4 ( .A(mult_18_CARRYB_4__4_), .B(mult_18_ab_5__4_), .CI(
        mult_18_SUMB_4__5_), .CO(mult_18_CARRYB_5__4_), .S(mult_18_SUMB_5__4_)
         );
  FA_X1 mult_18_S2_5_3 ( .A(mult_18_ab_5__3_), .B(mult_18_CARRYB_4__3_), .CI(
        mult_18_SUMB_4__4_), .CO(mult_18_CARRYB_5__3_), .S(mult_18_SUMB_5__3_)
         );
  FA_X1 mult_18_S2_5_2 ( .A(mult_18_ab_5__2_), .B(mult_18_CARRYB_4__2_), .CI(
        mult_18_SUMB_4__3_), .CO(mult_18_CARRYB_5__2_), .S(mult_18_SUMB_5__2_)
         );
  FA_X1 mult_18_S2_5_1 ( .A(mult_18_ab_5__1_), .B(mult_18_CARRYB_4__1_), .CI(
        mult_18_SUMB_4__2_), .CO(mult_18_CARRYB_5__1_), .S(mult_18_SUMB_5__1_)
         );
  FA_X1 mult_18_S1_5_0 ( .A(mult_18_ab_5__0_), .B(mult_18_CARRYB_4__0_), .CI(
        mult_18_SUMB_4__1_), .CO(mult_18_CARRYB_5__0_), .S(mult_18_A1_3_) );
  FA_X1 mult_18_S3_6_6 ( .A(mult_18_ab_6__6_), .B(mult_18_CARRYB_5__6_), .CI(
        mult_18_ab_5__7_), .CO(mult_18_CARRYB_6__6_), .S(mult_18_SUMB_6__6_)
         );
  FA_X1 mult_18_S2_6_5 ( .A(mult_18_ab_6__5_), .B(mult_18_CARRYB_5__5_), .CI(
        mult_18_SUMB_5__6_), .CO(mult_18_CARRYB_6__5_), .S(mult_18_SUMB_6__5_)
         );
  FA_X1 mult_18_S2_6_4 ( .A(mult_18_ab_6__4_), .B(mult_18_CARRYB_5__4_), .CI(
        mult_18_SUMB_5__5_), .CO(mult_18_CARRYB_6__4_), .S(mult_18_SUMB_6__4_)
         );
  FA_X1 mult_18_S2_6_3 ( .A(mult_18_ab_6__3_), .B(mult_18_CARRYB_5__3_), .CI(
        mult_18_SUMB_5__4_), .CO(mult_18_CARRYB_6__3_), .S(mult_18_SUMB_6__3_)
         );
  FA_X1 mult_18_S2_6_2 ( .A(mult_18_ab_6__2_), .B(mult_18_CARRYB_5__2_), .CI(
        mult_18_SUMB_5__3_), .CO(mult_18_CARRYB_6__2_), .S(mult_18_SUMB_6__2_)
         );
  FA_X1 mult_18_S2_6_1 ( .A(mult_18_ab_6__1_), .B(mult_18_CARRYB_5__1_), .CI(
        mult_18_SUMB_5__2_), .CO(mult_18_CARRYB_6__1_), .S(mult_18_SUMB_6__1_)
         );
  FA_X1 mult_18_S1_6_0 ( .A(mult_18_ab_6__0_), .B(mult_18_CARRYB_5__0_), .CI(
        mult_18_SUMB_5__1_), .CO(mult_18_CARRYB_6__0_), .S(mult_18_A1_4_) );
  FA_X1 mult_18_S14_7 ( .A(mult_18_n66), .B(mult_18_n50), .CI(mult_18_ab_7__7_), .CO(mult_18_CARRYB_7__7_), .S(mult_18_SUMB_7__7_) );
  FA_X1 mult_18_S5_6 ( .A(mult_18_ab_7__6_), .B(mult_18_CARRYB_6__6_), .CI(
        mult_18_ab_6__7_), .CO(mult_18_CARRYB_7__6_), .S(mult_18_SUMB_7__6_)
         );
  FA_X1 mult_18_S4_5 ( .A(mult_18_ab_7__5_), .B(mult_18_CARRYB_6__5_), .CI(
        mult_18_SUMB_6__6_), .CO(mult_18_CARRYB_7__5_), .S(mult_18_SUMB_7__5_)
         );
  FA_X1 mult_18_S4_4 ( .A(mult_18_ab_7__4_), .B(mult_18_CARRYB_6__4_), .CI(
        mult_18_SUMB_6__5_), .CO(mult_18_CARRYB_7__4_), .S(mult_18_SUMB_7__4_)
         );
  FA_X1 mult_18_S4_3 ( .A(mult_18_ab_7__3_), .B(mult_18_CARRYB_6__3_), .CI(
        mult_18_SUMB_6__4_), .CO(mult_18_CARRYB_7__3_), .S(mult_18_SUMB_7__3_)
         );
  FA_X1 mult_18_S4_2 ( .A(mult_18_CARRYB_6__2_), .B(mult_18_ab_7__2_), .CI(
        mult_18_SUMB_6__3_), .CO(mult_18_CARRYB_7__2_), .S(mult_18_SUMB_7__2_)
         );
  FA_X1 mult_18_S4_1 ( .A(mult_18_ab_7__1_), .B(mult_18_CARRYB_6__1_), .CI(
        mult_18_SUMB_6__2_), .CO(mult_18_CARRYB_7__1_), .S(mult_18_SUMB_7__1_)
         );
  FA_X1 mult_18_S4_0 ( .A(mult_18_ab_7__0_), .B(mult_18_CARRYB_6__0_), .CI(
        mult_18_SUMB_6__1_), .CO(mult_18_CARRYB_7__0_), .S(mult_18_SUMB_7__0_)
         );
  INV_X1 mult_18_FS_1_U71 ( .A(mult_18_FS_1_n54), .ZN(mult_18_FS_1_n59) );
  INV_X1 mult_18_FS_1_U70 ( .A(mult_18_FS_1_n26), .ZN(mult_18_FS_1_n45) );
  NAND2_X1 mult_18_FS_1_U69 ( .A1(mult_18_FS_1_n45), .A2(mult_18_FS_1_n56), 
        .ZN(mult_18_FS_1_n60) );
  INV_X1 mult_18_FS_1_U68 ( .A(mult_18_FS_1_n25), .ZN(mult_18_FS_1_n24) );
  XNOR2_X1 mult_18_FS_1_U67 ( .A(mult_18_FS_1_n57), .B(mult_18_FS_1_n58), .ZN(
        N13) );
  INV_X1 mult_18_FS_1_U66 ( .A(mult_18_FS_1_n55), .ZN(mult_18_FS_1_n47) );
  XNOR2_X1 mult_18_FS_1_U65 ( .A(mult_18_FS_1_n49), .B(mult_18_FS_1_n50), .ZN(
        N14) );
  NAND2_X1 mult_18_FS_1_U64 ( .A1(mult_18_FS_1_n48), .A2(mult_18_FS_1_n17), 
        .ZN(mult_18_FS_1_n46) );
  INV_X1 mult_18_FS_1_U63 ( .A(mult_18_FS_1_n40), .ZN(mult_18_FS_1_n36) );
  XNOR2_X1 mult_18_FS_1_U62 ( .A(mult_18_FS_1_n32), .B(mult_18_FS_1_n34), .ZN(
        N15) );
  XNOR2_X1 mult_18_FS_1_U61 ( .A(mult_18_FS_1_n27), .B(mult_18_FS_1_n3), .ZN(
        N10) );
  NAND3_X1 mult_18_FS_1_U60 ( .A1(mult_18_FS_1_n22), .A2(mult_18_FS_1_n21), 
        .A3(mult_18_FS_1_n23), .ZN(mult_18_FS_1_n19) );
  XNOR2_X1 mult_18_FS_1_U59 ( .A(mult_18_FS_1_n15), .B(mult_18_FS_1_n16), .ZN(
        N12) );
  OAI211_X1 mult_18_FS_1_U58 ( .C1(mult_18_n36), .C2(mult_18_n41), .A(
        mult_18_A2_6_), .B(mult_18_n35), .ZN(mult_18_FS_1_n26) );
  NAND2_X1 mult_18_FS_1_U57 ( .A1(mult_18_n41), .A2(mult_18_n36), .ZN(
        mult_18_FS_1_n25) );
  OAI21_X1 mult_18_FS_1_U56 ( .B1(mult_18_FS_1_n6), .B2(mult_18_n41), .A(
        mult_18_FS_1_n25), .ZN(mult_18_FS_1_n27) );
  NAND2_X1 mult_18_FS_1_U55 ( .A1(mult_18_FS_1_n7), .A2(mult_18_FS_1_n33), 
        .ZN(mult_18_FS_1_n31) );
  NOR2_X1 mult_18_FS_1_U54 ( .A1(mult_18_FS_1_n45), .A2(mult_18_FS_1_n24), 
        .ZN(mult_18_FS_1_n51) );
  NAND2_X1 mult_18_FS_1_U53 ( .A1(mult_18_FS_1_n24), .A2(mult_18_FS_1_n21), 
        .ZN(mult_18_FS_1_n18) );
  NAND2_X1 mult_18_FS_1_U52 ( .A1(mult_18_FS_1_n56), .A2(mult_18_FS_1_n24), 
        .ZN(mult_18_FS_1_n61) );
  OAI221_X1 mult_18_FS_1_U51 ( .B1(mult_18_FS_1_n35), .B2(mult_18_FS_1_n36), 
        .C1(mult_18_FS_1_n37), .C2(mult_18_FS_1_n38), .A(mult_18_FS_1_n39), 
        .ZN(mult_18_FS_1_n32) );
  OAI211_X1 mult_18_FS_1_U50 ( .C1(mult_18_n40), .C2(mult_18_n42), .A(
        mult_18_n39), .B(mult_18_n38), .ZN(mult_18_FS_1_n48) );
  NAND2_X1 mult_18_FS_1_U49 ( .A1(mult_18_FS_1_n56), .A2(mult_18_FS_1_n41), 
        .ZN(mult_18_FS_1_n52) );
  AND2_X1 mult_18_FS_1_U48 ( .A1(mult_18_A2_6_), .A2(mult_18_n35), .ZN(
        mult_18_FS_1_n23) );
  NAND3_X1 mult_18_FS_1_U47 ( .A1(mult_18_FS_1_n19), .A2(mult_18_FS_1_n20), 
        .A3(mult_18_FS_1_n18), .ZN(mult_18_FS_1_n15) );
  NAND3_X1 mult_18_FS_1_U46 ( .A1(mult_18_FS_1_n60), .A2(mult_18_FS_1_n61), 
        .A3(mult_18_FS_1_n59), .ZN(mult_18_FS_1_n57) );
  BUF_X1 mult_18_FS_1_U45 ( .A(mult_18_A1_5_), .Z(N8) );
  BUF_X1 mult_18_FS_1_U44 ( .A(mult_18_A1_0_), .Z(N3) );
  BUF_X1 mult_18_FS_1_U43 ( .A(mult_18_A1_1_), .Z(N4) );
  BUF_X1 mult_18_FS_1_U42 ( .A(mult_18_A1_2_), .Z(N5) );
  BUF_X1 mult_18_FS_1_U41 ( .A(mult_18_A1_3_), .Z(N6) );
  NAND2_X1 mult_18_FS_1_U40 ( .A1(mult_18_n47), .A2(mult_18_n48), .ZN(
        mult_18_FS_1_n30) );
  BUF_X1 mult_18_FS_1_U39 ( .A(mult_18_A1_4_), .Z(N7) );
  OR2_X1 mult_18_FS_1_U38 ( .A1(mult_18_n47), .A2(mult_18_n48), .ZN(
        mult_18_FS_1_n33) );
  NAND2_X1 mult_18_FS_1_U37 ( .A1(mult_18_n46), .A2(mult_18_n45), .ZN(
        mult_18_FS_1_n39) );
  OR2_X1 mult_18_FS_1_U36 ( .A1(mult_18_n46), .A2(mult_18_n45), .ZN(
        mult_18_FS_1_n40) );
  NAND2_X1 mult_18_FS_1_U35 ( .A1(mult_18_n44), .A2(mult_18_n43), .ZN(
        mult_18_FS_1_n55) );
  INV_X1 mult_18_FS_1_U34 ( .A(mult_18_n42), .ZN(mult_18_FS_1_n43) );
  OR2_X1 mult_18_FS_1_U33 ( .A1(mult_18_n36), .A2(mult_18_n41), .ZN(
        mult_18_FS_1_n22) );
  INV_X1 mult_18_FS_1_U32 ( .A(mult_18_n40), .ZN(mult_18_FS_1_n44) );
  NAND2_X1 mult_18_FS_1_U31 ( .A1(mult_18_n42), .A2(mult_18_n40), .ZN(
        mult_18_FS_1_n17) );
  NAND2_X1 mult_18_FS_1_U30 ( .A1(mult_18_FS_1_n30), .A2(mult_18_FS_1_n31), 
        .ZN(mult_18_FS_1_n28) );
  XNOR2_X1 mult_18_FS_1_U29 ( .A(mult_18_n49), .B(mult_18_A1_13_), .ZN(
        mult_18_FS_1_n29) );
  XNOR2_X1 mult_18_FS_1_U28 ( .A(mult_18_FS_1_n28), .B(mult_18_FS_1_n29), .ZN(
        N16) );
  NAND2_X1 mult_18_FS_1_U27 ( .A1(mult_18_n39), .A2(mult_18_n38), .ZN(
        mult_18_FS_1_n20) );
  NOR2_X1 mult_18_FS_1_U26 ( .A1(mult_18_n40), .A2(mult_18_n42), .ZN(
        mult_18_FS_1_n62) );
  OAI21_X1 mult_18_FS_1_U25 ( .B1(mult_18_FS_1_n62), .B2(mult_18_FS_1_n20), 
        .A(mult_18_FS_1_n17), .ZN(mult_18_FS_1_n54) );
  OAI21_X1 mult_18_FS_1_U24 ( .B1(mult_18_FS_1_n2), .B2(mult_18_n42), .A(
        mult_18_FS_1_n17), .ZN(mult_18_FS_1_n16) );
  AND2_X1 mult_18_FS_1_U23 ( .A1(mult_18_FS_1_n21), .A2(mult_18_FS_1_n20), 
        .ZN(mult_18_FS_1_n8) );
  NAND2_X1 mult_18_FS_1_U22 ( .A1(mult_18_FS_1_n43), .A2(mult_18_FS_1_n44), 
        .ZN(mult_18_FS_1_n42) );
  NAND2_X1 mult_18_FS_1_U21 ( .A1(mult_18_FS_1_n55), .A2(mult_18_FS_1_n41), 
        .ZN(mult_18_FS_1_n58) );
  AOI21_X1 mult_18_FS_1_U20 ( .B1(mult_18_FS_1_n54), .B2(mult_18_FS_1_n41), 
        .A(mult_18_FS_1_n47), .ZN(mult_18_FS_1_n53) );
  OAI21_X1 mult_18_FS_1_U19 ( .B1(mult_18_FS_1_n51), .B2(mult_18_FS_1_n52), 
        .A(mult_18_FS_1_n53), .ZN(mult_18_FS_1_n49) );
  NAND2_X1 mult_18_FS_1_U18 ( .A1(mult_18_FS_1_n40), .A2(mult_18_FS_1_n39), 
        .ZN(mult_18_FS_1_n50) );
  NAND2_X1 mult_18_FS_1_U17 ( .A1(mult_18_FS_1_n30), .A2(mult_18_FS_1_n33), 
        .ZN(mult_18_FS_1_n34) );
  NAND4_X1 mult_18_FS_1_U16 ( .A1(mult_18_FS_1_n40), .A2(mult_18_FS_1_n41), 
        .A3(mult_18_FS_1_n42), .A4(mult_18_FS_1_n21), .ZN(mult_18_FS_1_n38) );
  AOI21_X1 mult_18_FS_1_U15 ( .B1(mult_18_FS_1_n41), .B2(mult_18_FS_1_n46), 
        .A(mult_18_FS_1_n47), .ZN(mult_18_FS_1_n35) );
  OR2_X2 mult_18_FS_1_U14 ( .A1(mult_18_n44), .A2(mult_18_n43), .ZN(
        mult_18_FS_1_n41) );
  OR2_X2 mult_18_FS_1_U13 ( .A1(mult_18_n38), .A2(mult_18_n39), .ZN(
        mult_18_FS_1_n21) );
  AND2_X1 mult_18_FS_1_U12 ( .A1(mult_18_FS_1_n42), .A2(mult_18_FS_1_n21), 
        .ZN(mult_18_FS_1_n56) );
  XNOR2_X1 mult_18_FS_1_U11 ( .A(mult_18_FS_1_n37), .B(mult_18_FS_1_n8), .ZN(
        N11) );
  CLKBUF_X1 mult_18_FS_1_U10 ( .A(mult_18_FS_1_n1), .Z(mult_18_FS_1_n7) );
  CLKBUF_X1 mult_18_FS_1_U9 ( .A(mult_18_n36), .Z(mult_18_FS_1_n6) );
  CLKBUF_X1 mult_18_FS_1_U8 ( .A(mult_18_A2_6_), .Z(mult_18_FS_1_n5) );
  NOR2_X1 mult_18_FS_1_U7 ( .A1(mult_18_FS_1_n5), .A2(mult_18_n35), .ZN(
        mult_18_FS_1_n4) );
  NOR2_X1 mult_18_FS_1_U6 ( .A1(mult_18_FS_1_n3), .A2(mult_18_FS_1_n4), .ZN(N9) );
  AND2_X1 mult_18_FS_1_U5 ( .A1(mult_18_A2_6_), .A2(mult_18_n35), .ZN(
        mult_18_FS_1_n3) );
  INV_X1 mult_18_FS_1_U4 ( .A(mult_18_FS_1_n44), .ZN(mult_18_FS_1_n2) );
  AND2_X2 mult_18_FS_1_U3 ( .A1(mult_18_FS_1_n26), .A2(mult_18_FS_1_n25), .ZN(
        mult_18_FS_1_n37) );
  OAI221_X1 mult_18_FS_1_U2 ( .B1(mult_18_FS_1_n35), .B2(mult_18_FS_1_n36), 
        .C1(mult_18_FS_1_n37), .C2(mult_18_FS_1_n38), .A(mult_18_FS_1_n39), 
        .ZN(mult_18_FS_1_n1) );
  INV_X1 add_18_U147 ( .A(add_18_n71), .ZN(add_18_n67) );
  NAND3_X1 add_18_U146 ( .A1(add_18_n63), .A2(add_18_n129), .A3(add_18_n58), 
        .ZN(add_18_n127) );
  INV_X1 add_18_U145 ( .A(add_18_n116), .ZN(add_18_n115) );
  INV_X1 add_18_U144 ( .A(add_18_n111), .ZN(add_18_n93) );
  XNOR2_X1 add_18_U143 ( .A(add_18_n113), .B(add_18_n114), .ZN(N28) );
  INV_X1 add_18_U142 ( .A(add_18_n35), .ZN(add_18_n112) );
  NAND3_X1 add_18_U141 ( .A1(add_18_n14), .A2(add_18_n26), .A3(add_18_n12), 
        .ZN(add_18_n104) );
  INV_X1 add_18_U140 ( .A(add_18_n101), .ZN(add_18_n109) );
  INV_X1 add_18_U139 ( .A(add_18_n95), .ZN(add_18_n107) );
  NOR2_X1 add_18_U138 ( .A1(add_18_n102), .A2(add_18_n15), .ZN(add_18_n98) );
  XNOR2_X1 add_18_U137 ( .A(add_18_n96), .B(add_18_n97), .ZN(N31) );
  NAND2_X1 add_18_U136 ( .A1(N11), .A2(acc[10]), .ZN(add_18_n92) );
  NAND3_X1 add_18_U135 ( .A1(add_18_n91), .A2(add_18_n32), .A3(add_18_n92), 
        .ZN(add_18_n88) );
  INV_X1 add_18_U134 ( .A(add_18_n90), .ZN(add_18_n89) );
  AOI21_X1 add_18_U133 ( .B1(add_18_n87), .B2(add_18_n88), .A(add_18_n89), 
        .ZN(add_18_n86) );
  NAND3_X1 add_18_U132 ( .A1(acc[13]), .A2(add_18_n7), .A3(add_18_n8), .ZN(
        add_18_n77) );
  NAND3_X1 add_18_U131 ( .A1(add_18_n81), .A2(add_18_n80), .A3(add_18_n24), 
        .ZN(add_18_n79) );
  NAND3_X1 add_18_U130 ( .A1(add_18_n77), .A2(add_18_n79), .A3(add_18_n78), 
        .ZN(add_18_n76) );
  INV_X1 add_18_U129 ( .A(add_18_n69), .ZN(add_18_n66) );
  INV_X1 add_18_U128 ( .A(add_18_n64), .ZN(add_18_n60) );
  INV_X1 add_18_U127 ( .A(add_18_n63), .ZN(add_18_n61) );
  OAI21_X1 add_18_U126 ( .B1(add_18_n60), .B2(add_18_n61), .A(add_18_n62), 
        .ZN(add_18_n56) );
  XNOR2_X1 add_18_U125 ( .A(add_18_n56), .B(add_18_n57), .ZN(N20) );
  XNOR2_X1 add_18_U124 ( .A(add_18_n53), .B(add_18_n54), .ZN(N21) );
  INV_X1 add_18_U123 ( .A(add_18_n45), .ZN(add_18_n41) );
  INV_X1 add_18_U122 ( .A(add_18_n44), .ZN(add_18_n42) );
  OAI21_X1 add_18_U121 ( .B1(add_18_n41), .B2(add_18_n42), .A(add_18_n43), 
        .ZN(add_18_n37) );
  XNOR2_X1 add_18_U120 ( .A(add_18_n38), .B(add_18_n37), .ZN(N24) );
  OAI211_X1 add_18_U119 ( .C1(add_18_n110), .C2(add_18_n21), .A(add_18_n104), 
        .B(add_18_n90), .ZN(add_18_n108) );
  AOI21_X1 add_18_U118 ( .B1(add_18_n108), .B2(add_18_n101), .A(add_18_n24), 
        .ZN(add_18_n105) );
  OAI21_X1 add_18_U117 ( .B1(add_18_n3), .B2(add_18_n85), .A(add_18_n86), .ZN(
        add_18_n75) );
  AOI21_X1 add_18_U116 ( .B1(add_18_n75), .B2(add_18_n74), .A(add_18_n76), 
        .ZN(add_18_n73) );
  NAND2_X1 add_18_U115 ( .A1(N12), .A2(acc[11]), .ZN(add_18_n90) );
  XNOR2_X1 add_18_U114 ( .A(add_18_n73), .B(add_18_n22), .ZN(N32) );
  OAI21_X1 add_18_U113 ( .B1(add_18_n115), .B2(add_18_n93), .A(add_18_n92), 
        .ZN(add_18_n113) );
  NAND2_X1 add_18_U112 ( .A1(N9), .A2(acc[8]), .ZN(add_18_n35) );
  XNOR2_X1 add_18_U111 ( .A(add_18_n105), .B(add_18_n106), .ZN(N30) );
  NAND2_X1 add_18_U110 ( .A1(add_18_n94), .A2(add_18_n10), .ZN(add_18_n103) );
  NAND2_X1 add_18_U109 ( .A1(add_18_n16), .A2(add_18_n26), .ZN(add_18_n110) );
  NAND2_X1 add_18_U108 ( .A1(add_18_n14), .A2(add_18_n26), .ZN(add_18_n85) );
  NAND2_X1 add_18_U107 ( .A1(add_18_n90), .A2(add_18_n26), .ZN(add_18_n114) );
  INV_X1 add_18_U106 ( .A(N10), .ZN(add_18_n119) );
  NAND2_X1 add_18_U105 ( .A1(add_18_n5), .A2(acc[9]), .ZN(add_18_n32) );
  NAND2_X1 add_18_U104 ( .A1(add_18_n112), .A2(add_18_n31), .ZN(add_18_n91) );
  NAND2_X1 add_18_U103 ( .A1(add_18_n29), .A2(add_18_n28), .ZN(add_18_n118) );
  NAND2_X1 add_18_U102 ( .A1(add_18_n31), .A2(add_18_n32), .ZN(add_18_n30) );
  OAI21_X1 add_18_U101 ( .B1(add_18_n98), .B2(add_18_n99), .A(add_18_n100), 
        .ZN(add_18_n96) );
  NAND2_X1 add_18_U100 ( .A1(add_18_n18), .A2(acc[14]), .ZN(add_18_n78) );
  INV_X1 add_18_U99 ( .A(N14), .ZN(add_18_n82) );
  NAND2_X1 add_18_U98 ( .A1(add_18_n119), .A2(add_18_n120), .ZN(add_18_n31) );
  NAND2_X1 add_18_U97 ( .A1(add_18_n119), .A2(add_18_n120), .ZN(add_18_n28) );
  NAND2_X1 add_18_U96 ( .A1(add_18_n33), .A2(add_18_n36), .ZN(add_18_n84) );
  OR2_X1 add_18_U95 ( .A1(acc[12]), .A2(N13), .ZN(add_18_n27) );
  AND3_X1 add_18_U94 ( .A1(add_18_n95), .A2(add_18_n17), .A3(add_18_n27), .ZN(
        add_18_n74) );
  NAND2_X1 add_18_U93 ( .A1(add_18_n84), .A2(add_18_n35), .ZN(add_18_n29) );
  NAND2_X1 add_18_U92 ( .A1(add_18_n118), .A2(add_18_n32), .ZN(add_18_n116) );
  XNOR2_X1 add_18_U91 ( .A(add_18_n116), .B(add_18_n117), .ZN(N27) );
  NAND2_X1 add_18_U90 ( .A1(add_18_n82), .A2(add_18_n83), .ZN(add_18_n80) );
  NAND2_X1 add_18_U89 ( .A1(add_18_n82), .A2(add_18_n83), .ZN(add_18_n95) );
  OR2_X1 add_18_U88 ( .A1(N12), .A2(acc[11]), .ZN(add_18_n94) );
  NAND2_X1 add_18_U87 ( .A1(add_18_n92), .A2(add_18_n16), .ZN(add_18_n117) );
  NAND2_X1 add_18_U86 ( .A1(add_18_n36), .A2(add_18_n35), .ZN(add_18_n34) );
  AOI21_X1 add_18_U85 ( .B1(add_18_n95), .B2(add_18_n24), .A(add_18_n25), .ZN(
        add_18_n100) );
  NAND2_X1 add_18_U84 ( .A1(add_18_n95), .A2(add_18_n101), .ZN(add_18_n99) );
  OAI21_X1 add_18_U83 ( .B1(add_18_n103), .B2(add_18_n23), .A(add_18_n90), 
        .ZN(add_18_n102) );
  XNOR2_X1 add_18_U82 ( .A(add_18_n29), .B(add_18_n30), .ZN(N26) );
  NAND2_X1 add_18_U81 ( .A1(add_18_n78), .A2(add_18_n17), .ZN(add_18_n97) );
  INV_X1 add_18_U80 ( .A(acc[0]), .ZN(add_18_n131) );
  NAND2_X1 add_18_U79 ( .A1(add_18_n130), .A2(add_18_n131), .ZN(add_18_n128)
         );
  INV_X1 add_18_U78 ( .A(acc[13]), .ZN(add_18_n83) );
  INV_X1 add_18_U77 ( .A(acc[9]), .ZN(add_18_n120) );
  NAND2_X1 add_18_U76 ( .A1(N1), .A2(acc[0]), .ZN(add_18_n72) );
  NAND2_X1 add_18_U75 ( .A1(N2), .A2(acc[1]), .ZN(add_18_n68) );
  OR2_X1 add_18_U74 ( .A1(N2), .A2(acc[1]), .ZN(add_18_n71) );
  OR2_X1 add_18_U73 ( .A1(N3), .A2(acc[2]), .ZN(add_18_n63) );
  NAND2_X1 add_18_U72 ( .A1(N3), .A2(acc[2]), .ZN(add_18_n62) );
  NAND2_X1 add_18_U71 ( .A1(N4), .A2(acc[3]), .ZN(add_18_n59) );
  OR2_X1 add_18_U70 ( .A1(N4), .A2(acc[3]), .ZN(add_18_n58) );
  NAND2_X1 add_18_U69 ( .A1(N5), .A2(acc[4]), .ZN(add_18_n52) );
  NAND2_X1 add_18_U68 ( .A1(N6), .A2(acc[5]), .ZN(add_18_n48) );
  OR2_X2 add_18_U67 ( .A1(N6), .A2(acc[5]), .ZN(add_18_n49) );
  NAND2_X1 add_18_U66 ( .A1(N7), .A2(acc[6]), .ZN(add_18_n43) );
  OR2_X1 add_18_U65 ( .A1(N9), .A2(acc[8]), .ZN(add_18_n36) );
  NAND2_X1 add_18_U64 ( .A1(N8), .A2(acc[7]), .ZN(add_18_n40) );
  AND2_X1 add_18_U63 ( .A1(add_18_n8), .A2(acc[13]), .ZN(add_18_n25) );
  AND2_X1 add_18_U62 ( .A1(N13), .A2(acc[12]), .ZN(add_18_n24) );
  AND3_X1 add_18_U61 ( .A1(add_18_n91), .A2(add_18_n32), .A3(add_18_n92), .ZN(
        add_18_n23) );
  OR2_X2 add_18_U60 ( .A1(N8), .A2(acc[7]), .ZN(add_18_n39) );
  INV_X1 add_18_U59 ( .A(add_18_n72), .ZN(add_18_n69) );
  NAND2_X1 add_18_U58 ( .A1(add_18_n71), .A2(add_18_n68), .ZN(add_18_n70) );
  XNOR2_X1 add_18_U57 ( .A(add_18_n69), .B(add_18_n70), .ZN(N18) );
  OAI21_X1 add_18_U56 ( .B1(add_18_n66), .B2(add_18_n67), .A(add_18_n68), .ZN(
        add_18_n64) );
  NAND2_X1 add_18_U55 ( .A1(add_18_n63), .A2(add_18_n62), .ZN(add_18_n65) );
  XNOR2_X1 add_18_U54 ( .A(add_18_n64), .B(add_18_n65), .ZN(N19) );
  NAND2_X1 add_18_U53 ( .A1(add_18_n58), .A2(add_18_n59), .ZN(add_18_n57) );
  NAND2_X1 add_18_U52 ( .A1(add_18_n55), .A2(add_18_n52), .ZN(add_18_n54) );
  NAND2_X1 add_18_U51 ( .A1(add_18_n51), .A2(add_18_n52), .ZN(add_18_n50) );
  NAND2_X1 add_18_U50 ( .A1(add_18_n49), .A2(add_18_n50), .ZN(add_18_n47) );
  NAND2_X1 add_18_U49 ( .A1(add_18_n47), .A2(add_18_n48), .ZN(add_18_n45) );
  NAND2_X1 add_18_U48 ( .A1(add_18_n44), .A2(add_18_n43), .ZN(add_18_n46) );
  XNOR2_X1 add_18_U47 ( .A(add_18_n45), .B(add_18_n46), .ZN(N23) );
  OAI211_X1 add_18_U46 ( .C1(add_18_n67), .C2(add_18_n72), .A(add_18_n68), .B(
        add_18_n62), .ZN(add_18_n129) );
  NAND2_X1 add_18_U45 ( .A1(add_18_n127), .A2(add_18_n59), .ZN(add_18_n53) );
  NAND2_X1 add_18_U44 ( .A1(add_18_n53), .A2(add_18_n55), .ZN(add_18_n51) );
  NAND2_X1 add_18_U43 ( .A1(add_18_n39), .A2(add_18_n40), .ZN(add_18_n38) );
  INV_X1 add_18_U42 ( .A(add_18_n49), .ZN(add_18_n125) );
  OAI211_X1 add_18_U41 ( .C1(add_18_n125), .C2(add_18_n52), .A(add_18_n48), 
        .B(add_18_n43), .ZN(add_18_n124) );
  XNOR2_X1 add_18_U40 ( .A(add_18_n13), .B(add_18_n34), .ZN(N25) );
  NOR2_X1 add_18_U39 ( .A1(add_18_n107), .A2(add_18_n25), .ZN(add_18_n106) );
  AND3_X1 add_18_U38 ( .A1(add_18_n32), .A2(add_18_n92), .A3(add_18_n91), .ZN(
        add_18_n21) );
  NAND2_X1 add_18_U37 ( .A1(add_18_n44), .A2(add_18_n39), .ZN(add_18_n121) );
  NAND2_X1 add_18_U36 ( .A1(add_18_n49), .A2(add_18_n126), .ZN(add_18_n122) );
  OAI211_X1 add_18_U35 ( .C1(add_18_n121), .C2(add_18_n122), .A(add_18_n123), 
        .B(add_18_n40), .ZN(add_18_n33) );
  INV_X1 add_18_U34 ( .A(N1), .ZN(add_18_n130) );
  INV_X1 add_18_U33 ( .A(add_18_n51), .ZN(add_18_n126) );
  AND2_X1 add_18_U32 ( .A1(add_18_n128), .A2(add_18_n72), .ZN(N17) );
  OR2_X1 add_18_U31 ( .A1(N5), .A2(acc[4]), .ZN(add_18_n55) );
  AND2_X1 add_18_U30 ( .A1(add_18_n49), .A2(add_18_n48), .ZN(add_18_n19) );
  XOR2_X1 add_18_U29 ( .A(add_18_n50), .B(add_18_n19), .Z(N22) );
  CLKBUF_X1 add_18_U28 ( .A(N15), .Z(add_18_n18) );
  OR2_X1 add_18_U27 ( .A1(N15), .A2(acc[14]), .ZN(add_18_n81) );
  OR2_X1 add_18_U26 ( .A1(acc[14]), .A2(N15), .ZN(add_18_n17) );
  AND3_X1 add_18_U25 ( .A1(add_18_n14), .A2(add_18_n26), .A3(add_18_n12), .ZN(
        add_18_n15) );
  OAI211_X1 add_18_U24 ( .C1(add_18_n121), .C2(add_18_n122), .A(add_18_n123), 
        .B(add_18_n40), .ZN(add_18_n13) );
  AND2_X1 add_18_U23 ( .A1(add_18_n13), .A2(add_18_n36), .ZN(add_18_n12) );
  OR2_X1 add_18_U22 ( .A1(N11), .A2(acc[10]), .ZN(add_18_n111) );
  OR2_X1 add_18_U21 ( .A1(N11), .A2(acc[10]), .ZN(add_18_n11) );
  OAI211_X1 add_18_U20 ( .C1(add_18_n110), .C2(add_18_n21), .A(add_18_n6), .B(
        add_18_n90), .ZN(add_18_n9) );
  AND2_X1 add_18_U19 ( .A1(add_18_n94), .A2(add_18_n111), .ZN(add_18_n87) );
  OR2_X1 add_18_U18 ( .A1(N7), .A2(acc[6]), .ZN(add_18_n44) );
  NAND2_X1 add_18_U17 ( .A1(add_18_n39), .A2(add_18_n1), .ZN(add_18_n123) );
  OR2_X1 add_18_U16 ( .A1(N15), .A2(acc[14]), .ZN(add_18_n7) );
  NAND3_X1 add_18_U15 ( .A1(add_18_n14), .A2(add_18_n26), .A3(add_18_n12), 
        .ZN(add_18_n6) );
  CLKBUF_X1 add_18_U14 ( .A(N10), .Z(add_18_n5) );
  XNOR2_X1 add_18_U13 ( .A(N16), .B(add_18_n4), .ZN(add_18_n22) );
  INV_X1 add_18_U12 ( .A(acc[15]), .ZN(add_18_n4) );
  CLKBUF_X1 add_18_U11 ( .A(add_18_n84), .Z(add_18_n3) );
  OR2_X2 add_18_U10 ( .A1(N12), .A2(acc[11]), .ZN(add_18_n26) );
  BUF_X1 add_18_U9 ( .A(add_18_n111), .Z(add_18_n16) );
  OR2_X1 add_18_U8 ( .A1(add_18_n109), .A2(add_18_n24), .ZN(add_18_n2) );
  XNOR2_X1 add_18_U7 ( .A(add_18_n9), .B(add_18_n2), .ZN(N29) );
  AND2_X1 add_18_U6 ( .A1(add_18_n124), .A2(add_18_n44), .ZN(add_18_n1) );
  OR2_X1 add_18_U5 ( .A1(N13), .A2(acc[12]), .ZN(add_18_n101) );
  BUF_X1 add_18_U4 ( .A(N14), .Z(add_18_n8) );
  AND2_X2 add_18_U3 ( .A1(add_18_n11), .A2(add_18_n28), .ZN(add_18_n14) );
  BUF_X1 add_18_U2 ( .A(add_18_n11), .Z(add_18_n10) );
endmodule

