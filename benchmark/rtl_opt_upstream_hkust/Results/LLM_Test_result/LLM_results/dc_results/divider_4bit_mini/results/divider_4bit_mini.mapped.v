/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:08:02 2025
/////////////////////////////////////////////////////////////


module divider_4bit_mini ( A, B, result, odd );
  input [3:0] A;
  input [1:0] B;
  output [3:0] result;
  output [3:0] odd;
  wire   div_14_n12, div_14_n11, div_14_n10, div_14_n9, div_14_n8, div_14_n7,
         div_14_n6, div_14_n5, div_14_n3, div_14_n2, div_14_n1,
         div_14_u_div_PartRem_4__2_, div_14_u_div_PartRem_4__1_,
         div_14_u_div_PartRem_3__2_, div_14_u_div_PartRem_3__1_,
         div_14_u_div_PartRem_2__2_, div_14_u_div_PartRem_2__1_,
         div_14_u_div_PartRem_1__2_, div_14_u_div_PartRem_1__1_,
         div_14_u_div_CryTmp_3__2_, div_14_u_div_CryTmp_3__1_,
         div_14_u_div_CryTmp_2__2_, div_14_u_div_CryTmp_2__1_,
         div_14_u_div_CryTmp_1__2_, div_14_u_div_CryTmp_1__1_,
         div_14_u_div_CryTmp_0__2_, div_14_u_div_CryTmp_0__1_,
         div_14_u_div_SumTmp_3__1_, div_14_u_div_SumTmp_3__0_,
         div_14_u_div_SumTmp_2__1_, div_14_u_div_SumTmp_2__0_,
         div_14_u_div_SumTmp_1__1_, div_14_u_div_SumTmp_1__0_, div_14_n13,
         rem_13_n73, rem_13_n72, rem_13_n71, rem_13_n70, rem_13_n69,
         rem_13_n68, rem_13_n67, rem_13_n66, rem_13_n65, rem_13_n64,
         rem_13_n63, rem_13_n62, rem_13_n61, rem_13_n60, rem_13_n59,
         rem_13_n58, rem_13_n57, rem_13_n56, rem_13_n55, rem_13_n54,
         rem_13_n53, rem_13_n52, rem_13_n51, rem_13_n50, rem_13_n49,
         rem_13_n48, rem_13_n47, rem_13_n46, rem_13_n45, rem_13_n44,
         rem_13_n43, rem_13_n42, rem_13_n41, rem_13_n40, rem_13_n39,
         rem_13_n38, rem_13_n37, rem_13_n36, rem_13_n35, rem_13_n34,
         rem_13_n33, rem_13_n32, rem_13_n31, rem_13_n30, rem_13_n29,
         rem_13_n28, rem_13_n27, rem_13_n26, rem_13_n25, rem_13_n24,
         rem_13_n23, rem_13_n22, rem_13_n21, rem_13_n20, rem_13_n19,
         rem_13_n18, rem_13_n17, rem_13_n16, rem_13_n15, rem_13_n14,
         rem_13_n13, rem_13_n12, rem_13_n11, rem_13_n10, rem_13_n9, rem_13_n8,
         rem_13_n7, rem_13_n6, rem_13_n5, rem_13_n4, rem_13_n3, rem_13_n2,
         rem_13_n1, rem_13_u_div_PartRem_4__2_, rem_13_u_div_PartRem_3__3_,
         rem_13_u_div_PartRem_3__2_, rem_13_u_div_PartRem_3__1_,
         rem_13_u_div_PartRem_2__4_, rem_13_u_div_PartRem_2__3_,
         rem_13_u_div_PartRem_2__2_, rem_13_u_div_PartRem_2__1_,
         rem_13_u_div_PartRem_1__4_, rem_13_u_div_PartRem_1__3_,
         rem_13_u_div_PartRem_1__2_, rem_13_u_div_PartRem_1__1_,
         rem_13_u_div_CryTmp_3__3_, rem_13_u_div_CryTmp_2__4_,
         rem_13_u_div_CryTmp_2__3_, rem_13_u_div_CryTmp_2__2_,
         rem_13_u_div_CryTmp_2__1_, rem_13_u_div_CryTmp_1__3_,
         rem_13_u_div_CryTmp_1__2_, rem_13_u_div_CryTmp_1__1_,
         rem_13_u_div_CryTmp_0__4_, rem_13_u_div_CryTmp_0__3_,
         rem_13_u_div_CryTmp_0__2_, rem_13_u_div_CryTmp_0__1_,
         rem_13_u_div_SumTmp_3__2_, rem_13_u_div_SumTmp_3__1_,
         rem_13_u_div_SumTmp_3__0_, rem_13_u_div_SumTmp_2__3_,
         rem_13_u_div_SumTmp_2__2_, rem_13_u_div_SumTmp_2__1_,
         rem_13_u_div_SumTmp_2__0_, rem_13_u_div_SumTmp_1__3_,
         rem_13_u_div_SumTmp_1__2_, rem_13_u_div_SumTmp_1__1_,
         rem_13_u_div_SumTmp_1__0_, rem_13_u_div_SumTmp_0__3_,
         rem_13_u_div_SumTmp_0__2_, rem_13_u_div_SumTmp_0__1_,
         rem_13_u_div_SumTmp_0__0_;
  wire   [75:76] rem_13_n;

  MUX2_X1 div_14_U31 ( .A(div_14_u_div_PartRem_2__1_), .B(
        div_14_u_div_SumTmp_1__1_), .S(result[3]), .Z(
        div_14_u_div_PartRem_1__2_) );
  MUX2_X1 div_14_U30 ( .A(A[3]), .B(div_14_u_div_SumTmp_3__0_), .S(result[1]), 
        .Z(div_14_u_div_PartRem_3__1_) );
  MUX2_X1 div_14_U29 ( .A(div_14_n3), .B(div_14_u_div_SumTmp_2__1_), .S(
        result[0]), .Z(div_14_u_div_PartRem_2__2_) );
  MUX2_X1 div_14_U28 ( .A(div_14_u_div_PartRem_4__1_), .B(
        div_14_u_div_SumTmp_3__1_), .S(result[1]), .Z(
        div_14_u_div_PartRem_3__2_) );
  AND2_X1 div_14_U27 ( .A1(div_14_n6), .A2(div_14_n5), .ZN(
        div_14_u_div_PartRem_4__2_) );
  XNOR2_X1 div_14_U26 ( .A(div_14_n12), .B(A[1]), .ZN(
        div_14_u_div_SumTmp_1__0_) );
  INV_X1 div_14_U25 ( .A(A[0]), .ZN(div_14_n10) );
  NAND2_X1 div_14_U24 ( .A1(div_14_n9), .A2(div_14_n10), .ZN(
        div_14_u_div_CryTmp_0__1_) );
  OR2_X1 div_14_U23 ( .A1(div_14_n12), .A2(A[2]), .ZN(
        div_14_u_div_CryTmp_2__1_) );
  OR2_X1 div_14_U22 ( .A1(div_14_n12), .A2(A[1]), .ZN(
        div_14_u_div_CryTmp_1__1_) );
  OR2_X1 div_14_U21 ( .A1(div_14_n12), .A2(A[3]), .ZN(
        div_14_u_div_CryTmp_3__1_) );
  XNOR2_X1 div_14_U20 ( .A(div_14_n12), .B(A[3]), .ZN(
        div_14_u_div_SumTmp_3__0_) );
  XNOR2_X1 div_14_U19 ( .A(div_14_n12), .B(A[2]), .ZN(
        div_14_u_div_SumTmp_2__0_) );
  INV_X1 div_14_U18 ( .A(div_14_n12), .ZN(div_14_n9) );
  XOR2_X1 div_14_U17 ( .A(div_14_n12), .B(div_14_n1), .Z(div_14_n6) );
  OR2_X1 div_14_U16 ( .A1(div_14_u_div_CryTmp_0__2_), .A2(
        div_14_u_div_PartRem_1__2_), .ZN(result[2]) );
  INV_X1 div_14_U15 ( .A(div_14_u_div_CryTmp_2__2_), .ZN(div_14_n8) );
  INV_X1 div_14_U14 ( .A(div_14_u_div_PartRem_3__2_), .ZN(div_14_n7) );
  AND2_X1 div_14_U13 ( .A1(div_14_n12), .A2(div_14_n11), .ZN(div_14_n5) );
  OR2_X2 div_14_U12 ( .A1(div_14_u_div_CryTmp_3__2_), .A2(
        div_14_u_div_PartRem_4__2_), .ZN(result[1]) );
  NAND2_X1 div_14_U11 ( .A1(div_14_n8), .A2(div_14_n7), .ZN(result[0]) );
  MUX2_X1 div_14_U10 ( .A(A[3]), .B(div_14_u_div_SumTmp_3__0_), .S(result[1]), 
        .Z(div_14_n3) );
  INV_X1 div_14_U9 ( .A(B[1]), .ZN(div_14_n11) );
  INV_X1 div_14_U8 ( .A(B[1]), .ZN(div_14_n2) );
  INV_X1 div_14_U7 ( .A(B[1]), .ZN(div_14_n1) );
  MUX2_X2 div_14_U6 ( .A(A[2]), .B(div_14_u_div_SumTmp_2__0_), .S(div_14_n13), 
        .Z(div_14_u_div_PartRem_2__1_) );
  INV_X2 div_14_U5 ( .A(B[0]), .ZN(div_14_n12) );
  AND2_X1 div_14_U4 ( .A1(div_14_n5), .A2(B[0]), .ZN(
        div_14_u_div_PartRem_4__1_) );
  OR2_X1 div_14_U3 ( .A1(div_14_u_div_CryTmp_2__2_), .A2(
        div_14_u_div_PartRem_3__2_), .ZN(div_14_n13) );
  MUX2_X1 div_14_U2 ( .A(A[1]), .B(div_14_u_div_SumTmp_1__0_), .S(result[3]), 
        .Z(div_14_u_div_PartRem_1__1_) );
  OR2_X2 div_14_U1 ( .A1(div_14_u_div_CryTmp_1__2_), .A2(
        div_14_u_div_PartRem_2__2_), .ZN(result[3]) );
  FA_X1 div_14_u_div_u_fa_PartRem_0_0_1 ( .A(div_14_u_div_PartRem_1__1_), .B(
        div_14_n1), .CI(div_14_u_div_CryTmp_0__1_), .CO(
        div_14_u_div_CryTmp_0__2_) );
  FA_X1 div_14_u_div_u_fa_PartRem_0_1_1 ( .A(div_14_u_div_CryTmp_1__1_), .B(
        div_14_n2), .CI(div_14_u_div_PartRem_2__1_), .CO(
        div_14_u_div_CryTmp_1__2_), .S(div_14_u_div_SumTmp_1__1_) );
  FA_X1 div_14_u_div_u_fa_PartRem_0_2_1 ( .A(div_14_u_div_CryTmp_2__1_), .B(
        div_14_n1), .CI(div_14_u_div_PartRem_3__1_), .CO(
        div_14_u_div_CryTmp_2__2_), .S(div_14_u_div_SumTmp_2__1_) );
  FA_X1 div_14_u_div_u_fa_PartRem_0_3_1 ( .A(div_14_u_div_CryTmp_3__1_), .B(
        div_14_n2), .CI(div_14_u_div_PartRem_4__1_), .CO(
        div_14_u_div_CryTmp_3__2_), .S(div_14_u_div_SumTmp_3__1_) );
  MUX2_X1 rem_13_U115 ( .A(A[0]), .B(rem_13_u_div_SumTmp_0__0_), .S(rem_13_n62), .Z(odd[2]) );
  MUX2_X1 rem_13_U114 ( .A(rem_13_n23), .B(rem_13_u_div_SumTmp_0__1_), .S(
        rem_13_n62), .Z(odd[3]) );
  MUX2_X1 rem_13_U113 ( .A(rem_13_u_div_PartRem_1__2_), .B(
        rem_13_u_div_SumTmp_0__2_), .S(rem_13_n[76]), .Z(odd[0]) );
  MUX2_X1 rem_13_U112 ( .A(rem_13_u_div_PartRem_2__2_), .B(
        rem_13_u_div_SumTmp_1__2_), .S(rem_13_n17), .Z(
        rem_13_u_div_PartRem_1__3_) );
  MUX2_X1 rem_13_U111 ( .A(rem_13_u_div_PartRem_1__3_), .B(
        rem_13_u_div_SumTmp_0__3_), .S(rem_13_n[76]), .Z(odd[1]) );
  MUX2_X1 rem_13_U109 ( .A(rem_13_u_div_PartRem_2__3_), .B(
        rem_13_u_div_SumTmp_1__3_), .S(rem_13_n17), .Z(
        rem_13_u_div_PartRem_1__4_) );
  MUX2_X1 rem_13_U108 ( .A(rem_13_u_div_PartRem_4__2_), .B(
        rem_13_u_div_SumTmp_3__2_), .S(rem_13_u_div_CryTmp_3__3_), .Z(
        rem_13_u_div_PartRem_3__3_) );
  MUX2_X1 rem_13_U107 ( .A(rem_13_u_div_PartRem_3__3_), .B(
        rem_13_u_div_SumTmp_2__3_), .S(rem_13_n71), .Z(
        rem_13_u_div_PartRem_2__4_) );
  CLKBUF_X1 rem_13_U106 ( .A(rem_13_u_div_PartRem_3__1_), .Z(rem_13_n73) );
  CLKBUF_X1 rem_13_U105 ( .A(rem_13_u_div_PartRem_2__1_), .Z(rem_13_n72) );
  CLKBUF_X1 rem_13_U104 ( .A(rem_13_u_div_CryTmp_2__4_), .Z(rem_13_n69) );
  XNOR2_X1 rem_13_U103 ( .A(rem_13_n49), .B(A[0]), .ZN(
        rem_13_u_div_SumTmp_0__0_) );
  XNOR2_X1 rem_13_U102 ( .A(rem_13_n48), .B(A[1]), .ZN(
        rem_13_u_div_SumTmp_1__0_) );
  XNOR2_X1 rem_13_U101 ( .A(rem_13_n49), .B(A[2]), .ZN(
        rem_13_u_div_SumTmp_2__0_) );
  OR2_X1 rem_13_U100 ( .A1(rem_13_n48), .A2(A[2]), .ZN(
        rem_13_u_div_CryTmp_2__1_) );
  OR2_X1 rem_13_U99 ( .A1(rem_13_n49), .A2(A[0]), .ZN(
        rem_13_u_div_CryTmp_0__1_) );
  OR2_X1 rem_13_U98 ( .A1(rem_13_n48), .A2(A[1]), .ZN(
        rem_13_u_div_CryTmp_1__1_) );
  OR2_X1 rem_13_U97 ( .A1(rem_13_u_div_CryTmp_0__4_), .A2(
        rem_13_u_div_PartRem_1__4_), .ZN(rem_13_n[76]) );
  NAND3_X1 rem_13_U96 ( .A1(rem_13_n64), .A2(rem_13_n66), .A3(rem_13_n65), 
        .ZN(rem_13_u_div_CryTmp_0__3_) );
  NAND2_X1 rem_13_U95 ( .A1(rem_13_n35), .A2(rem_13_u_div_PartRem_1__2_), .ZN(
        rem_13_n66) );
  XOR2_X1 rem_13_U94 ( .A(rem_13_n36), .B(rem_13_u_div_PartRem_1__2_), .Z(
        rem_13_n63) );
  OR2_X1 rem_13_U93 ( .A1(rem_13_u_div_CryTmp_0__4_), .A2(
        rem_13_u_div_PartRem_1__4_), .ZN(rem_13_n62) );
  NAND3_X1 rem_13_U92 ( .A1(rem_13_n61), .A2(rem_13_n60), .A3(rem_13_n59), 
        .ZN(rem_13_u_div_CryTmp_2__4_) );
  NAND2_X1 rem_13_U91 ( .A1(rem_13_u_div_CryTmp_2__3_), .A2(
        rem_13_u_div_PartRem_3__3_), .ZN(rem_13_n60) );
  XOR2_X1 rem_13_U90 ( .A(rem_13_n58), .B(rem_13_n47), .Z(
        rem_13_u_div_SumTmp_2__3_) );
  NAND3_X1 rem_13_U89 ( .A1(rem_13_n56), .A2(rem_13_n2), .A3(rem_13_n57), .ZN(
        rem_13_u_div_CryTmp_2__3_) );
  NAND2_X1 rem_13_U88 ( .A1(rem_13_u_div_PartRem_3__2_), .A2(
        rem_13_u_div_CryTmp_2__2_), .ZN(rem_13_n56) );
  XOR2_X1 rem_13_U87 ( .A(rem_13_n54), .B(rem_13_n34), .Z(
        rem_13_u_div_SumTmp_2__2_) );
  NAND2_X1 rem_13_U86 ( .A1(rem_13_u_div_CryTmp_1__3_), .A2(
        rem_13_u_div_PartRem_2__3_), .ZN(rem_13_n53) );
  XOR2_X1 rem_13_U85 ( .A(rem_13_n24), .B(rem_13_u_div_PartRem_2__3_), .Z(
        rem_13_n50) );
  INV_X1 rem_13_U84 ( .A(B[0]), .ZN(rem_13_n49) );
  INV_X1 rem_13_U83 ( .A(B[0]), .ZN(rem_13_n48) );
  NOR2_X1 rem_13_U82 ( .A1(B[1]), .A2(B[0]), .ZN(rem_13_n67) );
  NAND3_X1 rem_13_U81 ( .A1(rem_13_n26), .A2(rem_13_n28), .A3(rem_13_n14), 
        .ZN(rem_13_n47) );
  NAND3_X1 rem_13_U80 ( .A1(rem_13_n55), .A2(rem_13_n56), .A3(rem_13_n57), 
        .ZN(rem_13_n46) );
  NAND3_X1 rem_13_U79 ( .A1(rem_13_n43), .A2(rem_13_n44), .A3(rem_13_n45), 
        .ZN(rem_13_u_div_CryTmp_0__2_) );
  NAND2_X1 rem_13_U78 ( .A1(rem_13_u_div_CryTmp_0__1_), .A2(rem_13_n70), .ZN(
        rem_13_n45) );
  NAND2_X1 rem_13_U77 ( .A1(rem_13_u_div_PartRem_1__1_), .A2(rem_13_n70), .ZN(
        rem_13_n44) );
  NAND2_X1 rem_13_U76 ( .A1(rem_13_u_div_PartRem_1__1_), .A2(
        rem_13_u_div_CryTmp_0__1_), .ZN(rem_13_n43) );
  XOR2_X1 rem_13_U75 ( .A(rem_13_n23), .B(rem_13_n42), .Z(
        rem_13_u_div_SumTmp_0__1_) );
  XOR2_X1 rem_13_U74 ( .A(rem_13_u_div_CryTmp_0__1_), .B(rem_13_n70), .Z(
        rem_13_n42) );
  NAND3_X1 rem_13_U73 ( .A1(rem_13_n41), .A2(rem_13_n15), .A3(rem_13_n40), 
        .ZN(rem_13_u_div_CryTmp_1__3_) );
  NAND2_X1 rem_13_U72 ( .A1(rem_13_u_div_CryTmp_1__2_), .A2(
        rem_13_u_div_PartRem_2__2_), .ZN(rem_13_n41) );
  XOR2_X1 rem_13_U71 ( .A(rem_13_n30), .B(rem_13_u_div_PartRem_2__2_), .Z(
        rem_13_n38) );
  NAND3_X1 rem_13_U70 ( .A1(rem_13_n39), .A2(rem_13_n40), .A3(rem_13_n41), 
        .ZN(rem_13_n37) );
  NAND3_X1 rem_13_U69 ( .A1(rem_13_n43), .A2(rem_13_n27), .A3(rem_13_n45), 
        .ZN(rem_13_n36) );
  NAND3_X1 rem_13_U68 ( .A1(rem_13_n43), .A2(rem_13_n44), .A3(rem_13_n45), 
        .ZN(rem_13_n35) );
  CLKBUF_X1 rem_13_U67 ( .A(rem_13_u_div_CryTmp_2__2_), .Z(rem_13_n34) );
  XOR2_X1 rem_13_U66 ( .A(rem_13_n33), .B(rem_13_n29), .Z(
        rem_13_u_div_SumTmp_3__2_) );
  AND2_X1 rem_13_U65 ( .A1(rem_13_n67), .A2(B[0]), .ZN(rem_13_n31) );
  MUX2_X1 rem_13_U64 ( .A(rem_13_n73), .B(rem_13_u_div_SumTmp_2__1_), .S(
        rem_13_n69), .Z(rem_13_u_div_PartRem_2__2_) );
  CLKBUF_X1 rem_13_U63 ( .A(rem_13_n25), .Z(rem_13_n30) );
  CLKBUF_X1 rem_13_U62 ( .A(rem_13_n56), .Z(rem_13_n28) );
  CLKBUF_X1 rem_13_U61 ( .A(rem_13_n44), .Z(rem_13_n27) );
  CLKBUF_X1 rem_13_U60 ( .A(rem_13_n57), .Z(rem_13_n26) );
  FA_X1 rem_13_U59 ( .A(rem_13_u_div_CryTmp_1__1_), .B(rem_13_n70), .CI(
        rem_13_u_div_PartRem_2__1_), .CO(rem_13_n25) );
  NAND3_X1 rem_13_U58 ( .A1(rem_13_n1), .A2(rem_13_n40), .A3(rem_13_n41), .ZN(
        rem_13_n24) );
  CLKBUF_X1 rem_13_U57 ( .A(rem_13_u_div_PartRem_1__1_), .Z(rem_13_n23) );
  MUX2_X2 rem_13_U56 ( .A(rem_13_n72), .B(rem_13_u_div_SumTmp_1__1_), .S(
        rem_13_n17), .Z(rem_13_u_div_PartRem_1__2_) );
  INV_X1 rem_13_U55 ( .A(A[3]), .ZN(rem_13_n22) );
  AOI21_X1 rem_13_U54 ( .B1(rem_13_n22), .B2(B[0]), .A(B[1]), .ZN(rem_13_n29)
         );
  INV_X1 rem_13_U53 ( .A(rem_13_u_div_PartRem_2__4_), .ZN(rem_13_n21) );
  XOR2_X1 rem_13_U52 ( .A(B[1]), .B(B[0]), .Z(rem_13_n68) );
  XNOR2_X1 rem_13_U51 ( .A(rem_13_n31), .B(B[1]), .ZN(rem_13_n32) );
  XOR2_X1 rem_13_U50 ( .A(B[0]), .B(A[3]), .Z(rem_13_u_div_SumTmp_3__0_) );
  MUX2_X1 rem_13_U49 ( .A(A[2]), .B(rem_13_u_div_SumTmp_2__0_), .S(
        rem_13_u_div_CryTmp_2__4_), .Z(rem_13_u_div_PartRem_2__1_) );
  INV_X1 rem_13_U48 ( .A(rem_13_n10), .ZN(rem_13_u_div_CryTmp_3__3_) );
  INV_X1 rem_13_U47 ( .A(B[1]), .ZN(rem_13_n19) );
  INV_X1 rem_13_U46 ( .A(B[0]), .ZN(rem_13_n18) );
  NAND4_X1 rem_13_U45 ( .A1(rem_13_n51), .A2(rem_13_n53), .A3(rem_13_n52), 
        .A4(rem_13_n21), .ZN(rem_13_n17) );
  NOR2_X1 rem_13_U44 ( .A1(rem_13_n49), .A2(A[3]), .ZN(rem_13_n16) );
  XNOR2_X1 rem_13_U43 ( .A(rem_13_n32), .B(rem_13_n16), .ZN(
        rem_13_u_div_SumTmp_3__1_) );
  AND2_X1 rem_13_U42 ( .A1(rem_13_n68), .A2(rem_13_n13), .ZN(
        rem_13_u_div_PartRem_4__2_) );
  CLKBUF_X1 rem_13_U41 ( .A(rem_13_n55), .Z(rem_13_n14) );
  MUX2_X1 rem_13_U40 ( .A(rem_13_u_div_SumTmp_3__0_), .B(A[3]), .S(rem_13_n20), 
        .Z(rem_13_u_div_PartRem_3__1_) );
  NOR2_X1 rem_13_U39 ( .A1(B[0]), .A2(B[1]), .ZN(rem_13_n13) );
  MUX2_X1 rem_13_U38 ( .A(rem_13_n12), .B(rem_13_u_div_SumTmp_2__2_), .S(
        rem_13_n71), .Z(rem_13_u_div_PartRem_2__3_) );
  INV_X1 rem_13_U37 ( .A(rem_13_n8), .ZN(rem_13_n9) );
  NAND3_X1 rem_13_U36 ( .A1(rem_13_n51), .A2(rem_13_n53), .A3(rem_13_n9), .ZN(
        rem_13_n[75]) );
  NAND2_X1 rem_13_U35 ( .A1(rem_13_n52), .A2(rem_13_n21), .ZN(rem_13_n8) );
  MUX2_X2 rem_13_U34 ( .A(A[1]), .B(rem_13_u_div_SumTmp_1__0_), .S(
        rem_13_n[75]), .Z(rem_13_u_div_PartRem_1__1_) );
  INV_X2 rem_13_U33 ( .A(B[1]), .ZN(rem_13_n70) );
  NAND3_X1 rem_13_U32 ( .A1(rem_13_n5), .A2(rem_13_n6), .A3(rem_13_n7), .ZN(
        rem_13_u_div_CryTmp_2__2_) );
  NAND2_X1 rem_13_U31 ( .A1(rem_13_u_div_CryTmp_2__1_), .A2(rem_13_n70), .ZN(
        rem_13_n7) );
  NAND2_X1 rem_13_U30 ( .A1(rem_13_u_div_PartRem_3__1_), .A2(rem_13_n70), .ZN(
        rem_13_n6) );
  NAND2_X1 rem_13_U29 ( .A1(rem_13_u_div_PartRem_3__1_), .A2(
        rem_13_u_div_CryTmp_2__1_), .ZN(rem_13_n5) );
  XOR2_X1 rem_13_U28 ( .A(rem_13_u_div_PartRem_3__1_), .B(rem_13_n4), .Z(
        rem_13_u_div_SumTmp_2__1_) );
  XOR2_X1 rem_13_U27 ( .A(rem_13_u_div_CryTmp_2__1_), .B(rem_13_n70), .Z(
        rem_13_n4) );
  CLKBUF_X1 rem_13_U26 ( .A(rem_13_n31), .Z(rem_13_n11) );
  BUF_X1 rem_13_U25 ( .A(rem_13_n69), .Z(rem_13_n71) );
  CLKBUF_X1 rem_13_U24 ( .A(rem_13_n39), .Z(rem_13_n1) );
  MUX2_X2 rem_13_U23 ( .A(rem_13_n11), .B(rem_13_u_div_SumTmp_3__1_), .S(
        rem_13_u_div_CryTmp_3__3_), .Z(rem_13_n3) );
  BUF_X1 rem_13_U22 ( .A(rem_13_n3), .Z(rem_13_n12) );
  MUX2_X1 rem_13_U21 ( .A(rem_13_u_div_SumTmp_3__1_), .B(rem_13_n11), .S(
        rem_13_n10), .Z(rem_13_u_div_PartRem_3__2_) );
  NAND2_X1 rem_13_U20 ( .A1(rem_13_n3), .A2(1'b1), .ZN(rem_13_n55) );
  NAND2_X1 rem_13_U19 ( .A1(rem_13_n3), .A2(1'b1), .ZN(rem_13_n2) );
  NAND2_X1 rem_13_U18 ( .A1(rem_13_n37), .A2(1'b1), .ZN(rem_13_n51) );
  OAI211_X1 rem_13_U17 ( .C1(A[3]), .C2(rem_13_n18), .A(1'b1), .B(rem_13_n19), 
        .ZN(rem_13_n10) );
  NAND2_X1 rem_13_U16 ( .A1(rem_13_n46), .A2(1'b1), .ZN(rem_13_n61) );
  NAND2_X1 rem_13_U15 ( .A1(rem_13_n25), .A2(1'b1), .ZN(rem_13_n15) );
  NAND2_X1 rem_13_U14 ( .A1(rem_13_u_div_CryTmp_2__2_), .A2(1'b1), .ZN(
        rem_13_n57) );
  OAI211_X1 rem_13_U13 ( .C1(A[3]), .C2(rem_13_n18), .A(1'b1), .B(rem_13_n19), 
        .ZN(rem_13_n20) );
  NAND2_X1 rem_13_U12 ( .A1(rem_13_n25), .A2(1'b1), .ZN(rem_13_n39) );
  INV_X2 rem_13_U11 ( .A(rem_13_u_div_PartRem_4__2_), .ZN(rem_13_n33) );
  INV_X2 rem_13_U10 ( .A(rem_13_u_div_PartRem_2__2_), .ZN(rem_13_n40) );
  INV_X2 rem_13_U9 ( .A(rem_13_n38), .ZN(rem_13_u_div_SumTmp_1__2_) );
  NAND2_X1 rem_13_U8 ( .A1(1'b1), .A2(rem_13_u_div_PartRem_2__3_), .ZN(
        rem_13_n52) );
  INV_X2 rem_13_U7 ( .A(rem_13_n50), .ZN(rem_13_u_div_SumTmp_1__3_) );
  NAND2_X1 rem_13_U6 ( .A1(rem_13_u_div_PartRem_3__3_), .A2(1'b1), .ZN(
        rem_13_n59) );
  INV_X2 rem_13_U5 ( .A(rem_13_u_div_PartRem_3__3_), .ZN(rem_13_n58) );
  INV_X2 rem_13_U4 ( .A(rem_13_n12), .ZN(rem_13_n54) );
  INV_X2 rem_13_U3 ( .A(rem_13_u_div_PartRem_1__2_), .ZN(rem_13_n65) );
  NAND2_X1 rem_13_U2 ( .A1(1'b1), .A2(rem_13_u_div_CryTmp_0__2_), .ZN(
        rem_13_n64) );
  INV_X2 rem_13_U1 ( .A(rem_13_n63), .ZN(rem_13_u_div_SumTmp_0__2_) );
  FA_X1 rem_13_u_div_u_fa_PartRem_0_0_3 ( .A(rem_13_u_div_PartRem_1__3_), .B(
        1'b1), .CI(rem_13_u_div_CryTmp_0__3_), .CO(rem_13_u_div_CryTmp_0__4_), 
        .S(rem_13_u_div_SumTmp_0__3_) );
  FA_X1 rem_13_u_div_u_fa_PartRem_0_1_1 ( .A(rem_13_u_div_CryTmp_1__1_), .B(
        rem_13_n70), .CI(rem_13_u_div_PartRem_2__1_), .CO(
        rem_13_u_div_CryTmp_1__2_), .S(rem_13_u_div_SumTmp_1__1_) );
endmodule

