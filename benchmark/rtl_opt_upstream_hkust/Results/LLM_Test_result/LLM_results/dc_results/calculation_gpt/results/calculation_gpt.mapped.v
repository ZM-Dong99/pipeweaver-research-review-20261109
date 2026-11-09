/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:28:42 2025
/////////////////////////////////////////////////////////////


module calculation_gpt ( a, b, c, d, s1, s2, s3, s4, s5, s6 );
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
  wire   N7, N6, N5, N4, N3, N2, N1, N0, N9, N8, N39, N38, N37, N36, N35, N34,
         N33, N32, N31, N30, N29, N28, N27, N26, N25, N23, N22, N21, N20, N19,
         N18, N17, N16, N15, N14, N13, N12, N11, N10, sum_cd_7_, sum_cd_6_,
         sum_cd_5_, sum_cd_4_, sum_cd_3_, sum_cd_2_, sum_cd_1_, sum_cd_0_, n7,
         n8, n9, n10, sub_24_n9, sub_24_n8, sub_24_n7, sub_24_n6, sub_24_n5,
         sub_24_n4, sub_24_n3, sub_24_n2, sub_24_n1, add_17_n1,
         sub_1_root_sub_0_root_add_25_4_n7, sub_1_root_sub_0_root_add_25_4_n6,
         sub_1_root_sub_0_root_add_25_4_n5, sub_1_root_sub_0_root_add_25_4_n4,
         sub_1_root_sub_0_root_add_25_4_n3, sub_1_root_sub_0_root_add_25_4_n2,
         sub_1_root_sub_0_root_add_25_4_n1, add_1_root_add_0_root_add_25_2_n1,
         add_0_root_add_0_root_add_25_2_n1, add_1_root_add_0_root_add_23_n1,
         add_0_root_add_0_root_add_23_n1, mult_16_n29, mult_16_n28,
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
         mult_16_ab_7__0_, add_22_n78, add_22_n77, add_22_n76, add_22_n75,
         add_22_n74, add_22_n73, add_22_n72, add_22_n71, add_22_n70,
         add_22_n69, add_22_n68, add_22_n67, add_22_n66, add_22_n65,
         add_22_n64, add_22_n63, add_22_n62, add_22_n61, add_22_n60,
         add_22_n59, add_22_n58, add_22_n57, add_22_n56, add_22_n55,
         add_22_n54, add_22_n53, add_22_n52, add_22_n51, add_22_n50,
         add_22_n49, add_22_n48, add_22_n47, add_22_n46, add_22_n45,
         add_22_n44, add_22_n43, add_22_n42, add_22_n41, add_22_n40,
         add_22_n39, add_22_n38, add_22_n37, add_22_n36, add_22_n35,
         add_22_n34, add_22_n33, add_22_n32, add_22_n31, add_22_n30,
         add_22_n29, add_22_n28, add_22_n27, add_22_n26, add_22_n25,
         add_22_n24, add_22_n23, add_22_n22, add_22_n21, add_22_n20,
         add_22_n19, add_22_n18, add_22_n17, add_22_n16, add_22_n15,
         add_22_n14, add_22_n13, add_22_n12, add_22_n11, add_22_n10, add_22_n9,
         add_22_n8, add_22_n7, add_22_n6, add_22_n5, add_22_n4, add_22_n3,
         add_22_n1, rem_22_n212, rem_22_n211, rem_22_n210, rem_22_n209,
         rem_22_n208, rem_22_n207, rem_22_n206, rem_22_n205, rem_22_n204,
         rem_22_n203, rem_22_n202, rem_22_n201, rem_22_n200, rem_22_n199,
         rem_22_n198, rem_22_n197, rem_22_n196, rem_22_n195, rem_22_n194,
         rem_22_n193, rem_22_n192, rem_22_n191, rem_22_n190, rem_22_n189,
         rem_22_n188, rem_22_n187, rem_22_n186, rem_22_n185, rem_22_n184,
         rem_22_n183, rem_22_n182, rem_22_n181, rem_22_n180, rem_22_n179,
         rem_22_n178, rem_22_n177, rem_22_n176, rem_22_n175, rem_22_n174,
         rem_22_n173, rem_22_n172, rem_22_n171, rem_22_n170, rem_22_n169,
         rem_22_n168, rem_22_n167, rem_22_n166, rem_22_n165, rem_22_n164,
         rem_22_n163, rem_22_n162, rem_22_n161, rem_22_n160, rem_22_n159,
         rem_22_n158, rem_22_n157, rem_22_n156, rem_22_n155, rem_22_n154,
         rem_22_n153, rem_22_n152, rem_22_n151, rem_22_n150, rem_22_n149,
         rem_22_n148, rem_22_n147, rem_22_n146, rem_22_n145, rem_22_n144,
         rem_22_n143, rem_22_n142, rem_22_n141, rem_22_n140, rem_22_n139,
         rem_22_n138, rem_22_n137, rem_22_n136, rem_22_n135, rem_22_n134,
         rem_22_n133, rem_22_n132, rem_22_n131, rem_22_n130, rem_22_n129,
         rem_22_n128, rem_22_n127, rem_22_n126, rem_22_n125, rem_22_n124,
         rem_22_n123, rem_22_n122, rem_22_n121, rem_22_n120, rem_22_n119,
         rem_22_n118, rem_22_n117, rem_22_n116, rem_22_n115, rem_22_n114,
         rem_22_n113, rem_22_n112, rem_22_n111, rem_22_n110, rem_22_n109,
         rem_22_n108, rem_22_n107, rem_22_n106, rem_22_n105, rem_22_n104,
         rem_22_n103, rem_22_n102, rem_22_n101, rem_22_n100, rem_22_n99,
         rem_22_n98, rem_22_n97, rem_22_n96, rem_22_n95, rem_22_n94,
         rem_22_n93, rem_22_n92, rem_22_n91, rem_22_n90, rem_22_n89,
         rem_22_n88, rem_22_n87, rem_22_n86, rem_22_n85, rem_22_n84,
         rem_22_n83, rem_22_n82, rem_22_n81, rem_22_n80, rem_22_n79,
         rem_22_n78, rem_22_n77, rem_22_n76, rem_22_n75, rem_22_n74,
         rem_22_n73, rem_22_n72, rem_22_n71, rem_22_n70, rem_22_n69,
         rem_22_n68, rem_22_n67, rem_22_n66, rem_22_n65, rem_22_n64,
         rem_22_n63, rem_22_n62, rem_22_n61, rem_22_n60, rem_22_n59,
         rem_22_n58, rem_22_n57, rem_22_n56, rem_22_n55, rem_22_n54,
         rem_22_n53, rem_22_n52, rem_22_n51, rem_22_n50, rem_22_n49,
         rem_22_n48, rem_22_n47, rem_22_n46, rem_22_n45, rem_22_n44,
         rem_22_n43, rem_22_n42, rem_22_n41, rem_22_n40, rem_22_n39,
         rem_22_n38, rem_22_n37, rem_22_n36, rem_22_n35, rem_22_n34,
         rem_22_n33, rem_22_n32, rem_22_n31, rem_22_n30, rem_22_n29,
         rem_22_n28, rem_22_n27, rem_22_n26, rem_22_n25, rem_22_n24,
         rem_22_n23, rem_22_n22, rem_22_n21, rem_22_n20, rem_22_n19,
         rem_22_n18, rem_22_n17, rem_22_n16, rem_22_n15, rem_22_n14,
         rem_22_n13, rem_22_n12, rem_22_n11, rem_22_n10, rem_22_n9, rem_22_n8,
         rem_22_n7, rem_22_n6, rem_22_n5, rem_22_n4, rem_22_n3, rem_22_n2,
         rem_22_n1, rem_22_u_div_PartRem_6__2_, rem_22_u_div_PartRem_5__3_,
         rem_22_u_div_PartRem_5__2_, rem_22_u_div_PartRem_4__4_,
         rem_22_u_div_PartRem_4__3_, rem_22_u_div_PartRem_4__2_,
         rem_22_u_div_PartRem_4__1_, rem_22_u_div_PartRem_3__5_,
         rem_22_u_div_PartRem_3__4_, rem_22_u_div_PartRem_3__3_,
         rem_22_u_div_PartRem_3__2_, rem_22_u_div_PartRem_2__6_,
         rem_22_u_div_PartRem_2__5_, rem_22_u_div_PartRem_2__4_,
         rem_22_u_div_PartRem_2__3_, rem_22_u_div_PartRem_2__2_,
         rem_22_u_div_PartRem_1__7_, rem_22_u_div_PartRem_1__6_,
         rem_22_u_div_PartRem_1__5_, rem_22_u_div_PartRem_1__4_,
         rem_22_u_div_PartRem_1__3_, rem_22_u_div_PartRem_1__2_,
         rem_22_u_div_PartRem_1__1_, rem_22_u_div_CryTmp_7__1_,
         rem_22_u_div_CryTmp_6__2_, rem_22_u_div_CryTmp_5__3_,
         rem_22_u_div_CryTmp_5__2_, rem_22_u_div_CryTmp_5__1_,
         rem_22_u_div_CryTmp_4__4_, rem_22_u_div_CryTmp_4__3_,
         rem_22_u_div_CryTmp_4__2_, rem_22_u_div_CryTmp_4__1_,
         rem_22_u_div_CryTmp_3__5_, rem_22_u_div_CryTmp_3__4_,
         rem_22_u_div_CryTmp_3__3_, rem_22_u_div_CryTmp_3__2_,
         rem_22_u_div_CryTmp_3__1_, rem_22_u_div_CryTmp_2__6_,
         rem_22_u_div_CryTmp_2__5_, rem_22_u_div_CryTmp_2__4_,
         rem_22_u_div_CryTmp_2__3_, rem_22_u_div_CryTmp_2__2_,
         rem_22_u_div_CryTmp_2__1_, rem_22_u_div_CryTmp_1__6_,
         rem_22_u_div_CryTmp_1__5_, rem_22_u_div_CryTmp_1__4_,
         rem_22_u_div_CryTmp_1__3_, rem_22_u_div_CryTmp_1__2_,
         rem_22_u_div_CryTmp_1__1_, rem_22_u_div_CryTmp_0__8_,
         rem_22_u_div_CryTmp_0__7_, rem_22_u_div_CryTmp_0__6_,
         rem_22_u_div_CryTmp_0__5_, rem_22_u_div_CryTmp_0__4_,
         rem_22_u_div_CryTmp_0__3_, rem_22_u_div_CryTmp_0__2_,
         rem_22_u_div_CryTmp_0__1_, rem_22_u_div_SumTmp_7__0_,
         rem_22_u_div_SumTmp_6__1_, rem_22_u_div_SumTmp_6__0_,
         rem_22_u_div_SumTmp_5__2_, rem_22_u_div_SumTmp_5__1_,
         rem_22_u_div_SumTmp_5__0_, rem_22_u_div_SumTmp_3__4_,
         rem_22_u_div_SumTmp_3__3_, rem_22_u_div_SumTmp_3__1_,
         rem_22_u_div_SumTmp_3__0_, rem_22_u_div_SumTmp_2__3_,
         rem_22_u_div_SumTmp_2__2_, rem_22_u_div_SumTmp_2__0_,
         rem_22_u_div_SumTmp_1__0_, rem_22_u_div_SumTmp_0__7_,
         rem_22_u_div_SumTmp_0__6_, rem_22_u_div_SumTmp_0__5_,
         rem_22_u_div_SumTmp_0__4_, rem_22_u_div_SumTmp_0__3_,
         rem_22_u_div_SumTmp_0__2_, rem_22_u_div_SumTmp_0__1_,
         rem_22_u_div_SumTmp_0__0_;
  wire   [7:1] sub_24_carry;
  wire   [7:2] add_17_carry;
  wire   [7:2] add_25_3_carry;
  wire   [7:2] sub_1_root_sub_0_root_add_25_4_carry;
  wire   [7:2] add_1_root_add_0_root_add_25_2_carry;
  wire   [7:2] add_0_root_add_0_root_add_25_2_carry;
  wire   [7:2] add_0_root_sub_0_root_add_25_4_carry;
  wire   [7:2] add_1_root_add_0_root_add_23_carry;
  wire   [7:2] add_0_root_add_0_root_add_23_carry;
  wire   [7:0] rem_22_u_div_BInv;

  BUF_X2 U8 ( .A(a[7]), .Z(n7) );
  BUF_X2 U9 ( .A(b[1]), .Z(n8) );
  BUF_X1 U10 ( .A(b[7]), .Z(n9) );
  BUF_X1 U11 ( .A(b[0]), .Z(n10) );
  INV_X1 sub_24_U11 ( .A(n10), .ZN(sub_24_n9) );
  INV_X1 sub_24_U10 ( .A(b[7]), .ZN(sub_24_n2) );
  XNOR2_X1 sub_24_U9 ( .A(sub_24_n9), .B(a[0]), .ZN(s5[0]) );
  INV_X1 sub_24_U8 ( .A(a[0]), .ZN(sub_24_n1) );
  NAND2_X1 sub_24_U7 ( .A1(n10), .A2(sub_24_n1), .ZN(sub_24_carry[1]) );
  INV_X1 sub_24_U6 ( .A(n8), .ZN(sub_24_n8) );
  INV_X1 sub_24_U5 ( .A(b[2]), .ZN(sub_24_n7) );
  INV_X1 sub_24_U4 ( .A(b[3]), .ZN(sub_24_n6) );
  INV_X1 sub_24_U3 ( .A(b[4]), .ZN(sub_24_n5) );
  INV_X1 sub_24_U2 ( .A(b[5]), .ZN(sub_24_n4) );
  INV_X1 sub_24_U1 ( .A(b[6]), .ZN(sub_24_n3) );
  FA_X1 sub_24_U2_1 ( .A(a[1]), .B(sub_24_n8), .CI(sub_24_carry[1]), .CO(
        sub_24_carry[2]), .S(s5[1]) );
  FA_X1 sub_24_U2_2 ( .A(a[2]), .B(sub_24_n7), .CI(sub_24_carry[2]), .CO(
        sub_24_carry[3]), .S(s5[2]) );
  FA_X1 sub_24_U2_3 ( .A(a[3]), .B(sub_24_n6), .CI(sub_24_carry[3]), .CO(
        sub_24_carry[4]), .S(s5[3]) );
  FA_X1 sub_24_U2_4 ( .A(a[4]), .B(sub_24_n5), .CI(sub_24_carry[4]), .CO(
        sub_24_carry[5]), .S(s5[4]) );
  FA_X1 sub_24_U2_5 ( .A(a[5]), .B(sub_24_n4), .CI(sub_24_carry[5]), .CO(
        sub_24_carry[6]), .S(s5[5]) );
  FA_X1 sub_24_U2_6 ( .A(a[6]), .B(sub_24_n3), .CI(sub_24_carry[6]), .CO(
        sub_24_carry[7]), .S(s5[6]) );
  FA_X1 sub_24_U2_7 ( .A(n7), .B(sub_24_n2), .CI(sub_24_carry[7]), .S(s5[7])
         );
  XOR2_X1 add_17_U2 ( .A(n10), .B(a[0]), .Z(s1[0]) );
  AND2_X1 add_17_U1 ( .A1(n10), .A2(a[0]), .ZN(add_17_n1) );
  FA_X1 add_17_U1_1 ( .A(a[1]), .B(n8), .CI(add_17_n1), .CO(add_17_carry[2]), 
        .S(s1[1]) );
  FA_X1 add_17_U1_2 ( .A(a[2]), .B(b[2]), .CI(add_17_carry[2]), .CO(
        add_17_carry[3]), .S(s1[2]) );
  FA_X1 add_17_U1_3 ( .A(a[3]), .B(b[3]), .CI(add_17_carry[3]), .CO(
        add_17_carry[4]), .S(s1[3]) );
  FA_X1 add_17_U1_4 ( .A(a[4]), .B(b[4]), .CI(add_17_carry[4]), .CO(
        add_17_carry[5]), .S(s1[4]) );
  FA_X1 add_17_U1_5 ( .A(a[5]), .B(b[5]), .CI(add_17_carry[5]), .CO(
        add_17_carry[6]), .S(s1[5]) );
  FA_X1 add_17_U1_6 ( .A(a[6]), .B(b[6]), .CI(add_17_carry[6]), .CO(
        add_17_carry[7]), .S(s1[6]) );
  FA_X1 add_17_U1_7 ( .A(n7), .B(n9), .CI(add_17_carry[7]), .S(s1[7]) );
  INV_X1 add_25_3_U2 ( .A(n10), .ZN(N32) );
  XOR2_X1 add_25_3_U1 ( .A(add_25_3_carry[7]), .B(b[7]), .Z(N39) );
  HA_X1 add_25_3_U1_1_1 ( .A(n8), .B(n10), .CO(add_25_3_carry[2]), .S(N33) );
  HA_X1 add_25_3_U1_1_2 ( .A(b[2]), .B(add_25_3_carry[2]), .CO(
        add_25_3_carry[3]), .S(N34) );
  HA_X1 add_25_3_U1_1_3 ( .A(b[3]), .B(add_25_3_carry[3]), .CO(
        add_25_3_carry[4]), .S(N35) );
  HA_X1 add_25_3_U1_1_4 ( .A(b[4]), .B(add_25_3_carry[4]), .CO(
        add_25_3_carry[5]), .S(N36) );
  HA_X1 add_25_3_U1_1_5 ( .A(b[5]), .B(add_25_3_carry[5]), .CO(
        add_25_3_carry[6]), .S(N37) );
  HA_X1 add_25_3_U1_1_6 ( .A(b[6]), .B(add_25_3_carry[6]), .CO(
        add_25_3_carry[7]), .S(N38) );
  INV_X1 sub_1_root_sub_0_root_add_25_4_U7 ( .A(b[7]), .ZN(
        sub_1_root_sub_0_root_add_25_4_n1) );
  INV_X1 sub_1_root_sub_0_root_add_25_4_U6 ( .A(b[3]), .ZN(
        sub_1_root_sub_0_root_add_25_4_n5) );
  INV_X1 sub_1_root_sub_0_root_add_25_4_U5 ( .A(b[2]), .ZN(
        sub_1_root_sub_0_root_add_25_4_n6) );
  INV_X1 sub_1_root_sub_0_root_add_25_4_U4 ( .A(b[4]), .ZN(
        sub_1_root_sub_0_root_add_25_4_n4) );
  INV_X1 sub_1_root_sub_0_root_add_25_4_U3 ( .A(b[5]), .ZN(
        sub_1_root_sub_0_root_add_25_4_n3) );
  INV_X1 sub_1_root_sub_0_root_add_25_4_U2 ( .A(b[6]), .ZN(
        sub_1_root_sub_0_root_add_25_4_n2) );
  INV_X1 sub_1_root_sub_0_root_add_25_4_U1 ( .A(n8), .ZN(
        sub_1_root_sub_0_root_add_25_4_n7) );
  FA_X1 sub_1_root_sub_0_root_add_25_4_U2_1 ( .A(N33), .B(
        sub_1_root_sub_0_root_add_25_4_n7), .CI(N32), .CO(
        sub_1_root_sub_0_root_add_25_4_carry[2]), .S(N25) );
  FA_X1 sub_1_root_sub_0_root_add_25_4_U2_2 ( .A(N34), .B(
        sub_1_root_sub_0_root_add_25_4_n6), .CI(
        sub_1_root_sub_0_root_add_25_4_carry[2]), .CO(
        sub_1_root_sub_0_root_add_25_4_carry[3]), .S(N26) );
  FA_X1 sub_1_root_sub_0_root_add_25_4_U2_3 ( .A(N35), .B(
        sub_1_root_sub_0_root_add_25_4_n5), .CI(
        sub_1_root_sub_0_root_add_25_4_carry[3]), .CO(
        sub_1_root_sub_0_root_add_25_4_carry[4]), .S(N27) );
  FA_X1 sub_1_root_sub_0_root_add_25_4_U2_4 ( .A(N36), .B(
        sub_1_root_sub_0_root_add_25_4_n4), .CI(
        sub_1_root_sub_0_root_add_25_4_carry[4]), .CO(
        sub_1_root_sub_0_root_add_25_4_carry[5]), .S(N28) );
  FA_X1 sub_1_root_sub_0_root_add_25_4_U2_5 ( .A(N37), .B(
        sub_1_root_sub_0_root_add_25_4_n3), .CI(
        sub_1_root_sub_0_root_add_25_4_carry[5]), .CO(
        sub_1_root_sub_0_root_add_25_4_carry[6]), .S(N29) );
  FA_X1 sub_1_root_sub_0_root_add_25_4_U2_6 ( .A(N38), .B(
        sub_1_root_sub_0_root_add_25_4_n2), .CI(
        sub_1_root_sub_0_root_add_25_4_carry[6]), .CO(
        sub_1_root_sub_0_root_add_25_4_carry[7]), .S(N30) );
  FA_X1 sub_1_root_sub_0_root_add_25_4_U2_7 ( .A(N39), .B(
        sub_1_root_sub_0_root_add_25_4_n1), .CI(
        sub_1_root_sub_0_root_add_25_4_carry[7]), .S(N31) );
  XOR2_X1 add_1_root_add_0_root_add_25_2_U2 ( .A(d[0]), .B(c[0]), .Z(N8) );
  AND2_X1 add_1_root_add_0_root_add_25_2_U1 ( .A1(d[0]), .A2(c[0]), .ZN(
        add_1_root_add_0_root_add_25_2_n1) );
  FA_X1 add_1_root_add_0_root_add_25_2_U1_1 ( .A(c[1]), .B(d[1]), .CI(
        add_1_root_add_0_root_add_25_2_n1), .CO(
        add_1_root_add_0_root_add_25_2_carry[2]), .S(N9) );
  FA_X1 add_1_root_add_0_root_add_25_2_U1_2 ( .A(c[2]), .B(d[2]), .CI(
        add_1_root_add_0_root_add_25_2_carry[2]), .CO(
        add_1_root_add_0_root_add_25_2_carry[3]), .S(N10) );
  FA_X1 add_1_root_add_0_root_add_25_2_U1_3 ( .A(c[3]), .B(d[3]), .CI(
        add_1_root_add_0_root_add_25_2_carry[3]), .CO(
        add_1_root_add_0_root_add_25_2_carry[4]), .S(N11) );
  FA_X1 add_1_root_add_0_root_add_25_2_U1_4 ( .A(c[4]), .B(d[4]), .CI(
        add_1_root_add_0_root_add_25_2_carry[4]), .CO(
        add_1_root_add_0_root_add_25_2_carry[5]), .S(N12) );
  FA_X1 add_1_root_add_0_root_add_25_2_U1_5 ( .A(c[5]), .B(d[5]), .CI(
        add_1_root_add_0_root_add_25_2_carry[5]), .CO(
        add_1_root_add_0_root_add_25_2_carry[6]), .S(N13) );
  FA_X1 add_1_root_add_0_root_add_25_2_U1_6 ( .A(c[6]), .B(d[6]), .CI(
        add_1_root_add_0_root_add_25_2_carry[6]), .CO(
        add_1_root_add_0_root_add_25_2_carry[7]), .S(N14) );
  FA_X1 add_1_root_add_0_root_add_25_2_U1_7 ( .A(c[7]), .B(d[7]), .CI(
        add_1_root_add_0_root_add_25_2_carry[7]), .S(N15) );
  XOR2_X1 add_0_root_add_0_root_add_25_2_U2 ( .A(s2[0]), .B(N8), .Z(N16) );
  AND2_X1 add_0_root_add_0_root_add_25_2_U1 ( .A1(s2[0]), .A2(N8), .ZN(
        add_0_root_add_0_root_add_25_2_n1) );
  FA_X1 add_0_root_add_0_root_add_25_2_U1_1 ( .A(N9), .B(s2[1]), .CI(
        add_0_root_add_0_root_add_25_2_n1), .CO(
        add_0_root_add_0_root_add_25_2_carry[2]), .S(N17) );
  FA_X1 add_0_root_add_0_root_add_25_2_U1_2 ( .A(N10), .B(s2[2]), .CI(
        add_0_root_add_0_root_add_25_2_carry[2]), .CO(
        add_0_root_add_0_root_add_25_2_carry[3]), .S(N18) );
  FA_X1 add_0_root_add_0_root_add_25_2_U1_3 ( .A(N11), .B(s2[3]), .CI(
        add_0_root_add_0_root_add_25_2_carry[3]), .CO(
        add_0_root_add_0_root_add_25_2_carry[4]), .S(N19) );
  FA_X1 add_0_root_add_0_root_add_25_2_U1_4 ( .A(N12), .B(s2[4]), .CI(
        add_0_root_add_0_root_add_25_2_carry[4]), .CO(
        add_0_root_add_0_root_add_25_2_carry[5]), .S(N20) );
  FA_X1 add_0_root_add_0_root_add_25_2_U1_5 ( .A(N13), .B(s2[5]), .CI(
        add_0_root_add_0_root_add_25_2_carry[5]), .CO(
        add_0_root_add_0_root_add_25_2_carry[6]), .S(N21) );
  FA_X1 add_0_root_add_0_root_add_25_2_U1_6 ( .A(N14), .B(s2[6]), .CI(
        add_0_root_add_0_root_add_25_2_carry[6]), .CO(
        add_0_root_add_0_root_add_25_2_carry[7]), .S(N22) );
  FA_X1 add_0_root_add_0_root_add_25_2_U1_7 ( .A(N15), .B(s2[7]), .CI(
        add_0_root_add_0_root_add_25_2_carry[7]), .S(N23) );
  INV_X1 add_0_root_sub_0_root_add_25_4_U1 ( .A(N16), .ZN(s6[0]) );
  FA_X1 add_0_root_sub_0_root_add_25_4_U1_1 ( .A(N25), .B(N17), .CI(N16), .CO(
        add_0_root_sub_0_root_add_25_4_carry[2]), .S(s6[1]) );
  FA_X1 add_0_root_sub_0_root_add_25_4_U1_2 ( .A(N26), .B(N18), .CI(
        add_0_root_sub_0_root_add_25_4_carry[2]), .CO(
        add_0_root_sub_0_root_add_25_4_carry[3]), .S(s6[2]) );
  FA_X1 add_0_root_sub_0_root_add_25_4_U1_3 ( .A(N27), .B(N19), .CI(
        add_0_root_sub_0_root_add_25_4_carry[3]), .CO(
        add_0_root_sub_0_root_add_25_4_carry[4]), .S(s6[3]) );
  FA_X1 add_0_root_sub_0_root_add_25_4_U1_4 ( .A(N28), .B(N20), .CI(
        add_0_root_sub_0_root_add_25_4_carry[4]), .CO(
        add_0_root_sub_0_root_add_25_4_carry[5]), .S(s6[4]) );
  FA_X1 add_0_root_sub_0_root_add_25_4_U1_5 ( .A(N29), .B(N21), .CI(
        add_0_root_sub_0_root_add_25_4_carry[5]), .CO(
        add_0_root_sub_0_root_add_25_4_carry[6]), .S(s6[5]) );
  FA_X1 add_0_root_sub_0_root_add_25_4_U1_6 ( .A(N30), .B(N22), .CI(
        add_0_root_sub_0_root_add_25_4_carry[6]), .CO(
        add_0_root_sub_0_root_add_25_4_carry[7]), .S(s6[6]) );
  FA_X1 add_0_root_sub_0_root_add_25_4_U1_7 ( .A(N31), .B(N23), .CI(
        add_0_root_sub_0_root_add_25_4_carry[7]), .S(s6[7]) );
  XOR2_X1 add_1_root_add_0_root_add_23_U2 ( .A(d[0]), .B(c[0]), .Z(sum_cd_0_)
         );
  AND2_X1 add_1_root_add_0_root_add_23_U1 ( .A1(d[0]), .A2(c[0]), .ZN(
        add_1_root_add_0_root_add_23_n1) );
  FA_X1 add_1_root_add_0_root_add_23_U1_1 ( .A(c[1]), .B(d[1]), .CI(
        add_1_root_add_0_root_add_23_n1), .CO(
        add_1_root_add_0_root_add_23_carry[2]), .S(sum_cd_1_) );
  FA_X1 add_1_root_add_0_root_add_23_U1_2 ( .A(c[2]), .B(d[2]), .CI(
        add_1_root_add_0_root_add_23_carry[2]), .CO(
        add_1_root_add_0_root_add_23_carry[3]), .S(sum_cd_2_) );
  FA_X1 add_1_root_add_0_root_add_23_U1_3 ( .A(c[3]), .B(d[3]), .CI(
        add_1_root_add_0_root_add_23_carry[3]), .CO(
        add_1_root_add_0_root_add_23_carry[4]), .S(sum_cd_3_) );
  FA_X1 add_1_root_add_0_root_add_23_U1_4 ( .A(c[4]), .B(d[4]), .CI(
        add_1_root_add_0_root_add_23_carry[4]), .CO(
        add_1_root_add_0_root_add_23_carry[5]), .S(sum_cd_4_) );
  FA_X1 add_1_root_add_0_root_add_23_U1_5 ( .A(c[5]), .B(d[5]), .CI(
        add_1_root_add_0_root_add_23_carry[5]), .CO(
        add_1_root_add_0_root_add_23_carry[6]), .S(sum_cd_5_) );
  FA_X1 add_1_root_add_0_root_add_23_U1_6 ( .A(c[6]), .B(d[6]), .CI(
        add_1_root_add_0_root_add_23_carry[6]), .CO(
        add_1_root_add_0_root_add_23_carry[7]), .S(sum_cd_6_) );
  FA_X1 add_1_root_add_0_root_add_23_U1_7 ( .A(c[7]), .B(d[7]), .CI(
        add_1_root_add_0_root_add_23_carry[7]), .S(sum_cd_7_) );
  XOR2_X1 add_0_root_add_0_root_add_23_U2 ( .A(s2[0]), .B(sum_cd_0_), .Z(s4[0]) );
  AND2_X1 add_0_root_add_0_root_add_23_U1 ( .A1(s2[0]), .A2(sum_cd_0_), .ZN(
        add_0_root_add_0_root_add_23_n1) );
  FA_X1 add_0_root_add_0_root_add_23_U1_1 ( .A(sum_cd_1_), .B(s2[1]), .CI(
        add_0_root_add_0_root_add_23_n1), .CO(
        add_0_root_add_0_root_add_23_carry[2]), .S(s4[1]) );
  FA_X1 add_0_root_add_0_root_add_23_U1_2 ( .A(sum_cd_2_), .B(s2[2]), .CI(
        add_0_root_add_0_root_add_23_carry[2]), .CO(
        add_0_root_add_0_root_add_23_carry[3]), .S(s4[2]) );
  FA_X1 add_0_root_add_0_root_add_23_U1_3 ( .A(sum_cd_3_), .B(s2[3]), .CI(
        add_0_root_add_0_root_add_23_carry[3]), .CO(
        add_0_root_add_0_root_add_23_carry[4]), .S(s4[3]) );
  FA_X1 add_0_root_add_0_root_add_23_U1_4 ( .A(sum_cd_4_), .B(s2[4]), .CI(
        add_0_root_add_0_root_add_23_carry[4]), .CO(
        add_0_root_add_0_root_add_23_carry[5]), .S(s4[4]) );
  FA_X1 add_0_root_add_0_root_add_23_U1_5 ( .A(sum_cd_5_), .B(s2[5]), .CI(
        add_0_root_add_0_root_add_23_carry[5]), .CO(
        add_0_root_add_0_root_add_23_carry[6]), .S(s4[5]) );
  FA_X1 add_0_root_add_0_root_add_23_U1_6 ( .A(sum_cd_6_), .B(s2[6]), .CI(
        add_0_root_add_0_root_add_23_carry[6]), .CO(
        add_0_root_add_0_root_add_23_carry[7]), .S(s4[6]) );
  FA_X1 add_0_root_add_0_root_add_23_U1_7 ( .A(sum_cd_7_), .B(s2[7]), .CI(
        add_0_root_add_0_root_add_23_carry[7]), .S(s4[7]) );
  NOR2_X1 mult_16_U64 ( .A1(mult_16_n29), .A2(mult_16_n28), .ZN(s2[0]) );
  AND2_X1 mult_16_U63 ( .A1(n7), .A2(n10), .ZN(mult_16_ab_7__0_) );
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
  INV_X1 mult_16_U36 ( .A(n10), .ZN(mult_16_n28) );
  NOR2_X1 mult_16_U35 ( .A1(mult_16_n29), .A2(mult_16_n26), .ZN(
        mult_16_ab_0__1_) );
  NOR2_X1 mult_16_U34 ( .A1(mult_16_n26), .A2(mult_16_n17), .ZN(
        mult_16_ab_1__1_) );
  INV_X1 mult_16_U33 ( .A(n8), .ZN(mult_16_n26) );
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
  INV_X1 mult_16_U24 ( .A(b[4]), .ZN(mult_16_n20) );
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
  NAND2_X1 mult_16_U15 ( .A1(b[7]), .A2(a[0]), .ZN(mult_16_n15) );
  XNOR2_X1 mult_16_U14 ( .A(mult_16_n15), .B(mult_16_ab_1__6_), .ZN(
        mult_16_n14) );
  XOR2_X1 mult_16_U13 ( .A(mult_16_ab_1__0_), .B(mult_16_ab_0__1_), .Z(s2[1])
         );
  AND2_X1 mult_16_U12 ( .A1(mult_16_ab_0__6_), .A2(mult_16_ab_1__5_), .ZN(
        mult_16_n12) );
  XOR2_X1 mult_16_U11 ( .A(mult_16_ab_1__2_), .B(mult_16_ab_0__3_), .Z(
        mult_16_n11) );
  AND2_X1 mult_16_U10 ( .A1(mult_16_ab_0__3_), .A2(mult_16_ab_1__2_), .ZN(
        mult_16_n10) );
  AND2_X1 mult_16_U9 ( .A1(mult_16_ab_0__4_), .A2(mult_16_ab_1__3_), .ZN(
        mult_16_n9) );
  AND2_X1 mult_16_U8 ( .A1(mult_16_ab_0__1_), .A2(mult_16_ab_1__0_), .ZN(
        mult_16_n8) );
  AND2_X1 mult_16_U7 ( .A1(mult_16_ab_0__5_), .A2(mult_16_ab_1__4_), .ZN(
        mult_16_n7) );
  XOR2_X1 mult_16_U6 ( .A(mult_16_ab_1__3_), .B(mult_16_ab_0__4_), .Z(
        mult_16_n6) );
  AND2_X1 mult_16_U5 ( .A1(mult_16_ab_0__2_), .A2(mult_16_ab_1__1_), .ZN(
        mult_16_n5) );
  XOR2_X1 mult_16_U4 ( .A(mult_16_ab_1__4_), .B(mult_16_ab_0__5_), .Z(
        mult_16_n4) );
  XOR2_X1 mult_16_U3 ( .A(mult_16_ab_1__1_), .B(mult_16_ab_0__2_), .Z(
        mult_16_n3) );
  XOR2_X1 mult_16_U2 ( .A(mult_16_ab_1__5_), .B(mult_16_ab_0__6_), .Z(
        mult_16_n2) );
  FA_X1 mult_16_S2_2_5 ( .A(mult_16_ab_2__5_), .B(mult_16_n12), .CI(
        mult_16_n14), .S(mult_16_SUMB_2__5_) );
  FA_X1 mult_16_S2_2_4 ( .A(mult_16_ab_2__4_), .B(mult_16_n7), .CI(mult_16_n2), 
        .CO(mult_16_CARRYB_2__4_), .S(mult_16_SUMB_2__4_) );
  FA_X1 mult_16_S2_2_3 ( .A(mult_16_ab_2__3_), .B(mult_16_n9), .CI(mult_16_n4), 
        .CO(mult_16_CARRYB_2__3_), .S(mult_16_SUMB_2__3_) );
  FA_X1 mult_16_S2_2_2 ( .A(mult_16_ab_2__2_), .B(mult_16_n10), .CI(mult_16_n6), .CO(mult_16_CARRYB_2__2_), .S(mult_16_SUMB_2__2_) );
  FA_X1 mult_16_S2_2_1 ( .A(mult_16_ab_2__1_), .B(mult_16_n5), .CI(mult_16_n11), .CO(mult_16_CARRYB_2__1_), .S(mult_16_SUMB_2__1_) );
  FA_X1 mult_16_S1_2_0 ( .A(mult_16_ab_2__0_), .B(mult_16_n8), .CI(mult_16_n3), 
        .CO(mult_16_CARRYB_2__0_), .S(s2[2]) );
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
  INV_X1 add_22_U86 ( .A(add_22_n12), .ZN(add_22_n74) );
  INV_X1 add_22_U85 ( .A(add_22_n61), .ZN(add_22_n34) );
  INV_X1 add_22_U84 ( .A(add_22_n72), .ZN(add_22_n71) );
  OAI21_X1 add_22_U83 ( .B1(add_22_n71), .B2(add_22_n21), .A(add_22_n18), .ZN(
        add_22_n69) );
  XNOR2_X1 add_22_U82 ( .A(add_22_n69), .B(add_22_n70), .ZN(s3[3]) );
  INV_X1 add_22_U81 ( .A(add_22_n68), .ZN(add_22_n67) );
  INV_X1 add_22_U80 ( .A(add_22_n66), .ZN(add_22_n42) );
  INV_X1 add_22_U79 ( .A(add_22_n47), .ZN(add_22_n57) );
  INV_X1 add_22_U78 ( .A(add_22_n49), .ZN(add_22_n46) );
  INV_X1 add_22_U77 ( .A(add_22_n48), .ZN(add_22_n54) );
  INV_X1 add_22_U76 ( .A(add_22_n37), .ZN(add_22_n45) );
  XNOR2_X1 add_22_U75 ( .A(add_22_n43), .B(add_22_n44), .ZN(s3[6]) );
  INV_X1 add_22_U74 ( .A(add_22_n38), .ZN(add_22_n35) );
  INV_X1 add_22_U73 ( .A(add_22_n40), .ZN(add_22_n39) );
  INV_X1 add_22_U72 ( .A(add_22_n36), .ZN(add_22_n31) );
  NOR2_X1 add_22_U71 ( .A1(add_22_n34), .A2(add_22_n35), .ZN(add_22_n32) );
  NAND4_X1 add_22_U70 ( .A1(add_22_n19), .A2(add_22_n31), .A3(add_22_n32), 
        .A4(add_22_n7), .ZN(add_22_n30) );
  XNOR2_X1 add_22_U69 ( .A(add_22_n26), .B(add_22_n27), .ZN(s3[7]) );
  NAND2_X1 add_22_U68 ( .A1(N0), .A2(d[0]), .ZN(add_22_n63) );
  INV_X1 add_22_U67 ( .A(add_22_n24), .ZN(add_22_n78) );
  NAND2_X1 add_22_U66 ( .A1(add_22_n62), .A2(add_22_n63), .ZN(add_22_n33) );
  AOI21_X1 add_22_U65 ( .B1(add_22_n51), .B2(add_22_n50), .A(add_22_n57), .ZN(
        add_22_n52) );
  XNOR2_X1 add_22_U64 ( .A(add_22_n20), .B(add_22_n58), .ZN(s3[4]) );
  NAND2_X1 add_22_U63 ( .A1(N1), .A2(d[1]), .ZN(add_22_n62) );
  NAND2_X1 add_22_U62 ( .A1(add_22_n59), .A2(add_22_n11), .ZN(add_22_n51) );
  NAND2_X1 add_22_U61 ( .A1(add_22_n66), .A2(add_22_n16), .ZN(add_22_n70) );
  NOR2_X1 add_22_U60 ( .A1(add_22_n60), .A2(add_22_n42), .ZN(add_22_n59) );
  XNOR2_X1 add_22_U59 ( .A(add_22_n52), .B(add_22_n53), .ZN(s3[5]) );
  NAND2_X1 add_22_U58 ( .A1(d[3]), .A2(N3), .ZN(add_22_n66) );
  NAND2_X1 add_22_U57 ( .A1(d[4]), .A2(N4), .ZN(add_22_n47) );
  NOR2_X1 add_22_U56 ( .A1(add_22_n36), .A2(add_22_n35), .ZN(add_22_n41) );
  OAI21_X1 add_22_U55 ( .B1(add_22_n22), .B2(add_22_n13), .A(add_22_n45), .ZN(
        add_22_n43) );
  NAND2_X1 add_22_U54 ( .A1(add_22_n18), .A2(add_22_n64), .ZN(add_22_n73) );
  NAND2_X1 add_22_U53 ( .A1(add_22_n6), .A2(add_22_n23), .ZN(add_22_n75) );
  OAI21_X1 add_22_U52 ( .B1(add_22_n74), .B2(add_22_n34), .A(add_22_n23), .ZN(
        add_22_n72) );
  NAND2_X1 add_22_U51 ( .A1(N2), .A2(d[2]), .ZN(add_22_n68) );
  NAND3_X1 add_22_U50 ( .A1(add_22_n28), .A2(add_22_n30), .A3(add_22_n29), 
        .ZN(add_22_n26) );
  INV_X1 add_22_U49 ( .A(d[0]), .ZN(add_22_n77) );
  NAND2_X1 add_22_U48 ( .A1(add_22_n78), .A2(add_22_n77), .ZN(add_22_n76) );
  NAND2_X1 add_22_U47 ( .A1(d[6]), .A2(N6), .ZN(add_22_n40) );
  NAND2_X1 add_22_U46 ( .A1(d[5]), .A2(N5), .ZN(add_22_n48) );
  OR2_X2 add_22_U45 ( .A1(N4), .A2(d[4]), .ZN(add_22_n50) );
  INV_X1 add_22_U44 ( .A(N5), .ZN(add_22_n56) );
  INV_X1 add_22_U43 ( .A(d[5]), .ZN(add_22_n55) );
  NAND2_X1 add_22_U42 ( .A1(add_22_n55), .A2(add_22_n56), .ZN(add_22_n49) );
  XNOR2_X1 add_22_U41 ( .A(d[7]), .B(N7), .ZN(add_22_n27) );
  OR2_X2 add_22_U40 ( .A1(d[6]), .A2(N6), .ZN(add_22_n38) );
  XNOR2_X1 add_22_U39 ( .A(add_22_n75), .B(add_22_n3), .ZN(s3[1]) );
  XNOR2_X1 add_22_U38 ( .A(add_22_n72), .B(add_22_n73), .ZN(s3[2]) );
  NAND2_X1 add_22_U37 ( .A1(add_22_n47), .A2(add_22_n50), .ZN(add_22_n58) );
  NAND2_X1 add_22_U36 ( .A1(add_22_n49), .A2(add_22_n50), .ZN(add_22_n36) );
  AOI21_X1 add_22_U35 ( .B1(add_22_n37), .B2(add_22_n38), .A(add_22_n39), .ZN(
        add_22_n29) );
  OAI21_X1 add_22_U34 ( .B1(add_22_n46), .B2(add_22_n47), .A(add_22_n48), .ZN(
        add_22_n37) );
  NOR2_X1 add_22_U33 ( .A1(add_22_n46), .A2(add_22_n54), .ZN(add_22_n53) );
  NAND2_X1 add_22_U32 ( .A1(add_22_n40), .A2(add_22_n38), .ZN(add_22_n44) );
  AND2_X1 add_22_U31 ( .A1(add_22_n67), .A2(add_22_n15), .ZN(add_22_n25) );
  CLKBUF_X1 add_22_U30 ( .A(N0), .Z(add_22_n24) );
  CLKBUF_X1 add_22_U29 ( .A(add_22_n62), .Z(add_22_n23) );
  NOR2_X1 add_22_U28 ( .A1(d[2]), .A2(add_22_n17), .ZN(add_22_n21) );
  AND2_X1 add_22_U27 ( .A1(add_22_n64), .A2(add_22_n15), .ZN(add_22_n19) );
  BUF_X1 add_22_U26 ( .A(add_22_n68), .Z(add_22_n18) );
  CLKBUF_X1 add_22_U25 ( .A(N2), .Z(add_22_n17) );
  OR2_X1 add_22_U24 ( .A1(N3), .A2(d[3]), .ZN(add_22_n16) );
  OR2_X1 add_22_U23 ( .A1(N3), .A2(d[3]), .ZN(add_22_n15) );
  INV_X1 add_22_U22 ( .A(add_22_n31), .ZN(add_22_n13) );
  AND2_X1 add_22_U21 ( .A1(N0), .A2(d[0]), .ZN(add_22_n12) );
  NAND2_X1 add_22_U20 ( .A1(add_22_n67), .A2(add_22_n15), .ZN(add_22_n11) );
  OR2_X1 add_22_U19 ( .A1(N2), .A2(d[2]), .ZN(add_22_n14) );
  OR2_X1 add_22_U18 ( .A1(N2), .A2(d[2]), .ZN(add_22_n64) );
  NAND2_X1 add_22_U17 ( .A1(add_22_n66), .A2(add_22_n11), .ZN(add_22_n10) );
  NOR2_X1 add_22_U16 ( .A1(add_22_n9), .A2(add_22_n10), .ZN(add_22_n22) );
  NOR2_X1 add_22_U15 ( .A1(add_22_n8), .A2(add_22_n5), .ZN(add_22_n9) );
  NAND2_X1 add_22_U14 ( .A1(add_22_n6), .A2(add_22_n7), .ZN(add_22_n8) );
  NAND2_X1 add_22_U13 ( .A1(add_22_n62), .A2(add_22_n63), .ZN(add_22_n7) );
  NAND2_X1 add_22_U12 ( .A1(add_22_n14), .A2(add_22_n16), .ZN(add_22_n5) );
  AND4_X1 add_22_U11 ( .A1(add_22_n33), .A2(add_22_n14), .A3(add_22_n61), .A4(
        add_22_n65), .ZN(add_22_n60) );
  AOI22_X1 add_22_U10 ( .A1(add_22_n41), .A2(add_22_n25), .B1(add_22_n1), .B2(
        add_22_n4), .ZN(add_22_n28) );
  BUF_X1 add_22_U9 ( .A(add_22_n61), .Z(add_22_n6) );
  OR2_X1 add_22_U8 ( .A1(N3), .A2(d[3]), .ZN(add_22_n65) );
  AND2_X1 add_22_U7 ( .A1(add_22_n50), .A2(add_22_n49), .ZN(add_22_n4) );
  INV_X1 add_22_U6 ( .A(add_22_n74), .ZN(add_22_n3) );
  AND2_X1 add_22_U5 ( .A1(add_22_n76), .A2(add_22_n74), .ZN(s3[0]) );
  AND2_X1 add_22_U4 ( .A1(add_22_n42), .A2(add_22_n38), .ZN(add_22_n1) );
  OR2_X2 add_22_U3 ( .A1(N1), .A2(d[1]), .ZN(add_22_n61) );
  BUF_X1 add_22_U2 ( .A(add_22_n51), .Z(add_22_n20) );
  MUX2_X1 rem_22_U285 ( .A(a[0]), .B(rem_22_u_div_SumTmp_0__0_), .S(rem_22_n87), .Z(N0) );
  MUX2_X1 rem_22_U284 ( .A(rem_22_n30), .B(rem_22_u_div_SumTmp_0__1_), .S(
        rem_22_n87), .Z(N1) );
  MUX2_X1 rem_22_U283 ( .A(rem_22_n187), .B(rem_22_n13), .S(rem_22_n2), .Z(
        rem_22_n210) );
  INV_X1 rem_22_U282 ( .A(rem_22_n210), .ZN(rem_22_u_div_PartRem_1__2_) );
  MUX2_X1 rem_22_U281 ( .A(rem_22_n181), .B(rem_22_n11), .S(rem_22_n152), .Z(
        rem_22_n186) );
  MUX2_X1 rem_22_U280 ( .A(rem_22_n186), .B(rem_22_n14), .S(rem_22_n2), .Z(
        rem_22_n209) );
  INV_X1 rem_22_U279 ( .A(rem_22_n209), .ZN(rem_22_u_div_PartRem_1__3_) );
  MUX2_X1 rem_22_U278 ( .A(rem_22_n89), .B(rem_22_n207), .S(rem_22_n149), .Z(
        rem_22_n180) );
  MUX2_X1 rem_22_U277 ( .A(rem_22_n180), .B(rem_22_n206), .S(rem_22_n152), .Z(
        rem_22_n185) );
  MUX2_X1 rem_22_U276 ( .A(rem_22_n185), .B(rem_22_n15), .S(rem_22_n2), .Z(
        rem_22_n205) );
  INV_X1 rem_22_U275 ( .A(rem_22_n205), .ZN(rem_22_u_div_PartRem_1__4_) );
  MUX2_X1 rem_22_U274 ( .A(rem_22_u_div_PartRem_1__4_), .B(
        rem_22_u_div_SumTmp_0__4_), .S(rem_22_u_div_CryTmp_0__8_), .Z(N4) );
  INV_X2 rem_22_U273 ( .A(b[3]), .ZN(rem_22_u_div_BInv[3]) );
  MUX2_X1 rem_22_U272 ( .A(rem_22_n172), .B(rem_22_n5), .S(rem_22_n150), .Z(
        rem_22_n175) );
  MUX2_X1 rem_22_U271 ( .A(rem_22_n175), .B(rem_22_n8), .S(rem_22_n149), .Z(
        rem_22_n179) );
  MUX2_X1 rem_22_U270 ( .A(rem_22_n179), .B(rem_22_n202), .S(rem_22_n152), .Z(
        rem_22_n184) );
  MUX2_X1 rem_22_U269 ( .A(rem_22_n184), .B(rem_22_n16), .S(rem_22_n2), .Z(
        rem_22_n201) );
  INV_X1 rem_22_U268 ( .A(rem_22_n201), .ZN(rem_22_u_div_PartRem_1__5_) );
  MUX2_X1 rem_22_U267 ( .A(rem_22_u_div_PartRem_1__5_), .B(
        rem_22_u_div_SumTmp_0__5_), .S(rem_22_n87), .Z(N5) );
  INV_X2 rem_22_U266 ( .A(b[2]), .ZN(rem_22_u_div_BInv[2]) );
  MUX2_X1 rem_22_U265 ( .A(rem_22_n169), .B(rem_22_n199), .S(rem_22_n151), .Z(
        rem_22_n171) );
  MUX2_X1 rem_22_U264 ( .A(rem_22_n171), .B(rem_22_n6), .S(rem_22_n150), .Z(
        rem_22_n174) );
  MUX2_X1 rem_22_U263 ( .A(rem_22_n174), .B(rem_22_n198), .S(rem_22_n149), .Z(
        rem_22_n178) );
  MUX2_X1 rem_22_U262 ( .A(rem_22_n178), .B(rem_22_n10), .S(rem_22_n152), .Z(
        rem_22_n183) );
  MUX2_X1 rem_22_U261 ( .A(rem_22_n183), .B(rem_22_n17), .S(rem_22_n2), .Z(
        rem_22_n197) );
  INV_X1 rem_22_U260 ( .A(rem_22_n197), .ZN(rem_22_u_div_PartRem_1__6_) );
  MUX2_X1 rem_22_U259 ( .A(rem_22_u_div_PartRem_1__6_), .B(
        rem_22_u_div_SumTmp_0__6_), .S(rem_22_n26), .Z(N6) );
  MUX2_X1 rem_22_U258 ( .A(rem_22_n167), .B(rem_22_n191), .S(rem_22_n192), .Z(
        rem_22_n168) );
  MUX2_X1 rem_22_U257 ( .A(rem_22_n168), .B(rem_22_n190), .S(rem_22_n151), .Z(
        rem_22_n170) );
  MUX2_X1 rem_22_U256 ( .A(rem_22_n170), .B(rem_22_n7), .S(rem_22_n150), .Z(
        rem_22_n173) );
  MUX2_X1 rem_22_U255 ( .A(rem_22_n173), .B(rem_22_n189), .S(rem_22_n149), .Z(
        rem_22_n177) );
  MUX2_X1 rem_22_U254 ( .A(rem_22_n177), .B(rem_22_n9), .S(rem_22_n152), .Z(
        rem_22_n182) );
  MUX2_X1 rem_22_U253 ( .A(rem_22_n182), .B(rem_22_n12), .S(rem_22_n2), .Z(
        rem_22_n188) );
  INV_X1 rem_22_U252 ( .A(rem_22_n188), .ZN(rem_22_u_div_PartRem_1__7_) );
  MUX2_X1 rem_22_U251 ( .A(rem_22_u_div_PartRem_1__7_), .B(
        rem_22_u_div_SumTmp_0__7_), .S(rem_22_n164), .Z(N7) );
  INV_X1 rem_22_U250 ( .A(rem_22_n186), .ZN(rem_22_u_div_PartRem_2__2_) );
  INV_X1 rem_22_U249 ( .A(rem_22_n185), .ZN(rem_22_u_div_PartRem_2__3_) );
  INV_X1 rem_22_U248 ( .A(rem_22_n184), .ZN(rem_22_u_div_PartRem_2__4_) );
  INV_X1 rem_22_U247 ( .A(rem_22_n183), .ZN(rem_22_u_div_PartRem_2__5_) );
  INV_X1 rem_22_U246 ( .A(rem_22_n182), .ZN(rem_22_u_div_PartRem_2__6_) );
  INV_X1 rem_22_U245 ( .A(rem_22_n180), .ZN(rem_22_u_div_PartRem_3__2_) );
  INV_X1 rem_22_U244 ( .A(rem_22_n179), .ZN(rem_22_u_div_PartRem_3__3_) );
  INV_X1 rem_22_U243 ( .A(rem_22_n178), .ZN(rem_22_u_div_PartRem_3__4_) );
  INV_X1 rem_22_U242 ( .A(rem_22_n177), .ZN(rem_22_u_div_PartRem_3__5_) );
  INV_X1 rem_22_U241 ( .A(rem_22_n176), .ZN(rem_22_u_div_PartRem_4__1_) );
  INV_X1 rem_22_U240 ( .A(rem_22_n175), .ZN(rem_22_u_div_PartRem_4__2_) );
  INV_X1 rem_22_U239 ( .A(rem_22_n174), .ZN(rem_22_u_div_PartRem_4__3_) );
  INV_X1 rem_22_U238 ( .A(rem_22_n173), .ZN(rem_22_u_div_PartRem_4__4_) );
  INV_X1 rem_22_U237 ( .A(rem_22_n171), .ZN(rem_22_u_div_PartRem_5__2_) );
  INV_X1 rem_22_U236 ( .A(rem_22_n170), .ZN(rem_22_u_div_PartRem_5__3_) );
  INV_X1 rem_22_U235 ( .A(rem_22_n168), .ZN(rem_22_u_div_PartRem_6__2_) );
  INV_X1 rem_22_U234 ( .A(rem_22_n1), .ZN(rem_22_n194) );
  NOR2_X1 rem_22_U233 ( .A1(rem_22_n194), .A2(rem_22_n193), .ZN(rem_22_n192)
         );
  INV_X1 rem_22_U232 ( .A(b[7]), .ZN(rem_22_u_div_BInv[7]) );
  NOR2_X1 rem_22_U231 ( .A1(b[6]), .A2(b[7]), .ZN(rem_22_n166) );
  NOR2_X1 rem_22_U230 ( .A1(b[6]), .A2(b[7]), .ZN(rem_22_n165) );
  CLKBUF_X1 rem_22_U229 ( .A(rem_22_n87), .Z(rem_22_n164) );
  INV_X1 rem_22_U228 ( .A(b[0]), .ZN(rem_22_u_div_BInv[0]) );
  CLKBUF_X1 rem_22_U227 ( .A(rem_22_u_div_BInv[0]), .Z(rem_22_n163) );
  NOR2_X1 rem_22_U226 ( .A1(b[5]), .A2(b[4]), .ZN(rem_22_n208) );
  XNOR2_X1 rem_22_U225 ( .A(rem_22_n162), .B(a[2]), .ZN(
        rem_22_u_div_SumTmp_2__0_) );
  XNOR2_X1 rem_22_U224 ( .A(rem_22_n163), .B(a[3]), .ZN(
        rem_22_u_div_SumTmp_3__0_) );
  XNOR2_X1 rem_22_U223 ( .A(rem_22_n163), .B(a[5]), .ZN(
        rem_22_u_div_SumTmp_5__0_) );
  XNOR2_X1 rem_22_U222 ( .A(rem_22_n162), .B(a[6]), .ZN(
        rem_22_u_div_SumTmp_6__0_) );
  XNOR2_X1 rem_22_U221 ( .A(rem_22_u_div_BInv[0]), .B(rem_22_n27), .ZN(
        rem_22_u_div_SumTmp_7__0_) );
  INV_X1 rem_22_U220 ( .A(a[7]), .ZN(rem_22_n154) );
  NAND2_X1 rem_22_U219 ( .A1(rem_22_n154), .A2(b[0]), .ZN(
        rem_22_u_div_CryTmp_7__1_) );
  NOR2_X1 rem_22_U218 ( .A1(b[2]), .A2(b[1]), .ZN(rem_22_n196) );
  XNOR2_X1 rem_22_U217 ( .A(rem_22_n163), .B(a[1]), .ZN(
        rem_22_u_div_SumTmp_1__0_) );
  INV_X1 rem_22_U216 ( .A(a[2]), .ZN(rem_22_n160) );
  NAND2_X1 rem_22_U215 ( .A1(rem_22_n159), .A2(rem_22_n160), .ZN(
        rem_22_u_div_CryTmp_2__1_) );
  INV_X1 rem_22_U214 ( .A(a[5]), .ZN(rem_22_n155) );
  NAND2_X1 rem_22_U213 ( .A1(rem_22_n156), .A2(rem_22_n155), .ZN(
        rem_22_u_div_CryTmp_5__1_) );
  MUX2_X1 rem_22_U212 ( .A(rem_22_n3), .B(rem_22_n157), .S(rem_22_n153), .Z(
        rem_22_n176) );
  XNOR2_X1 rem_22_U211 ( .A(rem_22_n162), .B(a[0]), .ZN(
        rem_22_u_div_SumTmp_0__0_) );
  OR2_X1 rem_22_U210 ( .A1(rem_22_n162), .A2(a[0]), .ZN(
        rem_22_u_div_CryTmp_0__1_) );
  INV_X1 rem_22_U209 ( .A(a[1]), .ZN(rem_22_n161) );
  NAND2_X1 rem_22_U208 ( .A1(rem_22_n159), .A2(rem_22_n161), .ZN(
        rem_22_u_div_CryTmp_1__1_) );
  INV_X1 rem_22_U207 ( .A(a[3]), .ZN(rem_22_n158) );
  NAND2_X1 rem_22_U206 ( .A1(rem_22_n159), .A2(rem_22_n158), .ZN(
        rem_22_u_div_CryTmp_3__1_) );
  INV_X1 rem_22_U205 ( .A(a[4]), .ZN(rem_22_n157) );
  NAND2_X1 rem_22_U204 ( .A1(rem_22_n156), .A2(rem_22_n157), .ZN(
        rem_22_u_div_CryTmp_4__1_) );
  INV_X1 rem_22_U203 ( .A(a[7]), .ZN(rem_22_n195) );
  NAND2_X1 rem_22_U202 ( .A1(rem_22_n32), .A2(rem_22_u_div_BInv[2]), .ZN(
        rem_22_n193) );
  INV_X1 rem_22_U201 ( .A(rem_22_u_div_SumTmp_5__1_), .ZN(rem_22_n199) );
  INV_X1 rem_22_U200 ( .A(rem_22_u_div_SumTmp_6__1_), .ZN(rem_22_n191) );
  INV_X1 rem_22_U199 ( .A(rem_22_u_div_SumTmp_3__1_), .ZN(rem_22_n207) );
  INV_X1 rem_22_U198 ( .A(rem_22_n162), .ZN(rem_22_n159) );
  INV_X1 rem_22_U197 ( .A(rem_22_n162), .ZN(rem_22_n156) );
  INV_X1 rem_22_U196 ( .A(rem_22_u_div_SumTmp_3__4_), .ZN(rem_22_n189) );
  INV_X1 rem_22_U195 ( .A(rem_22_u_div_SumTmp_3__3_), .ZN(rem_22_n198) );
  INV_X1 rem_22_U194 ( .A(rem_22_u_div_SumTmp_2__3_), .ZN(rem_22_n202) );
  INV_X1 rem_22_U193 ( .A(rem_22_u_div_SumTmp_5__2_), .ZN(rem_22_n190) );
  INV_X1 rem_22_U192 ( .A(rem_22_u_div_SumTmp_2__2_), .ZN(rem_22_n206) );
  AND2_X1 rem_22_U191 ( .A1(rem_22_u_div_CryTmp_5__3_), .A2(rem_22_n32), .ZN(
        rem_22_n151) );
  AND2_X1 rem_22_U190 ( .A1(rem_22_n64), .A2(rem_22_n29), .ZN(rem_22_n150) );
  AND2_X1 rem_22_U189 ( .A1(rem_22_u_div_CryTmp_3__5_), .A2(rem_22_n18), .ZN(
        rem_22_n149) );
  AND2_X1 rem_22_U188 ( .A1(rem_22_n122), .A2(rem_22_n148), .ZN(rem_22_n212)
         );
  NOR2_X1 rem_22_U187 ( .A1(b[6]), .A2(b[7]), .ZN(rem_22_n147) );
  AND2_X1 rem_22_U186 ( .A1(rem_22_u_div_CryTmp_2__6_), .A2(rem_22_n147), .ZN(
        rem_22_n211) );
  AND2_X1 rem_22_U185 ( .A1(rem_22_u_div_CryTmp_5__3_), .A2(rem_22_n32), .ZN(
        rem_22_n203) );
  MUX2_X2 rem_22_U184 ( .A(a[3]), .B(rem_22_u_div_SumTmp_3__0_), .S(
        rem_22_n146), .Z(rem_22_n145) );
  INV_X2 rem_22_U183 ( .A(b[1]), .ZN(rem_22_u_div_BInv[1]) );
  INV_X2 rem_22_U182 ( .A(b[5]), .ZN(rem_22_u_div_BInv[5]) );
  NAND3_X1 rem_22_U181 ( .A1(rem_22_n143), .A2(rem_22_n142), .A3(rem_22_n144), 
        .ZN(rem_22_u_div_CryTmp_2__2_) );
  NAND2_X1 rem_22_U180 ( .A1(rem_22_u_div_CryTmp_2__1_), .A2(
        rem_22_u_div_BInv[1]), .ZN(rem_22_n144) );
  NAND2_X1 rem_22_U179 ( .A1(rem_22_n145), .A2(rem_22_u_div_BInv[1]), .ZN(
        rem_22_n143) );
  NAND2_X1 rem_22_U178 ( .A1(rem_22_n145), .A2(rem_22_u_div_CryTmp_2__1_), 
        .ZN(rem_22_n142) );
  XOR2_X1 rem_22_U177 ( .A(rem_22_u_div_CryTmp_2__1_), .B(rem_22_u_div_BInv[1]), .Z(rem_22_n141) );
  NAND3_X1 rem_22_U176 ( .A1(rem_22_n139), .A2(rem_22_n138), .A3(rem_22_n140), 
        .ZN(rem_22_u_div_CryTmp_3__3_) );
  NAND2_X1 rem_22_U175 ( .A1(rem_22_u_div_PartRem_4__2_), .A2(
        rem_22_u_div_BInv[2]), .ZN(rem_22_n140) );
  NAND2_X1 rem_22_U174 ( .A1(rem_22_n42), .A2(rem_22_u_div_BInv[2]), .ZN(
        rem_22_n139) );
  NAND2_X1 rem_22_U173 ( .A1(rem_22_u_div_CryTmp_3__2_), .A2(
        rem_22_u_div_PartRem_4__2_), .ZN(rem_22_n138) );
  XOR2_X1 rem_22_U172 ( .A(rem_22_u_div_PartRem_4__2_), .B(
        rem_22_u_div_BInv[2]), .Z(rem_22_n137) );
  NAND2_X1 rem_22_U171 ( .A1(rem_22_u_div_BInv[6]), .A2(rem_22_n86), .ZN(
        rem_22_n136) );
  NAND2_X1 rem_22_U170 ( .A1(rem_22_u_div_CryTmp_1__6_), .A2(
        rem_22_u_div_PartRem_2__6_), .ZN(rem_22_n135) );
  NAND2_X1 rem_22_U169 ( .A1(rem_22_u_div_PartRem_2__6_), .A2(
        rem_22_u_div_BInv[6]), .ZN(rem_22_n134) );
  XOR2_X1 rem_22_U168 ( .A(rem_22_u_div_PartRem_2__6_), .B(
        rem_22_u_div_BInv[6]), .Z(rem_22_n133) );
  NAND3_X1 rem_22_U167 ( .A1(rem_22_n132), .A2(rem_22_n131), .A3(rem_22_n130), 
        .ZN(rem_22_u_div_CryTmp_1__6_) );
  NAND2_X1 rem_22_U166 ( .A1(rem_22_n58), .A2(rem_22_u_div_BInv[5]), .ZN(
        rem_22_n132) );
  NAND2_X1 rem_22_U165 ( .A1(rem_22_u_div_CryTmp_1__5_), .A2(
        rem_22_u_div_PartRem_2__5_), .ZN(rem_22_n131) );
  NAND2_X1 rem_22_U164 ( .A1(rem_22_u_div_PartRem_2__5_), .A2(
        rem_22_u_div_BInv[5]), .ZN(rem_22_n130) );
  XOR2_X1 rem_22_U163 ( .A(rem_22_u_div_PartRem_2__5_), .B(
        rem_22_u_div_BInv[5]), .Z(rem_22_n129) );
  NAND3_X1 rem_22_U162 ( .A1(rem_22_n126), .A2(rem_22_n127), .A3(rem_22_n128), 
        .ZN(rem_22_u_div_CryTmp_0__6_) );
  NAND2_X1 rem_22_U161 ( .A1(rem_22_u_div_PartRem_1__5_), .A2(
        rem_22_u_div_BInv[5]), .ZN(rem_22_n128) );
  NAND2_X1 rem_22_U160 ( .A1(rem_22_u_div_CryTmp_0__5_), .A2(
        rem_22_u_div_BInv[5]), .ZN(rem_22_n127) );
  NAND2_X1 rem_22_U159 ( .A1(rem_22_n54), .A2(rem_22_u_div_PartRem_1__5_), 
        .ZN(rem_22_n126) );
  XOR2_X1 rem_22_U158 ( .A(rem_22_n55), .B(rem_22_n125), .Z(
        rem_22_u_div_SumTmp_0__5_) );
  XOR2_X1 rem_22_U157 ( .A(rem_22_u_div_PartRem_1__5_), .B(
        rem_22_u_div_BInv[5]), .Z(rem_22_n125) );
  INV_X1 rem_22_U156 ( .A(rem_22_n124), .ZN(rem_22_n204) );
  MUX2_X2 rem_22_U155 ( .A(a[2]), .B(rem_22_u_div_SumTmp_2__0_), .S(
        rem_22_n211), .Z(rem_22_n123) );
  NAND2_X1 rem_22_U154 ( .A1(rem_22_u_div_CryTmp_4__4_), .A2(rem_22_n29), .ZN(
        rem_22_n153) );
  INV_X1 rem_22_U153 ( .A(b[7]), .ZN(rem_22_n148) );
  INV_X1 rem_22_U152 ( .A(rem_22_n33), .ZN(rem_22_n181) );
  NAND3_X1 rem_22_U151 ( .A1(rem_22_n135), .A2(rem_22_n136), .A3(rem_22_n134), 
        .ZN(rem_22_n122) );
  NAND3_X1 rem_22_U150 ( .A1(rem_22_n120), .A2(rem_22_n121), .A3(rem_22_n119), 
        .ZN(rem_22_u_div_CryTmp_4__4_) );
  NAND2_X1 rem_22_U149 ( .A1(rem_22_n85), .A2(rem_22_u_div_BInv[3]), .ZN(
        rem_22_n121) );
  NAND2_X1 rem_22_U148 ( .A1(rem_22_u_div_CryTmp_4__3_), .A2(
        rem_22_u_div_PartRem_5__3_), .ZN(rem_22_n120) );
  NAND2_X1 rem_22_U147 ( .A1(rem_22_u_div_PartRem_5__3_), .A2(
        rem_22_u_div_BInv[3]), .ZN(rem_22_n119) );
  XOR2_X1 rem_22_U146 ( .A(rem_22_u_div_PartRem_5__3_), .B(
        rem_22_u_div_BInv[3]), .Z(rem_22_n118) );
  NAND3_X1 rem_22_U145 ( .A1(rem_22_n116), .A2(rem_22_n117), .A3(rem_22_n115), 
        .ZN(rem_22_u_div_CryTmp_4__3_) );
  NAND2_X1 rem_22_U144 ( .A1(rem_22_n56), .A2(rem_22_u_div_BInv[2]), .ZN(
        rem_22_n117) );
  NAND2_X1 rem_22_U143 ( .A1(rem_22_u_div_CryTmp_4__2_), .A2(
        rem_22_u_div_PartRem_5__2_), .ZN(rem_22_n116) );
  NAND2_X1 rem_22_U142 ( .A1(rem_22_u_div_PartRem_5__2_), .A2(
        rem_22_u_div_BInv[2]), .ZN(rem_22_n115) );
  XOR2_X1 rem_22_U141 ( .A(rem_22_u_div_PartRem_5__2_), .B(
        rem_22_u_div_BInv[2]), .Z(rem_22_n114) );
  NAND3_X1 rem_22_U140 ( .A1(rem_22_n112), .A2(rem_22_n111), .A3(rem_22_n113), 
        .ZN(rem_22_u_div_CryTmp_1__4_) );
  NAND2_X1 rem_22_U139 ( .A1(rem_22_u_div_PartRem_2__3_), .A2(
        rem_22_u_div_BInv[3]), .ZN(rem_22_n113) );
  NAND2_X1 rem_22_U138 ( .A1(rem_22_u_div_CryTmp_1__3_), .A2(
        rem_22_u_div_BInv[3]), .ZN(rem_22_n112) );
  NAND2_X1 rem_22_U137 ( .A1(rem_22_n70), .A2(rem_22_u_div_PartRem_2__3_), 
        .ZN(rem_22_n111) );
  XOR2_X1 rem_22_U136 ( .A(rem_22_u_div_PartRem_2__3_), .B(
        rem_22_u_div_BInv[3]), .Z(rem_22_n110) );
  NAND3_X1 rem_22_U135 ( .A1(rem_22_n107), .A2(rem_22_n108), .A3(rem_22_n109), 
        .ZN(rem_22_u_div_CryTmp_0__4_) );
  NAND2_X1 rem_22_U134 ( .A1(rem_22_u_div_PartRem_1__3_), .A2(
        rem_22_u_div_BInv[3]), .ZN(rem_22_n109) );
  NAND2_X1 rem_22_U133 ( .A1(rem_22_u_div_CryTmp_0__3_), .A2(
        rem_22_u_div_BInv[3]), .ZN(rem_22_n108) );
  NAND2_X1 rem_22_U132 ( .A1(rem_22_u_div_CryTmp_0__3_), .A2(
        rem_22_u_div_PartRem_1__3_), .ZN(rem_22_n107) );
  XOR2_X1 rem_22_U131 ( .A(rem_22_n52), .B(rem_22_n106), .Z(
        rem_22_u_div_SumTmp_0__3_) );
  XOR2_X1 rem_22_U130 ( .A(rem_22_u_div_PartRem_1__3_), .B(
        rem_22_u_div_BInv[3]), .Z(rem_22_n106) );
  INV_X2 rem_22_U129 ( .A(b[4]), .ZN(rem_22_u_div_BInv[4]) );
  INV_X2 rem_22_U128 ( .A(b[6]), .ZN(rem_22_u_div_BInv[6]) );
  NAND3_X1 rem_22_U127 ( .A1(rem_22_n103), .A2(rem_22_n104), .A3(rem_22_n105), 
        .ZN(rem_22_u_div_CryTmp_2__5_) );
  NAND2_X1 rem_22_U126 ( .A1(rem_22_u_div_PartRem_3__4_), .A2(
        rem_22_u_div_BInv[4]), .ZN(rem_22_n105) );
  NAND2_X1 rem_22_U125 ( .A1(rem_22_u_div_CryTmp_2__4_), .A2(
        rem_22_u_div_BInv[4]), .ZN(rem_22_n104) );
  NAND2_X1 rem_22_U124 ( .A1(rem_22_u_div_CryTmp_2__4_), .A2(
        rem_22_u_div_PartRem_3__4_), .ZN(rem_22_n103) );
  XOR2_X1 rem_22_U123 ( .A(rem_22_u_div_PartRem_3__4_), .B(
        rem_22_u_div_BInv[4]), .Z(rem_22_n102) );
  NAND3_X1 rem_22_U122 ( .A1(rem_22_n99), .A2(rem_22_n100), .A3(rem_22_n101), 
        .ZN(rem_22_u_div_CryTmp_1__2_) );
  NAND2_X1 rem_22_U121 ( .A1(rem_22_u_div_CryTmp_1__1_), .A2(
        rem_22_u_div_BInv[1]), .ZN(rem_22_n101) );
  NAND2_X1 rem_22_U120 ( .A1(rem_22_n123), .A2(rem_22_u_div_BInv[1]), .ZN(
        rem_22_n100) );
  NAND2_X1 rem_22_U119 ( .A1(rem_22_n123), .A2(rem_22_u_div_CryTmp_1__1_), 
        .ZN(rem_22_n99) );
  XOR2_X1 rem_22_U118 ( .A(rem_22_u_div_CryTmp_1__1_), .B(rem_22_u_div_BInv[1]), .Z(rem_22_n98) );
  NAND3_X1 rem_22_U117 ( .A1(rem_22_n95), .A2(rem_22_n96), .A3(rem_22_n97), 
        .ZN(rem_22_u_div_CryTmp_0__7_) );
  NAND2_X1 rem_22_U116 ( .A1(rem_22_u_div_PartRem_1__6_), .A2(
        rem_22_u_div_BInv[6]), .ZN(rem_22_n97) );
  NAND2_X1 rem_22_U115 ( .A1(rem_22_u_div_CryTmp_0__6_), .A2(
        rem_22_u_div_BInv[6]), .ZN(rem_22_n96) );
  NAND2_X1 rem_22_U114 ( .A1(rem_22_n50), .A2(rem_22_u_div_PartRem_1__6_), 
        .ZN(rem_22_n95) );
  XOR2_X1 rem_22_U113 ( .A(rem_22_n83), .B(rem_22_n94), .Z(
        rem_22_u_div_SumTmp_0__6_) );
  XOR2_X1 rem_22_U112 ( .A(rem_22_u_div_PartRem_1__6_), .B(
        rem_22_u_div_BInv[6]), .Z(rem_22_n94) );
  NAND3_X1 rem_22_U111 ( .A1(rem_22_n92), .A2(rem_22_n91), .A3(rem_22_n93), 
        .ZN(rem_22_u_div_CryTmp_2__6_) );
  NAND2_X1 rem_22_U110 ( .A1(rem_22_u_div_PartRem_3__5_), .A2(
        rem_22_u_div_BInv[5]), .ZN(rem_22_n93) );
  NAND2_X1 rem_22_U109 ( .A1(rem_22_u_div_CryTmp_2__5_), .A2(
        rem_22_u_div_BInv[5]), .ZN(rem_22_n92) );
  NAND2_X1 rem_22_U108 ( .A1(rem_22_n84), .A2(rem_22_u_div_PartRem_3__5_), 
        .ZN(rem_22_n91) );
  XOR2_X1 rem_22_U107 ( .A(rem_22_u_div_PartRem_3__5_), .B(
        rem_22_u_div_BInv[5]), .Z(rem_22_n90) );
  INV_X1 rem_22_U106 ( .A(rem_22_n34), .ZN(rem_22_n187) );
  CLKBUF_X1 rem_22_U105 ( .A(rem_22_n176), .Z(rem_22_n89) );
  MUX2_X1 rem_22_U104 ( .A(a[5]), .B(rem_22_u_div_SumTmp_5__0_), .S(
        rem_22_n203), .Z(rem_22_n88) );
  INV_X1 rem_22_U103 ( .A(rem_22_n60), .ZN(rem_22_n172) );
  FA_X1 rem_22_U102 ( .A(rem_22_u_div_PartRem_1__7_), .B(rem_22_u_div_BInv[7]), 
        .CI(rem_22_n53), .CO(rem_22_n87) );
  NAND3_X1 rem_22_U101 ( .A1(rem_22_n132), .A2(rem_22_n131), .A3(rem_22_n130), 
        .ZN(rem_22_n86) );
  NAND3_X1 rem_22_U100 ( .A1(rem_22_n116), .A2(rem_22_n117), .A3(rem_22_n115), 
        .ZN(rem_22_n85) );
  NAND3_X1 rem_22_U99 ( .A1(rem_22_n104), .A2(rem_22_n103), .A3(rem_22_n105), 
        .ZN(rem_22_n84) );
  CLKBUF_X1 rem_22_U98 ( .A(rem_22_n50), .Z(rem_22_n83) );
  NAND3_X1 rem_22_U97 ( .A1(rem_22_n80), .A2(rem_22_n81), .A3(rem_22_n82), 
        .ZN(rem_22_u_div_CryTmp_4__2_) );
  NAND2_X1 rem_22_U96 ( .A1(rem_22_u_div_CryTmp_4__1_), .A2(
        rem_22_u_div_BInv[1]), .ZN(rem_22_n82) );
  NAND2_X1 rem_22_U95 ( .A1(rem_22_n88), .A2(rem_22_u_div_BInv[1]), .ZN(
        rem_22_n81) );
  NAND2_X1 rem_22_U94 ( .A1(rem_22_n37), .A2(rem_22_u_div_CryTmp_4__1_), .ZN(
        rem_22_n80) );
  XOR2_X1 rem_22_U93 ( .A(rem_22_u_div_CryTmp_4__1_), .B(rem_22_u_div_BInv[1]), 
        .Z(rem_22_n79) );
  NAND3_X1 rem_22_U92 ( .A1(rem_22_n77), .A2(rem_22_n76), .A3(rem_22_n78), 
        .ZN(rem_22_u_div_CryTmp_1__5_) );
  NAND2_X1 rem_22_U91 ( .A1(rem_22_u_div_PartRem_2__4_), .A2(
        rem_22_u_div_BInv[4]), .ZN(rem_22_n78) );
  NAND2_X1 rem_22_U90 ( .A1(rem_22_u_div_CryTmp_1__4_), .A2(
        rem_22_u_div_BInv[4]), .ZN(rem_22_n77) );
  NAND2_X1 rem_22_U89 ( .A1(rem_22_n63), .A2(rem_22_u_div_PartRem_2__4_), .ZN(
        rem_22_n76) );
  XOR2_X1 rem_22_U88 ( .A(rem_22_u_div_PartRem_2__4_), .B(rem_22_u_div_BInv[4]), .Z(rem_22_n75) );
  NAND3_X1 rem_22_U87 ( .A1(rem_22_n72), .A2(rem_22_n73), .A3(rem_22_n74), 
        .ZN(rem_22_u_div_CryTmp_1__3_) );
  NAND2_X1 rem_22_U86 ( .A1(rem_22_u_div_PartRem_2__2_), .A2(
        rem_22_u_div_BInv[2]), .ZN(rem_22_n74) );
  NAND2_X1 rem_22_U85 ( .A1(rem_22_u_div_CryTmp_1__2_), .A2(
        rem_22_u_div_BInv[2]), .ZN(rem_22_n73) );
  NAND2_X1 rem_22_U84 ( .A1(rem_22_n48), .A2(rem_22_u_div_PartRem_2__2_), .ZN(
        rem_22_n72) );
  XOR2_X1 rem_22_U83 ( .A(rem_22_u_div_PartRem_2__2_), .B(rem_22_u_div_BInv[2]), .Z(rem_22_n71) );
  AND2_X1 rem_22_U82 ( .A1(rem_22_u_div_CryTmp_2__6_), .A2(rem_22_n39), .ZN(
        rem_22_n152) );
  NAND3_X1 rem_22_U81 ( .A1(rem_22_n72), .A2(rem_22_n73), .A3(rem_22_n74), 
        .ZN(rem_22_n70) );
  CLKBUF_X1 rem_22_U80 ( .A(rem_22_n48), .Z(rem_22_n69) );
  NAND3_X1 rem_22_U79 ( .A1(rem_22_n66), .A2(rem_22_n67), .A3(rem_22_n68), 
        .ZN(rem_22_u_div_CryTmp_0__5_) );
  NAND2_X1 rem_22_U78 ( .A1(rem_22_u_div_PartRem_1__4_), .A2(
        rem_22_u_div_BInv[4]), .ZN(rem_22_n68) );
  NAND2_X1 rem_22_U77 ( .A1(rem_22_u_div_CryTmp_0__4_), .A2(
        rem_22_u_div_BInv[4]), .ZN(rem_22_n67) );
  NAND2_X1 rem_22_U76 ( .A1(rem_22_n49), .A2(rem_22_u_div_PartRem_1__4_), .ZN(
        rem_22_n66) );
  XOR2_X1 rem_22_U75 ( .A(rem_22_n61), .B(rem_22_n65), .Z(
        rem_22_u_div_SumTmp_0__4_) );
  XOR2_X1 rem_22_U74 ( .A(rem_22_u_div_PartRem_1__4_), .B(rem_22_u_div_BInv[4]), .Z(rem_22_n65) );
  CLKBUF_X1 rem_22_U73 ( .A(rem_22_u_div_CryTmp_4__4_), .Z(rem_22_n64) );
  MUX2_X1 rem_22_U72 ( .A(a[1]), .B(rem_22_u_div_SumTmp_1__0_), .S(rem_22_n212), .Z(rem_22_u_div_PartRem_1__1_) );
  NAND3_X1 rem_22_U71 ( .A1(rem_22_n111), .A2(rem_22_n112), .A3(rem_22_n113), 
        .ZN(rem_22_n63) );
  MUX2_X2 rem_22_U70 ( .A(rem_22_u_div_PartRem_1__2_), .B(
        rem_22_u_div_SumTmp_0__2_), .S(rem_22_n26), .Z(N2) );
  MUX2_X2 rem_22_U69 ( .A(rem_22_u_div_PartRem_1__3_), .B(
        rem_22_u_div_SumTmp_0__3_), .S(rem_22_u_div_CryTmp_0__8_), .Z(N3) );
  CLKBUF_X1 rem_22_U68 ( .A(rem_22_n49), .Z(rem_22_n61) );
  CLKBUF_X1 rem_22_U67 ( .A(rem_22_n37), .Z(rem_22_n60) );
  NAND3_X1 rem_22_U66 ( .A1(rem_22_n46), .A2(rem_22_n76), .A3(rem_22_n78), 
        .ZN(rem_22_n59) );
  NAND3_X1 rem_22_U65 ( .A1(rem_22_n77), .A2(rem_22_n76), .A3(rem_22_n78), 
        .ZN(rem_22_n58) );
  NAND3_X1 rem_22_U64 ( .A1(rem_22_n36), .A2(rem_22_n81), .A3(rem_22_n82), 
        .ZN(rem_22_n57) );
  NAND3_X1 rem_22_U63 ( .A1(rem_22_n81), .A2(rem_22_n35), .A3(rem_22_n82), 
        .ZN(rem_22_n56) );
  NAND3_X1 rem_22_U62 ( .A1(rem_22_n45), .A2(rem_22_n31), .A3(rem_22_n68), 
        .ZN(rem_22_n55) );
  NAND3_X1 rem_22_U61 ( .A1(rem_22_n38), .A2(rem_22_n67), .A3(rem_22_n68), 
        .ZN(rem_22_n54) );
  NAND3_X1 rem_22_U60 ( .A1(rem_22_n95), .A2(rem_22_n96), .A3(rem_22_n97), 
        .ZN(rem_22_n53) );
  AND2_X1 rem_22_U59 ( .A1(rem_22_u_div_CryTmp_3__5_), .A2(rem_22_n18), .ZN(
        rem_22_n146) );
  NAND3_X1 rem_22_U58 ( .A1(rem_22_n126), .A2(rem_22_n127), .A3(rem_22_n128), 
        .ZN(rem_22_n50) );
  NAND3_X1 rem_22_U57 ( .A1(rem_22_n108), .A2(rem_22_n107), .A3(rem_22_n109), 
        .ZN(rem_22_n49) );
  NAND3_X1 rem_22_U56 ( .A1(rem_22_n100), .A2(rem_22_n99), .A3(rem_22_n101), 
        .ZN(rem_22_n48) );
  CLKBUF_X1 rem_22_U55 ( .A(rem_22_u_div_CryTmp_4__3_), .Z(rem_22_n47) );
  CLKBUF_X1 rem_22_U54 ( .A(rem_22_n77), .Z(rem_22_n46) );
  CLKBUF_X1 rem_22_U53 ( .A(rem_22_n38), .Z(rem_22_n45) );
  CLKBUF_X1 rem_22_U52 ( .A(rem_22_u_div_CryTmp_1__6_), .Z(rem_22_n44) );
  CLKBUF_X1 rem_22_U51 ( .A(rem_22_u_div_CryTmp_2__5_), .Z(rem_22_n43) );
  FA_X1 rem_22_U50 ( .A(rem_22_u_div_CryTmp_3__1_), .B(rem_22_u_div_BInv[1]), 
        .CI(rem_22_u_div_PartRem_4__1_), .CO(rem_22_n42) );
  CLKBUF_X1 rem_22_U49 ( .A(rem_22_u_div_CryTmp_0__3_), .Z(rem_22_n52) );
  CLKBUF_X1 rem_22_U48 ( .A(rem_22_u_div_CryTmp_2__4_), .Z(rem_22_n51) );
  CLKBUF_X1 rem_22_U47 ( .A(rem_22_u_div_CryTmp_1__4_), .Z(rem_22_n41) );
  CLKBUF_X1 rem_22_U46 ( .A(rem_22_u_div_CryTmp_1__3_), .Z(rem_22_n40) );
  NOR2_X1 rem_22_U45 ( .A1(b[6]), .A2(b[7]), .ZN(rem_22_n39) );
  NAND2_X1 rem_22_U44 ( .A1(rem_22_n49), .A2(rem_22_u_div_PartRem_1__4_), .ZN(
        rem_22_n38) );
  MUX2_X1 rem_22_U43 ( .A(a[5]), .B(rem_22_u_div_SumTmp_5__0_), .S(rem_22_n203), .Z(rem_22_n37) );
  CLKBUF_X1 rem_22_U42 ( .A(rem_22_n80), .Z(rem_22_n36) );
  NAND2_X1 rem_22_U41 ( .A1(rem_22_n37), .A2(rem_22_u_div_CryTmp_4__1_), .ZN(
        rem_22_n35) );
  CLKBUF_X1 rem_22_U40 ( .A(rem_22_n42), .Z(rem_22_n62) );
  CLKBUF_X1 rem_22_U39 ( .A(rem_22_n123), .Z(rem_22_n34) );
  CLKBUF_X1 rem_22_U38 ( .A(rem_22_n145), .Z(rem_22_n33) );
  AND2_X1 rem_22_U37 ( .A1(rem_22_n29), .A2(rem_22_u_div_BInv[3]), .ZN(
        rem_22_n32) );
  CLKBUF_X1 rem_22_U36 ( .A(rem_22_n67), .Z(rem_22_n31) );
  CLKBUF_X1 rem_22_U35 ( .A(rem_22_u_div_PartRem_1__1_), .Z(rem_22_n30) );
  AND2_X1 rem_22_U34 ( .A1(rem_22_n208), .A2(rem_22_n166), .ZN(rem_22_n124) );
  INV_X1 rem_22_U33 ( .A(rem_22_n204), .ZN(rem_22_n29) );
  INV_X1 rem_22_U32 ( .A(rem_22_n195), .ZN(rem_22_n27) );
  FA_X1 rem_22_U31 ( .A(rem_22_u_div_PartRem_1__7_), .B(rem_22_u_div_BInv[7]), 
        .CI(rem_22_u_div_CryTmp_0__7_), .CO(rem_22_n26) );
  NAND2_X1 rem_22_U30 ( .A1(rem_22_n28), .A2(rem_22_n124), .ZN(rem_22_n25) );
  MUX2_X1 rem_22_U29 ( .A(rem_22_u_div_SumTmp_7__0_), .B(rem_22_n27), .S(
        rem_22_n25), .Z(rem_22_n24) );
  INV_X1 rem_22_U28 ( .A(rem_22_n23), .ZN(rem_22_n167) );
  CLKBUF_X1 rem_22_U27 ( .A(rem_22_n24), .Z(rem_22_n23) );
  MUX2_X1 rem_22_U26 ( .A(a[6]), .B(rem_22_u_div_SumTmp_6__0_), .S(rem_22_n200), .Z(rem_22_n22) );
  CLKBUF_X1 rem_22_U25 ( .A(rem_22_n22), .Z(rem_22_n21) );
  INV_X1 rem_22_U24 ( .A(rem_22_n193), .ZN(rem_22_n20) );
  AND2_X1 rem_22_U23 ( .A1(rem_22_u_div_CryTmp_6__2_), .A2(rem_22_n20), .ZN(
        rem_22_n200) );
  INV_X1 rem_22_U22 ( .A(b[3]), .ZN(rem_22_n19) );
  AND3_X1 rem_22_U21 ( .A1(rem_22_u_div_CryTmp_7__1_), .A2(rem_22_n196), .A3(
        rem_22_n19), .ZN(rem_22_n28) );
  BUF_X2 rem_22_U20 ( .A(rem_22_u_div_BInv[0]), .Z(rem_22_n162) );
  AND2_X1 rem_22_U19 ( .A1(rem_22_n165), .A2(rem_22_u_div_BInv[5]), .ZN(
        rem_22_n18) );
  XNOR2_X1 rem_22_U18 ( .A(rem_22_n129), .B(rem_22_n59), .ZN(rem_22_n17) );
  XNOR2_X1 rem_22_U17 ( .A(rem_22_n41), .B(rem_22_n75), .ZN(rem_22_n16) );
  XNOR2_X1 rem_22_U16 ( .A(rem_22_n40), .B(rem_22_n110), .ZN(rem_22_n15) );
  XNOR2_X1 rem_22_U15 ( .A(rem_22_n69), .B(rem_22_n71), .ZN(rem_22_n14) );
  XNOR2_X1 rem_22_U14 ( .A(rem_22_n34), .B(rem_22_n98), .ZN(rem_22_n13) );
  XNOR2_X1 rem_22_U13 ( .A(rem_22_n133), .B(rem_22_n44), .ZN(rem_22_n12) );
  XNOR2_X1 rem_22_U12 ( .A(rem_22_n33), .B(rem_22_n141), .ZN(rem_22_n11) );
  XNOR2_X1 rem_22_U11 ( .A(rem_22_n51), .B(rem_22_n102), .ZN(rem_22_n10) );
  XNOR2_X1 rem_22_U10 ( .A(rem_22_n43), .B(rem_22_n90), .ZN(rem_22_n9) );
  XNOR2_X1 rem_22_U9 ( .A(rem_22_n62), .B(rem_22_n137), .ZN(rem_22_n8) );
  XNOR2_X1 rem_22_U8 ( .A(rem_22_n118), .B(rem_22_n47), .ZN(rem_22_n7) );
  XNOR2_X1 rem_22_U7 ( .A(rem_22_n114), .B(rem_22_n57), .ZN(rem_22_n6) );
  XNOR2_X1 rem_22_U6 ( .A(rem_22_n60), .B(rem_22_n79), .ZN(rem_22_n5) );
  OR2_X1 rem_22_U5 ( .A1(a[6]), .A2(rem_22_n162), .ZN(rem_22_n4) );
  XOR2_X1 rem_22_U4 ( .A(rem_22_n162), .B(a[4]), .Z(rem_22_n3) );
  AND2_X1 rem_22_U3 ( .A1(rem_22_n122), .A2(rem_22_u_div_BInv[7]), .ZN(
        rem_22_n2) );
  INV_X1 rem_22_U2 ( .A(rem_22_n21), .ZN(rem_22_n169) );
  CLKBUF_X1 rem_22_U1 ( .A(rem_22_u_div_CryTmp_6__2_), .Z(rem_22_n1) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_0_1 ( .A(rem_22_u_div_CryTmp_0__1_), .B(
        rem_22_u_div_BInv[1]), .CI(rem_22_u_div_PartRem_1__1_), .CO(
        rem_22_u_div_CryTmp_0__2_), .S(rem_22_u_div_SumTmp_0__1_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_0_2 ( .A(rem_22_u_div_PartRem_1__2_), .B(
        rem_22_u_div_BInv[2]), .CI(rem_22_u_div_CryTmp_0__2_), .CO(
        rem_22_u_div_CryTmp_0__3_), .S(rem_22_u_div_SumTmp_0__2_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_0_7 ( .A(rem_22_u_div_PartRem_1__7_), .B(
        rem_22_u_div_BInv[7]), .CI(rem_22_u_div_CryTmp_0__7_), .CO(
        rem_22_u_div_CryTmp_0__8_), .S(rem_22_u_div_SumTmp_0__7_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_2_2 ( .A(rem_22_u_div_PartRem_3__2_), .B(
        rem_22_u_div_BInv[2]), .CI(rem_22_u_div_CryTmp_2__2_), .CO(
        rem_22_u_div_CryTmp_2__3_), .S(rem_22_u_div_SumTmp_2__2_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_2_3 ( .A(rem_22_u_div_PartRem_3__3_), .B(
        rem_22_u_div_BInv[3]), .CI(rem_22_u_div_CryTmp_2__3_), .CO(
        rem_22_u_div_CryTmp_2__4_), .S(rem_22_u_div_SumTmp_2__3_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_3_1 ( .A(rem_22_u_div_CryTmp_3__1_), .B(
        rem_22_u_div_BInv[1]), .CI(rem_22_u_div_PartRem_4__1_), .CO(
        rem_22_u_div_CryTmp_3__2_), .S(rem_22_u_div_SumTmp_3__1_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_3_3 ( .A(rem_22_u_div_PartRem_4__3_), .B(
        rem_22_u_div_BInv[3]), .CI(rem_22_u_div_CryTmp_3__3_), .CO(
        rem_22_u_div_CryTmp_3__4_), .S(rem_22_u_div_SumTmp_3__3_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_3_4 ( .A(rem_22_u_div_PartRem_4__4_), .B(
        rem_22_u_div_BInv[4]), .CI(rem_22_u_div_CryTmp_3__4_), .CO(
        rem_22_u_div_CryTmp_3__5_), .S(rem_22_u_div_SumTmp_3__4_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_5_1 ( .A(rem_22_u_div_CryTmp_5__1_), .B(
        rem_22_u_div_BInv[1]), .CI(rem_22_n22), .CO(rem_22_u_div_CryTmp_5__2_), 
        .S(rem_22_u_div_SumTmp_5__1_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_5_2 ( .A(rem_22_u_div_PartRem_6__2_), .B(
        rem_22_u_div_BInv[2]), .CI(rem_22_u_div_CryTmp_5__2_), .CO(
        rem_22_u_div_CryTmp_5__3_), .S(rem_22_u_div_SumTmp_5__2_) );
  FA_X1 rem_22_u_div_u_fa_PartRem_0_6_1 ( .A(rem_22_n4), .B(
        rem_22_u_div_BInv[1]), .CI(rem_22_n24), .CO(rem_22_u_div_CryTmp_6__2_), 
        .S(rem_22_u_div_SumTmp_6__1_) );
endmodule

