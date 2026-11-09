/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 01:43:32 2025
/////////////////////////////////////////////////////////////


module calculation ( a, b, c, d, s1, s2, s3, s4, s5, s6 );
  input [7:0] a;
  input [7:0] b;
  input [7:0] c;
  input [7:0] d;
  output [7:0] s1;
  output [7:0] s2;
  output [7:0] s3;
  output [7:0] s4;
  output [7:0] s5;
  output [7:0] s6;
  wire   N7, N6, N5, N4, N3, N2, N1, N0, N55, N54, N53, N52, N51, N50, N49,
         N48, N47, N46, N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, N35,
         N34, N33, N32, N31, N30, N29, N28, N27, N26, N25, N24, N9, N8, N15,
         N14, N13, N12, N11, N10, n7, n8, n9, n10, n11, n12, sub_20_n10,
         sub_20_n9, sub_20_n8, sub_20_n7, sub_20_n6, sub_20_n5, sub_20_n4,
         sub_20_n3, sub_20_n2, sub_20_n1, add_16_n1,
         sub_2_root_add_0_root_sub_21_n10, sub_2_root_add_0_root_sub_21_n9,
         sub_2_root_add_0_root_sub_21_n8, sub_2_root_add_0_root_sub_21_n7,
         sub_2_root_add_0_root_sub_21_n6, sub_2_root_add_0_root_sub_21_n5,
         sub_2_root_add_0_root_sub_21_n4, sub_2_root_add_0_root_sub_21_n3,
         sub_2_root_add_0_root_sub_21_n2, sub_2_root_add_0_root_sub_21_n1,
         r97_n29, r97_n28, r97_n27, r97_n26, r97_n25, r97_n24, r97_n23,
         r97_n22, r97_n21, r97_n20, r97_n19, r97_n18, r97_n17, r97_n16,
         r97_n15, r97_n14, r97_n12, r97_n11, r97_n10, r97_n9, r97_n8, r97_n7,
         r97_n6, r97_n5, r97_n4, r97_n3, r97_n2, r97_SUMB_2__1_,
         r97_SUMB_2__2_, r97_SUMB_2__3_, r97_SUMB_2__4_, r97_SUMB_2__5_,
         r97_SUMB_3__1_, r97_SUMB_3__2_, r97_SUMB_3__3_, r97_SUMB_3__4_,
         r97_SUMB_4__1_, r97_SUMB_4__2_, r97_SUMB_4__3_, r97_SUMB_5__1_,
         r97_SUMB_5__2_, r97_SUMB_6__1_, r97_CARRYB_2__0_, r97_CARRYB_2__1_,
         r97_CARRYB_2__2_, r97_CARRYB_2__3_, r97_CARRYB_2__4_,
         r97_CARRYB_3__0_, r97_CARRYB_3__1_, r97_CARRYB_3__2_,
         r97_CARRYB_3__3_, r97_CARRYB_4__0_, r97_CARRYB_4__1_,
         r97_CARRYB_4__2_, r97_CARRYB_5__0_, r97_CARRYB_5__1_,
         r97_CARRYB_6__0_, r97_ab_0__1_, r97_ab_0__2_, r97_ab_0__3_,
         r97_ab_0__4_, r97_ab_0__5_, r97_ab_0__6_, r97_ab_1__0_, r97_ab_1__1_,
         r97_ab_1__2_, r97_ab_1__3_, r97_ab_1__4_, r97_ab_1__5_, r97_ab_1__6_,
         r97_ab_2__0_, r97_ab_2__1_, r97_ab_2__2_, r97_ab_2__3_, r97_ab_2__4_,
         r97_ab_2__5_, r97_ab_3__0_, r97_ab_3__1_, r97_ab_3__2_, r97_ab_3__3_,
         r97_ab_3__4_, r97_ab_4__0_, r97_ab_4__1_, r97_ab_4__2_, r97_ab_4__3_,
         r97_ab_5__0_, r97_ab_5__1_, r97_ab_5__2_, r97_ab_6__0_, r97_ab_6__1_,
         r97_ab_7__0_, mult_21_n29, mult_21_n28, mult_21_n27, mult_21_n26,
         mult_21_n25, mult_21_n24, mult_21_n23, mult_21_n22, mult_21_n21,
         mult_21_n20, mult_21_n19, mult_21_n18, mult_21_n17, mult_21_n16,
         mult_21_n15, mult_21_n13, mult_21_n12, mult_21_n11, mult_21_n10,
         mult_21_n9, mult_21_n8, mult_21_n7, mult_21_n6, mult_21_n5,
         mult_21_n4, mult_21_n3, mult_21_n2, mult_21_SUMB_2__1_,
         mult_21_SUMB_2__2_, mult_21_SUMB_2__3_, mult_21_SUMB_2__4_,
         mult_21_SUMB_2__5_, mult_21_SUMB_3__1_, mult_21_SUMB_3__2_,
         mult_21_SUMB_3__3_, mult_21_SUMB_3__4_, mult_21_SUMB_4__1_,
         mult_21_SUMB_4__2_, mult_21_SUMB_4__3_, mult_21_SUMB_5__1_,
         mult_21_SUMB_5__2_, mult_21_SUMB_6__1_, mult_21_CARRYB_2__0_,
         mult_21_CARRYB_2__1_, mult_21_CARRYB_2__2_, mult_21_CARRYB_2__3_,
         mult_21_CARRYB_2__4_, mult_21_CARRYB_3__0_, mult_21_CARRYB_3__1_,
         mult_21_CARRYB_3__2_, mult_21_CARRYB_3__3_, mult_21_CARRYB_4__0_,
         mult_21_CARRYB_4__1_, mult_21_CARRYB_4__2_, mult_21_CARRYB_5__0_,
         mult_21_CARRYB_5__1_, mult_21_CARRYB_6__0_, mult_21_ab_0__1_,
         mult_21_ab_0__2_, mult_21_ab_0__3_, mult_21_ab_0__4_,
         mult_21_ab_0__5_, mult_21_ab_0__6_, mult_21_ab_1__0_,
         mult_21_ab_1__1_, mult_21_ab_1__2_, mult_21_ab_1__3_,
         mult_21_ab_1__4_, mult_21_ab_1__5_, mult_21_ab_1__6_,
         mult_21_ab_2__0_, mult_21_ab_2__1_, mult_21_ab_2__2_,
         mult_21_ab_2__3_, mult_21_ab_2__4_, mult_21_ab_2__5_,
         mult_21_ab_3__0_, mult_21_ab_3__1_, mult_21_ab_3__2_,
         mult_21_ab_3__3_, mult_21_ab_3__4_, mult_21_ab_4__0_,
         mult_21_ab_4__1_, mult_21_ab_4__2_, mult_21_ab_4__3_,
         mult_21_ab_5__0_, mult_21_ab_5__1_, mult_21_ab_5__2_,
         mult_21_ab_6__0_, mult_21_ab_6__1_, mult_21_ab_7__0_,
         add_1_root_add_0_root_sub_21_n1, add_0_root_add_0_root_sub_21_n1,
         add_1_root_add_0_root_add_19_2_n1, add_0_root_add_0_root_add_19_2_n1,
         add_18_n70, add_18_n69, add_18_n68, add_18_n67, add_18_n66,
         add_18_n65, add_18_n64, add_18_n63, add_18_n62, add_18_n61,
         add_18_n60, add_18_n59, add_18_n58, add_18_n57, add_18_n56,
         add_18_n55, add_18_n54, add_18_n53, add_18_n52, add_18_n51,
         add_18_n50, add_18_n49, add_18_n48, add_18_n47, add_18_n46,
         add_18_n45, add_18_n44, add_18_n43, add_18_n42, add_18_n41,
         add_18_n40, add_18_n39, add_18_n38, add_18_n37, add_18_n36,
         add_18_n35, add_18_n34, add_18_n33, add_18_n32, add_18_n31,
         add_18_n30, add_18_n29, add_18_n28, add_18_n27, add_18_n26,
         add_18_n25, add_18_n24, add_18_n23, add_18_n22, add_18_n21,
         add_18_n20, add_18_n19, add_18_n18, add_18_n17, add_18_n16,
         add_18_n15, add_18_n14, add_18_n13, add_18_n12, add_18_n11,
         add_18_n10, add_18_n9, add_18_n8, add_18_n7, add_18_n6, add_18_n4,
         add_18_n3, add_18_n2, add_18_n1, rem_18_n237, rem_18_n236,
         rem_18_n235, rem_18_n234, rem_18_n233, rem_18_n232, rem_18_n231,
         rem_18_n230, rem_18_n229, rem_18_n228, rem_18_n227, rem_18_n226,
         rem_18_n225, rem_18_n224, rem_18_n223, rem_18_n222, rem_18_n221,
         rem_18_n220, rem_18_n219, rem_18_n218, rem_18_n217, rem_18_n216,
         rem_18_n215, rem_18_n214, rem_18_n213, rem_18_n212, rem_18_n211,
         rem_18_n210, rem_18_n209, rem_18_n208, rem_18_n207, rem_18_n206,
         rem_18_n205, rem_18_n204, rem_18_n203, rem_18_n202, rem_18_n201,
         rem_18_n200, rem_18_n199, rem_18_n198, rem_18_n197, rem_18_n196,
         rem_18_n195, rem_18_n194, rem_18_n193, rem_18_n192, rem_18_n191,
         rem_18_n190, rem_18_n189, rem_18_n188, rem_18_n187, rem_18_n186,
         rem_18_n185, rem_18_n184, rem_18_n183, rem_18_n182, rem_18_n181,
         rem_18_n180, rem_18_n179, rem_18_n178, rem_18_n177, rem_18_n176,
         rem_18_n175, rem_18_n174, rem_18_n173, rem_18_n172, rem_18_n171,
         rem_18_n170, rem_18_n169, rem_18_n168, rem_18_n167, rem_18_n166,
         rem_18_n165, rem_18_n164, rem_18_n163, rem_18_n162, rem_18_n161,
         rem_18_n160, rem_18_n159, rem_18_n158, rem_18_n157, rem_18_n156,
         rem_18_n155, rem_18_n154, rem_18_n153, rem_18_n152, rem_18_n151,
         rem_18_n150, rem_18_n149, rem_18_n148, rem_18_n147, rem_18_n146,
         rem_18_n145, rem_18_n144, rem_18_n143, rem_18_n142, rem_18_n141,
         rem_18_n140, rem_18_n139, rem_18_n138, rem_18_n137, rem_18_n136,
         rem_18_n135, rem_18_n134, rem_18_n133, rem_18_n132, rem_18_n131,
         rem_18_n130, rem_18_n129, rem_18_n128, rem_18_n127, rem_18_n126,
         rem_18_n125, rem_18_n124, rem_18_n123, rem_18_n122, rem_18_n121,
         rem_18_n120, rem_18_n119, rem_18_n118, rem_18_n117, rem_18_n116,
         rem_18_n115, rem_18_n114, rem_18_n113, rem_18_n112, rem_18_n111,
         rem_18_n110, rem_18_n109, rem_18_n108, rem_18_n107, rem_18_n106,
         rem_18_n105, rem_18_n104, rem_18_n103, rem_18_n102, rem_18_n101,
         rem_18_n100, rem_18_n99, rem_18_n98, rem_18_n97, rem_18_n96,
         rem_18_n95, rem_18_n94, rem_18_n93, rem_18_n92, rem_18_n91,
         rem_18_n90, rem_18_n89, rem_18_n88, rem_18_n87, rem_18_n86,
         rem_18_n85, rem_18_n84, rem_18_n83, rem_18_n82, rem_18_n81,
         rem_18_n80, rem_18_n79, rem_18_n78, rem_18_n77, rem_18_n76,
         rem_18_n75, rem_18_n74, rem_18_n73, rem_18_n72, rem_18_n71,
         rem_18_n70, rem_18_n69, rem_18_n68, rem_18_n67, rem_18_n66,
         rem_18_n65, rem_18_n64, rem_18_n63, rem_18_n62, rem_18_n61,
         rem_18_n60, rem_18_n59, rem_18_n58, rem_18_n57, rem_18_n56,
         rem_18_n55, rem_18_n54, rem_18_n53, rem_18_n52, rem_18_n51,
         rem_18_n50, rem_18_n49, rem_18_n48, rem_18_n47, rem_18_n46,
         rem_18_n45, rem_18_n44, rem_18_n43, rem_18_n42, rem_18_n41,
         rem_18_n40, rem_18_n39, rem_18_n38, rem_18_n37, rem_18_n36,
         rem_18_n35, rem_18_n34, rem_18_n33, rem_18_n32, rem_18_n31,
         rem_18_n30, rem_18_n29, rem_18_n28, rem_18_n27, rem_18_n26,
         rem_18_n25, rem_18_n24, rem_18_n23, rem_18_n22, rem_18_n21,
         rem_18_n20, rem_18_n19, rem_18_n18, rem_18_n17, rem_18_n16,
         rem_18_n15, rem_18_n14, rem_18_n13, rem_18_n12, rem_18_n11,
         rem_18_n10, rem_18_n9, rem_18_n8, rem_18_n7, rem_18_n6, rem_18_n5,
         rem_18_n4, rem_18_n3, rem_18_n2, rem_18_n1,
         rem_18_u_div_PartRem_6__2_, rem_18_u_div_PartRem_5__3_,
         rem_18_u_div_PartRem_5__2_, rem_18_u_div_PartRem_4__4_,
         rem_18_u_div_PartRem_4__3_, rem_18_u_div_PartRem_4__2_,
         rem_18_u_div_PartRem_3__5_, rem_18_u_div_PartRem_3__4_,
         rem_18_u_div_PartRem_3__3_, rem_18_u_div_PartRem_3__2_,
         rem_18_u_div_PartRem_2__6_, rem_18_u_div_PartRem_2__5_,
         rem_18_u_div_PartRem_2__4_, rem_18_u_div_PartRem_2__3_,
         rem_18_u_div_PartRem_2__2_, rem_18_u_div_PartRem_1__7_,
         rem_18_u_div_PartRem_1__6_, rem_18_u_div_PartRem_1__5_,
         rem_18_u_div_PartRem_1__4_, rem_18_u_div_PartRem_1__3_,
         rem_18_u_div_PartRem_1__2_, rem_18_u_div_PartRem_1__1_,
         rem_18_u_div_CryTmp_6__2_, rem_18_u_div_CryTmp_6__1_,
         rem_18_u_div_CryTmp_5__3_, rem_18_u_div_CryTmp_5__2_,
         rem_18_u_div_CryTmp_5__1_, rem_18_u_div_CryTmp_4__4_,
         rem_18_u_div_CryTmp_4__3_, rem_18_u_div_CryTmp_4__2_,
         rem_18_u_div_CryTmp_4__1_, rem_18_u_div_CryTmp_3__5_,
         rem_18_u_div_CryTmp_3__4_, rem_18_u_div_CryTmp_3__3_,
         rem_18_u_div_CryTmp_3__2_, rem_18_u_div_CryTmp_3__1_,
         rem_18_u_div_CryTmp_2__6_, rem_18_u_div_CryTmp_2__5_,
         rem_18_u_div_CryTmp_2__4_, rem_18_u_div_CryTmp_2__3_,
         rem_18_u_div_CryTmp_2__2_, rem_18_u_div_CryTmp_2__1_,
         rem_18_u_div_CryTmp_1__6_, rem_18_u_div_CryTmp_1__5_,
         rem_18_u_div_CryTmp_1__4_, rem_18_u_div_CryTmp_1__3_,
         rem_18_u_div_CryTmp_1__2_, rem_18_u_div_CryTmp_1__1_,
         rem_18_u_div_CryTmp_0__8_, rem_18_u_div_CryTmp_0__7_,
         rem_18_u_div_CryTmp_0__6_, rem_18_u_div_CryTmp_0__4_,
         rem_18_u_div_CryTmp_0__3_, rem_18_u_div_CryTmp_0__2_,
         rem_18_u_div_CryTmp_0__1_, rem_18_u_div_SumTmp_7__0_,
         rem_18_u_div_SumTmp_6__1_, rem_18_u_div_SumTmp_5__2_,
         rem_18_u_div_SumTmp_4__3_, rem_18_u_div_SumTmp_4__2_,
         rem_18_u_div_SumTmp_4__0_, rem_18_u_div_SumTmp_3__0_,
         rem_18_u_div_SumTmp_2__2_, rem_18_u_div_SumTmp_2__0_,
         rem_18_u_div_SumTmp_1__2_, rem_18_u_div_SumTmp_1__0_,
         rem_18_u_div_SumTmp_0__7_, rem_18_u_div_SumTmp_0__6_,
         rem_18_u_div_SumTmp_0__5_, rem_18_u_div_SumTmp_0__4_,
         rem_18_u_div_SumTmp_0__3_, rem_18_u_div_SumTmp_0__2_,
         rem_18_u_div_SumTmp_0__1_, rem_18_u_div_SumTmp_0__0_;
  wire   [7:1] sub_20_carry;
  wire   [7:2] add_16_carry;
  wire   [7:2] add_21_carry;
  wire   [7:1] sub_2_root_add_0_root_sub_21_carry;
  wire   [7:2] add_1_root_add_0_root_sub_21_carry;
  wire   [7:2] add_0_root_add_0_root_sub_21_carry;
  wire   [7:2] add_1_root_add_0_root_add_19_2_carry;
  wire   [7:2] add_0_root_add_0_root_add_19_2_carry;
  wire   [7:1] rem_18_u_div_BInv;

  BUF_X1 U8 ( .A(b[4]), .Z(n7) );
  BUF_X1 U9 ( .A(n8), .Z(n9) );
  BUF_X1 U10 ( .A(n7), .Z(n8) );
  BUF_X1 U11 ( .A(b[7]), .Z(n10) );
  BUF_X2 U12 ( .A(n10), .Z(n11) );
  BUF_X1 U13 ( .A(n11), .Z(n12) );
  INV_X1 sub_20_U12 ( .A(b[0]), .ZN(sub_20_n10) );
  INV_X1 sub_20_U11 ( .A(n11), .ZN(sub_20_n3) );
  XNOR2_X1 sub_20_U10 ( .A(sub_20_n10), .B(a[0]), .ZN(s5[0]) );
  INV_X1 sub_20_U9 ( .A(a[0]), .ZN(sub_20_n2) );
  NAND2_X1 sub_20_U8 ( .A1(sub_20_n1), .A2(sub_20_n2), .ZN(sub_20_carry[1]) );
  INV_X1 sub_20_U7 ( .A(b[1]), .ZN(sub_20_n9) );
  INV_X1 sub_20_U6 ( .A(b[2]), .ZN(sub_20_n8) );
  INV_X1 sub_20_U5 ( .A(b[3]), .ZN(sub_20_n7) );
  INV_X1 sub_20_U4 ( .A(n9), .ZN(sub_20_n6) );
  INV_X1 sub_20_U3 ( .A(b[5]), .ZN(sub_20_n5) );
  INV_X1 sub_20_U2 ( .A(b[6]), .ZN(sub_20_n4) );
  INV_X1 sub_20_U1 ( .A(sub_20_n10), .ZN(sub_20_n1) );
  FA_X1 sub_20_U2_1 ( .A(a[1]), .B(sub_20_n9), .CI(sub_20_carry[1]), .CO(
        sub_20_carry[2]), .S(s5[1]) );
  FA_X1 sub_20_U2_2 ( .A(a[2]), .B(sub_20_n8), .CI(sub_20_carry[2]), .CO(
        sub_20_carry[3]), .S(s5[2]) );
  FA_X1 sub_20_U2_3 ( .A(a[3]), .B(sub_20_n7), .CI(sub_20_carry[3]), .CO(
        sub_20_carry[4]), .S(s5[3]) );
  FA_X1 sub_20_U2_4 ( .A(a[4]), .B(sub_20_n6), .CI(sub_20_carry[4]), .CO(
        sub_20_carry[5]), .S(s5[4]) );
  FA_X1 sub_20_U2_5 ( .A(a[5]), .B(sub_20_n5), .CI(sub_20_carry[5]), .CO(
        sub_20_carry[6]), .S(s5[5]) );
  FA_X1 sub_20_U2_6 ( .A(a[6]), .B(sub_20_n4), .CI(sub_20_carry[6]), .CO(
        sub_20_carry[7]), .S(s5[6]) );
  FA_X1 sub_20_U2_7 ( .A(a[7]), .B(sub_20_n3), .CI(sub_20_carry[7]), .S(s5[7])
         );
  XOR2_X1 add_16_U2 ( .A(b[0]), .B(a[0]), .Z(s1[0]) );
  AND2_X1 add_16_U1 ( .A1(b[0]), .A2(a[0]), .ZN(add_16_n1) );
  FA_X1 add_16_U1_1 ( .A(a[1]), .B(b[1]), .CI(add_16_n1), .CO(add_16_carry[2]), 
        .S(s1[1]) );
  FA_X1 add_16_U1_2 ( .A(a[2]), .B(b[2]), .CI(add_16_carry[2]), .CO(
        add_16_carry[3]), .S(s1[2]) );
  FA_X1 add_16_U1_3 ( .A(a[3]), .B(b[3]), .CI(add_16_carry[3]), .CO(
        add_16_carry[4]), .S(s1[3]) );
  FA_X1 add_16_U1_4 ( .A(a[4]), .B(n9), .CI(add_16_carry[4]), .CO(
        add_16_carry[5]), .S(s1[4]) );
  FA_X1 add_16_U1_5 ( .A(a[5]), .B(b[5]), .CI(add_16_carry[5]), .CO(
        add_16_carry[6]), .S(s1[5]) );
  FA_X1 add_16_U1_6 ( .A(a[6]), .B(b[6]), .CI(add_16_carry[6]), .CO(
        add_16_carry[7]), .S(s1[6]) );
  FA_X1 add_16_U1_7 ( .A(a[7]), .B(n12), .CI(add_16_carry[7]), .S(s1[7]) );
  INV_X1 add_21_U2 ( .A(b[0]), .ZN(N24) );
  XOR2_X1 add_21_U1 ( .A(add_21_carry[7]), .B(n11), .Z(N31) );
  HA_X1 add_21_U1_1_1 ( .A(b[1]), .B(b[0]), .CO(add_21_carry[2]), .S(N25) );
  HA_X1 add_21_U1_1_2 ( .A(b[2]), .B(add_21_carry[2]), .CO(add_21_carry[3]), 
        .S(N26) );
  HA_X1 add_21_U1_1_3 ( .A(b[3]), .B(add_21_carry[3]), .CO(add_21_carry[4]), 
        .S(N27) );
  HA_X1 add_21_U1_1_4 ( .A(n7), .B(add_21_carry[4]), .CO(add_21_carry[5]), .S(
        N28) );
  HA_X1 add_21_U1_1_5 ( .A(b[5]), .B(add_21_carry[5]), .CO(add_21_carry[6]), 
        .S(N29) );
  HA_X1 add_21_U1_1_6 ( .A(b[6]), .B(add_21_carry[6]), .CO(add_21_carry[7]), 
        .S(N30) );
  INV_X1 sub_2_root_add_0_root_sub_21_U12 ( .A(b[0]), .ZN(
        sub_2_root_add_0_root_sub_21_n10) );
  INV_X1 sub_2_root_add_0_root_sub_21_U11 ( .A(n11), .ZN(
        sub_2_root_add_0_root_sub_21_n3) );
  XNOR2_X1 sub_2_root_add_0_root_sub_21_U10 ( .A(
        sub_2_root_add_0_root_sub_21_n10), .B(d[0]), .ZN(N48) );
  INV_X1 sub_2_root_add_0_root_sub_21_U9 ( .A(b[3]), .ZN(
        sub_2_root_add_0_root_sub_21_n7) );
  INV_X1 sub_2_root_add_0_root_sub_21_U8 ( .A(n8), .ZN(
        sub_2_root_add_0_root_sub_21_n6) );
  INV_X1 sub_2_root_add_0_root_sub_21_U7 ( .A(b[2]), .ZN(
        sub_2_root_add_0_root_sub_21_n8) );
  INV_X1 sub_2_root_add_0_root_sub_21_U6 ( .A(b[5]), .ZN(
        sub_2_root_add_0_root_sub_21_n5) );
  INV_X1 sub_2_root_add_0_root_sub_21_U5 ( .A(b[6]), .ZN(
        sub_2_root_add_0_root_sub_21_n4) );
  INV_X1 sub_2_root_add_0_root_sub_21_U4 ( .A(d[0]), .ZN(
        sub_2_root_add_0_root_sub_21_n2) );
  NAND2_X1 sub_2_root_add_0_root_sub_21_U3 ( .A1(
        sub_2_root_add_0_root_sub_21_n1), .A2(sub_2_root_add_0_root_sub_21_n2), 
        .ZN(sub_2_root_add_0_root_sub_21_carry[1]) );
  INV_X1 sub_2_root_add_0_root_sub_21_U2 ( .A(b[1]), .ZN(
        sub_2_root_add_0_root_sub_21_n9) );
  INV_X1 sub_2_root_add_0_root_sub_21_U1 ( .A(sub_2_root_add_0_root_sub_21_n10), .ZN(sub_2_root_add_0_root_sub_21_n1) );
  FA_X1 sub_2_root_add_0_root_sub_21_U2_1 ( .A(d[1]), .B(
        sub_2_root_add_0_root_sub_21_n9), .CI(
        sub_2_root_add_0_root_sub_21_carry[1]), .CO(
        sub_2_root_add_0_root_sub_21_carry[2]), .S(N49) );
  FA_X1 sub_2_root_add_0_root_sub_21_U2_2 ( .A(d[2]), .B(
        sub_2_root_add_0_root_sub_21_n8), .CI(
        sub_2_root_add_0_root_sub_21_carry[2]), .CO(
        sub_2_root_add_0_root_sub_21_carry[3]), .S(N50) );
  FA_X1 sub_2_root_add_0_root_sub_21_U2_3 ( .A(d[3]), .B(
        sub_2_root_add_0_root_sub_21_n7), .CI(
        sub_2_root_add_0_root_sub_21_carry[3]), .CO(
        sub_2_root_add_0_root_sub_21_carry[4]), .S(N51) );
  FA_X1 sub_2_root_add_0_root_sub_21_U2_4 ( .A(d[4]), .B(
        sub_2_root_add_0_root_sub_21_n6), .CI(
        sub_2_root_add_0_root_sub_21_carry[4]), .CO(
        sub_2_root_add_0_root_sub_21_carry[5]), .S(N52) );
  FA_X1 sub_2_root_add_0_root_sub_21_U2_5 ( .A(d[5]), .B(
        sub_2_root_add_0_root_sub_21_n5), .CI(
        sub_2_root_add_0_root_sub_21_carry[5]), .CO(
        sub_2_root_add_0_root_sub_21_carry[6]), .S(N53) );
  FA_X1 sub_2_root_add_0_root_sub_21_U2_6 ( .A(d[6]), .B(
        sub_2_root_add_0_root_sub_21_n4), .CI(
        sub_2_root_add_0_root_sub_21_carry[6]), .CO(
        sub_2_root_add_0_root_sub_21_carry[7]), .S(N54) );
  FA_X1 sub_2_root_add_0_root_sub_21_U2_7 ( .A(d[7]), .B(
        sub_2_root_add_0_root_sub_21_n3), .CI(
        sub_2_root_add_0_root_sub_21_carry[7]), .S(N55) );
  NOR2_X1 r97_U64 ( .A1(r97_n29), .A2(r97_n28), .ZN(s2[0]) );
  AND2_X1 r97_U63 ( .A1(a[7]), .A2(b[0]), .ZN(r97_ab_7__0_) );
  NOR2_X1 r97_U62 ( .A1(r97_n28), .A2(r97_n27), .ZN(r97_ab_6__0_) );
  NOR2_X1 r97_U61 ( .A1(r97_n27), .A2(r97_n26), .ZN(r97_ab_6__1_) );
  INV_X1 r97_U60 ( .A(a[6]), .ZN(r97_n27) );
  NOR2_X1 r97_U59 ( .A1(r97_n28), .A2(r97_n25), .ZN(r97_ab_5__0_) );
  NOR2_X1 r97_U58 ( .A1(r97_n26), .A2(r97_n25), .ZN(r97_ab_5__1_) );
  NOR2_X1 r97_U57 ( .A1(r97_n25), .A2(r97_n24), .ZN(r97_ab_5__2_) );
  INV_X1 r97_U56 ( .A(a[5]), .ZN(r97_n25) );
  NOR2_X1 r97_U55 ( .A1(r97_n28), .A2(r97_n23), .ZN(r97_ab_4__0_) );
  NOR2_X1 r97_U54 ( .A1(r97_n26), .A2(r97_n23), .ZN(r97_ab_4__1_) );
  NOR2_X1 r97_U53 ( .A1(r97_n24), .A2(r97_n23), .ZN(r97_ab_4__2_) );
  NOR2_X1 r97_U52 ( .A1(r97_n23), .A2(r97_n22), .ZN(r97_ab_4__3_) );
  INV_X1 r97_U51 ( .A(a[4]), .ZN(r97_n23) );
  NOR2_X1 r97_U50 ( .A1(r97_n28), .A2(r97_n21), .ZN(r97_ab_3__0_) );
  NOR2_X1 r97_U49 ( .A1(r97_n26), .A2(r97_n21), .ZN(r97_ab_3__1_) );
  NOR2_X1 r97_U48 ( .A1(r97_n24), .A2(r97_n21), .ZN(r97_ab_3__2_) );
  NOR2_X1 r97_U47 ( .A1(r97_n22), .A2(r97_n21), .ZN(r97_ab_3__3_) );
  NOR2_X1 r97_U46 ( .A1(r97_n21), .A2(r97_n20), .ZN(r97_ab_3__4_) );
  INV_X1 r97_U45 ( .A(a[3]), .ZN(r97_n21) );
  NOR2_X1 r97_U44 ( .A1(r97_n28), .A2(r97_n19), .ZN(r97_ab_2__0_) );
  NOR2_X1 r97_U43 ( .A1(r97_n26), .A2(r97_n19), .ZN(r97_ab_2__1_) );
  NOR2_X1 r97_U42 ( .A1(r97_n24), .A2(r97_n19), .ZN(r97_ab_2__2_) );
  NOR2_X1 r97_U41 ( .A1(r97_n22), .A2(r97_n19), .ZN(r97_ab_2__3_) );
  NOR2_X1 r97_U40 ( .A1(r97_n20), .A2(r97_n19), .ZN(r97_ab_2__4_) );
  NOR2_X1 r97_U39 ( .A1(r97_n19), .A2(r97_n18), .ZN(r97_ab_2__5_) );
  INV_X1 r97_U38 ( .A(a[2]), .ZN(r97_n19) );
  NOR2_X1 r97_U37 ( .A1(r97_n28), .A2(r97_n17), .ZN(r97_ab_1__0_) );
  NOR2_X1 r97_U36 ( .A1(r97_n29), .A2(r97_n26), .ZN(r97_ab_0__1_) );
  NOR2_X1 r97_U35 ( .A1(r97_n26), .A2(r97_n17), .ZN(r97_ab_1__1_) );
  INV_X1 r97_U34 ( .A(b[1]), .ZN(r97_n26) );
  NOR2_X1 r97_U33 ( .A1(r97_n29), .A2(r97_n24), .ZN(r97_ab_0__2_) );
  NOR2_X1 r97_U32 ( .A1(r97_n24), .A2(r97_n17), .ZN(r97_ab_1__2_) );
  INV_X1 r97_U31 ( .A(b[2]), .ZN(r97_n24) );
  NOR2_X1 r97_U30 ( .A1(r97_n29), .A2(r97_n22), .ZN(r97_ab_0__3_) );
  NOR2_X1 r97_U29 ( .A1(r97_n22), .A2(r97_n17), .ZN(r97_ab_1__3_) );
  INV_X1 r97_U28 ( .A(b[3]), .ZN(r97_n22) );
  NOR2_X1 r97_U27 ( .A1(r97_n29), .A2(r97_n20), .ZN(r97_ab_0__4_) );
  NOR2_X1 r97_U26 ( .A1(r97_n20), .A2(r97_n17), .ZN(r97_ab_1__4_) );
  INV_X1 r97_U25 ( .A(b[4]), .ZN(r97_n20) );
  NOR2_X1 r97_U24 ( .A1(r97_n29), .A2(r97_n18), .ZN(r97_ab_0__5_) );
  NOR2_X1 r97_U23 ( .A1(r97_n18), .A2(r97_n17), .ZN(r97_ab_1__5_) );
  INV_X1 r97_U22 ( .A(b[5]), .ZN(r97_n18) );
  NOR2_X1 r97_U21 ( .A1(r97_n29), .A2(r97_n16), .ZN(r97_ab_0__6_) );
  INV_X1 r97_U20 ( .A(a[0]), .ZN(r97_n29) );
  NOR2_X1 r97_U19 ( .A1(r97_n17), .A2(r97_n16), .ZN(r97_ab_1__6_) );
  INV_X1 r97_U18 ( .A(b[6]), .ZN(r97_n16) );
  INV_X1 r97_U17 ( .A(a[1]), .ZN(r97_n17) );
  INV_X1 r97_U16 ( .A(b[0]), .ZN(r97_n28) );
  NAND2_X1 r97_U15 ( .A1(n10), .A2(a[0]), .ZN(r97_n15) );
  XNOR2_X1 r97_U14 ( .A(r97_n15), .B(r97_ab_1__6_), .ZN(r97_n14) );
  XOR2_X1 r97_U13 ( .A(r97_ab_1__0_), .B(r97_ab_0__1_), .Z(s2[1]) );
  AND2_X1 r97_U12 ( .A1(r97_ab_0__6_), .A2(r97_ab_1__5_), .ZN(r97_n12) );
  AND2_X1 r97_U11 ( .A1(r97_ab_0__1_), .A2(r97_ab_1__0_), .ZN(r97_n11) );
  AND2_X1 r97_U10 ( .A1(r97_ab_0__2_), .A2(r97_ab_1__1_), .ZN(r97_n10) );
  AND2_X1 r97_U9 ( .A1(r97_ab_0__3_), .A2(r97_ab_1__2_), .ZN(r97_n9) );
  AND2_X1 r97_U8 ( .A1(r97_ab_0__4_), .A2(r97_ab_1__3_), .ZN(r97_n8) );
  AND2_X1 r97_U7 ( .A1(r97_ab_0__5_), .A2(r97_ab_1__4_), .ZN(r97_n7) );
  XOR2_X1 r97_U6 ( .A(r97_ab_1__1_), .B(r97_ab_0__2_), .Z(r97_n6) );
  XOR2_X1 r97_U5 ( .A(r97_ab_1__2_), .B(r97_ab_0__3_), .Z(r97_n5) );
  XOR2_X1 r97_U4 ( .A(r97_ab_1__3_), .B(r97_ab_0__4_), .Z(r97_n4) );
  XOR2_X1 r97_U3 ( .A(r97_ab_1__4_), .B(r97_ab_0__5_), .Z(r97_n3) );
  XOR2_X1 r97_U2 ( .A(r97_ab_1__5_), .B(r97_ab_0__6_), .Z(r97_n2) );
  FA_X1 r97_S2_2_5 ( .A(r97_ab_2__5_), .B(r97_n12), .CI(r97_n14), .S(
        r97_SUMB_2__5_) );
  FA_X1 r97_S2_2_4 ( .A(r97_ab_2__4_), .B(r97_n7), .CI(r97_n2), .CO(
        r97_CARRYB_2__4_), .S(r97_SUMB_2__4_) );
  FA_X1 r97_S2_2_3 ( .A(r97_ab_2__3_), .B(r97_n8), .CI(r97_n3), .CO(
        r97_CARRYB_2__3_), .S(r97_SUMB_2__3_) );
  FA_X1 r97_S2_2_2 ( .A(r97_ab_2__2_), .B(r97_n9), .CI(r97_n4), .CO(
        r97_CARRYB_2__2_), .S(r97_SUMB_2__2_) );
  FA_X1 r97_S2_2_1 ( .A(r97_ab_2__1_), .B(r97_n10), .CI(r97_n5), .CO(
        r97_CARRYB_2__1_), .S(r97_SUMB_2__1_) );
  FA_X1 r97_S1_2_0 ( .A(r97_ab_2__0_), .B(r97_n11), .CI(r97_n6), .CO(
        r97_CARRYB_2__0_), .S(s2[2]) );
  FA_X1 r97_S2_3_4 ( .A(r97_ab_3__4_), .B(r97_CARRYB_2__4_), .CI(
        r97_SUMB_2__5_), .S(r97_SUMB_3__4_) );
  FA_X1 r97_S2_3_3 ( .A(r97_ab_3__3_), .B(r97_CARRYB_2__3_), .CI(
        r97_SUMB_2__4_), .CO(r97_CARRYB_3__3_), .S(r97_SUMB_3__3_) );
  FA_X1 r97_S2_3_2 ( .A(r97_ab_3__2_), .B(r97_CARRYB_2__2_), .CI(
        r97_SUMB_2__3_), .CO(r97_CARRYB_3__2_), .S(r97_SUMB_3__2_) );
  FA_X1 r97_S2_3_1 ( .A(r97_ab_3__1_), .B(r97_CARRYB_2__1_), .CI(
        r97_SUMB_2__2_), .CO(r97_CARRYB_3__1_), .S(r97_SUMB_3__1_) );
  FA_X1 r97_S1_3_0 ( .A(r97_ab_3__0_), .B(r97_CARRYB_2__0_), .CI(
        r97_SUMB_2__1_), .CO(r97_CARRYB_3__0_), .S(s2[3]) );
  FA_X1 r97_S2_4_3 ( .A(r97_ab_4__3_), .B(r97_CARRYB_3__3_), .CI(
        r97_SUMB_3__4_), .S(r97_SUMB_4__3_) );
  FA_X1 r97_S2_4_2 ( .A(r97_ab_4__2_), .B(r97_CARRYB_3__2_), .CI(
        r97_SUMB_3__3_), .CO(r97_CARRYB_4__2_), .S(r97_SUMB_4__2_) );
  FA_X1 r97_S2_4_1 ( .A(r97_ab_4__1_), .B(r97_CARRYB_3__1_), .CI(
        r97_SUMB_3__2_), .CO(r97_CARRYB_4__1_), .S(r97_SUMB_4__1_) );
  FA_X1 r97_S1_4_0 ( .A(r97_ab_4__0_), .B(r97_CARRYB_3__0_), .CI(
        r97_SUMB_3__1_), .CO(r97_CARRYB_4__0_), .S(s2[4]) );
  FA_X1 r97_S2_5_2 ( .A(r97_ab_5__2_), .B(r97_CARRYB_4__2_), .CI(
        r97_SUMB_4__3_), .S(r97_SUMB_5__2_) );
  FA_X1 r97_S2_5_1 ( .A(r97_ab_5__1_), .B(r97_CARRYB_4__1_), .CI(
        r97_SUMB_4__2_), .CO(r97_CARRYB_5__1_), .S(r97_SUMB_5__1_) );
  FA_X1 r97_S1_5_0 ( .A(r97_ab_5__0_), .B(r97_CARRYB_4__0_), .CI(
        r97_SUMB_4__1_), .CO(r97_CARRYB_5__0_), .S(s2[5]) );
  FA_X1 r97_S2_6_1 ( .A(r97_ab_6__1_), .B(r97_CARRYB_5__1_), .CI(
        r97_SUMB_5__2_), .S(r97_SUMB_6__1_) );
  FA_X1 r97_S1_6_0 ( .A(r97_ab_6__0_), .B(r97_CARRYB_5__0_), .CI(
        r97_SUMB_5__1_), .CO(r97_CARRYB_6__0_), .S(s2[6]) );
  FA_X1 r97_S4_0 ( .A(r97_ab_7__0_), .B(r97_CARRYB_6__0_), .CI(r97_SUMB_6__1_), 
        .S(s2[7]) );
  NOR2_X1 mult_21_U64 ( .A1(mult_21_n29), .A2(mult_21_n28), .ZN(N32) );
  AND2_X1 mult_21_U63 ( .A1(N31), .A2(a[0]), .ZN(mult_21_ab_7__0_) );
  NOR2_X1 mult_21_U62 ( .A1(mult_21_n28), .A2(mult_21_n27), .ZN(
        mult_21_ab_6__0_) );
  NOR2_X1 mult_21_U61 ( .A1(mult_21_n27), .A2(mult_21_n26), .ZN(
        mult_21_ab_6__1_) );
  INV_X1 mult_21_U60 ( .A(N30), .ZN(mult_21_n27) );
  NOR2_X1 mult_21_U59 ( .A1(mult_21_n28), .A2(mult_21_n25), .ZN(
        mult_21_ab_5__0_) );
  NOR2_X1 mult_21_U58 ( .A1(mult_21_n26), .A2(mult_21_n25), .ZN(
        mult_21_ab_5__1_) );
  NOR2_X1 mult_21_U57 ( .A1(mult_21_n25), .A2(mult_21_n24), .ZN(
        mult_21_ab_5__2_) );
  INV_X1 mult_21_U56 ( .A(N29), .ZN(mult_21_n25) );
  NOR2_X1 mult_21_U55 ( .A1(mult_21_n28), .A2(mult_21_n23), .ZN(
        mult_21_ab_4__0_) );
  NOR2_X1 mult_21_U54 ( .A1(mult_21_n26), .A2(mult_21_n23), .ZN(
        mult_21_ab_4__1_) );
  NOR2_X1 mult_21_U53 ( .A1(mult_21_n24), .A2(mult_21_n23), .ZN(
        mult_21_ab_4__2_) );
  NOR2_X1 mult_21_U52 ( .A1(mult_21_n23), .A2(mult_21_n22), .ZN(
        mult_21_ab_4__3_) );
  INV_X1 mult_21_U51 ( .A(N28), .ZN(mult_21_n23) );
  NOR2_X1 mult_21_U50 ( .A1(mult_21_n28), .A2(mult_21_n21), .ZN(
        mult_21_ab_3__0_) );
  NOR2_X1 mult_21_U49 ( .A1(mult_21_n26), .A2(mult_21_n21), .ZN(
        mult_21_ab_3__1_) );
  NOR2_X1 mult_21_U48 ( .A1(mult_21_n24), .A2(mult_21_n21), .ZN(
        mult_21_ab_3__2_) );
  NOR2_X1 mult_21_U47 ( .A1(mult_21_n22), .A2(mult_21_n21), .ZN(
        mult_21_ab_3__3_) );
  NOR2_X1 mult_21_U46 ( .A1(mult_21_n21), .A2(mult_21_n20), .ZN(
        mult_21_ab_3__4_) );
  INV_X1 mult_21_U45 ( .A(N27), .ZN(mult_21_n21) );
  NOR2_X1 mult_21_U44 ( .A1(mult_21_n28), .A2(mult_21_n19), .ZN(
        mult_21_ab_2__0_) );
  NOR2_X1 mult_21_U43 ( .A1(mult_21_n26), .A2(mult_21_n19), .ZN(
        mult_21_ab_2__1_) );
  NOR2_X1 mult_21_U42 ( .A1(mult_21_n24), .A2(mult_21_n19), .ZN(
        mult_21_ab_2__2_) );
  NOR2_X1 mult_21_U41 ( .A1(mult_21_n22), .A2(mult_21_n19), .ZN(
        mult_21_ab_2__3_) );
  NOR2_X1 mult_21_U40 ( .A1(mult_21_n20), .A2(mult_21_n19), .ZN(
        mult_21_ab_2__4_) );
  NOR2_X1 mult_21_U39 ( .A1(mult_21_n19), .A2(mult_21_n18), .ZN(
        mult_21_ab_2__5_) );
  INV_X1 mult_21_U38 ( .A(N26), .ZN(mult_21_n19) );
  NOR2_X1 mult_21_U37 ( .A1(mult_21_n28), .A2(mult_21_n17), .ZN(
        mult_21_ab_1__0_) );
  INV_X1 mult_21_U36 ( .A(a[0]), .ZN(mult_21_n28) );
  NOR2_X1 mult_21_U35 ( .A1(mult_21_n29), .A2(mult_21_n26), .ZN(
        mult_21_ab_0__1_) );
  NOR2_X1 mult_21_U34 ( .A1(mult_21_n26), .A2(mult_21_n17), .ZN(
        mult_21_ab_1__1_) );
  INV_X1 mult_21_U33 ( .A(a[1]), .ZN(mult_21_n26) );
  NOR2_X1 mult_21_U32 ( .A1(mult_21_n29), .A2(mult_21_n24), .ZN(
        mult_21_ab_0__2_) );
  NOR2_X1 mult_21_U31 ( .A1(mult_21_n24), .A2(mult_21_n17), .ZN(
        mult_21_ab_1__2_) );
  INV_X1 mult_21_U30 ( .A(a[2]), .ZN(mult_21_n24) );
  NOR2_X1 mult_21_U29 ( .A1(mult_21_n29), .A2(mult_21_n22), .ZN(
        mult_21_ab_0__3_) );
  NOR2_X1 mult_21_U28 ( .A1(mult_21_n22), .A2(mult_21_n17), .ZN(
        mult_21_ab_1__3_) );
  INV_X1 mult_21_U27 ( .A(a[3]), .ZN(mult_21_n22) );
  NOR2_X1 mult_21_U26 ( .A1(mult_21_n29), .A2(mult_21_n20), .ZN(
        mult_21_ab_0__4_) );
  NOR2_X1 mult_21_U25 ( .A1(mult_21_n20), .A2(mult_21_n17), .ZN(
        mult_21_ab_1__4_) );
  INV_X1 mult_21_U24 ( .A(a[4]), .ZN(mult_21_n20) );
  NOR2_X1 mult_21_U23 ( .A1(mult_21_n29), .A2(mult_21_n18), .ZN(
        mult_21_ab_0__5_) );
  NOR2_X1 mult_21_U22 ( .A1(mult_21_n18), .A2(mult_21_n17), .ZN(
        mult_21_ab_1__5_) );
  INV_X1 mult_21_U21 ( .A(a[5]), .ZN(mult_21_n18) );
  NOR2_X1 mult_21_U20 ( .A1(mult_21_n29), .A2(mult_21_n16), .ZN(
        mult_21_ab_0__6_) );
  INV_X1 mult_21_U19 ( .A(N24), .ZN(mult_21_n29) );
  NOR2_X1 mult_21_U18 ( .A1(mult_21_n17), .A2(mult_21_n16), .ZN(
        mult_21_ab_1__6_) );
  INV_X1 mult_21_U17 ( .A(a[6]), .ZN(mult_21_n16) );
  INV_X1 mult_21_U16 ( .A(N25), .ZN(mult_21_n17) );
  NAND2_X1 mult_21_U15 ( .A1(a[7]), .A2(N24), .ZN(mult_21_n15) );
  XOR2_X1 mult_21_U14 ( .A(mult_21_ab_1__0_), .B(mult_21_ab_0__1_), .Z(N33) );
  AND2_X1 mult_21_U13 ( .A1(mult_21_ab_0__1_), .A2(mult_21_ab_1__0_), .ZN(
        mult_21_n13) );
  AND2_X1 mult_21_U12 ( .A1(mult_21_ab_0__2_), .A2(mult_21_ab_1__1_), .ZN(
        mult_21_n12) );
  AND2_X1 mult_21_U11 ( .A1(mult_21_ab_0__3_), .A2(mult_21_ab_1__2_), .ZN(
        mult_21_n11) );
  AND2_X1 mult_21_U10 ( .A1(mult_21_ab_0__4_), .A2(mult_21_ab_1__3_), .ZN(
        mult_21_n10) );
  AND2_X1 mult_21_U9 ( .A1(mult_21_ab_0__5_), .A2(mult_21_ab_1__4_), .ZN(
        mult_21_n9) );
  AND2_X1 mult_21_U8 ( .A1(mult_21_ab_0__6_), .A2(mult_21_ab_1__5_), .ZN(
        mult_21_n8) );
  XOR2_X1 mult_21_U7 ( .A(mult_21_ab_1__1_), .B(mult_21_ab_0__2_), .Z(
        mult_21_n7) );
  XOR2_X1 mult_21_U6 ( .A(mult_21_ab_1__2_), .B(mult_21_ab_0__3_), .Z(
        mult_21_n6) );
  XOR2_X1 mult_21_U5 ( .A(mult_21_ab_1__3_), .B(mult_21_ab_0__4_), .Z(
        mult_21_n5) );
  XOR2_X1 mult_21_U4 ( .A(mult_21_ab_1__4_), .B(mult_21_ab_0__5_), .Z(
        mult_21_n4) );
  XOR2_X1 mult_21_U3 ( .A(mult_21_ab_1__5_), .B(mult_21_ab_0__6_), .Z(
        mult_21_n3) );
  XNOR2_X1 mult_21_U2 ( .A(mult_21_n15), .B(mult_21_ab_1__6_), .ZN(mult_21_n2)
         );
  FA_X1 mult_21_S2_2_5 ( .A(mult_21_ab_2__5_), .B(mult_21_n8), .CI(mult_21_n2), 
        .S(mult_21_SUMB_2__5_) );
  FA_X1 mult_21_S2_2_4 ( .A(mult_21_ab_2__4_), .B(mult_21_n9), .CI(mult_21_n3), 
        .CO(mult_21_CARRYB_2__4_), .S(mult_21_SUMB_2__4_) );
  FA_X1 mult_21_S2_2_3 ( .A(mult_21_ab_2__3_), .B(mult_21_n10), .CI(mult_21_n4), .CO(mult_21_CARRYB_2__3_), .S(mult_21_SUMB_2__3_) );
  FA_X1 mult_21_S2_2_2 ( .A(mult_21_ab_2__2_), .B(mult_21_n11), .CI(mult_21_n5), .CO(mult_21_CARRYB_2__2_), .S(mult_21_SUMB_2__2_) );
  FA_X1 mult_21_S2_2_1 ( .A(mult_21_ab_2__1_), .B(mult_21_n12), .CI(mult_21_n6), .CO(mult_21_CARRYB_2__1_), .S(mult_21_SUMB_2__1_) );
  FA_X1 mult_21_S1_2_0 ( .A(mult_21_ab_2__0_), .B(mult_21_n13), .CI(mult_21_n7), .CO(mult_21_CARRYB_2__0_), .S(N34) );
  FA_X1 mult_21_S2_3_4 ( .A(mult_21_ab_3__4_), .B(mult_21_CARRYB_2__4_), .CI(
        mult_21_SUMB_2__5_), .S(mult_21_SUMB_3__4_) );
  FA_X1 mult_21_S2_3_3 ( .A(mult_21_ab_3__3_), .B(mult_21_CARRYB_2__3_), .CI(
        mult_21_SUMB_2__4_), .CO(mult_21_CARRYB_3__3_), .S(mult_21_SUMB_3__3_)
         );
  FA_X1 mult_21_S2_3_2 ( .A(mult_21_ab_3__2_), .B(mult_21_CARRYB_2__2_), .CI(
        mult_21_SUMB_2__3_), .CO(mult_21_CARRYB_3__2_), .S(mult_21_SUMB_3__2_)
         );
  FA_X1 mult_21_S2_3_1 ( .A(mult_21_ab_3__1_), .B(mult_21_CARRYB_2__1_), .CI(
        mult_21_SUMB_2__2_), .CO(mult_21_CARRYB_3__1_), .S(mult_21_SUMB_3__1_)
         );
  FA_X1 mult_21_S1_3_0 ( .A(mult_21_ab_3__0_), .B(mult_21_CARRYB_2__0_), .CI(
        mult_21_SUMB_2__1_), .CO(mult_21_CARRYB_3__0_), .S(N35) );
  FA_X1 mult_21_S2_4_3 ( .A(mult_21_ab_4__3_), .B(mult_21_CARRYB_3__3_), .CI(
        mult_21_SUMB_3__4_), .S(mult_21_SUMB_4__3_) );
  FA_X1 mult_21_S2_4_2 ( .A(mult_21_ab_4__2_), .B(mult_21_CARRYB_3__2_), .CI(
        mult_21_SUMB_3__3_), .CO(mult_21_CARRYB_4__2_), .S(mult_21_SUMB_4__2_)
         );
  FA_X1 mult_21_S2_4_1 ( .A(mult_21_ab_4__1_), .B(mult_21_CARRYB_3__1_), .CI(
        mult_21_SUMB_3__2_), .CO(mult_21_CARRYB_4__1_), .S(mult_21_SUMB_4__1_)
         );
  FA_X1 mult_21_S1_4_0 ( .A(mult_21_ab_4__0_), .B(mult_21_CARRYB_3__0_), .CI(
        mult_21_SUMB_3__1_), .CO(mult_21_CARRYB_4__0_), .S(N36) );
  FA_X1 mult_21_S2_5_2 ( .A(mult_21_ab_5__2_), .B(mult_21_CARRYB_4__2_), .CI(
        mult_21_SUMB_4__3_), .S(mult_21_SUMB_5__2_) );
  FA_X1 mult_21_S2_5_1 ( .A(mult_21_ab_5__1_), .B(mult_21_CARRYB_4__1_), .CI(
        mult_21_SUMB_4__2_), .CO(mult_21_CARRYB_5__1_), .S(mult_21_SUMB_5__1_)
         );
  FA_X1 mult_21_S1_5_0 ( .A(mult_21_ab_5__0_), .B(mult_21_CARRYB_4__0_), .CI(
        mult_21_SUMB_4__1_), .CO(mult_21_CARRYB_5__0_), .S(N37) );
  FA_X1 mult_21_S2_6_1 ( .A(mult_21_ab_6__1_), .B(mult_21_CARRYB_5__1_), .CI(
        mult_21_SUMB_5__2_), .S(mult_21_SUMB_6__1_) );
  FA_X1 mult_21_S1_6_0 ( .A(mult_21_ab_6__0_), .B(mult_21_CARRYB_5__0_), .CI(
        mult_21_SUMB_5__1_), .CO(mult_21_CARRYB_6__0_), .S(N38) );
  FA_X1 mult_21_S4_0 ( .A(mult_21_ab_7__0_), .B(mult_21_CARRYB_6__0_), .CI(
        mult_21_SUMB_6__1_), .S(N39) );
  XOR2_X1 add_1_root_add_0_root_sub_21_U2 ( .A(N48), .B(c[0]), .Z(N40) );
  AND2_X1 add_1_root_add_0_root_sub_21_U1 ( .A1(N48), .A2(c[0]), .ZN(
        add_1_root_add_0_root_sub_21_n1) );
  FA_X1 add_1_root_add_0_root_sub_21_U1_1 ( .A(c[1]), .B(N49), .CI(
        add_1_root_add_0_root_sub_21_n1), .CO(
        add_1_root_add_0_root_sub_21_carry[2]), .S(N41) );
  FA_X1 add_1_root_add_0_root_sub_21_U1_2 ( .A(c[2]), .B(N50), .CI(
        add_1_root_add_0_root_sub_21_carry[2]), .CO(
        add_1_root_add_0_root_sub_21_carry[3]), .S(N42) );
  FA_X1 add_1_root_add_0_root_sub_21_U1_3 ( .A(c[3]), .B(N51), .CI(
        add_1_root_add_0_root_sub_21_carry[3]), .CO(
        add_1_root_add_0_root_sub_21_carry[4]), .S(N43) );
  FA_X1 add_1_root_add_0_root_sub_21_U1_4 ( .A(c[4]), .B(N52), .CI(
        add_1_root_add_0_root_sub_21_carry[4]), .CO(
        add_1_root_add_0_root_sub_21_carry[5]), .S(N44) );
  FA_X1 add_1_root_add_0_root_sub_21_U1_5 ( .A(c[5]), .B(N53), .CI(
        add_1_root_add_0_root_sub_21_carry[5]), .CO(
        add_1_root_add_0_root_sub_21_carry[6]), .S(N45) );
  FA_X1 add_1_root_add_0_root_sub_21_U1_6 ( .A(c[6]), .B(N54), .CI(
        add_1_root_add_0_root_sub_21_carry[6]), .CO(
        add_1_root_add_0_root_sub_21_carry[7]), .S(N46) );
  FA_X1 add_1_root_add_0_root_sub_21_U1_7 ( .A(c[7]), .B(N55), .CI(
        add_1_root_add_0_root_sub_21_carry[7]), .S(N47) );
  XOR2_X1 add_0_root_add_0_root_sub_21_U2 ( .A(N32), .B(N40), .Z(s6[0]) );
  AND2_X1 add_0_root_add_0_root_sub_21_U1 ( .A1(N32), .A2(N40), .ZN(
        add_0_root_add_0_root_sub_21_n1) );
  FA_X1 add_0_root_add_0_root_sub_21_U1_1 ( .A(N41), .B(N33), .CI(
        add_0_root_add_0_root_sub_21_n1), .CO(
        add_0_root_add_0_root_sub_21_carry[2]), .S(s6[1]) );
  FA_X1 add_0_root_add_0_root_sub_21_U1_2 ( .A(N42), .B(N34), .CI(
        add_0_root_add_0_root_sub_21_carry[2]), .CO(
        add_0_root_add_0_root_sub_21_carry[3]), .S(s6[2]) );
  FA_X1 add_0_root_add_0_root_sub_21_U1_3 ( .A(N43), .B(N35), .CI(
        add_0_root_add_0_root_sub_21_carry[3]), .CO(
        add_0_root_add_0_root_sub_21_carry[4]), .S(s6[3]) );
  FA_X1 add_0_root_add_0_root_sub_21_U1_4 ( .A(N44), .B(N36), .CI(
        add_0_root_add_0_root_sub_21_carry[4]), .CO(
        add_0_root_add_0_root_sub_21_carry[5]), .S(s6[4]) );
  FA_X1 add_0_root_add_0_root_sub_21_U1_5 ( .A(N45), .B(N37), .CI(
        add_0_root_add_0_root_sub_21_carry[5]), .CO(
        add_0_root_add_0_root_sub_21_carry[6]), .S(s6[5]) );
  FA_X1 add_0_root_add_0_root_sub_21_U1_6 ( .A(N46), .B(N38), .CI(
        add_0_root_add_0_root_sub_21_carry[6]), .CO(
        add_0_root_add_0_root_sub_21_carry[7]), .S(s6[6]) );
  FA_X1 add_0_root_add_0_root_sub_21_U1_7 ( .A(N47), .B(N39), .CI(
        add_0_root_add_0_root_sub_21_carry[7]), .S(s6[7]) );
  XOR2_X1 add_1_root_add_0_root_add_19_2_U2 ( .A(d[0]), .B(c[0]), .Z(N8) );
  AND2_X1 add_1_root_add_0_root_add_19_2_U1 ( .A1(d[0]), .A2(c[0]), .ZN(
        add_1_root_add_0_root_add_19_2_n1) );
  FA_X1 add_1_root_add_0_root_add_19_2_U1_1 ( .A(c[1]), .B(d[1]), .CI(
        add_1_root_add_0_root_add_19_2_n1), .CO(
        add_1_root_add_0_root_add_19_2_carry[2]), .S(N9) );
  FA_X1 add_1_root_add_0_root_add_19_2_U1_2 ( .A(c[2]), .B(d[2]), .CI(
        add_1_root_add_0_root_add_19_2_carry[2]), .CO(
        add_1_root_add_0_root_add_19_2_carry[3]), .S(N10) );
  FA_X1 add_1_root_add_0_root_add_19_2_U1_3 ( .A(c[3]), .B(d[3]), .CI(
        add_1_root_add_0_root_add_19_2_carry[3]), .CO(
        add_1_root_add_0_root_add_19_2_carry[4]), .S(N11) );
  FA_X1 add_1_root_add_0_root_add_19_2_U1_4 ( .A(c[4]), .B(d[4]), .CI(
        add_1_root_add_0_root_add_19_2_carry[4]), .CO(
        add_1_root_add_0_root_add_19_2_carry[5]), .S(N12) );
  FA_X1 add_1_root_add_0_root_add_19_2_U1_5 ( .A(c[5]), .B(d[5]), .CI(
        add_1_root_add_0_root_add_19_2_carry[5]), .CO(
        add_1_root_add_0_root_add_19_2_carry[6]), .S(N13) );
  FA_X1 add_1_root_add_0_root_add_19_2_U1_6 ( .A(c[6]), .B(d[6]), .CI(
        add_1_root_add_0_root_add_19_2_carry[6]), .CO(
        add_1_root_add_0_root_add_19_2_carry[7]), .S(N14) );
  FA_X1 add_1_root_add_0_root_add_19_2_U1_7 ( .A(c[7]), .B(d[7]), .CI(
        add_1_root_add_0_root_add_19_2_carry[7]), .S(N15) );
  XOR2_X1 add_0_root_add_0_root_add_19_2_U2 ( .A(s2[0]), .B(N8), .Z(s4[0]) );
  AND2_X1 add_0_root_add_0_root_add_19_2_U1 ( .A1(s2[0]), .A2(N8), .ZN(
        add_0_root_add_0_root_add_19_2_n1) );
  FA_X1 add_0_root_add_0_root_add_19_2_U1_1 ( .A(N9), .B(s2[1]), .CI(
        add_0_root_add_0_root_add_19_2_n1), .CO(
        add_0_root_add_0_root_add_19_2_carry[2]), .S(s4[1]) );
  FA_X1 add_0_root_add_0_root_add_19_2_U1_2 ( .A(N10), .B(s2[2]), .CI(
        add_0_root_add_0_root_add_19_2_carry[2]), .CO(
        add_0_root_add_0_root_add_19_2_carry[3]), .S(s4[2]) );
  FA_X1 add_0_root_add_0_root_add_19_2_U1_3 ( .A(N11), .B(s2[3]), .CI(
        add_0_root_add_0_root_add_19_2_carry[3]), .CO(
        add_0_root_add_0_root_add_19_2_carry[4]), .S(s4[3]) );
  FA_X1 add_0_root_add_0_root_add_19_2_U1_4 ( .A(N12), .B(s2[4]), .CI(
        add_0_root_add_0_root_add_19_2_carry[4]), .CO(
        add_0_root_add_0_root_add_19_2_carry[5]), .S(s4[4]) );
  FA_X1 add_0_root_add_0_root_add_19_2_U1_5 ( .A(N13), .B(s2[5]), .CI(
        add_0_root_add_0_root_add_19_2_carry[5]), .CO(
        add_0_root_add_0_root_add_19_2_carry[6]), .S(s4[5]) );
  FA_X1 add_0_root_add_0_root_add_19_2_U1_6 ( .A(N14), .B(s2[6]), .CI(
        add_0_root_add_0_root_add_19_2_carry[6]), .CO(
        add_0_root_add_0_root_add_19_2_carry[7]), .S(s4[6]) );
  FA_X1 add_0_root_add_0_root_add_19_2_U1_7 ( .A(N15), .B(s2[7]), .CI(
        add_0_root_add_0_root_add_19_2_carry[7]), .S(s4[7]) );
  INV_X1 add_18_U78 ( .A(add_18_n59), .ZN(add_18_n31) );
  INV_X1 add_18_U77 ( .A(add_18_n64), .ZN(add_18_n41) );
  INV_X1 add_18_U76 ( .A(add_18_n45), .ZN(add_18_n54) );
  INV_X1 add_18_U75 ( .A(add_18_n46), .ZN(add_18_n51) );
  INV_X1 add_18_U74 ( .A(add_18_n34), .ZN(add_18_n44) );
  XNOR2_X1 add_18_U73 ( .A(add_18_n42), .B(add_18_n43), .ZN(s3[6]) );
  INV_X1 add_18_U72 ( .A(add_18_n37), .ZN(add_18_n36) );
  INV_X1 add_18_U71 ( .A(add_18_n1), .ZN(add_18_n28) );
  NOR2_X1 add_18_U70 ( .A1(add_18_n32), .A2(add_18_n31), .ZN(add_18_n29) );
  XNOR2_X1 add_18_U69 ( .A(add_18_n23), .B(add_18_n24), .ZN(s3[7]) );
  NAND2_X1 add_18_U68 ( .A1(N0), .A2(d[0]), .ZN(add_18_n61) );
  INV_X1 add_18_U67 ( .A(add_18_n18), .ZN(add_18_n70) );
  NAND2_X1 add_18_U66 ( .A1(add_18_n60), .A2(add_18_n61), .ZN(add_18_n30) );
  AOI21_X1 add_18_U65 ( .B1(add_18_n48), .B2(add_18_n47), .A(add_18_n54), .ZN(
        add_18_n49) );
  XNOR2_X1 add_18_U64 ( .A(add_18_n14), .B(add_18_n55), .ZN(s3[4]) );
  NAND2_X1 add_18_U63 ( .A1(N1), .A2(d[1]), .ZN(add_18_n60) );
  NAND2_X1 add_18_U62 ( .A1(add_18_n57), .A2(add_18_n56), .ZN(add_18_n48) );
  NOR2_X1 add_18_U61 ( .A1(add_18_n58), .A2(add_18_n3), .ZN(add_18_n57) );
  XNOR2_X1 add_18_U60 ( .A(add_18_n49), .B(add_18_n50), .ZN(s3[5]) );
  NAND2_X1 add_18_U59 ( .A1(d[3]), .A2(N3), .ZN(add_18_n64) );
  AOI21_X1 add_18_U58 ( .B1(add_18_n38), .B2(add_18_n22), .A(add_18_n39), .ZN(
        add_18_n25) );
  NAND2_X1 add_18_U57 ( .A1(d[4]), .A2(N4), .ZN(add_18_n45) );
  NOR2_X1 add_18_U56 ( .A1(add_18_n40), .A2(add_18_n33), .ZN(add_18_n39) );
  NOR2_X1 add_18_U55 ( .A1(add_18_n32), .A2(add_18_n33), .ZN(add_18_n38) );
  OAI21_X1 add_18_U54 ( .B1(add_18_n15), .B2(add_18_n2), .A(add_18_n44), .ZN(
        add_18_n42) );
  NAND2_X1 add_18_U53 ( .A1(add_18_n65), .A2(add_18_n16), .ZN(add_18_n67) );
  NAND2_X1 add_18_U52 ( .A1(N2), .A2(d[2]), .ZN(add_18_n65) );
  NAND3_X1 add_18_U51 ( .A1(add_18_n25), .A2(add_18_n27), .A3(add_18_n26), 
        .ZN(add_18_n23) );
  INV_X1 add_18_U50 ( .A(d[0]), .ZN(add_18_n69) );
  NAND2_X1 add_18_U49 ( .A1(add_18_n70), .A2(add_18_n69), .ZN(add_18_n68) );
  NAND2_X1 add_18_U48 ( .A1(d[6]), .A2(N6), .ZN(add_18_n37) );
  NAND2_X1 add_18_U47 ( .A1(d[5]), .A2(N5), .ZN(add_18_n46) );
  INV_X1 add_18_U46 ( .A(N5), .ZN(add_18_n53) );
  INV_X1 add_18_U45 ( .A(d[5]), .ZN(add_18_n52) );
  XNOR2_X1 add_18_U44 ( .A(d[7]), .B(N7), .ZN(add_18_n24) );
  XNOR2_X1 add_18_U43 ( .A(add_18_n8), .B(add_18_n67), .ZN(s3[2]) );
  NAND2_X1 add_18_U42 ( .A1(add_18_n45), .A2(add_18_n47), .ZN(add_18_n55) );
  AOI21_X1 add_18_U41 ( .B1(add_18_n34), .B2(add_18_n13), .A(add_18_n36), .ZN(
        add_18_n26) );
  OAI21_X1 add_18_U40 ( .B1(add_18_n4), .B2(add_18_n45), .A(add_18_n46), .ZN(
        add_18_n34) );
  NAND2_X1 add_18_U39 ( .A1(add_18_n41), .A2(add_18_n35), .ZN(add_18_n40) );
  NOR2_X1 add_18_U38 ( .A1(add_18_n4), .A2(add_18_n51), .ZN(add_18_n50) );
  NAND2_X1 add_18_U37 ( .A1(add_18_n37), .A2(add_18_n13), .ZN(add_18_n43) );
  INV_X1 add_18_U36 ( .A(add_18_n22), .ZN(add_18_n56) );
  NAND2_X1 add_18_U35 ( .A1(add_18_n59), .A2(add_18_n20), .ZN(add_18_n21) );
  XNOR2_X1 add_18_U34 ( .A(add_18_n21), .B(add_18_n19), .ZN(s3[1]) );
  AND2_X1 add_18_U33 ( .A1(add_18_n10), .A2(add_18_n17), .ZN(add_18_n22) );
  OR2_X1 add_18_U32 ( .A1(d[3]), .A2(N3), .ZN(add_18_n63) );
  OR2_X1 add_18_U31 ( .A1(N3), .A2(d[3]), .ZN(add_18_n17) );
  OR2_X1 add_18_U30 ( .A1(N2), .A2(d[2]), .ZN(add_18_n62) );
  OR2_X1 add_18_U29 ( .A1(N2), .A2(d[2]), .ZN(add_18_n16) );
  OR2_X2 add_18_U28 ( .A1(N1), .A2(d[1]), .ZN(add_18_n59) );
  OR2_X1 add_18_U27 ( .A1(N6), .A2(d[6]), .ZN(add_18_n35) );
  AND2_X1 add_18_U26 ( .A1(add_18_n63), .A2(add_18_n62), .ZN(add_18_n12) );
  AND4_X1 add_18_U25 ( .A1(add_18_n30), .A2(add_18_n63), .A3(add_18_n62), .A4(
        add_18_n59), .ZN(add_18_n58) );
  NAND4_X1 add_18_U24 ( .A1(add_18_n29), .A2(add_18_n28), .A3(add_18_n30), 
        .A4(add_18_n12), .ZN(add_18_n27) );
  NOR3_X1 add_18_U23 ( .A1(add_18_n9), .A2(add_18_n22), .A3(add_18_n3), .ZN(
        add_18_n15) );
  INV_X1 add_18_U22 ( .A(add_18_n13), .ZN(add_18_n32) );
  INV_X1 add_18_U21 ( .A(add_18_n65), .ZN(add_18_n10) );
  AOI21_X1 add_18_U20 ( .B1(add_18_n66), .B2(add_18_n16), .A(add_18_n10), .ZN(
        add_18_n11) );
  AND4_X1 add_18_U19 ( .A1(add_18_n30), .A2(add_18_n63), .A3(add_18_n62), .A4(
        add_18_n59), .ZN(add_18_n9) );
  BUF_X1 add_18_U18 ( .A(add_18_n48), .Z(add_18_n14) );
  OAI21_X1 add_18_U17 ( .B1(add_18_n6), .B2(add_18_n31), .A(add_18_n20), .ZN(
        add_18_n66) );
  OAI21_X1 add_18_U16 ( .B1(add_18_n6), .B2(add_18_n31), .A(add_18_n20), .ZN(
        add_18_n8) );
  AND2_X1 add_18_U15 ( .A1(add_18_n64), .A2(add_18_n17), .ZN(add_18_n7) );
  XNOR2_X1 add_18_U14 ( .A(add_18_n11), .B(add_18_n7), .ZN(s3[3]) );
  NAND2_X1 add_18_U13 ( .A1(add_18_n18), .A2(d[0]), .ZN(add_18_n6) );
  BUF_X1 add_18_U12 ( .A(N0), .Z(add_18_n18) );
  BUF_X1 add_18_U11 ( .A(add_18_n60), .Z(add_18_n20) );
  AND2_X1 add_18_U10 ( .A1(add_18_n18), .A2(d[0]), .ZN(add_18_n19) );
  AND2_X1 add_18_U9 ( .A1(add_18_n6), .A2(add_18_n68), .ZN(s3[0]) );
  AND2_X1 add_18_U8 ( .A1(add_18_n52), .A2(add_18_n53), .ZN(add_18_n4) );
  OR2_X1 add_18_U7 ( .A1(d[4]), .A2(N4), .ZN(add_18_n47) );
  OR2_X2 add_18_U6 ( .A1(N6), .A2(d[6]), .ZN(add_18_n13) );
  BUF_X1 add_18_U5 ( .A(add_18_n41), .Z(add_18_n3) );
  OAI22_X1 add_18_U4 ( .A1(d[5]), .A2(N5), .B1(d[4]), .B2(N4), .ZN(add_18_n33)
         );
  INV_X1 add_18_U3 ( .A(add_18_n28), .ZN(add_18_n2) );
  OAI22_X1 add_18_U2 ( .A1(d[5]), .A2(N5), .B1(d[4]), .B2(N4), .ZN(add_18_n1)
         );
  MUX2_X1 rem_18_U310 ( .A(a[0]), .B(rem_18_u_div_SumTmp_0__0_), .S(
        rem_18_n102), .Z(N0) );
  MUX2_X1 rem_18_U309 ( .A(rem_18_n62), .B(rem_18_u_div_SumTmp_0__1_), .S(
        rem_18_u_div_CryTmp_0__8_), .Z(N1) );
  MUX2_X1 rem_18_U308 ( .A(rem_18_n222), .B(rem_18_n27), .S(rem_18_n36), .Z(
        rem_18_n236) );
  INV_X1 rem_18_U307 ( .A(rem_18_n236), .ZN(rem_18_u_div_PartRem_1__2_) );
  MUX2_X1 rem_18_U306 ( .A(rem_18_u_div_PartRem_1__2_), .B(
        rem_18_u_div_SumTmp_0__2_), .S(rem_18_n102), .Z(N2) );
  MUX2_X1 rem_18_U305 ( .A(rem_18_n216), .B(rem_18_n23), .S(rem_18_n190), .Z(
        rem_18_n221) );
  MUX2_X1 rem_18_U304 ( .A(rem_18_n221), .B(rem_18_n235), .S(rem_18_n36), .Z(
        rem_18_n234) );
  MUX2_X1 rem_18_U303 ( .A(rem_18_n211), .B(rem_18_n16), .S(rem_18_n187), .Z(
        rem_18_n215) );
  MUX2_X1 rem_18_U302 ( .A(rem_18_n215), .B(rem_18_n232), .S(rem_18_n190), .Z(
        rem_18_n220) );
  MUX2_X1 rem_18_U301 ( .A(rem_18_n220), .B(rem_18_n28), .S(rem_18_n36), .Z(
        rem_18_n231) );
  INV_X1 rem_18_U300 ( .A(rem_18_n231), .ZN(rem_18_u_div_PartRem_1__4_) );
  MUX2_X1 rem_18_U299 ( .A(rem_18_u_div_PartRem_1__4_), .B(
        rem_18_u_div_SumTmp_0__4_), .S(rem_18_u_div_CryTmp_0__8_), .Z(N4) );
  INV_X2 rem_18_U298 ( .A(b[3]), .ZN(rem_18_u_div_BInv[3]) );
  MUX2_X1 rem_18_U297 ( .A(rem_18_n63), .B(rem_18_n15), .S(rem_18_n188), .Z(
        rem_18_n210) );
  MUX2_X1 rem_18_U296 ( .A(rem_18_n210), .B(rem_18_n17), .S(rem_18_n187), .Z(
        rem_18_n214) );
  MUX2_X1 rem_18_U295 ( .A(rem_18_n214), .B(rem_18_n21), .S(rem_18_n190), .Z(
        rem_18_n219) );
  MUX2_X1 rem_18_U294 ( .A(rem_18_n219), .B(rem_18_n26), .S(rem_18_n36), .Z(
        rem_18_n230) );
  INV_X1 rem_18_U293 ( .A(rem_18_n230), .ZN(rem_18_u_div_PartRem_1__5_) );
  MUX2_X1 rem_18_U292 ( .A(rem_18_u_div_PartRem_1__5_), .B(
        rem_18_u_div_SumTmp_0__5_), .S(rem_18_n102), .Z(N5) );
  MUX2_X1 rem_18_U291 ( .A(rem_18_n107), .B(rem_18_n14), .S(rem_18_n189), .Z(
        rem_18_n206) );
  MUX2_X1 rem_18_U290 ( .A(rem_18_n206), .B(rem_18_n229), .S(rem_18_n188), .Z(
        rem_18_n209) );
  MUX2_X1 rem_18_U289 ( .A(rem_18_n209), .B(rem_18_n18), .S(rem_18_n187), .Z(
        rem_18_n213) );
  MUX2_X1 rem_18_U288 ( .A(rem_18_n213), .B(rem_18_n22), .S(rem_18_n190), .Z(
        rem_18_n218) );
  MUX2_X1 rem_18_U287 ( .A(rem_18_n218), .B(rem_18_n25), .S(rem_18_n36), .Z(
        rem_18_n228) );
  INV_X1 rem_18_U286 ( .A(rem_18_n228), .ZN(rem_18_u_div_PartRem_1__6_) );
  MUX2_X1 rem_18_U285 ( .A(rem_18_n202), .B(rem_18_n226), .S(rem_18_n227), .Z(
        rem_18_n203) );
  MUX2_X1 rem_18_U284 ( .A(rem_18_n203), .B(rem_18_n225), .S(rem_18_n189), .Z(
        rem_18_n205) );
  MUX2_X1 rem_18_U283 ( .A(rem_18_n205), .B(rem_18_n224), .S(rem_18_n43), .Z(
        rem_18_n208) );
  MUX2_X1 rem_18_U282 ( .A(rem_18_n208), .B(rem_18_n19), .S(rem_18_n187), .Z(
        rem_18_n212) );
  MUX2_X1 rem_18_U281 ( .A(rem_18_n212), .B(rem_18_n20), .S(rem_18_n190), .Z(
        rem_18_n217) );
  MUX2_X1 rem_18_U280 ( .A(rem_18_n217), .B(rem_18_n24), .S(rem_18_n36), .Z(
        rem_18_n223) );
  INV_X1 rem_18_U279 ( .A(rem_18_n223), .ZN(rem_18_u_div_PartRem_1__7_) );
  MUX2_X1 rem_18_U278 ( .A(rem_18_u_div_PartRem_1__7_), .B(
        rem_18_u_div_SumTmp_0__7_), .S(rem_18_n102), .Z(N7) );
  INV_X2 rem_18_U277 ( .A(b[1]), .ZN(rem_18_u_div_BInv[1]) );
  INV_X1 rem_18_U276 ( .A(rem_18_n221), .ZN(rem_18_u_div_PartRem_2__2_) );
  INV_X1 rem_18_U275 ( .A(rem_18_n220), .ZN(rem_18_u_div_PartRem_2__3_) );
  INV_X1 rem_18_U274 ( .A(rem_18_n219), .ZN(rem_18_u_div_PartRem_2__4_) );
  INV_X1 rem_18_U273 ( .A(rem_18_n218), .ZN(rem_18_u_div_PartRem_2__5_) );
  INV_X1 rem_18_U272 ( .A(rem_18_n217), .ZN(rem_18_u_div_PartRem_2__6_) );
  INV_X1 rem_18_U271 ( .A(rem_18_n215), .ZN(rem_18_u_div_PartRem_3__2_) );
  INV_X1 rem_18_U270 ( .A(rem_18_n214), .ZN(rem_18_u_div_PartRem_3__3_) );
  INV_X1 rem_18_U269 ( .A(rem_18_n213), .ZN(rem_18_u_div_PartRem_3__4_) );
  INV_X1 rem_18_U268 ( .A(rem_18_n212), .ZN(rem_18_u_div_PartRem_3__5_) );
  INV_X1 rem_18_U267 ( .A(rem_18_n210), .ZN(rem_18_u_div_PartRem_4__2_) );
  INV_X1 rem_18_U266 ( .A(rem_18_n209), .ZN(rem_18_u_div_PartRem_4__3_) );
  INV_X1 rem_18_U265 ( .A(rem_18_n208), .ZN(rem_18_u_div_PartRem_4__4_) );
  INV_X1 rem_18_U264 ( .A(rem_18_n206), .ZN(rem_18_u_div_PartRem_5__2_) );
  INV_X1 rem_18_U263 ( .A(rem_18_n205), .ZN(rem_18_u_div_PartRem_5__3_) );
  INV_X1 rem_18_U262 ( .A(rem_18_n203), .ZN(rem_18_u_div_PartRem_6__2_) );
  MUX2_X2 rem_18_U261 ( .A(a[1]), .B(rem_18_u_div_SumTmp_1__0_), .S(
        rem_18_n237), .Z(rem_18_u_div_PartRem_1__1_) );
  INV_X1 rem_18_U260 ( .A(b[7]), .ZN(rem_18_u_div_BInv[7]) );
  AND2_X1 rem_18_U259 ( .A1(rem_18_n79), .A2(rem_18_u_div_BInv[7]), .ZN(
        rem_18_n237) );
  INV_X1 rem_18_U258 ( .A(b[0]), .ZN(rem_18_n200) );
  XNOR2_X1 rem_18_U257 ( .A(rem_18_n199), .B(a[2]), .ZN(
        rem_18_u_div_SumTmp_2__0_) );
  XNOR2_X1 rem_18_U256 ( .A(rem_18_n200), .B(a[3]), .ZN(
        rem_18_u_div_SumTmp_3__0_) );
  XNOR2_X1 rem_18_U255 ( .A(rem_18_n199), .B(a[4]), .ZN(
        rem_18_u_div_SumTmp_4__0_) );
  XNOR2_X1 rem_18_U254 ( .A(rem_18_n199), .B(a[7]), .ZN(
        rem_18_u_div_SumTmp_7__0_) );
  XNOR2_X1 rem_18_U253 ( .A(rem_18_n200), .B(a[1]), .ZN(
        rem_18_u_div_SumTmp_1__0_) );
  INV_X1 rem_18_U252 ( .A(a[6]), .ZN(rem_18_n191) );
  NAND2_X1 rem_18_U251 ( .A1(rem_18_n194), .A2(rem_18_n191), .ZN(
        rem_18_u_div_CryTmp_6__1_) );
  XNOR2_X1 rem_18_U250 ( .A(rem_18_n199), .B(a[0]), .ZN(
        rem_18_u_div_SumTmp_0__0_) );
  NOR2_X1 rem_18_U249 ( .A1(b[5]), .A2(b[4]), .ZN(rem_18_n233) );
  OR2_X1 rem_18_U248 ( .A1(rem_18_n199), .A2(a[0]), .ZN(
        rem_18_u_div_CryTmp_0__1_) );
  INV_X1 rem_18_U247 ( .A(a[1]), .ZN(rem_18_n198) );
  NAND2_X1 rem_18_U246 ( .A1(rem_18_n197), .A2(rem_18_n198), .ZN(
        rem_18_u_div_CryTmp_1__1_) );
  INV_X1 rem_18_U245 ( .A(a[2]), .ZN(rem_18_n196) );
  NAND2_X1 rem_18_U244 ( .A1(rem_18_n197), .A2(rem_18_n196), .ZN(
        rem_18_u_div_CryTmp_2__1_) );
  INV_X1 rem_18_U243 ( .A(a[3]), .ZN(rem_18_n195) );
  NAND2_X1 rem_18_U242 ( .A1(rem_18_n194), .A2(rem_18_n195), .ZN(
        rem_18_u_div_CryTmp_3__1_) );
  INV_X1 rem_18_U241 ( .A(a[4]), .ZN(rem_18_n193) );
  NAND2_X1 rem_18_U240 ( .A1(b[0]), .A2(rem_18_n193), .ZN(
        rem_18_u_div_CryTmp_4__1_) );
  INV_X1 rem_18_U239 ( .A(a[5]), .ZN(rem_18_n192) );
  NAND2_X1 rem_18_U238 ( .A1(rem_18_n194), .A2(rem_18_n192), .ZN(
        rem_18_u_div_CryTmp_5__1_) );
  INV_X1 rem_18_U237 ( .A(rem_18_n200), .ZN(rem_18_n197) );
  INV_X1 rem_18_U236 ( .A(rem_18_n200), .ZN(rem_18_n194) );
  INV_X1 rem_18_U235 ( .A(rem_18_u_div_SumTmp_6__1_), .ZN(rem_18_n226) );
  AND2_X1 rem_18_U234 ( .A1(rem_18_u_div_CryTmp_2__6_), .A2(rem_18_n201), .ZN(
        rem_18_n190) );
  INV_X1 rem_18_U233 ( .A(rem_18_u_div_SumTmp_4__3_), .ZN(rem_18_n224) );
  INV_X1 rem_18_U232 ( .A(rem_18_u_div_SumTmp_5__2_), .ZN(rem_18_n225) );
  INV_X1 rem_18_U231 ( .A(rem_18_u_div_SumTmp_4__2_), .ZN(rem_18_n229) );
  INV_X1 rem_18_U230 ( .A(rem_18_u_div_SumTmp_2__2_), .ZN(rem_18_n232) );
  INV_X1 rem_18_U229 ( .A(rem_18_u_div_SumTmp_1__2_), .ZN(rem_18_n235) );
  AND2_X1 rem_18_U228 ( .A1(rem_18_u_div_CryTmp_5__3_), .A2(rem_18_n114), .ZN(
        rem_18_n189) );
  AND2_X1 rem_18_U227 ( .A1(rem_18_u_div_CryTmp_4__4_), .A2(rem_18_n123), .ZN(
        rem_18_n188) );
  INV_X2 rem_18_U226 ( .A(b[5]), .ZN(rem_18_u_div_BInv[5]) );
  NAND3_X1 rem_18_U225 ( .A1(rem_18_n182), .A2(rem_18_n183), .A3(rem_18_n184), 
        .ZN(rem_18_u_div_CryTmp_3__3_) );
  NAND2_X1 rem_18_U224 ( .A1(rem_18_u_div_PartRem_4__2_), .A2(
        rem_18_u_div_BInv[2]), .ZN(rem_18_n184) );
  NAND2_X1 rem_18_U223 ( .A1(rem_18_u_div_CryTmp_3__2_), .A2(
        rem_18_u_div_BInv[2]), .ZN(rem_18_n183) );
  NAND2_X1 rem_18_U222 ( .A1(rem_18_n55), .A2(rem_18_u_div_PartRem_4__2_), 
        .ZN(rem_18_n182) );
  XOR2_X1 rem_18_U221 ( .A(rem_18_u_div_PartRem_4__2_), .B(
        rem_18_u_div_BInv[2]), .Z(rem_18_n181) );
  NAND2_X1 rem_18_U220 ( .A1(rem_18_u_div_CryTmp_1__6_), .A2(
        rem_18_u_div_BInv[6]), .ZN(rem_18_n180) );
  NAND2_X1 rem_18_U219 ( .A1(rem_18_u_div_PartRem_2__6_), .A2(rem_18_n101), 
        .ZN(rem_18_n179) );
  NAND2_X1 rem_18_U218 ( .A1(rem_18_u_div_PartRem_2__6_), .A2(rem_18_n4), .ZN(
        rem_18_n178) );
  XOR2_X1 rem_18_U217 ( .A(rem_18_u_div_PartRem_2__6_), .B(rem_18_n3), .Z(
        rem_18_n177) );
  NAND3_X1 rem_18_U216 ( .A1(rem_18_n176), .A2(rem_18_n175), .A3(rem_18_n174), 
        .ZN(rem_18_u_div_CryTmp_1__6_) );
  NAND2_X1 rem_18_U215 ( .A1(rem_18_n56), .A2(rem_18_u_div_BInv[5]), .ZN(
        rem_18_n176) );
  NAND2_X1 rem_18_U214 ( .A1(rem_18_u_div_PartRem_2__5_), .A2(
        rem_18_u_div_CryTmp_1__5_), .ZN(rem_18_n175) );
  NAND2_X1 rem_18_U213 ( .A1(rem_18_u_div_PartRem_2__5_), .A2(
        rem_18_u_div_BInv[5]), .ZN(rem_18_n174) );
  XOR2_X1 rem_18_U212 ( .A(rem_18_u_div_PartRem_2__5_), .B(
        rem_18_u_div_BInv[5]), .Z(rem_18_n173) );
  NAND3_X1 rem_18_U211 ( .A1(rem_18_n170), .A2(rem_18_n171), .A3(rem_18_n172), 
        .ZN(rem_18_u_div_CryTmp_0__6_) );
  NAND2_X1 rem_18_U210 ( .A1(rem_18_u_div_PartRem_1__5_), .A2(
        rem_18_u_div_BInv[5]), .ZN(rem_18_n172) );
  NAND2_X1 rem_18_U209 ( .A1(rem_18_n75), .A2(rem_18_u_div_BInv[5]), .ZN(
        rem_18_n171) );
  NAND2_X1 rem_18_U208 ( .A1(rem_18_n50), .A2(rem_18_u_div_PartRem_1__5_), 
        .ZN(rem_18_n170) );
  XOR2_X1 rem_18_U207 ( .A(rem_18_n76), .B(rem_18_n169), .Z(
        rem_18_u_div_SumTmp_0__5_) );
  XOR2_X1 rem_18_U206 ( .A(rem_18_u_div_PartRem_1__5_), .B(
        rem_18_u_div_BInv[5]), .Z(rem_18_n169) );
  INV_X1 rem_18_U205 ( .A(rem_18_n108), .ZN(rem_18_n211) );
  INV_X2 rem_18_U204 ( .A(b[2]), .ZN(rem_18_u_div_BInv[2]) );
  NAND3_X1 rem_18_U203 ( .A1(rem_18_n163), .A2(rem_18_n164), .A3(rem_18_n165), 
        .ZN(rem_18_u_div_CryTmp_4__2_) );
  NAND2_X1 rem_18_U202 ( .A1(rem_18_u_div_CryTmp_4__1_), .A2(
        rem_18_u_div_BInv[1]), .ZN(rem_18_n165) );
  XOR2_X1 rem_18_U201 ( .A(rem_18_u_div_CryTmp_4__1_), .B(rem_18_u_div_BInv[1]), .Z(rem_18_n162) );
  NAND2_X1 rem_18_U200 ( .A1(rem_18_u_div_CryTmp_5__1_), .A2(
        rem_18_u_div_BInv[1]), .ZN(rem_18_n161) );
  XOR2_X1 rem_18_U199 ( .A(rem_18_u_div_CryTmp_5__1_), .B(rem_18_u_div_BInv[1]), .Z(rem_18_n160) );
  NAND3_X1 rem_18_U198 ( .A1(rem_18_n159), .A2(rem_18_n158), .A3(rem_18_n157), 
        .ZN(rem_18_u_div_CryTmp_2__5_) );
  NAND2_X1 rem_18_U197 ( .A1(rem_18_u_div_CryTmp_2__4_), .A2(
        rem_18_u_div_BInv[4]), .ZN(rem_18_n159) );
  NAND2_X1 rem_18_U196 ( .A1(rem_18_n47), .A2(rem_18_u_div_PartRem_3__4_), 
        .ZN(rem_18_n158) );
  NAND2_X1 rem_18_U195 ( .A1(rem_18_u_div_PartRem_3__4_), .A2(
        rem_18_u_div_BInv[4]), .ZN(rem_18_n157) );
  XOR2_X1 rem_18_U194 ( .A(rem_18_u_div_PartRem_3__4_), .B(
        rem_18_u_div_BInv[4]), .Z(rem_18_n156) );
  NAND3_X1 rem_18_U193 ( .A1(rem_18_n154), .A2(rem_18_n153), .A3(rem_18_n155), 
        .ZN(rem_18_u_div_CryTmp_2__4_) );
  NAND2_X1 rem_18_U192 ( .A1(rem_18_u_div_CryTmp_2__3_), .A2(
        rem_18_u_div_BInv[3]), .ZN(rem_18_n155) );
  NAND2_X1 rem_18_U191 ( .A1(rem_18_u_div_PartRem_3__3_), .A2(
        rem_18_u_div_CryTmp_2__3_), .ZN(rem_18_n154) );
  NAND2_X1 rem_18_U190 ( .A1(rem_18_u_div_PartRem_3__3_), .A2(
        rem_18_u_div_BInv[3]), .ZN(rem_18_n153) );
  XOR2_X1 rem_18_U189 ( .A(rem_18_u_div_PartRem_3__3_), .B(
        rem_18_u_div_BInv[3]), .Z(rem_18_n152) );
  NAND3_X1 rem_18_U188 ( .A1(rem_18_n150), .A2(rem_18_n149), .A3(rem_18_n151), 
        .ZN(rem_18_u_div_CryTmp_2__2_) );
  NAND2_X1 rem_18_U187 ( .A1(rem_18_u_div_CryTmp_2__1_), .A2(
        rem_18_u_div_BInv[1]), .ZN(rem_18_n151) );
  NAND2_X1 rem_18_U186 ( .A1(rem_18_n122), .A2(rem_18_u_div_BInv[1]), .ZN(
        rem_18_n150) );
  NAND2_X1 rem_18_U185 ( .A1(rem_18_n185), .A2(rem_18_u_div_CryTmp_2__1_), 
        .ZN(rem_18_n149) );
  XOR2_X1 rem_18_U184 ( .A(rem_18_u_div_CryTmp_2__1_), .B(rem_18_u_div_BInv[1]), .Z(rem_18_n148) );
  NAND3_X1 rem_18_U183 ( .A1(rem_18_n146), .A2(rem_18_n145), .A3(rem_18_n147), 
        .ZN(rem_18_u_div_CryTmp_0__3_) );
  NAND2_X1 rem_18_U182 ( .A1(rem_18_u_div_PartRem_1__2_), .A2(
        rem_18_u_div_BInv[2]), .ZN(rem_18_n147) );
  NAND2_X1 rem_18_U181 ( .A1(rem_18_n65), .A2(rem_18_u_div_BInv[2]), .ZN(
        rem_18_n146) );
  NAND2_X1 rem_18_U180 ( .A1(rem_18_u_div_CryTmp_0__2_), .A2(
        rem_18_u_div_PartRem_1__2_), .ZN(rem_18_n145) );
  XOR2_X1 rem_18_U179 ( .A(rem_18_n95), .B(rem_18_n144), .Z(
        rem_18_u_div_SumTmp_0__2_) );
  XOR2_X1 rem_18_U178 ( .A(rem_18_u_div_PartRem_1__2_), .B(
        rem_18_u_div_BInv[2]), .Z(rem_18_n144) );
  NAND3_X1 rem_18_U177 ( .A1(rem_18_n153), .A2(rem_18_n154), .A3(rem_18_n155), 
        .ZN(rem_18_n143) );
  INV_X1 rem_18_U176 ( .A(rem_18_n63), .ZN(rem_18_n142) );
  NAND3_X1 rem_18_U175 ( .A1(rem_18_n140), .A2(rem_18_n139), .A3(rem_18_n141), 
        .ZN(rem_18_u_div_CryTmp_1__4_) );
  NAND2_X1 rem_18_U174 ( .A1(rem_18_u_div_PartRem_2__3_), .A2(
        rem_18_u_div_BInv[3]), .ZN(rem_18_n141) );
  NAND2_X1 rem_18_U173 ( .A1(rem_18_u_div_CryTmp_1__3_), .A2(
        rem_18_u_div_BInv[3]), .ZN(rem_18_n140) );
  NAND2_X1 rem_18_U172 ( .A1(rem_18_u_div_CryTmp_1__3_), .A2(
        rem_18_u_div_PartRem_2__3_), .ZN(rem_18_n139) );
  XOR2_X1 rem_18_U171 ( .A(rem_18_u_div_PartRem_2__3_), .B(
        rem_18_u_div_BInv[3]), .Z(rem_18_n138) );
  NAND3_X1 rem_18_U170 ( .A1(rem_18_n135), .A2(rem_18_n136), .A3(rem_18_n137), 
        .ZN(rem_18_u_div_CryTmp_0__7_) );
  NAND2_X1 rem_18_U169 ( .A1(rem_18_u_div_PartRem_1__6_), .A2(rem_18_n4), .ZN(
        rem_18_n137) );
  NAND2_X1 rem_18_U168 ( .A1(rem_18_u_div_CryTmp_0__6_), .A2(
        rem_18_u_div_BInv[6]), .ZN(rem_18_n136) );
  NAND2_X1 rem_18_U167 ( .A1(rem_18_n115), .A2(rem_18_u_div_PartRem_1__6_), 
        .ZN(rem_18_n135) );
  XOR2_X1 rem_18_U166 ( .A(rem_18_n54), .B(rem_18_n134), .Z(
        rem_18_u_div_SumTmp_0__6_) );
  XOR2_X1 rem_18_U165 ( .A(rem_18_u_div_PartRem_1__6_), .B(rem_18_n5), .Z(
        rem_18_n134) );
  INV_X1 rem_18_U164 ( .A(rem_18_n61), .ZN(rem_18_n216) );
  NAND3_X1 rem_18_U163 ( .A1(rem_18_n133), .A2(rem_18_n132), .A3(rem_18_n131), 
        .ZN(rem_18_u_div_CryTmp_3__5_) );
  NAND2_X1 rem_18_U162 ( .A1(rem_18_n8), .A2(rem_18_u_div_BInv[4]), .ZN(
        rem_18_n133) );
  NAND2_X1 rem_18_U161 ( .A1(rem_18_u_div_CryTmp_3__4_), .A2(
        rem_18_u_div_PartRem_4__4_), .ZN(rem_18_n132) );
  NAND2_X1 rem_18_U160 ( .A1(rem_18_u_div_PartRem_4__4_), .A2(
        rem_18_u_div_BInv[4]), .ZN(rem_18_n131) );
  XOR2_X1 rem_18_U159 ( .A(rem_18_u_div_PartRem_4__4_), .B(
        rem_18_u_div_BInv[4]), .Z(rem_18_n130) );
  NAND3_X1 rem_18_U158 ( .A1(rem_18_n128), .A2(rem_18_n129), .A3(rem_18_n127), 
        .ZN(rem_18_u_div_CryTmp_3__4_) );
  NAND2_X1 rem_18_U157 ( .A1(rem_18_u_div_CryTmp_3__3_), .A2(
        rem_18_u_div_BInv[3]), .ZN(rem_18_n129) );
  NAND2_X1 rem_18_U156 ( .A1(rem_18_u_div_PartRem_4__3_), .A2(rem_18_n49), 
        .ZN(rem_18_n128) );
  NAND2_X1 rem_18_U155 ( .A1(rem_18_u_div_PartRem_4__3_), .A2(
        rem_18_u_div_BInv[3]), .ZN(rem_18_n127) );
  XOR2_X1 rem_18_U154 ( .A(rem_18_u_div_PartRem_4__3_), .B(
        rem_18_u_div_BInv[3]), .Z(rem_18_n126) );
  NAND3_X1 rem_18_U153 ( .A1(rem_18_n48), .A2(rem_18_n73), .A3(rem_18_n184), 
        .ZN(rem_18_n125) );
  NAND3_X1 rem_18_U152 ( .A1(rem_18_n127), .A2(rem_18_n44), .A3(rem_18_n45), 
        .ZN(rem_18_n124) );
  INV_X1 rem_18_U151 ( .A(rem_18_n78), .ZN(rem_18_n222) );
  AND2_X1 rem_18_U150 ( .A1(rem_18_n89), .A2(rem_18_n201), .ZN(rem_18_n123) );
  MUX2_X1 rem_18_U149 ( .A(a[4]), .B(rem_18_u_div_SumTmp_4__0_), .S(
        rem_18_n167), .Z(rem_18_n166) );
  MUX2_X1 rem_18_U148 ( .A(a[3]), .B(rem_18_u_div_SumTmp_3__0_), .S(
        rem_18_n186), .Z(rem_18_n185) );
  MUX2_X1 rem_18_U147 ( .A(a[3]), .B(rem_18_u_div_SumTmp_3__0_), .S(
        rem_18_n186), .Z(rem_18_n122) );
  OR2_X1 rem_18_U146 ( .A1(rem_18_n207), .A2(b[1]), .ZN(rem_18_n164) );
  OR2_X1 rem_18_U145 ( .A1(rem_18_n207), .A2(rem_18_n121), .ZN(rem_18_n163) );
  INV_X2 rem_18_U144 ( .A(b[4]), .ZN(rem_18_u_div_BInv[4]) );
  NAND2_X1 rem_18_U143 ( .A1(rem_18_u_div_PartRem_1__4_), .A2(
        rem_18_u_div_BInv[4]), .ZN(rem_18_n120) );
  NAND2_X1 rem_18_U142 ( .A1(rem_18_u_div_CryTmp_0__4_), .A2(
        rem_18_u_div_BInv[4]), .ZN(rem_18_n119) );
  NAND2_X1 rem_18_U141 ( .A1(rem_18_u_div_CryTmp_0__4_), .A2(
        rem_18_u_div_PartRem_1__4_), .ZN(rem_18_n118) );
  XOR2_X1 rem_18_U140 ( .A(rem_18_n80), .B(rem_18_n117), .Z(
        rem_18_u_div_SumTmp_0__4_) );
  XOR2_X1 rem_18_U139 ( .A(rem_18_u_div_PartRem_1__4_), .B(
        rem_18_u_div_BInv[4]), .Z(rem_18_n117) );
  AND2_X1 rem_18_U138 ( .A1(rem_18_u_div_CryTmp_4__4_), .A2(rem_18_n123), .ZN(
        rem_18_n167) );
  NAND2_X1 rem_18_U137 ( .A1(rem_18_u_div_CryTmp_5__3_), .A2(rem_18_n114), 
        .ZN(rem_18_n116) );
  MUX2_X1 rem_18_U136 ( .A(rem_18_n12), .B(rem_18_n192), .S(rem_18_n116), .Z(
        rem_18_n207) );
  NAND3_X1 rem_18_U135 ( .A1(rem_18_n171), .A2(rem_18_n170), .A3(rem_18_n172), 
        .ZN(rem_18_n115) );
  AND2_X1 rem_18_U134 ( .A1(rem_18_n123), .A2(rem_18_u_div_BInv[3]), .ZN(
        rem_18_n114) );
  NAND3_X1 rem_18_U133 ( .A1(rem_18_n112), .A2(rem_18_n111), .A3(rem_18_n113), 
        .ZN(rem_18_u_div_CryTmp_2__6_) );
  NAND2_X1 rem_18_U132 ( .A1(rem_18_u_div_PartRem_3__5_), .A2(
        rem_18_u_div_BInv[5]), .ZN(rem_18_n113) );
  NAND2_X1 rem_18_U131 ( .A1(rem_18_n100), .A2(rem_18_u_div_BInv[5]), .ZN(
        rem_18_n112) );
  NAND2_X1 rem_18_U130 ( .A1(rem_18_u_div_CryTmp_2__5_), .A2(
        rem_18_u_div_PartRem_3__5_), .ZN(rem_18_n111) );
  XOR2_X1 rem_18_U129 ( .A(rem_18_u_div_PartRem_3__5_), .B(
        rem_18_u_div_BInv[5]), .Z(rem_18_n110) );
  NAND3_X1 rem_18_U128 ( .A1(rem_18_n133), .A2(rem_18_n132), .A3(rem_18_n131), 
        .ZN(rem_18_n109) );
  AND2_X1 rem_18_U127 ( .A1(rem_18_n109), .A2(rem_18_n13), .ZN(rem_18_n186) );
  MUX2_X1 rem_18_U126 ( .A(a[4]), .B(rem_18_u_div_SumTmp_4__0_), .S(rem_18_n43), .Z(rem_18_n108) );
  NAND3_X1 rem_18_U125 ( .A1(rem_18_n105), .A2(rem_18_n104), .A3(rem_18_n106), 
        .ZN(rem_18_u_div_CryTmp_1__2_) );
  NAND2_X1 rem_18_U124 ( .A1(rem_18_u_div_CryTmp_1__1_), .A2(
        rem_18_u_div_BInv[1]), .ZN(rem_18_n106) );
  NAND2_X1 rem_18_U123 ( .A1(rem_18_n42), .A2(rem_18_u_div_BInv[1]), .ZN(
        rem_18_n105) );
  NAND2_X1 rem_18_U122 ( .A1(rem_18_n168), .A2(rem_18_u_div_CryTmp_1__1_), 
        .ZN(rem_18_n104) );
  XOR2_X1 rem_18_U121 ( .A(rem_18_u_div_CryTmp_1__1_), .B(rem_18_u_div_BInv[1]), .Z(rem_18_n103) );
  FA_X1 rem_18_U120 ( .A(rem_18_u_div_PartRem_1__7_), .B(rem_18_u_div_BInv[7]), 
        .CI(rem_18_n74), .CO(rem_18_n102) );
  NAND3_X1 rem_18_U119 ( .A1(rem_18_n176), .A2(rem_18_n175), .A3(rem_18_n174), 
        .ZN(rem_18_n101) );
  NAND3_X1 rem_18_U118 ( .A1(rem_18_n39), .A2(rem_18_n159), .A3(rem_18_n157), 
        .ZN(rem_18_n100) );
  NAND3_X1 rem_18_U117 ( .A1(rem_18_n97), .A2(rem_18_n98), .A3(rem_18_n99), 
        .ZN(rem_18_u_div_CryTmp_3__2_) );
  NAND2_X1 rem_18_U116 ( .A1(rem_18_u_div_CryTmp_3__1_), .A2(
        rem_18_u_div_BInv[1]), .ZN(rem_18_n99) );
  NAND2_X1 rem_18_U115 ( .A1(rem_18_n30), .A2(rem_18_u_div_BInv[1]), .ZN(
        rem_18_n98) );
  NAND2_X1 rem_18_U114 ( .A1(rem_18_n166), .A2(rem_18_u_div_CryTmp_3__1_), 
        .ZN(rem_18_n97) );
  XOR2_X1 rem_18_U113 ( .A(rem_18_u_div_CryTmp_3__1_), .B(rem_18_u_div_BInv[1]), .Z(rem_18_n96) );
  INV_X1 rem_18_U112 ( .A(rem_18_n86), .ZN(rem_18_n202) );
  NAND2_X1 rem_18_U111 ( .A1(rem_18_n91), .A2(rem_18_n92), .ZN(rem_18_n94) );
  INV_X1 rem_18_U110 ( .A(b[3]), .ZN(rem_18_n90) );
  NOR2_X1 rem_18_U109 ( .A1(b[5]), .A2(b[4]), .ZN(rem_18_n89) );
  INV_X1 rem_18_U108 ( .A(rem_18_n107), .ZN(rem_18_n88) );
  MUX2_X1 rem_18_U107 ( .A(rem_18_n191), .B(rem_18_n11), .S(rem_18_n29), .Z(
        rem_18_n87) );
  CLKBUF_X1 rem_18_U106 ( .A(rem_18_n55), .Z(rem_18_n85) );
  NAND3_X1 rem_18_U105 ( .A1(rem_18_n83), .A2(rem_18_n82), .A3(rem_18_n84), 
        .ZN(rem_18_u_div_CryTmp_1__5_) );
  NAND2_X1 rem_18_U104 ( .A1(rem_18_u_div_PartRem_2__4_), .A2(
        rem_18_u_div_BInv[4]), .ZN(rem_18_n84) );
  NAND2_X1 rem_18_U103 ( .A1(rem_18_u_div_CryTmp_1__4_), .A2(
        rem_18_u_div_BInv[4]), .ZN(rem_18_n83) );
  NAND2_X1 rem_18_U102 ( .A1(rem_18_n77), .A2(rem_18_u_div_PartRem_2__4_), 
        .ZN(rem_18_n82) );
  XOR2_X1 rem_18_U101 ( .A(rem_18_u_div_PartRem_2__4_), .B(
        rem_18_u_div_BInv[4]), .Z(rem_18_n81) );
  CLKBUF_X1 rem_18_U100 ( .A(rem_18_n65), .Z(rem_18_n95) );
  NAND3_X1 rem_18_U99 ( .A1(rem_18_n179), .A2(rem_18_n180), .A3(rem_18_n178), 
        .ZN(rem_18_n79) );
  CLKBUF_X1 rem_18_U98 ( .A(rem_18_n42), .Z(rem_18_n78) );
  NAND3_X1 rem_18_U97 ( .A1(rem_18_n139), .A2(rem_18_n140), .A3(rem_18_n141), 
        .ZN(rem_18_n77) );
  NAND3_X1 rem_18_U96 ( .A1(rem_18_n119), .A2(rem_18_n64), .A3(rem_18_n120), 
        .ZN(rem_18_n76) );
  NAND3_X1 rem_18_U95 ( .A1(rem_18_n119), .A2(rem_18_n118), .A3(rem_18_n120), 
        .ZN(rem_18_n75) );
  NAND3_X1 rem_18_U94 ( .A1(rem_18_n135), .A2(rem_18_n136), .A3(rem_18_n137), 
        .ZN(rem_18_n74) );
  INV_X1 rem_18_U93 ( .A(rem_18_u_div_CryTmp_0__8_), .ZN(rem_18_n70) );
  NAND2_X1 rem_18_U92 ( .A1(rem_18_n71), .A2(rem_18_n72), .ZN(N3) );
  NAND2_X1 rem_18_U91 ( .A1(rem_18_u_div_SumTmp_0__3_), .A2(
        rem_18_u_div_CryTmp_0__8_), .ZN(rem_18_n72) );
  NAND2_X1 rem_18_U90 ( .A1(rem_18_n70), .A2(rem_18_u_div_PartRem_1__3_), .ZN(
        rem_18_n71) );
  NAND3_X1 rem_18_U89 ( .A1(rem_18_n67), .A2(rem_18_n68), .A3(rem_18_n69), 
        .ZN(rem_18_u_div_CryTmp_0__2_) );
  NAND2_X1 rem_18_U88 ( .A1(rem_18_u_div_CryTmp_0__1_), .A2(
        rem_18_u_div_BInv[1]), .ZN(rem_18_n69) );
  NAND2_X1 rem_18_U87 ( .A1(rem_18_u_div_PartRem_1__1_), .A2(
        rem_18_u_div_BInv[1]), .ZN(rem_18_n68) );
  NAND2_X1 rem_18_U86 ( .A1(rem_18_u_div_PartRem_1__1_), .A2(
        rem_18_u_div_CryTmp_0__1_), .ZN(rem_18_n67) );
  XOR2_X1 rem_18_U85 ( .A(rem_18_n62), .B(rem_18_n66), .Z(
        rem_18_u_div_SumTmp_0__1_) );
  XOR2_X1 rem_18_U84 ( .A(rem_18_u_div_CryTmp_0__1_), .B(rem_18_u_div_BInv[1]), 
        .Z(rem_18_n66) );
  CLKBUF_X1 rem_18_U83 ( .A(rem_18_u_div_CryTmp_0__4_), .Z(rem_18_n80) );
  NAND3_X1 rem_18_U82 ( .A1(rem_18_n68), .A2(rem_18_n67), .A3(rem_18_n69), 
        .ZN(rem_18_n65) );
  CLKBUF_X1 rem_18_U81 ( .A(rem_18_n93), .Z(rem_18_n86) );
  CLKBUF_X1 rem_18_U80 ( .A(rem_18_n118), .Z(rem_18_n64) );
  CLKBUF_X1 rem_18_U79 ( .A(rem_18_n207), .Z(rem_18_n63) );
  CLKBUF_X1 rem_18_U78 ( .A(rem_18_n183), .Z(rem_18_n73) );
  CLKBUF_X1 rem_18_U77 ( .A(rem_18_u_div_PartRem_1__1_), .Z(rem_18_n62) );
  MUX2_X1 rem_18_U76 ( .A(a[3]), .B(rem_18_u_div_SumTmp_3__0_), .S(rem_18_n187), .Z(rem_18_n61) );
  MUX2_X1 rem_18_U75 ( .A(a[3]), .B(rem_18_u_div_SumTmp_3__0_), .S(rem_18_n187), .Z(rem_18_n60) );
  CLKBUF_X1 rem_18_U74 ( .A(rem_18_n56), .Z(rem_18_n57) );
  CLKBUF_X1 rem_18_U73 ( .A(rem_18_u_div_CryTmp_2__3_), .Z(rem_18_n59) );
  CLKBUF_X1 rem_18_U72 ( .A(rem_18_u_div_CryTmp_1__3_), .Z(rem_18_n58) );
  NAND3_X1 rem_18_U71 ( .A1(rem_18_n83), .A2(rem_18_n82), .A3(rem_18_n84), 
        .ZN(rem_18_n56) );
  NAND3_X1 rem_18_U70 ( .A1(rem_18_n98), .A2(rem_18_n97), .A3(rem_18_n99), 
        .ZN(rem_18_n55) );
  CLKBUF_X1 rem_18_U69 ( .A(rem_18_n115), .Z(rem_18_n54) );
  CLKBUF_X1 rem_18_U68 ( .A(rem_18_u_div_CryTmp_1__4_), .Z(rem_18_n53) );
  NAND3_X1 rem_18_U67 ( .A1(rem_18_n38), .A2(rem_18_n51), .A3(rem_18_n157), 
        .ZN(rem_18_n52) );
  CLKBUF_X1 rem_18_U66 ( .A(rem_18_n39), .Z(rem_18_n51) );
  NAND3_X1 rem_18_U65 ( .A1(rem_18_n119), .A2(rem_18_n118), .A3(rem_18_n120), 
        .ZN(rem_18_n50) );
  NAND3_X1 rem_18_U64 ( .A1(rem_18_n182), .A2(rem_18_n183), .A3(rem_18_n184), 
        .ZN(rem_18_n49) );
  CLKBUF_X1 rem_18_U63 ( .A(rem_18_n182), .Z(rem_18_n48) );
  NAND3_X1 rem_18_U62 ( .A1(rem_18_n154), .A2(rem_18_n153), .A3(rem_18_n155), 
        .ZN(rem_18_n47) );
  NAND3_X1 rem_18_U61 ( .A1(rem_18_n41), .A2(rem_18_n40), .A3(rem_18_n174), 
        .ZN(rem_18_n46) );
  CLKBUF_X1 rem_18_U60 ( .A(rem_18_n1), .Z(rem_18_n44) );
  CLKBUF_X1 rem_18_U59 ( .A(rem_18_n2), .Z(rem_18_n45) );
  CLKBUF_X1 rem_18_U58 ( .A(rem_18_n188), .Z(rem_18_n43) );
  MUX2_X1 rem_18_U57 ( .A(a[2]), .B(rem_18_u_div_SumTmp_2__0_), .S(rem_18_n31), 
        .Z(rem_18_n168) );
  MUX2_X1 rem_18_U56 ( .A(a[2]), .B(rem_18_u_div_SumTmp_2__0_), .S(rem_18_n31), 
        .Z(rem_18_n42) );
  CLKBUF_X1 rem_18_U55 ( .A(rem_18_n176), .Z(rem_18_n41) );
  CLKBUF_X1 rem_18_U54 ( .A(rem_18_n175), .Z(rem_18_n40) );
  NAND2_X1 rem_18_U53 ( .A1(rem_18_n47), .A2(rem_18_u_div_PartRem_3__4_), .ZN(
        rem_18_n39) );
  NAND3_X1 rem_18_U52 ( .A1(rem_18_n179), .A2(rem_18_n180), .A3(rem_18_n178), 
        .ZN(rem_18_n37) );
  AND2_X2 rem_18_U51 ( .A1(rem_18_n37), .A2(rem_18_u_div_BInv[7]), .ZN(
        rem_18_n36) );
  CLKBUF_X1 rem_18_U50 ( .A(rem_18_n159), .Z(rem_18_n38) );
  INV_X1 rem_18_U49 ( .A(b[7]), .ZN(rem_18_n35) );
  INV_X1 rem_18_U48 ( .A(b[6]), .ZN(rem_18_n34) );
  AND4_X1 rem_18_U47 ( .A1(rem_18_n233), .A2(rem_18_n90), .A3(rem_18_n34), 
        .A4(rem_18_n35), .ZN(rem_18_n91) );
  INV_X1 rem_18_U46 ( .A(a[7]), .ZN(rem_18_n33) );
  AOI211_X1 rem_18_U45 ( .C1(rem_18_n33), .C2(b[0]), .A(b[2]), .B(b[1]), .ZN(
        rem_18_n92) );
  INV_X1 rem_18_U44 ( .A(rem_18_u_div_CryTmp_5__1_), .ZN(rem_18_n32) );
  OAI221_X1 rem_18_U43 ( .B1(rem_18_n204), .B2(rem_18_n32), .C1(rem_18_n87), 
        .C2(b[1]), .A(rem_18_n161), .ZN(rem_18_u_div_CryTmp_5__2_) );
  AND4_X1 rem_18_U42 ( .A1(rem_18_n7), .A2(rem_18_n123), .A3(
        rem_18_u_div_BInv[3]), .A4(rem_18_u_div_BInv[2]), .ZN(rem_18_n227) );
  AND2_X1 rem_18_U41 ( .A1(rem_18_u_div_CryTmp_2__6_), .A2(rem_18_n201), .ZN(
        rem_18_n31) );
  MUX2_X1 rem_18_U40 ( .A(a[4]), .B(rem_18_u_div_SumTmp_4__0_), .S(rem_18_n167), .Z(rem_18_n30) );
  NOR2_X1 rem_18_U39 ( .A1(b[6]), .A2(b[7]), .ZN(rem_18_n201) );
  XNOR2_X1 rem_18_U38 ( .A(rem_18_n58), .B(rem_18_n138), .ZN(rem_18_n28) );
  XNOR2_X1 rem_18_U37 ( .A(rem_18_n78), .B(rem_18_n103), .ZN(rem_18_n27) );
  XNOR2_X1 rem_18_U36 ( .A(rem_18_n53), .B(rem_18_n81), .ZN(rem_18_n26) );
  XNOR2_X1 rem_18_U35 ( .A(rem_18_n173), .B(rem_18_n57), .ZN(rem_18_n25) );
  XNOR2_X1 rem_18_U34 ( .A(rem_18_n177), .B(rem_18_n46), .ZN(rem_18_n24) );
  XNOR2_X1 rem_18_U33 ( .A(rem_18_n60), .B(rem_18_n148), .ZN(rem_18_n23) );
  XNOR2_X1 rem_18_U32 ( .A(rem_18_n156), .B(rem_18_n143), .ZN(rem_18_n22) );
  XNOR2_X1 rem_18_U31 ( .A(rem_18_n59), .B(rem_18_n152), .ZN(rem_18_n21) );
  XNOR2_X1 rem_18_U30 ( .A(rem_18_n52), .B(rem_18_n110), .ZN(rem_18_n20) );
  XNOR2_X1 rem_18_U29 ( .A(rem_18_n130), .B(rem_18_n124), .ZN(rem_18_n19) );
  XNOR2_X1 rem_18_U28 ( .A(rem_18_n126), .B(rem_18_n125), .ZN(rem_18_n18) );
  XNOR2_X1 rem_18_U27 ( .A(rem_18_n85), .B(rem_18_n181), .ZN(rem_18_n17) );
  XNOR2_X1 rem_18_U26 ( .A(rem_18_n108), .B(rem_18_n96), .ZN(rem_18_n16) );
  XNOR2_X1 rem_18_U25 ( .A(rem_18_n142), .B(rem_18_n162), .ZN(rem_18_n15) );
  XNOR2_X1 rem_18_U24 ( .A(rem_18_n88), .B(rem_18_n160), .ZN(rem_18_n14) );
  AND2_X1 rem_18_U23 ( .A1(rem_18_n201), .A2(rem_18_u_div_BInv[5]), .ZN(
        rem_18_n13) );
  XOR2_X1 rem_18_U22 ( .A(rem_18_n200), .B(a[5]), .Z(rem_18_n12) );
  XOR2_X1 rem_18_U21 ( .A(rem_18_n199), .B(a[6]), .Z(rem_18_n11) );
  INV_X1 rem_18_U20 ( .A(b[0]), .ZN(rem_18_n199) );
  INV_X1 rem_18_U19 ( .A(rem_18_n234), .ZN(rem_18_u_div_PartRem_1__3_) );
  INV_X1 rem_18_U18 ( .A(rem_18_u_div_CryTmp_4__1_), .ZN(rem_18_n121) );
  MUX2_X1 rem_18_U17 ( .A(rem_18_u_div_PartRem_1__6_), .B(
        rem_18_u_div_SumTmp_0__6_), .S(rem_18_u_div_CryTmp_0__8_), .Z(N6) );
  AND2_X2 rem_18_U16 ( .A1(rem_18_u_div_CryTmp_3__5_), .A2(rem_18_n13), .ZN(
        rem_18_n187) );
  AND2_X1 rem_18_U15 ( .A1(rem_18_n114), .A2(rem_18_u_div_BInv[2]), .ZN(
        rem_18_n10) );
  BUF_X1 rem_18_U14 ( .A(rem_18_n87), .Z(rem_18_n107) );
  AND2_X1 rem_18_U13 ( .A1(rem_18_n7), .A2(rem_18_n9), .ZN(rem_18_n29) );
  AND2_X1 rem_18_U12 ( .A1(rem_18_n114), .A2(rem_18_u_div_BInv[2]), .ZN(
        rem_18_n9) );
  NAND3_X1 rem_18_U11 ( .A1(rem_18_n1), .A2(rem_18_n2), .A3(rem_18_n127), .ZN(
        rem_18_n8) );
  MUX2_X2 rem_18_U10 ( .A(rem_18_u_div_SumTmp_7__0_), .B(a[7]), .S(rem_18_n94), 
        .Z(rem_18_n93) );
  FA_X1 rem_18_U9 ( .A(rem_18_u_div_CryTmp_6__1_), .B(rem_18_u_div_BInv[1]), 
        .CI(rem_18_n93), .CO(rem_18_n7) );
  NAND2_X1 rem_18_U8 ( .A1(rem_18_u_div_CryTmp_6__2_), .A2(rem_18_n10), .ZN(
        rem_18_n6) );
  MUX2_X1 rem_18_U7 ( .A(rem_18_n11), .B(rem_18_n191), .S(rem_18_n6), .Z(
        rem_18_n204) );
  INV_X1 rem_18_U6 ( .A(b[6]), .ZN(rem_18_u_div_BInv[6]) );
  INV_X1 rem_18_U5 ( .A(b[6]), .ZN(rem_18_n5) );
  INV_X1 rem_18_U4 ( .A(b[6]), .ZN(rem_18_n4) );
  INV_X1 rem_18_U3 ( .A(b[6]), .ZN(rem_18_n3) );
  NAND2_X1 rem_18_U2 ( .A1(rem_18_u_div_CryTmp_3__3_), .A2(
        rem_18_u_div_BInv[3]), .ZN(rem_18_n2) );
  NAND2_X1 rem_18_U1 ( .A1(rem_18_u_div_PartRem_4__3_), .A2(rem_18_n49), .ZN(
        rem_18_n1) );
  FA_X1 rem_18_u_div_u_fa_PartRem_0_0_3 ( .A(rem_18_u_div_PartRem_1__3_), .B(
        rem_18_u_div_BInv[3]), .CI(rem_18_u_div_CryTmp_0__3_), .CO(
        rem_18_u_div_CryTmp_0__4_), .S(rem_18_u_div_SumTmp_0__3_) );
  FA_X1 rem_18_u_div_u_fa_PartRem_0_0_7 ( .A(rem_18_u_div_PartRem_1__7_), .B(
        rem_18_u_div_BInv[7]), .CI(rem_18_u_div_CryTmp_0__7_), .CO(
        rem_18_u_div_CryTmp_0__8_), .S(rem_18_u_div_SumTmp_0__7_) );
  FA_X1 rem_18_u_div_u_fa_PartRem_0_1_2 ( .A(rem_18_u_div_PartRem_2__2_), .B(
        rem_18_u_div_BInv[2]), .CI(rem_18_u_div_CryTmp_1__2_), .CO(
        rem_18_u_div_CryTmp_1__3_), .S(rem_18_u_div_SumTmp_1__2_) );
  FA_X1 rem_18_u_div_u_fa_PartRem_0_2_2 ( .A(rem_18_u_div_PartRem_3__2_), .B(
        rem_18_u_div_BInv[2]), .CI(rem_18_u_div_CryTmp_2__2_), .CO(
        rem_18_u_div_CryTmp_2__3_), .S(rem_18_u_div_SumTmp_2__2_) );
  FA_X1 rem_18_u_div_u_fa_PartRem_0_4_2 ( .A(rem_18_u_div_PartRem_5__2_), .B(
        rem_18_u_div_BInv[2]), .CI(rem_18_u_div_CryTmp_4__2_), .CO(
        rem_18_u_div_CryTmp_4__3_), .S(rem_18_u_div_SumTmp_4__2_) );
  FA_X1 rem_18_u_div_u_fa_PartRem_0_4_3 ( .A(rem_18_u_div_PartRem_5__3_), .B(
        rem_18_u_div_BInv[3]), .CI(rem_18_u_div_CryTmp_4__3_), .CO(
        rem_18_u_div_CryTmp_4__4_), .S(rem_18_u_div_SumTmp_4__3_) );
  FA_X1 rem_18_u_div_u_fa_PartRem_0_5_2 ( .A(rem_18_u_div_BInv[2]), .B(
        rem_18_u_div_PartRem_6__2_), .CI(rem_18_u_div_CryTmp_5__2_), .CO(
        rem_18_u_div_CryTmp_5__3_), .S(rem_18_u_div_SumTmp_5__2_) );
  FA_X1 rem_18_u_div_u_fa_PartRem_0_6_1 ( .A(rem_18_u_div_CryTmp_6__1_), .B(
        rem_18_u_div_BInv[1]), .CI(rem_18_n93), .CO(rem_18_u_div_CryTmp_6__2_), 
        .S(rem_18_u_div_SumTmp_6__1_) );
endmodule

