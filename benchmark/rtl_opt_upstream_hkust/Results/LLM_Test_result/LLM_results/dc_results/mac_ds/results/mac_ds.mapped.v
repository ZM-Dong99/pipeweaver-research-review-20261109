/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:06:33 2025
/////////////////////////////////////////////////////////////


module mac_ds ( clk, a, b, reset, z );
  input [7:0] a;
  input [7:0] b;
  output [15:0] z;
  input clk, reset;
  wire   N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16,
         N17, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30, N31,
         N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44, N45,
         N46, N47, N48, N49, N50, n5, mult_12_n86, mult_12_n85, mult_12_n84,
         mult_12_n83, mult_12_n82, mult_12_n81, mult_12_n80, mult_12_n79,
         mult_12_n78, mult_12_n77, mult_12_n76, mult_12_n75, mult_12_n74,
         mult_12_n73, mult_12_n72, mult_12_n71, mult_12_n70, mult_12_n69,
         mult_12_n68, mult_12_n67, mult_12_n66, mult_12_n65, mult_12_n64,
         mult_12_n63, mult_12_n62, mult_12_n61, mult_12_n60, mult_12_n59,
         mult_12_n58, mult_12_n57, mult_12_n56, mult_12_n55, mult_12_n54,
         mult_12_n52, mult_12_n51, mult_12_n50, mult_12_n49, mult_12_n48,
         mult_12_n47, mult_12_n46, mult_12_n45, mult_12_n44, mult_12_n43,
         mult_12_n42, mult_12_n41, mult_12_n40, mult_12_n39, mult_12_n38,
         mult_12_n37, mult_12_n36, mult_12_n35, mult_12_n34, mult_12_n33,
         mult_12_n32, mult_12_n31, mult_12_n30, mult_12_n29, mult_12_n28,
         mult_12_n27, mult_12_n26, mult_12_n25, mult_12_n24, mult_12_n23,
         mult_12_n22, mult_12_n21, mult_12_n20, mult_12_n19, mult_12_n18,
         mult_12_n17, mult_12_n16, mult_12_n15, mult_12_n14, mult_12_n13,
         mult_12_n12, mult_12_n11, mult_12_n10, mult_12_n9, mult_12_n8,
         mult_12_n7, mult_12_n6, mult_12_n5, mult_12_n4, mult_12_n3,
         mult_12_n2, mult_12_A2_6_, mult_12_A1_0_, mult_12_A1_1_,
         mult_12_A1_2_, mult_12_A1_3_, mult_12_A1_4_, mult_12_A1_5_,
         mult_12_A1_13_, mult_12_SUMB_1__6_, mult_12_SUMB_2__1_,
         mult_12_SUMB_2__2_, mult_12_SUMB_2__3_, mult_12_SUMB_2__4_,
         mult_12_SUMB_2__5_, mult_12_SUMB_2__6_, mult_12_SUMB_3__1_,
         mult_12_SUMB_3__2_, mult_12_SUMB_3__3_, mult_12_SUMB_3__4_,
         mult_12_SUMB_3__5_, mult_12_SUMB_3__6_, mult_12_SUMB_4__1_,
         mult_12_SUMB_4__2_, mult_12_SUMB_4__3_, mult_12_SUMB_4__4_,
         mult_12_SUMB_4__5_, mult_12_SUMB_4__6_, mult_12_SUMB_5__1_,
         mult_12_SUMB_5__2_, mult_12_SUMB_5__3_, mult_12_SUMB_5__4_,
         mult_12_SUMB_5__5_, mult_12_SUMB_5__6_, mult_12_SUMB_6__1_,
         mult_12_SUMB_6__2_, mult_12_SUMB_6__3_, mult_12_SUMB_6__4_,
         mult_12_SUMB_6__5_, mult_12_SUMB_6__6_, mult_12_SUMB_7__0_,
         mult_12_SUMB_7__1_, mult_12_SUMB_7__2_, mult_12_SUMB_7__3_,
         mult_12_SUMB_7__4_, mult_12_SUMB_7__5_, mult_12_SUMB_7__6_,
         mult_12_SUMB_7__7_, mult_12_CARRYB_1__6_, mult_12_CARRYB_2__0_,
         mult_12_CARRYB_2__1_, mult_12_CARRYB_2__2_, mult_12_CARRYB_2__3_,
         mult_12_CARRYB_2__4_, mult_12_CARRYB_2__5_, mult_12_CARRYB_2__6_,
         mult_12_CARRYB_3__0_, mult_12_CARRYB_3__1_, mult_12_CARRYB_3__2_,
         mult_12_CARRYB_3__3_, mult_12_CARRYB_3__4_, mult_12_CARRYB_3__5_,
         mult_12_CARRYB_3__6_, mult_12_CARRYB_4__0_, mult_12_CARRYB_4__1_,
         mult_12_CARRYB_4__2_, mult_12_CARRYB_4__3_, mult_12_CARRYB_4__4_,
         mult_12_CARRYB_4__5_, mult_12_CARRYB_4__6_, mult_12_CARRYB_5__0_,
         mult_12_CARRYB_5__1_, mult_12_CARRYB_5__2_, mult_12_CARRYB_5__3_,
         mult_12_CARRYB_5__4_, mult_12_CARRYB_5__5_, mult_12_CARRYB_5__6_,
         mult_12_CARRYB_6__0_, mult_12_CARRYB_6__1_, mult_12_CARRYB_6__2_,
         mult_12_CARRYB_6__3_, mult_12_CARRYB_6__4_, mult_12_CARRYB_6__5_,
         mult_12_CARRYB_6__6_, mult_12_CARRYB_7__0_, mult_12_CARRYB_7__1_,
         mult_12_CARRYB_7__2_, mult_12_CARRYB_7__3_, mult_12_CARRYB_7__4_,
         mult_12_CARRYB_7__5_, mult_12_CARRYB_7__6_, mult_12_CARRYB_7__7_,
         mult_12_ab_0__1_, mult_12_ab_0__2_, mult_12_ab_0__3_,
         mult_12_ab_0__5_, mult_12_ab_0__6_, mult_12_ab_0__7_,
         mult_12_ab_1__0_, mult_12_ab_1__1_, mult_12_ab_1__2_,
         mult_12_ab_1__3_, mult_12_ab_1__4_, mult_12_ab_1__5_,
         mult_12_ab_1__6_, mult_12_ab_1__7_, mult_12_ab_2__0_,
         mult_12_ab_2__1_, mult_12_ab_2__2_, mult_12_ab_2__3_,
         mult_12_ab_2__4_, mult_12_ab_2__5_, mult_12_ab_2__6_,
         mult_12_ab_2__7_, mult_12_ab_3__0_, mult_12_ab_3__1_,
         mult_12_ab_3__2_, mult_12_ab_3__3_, mult_12_ab_3__4_,
         mult_12_ab_3__5_, mult_12_ab_3__6_, mult_12_ab_3__7_,
         mult_12_ab_4__0_, mult_12_ab_4__1_, mult_12_ab_4__2_,
         mult_12_ab_4__3_, mult_12_ab_4__4_, mult_12_ab_4__5_,
         mult_12_ab_4__6_, mult_12_ab_4__7_, mult_12_ab_5__0_,
         mult_12_ab_5__1_, mult_12_ab_5__2_, mult_12_ab_5__3_,
         mult_12_ab_5__4_, mult_12_ab_5__5_, mult_12_ab_5__6_,
         mult_12_ab_5__7_, mult_12_ab_6__0_, mult_12_ab_6__1_,
         mult_12_ab_6__2_, mult_12_ab_6__3_, mult_12_ab_6__4_,
         mult_12_ab_6__5_, mult_12_ab_6__6_, mult_12_ab_6__7_,
         mult_12_ab_7__0_, mult_12_ab_7__1_, mult_12_ab_7__2_,
         mult_12_ab_7__3_, mult_12_ab_7__4_, mult_12_ab_7__5_,
         mult_12_ab_7__6_, mult_12_ab_7__7_, mult_12_FS_1_n75,
         mult_12_FS_1_n74, mult_12_FS_1_n73, mult_12_FS_1_n72,
         mult_12_FS_1_n71, mult_12_FS_1_n70, mult_12_FS_1_n69,
         mult_12_FS_1_n68, mult_12_FS_1_n67, mult_12_FS_1_n66,
         mult_12_FS_1_n65, mult_12_FS_1_n64, mult_12_FS_1_n63,
         mult_12_FS_1_n62, mult_12_FS_1_n61, mult_12_FS_1_n60,
         mult_12_FS_1_n59, mult_12_FS_1_n58, mult_12_FS_1_n57,
         mult_12_FS_1_n56, mult_12_FS_1_n55, mult_12_FS_1_n54,
         mult_12_FS_1_n53, mult_12_FS_1_n52, mult_12_FS_1_n51,
         mult_12_FS_1_n50, mult_12_FS_1_n49, mult_12_FS_1_n48,
         mult_12_FS_1_n47, mult_12_FS_1_n46, mult_12_FS_1_n45,
         mult_12_FS_1_n44, mult_12_FS_1_n43, mult_12_FS_1_n42,
         mult_12_FS_1_n41, mult_12_FS_1_n40, mult_12_FS_1_n39,
         mult_12_FS_1_n38, mult_12_FS_1_n37, mult_12_FS_1_n36,
         mult_12_FS_1_n35, mult_12_FS_1_n34, mult_12_FS_1_n33,
         mult_12_FS_1_n32, mult_12_FS_1_n31, mult_12_FS_1_n30,
         mult_12_FS_1_n29, mult_12_FS_1_n28, mult_12_FS_1_n27,
         mult_12_FS_1_n26, mult_12_FS_1_n25, mult_12_FS_1_n24,
         mult_12_FS_1_n23, mult_12_FS_1_n15, mult_12_FS_1_n14,
         mult_12_FS_1_n13, mult_12_FS_1_n12, mult_12_FS_1_n11,
         mult_12_FS_1_n10, mult_12_FS_1_n9, mult_12_FS_1_n8, mult_12_FS_1_n7,
         mult_12_FS_1_n6, mult_12_FS_1_n5, mult_12_FS_1_n4, mult_12_FS_1_n3,
         mult_12_FS_1_n2, mult_12_FS_1_n1, add_17_n189, add_17_n188,
         add_17_n187, add_17_n186, add_17_n185, add_17_n184, add_17_n183,
         add_17_n182, add_17_n181, add_17_n180, add_17_n179, add_17_n178,
         add_17_n177, add_17_n176, add_17_n175, add_17_n174, add_17_n173,
         add_17_n172, add_17_n171, add_17_n170, add_17_n169, add_17_n168,
         add_17_n167, add_17_n166, add_17_n165, add_17_n164, add_17_n163,
         add_17_n162, add_17_n161, add_17_n160, add_17_n159, add_17_n158,
         add_17_n157, add_17_n156, add_17_n155, add_17_n154, add_17_n153,
         add_17_n152, add_17_n151, add_17_n150, add_17_n149, add_17_n148,
         add_17_n147, add_17_n146, add_17_n145, add_17_n144, add_17_n143,
         add_17_n142, add_17_n141, add_17_n140, add_17_n139, add_17_n138,
         add_17_n137, add_17_n136, add_17_n135, add_17_n134, add_17_n133,
         add_17_n132, add_17_n131, add_17_n130, add_17_n129, add_17_n128,
         add_17_n127, add_17_n126, add_17_n125, add_17_n124, add_17_n123,
         add_17_n122, add_17_n121, add_17_n120, add_17_n119, add_17_n118,
         add_17_n117, add_17_n116, add_17_n115, add_17_n114, add_17_n113,
         add_17_n112, add_17_n111, add_17_n110, add_17_n109, add_17_n108,
         add_17_n107, add_17_n106, add_17_n105, add_17_n104, add_17_n103,
         add_17_n102, add_17_n101, add_17_n100, add_17_n99, add_17_n98,
         add_17_n97, add_17_n96, add_17_n95, add_17_n94, add_17_n93,
         add_17_n92, add_17_n91, add_17_n90, add_17_n89, add_17_n88,
         add_17_n87, add_17_n86, add_17_n85, add_17_n84, add_17_n83,
         add_17_n82, add_17_n81, add_17_n80, add_17_n79, add_17_n78,
         add_17_n77, add_17_n76, add_17_n75, add_17_n74, add_17_n73,
         add_17_n72, add_17_n71, add_17_n70, add_17_n69, add_17_n68,
         add_17_n67, add_17_n66, add_17_n65, add_17_n64, add_17_n63,
         add_17_n62, add_17_n61, add_17_n60, add_17_n59, add_17_n58,
         add_17_n57, add_17_n56, add_17_n55, add_17_n54, add_17_n53,
         add_17_n52, add_17_n51, add_17_n50, add_17_n49, add_17_n48,
         add_17_n47, add_17_n46, add_17_n45, add_17_n44, add_17_n43,
         add_17_n42, add_17_n41, add_17_n40, add_17_n39, add_17_n38,
         add_17_n37, add_17_n36, add_17_n35, add_17_n34, add_17_n33,
         add_17_n32, add_17_n31, add_17_n30, add_17_n29, add_17_n28,
         add_17_n27, add_17_n26, add_17_n25, add_17_n24, add_17_n23,
         add_17_n22, add_17_n21, add_17_n20, add_17_n19, add_17_n18,
         add_17_n17, add_17_n16, add_17_n15, add_17_n14, add_17_n13,
         add_17_n12, add_17_n11, add_17_n10, add_17_n9, add_17_n8, add_17_n7,
         add_17_n6, add_17_n5, add_17_n4, add_17_n3, add_17_n2;
  wire   [15:0] acc;
  wire   [15:0] product;

  DFF_X1 product_reg_7_ ( .D(N9), .CK(clk), .Q(product[7]) );
  DFF_X1 product_reg_6_ ( .D(N8), .CK(clk), .Q(product[6]) );
  DFF_X1 product_reg_5_ ( .D(N7), .CK(clk), .Q(product[5]) );
  DFF_X1 product_reg_4_ ( .D(N6), .CK(clk), .Q(product[4]) );
  DFF_X1 product_reg_3_ ( .D(N5), .CK(clk), .Q(product[3]) );
  DFF_X1 product_reg_2_ ( .D(N4), .CK(clk), .Q(product[2]) );
  DFF_X1 product_reg_1_ ( .D(N3), .CK(clk), .Q(product[1]) );
  DFF_X1 product_reg_0_ ( .D(N2), .CK(clk), .Q(product[0]) );
  DFF_X1 acc_reg_0_ ( .D(N35), .CK(clk), .Q(acc[0]) );
  DFF_X1 z_reg_0_ ( .D(acc[0]), .CK(clk), .Q(z[0]) );
  DFF_X1 acc_reg_1_ ( .D(N36), .CK(clk), .Q(acc[1]) );
  DFF_X1 z_reg_1_ ( .D(acc[1]), .CK(clk), .Q(z[1]) );
  DFF_X1 acc_reg_2_ ( .D(N37), .CK(clk), .Q(acc[2]) );
  DFF_X1 z_reg_2_ ( .D(acc[2]), .CK(clk), .Q(z[2]) );
  DFF_X1 acc_reg_3_ ( .D(N38), .CK(clk), .Q(acc[3]) );
  DFF_X1 z_reg_3_ ( .D(acc[3]), .CK(clk), .Q(z[3]) );
  DFF_X1 acc_reg_4_ ( .D(N39), .CK(clk), .Q(acc[4]) );
  DFF_X1 z_reg_4_ ( .D(acc[4]), .CK(clk), .Q(z[4]) );
  DFF_X1 acc_reg_5_ ( .D(N40), .CK(clk), .Q(acc[5]) );
  DFF_X1 z_reg_5_ ( .D(acc[5]), .CK(clk), .Q(z[5]) );
  DFF_X1 acc_reg_6_ ( .D(N41), .CK(clk), .Q(acc[6]) );
  DFF_X1 z_reg_6_ ( .D(acc[6]), .CK(clk), .Q(z[6]) );
  DFF_X1 acc_reg_7_ ( .D(N42), .CK(clk), .Q(acc[7]) );
  DFF_X1 z_reg_7_ ( .D(acc[7]), .CK(clk), .Q(z[7]) );
  DFF_X1 acc_reg_8_ ( .D(N43), .CK(clk), .Q(acc[8]) );
  DFF_X1 z_reg_8_ ( .D(acc[8]), .CK(clk), .Q(z[8]) );
  DFF_X1 acc_reg_9_ ( .D(N44), .CK(clk), .Q(acc[9]) );
  DFF_X1 z_reg_9_ ( .D(acc[9]), .CK(clk), .Q(z[9]) );
  DFF_X1 acc_reg_10_ ( .D(N45), .CK(clk), .Q(acc[10]) );
  DFF_X1 z_reg_10_ ( .D(acc[10]), .CK(clk), .Q(z[10]) );
  DFF_X1 acc_reg_11_ ( .D(N46), .CK(clk), .Q(acc[11]) );
  DFF_X1 z_reg_11_ ( .D(acc[11]), .CK(clk), .Q(z[11]) );
  DFF_X1 acc_reg_12_ ( .D(N47), .CK(clk), .Q(acc[12]) );
  DFF_X1 z_reg_12_ ( .D(acc[12]), .CK(clk), .Q(z[12]) );
  DFF_X1 acc_reg_13_ ( .D(N48), .CK(clk), .Q(acc[13]) );
  DFF_X1 z_reg_13_ ( .D(acc[13]), .CK(clk), .Q(z[13]) );
  DFF_X1 acc_reg_14_ ( .D(N49), .CK(clk), .Q(acc[14]) );
  DFF_X1 z_reg_14_ ( .D(acc[14]), .CK(clk), .Q(z[14]) );
  DFF_X1 acc_reg_15_ ( .D(N50), .CK(clk), .Q(acc[15]) );
  DFF_X1 z_reg_15_ ( .D(acc[15]), .CK(clk), .Q(z[15]) );
  DFF_X1 product_reg_8_ ( .D(N10), .CK(clk), .Q(product[8]) );
  DFF_X1 product_reg_9_ ( .D(N11), .CK(clk), .Q(product[9]) );
  DFF_X1 product_reg_10_ ( .D(N12), .CK(clk), .Q(product[10]) );
  DFF_X1 product_reg_15_ ( .D(N17), .CK(clk), .Q(product[15]) );
  DFF_X1 product_reg_14_ ( .D(N16), .CK(clk), .Q(product[14]) );
  DFF_X2 product_reg_13_ ( .D(N15), .CK(clk), .Q(product[13]) );
  DFF_X2 product_reg_11_ ( .D(N13), .CK(clk), .Q(product[11]) );
  DFF_X2 product_reg_12_ ( .D(N14), .CK(clk), .Q(product[12]) );
  INV_X1 U21 ( .A(reset), .ZN(n5) );
  AND2_X1 U22 ( .A1(N34), .A2(n5), .ZN(N50) );
  AND2_X1 U23 ( .A1(N33), .A2(n5), .ZN(N49) );
  AND2_X1 U24 ( .A1(N32), .A2(n5), .ZN(N48) );
  AND2_X1 U25 ( .A1(N31), .A2(n5), .ZN(N47) );
  AND2_X1 U26 ( .A1(N30), .A2(n5), .ZN(N46) );
  AND2_X1 U27 ( .A1(N29), .A2(n5), .ZN(N45) );
  AND2_X1 U28 ( .A1(N28), .A2(n5), .ZN(N44) );
  AND2_X1 U29 ( .A1(N27), .A2(n5), .ZN(N43) );
  AND2_X1 U30 ( .A1(N26), .A2(n5), .ZN(N42) );
  AND2_X1 U31 ( .A1(N25), .A2(n5), .ZN(N41) );
  AND2_X1 U32 ( .A1(N24), .A2(n5), .ZN(N40) );
  AND2_X1 U33 ( .A1(N23), .A2(n5), .ZN(N39) );
  AND2_X1 U34 ( .A1(N22), .A2(n5), .ZN(N38) );
  AND2_X1 U35 ( .A1(N21), .A2(n5), .ZN(N37) );
  AND2_X1 U36 ( .A1(N20), .A2(n5), .ZN(N36) );
  AND2_X1 U37 ( .A1(N19), .A2(n5), .ZN(N35) );
  INV_X1 mult_12_U164 ( .A(mult_12_CARRYB_7__7_), .ZN(mult_12_A1_13_) );
  NOR2_X1 mult_12_U163 ( .A1(mult_12_n84), .A2(mult_12_n83), .ZN(N2) );
  NOR2_X1 mult_12_U162 ( .A1(b[0]), .A2(mult_12_n85), .ZN(mult_12_ab_7__0_) );
  NOR2_X1 mult_12_U161 ( .A1(b[1]), .A2(mult_12_n85), .ZN(mult_12_ab_7__1_) );
  NOR2_X1 mult_12_U160 ( .A1(b[2]), .A2(mult_12_n85), .ZN(mult_12_ab_7__2_) );
  NOR2_X1 mult_12_U159 ( .A1(b[3]), .A2(mult_12_n85), .ZN(mult_12_ab_7__3_) );
  NOR2_X1 mult_12_U158 ( .A1(b[4]), .A2(mult_12_n85), .ZN(mult_12_ab_7__4_) );
  NOR2_X1 mult_12_U157 ( .A1(b[5]), .A2(mult_12_n85), .ZN(mult_12_ab_7__5_) );
  NOR2_X1 mult_12_U156 ( .A1(a[6]), .A2(mult_12_n70), .ZN(mult_12_ab_6__7_) );
  NOR2_X1 mult_12_U155 ( .A1(b[6]), .A2(mult_12_n85), .ZN(mult_12_ab_7__6_) );
  NOR2_X1 mult_12_U154 ( .A1(mult_12_n69), .A2(mult_12_n85), .ZN(
        mult_12_ab_7__7_) );
  NOR2_X1 mult_12_U153 ( .A1(mult_12_n83), .A2(mult_12_n82), .ZN(
        mult_12_ab_6__0_) );
  NOR2_X1 mult_12_U152 ( .A1(mult_12_n82), .A2(mult_12_n81), .ZN(
        mult_12_ab_6__1_) );
  NOR2_X1 mult_12_U151 ( .A1(mult_12_n82), .A2(mult_12_n80), .ZN(
        mult_12_ab_6__2_) );
  NOR2_X1 mult_12_U150 ( .A1(mult_12_n82), .A2(mult_12_n79), .ZN(
        mult_12_ab_6__3_) );
  NOR2_X1 mult_12_U149 ( .A1(mult_12_n82), .A2(mult_12_n22), .ZN(
        mult_12_ab_6__4_) );
  NOR2_X1 mult_12_U148 ( .A1(mult_12_n82), .A2(mult_12_n77), .ZN(
        mult_12_ab_6__5_) );
  NOR2_X1 mult_12_U147 ( .A1(a[5]), .A2(mult_12_n69), .ZN(mult_12_ab_5__7_) );
  NOR2_X1 mult_12_U146 ( .A1(mult_12_n82), .A2(mult_12_n76), .ZN(
        mult_12_ab_6__6_) );
  INV_X1 mult_12_U145 ( .A(a[6]), .ZN(mult_12_n82) );
  NOR2_X1 mult_12_U144 ( .A1(mult_12_n83), .A2(mult_12_n75), .ZN(
        mult_12_ab_5__0_) );
  NOR2_X1 mult_12_U143 ( .A1(mult_12_n81), .A2(mult_12_n75), .ZN(
        mult_12_ab_5__1_) );
  NOR2_X1 mult_12_U142 ( .A1(mult_12_n80), .A2(mult_12_n75), .ZN(
        mult_12_ab_5__2_) );
  NOR2_X1 mult_12_U141 ( .A1(mult_12_n79), .A2(mult_12_n75), .ZN(
        mult_12_ab_5__3_) );
  NOR2_X1 mult_12_U140 ( .A1(mult_12_n22), .A2(mult_12_n75), .ZN(
        mult_12_ab_5__4_) );
  NOR2_X1 mult_12_U139 ( .A1(mult_12_n77), .A2(mult_12_n75), .ZN(
        mult_12_ab_5__5_) );
  NOR2_X1 mult_12_U138 ( .A1(a[4]), .A2(mult_12_n70), .ZN(mult_12_ab_4__7_) );
  NOR2_X1 mult_12_U137 ( .A1(mult_12_n76), .A2(mult_12_n75), .ZN(
        mult_12_ab_5__6_) );
  INV_X1 mult_12_U136 ( .A(a[5]), .ZN(mult_12_n75) );
  NOR2_X1 mult_12_U135 ( .A1(mult_12_n83), .A2(mult_12_n74), .ZN(
        mult_12_ab_4__0_) );
  NOR2_X1 mult_12_U134 ( .A1(mult_12_n81), .A2(mult_12_n74), .ZN(
        mult_12_ab_4__1_) );
  NOR2_X1 mult_12_U133 ( .A1(mult_12_n80), .A2(mult_12_n74), .ZN(
        mult_12_ab_4__2_) );
  NOR2_X1 mult_12_U132 ( .A1(mult_12_n79), .A2(mult_12_n74), .ZN(
        mult_12_ab_4__3_) );
  NOR2_X1 mult_12_U131 ( .A1(mult_12_n22), .A2(mult_12_n74), .ZN(
        mult_12_ab_4__4_) );
  NOR2_X1 mult_12_U130 ( .A1(mult_12_n77), .A2(mult_12_n74), .ZN(
        mult_12_ab_4__5_) );
  NOR2_X1 mult_12_U129 ( .A1(a[3]), .A2(mult_12_n69), .ZN(mult_12_ab_3__7_) );
  NOR2_X1 mult_12_U128 ( .A1(mult_12_n76), .A2(mult_12_n74), .ZN(
        mult_12_ab_4__6_) );
  INV_X1 mult_12_U127 ( .A(a[4]), .ZN(mult_12_n74) );
  NOR2_X1 mult_12_U126 ( .A1(mult_12_n83), .A2(mult_12_n73), .ZN(
        mult_12_ab_3__0_) );
  NOR2_X1 mult_12_U125 ( .A1(mult_12_n81), .A2(mult_12_n73), .ZN(
        mult_12_ab_3__1_) );
  NOR2_X1 mult_12_U124 ( .A1(mult_12_n80), .A2(mult_12_n73), .ZN(
        mult_12_ab_3__2_) );
  NOR2_X1 mult_12_U123 ( .A1(mult_12_n79), .A2(mult_12_n73), .ZN(
        mult_12_ab_3__3_) );
  NOR2_X1 mult_12_U122 ( .A1(mult_12_n22), .A2(mult_12_n73), .ZN(
        mult_12_ab_3__4_) );
  NOR2_X1 mult_12_U121 ( .A1(mult_12_n77), .A2(mult_12_n73), .ZN(
        mult_12_ab_3__5_) );
  NOR2_X1 mult_12_U120 ( .A1(a[2]), .A2(mult_12_n70), .ZN(mult_12_ab_2__7_) );
  NOR2_X1 mult_12_U119 ( .A1(mult_12_n76), .A2(mult_12_n73), .ZN(
        mult_12_ab_3__6_) );
  INV_X1 mult_12_U118 ( .A(a[3]), .ZN(mult_12_n73) );
  NOR2_X1 mult_12_U117 ( .A1(mult_12_n83), .A2(mult_12_n28), .ZN(
        mult_12_ab_2__0_) );
  NOR2_X1 mult_12_U116 ( .A1(mult_12_n81), .A2(mult_12_n42), .ZN(
        mult_12_ab_2__1_) );
  NOR2_X1 mult_12_U115 ( .A1(mult_12_n80), .A2(mult_12_n29), .ZN(
        mult_12_ab_2__2_) );
  NOR2_X1 mult_12_U114 ( .A1(mult_12_n79), .A2(mult_12_n29), .ZN(
        mult_12_ab_2__3_) );
  NOR2_X1 mult_12_U113 ( .A1(mult_12_n78), .A2(mult_12_n28), .ZN(
        mult_12_ab_2__4_) );
  NOR2_X1 mult_12_U112 ( .A1(mult_12_n77), .A2(mult_12_n42), .ZN(
        mult_12_ab_2__5_) );
  NOR2_X1 mult_12_U111 ( .A1(mult_12_n69), .A2(mult_12_n8), .ZN(
        mult_12_ab_1__7_) );
  NOR2_X1 mult_12_U110 ( .A1(mult_12_n83), .A2(mult_12_n72), .ZN(
        mult_12_ab_1__0_) );
  INV_X1 mult_12_U109 ( .A(b[0]), .ZN(mult_12_n83) );
  NOR2_X1 mult_12_U108 ( .A1(mult_12_n84), .A2(mult_12_n81), .ZN(
        mult_12_ab_0__1_) );
  NOR2_X1 mult_12_U107 ( .A1(mult_12_n81), .A2(mult_12_n72), .ZN(
        mult_12_ab_1__1_) );
  INV_X1 mult_12_U106 ( .A(b[1]), .ZN(mult_12_n81) );
  NOR2_X1 mult_12_U105 ( .A1(mult_12_n84), .A2(mult_12_n80), .ZN(
        mult_12_ab_0__2_) );
  NOR2_X1 mult_12_U104 ( .A1(mult_12_n80), .A2(mult_12_n72), .ZN(
        mult_12_ab_1__2_) );
  INV_X1 mult_12_U103 ( .A(b[2]), .ZN(mult_12_n80) );
  NOR2_X1 mult_12_U102 ( .A1(mult_12_n84), .A2(mult_12_n79), .ZN(
        mult_12_ab_0__3_) );
  NOR2_X1 mult_12_U101 ( .A1(mult_12_n79), .A2(mult_12_n72), .ZN(
        mult_12_ab_1__3_) );
  INV_X1 mult_12_U100 ( .A(a[0]), .ZN(mult_12_n84) );
  NOR2_X1 mult_12_U99 ( .A1(mult_12_n86), .A2(a[0]), .ZN(mult_12_ab_0__7_) );
  INV_X2 mult_12_U98 ( .A(a[7]), .ZN(mult_12_n85) );
  INV_X1 mult_12_U97 ( .A(mult_12_n69), .ZN(mult_12_n71) );
  INV_X1 mult_12_U96 ( .A(b[7]), .ZN(mult_12_n86) );
  INV_X1 mult_12_U95 ( .A(mult_12_n71), .ZN(mult_12_n70) );
  INV_X1 mult_12_U94 ( .A(b[7]), .ZN(mult_12_n69) );
  INV_X1 mult_12_U93 ( .A(b[5]), .ZN(mult_12_n77) );
  AND2_X1 mult_12_U92 ( .A1(mult_12_CARRYB_7__6_), .A2(mult_12_SUMB_7__7_), 
        .ZN(mult_12_n68) );
  XOR2_X1 mult_12_U91 ( .A(mult_12_CARRYB_7__6_), .B(mult_12_SUMB_7__7_), .Z(
        mult_12_n67) );
  AND2_X1 mult_12_U90 ( .A1(mult_12_CARRYB_7__5_), .A2(mult_12_SUMB_7__6_), 
        .ZN(mult_12_n66) );
  AND2_X1 mult_12_U89 ( .A1(mult_12_CARRYB_7__4_), .A2(mult_12_SUMB_7__5_), 
        .ZN(mult_12_n65) );
  XOR2_X1 mult_12_U88 ( .A(mult_12_CARRYB_7__5_), .B(mult_12_SUMB_7__6_), .Z(
        mult_12_n64) );
  AND2_X1 mult_12_U87 ( .A1(mult_12_CARRYB_7__3_), .A2(mult_12_SUMB_7__4_), 
        .ZN(mult_12_n63) );
  XOR2_X1 mult_12_U86 ( .A(mult_12_CARRYB_7__4_), .B(mult_12_SUMB_7__5_), .Z(
        mult_12_n62) );
  XOR2_X1 mult_12_U85 ( .A(mult_12_SUMB_7__3_), .B(mult_12_CARRYB_7__2_), .Z(
        mult_12_n61) );
  XOR2_X1 mult_12_U84 ( .A(mult_12_CARRYB_7__3_), .B(mult_12_SUMB_7__4_), .Z(
        mult_12_n59) );
  AND2_X1 mult_12_U83 ( .A1(mult_12_SUMB_7__2_), .A2(mult_12_CARRYB_7__1_), 
        .ZN(mult_12_n57) );
  AND2_X1 mult_12_U82 ( .A1(mult_12_ab_0__6_), .A2(mult_12_ab_1__5_), .ZN(
        mult_12_n55) );
  XOR2_X1 mult_12_U81 ( .A(mult_12_SUMB_7__2_), .B(mult_12_CARRYB_7__1_), .Z(
        mult_12_n54) );
  XOR2_X1 mult_12_U80 ( .A(mult_12_ab_1__0_), .B(mult_12_ab_0__1_), .Z(N3) );
  INV_X1 mult_12_U79 ( .A(a[1]), .ZN(mult_12_n72) );
  INV_X1 mult_12_U78 ( .A(b[6]), .ZN(mult_12_n76) );
  AND2_X1 mult_12_U77 ( .A1(b[6]), .A2(a[1]), .ZN(mult_12_ab_1__6_) );
  AND2_X1 mult_12_U76 ( .A1(mult_12_CARRYB_7__2_), .A2(mult_12_SUMB_7__3_), 
        .ZN(mult_12_n58) );
  AND2_X1 mult_12_U75 ( .A1(mult_12_SUMB_7__1_), .A2(mult_12_CARRYB_7__0_), 
        .ZN(mult_12_n56) );
  NAND3_X1 mult_12_U74 ( .A1(mult_12_n50), .A2(mult_12_n51), .A3(mult_12_n52), 
        .ZN(mult_12_CARRYB_2__6_) );
  NAND2_X1 mult_12_U73 ( .A1(mult_12_ab_2__6_), .A2(mult_12_ab_1__7_), .ZN(
        mult_12_n52) );
  NAND2_X1 mult_12_U72 ( .A1(mult_12_CARRYB_1__6_), .A2(mult_12_n41), .ZN(
        mult_12_n51) );
  NAND2_X1 mult_12_U71 ( .A1(mult_12_CARRYB_1__6_), .A2(mult_12_ab_2__6_), 
        .ZN(mult_12_n50) );
  NAND3_X1 mult_12_U70 ( .A1(mult_12_n47), .A2(mult_12_n48), .A3(mult_12_n49), 
        .ZN(mult_12_A2_6_) );
  NAND2_X1 mult_12_U69 ( .A1(mult_12_n71), .A2(a[7]), .ZN(mult_12_n49) );
  NAND2_X1 mult_12_U68 ( .A1(mult_12_SUMB_7__0_), .A2(a[7]), .ZN(mult_12_n48)
         );
  NAND2_X1 mult_12_U67 ( .A1(mult_12_SUMB_7__0_), .A2(mult_12_n71), .ZN(
        mult_12_n47) );
  NAND3_X1 mult_12_U66 ( .A1(mult_12_n44), .A2(mult_12_n45), .A3(mult_12_n46), 
        .ZN(mult_12_CARRYB_2__5_) );
  NAND2_X1 mult_12_U65 ( .A1(mult_12_n55), .A2(mult_12_ab_2__5_), .ZN(
        mult_12_n46) );
  NAND2_X1 mult_12_U64 ( .A1(mult_12_SUMB_1__6_), .A2(mult_12_ab_2__5_), .ZN(
        mult_12_n45) );
  NAND2_X1 mult_12_U63 ( .A1(mult_12_SUMB_1__6_), .A2(mult_12_n55), .ZN(
        mult_12_n44) );
  XNOR2_X1 mult_12_U62 ( .A(mult_12_n55), .B(mult_12_ab_2__5_), .ZN(
        mult_12_n43) );
  XNOR2_X1 mult_12_U61 ( .A(mult_12_SUMB_1__6_), .B(mult_12_n43), .ZN(
        mult_12_SUMB_2__5_) );
  INV_X1 mult_12_U60 ( .A(a[2]), .ZN(mult_12_n42) );
  CLKBUF_X1 mult_12_U59 ( .A(mult_12_ab_1__7_), .Z(mult_12_n41) );
  NAND3_X1 mult_12_U58 ( .A1(mult_12_n38), .A2(mult_12_n39), .A3(mult_12_n40), 
        .ZN(mult_12_CARRYB_7__3_) );
  NAND2_X1 mult_12_U57 ( .A1(mult_12_ab_7__3_), .A2(mult_12_SUMB_6__4_), .ZN(
        mult_12_n40) );
  NAND2_X1 mult_12_U56 ( .A1(mult_12_n7), .A2(mult_12_SUMB_6__4_), .ZN(
        mult_12_n39) );
  NAND2_X1 mult_12_U55 ( .A1(mult_12_n7), .A2(mult_12_ab_7__3_), .ZN(
        mult_12_n38) );
  NAND3_X1 mult_12_U54 ( .A1(mult_12_n35), .A2(mult_12_n36), .A3(mult_12_n37), 
        .ZN(mult_12_CARRYB_6__4_) );
  NAND2_X1 mult_12_U53 ( .A1(mult_12_CARRYB_5__4_), .A2(mult_12_SUMB_5__5_), 
        .ZN(mult_12_n37) );
  NAND2_X1 mult_12_U52 ( .A1(mult_12_ab_6__4_), .A2(mult_12_SUMB_5__5_), .ZN(
        mult_12_n36) );
  NAND2_X1 mult_12_U51 ( .A1(mult_12_ab_6__4_), .A2(mult_12_CARRYB_5__4_), 
        .ZN(mult_12_n35) );
  AND2_X1 mult_12_U50 ( .A1(b[5]), .A2(a[1]), .ZN(mult_12_ab_1__5_) );
  NAND3_X1 mult_12_U49 ( .A1(mult_12_n32), .A2(mult_12_n33), .A3(mult_12_n34), 
        .ZN(mult_12_CARRYB_5__6_) );
  NAND2_X1 mult_12_U48 ( .A1(mult_12_ab_5__6_), .A2(mult_12_ab_4__7_), .ZN(
        mult_12_n34) );
  NAND2_X1 mult_12_U47 ( .A1(mult_12_CARRYB_4__6_), .A2(mult_12_ab_4__7_), 
        .ZN(mult_12_n33) );
  NAND2_X1 mult_12_U46 ( .A1(mult_12_CARRYB_4__6_), .A2(mult_12_ab_5__6_), 
        .ZN(mult_12_n32) );
  XOR2_X1 mult_12_U45 ( .A(mult_12_CARRYB_4__6_), .B(mult_12_n31), .Z(
        mult_12_SUMB_5__6_) );
  XOR2_X1 mult_12_U44 ( .A(mult_12_ab_5__6_), .B(mult_12_ab_4__7_), .Z(
        mult_12_n31) );
  XNOR2_X1 mult_12_U43 ( .A(mult_12_CARRYB_6__3_), .B(mult_12_ab_7__3_), .ZN(
        mult_12_n30) );
  XNOR2_X1 mult_12_U42 ( .A(mult_12_n30), .B(mult_12_SUMB_6__4_), .ZN(
        mult_12_SUMB_7__3_) );
  INV_X1 mult_12_U41 ( .A(a[2]), .ZN(mult_12_n29) );
  INV_X1 mult_12_U40 ( .A(a[2]), .ZN(mult_12_n28) );
  XOR2_X1 mult_12_U39 ( .A(mult_12_CARRYB_7__0_), .B(mult_12_SUMB_7__1_), .Z(
        mult_12_n60) );
  AND2_X1 mult_12_U38 ( .A1(b[6]), .A2(a[2]), .ZN(mult_12_ab_2__6_) );
  NAND3_X1 mult_12_U37 ( .A1(mult_12_n25), .A2(mult_12_n26), .A3(mult_12_n27), 
        .ZN(mult_12_CARRYB_3__6_) );
  NAND2_X1 mult_12_U36 ( .A1(mult_12_ab_2__7_), .A2(mult_12_ab_3__6_), .ZN(
        mult_12_n27) );
  NAND2_X1 mult_12_U35 ( .A1(mult_12_CARRYB_2__6_), .A2(mult_12_ab_3__6_), 
        .ZN(mult_12_n26) );
  NAND2_X1 mult_12_U34 ( .A1(mult_12_n2), .A2(mult_12_n5), .ZN(mult_12_n25) );
  XOR2_X1 mult_12_U33 ( .A(mult_12_CARRYB_2__6_), .B(mult_12_n24), .Z(
        mult_12_SUMB_3__6_) );
  XOR2_X1 mult_12_U32 ( .A(mult_12_ab_2__7_), .B(mult_12_ab_3__6_), .Z(
        mult_12_n24) );
  INV_X1 mult_12_U31 ( .A(b[4]), .ZN(mult_12_n78) );
  NOR2_X1 mult_12_U30 ( .A1(mult_12_n84), .A2(mult_12_n78), .ZN(mult_12_n23)
         );
  INV_X1 mult_12_U29 ( .A(b[4]), .ZN(mult_12_n22) );
  INV_X2 mult_12_U28 ( .A(b[3]), .ZN(mult_12_n79) );
  XNOR2_X1 mult_12_U27 ( .A(mult_12_n71), .B(a[7]), .ZN(mult_12_n21) );
  XNOR2_X1 mult_12_U26 ( .A(mult_12_SUMB_7__0_), .B(mult_12_n21), .ZN(
        mult_12_A1_5_) );
  OR2_X1 mult_12_U25 ( .A1(mult_12_n84), .A2(mult_12_n78), .ZN(mult_12_n20) );
  XNOR2_X1 mult_12_U24 ( .A(mult_12_ab_1__3_), .B(mult_12_n20), .ZN(
        mult_12_n19) );
  AND2_X1 mult_12_U23 ( .A1(b[4]), .A2(mult_12_n8), .ZN(mult_12_ab_1__4_) );
  AND2_X1 mult_12_U22 ( .A1(mult_12_ab_0__1_), .A2(mult_12_ab_1__0_), .ZN(
        mult_12_n18) );
  XOR2_X1 mult_12_U21 ( .A(mult_12_ab_1__4_), .B(mult_12_ab_0__5_), .Z(
        mult_12_n17) );
  AND2_X1 mult_12_U20 ( .A1(mult_12_ab_0__2_), .A2(mult_12_ab_1__1_), .ZN(
        mult_12_n16) );
  AND2_X1 mult_12_U19 ( .A1(mult_12_ab_0__5_), .A2(mult_12_ab_1__4_), .ZN(
        mult_12_n15) );
  AND2_X1 mult_12_U18 ( .A1(mult_12_ab_0__3_), .A2(mult_12_ab_1__2_), .ZN(
        mult_12_n14) );
  XOR2_X1 mult_12_U17 ( .A(mult_12_ab_1__1_), .B(mult_12_ab_0__2_), .Z(
        mult_12_n13) );
  XOR2_X1 mult_12_U16 ( .A(mult_12_ab_1__2_), .B(mult_12_ab_0__3_), .Z(
        mult_12_n12) );
  XOR2_X1 mult_12_U15 ( .A(mult_12_ab_1__5_), .B(mult_12_ab_0__6_), .Z(
        mult_12_n11) );
  AND2_X1 mult_12_U14 ( .A1(mult_12_ab_1__3_), .A2(mult_12_n23), .ZN(
        mult_12_n10) );
  AND2_X1 mult_12_U13 ( .A1(a[0]), .A2(b[5]), .ZN(mult_12_ab_0__5_) );
  AND2_X1 mult_12_U12 ( .A1(a[0]), .A2(b[6]), .ZN(mult_12_ab_0__6_) );
  XNOR2_X1 mult_12_U11 ( .A(mult_12_ab_2__6_), .B(mult_12_ab_1__7_), .ZN(
        mult_12_n9) );
  XNOR2_X1 mult_12_U10 ( .A(mult_12_CARRYB_1__6_), .B(mult_12_n9), .ZN(
        mult_12_SUMB_2__6_) );
  BUF_X1 mult_12_U9 ( .A(a[1]), .Z(mult_12_n8) );
  CLKBUF_X1 mult_12_U8 ( .A(mult_12_CARRYB_6__3_), .Z(mult_12_n7) );
  XNOR2_X1 mult_12_U7 ( .A(mult_12_ab_6__4_), .B(mult_12_CARRYB_5__4_), .ZN(
        mult_12_n6) );
  XNOR2_X1 mult_12_U6 ( .A(mult_12_n6), .B(mult_12_n4), .ZN(mult_12_SUMB_6__4_) );
  BUF_X1 mult_12_U5 ( .A(mult_12_ab_2__7_), .Z(mult_12_n5) );
  INV_X1 mult_12_U4 ( .A(mult_12_n3), .ZN(mult_12_n4) );
  INV_X1 mult_12_U3 ( .A(mult_12_SUMB_5__5_), .ZN(mult_12_n3) );
  NAND3_X1 mult_12_U2 ( .A1(mult_12_n50), .A2(mult_12_n51), .A3(mult_12_n52), 
        .ZN(mult_12_n2) );
  FA_X1 mult_12_S0_6 ( .A(mult_12_ab_1__6_), .B(1'b0), .CI(mult_12_ab_0__7_), 
        .CO(mult_12_CARRYB_1__6_), .S(mult_12_SUMB_1__6_) );
  FA_X1 mult_12_S2_2_4 ( .A(mult_12_ab_2__4_), .B(mult_12_n15), .CI(
        mult_12_n11), .CO(mult_12_CARRYB_2__4_), .S(mult_12_SUMB_2__4_) );
  FA_X1 mult_12_S2_2_3 ( .A(mult_12_ab_2__3_), .B(mult_12_n10), .CI(
        mult_12_n17), .CO(mult_12_CARRYB_2__3_), .S(mult_12_SUMB_2__3_) );
  FA_X1 mult_12_S2_2_2 ( .A(mult_12_ab_2__2_), .B(mult_12_n14), .CI(
        mult_12_n19), .CO(mult_12_CARRYB_2__2_), .S(mult_12_SUMB_2__2_) );
  FA_X1 mult_12_S2_2_1 ( .A(mult_12_ab_2__1_), .B(mult_12_n16), .CI(
        mult_12_n12), .CO(mult_12_CARRYB_2__1_), .S(mult_12_SUMB_2__1_) );
  FA_X1 mult_12_S1_2_0 ( .A(mult_12_ab_2__0_), .B(mult_12_n18), .CI(
        mult_12_n13), .CO(mult_12_CARRYB_2__0_), .S(mult_12_A1_0_) );
  FA_X1 mult_12_S2_3_5 ( .A(mult_12_ab_3__5_), .B(mult_12_SUMB_2__6_), .CI(
        mult_12_CARRYB_2__5_), .CO(mult_12_CARRYB_3__5_), .S(
        mult_12_SUMB_3__5_) );
  FA_X1 mult_12_S2_3_4 ( .A(mult_12_ab_3__4_), .B(mult_12_CARRYB_2__4_), .CI(
        mult_12_SUMB_2__5_), .CO(mult_12_CARRYB_3__4_), .S(mult_12_SUMB_3__4_)
         );
  FA_X1 mult_12_S2_3_3 ( .A(mult_12_ab_3__3_), .B(mult_12_CARRYB_2__3_), .CI(
        mult_12_SUMB_2__4_), .CO(mult_12_CARRYB_3__3_), .S(mult_12_SUMB_3__3_)
         );
  FA_X1 mult_12_S2_3_2 ( .A(mult_12_ab_3__2_), .B(mult_12_CARRYB_2__2_), .CI(
        mult_12_SUMB_2__3_), .CO(mult_12_CARRYB_3__2_), .S(mult_12_SUMB_3__2_)
         );
  FA_X1 mult_12_S2_3_1 ( .A(mult_12_ab_3__1_), .B(mult_12_CARRYB_2__1_), .CI(
        mult_12_SUMB_2__2_), .CO(mult_12_CARRYB_3__1_), .S(mult_12_SUMB_3__1_)
         );
  FA_X1 mult_12_S1_3_0 ( .A(mult_12_ab_3__0_), .B(mult_12_CARRYB_2__0_), .CI(
        mult_12_SUMB_2__1_), .CO(mult_12_CARRYB_3__0_), .S(mult_12_A1_1_) );
  FA_X1 mult_12_S3_4_6 ( .A(mult_12_ab_4__6_), .B(mult_12_CARRYB_3__6_), .CI(
        mult_12_ab_3__7_), .CO(mult_12_CARRYB_4__6_), .S(mult_12_SUMB_4__6_)
         );
  FA_X1 mult_12_S2_4_5 ( .A(mult_12_ab_4__5_), .B(mult_12_SUMB_3__6_), .CI(
        mult_12_CARRYB_3__5_), .CO(mult_12_CARRYB_4__5_), .S(
        mult_12_SUMB_4__5_) );
  FA_X1 mult_12_S2_4_4 ( .A(mult_12_ab_4__4_), .B(mult_12_CARRYB_3__4_), .CI(
        mult_12_SUMB_3__5_), .CO(mult_12_CARRYB_4__4_), .S(mult_12_SUMB_4__4_)
         );
  FA_X1 mult_12_S2_4_3 ( .A(mult_12_ab_4__3_), .B(mult_12_CARRYB_3__3_), .CI(
        mult_12_SUMB_3__4_), .CO(mult_12_CARRYB_4__3_), .S(mult_12_SUMB_4__3_)
         );
  FA_X1 mult_12_S2_4_2 ( .A(mult_12_ab_4__2_), .B(mult_12_CARRYB_3__2_), .CI(
        mult_12_SUMB_3__3_), .CO(mult_12_CARRYB_4__2_), .S(mult_12_SUMB_4__2_)
         );
  FA_X1 mult_12_S2_4_1 ( .A(mult_12_ab_4__1_), .B(mult_12_CARRYB_3__1_), .CI(
        mult_12_SUMB_3__2_), .CO(mult_12_CARRYB_4__1_), .S(mult_12_SUMB_4__1_)
         );
  FA_X1 mult_12_S1_4_0 ( .A(mult_12_ab_4__0_), .B(mult_12_CARRYB_3__0_), .CI(
        mult_12_SUMB_3__1_), .CO(mult_12_CARRYB_4__0_), .S(mult_12_A1_2_) );
  FA_X1 mult_12_S2_5_5 ( .A(mult_12_ab_5__5_), .B(mult_12_CARRYB_4__5_), .CI(
        mult_12_SUMB_4__6_), .CO(mult_12_CARRYB_5__5_), .S(mult_12_SUMB_5__5_)
         );
  FA_X1 mult_12_S2_5_4 ( .A(mult_12_CARRYB_4__4_), .B(mult_12_ab_5__4_), .CI(
        mult_12_SUMB_4__5_), .CO(mult_12_CARRYB_5__4_), .S(mult_12_SUMB_5__4_)
         );
  FA_X1 mult_12_S2_5_3 ( .A(mult_12_ab_5__3_), .B(mult_12_CARRYB_4__3_), .CI(
        mult_12_SUMB_4__4_), .CO(mult_12_CARRYB_5__3_), .S(mult_12_SUMB_5__3_)
         );
  FA_X1 mult_12_S2_5_2 ( .A(mult_12_ab_5__2_), .B(mult_12_CARRYB_4__2_), .CI(
        mult_12_SUMB_4__3_), .CO(mult_12_CARRYB_5__2_), .S(mult_12_SUMB_5__2_)
         );
  FA_X1 mult_12_S2_5_1 ( .A(mult_12_ab_5__1_), .B(mult_12_CARRYB_4__1_), .CI(
        mult_12_SUMB_4__2_), .CO(mult_12_CARRYB_5__1_), .S(mult_12_SUMB_5__1_)
         );
  FA_X1 mult_12_S1_5_0 ( .A(mult_12_ab_5__0_), .B(mult_12_CARRYB_4__0_), .CI(
        mult_12_SUMB_4__1_), .CO(mult_12_CARRYB_5__0_), .S(mult_12_A1_3_) );
  FA_X1 mult_12_S3_6_6 ( .A(mult_12_ab_6__6_), .B(mult_12_CARRYB_5__6_), .CI(
        mult_12_ab_5__7_), .CO(mult_12_CARRYB_6__6_), .S(mult_12_SUMB_6__6_)
         );
  FA_X1 mult_12_S2_6_5 ( .A(mult_12_ab_6__5_), .B(mult_12_CARRYB_5__5_), .CI(
        mult_12_SUMB_5__6_), .CO(mult_12_CARRYB_6__5_), .S(mult_12_SUMB_6__5_)
         );
  FA_X1 mult_12_S2_6_3 ( .A(mult_12_CARRYB_5__3_), .B(mult_12_ab_6__3_), .CI(
        mult_12_SUMB_5__4_), .CO(mult_12_CARRYB_6__3_), .S(mult_12_SUMB_6__3_)
         );
  FA_X1 mult_12_S2_6_2 ( .A(mult_12_ab_6__2_), .B(mult_12_CARRYB_5__2_), .CI(
        mult_12_SUMB_5__3_), .CO(mult_12_CARRYB_6__2_), .S(mult_12_SUMB_6__2_)
         );
  FA_X1 mult_12_S2_6_1 ( .A(mult_12_ab_6__1_), .B(mult_12_CARRYB_5__1_), .CI(
        mult_12_SUMB_5__2_), .CO(mult_12_CARRYB_6__1_), .S(mult_12_SUMB_6__1_)
         );
  FA_X1 mult_12_S1_6_0 ( .A(mult_12_ab_6__0_), .B(mult_12_CARRYB_5__0_), .CI(
        mult_12_SUMB_5__1_), .CO(mult_12_CARRYB_6__0_), .S(mult_12_A1_4_) );
  FA_X1 mult_12_S14_7 ( .A(mult_12_n85), .B(mult_12_n70), .CI(mult_12_ab_7__7_), .CO(mult_12_CARRYB_7__7_), .S(mult_12_SUMB_7__7_) );
  FA_X1 mult_12_S5_6 ( .A(mult_12_ab_7__6_), .B(mult_12_CARRYB_6__6_), .CI(
        mult_12_ab_6__7_), .CO(mult_12_CARRYB_7__6_), .S(mult_12_SUMB_7__6_)
         );
  FA_X1 mult_12_S4_5 ( .A(mult_12_ab_7__5_), .B(mult_12_CARRYB_6__5_), .CI(
        mult_12_SUMB_6__6_), .CO(mult_12_CARRYB_7__5_), .S(mult_12_SUMB_7__5_)
         );
  FA_X1 mult_12_S4_4 ( .A(mult_12_ab_7__4_), .B(mult_12_CARRYB_6__4_), .CI(
        mult_12_SUMB_6__5_), .CO(mult_12_CARRYB_7__4_), .S(mult_12_SUMB_7__4_)
         );
  FA_X1 mult_12_S4_2 ( .A(mult_12_CARRYB_6__2_), .B(mult_12_ab_7__2_), .CI(
        mult_12_SUMB_6__3_), .CO(mult_12_CARRYB_7__2_), .S(mult_12_SUMB_7__2_)
         );
  FA_X1 mult_12_S4_1 ( .A(mult_12_ab_7__1_), .B(mult_12_CARRYB_6__1_), .CI(
        mult_12_SUMB_6__2_), .CO(mult_12_CARRYB_7__1_), .S(mult_12_SUMB_7__1_)
         );
  FA_X1 mult_12_S4_0 ( .A(mult_12_ab_7__0_), .B(mult_12_CARRYB_6__0_), .CI(
        mult_12_SUMB_6__1_), .CO(mult_12_CARRYB_7__0_), .S(mult_12_SUMB_7__0_)
         );
  INV_X1 mult_12_FS_1_U83 ( .A(mult_12_FS_1_n30), .ZN(mult_12_FS_1_n75) );
  NAND3_X1 mult_12_FS_1_U82 ( .A1(mult_12_FS_1_n33), .A2(mult_12_A2_6_), .A3(
        mult_12_n60), .ZN(mult_12_FS_1_n74) );
  NAND3_X1 mult_12_FS_1_U81 ( .A1(mult_12_FS_1_n32), .A2(mult_12_FS_1_n12), 
        .A3(mult_12_FS_1_n31), .ZN(mult_12_FS_1_n73) );
  NAND3_X1 mult_12_FS_1_U80 ( .A1(mult_12_FS_1_n57), .A2(mult_12_FS_1_n12), 
        .A3(mult_12_FS_1_n31), .ZN(mult_12_FS_1_n64) );
  INV_X1 mult_12_FS_1_U79 ( .A(mult_12_FS_1_n57), .ZN(mult_12_FS_1_n68) );
  XNOR2_X1 mult_12_FS_1_U78 ( .A(mult_12_FS_1_n62), .B(mult_12_FS_1_n63), .ZN(
        N15) );
  INV_X1 mult_12_FS_1_U77 ( .A(mult_12_FS_1_n15), .ZN(mult_12_FS_1_n55) );
  INV_X1 mult_12_FS_1_U76 ( .A(mult_12_FS_1_n47), .ZN(mult_12_FS_1_n56) );
  OAI221_X1 mult_12_FS_1_U75 ( .B1(mult_12_FS_1_n55), .B2(mult_12_FS_1_n56), 
        .C1(mult_12_FS_1_n8), .C2(mult_12_FS_1_n7), .A(mult_12_FS_1_n52), .ZN(
        mult_12_FS_1_n53) );
  XNOR2_X1 mult_12_FS_1_U74 ( .A(mult_12_FS_1_n53), .B(mult_12_FS_1_n54), .ZN(
        N16) );
  NAND3_X1 mult_12_FS_1_U73 ( .A1(mult_12_FS_1_n15), .A2(mult_12_FS_1_n47), 
        .A3(mult_12_FS_1_n44), .ZN(mult_12_FS_1_n42) );
  NAND3_X1 mult_12_FS_1_U72 ( .A1(mult_12_FS_1_n23), .A2(mult_12_FS_1_n45), 
        .A3(mult_12_FS_1_n44), .ZN(mult_12_FS_1_n43) );
  NAND3_X1 mult_12_FS_1_U71 ( .A1(mult_12_FS_1_n43), .A2(mult_12_FS_1_n42), 
        .A3(mult_12_FS_1_n41), .ZN(mult_12_FS_1_n39) );
  INV_X1 mult_12_FS_1_U70 ( .A(mult_12_FS_1_n31), .ZN(mult_12_FS_1_n29) );
  XNOR2_X1 mult_12_FS_1_U69 ( .A(mult_12_FS_1_n25), .B(mult_12_FS_1_n26), .ZN(
        N13) );
  OAI21_X1 mult_12_FS_1_U68 ( .B1(mult_12_FS_1_n3), .B2(mult_12_FS_1_n64), .A(
        mult_12_FS_1_n65), .ZN(mult_12_FS_1_n62) );
  OAI21_X1 mult_12_FS_1_U67 ( .B1(mult_12_FS_1_n3), .B2(mult_12_FS_1_n29), .A(
        mult_12_FS_1_n30), .ZN(mult_12_FS_1_n25) );
  NAND4_X1 mult_12_FS_1_U66 ( .A1(mult_12_FS_1_n31), .A2(mult_12_FS_1_n47), 
        .A3(mult_12_FS_1_n12), .A4(mult_12_FS_1_n57), .ZN(mult_12_FS_1_n46) );
  NAND2_X1 mult_12_FS_1_U65 ( .A1(mult_12_FS_1_n14), .A2(mult_12_n56), .ZN(
        mult_12_FS_1_n34) );
  INV_X1 mult_12_FS_1_U64 ( .A(mult_12_FS_1_n46), .ZN(mult_12_FS_1_n45) );
  NAND2_X1 mult_12_FS_1_U63 ( .A1(mult_12_FS_1_n12), .A2(mult_12_FS_1_n28), 
        .ZN(mult_12_FS_1_n26) );
  NAND2_X1 mult_12_FS_1_U62 ( .A1(mult_12_FS_1_n57), .A2(mult_12_FS_1_n27), 
        .ZN(mult_12_FS_1_n58) );
  NAND2_X1 mult_12_FS_1_U61 ( .A1(mult_12_FS_1_n75), .A2(mult_12_FS_1_n12), 
        .ZN(mult_12_FS_1_n69) );
  CLKBUF_X1 mult_12_FS_1_U60 ( .A(mult_12_FS_1_n10), .Z(mult_12_FS_1_n24) );
  XNOR2_X1 mult_12_FS_1_U59 ( .A(mult_12_FS_1_n39), .B(mult_12_FS_1_n40), .ZN(
        N17) );
  NAND2_X1 mult_12_FS_1_U58 ( .A1(mult_12_FS_1_n61), .A2(mult_12_FS_1_n57), 
        .ZN(mult_12_FS_1_n59) );
  AND2_X1 mult_12_FS_1_U57 ( .A1(mult_12_n59), .A2(mult_12_n58), .ZN(
        mult_12_FS_1_n61) );
  NAND2_X1 mult_12_FS_1_U56 ( .A1(mult_12_n59), .A2(mult_12_n58), .ZN(
        mult_12_FS_1_n28) );
  NAND2_X1 mult_12_FS_1_U55 ( .A1(mult_12_n57), .A2(mult_12_n61), .ZN(
        mult_12_FS_1_n30) );
  BUF_X1 mult_12_FS_1_U54 ( .A(mult_12_A1_5_), .Z(N9) );
  BUF_X1 mult_12_FS_1_U53 ( .A(mult_12_A1_4_), .Z(N8) );
  BUF_X1 mult_12_FS_1_U52 ( .A(mult_12_A1_3_), .Z(N7) );
  BUF_X1 mult_12_FS_1_U51 ( .A(mult_12_A1_2_), .Z(N6) );
  BUF_X1 mult_12_FS_1_U50 ( .A(mult_12_A1_1_), .Z(N5) );
  BUF_X1 mult_12_FS_1_U49 ( .A(mult_12_A1_0_), .Z(N4) );
  NAND2_X1 mult_12_FS_1_U48 ( .A1(mult_12_FS_1_n9), .A2(mult_12_FS_1_n11), 
        .ZN(mult_12_FS_1_n35) );
  INV_X1 mult_12_FS_1_U47 ( .A(mult_12_A2_6_), .ZN(mult_12_FS_1_n37) );
  NAND2_X1 mult_12_FS_1_U46 ( .A1(mult_12_FS_1_n38), .A2(mult_12_FS_1_n37), 
        .ZN(mult_12_FS_1_n36) );
  NAND2_X1 mult_12_FS_1_U45 ( .A1(mult_12_n66), .A2(mult_12_n67), .ZN(
        mult_12_FS_1_n50) );
  NAND2_X1 mult_12_FS_1_U44 ( .A1(mult_12_n65), .A2(mult_12_n64), .ZN(
        mult_12_FS_1_n52) );
  INV_X1 mult_12_FS_1_U43 ( .A(mult_12_FS_1_n9), .ZN(mult_12_FS_1_n38) );
  NAND2_X1 mult_12_FS_1_U42 ( .A1(mult_12_n63), .A2(mult_12_n62), .ZN(
        mult_12_FS_1_n60) );
  NAND2_X1 mult_12_FS_1_U41 ( .A1(mult_12_FS_1_n13), .A2(mult_12_FS_1_n34), 
        .ZN(mult_12_FS_1_n23) );
  XNOR2_X1 mult_12_FS_1_U40 ( .A(mult_12_n68), .B(mult_12_A1_13_), .ZN(
        mult_12_FS_1_n40) );
  NAND2_X1 mult_12_FS_1_U39 ( .A1(mult_12_FS_1_n34), .A2(mult_12_FS_1_n74), 
        .ZN(mult_12_FS_1_n32) );
  INV_X1 mult_12_FS_1_U38 ( .A(mult_12_FS_1_n44), .ZN(mult_12_FS_1_n51) );
  NOR2_X1 mult_12_FS_1_U37 ( .A1(mult_12_FS_1_n51), .A2(mult_12_FS_1_n52), 
        .ZN(mult_12_FS_1_n48) );
  INV_X1 mult_12_FS_1_U36 ( .A(mult_12_FS_1_n50), .ZN(mult_12_FS_1_n49) );
  NOR2_X1 mult_12_FS_1_U35 ( .A1(mult_12_FS_1_n48), .A2(mult_12_FS_1_n49), 
        .ZN(mult_12_FS_1_n41) );
  NOR2_X1 mult_12_FS_1_U34 ( .A1(mult_12_FS_1_n68), .A2(mult_12_FS_1_n69), 
        .ZN(mult_12_FS_1_n66) );
  OAI21_X1 mult_12_FS_1_U33 ( .B1(mult_12_FS_1_n68), .B2(mult_12_FS_1_n28), 
        .A(mult_12_FS_1_n60), .ZN(mult_12_FS_1_n67) );
  NOR2_X1 mult_12_FS_1_U32 ( .A1(mult_12_FS_1_n66), .A2(mult_12_FS_1_n67), 
        .ZN(mult_12_FS_1_n65) );
  NAND2_X1 mult_12_FS_1_U31 ( .A1(mult_12_FS_1_n52), .A2(mult_12_FS_1_n47), 
        .ZN(mult_12_FS_1_n63) );
  AND2_X1 mult_12_FS_1_U30 ( .A1(mult_12_FS_1_n28), .A2(mult_12_FS_1_n69), 
        .ZN(mult_12_FS_1_n72) );
  NAND2_X1 mult_12_FS_1_U29 ( .A1(mult_12_FS_1_n73), .A2(mult_12_FS_1_n72), 
        .ZN(mult_12_FS_1_n70) );
  NAND2_X1 mult_12_FS_1_U28 ( .A1(mult_12_FS_1_n60), .A2(mult_12_FS_1_n57), 
        .ZN(mult_12_FS_1_n71) );
  XNOR2_X1 mult_12_FS_1_U27 ( .A(mult_12_FS_1_n70), .B(mult_12_FS_1_n71), .ZN(
        N14) );
  NAND2_X1 mult_12_FS_1_U26 ( .A1(mult_12_FS_1_n50), .A2(mult_12_FS_1_n44), 
        .ZN(mult_12_FS_1_n54) );
  AND2_X1 mult_12_FS_1_U25 ( .A1(mult_12_FS_1_n36), .A2(mult_12_FS_1_n35), 
        .ZN(N10) );
  OR2_X2 mult_12_FS_1_U24 ( .A1(mult_12_n66), .A2(mult_12_n67), .ZN(
        mult_12_FS_1_n44) );
  OR2_X2 mult_12_FS_1_U23 ( .A1(mult_12_n65), .A2(mult_12_n64), .ZN(
        mult_12_FS_1_n47) );
  OR2_X2 mult_12_FS_1_U22 ( .A1(mult_12_n62), .A2(mult_12_n63), .ZN(
        mult_12_FS_1_n57) );
  OAI211_X1 mult_12_FS_1_U21 ( .C1(mult_12_FS_1_n58), .C2(mult_12_FS_1_n30), 
        .A(mult_12_FS_1_n59), .B(mult_12_FS_1_n60), .ZN(mult_12_FS_1_n15) );
  NAND3_X1 mult_12_FS_1_U20 ( .A1(mult_12_FS_1_n10), .A2(mult_12_n60), .A3(
        mult_12_A2_6_), .ZN(mult_12_FS_1_n13) );
  OR2_X1 mult_12_FS_1_U19 ( .A1(mult_12_n59), .A2(mult_12_n58), .ZN(
        mult_12_FS_1_n27) );
  INV_X1 mult_12_FS_1_U18 ( .A(mult_12_FS_1_n37), .ZN(mult_12_FS_1_n11) );
  BUF_X1 mult_12_FS_1_U17 ( .A(mult_12_n54), .Z(mult_12_FS_1_n14) );
  OR2_X1 mult_12_FS_1_U16 ( .A1(mult_12_n54), .A2(mult_12_n56), .ZN(
        mult_12_FS_1_n33) );
  OR2_X1 mult_12_FS_1_U15 ( .A1(mult_12_n54), .A2(mult_12_n56), .ZN(
        mult_12_FS_1_n10) );
  CLKBUF_X1 mult_12_FS_1_U14 ( .A(mult_12_n60), .Z(mult_12_FS_1_n9) );
  OR2_X2 mult_12_FS_1_U13 ( .A1(mult_12_n59), .A2(mult_12_n58), .ZN(
        mult_12_FS_1_n12) );
  CLKBUF_X1 mult_12_FS_1_U12 ( .A(mult_12_FS_1_n46), .Z(mult_12_FS_1_n7) );
  NAND2_X1 mult_12_FS_1_U11 ( .A1(mult_12_FS_1_n14), .A2(mult_12_FS_1_n1), 
        .ZN(mult_12_FS_1_n6) );
  AND2_X1 mult_12_FS_1_U10 ( .A1(mult_12_FS_1_n24), .A2(mult_12_FS_1_n6), .ZN(
        mult_12_FS_1_n5) );
  XNOR2_X1 mult_12_FS_1_U9 ( .A(mult_12_FS_1_n35), .B(mult_12_FS_1_n5), .ZN(
        N11) );
  NAND2_X1 mult_12_FS_1_U8 ( .A1(mult_12_FS_1_n31), .A2(mult_12_FS_1_n30), 
        .ZN(mult_12_FS_1_n4) );
  XNOR2_X1 mult_12_FS_1_U7 ( .A(mult_12_FS_1_n2), .B(mult_12_FS_1_n4), .ZN(N12) );
  AND2_X1 mult_12_FS_1_U6 ( .A1(mult_12_FS_1_n74), .A2(mult_12_FS_1_n6), .ZN(
        mult_12_FS_1_n8) );
  AND2_X1 mult_12_FS_1_U5 ( .A1(mult_12_FS_1_n74), .A2(mult_12_FS_1_n6), .ZN(
        mult_12_FS_1_n3) );
  CLKBUF_X1 mult_12_FS_1_U4 ( .A(mult_12_FS_1_n23), .Z(mult_12_FS_1_n2) );
  OR2_X2 mult_12_FS_1_U3 ( .A1(mult_12_n57), .A2(mult_12_n61), .ZN(
        mult_12_FS_1_n31) );
  BUF_X1 mult_12_FS_1_U2 ( .A(mult_12_n56), .Z(mult_12_FS_1_n1) );
  INV_X1 add_17_U205 ( .A(add_17_n184), .ZN(add_17_n176) );
  INV_X1 add_17_U204 ( .A(add_17_n116), .ZN(add_17_n185) );
  NAND2_X1 add_17_U203 ( .A1(acc[4]), .A2(product[4]), .ZN(add_17_n187) );
  INV_X1 add_17_U202 ( .A(add_17_n50), .ZN(add_17_n182) );
  NAND2_X1 add_17_U201 ( .A1(product[1]), .A2(acc[1]), .ZN(add_17_n181) );
  NAND3_X1 add_17_U200 ( .A1(add_17_n56), .A2(add_17_n53), .A3(add_17_n180), 
        .ZN(add_17_n178) );
  INV_X1 add_17_U199 ( .A(add_17_n53), .ZN(add_17_n49) );
  INV_X1 add_17_U198 ( .A(add_17_n8), .ZN(add_17_n174) );
  NAND2_X1 add_17_U197 ( .A1(add_17_n170), .A2(add_17_n171), .ZN(add_17_n168)
         );
  XNOR2_X1 add_17_U196 ( .A(add_17_n168), .B(add_17_n169), .ZN(N29) );
  INV_X1 add_17_U195 ( .A(add_17_n167), .ZN(add_17_n156) );
  NAND2_X1 add_17_U194 ( .A1(product[1]), .A2(acc[1]), .ZN(add_17_n166) );
  INV_X1 add_17_U193 ( .A(add_17_n105), .ZN(add_17_n71) );
  INV_X1 add_17_U192 ( .A(add_17_n129), .ZN(add_17_n136) );
  INV_X1 add_17_U191 ( .A(add_17_n7), .ZN(add_17_n154) );
  INV_X1 add_17_U190 ( .A(add_17_n11), .ZN(add_17_n155) );
  INV_X1 add_17_U189 ( .A(add_17_n10), .ZN(add_17_n153) );
  NAND3_X1 add_17_U188 ( .A1(add_17_n129), .A2(add_17_n7), .A3(add_17_n153), 
        .ZN(add_17_n150) );
  NAND2_X1 add_17_U187 ( .A1(add_17_n150), .A2(add_17_n151), .ZN(add_17_n149)
         );
  INV_X1 add_17_U186 ( .A(add_17_n123), .ZN(add_17_n128) );
  INV_X1 add_17_U185 ( .A(add_17_n127), .ZN(add_17_n147) );
  NAND3_X1 add_17_U184 ( .A1(acc[8]), .A2(product[8]), .A3(add_17_n7), .ZN(
        add_17_n124) );
  INV_X1 add_17_U183 ( .A(add_17_n124), .ZN(add_17_n137) );
  INV_X1 add_17_U182 ( .A(add_17_n70), .ZN(add_17_n104) );
  INV_X1 add_17_U181 ( .A(add_17_n117), .ZN(add_17_n115) );
  OAI21_X1 add_17_U180 ( .B1(add_17_n115), .B2(add_17_n116), .A(add_17_n16), 
        .ZN(add_17_n114) );
  INV_X1 add_17_U179 ( .A(add_17_n33), .ZN(add_17_n74) );
  NAND2_X1 add_17_U178 ( .A1(product[1]), .A2(acc[1]), .ZN(add_17_n113) );
  NAND2_X1 add_17_U177 ( .A1(add_17_n74), .A2(add_17_n112), .ZN(add_17_n111)
         );
  NAND2_X1 add_17_U176 ( .A1(add_17_n110), .A2(add_17_n102), .ZN(add_17_n109)
         );
  NAND2_X1 add_17_U175 ( .A1(add_17_n108), .A2(add_17_n109), .ZN(add_17_n106)
         );
  XNOR2_X1 add_17_U174 ( .A(add_17_n106), .B(add_17_n107), .ZN(N32) );
  INV_X1 add_17_U173 ( .A(add_17_n89), .ZN(add_17_n95) );
  NAND2_X1 add_17_U172 ( .A1(add_17_n103), .A2(add_17_n104), .ZN(add_17_n97)
         );
  INV_X1 add_17_U171 ( .A(add_17_n102), .ZN(add_17_n98) );
  INV_X1 add_17_U170 ( .A(add_17_n101), .ZN(add_17_n82) );
  INV_X1 add_17_U169 ( .A(add_17_n67), .ZN(add_17_n100) );
  INV_X1 add_17_U168 ( .A(add_17_n68), .ZN(add_17_n92) );
  INV_X1 add_17_U167 ( .A(add_17_n88), .ZN(add_17_n66) );
  NAND2_X1 add_17_U166 ( .A1(add_17_n84), .A2(add_17_n85), .ZN(add_17_n80) );
  INV_X1 add_17_U165 ( .A(add_17_n83), .ZN(add_17_n72) );
  NAND2_X1 add_17_U164 ( .A1(add_17_n80), .A2(add_17_n81), .ZN(add_17_n79) );
  NAND2_X1 add_17_U163 ( .A1(product[1]), .A2(acc[1]), .ZN(add_17_n76) );
  NAND2_X1 add_17_U162 ( .A1(add_17_n74), .A2(add_17_n75), .ZN(add_17_n73) );
  NAND2_X1 add_17_U161 ( .A1(add_17_n62), .A2(add_17_n63), .ZN(add_17_n60) );
  XNOR2_X1 add_17_U160 ( .A(add_17_n60), .B(add_17_n61), .ZN(N34) );
  INV_X1 add_17_U159 ( .A(add_17_n51), .ZN(add_17_n48) );
  OAI21_X1 add_17_U158 ( .B1(add_17_n48), .B2(add_17_n49), .A(add_17_n50), 
        .ZN(add_17_n45) );
  XNOR2_X1 add_17_U157 ( .A(add_17_n45), .B(add_17_n46), .ZN(N22) );
  XNOR2_X1 add_17_U156 ( .A(add_17_n43), .B(add_17_n44), .ZN(N23) );
  INV_X1 add_17_U155 ( .A(add_17_n43), .ZN(add_17_n41) );
  INV_X1 add_17_U154 ( .A(add_17_n42), .ZN(add_17_n30) );
  NAND2_X1 add_17_U153 ( .A1(product[1]), .A2(acc[1]), .ZN(add_17_n37) );
  INV_X1 add_17_U152 ( .A(add_17_n31), .ZN(add_17_n29) );
  NOR2_X1 add_17_U151 ( .A1(add_17_n29), .A2(add_17_n30), .ZN(add_17_n28) );
  NAND2_X1 add_17_U150 ( .A1(add_17_n22), .A2(add_17_n23), .ZN(add_17_n24) );
  XNOR2_X1 add_17_U149 ( .A(add_17_n24), .B(add_17_n25), .ZN(N25) );
  NAND3_X1 add_17_U148 ( .A1(add_17_n32), .A2(add_17_n36), .A3(add_17_n111), 
        .ZN(add_17_n102) );
  NAND3_X1 add_17_U147 ( .A1(add_17_n32), .A2(add_17_n36), .A3(add_17_n73), 
        .ZN(add_17_n43) );
  NAND2_X1 add_17_U146 ( .A1(product[7]), .A2(acc[7]), .ZN(add_17_n16) );
  INV_X1 add_17_U145 ( .A(product[0]), .ZN(add_17_n188) );
  INV_X1 add_17_U144 ( .A(acc[0]), .ZN(add_17_n189) );
  NAND2_X1 add_17_U143 ( .A1(product[14]), .A2(acc[14]), .ZN(add_17_n68) );
  NAND2_X1 add_17_U142 ( .A1(product[1]), .A2(acc[1]), .ZN(add_17_n55) );
  NAND2_X1 add_17_U141 ( .A1(product[8]), .A2(acc[8]), .ZN(add_17_n10) );
  NAND2_X1 add_17_U140 ( .A1(product[12]), .A2(acc[12]), .ZN(add_17_n101) );
  NAND2_X1 add_17_U139 ( .A1(product[13]), .A2(acc[13]), .ZN(add_17_n67) );
  OR2_X1 add_17_U138 ( .A1(product[2]), .A2(acc[2]), .ZN(add_17_n53) );
  NAND2_X1 add_17_U137 ( .A1(product[0]), .A2(acc[0]), .ZN(add_17_n59) );
  NAND2_X1 add_17_U136 ( .A1(add_17_n181), .A2(add_17_n77), .ZN(add_17_n180)
         );
  NAND2_X1 add_17_U135 ( .A1(product[9]), .A2(acc[9]), .ZN(add_17_n8) );
  NAND2_X1 add_17_U134 ( .A1(product[10]), .A2(acc[10]), .ZN(add_17_n122) );
  NAND2_X1 add_17_U133 ( .A1(product[4]), .A2(acc[4]), .ZN(add_17_n35) );
  NAND2_X1 add_17_U132 ( .A1(product[0]), .A2(acc[0]), .ZN(add_17_n77) );
  OR2_X1 add_17_U131 ( .A1(product[14]), .A2(acc[14]), .ZN(add_17_n88) );
  NAND2_X1 add_17_U130 ( .A1(product[3]), .A2(acc[3]), .ZN(add_17_n36) );
  OR2_X1 add_17_U129 ( .A1(product[12]), .A2(acc[12]), .ZN(add_17_n119) );
  NAND2_X1 add_17_U128 ( .A1(product[11]), .A2(acc[11]), .ZN(add_17_n123) );
  OR2_X1 add_17_U127 ( .A1(product[11]), .A2(acc[11]), .ZN(add_17_n127) );
  AND2_X1 add_17_U126 ( .A1(add_17_n37), .A2(add_17_n38), .ZN(add_17_n4) );
  NAND2_X1 add_17_U125 ( .A1(add_17_n76), .A2(add_17_n77), .ZN(add_17_n75) );
  NAND2_X1 add_17_U124 ( .A1(product[6]), .A2(acc[6]), .ZN(add_17_n18) );
  NOR2_X1 add_17_U123 ( .A1(acc[10]), .A2(product[10]), .ZN(add_17_n141) );
  XNOR2_X1 add_17_U122 ( .A(product[15]), .B(acc[15]), .ZN(add_17_n61) );
  NOR2_X1 add_17_U121 ( .A1(acc[11]), .A2(product[11]), .ZN(add_17_n144) );
  NAND2_X1 add_17_U120 ( .A1(product[2]), .A2(acc[2]), .ZN(add_17_n50) );
  NAND2_X1 add_17_U119 ( .A1(product[0]), .A2(acc[0]), .ZN(add_17_n38) );
  NAND2_X1 add_17_U118 ( .A1(product[5]), .A2(acc[5]), .ZN(add_17_n23) );
  NOR2_X1 add_17_U117 ( .A1(acc[5]), .A2(product[5]), .ZN(add_17_n186) );
  OAI211_X1 add_17_U116 ( .C1(add_17_n186), .C2(add_17_n187), .A(add_17_n18), 
        .B(add_17_n23), .ZN(add_17_n117) );
  NOR2_X1 add_17_U115 ( .A1(acc[9]), .A2(product[9]), .ZN(add_17_n143) );
  NOR2_X1 add_17_U114 ( .A1(add_17_n141), .A2(add_17_n142), .ZN(add_17_n140)
         );
  NOR2_X1 add_17_U113 ( .A1(add_17_n143), .A2(add_17_n144), .ZN(add_17_n139)
         );
  AND2_X1 add_17_U112 ( .A1(add_17_n139), .A2(add_17_n140), .ZN(add_17_n118)
         );
  NOR2_X1 add_17_U111 ( .A1(acc[8]), .A2(product[8]), .ZN(add_17_n142) );
  NAND2_X1 add_17_U110 ( .A1(add_17_n113), .A2(add_17_n77), .ZN(add_17_n112)
         );
  OR2_X1 add_17_U109 ( .A1(product[3]), .A2(acc[3]), .ZN(add_17_n47) );
  NOR2_X1 add_17_U108 ( .A1(acc[2]), .A2(product[2]), .ZN(add_17_n165) );
  OR2_X1 add_17_U107 ( .A1(product[4]), .A2(acc[4]), .ZN(add_17_n42) );
  INV_X1 add_17_U106 ( .A(product[1]), .ZN(add_17_n162) );
  OR2_X1 add_17_U105 ( .A1(product[7]), .A2(acc[7]), .ZN(add_17_n17) );
  OR2_X1 add_17_U104 ( .A1(product[5]), .A2(acc[5]), .ZN(add_17_n31) );
  INV_X1 add_17_U103 ( .A(acc[1]), .ZN(add_17_n163) );
  NOR2_X1 add_17_U102 ( .A1(acc[3]), .A2(product[3]), .ZN(add_17_n164) );
  NAND2_X1 add_17_U101 ( .A1(add_17_n162), .A2(add_17_n163), .ZN(add_17_n161)
         );
  NOR2_X1 add_17_U100 ( .A1(add_17_n164), .A2(add_17_n165), .ZN(add_17_n160)
         );
  NAND2_X1 add_17_U99 ( .A1(add_17_n160), .A2(add_17_n161), .ZN(add_17_n33) );
  OAI21_X1 add_17_U98 ( .B1(add_17_n2), .B2(add_17_n33), .A(add_17_n32), .ZN(
        add_17_n159) );
  NAND2_X1 add_17_U97 ( .A1(add_17_n188), .A2(add_17_n189), .ZN(add_17_n179)
         );
  NAND2_X1 add_17_U96 ( .A1(add_17_n56), .A2(add_17_n55), .ZN(add_17_n58) );
  XNOR2_X1 add_17_U95 ( .A(add_17_n57), .B(add_17_n58), .ZN(N20) );
  NAND2_X1 add_17_U94 ( .A1(add_17_n53), .A2(add_17_n50), .ZN(add_17_n52) );
  XNOR2_X1 add_17_U93 ( .A(add_17_n51), .B(add_17_n52), .ZN(N21) );
  NAND2_X1 add_17_U92 ( .A1(add_17_n8), .A2(add_17_n122), .ZN(add_17_n152) );
  NAND2_X1 add_17_U91 ( .A1(add_17_n152), .A2(add_17_n129), .ZN(add_17_n151)
         );
  NOR3_X1 add_17_U90 ( .A1(add_17_n136), .A2(add_17_n154), .A3(add_17_n155), 
        .ZN(add_17_n148) );
  INV_X1 add_17_U89 ( .A(add_17_n59), .ZN(add_17_n57) );
  NAND2_X1 add_17_U88 ( .A1(add_17_n47), .A2(add_17_n36), .ZN(add_17_n46) );
  NAND2_X1 add_17_U87 ( .A1(add_17_n56), .A2(add_17_n57), .ZN(add_17_n54) );
  NAND2_X1 add_17_U86 ( .A1(add_17_n54), .A2(add_17_n55), .ZN(add_17_n51) );
  NAND2_X1 add_17_U85 ( .A1(add_17_n162), .A2(add_17_n163), .ZN(add_17_n56) );
  NAND2_X1 add_17_U84 ( .A1(add_17_n42), .A2(add_17_n35), .ZN(add_17_n44) );
  NAND2_X1 add_17_U83 ( .A1(add_17_n20), .A2(add_17_n18), .ZN(add_17_n25) );
  NOR2_X1 add_17_U82 ( .A1(add_17_n10), .A2(add_17_n184), .ZN(add_17_n183) );
  AOI21_X1 add_17_U81 ( .B1(add_17_n176), .B2(add_17_n167), .A(add_17_n183), 
        .ZN(add_17_n170) );
  AND2_X1 add_17_U80 ( .A1(add_17_n32), .A2(add_17_n36), .ZN(add_17_n177) );
  NOR2_X1 add_17_U79 ( .A1(add_17_n70), .A2(add_17_n105), .ZN(add_17_n110) );
  AND2_X1 add_17_U78 ( .A1(add_17_n35), .A2(add_17_n36), .ZN(add_17_n34) );
  NAND2_X1 add_17_U77 ( .A1(add_17_n88), .A2(add_17_n89), .ZN(add_17_n83) );
  NAND2_X1 add_17_U76 ( .A1(add_17_n10), .A2(add_17_n11), .ZN(add_17_n13) );
  XNOR2_X1 add_17_U75 ( .A(add_17_n12), .B(add_17_n13), .ZN(N27) );
  NAND2_X1 add_17_U74 ( .A1(add_17_n8), .A2(add_17_n122), .ZN(add_17_n138) );
  NOR2_X1 add_17_U73 ( .A1(add_17_n137), .A2(add_17_n138), .ZN(add_17_n135) );
  OAI21_X1 add_17_U72 ( .B1(add_17_n135), .B2(add_17_n136), .A(add_17_n123), 
        .ZN(add_17_n134) );
  NAND2_X1 add_17_U71 ( .A1(add_17_n134), .A2(add_17_n127), .ZN(add_17_n133)
         );
  NAND2_X1 add_17_U70 ( .A1(add_17_n119), .A2(add_17_n127), .ZN(add_17_n126)
         );
  NAND2_X1 add_17_U69 ( .A1(add_17_n129), .A2(add_17_n122), .ZN(add_17_n169)
         );
  NAND2_X1 add_17_U68 ( .A1(add_17_n176), .A2(add_17_n47), .ZN(add_17_n175) );
  NAND2_X1 add_17_U67 ( .A1(add_17_n7), .A2(add_17_n11), .ZN(add_17_n184) );
  NOR2_X1 add_17_U66 ( .A1(add_17_n105), .A2(add_17_n175), .ZN(add_17_n173) );
  NAND2_X1 add_17_U65 ( .A1(add_17_n177), .A2(add_17_n178), .ZN(add_17_n172)
         );
  AOI21_X1 add_17_U64 ( .B1(add_17_n172), .B2(add_17_n173), .A(add_17_n174), 
        .ZN(add_17_n171) );
  NOR2_X1 add_17_U63 ( .A1(add_17_n70), .A2(add_17_n83), .ZN(add_17_n84) );
  NAND2_X1 add_17_U62 ( .A1(add_17_n86), .A2(add_17_n16), .ZN(add_17_n85) );
  OAI21_X1 add_17_U61 ( .B1(add_17_n41), .B2(add_17_n30), .A(add_17_n35), .ZN(
        add_17_n39) );
  NAND2_X1 add_17_U60 ( .A1(add_17_n31), .A2(add_17_n23), .ZN(add_17_n40) );
  XNOR2_X1 add_17_U59 ( .A(add_17_n39), .B(add_17_n40), .ZN(N24) );
  NAND2_X1 add_17_U58 ( .A1(add_17_n67), .A2(add_17_n89), .ZN(add_17_n107) );
  AND2_X1 add_17_U57 ( .A1(add_17_n87), .A2(add_17_n101), .ZN(add_17_n3) );
  AND2_X1 add_17_U56 ( .A1(add_17_n3), .A2(add_17_n96), .ZN(add_17_n108) );
  NAND2_X1 add_17_U55 ( .A1(add_17_n71), .A2(add_17_n72), .ZN(add_17_n69) );
  NOR2_X1 add_17_U54 ( .A1(add_17_n69), .A2(add_17_n70), .ZN(add_17_n64) );
  OAI21_X1 add_17_U53 ( .B1(add_17_n66), .B2(add_17_n67), .A(add_17_n68), .ZN(
        add_17_n65) );
  AOI21_X1 add_17_U52 ( .B1(add_17_n43), .B2(add_17_n64), .A(add_17_n65), .ZN(
        add_17_n63) );
  NOR2_X1 add_17_U51 ( .A1(add_17_n128), .A2(add_17_n129), .ZN(add_17_n125) );
  NAND4_X1 add_17_U50 ( .A1(add_17_n8), .A2(add_17_n122), .A3(add_17_n123), 
        .A4(add_17_n124), .ZN(add_17_n121) );
  NOR2_X1 add_17_U49 ( .A1(add_17_n125), .A2(add_17_n126), .ZN(add_17_n120) );
  NAND2_X1 add_17_U48 ( .A1(add_17_n120), .A2(add_17_n121), .ZN(add_17_n87) );
  AOI21_X1 add_17_U47 ( .B1(add_17_n12), .B2(add_17_n148), .A(add_17_n149), 
        .ZN(add_17_n145) );
  NOR2_X1 add_17_U46 ( .A1(add_17_n128), .A2(add_17_n147), .ZN(add_17_n146) );
  XNOR2_X1 add_17_U45 ( .A(add_17_n145), .B(add_17_n146), .ZN(N30) );
  NAND2_X1 add_17_U44 ( .A1(add_17_n104), .A2(add_17_n114), .ZN(add_17_n96) );
  NAND2_X1 add_17_U43 ( .A1(add_17_n118), .A2(add_17_n119), .ZN(add_17_n70) );
  NOR2_X1 add_17_U42 ( .A1(add_17_n93), .A2(add_17_n94), .ZN(add_17_n90) );
  NOR2_X1 add_17_U41 ( .A1(add_17_n92), .A2(add_17_n66), .ZN(add_17_n91) );
  XNOR2_X1 add_17_U40 ( .A(add_17_n90), .B(add_17_n91), .ZN(N33) );
  AOI21_X1 add_17_U39 ( .B1(add_17_n82), .B2(add_17_n89), .A(add_17_n100), 
        .ZN(add_17_n99) );
  OAI21_X1 add_17_U38 ( .B1(add_17_n97), .B2(add_17_n98), .A(add_17_n99), .ZN(
        add_17_n93) );
  NAND2_X1 add_17_U37 ( .A1(add_17_n182), .A2(add_17_n47), .ZN(add_17_n32) );
  NAND2_X1 add_17_U36 ( .A1(add_17_n18), .A2(add_17_n19), .ZN(add_17_n14) );
  NAND2_X1 add_17_U35 ( .A1(add_17_n16), .A2(add_17_n17), .ZN(add_17_n15) );
  XNOR2_X1 add_17_U34 ( .A(add_17_n14), .B(add_17_n15), .ZN(N26) );
  NAND2_X1 add_17_U33 ( .A1(add_17_n22), .A2(add_17_n23), .ZN(add_17_n21) );
  NAND2_X1 add_17_U32 ( .A1(add_17_n20), .A2(add_17_n21), .ZN(add_17_n19) );
  OAI21_X1 add_17_U31 ( .B1(add_17_n4), .B2(add_17_n33), .A(add_17_n34), .ZN(
        add_17_n26) );
  INV_X1 add_17_U30 ( .A(add_17_n32), .ZN(add_17_n27) );
  OAI21_X1 add_17_U29 ( .B1(add_17_n26), .B2(add_17_n27), .A(add_17_n28), .ZN(
        add_17_n22) );
  NAND2_X1 add_17_U28 ( .A1(add_17_n20), .A2(add_17_n17), .ZN(add_17_n116) );
  NAND2_X1 add_17_U27 ( .A1(add_17_n185), .A2(add_17_n117), .ZN(add_17_n86) );
  NAND2_X1 add_17_U26 ( .A1(add_17_n86), .A2(add_17_n16), .ZN(add_17_n167) );
  NAND4_X1 add_17_U25 ( .A1(add_17_n42), .A2(add_17_n31), .A3(add_17_n20), 
        .A4(add_17_n17), .ZN(add_17_n105) );
  NAND2_X1 add_17_U24 ( .A1(add_17_n132), .A2(add_17_n133), .ZN(add_17_n130)
         );
  NAND2_X1 add_17_U23 ( .A1(add_17_n101), .A2(add_17_n119), .ZN(add_17_n131)
         );
  XNOR2_X1 add_17_U22 ( .A(add_17_n130), .B(add_17_n131), .ZN(N31) );
  NAND2_X1 add_17_U21 ( .A1(add_17_n118), .A2(add_17_n12), .ZN(add_17_n132) );
  NAND2_X1 add_17_U20 ( .A1(add_17_n9), .A2(add_17_n10), .ZN(add_17_n5) );
  NAND2_X1 add_17_U19 ( .A1(add_17_n7), .A2(add_17_n8), .ZN(add_17_n6) );
  XNOR2_X1 add_17_U18 ( .A(add_17_n5), .B(add_17_n6), .ZN(N28) );
  NAND2_X1 add_17_U17 ( .A1(add_17_n11), .A2(add_17_n12), .ZN(add_17_n9) );
  INV_X1 add_17_U16 ( .A(add_17_n36), .ZN(add_17_n158) );
  OAI21_X1 add_17_U15 ( .B1(add_17_n158), .B2(add_17_n159), .A(add_17_n71), 
        .ZN(add_17_n157) );
  NAND2_X1 add_17_U14 ( .A1(add_17_n156), .A2(add_17_n157), .ZN(add_17_n12) );
  NOR2_X1 add_17_U13 ( .A1(add_17_n105), .A2(add_17_n95), .ZN(add_17_n103) );
  NAND2_X1 add_17_U12 ( .A1(add_17_n82), .A2(add_17_n72), .ZN(add_17_n81) );
  NOR2_X1 add_17_U11 ( .A1(add_17_n83), .A2(add_17_n87), .ZN(add_17_n78) );
  NOR2_X1 add_17_U10 ( .A1(add_17_n78), .A2(add_17_n79), .ZN(add_17_n62) );
  OAI22_X1 add_17_U9 ( .A1(add_17_n95), .A2(add_17_n96), .B1(add_17_n95), .B2(
        add_17_n87), .ZN(add_17_n94) );
  OR2_X1 add_17_U8 ( .A1(product[8]), .A2(acc[8]), .ZN(add_17_n11) );
  OR2_X1 add_17_U7 ( .A1(product[13]), .A2(acc[13]), .ZN(add_17_n89) );
  OR2_X1 add_17_U6 ( .A1(product[10]), .A2(acc[10]), .ZN(add_17_n129) );
  OR2_X1 add_17_U5 ( .A1(product[9]), .A2(acc[9]), .ZN(add_17_n7) );
  OR2_X1 add_17_U4 ( .A1(product[6]), .A2(acc[6]), .ZN(add_17_n20) );
  AND2_X1 add_17_U3 ( .A1(add_17_n166), .A2(add_17_n38), .ZN(add_17_n2) );
  AND2_X1 add_17_U2 ( .A1(add_17_n59), .A2(add_17_n179), .ZN(N19) );
endmodule

