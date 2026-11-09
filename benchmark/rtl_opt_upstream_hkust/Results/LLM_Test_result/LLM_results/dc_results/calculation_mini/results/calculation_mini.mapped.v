/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:07:25 2025
/////////////////////////////////////////////////////////////


module calculation_mini ( a, b, c, d, s1, s2, s3, s4, s5, s6 );
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
  wire   a_mod_b_7_, a_mod_b_6_, a_mod_b_5_, a_mod_b_4_, a_mod_b_3_,
         a_mod_b_2_, a_mod_b_1_, a_mod_b_0_, temp_s6_mult_7_, temp_s6_mult_6_,
         temp_s6_mult_5_, temp_s6_mult_4_, temp_s6_mult_3_, temp_s6_mult_2_,
         temp_s6_mult_1_, temp_s6_mult_0_, temp_s6_intermediate_7_,
         temp_s6_intermediate_6_, temp_s6_intermediate_5_,
         temp_s6_intermediate_4_, temp_s6_intermediate_3_,
         temp_s6_intermediate_2_, temp_s6_intermediate_1_,
         temp_s6_intermediate_0_, b_plus_1_7_, b_plus_1_6_, b_plus_1_5_,
         b_plus_1_4_, b_plus_1_3_, b_plus_1_2_, b_plus_1_1_, b_plus_1_0_, N7,
         N6, N5, N4, N3, N2, N1, N0, c_plus_d_7_, c_plus_d_6_, c_plus_d_5_,
         c_plus_d_4_, c_plus_d_3_, c_plus_d_2_, c_plus_d_1_, c_plus_d_0_, n7,
         n8, n9, n10, n11, n12, sub_33_n10, sub_33_n9, sub_33_n8, sub_33_n7,
         sub_33_n6, sub_33_n5, sub_33_n4, sub_33_n3, sub_33_n2, sub_33_n1,
         add_17_n1, sub_2_root_add_0_root_sub_42_n10,
         sub_2_root_add_0_root_sub_42_n9, sub_2_root_add_0_root_sub_42_n8,
         sub_2_root_add_0_root_sub_42_n7, sub_2_root_add_0_root_sub_42_n6,
         sub_2_root_add_0_root_sub_42_n5, sub_2_root_add_0_root_sub_42_n4,
         sub_2_root_add_0_root_sub_42_n3, sub_2_root_add_0_root_sub_42_n2,
         sub_2_root_add_0_root_sub_42_n1, mult_18_n29, mult_18_n28,
         mult_18_n27, mult_18_n26, mult_18_n25, mult_18_n24, mult_18_n23,
         mult_18_n22, mult_18_n21, mult_18_n20, mult_18_n19, mult_18_n18,
         mult_18_n17, mult_18_n16, mult_18_n15, mult_18_n14, mult_18_n12,
         mult_18_n11, mult_18_n10, mult_18_n9, mult_18_n8, mult_18_n7,
         mult_18_n6, mult_18_n5, mult_18_n4, mult_18_n3, mult_18_n2,
         mult_18_SUMB_2__1_, mult_18_SUMB_2__2_, mult_18_SUMB_2__3_,
         mult_18_SUMB_2__4_, mult_18_SUMB_2__5_, mult_18_SUMB_3__1_,
         mult_18_SUMB_3__2_, mult_18_SUMB_3__3_, mult_18_SUMB_3__4_,
         mult_18_SUMB_4__1_, mult_18_SUMB_4__2_, mult_18_SUMB_4__3_,
         mult_18_SUMB_5__1_, mult_18_SUMB_5__2_, mult_18_SUMB_6__1_,
         mult_18_CARRYB_2__0_, mult_18_CARRYB_2__1_, mult_18_CARRYB_2__2_,
         mult_18_CARRYB_2__3_, mult_18_CARRYB_2__4_, mult_18_CARRYB_3__0_,
         mult_18_CARRYB_3__1_, mult_18_CARRYB_3__2_, mult_18_CARRYB_3__3_,
         mult_18_CARRYB_4__0_, mult_18_CARRYB_4__1_, mult_18_CARRYB_4__2_,
         mult_18_CARRYB_5__0_, mult_18_CARRYB_5__1_, mult_18_CARRYB_6__0_,
         mult_18_ab_0__1_, mult_18_ab_0__2_, mult_18_ab_0__3_,
         mult_18_ab_0__4_, mult_18_ab_0__5_, mult_18_ab_0__6_,
         mult_18_ab_1__0_, mult_18_ab_1__1_, mult_18_ab_1__2_,
         mult_18_ab_1__3_, mult_18_ab_1__4_, mult_18_ab_1__5_,
         mult_18_ab_1__6_, mult_18_ab_2__0_, mult_18_ab_2__1_,
         mult_18_ab_2__2_, mult_18_ab_2__3_, mult_18_ab_2__4_,
         mult_18_ab_2__5_, mult_18_ab_3__0_, mult_18_ab_3__1_,
         mult_18_ab_3__2_, mult_18_ab_3__3_, mult_18_ab_3__4_,
         mult_18_ab_4__0_, mult_18_ab_4__1_, mult_18_ab_4__2_,
         mult_18_ab_4__3_, mult_18_ab_5__0_, mult_18_ab_5__1_,
         mult_18_ab_5__2_, mult_18_ab_6__0_, mult_18_ab_6__1_,
         mult_18_ab_7__0_, mult_40_n29, mult_40_n28, mult_40_n27, mult_40_n26,
         mult_40_n25, mult_40_n24, mult_40_n23, mult_40_n22, mult_40_n21,
         mult_40_n20, mult_40_n19, mult_40_n18, mult_40_n17, mult_40_n16,
         mult_40_n15, mult_40_n13, mult_40_n12, mult_40_n11, mult_40_n10,
         mult_40_n9, mult_40_n8, mult_40_n7, mult_40_n6, mult_40_n5,
         mult_40_n4, mult_40_n3, mult_40_n2, mult_40_SUMB_2__1_,
         mult_40_SUMB_2__2_, mult_40_SUMB_2__3_, mult_40_SUMB_2__4_,
         mult_40_SUMB_2__5_, mult_40_SUMB_3__1_, mult_40_SUMB_3__2_,
         mult_40_SUMB_3__3_, mult_40_SUMB_3__4_, mult_40_SUMB_4__1_,
         mult_40_SUMB_4__2_, mult_40_SUMB_4__3_, mult_40_SUMB_5__1_,
         mult_40_SUMB_5__2_, mult_40_SUMB_6__1_, mult_40_CARRYB_2__0_,
         mult_40_CARRYB_2__1_, mult_40_CARRYB_2__2_, mult_40_CARRYB_2__3_,
         mult_40_CARRYB_2__4_, mult_40_CARRYB_3__0_, mult_40_CARRYB_3__1_,
         mult_40_CARRYB_3__2_, mult_40_CARRYB_3__3_, mult_40_CARRYB_4__0_,
         mult_40_CARRYB_4__1_, mult_40_CARRYB_4__2_, mult_40_CARRYB_5__0_,
         mult_40_CARRYB_5__1_, mult_40_CARRYB_6__0_, mult_40_ab_0__1_,
         mult_40_ab_0__2_, mult_40_ab_0__3_, mult_40_ab_0__4_,
         mult_40_ab_0__5_, mult_40_ab_0__6_, mult_40_ab_1__0_,
         mult_40_ab_1__1_, mult_40_ab_1__2_, mult_40_ab_1__3_,
         mult_40_ab_1__4_, mult_40_ab_1__5_, mult_40_ab_1__6_,
         mult_40_ab_2__0_, mult_40_ab_2__1_, mult_40_ab_2__2_,
         mult_40_ab_2__3_, mult_40_ab_2__4_, mult_40_ab_2__5_,
         mult_40_ab_3__0_, mult_40_ab_3__1_, mult_40_ab_3__2_,
         mult_40_ab_3__3_, mult_40_ab_3__4_, mult_40_ab_4__0_,
         mult_40_ab_4__1_, mult_40_ab_4__2_, mult_40_ab_4__3_,
         mult_40_ab_5__0_, mult_40_ab_5__1_, mult_40_ab_5__2_,
         mult_40_ab_6__0_, mult_40_ab_6__1_, mult_40_ab_7__0_,
         add_1_root_add_0_root_sub_42_n1, add_0_root_add_0_root_sub_42_n1,
         add_1_root_add_0_root_add_30_n1, add_0_root_add_0_root_add_30_n1,
         add_26_n70, add_26_n69, add_26_n68, add_26_n67, add_26_n66,
         add_26_n65, add_26_n64, add_26_n63, add_26_n62, add_26_n61,
         add_26_n60, add_26_n59, add_26_n58, add_26_n57, add_26_n56,
         add_26_n55, add_26_n54, add_26_n53, add_26_n52, add_26_n51,
         add_26_n50, add_26_n49, add_26_n48, add_26_n47, add_26_n46,
         add_26_n45, add_26_n44, add_26_n43, add_26_n42, add_26_n41,
         add_26_n40, add_26_n39, add_26_n38, add_26_n37, add_26_n36,
         add_26_n35, add_26_n34, add_26_n33, add_26_n32, add_26_n31,
         add_26_n30, add_26_n29, add_26_n28, add_26_n27, add_26_n26,
         add_26_n25, add_26_n24, add_26_n23, add_26_n22, add_26_n21,
         add_26_n20, add_26_n19, add_26_n18, add_26_n17, add_26_n16,
         add_26_n15, add_26_n14, add_26_n13, add_26_n12, add_26_n11,
         add_26_n10, add_26_n9, add_26_n8, add_26_n7, add_26_n6, add_26_n4,
         add_26_n3, add_26_n2, add_26_n1, rem_25_n237, rem_25_n236,
         rem_25_n235, rem_25_n234, rem_25_n233, rem_25_n232, rem_25_n231,
         rem_25_n230, rem_25_n229, rem_25_n228, rem_25_n227, rem_25_n226,
         rem_25_n225, rem_25_n224, rem_25_n223, rem_25_n222, rem_25_n221,
         rem_25_n220, rem_25_n219, rem_25_n218, rem_25_n217, rem_25_n216,
         rem_25_n215, rem_25_n214, rem_25_n213, rem_25_n212, rem_25_n211,
         rem_25_n210, rem_25_n209, rem_25_n208, rem_25_n207, rem_25_n206,
         rem_25_n205, rem_25_n204, rem_25_n203, rem_25_n202, rem_25_n201,
         rem_25_n200, rem_25_n199, rem_25_n198, rem_25_n197, rem_25_n196,
         rem_25_n195, rem_25_n194, rem_25_n193, rem_25_n192, rem_25_n191,
         rem_25_n190, rem_25_n189, rem_25_n188, rem_25_n187, rem_25_n186,
         rem_25_n185, rem_25_n184, rem_25_n183, rem_25_n182, rem_25_n181,
         rem_25_n180, rem_25_n179, rem_25_n178, rem_25_n177, rem_25_n176,
         rem_25_n175, rem_25_n174, rem_25_n173, rem_25_n172, rem_25_n171,
         rem_25_n170, rem_25_n169, rem_25_n168, rem_25_n167, rem_25_n166,
         rem_25_n165, rem_25_n164, rem_25_n163, rem_25_n162, rem_25_n161,
         rem_25_n160, rem_25_n159, rem_25_n158, rem_25_n157, rem_25_n156,
         rem_25_n155, rem_25_n154, rem_25_n153, rem_25_n152, rem_25_n151,
         rem_25_n150, rem_25_n149, rem_25_n148, rem_25_n147, rem_25_n146,
         rem_25_n145, rem_25_n144, rem_25_n143, rem_25_n142, rem_25_n141,
         rem_25_n140, rem_25_n139, rem_25_n138, rem_25_n137, rem_25_n136,
         rem_25_n135, rem_25_n134, rem_25_n133, rem_25_n132, rem_25_n131,
         rem_25_n130, rem_25_n129, rem_25_n128, rem_25_n127, rem_25_n126,
         rem_25_n125, rem_25_n124, rem_25_n123, rem_25_n122, rem_25_n121,
         rem_25_n120, rem_25_n119, rem_25_n118, rem_25_n117, rem_25_n116,
         rem_25_n115, rem_25_n114, rem_25_n113, rem_25_n112, rem_25_n111,
         rem_25_n110, rem_25_n109, rem_25_n108, rem_25_n107, rem_25_n106,
         rem_25_n105, rem_25_n104, rem_25_n103, rem_25_n102, rem_25_n101,
         rem_25_n100, rem_25_n99, rem_25_n98, rem_25_n97, rem_25_n96,
         rem_25_n95, rem_25_n94, rem_25_n93, rem_25_n92, rem_25_n91,
         rem_25_n90, rem_25_n89, rem_25_n88, rem_25_n87, rem_25_n86,
         rem_25_n85, rem_25_n84, rem_25_n83, rem_25_n82, rem_25_n81,
         rem_25_n80, rem_25_n79, rem_25_n78, rem_25_n77, rem_25_n76,
         rem_25_n75, rem_25_n74, rem_25_n73, rem_25_n72, rem_25_n71,
         rem_25_n70, rem_25_n69, rem_25_n68, rem_25_n67, rem_25_n66,
         rem_25_n65, rem_25_n64, rem_25_n63, rem_25_n62, rem_25_n61,
         rem_25_n60, rem_25_n59, rem_25_n58, rem_25_n57, rem_25_n56,
         rem_25_n55, rem_25_n54, rem_25_n53, rem_25_n52, rem_25_n51,
         rem_25_n50, rem_25_n49, rem_25_n48, rem_25_n47, rem_25_n46,
         rem_25_n45, rem_25_n44, rem_25_n43, rem_25_n42, rem_25_n41,
         rem_25_n40, rem_25_n39, rem_25_n38, rem_25_n37, rem_25_n36,
         rem_25_n35, rem_25_n34, rem_25_n33, rem_25_n32, rem_25_n31,
         rem_25_n30, rem_25_n29, rem_25_n28, rem_25_n27, rem_25_n26,
         rem_25_n25, rem_25_n24, rem_25_n23, rem_25_n22, rem_25_n21,
         rem_25_n20, rem_25_n19, rem_25_n18, rem_25_n17, rem_25_n16,
         rem_25_n15, rem_25_n14, rem_25_n13, rem_25_n12, rem_25_n11,
         rem_25_n10, rem_25_n9, rem_25_n8, rem_25_n7, rem_25_n6, rem_25_n5,
         rem_25_n4, rem_25_n3, rem_25_n2, rem_25_n1,
         rem_25_u_div_PartRem_6__2_, rem_25_u_div_PartRem_5__3_,
         rem_25_u_div_PartRem_5__2_, rem_25_u_div_PartRem_4__4_,
         rem_25_u_div_PartRem_4__3_, rem_25_u_div_PartRem_4__2_,
         rem_25_u_div_PartRem_3__5_, rem_25_u_div_PartRem_3__4_,
         rem_25_u_div_PartRem_3__3_, rem_25_u_div_PartRem_3__2_,
         rem_25_u_div_PartRem_2__6_, rem_25_u_div_PartRem_2__5_,
         rem_25_u_div_PartRem_2__4_, rem_25_u_div_PartRem_2__3_,
         rem_25_u_div_PartRem_2__2_, rem_25_u_div_PartRem_1__7_,
         rem_25_u_div_PartRem_1__6_, rem_25_u_div_PartRem_1__5_,
         rem_25_u_div_PartRem_1__4_, rem_25_u_div_PartRem_1__3_,
         rem_25_u_div_PartRem_1__2_, rem_25_u_div_PartRem_1__1_,
         rem_25_u_div_CryTmp_6__2_, rem_25_u_div_CryTmp_6__1_,
         rem_25_u_div_CryTmp_5__3_, rem_25_u_div_CryTmp_5__2_,
         rem_25_u_div_CryTmp_5__1_, rem_25_u_div_CryTmp_4__4_,
         rem_25_u_div_CryTmp_4__3_, rem_25_u_div_CryTmp_4__2_,
         rem_25_u_div_CryTmp_4__1_, rem_25_u_div_CryTmp_3__5_,
         rem_25_u_div_CryTmp_3__4_, rem_25_u_div_CryTmp_3__3_,
         rem_25_u_div_CryTmp_3__2_, rem_25_u_div_CryTmp_3__1_,
         rem_25_u_div_CryTmp_2__6_, rem_25_u_div_CryTmp_2__5_,
         rem_25_u_div_CryTmp_2__4_, rem_25_u_div_CryTmp_2__3_,
         rem_25_u_div_CryTmp_2__2_, rem_25_u_div_CryTmp_2__1_,
         rem_25_u_div_CryTmp_1__6_, rem_25_u_div_CryTmp_1__5_,
         rem_25_u_div_CryTmp_1__4_, rem_25_u_div_CryTmp_1__3_,
         rem_25_u_div_CryTmp_1__2_, rem_25_u_div_CryTmp_1__1_,
         rem_25_u_div_CryTmp_0__8_, rem_25_u_div_CryTmp_0__7_,
         rem_25_u_div_CryTmp_0__6_, rem_25_u_div_CryTmp_0__4_,
         rem_25_u_div_CryTmp_0__3_, rem_25_u_div_CryTmp_0__2_,
         rem_25_u_div_CryTmp_0__1_, rem_25_u_div_SumTmp_7__0_,
         rem_25_u_div_SumTmp_6__1_, rem_25_u_div_SumTmp_5__2_,
         rem_25_u_div_SumTmp_4__3_, rem_25_u_div_SumTmp_4__2_,
         rem_25_u_div_SumTmp_4__0_, rem_25_u_div_SumTmp_3__0_,
         rem_25_u_div_SumTmp_2__2_, rem_25_u_div_SumTmp_2__0_,
         rem_25_u_div_SumTmp_1__2_, rem_25_u_div_SumTmp_1__0_,
         rem_25_u_div_SumTmp_0__7_, rem_25_u_div_SumTmp_0__6_,
         rem_25_u_div_SumTmp_0__5_, rem_25_u_div_SumTmp_0__4_,
         rem_25_u_div_SumTmp_0__3_, rem_25_u_div_SumTmp_0__2_,
         rem_25_u_div_SumTmp_0__1_, rem_25_u_div_SumTmp_0__0_;
  wire   [7:1] sub_33_carry;
  wire   [7:2] add_17_carry;
  wire   [7:2] add_39_carry;
  wire   [7:1] sub_2_root_add_0_root_sub_42_carry;
  wire   [7:2] add_1_root_add_0_root_sub_42_carry;
  wire   [7:2] add_0_root_add_0_root_sub_42_carry;
  wire   [7:2] add_1_root_add_0_root_add_30_carry;
  wire   [7:2] add_0_root_add_0_root_add_30_carry;
  wire   [7:1] rem_25_u_div_BInv;

  BUF_X1 U8 ( .A(b[4]), .Z(n7) );
  BUF_X1 U9 ( .A(n8), .Z(n9) );
  BUF_X1 U10 ( .A(n7), .Z(n8) );
  BUF_X1 U11 ( .A(b[7]), .Z(n10) );
  BUF_X2 U12 ( .A(n10), .Z(n11) );
  BUF_X1 U13 ( .A(n11), .Z(n12) );
  INV_X1 sub_33_U12 ( .A(b[0]), .ZN(sub_33_n10) );
  INV_X1 sub_33_U11 ( .A(n11), .ZN(sub_33_n3) );
  XNOR2_X1 sub_33_U10 ( .A(sub_33_n10), .B(a[0]), .ZN(s5[0]) );
  INV_X1 sub_33_U9 ( .A(a[0]), .ZN(sub_33_n2) );
  NAND2_X1 sub_33_U8 ( .A1(sub_33_n1), .A2(sub_33_n2), .ZN(sub_33_carry[1]) );
  INV_X1 sub_33_U7 ( .A(b[1]), .ZN(sub_33_n9) );
  INV_X1 sub_33_U6 ( .A(b[2]), .ZN(sub_33_n8) );
  INV_X1 sub_33_U5 ( .A(b[3]), .ZN(sub_33_n7) );
  INV_X1 sub_33_U4 ( .A(n9), .ZN(sub_33_n6) );
  INV_X1 sub_33_U3 ( .A(b[5]), .ZN(sub_33_n5) );
  INV_X1 sub_33_U2 ( .A(b[6]), .ZN(sub_33_n4) );
  INV_X1 sub_33_U1 ( .A(sub_33_n10), .ZN(sub_33_n1) );
  FA_X1 sub_33_U2_1 ( .A(a[1]), .B(sub_33_n9), .CI(sub_33_carry[1]), .CO(
        sub_33_carry[2]), .S(s5[1]) );
  FA_X1 sub_33_U2_2 ( .A(a[2]), .B(sub_33_n8), .CI(sub_33_carry[2]), .CO(
        sub_33_carry[3]), .S(s5[2]) );
  FA_X1 sub_33_U2_3 ( .A(a[3]), .B(sub_33_n7), .CI(sub_33_carry[3]), .CO(
        sub_33_carry[4]), .S(s5[3]) );
  FA_X1 sub_33_U2_4 ( .A(a[4]), .B(sub_33_n6), .CI(sub_33_carry[4]), .CO(
        sub_33_carry[5]), .S(s5[4]) );
  FA_X1 sub_33_U2_5 ( .A(a[5]), .B(sub_33_n5), .CI(sub_33_carry[5]), .CO(
        sub_33_carry[6]), .S(s5[5]) );
  FA_X1 sub_33_U2_6 ( .A(a[6]), .B(sub_33_n4), .CI(sub_33_carry[6]), .CO(
        sub_33_carry[7]), .S(s5[6]) );
  FA_X1 sub_33_U2_7 ( .A(a[7]), .B(sub_33_n3), .CI(sub_33_carry[7]), .S(s5[7])
         );
  XOR2_X1 add_17_U2 ( .A(b[0]), .B(a[0]), .Z(s1[0]) );
  AND2_X1 add_17_U1 ( .A1(b[0]), .A2(a[0]), .ZN(add_17_n1) );
  FA_X1 add_17_U1_1 ( .A(a[1]), .B(b[1]), .CI(add_17_n1), .CO(add_17_carry[2]), 
        .S(s1[1]) );
  FA_X1 add_17_U1_2 ( .A(a[2]), .B(b[2]), .CI(add_17_carry[2]), .CO(
        add_17_carry[3]), .S(s1[2]) );
  FA_X1 add_17_U1_3 ( .A(a[3]), .B(b[3]), .CI(add_17_carry[3]), .CO(
        add_17_carry[4]), .S(s1[3]) );
  FA_X1 add_17_U1_4 ( .A(a[4]), .B(n9), .CI(add_17_carry[4]), .CO(
        add_17_carry[5]), .S(s1[4]) );
  FA_X1 add_17_U1_5 ( .A(a[5]), .B(b[5]), .CI(add_17_carry[5]), .CO(
        add_17_carry[6]), .S(s1[5]) );
  FA_X1 add_17_U1_6 ( .A(a[6]), .B(b[6]), .CI(add_17_carry[6]), .CO(
        add_17_carry[7]), .S(s1[6]) );
  FA_X1 add_17_U1_7 ( .A(a[7]), .B(n12), .CI(add_17_carry[7]), .S(s1[7]) );
  INV_X1 add_39_U2 ( .A(b[0]), .ZN(b_plus_1_0_) );
  XOR2_X1 add_39_U1 ( .A(add_39_carry[7]), .B(n11), .Z(b_plus_1_7_) );
  HA_X1 add_39_U1_1_1 ( .A(b[1]), .B(b[0]), .CO(add_39_carry[2]), .S(
        b_plus_1_1_) );
  HA_X1 add_39_U1_1_2 ( .A(b[2]), .B(add_39_carry[2]), .CO(add_39_carry[3]), 
        .S(b_plus_1_2_) );
  HA_X1 add_39_U1_1_3 ( .A(b[3]), .B(add_39_carry[3]), .CO(add_39_carry[4]), 
        .S(b_plus_1_3_) );
  HA_X1 add_39_U1_1_4 ( .A(n7), .B(add_39_carry[4]), .CO(add_39_carry[5]), .S(
        b_plus_1_4_) );
  HA_X1 add_39_U1_1_5 ( .A(b[5]), .B(add_39_carry[5]), .CO(add_39_carry[6]), 
        .S(b_plus_1_5_) );
  HA_X1 add_39_U1_1_6 ( .A(b[6]), .B(add_39_carry[6]), .CO(add_39_carry[7]), 
        .S(b_plus_1_6_) );
  INV_X1 sub_2_root_add_0_root_sub_42_U12 ( .A(b[0]), .ZN(
        sub_2_root_add_0_root_sub_42_n10) );
  INV_X1 sub_2_root_add_0_root_sub_42_U11 ( .A(n11), .ZN(
        sub_2_root_add_0_root_sub_42_n3) );
  XNOR2_X1 sub_2_root_add_0_root_sub_42_U10 ( .A(
        sub_2_root_add_0_root_sub_42_n10), .B(d[0]), .ZN(
        temp_s6_intermediate_0_) );
  INV_X1 sub_2_root_add_0_root_sub_42_U9 ( .A(b[3]), .ZN(
        sub_2_root_add_0_root_sub_42_n7) );
  INV_X1 sub_2_root_add_0_root_sub_42_U8 ( .A(n8), .ZN(
        sub_2_root_add_0_root_sub_42_n6) );
  INV_X1 sub_2_root_add_0_root_sub_42_U7 ( .A(b[2]), .ZN(
        sub_2_root_add_0_root_sub_42_n8) );
  INV_X1 sub_2_root_add_0_root_sub_42_U6 ( .A(b[5]), .ZN(
        sub_2_root_add_0_root_sub_42_n5) );
  INV_X1 sub_2_root_add_0_root_sub_42_U5 ( .A(b[6]), .ZN(
        sub_2_root_add_0_root_sub_42_n4) );
  INV_X1 sub_2_root_add_0_root_sub_42_U4 ( .A(d[0]), .ZN(
        sub_2_root_add_0_root_sub_42_n2) );
  NAND2_X1 sub_2_root_add_0_root_sub_42_U3 ( .A1(
        sub_2_root_add_0_root_sub_42_n1), .A2(sub_2_root_add_0_root_sub_42_n2), 
        .ZN(sub_2_root_add_0_root_sub_42_carry[1]) );
  INV_X1 sub_2_root_add_0_root_sub_42_U2 ( .A(b[1]), .ZN(
        sub_2_root_add_0_root_sub_42_n9) );
  INV_X1 sub_2_root_add_0_root_sub_42_U1 ( .A(sub_2_root_add_0_root_sub_42_n10), .ZN(sub_2_root_add_0_root_sub_42_n1) );
  FA_X1 sub_2_root_add_0_root_sub_42_U2_1 ( .A(d[1]), .B(
        sub_2_root_add_0_root_sub_42_n9), .CI(
        sub_2_root_add_0_root_sub_42_carry[1]), .CO(
        sub_2_root_add_0_root_sub_42_carry[2]), .S(temp_s6_intermediate_1_) );
  FA_X1 sub_2_root_add_0_root_sub_42_U2_2 ( .A(d[2]), .B(
        sub_2_root_add_0_root_sub_42_n8), .CI(
        sub_2_root_add_0_root_sub_42_carry[2]), .CO(
        sub_2_root_add_0_root_sub_42_carry[3]), .S(temp_s6_intermediate_2_) );
  FA_X1 sub_2_root_add_0_root_sub_42_U2_3 ( .A(d[3]), .B(
        sub_2_root_add_0_root_sub_42_n7), .CI(
        sub_2_root_add_0_root_sub_42_carry[3]), .CO(
        sub_2_root_add_0_root_sub_42_carry[4]), .S(temp_s6_intermediate_3_) );
  FA_X1 sub_2_root_add_0_root_sub_42_U2_4 ( .A(d[4]), .B(
        sub_2_root_add_0_root_sub_42_n6), .CI(
        sub_2_root_add_0_root_sub_42_carry[4]), .CO(
        sub_2_root_add_0_root_sub_42_carry[5]), .S(temp_s6_intermediate_4_) );
  FA_X1 sub_2_root_add_0_root_sub_42_U2_5 ( .A(d[5]), .B(
        sub_2_root_add_0_root_sub_42_n5), .CI(
        sub_2_root_add_0_root_sub_42_carry[5]), .CO(
        sub_2_root_add_0_root_sub_42_carry[6]), .S(temp_s6_intermediate_5_) );
  FA_X1 sub_2_root_add_0_root_sub_42_U2_6 ( .A(d[6]), .B(
        sub_2_root_add_0_root_sub_42_n4), .CI(
        sub_2_root_add_0_root_sub_42_carry[6]), .CO(
        sub_2_root_add_0_root_sub_42_carry[7]), .S(temp_s6_intermediate_6_) );
  FA_X1 sub_2_root_add_0_root_sub_42_U2_7 ( .A(d[7]), .B(
        sub_2_root_add_0_root_sub_42_n3), .CI(
        sub_2_root_add_0_root_sub_42_carry[7]), .S(temp_s6_intermediate_7_) );
  NOR2_X1 mult_18_U64 ( .A1(mult_18_n29), .A2(mult_18_n28), .ZN(s2[0]) );
  AND2_X1 mult_18_U63 ( .A1(a[7]), .A2(b[0]), .ZN(mult_18_ab_7__0_) );
  NOR2_X1 mult_18_U62 ( .A1(mult_18_n28), .A2(mult_18_n27), .ZN(
        mult_18_ab_6__0_) );
  NOR2_X1 mult_18_U61 ( .A1(mult_18_n27), .A2(mult_18_n26), .ZN(
        mult_18_ab_6__1_) );
  INV_X1 mult_18_U60 ( .A(a[6]), .ZN(mult_18_n27) );
  NOR2_X1 mult_18_U59 ( .A1(mult_18_n28), .A2(mult_18_n25), .ZN(
        mult_18_ab_5__0_) );
  NOR2_X1 mult_18_U58 ( .A1(mult_18_n26), .A2(mult_18_n25), .ZN(
        mult_18_ab_5__1_) );
  NOR2_X1 mult_18_U57 ( .A1(mult_18_n25), .A2(mult_18_n24), .ZN(
        mult_18_ab_5__2_) );
  INV_X1 mult_18_U56 ( .A(a[5]), .ZN(mult_18_n25) );
  NOR2_X1 mult_18_U55 ( .A1(mult_18_n28), .A2(mult_18_n23), .ZN(
        mult_18_ab_4__0_) );
  NOR2_X1 mult_18_U54 ( .A1(mult_18_n26), .A2(mult_18_n23), .ZN(
        mult_18_ab_4__1_) );
  NOR2_X1 mult_18_U53 ( .A1(mult_18_n24), .A2(mult_18_n23), .ZN(
        mult_18_ab_4__2_) );
  NOR2_X1 mult_18_U52 ( .A1(mult_18_n23), .A2(mult_18_n22), .ZN(
        mult_18_ab_4__3_) );
  INV_X1 mult_18_U51 ( .A(a[4]), .ZN(mult_18_n23) );
  NOR2_X1 mult_18_U50 ( .A1(mult_18_n28), .A2(mult_18_n21), .ZN(
        mult_18_ab_3__0_) );
  NOR2_X1 mult_18_U49 ( .A1(mult_18_n26), .A2(mult_18_n21), .ZN(
        mult_18_ab_3__1_) );
  NOR2_X1 mult_18_U48 ( .A1(mult_18_n24), .A2(mult_18_n21), .ZN(
        mult_18_ab_3__2_) );
  NOR2_X1 mult_18_U47 ( .A1(mult_18_n22), .A2(mult_18_n21), .ZN(
        mult_18_ab_3__3_) );
  NOR2_X1 mult_18_U46 ( .A1(mult_18_n21), .A2(mult_18_n20), .ZN(
        mult_18_ab_3__4_) );
  INV_X1 mult_18_U45 ( .A(a[3]), .ZN(mult_18_n21) );
  NOR2_X1 mult_18_U44 ( .A1(mult_18_n28), .A2(mult_18_n19), .ZN(
        mult_18_ab_2__0_) );
  NOR2_X1 mult_18_U43 ( .A1(mult_18_n26), .A2(mult_18_n19), .ZN(
        mult_18_ab_2__1_) );
  NOR2_X1 mult_18_U42 ( .A1(mult_18_n24), .A2(mult_18_n19), .ZN(
        mult_18_ab_2__2_) );
  NOR2_X1 mult_18_U41 ( .A1(mult_18_n22), .A2(mult_18_n19), .ZN(
        mult_18_ab_2__3_) );
  NOR2_X1 mult_18_U40 ( .A1(mult_18_n20), .A2(mult_18_n19), .ZN(
        mult_18_ab_2__4_) );
  NOR2_X1 mult_18_U39 ( .A1(mult_18_n19), .A2(mult_18_n18), .ZN(
        mult_18_ab_2__5_) );
  INV_X1 mult_18_U38 ( .A(a[2]), .ZN(mult_18_n19) );
  NOR2_X1 mult_18_U37 ( .A1(mult_18_n28), .A2(mult_18_n17), .ZN(
        mult_18_ab_1__0_) );
  NOR2_X1 mult_18_U36 ( .A1(mult_18_n29), .A2(mult_18_n26), .ZN(
        mult_18_ab_0__1_) );
  NOR2_X1 mult_18_U35 ( .A1(mult_18_n26), .A2(mult_18_n17), .ZN(
        mult_18_ab_1__1_) );
  INV_X1 mult_18_U34 ( .A(b[1]), .ZN(mult_18_n26) );
  NOR2_X1 mult_18_U33 ( .A1(mult_18_n29), .A2(mult_18_n24), .ZN(
        mult_18_ab_0__2_) );
  NOR2_X1 mult_18_U32 ( .A1(mult_18_n24), .A2(mult_18_n17), .ZN(
        mult_18_ab_1__2_) );
  INV_X1 mult_18_U31 ( .A(b[2]), .ZN(mult_18_n24) );
  NOR2_X1 mult_18_U30 ( .A1(mult_18_n29), .A2(mult_18_n22), .ZN(
        mult_18_ab_0__3_) );
  NOR2_X1 mult_18_U29 ( .A1(mult_18_n22), .A2(mult_18_n17), .ZN(
        mult_18_ab_1__3_) );
  INV_X1 mult_18_U28 ( .A(b[3]), .ZN(mult_18_n22) );
  NOR2_X1 mult_18_U27 ( .A1(mult_18_n29), .A2(mult_18_n20), .ZN(
        mult_18_ab_0__4_) );
  NOR2_X1 mult_18_U26 ( .A1(mult_18_n20), .A2(mult_18_n17), .ZN(
        mult_18_ab_1__4_) );
  INV_X1 mult_18_U25 ( .A(b[4]), .ZN(mult_18_n20) );
  NOR2_X1 mult_18_U24 ( .A1(mult_18_n29), .A2(mult_18_n18), .ZN(
        mult_18_ab_0__5_) );
  NOR2_X1 mult_18_U23 ( .A1(mult_18_n18), .A2(mult_18_n17), .ZN(
        mult_18_ab_1__5_) );
  INV_X1 mult_18_U22 ( .A(b[5]), .ZN(mult_18_n18) );
  NOR2_X1 mult_18_U21 ( .A1(mult_18_n29), .A2(mult_18_n16), .ZN(
        mult_18_ab_0__6_) );
  INV_X1 mult_18_U20 ( .A(a[0]), .ZN(mult_18_n29) );
  NOR2_X1 mult_18_U19 ( .A1(mult_18_n17), .A2(mult_18_n16), .ZN(
        mult_18_ab_1__6_) );
  INV_X1 mult_18_U18 ( .A(b[6]), .ZN(mult_18_n16) );
  INV_X1 mult_18_U17 ( .A(a[1]), .ZN(mult_18_n17) );
  INV_X1 mult_18_U16 ( .A(b[0]), .ZN(mult_18_n28) );
  NAND2_X1 mult_18_U15 ( .A1(n10), .A2(a[0]), .ZN(mult_18_n15) );
  XNOR2_X1 mult_18_U14 ( .A(mult_18_n15), .B(mult_18_ab_1__6_), .ZN(
        mult_18_n14) );
  XOR2_X1 mult_18_U13 ( .A(mult_18_ab_1__0_), .B(mult_18_ab_0__1_), .Z(s2[1])
         );
  AND2_X1 mult_18_U12 ( .A1(mult_18_ab_0__6_), .A2(mult_18_ab_1__5_), .ZN(
        mult_18_n12) );
  AND2_X1 mult_18_U11 ( .A1(mult_18_ab_0__1_), .A2(mult_18_ab_1__0_), .ZN(
        mult_18_n11) );
  AND2_X1 mult_18_U10 ( .A1(mult_18_ab_0__2_), .A2(mult_18_ab_1__1_), .ZN(
        mult_18_n10) );
  AND2_X1 mult_18_U9 ( .A1(mult_18_ab_0__3_), .A2(mult_18_ab_1__2_), .ZN(
        mult_18_n9) );
  AND2_X1 mult_18_U8 ( .A1(mult_18_ab_0__4_), .A2(mult_18_ab_1__3_), .ZN(
        mult_18_n8) );
  AND2_X1 mult_18_U7 ( .A1(mult_18_ab_0__5_), .A2(mult_18_ab_1__4_), .ZN(
        mult_18_n7) );
  XOR2_X1 mult_18_U6 ( .A(mult_18_ab_1__1_), .B(mult_18_ab_0__2_), .Z(
        mult_18_n6) );
  XOR2_X1 mult_18_U5 ( .A(mult_18_ab_1__2_), .B(mult_18_ab_0__3_), .Z(
        mult_18_n5) );
  XOR2_X1 mult_18_U4 ( .A(mult_18_ab_1__3_), .B(mult_18_ab_0__4_), .Z(
        mult_18_n4) );
  XOR2_X1 mult_18_U3 ( .A(mult_18_ab_1__4_), .B(mult_18_ab_0__5_), .Z(
        mult_18_n3) );
  XOR2_X1 mult_18_U2 ( .A(mult_18_ab_1__5_), .B(mult_18_ab_0__6_), .Z(
        mult_18_n2) );
  FA_X1 mult_18_S2_2_5 ( .A(mult_18_ab_2__5_), .B(mult_18_n12), .CI(
        mult_18_n14), .S(mult_18_SUMB_2__5_) );
  FA_X1 mult_18_S2_2_4 ( .A(mult_18_ab_2__4_), .B(mult_18_n7), .CI(mult_18_n2), 
        .CO(mult_18_CARRYB_2__4_), .S(mult_18_SUMB_2__4_) );
  FA_X1 mult_18_S2_2_3 ( .A(mult_18_ab_2__3_), .B(mult_18_n8), .CI(mult_18_n3), 
        .CO(mult_18_CARRYB_2__3_), .S(mult_18_SUMB_2__3_) );
  FA_X1 mult_18_S2_2_2 ( .A(mult_18_ab_2__2_), .B(mult_18_n9), .CI(mult_18_n4), 
        .CO(mult_18_CARRYB_2__2_), .S(mult_18_SUMB_2__2_) );
  FA_X1 mult_18_S2_2_1 ( .A(mult_18_ab_2__1_), .B(mult_18_n10), .CI(mult_18_n5), .CO(mult_18_CARRYB_2__1_), .S(mult_18_SUMB_2__1_) );
  FA_X1 mult_18_S1_2_0 ( .A(mult_18_ab_2__0_), .B(mult_18_n11), .CI(mult_18_n6), .CO(mult_18_CARRYB_2__0_), .S(s2[2]) );
  FA_X1 mult_18_S2_3_4 ( .A(mult_18_ab_3__4_), .B(mult_18_CARRYB_2__4_), .CI(
        mult_18_SUMB_2__5_), .S(mult_18_SUMB_3__4_) );
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
        mult_18_SUMB_2__1_), .CO(mult_18_CARRYB_3__0_), .S(s2[3]) );
  FA_X1 mult_18_S2_4_3 ( .A(mult_18_ab_4__3_), .B(mult_18_CARRYB_3__3_), .CI(
        mult_18_SUMB_3__4_), .S(mult_18_SUMB_4__3_) );
  FA_X1 mult_18_S2_4_2 ( .A(mult_18_ab_4__2_), .B(mult_18_CARRYB_3__2_), .CI(
        mult_18_SUMB_3__3_), .CO(mult_18_CARRYB_4__2_), .S(mult_18_SUMB_4__2_)
         );
  FA_X1 mult_18_S2_4_1 ( .A(mult_18_ab_4__1_), .B(mult_18_CARRYB_3__1_), .CI(
        mult_18_SUMB_3__2_), .CO(mult_18_CARRYB_4__1_), .S(mult_18_SUMB_4__1_)
         );
  FA_X1 mult_18_S1_4_0 ( .A(mult_18_ab_4__0_), .B(mult_18_CARRYB_3__0_), .CI(
        mult_18_SUMB_3__1_), .CO(mult_18_CARRYB_4__0_), .S(s2[4]) );
  FA_X1 mult_18_S2_5_2 ( .A(mult_18_ab_5__2_), .B(mult_18_CARRYB_4__2_), .CI(
        mult_18_SUMB_4__3_), .S(mult_18_SUMB_5__2_) );
  FA_X1 mult_18_S2_5_1 ( .A(mult_18_ab_5__1_), .B(mult_18_CARRYB_4__1_), .CI(
        mult_18_SUMB_4__2_), .CO(mult_18_CARRYB_5__1_), .S(mult_18_SUMB_5__1_)
         );
  FA_X1 mult_18_S1_5_0 ( .A(mult_18_ab_5__0_), .B(mult_18_CARRYB_4__0_), .CI(
        mult_18_SUMB_4__1_), .CO(mult_18_CARRYB_5__0_), .S(s2[5]) );
  FA_X1 mult_18_S2_6_1 ( .A(mult_18_ab_6__1_), .B(mult_18_CARRYB_5__1_), .CI(
        mult_18_SUMB_5__2_), .S(mult_18_SUMB_6__1_) );
  FA_X1 mult_18_S1_6_0 ( .A(mult_18_ab_6__0_), .B(mult_18_CARRYB_5__0_), .CI(
        mult_18_SUMB_5__1_), .CO(mult_18_CARRYB_6__0_), .S(s2[6]) );
  FA_X1 mult_18_S4_0 ( .A(mult_18_ab_7__0_), .B(mult_18_CARRYB_6__0_), .CI(
        mult_18_SUMB_6__1_), .S(s2[7]) );
  NOR2_X1 mult_40_U64 ( .A1(mult_40_n29), .A2(mult_40_n28), .ZN(
        temp_s6_mult_0_) );
  AND2_X1 mult_40_U63 ( .A1(b_plus_1_7_), .A2(a[0]), .ZN(mult_40_ab_7__0_) );
  NOR2_X1 mult_40_U62 ( .A1(mult_40_n28), .A2(mult_40_n27), .ZN(
        mult_40_ab_6__0_) );
  NOR2_X1 mult_40_U61 ( .A1(mult_40_n27), .A2(mult_40_n26), .ZN(
        mult_40_ab_6__1_) );
  INV_X1 mult_40_U60 ( .A(b_plus_1_6_), .ZN(mult_40_n27) );
  NOR2_X1 mult_40_U59 ( .A1(mult_40_n28), .A2(mult_40_n25), .ZN(
        mult_40_ab_5__0_) );
  NOR2_X1 mult_40_U58 ( .A1(mult_40_n26), .A2(mult_40_n25), .ZN(
        mult_40_ab_5__1_) );
  NOR2_X1 mult_40_U57 ( .A1(mult_40_n25), .A2(mult_40_n24), .ZN(
        mult_40_ab_5__2_) );
  INV_X1 mult_40_U56 ( .A(b_plus_1_5_), .ZN(mult_40_n25) );
  NOR2_X1 mult_40_U55 ( .A1(mult_40_n28), .A2(mult_40_n23), .ZN(
        mult_40_ab_4__0_) );
  NOR2_X1 mult_40_U54 ( .A1(mult_40_n26), .A2(mult_40_n23), .ZN(
        mult_40_ab_4__1_) );
  NOR2_X1 mult_40_U53 ( .A1(mult_40_n24), .A2(mult_40_n23), .ZN(
        mult_40_ab_4__2_) );
  NOR2_X1 mult_40_U52 ( .A1(mult_40_n23), .A2(mult_40_n22), .ZN(
        mult_40_ab_4__3_) );
  INV_X1 mult_40_U51 ( .A(b_plus_1_4_), .ZN(mult_40_n23) );
  NOR2_X1 mult_40_U50 ( .A1(mult_40_n28), .A2(mult_40_n21), .ZN(
        mult_40_ab_3__0_) );
  NOR2_X1 mult_40_U49 ( .A1(mult_40_n26), .A2(mult_40_n21), .ZN(
        mult_40_ab_3__1_) );
  NOR2_X1 mult_40_U48 ( .A1(mult_40_n24), .A2(mult_40_n21), .ZN(
        mult_40_ab_3__2_) );
  NOR2_X1 mult_40_U47 ( .A1(mult_40_n22), .A2(mult_40_n21), .ZN(
        mult_40_ab_3__3_) );
  NOR2_X1 mult_40_U46 ( .A1(mult_40_n21), .A2(mult_40_n20), .ZN(
        mult_40_ab_3__4_) );
  INV_X1 mult_40_U45 ( .A(b_plus_1_3_), .ZN(mult_40_n21) );
  NOR2_X1 mult_40_U44 ( .A1(mult_40_n28), .A2(mult_40_n19), .ZN(
        mult_40_ab_2__0_) );
  NOR2_X1 mult_40_U43 ( .A1(mult_40_n26), .A2(mult_40_n19), .ZN(
        mult_40_ab_2__1_) );
  NOR2_X1 mult_40_U42 ( .A1(mult_40_n24), .A2(mult_40_n19), .ZN(
        mult_40_ab_2__2_) );
  NOR2_X1 mult_40_U41 ( .A1(mult_40_n22), .A2(mult_40_n19), .ZN(
        mult_40_ab_2__3_) );
  NOR2_X1 mult_40_U40 ( .A1(mult_40_n20), .A2(mult_40_n19), .ZN(
        mult_40_ab_2__4_) );
  NOR2_X1 mult_40_U39 ( .A1(mult_40_n19), .A2(mult_40_n18), .ZN(
        mult_40_ab_2__5_) );
  INV_X1 mult_40_U38 ( .A(b_plus_1_2_), .ZN(mult_40_n19) );
  NOR2_X1 mult_40_U37 ( .A1(mult_40_n28), .A2(mult_40_n17), .ZN(
        mult_40_ab_1__0_) );
  INV_X1 mult_40_U36 ( .A(a[0]), .ZN(mult_40_n28) );
  NOR2_X1 mult_40_U35 ( .A1(mult_40_n29), .A2(mult_40_n26), .ZN(
        mult_40_ab_0__1_) );
  NOR2_X1 mult_40_U34 ( .A1(mult_40_n26), .A2(mult_40_n17), .ZN(
        mult_40_ab_1__1_) );
  INV_X1 mult_40_U33 ( .A(a[1]), .ZN(mult_40_n26) );
  NOR2_X1 mult_40_U32 ( .A1(mult_40_n29), .A2(mult_40_n24), .ZN(
        mult_40_ab_0__2_) );
  NOR2_X1 mult_40_U31 ( .A1(mult_40_n24), .A2(mult_40_n17), .ZN(
        mult_40_ab_1__2_) );
  INV_X1 mult_40_U30 ( .A(a[2]), .ZN(mult_40_n24) );
  NOR2_X1 mult_40_U29 ( .A1(mult_40_n29), .A2(mult_40_n22), .ZN(
        mult_40_ab_0__3_) );
  NOR2_X1 mult_40_U28 ( .A1(mult_40_n22), .A2(mult_40_n17), .ZN(
        mult_40_ab_1__3_) );
  INV_X1 mult_40_U27 ( .A(a[3]), .ZN(mult_40_n22) );
  NOR2_X1 mult_40_U26 ( .A1(mult_40_n29), .A2(mult_40_n20), .ZN(
        mult_40_ab_0__4_) );
  NOR2_X1 mult_40_U25 ( .A1(mult_40_n20), .A2(mult_40_n17), .ZN(
        mult_40_ab_1__4_) );
  INV_X1 mult_40_U24 ( .A(a[4]), .ZN(mult_40_n20) );
  NOR2_X1 mult_40_U23 ( .A1(mult_40_n29), .A2(mult_40_n18), .ZN(
        mult_40_ab_0__5_) );
  NOR2_X1 mult_40_U22 ( .A1(mult_40_n18), .A2(mult_40_n17), .ZN(
        mult_40_ab_1__5_) );
  INV_X1 mult_40_U21 ( .A(a[5]), .ZN(mult_40_n18) );
  NOR2_X1 mult_40_U20 ( .A1(mult_40_n29), .A2(mult_40_n16), .ZN(
        mult_40_ab_0__6_) );
  INV_X1 mult_40_U19 ( .A(b_plus_1_0_), .ZN(mult_40_n29) );
  NOR2_X1 mult_40_U18 ( .A1(mult_40_n17), .A2(mult_40_n16), .ZN(
        mult_40_ab_1__6_) );
  INV_X1 mult_40_U17 ( .A(a[6]), .ZN(mult_40_n16) );
  INV_X1 mult_40_U16 ( .A(b_plus_1_1_), .ZN(mult_40_n17) );
  NAND2_X1 mult_40_U15 ( .A1(a[7]), .A2(b_plus_1_0_), .ZN(mult_40_n15) );
  XOR2_X1 mult_40_U14 ( .A(mult_40_ab_1__0_), .B(mult_40_ab_0__1_), .Z(
        temp_s6_mult_1_) );
  AND2_X1 mult_40_U13 ( .A1(mult_40_ab_0__1_), .A2(mult_40_ab_1__0_), .ZN(
        mult_40_n13) );
  AND2_X1 mult_40_U12 ( .A1(mult_40_ab_0__2_), .A2(mult_40_ab_1__1_), .ZN(
        mult_40_n12) );
  AND2_X1 mult_40_U11 ( .A1(mult_40_ab_0__3_), .A2(mult_40_ab_1__2_), .ZN(
        mult_40_n11) );
  AND2_X1 mult_40_U10 ( .A1(mult_40_ab_0__4_), .A2(mult_40_ab_1__3_), .ZN(
        mult_40_n10) );
  AND2_X1 mult_40_U9 ( .A1(mult_40_ab_0__5_), .A2(mult_40_ab_1__4_), .ZN(
        mult_40_n9) );
  AND2_X1 mult_40_U8 ( .A1(mult_40_ab_0__6_), .A2(mult_40_ab_1__5_), .ZN(
        mult_40_n8) );
  XOR2_X1 mult_40_U7 ( .A(mult_40_ab_1__1_), .B(mult_40_ab_0__2_), .Z(
        mult_40_n7) );
  XOR2_X1 mult_40_U6 ( .A(mult_40_ab_1__2_), .B(mult_40_ab_0__3_), .Z(
        mult_40_n6) );
  XOR2_X1 mult_40_U5 ( .A(mult_40_ab_1__3_), .B(mult_40_ab_0__4_), .Z(
        mult_40_n5) );
  XOR2_X1 mult_40_U4 ( .A(mult_40_ab_1__4_), .B(mult_40_ab_0__5_), .Z(
        mult_40_n4) );
  XOR2_X1 mult_40_U3 ( .A(mult_40_ab_1__5_), .B(mult_40_ab_0__6_), .Z(
        mult_40_n3) );
  XNOR2_X1 mult_40_U2 ( .A(mult_40_n15), .B(mult_40_ab_1__6_), .ZN(mult_40_n2)
         );
  FA_X1 mult_40_S2_2_5 ( .A(mult_40_ab_2__5_), .B(mult_40_n8), .CI(mult_40_n2), 
        .S(mult_40_SUMB_2__5_) );
  FA_X1 mult_40_S2_2_4 ( .A(mult_40_ab_2__4_), .B(mult_40_n9), .CI(mult_40_n3), 
        .CO(mult_40_CARRYB_2__4_), .S(mult_40_SUMB_2__4_) );
  FA_X1 mult_40_S2_2_3 ( .A(mult_40_ab_2__3_), .B(mult_40_n10), .CI(mult_40_n4), .CO(mult_40_CARRYB_2__3_), .S(mult_40_SUMB_2__3_) );
  FA_X1 mult_40_S2_2_2 ( .A(mult_40_ab_2__2_), .B(mult_40_n11), .CI(mult_40_n5), .CO(mult_40_CARRYB_2__2_), .S(mult_40_SUMB_2__2_) );
  FA_X1 mult_40_S2_2_1 ( .A(mult_40_ab_2__1_), .B(mult_40_n12), .CI(mult_40_n6), .CO(mult_40_CARRYB_2__1_), .S(mult_40_SUMB_2__1_) );
  FA_X1 mult_40_S1_2_0 ( .A(mult_40_ab_2__0_), .B(mult_40_n13), .CI(mult_40_n7), .CO(mult_40_CARRYB_2__0_), .S(temp_s6_mult_2_) );
  FA_X1 mult_40_S2_3_4 ( .A(mult_40_ab_3__4_), .B(mult_40_CARRYB_2__4_), .CI(
        mult_40_SUMB_2__5_), .S(mult_40_SUMB_3__4_) );
  FA_X1 mult_40_S2_3_3 ( .A(mult_40_ab_3__3_), .B(mult_40_CARRYB_2__3_), .CI(
        mult_40_SUMB_2__4_), .CO(mult_40_CARRYB_3__3_), .S(mult_40_SUMB_3__3_)
         );
  FA_X1 mult_40_S2_3_2 ( .A(mult_40_ab_3__2_), .B(mult_40_CARRYB_2__2_), .CI(
        mult_40_SUMB_2__3_), .CO(mult_40_CARRYB_3__2_), .S(mult_40_SUMB_3__2_)
         );
  FA_X1 mult_40_S2_3_1 ( .A(mult_40_ab_3__1_), .B(mult_40_CARRYB_2__1_), .CI(
        mult_40_SUMB_2__2_), .CO(mult_40_CARRYB_3__1_), .S(mult_40_SUMB_3__1_)
         );
  FA_X1 mult_40_S1_3_0 ( .A(mult_40_ab_3__0_), .B(mult_40_CARRYB_2__0_), .CI(
        mult_40_SUMB_2__1_), .CO(mult_40_CARRYB_3__0_), .S(temp_s6_mult_3_) );
  FA_X1 mult_40_S2_4_3 ( .A(mult_40_ab_4__3_), .B(mult_40_CARRYB_3__3_), .CI(
        mult_40_SUMB_3__4_), .S(mult_40_SUMB_4__3_) );
  FA_X1 mult_40_S2_4_2 ( .A(mult_40_ab_4__2_), .B(mult_40_CARRYB_3__2_), .CI(
        mult_40_SUMB_3__3_), .CO(mult_40_CARRYB_4__2_), .S(mult_40_SUMB_4__2_)
         );
  FA_X1 mult_40_S2_4_1 ( .A(mult_40_ab_4__1_), .B(mult_40_CARRYB_3__1_), .CI(
        mult_40_SUMB_3__2_), .CO(mult_40_CARRYB_4__1_), .S(mult_40_SUMB_4__1_)
         );
  FA_X1 mult_40_S1_4_0 ( .A(mult_40_ab_4__0_), .B(mult_40_CARRYB_3__0_), .CI(
        mult_40_SUMB_3__1_), .CO(mult_40_CARRYB_4__0_), .S(temp_s6_mult_4_) );
  FA_X1 mult_40_S2_5_2 ( .A(mult_40_ab_5__2_), .B(mult_40_CARRYB_4__2_), .CI(
        mult_40_SUMB_4__3_), .S(mult_40_SUMB_5__2_) );
  FA_X1 mult_40_S2_5_1 ( .A(mult_40_ab_5__1_), .B(mult_40_CARRYB_4__1_), .CI(
        mult_40_SUMB_4__2_), .CO(mult_40_CARRYB_5__1_), .S(mult_40_SUMB_5__1_)
         );
  FA_X1 mult_40_S1_5_0 ( .A(mult_40_ab_5__0_), .B(mult_40_CARRYB_4__0_), .CI(
        mult_40_SUMB_4__1_), .CO(mult_40_CARRYB_5__0_), .S(temp_s6_mult_5_) );
  FA_X1 mult_40_S2_6_1 ( .A(mult_40_ab_6__1_), .B(mult_40_CARRYB_5__1_), .CI(
        mult_40_SUMB_5__2_), .S(mult_40_SUMB_6__1_) );
  FA_X1 mult_40_S1_6_0 ( .A(mult_40_ab_6__0_), .B(mult_40_CARRYB_5__0_), .CI(
        mult_40_SUMB_5__1_), .CO(mult_40_CARRYB_6__0_), .S(temp_s6_mult_6_) );
  FA_X1 mult_40_S4_0 ( .A(mult_40_ab_7__0_), .B(mult_40_CARRYB_6__0_), .CI(
        mult_40_SUMB_6__1_), .S(temp_s6_mult_7_) );
  XOR2_X1 add_1_root_add_0_root_sub_42_U2 ( .A(temp_s6_intermediate_0_), .B(
        c[0]), .Z(N0) );
  AND2_X1 add_1_root_add_0_root_sub_42_U1 ( .A1(temp_s6_intermediate_0_), .A2(
        c[0]), .ZN(add_1_root_add_0_root_sub_42_n1) );
  FA_X1 add_1_root_add_0_root_sub_42_U1_1 ( .A(c[1]), .B(
        temp_s6_intermediate_1_), .CI(add_1_root_add_0_root_sub_42_n1), .CO(
        add_1_root_add_0_root_sub_42_carry[2]), .S(N1) );
  FA_X1 add_1_root_add_0_root_sub_42_U1_2 ( .A(c[2]), .B(
        temp_s6_intermediate_2_), .CI(add_1_root_add_0_root_sub_42_carry[2]), 
        .CO(add_1_root_add_0_root_sub_42_carry[3]), .S(N2) );
  FA_X1 add_1_root_add_0_root_sub_42_U1_3 ( .A(c[3]), .B(
        temp_s6_intermediate_3_), .CI(add_1_root_add_0_root_sub_42_carry[3]), 
        .CO(add_1_root_add_0_root_sub_42_carry[4]), .S(N3) );
  FA_X1 add_1_root_add_0_root_sub_42_U1_4 ( .A(c[4]), .B(
        temp_s6_intermediate_4_), .CI(add_1_root_add_0_root_sub_42_carry[4]), 
        .CO(add_1_root_add_0_root_sub_42_carry[5]), .S(N4) );
  FA_X1 add_1_root_add_0_root_sub_42_U1_5 ( .A(c[5]), .B(
        temp_s6_intermediate_5_), .CI(add_1_root_add_0_root_sub_42_carry[5]), 
        .CO(add_1_root_add_0_root_sub_42_carry[6]), .S(N5) );
  FA_X1 add_1_root_add_0_root_sub_42_U1_6 ( .A(c[6]), .B(
        temp_s6_intermediate_6_), .CI(add_1_root_add_0_root_sub_42_carry[6]), 
        .CO(add_1_root_add_0_root_sub_42_carry[7]), .S(N6) );
  FA_X1 add_1_root_add_0_root_sub_42_U1_7 ( .A(c[7]), .B(
        temp_s6_intermediate_7_), .CI(add_1_root_add_0_root_sub_42_carry[7]), 
        .S(N7) );
  XOR2_X1 add_0_root_add_0_root_sub_42_U2 ( .A(temp_s6_mult_0_), .B(N0), .Z(
        s6[0]) );
  AND2_X1 add_0_root_add_0_root_sub_42_U1 ( .A1(temp_s6_mult_0_), .A2(N0), 
        .ZN(add_0_root_add_0_root_sub_42_n1) );
  FA_X1 add_0_root_add_0_root_sub_42_U1_1 ( .A(N1), .B(temp_s6_mult_1_), .CI(
        add_0_root_add_0_root_sub_42_n1), .CO(
        add_0_root_add_0_root_sub_42_carry[2]), .S(s6[1]) );
  FA_X1 add_0_root_add_0_root_sub_42_U1_2 ( .A(N2), .B(temp_s6_mult_2_), .CI(
        add_0_root_add_0_root_sub_42_carry[2]), .CO(
        add_0_root_add_0_root_sub_42_carry[3]), .S(s6[2]) );
  FA_X1 add_0_root_add_0_root_sub_42_U1_3 ( .A(N3), .B(temp_s6_mult_3_), .CI(
        add_0_root_add_0_root_sub_42_carry[3]), .CO(
        add_0_root_add_0_root_sub_42_carry[4]), .S(s6[3]) );
  FA_X1 add_0_root_add_0_root_sub_42_U1_4 ( .A(N4), .B(temp_s6_mult_4_), .CI(
        add_0_root_add_0_root_sub_42_carry[4]), .CO(
        add_0_root_add_0_root_sub_42_carry[5]), .S(s6[4]) );
  FA_X1 add_0_root_add_0_root_sub_42_U1_5 ( .A(N5), .B(temp_s6_mult_5_), .CI(
        add_0_root_add_0_root_sub_42_carry[5]), .CO(
        add_0_root_add_0_root_sub_42_carry[6]), .S(s6[5]) );
  FA_X1 add_0_root_add_0_root_sub_42_U1_6 ( .A(N6), .B(temp_s6_mult_6_), .CI(
        add_0_root_add_0_root_sub_42_carry[6]), .CO(
        add_0_root_add_0_root_sub_42_carry[7]), .S(s6[6]) );
  FA_X1 add_0_root_add_0_root_sub_42_U1_7 ( .A(N7), .B(temp_s6_mult_7_), .CI(
        add_0_root_add_0_root_sub_42_carry[7]), .S(s6[7]) );
  XOR2_X1 add_1_root_add_0_root_add_30_U2 ( .A(d[0]), .B(c[0]), .Z(c_plus_d_0_) );
  AND2_X1 add_1_root_add_0_root_add_30_U1 ( .A1(d[0]), .A2(c[0]), .ZN(
        add_1_root_add_0_root_add_30_n1) );
  FA_X1 add_1_root_add_0_root_add_30_U1_1 ( .A(c[1]), .B(d[1]), .CI(
        add_1_root_add_0_root_add_30_n1), .CO(
        add_1_root_add_0_root_add_30_carry[2]), .S(c_plus_d_1_) );
  FA_X1 add_1_root_add_0_root_add_30_U1_2 ( .A(c[2]), .B(d[2]), .CI(
        add_1_root_add_0_root_add_30_carry[2]), .CO(
        add_1_root_add_0_root_add_30_carry[3]), .S(c_plus_d_2_) );
  FA_X1 add_1_root_add_0_root_add_30_U1_3 ( .A(c[3]), .B(d[3]), .CI(
        add_1_root_add_0_root_add_30_carry[3]), .CO(
        add_1_root_add_0_root_add_30_carry[4]), .S(c_plus_d_3_) );
  FA_X1 add_1_root_add_0_root_add_30_U1_4 ( .A(c[4]), .B(d[4]), .CI(
        add_1_root_add_0_root_add_30_carry[4]), .CO(
        add_1_root_add_0_root_add_30_carry[5]), .S(c_plus_d_4_) );
  FA_X1 add_1_root_add_0_root_add_30_U1_5 ( .A(c[5]), .B(d[5]), .CI(
        add_1_root_add_0_root_add_30_carry[5]), .CO(
        add_1_root_add_0_root_add_30_carry[6]), .S(c_plus_d_5_) );
  FA_X1 add_1_root_add_0_root_add_30_U1_6 ( .A(c[6]), .B(d[6]), .CI(
        add_1_root_add_0_root_add_30_carry[6]), .CO(
        add_1_root_add_0_root_add_30_carry[7]), .S(c_plus_d_6_) );
  FA_X1 add_1_root_add_0_root_add_30_U1_7 ( .A(c[7]), .B(d[7]), .CI(
        add_1_root_add_0_root_add_30_carry[7]), .S(c_plus_d_7_) );
  XOR2_X1 add_0_root_add_0_root_add_30_U2 ( .A(s2[0]), .B(c_plus_d_0_), .Z(
        s4[0]) );
  AND2_X1 add_0_root_add_0_root_add_30_U1 ( .A1(s2[0]), .A2(c_plus_d_0_), .ZN(
        add_0_root_add_0_root_add_30_n1) );
  FA_X1 add_0_root_add_0_root_add_30_U1_1 ( .A(c_plus_d_1_), .B(s2[1]), .CI(
        add_0_root_add_0_root_add_30_n1), .CO(
        add_0_root_add_0_root_add_30_carry[2]), .S(s4[1]) );
  FA_X1 add_0_root_add_0_root_add_30_U1_2 ( .A(c_plus_d_2_), .B(s2[2]), .CI(
        add_0_root_add_0_root_add_30_carry[2]), .CO(
        add_0_root_add_0_root_add_30_carry[3]), .S(s4[2]) );
  FA_X1 add_0_root_add_0_root_add_30_U1_3 ( .A(c_plus_d_3_), .B(s2[3]), .CI(
        add_0_root_add_0_root_add_30_carry[3]), .CO(
        add_0_root_add_0_root_add_30_carry[4]), .S(s4[3]) );
  FA_X1 add_0_root_add_0_root_add_30_U1_4 ( .A(c_plus_d_4_), .B(s2[4]), .CI(
        add_0_root_add_0_root_add_30_carry[4]), .CO(
        add_0_root_add_0_root_add_30_carry[5]), .S(s4[4]) );
  FA_X1 add_0_root_add_0_root_add_30_U1_5 ( .A(c_plus_d_5_), .B(s2[5]), .CI(
        add_0_root_add_0_root_add_30_carry[5]), .CO(
        add_0_root_add_0_root_add_30_carry[6]), .S(s4[5]) );
  FA_X1 add_0_root_add_0_root_add_30_U1_6 ( .A(c_plus_d_6_), .B(s2[6]), .CI(
        add_0_root_add_0_root_add_30_carry[6]), .CO(
        add_0_root_add_0_root_add_30_carry[7]), .S(s4[6]) );
  FA_X1 add_0_root_add_0_root_add_30_U1_7 ( .A(c_plus_d_7_), .B(s2[7]), .CI(
        add_0_root_add_0_root_add_30_carry[7]), .S(s4[7]) );
  INV_X1 add_26_U78 ( .A(add_26_n59), .ZN(add_26_n31) );
  INV_X1 add_26_U77 ( .A(add_26_n64), .ZN(add_26_n41) );
  INV_X1 add_26_U76 ( .A(add_26_n45), .ZN(add_26_n54) );
  INV_X1 add_26_U75 ( .A(add_26_n46), .ZN(add_26_n51) );
  INV_X1 add_26_U74 ( .A(add_26_n34), .ZN(add_26_n44) );
  XNOR2_X1 add_26_U73 ( .A(add_26_n42), .B(add_26_n43), .ZN(s3[6]) );
  INV_X1 add_26_U72 ( .A(add_26_n37), .ZN(add_26_n36) );
  INV_X1 add_26_U71 ( .A(add_26_n1), .ZN(add_26_n28) );
  NOR2_X1 add_26_U70 ( .A1(add_26_n32), .A2(add_26_n31), .ZN(add_26_n29) );
  XNOR2_X1 add_26_U69 ( .A(add_26_n23), .B(add_26_n24), .ZN(s3[7]) );
  NAND2_X1 add_26_U68 ( .A1(a_mod_b_0_), .A2(d[0]), .ZN(add_26_n61) );
  INV_X1 add_26_U67 ( .A(add_26_n18), .ZN(add_26_n70) );
  NAND2_X1 add_26_U66 ( .A1(add_26_n60), .A2(add_26_n61), .ZN(add_26_n30) );
  AOI21_X1 add_26_U65 ( .B1(add_26_n48), .B2(add_26_n47), .A(add_26_n54), .ZN(
        add_26_n49) );
  XNOR2_X1 add_26_U64 ( .A(add_26_n14), .B(add_26_n55), .ZN(s3[4]) );
  NAND2_X1 add_26_U63 ( .A1(a_mod_b_1_), .A2(d[1]), .ZN(add_26_n60) );
  NAND2_X1 add_26_U62 ( .A1(add_26_n57), .A2(add_26_n56), .ZN(add_26_n48) );
  NOR2_X1 add_26_U61 ( .A1(add_26_n58), .A2(add_26_n3), .ZN(add_26_n57) );
  XNOR2_X1 add_26_U60 ( .A(add_26_n49), .B(add_26_n50), .ZN(s3[5]) );
  NAND2_X1 add_26_U59 ( .A1(d[3]), .A2(a_mod_b_3_), .ZN(add_26_n64) );
  AOI21_X1 add_26_U58 ( .B1(add_26_n38), .B2(add_26_n22), .A(add_26_n39), .ZN(
        add_26_n25) );
  NAND2_X1 add_26_U57 ( .A1(d[4]), .A2(a_mod_b_4_), .ZN(add_26_n45) );
  NOR2_X1 add_26_U56 ( .A1(add_26_n40), .A2(add_26_n33), .ZN(add_26_n39) );
  NOR2_X1 add_26_U55 ( .A1(add_26_n32), .A2(add_26_n33), .ZN(add_26_n38) );
  OAI21_X1 add_26_U54 ( .B1(add_26_n15), .B2(add_26_n2), .A(add_26_n44), .ZN(
        add_26_n42) );
  NAND2_X1 add_26_U53 ( .A1(add_26_n65), .A2(add_26_n16), .ZN(add_26_n67) );
  NAND2_X1 add_26_U52 ( .A1(a_mod_b_2_), .A2(d[2]), .ZN(add_26_n65) );
  NAND3_X1 add_26_U51 ( .A1(add_26_n25), .A2(add_26_n27), .A3(add_26_n26), 
        .ZN(add_26_n23) );
  INV_X1 add_26_U50 ( .A(d[0]), .ZN(add_26_n69) );
  NAND2_X1 add_26_U49 ( .A1(add_26_n70), .A2(add_26_n69), .ZN(add_26_n68) );
  NAND2_X1 add_26_U48 ( .A1(d[6]), .A2(a_mod_b_6_), .ZN(add_26_n37) );
  NAND2_X1 add_26_U47 ( .A1(d[5]), .A2(a_mod_b_5_), .ZN(add_26_n46) );
  INV_X1 add_26_U46 ( .A(a_mod_b_5_), .ZN(add_26_n53) );
  INV_X1 add_26_U45 ( .A(d[5]), .ZN(add_26_n52) );
  XNOR2_X1 add_26_U44 ( .A(d[7]), .B(a_mod_b_7_), .ZN(add_26_n24) );
  XNOR2_X1 add_26_U43 ( .A(add_26_n8), .B(add_26_n67), .ZN(s3[2]) );
  NAND2_X1 add_26_U42 ( .A1(add_26_n45), .A2(add_26_n47), .ZN(add_26_n55) );
  AOI21_X1 add_26_U41 ( .B1(add_26_n34), .B2(add_26_n13), .A(add_26_n36), .ZN(
        add_26_n26) );
  OAI21_X1 add_26_U40 ( .B1(add_26_n4), .B2(add_26_n45), .A(add_26_n46), .ZN(
        add_26_n34) );
  NAND2_X1 add_26_U39 ( .A1(add_26_n41), .A2(add_26_n35), .ZN(add_26_n40) );
  NOR2_X1 add_26_U38 ( .A1(add_26_n4), .A2(add_26_n51), .ZN(add_26_n50) );
  NAND2_X1 add_26_U37 ( .A1(add_26_n37), .A2(add_26_n13), .ZN(add_26_n43) );
  INV_X1 add_26_U36 ( .A(add_26_n22), .ZN(add_26_n56) );
  NAND2_X1 add_26_U35 ( .A1(add_26_n59), .A2(add_26_n20), .ZN(add_26_n21) );
  XNOR2_X1 add_26_U34 ( .A(add_26_n21), .B(add_26_n19), .ZN(s3[1]) );
  AND2_X1 add_26_U33 ( .A1(add_26_n10), .A2(add_26_n17), .ZN(add_26_n22) );
  OR2_X1 add_26_U32 ( .A1(d[3]), .A2(a_mod_b_3_), .ZN(add_26_n63) );
  OR2_X1 add_26_U31 ( .A1(a_mod_b_3_), .A2(d[3]), .ZN(add_26_n17) );
  OR2_X1 add_26_U30 ( .A1(a_mod_b_2_), .A2(d[2]), .ZN(add_26_n62) );
  OR2_X1 add_26_U29 ( .A1(a_mod_b_2_), .A2(d[2]), .ZN(add_26_n16) );
  OR2_X2 add_26_U28 ( .A1(a_mod_b_1_), .A2(d[1]), .ZN(add_26_n59) );
  OR2_X1 add_26_U27 ( .A1(a_mod_b_6_), .A2(d[6]), .ZN(add_26_n35) );
  AND2_X1 add_26_U26 ( .A1(add_26_n63), .A2(add_26_n62), .ZN(add_26_n12) );
  AND4_X1 add_26_U25 ( .A1(add_26_n30), .A2(add_26_n63), .A3(add_26_n62), .A4(
        add_26_n59), .ZN(add_26_n58) );
  NAND4_X1 add_26_U24 ( .A1(add_26_n29), .A2(add_26_n28), .A3(add_26_n30), 
        .A4(add_26_n12), .ZN(add_26_n27) );
  NOR3_X1 add_26_U23 ( .A1(add_26_n9), .A2(add_26_n22), .A3(add_26_n3), .ZN(
        add_26_n15) );
  INV_X1 add_26_U22 ( .A(add_26_n13), .ZN(add_26_n32) );
  INV_X1 add_26_U21 ( .A(add_26_n65), .ZN(add_26_n10) );
  AOI21_X1 add_26_U20 ( .B1(add_26_n66), .B2(add_26_n16), .A(add_26_n10), .ZN(
        add_26_n11) );
  AND4_X1 add_26_U19 ( .A1(add_26_n30), .A2(add_26_n63), .A3(add_26_n62), .A4(
        add_26_n59), .ZN(add_26_n9) );
  BUF_X1 add_26_U18 ( .A(add_26_n48), .Z(add_26_n14) );
  OAI21_X1 add_26_U17 ( .B1(add_26_n6), .B2(add_26_n31), .A(add_26_n20), .ZN(
        add_26_n66) );
  OAI21_X1 add_26_U16 ( .B1(add_26_n6), .B2(add_26_n31), .A(add_26_n20), .ZN(
        add_26_n8) );
  AND2_X1 add_26_U15 ( .A1(add_26_n64), .A2(add_26_n17), .ZN(add_26_n7) );
  XNOR2_X1 add_26_U14 ( .A(add_26_n11), .B(add_26_n7), .ZN(s3[3]) );
  NAND2_X1 add_26_U13 ( .A1(add_26_n18), .A2(d[0]), .ZN(add_26_n6) );
  BUF_X1 add_26_U12 ( .A(a_mod_b_0_), .Z(add_26_n18) );
  BUF_X1 add_26_U11 ( .A(add_26_n60), .Z(add_26_n20) );
  AND2_X1 add_26_U10 ( .A1(add_26_n18), .A2(d[0]), .ZN(add_26_n19) );
  AND2_X1 add_26_U9 ( .A1(add_26_n6), .A2(add_26_n68), .ZN(s3[0]) );
  AND2_X1 add_26_U8 ( .A1(add_26_n52), .A2(add_26_n53), .ZN(add_26_n4) );
  OR2_X1 add_26_U7 ( .A1(d[4]), .A2(a_mod_b_4_), .ZN(add_26_n47) );
  OR2_X2 add_26_U6 ( .A1(a_mod_b_6_), .A2(d[6]), .ZN(add_26_n13) );
  BUF_X1 add_26_U5 ( .A(add_26_n41), .Z(add_26_n3) );
  OAI22_X1 add_26_U4 ( .A1(d[5]), .A2(a_mod_b_5_), .B1(d[4]), .B2(a_mod_b_4_), 
        .ZN(add_26_n33) );
  INV_X1 add_26_U3 ( .A(add_26_n28), .ZN(add_26_n2) );
  OAI22_X1 add_26_U2 ( .A1(d[5]), .A2(a_mod_b_5_), .B1(d[4]), .B2(a_mod_b_4_), 
        .ZN(add_26_n1) );
  MUX2_X1 rem_25_U310 ( .A(a[0]), .B(rem_25_u_div_SumTmp_0__0_), .S(
        rem_25_n102), .Z(a_mod_b_0_) );
  MUX2_X1 rem_25_U309 ( .A(rem_25_n62), .B(rem_25_u_div_SumTmp_0__1_), .S(
        rem_25_u_div_CryTmp_0__8_), .Z(a_mod_b_1_) );
  MUX2_X1 rem_25_U308 ( .A(rem_25_n222), .B(rem_25_n27), .S(rem_25_n36), .Z(
        rem_25_n236) );
  INV_X1 rem_25_U307 ( .A(rem_25_n236), .ZN(rem_25_u_div_PartRem_1__2_) );
  MUX2_X1 rem_25_U306 ( .A(rem_25_u_div_PartRem_1__2_), .B(
        rem_25_u_div_SumTmp_0__2_), .S(rem_25_n102), .Z(a_mod_b_2_) );
  MUX2_X1 rem_25_U305 ( .A(rem_25_n216), .B(rem_25_n23), .S(rem_25_n190), .Z(
        rem_25_n221) );
  MUX2_X1 rem_25_U304 ( .A(rem_25_n221), .B(rem_25_n235), .S(rem_25_n36), .Z(
        rem_25_n234) );
  MUX2_X1 rem_25_U303 ( .A(rem_25_n211), .B(rem_25_n16), .S(rem_25_n187), .Z(
        rem_25_n215) );
  MUX2_X1 rem_25_U302 ( .A(rem_25_n215), .B(rem_25_n232), .S(rem_25_n190), .Z(
        rem_25_n220) );
  MUX2_X1 rem_25_U301 ( .A(rem_25_n220), .B(rem_25_n28), .S(rem_25_n36), .Z(
        rem_25_n231) );
  INV_X1 rem_25_U300 ( .A(rem_25_n231), .ZN(rem_25_u_div_PartRem_1__4_) );
  MUX2_X1 rem_25_U299 ( .A(rem_25_u_div_PartRem_1__4_), .B(
        rem_25_u_div_SumTmp_0__4_), .S(rem_25_u_div_CryTmp_0__8_), .Z(
        a_mod_b_4_) );
  INV_X2 rem_25_U298 ( .A(b[3]), .ZN(rem_25_u_div_BInv[3]) );
  MUX2_X1 rem_25_U297 ( .A(rem_25_n63), .B(rem_25_n15), .S(rem_25_n188), .Z(
        rem_25_n210) );
  MUX2_X1 rem_25_U296 ( .A(rem_25_n210), .B(rem_25_n17), .S(rem_25_n187), .Z(
        rem_25_n214) );
  MUX2_X1 rem_25_U295 ( .A(rem_25_n214), .B(rem_25_n21), .S(rem_25_n190), .Z(
        rem_25_n219) );
  MUX2_X1 rem_25_U294 ( .A(rem_25_n219), .B(rem_25_n26), .S(rem_25_n36), .Z(
        rem_25_n230) );
  INV_X1 rem_25_U293 ( .A(rem_25_n230), .ZN(rem_25_u_div_PartRem_1__5_) );
  MUX2_X1 rem_25_U292 ( .A(rem_25_u_div_PartRem_1__5_), .B(
        rem_25_u_div_SumTmp_0__5_), .S(rem_25_n102), .Z(a_mod_b_5_) );
  MUX2_X1 rem_25_U291 ( .A(rem_25_n107), .B(rem_25_n14), .S(rem_25_n189), .Z(
        rem_25_n206) );
  MUX2_X1 rem_25_U290 ( .A(rem_25_n206), .B(rem_25_n229), .S(rem_25_n188), .Z(
        rem_25_n209) );
  MUX2_X1 rem_25_U289 ( .A(rem_25_n209), .B(rem_25_n18), .S(rem_25_n187), .Z(
        rem_25_n213) );
  MUX2_X1 rem_25_U288 ( .A(rem_25_n213), .B(rem_25_n22), .S(rem_25_n190), .Z(
        rem_25_n218) );
  MUX2_X1 rem_25_U287 ( .A(rem_25_n218), .B(rem_25_n25), .S(rem_25_n36), .Z(
        rem_25_n228) );
  INV_X1 rem_25_U286 ( .A(rem_25_n228), .ZN(rem_25_u_div_PartRem_1__6_) );
  MUX2_X1 rem_25_U285 ( .A(rem_25_n202), .B(rem_25_n226), .S(rem_25_n227), .Z(
        rem_25_n203) );
  MUX2_X1 rem_25_U284 ( .A(rem_25_n203), .B(rem_25_n225), .S(rem_25_n189), .Z(
        rem_25_n205) );
  MUX2_X1 rem_25_U283 ( .A(rem_25_n205), .B(rem_25_n224), .S(rem_25_n43), .Z(
        rem_25_n208) );
  MUX2_X1 rem_25_U282 ( .A(rem_25_n208), .B(rem_25_n19), .S(rem_25_n187), .Z(
        rem_25_n212) );
  MUX2_X1 rem_25_U281 ( .A(rem_25_n212), .B(rem_25_n20), .S(rem_25_n190), .Z(
        rem_25_n217) );
  MUX2_X1 rem_25_U280 ( .A(rem_25_n217), .B(rem_25_n24), .S(rem_25_n36), .Z(
        rem_25_n223) );
  INV_X1 rem_25_U279 ( .A(rem_25_n223), .ZN(rem_25_u_div_PartRem_1__7_) );
  MUX2_X1 rem_25_U278 ( .A(rem_25_u_div_PartRem_1__7_), .B(
        rem_25_u_div_SumTmp_0__7_), .S(rem_25_n102), .Z(a_mod_b_7_) );
  INV_X2 rem_25_U277 ( .A(b[1]), .ZN(rem_25_u_div_BInv[1]) );
  INV_X1 rem_25_U276 ( .A(rem_25_n221), .ZN(rem_25_u_div_PartRem_2__2_) );
  INV_X1 rem_25_U275 ( .A(rem_25_n220), .ZN(rem_25_u_div_PartRem_2__3_) );
  INV_X1 rem_25_U274 ( .A(rem_25_n219), .ZN(rem_25_u_div_PartRem_2__4_) );
  INV_X1 rem_25_U273 ( .A(rem_25_n218), .ZN(rem_25_u_div_PartRem_2__5_) );
  INV_X1 rem_25_U272 ( .A(rem_25_n217), .ZN(rem_25_u_div_PartRem_2__6_) );
  INV_X1 rem_25_U271 ( .A(rem_25_n215), .ZN(rem_25_u_div_PartRem_3__2_) );
  INV_X1 rem_25_U270 ( .A(rem_25_n214), .ZN(rem_25_u_div_PartRem_3__3_) );
  INV_X1 rem_25_U269 ( .A(rem_25_n213), .ZN(rem_25_u_div_PartRem_3__4_) );
  INV_X1 rem_25_U268 ( .A(rem_25_n212), .ZN(rem_25_u_div_PartRem_3__5_) );
  INV_X1 rem_25_U267 ( .A(rem_25_n210), .ZN(rem_25_u_div_PartRem_4__2_) );
  INV_X1 rem_25_U266 ( .A(rem_25_n209), .ZN(rem_25_u_div_PartRem_4__3_) );
  INV_X1 rem_25_U265 ( .A(rem_25_n208), .ZN(rem_25_u_div_PartRem_4__4_) );
  INV_X1 rem_25_U264 ( .A(rem_25_n206), .ZN(rem_25_u_div_PartRem_5__2_) );
  INV_X1 rem_25_U263 ( .A(rem_25_n205), .ZN(rem_25_u_div_PartRem_5__3_) );
  INV_X1 rem_25_U262 ( .A(rem_25_n203), .ZN(rem_25_u_div_PartRem_6__2_) );
  MUX2_X2 rem_25_U261 ( .A(a[1]), .B(rem_25_u_div_SumTmp_1__0_), .S(
        rem_25_n237), .Z(rem_25_u_div_PartRem_1__1_) );
  INV_X1 rem_25_U260 ( .A(b[7]), .ZN(rem_25_u_div_BInv[7]) );
  AND2_X1 rem_25_U259 ( .A1(rem_25_n79), .A2(rem_25_u_div_BInv[7]), .ZN(
        rem_25_n237) );
  INV_X1 rem_25_U258 ( .A(b[0]), .ZN(rem_25_n200) );
  XNOR2_X1 rem_25_U257 ( .A(rem_25_n199), .B(a[2]), .ZN(
        rem_25_u_div_SumTmp_2__0_) );
  XNOR2_X1 rem_25_U256 ( .A(rem_25_n200), .B(a[3]), .ZN(
        rem_25_u_div_SumTmp_3__0_) );
  XNOR2_X1 rem_25_U255 ( .A(rem_25_n199), .B(a[4]), .ZN(
        rem_25_u_div_SumTmp_4__0_) );
  XNOR2_X1 rem_25_U254 ( .A(rem_25_n199), .B(a[7]), .ZN(
        rem_25_u_div_SumTmp_7__0_) );
  XNOR2_X1 rem_25_U253 ( .A(rem_25_n200), .B(a[1]), .ZN(
        rem_25_u_div_SumTmp_1__0_) );
  INV_X1 rem_25_U252 ( .A(a[6]), .ZN(rem_25_n191) );
  NAND2_X1 rem_25_U251 ( .A1(rem_25_n194), .A2(rem_25_n191), .ZN(
        rem_25_u_div_CryTmp_6__1_) );
  XNOR2_X1 rem_25_U250 ( .A(rem_25_n199), .B(a[0]), .ZN(
        rem_25_u_div_SumTmp_0__0_) );
  NOR2_X1 rem_25_U249 ( .A1(b[5]), .A2(b[4]), .ZN(rem_25_n233) );
  OR2_X1 rem_25_U248 ( .A1(rem_25_n199), .A2(a[0]), .ZN(
        rem_25_u_div_CryTmp_0__1_) );
  INV_X1 rem_25_U247 ( .A(a[1]), .ZN(rem_25_n198) );
  NAND2_X1 rem_25_U246 ( .A1(rem_25_n197), .A2(rem_25_n198), .ZN(
        rem_25_u_div_CryTmp_1__1_) );
  INV_X1 rem_25_U245 ( .A(a[2]), .ZN(rem_25_n196) );
  NAND2_X1 rem_25_U244 ( .A1(rem_25_n197), .A2(rem_25_n196), .ZN(
        rem_25_u_div_CryTmp_2__1_) );
  INV_X1 rem_25_U243 ( .A(a[3]), .ZN(rem_25_n195) );
  NAND2_X1 rem_25_U242 ( .A1(rem_25_n194), .A2(rem_25_n195), .ZN(
        rem_25_u_div_CryTmp_3__1_) );
  INV_X1 rem_25_U241 ( .A(a[4]), .ZN(rem_25_n193) );
  NAND2_X1 rem_25_U240 ( .A1(b[0]), .A2(rem_25_n193), .ZN(
        rem_25_u_div_CryTmp_4__1_) );
  INV_X1 rem_25_U239 ( .A(a[5]), .ZN(rem_25_n192) );
  NAND2_X1 rem_25_U238 ( .A1(rem_25_n194), .A2(rem_25_n192), .ZN(
        rem_25_u_div_CryTmp_5__1_) );
  INV_X1 rem_25_U237 ( .A(rem_25_n200), .ZN(rem_25_n197) );
  INV_X1 rem_25_U236 ( .A(rem_25_n200), .ZN(rem_25_n194) );
  INV_X1 rem_25_U235 ( .A(rem_25_u_div_SumTmp_6__1_), .ZN(rem_25_n226) );
  AND2_X1 rem_25_U234 ( .A1(rem_25_u_div_CryTmp_2__6_), .A2(rem_25_n201), .ZN(
        rem_25_n190) );
  INV_X1 rem_25_U233 ( .A(rem_25_u_div_SumTmp_4__3_), .ZN(rem_25_n224) );
  INV_X1 rem_25_U232 ( .A(rem_25_u_div_SumTmp_5__2_), .ZN(rem_25_n225) );
  INV_X1 rem_25_U231 ( .A(rem_25_u_div_SumTmp_4__2_), .ZN(rem_25_n229) );
  INV_X1 rem_25_U230 ( .A(rem_25_u_div_SumTmp_2__2_), .ZN(rem_25_n232) );
  INV_X1 rem_25_U229 ( .A(rem_25_u_div_SumTmp_1__2_), .ZN(rem_25_n235) );
  AND2_X1 rem_25_U228 ( .A1(rem_25_u_div_CryTmp_5__3_), .A2(rem_25_n114), .ZN(
        rem_25_n189) );
  AND2_X1 rem_25_U227 ( .A1(rem_25_u_div_CryTmp_4__4_), .A2(rem_25_n123), .ZN(
        rem_25_n188) );
  INV_X2 rem_25_U226 ( .A(b[5]), .ZN(rem_25_u_div_BInv[5]) );
  NAND3_X1 rem_25_U225 ( .A1(rem_25_n182), .A2(rem_25_n183), .A3(rem_25_n184), 
        .ZN(rem_25_u_div_CryTmp_3__3_) );
  NAND2_X1 rem_25_U224 ( .A1(rem_25_u_div_PartRem_4__2_), .A2(
        rem_25_u_div_BInv[2]), .ZN(rem_25_n184) );
  NAND2_X1 rem_25_U223 ( .A1(rem_25_u_div_CryTmp_3__2_), .A2(
        rem_25_u_div_BInv[2]), .ZN(rem_25_n183) );
  NAND2_X1 rem_25_U222 ( .A1(rem_25_n55), .A2(rem_25_u_div_PartRem_4__2_), 
        .ZN(rem_25_n182) );
  XOR2_X1 rem_25_U221 ( .A(rem_25_u_div_PartRem_4__2_), .B(
        rem_25_u_div_BInv[2]), .Z(rem_25_n181) );
  NAND2_X1 rem_25_U220 ( .A1(rem_25_u_div_CryTmp_1__6_), .A2(
        rem_25_u_div_BInv[6]), .ZN(rem_25_n180) );
  NAND2_X1 rem_25_U219 ( .A1(rem_25_u_div_PartRem_2__6_), .A2(rem_25_n101), 
        .ZN(rem_25_n179) );
  NAND2_X1 rem_25_U218 ( .A1(rem_25_u_div_PartRem_2__6_), .A2(rem_25_n4), .ZN(
        rem_25_n178) );
  XOR2_X1 rem_25_U217 ( .A(rem_25_u_div_PartRem_2__6_), .B(rem_25_n3), .Z(
        rem_25_n177) );
  NAND3_X1 rem_25_U216 ( .A1(rem_25_n176), .A2(rem_25_n175), .A3(rem_25_n174), 
        .ZN(rem_25_u_div_CryTmp_1__6_) );
  NAND2_X1 rem_25_U215 ( .A1(rem_25_n56), .A2(rem_25_u_div_BInv[5]), .ZN(
        rem_25_n176) );
  NAND2_X1 rem_25_U214 ( .A1(rem_25_u_div_PartRem_2__5_), .A2(
        rem_25_u_div_CryTmp_1__5_), .ZN(rem_25_n175) );
  NAND2_X1 rem_25_U213 ( .A1(rem_25_u_div_PartRem_2__5_), .A2(
        rem_25_u_div_BInv[5]), .ZN(rem_25_n174) );
  XOR2_X1 rem_25_U212 ( .A(rem_25_u_div_PartRem_2__5_), .B(
        rem_25_u_div_BInv[5]), .Z(rem_25_n173) );
  NAND3_X1 rem_25_U211 ( .A1(rem_25_n170), .A2(rem_25_n171), .A3(rem_25_n172), 
        .ZN(rem_25_u_div_CryTmp_0__6_) );
  NAND2_X1 rem_25_U210 ( .A1(rem_25_u_div_PartRem_1__5_), .A2(
        rem_25_u_div_BInv[5]), .ZN(rem_25_n172) );
  NAND2_X1 rem_25_U209 ( .A1(rem_25_n75), .A2(rem_25_u_div_BInv[5]), .ZN(
        rem_25_n171) );
  NAND2_X1 rem_25_U208 ( .A1(rem_25_n50), .A2(rem_25_u_div_PartRem_1__5_), 
        .ZN(rem_25_n170) );
  XOR2_X1 rem_25_U207 ( .A(rem_25_n76), .B(rem_25_n169), .Z(
        rem_25_u_div_SumTmp_0__5_) );
  XOR2_X1 rem_25_U206 ( .A(rem_25_u_div_PartRem_1__5_), .B(
        rem_25_u_div_BInv[5]), .Z(rem_25_n169) );
  INV_X1 rem_25_U205 ( .A(rem_25_n108), .ZN(rem_25_n211) );
  INV_X2 rem_25_U204 ( .A(b[2]), .ZN(rem_25_u_div_BInv[2]) );
  NAND3_X1 rem_25_U203 ( .A1(rem_25_n163), .A2(rem_25_n164), .A3(rem_25_n165), 
        .ZN(rem_25_u_div_CryTmp_4__2_) );
  NAND2_X1 rem_25_U202 ( .A1(rem_25_u_div_CryTmp_4__1_), .A2(
        rem_25_u_div_BInv[1]), .ZN(rem_25_n165) );
  XOR2_X1 rem_25_U201 ( .A(rem_25_u_div_CryTmp_4__1_), .B(rem_25_u_div_BInv[1]), .Z(rem_25_n162) );
  NAND2_X1 rem_25_U200 ( .A1(rem_25_u_div_CryTmp_5__1_), .A2(
        rem_25_u_div_BInv[1]), .ZN(rem_25_n161) );
  XOR2_X1 rem_25_U199 ( .A(rem_25_u_div_CryTmp_5__1_), .B(rem_25_u_div_BInv[1]), .Z(rem_25_n160) );
  NAND3_X1 rem_25_U198 ( .A1(rem_25_n159), .A2(rem_25_n158), .A3(rem_25_n157), 
        .ZN(rem_25_u_div_CryTmp_2__5_) );
  NAND2_X1 rem_25_U197 ( .A1(rem_25_u_div_CryTmp_2__4_), .A2(
        rem_25_u_div_BInv[4]), .ZN(rem_25_n159) );
  NAND2_X1 rem_25_U196 ( .A1(rem_25_n47), .A2(rem_25_u_div_PartRem_3__4_), 
        .ZN(rem_25_n158) );
  NAND2_X1 rem_25_U195 ( .A1(rem_25_u_div_PartRem_3__4_), .A2(
        rem_25_u_div_BInv[4]), .ZN(rem_25_n157) );
  XOR2_X1 rem_25_U194 ( .A(rem_25_u_div_PartRem_3__4_), .B(
        rem_25_u_div_BInv[4]), .Z(rem_25_n156) );
  NAND3_X1 rem_25_U193 ( .A1(rem_25_n154), .A2(rem_25_n153), .A3(rem_25_n155), 
        .ZN(rem_25_u_div_CryTmp_2__4_) );
  NAND2_X1 rem_25_U192 ( .A1(rem_25_u_div_CryTmp_2__3_), .A2(
        rem_25_u_div_BInv[3]), .ZN(rem_25_n155) );
  NAND2_X1 rem_25_U191 ( .A1(rem_25_u_div_PartRem_3__3_), .A2(
        rem_25_u_div_CryTmp_2__3_), .ZN(rem_25_n154) );
  NAND2_X1 rem_25_U190 ( .A1(rem_25_u_div_PartRem_3__3_), .A2(
        rem_25_u_div_BInv[3]), .ZN(rem_25_n153) );
  XOR2_X1 rem_25_U189 ( .A(rem_25_u_div_PartRem_3__3_), .B(
        rem_25_u_div_BInv[3]), .Z(rem_25_n152) );
  NAND3_X1 rem_25_U188 ( .A1(rem_25_n150), .A2(rem_25_n149), .A3(rem_25_n151), 
        .ZN(rem_25_u_div_CryTmp_2__2_) );
  NAND2_X1 rem_25_U187 ( .A1(rem_25_u_div_CryTmp_2__1_), .A2(
        rem_25_u_div_BInv[1]), .ZN(rem_25_n151) );
  NAND2_X1 rem_25_U186 ( .A1(rem_25_n122), .A2(rem_25_u_div_BInv[1]), .ZN(
        rem_25_n150) );
  NAND2_X1 rem_25_U185 ( .A1(rem_25_n185), .A2(rem_25_u_div_CryTmp_2__1_), 
        .ZN(rem_25_n149) );
  XOR2_X1 rem_25_U184 ( .A(rem_25_u_div_CryTmp_2__1_), .B(rem_25_u_div_BInv[1]), .Z(rem_25_n148) );
  NAND3_X1 rem_25_U183 ( .A1(rem_25_n146), .A2(rem_25_n145), .A3(rem_25_n147), 
        .ZN(rem_25_u_div_CryTmp_0__3_) );
  NAND2_X1 rem_25_U182 ( .A1(rem_25_u_div_PartRem_1__2_), .A2(
        rem_25_u_div_BInv[2]), .ZN(rem_25_n147) );
  NAND2_X1 rem_25_U181 ( .A1(rem_25_n65), .A2(rem_25_u_div_BInv[2]), .ZN(
        rem_25_n146) );
  NAND2_X1 rem_25_U180 ( .A1(rem_25_u_div_CryTmp_0__2_), .A2(
        rem_25_u_div_PartRem_1__2_), .ZN(rem_25_n145) );
  XOR2_X1 rem_25_U179 ( .A(rem_25_n95), .B(rem_25_n144), .Z(
        rem_25_u_div_SumTmp_0__2_) );
  XOR2_X1 rem_25_U178 ( .A(rem_25_u_div_PartRem_1__2_), .B(
        rem_25_u_div_BInv[2]), .Z(rem_25_n144) );
  NAND3_X1 rem_25_U177 ( .A1(rem_25_n153), .A2(rem_25_n154), .A3(rem_25_n155), 
        .ZN(rem_25_n143) );
  INV_X1 rem_25_U176 ( .A(rem_25_n63), .ZN(rem_25_n142) );
  NAND3_X1 rem_25_U175 ( .A1(rem_25_n140), .A2(rem_25_n139), .A3(rem_25_n141), 
        .ZN(rem_25_u_div_CryTmp_1__4_) );
  NAND2_X1 rem_25_U174 ( .A1(rem_25_u_div_PartRem_2__3_), .A2(
        rem_25_u_div_BInv[3]), .ZN(rem_25_n141) );
  NAND2_X1 rem_25_U173 ( .A1(rem_25_u_div_CryTmp_1__3_), .A2(
        rem_25_u_div_BInv[3]), .ZN(rem_25_n140) );
  NAND2_X1 rem_25_U172 ( .A1(rem_25_u_div_CryTmp_1__3_), .A2(
        rem_25_u_div_PartRem_2__3_), .ZN(rem_25_n139) );
  XOR2_X1 rem_25_U171 ( .A(rem_25_u_div_PartRem_2__3_), .B(
        rem_25_u_div_BInv[3]), .Z(rem_25_n138) );
  NAND3_X1 rem_25_U170 ( .A1(rem_25_n135), .A2(rem_25_n136), .A3(rem_25_n137), 
        .ZN(rem_25_u_div_CryTmp_0__7_) );
  NAND2_X1 rem_25_U169 ( .A1(rem_25_u_div_PartRem_1__6_), .A2(rem_25_n4), .ZN(
        rem_25_n137) );
  NAND2_X1 rem_25_U168 ( .A1(rem_25_u_div_CryTmp_0__6_), .A2(
        rem_25_u_div_BInv[6]), .ZN(rem_25_n136) );
  NAND2_X1 rem_25_U167 ( .A1(rem_25_n115), .A2(rem_25_u_div_PartRem_1__6_), 
        .ZN(rem_25_n135) );
  XOR2_X1 rem_25_U166 ( .A(rem_25_n54), .B(rem_25_n134), .Z(
        rem_25_u_div_SumTmp_0__6_) );
  XOR2_X1 rem_25_U165 ( .A(rem_25_u_div_PartRem_1__6_), .B(rem_25_n5), .Z(
        rem_25_n134) );
  INV_X1 rem_25_U164 ( .A(rem_25_n61), .ZN(rem_25_n216) );
  NAND3_X1 rem_25_U163 ( .A1(rem_25_n133), .A2(rem_25_n132), .A3(rem_25_n131), 
        .ZN(rem_25_u_div_CryTmp_3__5_) );
  NAND2_X1 rem_25_U162 ( .A1(rem_25_n8), .A2(rem_25_u_div_BInv[4]), .ZN(
        rem_25_n133) );
  NAND2_X1 rem_25_U161 ( .A1(rem_25_u_div_CryTmp_3__4_), .A2(
        rem_25_u_div_PartRem_4__4_), .ZN(rem_25_n132) );
  NAND2_X1 rem_25_U160 ( .A1(rem_25_u_div_PartRem_4__4_), .A2(
        rem_25_u_div_BInv[4]), .ZN(rem_25_n131) );
  XOR2_X1 rem_25_U159 ( .A(rem_25_u_div_PartRem_4__4_), .B(
        rem_25_u_div_BInv[4]), .Z(rem_25_n130) );
  NAND3_X1 rem_25_U158 ( .A1(rem_25_n128), .A2(rem_25_n129), .A3(rem_25_n127), 
        .ZN(rem_25_u_div_CryTmp_3__4_) );
  NAND2_X1 rem_25_U157 ( .A1(rem_25_u_div_CryTmp_3__3_), .A2(
        rem_25_u_div_BInv[3]), .ZN(rem_25_n129) );
  NAND2_X1 rem_25_U156 ( .A1(rem_25_u_div_PartRem_4__3_), .A2(rem_25_n49), 
        .ZN(rem_25_n128) );
  NAND2_X1 rem_25_U155 ( .A1(rem_25_u_div_PartRem_4__3_), .A2(
        rem_25_u_div_BInv[3]), .ZN(rem_25_n127) );
  XOR2_X1 rem_25_U154 ( .A(rem_25_u_div_PartRem_4__3_), .B(
        rem_25_u_div_BInv[3]), .Z(rem_25_n126) );
  NAND3_X1 rem_25_U153 ( .A1(rem_25_n48), .A2(rem_25_n73), .A3(rem_25_n184), 
        .ZN(rem_25_n125) );
  NAND3_X1 rem_25_U152 ( .A1(rem_25_n127), .A2(rem_25_n44), .A3(rem_25_n45), 
        .ZN(rem_25_n124) );
  INV_X1 rem_25_U151 ( .A(rem_25_n78), .ZN(rem_25_n222) );
  AND2_X1 rem_25_U150 ( .A1(rem_25_n89), .A2(rem_25_n201), .ZN(rem_25_n123) );
  MUX2_X1 rem_25_U149 ( .A(a[4]), .B(rem_25_u_div_SumTmp_4__0_), .S(
        rem_25_n167), .Z(rem_25_n166) );
  MUX2_X1 rem_25_U148 ( .A(a[3]), .B(rem_25_u_div_SumTmp_3__0_), .S(
        rem_25_n186), .Z(rem_25_n185) );
  MUX2_X1 rem_25_U147 ( .A(a[3]), .B(rem_25_u_div_SumTmp_3__0_), .S(
        rem_25_n186), .Z(rem_25_n122) );
  OR2_X1 rem_25_U146 ( .A1(rem_25_n207), .A2(b[1]), .ZN(rem_25_n164) );
  OR2_X1 rem_25_U145 ( .A1(rem_25_n207), .A2(rem_25_n121), .ZN(rem_25_n163) );
  INV_X2 rem_25_U144 ( .A(b[4]), .ZN(rem_25_u_div_BInv[4]) );
  NAND2_X1 rem_25_U143 ( .A1(rem_25_u_div_PartRem_1__4_), .A2(
        rem_25_u_div_BInv[4]), .ZN(rem_25_n120) );
  NAND2_X1 rem_25_U142 ( .A1(rem_25_u_div_CryTmp_0__4_), .A2(
        rem_25_u_div_BInv[4]), .ZN(rem_25_n119) );
  NAND2_X1 rem_25_U141 ( .A1(rem_25_u_div_CryTmp_0__4_), .A2(
        rem_25_u_div_PartRem_1__4_), .ZN(rem_25_n118) );
  XOR2_X1 rem_25_U140 ( .A(rem_25_n80), .B(rem_25_n117), .Z(
        rem_25_u_div_SumTmp_0__4_) );
  XOR2_X1 rem_25_U139 ( .A(rem_25_u_div_PartRem_1__4_), .B(
        rem_25_u_div_BInv[4]), .Z(rem_25_n117) );
  AND2_X1 rem_25_U138 ( .A1(rem_25_u_div_CryTmp_4__4_), .A2(rem_25_n123), .ZN(
        rem_25_n167) );
  NAND2_X1 rem_25_U137 ( .A1(rem_25_u_div_CryTmp_5__3_), .A2(rem_25_n114), 
        .ZN(rem_25_n116) );
  MUX2_X1 rem_25_U136 ( .A(rem_25_n12), .B(rem_25_n192), .S(rem_25_n116), .Z(
        rem_25_n207) );
  NAND3_X1 rem_25_U135 ( .A1(rem_25_n171), .A2(rem_25_n170), .A3(rem_25_n172), 
        .ZN(rem_25_n115) );
  AND2_X1 rem_25_U134 ( .A1(rem_25_n123), .A2(rem_25_u_div_BInv[3]), .ZN(
        rem_25_n114) );
  NAND3_X1 rem_25_U133 ( .A1(rem_25_n112), .A2(rem_25_n111), .A3(rem_25_n113), 
        .ZN(rem_25_u_div_CryTmp_2__6_) );
  NAND2_X1 rem_25_U132 ( .A1(rem_25_u_div_PartRem_3__5_), .A2(
        rem_25_u_div_BInv[5]), .ZN(rem_25_n113) );
  NAND2_X1 rem_25_U131 ( .A1(rem_25_n100), .A2(rem_25_u_div_BInv[5]), .ZN(
        rem_25_n112) );
  NAND2_X1 rem_25_U130 ( .A1(rem_25_u_div_CryTmp_2__5_), .A2(
        rem_25_u_div_PartRem_3__5_), .ZN(rem_25_n111) );
  XOR2_X1 rem_25_U129 ( .A(rem_25_u_div_PartRem_3__5_), .B(
        rem_25_u_div_BInv[5]), .Z(rem_25_n110) );
  NAND3_X1 rem_25_U128 ( .A1(rem_25_n133), .A2(rem_25_n132), .A3(rem_25_n131), 
        .ZN(rem_25_n109) );
  AND2_X1 rem_25_U127 ( .A1(rem_25_n109), .A2(rem_25_n13), .ZN(rem_25_n186) );
  MUX2_X1 rem_25_U126 ( .A(a[4]), .B(rem_25_u_div_SumTmp_4__0_), .S(rem_25_n43), .Z(rem_25_n108) );
  NAND3_X1 rem_25_U125 ( .A1(rem_25_n105), .A2(rem_25_n104), .A3(rem_25_n106), 
        .ZN(rem_25_u_div_CryTmp_1__2_) );
  NAND2_X1 rem_25_U124 ( .A1(rem_25_u_div_CryTmp_1__1_), .A2(
        rem_25_u_div_BInv[1]), .ZN(rem_25_n106) );
  NAND2_X1 rem_25_U123 ( .A1(rem_25_n42), .A2(rem_25_u_div_BInv[1]), .ZN(
        rem_25_n105) );
  NAND2_X1 rem_25_U122 ( .A1(rem_25_n168), .A2(rem_25_u_div_CryTmp_1__1_), 
        .ZN(rem_25_n104) );
  XOR2_X1 rem_25_U121 ( .A(rem_25_u_div_CryTmp_1__1_), .B(rem_25_u_div_BInv[1]), .Z(rem_25_n103) );
  FA_X1 rem_25_U120 ( .A(rem_25_u_div_PartRem_1__7_), .B(rem_25_u_div_BInv[7]), 
        .CI(rem_25_n74), .CO(rem_25_n102) );
  NAND3_X1 rem_25_U119 ( .A1(rem_25_n176), .A2(rem_25_n175), .A3(rem_25_n174), 
        .ZN(rem_25_n101) );
  NAND3_X1 rem_25_U118 ( .A1(rem_25_n39), .A2(rem_25_n159), .A3(rem_25_n157), 
        .ZN(rem_25_n100) );
  NAND3_X1 rem_25_U117 ( .A1(rem_25_n97), .A2(rem_25_n98), .A3(rem_25_n99), 
        .ZN(rem_25_u_div_CryTmp_3__2_) );
  NAND2_X1 rem_25_U116 ( .A1(rem_25_u_div_CryTmp_3__1_), .A2(
        rem_25_u_div_BInv[1]), .ZN(rem_25_n99) );
  NAND2_X1 rem_25_U115 ( .A1(rem_25_n30), .A2(rem_25_u_div_BInv[1]), .ZN(
        rem_25_n98) );
  NAND2_X1 rem_25_U114 ( .A1(rem_25_n166), .A2(rem_25_u_div_CryTmp_3__1_), 
        .ZN(rem_25_n97) );
  XOR2_X1 rem_25_U113 ( .A(rem_25_u_div_CryTmp_3__1_), .B(rem_25_u_div_BInv[1]), .Z(rem_25_n96) );
  INV_X1 rem_25_U112 ( .A(rem_25_n86), .ZN(rem_25_n202) );
  NAND2_X1 rem_25_U111 ( .A1(rem_25_n91), .A2(rem_25_n92), .ZN(rem_25_n94) );
  INV_X1 rem_25_U110 ( .A(b[3]), .ZN(rem_25_n90) );
  NOR2_X1 rem_25_U109 ( .A1(b[5]), .A2(b[4]), .ZN(rem_25_n89) );
  INV_X1 rem_25_U108 ( .A(rem_25_n107), .ZN(rem_25_n88) );
  MUX2_X1 rem_25_U107 ( .A(rem_25_n191), .B(rem_25_n11), .S(rem_25_n29), .Z(
        rem_25_n87) );
  CLKBUF_X1 rem_25_U106 ( .A(rem_25_n55), .Z(rem_25_n85) );
  NAND3_X1 rem_25_U105 ( .A1(rem_25_n83), .A2(rem_25_n82), .A3(rem_25_n84), 
        .ZN(rem_25_u_div_CryTmp_1__5_) );
  NAND2_X1 rem_25_U104 ( .A1(rem_25_u_div_PartRem_2__4_), .A2(
        rem_25_u_div_BInv[4]), .ZN(rem_25_n84) );
  NAND2_X1 rem_25_U103 ( .A1(rem_25_u_div_CryTmp_1__4_), .A2(
        rem_25_u_div_BInv[4]), .ZN(rem_25_n83) );
  NAND2_X1 rem_25_U102 ( .A1(rem_25_n77), .A2(rem_25_u_div_PartRem_2__4_), 
        .ZN(rem_25_n82) );
  XOR2_X1 rem_25_U101 ( .A(rem_25_u_div_PartRem_2__4_), .B(
        rem_25_u_div_BInv[4]), .Z(rem_25_n81) );
  CLKBUF_X1 rem_25_U100 ( .A(rem_25_n65), .Z(rem_25_n95) );
  NAND3_X1 rem_25_U99 ( .A1(rem_25_n179), .A2(rem_25_n180), .A3(rem_25_n178), 
        .ZN(rem_25_n79) );
  CLKBUF_X1 rem_25_U98 ( .A(rem_25_n42), .Z(rem_25_n78) );
  NAND3_X1 rem_25_U97 ( .A1(rem_25_n139), .A2(rem_25_n140), .A3(rem_25_n141), 
        .ZN(rem_25_n77) );
  NAND3_X1 rem_25_U96 ( .A1(rem_25_n119), .A2(rem_25_n64), .A3(rem_25_n120), 
        .ZN(rem_25_n76) );
  NAND3_X1 rem_25_U95 ( .A1(rem_25_n119), .A2(rem_25_n118), .A3(rem_25_n120), 
        .ZN(rem_25_n75) );
  NAND3_X1 rem_25_U94 ( .A1(rem_25_n135), .A2(rem_25_n136), .A3(rem_25_n137), 
        .ZN(rem_25_n74) );
  INV_X1 rem_25_U93 ( .A(rem_25_u_div_CryTmp_0__8_), .ZN(rem_25_n70) );
  NAND2_X1 rem_25_U92 ( .A1(rem_25_n71), .A2(rem_25_n72), .ZN(a_mod_b_3_) );
  NAND2_X1 rem_25_U91 ( .A1(rem_25_u_div_SumTmp_0__3_), .A2(
        rem_25_u_div_CryTmp_0__8_), .ZN(rem_25_n72) );
  NAND2_X1 rem_25_U90 ( .A1(rem_25_n70), .A2(rem_25_u_div_PartRem_1__3_), .ZN(
        rem_25_n71) );
  NAND3_X1 rem_25_U89 ( .A1(rem_25_n67), .A2(rem_25_n68), .A3(rem_25_n69), 
        .ZN(rem_25_u_div_CryTmp_0__2_) );
  NAND2_X1 rem_25_U88 ( .A1(rem_25_u_div_CryTmp_0__1_), .A2(
        rem_25_u_div_BInv[1]), .ZN(rem_25_n69) );
  NAND2_X1 rem_25_U87 ( .A1(rem_25_u_div_PartRem_1__1_), .A2(
        rem_25_u_div_BInv[1]), .ZN(rem_25_n68) );
  NAND2_X1 rem_25_U86 ( .A1(rem_25_u_div_PartRem_1__1_), .A2(
        rem_25_u_div_CryTmp_0__1_), .ZN(rem_25_n67) );
  XOR2_X1 rem_25_U85 ( .A(rem_25_n62), .B(rem_25_n66), .Z(
        rem_25_u_div_SumTmp_0__1_) );
  XOR2_X1 rem_25_U84 ( .A(rem_25_u_div_CryTmp_0__1_), .B(rem_25_u_div_BInv[1]), 
        .Z(rem_25_n66) );
  CLKBUF_X1 rem_25_U83 ( .A(rem_25_u_div_CryTmp_0__4_), .Z(rem_25_n80) );
  NAND3_X1 rem_25_U82 ( .A1(rem_25_n68), .A2(rem_25_n67), .A3(rem_25_n69), 
        .ZN(rem_25_n65) );
  CLKBUF_X1 rem_25_U81 ( .A(rem_25_n93), .Z(rem_25_n86) );
  CLKBUF_X1 rem_25_U80 ( .A(rem_25_n118), .Z(rem_25_n64) );
  CLKBUF_X1 rem_25_U79 ( .A(rem_25_n207), .Z(rem_25_n63) );
  CLKBUF_X1 rem_25_U78 ( .A(rem_25_n183), .Z(rem_25_n73) );
  CLKBUF_X1 rem_25_U77 ( .A(rem_25_u_div_PartRem_1__1_), .Z(rem_25_n62) );
  MUX2_X1 rem_25_U76 ( .A(a[3]), .B(rem_25_u_div_SumTmp_3__0_), .S(rem_25_n187), .Z(rem_25_n61) );
  MUX2_X1 rem_25_U75 ( .A(a[3]), .B(rem_25_u_div_SumTmp_3__0_), .S(rem_25_n187), .Z(rem_25_n60) );
  CLKBUF_X1 rem_25_U74 ( .A(rem_25_n56), .Z(rem_25_n57) );
  CLKBUF_X1 rem_25_U73 ( .A(rem_25_u_div_CryTmp_2__3_), .Z(rem_25_n59) );
  CLKBUF_X1 rem_25_U72 ( .A(rem_25_u_div_CryTmp_1__3_), .Z(rem_25_n58) );
  NAND3_X1 rem_25_U71 ( .A1(rem_25_n83), .A2(rem_25_n82), .A3(rem_25_n84), 
        .ZN(rem_25_n56) );
  NAND3_X1 rem_25_U70 ( .A1(rem_25_n98), .A2(rem_25_n97), .A3(rem_25_n99), 
        .ZN(rem_25_n55) );
  CLKBUF_X1 rem_25_U69 ( .A(rem_25_n115), .Z(rem_25_n54) );
  CLKBUF_X1 rem_25_U68 ( .A(rem_25_u_div_CryTmp_1__4_), .Z(rem_25_n53) );
  NAND3_X1 rem_25_U67 ( .A1(rem_25_n38), .A2(rem_25_n51), .A3(rem_25_n157), 
        .ZN(rem_25_n52) );
  CLKBUF_X1 rem_25_U66 ( .A(rem_25_n39), .Z(rem_25_n51) );
  NAND3_X1 rem_25_U65 ( .A1(rem_25_n119), .A2(rem_25_n118), .A3(rem_25_n120), 
        .ZN(rem_25_n50) );
  NAND3_X1 rem_25_U64 ( .A1(rem_25_n182), .A2(rem_25_n183), .A3(rem_25_n184), 
        .ZN(rem_25_n49) );
  CLKBUF_X1 rem_25_U63 ( .A(rem_25_n182), .Z(rem_25_n48) );
  NAND3_X1 rem_25_U62 ( .A1(rem_25_n154), .A2(rem_25_n153), .A3(rem_25_n155), 
        .ZN(rem_25_n47) );
  NAND3_X1 rem_25_U61 ( .A1(rem_25_n41), .A2(rem_25_n40), .A3(rem_25_n174), 
        .ZN(rem_25_n46) );
  CLKBUF_X1 rem_25_U60 ( .A(rem_25_n1), .Z(rem_25_n44) );
  CLKBUF_X1 rem_25_U59 ( .A(rem_25_n2), .Z(rem_25_n45) );
  CLKBUF_X1 rem_25_U58 ( .A(rem_25_n188), .Z(rem_25_n43) );
  MUX2_X1 rem_25_U57 ( .A(a[2]), .B(rem_25_u_div_SumTmp_2__0_), .S(rem_25_n31), 
        .Z(rem_25_n168) );
  MUX2_X1 rem_25_U56 ( .A(a[2]), .B(rem_25_u_div_SumTmp_2__0_), .S(rem_25_n31), 
        .Z(rem_25_n42) );
  CLKBUF_X1 rem_25_U55 ( .A(rem_25_n176), .Z(rem_25_n41) );
  CLKBUF_X1 rem_25_U54 ( .A(rem_25_n175), .Z(rem_25_n40) );
  NAND2_X1 rem_25_U53 ( .A1(rem_25_n47), .A2(rem_25_u_div_PartRem_3__4_), .ZN(
        rem_25_n39) );
  NAND3_X1 rem_25_U52 ( .A1(rem_25_n179), .A2(rem_25_n180), .A3(rem_25_n178), 
        .ZN(rem_25_n37) );
  AND2_X2 rem_25_U51 ( .A1(rem_25_n37), .A2(rem_25_u_div_BInv[7]), .ZN(
        rem_25_n36) );
  CLKBUF_X1 rem_25_U50 ( .A(rem_25_n159), .Z(rem_25_n38) );
  INV_X1 rem_25_U49 ( .A(b[7]), .ZN(rem_25_n35) );
  INV_X1 rem_25_U48 ( .A(b[6]), .ZN(rem_25_n34) );
  AND4_X1 rem_25_U47 ( .A1(rem_25_n233), .A2(rem_25_n90), .A3(rem_25_n34), 
        .A4(rem_25_n35), .ZN(rem_25_n91) );
  INV_X1 rem_25_U46 ( .A(a[7]), .ZN(rem_25_n33) );
  AOI211_X1 rem_25_U45 ( .C1(rem_25_n33), .C2(b[0]), .A(b[2]), .B(b[1]), .ZN(
        rem_25_n92) );
  INV_X1 rem_25_U44 ( .A(rem_25_u_div_CryTmp_5__1_), .ZN(rem_25_n32) );
  OAI221_X1 rem_25_U43 ( .B1(rem_25_n204), .B2(rem_25_n32), .C1(rem_25_n87), 
        .C2(b[1]), .A(rem_25_n161), .ZN(rem_25_u_div_CryTmp_5__2_) );
  AND4_X1 rem_25_U42 ( .A1(rem_25_n7), .A2(rem_25_n123), .A3(
        rem_25_u_div_BInv[3]), .A4(rem_25_u_div_BInv[2]), .ZN(rem_25_n227) );
  AND2_X1 rem_25_U41 ( .A1(rem_25_u_div_CryTmp_2__6_), .A2(rem_25_n201), .ZN(
        rem_25_n31) );
  MUX2_X1 rem_25_U40 ( .A(a[4]), .B(rem_25_u_div_SumTmp_4__0_), .S(rem_25_n167), .Z(rem_25_n30) );
  NOR2_X1 rem_25_U39 ( .A1(b[6]), .A2(b[7]), .ZN(rem_25_n201) );
  XNOR2_X1 rem_25_U38 ( .A(rem_25_n58), .B(rem_25_n138), .ZN(rem_25_n28) );
  XNOR2_X1 rem_25_U37 ( .A(rem_25_n78), .B(rem_25_n103), .ZN(rem_25_n27) );
  XNOR2_X1 rem_25_U36 ( .A(rem_25_n53), .B(rem_25_n81), .ZN(rem_25_n26) );
  XNOR2_X1 rem_25_U35 ( .A(rem_25_n173), .B(rem_25_n57), .ZN(rem_25_n25) );
  XNOR2_X1 rem_25_U34 ( .A(rem_25_n177), .B(rem_25_n46), .ZN(rem_25_n24) );
  XNOR2_X1 rem_25_U33 ( .A(rem_25_n60), .B(rem_25_n148), .ZN(rem_25_n23) );
  XNOR2_X1 rem_25_U32 ( .A(rem_25_n156), .B(rem_25_n143), .ZN(rem_25_n22) );
  XNOR2_X1 rem_25_U31 ( .A(rem_25_n59), .B(rem_25_n152), .ZN(rem_25_n21) );
  XNOR2_X1 rem_25_U30 ( .A(rem_25_n52), .B(rem_25_n110), .ZN(rem_25_n20) );
  XNOR2_X1 rem_25_U29 ( .A(rem_25_n130), .B(rem_25_n124), .ZN(rem_25_n19) );
  XNOR2_X1 rem_25_U28 ( .A(rem_25_n126), .B(rem_25_n125), .ZN(rem_25_n18) );
  XNOR2_X1 rem_25_U27 ( .A(rem_25_n85), .B(rem_25_n181), .ZN(rem_25_n17) );
  XNOR2_X1 rem_25_U26 ( .A(rem_25_n108), .B(rem_25_n96), .ZN(rem_25_n16) );
  XNOR2_X1 rem_25_U25 ( .A(rem_25_n142), .B(rem_25_n162), .ZN(rem_25_n15) );
  XNOR2_X1 rem_25_U24 ( .A(rem_25_n88), .B(rem_25_n160), .ZN(rem_25_n14) );
  AND2_X1 rem_25_U23 ( .A1(rem_25_n201), .A2(rem_25_u_div_BInv[5]), .ZN(
        rem_25_n13) );
  XOR2_X1 rem_25_U22 ( .A(rem_25_n200), .B(a[5]), .Z(rem_25_n12) );
  XOR2_X1 rem_25_U21 ( .A(rem_25_n199), .B(a[6]), .Z(rem_25_n11) );
  INV_X1 rem_25_U20 ( .A(b[0]), .ZN(rem_25_n199) );
  INV_X1 rem_25_U19 ( .A(rem_25_n234), .ZN(rem_25_u_div_PartRem_1__3_) );
  INV_X1 rem_25_U18 ( .A(rem_25_u_div_CryTmp_4__1_), .ZN(rem_25_n121) );
  MUX2_X1 rem_25_U17 ( .A(rem_25_u_div_PartRem_1__6_), .B(
        rem_25_u_div_SumTmp_0__6_), .S(rem_25_u_div_CryTmp_0__8_), .Z(
        a_mod_b_6_) );
  AND2_X2 rem_25_U16 ( .A1(rem_25_u_div_CryTmp_3__5_), .A2(rem_25_n13), .ZN(
        rem_25_n187) );
  AND2_X1 rem_25_U15 ( .A1(rem_25_n114), .A2(rem_25_u_div_BInv[2]), .ZN(
        rem_25_n10) );
  BUF_X1 rem_25_U14 ( .A(rem_25_n87), .Z(rem_25_n107) );
  AND2_X1 rem_25_U13 ( .A1(rem_25_n7), .A2(rem_25_n9), .ZN(rem_25_n29) );
  AND2_X1 rem_25_U12 ( .A1(rem_25_n114), .A2(rem_25_u_div_BInv[2]), .ZN(
        rem_25_n9) );
  NAND3_X1 rem_25_U11 ( .A1(rem_25_n1), .A2(rem_25_n2), .A3(rem_25_n127), .ZN(
        rem_25_n8) );
  MUX2_X2 rem_25_U10 ( .A(rem_25_u_div_SumTmp_7__0_), .B(a[7]), .S(rem_25_n94), 
        .Z(rem_25_n93) );
  FA_X1 rem_25_U9 ( .A(rem_25_u_div_CryTmp_6__1_), .B(rem_25_u_div_BInv[1]), 
        .CI(rem_25_n93), .CO(rem_25_n7) );
  NAND2_X1 rem_25_U8 ( .A1(rem_25_u_div_CryTmp_6__2_), .A2(rem_25_n10), .ZN(
        rem_25_n6) );
  MUX2_X1 rem_25_U7 ( .A(rem_25_n11), .B(rem_25_n191), .S(rem_25_n6), .Z(
        rem_25_n204) );
  INV_X1 rem_25_U6 ( .A(b[6]), .ZN(rem_25_u_div_BInv[6]) );
  INV_X1 rem_25_U5 ( .A(b[6]), .ZN(rem_25_n5) );
  INV_X1 rem_25_U4 ( .A(b[6]), .ZN(rem_25_n4) );
  INV_X1 rem_25_U3 ( .A(b[6]), .ZN(rem_25_n3) );
  NAND2_X1 rem_25_U2 ( .A1(rem_25_u_div_CryTmp_3__3_), .A2(
        rem_25_u_div_BInv[3]), .ZN(rem_25_n2) );
  NAND2_X1 rem_25_U1 ( .A1(rem_25_u_div_PartRem_4__3_), .A2(rem_25_n49), .ZN(
        rem_25_n1) );
  FA_X1 rem_25_u_div_u_fa_PartRem_0_0_3 ( .A(rem_25_u_div_PartRem_1__3_), .B(
        rem_25_u_div_BInv[3]), .CI(rem_25_u_div_CryTmp_0__3_), .CO(
        rem_25_u_div_CryTmp_0__4_), .S(rem_25_u_div_SumTmp_0__3_) );
  FA_X1 rem_25_u_div_u_fa_PartRem_0_0_7 ( .A(rem_25_u_div_PartRem_1__7_), .B(
        rem_25_u_div_BInv[7]), .CI(rem_25_u_div_CryTmp_0__7_), .CO(
        rem_25_u_div_CryTmp_0__8_), .S(rem_25_u_div_SumTmp_0__7_) );
  FA_X1 rem_25_u_div_u_fa_PartRem_0_1_2 ( .A(rem_25_u_div_PartRem_2__2_), .B(
        rem_25_u_div_BInv[2]), .CI(rem_25_u_div_CryTmp_1__2_), .CO(
        rem_25_u_div_CryTmp_1__3_), .S(rem_25_u_div_SumTmp_1__2_) );
  FA_X1 rem_25_u_div_u_fa_PartRem_0_2_2 ( .A(rem_25_u_div_PartRem_3__2_), .B(
        rem_25_u_div_BInv[2]), .CI(rem_25_u_div_CryTmp_2__2_), .CO(
        rem_25_u_div_CryTmp_2__3_), .S(rem_25_u_div_SumTmp_2__2_) );
  FA_X1 rem_25_u_div_u_fa_PartRem_0_4_2 ( .A(rem_25_u_div_PartRem_5__2_), .B(
        rem_25_u_div_BInv[2]), .CI(rem_25_u_div_CryTmp_4__2_), .CO(
        rem_25_u_div_CryTmp_4__3_), .S(rem_25_u_div_SumTmp_4__2_) );
  FA_X1 rem_25_u_div_u_fa_PartRem_0_4_3 ( .A(rem_25_u_div_PartRem_5__3_), .B(
        rem_25_u_div_BInv[3]), .CI(rem_25_u_div_CryTmp_4__3_), .CO(
        rem_25_u_div_CryTmp_4__4_), .S(rem_25_u_div_SumTmp_4__3_) );
  FA_X1 rem_25_u_div_u_fa_PartRem_0_5_2 ( .A(rem_25_u_div_BInv[2]), .B(
        rem_25_u_div_PartRem_6__2_), .CI(rem_25_u_div_CryTmp_5__2_), .CO(
        rem_25_u_div_CryTmp_5__3_), .S(rem_25_u_div_SumTmp_5__2_) );
  FA_X1 rem_25_u_div_u_fa_PartRem_0_6_1 ( .A(rem_25_u_div_CryTmp_6__1_), .B(
        rem_25_u_div_BInv[1]), .CI(rem_25_n93), .CO(rem_25_u_div_CryTmp_6__2_), 
        .S(rem_25_u_div_SumTmp_6__1_) );
endmodule

