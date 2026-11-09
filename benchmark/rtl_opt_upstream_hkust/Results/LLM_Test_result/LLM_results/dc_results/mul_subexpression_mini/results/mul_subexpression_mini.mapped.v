/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:08:58 2025
/////////////////////////////////////////////////////////////


module mul_subexpression_mini ( multiplicand, multiplier, product );
  input [7:0] multiplicand;
  input [7:0] multiplier;
  output [15:0] product;
  wire   mult_12_n80, mult_12_n79, mult_12_n78, mult_12_n77, mult_12_n76,
         mult_12_n75, mult_12_n74, mult_12_n73, mult_12_n72, mult_12_n71,
         mult_12_n70, mult_12_n69, mult_12_n68, mult_12_n67, mult_12_n66,
         mult_12_n65, mult_12_n64, mult_12_n63, mult_12_n62, mult_12_n61,
         mult_12_n60, mult_12_n59, mult_12_n57, mult_12_n56, mult_12_n55,
         mult_12_n54, mult_12_n53, mult_12_n52, mult_12_n51, mult_12_n50,
         mult_12_n49, mult_12_n48, mult_12_n47, mult_12_n46, mult_12_n45,
         mult_12_n44, mult_12_n43, mult_12_n42, mult_12_n41, mult_12_n40,
         mult_12_n39, mult_12_n38, mult_12_n37, mult_12_n36, mult_12_n35,
         mult_12_n34, mult_12_n33, mult_12_n32, mult_12_n31, mult_12_n30,
         mult_12_n29, mult_12_n28, mult_12_n27, mult_12_n26, mult_12_n25,
         mult_12_n24, mult_12_n23, mult_12_n22, mult_12_n21, mult_12_n20,
         mult_12_n19, mult_12_n18, mult_12_n17, mult_12_n16, mult_12_n15,
         mult_12_n14, mult_12_n13, mult_12_n12, mult_12_n11, mult_12_n10,
         mult_12_n9, mult_12_n8, mult_12_n7, mult_12_n6, mult_12_n5,
         mult_12_n4, mult_12_n3, mult_12_n2, mult_12_A2_9_, mult_12_A1_0_,
         mult_12_A1_1_, mult_12_A1_2_, mult_12_A1_3_, mult_12_A1_4_,
         mult_12_A1_8_, mult_12_SUMB_1__4_, mult_12_SUMB_1__5_,
         mult_12_SUMB_1__6_, mult_12_SUMB_2__1_, mult_12_SUMB_2__2_,
         mult_12_SUMB_2__3_, mult_12_SUMB_2__4_, mult_12_SUMB_2__5_,
         mult_12_SUMB_2__6_, mult_12_SUMB_3__1_, mult_12_SUMB_3__2_,
         mult_12_SUMB_3__3_, mult_12_SUMB_3__4_, mult_12_SUMB_3__5_,
         mult_12_SUMB_3__6_, mult_12_SUMB_4__1_, mult_12_SUMB_4__2_,
         mult_12_SUMB_4__3_, mult_12_SUMB_4__4_, mult_12_SUMB_4__5_,
         mult_12_SUMB_4__6_, mult_12_SUMB_5__1_, mult_12_SUMB_5__2_,
         mult_12_SUMB_5__3_, mult_12_SUMB_5__4_, mult_12_SUMB_5__5_,
         mult_12_SUMB_5__6_, mult_12_SUMB_6__1_, mult_12_SUMB_6__2_,
         mult_12_SUMB_6__3_, mult_12_SUMB_6__4_, mult_12_SUMB_6__5_,
         mult_12_SUMB_6__6_, mult_12_SUMB_7__0_, mult_12_SUMB_7__1_,
         mult_12_SUMB_7__2_, mult_12_SUMB_7__3_, mult_12_SUMB_7__4_,
         mult_12_SUMB_7__5_, mult_12_SUMB_7__6_, mult_12_CARRYB_1__4_,
         mult_12_CARRYB_1__5_, mult_12_CARRYB_1__6_, mult_12_CARRYB_2__0_,
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
         mult_12_CARRYB_7__5_, mult_12_CARRYB_7__6_, mult_12_ab_0__1_,
         mult_12_ab_0__2_, mult_12_ab_0__3_, mult_12_ab_0__4_,
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
         mult_12_ab_7__6_, mult_12_ab_7__7_, mult_12_FS_1_n73,
         mult_12_FS_1_n72, mult_12_FS_1_n71, mult_12_FS_1_n70,
         mult_12_FS_1_n69, mult_12_FS_1_n68, mult_12_FS_1_n67,
         mult_12_FS_1_n66, mult_12_FS_1_n65, mult_12_FS_1_n64,
         mult_12_FS_1_n63, mult_12_FS_1_n62, mult_12_FS_1_n61,
         mult_12_FS_1_n60, mult_12_FS_1_n59, mult_12_FS_1_n58,
         mult_12_FS_1_n57, mult_12_FS_1_n56, mult_12_FS_1_n55,
         mult_12_FS_1_n54, mult_12_FS_1_n53, mult_12_FS_1_n52,
         mult_12_FS_1_n51, mult_12_FS_1_n50, mult_12_FS_1_n49,
         mult_12_FS_1_n48, mult_12_FS_1_n47, mult_12_FS_1_n46,
         mult_12_FS_1_n45, mult_12_FS_1_n44, mult_12_FS_1_n43,
         mult_12_FS_1_n42, mult_12_FS_1_n41, mult_12_FS_1_n40,
         mult_12_FS_1_n39, mult_12_FS_1_n38, mult_12_FS_1_n37,
         mult_12_FS_1_n36, mult_12_FS_1_n35, mult_12_FS_1_n34,
         mult_12_FS_1_n33, mult_12_FS_1_n32, mult_12_FS_1_n31,
         mult_12_FS_1_n30, mult_12_FS_1_n29, mult_12_FS_1_n28,
         mult_12_FS_1_n27, mult_12_FS_1_n26, mult_12_FS_1_n25,
         mult_12_FS_1_n24, mult_12_FS_1_n23, mult_12_FS_1_n22,
         mult_12_FS_1_n21, mult_12_FS_1_n13, mult_12_FS_1_n12,
         mult_12_FS_1_n10, mult_12_FS_1_n9, mult_12_FS_1_n8, mult_12_FS_1_n7,
         mult_12_FS_1_n6, mult_12_FS_1_n5, mult_12_FS_1_n4, mult_12_FS_1_n3,
         mult_12_FS_1_n2, mult_12_FS_1_n1;

  NOR2_X1 mult_12_U164 ( .A1(mult_12_n65), .A2(mult_12_n80), .ZN(product[0])
         );
  NOR2_X1 mult_12_U163 ( .A1(mult_12_n79), .A2(mult_12_n78), .ZN(
        mult_12_ab_7__7_) );
  NOR2_X1 mult_12_U162 ( .A1(mult_12_n80), .A2(mult_12_n78), .ZN(
        mult_12_ab_7__0_) );
  NOR2_X1 mult_12_U161 ( .A1(mult_12_n78), .A2(mult_12_n77), .ZN(
        mult_12_ab_7__1_) );
  NOR2_X1 mult_12_U160 ( .A1(mult_12_n78), .A2(mult_12_n76), .ZN(
        mult_12_ab_7__2_) );
  NOR2_X1 mult_12_U159 ( .A1(mult_12_n78), .A2(mult_12_n75), .ZN(
        mult_12_ab_7__3_) );
  NOR2_X1 mult_12_U158 ( .A1(mult_12_n78), .A2(mult_12_n26), .ZN(
        mult_12_ab_7__4_) );
  NOR2_X1 mult_12_U157 ( .A1(mult_12_n78), .A2(mult_12_n73), .ZN(
        mult_12_ab_7__5_) );
  NOR2_X1 mult_12_U156 ( .A1(mult_12_n79), .A2(mult_12_n72), .ZN(
        mult_12_ab_6__7_) );
  NOR2_X1 mult_12_U155 ( .A1(mult_12_n78), .A2(mult_12_n66), .ZN(
        mult_12_ab_7__6_) );
  INV_X1 mult_12_U154 ( .A(multiplicand[7]), .ZN(mult_12_n78) );
  NOR2_X1 mult_12_U153 ( .A1(mult_12_n80), .A2(mult_12_n72), .ZN(
        mult_12_ab_6__0_) );
  NOR2_X1 mult_12_U152 ( .A1(mult_12_n77), .A2(mult_12_n72), .ZN(
        mult_12_ab_6__1_) );
  NOR2_X1 mult_12_U151 ( .A1(mult_12_n76), .A2(mult_12_n72), .ZN(
        mult_12_ab_6__2_) );
  NOR2_X1 mult_12_U150 ( .A1(mult_12_n75), .A2(mult_12_n72), .ZN(
        mult_12_ab_6__3_) );
  NOR2_X1 mult_12_U149 ( .A1(mult_12_n26), .A2(mult_12_n72), .ZN(
        mult_12_ab_6__4_) );
  NOR2_X1 mult_12_U148 ( .A1(mult_12_n73), .A2(mult_12_n72), .ZN(
        mult_12_ab_6__5_) );
  NOR2_X1 mult_12_U147 ( .A1(mult_12_n79), .A2(mult_12_n71), .ZN(
        mult_12_ab_5__7_) );
  NOR2_X1 mult_12_U146 ( .A1(mult_12_n72), .A2(mult_12_n62), .ZN(
        mult_12_ab_6__6_) );
  INV_X1 mult_12_U145 ( .A(multiplicand[6]), .ZN(mult_12_n72) );
  NOR2_X1 mult_12_U144 ( .A1(mult_12_n80), .A2(mult_12_n71), .ZN(
        mult_12_ab_5__0_) );
  NOR2_X1 mult_12_U143 ( .A1(mult_12_n77), .A2(mult_12_n71), .ZN(
        mult_12_ab_5__1_) );
  NOR2_X1 mult_12_U142 ( .A1(mult_12_n76), .A2(mult_12_n71), .ZN(
        mult_12_ab_5__2_) );
  NOR2_X1 mult_12_U141 ( .A1(mult_12_n75), .A2(mult_12_n71), .ZN(
        mult_12_ab_5__3_) );
  NOR2_X1 mult_12_U140 ( .A1(mult_12_n26), .A2(mult_12_n71), .ZN(
        mult_12_ab_5__4_) );
  NOR2_X1 mult_12_U139 ( .A1(mult_12_n73), .A2(mult_12_n71), .ZN(
        mult_12_ab_5__5_) );
  NOR2_X1 mult_12_U138 ( .A1(mult_12_n79), .A2(mult_12_n70), .ZN(
        mult_12_ab_4__7_) );
  NOR2_X1 mult_12_U137 ( .A1(mult_12_n62), .A2(mult_12_n71), .ZN(
        mult_12_ab_5__6_) );
  INV_X1 mult_12_U136 ( .A(multiplicand[5]), .ZN(mult_12_n71) );
  NOR2_X1 mult_12_U135 ( .A1(mult_12_n80), .A2(mult_12_n70), .ZN(
        mult_12_ab_4__0_) );
  NOR2_X1 mult_12_U134 ( .A1(mult_12_n77), .A2(mult_12_n70), .ZN(
        mult_12_ab_4__1_) );
  NOR2_X1 mult_12_U133 ( .A1(mult_12_n76), .A2(mult_12_n70), .ZN(
        mult_12_ab_4__2_) );
  NOR2_X1 mult_12_U132 ( .A1(mult_12_n75), .A2(mult_12_n70), .ZN(
        mult_12_ab_4__3_) );
  NOR2_X1 mult_12_U131 ( .A1(mult_12_n26), .A2(mult_12_n70), .ZN(
        mult_12_ab_4__4_) );
  NOR2_X1 mult_12_U130 ( .A1(mult_12_n73), .A2(mult_12_n70), .ZN(
        mult_12_ab_4__5_) );
  NOR2_X1 mult_12_U129 ( .A1(mult_12_n79), .A2(mult_12_n69), .ZN(
        mult_12_ab_3__7_) );
  NOR2_X1 mult_12_U128 ( .A1(mult_12_n60), .A2(mult_12_n70), .ZN(
        mult_12_ab_4__6_) );
  INV_X1 mult_12_U127 ( .A(multiplicand[4]), .ZN(mult_12_n70) );
  NOR2_X1 mult_12_U126 ( .A1(mult_12_n80), .A2(mult_12_n69), .ZN(
        mult_12_ab_3__0_) );
  NOR2_X1 mult_12_U125 ( .A1(mult_12_n77), .A2(mult_12_n69), .ZN(
        mult_12_ab_3__1_) );
  NOR2_X1 mult_12_U124 ( .A1(mult_12_n76), .A2(mult_12_n69), .ZN(
        mult_12_ab_3__2_) );
  NOR2_X1 mult_12_U123 ( .A1(mult_12_n75), .A2(mult_12_n69), .ZN(
        mult_12_ab_3__3_) );
  NOR2_X1 mult_12_U122 ( .A1(mult_12_n74), .A2(mult_12_n69), .ZN(
        mult_12_ab_3__4_) );
  NOR2_X1 mult_12_U121 ( .A1(mult_12_n73), .A2(mult_12_n69), .ZN(
        mult_12_ab_3__5_) );
  NOR2_X1 mult_12_U120 ( .A1(mult_12_n79), .A2(mult_12_n68), .ZN(
        mult_12_ab_2__7_) );
  NOR2_X1 mult_12_U119 ( .A1(mult_12_n60), .A2(mult_12_n69), .ZN(
        mult_12_ab_3__6_) );
  INV_X1 mult_12_U118 ( .A(multiplicand[3]), .ZN(mult_12_n69) );
  NOR2_X1 mult_12_U117 ( .A1(mult_12_n80), .A2(mult_12_n68), .ZN(
        mult_12_ab_2__0_) );
  NOR2_X1 mult_12_U116 ( .A1(mult_12_n77), .A2(mult_12_n68), .ZN(
        mult_12_ab_2__1_) );
  NOR2_X1 mult_12_U115 ( .A1(mult_12_n76), .A2(mult_12_n68), .ZN(
        mult_12_ab_2__2_) );
  NOR2_X1 mult_12_U114 ( .A1(mult_12_n75), .A2(mult_12_n68), .ZN(
        mult_12_ab_2__3_) );
  NOR2_X1 mult_12_U113 ( .A1(mult_12_n74), .A2(mult_12_n68), .ZN(
        mult_12_ab_2__4_) );
  NOR2_X1 mult_12_U112 ( .A1(mult_12_n73), .A2(mult_12_n68), .ZN(
        mult_12_ab_2__5_) );
  NOR2_X1 mult_12_U111 ( .A1(mult_12_n79), .A2(mult_12_n64), .ZN(
        mult_12_ab_1__7_) );
  NOR2_X1 mult_12_U110 ( .A1(mult_12_n66), .A2(mult_12_n68), .ZN(
        mult_12_ab_2__6_) );
  NOR2_X1 mult_12_U109 ( .A1(mult_12_n80), .A2(mult_12_n63), .ZN(
        mult_12_ab_1__0_) );
  INV_X1 mult_12_U108 ( .A(multiplier[0]), .ZN(mult_12_n80) );
  NOR2_X1 mult_12_U107 ( .A1(mult_12_n65), .A2(mult_12_n77), .ZN(
        mult_12_ab_0__1_) );
  NOR2_X1 mult_12_U106 ( .A1(mult_12_n77), .A2(mult_12_n67), .ZN(
        mult_12_ab_1__1_) );
  INV_X1 mult_12_U105 ( .A(multiplier[1]), .ZN(mult_12_n77) );
  NOR2_X1 mult_12_U104 ( .A1(mult_12_n65), .A2(mult_12_n76), .ZN(
        mult_12_ab_0__2_) );
  NOR2_X1 mult_12_U103 ( .A1(mult_12_n76), .A2(mult_12_n61), .ZN(
        mult_12_ab_1__2_) );
  INV_X1 mult_12_U102 ( .A(multiplier[2]), .ZN(mult_12_n76) );
  NOR2_X1 mult_12_U101 ( .A1(mult_12_n65), .A2(mult_12_n75), .ZN(
        mult_12_ab_0__3_) );
  NOR2_X1 mult_12_U100 ( .A1(mult_12_n75), .A2(mult_12_n61), .ZN(
        mult_12_ab_1__3_) );
  INV_X1 mult_12_U99 ( .A(multiplier[3]), .ZN(mult_12_n75) );
  NOR2_X1 mult_12_U98 ( .A1(mult_12_n65), .A2(mult_12_n74), .ZN(
        mult_12_ab_0__4_) );
  NOR2_X1 mult_12_U97 ( .A1(mult_12_n74), .A2(mult_12_n63), .ZN(
        mult_12_ab_1__4_) );
  INV_X2 mult_12_U96 ( .A(multiplier[5]), .ZN(mult_12_n73) );
  INV_X1 mult_12_U95 ( .A(multiplicand[1]), .ZN(mult_12_n67) );
  INV_X1 mult_12_U94 ( .A(multiplier[6]), .ZN(mult_12_n66) );
  INV_X1 mult_12_U93 ( .A(multiplicand[1]), .ZN(mult_12_n64) );
  INV_X1 mult_12_U92 ( .A(multiplicand[1]), .ZN(mult_12_n63) );
  INV_X1 mult_12_U91 ( .A(multiplier[6]), .ZN(mult_12_n62) );
  AND2_X1 mult_12_U90 ( .A1(multiplier[5]), .A2(multiplicand[1]), .ZN(
        mult_12_ab_1__5_) );
  INV_X1 mult_12_U89 ( .A(multiplicand[1]), .ZN(mult_12_n61) );
  INV_X1 mult_12_U88 ( .A(multiplier[6]), .ZN(mult_12_n60) );
  INV_X1 mult_12_U87 ( .A(multiplier[7]), .ZN(mult_12_n79) );
  AND2_X1 mult_12_U86 ( .A1(mult_12_ab_0__4_), .A2(mult_12_ab_1__3_), .ZN(
        mult_12_n59) );
  XOR2_X1 mult_12_U85 ( .A(mult_12_ab_1__0_), .B(mult_12_ab_0__1_), .Z(
        product[1]) );
  XOR2_X1 mult_12_U84 ( .A(mult_12_CARRYB_7__0_), .B(mult_12_SUMB_7__1_), .Z(
        mult_12_n57) );
  XOR2_X1 mult_12_U83 ( .A(mult_12_CARRYB_7__6_), .B(mult_12_ab_7__7_), .Z(
        mult_12_n56) );
  AND2_X1 mult_12_U82 ( .A1(mult_12_CARRYB_7__5_), .A2(mult_12_SUMB_7__6_), 
        .ZN(mult_12_n55) );
  AND2_X1 mult_12_U81 ( .A1(mult_12_CARRYB_7__4_), .A2(mult_12_SUMB_7__5_), 
        .ZN(mult_12_n54) );
  XOR2_X1 mult_12_U80 ( .A(mult_12_CARRYB_7__5_), .B(mult_12_SUMB_7__6_), .Z(
        mult_12_n53) );
  AND2_X1 mult_12_U79 ( .A1(mult_12_CARRYB_7__3_), .A2(mult_12_SUMB_7__4_), 
        .ZN(mult_12_n52) );
  AND2_X1 mult_12_U78 ( .A1(mult_12_SUMB_7__2_), .A2(mult_12_CARRYB_7__1_), 
        .ZN(mult_12_n51) );
  XOR2_X1 mult_12_U77 ( .A(mult_12_CARRYB_7__1_), .B(mult_12_SUMB_7__2_), .Z(
        mult_12_n49) );
  XOR2_X1 mult_12_U76 ( .A(mult_12_CARRYB_7__4_), .B(mult_12_SUMB_7__5_), .Z(
        mult_12_n48) );
  XOR2_X1 mult_12_U75 ( .A(mult_12_CARRYB_7__3_), .B(mult_12_SUMB_7__4_), .Z(
        mult_12_n47) );
  AND2_X1 mult_12_U74 ( .A1(multiplier[6]), .A2(multiplicand[1]), .ZN(
        mult_12_ab_1__6_) );
  NAND3_X1 mult_12_U73 ( .A1(mult_12_n44), .A2(mult_12_n45), .A3(mult_12_n46), 
        .ZN(mult_12_CARRYB_2__3_) );
  NAND2_X1 mult_12_U72 ( .A1(mult_12_n59), .A2(mult_12_ab_2__3_), .ZN(
        mult_12_n46) );
  NAND2_X1 mult_12_U71 ( .A1(mult_12_SUMB_1__4_), .A2(mult_12_ab_2__3_), .ZN(
        mult_12_n45) );
  NAND2_X1 mult_12_U70 ( .A1(mult_12_SUMB_1__4_), .A2(mult_12_n59), .ZN(
        mult_12_n44) );
  XOR2_X1 mult_12_U69 ( .A(mult_12_SUMB_1__4_), .B(mult_12_n43), .Z(
        mult_12_SUMB_2__3_) );
  XOR2_X1 mult_12_U68 ( .A(mult_12_n59), .B(mult_12_ab_2__3_), .Z(mult_12_n43)
         );
  NAND3_X1 mult_12_U67 ( .A1(mult_12_n40), .A2(mult_12_n41), .A3(mult_12_n42), 
        .ZN(mult_12_CARRYB_4__2_) );
  NAND2_X1 mult_12_U66 ( .A1(mult_12_CARRYB_3__2_), .A2(mult_12_ab_4__2_), 
        .ZN(mult_12_n42) );
  NAND2_X1 mult_12_U65 ( .A1(mult_12_SUMB_3__3_), .A2(mult_12_ab_4__2_), .ZN(
        mult_12_n41) );
  NAND2_X1 mult_12_U64 ( .A1(mult_12_SUMB_3__3_), .A2(mult_12_CARRYB_3__2_), 
        .ZN(mult_12_n40) );
  XOR2_X1 mult_12_U63 ( .A(mult_12_SUMB_3__3_), .B(mult_12_n39), .Z(
        mult_12_SUMB_4__2_) );
  XOR2_X1 mult_12_U62 ( .A(mult_12_CARRYB_3__2_), .B(mult_12_ab_4__2_), .Z(
        mult_12_n39) );
  NAND3_X1 mult_12_U61 ( .A1(mult_12_n36), .A2(mult_12_n37), .A3(mult_12_n38), 
        .ZN(mult_12_CARRYB_3__2_) );
  NAND2_X1 mult_12_U60 ( .A1(mult_12_CARRYB_2__2_), .A2(mult_12_ab_3__2_), 
        .ZN(mult_12_n38) );
  NAND2_X1 mult_12_U59 ( .A1(mult_12_SUMB_2__3_), .A2(mult_12_ab_3__2_), .ZN(
        mult_12_n37) );
  NAND2_X1 mult_12_U58 ( .A1(mult_12_SUMB_2__3_), .A2(mult_12_CARRYB_2__2_), 
        .ZN(mult_12_n36) );
  XOR2_X1 mult_12_U57 ( .A(mult_12_SUMB_2__3_), .B(mult_12_n35), .Z(
        mult_12_SUMB_3__2_) );
  XOR2_X1 mult_12_U56 ( .A(mult_12_CARRYB_2__2_), .B(mult_12_ab_3__2_), .Z(
        mult_12_n35) );
  NAND3_X1 mult_12_U55 ( .A1(mult_12_n32), .A2(mult_12_n33), .A3(mult_12_n34), 
        .ZN(mult_12_CARRYB_4__6_) );
  NAND2_X1 mult_12_U54 ( .A1(mult_12_ab_4__6_), .A2(mult_12_ab_3__7_), .ZN(
        mult_12_n34) );
  NAND2_X1 mult_12_U53 ( .A1(mult_12_CARRYB_3__6_), .A2(mult_12_ab_3__7_), 
        .ZN(mult_12_n33) );
  NAND2_X1 mult_12_U52 ( .A1(mult_12_CARRYB_3__6_), .A2(mult_12_ab_4__6_), 
        .ZN(mult_12_n32) );
  XOR2_X1 mult_12_U51 ( .A(mult_12_CARRYB_3__6_), .B(mult_12_n31), .Z(
        mult_12_SUMB_4__6_) );
  XOR2_X1 mult_12_U50 ( .A(mult_12_ab_4__6_), .B(mult_12_ab_3__7_), .Z(
        mult_12_n31) );
  NAND3_X1 mult_12_U49 ( .A1(mult_12_n28), .A2(mult_12_n29), .A3(mult_12_n30), 
        .ZN(mult_12_CARRYB_3__6_) );
  NAND2_X1 mult_12_U48 ( .A1(mult_12_ab_3__6_), .A2(mult_12_ab_2__7_), .ZN(
        mult_12_n30) );
  NAND2_X1 mult_12_U47 ( .A1(mult_12_CARRYB_2__6_), .A2(mult_12_ab_2__7_), 
        .ZN(mult_12_n29) );
  NAND2_X1 mult_12_U46 ( .A1(mult_12_CARRYB_2__6_), .A2(mult_12_ab_3__6_), 
        .ZN(mult_12_n28) );
  XOR2_X1 mult_12_U45 ( .A(mult_12_CARRYB_2__6_), .B(mult_12_n27), .Z(
        mult_12_SUMB_3__6_) );
  XOR2_X1 mult_12_U44 ( .A(mult_12_ab_3__6_), .B(mult_12_ab_2__7_), .Z(
        mult_12_n27) );
  AND2_X1 mult_12_U43 ( .A1(multiplicand[0]), .A2(multiplier[6]), .ZN(
        mult_12_ab_0__6_) );
  INV_X1 mult_12_U42 ( .A(multiplier[4]), .ZN(mult_12_n74) );
  INV_X1 mult_12_U41 ( .A(multiplier[4]), .ZN(mult_12_n26) );
  NAND3_X1 mult_12_U40 ( .A1(mult_12_n23), .A2(mult_12_n24), .A3(mult_12_n25), 
        .ZN(mult_12_CARRYB_5__2_) );
  NAND2_X1 mult_12_U39 ( .A1(mult_12_CARRYB_4__2_), .A2(mult_12_ab_5__2_), 
        .ZN(mult_12_n25) );
  NAND2_X1 mult_12_U38 ( .A1(mult_12_SUMB_4__3_), .A2(mult_12_ab_5__2_), .ZN(
        mult_12_n24) );
  NAND2_X1 mult_12_U37 ( .A1(mult_12_SUMB_4__3_), .A2(mult_12_CARRYB_4__2_), 
        .ZN(mult_12_n23) );
  INV_X1 mult_12_U36 ( .A(multiplicand[0]), .ZN(mult_12_n65) );
  AND2_X1 mult_12_U35 ( .A1(multiplicand[0]), .A2(multiplier[5]), .ZN(
        mult_12_ab_0__5_) );
  NAND3_X1 mult_12_U34 ( .A1(mult_12_n20), .A2(mult_12_n21), .A3(mult_12_n22), 
        .ZN(mult_12_CARRYB_2__6_) );
  NAND2_X1 mult_12_U33 ( .A1(mult_12_ab_2__6_), .A2(mult_12_ab_1__7_), .ZN(
        mult_12_n22) );
  NAND2_X1 mult_12_U32 ( .A1(mult_12_CARRYB_1__6_), .A2(mult_12_ab_1__7_), 
        .ZN(mult_12_n21) );
  NAND2_X1 mult_12_U31 ( .A1(mult_12_CARRYB_1__6_), .A2(mult_12_ab_2__6_), 
        .ZN(mult_12_n20) );
  XOR2_X1 mult_12_U30 ( .A(mult_12_CARRYB_1__6_), .B(mult_12_n19), .Z(
        mult_12_SUMB_2__6_) );
  XOR2_X1 mult_12_U29 ( .A(mult_12_ab_2__6_), .B(mult_12_ab_1__7_), .Z(
        mult_12_n19) );
  NAND3_X1 mult_12_U28 ( .A1(mult_12_n16), .A2(mult_12_n17), .A3(mult_12_n18), 
        .ZN(mult_12_CARRYB_4__5_) );
  NAND2_X1 mult_12_U27 ( .A1(mult_12_SUMB_3__6_), .A2(mult_12_ab_4__5_), .ZN(
        mult_12_n18) );
  NAND2_X1 mult_12_U26 ( .A1(mult_12_CARRYB_3__5_), .A2(mult_12_ab_4__5_), 
        .ZN(mult_12_n17) );
  NAND2_X1 mult_12_U25 ( .A1(mult_12_CARRYB_3__5_), .A2(mult_12_SUMB_3__6_), 
        .ZN(mult_12_n16) );
  XOR2_X1 mult_12_U24 ( .A(mult_12_CARRYB_3__5_), .B(mult_12_n15), .Z(
        mult_12_SUMB_4__5_) );
  XOR2_X1 mult_12_U23 ( .A(mult_12_SUMB_3__6_), .B(mult_12_ab_4__5_), .Z(
        mult_12_n15) );
  CLKBUF_X1 mult_12_U22 ( .A(mult_12_SUMB_4__3_), .Z(mult_12_n14) );
  INV_X2 mult_12_U21 ( .A(multiplicand[2]), .ZN(mult_12_n68) );
  AND2_X2 mult_12_U20 ( .A1(multiplicand[0]), .A2(multiplier[7]), .ZN(
        mult_12_ab_0__7_) );
  XNOR2_X1 mult_12_U19 ( .A(mult_12_CARRYB_4__2_), .B(mult_12_ab_5__2_), .ZN(
        mult_12_n13) );
  XNOR2_X1 mult_12_U18 ( .A(mult_12_n14), .B(mult_12_n13), .ZN(
        mult_12_SUMB_5__2_) );
  AND2_X1 mult_12_U17 ( .A1(mult_12_SUMB_7__1_), .A2(mult_12_CARRYB_7__0_), 
        .ZN(mult_12_n50) );
  AND2_X1 mult_12_U16 ( .A1(mult_12_CARRYB_7__6_), .A2(mult_12_ab_7__7_), .ZN(
        mult_12_n12) );
  AND2_X1 mult_12_U15 ( .A1(mult_12_ab_0__1_), .A2(mult_12_ab_1__0_), .ZN(
        mult_12_n11) );
  AND2_X1 mult_12_U14 ( .A1(mult_12_ab_0__2_), .A2(mult_12_ab_1__1_), .ZN(
        mult_12_n10) );
  AND2_X1 mult_12_U13 ( .A1(mult_12_ab_0__3_), .A2(mult_12_ab_1__2_), .ZN(
        mult_12_n9) );
  XOR2_X1 mult_12_U12 ( .A(mult_12_ab_1__1_), .B(mult_12_ab_0__2_), .Z(
        mult_12_n8) );
  XOR2_X1 mult_12_U11 ( .A(mult_12_ab_1__2_), .B(mult_12_ab_0__3_), .Z(
        mult_12_n7) );
  XOR2_X1 mult_12_U10 ( .A(mult_12_ab_1__3_), .B(mult_12_ab_0__4_), .Z(
        mult_12_n6) );
  INV_X2 mult_12_U9 ( .A(mult_12_n5), .ZN(mult_12_SUMB_1__6_) );
  XNOR2_X2 mult_12_U8 ( .A(mult_12_ab_1__6_), .B(mult_12_ab_0__7_), .ZN(
        mult_12_n5) );
  INV_X2 mult_12_U7 ( .A(mult_12_n4), .ZN(mult_12_CARRYB_1__6_) );
  NAND2_X2 mult_12_U6 ( .A1(mult_12_ab_0__7_), .A2(mult_12_ab_1__6_), .ZN(
        mult_12_n4) );
  INV_X2 mult_12_U5 ( .A(mult_12_n3), .ZN(mult_12_A1_8_) );
  XNOR2_X2 mult_12_U4 ( .A(mult_12_CARRYB_7__2_), .B(mult_12_SUMB_7__3_), .ZN(
        mult_12_n3) );
  INV_X2 mult_12_U3 ( .A(mult_12_n2), .ZN(mult_12_A2_9_) );
  NAND2_X2 mult_12_U2 ( .A1(mult_12_CARRYB_7__2_), .A2(mult_12_SUMB_7__3_), 
        .ZN(mult_12_n2) );
  FA_X1 mult_12_S0_5 ( .A(mult_12_ab_0__6_), .B(mult_12_ab_1__5_), .CI(1'b0), 
        .CO(mult_12_CARRYB_1__5_), .S(mult_12_SUMB_1__5_) );
  FA_X1 mult_12_S0_4 ( .A(mult_12_ab_0__5_), .B(mult_12_ab_1__4_), .CI(1'b0), 
        .CO(mult_12_CARRYB_1__4_), .S(mult_12_SUMB_1__4_) );
  FA_X1 mult_12_S2_2_5 ( .A(mult_12_ab_2__5_), .B(mult_12_CARRYB_1__5_), .CI(
        mult_12_SUMB_1__6_), .CO(mult_12_CARRYB_2__5_), .S(mult_12_SUMB_2__5_)
         );
  FA_X1 mult_12_S2_2_4 ( .A(mult_12_CARRYB_1__4_), .B(mult_12_ab_2__4_), .CI(
        mult_12_SUMB_1__5_), .CO(mult_12_CARRYB_2__4_), .S(mult_12_SUMB_2__4_)
         );
  FA_X1 mult_12_S2_2_2 ( .A(mult_12_ab_2__2_), .B(mult_12_n9), .CI(mult_12_n6), 
        .CO(mult_12_CARRYB_2__2_), .S(mult_12_SUMB_2__2_) );
  FA_X1 mult_12_S2_2_1 ( .A(mult_12_ab_2__1_), .B(mult_12_n10), .CI(mult_12_n7), .CO(mult_12_CARRYB_2__1_), .S(mult_12_SUMB_2__1_) );
  FA_X1 mult_12_S1_2_0 ( .A(mult_12_ab_2__0_), .B(mult_12_n11), .CI(mult_12_n8), .CO(mult_12_CARRYB_2__0_), .S(mult_12_A1_0_) );
  FA_X1 mult_12_S2_3_5 ( .A(mult_12_ab_3__5_), .B(mult_12_CARRYB_2__5_), .CI(
        mult_12_SUMB_2__6_), .CO(mult_12_CARRYB_3__5_), .S(mult_12_SUMB_3__5_)
         );
  FA_X1 mult_12_S2_3_4 ( .A(mult_12_CARRYB_2__4_), .B(mult_12_ab_3__4_), .CI(
        mult_12_SUMB_2__5_), .CO(mult_12_CARRYB_3__4_), .S(mult_12_SUMB_3__4_)
         );
  FA_X1 mult_12_S2_3_3 ( .A(mult_12_ab_3__3_), .B(mult_12_CARRYB_2__3_), .CI(
        mult_12_SUMB_2__4_), .CO(mult_12_CARRYB_3__3_), .S(mult_12_SUMB_3__3_)
         );
  FA_X1 mult_12_S2_3_1 ( .A(mult_12_ab_3__1_), .B(mult_12_CARRYB_2__1_), .CI(
        mult_12_SUMB_2__2_), .CO(mult_12_CARRYB_3__1_), .S(mult_12_SUMB_3__1_)
         );
  FA_X1 mult_12_S1_3_0 ( .A(mult_12_ab_3__0_), .B(mult_12_CARRYB_2__0_), .CI(
        mult_12_SUMB_2__1_), .CO(mult_12_CARRYB_3__0_), .S(mult_12_A1_1_) );
  FA_X1 mult_12_S2_4_4 ( .A(mult_12_SUMB_3__5_), .B(mult_12_ab_4__4_), .CI(
        mult_12_CARRYB_3__4_), .CO(mult_12_CARRYB_4__4_), .S(
        mult_12_SUMB_4__4_) );
  FA_X1 mult_12_S2_4_3 ( .A(mult_12_ab_4__3_), .B(mult_12_CARRYB_3__3_), .CI(
        mult_12_SUMB_3__4_), .CO(mult_12_CARRYB_4__3_), .S(mult_12_SUMB_4__3_)
         );
  FA_X1 mult_12_S2_4_1 ( .A(mult_12_ab_4__1_), .B(mult_12_CARRYB_3__1_), .CI(
        mult_12_SUMB_3__2_), .CO(mult_12_CARRYB_4__1_), .S(mult_12_SUMB_4__1_)
         );
  FA_X1 mult_12_S1_4_0 ( .A(mult_12_ab_4__0_), .B(mult_12_CARRYB_3__0_), .CI(
        mult_12_SUMB_3__1_), .CO(mult_12_CARRYB_4__0_), .S(mult_12_A1_2_) );
  FA_X1 mult_12_S3_5_6 ( .A(mult_12_ab_5__6_), .B(mult_12_CARRYB_4__6_), .CI(
        mult_12_ab_4__7_), .CO(mult_12_CARRYB_5__6_), .S(mult_12_SUMB_5__6_)
         );
  FA_X1 mult_12_S2_5_5 ( .A(mult_12_ab_5__5_), .B(mult_12_CARRYB_4__5_), .CI(
        mult_12_SUMB_4__6_), .CO(mult_12_CARRYB_5__5_), .S(mult_12_SUMB_5__5_)
         );
  FA_X1 mult_12_S2_5_4 ( .A(mult_12_SUMB_4__5_), .B(mult_12_ab_5__4_), .CI(
        mult_12_CARRYB_4__4_), .CO(mult_12_CARRYB_5__4_), .S(
        mult_12_SUMB_5__4_) );
  FA_X1 mult_12_S2_5_3 ( .A(mult_12_ab_5__3_), .B(mult_12_CARRYB_4__3_), .CI(
        mult_12_SUMB_4__4_), .CO(mult_12_CARRYB_5__3_), .S(mult_12_SUMB_5__3_)
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
  FA_X1 mult_12_S2_6_4 ( .A(mult_12_CARRYB_5__4_), .B(mult_12_ab_6__4_), .CI(
        mult_12_SUMB_5__5_), .CO(mult_12_CARRYB_6__4_), .S(mult_12_SUMB_6__4_)
         );
  FA_X1 mult_12_S2_6_3 ( .A(mult_12_SUMB_5__4_), .B(mult_12_ab_6__3_), .CI(
        mult_12_CARRYB_5__3_), .CO(mult_12_CARRYB_6__3_), .S(
        mult_12_SUMB_6__3_) );
  FA_X1 mult_12_S2_6_2 ( .A(mult_12_CARRYB_5__2_), .B(mult_12_ab_6__2_), .CI(
        mult_12_SUMB_5__3_), .CO(mult_12_CARRYB_6__2_), .S(mult_12_SUMB_6__2_)
         );
  FA_X1 mult_12_S2_6_1 ( .A(mult_12_ab_6__1_), .B(mult_12_CARRYB_5__1_), .CI(
        mult_12_SUMB_5__2_), .CO(mult_12_CARRYB_6__1_), .S(mult_12_SUMB_6__1_)
         );
  FA_X1 mult_12_S1_6_0 ( .A(mult_12_ab_6__0_), .B(mult_12_CARRYB_5__0_), .CI(
        mult_12_SUMB_5__1_), .CO(mult_12_CARRYB_6__0_), .S(mult_12_A1_4_) );
  FA_X1 mult_12_S5_6 ( .A(mult_12_ab_7__6_), .B(mult_12_CARRYB_6__6_), .CI(
        mult_12_ab_6__7_), .CO(mult_12_CARRYB_7__6_), .S(mult_12_SUMB_7__6_)
         );
  FA_X1 mult_12_S4_5 ( .A(mult_12_ab_7__5_), .B(mult_12_CARRYB_6__5_), .CI(
        mult_12_SUMB_6__6_), .CO(mult_12_CARRYB_7__5_), .S(mult_12_SUMB_7__5_)
         );
  FA_X1 mult_12_S4_4 ( .A(mult_12_ab_7__4_), .B(mult_12_CARRYB_6__4_), .CI(
        mult_12_SUMB_6__5_), .CO(mult_12_CARRYB_7__4_), .S(mult_12_SUMB_7__4_)
         );
  FA_X1 mult_12_S4_3 ( .A(mult_12_CARRYB_6__3_), .B(mult_12_ab_7__3_), .CI(
        mult_12_SUMB_6__4_), .CO(mult_12_CARRYB_7__3_), .S(mult_12_SUMB_7__3_)
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
  INV_X1 mult_12_FS_1_U80 ( .A(mult_12_FS_1_n50), .ZN(mult_12_FS_1_n61) );
  NAND2_X1 mult_12_FS_1_U79 ( .A1(mult_12_FS_1_n60), .A2(mult_12_FS_1_n29), 
        .ZN(mult_12_FS_1_n59) );
  XNOR2_X1 mult_12_FS_1_U78 ( .A(mult_12_FS_1_n56), .B(mult_12_FS_1_n57), .ZN(
        product[13]) );
  INV_X1 mult_12_FS_1_U77 ( .A(mult_12_FS_1_n51), .ZN(mult_12_FS_1_n33) );
  INV_X1 mult_12_FS_1_U76 ( .A(mult_12_FS_1_n45), .ZN(mult_12_FS_1_n48) );
  NAND2_X1 mult_12_FS_1_U75 ( .A1(mult_12_FS_1_n1), .A2(mult_12_FS_1_n29), 
        .ZN(mult_12_FS_1_n49) );
  OAI211_X1 mult_12_FS_1_U74 ( .C1(mult_12_FS_1_n33), .C2(mult_12_FS_1_n48), 
        .A(mult_12_FS_1_n49), .B(mult_12_FS_1_n44), .ZN(mult_12_FS_1_n46) );
  XNOR2_X1 mult_12_FS_1_U73 ( .A(mult_12_FS_1_n46), .B(mult_12_FS_1_n47), .ZN(
        product[14]) );
  INV_X1 mult_12_FS_1_U72 ( .A(mult_12_FS_1_n44), .ZN(mult_12_FS_1_n43) );
  INV_X1 mult_12_FS_1_U71 ( .A(mult_12_FS_1_n39), .ZN(mult_12_FS_1_n38) );
  OAI211_X1 mult_12_FS_1_U70 ( .C1(mult_12_FS_1_n33), .C2(mult_12_FS_1_n34), 
        .A(mult_12_FS_1_n35), .B(mult_12_FS_1_n36), .ZN(mult_12_FS_1_n31) );
  XNOR2_X1 mult_12_FS_1_U69 ( .A(mult_12_FS_1_n31), .B(mult_12_FS_1_n32), .ZN(
        product[15]) );
  NAND2_X1 mult_12_FS_1_U68 ( .A1(mult_12_FS_1_n10), .A2(mult_12_FS_1_n29), 
        .ZN(mult_12_FS_1_n27) );
  AOI21_X1 mult_12_FS_1_U67 ( .B1(mult_12_FS_1_n13), .B2(mult_12_FS_1_n37), 
        .A(mult_12_FS_1_n38), .ZN(mult_12_FS_1_n36) );
  NAND2_X1 mult_12_FS_1_U66 ( .A1(mult_12_FS_1_n70), .A2(mult_12_FS_1_n71), 
        .ZN(mult_12_FS_1_n30) );
  NAND2_X1 mult_12_FS_1_U65 ( .A1(mult_12_FS_1_n42), .A2(mult_12_FS_1_n30), 
        .ZN(mult_12_FS_1_n41) );
  INV_X1 mult_12_FS_1_U64 ( .A(mult_12_n49), .ZN(mult_12_FS_1_n71) );
  INV_X1 mult_12_FS_1_U63 ( .A(mult_12_A1_8_), .ZN(mult_12_FS_1_n73) );
  NAND2_X1 mult_12_FS_1_U62 ( .A1(mult_12_FS_1_n7), .A2(mult_12_n50), .ZN(
        mult_12_FS_1_n22) );
  NAND2_X1 mult_12_FS_1_U61 ( .A1(mult_12_FS_1_n50), .A2(mult_12_FS_1_n25), 
        .ZN(mult_12_FS_1_n52) );
  NAND2_X1 mult_12_FS_1_U60 ( .A1(mult_12_FS_1_n8), .A2(mult_12_FS_1_n25), 
        .ZN(mult_12_FS_1_n64) );
  NAND2_X1 mult_12_FS_1_U59 ( .A1(mult_12_FS_1_n69), .A2(mult_12_FS_1_n25), 
        .ZN(mult_12_FS_1_n68) );
  NAND2_X1 mult_12_FS_1_U58 ( .A1(mult_12_FS_1_n25), .A2(mult_12_FS_1_n26), 
        .ZN(mult_12_FS_1_n24) );
  OAI211_X1 mult_12_FS_1_U57 ( .C1(mult_12_FS_1_n67), .C2(mult_12_FS_1_n68), 
        .A(mult_12_FS_1_n64), .B(mult_12_FS_1_n26), .ZN(mult_12_FS_1_n65) );
  NOR2_X1 mult_12_FS_1_U56 ( .A1(mult_12_FS_1_n64), .A2(mult_12_FS_1_n61), 
        .ZN(mult_12_FS_1_n62) );
  NOR2_X1 mult_12_FS_1_U55 ( .A1(mult_12_FS_1_n62), .A2(mult_12_FS_1_n63), 
        .ZN(mult_12_FS_1_n58) );
  NAND2_X1 mult_12_FS_1_U54 ( .A1(mult_12_FS_1_n73), .A2(mult_12_FS_1_n72), 
        .ZN(mult_12_FS_1_n28) );
  INV_X1 mult_12_FS_1_U53 ( .A(mult_12_n51), .ZN(mult_12_FS_1_n72) );
  AND2_X1 mult_12_FS_1_U52 ( .A1(mult_12_FS_1_n73), .A2(mult_12_FS_1_n72), 
        .ZN(mult_12_FS_1_n21) );
  NOR2_X1 mult_12_FS_1_U51 ( .A1(mult_12_FS_1_n40), .A2(mult_12_FS_1_n41), 
        .ZN(mult_12_FS_1_n37) );
  BUF_X1 mult_12_FS_1_U50 ( .A(mult_12_A1_0_), .Z(product[2]) );
  BUF_X1 mult_12_FS_1_U49 ( .A(mult_12_A1_1_), .Z(product[3]) );
  BUF_X1 mult_12_FS_1_U48 ( .A(mult_12_A1_2_), .Z(product[4]) );
  BUF_X1 mult_12_FS_1_U47 ( .A(mult_12_A1_3_), .Z(product[5]) );
  BUF_X1 mult_12_FS_1_U46 ( .A(mult_12_A1_4_), .Z(product[6]) );
  BUF_X1 mult_12_FS_1_U45 ( .A(mult_12_SUMB_7__0_), .Z(product[7]) );
  BUF_X1 mult_12_FS_1_U44 ( .A(mult_12_n57), .Z(product[8]) );
  NAND2_X1 mult_12_FS_1_U43 ( .A1(mult_12_A2_9_), .A2(mult_12_n47), .ZN(
        mult_12_FS_1_n26) );
  AND2_X1 mult_12_FS_1_U42 ( .A1(mult_12_n47), .A2(mult_12_A2_9_), .ZN(
        mult_12_FS_1_n55) );
  NAND2_X1 mult_12_FS_1_U41 ( .A1(mult_12_FS_1_n55), .A2(mult_12_FS_1_n50), 
        .ZN(mult_12_FS_1_n53) );
  OAI211_X1 mult_12_FS_1_U40 ( .C1(mult_12_FS_1_n52), .C2(mult_12_FS_1_n4), 
        .A(mult_12_FS_1_n53), .B(mult_12_FS_1_n54), .ZN(mult_12_FS_1_n51) );
  OR2_X2 mult_12_FS_1_U39 ( .A1(mult_12_A2_9_), .A2(mult_12_n47), .ZN(
        mult_12_FS_1_n25) );
  NAND2_X1 mult_12_FS_1_U38 ( .A1(mult_12_FS_1_n27), .A2(mult_12_FS_1_n4), 
        .ZN(mult_12_FS_1_n23) );
  XNOR2_X1 mult_12_FS_1_U37 ( .A(mult_12_FS_1_n23), .B(mult_12_FS_1_n24), .ZN(
        product[11]) );
  INV_X1 mult_12_FS_1_U36 ( .A(mult_12_FS_1_n22), .ZN(mult_12_FS_1_n69) );
  NAND2_X1 mult_12_FS_1_U35 ( .A1(mult_12_FS_1_n54), .A2(mult_12_FS_1_n50), 
        .ZN(mult_12_FS_1_n66) );
  XNOR2_X1 mult_12_FS_1_U34 ( .A(mult_12_FS_1_n65), .B(mult_12_FS_1_n66), .ZN(
        product[12]) );
  OAI21_X1 mult_12_FS_1_U33 ( .B1(mult_12_FS_1_n61), .B2(mult_12_FS_1_n26), 
        .A(mult_12_FS_1_n54), .ZN(mult_12_FS_1_n63) );
  NAND2_X1 mult_12_FS_1_U32 ( .A1(mult_12_FS_1_n42), .A2(mult_12_FS_1_n39), 
        .ZN(mult_12_FS_1_n47) );
  INV_X1 mult_12_FS_1_U31 ( .A(mult_12_n12), .ZN(mult_12_FS_1_n32) );
  NAND2_X1 mult_12_FS_1_U30 ( .A1(mult_12_n55), .A2(mult_12_n56), .ZN(
        mult_12_FS_1_n39) );
  NAND2_X1 mult_12_FS_1_U29 ( .A1(mult_12_n54), .A2(mult_12_n53), .ZN(
        mult_12_FS_1_n44) );
  NAND2_X1 mult_12_FS_1_U28 ( .A1(mult_12_n52), .A2(mult_12_n48), .ZN(
        mult_12_FS_1_n54) );
  OR2_X1 mult_12_FS_1_U27 ( .A1(mult_12_n54), .A2(mult_12_n53), .ZN(
        mult_12_FS_1_n45) );
  NAND2_X1 mult_12_FS_1_U26 ( .A1(mult_12_FS_1_n44), .A2(mult_12_FS_1_n45), 
        .ZN(mult_12_FS_1_n57) );
  INV_X1 mult_12_FS_1_U25 ( .A(mult_12_n50), .ZN(mult_12_FS_1_n70) );
  AND2_X1 mult_12_FS_1_U24 ( .A1(mult_12_FS_1_n7), .A2(mult_12_n50), .ZN(
        mult_12_FS_1_n12) );
  INV_X1 mult_12_FS_1_U23 ( .A(mult_12_FS_1_n12), .ZN(mult_12_FS_1_n40) );
  AND2_X1 mult_12_FS_1_U22 ( .A1(mult_12_FS_1_n22), .A2(mult_12_FS_1_n30), 
        .ZN(product[9]) );
  NAND2_X1 mult_12_FS_1_U21 ( .A1(mult_12_FS_1_n43), .A2(mult_12_FS_1_n42), 
        .ZN(mult_12_FS_1_n35) );
  NAND2_X1 mult_12_FS_1_U20 ( .A1(mult_12_FS_1_n42), .A2(mult_12_FS_1_n45), 
        .ZN(mult_12_FS_1_n34) );
  INV_X1 mult_12_FS_1_U19 ( .A(mult_12_FS_1_n22), .ZN(mult_12_FS_1_n29) );
  INV_X1 mult_12_FS_1_U18 ( .A(mult_12_FS_1_n21), .ZN(mult_12_FS_1_n10) );
  OR2_X2 mult_12_FS_1_U17 ( .A1(mult_12_n55), .A2(mult_12_n56), .ZN(
        mult_12_FS_1_n42) );
  OR2_X2 mult_12_FS_1_U16 ( .A1(mult_12_n52), .A2(mult_12_n48), .ZN(
        mult_12_FS_1_n50) );
  AND3_X1 mult_12_FS_1_U15 ( .A1(mult_12_FS_1_n28), .A2(mult_12_FS_1_n25), 
        .A3(mult_12_FS_1_n9), .ZN(mult_12_FS_1_n13) );
  AND2_X1 mult_12_FS_1_U14 ( .A1(mult_12_FS_1_n50), .A2(mult_12_FS_1_n45), 
        .ZN(mult_12_FS_1_n9) );
  AND2_X1 mult_12_FS_1_U13 ( .A1(mult_12_A1_8_), .A2(mult_12_n51), .ZN(
        mult_12_FS_1_n8) );
  BUF_X1 mult_12_FS_1_U12 ( .A(mult_12_n49), .Z(mult_12_FS_1_n7) );
  OR2_X1 mult_12_FS_1_U11 ( .A1(mult_12_FS_1_n21), .A2(mult_12_FS_1_n5), .ZN(
        mult_12_FS_1_n67) );
  NAND2_X1 mult_12_FS_1_U10 ( .A1(mult_12_FS_1_n59), .A2(mult_12_FS_1_n58), 
        .ZN(mult_12_FS_1_n56) );
  NAND2_X1 mult_12_FS_1_U9 ( .A1(mult_12_FS_1_n10), .A2(mult_12_FS_1_n4), .ZN(
        mult_12_FS_1_n6) );
  XNOR2_X1 mult_12_FS_1_U8 ( .A(mult_12_FS_1_n6), .B(mult_12_FS_1_n29), .ZN(
        product[10]) );
  AND2_X1 mult_12_FS_1_U7 ( .A1(mult_12_FS_1_n70), .A2(mult_12_FS_1_n71), .ZN(
        mult_12_FS_1_n5) );
  NAND2_X1 mult_12_FS_1_U6 ( .A1(mult_12_A1_8_), .A2(mult_12_n51), .ZN(
        mult_12_FS_1_n4) );
  INV_X1 mult_12_FS_1_U5 ( .A(mult_12_FS_1_n2), .ZN(mult_12_FS_1_n3) );
  NOR2_X1 mult_12_FS_1_U4 ( .A1(mult_12_FS_1_n21), .A2(mult_12_FS_1_n3), .ZN(
        mult_12_FS_1_n60) );
  AND2_X1 mult_12_FS_1_U3 ( .A1(mult_12_FS_1_n25), .A2(mult_12_FS_1_n50), .ZN(
        mult_12_FS_1_n2) );
  AND3_X1 mult_12_FS_1_U2 ( .A1(mult_12_FS_1_n28), .A2(mult_12_FS_1_n25), .A3(
        mult_12_FS_1_n9), .ZN(mult_12_FS_1_n1) );
endmodule

