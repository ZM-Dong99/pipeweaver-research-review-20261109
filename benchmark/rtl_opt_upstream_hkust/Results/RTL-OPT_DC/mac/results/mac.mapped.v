/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 01:45:13 2025
/////////////////////////////////////////////////////////////


module mac ( clk, a, b, reset, z );
  input [7:0] a;
  input [7:0] b;
  output [15:0] z;
  input clk, reset;
  wire   N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16,
         N17, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30, N31,
         N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44, N45,
         N46, N47, N48, N49, N50, n5, mult_16_n79, mult_16_n78, mult_16_n77,
         mult_16_n76, mult_16_n75, mult_16_n74, mult_16_n73, mult_16_n72,
         mult_16_n71, mult_16_n70, mult_16_n69, mult_16_n68, mult_16_n67,
         mult_16_n66, mult_16_n65, mult_16_n64, mult_16_n63, mult_16_n62,
         mult_16_n61, mult_16_n60, mult_16_n59, mult_16_n58, mult_16_n57,
         mult_16_n56, mult_16_n55, mult_16_n54, mult_16_n53, mult_16_n52,
         mult_16_n51, mult_16_n50, mult_16_n48, mult_16_n47, mult_16_n46,
         mult_16_n45, mult_16_n44, mult_16_n43, mult_16_n42, mult_16_n41,
         mult_16_n40, mult_16_n39, mult_16_n38, mult_16_n37, mult_16_n36,
         mult_16_n35, mult_16_n34, mult_16_n33, mult_16_n32, mult_16_n31,
         mult_16_n30, mult_16_n29, mult_16_n28, mult_16_n27, mult_16_n26,
         mult_16_n25, mult_16_n24, mult_16_n23, mult_16_n22, mult_16_n21,
         mult_16_n20, mult_16_n19, mult_16_n18, mult_16_n17, mult_16_n16,
         mult_16_n15, mult_16_n14, mult_16_n13, mult_16_n12, mult_16_n11,
         mult_16_n10, mult_16_n9, mult_16_n8, mult_16_n7, mult_16_n6,
         mult_16_n5, mult_16_n4, mult_16_n3, mult_16_n2, mult_16_A2_6_,
         mult_16_A2_7_, mult_16_A1_0_, mult_16_A1_1_, mult_16_A1_2_,
         mult_16_A1_3_, mult_16_A1_4_, mult_16_A1_5_, mult_16_A1_6_,
         mult_16_A1_13_, mult_16_SUMB_1__5_, mult_16_SUMB_1__6_,
         mult_16_SUMB_2__1_, mult_16_SUMB_2__2_, mult_16_SUMB_2__3_,
         mult_16_SUMB_2__4_, mult_16_SUMB_2__5_, mult_16_SUMB_2__6_,
         mult_16_SUMB_3__1_, mult_16_SUMB_3__2_, mult_16_SUMB_3__3_,
         mult_16_SUMB_3__4_, mult_16_SUMB_3__5_, mult_16_SUMB_3__6_,
         mult_16_SUMB_4__1_, mult_16_SUMB_4__2_, mult_16_SUMB_4__3_,
         mult_16_SUMB_4__4_, mult_16_SUMB_4__5_, mult_16_SUMB_4__6_,
         mult_16_SUMB_5__1_, mult_16_SUMB_5__2_, mult_16_SUMB_5__3_,
         mult_16_SUMB_5__4_, mult_16_SUMB_5__5_, mult_16_SUMB_5__6_,
         mult_16_SUMB_6__1_, mult_16_SUMB_6__2_, mult_16_SUMB_6__3_,
         mult_16_SUMB_6__4_, mult_16_SUMB_6__5_, mult_16_SUMB_6__6_,
         mult_16_SUMB_7__0_, mult_16_SUMB_7__1_, mult_16_SUMB_7__2_,
         mult_16_SUMB_7__3_, mult_16_SUMB_7__4_, mult_16_SUMB_7__5_,
         mult_16_SUMB_7__6_, mult_16_SUMB_7__7_, mult_16_CARRYB_1__5_,
         mult_16_CARRYB_1__6_, mult_16_CARRYB_2__0_, mult_16_CARRYB_2__1_,
         mult_16_CARRYB_2__2_, mult_16_CARRYB_2__3_, mult_16_CARRYB_2__4_,
         mult_16_CARRYB_2__5_, mult_16_CARRYB_2__6_, mult_16_CARRYB_3__0_,
         mult_16_CARRYB_3__1_, mult_16_CARRYB_3__2_, mult_16_CARRYB_3__3_,
         mult_16_CARRYB_3__4_, mult_16_CARRYB_3__5_, mult_16_CARRYB_3__6_,
         mult_16_CARRYB_4__0_, mult_16_CARRYB_4__1_, mult_16_CARRYB_4__2_,
         mult_16_CARRYB_4__3_, mult_16_CARRYB_4__4_, mult_16_CARRYB_4__5_,
         mult_16_CARRYB_4__6_, mult_16_CARRYB_5__0_, mult_16_CARRYB_5__1_,
         mult_16_CARRYB_5__2_, mult_16_CARRYB_5__3_, mult_16_CARRYB_5__4_,
         mult_16_CARRYB_5__5_, mult_16_CARRYB_5__6_, mult_16_CARRYB_6__0_,
         mult_16_CARRYB_6__1_, mult_16_CARRYB_6__2_, mult_16_CARRYB_6__3_,
         mult_16_CARRYB_6__4_, mult_16_CARRYB_6__5_, mult_16_CARRYB_6__6_,
         mult_16_CARRYB_7__0_, mult_16_CARRYB_7__1_, mult_16_CARRYB_7__2_,
         mult_16_CARRYB_7__3_, mult_16_CARRYB_7__4_, mult_16_CARRYB_7__5_,
         mult_16_CARRYB_7__6_, mult_16_CARRYB_7__7_, mult_16_ab_0__1_,
         mult_16_ab_0__2_, mult_16_ab_0__3_, mult_16_ab_0__4_,
         mult_16_ab_0__5_, mult_16_ab_0__6_, mult_16_ab_0__7_,
         mult_16_ab_1__0_, mult_16_ab_1__1_, mult_16_ab_1__2_,
         mult_16_ab_1__3_, mult_16_ab_1__4_, mult_16_ab_1__5_,
         mult_16_ab_1__6_, mult_16_ab_1__7_, mult_16_ab_2__0_,
         mult_16_ab_2__1_, mult_16_ab_2__2_, mult_16_ab_2__3_,
         mult_16_ab_2__4_, mult_16_ab_2__5_, mult_16_ab_2__6_,
         mult_16_ab_2__7_, mult_16_ab_3__0_, mult_16_ab_3__1_,
         mult_16_ab_3__2_, mult_16_ab_3__3_, mult_16_ab_3__4_,
         mult_16_ab_3__5_, mult_16_ab_3__6_, mult_16_ab_3__7_,
         mult_16_ab_4__0_, mult_16_ab_4__1_, mult_16_ab_4__2_,
         mult_16_ab_4__3_, mult_16_ab_4__4_, mult_16_ab_4__5_,
         mult_16_ab_4__6_, mult_16_ab_4__7_, mult_16_ab_5__0_,
         mult_16_ab_5__1_, mult_16_ab_5__2_, mult_16_ab_5__3_,
         mult_16_ab_5__4_, mult_16_ab_5__5_, mult_16_ab_5__6_,
         mult_16_ab_5__7_, mult_16_ab_6__0_, mult_16_ab_6__1_,
         mult_16_ab_6__2_, mult_16_ab_6__3_, mult_16_ab_6__4_,
         mult_16_ab_6__5_, mult_16_ab_6__6_, mult_16_ab_6__7_,
         mult_16_ab_7__0_, mult_16_ab_7__1_, mult_16_ab_7__2_,
         mult_16_ab_7__3_, mult_16_ab_7__4_, mult_16_ab_7__5_,
         mult_16_ab_7__6_, mult_16_ab_7__7_, mult_16_FS_1_n71,
         mult_16_FS_1_n70, mult_16_FS_1_n69, mult_16_FS_1_n68,
         mult_16_FS_1_n67, mult_16_FS_1_n66, mult_16_FS_1_n65,
         mult_16_FS_1_n64, mult_16_FS_1_n63, mult_16_FS_1_n62,
         mult_16_FS_1_n61, mult_16_FS_1_n60, mult_16_FS_1_n59,
         mult_16_FS_1_n58, mult_16_FS_1_n57, mult_16_FS_1_n56,
         mult_16_FS_1_n55, mult_16_FS_1_n54, mult_16_FS_1_n53,
         mult_16_FS_1_n52, mult_16_FS_1_n51, mult_16_FS_1_n50,
         mult_16_FS_1_n49, mult_16_FS_1_n48, mult_16_FS_1_n47,
         mult_16_FS_1_n46, mult_16_FS_1_n45, mult_16_FS_1_n44,
         mult_16_FS_1_n43, mult_16_FS_1_n42, mult_16_FS_1_n41,
         mult_16_FS_1_n40, mult_16_FS_1_n39, mult_16_FS_1_n38,
         mult_16_FS_1_n37, mult_16_FS_1_n36, mult_16_FS_1_n35,
         mult_16_FS_1_n34, mult_16_FS_1_n33, mult_16_FS_1_n32,
         mult_16_FS_1_n31, mult_16_FS_1_n30, mult_16_FS_1_n29,
         mult_16_FS_1_n28, mult_16_FS_1_n27, mult_16_FS_1_n26,
         mult_16_FS_1_n25, mult_16_FS_1_n24, mult_16_FS_1_n23,
         mult_16_FS_1_n16, mult_16_FS_1_n14, mult_16_FS_1_n13,
         mult_16_FS_1_n12, mult_16_FS_1_n11, mult_16_FS_1_n10, mult_16_FS_1_n9,
         mult_16_FS_1_n8, mult_16_FS_1_n7, mult_16_FS_1_n6, mult_16_FS_1_n5,
         mult_16_FS_1_n4, mult_16_FS_1_n3, mult_16_FS_1_n2, mult_16_FS_1_n1,
         add_21_n189, add_21_n188, add_21_n187, add_21_n186, add_21_n185,
         add_21_n184, add_21_n183, add_21_n182, add_21_n181, add_21_n180,
         add_21_n179, add_21_n178, add_21_n177, add_21_n176, add_21_n175,
         add_21_n174, add_21_n173, add_21_n172, add_21_n171, add_21_n170,
         add_21_n169, add_21_n168, add_21_n167, add_21_n166, add_21_n165,
         add_21_n164, add_21_n163, add_21_n162, add_21_n161, add_21_n160,
         add_21_n159, add_21_n158, add_21_n157, add_21_n156, add_21_n155,
         add_21_n154, add_21_n153, add_21_n152, add_21_n151, add_21_n150,
         add_21_n149, add_21_n148, add_21_n147, add_21_n146, add_21_n145,
         add_21_n144, add_21_n143, add_21_n142, add_21_n141, add_21_n140,
         add_21_n139, add_21_n138, add_21_n137, add_21_n136, add_21_n135,
         add_21_n134, add_21_n133, add_21_n132, add_21_n131, add_21_n130,
         add_21_n129, add_21_n128, add_21_n127, add_21_n126, add_21_n125,
         add_21_n124, add_21_n123, add_21_n122, add_21_n121, add_21_n120,
         add_21_n119, add_21_n118, add_21_n117, add_21_n116, add_21_n115,
         add_21_n114, add_21_n113, add_21_n112, add_21_n111, add_21_n110,
         add_21_n109, add_21_n108, add_21_n107, add_21_n106, add_21_n105,
         add_21_n104, add_21_n103, add_21_n102, add_21_n101, add_21_n100,
         add_21_n99, add_21_n98, add_21_n97, add_21_n96, add_21_n95,
         add_21_n94, add_21_n93, add_21_n92, add_21_n91, add_21_n90,
         add_21_n89, add_21_n88, add_21_n87, add_21_n86, add_21_n85,
         add_21_n84, add_21_n83, add_21_n82, add_21_n81, add_21_n80,
         add_21_n79, add_21_n78, add_21_n77, add_21_n76, add_21_n75,
         add_21_n74, add_21_n73, add_21_n72, add_21_n71, add_21_n70,
         add_21_n69, add_21_n68, add_21_n67, add_21_n66, add_21_n65,
         add_21_n64, add_21_n63, add_21_n62, add_21_n61, add_21_n60,
         add_21_n59, add_21_n58, add_21_n57, add_21_n56, add_21_n55,
         add_21_n54, add_21_n53, add_21_n52, add_21_n51, add_21_n50,
         add_21_n49, add_21_n48, add_21_n47, add_21_n46, add_21_n45,
         add_21_n44, add_21_n43, add_21_n42, add_21_n41, add_21_n40,
         add_21_n39, add_21_n38, add_21_n37, add_21_n36, add_21_n35,
         add_21_n34, add_21_n33, add_21_n32, add_21_n31, add_21_n30,
         add_21_n29, add_21_n28, add_21_n27, add_21_n26, add_21_n25,
         add_21_n24, add_21_n23, add_21_n22, add_21_n21, add_21_n20,
         add_21_n19, add_21_n18, add_21_n17, add_21_n16, add_21_n15,
         add_21_n14, add_21_n13, add_21_n12, add_21_n11, add_21_n10, add_21_n9,
         add_21_n8, add_21_n7, add_21_n6, add_21_n5, add_21_n4, add_21_n3,
         add_21_n2;
  wire   [15:0] acc;
  wire   [7:0] a_reg;
  wire   [7:0] b_reg;
  wire   [15:0] product_reg;

  DFF_X1 a_reg_reg_7_ ( .D(a[7]), .CK(clk), .Q(a_reg[7]) );
  DFF_X1 a_reg_reg_6_ ( .D(a[6]), .CK(clk), .Q(a_reg[6]) );
  DFF_X1 a_reg_reg_5_ ( .D(a[5]), .CK(clk), .Q(a_reg[5]) );
  DFF_X1 a_reg_reg_4_ ( .D(a[4]), .CK(clk), .Q(a_reg[4]) );
  DFF_X1 a_reg_reg_3_ ( .D(a[3]), .CK(clk), .Q(a_reg[3]) );
  DFF_X1 b_reg_reg_6_ ( .D(b[6]), .CK(clk), .Q(b_reg[6]) );
  DFF_X1 b_reg_reg_5_ ( .D(b[5]), .CK(clk), .Q(b_reg[5]) );
  DFF_X1 b_reg_reg_4_ ( .D(b[4]), .CK(clk), .Q(b_reg[4]) );
  DFF_X1 b_reg_reg_3_ ( .D(b[3]), .CK(clk), .Q(b_reg[3]) );
  DFF_X1 b_reg_reg_2_ ( .D(b[2]), .CK(clk), .Q(b_reg[2]) );
  DFF_X1 b_reg_reg_1_ ( .D(b[1]), .CK(clk), .Q(b_reg[1]) );
  DFF_X1 product_reg_reg_6_ ( .D(N8), .CK(clk), .Q(product_reg[6]) );
  DFF_X1 product_reg_reg_5_ ( .D(N7), .CK(clk), .Q(product_reg[5]) );
  DFF_X1 product_reg_reg_4_ ( .D(N6), .CK(clk), .Q(product_reg[4]) );
  DFF_X1 product_reg_reg_3_ ( .D(N5), .CK(clk), .Q(product_reg[3]) );
  DFF_X1 product_reg_reg_2_ ( .D(N4), .CK(clk), .Q(product_reg[2]) );
  DFF_X1 product_reg_reg_1_ ( .D(N3), .CK(clk), .Q(product_reg[1]) );
  DFF_X1 product_reg_reg_0_ ( .D(N2), .CK(clk), .Q(product_reg[0]) );
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
  DFF_X1 b_reg_reg_0_ ( .D(b[0]), .CK(clk), .Q(b_reg[0]) );
  DFF_X1 a_reg_reg_2_ ( .D(a[2]), .CK(clk), .Q(a_reg[2]) );
  DFF_X1 a_reg_reg_0_ ( .D(a[0]), .CK(clk), .Q(a_reg[0]) );
  DFF_X1 a_reg_reg_1_ ( .D(a[1]), .CK(clk), .Q(a_reg[1]) );
  DFF_X1 b_reg_reg_7_ ( .D(b[7]), .CK(clk), .Q(b_reg[7]) );
  DFF_X1 product_reg_reg_8_ ( .D(N10), .CK(clk), .Q(product_reg[8]) );
  DFF_X1 product_reg_reg_9_ ( .D(N11), .CK(clk), .Q(product_reg[9]) );
  DFF_X1 product_reg_reg_10_ ( .D(N12), .CK(clk), .Q(product_reg[10]) );
  DFF_X1 product_reg_reg_14_ ( .D(N16), .CK(clk), .Q(product_reg[14]) );
  DFF_X1 product_reg_reg_7_ ( .D(N9), .CK(clk), .Q(product_reg[7]) );
  DFF_X2 product_reg_reg_11_ ( .D(N13), .CK(clk), .Q(product_reg[11]) );
  DFF_X2 product_reg_reg_13_ ( .D(N15), .CK(clk), .Q(product_reg[13]) );
  DFF_X1 product_reg_reg_12_ ( .D(N14), .CK(clk), .Q(product_reg[12]) );
  DFF_X2 product_reg_reg_15_ ( .D(N17), .CK(clk), .Q(product_reg[15]) );
  INV_X2 U21 ( .A(reset), .ZN(n5) );
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
  INV_X1 mult_16_U156 ( .A(mult_16_CARRYB_7__7_), .ZN(mult_16_A1_13_) );
  NOR2_X1 mult_16_U155 ( .A1(mult_16_n77), .A2(mult_16_n76), .ZN(N2) );
  NOR2_X1 mult_16_U154 ( .A1(b_reg[0]), .A2(mult_16_n78), .ZN(mult_16_ab_7__0_) );
  NOR2_X1 mult_16_U153 ( .A1(b_reg[1]), .A2(mult_16_n78), .ZN(mult_16_ab_7__1_) );
  NOR2_X1 mult_16_U152 ( .A1(b_reg[2]), .A2(mult_16_n78), .ZN(mult_16_ab_7__2_) );
  NOR2_X1 mult_16_U151 ( .A1(b_reg[3]), .A2(mult_16_n78), .ZN(mult_16_ab_7__3_) );
  NOR2_X1 mult_16_U150 ( .A1(b_reg[4]), .A2(mult_16_n78), .ZN(mult_16_ab_7__4_) );
  NOR2_X1 mult_16_U149 ( .A1(mult_16_n19), .A2(mult_16_n78), .ZN(
        mult_16_ab_7__5_) );
  NOR2_X1 mult_16_U148 ( .A1(a_reg[6]), .A2(mult_16_n28), .ZN(mult_16_ab_6__7_) );
  NOR2_X1 mult_16_U147 ( .A1(mult_16_n23), .A2(mult_16_n78), .ZN(
        mult_16_ab_7__6_) );
  NOR2_X1 mult_16_U146 ( .A1(mult_16_n27), .A2(mult_16_n78), .ZN(
        mult_16_ab_7__7_) );
  NOR2_X1 mult_16_U145 ( .A1(mult_16_n76), .A2(mult_16_n75), .ZN(
        mult_16_ab_6__0_) );
  NOR2_X1 mult_16_U144 ( .A1(mult_16_n75), .A2(mult_16_n74), .ZN(
        mult_16_ab_6__1_) );
  NOR2_X1 mult_16_U143 ( .A1(mult_16_n75), .A2(mult_16_n73), .ZN(
        mult_16_ab_6__2_) );
  NOR2_X1 mult_16_U142 ( .A1(mult_16_n75), .A2(mult_16_n72), .ZN(
        mult_16_ab_6__3_) );
  NOR2_X1 mult_16_U141 ( .A1(mult_16_n75), .A2(mult_16_n71), .ZN(
        mult_16_ab_6__4_) );
  NOR2_X1 mult_16_U140 ( .A1(mult_16_n75), .A2(mult_16_n70), .ZN(
        mult_16_ab_6__5_) );
  NOR2_X1 mult_16_U139 ( .A1(a_reg[5]), .A2(mult_16_n27), .ZN(mult_16_ab_5__7_) );
  NOR2_X1 mult_16_U138 ( .A1(mult_16_n75), .A2(mult_16_n69), .ZN(
        mult_16_ab_6__6_) );
  INV_X1 mult_16_U137 ( .A(a_reg[6]), .ZN(mult_16_n75) );
  NOR2_X1 mult_16_U136 ( .A1(mult_16_n76), .A2(mult_16_n68), .ZN(
        mult_16_ab_5__0_) );
  NOR2_X1 mult_16_U135 ( .A1(mult_16_n74), .A2(mult_16_n68), .ZN(
        mult_16_ab_5__1_) );
  NOR2_X1 mult_16_U134 ( .A1(mult_16_n73), .A2(mult_16_n68), .ZN(
        mult_16_ab_5__2_) );
  NOR2_X1 mult_16_U133 ( .A1(mult_16_n72), .A2(mult_16_n68), .ZN(
        mult_16_ab_5__3_) );
  NOR2_X1 mult_16_U132 ( .A1(mult_16_n71), .A2(mult_16_n68), .ZN(
        mult_16_ab_5__4_) );
  NOR2_X1 mult_16_U131 ( .A1(mult_16_n70), .A2(mult_16_n68), .ZN(
        mult_16_ab_5__5_) );
  NOR2_X1 mult_16_U130 ( .A1(a_reg[4]), .A2(mult_16_n28), .ZN(mult_16_ab_4__7_) );
  NOR2_X1 mult_16_U129 ( .A1(mult_16_n69), .A2(mult_16_n68), .ZN(
        mult_16_ab_5__6_) );
  INV_X1 mult_16_U128 ( .A(a_reg[5]), .ZN(mult_16_n68) );
  NOR2_X1 mult_16_U127 ( .A1(mult_16_n76), .A2(mult_16_n67), .ZN(
        mult_16_ab_4__0_) );
  NOR2_X1 mult_16_U126 ( .A1(mult_16_n74), .A2(mult_16_n67), .ZN(
        mult_16_ab_4__1_) );
  NOR2_X1 mult_16_U125 ( .A1(mult_16_n73), .A2(mult_16_n67), .ZN(
        mult_16_ab_4__2_) );
  NOR2_X1 mult_16_U124 ( .A1(mult_16_n72), .A2(mult_16_n67), .ZN(
        mult_16_ab_4__3_) );
  NOR2_X1 mult_16_U123 ( .A1(mult_16_n71), .A2(mult_16_n67), .ZN(
        mult_16_ab_4__4_) );
  NOR2_X1 mult_16_U122 ( .A1(mult_16_n70), .A2(mult_16_n67), .ZN(
        mult_16_ab_4__5_) );
  NOR2_X1 mult_16_U121 ( .A1(a_reg[3]), .A2(mult_16_n27), .ZN(mult_16_ab_3__7_) );
  NOR2_X1 mult_16_U120 ( .A1(mult_16_n69), .A2(mult_16_n67), .ZN(
        mult_16_ab_4__6_) );
  INV_X1 mult_16_U119 ( .A(a_reg[4]), .ZN(mult_16_n67) );
  NOR2_X1 mult_16_U118 ( .A1(mult_16_n76), .A2(mult_16_n66), .ZN(
        mult_16_ab_3__0_) );
  NOR2_X1 mult_16_U117 ( .A1(mult_16_n74), .A2(mult_16_n66), .ZN(
        mult_16_ab_3__1_) );
  NOR2_X1 mult_16_U116 ( .A1(mult_16_n73), .A2(mult_16_n66), .ZN(
        mult_16_ab_3__2_) );
  NOR2_X1 mult_16_U115 ( .A1(mult_16_n72), .A2(mult_16_n66), .ZN(
        mult_16_ab_3__3_) );
  NOR2_X1 mult_16_U114 ( .A1(mult_16_n71), .A2(mult_16_n66), .ZN(
        mult_16_ab_3__4_) );
  NOR2_X1 mult_16_U113 ( .A1(mult_16_n70), .A2(mult_16_n66), .ZN(
        mult_16_ab_3__5_) );
  NOR2_X1 mult_16_U112 ( .A1(a_reg[2]), .A2(mult_16_n28), .ZN(mult_16_ab_2__7_) );
  NOR2_X1 mult_16_U111 ( .A1(mult_16_n69), .A2(mult_16_n66), .ZN(
        mult_16_ab_3__6_) );
  INV_X1 mult_16_U110 ( .A(a_reg[3]), .ZN(mult_16_n66) );
  NOR2_X1 mult_16_U109 ( .A1(mult_16_n76), .A2(mult_16_n65), .ZN(
        mult_16_ab_2__0_) );
  NOR2_X1 mult_16_U108 ( .A1(mult_16_n74), .A2(mult_16_n65), .ZN(
        mult_16_ab_2__1_) );
  NOR2_X1 mult_16_U107 ( .A1(mult_16_n73), .A2(mult_16_n65), .ZN(
        mult_16_ab_2__2_) );
  NOR2_X1 mult_16_U106 ( .A1(mult_16_n72), .A2(mult_16_n65), .ZN(
        mult_16_ab_2__3_) );
  NOR2_X1 mult_16_U105 ( .A1(mult_16_n71), .A2(mult_16_n65), .ZN(
        mult_16_ab_2__4_) );
  NOR2_X1 mult_16_U104 ( .A1(mult_16_n65), .A2(mult_16_n70), .ZN(
        mult_16_ab_2__5_) );
  INV_X1 mult_16_U103 ( .A(a_reg[2]), .ZN(mult_16_n65) );
  NOR2_X1 mult_16_U102 ( .A1(mult_16_n76), .A2(mult_16_n64), .ZN(
        mult_16_ab_1__0_) );
  INV_X1 mult_16_U101 ( .A(b_reg[0]), .ZN(mult_16_n76) );
  NOR2_X1 mult_16_U100 ( .A1(mult_16_n77), .A2(mult_16_n74), .ZN(
        mult_16_ab_0__1_) );
  NOR2_X1 mult_16_U99 ( .A1(mult_16_n74), .A2(mult_16_n64), .ZN(
        mult_16_ab_1__1_) );
  INV_X1 mult_16_U98 ( .A(b_reg[1]), .ZN(mult_16_n74) );
  NOR2_X1 mult_16_U97 ( .A1(mult_16_n77), .A2(mult_16_n73), .ZN(
        mult_16_ab_0__2_) );
  INV_X1 mult_16_U96 ( .A(b_reg[2]), .ZN(mult_16_n73) );
  NOR2_X1 mult_16_U95 ( .A1(mult_16_n77), .A2(mult_16_n72), .ZN(
        mult_16_ab_0__3_) );
  NOR2_X1 mult_16_U94 ( .A1(mult_16_n72), .A2(mult_16_n64), .ZN(
        mult_16_ab_1__3_) );
  INV_X1 mult_16_U93 ( .A(b_reg[3]), .ZN(mult_16_n72) );
  NOR2_X1 mult_16_U92 ( .A1(mult_16_n77), .A2(mult_16_n71), .ZN(
        mult_16_ab_0__4_) );
  NOR2_X1 mult_16_U91 ( .A1(mult_16_n71), .A2(mult_16_n64), .ZN(
        mult_16_ab_1__4_) );
  INV_X1 mult_16_U90 ( .A(b_reg[4]), .ZN(mult_16_n71) );
  NOR2_X1 mult_16_U89 ( .A1(mult_16_n77), .A2(mult_16_n70), .ZN(
        mult_16_ab_0__5_) );
  INV_X1 mult_16_U88 ( .A(b_reg[5]), .ZN(mult_16_n70) );
  INV_X1 mult_16_U87 ( .A(a_reg[0]), .ZN(mult_16_n77) );
  INV_X1 mult_16_U86 ( .A(a_reg[1]), .ZN(mult_16_n64) );
  NOR2_X1 mult_16_U85 ( .A1(mult_16_n79), .A2(a_reg[0]), .ZN(mult_16_ab_0__7_)
         );
  INV_X1 mult_16_U84 ( .A(b_reg[7]), .ZN(mult_16_n79) );
  AND2_X1 mult_16_U83 ( .A1(mult_16_CARRYB_7__6_), .A2(mult_16_SUMB_7__7_), 
        .ZN(mult_16_n62) );
  XOR2_X1 mult_16_U82 ( .A(mult_16_CARRYB_7__6_), .B(mult_16_SUMB_7__7_), .Z(
        mult_16_n61) );
  AND2_X1 mult_16_U81 ( .A1(mult_16_CARRYB_7__5_), .A2(mult_16_SUMB_7__6_), 
        .ZN(mult_16_n60) );
  XOR2_X1 mult_16_U80 ( .A(mult_16_CARRYB_7__5_), .B(mult_16_SUMB_7__6_), .Z(
        mult_16_n59) );
  AND2_X1 mult_16_U79 ( .A1(mult_16_CARRYB_7__4_), .A2(mult_16_SUMB_7__5_), 
        .ZN(mult_16_n58) );
  AND2_X1 mult_16_U78 ( .A1(mult_16_SUMB_7__4_), .A2(mult_16_CARRYB_7__3_), 
        .ZN(mult_16_n57) );
  XOR2_X1 mult_16_U77 ( .A(mult_16_CARRYB_7__4_), .B(mult_16_SUMB_7__5_), .Z(
        mult_16_n56) );
  XOR2_X1 mult_16_U76 ( .A(mult_16_CARRYB_7__3_), .B(mult_16_SUMB_7__4_), .Z(
        mult_16_n55) );
  AND2_X1 mult_16_U75 ( .A1(mult_16_SUMB_7__3_), .A2(mult_16_CARRYB_7__2_), 
        .ZN(mult_16_n54) );
  AND2_X1 mult_16_U74 ( .A1(mult_16_CARRYB_7__1_), .A2(mult_16_SUMB_7__2_), 
        .ZN(mult_16_n52) );
  AND2_X1 mult_16_U73 ( .A1(mult_16_ab_0__5_), .A2(mult_16_ab_1__4_), .ZN(
        mult_16_n51) );
  XOR2_X1 mult_16_U72 ( .A(mult_16_CARRYB_7__1_), .B(mult_16_SUMB_7__2_), .Z(
        mult_16_n50) );
  XOR2_X1 mult_16_U71 ( .A(mult_16_ab_1__0_), .B(mult_16_ab_0__1_), .Z(N3) );
  INV_X2 mult_16_U70 ( .A(a_reg[7]), .ZN(mult_16_n78) );
  INV_X1 mult_16_U69 ( .A(mult_16_n23), .ZN(mult_16_n69) );
  AND2_X1 mult_16_U68 ( .A1(a_reg[1]), .A2(b_reg[6]), .ZN(mult_16_ab_1__6_) );
  INV_X1 mult_16_U67 ( .A(mult_16_SUMB_7__3_), .ZN(mult_16_n46) );
  INV_X1 mult_16_U66 ( .A(mult_16_CARRYB_7__2_), .ZN(mult_16_n45) );
  NAND2_X1 mult_16_U65 ( .A1(mult_16_n47), .A2(mult_16_n48), .ZN(mult_16_n53)
         );
  NAND2_X1 mult_16_U64 ( .A1(mult_16_SUMB_7__3_), .A2(mult_16_n45), .ZN(
        mult_16_n48) );
  NAND2_X1 mult_16_U63 ( .A1(mult_16_CARRYB_7__2_), .A2(mult_16_n46), .ZN(
        mult_16_n47) );
  AND2_X1 mult_16_U62 ( .A1(b_reg[6]), .A2(a_reg[0]), .ZN(mult_16_ab_0__6_) );
  AND2_X1 mult_16_U61 ( .A1(a_reg[1]), .A2(b_reg[5]), .ZN(mult_16_ab_1__5_) );
  INV_X1 mult_16_U60 ( .A(mult_16_n27), .ZN(mult_16_n44) );
  NAND3_X1 mult_16_U59 ( .A1(mult_16_n41), .A2(mult_16_n42), .A3(mult_16_n43), 
        .ZN(mult_16_CARRYB_2__6_) );
  NAND2_X1 mult_16_U58 ( .A1(mult_16_ab_2__6_), .A2(mult_16_n25), .ZN(
        mult_16_n43) );
  NAND2_X1 mult_16_U57 ( .A1(mult_16_CARRYB_1__6_), .A2(mult_16_n25), .ZN(
        mult_16_n42) );
  NAND2_X1 mult_16_U56 ( .A1(mult_16_CARRYB_1__6_), .A2(mult_16_ab_2__6_), 
        .ZN(mult_16_n41) );
  NAND3_X1 mult_16_U55 ( .A1(mult_16_n38), .A2(mult_16_n39), .A3(mult_16_n40), 
        .ZN(mult_16_CARRYB_7__0_) );
  NAND2_X1 mult_16_U54 ( .A1(mult_16_CARRYB_6__0_), .A2(mult_16_ab_7__0_), 
        .ZN(mult_16_n40) );
  NAND2_X1 mult_16_U53 ( .A1(mult_16_SUMB_6__1_), .A2(mult_16_ab_7__0_), .ZN(
        mult_16_n39) );
  NAND2_X1 mult_16_U52 ( .A1(mult_16_SUMB_6__1_), .A2(mult_16_CARRYB_6__0_), 
        .ZN(mult_16_n38) );
  CLKBUF_X1 mult_16_U51 ( .A(a_reg[1]), .Z(mult_16_n37) );
  NAND3_X1 mult_16_U50 ( .A1(mult_16_n34), .A2(mult_16_n35), .A3(mult_16_n36), 
        .ZN(mult_16_CARRYB_3__4_) );
  NAND2_X1 mult_16_U49 ( .A1(mult_16_CARRYB_2__4_), .A2(mult_16_SUMB_2__5_), 
        .ZN(mult_16_n36) );
  NAND2_X1 mult_16_U48 ( .A1(mult_16_ab_3__4_), .A2(mult_16_SUMB_2__5_), .ZN(
        mult_16_n35) );
  NAND2_X1 mult_16_U47 ( .A1(mult_16_ab_3__4_), .A2(mult_16_CARRYB_2__4_), 
        .ZN(mult_16_n34) );
  NAND3_X1 mult_16_U46 ( .A1(mult_16_n33), .A2(mult_16_n32), .A3(mult_16_n31), 
        .ZN(mult_16_CARRYB_2__5_) );
  NAND2_X1 mult_16_U45 ( .A1(mult_16_CARRYB_1__5_), .A2(mult_16_SUMB_1__6_), 
        .ZN(mult_16_n33) );
  NAND2_X1 mult_16_U44 ( .A1(mult_16_SUMB_1__6_), .A2(mult_16_ab_2__5_), .ZN(
        mult_16_n32) );
  NAND2_X1 mult_16_U43 ( .A1(mult_16_ab_2__5_), .A2(mult_16_CARRYB_1__5_), 
        .ZN(mult_16_n31) );
  XNOR2_X1 mult_16_U42 ( .A(mult_16_ab_3__4_), .B(mult_16_CARRYB_2__4_), .ZN(
        mult_16_n30) );
  XNOR2_X1 mult_16_U41 ( .A(mult_16_n30), .B(mult_16_n21), .ZN(
        mult_16_SUMB_3__4_) );
  XNOR2_X1 mult_16_U40 ( .A(mult_16_ab_2__5_), .B(mult_16_CARRYB_1__5_), .ZN(
        mult_16_n29) );
  XNOR2_X1 mult_16_U39 ( .A(mult_16_SUMB_1__6_), .B(mult_16_n29), .ZN(
        mult_16_SUMB_2__5_) );
  INV_X1 mult_16_U38 ( .A(b_reg[7]), .ZN(mult_16_n63) );
  BUF_X1 mult_16_U37 ( .A(mult_16_n63), .Z(mult_16_n28) );
  BUF_X1 mult_16_U36 ( .A(mult_16_n63), .Z(mult_16_n27) );
  BUF_X1 mult_16_U35 ( .A(mult_16_n63), .Z(mult_16_n26) );
  NOR2_X1 mult_16_U34 ( .A1(mult_16_n37), .A2(mult_16_n26), .ZN(
        mult_16_ab_1__7_) );
  NOR2_X1 mult_16_U33 ( .A1(mult_16_n37), .A2(mult_16_n26), .ZN(mult_16_n25)
         );
  XOR2_X1 mult_16_U32 ( .A(mult_16_ab_1__2_), .B(mult_16_ab_0__3_), .Z(
        mult_16_n24) );
  AND2_X1 mult_16_U31 ( .A1(b_reg[2]), .A2(mult_16_n37), .ZN(mult_16_ab_1__2_)
         );
  AND2_X1 mult_16_U30 ( .A1(mult_16_n2), .A2(a_reg[2]), .ZN(mult_16_ab_2__6_)
         );
  CLKBUF_X1 mult_16_U29 ( .A(mult_16_n2), .Z(mult_16_n23) );
  XNOR2_X1 mult_16_U28 ( .A(mult_16_ab_2__6_), .B(mult_16_ab_1__7_), .ZN(
        mult_16_n22) );
  XNOR2_X1 mult_16_U27 ( .A(mult_16_n20), .B(mult_16_n22), .ZN(
        mult_16_SUMB_2__6_) );
  CLKBUF_X1 mult_16_U26 ( .A(mult_16_SUMB_2__5_), .Z(mult_16_n21) );
  BUF_X1 mult_16_U25 ( .A(mult_16_CARRYB_1__6_), .Z(mult_16_n20) );
  CLKBUF_X1 mult_16_U24 ( .A(b_reg[5]), .Z(mult_16_n19) );
  AND2_X1 mult_16_U23 ( .A1(mult_16_ab_0__1_), .A2(mult_16_ab_1__0_), .ZN(
        mult_16_n18) );
  AND2_X1 mult_16_U22 ( .A1(mult_16_ab_0__3_), .A2(mult_16_ab_1__2_), .ZN(
        mult_16_n17) );
  AND2_X1 mult_16_U21 ( .A1(mult_16_ab_0__4_), .A2(mult_16_ab_1__3_), .ZN(
        mult_16_n16) );
  AND2_X1 mult_16_U20 ( .A1(mult_16_ab_0__2_), .A2(mult_16_ab_1__1_), .ZN(
        mult_16_n15) );
  XOR2_X1 mult_16_U19 ( .A(mult_16_ab_1__1_), .B(mult_16_ab_0__2_), .Z(
        mult_16_n14) );
  XOR2_X1 mult_16_U18 ( .A(mult_16_ab_1__3_), .B(mult_16_ab_0__4_), .Z(
        mult_16_n13) );
  XOR2_X1 mult_16_U17 ( .A(mult_16_ab_0__5_), .B(mult_16_ab_1__4_), .Z(
        mult_16_n12) );
  NAND3_X1 mult_16_U16 ( .A1(mult_16_n9), .A2(mult_16_n10), .A3(mult_16_n11), 
        .ZN(mult_16_CARRYB_3__3_) );
  NAND2_X1 mult_16_U15 ( .A1(mult_16_CARRYB_2__3_), .A2(mult_16_SUMB_2__4_), 
        .ZN(mult_16_n11) );
  NAND2_X1 mult_16_U14 ( .A1(mult_16_ab_3__3_), .A2(mult_16_SUMB_2__4_), .ZN(
        mult_16_n10) );
  NAND2_X1 mult_16_U13 ( .A1(mult_16_ab_3__3_), .A2(mult_16_CARRYB_2__3_), 
        .ZN(mult_16_n9) );
  NAND3_X1 mult_16_U12 ( .A1(mult_16_n6), .A2(mult_16_n7), .A3(mult_16_n8), 
        .ZN(mult_16_CARRYB_2__4_) );
  NAND2_X1 mult_16_U11 ( .A1(mult_16_n51), .A2(mult_16_SUMB_1__5_), .ZN(
        mult_16_n8) );
  NAND2_X1 mult_16_U10 ( .A1(mult_16_ab_2__4_), .A2(mult_16_SUMB_1__5_), .ZN(
        mult_16_n7) );
  NAND2_X1 mult_16_U9 ( .A1(mult_16_ab_2__4_), .A2(mult_16_n51), .ZN(
        mult_16_n6) );
  XOR2_X1 mult_16_U8 ( .A(mult_16_n5), .B(mult_16_SUMB_1__5_), .Z(
        mult_16_SUMB_2__4_) );
  XOR2_X1 mult_16_U7 ( .A(mult_16_ab_2__4_), .B(mult_16_n51), .Z(mult_16_n5)
         );
  XNOR2_X1 mult_16_U6 ( .A(mult_16_ab_3__3_), .B(mult_16_CARRYB_2__3_), .ZN(
        mult_16_n4) );
  XNOR2_X1 mult_16_U5 ( .A(mult_16_n4), .B(mult_16_SUMB_2__4_), .ZN(
        mult_16_SUMB_3__3_) );
  XNOR2_X1 mult_16_U4 ( .A(mult_16_CARRYB_6__0_), .B(mult_16_ab_7__0_), .ZN(
        mult_16_n3) );
  XNOR2_X1 mult_16_U3 ( .A(mult_16_n3), .B(mult_16_SUMB_6__1_), .ZN(
        mult_16_SUMB_7__0_) );
  CLKBUF_X1 mult_16_U2 ( .A(b_reg[6]), .Z(mult_16_n2) );
  FA_X1 mult_16_S14_8 ( .A(1'b0), .B(mult_16_CARRYB_7__0_), .CI(
        mult_16_SUMB_7__1_), .CO(mult_16_A2_7_), .S(mult_16_A1_6_) );
  FA_X1 mult_16_S0_6 ( .A(1'b0), .B(mult_16_ab_1__6_), .CI(mult_16_ab_0__7_), 
        .CO(mult_16_CARRYB_1__6_), .S(mult_16_SUMB_1__6_) );
  FA_X1 mult_16_S0_5 ( .A(mult_16_ab_0__6_), .B(1'b0), .CI(mult_16_ab_1__5_), 
        .CO(mult_16_CARRYB_1__5_), .S(mult_16_SUMB_1__5_) );
  FA_X1 mult_16_S2_2_3 ( .A(mult_16_ab_2__3_), .B(mult_16_n16), .CI(
        mult_16_n12), .CO(mult_16_CARRYB_2__3_), .S(mult_16_SUMB_2__3_) );
  FA_X1 mult_16_S2_2_2 ( .A(mult_16_ab_2__2_), .B(mult_16_n17), .CI(
        mult_16_n13), .CO(mult_16_CARRYB_2__2_), .S(mult_16_SUMB_2__2_) );
  FA_X1 mult_16_S2_2_1 ( .A(mult_16_ab_2__1_), .B(mult_16_n15), .CI(
        mult_16_n24), .CO(mult_16_CARRYB_2__1_), .S(mult_16_SUMB_2__1_) );
  FA_X1 mult_16_S1_2_0 ( .A(mult_16_ab_2__0_), .B(mult_16_n18), .CI(
        mult_16_n14), .CO(mult_16_CARRYB_2__0_), .S(mult_16_A1_0_) );
  FA_X1 mult_16_S3_3_6 ( .A(mult_16_ab_3__6_), .B(mult_16_ab_2__7_), .CI(
        mult_16_CARRYB_2__6_), .CO(mult_16_CARRYB_3__6_), .S(
        mult_16_SUMB_3__6_) );
  FA_X1 mult_16_S2_3_5 ( .A(mult_16_SUMB_2__6_), .B(mult_16_ab_3__5_), .CI(
        mult_16_CARRYB_2__5_), .CO(mult_16_CARRYB_3__5_), .S(
        mult_16_SUMB_3__5_) );
  FA_X1 mult_16_S2_3_2 ( .A(mult_16_ab_3__2_), .B(mult_16_CARRYB_2__2_), .CI(
        mult_16_SUMB_2__3_), .CO(mult_16_CARRYB_3__2_), .S(mult_16_SUMB_3__2_)
         );
  FA_X1 mult_16_S2_3_1 ( .A(mult_16_ab_3__1_), .B(mult_16_CARRYB_2__1_), .CI(
        mult_16_SUMB_2__2_), .CO(mult_16_CARRYB_3__1_), .S(mult_16_SUMB_3__1_)
         );
  FA_X1 mult_16_S1_3_0 ( .A(mult_16_ab_3__0_), .B(mult_16_CARRYB_2__0_), .CI(
        mult_16_SUMB_2__1_), .CO(mult_16_CARRYB_3__0_), .S(mult_16_A1_1_) );
  FA_X1 mult_16_S3_4_6 ( .A(mult_16_ab_4__6_), .B(mult_16_CARRYB_3__6_), .CI(
        mult_16_ab_3__7_), .CO(mult_16_CARRYB_4__6_), .S(mult_16_SUMB_4__6_)
         );
  FA_X1 mult_16_S2_4_5 ( .A(mult_16_ab_4__5_), .B(mult_16_CARRYB_3__5_), .CI(
        mult_16_SUMB_3__6_), .CO(mult_16_CARRYB_4__5_), .S(mult_16_SUMB_4__5_)
         );
  FA_X1 mult_16_S2_4_4 ( .A(mult_16_ab_4__4_), .B(mult_16_CARRYB_3__4_), .CI(
        mult_16_SUMB_3__5_), .CO(mult_16_CARRYB_4__4_), .S(mult_16_SUMB_4__4_)
         );
  FA_X1 mult_16_S2_4_3 ( .A(mult_16_CARRYB_3__3_), .B(mult_16_ab_4__3_), .CI(
        mult_16_SUMB_3__4_), .CO(mult_16_CARRYB_4__3_), .S(mult_16_SUMB_4__3_)
         );
  FA_X1 mult_16_S2_4_2 ( .A(mult_16_ab_4__2_), .B(mult_16_CARRYB_3__2_), .CI(
        mult_16_SUMB_3__3_), .CO(mult_16_CARRYB_4__2_), .S(mult_16_SUMB_4__2_)
         );
  FA_X1 mult_16_S2_4_1 ( .A(mult_16_ab_4__1_), .B(mult_16_CARRYB_3__1_), .CI(
        mult_16_SUMB_3__2_), .CO(mult_16_CARRYB_4__1_), .S(mult_16_SUMB_4__1_)
         );
  FA_X1 mult_16_S1_4_0 ( .A(mult_16_ab_4__0_), .B(mult_16_CARRYB_3__0_), .CI(
        mult_16_SUMB_3__1_), .CO(mult_16_CARRYB_4__0_), .S(mult_16_A1_2_) );
  FA_X1 mult_16_S3_5_6 ( .A(mult_16_ab_5__6_), .B(mult_16_CARRYB_4__6_), .CI(
        mult_16_ab_4__7_), .CO(mult_16_CARRYB_5__6_), .S(mult_16_SUMB_5__6_)
         );
  FA_X1 mult_16_S2_5_5 ( .A(mult_16_ab_5__5_), .B(mult_16_CARRYB_4__5_), .CI(
        mult_16_SUMB_4__6_), .CO(mult_16_CARRYB_5__5_), .S(mult_16_SUMB_5__5_)
         );
  FA_X1 mult_16_S2_5_4 ( .A(mult_16_CARRYB_4__4_), .B(mult_16_ab_5__4_), .CI(
        mult_16_SUMB_4__5_), .CO(mult_16_CARRYB_5__4_), .S(mult_16_SUMB_5__4_)
         );
  FA_X1 mult_16_S2_5_3 ( .A(mult_16_ab_5__3_), .B(mult_16_CARRYB_4__3_), .CI(
        mult_16_SUMB_4__4_), .CO(mult_16_CARRYB_5__3_), .S(mult_16_SUMB_5__3_)
         );
  FA_X1 mult_16_S2_5_2 ( .A(mult_16_CARRYB_4__2_), .B(mult_16_ab_5__2_), .CI(
        mult_16_SUMB_4__3_), .CO(mult_16_CARRYB_5__2_), .S(mult_16_SUMB_5__2_)
         );
  FA_X1 mult_16_S2_5_1 ( .A(mult_16_ab_5__1_), .B(mult_16_CARRYB_4__1_), .CI(
        mult_16_SUMB_4__2_), .CO(mult_16_CARRYB_5__1_), .S(mult_16_SUMB_5__1_)
         );
  FA_X1 mult_16_S1_5_0 ( .A(mult_16_ab_5__0_), .B(mult_16_CARRYB_4__0_), .CI(
        mult_16_SUMB_4__1_), .CO(mult_16_CARRYB_5__0_), .S(mult_16_A1_3_) );
  FA_X1 mult_16_S3_6_6 ( .A(mult_16_ab_6__6_), .B(mult_16_CARRYB_5__6_), .CI(
        mult_16_ab_5__7_), .CO(mult_16_CARRYB_6__6_), .S(mult_16_SUMB_6__6_)
         );
  FA_X1 mult_16_S2_6_5 ( .A(mult_16_ab_6__5_), .B(mult_16_CARRYB_5__5_), .CI(
        mult_16_SUMB_5__6_), .CO(mult_16_CARRYB_6__5_), .S(mult_16_SUMB_6__5_)
         );
  FA_X1 mult_16_S2_6_4 ( .A(mult_16_ab_6__4_), .B(mult_16_CARRYB_5__4_), .CI(
        mult_16_SUMB_5__5_), .CO(mult_16_CARRYB_6__4_), .S(mult_16_SUMB_6__4_)
         );
  FA_X1 mult_16_S2_6_3 ( .A(mult_16_ab_6__3_), .B(mult_16_CARRYB_5__3_), .CI(
        mult_16_SUMB_5__4_), .CO(mult_16_CARRYB_6__3_), .S(mult_16_SUMB_6__3_)
         );
  FA_X1 mult_16_S2_6_2 ( .A(mult_16_CARRYB_5__2_), .B(mult_16_ab_6__2_), .CI(
        mult_16_SUMB_5__3_), .CO(mult_16_CARRYB_6__2_), .S(mult_16_SUMB_6__2_)
         );
  FA_X1 mult_16_S2_6_1 ( .A(mult_16_CARRYB_5__1_), .B(mult_16_ab_6__1_), .CI(
        mult_16_SUMB_5__2_), .CO(mult_16_CARRYB_6__1_), .S(mult_16_SUMB_6__1_)
         );
  FA_X1 mult_16_S1_6_0 ( .A(mult_16_ab_6__0_), .B(mult_16_CARRYB_5__0_), .CI(
        mult_16_SUMB_5__1_), .CO(mult_16_CARRYB_6__0_), .S(mult_16_A1_4_) );
  FA_X1 mult_16_S14_7 ( .A(mult_16_n78), .B(mult_16_n28), .CI(mult_16_ab_7__7_), .CO(mult_16_CARRYB_7__7_), .S(mult_16_SUMB_7__7_) );
  FA_X1 mult_16_S5_6 ( .A(mult_16_ab_7__6_), .B(mult_16_CARRYB_6__6_), .CI(
        mult_16_ab_6__7_), .CO(mult_16_CARRYB_7__6_), .S(mult_16_SUMB_7__6_)
         );
  FA_X1 mult_16_S4_5 ( .A(mult_16_ab_7__5_), .B(mult_16_CARRYB_6__5_), .CI(
        mult_16_SUMB_6__6_), .CO(mult_16_CARRYB_7__5_), .S(mult_16_SUMB_7__5_)
         );
  FA_X1 mult_16_S4_4 ( .A(mult_16_ab_7__4_), .B(mult_16_CARRYB_6__4_), .CI(
        mult_16_SUMB_6__5_), .CO(mult_16_CARRYB_7__4_), .S(mult_16_SUMB_7__4_)
         );
  FA_X1 mult_16_S4_3 ( .A(mult_16_ab_7__3_), .B(mult_16_CARRYB_6__3_), .CI(
        mult_16_SUMB_6__4_), .CO(mult_16_CARRYB_7__3_), .S(mult_16_SUMB_7__3_)
         );
  FA_X1 mult_16_S4_2 ( .A(mult_16_ab_7__2_), .B(mult_16_CARRYB_6__2_), .CI(
        mult_16_SUMB_6__3_), .CO(mult_16_CARRYB_7__2_), .S(mult_16_SUMB_7__2_)
         );
  FA_X1 mult_16_S4_1 ( .A(mult_16_ab_7__1_), .B(mult_16_CARRYB_6__1_), .CI(
        mult_16_SUMB_6__2_), .CO(mult_16_CARRYB_7__1_), .S(mult_16_SUMB_7__1_)
         );
  FA_X1 mult_16_S14_7_0 ( .A(a_reg[7]), .B(mult_16_n44), .CI(
        mult_16_SUMB_7__0_), .CO(mult_16_A2_6_), .S(mult_16_A1_5_) );
  INV_X1 mult_16_FS_1_U79 ( .A(mult_16_FS_1_n29), .ZN(mult_16_FS_1_n71) );
  NAND3_X1 mult_16_FS_1_U78 ( .A1(mult_16_FS_1_n31), .A2(mult_16_A2_6_), .A3(
        mult_16_A1_6_), .ZN(mult_16_FS_1_n70) );
  NAND3_X1 mult_16_FS_1_U77 ( .A1(mult_16_FS_1_n23), .A2(mult_16_FS_1_n26), 
        .A3(mult_16_FS_1_n14), .ZN(mult_16_FS_1_n69) );
  NAND3_X1 mult_16_FS_1_U76 ( .A1(mult_16_FS_1_n57), .A2(mult_16_FS_1_n26), 
        .A3(mult_16_FS_1_n14), .ZN(mult_16_FS_1_n60) );
  INV_X1 mult_16_FS_1_U75 ( .A(mult_16_FS_1_n57), .ZN(mult_16_FS_1_n64) );
  XNOR2_X1 mult_16_FS_1_U74 ( .A(mult_16_FS_1_n58), .B(mult_16_FS_1_n59), .ZN(
        N15) );
  NAND3_X1 mult_16_FS_1_U73 ( .A1(mult_16_FS_1_n9), .A2(mult_16_FS_1_n1), .A3(
        mult_16_FS_1_n57), .ZN(mult_16_FS_1_n55) );
  NAND3_X1 mult_16_FS_1_U72 ( .A1(mult_16_FS_1_n56), .A2(mult_16_FS_1_n55), 
        .A3(mult_16_FS_1_n54), .ZN(mult_16_FS_1_n53) );
  OAI211_X1 mult_16_FS_1_U71 ( .C1(mult_16_FS_1_n12), .C2(mult_16_FS_1_n49), 
        .A(mult_16_FS_1_n40), .B(mult_16_FS_1_n47), .ZN(mult_16_FS_1_n50) );
  XNOR2_X1 mult_16_FS_1_U70 ( .A(mult_16_FS_1_n50), .B(mult_16_FS_1_n51), .ZN(
        N16) );
  INV_X1 mult_16_FS_1_U69 ( .A(mult_16_FS_1_n44), .ZN(mult_16_FS_1_n39) );
  INV_X1 mult_16_FS_1_U68 ( .A(mult_16_FS_1_n49), .ZN(mult_16_FS_1_n48) );
  NAND2_X1 mult_16_FS_1_U67 ( .A1(mult_16_FS_1_n48), .A2(mult_16_FS_1_n44), 
        .ZN(mult_16_FS_1_n41) );
  INV_X1 mult_16_FS_1_U66 ( .A(mult_16_FS_1_n47), .ZN(mult_16_FS_1_n43) );
  INV_X1 mult_16_FS_1_U65 ( .A(mult_16_FS_1_n46), .ZN(mult_16_FS_1_n45) );
  XNOR2_X1 mult_16_FS_1_U64 ( .A(mult_16_FS_1_n37), .B(mult_16_FS_1_n38), .ZN(
        N17) );
  INV_X1 mult_16_FS_1_U63 ( .A(mult_16_FS_1_n14), .ZN(mult_16_FS_1_n28) );
  XNOR2_X1 mult_16_FS_1_U62 ( .A(mult_16_FS_1_n24), .B(mult_16_FS_1_n25), .ZN(
        N13) );
  NAND4_X1 mult_16_FS_1_U61 ( .A1(mult_16_FS_1_n26), .A2(mult_16_FS_1_n10), 
        .A3(mult_16_FS_1_n57), .A4(mult_16_n52), .ZN(mult_16_FS_1_n56) );
  NAND4_X1 mult_16_FS_1_U60 ( .A1(mult_16_FS_1_n57), .A2(mult_16_FS_1_n52), 
        .A3(mult_16_FS_1_n26), .A4(mult_16_FS_1_n30), .ZN(mult_16_FS_1_n49) );
  NAND2_X1 mult_16_FS_1_U59 ( .A1(mult_16_FS_1_n71), .A2(mult_16_FS_1_n26), 
        .ZN(mult_16_FS_1_n65) );
  NAND2_X1 mult_16_FS_1_U58 ( .A1(mult_16_FS_1_n26), .A2(mult_16_FS_1_n27), 
        .ZN(mult_16_FS_1_n25) );
  OAI21_X1 mult_16_FS_1_U57 ( .B1(mult_16_FS_1_n12), .B2(mult_16_FS_1_n28), 
        .A(mult_16_FS_1_n29), .ZN(mult_16_FS_1_n24) );
  OAI221_X1 mult_16_FS_1_U56 ( .B1(mult_16_FS_1_n40), .B2(mult_16_FS_1_n39), 
        .C1(mult_16_FS_1_n16), .C2(mult_16_FS_1_n41), .A(mult_16_FS_1_n42), 
        .ZN(mult_16_FS_1_n37) );
  OAI21_X1 mult_16_FS_1_U55 ( .B1(mult_16_FS_1_n60), .B2(mult_16_FS_1_n3), .A(
        mult_16_FS_1_n61), .ZN(mult_16_FS_1_n58) );
  NAND2_X1 mult_16_FS_1_U54 ( .A1(mult_16_FS_1_n1), .A2(mult_16_FS_1_n9), .ZN(
        mult_16_FS_1_n27) );
  NAND2_X1 mult_16_FS_1_U53 ( .A1(mult_16_FS_1_n52), .A2(mult_16_FS_1_n53), 
        .ZN(mult_16_FS_1_n40) );
  NAND2_X1 mult_16_FS_1_U52 ( .A1(mult_16_FS_1_n69), .A2(mult_16_FS_1_n68), 
        .ZN(mult_16_FS_1_n66) );
  NAND2_X1 mult_16_FS_1_U51 ( .A1(mult_16_n52), .A2(mult_16_n53), .ZN(
        mult_16_FS_1_n29) );
  BUF_X1 mult_16_FS_1_U50 ( .A(mult_16_A1_5_), .Z(N9) );
  BUF_X1 mult_16_FS_1_U49 ( .A(mult_16_A1_4_), .Z(N8) );
  BUF_X1 mult_16_FS_1_U48 ( .A(mult_16_A1_3_), .Z(N7) );
  BUF_X1 mult_16_FS_1_U47 ( .A(mult_16_A1_2_), .Z(N6) );
  BUF_X1 mult_16_FS_1_U46 ( .A(mult_16_A1_1_), .Z(N5) );
  BUF_X1 mult_16_FS_1_U45 ( .A(mult_16_A1_0_), .Z(N4) );
  NAND2_X1 mult_16_FS_1_U44 ( .A1(mult_16_A2_6_), .A2(mult_16_FS_1_n2), .ZN(
        mult_16_FS_1_n33) );
  INV_X1 mult_16_FS_1_U43 ( .A(mult_16_A2_6_), .ZN(mult_16_FS_1_n35) );
  NAND2_X1 mult_16_FS_1_U42 ( .A1(mult_16_FS_1_n36), .A2(mult_16_FS_1_n35), 
        .ZN(mult_16_FS_1_n34) );
  INV_X1 mult_16_FS_1_U41 ( .A(mult_16_FS_1_n4), .ZN(mult_16_FS_1_n36) );
  NAND2_X1 mult_16_FS_1_U40 ( .A1(mult_16_FS_1_n5), .A2(mult_16_n50), .ZN(
        mult_16_FS_1_n32) );
  NAND2_X1 mult_16_FS_1_U39 ( .A1(mult_16_n60), .A2(mult_16_n61), .ZN(
        mult_16_FS_1_n46) );
  NAND2_X1 mult_16_FS_1_U38 ( .A1(mult_16_n58), .A2(mult_16_n59), .ZN(
        mult_16_FS_1_n47) );
  NAND2_X1 mult_16_FS_1_U37 ( .A1(mult_16_n57), .A2(mult_16_n56), .ZN(
        mult_16_FS_1_n54) );
  OR2_X1 mult_16_FS_1_U36 ( .A1(mult_16_n58), .A2(mult_16_n59), .ZN(
        mult_16_FS_1_n52) );
  OR2_X1 mult_16_FS_1_U35 ( .A1(mult_16_n52), .A2(mult_16_n53), .ZN(
        mult_16_FS_1_n30) );
  NAND2_X1 mult_16_FS_1_U34 ( .A1(mult_16_FS_1_n13), .A2(mult_16_FS_1_n32), 
        .ZN(mult_16_FS_1_n23) );
  XNOR2_X1 mult_16_FS_1_U33 ( .A(mult_16_n62), .B(mult_16_A1_13_), .ZN(
        mult_16_FS_1_n38) );
  AOI21_X1 mult_16_FS_1_U32 ( .B1(mult_16_FS_1_n43), .B2(mult_16_FS_1_n44), 
        .A(mult_16_FS_1_n45), .ZN(mult_16_FS_1_n42) );
  OAI21_X1 mult_16_FS_1_U31 ( .B1(mult_16_FS_1_n64), .B2(mult_16_FS_1_n27), 
        .A(mult_16_FS_1_n54), .ZN(mult_16_FS_1_n63) );
  NOR2_X1 mult_16_FS_1_U30 ( .A1(mult_16_FS_1_n64), .A2(mult_16_FS_1_n65), 
        .ZN(mult_16_FS_1_n62) );
  NOR2_X1 mult_16_FS_1_U29 ( .A1(mult_16_FS_1_n62), .A2(mult_16_FS_1_n63), 
        .ZN(mult_16_FS_1_n61) );
  NAND2_X1 mult_16_FS_1_U28 ( .A1(mult_16_FS_1_n47), .A2(mult_16_FS_1_n52), 
        .ZN(mult_16_FS_1_n59) );
  AND2_X1 mult_16_FS_1_U27 ( .A1(mult_16_FS_1_n27), .A2(mult_16_FS_1_n65), 
        .ZN(mult_16_FS_1_n68) );
  NAND2_X1 mult_16_FS_1_U26 ( .A1(mult_16_FS_1_n54), .A2(mult_16_FS_1_n57), 
        .ZN(mult_16_FS_1_n67) );
  XNOR2_X1 mult_16_FS_1_U25 ( .A(mult_16_FS_1_n66), .B(mult_16_FS_1_n67), .ZN(
        N14) );
  NAND2_X1 mult_16_FS_1_U24 ( .A1(mult_16_FS_1_n46), .A2(mult_16_FS_1_n44), 
        .ZN(mult_16_FS_1_n51) );
  AND2_X1 mult_16_FS_1_U23 ( .A1(mult_16_FS_1_n34), .A2(mult_16_FS_1_n33), 
        .ZN(N10) );
  OR2_X2 mult_16_FS_1_U22 ( .A1(mult_16_n60), .A2(mult_16_n61), .ZN(
        mult_16_FS_1_n44) );
  OR2_X2 mult_16_FS_1_U21 ( .A1(mult_16_n57), .A2(mult_16_n56), .ZN(
        mult_16_FS_1_n57) );
  OR2_X2 mult_16_FS_1_U20 ( .A1(mult_16_n55), .A2(mult_16_n54), .ZN(
        mult_16_FS_1_n26) );
  OR2_X1 mult_16_FS_1_U19 ( .A1(mult_16_n52), .A2(mult_16_FS_1_n10), .ZN(
        mult_16_FS_1_n14) );
  NAND3_X1 mult_16_FS_1_U18 ( .A1(mult_16_A1_6_), .A2(mult_16_FS_1_n31), .A3(
        mult_16_A2_6_), .ZN(mult_16_FS_1_n13) );
  AND2_X1 mult_16_FS_1_U17 ( .A1(mult_16_FS_1_n70), .A2(mult_16_FS_1_n32), 
        .ZN(mult_16_FS_1_n16) );
  AND2_X1 mult_16_FS_1_U16 ( .A1(mult_16_FS_1_n6), .A2(mult_16_FS_1_n32), .ZN(
        mult_16_FS_1_n12) );
  CLKBUF_X1 mult_16_FS_1_U15 ( .A(mult_16_n55), .Z(mult_16_FS_1_n9) );
  BUF_X1 mult_16_FS_1_U14 ( .A(mult_16_FS_1_n23), .Z(mult_16_FS_1_n11) );
  AND2_X1 mult_16_FS_1_U13 ( .A1(mult_16_FS_1_n31), .A2(mult_16_FS_1_n32), 
        .ZN(mult_16_FS_1_n8) );
  XNOR2_X1 mult_16_FS_1_U12 ( .A(mult_16_FS_1_n8), .B(mult_16_FS_1_n33), .ZN(
        N11) );
  BUF_X1 mult_16_FS_1_U11 ( .A(mult_16_n53), .Z(mult_16_FS_1_n10) );
  NAND2_X1 mult_16_FS_1_U10 ( .A1(mult_16_FS_1_n14), .A2(mult_16_FS_1_n29), 
        .ZN(mult_16_FS_1_n7) );
  XNOR2_X1 mult_16_FS_1_U9 ( .A(mult_16_FS_1_n11), .B(mult_16_FS_1_n7), .ZN(
        N12) );
  NAND3_X1 mult_16_FS_1_U8 ( .A1(mult_16_FS_1_n31), .A2(mult_16_A2_6_), .A3(
        mult_16_A1_6_), .ZN(mult_16_FS_1_n6) );
  CLKBUF_X1 mult_16_FS_1_U7 ( .A(mult_16_A2_7_), .Z(mult_16_FS_1_n5) );
  CLKBUF_X1 mult_16_FS_1_U6 ( .A(mult_16_A1_6_), .Z(mult_16_FS_1_n4) );
  AND2_X1 mult_16_FS_1_U5 ( .A1(mult_16_FS_1_n70), .A2(mult_16_FS_1_n32), .ZN(
        mult_16_FS_1_n3) );
  CLKBUF_X1 mult_16_FS_1_U4 ( .A(mult_16_A1_6_), .Z(mult_16_FS_1_n2) );
  OR2_X2 mult_16_FS_1_U3 ( .A1(mult_16_A2_7_), .A2(mult_16_n50), .ZN(
        mult_16_FS_1_n31) );
  CLKBUF_X1 mult_16_FS_1_U2 ( .A(mult_16_n54), .Z(mult_16_FS_1_n1) );
  INV_X1 add_21_U205 ( .A(add_21_n184), .ZN(add_21_n176) );
  INV_X1 add_21_U204 ( .A(add_21_n116), .ZN(add_21_n185) );
  NAND2_X1 add_21_U203 ( .A1(acc[4]), .A2(product_reg[4]), .ZN(add_21_n187) );
  INV_X1 add_21_U202 ( .A(add_21_n50), .ZN(add_21_n182) );
  NAND2_X1 add_21_U201 ( .A1(product_reg[1]), .A2(acc[1]), .ZN(add_21_n181) );
  NAND3_X1 add_21_U200 ( .A1(add_21_n56), .A2(add_21_n53), .A3(add_21_n180), 
        .ZN(add_21_n178) );
  INV_X1 add_21_U199 ( .A(add_21_n53), .ZN(add_21_n49) );
  INV_X1 add_21_U198 ( .A(add_21_n8), .ZN(add_21_n174) );
  NAND2_X1 add_21_U197 ( .A1(add_21_n170), .A2(add_21_n171), .ZN(add_21_n168)
         );
  XNOR2_X1 add_21_U196 ( .A(add_21_n168), .B(add_21_n169), .ZN(N29) );
  INV_X1 add_21_U195 ( .A(add_21_n167), .ZN(add_21_n156) );
  NAND2_X1 add_21_U194 ( .A1(product_reg[1]), .A2(acc[1]), .ZN(add_21_n166) );
  INV_X1 add_21_U193 ( .A(add_21_n105), .ZN(add_21_n71) );
  INV_X1 add_21_U192 ( .A(add_21_n129), .ZN(add_21_n136) );
  INV_X1 add_21_U191 ( .A(add_21_n7), .ZN(add_21_n154) );
  INV_X1 add_21_U190 ( .A(add_21_n11), .ZN(add_21_n155) );
  INV_X1 add_21_U189 ( .A(add_21_n10), .ZN(add_21_n153) );
  NAND3_X1 add_21_U188 ( .A1(add_21_n129), .A2(add_21_n7), .A3(add_21_n153), 
        .ZN(add_21_n150) );
  NAND2_X1 add_21_U187 ( .A1(add_21_n150), .A2(add_21_n151), .ZN(add_21_n149)
         );
  INV_X1 add_21_U186 ( .A(add_21_n123), .ZN(add_21_n128) );
  INV_X1 add_21_U185 ( .A(add_21_n127), .ZN(add_21_n147) );
  NAND3_X1 add_21_U184 ( .A1(acc[8]), .A2(product_reg[8]), .A3(add_21_n7), 
        .ZN(add_21_n124) );
  INV_X1 add_21_U183 ( .A(add_21_n124), .ZN(add_21_n137) );
  INV_X1 add_21_U182 ( .A(add_21_n70), .ZN(add_21_n104) );
  INV_X1 add_21_U181 ( .A(add_21_n117), .ZN(add_21_n115) );
  OAI21_X1 add_21_U180 ( .B1(add_21_n115), .B2(add_21_n116), .A(add_21_n16), 
        .ZN(add_21_n114) );
  INV_X1 add_21_U179 ( .A(add_21_n33), .ZN(add_21_n74) );
  NAND2_X1 add_21_U178 ( .A1(product_reg[1]), .A2(acc[1]), .ZN(add_21_n113) );
  NAND2_X1 add_21_U177 ( .A1(add_21_n74), .A2(add_21_n112), .ZN(add_21_n111)
         );
  NAND2_X1 add_21_U176 ( .A1(add_21_n110), .A2(add_21_n102), .ZN(add_21_n109)
         );
  NAND2_X1 add_21_U175 ( .A1(add_21_n108), .A2(add_21_n109), .ZN(add_21_n106)
         );
  XNOR2_X1 add_21_U174 ( .A(add_21_n106), .B(add_21_n107), .ZN(N32) );
  INV_X1 add_21_U173 ( .A(add_21_n89), .ZN(add_21_n95) );
  NAND2_X1 add_21_U172 ( .A1(add_21_n103), .A2(add_21_n104), .ZN(add_21_n97)
         );
  INV_X1 add_21_U171 ( .A(add_21_n102), .ZN(add_21_n98) );
  INV_X1 add_21_U170 ( .A(add_21_n101), .ZN(add_21_n82) );
  INV_X1 add_21_U169 ( .A(add_21_n67), .ZN(add_21_n100) );
  INV_X1 add_21_U168 ( .A(add_21_n68), .ZN(add_21_n92) );
  INV_X1 add_21_U167 ( .A(add_21_n88), .ZN(add_21_n66) );
  NAND2_X1 add_21_U166 ( .A1(add_21_n84), .A2(add_21_n85), .ZN(add_21_n80) );
  INV_X1 add_21_U165 ( .A(add_21_n83), .ZN(add_21_n72) );
  NAND2_X1 add_21_U164 ( .A1(add_21_n80), .A2(add_21_n81), .ZN(add_21_n79) );
  NAND2_X1 add_21_U163 ( .A1(product_reg[1]), .A2(acc[1]), .ZN(add_21_n76) );
  NAND2_X1 add_21_U162 ( .A1(add_21_n74), .A2(add_21_n75), .ZN(add_21_n73) );
  NAND2_X1 add_21_U161 ( .A1(add_21_n62), .A2(add_21_n63), .ZN(add_21_n60) );
  XNOR2_X1 add_21_U160 ( .A(add_21_n60), .B(add_21_n61), .ZN(N34) );
  INV_X1 add_21_U159 ( .A(add_21_n51), .ZN(add_21_n48) );
  OAI21_X1 add_21_U158 ( .B1(add_21_n48), .B2(add_21_n49), .A(add_21_n50), 
        .ZN(add_21_n45) );
  XNOR2_X1 add_21_U157 ( .A(add_21_n45), .B(add_21_n46), .ZN(N22) );
  XNOR2_X1 add_21_U156 ( .A(add_21_n43), .B(add_21_n44), .ZN(N23) );
  INV_X1 add_21_U155 ( .A(add_21_n43), .ZN(add_21_n41) );
  INV_X1 add_21_U154 ( .A(add_21_n42), .ZN(add_21_n30) );
  NAND2_X1 add_21_U153 ( .A1(product_reg[1]), .A2(acc[1]), .ZN(add_21_n37) );
  INV_X1 add_21_U152 ( .A(add_21_n31), .ZN(add_21_n29) );
  NOR2_X1 add_21_U151 ( .A1(add_21_n29), .A2(add_21_n30), .ZN(add_21_n28) );
  NAND2_X1 add_21_U150 ( .A1(add_21_n22), .A2(add_21_n23), .ZN(add_21_n24) );
  XNOR2_X1 add_21_U149 ( .A(add_21_n24), .B(add_21_n25), .ZN(N25) );
  NAND3_X1 add_21_U148 ( .A1(add_21_n32), .A2(add_21_n36), .A3(add_21_n111), 
        .ZN(add_21_n102) );
  NAND3_X1 add_21_U147 ( .A1(add_21_n32), .A2(add_21_n36), .A3(add_21_n73), 
        .ZN(add_21_n43) );
  NAND2_X1 add_21_U146 ( .A1(product_reg[7]), .A2(acc[7]), .ZN(add_21_n16) );
  INV_X1 add_21_U145 ( .A(product_reg[0]), .ZN(add_21_n188) );
  INV_X1 add_21_U144 ( .A(acc[0]), .ZN(add_21_n189) );
  NAND2_X1 add_21_U143 ( .A1(product_reg[14]), .A2(acc[14]), .ZN(add_21_n68)
         );
  NAND2_X1 add_21_U142 ( .A1(product_reg[1]), .A2(acc[1]), .ZN(add_21_n55) );
  NAND2_X1 add_21_U141 ( .A1(product_reg[8]), .A2(acc[8]), .ZN(add_21_n10) );
  NAND2_X1 add_21_U140 ( .A1(product_reg[12]), .A2(acc[12]), .ZN(add_21_n101)
         );
  NAND2_X1 add_21_U139 ( .A1(product_reg[13]), .A2(acc[13]), .ZN(add_21_n67)
         );
  OR2_X1 add_21_U138 ( .A1(product_reg[2]), .A2(acc[2]), .ZN(add_21_n53) );
  NAND2_X1 add_21_U137 ( .A1(product_reg[0]), .A2(acc[0]), .ZN(add_21_n59) );
  NAND2_X1 add_21_U136 ( .A1(add_21_n181), .A2(add_21_n77), .ZN(add_21_n180)
         );
  NAND2_X1 add_21_U135 ( .A1(product_reg[9]), .A2(acc[9]), .ZN(add_21_n8) );
  NAND2_X1 add_21_U134 ( .A1(product_reg[10]), .A2(acc[10]), .ZN(add_21_n122)
         );
  NAND2_X1 add_21_U133 ( .A1(product_reg[4]), .A2(acc[4]), .ZN(add_21_n35) );
  NAND2_X1 add_21_U132 ( .A1(product_reg[0]), .A2(acc[0]), .ZN(add_21_n77) );
  OR2_X1 add_21_U131 ( .A1(product_reg[14]), .A2(acc[14]), .ZN(add_21_n88) );
  NAND2_X1 add_21_U130 ( .A1(product_reg[3]), .A2(acc[3]), .ZN(add_21_n36) );
  OR2_X1 add_21_U129 ( .A1(product_reg[12]), .A2(acc[12]), .ZN(add_21_n119) );
  OR2_X1 add_21_U128 ( .A1(product_reg[13]), .A2(acc[13]), .ZN(add_21_n89) );
  NAND2_X1 add_21_U127 ( .A1(product_reg[11]), .A2(acc[11]), .ZN(add_21_n123)
         );
  OR2_X1 add_21_U126 ( .A1(product_reg[10]), .A2(acc[10]), .ZN(add_21_n129) );
  OR2_X1 add_21_U125 ( .A1(product_reg[11]), .A2(acc[11]), .ZN(add_21_n127) );
  OR2_X1 add_21_U124 ( .A1(product_reg[8]), .A2(acc[8]), .ZN(add_21_n11) );
  AND2_X1 add_21_U123 ( .A1(add_21_n37), .A2(add_21_n38), .ZN(add_21_n4) );
  NAND2_X1 add_21_U122 ( .A1(add_21_n76), .A2(add_21_n77), .ZN(add_21_n75) );
  NAND2_X1 add_21_U121 ( .A1(product_reg[6]), .A2(acc[6]), .ZN(add_21_n18) );
  NOR2_X1 add_21_U120 ( .A1(acc[10]), .A2(product_reg[10]), .ZN(add_21_n141)
         );
  XNOR2_X1 add_21_U119 ( .A(product_reg[15]), .B(acc[15]), .ZN(add_21_n61) );
  OR2_X1 add_21_U118 ( .A1(product_reg[9]), .A2(acc[9]), .ZN(add_21_n7) );
  NOR2_X1 add_21_U117 ( .A1(acc[11]), .A2(product_reg[11]), .ZN(add_21_n144)
         );
  NAND2_X1 add_21_U116 ( .A1(product_reg[2]), .A2(acc[2]), .ZN(add_21_n50) );
  NAND2_X1 add_21_U115 ( .A1(product_reg[0]), .A2(acc[0]), .ZN(add_21_n38) );
  NAND2_X1 add_21_U114 ( .A1(product_reg[5]), .A2(acc[5]), .ZN(add_21_n23) );
  NOR2_X1 add_21_U113 ( .A1(acc[5]), .A2(product_reg[5]), .ZN(add_21_n186) );
  OAI211_X1 add_21_U112 ( .C1(add_21_n186), .C2(add_21_n187), .A(add_21_n18), 
        .B(add_21_n23), .ZN(add_21_n117) );
  NOR2_X1 add_21_U111 ( .A1(acc[9]), .A2(product_reg[9]), .ZN(add_21_n143) );
  NOR2_X1 add_21_U110 ( .A1(add_21_n141), .A2(add_21_n142), .ZN(add_21_n140)
         );
  NOR2_X1 add_21_U109 ( .A1(add_21_n143), .A2(add_21_n144), .ZN(add_21_n139)
         );
  AND2_X1 add_21_U108 ( .A1(add_21_n139), .A2(add_21_n140), .ZN(add_21_n118)
         );
  NOR2_X1 add_21_U107 ( .A1(acc[8]), .A2(product_reg[8]), .ZN(add_21_n142) );
  NAND2_X1 add_21_U106 ( .A1(add_21_n113), .A2(add_21_n77), .ZN(add_21_n112)
         );
  OR2_X1 add_21_U105 ( .A1(product_reg[3]), .A2(acc[3]), .ZN(add_21_n47) );
  NOR2_X1 add_21_U104 ( .A1(acc[2]), .A2(product_reg[2]), .ZN(add_21_n165) );
  OR2_X1 add_21_U103 ( .A1(product_reg[4]), .A2(acc[4]), .ZN(add_21_n42) );
  INV_X1 add_21_U102 ( .A(product_reg[1]), .ZN(add_21_n162) );
  OR2_X1 add_21_U101 ( .A1(product_reg[7]), .A2(acc[7]), .ZN(add_21_n17) );
  OR2_X1 add_21_U100 ( .A1(product_reg[5]), .A2(acc[5]), .ZN(add_21_n31) );
  OR2_X1 add_21_U99 ( .A1(product_reg[6]), .A2(acc[6]), .ZN(add_21_n20) );
  INV_X1 add_21_U98 ( .A(acc[1]), .ZN(add_21_n163) );
  NOR2_X1 add_21_U97 ( .A1(acc[3]), .A2(product_reg[3]), .ZN(add_21_n164) );
  NAND2_X1 add_21_U96 ( .A1(add_21_n162), .A2(add_21_n163), .ZN(add_21_n161)
         );
  NOR2_X1 add_21_U95 ( .A1(add_21_n164), .A2(add_21_n165), .ZN(add_21_n160) );
  NAND2_X1 add_21_U94 ( .A1(add_21_n160), .A2(add_21_n161), .ZN(add_21_n33) );
  OAI21_X1 add_21_U93 ( .B1(add_21_n2), .B2(add_21_n33), .A(add_21_n32), .ZN(
        add_21_n159) );
  NAND2_X1 add_21_U92 ( .A1(add_21_n188), .A2(add_21_n189), .ZN(add_21_n179)
         );
  NAND2_X1 add_21_U91 ( .A1(add_21_n56), .A2(add_21_n55), .ZN(add_21_n58) );
  XNOR2_X1 add_21_U90 ( .A(add_21_n57), .B(add_21_n58), .ZN(N20) );
  NAND2_X1 add_21_U89 ( .A1(add_21_n53), .A2(add_21_n50), .ZN(add_21_n52) );
  XNOR2_X1 add_21_U88 ( .A(add_21_n51), .B(add_21_n52), .ZN(N21) );
  NAND2_X1 add_21_U87 ( .A1(add_21_n8), .A2(add_21_n122), .ZN(add_21_n152) );
  NAND2_X1 add_21_U86 ( .A1(add_21_n152), .A2(add_21_n129), .ZN(add_21_n151)
         );
  NOR3_X1 add_21_U85 ( .A1(add_21_n136), .A2(add_21_n154), .A3(add_21_n155), 
        .ZN(add_21_n148) );
  INV_X1 add_21_U84 ( .A(add_21_n59), .ZN(add_21_n57) );
  NAND2_X1 add_21_U83 ( .A1(add_21_n47), .A2(add_21_n36), .ZN(add_21_n46) );
  NAND2_X1 add_21_U82 ( .A1(add_21_n56), .A2(add_21_n57), .ZN(add_21_n54) );
  NAND2_X1 add_21_U81 ( .A1(add_21_n54), .A2(add_21_n55), .ZN(add_21_n51) );
  NAND2_X1 add_21_U80 ( .A1(add_21_n162), .A2(add_21_n163), .ZN(add_21_n56) );
  NAND2_X1 add_21_U79 ( .A1(add_21_n42), .A2(add_21_n35), .ZN(add_21_n44) );
  NAND2_X1 add_21_U78 ( .A1(add_21_n20), .A2(add_21_n18), .ZN(add_21_n25) );
  NOR2_X1 add_21_U77 ( .A1(add_21_n10), .A2(add_21_n184), .ZN(add_21_n183) );
  AOI21_X1 add_21_U76 ( .B1(add_21_n176), .B2(add_21_n167), .A(add_21_n183), 
        .ZN(add_21_n170) );
  AND2_X1 add_21_U75 ( .A1(add_21_n32), .A2(add_21_n36), .ZN(add_21_n177) );
  NOR2_X1 add_21_U74 ( .A1(add_21_n70), .A2(add_21_n105), .ZN(add_21_n110) );
  AND2_X1 add_21_U73 ( .A1(add_21_n35), .A2(add_21_n36), .ZN(add_21_n34) );
  NAND2_X1 add_21_U72 ( .A1(add_21_n88), .A2(add_21_n89), .ZN(add_21_n83) );
  NAND2_X1 add_21_U71 ( .A1(add_21_n10), .A2(add_21_n11), .ZN(add_21_n13) );
  XNOR2_X1 add_21_U70 ( .A(add_21_n12), .B(add_21_n13), .ZN(N27) );
  NAND2_X1 add_21_U69 ( .A1(add_21_n8), .A2(add_21_n122), .ZN(add_21_n138) );
  NOR2_X1 add_21_U68 ( .A1(add_21_n137), .A2(add_21_n138), .ZN(add_21_n135) );
  OAI21_X1 add_21_U67 ( .B1(add_21_n135), .B2(add_21_n136), .A(add_21_n123), 
        .ZN(add_21_n134) );
  NAND2_X1 add_21_U66 ( .A1(add_21_n134), .A2(add_21_n127), .ZN(add_21_n133)
         );
  NAND2_X1 add_21_U65 ( .A1(add_21_n119), .A2(add_21_n127), .ZN(add_21_n126)
         );
  NAND2_X1 add_21_U64 ( .A1(add_21_n129), .A2(add_21_n122), .ZN(add_21_n169)
         );
  NAND2_X1 add_21_U63 ( .A1(add_21_n176), .A2(add_21_n47), .ZN(add_21_n175) );
  NAND2_X1 add_21_U62 ( .A1(add_21_n7), .A2(add_21_n11), .ZN(add_21_n184) );
  NOR2_X1 add_21_U61 ( .A1(add_21_n105), .A2(add_21_n175), .ZN(add_21_n173) );
  NAND2_X1 add_21_U60 ( .A1(add_21_n177), .A2(add_21_n178), .ZN(add_21_n172)
         );
  AOI21_X1 add_21_U59 ( .B1(add_21_n172), .B2(add_21_n173), .A(add_21_n174), 
        .ZN(add_21_n171) );
  NOR2_X1 add_21_U58 ( .A1(add_21_n70), .A2(add_21_n83), .ZN(add_21_n84) );
  NAND2_X1 add_21_U57 ( .A1(add_21_n86), .A2(add_21_n16), .ZN(add_21_n85) );
  OAI21_X1 add_21_U56 ( .B1(add_21_n41), .B2(add_21_n30), .A(add_21_n35), .ZN(
        add_21_n39) );
  NAND2_X1 add_21_U55 ( .A1(add_21_n31), .A2(add_21_n23), .ZN(add_21_n40) );
  XNOR2_X1 add_21_U54 ( .A(add_21_n39), .B(add_21_n40), .ZN(N24) );
  NAND2_X1 add_21_U53 ( .A1(add_21_n67), .A2(add_21_n89), .ZN(add_21_n107) );
  AND2_X1 add_21_U52 ( .A1(add_21_n87), .A2(add_21_n101), .ZN(add_21_n3) );
  AND2_X1 add_21_U51 ( .A1(add_21_n3), .A2(add_21_n96), .ZN(add_21_n108) );
  NAND2_X1 add_21_U50 ( .A1(add_21_n71), .A2(add_21_n72), .ZN(add_21_n69) );
  NOR2_X1 add_21_U49 ( .A1(add_21_n69), .A2(add_21_n70), .ZN(add_21_n64) );
  OAI21_X1 add_21_U48 ( .B1(add_21_n66), .B2(add_21_n67), .A(add_21_n68), .ZN(
        add_21_n65) );
  AOI21_X1 add_21_U47 ( .B1(add_21_n43), .B2(add_21_n64), .A(add_21_n65), .ZN(
        add_21_n63) );
  NOR2_X1 add_21_U46 ( .A1(add_21_n128), .A2(add_21_n129), .ZN(add_21_n125) );
  NAND4_X1 add_21_U45 ( .A1(add_21_n8), .A2(add_21_n122), .A3(add_21_n123), 
        .A4(add_21_n124), .ZN(add_21_n121) );
  NOR2_X1 add_21_U44 ( .A1(add_21_n125), .A2(add_21_n126), .ZN(add_21_n120) );
  NAND2_X1 add_21_U43 ( .A1(add_21_n120), .A2(add_21_n121), .ZN(add_21_n87) );
  AOI21_X1 add_21_U42 ( .B1(add_21_n12), .B2(add_21_n148), .A(add_21_n149), 
        .ZN(add_21_n145) );
  NOR2_X1 add_21_U41 ( .A1(add_21_n128), .A2(add_21_n147), .ZN(add_21_n146) );
  XNOR2_X1 add_21_U40 ( .A(add_21_n145), .B(add_21_n146), .ZN(N30) );
  NAND2_X1 add_21_U39 ( .A1(add_21_n104), .A2(add_21_n114), .ZN(add_21_n96) );
  NAND2_X1 add_21_U38 ( .A1(add_21_n118), .A2(add_21_n119), .ZN(add_21_n70) );
  NOR2_X1 add_21_U37 ( .A1(add_21_n93), .A2(add_21_n94), .ZN(add_21_n90) );
  NOR2_X1 add_21_U36 ( .A1(add_21_n92), .A2(add_21_n66), .ZN(add_21_n91) );
  XNOR2_X1 add_21_U35 ( .A(add_21_n90), .B(add_21_n91), .ZN(N33) );
  AOI21_X1 add_21_U34 ( .B1(add_21_n82), .B2(add_21_n89), .A(add_21_n100), 
        .ZN(add_21_n99) );
  OAI21_X1 add_21_U33 ( .B1(add_21_n97), .B2(add_21_n98), .A(add_21_n99), .ZN(
        add_21_n93) );
  NAND2_X1 add_21_U32 ( .A1(add_21_n182), .A2(add_21_n47), .ZN(add_21_n32) );
  NAND2_X1 add_21_U31 ( .A1(add_21_n18), .A2(add_21_n19), .ZN(add_21_n14) );
  NAND2_X1 add_21_U30 ( .A1(add_21_n16), .A2(add_21_n17), .ZN(add_21_n15) );
  XNOR2_X1 add_21_U29 ( .A(add_21_n14), .B(add_21_n15), .ZN(N26) );
  NAND2_X1 add_21_U28 ( .A1(add_21_n22), .A2(add_21_n23), .ZN(add_21_n21) );
  NAND2_X1 add_21_U27 ( .A1(add_21_n20), .A2(add_21_n21), .ZN(add_21_n19) );
  OAI21_X1 add_21_U26 ( .B1(add_21_n4), .B2(add_21_n33), .A(add_21_n34), .ZN(
        add_21_n26) );
  INV_X1 add_21_U25 ( .A(add_21_n32), .ZN(add_21_n27) );
  OAI21_X1 add_21_U24 ( .B1(add_21_n26), .B2(add_21_n27), .A(add_21_n28), .ZN(
        add_21_n22) );
  NAND2_X1 add_21_U23 ( .A1(add_21_n20), .A2(add_21_n17), .ZN(add_21_n116) );
  NAND2_X1 add_21_U22 ( .A1(add_21_n185), .A2(add_21_n117), .ZN(add_21_n86) );
  NAND2_X1 add_21_U21 ( .A1(add_21_n86), .A2(add_21_n16), .ZN(add_21_n167) );
  NAND4_X1 add_21_U20 ( .A1(add_21_n42), .A2(add_21_n31), .A3(add_21_n20), 
        .A4(add_21_n17), .ZN(add_21_n105) );
  NAND2_X1 add_21_U19 ( .A1(add_21_n132), .A2(add_21_n133), .ZN(add_21_n130)
         );
  NAND2_X1 add_21_U18 ( .A1(add_21_n101), .A2(add_21_n119), .ZN(add_21_n131)
         );
  XNOR2_X1 add_21_U17 ( .A(add_21_n130), .B(add_21_n131), .ZN(N31) );
  NAND2_X1 add_21_U16 ( .A1(add_21_n118), .A2(add_21_n12), .ZN(add_21_n132) );
  NAND2_X1 add_21_U15 ( .A1(add_21_n9), .A2(add_21_n10), .ZN(add_21_n5) );
  NAND2_X1 add_21_U14 ( .A1(add_21_n7), .A2(add_21_n8), .ZN(add_21_n6) );
  XNOR2_X1 add_21_U13 ( .A(add_21_n5), .B(add_21_n6), .ZN(N28) );
  NAND2_X1 add_21_U12 ( .A1(add_21_n11), .A2(add_21_n12), .ZN(add_21_n9) );
  INV_X1 add_21_U11 ( .A(add_21_n36), .ZN(add_21_n158) );
  OAI21_X1 add_21_U10 ( .B1(add_21_n158), .B2(add_21_n159), .A(add_21_n71), 
        .ZN(add_21_n157) );
  NAND2_X1 add_21_U9 ( .A1(add_21_n156), .A2(add_21_n157), .ZN(add_21_n12) );
  NOR2_X1 add_21_U8 ( .A1(add_21_n105), .A2(add_21_n95), .ZN(add_21_n103) );
  NAND2_X1 add_21_U7 ( .A1(add_21_n82), .A2(add_21_n72), .ZN(add_21_n81) );
  NOR2_X1 add_21_U6 ( .A1(add_21_n83), .A2(add_21_n87), .ZN(add_21_n78) );
  NOR2_X1 add_21_U5 ( .A1(add_21_n78), .A2(add_21_n79), .ZN(add_21_n62) );
  OAI22_X1 add_21_U4 ( .A1(add_21_n95), .A2(add_21_n96), .B1(add_21_n95), .B2(
        add_21_n87), .ZN(add_21_n94) );
  AND2_X1 add_21_U3 ( .A1(add_21_n166), .A2(add_21_n38), .ZN(add_21_n2) );
  AND2_X1 add_21_U2 ( .A1(add_21_n59), .A2(add_21_n179), .ZN(N19) );
endmodule

