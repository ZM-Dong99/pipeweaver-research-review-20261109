/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:38:23 2025
/////////////////////////////////////////////////////////////


module calculation_dsr ( a, b, c, d, s1, s2, s3, s4, s5, s6 );
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
  wire   N8, N9, N10, N11, N12, N13, N14, N15, N7, N6, N5, N4, N3, N2, N1, N0,
         N39, N38, N37, N36, N35, N34, N33, N32, N23, N22, N21, N20, N19, N18,
         N17, N16, n11, n12, n13, n14, n15, sub_22_n9, sub_22_n8, sub_22_n7,
         sub_22_n6, sub_22_n5, sub_22_n4, sub_22_n3, sub_22_n2, sub_22_n1,
         add_0_root_add_21_2_n1, add_18_n1, r91_n1,
         sub_2_root_sub_0_root_sub_23_n9, sub_2_root_sub_0_root_sub_23_n8,
         sub_2_root_sub_0_root_sub_23_n7, sub_2_root_sub_0_root_sub_23_n6,
         sub_2_root_sub_0_root_sub_23_n5, sub_2_root_sub_0_root_sub_23_n4,
         sub_2_root_sub_0_root_sub_23_n3, sub_2_root_sub_0_root_sub_23_n2,
         sub_2_root_sub_0_root_sub_23_n1, add_1_root_sub_0_root_sub_23_n1,
         add_0_root_sub_0_root_sub_23_n1, mult_16_n29, mult_16_n28,
         mult_16_n27, mult_16_n26, mult_16_n25, mult_16_n24, mult_16_n23,
         mult_16_n22, mult_16_n21, mult_16_n20, mult_16_n19, mult_16_n18,
         mult_16_n17, mult_16_n16, mult_16_n15, mult_16_n14, mult_16_n12,
         mult_16_n11, mult_16_n10, mult_16_n9, mult_16_n8, mult_16_n7,
         mult_16_n6, mult_16_n5, mult_16_n4, mult_16_n3, mult_16_n2,
         mult_16_SUMB_2__1_, mult_16_SUMB_2__2_, mult_16_SUMB_2__3_,
         mult_16_SUMB_2__4_, mult_16_SUMB_2__5_, mult_16_SUMB_3__1_,
         mult_16_SUMB_3__2_, mult_16_SUMB_3__3_, mult_16_SUMB_3__4_,
         mult_16_SUMB_4__1_, mult_16_SUMB_4__2_, mult_16_SUMB_4__3_,
         mult_16_SUMB_5__1_, mult_16_SUMB_5__2_, mult_16_SUMB_6__1_,
         mult_16_CARRYB_2__0_, mult_16_CARRYB_2__1_, mult_16_CARRYB_2__2_,
         mult_16_CARRYB_2__3_, mult_16_CARRYB_2__4_, mult_16_CARRYB_3__0_,
         mult_16_CARRYB_3__1_, mult_16_CARRYB_3__2_, mult_16_CARRYB_3__3_,
         mult_16_CARRYB_4__0_, mult_16_CARRYB_4__1_, mult_16_CARRYB_4__2_,
         mult_16_CARRYB_5__0_, mult_16_CARRYB_5__1_, mult_16_CARRYB_6__0_,
         mult_16_ab_0__1_, mult_16_ab_0__2_, mult_16_ab_0__3_,
         mult_16_ab_0__4_, mult_16_ab_0__5_, mult_16_ab_0__6_,
         mult_16_ab_1__0_, mult_16_ab_1__1_, mult_16_ab_1__2_,
         mult_16_ab_1__3_, mult_16_ab_1__4_, mult_16_ab_1__5_,
         mult_16_ab_1__6_, mult_16_ab_2__0_, mult_16_ab_2__1_,
         mult_16_ab_2__2_, mult_16_ab_2__3_, mult_16_ab_2__4_,
         mult_16_ab_2__5_, mult_16_ab_3__0_, mult_16_ab_3__1_,
         mult_16_ab_3__2_, mult_16_ab_3__3_, mult_16_ab_3__4_,
         mult_16_ab_4__0_, mult_16_ab_4__1_, mult_16_ab_4__2_,
         mult_16_ab_4__3_, mult_16_ab_5__0_, mult_16_ab_5__1_,
         mult_16_ab_5__2_, mult_16_ab_6__0_, mult_16_ab_6__1_,
         mult_16_ab_7__0_, add_20_n74, add_20_n73, add_20_n72, add_20_n71,
         add_20_n70, add_20_n69, add_20_n68, add_20_n67, add_20_n66,
         add_20_n65, add_20_n64, add_20_n63, add_20_n62, add_20_n61,
         add_20_n60, add_20_n59, add_20_n58, add_20_n57, add_20_n56,
         add_20_n55, add_20_n54, add_20_n53, add_20_n52, add_20_n51,
         add_20_n50, add_20_n49, add_20_n48, add_20_n47, add_20_n46,
         add_20_n45, add_20_n44, add_20_n43, add_20_n42, add_20_n41,
         add_20_n40, add_20_n39, add_20_n38, add_20_n37, add_20_n36,
         add_20_n35, add_20_n34, add_20_n33, add_20_n32, add_20_n31,
         add_20_n30, add_20_n29, add_20_n28, add_20_n27, add_20_n26,
         add_20_n25, add_20_n24, add_20_n23, add_20_n22, add_20_n21,
         add_20_n20, add_20_n19, add_20_n18, add_20_n17, add_20_n16,
         add_20_n15, add_20_n14, add_20_n13, add_20_n12, add_20_n11,
         add_20_n10, add_20_n9, add_20_n8, add_20_n7, add_20_n6, add_20_n5,
         add_20_n4, add_20_n3, add_20_n1, rem_20_n205, rem_20_n204,
         rem_20_n203, rem_20_n202, rem_20_n201, rem_20_n200, rem_20_n199,
         rem_20_n198, rem_20_n197, rem_20_n196, rem_20_n195, rem_20_n194,
         rem_20_n193, rem_20_n192, rem_20_n191, rem_20_n190, rem_20_n189,
         rem_20_n188, rem_20_n187, rem_20_n186, rem_20_n185, rem_20_n184,
         rem_20_n183, rem_20_n182, rem_20_n181, rem_20_n180, rem_20_n179,
         rem_20_n178, rem_20_n177, rem_20_n176, rem_20_n175, rem_20_n174,
         rem_20_n173, rem_20_n172, rem_20_n171, rem_20_n170, rem_20_n169,
         rem_20_n168, rem_20_n167, rem_20_n166, rem_20_n165, rem_20_n164,
         rem_20_n163, rem_20_n162, rem_20_n161, rem_20_n160, rem_20_n159,
         rem_20_n158, rem_20_n157, rem_20_n156, rem_20_n155, rem_20_n154,
         rem_20_n153, rem_20_n152, rem_20_n151, rem_20_n150, rem_20_n149,
         rem_20_n148, rem_20_n147, rem_20_n146, rem_20_n145, rem_20_n144,
         rem_20_n143, rem_20_n142, rem_20_n141, rem_20_n140, rem_20_n139,
         rem_20_n138, rem_20_n137, rem_20_n136, rem_20_n135, rem_20_n134,
         rem_20_n133, rem_20_n132, rem_20_n131, rem_20_n130, rem_20_n129,
         rem_20_n128, rem_20_n127, rem_20_n126, rem_20_n125, rem_20_n124,
         rem_20_n123, rem_20_n122, rem_20_n121, rem_20_n120, rem_20_n119,
         rem_20_n118, rem_20_n117, rem_20_n116, rem_20_n115, rem_20_n114,
         rem_20_n113, rem_20_n112, rem_20_n111, rem_20_n110, rem_20_n109,
         rem_20_n108, rem_20_n107, rem_20_n106, rem_20_n105, rem_20_n104,
         rem_20_n103, rem_20_n102, rem_20_n101, rem_20_n100, rem_20_n99,
         rem_20_n98, rem_20_n97, rem_20_n96, rem_20_n95, rem_20_n94,
         rem_20_n93, rem_20_n92, rem_20_n91, rem_20_n90, rem_20_n89,
         rem_20_n88, rem_20_n87, rem_20_n86, rem_20_n85, rem_20_n84,
         rem_20_n83, rem_20_n82, rem_20_n81, rem_20_n80, rem_20_n79,
         rem_20_n78, rem_20_n77, rem_20_n76, rem_20_n75, rem_20_n74,
         rem_20_n73, rem_20_n72, rem_20_n71, rem_20_n70, rem_20_n69,
         rem_20_n68, rem_20_n67, rem_20_n66, rem_20_n65, rem_20_n64,
         rem_20_n63, rem_20_n62, rem_20_n61, rem_20_n60, rem_20_n59,
         rem_20_n58, rem_20_n57, rem_20_n56, rem_20_n55, rem_20_n54,
         rem_20_n53, rem_20_n52, rem_20_n51, rem_20_n50, rem_20_n49,
         rem_20_n48, rem_20_n47, rem_20_n46, rem_20_n45, rem_20_n44,
         rem_20_n43, rem_20_n42, rem_20_n41, rem_20_n40, rem_20_n39,
         rem_20_n38, rem_20_n37, rem_20_n36, rem_20_n35, rem_20_n34,
         rem_20_n33, rem_20_n32, rem_20_n31, rem_20_n30, rem_20_n29,
         rem_20_n28, rem_20_n27, rem_20_n26, rem_20_n25, rem_20_n24,
         rem_20_n23, rem_20_n22, rem_20_n21, rem_20_n20, rem_20_n19,
         rem_20_n18, rem_20_n17, rem_20_n16, rem_20_n15, rem_20_n14,
         rem_20_n13, rem_20_n12, rem_20_n11, rem_20_n10, rem_20_n9, rem_20_n8,
         rem_20_n7, rem_20_n6, rem_20_n5, rem_20_n4, rem_20_n3, rem_20_n2,
         rem_20_n1, rem_20_u_div_PartRem_6__2_, rem_20_u_div_PartRem_5__3_,
         rem_20_u_div_PartRem_5__2_, rem_20_u_div_PartRem_4__4_,
         rem_20_u_div_PartRem_4__3_, rem_20_u_div_PartRem_4__2_,
         rem_20_u_div_PartRem_4__1_, rem_20_u_div_PartRem_3__5_,
         rem_20_u_div_PartRem_3__4_, rem_20_u_div_PartRem_3__3_,
         rem_20_u_div_PartRem_3__2_, rem_20_u_div_PartRem_2__6_,
         rem_20_u_div_PartRem_2__5_, rem_20_u_div_PartRem_2__4_,
         rem_20_u_div_PartRem_2__3_, rem_20_u_div_PartRem_2__2_,
         rem_20_u_div_PartRem_1__7_, rem_20_u_div_PartRem_1__6_,
         rem_20_u_div_PartRem_1__5_, rem_20_u_div_PartRem_1__4_,
         rem_20_u_div_PartRem_1__3_, rem_20_u_div_PartRem_1__2_,
         rem_20_u_div_PartRem_1__1_, rem_20_u_div_CryTmp_7__1_,
         rem_20_u_div_CryTmp_6__2_, rem_20_u_div_CryTmp_6__1_,
         rem_20_u_div_CryTmp_5__3_, rem_20_u_div_CryTmp_5__2_,
         rem_20_u_div_CryTmp_5__1_, rem_20_u_div_CryTmp_4__4_,
         rem_20_u_div_CryTmp_4__3_, rem_20_u_div_CryTmp_4__2_,
         rem_20_u_div_CryTmp_4__1_, rem_20_u_div_CryTmp_3__5_,
         rem_20_u_div_CryTmp_3__4_, rem_20_u_div_CryTmp_3__3_,
         rem_20_u_div_CryTmp_3__2_, rem_20_u_div_CryTmp_3__1_,
         rem_20_u_div_CryTmp_2__6_, rem_20_u_div_CryTmp_2__5_,
         rem_20_u_div_CryTmp_2__4_, rem_20_u_div_CryTmp_2__3_,
         rem_20_u_div_CryTmp_2__2_, rem_20_u_div_CryTmp_2__1_,
         rem_20_u_div_CryTmp_1__6_, rem_20_u_div_CryTmp_1__5_,
         rem_20_u_div_CryTmp_1__4_, rem_20_u_div_CryTmp_1__3_,
         rem_20_u_div_CryTmp_1__2_, rem_20_u_div_CryTmp_1__1_,
         rem_20_u_div_CryTmp_0__8_, rem_20_u_div_CryTmp_0__7_,
         rem_20_u_div_CryTmp_0__6_, rem_20_u_div_CryTmp_0__5_,
         rem_20_u_div_CryTmp_0__4_, rem_20_u_div_CryTmp_0__3_,
         rem_20_u_div_CryTmp_0__2_, rem_20_u_div_CryTmp_0__1_,
         rem_20_u_div_SumTmp_7__0_, rem_20_u_div_SumTmp_6__1_,
         rem_20_u_div_SumTmp_6__0_, rem_20_u_div_SumTmp_5__2_,
         rem_20_u_div_SumTmp_5__1_, rem_20_u_div_SumTmp_5__0_,
         rem_20_u_div_SumTmp_3__4_, rem_20_u_div_SumTmp_3__3_,
         rem_20_u_div_SumTmp_3__1_, rem_20_u_div_SumTmp_3__0_,
         rem_20_u_div_SumTmp_2__3_, rem_20_u_div_SumTmp_2__2_,
         rem_20_u_div_SumTmp_2__0_, rem_20_u_div_SumTmp_1__0_,
         rem_20_u_div_SumTmp_0__7_, rem_20_u_div_SumTmp_0__6_,
         rem_20_u_div_SumTmp_0__5_, rem_20_u_div_SumTmp_0__4_,
         rem_20_u_div_SumTmp_0__3_, rem_20_u_div_SumTmp_0__2_,
         rem_20_u_div_SumTmp_0__1_, rem_20_u_div_SumTmp_0__0_;
  wire   [7:1] sub_22_carry;
  wire   [7:2] add_0_root_add_21_2_carry;
  wire   [7:2] add_18_carry;
  wire   [7:2] r91_carry;
  wire   [7:1] sub_2_root_sub_0_root_sub_23_carry;
  wire   [7:2] add_1_root_sub_0_root_sub_23_carry;
  wire   [7:2] add_0_root_sub_0_root_sub_23_carry;
  wire   [7:0] rem_20_u_div_BInv;

  BUF_X1 U11 ( .A(n13), .Z(n14) );
  BUF_X2 U12 ( .A(b[4]), .Z(n11) );
  BUF_X1 U13 ( .A(b[7]), .Z(n12) );
  BUF_X1 U14 ( .A(n12), .Z(n13) );
  BUF_X1 U15 ( .A(b[0]), .Z(n15) );
  INV_X1 sub_22_U11 ( .A(n15), .ZN(sub_22_n9) );
  INV_X1 sub_22_U10 ( .A(n14), .ZN(sub_22_n2) );
  XNOR2_X1 sub_22_U9 ( .A(sub_22_n9), .B(a[0]), .ZN(s5[0]) );
  INV_X1 sub_22_U8 ( .A(a[0]), .ZN(sub_22_n1) );
  NAND2_X1 sub_22_U7 ( .A1(n15), .A2(sub_22_n1), .ZN(sub_22_carry[1]) );
  INV_X1 sub_22_U6 ( .A(b[1]), .ZN(sub_22_n8) );
  INV_X1 sub_22_U5 ( .A(b[2]), .ZN(sub_22_n7) );
  INV_X1 sub_22_U4 ( .A(b[3]), .ZN(sub_22_n6) );
  INV_X1 sub_22_U3 ( .A(n11), .ZN(sub_22_n5) );
  INV_X1 sub_22_U2 ( .A(b[5]), .ZN(sub_22_n4) );
  INV_X1 sub_22_U1 ( .A(b[6]), .ZN(sub_22_n3) );
  FA_X1 sub_22_U2_1 ( .A(a[1]), .B(sub_22_n8), .CI(sub_22_carry[1]), .CO(
        sub_22_carry[2]), .S(s5[1]) );
  FA_X1 sub_22_U2_2 ( .A(a[2]), .B(sub_22_n7), .CI(sub_22_carry[2]), .CO(
        sub_22_carry[3]), .S(s5[2]) );
  FA_X1 sub_22_U2_3 ( .A(a[3]), .B(sub_22_n6), .CI(sub_22_carry[3]), .CO(
        sub_22_carry[4]), .S(s5[3]) );
  FA_X1 sub_22_U2_4 ( .A(a[4]), .B(sub_22_n5), .CI(sub_22_carry[4]), .CO(
        sub_22_carry[5]), .S(s5[4]) );
  FA_X1 sub_22_U2_5 ( .A(a[5]), .B(sub_22_n4), .CI(sub_22_carry[5]), .CO(
        sub_22_carry[6]), .S(s5[5]) );
  FA_X1 sub_22_U2_6 ( .A(a[6]), .B(sub_22_n3), .CI(sub_22_carry[6]), .CO(
        sub_22_carry[7]), .S(s5[6]) );
  FA_X1 sub_22_U2_7 ( .A(a[7]), .B(sub_22_n2), .CI(sub_22_carry[7]), .S(s5[7])
         );
  XOR2_X1 add_0_root_add_21_2_U2 ( .A(N8), .B(s2[0]), .Z(s4[0]) );
  AND2_X1 add_0_root_add_21_2_U1 ( .A1(N8), .A2(s2[0]), .ZN(
        add_0_root_add_21_2_n1) );
  FA_X1 add_0_root_add_21_2_U1_1 ( .A(s2[1]), .B(N9), .CI(
        add_0_root_add_21_2_n1), .CO(add_0_root_add_21_2_carry[2]), .S(s4[1])
         );
  FA_X1 add_0_root_add_21_2_U1_2 ( .A(s2[2]), .B(N10), .CI(
        add_0_root_add_21_2_carry[2]), .CO(add_0_root_add_21_2_carry[3]), .S(
        s4[2]) );
  FA_X1 add_0_root_add_21_2_U1_3 ( .A(s2[3]), .B(N11), .CI(
        add_0_root_add_21_2_carry[3]), .CO(add_0_root_add_21_2_carry[4]), .S(
        s4[3]) );
  FA_X1 add_0_root_add_21_2_U1_4 ( .A(s2[4]), .B(N12), .CI(
        add_0_root_add_21_2_carry[4]), .CO(add_0_root_add_21_2_carry[5]), .S(
        s4[4]) );
  FA_X1 add_0_root_add_21_2_U1_5 ( .A(s2[5]), .B(N13), .CI(
        add_0_root_add_21_2_carry[5]), .CO(add_0_root_add_21_2_carry[6]), .S(
        s4[5]) );
  FA_X1 add_0_root_add_21_2_U1_6 ( .A(s2[6]), .B(N14), .CI(
        add_0_root_add_21_2_carry[6]), .CO(add_0_root_add_21_2_carry[7]), .S(
        s4[6]) );
  FA_X1 add_0_root_add_21_2_U1_7 ( .A(s2[7]), .B(N15), .CI(
        add_0_root_add_21_2_carry[7]), .S(s4[7]) );
  XOR2_X1 add_18_U2 ( .A(n15), .B(a[0]), .Z(s1[0]) );
  AND2_X1 add_18_U1 ( .A1(n15), .A2(a[0]), .ZN(add_18_n1) );
  FA_X1 add_18_U1_1 ( .A(a[1]), .B(b[1]), .CI(add_18_n1), .CO(add_18_carry[2]), 
        .S(s1[1]) );
  FA_X1 add_18_U1_2 ( .A(a[2]), .B(b[2]), .CI(add_18_carry[2]), .CO(
        add_18_carry[3]), .S(s1[2]) );
  FA_X1 add_18_U1_3 ( .A(a[3]), .B(b[3]), .CI(add_18_carry[3]), .CO(
        add_18_carry[4]), .S(s1[3]) );
  FA_X1 add_18_U1_4 ( .A(a[4]), .B(n11), .CI(add_18_carry[4]), .CO(
        add_18_carry[5]), .S(s1[4]) );
  FA_X1 add_18_U1_5 ( .A(a[5]), .B(b[5]), .CI(add_18_carry[5]), .CO(
        add_18_carry[6]), .S(s1[5]) );
  FA_X1 add_18_U1_6 ( .A(a[6]), .B(b[6]), .CI(add_18_carry[6]), .CO(
        add_18_carry[7]), .S(s1[6]) );
  FA_X1 add_18_U1_7 ( .A(a[7]), .B(n14), .CI(add_18_carry[7]), .S(s1[7]) );
  XOR2_X1 r91_U2 ( .A(d[0]), .B(c[0]), .Z(N8) );
  AND2_X1 r91_U1 ( .A1(d[0]), .A2(c[0]), .ZN(r91_n1) );
  FA_X1 r91_U1_1 ( .A(c[1]), .B(d[1]), .CI(r91_n1), .CO(r91_carry[2]), .S(N9)
         );
  FA_X1 r91_U1_2 ( .A(c[2]), .B(d[2]), .CI(r91_carry[2]), .CO(r91_carry[3]), 
        .S(N10) );
  FA_X1 r91_U1_3 ( .A(c[3]), .B(d[3]), .CI(r91_carry[3]), .CO(r91_carry[4]), 
        .S(N11) );
  FA_X1 r91_U1_4 ( .A(c[4]), .B(d[4]), .CI(r91_carry[4]), .CO(r91_carry[5]), 
        .S(N12) );
  FA_X1 r91_U1_5 ( .A(c[5]), .B(d[5]), .CI(r91_carry[5]), .CO(r91_carry[6]), 
        .S(N13) );
  FA_X1 r91_U1_6 ( .A(c[6]), .B(d[6]), .CI(r91_carry[6]), .CO(r91_carry[7]), 
        .S(N14) );
  FA_X1 r91_U1_7 ( .A(c[7]), .B(d[7]), .CI(r91_carry[7]), .S(N15) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U11 ( .A(n15), .ZN(
        sub_2_root_sub_0_root_sub_23_n9) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U10 ( .A(n13), .ZN(
        sub_2_root_sub_0_root_sub_23_n2) );
  XNOR2_X1 sub_2_root_sub_0_root_sub_23_U9 ( .A(
        sub_2_root_sub_0_root_sub_23_n9), .B(a[0]), .ZN(N16) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U8 ( .A(b[5]), .ZN(
        sub_2_root_sub_0_root_sub_23_n4) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U7 ( .A(n11), .ZN(
        sub_2_root_sub_0_root_sub_23_n5) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U6 ( .A(b[3]), .ZN(
        sub_2_root_sub_0_root_sub_23_n6) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U5 ( .A(b[2]), .ZN(
        sub_2_root_sub_0_root_sub_23_n7) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U4 ( .A(b[6]), .ZN(
        sub_2_root_sub_0_root_sub_23_n3) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U3 ( .A(a[0]), .ZN(
        sub_2_root_sub_0_root_sub_23_n1) );
  NAND2_X1 sub_2_root_sub_0_root_sub_23_U2 ( .A1(n15), .A2(
        sub_2_root_sub_0_root_sub_23_n1), .ZN(
        sub_2_root_sub_0_root_sub_23_carry[1]) );
  INV_X1 sub_2_root_sub_0_root_sub_23_U1 ( .A(b[1]), .ZN(
        sub_2_root_sub_0_root_sub_23_n8) );
  FA_X1 sub_2_root_sub_0_root_sub_23_U2_1 ( .A(a[1]), .B(
        sub_2_root_sub_0_root_sub_23_n8), .CI(
        sub_2_root_sub_0_root_sub_23_carry[1]), .CO(
        sub_2_root_sub_0_root_sub_23_carry[2]), .S(N17) );
  FA_X1 sub_2_root_sub_0_root_sub_23_U2_2 ( .A(a[2]), .B(
        sub_2_root_sub_0_root_sub_23_n7), .CI(
        sub_2_root_sub_0_root_sub_23_carry[2]), .CO(
        sub_2_root_sub_0_root_sub_23_carry[3]), .S(N18) );
  FA_X1 sub_2_root_sub_0_root_sub_23_U2_3 ( .A(a[3]), .B(
        sub_2_root_sub_0_root_sub_23_n6), .CI(
        sub_2_root_sub_0_root_sub_23_carry[3]), .CO(
        sub_2_root_sub_0_root_sub_23_carry[4]), .S(N19) );
  FA_X1 sub_2_root_sub_0_root_sub_23_U2_4 ( .A(a[4]), .B(
        sub_2_root_sub_0_root_sub_23_n5), .CI(
        sub_2_root_sub_0_root_sub_23_carry[4]), .CO(
        sub_2_root_sub_0_root_sub_23_carry[5]), .S(N20) );
  FA_X1 sub_2_root_sub_0_root_sub_23_U2_5 ( .A(a[5]), .B(
        sub_2_root_sub_0_root_sub_23_n4), .CI(
        sub_2_root_sub_0_root_sub_23_carry[5]), .CO(
        sub_2_root_sub_0_root_sub_23_carry[6]), .S(N21) );
  FA_X1 sub_2_root_sub_0_root_sub_23_U2_6 ( .A(a[6]), .B(
        sub_2_root_sub_0_root_sub_23_n3), .CI(
        sub_2_root_sub_0_root_sub_23_carry[6]), .CO(
        sub_2_root_sub_0_root_sub_23_carry[7]), .S(N22) );
  FA_X1 sub_2_root_sub_0_root_sub_23_U2_7 ( .A(a[7]), .B(
        sub_2_root_sub_0_root_sub_23_n2), .CI(
        sub_2_root_sub_0_root_sub_23_carry[7]), .S(N23) );
  XOR2_X1 add_1_root_sub_0_root_sub_23_U2 ( .A(N16), .B(N8), .Z(N32) );
  AND2_X1 add_1_root_sub_0_root_sub_23_U1 ( .A1(N16), .A2(N8), .ZN(
        add_1_root_sub_0_root_sub_23_n1) );
  FA_X1 add_1_root_sub_0_root_sub_23_U1_1 ( .A(N9), .B(N17), .CI(
        add_1_root_sub_0_root_sub_23_n1), .CO(
        add_1_root_sub_0_root_sub_23_carry[2]), .S(N33) );
  FA_X1 add_1_root_sub_0_root_sub_23_U1_2 ( .A(N10), .B(N18), .CI(
        add_1_root_sub_0_root_sub_23_carry[2]), .CO(
        add_1_root_sub_0_root_sub_23_carry[3]), .S(N34) );
  FA_X1 add_1_root_sub_0_root_sub_23_U1_3 ( .A(N11), .B(N19), .CI(
        add_1_root_sub_0_root_sub_23_carry[3]), .CO(
        add_1_root_sub_0_root_sub_23_carry[4]), .S(N35) );
  FA_X1 add_1_root_sub_0_root_sub_23_U1_4 ( .A(N12), .B(N20), .CI(
        add_1_root_sub_0_root_sub_23_carry[4]), .CO(
        add_1_root_sub_0_root_sub_23_carry[5]), .S(N36) );
  FA_X1 add_1_root_sub_0_root_sub_23_U1_5 ( .A(N13), .B(N21), .CI(
        add_1_root_sub_0_root_sub_23_carry[5]), .CO(
        add_1_root_sub_0_root_sub_23_carry[6]), .S(N37) );
  FA_X1 add_1_root_sub_0_root_sub_23_U1_6 ( .A(N14), .B(N22), .CI(
        add_1_root_sub_0_root_sub_23_carry[6]), .CO(
        add_1_root_sub_0_root_sub_23_carry[7]), .S(N38) );
  FA_X1 add_1_root_sub_0_root_sub_23_U1_7 ( .A(N15), .B(N23), .CI(
        add_1_root_sub_0_root_sub_23_carry[7]), .S(N39) );
  XOR2_X1 add_0_root_sub_0_root_sub_23_U2 ( .A(s2[0]), .B(N32), .Z(s6[0]) );
  AND2_X1 add_0_root_sub_0_root_sub_23_U1 ( .A1(s2[0]), .A2(N32), .ZN(
        add_0_root_sub_0_root_sub_23_n1) );
  FA_X1 add_0_root_sub_0_root_sub_23_U1_1 ( .A(N33), .B(s2[1]), .CI(
        add_0_root_sub_0_root_sub_23_n1), .CO(
        add_0_root_sub_0_root_sub_23_carry[2]), .S(s6[1]) );
  FA_X1 add_0_root_sub_0_root_sub_23_U1_2 ( .A(N34), .B(s2[2]), .CI(
        add_0_root_sub_0_root_sub_23_carry[2]), .CO(
        add_0_root_sub_0_root_sub_23_carry[3]), .S(s6[2]) );
  FA_X1 add_0_root_sub_0_root_sub_23_U1_3 ( .A(N35), .B(s2[3]), .CI(
        add_0_root_sub_0_root_sub_23_carry[3]), .CO(
        add_0_root_sub_0_root_sub_23_carry[4]), .S(s6[3]) );
  FA_X1 add_0_root_sub_0_root_sub_23_U1_4 ( .A(N36), .B(s2[4]), .CI(
        add_0_root_sub_0_root_sub_23_carry[4]), .CO(
        add_0_root_sub_0_root_sub_23_carry[5]), .S(s6[4]) );
  FA_X1 add_0_root_sub_0_root_sub_23_U1_5 ( .A(N37), .B(s2[5]), .CI(
        add_0_root_sub_0_root_sub_23_carry[5]), .CO(
        add_0_root_sub_0_root_sub_23_carry[6]), .S(s6[5]) );
  FA_X1 add_0_root_sub_0_root_sub_23_U1_6 ( .A(N38), .B(s2[6]), .CI(
        add_0_root_sub_0_root_sub_23_carry[6]), .CO(
        add_0_root_sub_0_root_sub_23_carry[7]), .S(s6[6]) );
  FA_X1 add_0_root_sub_0_root_sub_23_U1_7 ( .A(N39), .B(s2[7]), .CI(
        add_0_root_sub_0_root_sub_23_carry[7]), .S(s6[7]) );
  NOR2_X1 mult_16_U64 ( .A1(mult_16_n29), .A2(mult_16_n28), .ZN(s2[0]) );
  AND2_X1 mult_16_U63 ( .A1(a[7]), .A2(n15), .ZN(mult_16_ab_7__0_) );
  NOR2_X1 mult_16_U62 ( .A1(mult_16_n28), .A2(mult_16_n27), .ZN(
        mult_16_ab_6__0_) );
  NOR2_X1 mult_16_U61 ( .A1(mult_16_n27), .A2(mult_16_n26), .ZN(
        mult_16_ab_6__1_) );
  INV_X1 mult_16_U60 ( .A(a[6]), .ZN(mult_16_n27) );
  NOR2_X1 mult_16_U59 ( .A1(mult_16_n28), .A2(mult_16_n25), .ZN(
        mult_16_ab_5__0_) );
  NOR2_X1 mult_16_U58 ( .A1(mult_16_n26), .A2(mult_16_n25), .ZN(
        mult_16_ab_5__1_) );
  NOR2_X1 mult_16_U57 ( .A1(mult_16_n25), .A2(mult_16_n24), .ZN(
        mult_16_ab_5__2_) );
  INV_X1 mult_16_U56 ( .A(a[5]), .ZN(mult_16_n25) );
  NOR2_X1 mult_16_U55 ( .A1(mult_16_n28), .A2(mult_16_n23), .ZN(
        mult_16_ab_4__0_) );
  NOR2_X1 mult_16_U54 ( .A1(mult_16_n26), .A2(mult_16_n23), .ZN(
        mult_16_ab_4__1_) );
  NOR2_X1 mult_16_U53 ( .A1(mult_16_n24), .A2(mult_16_n23), .ZN(
        mult_16_ab_4__2_) );
  NOR2_X1 mult_16_U52 ( .A1(mult_16_n23), .A2(mult_16_n22), .ZN(
        mult_16_ab_4__3_) );
  INV_X1 mult_16_U51 ( .A(a[4]), .ZN(mult_16_n23) );
  NOR2_X1 mult_16_U50 ( .A1(mult_16_n28), .A2(mult_16_n21), .ZN(
        mult_16_ab_3__0_) );
  NOR2_X1 mult_16_U49 ( .A1(mult_16_n26), .A2(mult_16_n21), .ZN(
        mult_16_ab_3__1_) );
  NOR2_X1 mult_16_U48 ( .A1(mult_16_n24), .A2(mult_16_n21), .ZN(
        mult_16_ab_3__2_) );
  NOR2_X1 mult_16_U47 ( .A1(mult_16_n22), .A2(mult_16_n21), .ZN(
        mult_16_ab_3__3_) );
  NOR2_X1 mult_16_U46 ( .A1(mult_16_n21), .A2(mult_16_n20), .ZN(
        mult_16_ab_3__4_) );
  INV_X1 mult_16_U45 ( .A(a[3]), .ZN(mult_16_n21) );
  NOR2_X1 mult_16_U44 ( .A1(mult_16_n28), .A2(mult_16_n19), .ZN(
        mult_16_ab_2__0_) );
  NOR2_X1 mult_16_U43 ( .A1(mult_16_n26), .A2(mult_16_n19), .ZN(
        mult_16_ab_2__1_) );
  NOR2_X1 mult_16_U42 ( .A1(mult_16_n24), .A2(mult_16_n19), .ZN(
        mult_16_ab_2__2_) );
  NOR2_X1 mult_16_U41 ( .A1(mult_16_n22), .A2(mult_16_n19), .ZN(
        mult_16_ab_2__3_) );
  NOR2_X1 mult_16_U40 ( .A1(mult_16_n20), .A2(mult_16_n19), .ZN(
        mult_16_ab_2__4_) );
  NOR2_X1 mult_16_U39 ( .A1(mult_16_n19), .A2(mult_16_n18), .ZN(
        mult_16_ab_2__5_) );
  INV_X1 mult_16_U38 ( .A(a[2]), .ZN(mult_16_n19) );
  NOR2_X1 mult_16_U37 ( .A1(mult_16_n28), .A2(mult_16_n17), .ZN(
        mult_16_ab_1__0_) );
  INV_X1 mult_16_U36 ( .A(n15), .ZN(mult_16_n28) );
  NOR2_X1 mult_16_U35 ( .A1(mult_16_n29), .A2(mult_16_n26), .ZN(
        mult_16_ab_0__1_) );
  NOR2_X1 mult_16_U34 ( .A1(mult_16_n26), .A2(mult_16_n17), .ZN(
        mult_16_ab_1__1_) );
  INV_X1 mult_16_U33 ( .A(b[1]), .ZN(mult_16_n26) );
  NOR2_X1 mult_16_U32 ( .A1(mult_16_n29), .A2(mult_16_n24), .ZN(
        mult_16_ab_0__2_) );
  NOR2_X1 mult_16_U31 ( .A1(mult_16_n24), .A2(mult_16_n17), .ZN(
        mult_16_ab_1__2_) );
  INV_X1 mult_16_U30 ( .A(b[2]), .ZN(mult_16_n24) );
  NOR2_X1 mult_16_U29 ( .A1(mult_16_n29), .A2(mult_16_n22), .ZN(
        mult_16_ab_0__3_) );
  NOR2_X1 mult_16_U28 ( .A1(mult_16_n22), .A2(mult_16_n17), .ZN(
        mult_16_ab_1__3_) );
  INV_X1 mult_16_U27 ( .A(b[3]), .ZN(mult_16_n22) );
  NOR2_X1 mult_16_U26 ( .A1(mult_16_n29), .A2(mult_16_n20), .ZN(
        mult_16_ab_0__4_) );
  NOR2_X1 mult_16_U25 ( .A1(mult_16_n20), .A2(mult_16_n17), .ZN(
        mult_16_ab_1__4_) );
  INV_X1 mult_16_U24 ( .A(n11), .ZN(mult_16_n20) );
  NOR2_X1 mult_16_U23 ( .A1(mult_16_n29), .A2(mult_16_n18), .ZN(
        mult_16_ab_0__5_) );
  NOR2_X1 mult_16_U22 ( .A1(mult_16_n18), .A2(mult_16_n17), .ZN(
        mult_16_ab_1__5_) );
  INV_X1 mult_16_U21 ( .A(b[5]), .ZN(mult_16_n18) );
  NOR2_X1 mult_16_U20 ( .A1(mult_16_n29), .A2(mult_16_n16), .ZN(
        mult_16_ab_0__6_) );
  INV_X1 mult_16_U19 ( .A(a[0]), .ZN(mult_16_n29) );
  NOR2_X1 mult_16_U18 ( .A1(mult_16_n17), .A2(mult_16_n16), .ZN(
        mult_16_ab_1__6_) );
  INV_X1 mult_16_U17 ( .A(b[6]), .ZN(mult_16_n16) );
  INV_X1 mult_16_U16 ( .A(a[1]), .ZN(mult_16_n17) );
  NAND2_X1 mult_16_U15 ( .A1(n12), .A2(a[0]), .ZN(mult_16_n15) );
  XNOR2_X1 mult_16_U14 ( .A(mult_16_n15), .B(mult_16_ab_1__6_), .ZN(
        mult_16_n14) );
  XOR2_X1 mult_16_U13 ( .A(mult_16_ab_1__0_), .B(mult_16_ab_0__1_), .Z(s2[1])
         );
  AND2_X1 mult_16_U12 ( .A1(mult_16_ab_0__6_), .A2(mult_16_ab_1__5_), .ZN(
        mult_16_n12) );
  XOR2_X1 mult_16_U11 ( .A(mult_16_ab_1__1_), .B(mult_16_ab_0__2_), .Z(
        mult_16_n11) );
  AND2_X1 mult_16_U10 ( .A1(mult_16_ab_0__2_), .A2(mult_16_ab_1__1_), .ZN(
        mult_16_n10) );
  AND2_X1 mult_16_U9 ( .A1(mult_16_ab_0__3_), .A2(mult_16_ab_1__2_), .ZN(
        mult_16_n9) );
  AND2_X1 mult_16_U8 ( .A1(mult_16_ab_0__4_), .A2(mult_16_ab_1__3_), .ZN(
        mult_16_n8) );
  XOR2_X1 mult_16_U7 ( .A(mult_16_ab_1__5_), .B(mult_16_ab_0__6_), .Z(
        mult_16_n7) );
  XOR2_X1 mult_16_U6 ( .A(mult_16_ab_1__2_), .B(mult_16_ab_0__3_), .Z(
        mult_16_n6) );
  AND2_X1 mult_16_U5 ( .A1(mult_16_ab_0__1_), .A2(mult_16_ab_1__0_), .ZN(
        mult_16_n5) );
  XOR2_X1 mult_16_U4 ( .A(mult_16_ab_1__3_), .B(mult_16_ab_0__4_), .Z(
        mult_16_n4) );
  AND2_X1 mult_16_U3 ( .A1(mult_16_ab_0__5_), .A2(mult_16_ab_1__4_), .ZN(
        mult_16_n3) );
  XOR2_X1 mult_16_U2 ( .A(mult_16_ab_1__4_), .B(mult_16_ab_0__5_), .Z(
        mult_16_n2) );
  FA_X1 mult_16_S2_2_5 ( .A(mult_16_ab_2__5_), .B(mult_16_n12), .CI(
        mult_16_n14), .S(mult_16_SUMB_2__5_) );
  FA_X1 mult_16_S2_2_4 ( .A(mult_16_ab_2__4_), .B(mult_16_n3), .CI(mult_16_n7), 
        .CO(mult_16_CARRYB_2__4_), .S(mult_16_SUMB_2__4_) );
  FA_X1 mult_16_S2_2_3 ( .A(mult_16_ab_2__3_), .B(mult_16_n8), .CI(mult_16_n2), 
        .CO(mult_16_CARRYB_2__3_), .S(mult_16_SUMB_2__3_) );
  FA_X1 mult_16_S2_2_2 ( .A(mult_16_ab_2__2_), .B(mult_16_n9), .CI(mult_16_n4), 
        .CO(mult_16_CARRYB_2__2_), .S(mult_16_SUMB_2__2_) );
  FA_X1 mult_16_S2_2_1 ( .A(mult_16_ab_2__1_), .B(mult_16_n10), .CI(mult_16_n6), .CO(mult_16_CARRYB_2__1_), .S(mult_16_SUMB_2__1_) );
  FA_X1 mult_16_S1_2_0 ( .A(mult_16_ab_2__0_), .B(mult_16_n5), .CI(mult_16_n11), .CO(mult_16_CARRYB_2__0_), .S(s2[2]) );
  FA_X1 mult_16_S2_3_4 ( .A(mult_16_ab_3__4_), .B(mult_16_CARRYB_2__4_), .CI(
        mult_16_SUMB_2__5_), .S(mult_16_SUMB_3__4_) );
  FA_X1 mult_16_S2_3_3 ( .A(mult_16_ab_3__3_), .B(mult_16_CARRYB_2__3_), .CI(
        mult_16_SUMB_2__4_), .CO(mult_16_CARRYB_3__3_), .S(mult_16_SUMB_3__3_)
         );
  FA_X1 mult_16_S2_3_2 ( .A(mult_16_ab_3__2_), .B(mult_16_CARRYB_2__2_), .CI(
        mult_16_SUMB_2__3_), .CO(mult_16_CARRYB_3__2_), .S(mult_16_SUMB_3__2_)
         );
  FA_X1 mult_16_S2_3_1 ( .A(mult_16_ab_3__1_), .B(mult_16_CARRYB_2__1_), .CI(
        mult_16_SUMB_2__2_), .CO(mult_16_CARRYB_3__1_), .S(mult_16_SUMB_3__1_)
         );
  FA_X1 mult_16_S1_3_0 ( .A(mult_16_ab_3__0_), .B(mult_16_CARRYB_2__0_), .CI(
        mult_16_SUMB_2__1_), .CO(mult_16_CARRYB_3__0_), .S(s2[3]) );
  FA_X1 mult_16_S2_4_3 ( .A(mult_16_ab_4__3_), .B(mult_16_CARRYB_3__3_), .CI(
        mult_16_SUMB_3__4_), .S(mult_16_SUMB_4__3_) );
  FA_X1 mult_16_S2_4_2 ( .A(mult_16_ab_4__2_), .B(mult_16_CARRYB_3__2_), .CI(
        mult_16_SUMB_3__3_), .CO(mult_16_CARRYB_4__2_), .S(mult_16_SUMB_4__2_)
         );
  FA_X1 mult_16_S2_4_1 ( .A(mult_16_ab_4__1_), .B(mult_16_CARRYB_3__1_), .CI(
        mult_16_SUMB_3__2_), .CO(mult_16_CARRYB_4__1_), .S(mult_16_SUMB_4__1_)
         );
  FA_X1 mult_16_S1_4_0 ( .A(mult_16_ab_4__0_), .B(mult_16_CARRYB_3__0_), .CI(
        mult_16_SUMB_3__1_), .CO(mult_16_CARRYB_4__0_), .S(s2[4]) );
  FA_X1 mult_16_S2_5_2 ( .A(mult_16_ab_5__2_), .B(mult_16_CARRYB_4__2_), .CI(
        mult_16_SUMB_4__3_), .S(mult_16_SUMB_5__2_) );
  FA_X1 mult_16_S2_5_1 ( .A(mult_16_ab_5__1_), .B(mult_16_CARRYB_4__1_), .CI(
        mult_16_SUMB_4__2_), .CO(mult_16_CARRYB_5__1_), .S(mult_16_SUMB_5__1_)
         );
  FA_X1 mult_16_S1_5_0 ( .A(mult_16_ab_5__0_), .B(mult_16_CARRYB_4__0_), .CI(
        mult_16_SUMB_4__1_), .CO(mult_16_CARRYB_5__0_), .S(s2[5]) );
  FA_X1 mult_16_S2_6_1 ( .A(mult_16_ab_6__1_), .B(mult_16_CARRYB_5__1_), .CI(
        mult_16_SUMB_5__2_), .S(mult_16_SUMB_6__1_) );
  FA_X1 mult_16_S1_6_0 ( .A(mult_16_ab_6__0_), .B(mult_16_CARRYB_5__0_), .CI(
        mult_16_SUMB_5__1_), .CO(mult_16_CARRYB_6__0_), .S(s2[6]) );
  FA_X1 mult_16_S4_0 ( .A(mult_16_ab_7__0_), .B(mult_16_CARRYB_6__0_), .CI(
        mult_16_SUMB_6__1_), .S(s2[7]) );
  INV_X1 add_20_U82 ( .A(add_20_n17), .ZN(add_20_n73) );
  INV_X1 add_20_U81 ( .A(add_20_n63), .ZN(add_20_n36) );
  INV_X1 add_20_U80 ( .A(add_20_n71), .ZN(add_20_n70) );
  OAI21_X1 add_20_U79 ( .B1(add_20_n70), .B2(add_20_n23), .A(add_20_n68), .ZN(
        add_20_n69) );
  INV_X1 add_20_U78 ( .A(add_20_n67), .ZN(add_20_n44) );
  INV_X1 add_20_U77 ( .A(add_20_n49), .ZN(add_20_n59) );
  INV_X1 add_20_U76 ( .A(add_20_n51), .ZN(add_20_n48) );
  INV_X1 add_20_U75 ( .A(add_20_n50), .ZN(add_20_n56) );
  INV_X1 add_20_U74 ( .A(add_20_n38), .ZN(add_20_n47) );
  XNOR2_X1 add_20_U73 ( .A(add_20_n45), .B(add_20_n46), .ZN(s3[6]) );
  INV_X1 add_20_U72 ( .A(add_20_n39), .ZN(add_20_n37) );
  INV_X1 add_20_U71 ( .A(add_20_n41), .ZN(add_20_n40) );
  INV_X1 add_20_U70 ( .A(add_20_n11), .ZN(add_20_n33) );
  NOR2_X1 add_20_U69 ( .A1(add_20_n36), .A2(add_20_n37), .ZN(add_20_n34) );
  NAND4_X1 add_20_U68 ( .A1(add_20_n21), .A2(add_20_n33), .A3(add_20_n34), 
        .A4(add_20_n12), .ZN(add_20_n32) );
  XNOR2_X1 add_20_U67 ( .A(add_20_n28), .B(add_20_n29), .ZN(s3[7]) );
  NAND2_X1 add_20_U66 ( .A1(N0), .A2(d[0]), .ZN(add_20_n65) );
  NAND2_X1 add_20_U65 ( .A1(add_20_n64), .A2(add_20_n65), .ZN(add_20_n35) );
  AOI21_X1 add_20_U64 ( .B1(add_20_n53), .B2(add_20_n52), .A(add_20_n59), .ZN(
        add_20_n54) );
  XNOR2_X1 add_20_U63 ( .A(add_20_n22), .B(add_20_n60), .ZN(s3[4]) );
  NAND2_X1 add_20_U62 ( .A1(N1), .A2(d[1]), .ZN(add_20_n64) );
  NAND2_X1 add_20_U61 ( .A1(add_20_n61), .A2(add_20_n16), .ZN(add_20_n53) );
  NOR2_X1 add_20_U60 ( .A1(add_20_n62), .A2(add_20_n44), .ZN(add_20_n61) );
  XNOR2_X1 add_20_U59 ( .A(add_20_n54), .B(add_20_n55), .ZN(s3[5]) );
  NAND2_X1 add_20_U58 ( .A1(N3), .A2(d[3]), .ZN(add_20_n67) );
  AOI21_X1 add_20_U57 ( .B1(add_20_n42), .B2(add_20_n27), .A(add_20_n43), .ZN(
        add_20_n30) );
  NAND2_X1 add_20_U56 ( .A1(d[4]), .A2(N4), .ZN(add_20_n49) );
  NOR2_X1 add_20_U55 ( .A1(add_20_n11), .A2(add_20_n37), .ZN(add_20_n42) );
  OAI21_X1 add_20_U54 ( .B1(add_20_n24), .B2(add_20_n18), .A(add_20_n47), .ZN(
        add_20_n45) );
  NAND2_X1 add_20_U53 ( .A1(add_20_n68), .A2(add_20_n7), .ZN(add_20_n72) );
  NAND2_X1 add_20_U52 ( .A1(add_20_n10), .A2(add_20_n25), .ZN(add_20_n74) );
  OAI21_X1 add_20_U51 ( .B1(add_20_n73), .B2(add_20_n36), .A(add_20_n25), .ZN(
        add_20_n71) );
  NAND3_X1 add_20_U50 ( .A1(add_20_n31), .A2(add_20_n32), .A3(add_20_n30), 
        .ZN(add_20_n28) );
  NAND2_X1 add_20_U49 ( .A1(d[6]), .A2(N6), .ZN(add_20_n41) );
  NAND2_X1 add_20_U48 ( .A1(d[5]), .A2(N5), .ZN(add_20_n50) );
  OR2_X2 add_20_U47 ( .A1(N4), .A2(d[4]), .ZN(add_20_n52) );
  INV_X1 add_20_U46 ( .A(N5), .ZN(add_20_n58) );
  INV_X1 add_20_U45 ( .A(d[5]), .ZN(add_20_n57) );
  NAND2_X1 add_20_U44 ( .A1(add_20_n57), .A2(add_20_n58), .ZN(add_20_n51) );
  XNOR2_X1 add_20_U43 ( .A(d[7]), .B(N7), .ZN(add_20_n29) );
  OR2_X2 add_20_U42 ( .A1(N6), .A2(d[6]), .ZN(add_20_n39) );
  XNOR2_X1 add_20_U41 ( .A(add_20_n74), .B(add_20_n3), .ZN(s3[1]) );
  XNOR2_X1 add_20_U40 ( .A(add_20_n5), .B(add_20_n72), .ZN(s3[2]) );
  NAND2_X1 add_20_U39 ( .A1(add_20_n52), .A2(add_20_n49), .ZN(add_20_n60) );
  AOI21_X1 add_20_U38 ( .B1(add_20_n38), .B2(add_20_n39), .A(add_20_n40), .ZN(
        add_20_n31) );
  OAI21_X1 add_20_U37 ( .B1(add_20_n48), .B2(add_20_n49), .A(add_20_n50), .ZN(
        add_20_n38) );
  NOR2_X1 add_20_U36 ( .A1(add_20_n48), .A2(add_20_n56), .ZN(add_20_n55) );
  AND2_X1 add_20_U35 ( .A1(add_20_n6), .A2(add_20_n20), .ZN(add_20_n27) );
  NAND2_X1 add_20_U34 ( .A1(add_20_n41), .A2(add_20_n39), .ZN(add_20_n46) );
  CLKBUF_X1 add_20_U33 ( .A(N0), .Z(add_20_n26) );
  CLKBUF_X1 add_20_U32 ( .A(add_20_n64), .Z(add_20_n25) );
  NOR2_X1 add_20_U31 ( .A1(d[2]), .A2(add_20_n9), .ZN(add_20_n23) );
  AND2_X1 add_20_U30 ( .A1(add_20_n7), .A2(add_20_n20), .ZN(add_20_n21) );
  OR2_X1 add_20_U29 ( .A1(N3), .A2(d[3]), .ZN(add_20_n66) );
  OR2_X1 add_20_U28 ( .A1(N3), .A2(d[3]), .ZN(add_20_n20) );
  INV_X1 add_20_U27 ( .A(add_20_n33), .ZN(add_20_n18) );
  AND2_X1 add_20_U26 ( .A1(N0), .A2(d[0]), .ZN(add_20_n17) );
  NAND2_X1 add_20_U25 ( .A1(add_20_n6), .A2(add_20_n20), .ZN(add_20_n16) );
  NAND2_X1 add_20_U24 ( .A1(add_20_n67), .A2(add_20_n16), .ZN(add_20_n15) );
  NOR2_X1 add_20_U23 ( .A1(add_20_n14), .A2(add_20_n15), .ZN(add_20_n24) );
  NOR2_X1 add_20_U22 ( .A1(add_20_n13), .A2(add_20_n8), .ZN(add_20_n14) );
  NAND2_X1 add_20_U21 ( .A1(add_20_n10), .A2(add_20_n12), .ZN(add_20_n13) );
  NAND2_X1 add_20_U20 ( .A1(add_20_n64), .A2(add_20_n65), .ZN(add_20_n12) );
  NAND2_X1 add_20_U19 ( .A1(add_20_n51), .A2(add_20_n52), .ZN(add_20_n11) );
  CLKBUF_X1 add_20_U18 ( .A(N2), .Z(add_20_n9) );
  NAND2_X1 add_20_U17 ( .A1(add_20_n66), .A2(add_20_n7), .ZN(add_20_n8) );
  AND4_X1 add_20_U16 ( .A1(add_20_n35), .A2(add_20_n66), .A3(add_20_n63), .A4(
        add_20_n19), .ZN(add_20_n62) );
  AND4_X1 add_20_U15 ( .A1(add_20_n44), .A2(add_20_n52), .A3(add_20_n39), .A4(
        add_20_n51), .ZN(add_20_n43) );
  BUF_X1 add_20_U14 ( .A(add_20_n63), .Z(add_20_n10) );
  OR2_X1 add_20_U13 ( .A1(N2), .A2(d[2]), .ZN(add_20_n19) );
  OR2_X1 add_20_U12 ( .A1(N2), .A2(d[2]), .ZN(add_20_n7) );
  OAI21_X1 add_20_U11 ( .B1(add_20_n73), .B2(add_20_n36), .A(add_20_n25), .ZN(
        add_20_n5) );
  AND2_X1 add_20_U10 ( .A1(add_20_n67), .A2(add_20_n20), .ZN(add_20_n4) );
  XOR2_X1 add_20_U9 ( .A(add_20_n69), .B(add_20_n4), .Z(s3[3]) );
  INV_X1 add_20_U8 ( .A(add_20_n6), .ZN(add_20_n68) );
  INV_X1 add_20_U7 ( .A(add_20_n73), .ZN(add_20_n3) );
  NOR2_X1 add_20_U6 ( .A1(add_20_n26), .A2(d[0]), .ZN(add_20_n1) );
  NOR2_X1 add_20_U5 ( .A1(add_20_n1), .A2(add_20_n17), .ZN(s3[0]) );
  OR2_X2 add_20_U4 ( .A1(N1), .A2(d[1]), .ZN(add_20_n63) );
  BUF_X1 add_20_U3 ( .A(add_20_n53), .Z(add_20_n22) );
  AND2_X2 add_20_U2 ( .A1(N2), .A2(d[2]), .ZN(add_20_n6) );
  MUX2_X1 rem_20_U279 ( .A(a[0]), .B(rem_20_u_div_SumTmp_0__0_), .S(rem_20_n82), .Z(N0) );
  MUX2_X1 rem_20_U278 ( .A(rem_20_n30), .B(rem_20_u_div_SumTmp_0__1_), .S(
        rem_20_n82), .Z(N1) );
  MUX2_X1 rem_20_U277 ( .A(rem_20_n182), .B(rem_20_n14), .S(rem_20_n3), .Z(
        rem_20_n203) );
  INV_X1 rem_20_U276 ( .A(rem_20_n203), .ZN(rem_20_u_div_PartRem_1__2_) );
  MUX2_X1 rem_20_U275 ( .A(rem_20_n176), .B(rem_20_n11), .S(rem_20_n146), .Z(
        rem_20_n181) );
  MUX2_X1 rem_20_U274 ( .A(rem_20_n181), .B(rem_20_n15), .S(rem_20_n3), .Z(
        rem_20_n202) );
  INV_X1 rem_20_U273 ( .A(rem_20_n202), .ZN(rem_20_u_div_PartRem_1__3_) );
  MUX2_X1 rem_20_U272 ( .A(rem_20_n27), .B(rem_20_n200), .S(rem_20_n143), .Z(
        rem_20_n175) );
  MUX2_X1 rem_20_U271 ( .A(rem_20_n175), .B(rem_20_n199), .S(rem_20_n146), .Z(
        rem_20_n180) );
  MUX2_X1 rem_20_U270 ( .A(rem_20_n180), .B(rem_20_n18), .S(rem_20_n3), .Z(
        rem_20_n198) );
  INV_X1 rem_20_U269 ( .A(rem_20_n198), .ZN(rem_20_u_div_PartRem_1__4_) );
  MUX2_X1 rem_20_U268 ( .A(rem_20_u_div_PartRem_1__4_), .B(
        rem_20_u_div_SumTmp_0__4_), .S(rem_20_u_div_CryTmp_0__8_), .Z(N4) );
  MUX2_X1 rem_20_U267 ( .A(rem_20_n167), .B(rem_20_n8), .S(rem_20_n144), .Z(
        rem_20_n170) );
  MUX2_X1 rem_20_U266 ( .A(rem_20_n170), .B(rem_20_n9), .S(rem_20_n143), .Z(
        rem_20_n174) );
  MUX2_X1 rem_20_U265 ( .A(rem_20_n174), .B(rem_20_n195), .S(rem_20_n146), .Z(
        rem_20_n179) );
  MUX2_X1 rem_20_U264 ( .A(rem_20_n179), .B(rem_20_n16), .S(rem_20_n3), .Z(
        rem_20_n194) );
  INV_X1 rem_20_U263 ( .A(rem_20_n194), .ZN(rem_20_u_div_PartRem_1__5_) );
  MUX2_X1 rem_20_U262 ( .A(rem_20_u_div_PartRem_1__5_), .B(
        rem_20_u_div_SumTmp_0__5_), .S(rem_20_n82), .Z(N5) );
  INV_X2 rem_20_U261 ( .A(b[2]), .ZN(rem_20_u_div_BInv[2]) );
  MUX2_X1 rem_20_U260 ( .A(rem_20_n164), .B(rem_20_n193), .S(rem_20_n145), .Z(
        rem_20_n166) );
  MUX2_X1 rem_20_U259 ( .A(rem_20_n166), .B(rem_20_n6), .S(rem_20_n144), .Z(
        rem_20_n169) );
  MUX2_X1 rem_20_U258 ( .A(rem_20_n169), .B(rem_20_n192), .S(rem_20_n143), .Z(
        rem_20_n173) );
  MUX2_X1 rem_20_U257 ( .A(rem_20_n173), .B(rem_20_n12), .S(rem_20_n146), .Z(
        rem_20_n178) );
  MUX2_X1 rem_20_U256 ( .A(rem_20_n178), .B(rem_20_n17), .S(rem_20_n3), .Z(
        rem_20_n191) );
  INV_X1 rem_20_U255 ( .A(rem_20_n191), .ZN(rem_20_u_div_PartRem_1__6_) );
  MUX2_X1 rem_20_U254 ( .A(rem_20_u_div_PartRem_1__6_), .B(
        rem_20_u_div_SumTmp_0__6_), .S(rem_20_u_div_CryTmp_0__8_), .Z(N6) );
  MUX2_X1 rem_20_U253 ( .A(rem_20_n162), .B(rem_20_n186), .S(rem_20_n187), .Z(
        rem_20_n163) );
  MUX2_X1 rem_20_U252 ( .A(rem_20_n163), .B(rem_20_n185), .S(rem_20_n145), .Z(
        rem_20_n165) );
  MUX2_X1 rem_20_U251 ( .A(rem_20_n165), .B(rem_20_n7), .S(rem_20_n144), .Z(
        rem_20_n168) );
  MUX2_X1 rem_20_U250 ( .A(rem_20_n168), .B(rem_20_n184), .S(rem_20_n37), .Z(
        rem_20_n172) );
  MUX2_X1 rem_20_U249 ( .A(rem_20_n172), .B(rem_20_n10), .S(rem_20_n146), .Z(
        rem_20_n177) );
  MUX2_X1 rem_20_U248 ( .A(rem_20_n177), .B(rem_20_n13), .S(rem_20_n3), .Z(
        rem_20_n183) );
  INV_X1 rem_20_U247 ( .A(rem_20_n183), .ZN(rem_20_u_div_PartRem_1__7_) );
  MUX2_X1 rem_20_U246 ( .A(rem_20_u_div_PartRem_1__7_), .B(
        rem_20_u_div_SumTmp_0__7_), .S(rem_20_n159), .Z(N7) );
  INV_X2 rem_20_U245 ( .A(b[1]), .ZN(rem_20_u_div_BInv[1]) );
  INV_X1 rem_20_U244 ( .A(rem_20_n181), .ZN(rem_20_u_div_PartRem_2__2_) );
  INV_X1 rem_20_U243 ( .A(rem_20_n180), .ZN(rem_20_u_div_PartRem_2__3_) );
  INV_X1 rem_20_U242 ( .A(rem_20_n179), .ZN(rem_20_u_div_PartRem_2__4_) );
  INV_X1 rem_20_U241 ( .A(rem_20_n178), .ZN(rem_20_u_div_PartRem_2__5_) );
  INV_X1 rem_20_U240 ( .A(rem_20_n177), .ZN(rem_20_u_div_PartRem_2__6_) );
  INV_X1 rem_20_U239 ( .A(rem_20_n175), .ZN(rem_20_u_div_PartRem_3__2_) );
  INV_X1 rem_20_U238 ( .A(rem_20_n174), .ZN(rem_20_u_div_PartRem_3__3_) );
  INV_X1 rem_20_U237 ( .A(rem_20_n173), .ZN(rem_20_u_div_PartRem_3__4_) );
  INV_X1 rem_20_U236 ( .A(rem_20_n172), .ZN(rem_20_u_div_PartRem_3__5_) );
  INV_X1 rem_20_U235 ( .A(rem_20_n171), .ZN(rem_20_u_div_PartRem_4__1_) );
  INV_X1 rem_20_U234 ( .A(rem_20_n170), .ZN(rem_20_u_div_PartRem_4__2_) );
  INV_X1 rem_20_U233 ( .A(rem_20_n169), .ZN(rem_20_u_div_PartRem_4__3_) );
  INV_X1 rem_20_U232 ( .A(rem_20_n168), .ZN(rem_20_u_div_PartRem_4__4_) );
  INV_X1 rem_20_U231 ( .A(rem_20_n166), .ZN(rem_20_u_div_PartRem_5__2_) );
  INV_X1 rem_20_U230 ( .A(rem_20_n165), .ZN(rem_20_u_div_PartRem_5__3_) );
  INV_X1 rem_20_U229 ( .A(rem_20_n163), .ZN(rem_20_u_div_PartRem_6__2_) );
  INV_X1 rem_20_U228 ( .A(rem_20_n2), .ZN(rem_20_n189) );
  NOR2_X1 rem_20_U227 ( .A1(rem_20_n189), .A2(rem_20_n188), .ZN(rem_20_n187)
         );
  NOR2_X1 rem_20_U226 ( .A1(b[6]), .A2(b[7]), .ZN(rem_20_n161) );
  NOR2_X1 rem_20_U225 ( .A1(b[6]), .A2(rem_20_n117), .ZN(rem_20_n160) );
  CLKBUF_X1 rem_20_U224 ( .A(rem_20_n82), .Z(rem_20_n159) );
  INV_X1 rem_20_U223 ( .A(b[0]), .ZN(rem_20_u_div_BInv[0]) );
  CLKBUF_X1 rem_20_U222 ( .A(rem_20_u_div_BInv[0]), .Z(rem_20_n158) );
  NOR2_X1 rem_20_U221 ( .A1(b[5]), .A2(b[4]), .ZN(rem_20_n201) );
  XNOR2_X1 rem_20_U220 ( .A(rem_20_n157), .B(a[2]), .ZN(
        rem_20_u_div_SumTmp_2__0_) );
  XNOR2_X1 rem_20_U219 ( .A(rem_20_n158), .B(a[3]), .ZN(
        rem_20_u_div_SumTmp_3__0_) );
  XNOR2_X1 rem_20_U218 ( .A(rem_20_n158), .B(a[5]), .ZN(
        rem_20_u_div_SumTmp_5__0_) );
  XNOR2_X1 rem_20_U217 ( .A(rem_20_n157), .B(a[6]), .ZN(
        rem_20_u_div_SumTmp_6__0_) );
  XNOR2_X1 rem_20_U216 ( .A(rem_20_u_div_BInv[0]), .B(a[7]), .ZN(
        rem_20_u_div_SumTmp_7__0_) );
  INV_X1 rem_20_U215 ( .A(a[7]), .ZN(rem_20_n148) );
  NAND2_X1 rem_20_U214 ( .A1(b[0]), .A2(rem_20_n148), .ZN(
        rem_20_u_div_CryTmp_7__1_) );
  NOR2_X1 rem_20_U213 ( .A1(b[2]), .A2(b[1]), .ZN(rem_20_n190) );
  XNOR2_X1 rem_20_U212 ( .A(rem_20_n158), .B(a[1]), .ZN(
        rem_20_u_div_SumTmp_1__0_) );
  INV_X1 rem_20_U211 ( .A(a[4]), .ZN(rem_20_n152) );
  NAND2_X1 rem_20_U210 ( .A1(rem_20_n151), .A2(rem_20_n152), .ZN(
        rem_20_u_div_CryTmp_4__1_) );
  MUX2_X1 rem_20_U209 ( .A(rem_20_n4), .B(rem_20_n152), .S(rem_20_n147), .Z(
        rem_20_n171) );
  INV_X1 rem_20_U208 ( .A(a[6]), .ZN(rem_20_n149) );
  NAND2_X1 rem_20_U207 ( .A1(rem_20_n151), .A2(rem_20_n149), .ZN(
        rem_20_u_div_CryTmp_6__1_) );
  XNOR2_X1 rem_20_U206 ( .A(rem_20_n157), .B(a[0]), .ZN(
        rem_20_u_div_SumTmp_0__0_) );
  OR2_X1 rem_20_U205 ( .A1(rem_20_n157), .A2(a[0]), .ZN(
        rem_20_u_div_CryTmp_0__1_) );
  INV_X1 rem_20_U204 ( .A(a[1]), .ZN(rem_20_n156) );
  NAND2_X1 rem_20_U203 ( .A1(rem_20_n155), .A2(rem_20_n156), .ZN(
        rem_20_u_div_CryTmp_1__1_) );
  INV_X1 rem_20_U202 ( .A(a[2]), .ZN(rem_20_n154) );
  NAND2_X1 rem_20_U201 ( .A1(rem_20_n155), .A2(rem_20_n154), .ZN(
        rem_20_u_div_CryTmp_2__1_) );
  INV_X1 rem_20_U200 ( .A(a[3]), .ZN(rem_20_n153) );
  NAND2_X1 rem_20_U199 ( .A1(rem_20_n155), .A2(rem_20_n153), .ZN(
        rem_20_u_div_CryTmp_3__1_) );
  INV_X1 rem_20_U198 ( .A(a[5]), .ZN(rem_20_n150) );
  NAND2_X1 rem_20_U197 ( .A1(rem_20_n151), .A2(rem_20_n150), .ZN(
        rem_20_u_div_CryTmp_5__1_) );
  NAND2_X1 rem_20_U196 ( .A1(rem_20_n32), .A2(rem_20_u_div_BInv[2]), .ZN(
        rem_20_n188) );
  INV_X1 rem_20_U195 ( .A(rem_20_u_div_SumTmp_5__1_), .ZN(rem_20_n193) );
  INV_X1 rem_20_U194 ( .A(rem_20_u_div_SumTmp_6__1_), .ZN(rem_20_n186) );
  INV_X1 rem_20_U193 ( .A(rem_20_u_div_SumTmp_3__1_), .ZN(rem_20_n200) );
  INV_X1 rem_20_U192 ( .A(rem_20_n158), .ZN(rem_20_n155) );
  INV_X1 rem_20_U191 ( .A(rem_20_n157), .ZN(rem_20_n151) );
  INV_X1 rem_20_U190 ( .A(rem_20_u_div_SumTmp_3__4_), .ZN(rem_20_n184) );
  INV_X1 rem_20_U189 ( .A(rem_20_u_div_SumTmp_3__3_), .ZN(rem_20_n192) );
  INV_X1 rem_20_U188 ( .A(rem_20_u_div_SumTmp_2__3_), .ZN(rem_20_n195) );
  INV_X1 rem_20_U187 ( .A(rem_20_u_div_SumTmp_5__2_), .ZN(rem_20_n185) );
  INV_X1 rem_20_U186 ( .A(rem_20_u_div_SumTmp_2__2_), .ZN(rem_20_n199) );
  AND2_X1 rem_20_U185 ( .A1(rem_20_u_div_CryTmp_5__3_), .A2(rem_20_n32), .ZN(
        rem_20_n145) );
  AND2_X1 rem_20_U184 ( .A1(rem_20_n34), .A2(rem_20_n118), .ZN(rem_20_n144) );
  AND2_X1 rem_20_U183 ( .A1(rem_20_u_div_CryTmp_3__5_), .A2(rem_20_n5), .ZN(
        rem_20_n143) );
  AND2_X1 rem_20_U182 ( .A1(rem_20_n116), .A2(rem_20_u_div_BInv[7]), .ZN(
        rem_20_n205) );
  AND2_X1 rem_20_U181 ( .A1(rem_20_u_div_CryTmp_2__6_), .A2(rem_20_n160), .ZN(
        rem_20_n204) );
  AND2_X1 rem_20_U180 ( .A1(rem_20_u_div_CryTmp_5__3_), .A2(rem_20_n32), .ZN(
        rem_20_n196) );
  MUX2_X2 rem_20_U179 ( .A(a[3]), .B(rem_20_u_div_SumTmp_3__0_), .S(
        rem_20_n142), .Z(rem_20_n141) );
  INV_X2 rem_20_U178 ( .A(b[5]), .ZN(rem_20_u_div_BInv[5]) );
  NAND3_X1 rem_20_U177 ( .A1(rem_20_n139), .A2(rem_20_n138), .A3(rem_20_n140), 
        .ZN(rem_20_u_div_CryTmp_2__2_) );
  NAND2_X1 rem_20_U176 ( .A1(rem_20_u_div_CryTmp_2__1_), .A2(
        rem_20_u_div_BInv[1]), .ZN(rem_20_n140) );
  NAND2_X1 rem_20_U175 ( .A1(rem_20_n141), .A2(rem_20_u_div_BInv[1]), .ZN(
        rem_20_n139) );
  NAND2_X1 rem_20_U174 ( .A1(rem_20_n141), .A2(rem_20_u_div_CryTmp_2__1_), 
        .ZN(rem_20_n138) );
  XOR2_X1 rem_20_U173 ( .A(rem_20_u_div_CryTmp_2__1_), .B(rem_20_u_div_BInv[1]), .Z(rem_20_n137) );
  NAND3_X1 rem_20_U172 ( .A1(rem_20_n135), .A2(rem_20_n134), .A3(rem_20_n136), 
        .ZN(rem_20_u_div_CryTmp_3__3_) );
  NAND2_X1 rem_20_U171 ( .A1(rem_20_u_div_PartRem_4__2_), .A2(
        rem_20_u_div_BInv[2]), .ZN(rem_20_n136) );
  NAND2_X1 rem_20_U170 ( .A1(rem_20_u_div_CryTmp_3__2_), .A2(
        rem_20_u_div_BInv[2]), .ZN(rem_20_n135) );
  NAND2_X1 rem_20_U169 ( .A1(rem_20_u_div_CryTmp_3__2_), .A2(
        rem_20_u_div_PartRem_4__2_), .ZN(rem_20_n134) );
  XOR2_X1 rem_20_U168 ( .A(rem_20_u_div_PartRem_4__2_), .B(
        rem_20_u_div_BInv[2]), .Z(rem_20_n133) );
  NAND2_X1 rem_20_U167 ( .A1(rem_20_n81), .A2(rem_20_u_div_BInv[6]), .ZN(
        rem_20_n132) );
  NAND2_X1 rem_20_U166 ( .A1(rem_20_u_div_CryTmp_1__6_), .A2(
        rem_20_u_div_PartRem_2__6_), .ZN(rem_20_n131) );
  NAND2_X1 rem_20_U165 ( .A1(rem_20_u_div_PartRem_2__6_), .A2(
        rem_20_u_div_BInv[6]), .ZN(rem_20_n130) );
  XOR2_X1 rem_20_U164 ( .A(rem_20_u_div_PartRem_2__6_), .B(
        rem_20_u_div_BInv[6]), .Z(rem_20_n129) );
  NAND3_X1 rem_20_U163 ( .A1(rem_20_n127), .A2(rem_20_n128), .A3(rem_20_n126), 
        .ZN(rem_20_u_div_CryTmp_1__6_) );
  NAND2_X1 rem_20_U162 ( .A1(rem_20_u_div_BInv[5]), .A2(rem_20_n57), .ZN(
        rem_20_n128) );
  NAND2_X1 rem_20_U161 ( .A1(rem_20_u_div_CryTmp_1__5_), .A2(
        rem_20_u_div_PartRem_2__5_), .ZN(rem_20_n127) );
  NAND2_X1 rem_20_U160 ( .A1(rem_20_u_div_PartRem_2__5_), .A2(
        rem_20_u_div_BInv[5]), .ZN(rem_20_n126) );
  XOR2_X1 rem_20_U159 ( .A(rem_20_u_div_PartRem_2__5_), .B(
        rem_20_u_div_BInv[5]), .Z(rem_20_n125) );
  NAND3_X1 rem_20_U158 ( .A1(rem_20_n122), .A2(rem_20_n123), .A3(rem_20_n124), 
        .ZN(rem_20_u_div_CryTmp_0__6_) );
  NAND2_X1 rem_20_U157 ( .A1(rem_20_u_div_PartRem_1__5_), .A2(
        rem_20_u_div_BInv[5]), .ZN(rem_20_n124) );
  NAND2_X1 rem_20_U156 ( .A1(rem_20_u_div_CryTmp_0__5_), .A2(
        rem_20_u_div_BInv[5]), .ZN(rem_20_n123) );
  NAND2_X1 rem_20_U155 ( .A1(rem_20_n44), .A2(rem_20_u_div_PartRem_1__5_), 
        .ZN(rem_20_n122) );
  XOR2_X1 rem_20_U154 ( .A(rem_20_n51), .B(rem_20_n121), .Z(
        rem_20_u_div_SumTmp_0__5_) );
  XOR2_X1 rem_20_U153 ( .A(rem_20_u_div_PartRem_1__5_), .B(
        rem_20_u_div_BInv[5]), .Z(rem_20_n121) );
  INV_X1 rem_20_U152 ( .A(rem_20_n28), .ZN(rem_20_n197) );
  MUX2_X2 rem_20_U151 ( .A(a[2]), .B(rem_20_u_div_SumTmp_2__0_), .S(
        rem_20_n204), .Z(rem_20_n119) );
  NAND2_X1 rem_20_U150 ( .A1(rem_20_u_div_CryTmp_4__4_), .A2(rem_20_n118), 
        .ZN(rem_20_n147) );
  INV_X1 rem_20_U149 ( .A(rem_20_u_div_BInv[7]), .ZN(rem_20_n117) );
  INV_X1 rem_20_U148 ( .A(rem_20_n53), .ZN(rem_20_n176) );
  NAND3_X1 rem_20_U147 ( .A1(rem_20_n131), .A2(rem_20_n132), .A3(rem_20_n130), 
        .ZN(rem_20_n116) );
  NAND3_X1 rem_20_U146 ( .A1(rem_20_n114), .A2(rem_20_n115), .A3(rem_20_n113), 
        .ZN(rem_20_u_div_CryTmp_4__4_) );
  NAND2_X1 rem_20_U145 ( .A1(rem_20_n80), .A2(rem_20_u_div_BInv[3]), .ZN(
        rem_20_n115) );
  NAND2_X1 rem_20_U144 ( .A1(rem_20_u_div_CryTmp_4__3_), .A2(
        rem_20_u_div_PartRem_5__3_), .ZN(rem_20_n114) );
  NAND2_X1 rem_20_U143 ( .A1(rem_20_u_div_PartRem_5__3_), .A2(
        rem_20_u_div_BInv[3]), .ZN(rem_20_n113) );
  XOR2_X1 rem_20_U142 ( .A(rem_20_u_div_PartRem_5__3_), .B(rem_20_n31), .Z(
        rem_20_n112) );
  NAND3_X1 rem_20_U141 ( .A1(rem_20_n110), .A2(rem_20_n111), .A3(rem_20_n109), 
        .ZN(rem_20_u_div_CryTmp_4__3_) );
  NAND2_X1 rem_20_U140 ( .A1(rem_20_n58), .A2(rem_20_u_div_BInv[2]), .ZN(
        rem_20_n111) );
  NAND2_X1 rem_20_U139 ( .A1(rem_20_u_div_CryTmp_4__2_), .A2(
        rem_20_u_div_PartRem_5__2_), .ZN(rem_20_n110) );
  NAND2_X1 rem_20_U138 ( .A1(rem_20_u_div_PartRem_5__2_), .A2(
        rem_20_u_div_BInv[2]), .ZN(rem_20_n109) );
  XOR2_X1 rem_20_U137 ( .A(rem_20_u_div_PartRem_5__2_), .B(
        rem_20_u_div_BInv[2]), .Z(rem_20_n108) );
  NAND3_X1 rem_20_U136 ( .A1(rem_20_n106), .A2(rem_20_n105), .A3(rem_20_n107), 
        .ZN(rem_20_u_div_CryTmp_1__4_) );
  NAND2_X1 rem_20_U135 ( .A1(rem_20_u_div_PartRem_2__3_), .A2(rem_20_n31), 
        .ZN(rem_20_n107) );
  NAND2_X1 rem_20_U134 ( .A1(rem_20_u_div_CryTmp_1__3_), .A2(rem_20_n31), .ZN(
        rem_20_n106) );
  NAND2_X1 rem_20_U133 ( .A1(rem_20_n65), .A2(rem_20_u_div_PartRem_2__3_), 
        .ZN(rem_20_n105) );
  XOR2_X1 rem_20_U132 ( .A(rem_20_u_div_PartRem_2__3_), .B(rem_20_n31), .Z(
        rem_20_n104) );
  NAND3_X1 rem_20_U131 ( .A1(rem_20_n102), .A2(rem_20_n101), .A3(rem_20_n103), 
        .ZN(rem_20_u_div_CryTmp_0__4_) );
  NAND2_X1 rem_20_U130 ( .A1(rem_20_u_div_PartRem_1__3_), .A2(rem_20_n31), 
        .ZN(rem_20_n103) );
  NAND2_X1 rem_20_U129 ( .A1(rem_20_u_div_CryTmp_0__3_), .A2(rem_20_n31), .ZN(
        rem_20_n102) );
  NAND2_X1 rem_20_U128 ( .A1(rem_20_u_div_CryTmp_0__3_), .A2(
        rem_20_u_div_PartRem_1__3_), .ZN(rem_20_n101) );
  XOR2_X1 rem_20_U127 ( .A(rem_20_n52), .B(rem_20_n100), .Z(
        rem_20_u_div_SumTmp_0__3_) );
  XOR2_X1 rem_20_U126 ( .A(rem_20_u_div_PartRem_1__3_), .B(rem_20_n31), .Z(
        rem_20_n100) );
  INV_X2 rem_20_U125 ( .A(b[4]), .ZN(rem_20_u_div_BInv[4]) );
  INV_X2 rem_20_U124 ( .A(b[6]), .ZN(rem_20_u_div_BInv[6]) );
  NAND3_X1 rem_20_U123 ( .A1(rem_20_n97), .A2(rem_20_n98), .A3(rem_20_n99), 
        .ZN(rem_20_u_div_CryTmp_2__5_) );
  NAND2_X1 rem_20_U122 ( .A1(rem_20_u_div_PartRem_3__4_), .A2(
        rem_20_u_div_BInv[4]), .ZN(rem_20_n99) );
  NAND2_X1 rem_20_U121 ( .A1(rem_20_u_div_CryTmp_2__4_), .A2(
        rem_20_u_div_BInv[4]), .ZN(rem_20_n98) );
  NAND2_X1 rem_20_U120 ( .A1(rem_20_u_div_CryTmp_2__4_), .A2(
        rem_20_u_div_PartRem_3__4_), .ZN(rem_20_n97) );
  XOR2_X1 rem_20_U119 ( .A(rem_20_u_div_PartRem_3__4_), .B(
        rem_20_u_div_BInv[4]), .Z(rem_20_n96) );
  NAND3_X1 rem_20_U118 ( .A1(rem_20_n94), .A2(rem_20_n93), .A3(rem_20_n95), 
        .ZN(rem_20_u_div_CryTmp_1__2_) );
  NAND2_X1 rem_20_U117 ( .A1(rem_20_u_div_CryTmp_1__1_), .A2(
        rem_20_u_div_BInv[1]), .ZN(rem_20_n95) );
  NAND2_X1 rem_20_U116 ( .A1(rem_20_n119), .A2(rem_20_u_div_BInv[1]), .ZN(
        rem_20_n94) );
  NAND2_X1 rem_20_U115 ( .A1(rem_20_n119), .A2(rem_20_u_div_CryTmp_1__1_), 
        .ZN(rem_20_n93) );
  XOR2_X1 rem_20_U114 ( .A(rem_20_u_div_CryTmp_1__1_), .B(rem_20_u_div_BInv[1]), .Z(rem_20_n92) );
  NAND3_X1 rem_20_U113 ( .A1(rem_20_n89), .A2(rem_20_n90), .A3(rem_20_n91), 
        .ZN(rem_20_u_div_CryTmp_0__7_) );
  NAND2_X1 rem_20_U112 ( .A1(rem_20_u_div_PartRem_1__6_), .A2(
        rem_20_u_div_BInv[6]), .ZN(rem_20_n91) );
  NAND2_X1 rem_20_U111 ( .A1(rem_20_u_div_CryTmp_0__6_), .A2(
        rem_20_u_div_BInv[6]), .ZN(rem_20_n90) );
  NAND2_X1 rem_20_U110 ( .A1(rem_20_n45), .A2(rem_20_u_div_PartRem_1__6_), 
        .ZN(rem_20_n89) );
  XOR2_X1 rem_20_U109 ( .A(rem_20_n78), .B(rem_20_n88), .Z(
        rem_20_u_div_SumTmp_0__6_) );
  XOR2_X1 rem_20_U108 ( .A(rem_20_u_div_PartRem_1__6_), .B(
        rem_20_u_div_BInv[6]), .Z(rem_20_n88) );
  NAND3_X1 rem_20_U107 ( .A1(rem_20_n86), .A2(rem_20_n85), .A3(rem_20_n87), 
        .ZN(rem_20_u_div_CryTmp_2__6_) );
  NAND2_X1 rem_20_U106 ( .A1(rem_20_u_div_PartRem_3__5_), .A2(
        rem_20_u_div_BInv[5]), .ZN(rem_20_n87) );
  NAND2_X1 rem_20_U105 ( .A1(rem_20_u_div_CryTmp_2__5_), .A2(
        rem_20_u_div_BInv[5]), .ZN(rem_20_n86) );
  NAND2_X1 rem_20_U104 ( .A1(rem_20_n79), .A2(rem_20_u_div_PartRem_3__5_), 
        .ZN(rem_20_n85) );
  XOR2_X1 rem_20_U103 ( .A(rem_20_u_div_PartRem_3__5_), .B(
        rem_20_u_div_BInv[5]), .Z(rem_20_n84) );
  INV_X1 rem_20_U102 ( .A(rem_20_n33), .ZN(rem_20_n182) );
  MUX2_X1 rem_20_U101 ( .A(a[5]), .B(rem_20_u_div_SumTmp_5__0_), .S(
        rem_20_n196), .Z(rem_20_n83) );
  INV_X1 rem_20_U100 ( .A(rem_20_n59), .ZN(rem_20_n167) );
  INV_X1 rem_20_U99 ( .A(rem_20_n197), .ZN(rem_20_n118) );
  FA_X1 rem_20_U98 ( .A(rem_20_u_div_PartRem_1__7_), .B(rem_20_u_div_BInv[7]), 
        .CI(rem_20_n47), .CO(rem_20_n82) );
  NAND3_X1 rem_20_U97 ( .A1(rem_20_n128), .A2(rem_20_n127), .A3(rem_20_n126), 
        .ZN(rem_20_n81) );
  NAND3_X1 rem_20_U96 ( .A1(rem_20_n110), .A2(rem_20_n109), .A3(rem_20_n111), 
        .ZN(rem_20_n80) );
  NAND3_X1 rem_20_U95 ( .A1(rem_20_n98), .A2(rem_20_n97), .A3(rem_20_n99), 
        .ZN(rem_20_n79) );
  CLKBUF_X1 rem_20_U94 ( .A(rem_20_n45), .Z(rem_20_n78) );
  NAND3_X1 rem_20_U93 ( .A1(rem_20_n76), .A2(rem_20_n75), .A3(rem_20_n77), 
        .ZN(rem_20_u_div_CryTmp_4__2_) );
  NAND2_X1 rem_20_U92 ( .A1(rem_20_u_div_CryTmp_4__1_), .A2(
        rem_20_u_div_BInv[1]), .ZN(rem_20_n77) );
  NAND2_X1 rem_20_U91 ( .A1(rem_20_n29), .A2(rem_20_u_div_BInv[1]), .ZN(
        rem_20_n76) );
  NAND2_X1 rem_20_U90 ( .A1(rem_20_n83), .A2(rem_20_u_div_CryTmp_4__1_), .ZN(
        rem_20_n75) );
  XOR2_X1 rem_20_U89 ( .A(rem_20_u_div_CryTmp_4__1_), .B(rem_20_u_div_BInv[1]), 
        .Z(rem_20_n74) );
  NAND3_X1 rem_20_U88 ( .A1(rem_20_n72), .A2(rem_20_n71), .A3(rem_20_n73), 
        .ZN(rem_20_u_div_CryTmp_1__5_) );
  NAND2_X1 rem_20_U87 ( .A1(rem_20_u_div_PartRem_2__4_), .A2(
        rem_20_u_div_BInv[4]), .ZN(rem_20_n73) );
  NAND2_X1 rem_20_U86 ( .A1(rem_20_u_div_CryTmp_1__4_), .A2(
        rem_20_u_div_BInv[4]), .ZN(rem_20_n72) );
  NAND2_X1 rem_20_U85 ( .A1(rem_20_n60), .A2(rem_20_u_div_PartRem_2__4_), .ZN(
        rem_20_n71) );
  XOR2_X1 rem_20_U84 ( .A(rem_20_u_div_PartRem_2__4_), .B(rem_20_u_div_BInv[4]), .Z(rem_20_n70) );
  NAND3_X1 rem_20_U83 ( .A1(rem_20_n67), .A2(rem_20_n68), .A3(rem_20_n69), 
        .ZN(rem_20_u_div_CryTmp_1__3_) );
  NAND2_X1 rem_20_U82 ( .A1(rem_20_u_div_PartRem_2__2_), .A2(
        rem_20_u_div_BInv[2]), .ZN(rem_20_n69) );
  NAND2_X1 rem_20_U81 ( .A1(rem_20_u_div_CryTmp_1__2_), .A2(
        rem_20_u_div_BInv[2]), .ZN(rem_20_n68) );
  NAND2_X1 rem_20_U80 ( .A1(rem_20_n55), .A2(rem_20_u_div_PartRem_2__2_), .ZN(
        rem_20_n67) );
  XOR2_X1 rem_20_U79 ( .A(rem_20_u_div_PartRem_2__2_), .B(rem_20_u_div_BInv[2]), .Z(rem_20_n66) );
  AND2_X1 rem_20_U78 ( .A1(rem_20_u_div_CryTmp_2__6_), .A2(rem_20_n160), .ZN(
        rem_20_n146) );
  NAND3_X1 rem_20_U77 ( .A1(rem_20_n67), .A2(rem_20_n68), .A3(rem_20_n69), 
        .ZN(rem_20_n65) );
  NAND3_X1 rem_20_U76 ( .A1(rem_20_n62), .A2(rem_20_n63), .A3(rem_20_n64), 
        .ZN(rem_20_u_div_CryTmp_0__5_) );
  NAND2_X1 rem_20_U75 ( .A1(rem_20_u_div_PartRem_1__4_), .A2(
        rem_20_u_div_BInv[4]), .ZN(rem_20_n64) );
  NAND2_X1 rem_20_U74 ( .A1(rem_20_u_div_CryTmp_0__4_), .A2(
        rem_20_u_div_BInv[4]), .ZN(rem_20_n63) );
  NAND2_X1 rem_20_U73 ( .A1(rem_20_n50), .A2(rem_20_u_div_PartRem_1__4_), .ZN(
        rem_20_n62) );
  XOR2_X1 rem_20_U72 ( .A(rem_20_n40), .B(rem_20_n61), .Z(
        rem_20_u_div_SumTmp_0__4_) );
  XOR2_X1 rem_20_U71 ( .A(rem_20_u_div_PartRem_1__4_), .B(rem_20_u_div_BInv[4]), .Z(rem_20_n61) );
  MUX2_X1 rem_20_U70 ( .A(a[1]), .B(rem_20_u_div_SumTmp_1__0_), .S(rem_20_n205), .Z(rem_20_u_div_PartRem_1__1_) );
  NAND3_X1 rem_20_U69 ( .A1(rem_20_n105), .A2(rem_20_n106), .A3(rem_20_n107), 
        .ZN(rem_20_n60) );
  MUX2_X2 rem_20_U68 ( .A(rem_20_u_div_PartRem_1__2_), .B(
        rem_20_u_div_SumTmp_0__2_), .S(rem_20_u_div_CryTmp_0__8_), .Z(N2) );
  MUX2_X2 rem_20_U67 ( .A(rem_20_u_div_PartRem_1__3_), .B(
        rem_20_u_div_SumTmp_0__3_), .S(rem_20_u_div_CryTmp_0__8_), .Z(N3) );
  AND2_X1 rem_20_U66 ( .A1(rem_20_n161), .A2(rem_20_n201), .ZN(rem_20_n120) );
  MUX2_X1 rem_20_U65 ( .A(a[5]), .B(rem_20_u_div_SumTmp_5__0_), .S(rem_20_n145), .Z(rem_20_n59) );
  NAND3_X1 rem_20_U64 ( .A1(rem_20_n76), .A2(rem_20_n75), .A3(rem_20_n77), 
        .ZN(rem_20_n58) );
  NAND3_X1 rem_20_U63 ( .A1(rem_20_n1), .A2(rem_20_n71), .A3(rem_20_n73), .ZN(
        rem_20_n57) );
  NAND3_X1 rem_20_U62 ( .A1(rem_20_n94), .A2(rem_20_n93), .A3(rem_20_n95), 
        .ZN(rem_20_n55) );
  CLKBUF_X1 rem_20_U61 ( .A(rem_20_u_div_CryTmp_1__4_), .Z(rem_20_n54) );
  MUX2_X1 rem_20_U60 ( .A(a[3]), .B(rem_20_u_div_SumTmp_3__0_), .S(rem_20_n37), 
        .Z(rem_20_n53) );
  CLKBUF_X1 rem_20_U59 ( .A(rem_20_n44), .Z(rem_20_n51) );
  NAND3_X1 rem_20_U58 ( .A1(rem_20_n102), .A2(rem_20_n101), .A3(rem_20_n103), 
        .ZN(rem_20_n50) );
  CLKBUF_X1 rem_20_U57 ( .A(rem_20_u_div_CryTmp_1__6_), .Z(rem_20_n49) );
  CLKBUF_X1 rem_20_U56 ( .A(rem_20_u_div_CryTmp_4__3_), .Z(rem_20_n48) );
  NAND3_X1 rem_20_U55 ( .A1(rem_20_n89), .A2(rem_20_n90), .A3(rem_20_n91), 
        .ZN(rem_20_n47) );
  NAND3_X1 rem_20_U54 ( .A1(rem_20_n122), .A2(rem_20_n123), .A3(rem_20_n124), 
        .ZN(rem_20_n45) );
  NAND3_X1 rem_20_U53 ( .A1(rem_20_n62), .A2(rem_20_n63), .A3(rem_20_n64), 
        .ZN(rem_20_n44) );
  CLKBUF_X1 rem_20_U52 ( .A(rem_20_u_div_CryTmp_1__5_), .Z(rem_20_n43) );
  CLKBUF_X1 rem_20_U51 ( .A(rem_20_u_div_CryTmp_4__2_), .Z(rem_20_n42) );
  CLKBUF_X1 rem_20_U50 ( .A(rem_20_u_div_CryTmp_3__2_), .Z(rem_20_n56) );
  CLKBUF_X1 rem_20_U49 ( .A(rem_20_u_div_CryTmp_0__3_), .Z(rem_20_n52) );
  CLKBUF_X1 rem_20_U48 ( .A(rem_20_u_div_CryTmp_2__4_), .Z(rem_20_n46) );
  CLKBUF_X1 rem_20_U47 ( .A(rem_20_u_div_CryTmp_2__5_), .Z(rem_20_n41) );
  CLKBUF_X1 rem_20_U46 ( .A(rem_20_n50), .Z(rem_20_n40) );
  NAND3_X1 rem_20_U45 ( .A1(rem_20_n67), .A2(rem_20_n38), .A3(rem_20_n69), 
        .ZN(rem_20_n39) );
  CLKBUF_X1 rem_20_U44 ( .A(rem_20_n143), .Z(rem_20_n37) );
  NAND3_X1 rem_20_U43 ( .A1(rem_20_n94), .A2(rem_20_n35), .A3(rem_20_n95), 
        .ZN(rem_20_n36) );
  BUF_X1 rem_20_U42 ( .A(rem_20_n93), .Z(rem_20_n35) );
  CLKBUF_X1 rem_20_U41 ( .A(rem_20_u_div_CryTmp_4__4_), .Z(rem_20_n34) );
  CLKBUF_X1 rem_20_U40 ( .A(rem_20_n119), .Z(rem_20_n33) );
  AND2_X1 rem_20_U39 ( .A1(rem_20_n28), .A2(rem_20_u_div_BInv[3]), .ZN(
        rem_20_n32) );
  INV_X1 rem_20_U38 ( .A(b[3]), .ZN(rem_20_u_div_BInv[3]) );
  CLKBUF_X1 rem_20_U37 ( .A(rem_20_u_div_BInv[3]), .Z(rem_20_n31) );
  CLKBUF_X1 rem_20_U36 ( .A(rem_20_u_div_PartRem_1__1_), .Z(rem_20_n30) );
  MUX2_X1 rem_20_U35 ( .A(a[5]), .B(rem_20_u_div_SumTmp_5__0_), .S(rem_20_n196), .Z(rem_20_n29) );
  CLKBUF_X1 rem_20_U34 ( .A(rem_20_n120), .Z(rem_20_n28) );
  INV_X1 rem_20_U33 ( .A(rem_20_n26), .ZN(rem_20_n27) );
  CLKBUF_X1 rem_20_U32 ( .A(rem_20_u_div_PartRem_4__1_), .Z(rem_20_n26) );
  INV_X2 rem_20_U31 ( .A(b[7]), .ZN(rem_20_u_div_BInv[7]) );
  INV_X1 rem_20_U30 ( .A(rem_20_n188), .ZN(rem_20_n25) );
  AND2_X1 rem_20_U29 ( .A1(rem_20_u_div_CryTmp_3__5_), .A2(rem_20_n5), .ZN(
        rem_20_n142) );
  CLKBUF_X1 rem_20_U28 ( .A(rem_20_n68), .Z(rem_20_n38) );
  NAND4_X1 rem_20_U27 ( .A1(rem_20_n120), .A2(rem_20_u_div_CryTmp_7__1_), .A3(
        rem_20_n190), .A4(rem_20_u_div_BInv[3]), .ZN(rem_20_n23) );
  MUX2_X1 rem_20_U26 ( .A(rem_20_u_div_SumTmp_7__0_), .B(a[7]), .S(rem_20_n23), 
        .Z(rem_20_n22) );
  INV_X1 rem_20_U25 ( .A(rem_20_n20), .ZN(rem_20_n164) );
  INV_X1 rem_20_U24 ( .A(rem_20_n19), .ZN(rem_20_n162) );
  AND2_X1 rem_20_U23 ( .A1(rem_20_u_div_CryTmp_6__2_), .A2(rem_20_n25), .ZN(
        rem_20_n21) );
  MUX2_X1 rem_20_U22 ( .A(a[6]), .B(rem_20_u_div_SumTmp_6__0_), .S(rem_20_n21), 
        .Z(rem_20_n24) );
  CLKBUF_X1 rem_20_U21 ( .A(rem_20_n24), .Z(rem_20_n20) );
  CLKBUF_X1 rem_20_U20 ( .A(rem_20_n22), .Z(rem_20_n19) );
  BUF_X1 rem_20_U19 ( .A(rem_20_u_div_BInv[0]), .Z(rem_20_n157) );
  XNOR2_X1 rem_20_U18 ( .A(rem_20_n39), .B(rem_20_n104), .ZN(rem_20_n18) );
  XNOR2_X1 rem_20_U17 ( .A(rem_20_n125), .B(rem_20_n43), .ZN(rem_20_n17) );
  XNOR2_X1 rem_20_U16 ( .A(rem_20_n54), .B(rem_20_n70), .ZN(rem_20_n16) );
  XNOR2_X1 rem_20_U15 ( .A(rem_20_n36), .B(rem_20_n66), .ZN(rem_20_n15) );
  XNOR2_X1 rem_20_U14 ( .A(rem_20_n33), .B(rem_20_n92), .ZN(rem_20_n14) );
  XNOR2_X1 rem_20_U13 ( .A(rem_20_n129), .B(rem_20_n49), .ZN(rem_20_n13) );
  XNOR2_X1 rem_20_U12 ( .A(rem_20_n46), .B(rem_20_n96), .ZN(rem_20_n12) );
  XNOR2_X1 rem_20_U11 ( .A(rem_20_n53), .B(rem_20_n137), .ZN(rem_20_n11) );
  XNOR2_X1 rem_20_U10 ( .A(rem_20_n41), .B(rem_20_n84), .ZN(rem_20_n10) );
  XNOR2_X1 rem_20_U9 ( .A(rem_20_n56), .B(rem_20_n133), .ZN(rem_20_n9) );
  XNOR2_X1 rem_20_U8 ( .A(rem_20_n59), .B(rem_20_n74), .ZN(rem_20_n8) );
  XNOR2_X1 rem_20_U7 ( .A(rem_20_n112), .B(rem_20_n48), .ZN(rem_20_n7) );
  XNOR2_X1 rem_20_U6 ( .A(rem_20_n108), .B(rem_20_n42), .ZN(rem_20_n6) );
  AND2_X1 rem_20_U5 ( .A1(rem_20_n160), .A2(rem_20_u_div_BInv[5]), .ZN(
        rem_20_n5) );
  XOR2_X1 rem_20_U4 ( .A(rem_20_n157), .B(a[4]), .Z(rem_20_n4) );
  AND2_X1 rem_20_U3 ( .A1(rem_20_n116), .A2(rem_20_u_div_BInv[7]), .ZN(
        rem_20_n3) );
  CLKBUF_X1 rem_20_U2 ( .A(rem_20_u_div_CryTmp_6__2_), .Z(rem_20_n2) );
  NAND2_X1 rem_20_U1 ( .A1(rem_20_u_div_CryTmp_1__4_), .A2(
        rem_20_u_div_BInv[4]), .ZN(rem_20_n1) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_0_1 ( .A(rem_20_u_div_CryTmp_0__1_), .B(
        rem_20_u_div_BInv[1]), .CI(rem_20_u_div_PartRem_1__1_), .CO(
        rem_20_u_div_CryTmp_0__2_), .S(rem_20_u_div_SumTmp_0__1_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_0_2 ( .A(rem_20_u_div_PartRem_1__2_), .B(
        rem_20_u_div_BInv[2]), .CI(rem_20_u_div_CryTmp_0__2_), .CO(
        rem_20_u_div_CryTmp_0__3_), .S(rem_20_u_div_SumTmp_0__2_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_0_7 ( .A(rem_20_u_div_PartRem_1__7_), .B(
        rem_20_u_div_BInv[7]), .CI(rem_20_u_div_CryTmp_0__7_), .CO(
        rem_20_u_div_CryTmp_0__8_), .S(rem_20_u_div_SumTmp_0__7_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_2_2 ( .A(rem_20_u_div_PartRem_3__2_), .B(
        rem_20_u_div_BInv[2]), .CI(rem_20_u_div_CryTmp_2__2_), .CO(
        rem_20_u_div_CryTmp_2__3_), .S(rem_20_u_div_SumTmp_2__2_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_2_3 ( .A(rem_20_u_div_PartRem_3__3_), .B(
        rem_20_n31), .CI(rem_20_u_div_CryTmp_2__3_), .CO(
        rem_20_u_div_CryTmp_2__4_), .S(rem_20_u_div_SumTmp_2__3_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_3_1 ( .A(rem_20_u_div_CryTmp_3__1_), .B(
        rem_20_u_div_BInv[1]), .CI(rem_20_u_div_PartRem_4__1_), .CO(
        rem_20_u_div_CryTmp_3__2_), .S(rem_20_u_div_SumTmp_3__1_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_3_3 ( .A(rem_20_u_div_PartRem_4__3_), .B(
        rem_20_n31), .CI(rem_20_u_div_CryTmp_3__3_), .CO(
        rem_20_u_div_CryTmp_3__4_), .S(rem_20_u_div_SumTmp_3__3_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_3_4 ( .A(rem_20_u_div_PartRem_4__4_), .B(
        rem_20_u_div_BInv[4]), .CI(rem_20_u_div_CryTmp_3__4_), .CO(
        rem_20_u_div_CryTmp_3__5_), .S(rem_20_u_div_SumTmp_3__4_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_5_1 ( .A(rem_20_u_div_CryTmp_5__1_), .B(
        rem_20_u_div_BInv[1]), .CI(rem_20_n24), .CO(rem_20_u_div_CryTmp_5__2_), 
        .S(rem_20_u_div_SumTmp_5__1_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_5_2 ( .A(rem_20_u_div_PartRem_6__2_), .B(
        rem_20_u_div_BInv[2]), .CI(rem_20_u_div_CryTmp_5__2_), .CO(
        rem_20_u_div_CryTmp_5__3_), .S(rem_20_u_div_SumTmp_5__2_) );
  FA_X1 rem_20_u_div_u_fa_PartRem_0_6_1 ( .A(rem_20_u_div_CryTmp_6__1_), .B(
        rem_20_u_div_BInv[1]), .CI(rem_20_n22), .CO(rem_20_u_div_CryTmp_6__2_), 
        .S(rem_20_u_div_SumTmp_6__1_) );
endmodule

