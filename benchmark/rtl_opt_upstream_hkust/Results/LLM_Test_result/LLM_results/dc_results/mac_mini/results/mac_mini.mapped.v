/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:08:47 2025
/////////////////////////////////////////////////////////////


module mac_mini ( clk, a, b, reset, z );
  input [7:0] a;
  input [7:0] b;
  output [15:0] z;
  input clk, reset;
  wire   N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16, N17,
         N18, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47,
         N48, N49, N50, product_9_, product_8_, product_7_, product_6_,
         product_5_, product_4_, product_3_, product_2_, product_1_,
         product_15_, product_14_, product_13_, product_12_, product_11_,
         product_10_, product_0_, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, mult_12_n92,
         mult_12_n91, mult_12_n90, mult_12_n89, mult_12_n88, mult_12_n87,
         mult_12_n86, mult_12_n85, mult_12_n84, mult_12_n83, mult_12_n82,
         mult_12_n81, mult_12_n80, mult_12_n79, mult_12_n78, mult_12_n77,
         mult_12_n76, mult_12_n75, mult_12_n74, mult_12_n73, mult_12_n72,
         mult_12_n71, mult_12_n70, mult_12_n69, mult_12_n68, mult_12_n67,
         mult_12_n66, mult_12_n65, mult_12_n64, mult_12_n63, mult_12_n62,
         mult_12_n61, mult_12_n59, mult_12_n58, mult_12_n57, mult_12_n56,
         mult_12_n55, mult_12_n54, mult_12_n53, mult_12_n52, mult_12_n51,
         mult_12_n50, mult_12_n49, mult_12_n48, mult_12_n47, mult_12_n46,
         mult_12_n45, mult_12_n44, mult_12_n43, mult_12_n42, mult_12_n41,
         mult_12_n40, mult_12_n39, mult_12_n38, mult_12_n37, mult_12_n36,
         mult_12_n35, mult_12_n34, mult_12_n33, mult_12_n32, mult_12_n31,
         mult_12_n30, mult_12_n29, mult_12_n28, mult_12_n27, mult_12_n26,
         mult_12_n25, mult_12_n24, mult_12_n23, mult_12_n22, mult_12_n21,
         mult_12_n20, mult_12_n19, mult_12_n18, mult_12_n17, mult_12_n16,
         mult_12_n15, mult_12_n14, mult_12_n13, mult_12_n12, mult_12_n11,
         mult_12_n10, mult_12_n9, mult_12_n8, mult_12_n7, mult_12_n6,
         mult_12_n5, mult_12_n4, mult_12_n3, mult_12_n2, mult_12_A2_6_,
         mult_12_A1_0_, mult_12_A1_1_, mult_12_A1_2_, mult_12_A1_3_,
         mult_12_A1_4_, mult_12_A1_5_, mult_12_A1_13_, mult_12_SUMB_1__6_,
         mult_12_SUMB_2__1_, mult_12_SUMB_2__2_, mult_12_SUMB_2__3_,
         mult_12_SUMB_2__4_, mult_12_SUMB_2__5_, mult_12_SUMB_2__6_,
         mult_12_SUMB_3__1_, mult_12_SUMB_3__2_, mult_12_SUMB_3__3_,
         mult_12_SUMB_3__4_, mult_12_SUMB_3__5_, mult_12_SUMB_3__6_,
         mult_12_SUMB_4__1_, mult_12_SUMB_4__2_, mult_12_SUMB_4__3_,
         mult_12_SUMB_4__4_, mult_12_SUMB_4__5_, mult_12_SUMB_4__6_,
         mult_12_SUMB_5__1_, mult_12_SUMB_5__2_, mult_12_SUMB_5__3_,
         mult_12_SUMB_5__4_, mult_12_SUMB_5__5_, mult_12_SUMB_5__6_,
         mult_12_SUMB_6__1_, mult_12_SUMB_6__2_, mult_12_SUMB_6__3_,
         mult_12_SUMB_6__4_, mult_12_SUMB_6__5_, mult_12_SUMB_6__6_,
         mult_12_SUMB_7__0_, mult_12_SUMB_7__1_, mult_12_SUMB_7__2_,
         mult_12_SUMB_7__3_, mult_12_SUMB_7__4_, mult_12_SUMB_7__5_,
         mult_12_SUMB_7__6_, mult_12_SUMB_7__7_, mult_12_CARRYB_1__6_,
         mult_12_CARRYB_2__0_, mult_12_CARRYB_2__1_, mult_12_CARRYB_2__2_,
         mult_12_CARRYB_2__3_, mult_12_CARRYB_2__4_, mult_12_CARRYB_2__5_,
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
         mult_12_ab_0__4_, mult_12_ab_0__5_, mult_12_ab_0__6_,
         mult_12_ab_0__7_, mult_12_ab_1__0_, mult_12_ab_1__1_,
         mult_12_ab_1__2_, mult_12_ab_1__3_, mult_12_ab_1__4_,
         mult_12_ab_1__5_, mult_12_ab_1__6_, mult_12_ab_1__7_,
         mult_12_ab_2__0_, mult_12_ab_2__1_, mult_12_ab_2__2_,
         mult_12_ab_2__3_, mult_12_ab_2__4_, mult_12_ab_2__5_,
         mult_12_ab_2__6_, mult_12_ab_2__7_, mult_12_ab_3__0_,
         mult_12_ab_3__1_, mult_12_ab_3__2_, mult_12_ab_3__3_,
         mult_12_ab_3__4_, mult_12_ab_3__5_, mult_12_ab_3__6_,
         mult_12_ab_3__7_, mult_12_ab_4__0_, mult_12_ab_4__1_,
         mult_12_ab_4__2_, mult_12_ab_4__3_, mult_12_ab_4__4_,
         mult_12_ab_4__5_, mult_12_ab_4__6_, mult_12_ab_4__7_,
         mult_12_ab_5__0_, mult_12_ab_5__1_, mult_12_ab_5__2_,
         mult_12_ab_5__3_, mult_12_ab_5__4_, mult_12_ab_5__5_,
         mult_12_ab_5__6_, mult_12_ab_5__7_, mult_12_ab_6__0_,
         mult_12_ab_6__1_, mult_12_ab_6__2_, mult_12_ab_6__3_,
         mult_12_ab_6__4_, mult_12_ab_6__5_, mult_12_ab_6__6_,
         mult_12_ab_6__7_, mult_12_ab_7__0_, mult_12_ab_7__1_,
         mult_12_ab_7__2_, mult_12_ab_7__3_, mult_12_ab_7__4_,
         mult_12_ab_7__5_, mult_12_ab_7__6_, mult_12_ab_7__7_,
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
         mult_12_FS_1_n23, mult_12_FS_1_n22, mult_12_FS_1_n21,
         mult_12_FS_1_n20, mult_12_FS_1_n13, mult_12_FS_1_n12,
         mult_12_FS_1_n11, mult_12_FS_1_n10, mult_12_FS_1_n9, mult_12_FS_1_n8,
         mult_12_FS_1_n7, mult_12_FS_1_n6, mult_12_FS_1_n5, mult_12_FS_1_n3,
         mult_12_FS_1_n2, mult_12_FS_1_n1, r60_n128, r60_n127, r60_n126,
         r60_n125, r60_n124, r60_n123, r60_n122, r60_n121, r60_n120, r60_n119,
         r60_n118, r60_n117, r60_n116, r60_n115, r60_n114, r60_n113, r60_n112,
         r60_n111, r60_n110, r60_n109, r60_n108, r60_n107, r60_n106, r60_n105,
         r60_n104, r60_n103, r60_n102, r60_n101, r60_n100, r60_n99, r60_n98,
         r60_n97, r60_n96, r60_n95, r60_n94, r60_n93, r60_n92, r60_n91,
         r60_n90, r60_n89, r60_n88, r60_n87, r60_n86, r60_n85, r60_n84,
         r60_n83, r60_n82, r60_n81, r60_n80, r60_n79, r60_n78, r60_n77,
         r60_n76, r60_n75, r60_n74, r60_n73, r60_n72, r60_n71, r60_n70,
         r60_n69, r60_n68, r60_n67, r60_n66, r60_n65, r60_n64, r60_n63,
         r60_n62, r60_n61, r60_n60, r60_n59, r60_n58, r60_n57, r60_n56,
         r60_n55, r60_n54, r60_n53, r60_n52, r60_n51, r60_n50, r60_n49,
         r60_n48, r60_n47, r60_n46, r60_n45, r60_n44, r60_n43, r60_n42,
         r60_n41, r60_n40, r60_n39, r60_n38, r60_n37, r60_n36, r60_n35,
         r60_n34, r60_n33, r60_n32, r60_n31, r60_n30, r60_n29, r60_n28,
         r60_n27, r60_n26, r60_n25, r60_n24, r60_n23, r60_n22, r60_n20,
         r60_n19, r60_n18, r60_n17, r60_n16, r60_n15, r60_n14, r60_n13,
         r60_n12, r60_n11, r60_n10, r60_n9, r60_n8, r60_n7, r60_n6, r60_n5,
         r60_n4, r60_n3, r60_n2, r60_n1;
  wire   [7:0] a_reg;
  wire   [7:0] b_reg;
  wire   [15:0] acc;

  DFF_X1 a_reg_reg_7_ ( .D(N42), .CK(clk), .Q(a_reg[7]) );
  DFF_X1 a_reg_reg_6_ ( .D(N41), .CK(clk), .Q(a_reg[6]) );
  DFF_X1 a_reg_reg_5_ ( .D(N40), .CK(clk), .Q(a_reg[5]) );
  DFF_X1 a_reg_reg_4_ ( .D(N39), .CK(clk), .Q(a_reg[4]) );
  DFF_X1 a_reg_reg_3_ ( .D(N38), .CK(clk), .Q(a_reg[3]) );
  DFF_X1 b_reg_reg_7_ ( .D(N50), .CK(clk), .Q(b_reg[7]) );
  DFF_X1 b_reg_reg_6_ ( .D(N49), .CK(clk), .Q(b_reg[6]) );
  DFF_X1 b_reg_reg_5_ ( .D(N48), .CK(clk), .Q(b_reg[5]) );
  DFF_X1 b_reg_reg_4_ ( .D(N47), .CK(clk), .Q(b_reg[4]) );
  DFF_X1 b_reg_reg_3_ ( .D(N46), .CK(clk), .Q(b_reg[3]) );
  DFF_X1 acc_reg_11_ ( .D(n16), .CK(clk), .Q(acc[11]) );
  DFF_X1 acc_reg_10_ ( .D(n13), .CK(clk), .Q(acc[10]) );
  DFF_X1 acc_reg_9_ ( .D(n12), .CK(clk), .Q(acc[9]) );
  DFF_X1 acc_reg_8_ ( .D(n17), .CK(clk), .Q(acc[8]) );
  DFF_X1 acc_reg_7_ ( .D(n11), .CK(clk), .Q(acc[7]) );
  DFF_X1 acc_reg_6_ ( .D(n5), .CK(clk), .Q(acc[6]) );
  DFF_X1 acc_reg_5_ ( .D(n6), .CK(clk), .Q(acc[5]) );
  DFF_X1 acc_reg_4_ ( .D(n7), .CK(clk), .Q(acc[4]) );
  DFF_X1 acc_reg_3_ ( .D(n18), .CK(clk), .Q(acc[3]) );
  DFF_X1 acc_reg_2_ ( .D(n8), .CK(clk), .Q(acc[2]) );
  DFF_X1 acc_reg_1_ ( .D(n9), .CK(clk), .Q(acc[1]) );
  DFF_X1 acc_reg_0_ ( .D(n10), .CK(clk), .Q(acc[0]) );
  DFF_X1 z_reg_11_ ( .D(n16), .CK(clk), .Q(z[11]) );
  DFF_X1 z_reg_10_ ( .D(n13), .CK(clk), .Q(z[10]) );
  DFF_X1 z_reg_9_ ( .D(n12), .CK(clk), .Q(z[9]) );
  DFF_X1 z_reg_8_ ( .D(n17), .CK(clk), .Q(z[8]) );
  DFF_X1 z_reg_7_ ( .D(n11), .CK(clk), .Q(z[7]) );
  DFF_X1 z_reg_6_ ( .D(n5), .CK(clk), .Q(z[6]) );
  DFF_X1 z_reg_5_ ( .D(n6), .CK(clk), .Q(z[5]) );
  DFF_X1 z_reg_4_ ( .D(n7), .CK(clk), .Q(z[4]) );
  DFF_X1 z_reg_3_ ( .D(n18), .CK(clk), .Q(z[3]) );
  DFF_X1 z_reg_2_ ( .D(n8), .CK(clk), .Q(z[2]) );
  DFF_X1 z_reg_1_ ( .D(n9), .CK(clk), .Q(z[1]) );
  DFF_X1 z_reg_0_ ( .D(n10), .CK(clk), .Q(z[0]) );
  DFF_X1 z_reg_12_ ( .D(n14), .CK(clk), .Q(z[12]) );
  DFF_X1 acc_reg_12_ ( .D(n14), .CK(clk), .Q(acc[12]) );
  DFF_X1 z_reg_14_ ( .D(n15), .CK(clk), .Q(z[14]) );
  DFF_X1 acc_reg_13_ ( .D(n20), .CK(clk), .Q(acc[13]) );
  DFF_X1 z_reg_13_ ( .D(n20), .CK(clk), .Q(z[13]) );
  DFF_X1 z_reg_15_ ( .D(n19), .CK(clk), .Q(z[15]) );
  DFF_X1 acc_reg_15_ ( .D(n19), .CK(clk), .Q(acc[15]) );
  DFF_X1 b_reg_reg_0_ ( .D(N43), .CK(clk), .Q(b_reg[0]) );
  DFF_X1 a_reg_reg_2_ ( .D(N37), .CK(clk), .Q(a_reg[2]) );
  DFF_X1 b_reg_reg_1_ ( .D(N44), .CK(clk), .Q(b_reg[1]) );
  DFF_X1 b_reg_reg_2_ ( .D(N45), .CK(clk), .Q(b_reg[2]) );
  DFF_X1 a_reg_reg_0_ ( .D(N35), .CK(clk), .Q(a_reg[0]) );
  DFF_X1 a_reg_reg_1_ ( .D(N36), .CK(clk), .Q(a_reg[1]) );
  DFF_X2 acc_reg_14_ ( .D(n15), .CK(clk), .Q(acc[14]) );
  AND2_X1 U36 ( .A1(N9), .A2(n21), .ZN(n5) );
  AND2_X1 U37 ( .A1(N8), .A2(n21), .ZN(n6) );
  AND2_X1 U38 ( .A1(N7), .A2(n21), .ZN(n7) );
  AND2_X1 U39 ( .A1(N5), .A2(n21), .ZN(n8) );
  AND2_X1 U40 ( .A1(N4), .A2(n21), .ZN(n9) );
  AND2_X1 U41 ( .A1(N3), .A2(n21), .ZN(n10) );
  AND2_X1 U42 ( .A1(N10), .A2(n21), .ZN(n11) );
  AND2_X1 U43 ( .A1(N12), .A2(n21), .ZN(n12) );
  AND2_X1 U44 ( .A1(N13), .A2(n21), .ZN(n13) );
  AND2_X1 U45 ( .A1(N15), .A2(n22), .ZN(n14) );
  AND2_X1 U46 ( .A1(N18), .A2(n22), .ZN(n19) );
  BUF_X2 U47 ( .A(n24), .Z(n22) );
  AND2_X1 U48 ( .A1(N17), .A2(n22), .ZN(n15) );
  AND2_X1 U49 ( .A1(N14), .A2(n21), .ZN(n16) );
  AND2_X1 U50 ( .A1(N11), .A2(n21), .ZN(n17) );
  AND2_X1 U51 ( .A1(N6), .A2(n21), .ZN(n18) );
  BUF_X1 U52 ( .A(n24), .Z(n21) );
  BUF_X1 U53 ( .A(n24), .Z(n23) );
  AND2_X1 U54 ( .A1(N16), .A2(n22), .ZN(n20) );
  INV_X1 U55 ( .A(reset), .ZN(n24) );
  AND2_X1 U56 ( .A1(b[0]), .A2(n23), .ZN(N43) );
  AND2_X1 U57 ( .A1(b[1]), .A2(n23), .ZN(N44) );
  AND2_X1 U58 ( .A1(b[2]), .A2(n23), .ZN(N45) );
  AND2_X1 U59 ( .A1(b[3]), .A2(n23), .ZN(N46) );
  AND2_X1 U60 ( .A1(b[4]), .A2(n23), .ZN(N47) );
  AND2_X1 U61 ( .A1(b[5]), .A2(n23), .ZN(N48) );
  AND2_X1 U62 ( .A1(b[6]), .A2(n22), .ZN(N49) );
  AND2_X1 U63 ( .A1(b[7]), .A2(n22), .ZN(N50) );
  AND2_X1 U64 ( .A1(a[0]), .A2(n22), .ZN(N35) );
  AND2_X1 U65 ( .A1(a[1]), .A2(n22), .ZN(N36) );
  AND2_X1 U66 ( .A1(a[2]), .A2(n22), .ZN(N37) );
  AND2_X1 U67 ( .A1(a[3]), .A2(n22), .ZN(N38) );
  AND2_X1 U68 ( .A1(a[4]), .A2(n22), .ZN(N39) );
  AND2_X1 U69 ( .A1(a[5]), .A2(n22), .ZN(N40) );
  AND2_X1 U70 ( .A1(a[6]), .A2(n22), .ZN(N41) );
  AND2_X1 U71 ( .A1(a[7]), .A2(n22), .ZN(N42) );
  INV_X1 mult_12_U176 ( .A(mult_12_CARRYB_7__7_), .ZN(mult_12_A1_13_) );
  NOR2_X1 mult_12_U175 ( .A1(mult_12_n90), .A2(mult_12_n89), .ZN(product_0_)
         );
  NOR2_X1 mult_12_U174 ( .A1(b_reg[0]), .A2(mult_12_n91), .ZN(mult_12_ab_7__0_) );
  NOR2_X1 mult_12_U173 ( .A1(b_reg[1]), .A2(mult_12_n91), .ZN(mult_12_ab_7__1_) );
  NOR2_X1 mult_12_U172 ( .A1(b_reg[2]), .A2(mult_12_n91), .ZN(mult_12_ab_7__2_) );
  NOR2_X1 mult_12_U171 ( .A1(b_reg[3]), .A2(mult_12_n91), .ZN(mult_12_ab_7__3_) );
  NOR2_X1 mult_12_U170 ( .A1(b_reg[4]), .A2(mult_12_n91), .ZN(mult_12_ab_7__4_) );
  NOR2_X1 mult_12_U169 ( .A1(b_reg[5]), .A2(mult_12_n91), .ZN(mult_12_ab_7__5_) );
  NOR2_X1 mult_12_U168 ( .A1(a_reg[6]), .A2(mult_12_n22), .ZN(mult_12_ab_6__7_) );
  NOR2_X1 mult_12_U167 ( .A1(mult_12_n76), .A2(mult_12_n91), .ZN(
        mult_12_ab_7__6_) );
  NOR2_X1 mult_12_U166 ( .A1(mult_12_n22), .A2(mult_12_n91), .ZN(
        mult_12_ab_7__7_) );
  NOR2_X1 mult_12_U165 ( .A1(mult_12_n89), .A2(mult_12_n88), .ZN(
        mult_12_ab_6__0_) );
  NOR2_X1 mult_12_U164 ( .A1(mult_12_n88), .A2(mult_12_n87), .ZN(
        mult_12_ab_6__1_) );
  NOR2_X1 mult_12_U163 ( .A1(mult_12_n88), .A2(mult_12_n86), .ZN(
        mult_12_ab_6__2_) );
  NOR2_X1 mult_12_U162 ( .A1(mult_12_n88), .A2(mult_12_n85), .ZN(
        mult_12_ab_6__3_) );
  NOR2_X1 mult_12_U161 ( .A1(mult_12_n88), .A2(mult_12_n23), .ZN(
        mult_12_ab_6__4_) );
  NOR2_X1 mult_12_U160 ( .A1(mult_12_n88), .A2(mult_12_n83), .ZN(
        mult_12_ab_6__5_) );
  NOR2_X1 mult_12_U159 ( .A1(a_reg[5]), .A2(mult_12_n22), .ZN(mult_12_ab_5__7_) );
  NOR2_X1 mult_12_U158 ( .A1(mult_12_n88), .A2(mult_12_n82), .ZN(
        mult_12_ab_6__6_) );
  INV_X1 mult_12_U157 ( .A(a_reg[6]), .ZN(mult_12_n88) );
  NOR2_X1 mult_12_U156 ( .A1(mult_12_n89), .A2(mult_12_n81), .ZN(
        mult_12_ab_5__0_) );
  NOR2_X1 mult_12_U155 ( .A1(mult_12_n87), .A2(mult_12_n81), .ZN(
        mult_12_ab_5__1_) );
  NOR2_X1 mult_12_U154 ( .A1(mult_12_n86), .A2(mult_12_n81), .ZN(
        mult_12_ab_5__2_) );
  NOR2_X1 mult_12_U153 ( .A1(mult_12_n85), .A2(mult_12_n81), .ZN(
        mult_12_ab_5__3_) );
  NOR2_X1 mult_12_U152 ( .A1(mult_12_n23), .A2(mult_12_n81), .ZN(
        mult_12_ab_5__4_) );
  NOR2_X1 mult_12_U151 ( .A1(mult_12_n83), .A2(mult_12_n81), .ZN(
        mult_12_ab_5__5_) );
  NOR2_X1 mult_12_U150 ( .A1(a_reg[4]), .A2(mult_12_n22), .ZN(mult_12_ab_4__7_) );
  NOR2_X1 mult_12_U149 ( .A1(mult_12_n82), .A2(mult_12_n81), .ZN(
        mult_12_ab_5__6_) );
  INV_X1 mult_12_U148 ( .A(a_reg[5]), .ZN(mult_12_n81) );
  NOR2_X1 mult_12_U147 ( .A1(mult_12_n89), .A2(mult_12_n80), .ZN(
        mult_12_ab_4__0_) );
  NOR2_X1 mult_12_U146 ( .A1(mult_12_n87), .A2(mult_12_n80), .ZN(
        mult_12_ab_4__1_) );
  NOR2_X1 mult_12_U145 ( .A1(mult_12_n86), .A2(mult_12_n80), .ZN(
        mult_12_ab_4__2_) );
  NOR2_X1 mult_12_U144 ( .A1(mult_12_n85), .A2(mult_12_n80), .ZN(
        mult_12_ab_4__3_) );
  NOR2_X1 mult_12_U143 ( .A1(mult_12_n23), .A2(mult_12_n80), .ZN(
        mult_12_ab_4__4_) );
  NOR2_X1 mult_12_U142 ( .A1(mult_12_n83), .A2(mult_12_n80), .ZN(
        mult_12_ab_4__5_) );
  NOR2_X1 mult_12_U141 ( .A1(a_reg[3]), .A2(mult_12_n22), .ZN(mult_12_ab_3__7_) );
  NOR2_X1 mult_12_U140 ( .A1(mult_12_n82), .A2(mult_12_n80), .ZN(
        mult_12_ab_4__6_) );
  INV_X1 mult_12_U139 ( .A(a_reg[4]), .ZN(mult_12_n80) );
  NOR2_X1 mult_12_U138 ( .A1(mult_12_n89), .A2(mult_12_n79), .ZN(
        mult_12_ab_3__0_) );
  NOR2_X1 mult_12_U137 ( .A1(mult_12_n87), .A2(mult_12_n79), .ZN(
        mult_12_ab_3__1_) );
  NOR2_X1 mult_12_U136 ( .A1(mult_12_n86), .A2(mult_12_n79), .ZN(
        mult_12_ab_3__2_) );
  NOR2_X1 mult_12_U135 ( .A1(mult_12_n85), .A2(mult_12_n79), .ZN(
        mult_12_ab_3__3_) );
  NOR2_X1 mult_12_U134 ( .A1(mult_12_n84), .A2(mult_12_n79), .ZN(
        mult_12_ab_3__4_) );
  NOR2_X1 mult_12_U133 ( .A1(mult_12_n83), .A2(mult_12_n79), .ZN(
        mult_12_ab_3__5_) );
  NOR2_X1 mult_12_U132 ( .A1(a_reg[2]), .A2(mult_12_n22), .ZN(mult_12_ab_2__7_) );
  NOR2_X1 mult_12_U131 ( .A1(mult_12_n82), .A2(mult_12_n79), .ZN(
        mult_12_ab_3__6_) );
  INV_X1 mult_12_U130 ( .A(a_reg[3]), .ZN(mult_12_n79) );
  NOR2_X1 mult_12_U129 ( .A1(mult_12_n89), .A2(mult_12_n25), .ZN(
        mult_12_ab_2__0_) );
  NOR2_X1 mult_12_U128 ( .A1(mult_12_n87), .A2(mult_12_n25), .ZN(
        mult_12_ab_2__1_) );
  NOR2_X1 mult_12_U127 ( .A1(mult_12_n86), .A2(mult_12_n25), .ZN(
        mult_12_ab_2__2_) );
  NOR2_X1 mult_12_U126 ( .A1(mult_12_n85), .A2(mult_12_n78), .ZN(
        mult_12_ab_2__3_) );
  NOR2_X1 mult_12_U125 ( .A1(mult_12_n84), .A2(mult_12_n78), .ZN(
        mult_12_ab_2__4_) );
  NOR2_X1 mult_12_U124 ( .A1(mult_12_n83), .A2(mult_12_n78), .ZN(
        mult_12_ab_2__5_) );
  NOR2_X1 mult_12_U123 ( .A1(mult_12_n92), .A2(a_reg[1]), .ZN(mult_12_ab_1__7_) );
  INV_X1 mult_12_U122 ( .A(a_reg[2]), .ZN(mult_12_n78) );
  NOR2_X1 mult_12_U121 ( .A1(mult_12_n89), .A2(mult_12_n31), .ZN(
        mult_12_ab_1__0_) );
  INV_X1 mult_12_U120 ( .A(b_reg[0]), .ZN(mult_12_n89) );
  NOR2_X1 mult_12_U119 ( .A1(mult_12_n90), .A2(mult_12_n87), .ZN(
        mult_12_ab_0__1_) );
  NOR2_X1 mult_12_U118 ( .A1(mult_12_n87), .A2(mult_12_n31), .ZN(
        mult_12_ab_1__1_) );
  INV_X1 mult_12_U117 ( .A(b_reg[1]), .ZN(mult_12_n87) );
  NOR2_X1 mult_12_U116 ( .A1(mult_12_n90), .A2(mult_12_n86), .ZN(
        mult_12_ab_0__2_) );
  NOR2_X1 mult_12_U115 ( .A1(mult_12_n31), .A2(mult_12_n86), .ZN(
        mult_12_ab_1__2_) );
  INV_X1 mult_12_U114 ( .A(b_reg[2]), .ZN(mult_12_n86) );
  NOR2_X1 mult_12_U113 ( .A1(mult_12_n90), .A2(mult_12_n85), .ZN(
        mult_12_ab_0__3_) );
  INV_X1 mult_12_U112 ( .A(b_reg[3]), .ZN(mult_12_n85) );
  INV_X1 mult_12_U111 ( .A(b_reg[4]), .ZN(mult_12_n84) );
  INV_X1 mult_12_U110 ( .A(b_reg[5]), .ZN(mult_12_n83) );
  INV_X1 mult_12_U109 ( .A(a_reg[0]), .ZN(mult_12_n90) );
  NOR2_X1 mult_12_U108 ( .A1(mult_12_n92), .A2(a_reg[0]), .ZN(mult_12_ab_0__7_) );
  INV_X2 mult_12_U107 ( .A(a_reg[7]), .ZN(mult_12_n91) );
  INV_X1 mult_12_U106 ( .A(mult_12_n22), .ZN(mult_12_n77) );
  INV_X1 mult_12_U105 ( .A(mult_12_n82), .ZN(mult_12_n76) );
  AND2_X1 mult_12_U104 ( .A1(mult_12_CARRYB_7__6_), .A2(mult_12_SUMB_7__7_), 
        .ZN(mult_12_n75) );
  XOR2_X1 mult_12_U103 ( .A(mult_12_CARRYB_7__6_), .B(mult_12_SUMB_7__7_), .Z(
        mult_12_n74) );
  AND2_X1 mult_12_U102 ( .A1(mult_12_CARRYB_7__5_), .A2(mult_12_SUMB_7__6_), 
        .ZN(mult_12_n73) );
  AND2_X1 mult_12_U101 ( .A1(mult_12_CARRYB_7__4_), .A2(mult_12_SUMB_7__5_), 
        .ZN(mult_12_n72) );
  XOR2_X1 mult_12_U100 ( .A(mult_12_CARRYB_7__5_), .B(mult_12_SUMB_7__6_), .Z(
        mult_12_n71) );
  AND2_X1 mult_12_U99 ( .A1(mult_12_CARRYB_7__3_), .A2(mult_12_SUMB_7__4_), 
        .ZN(mult_12_n70) );
  XOR2_X1 mult_12_U98 ( .A(mult_12_CARRYB_7__4_), .B(mult_12_SUMB_7__5_), .Z(
        mult_12_n69) );
  AND2_X1 mult_12_U97 ( .A1(mult_12_SUMB_7__2_), .A2(mult_12_CARRYB_7__1_), 
        .ZN(mult_12_n68) );
  XOR2_X1 mult_12_U96 ( .A(mult_12_SUMB_7__3_), .B(mult_12_CARRYB_7__2_), .Z(
        mult_12_n66) );
  AND2_X1 mult_12_U95 ( .A1(mult_12_SUMB_7__3_), .A2(mult_12_CARRYB_7__2_), 
        .ZN(mult_12_n65) );
  XOR2_X1 mult_12_U94 ( .A(mult_12_SUMB_7__2_), .B(mult_12_CARRYB_7__1_), .Z(
        mult_12_n64) );
  AND2_X1 mult_12_U93 ( .A1(mult_12_ab_0__6_), .A2(mult_12_ab_1__5_), .ZN(
        mult_12_n62) );
  XOR2_X1 mult_12_U92 ( .A(mult_12_SUMB_7__4_), .B(mult_12_CARRYB_7__3_), .Z(
        mult_12_n61) );
  XOR2_X1 mult_12_U91 ( .A(mult_12_ab_1__0_), .B(mult_12_ab_0__1_), .Z(
        product_1_) );
  AND2_X1 mult_12_U90 ( .A1(mult_12_SUMB_7__1_), .A2(mult_12_CARRYB_7__0_), 
        .ZN(mult_12_n63) );
  NAND3_X1 mult_12_U89 ( .A1(mult_12_n57), .A2(mult_12_n58), .A3(mult_12_n59), 
        .ZN(mult_12_CARRYB_6__1_) );
  NAND2_X1 mult_12_U88 ( .A1(mult_12_CARRYB_5__1_), .A2(mult_12_SUMB_5__2_), 
        .ZN(mult_12_n59) );
  NAND2_X1 mult_12_U87 ( .A1(mult_12_ab_6__1_), .A2(mult_12_SUMB_5__2_), .ZN(
        mult_12_n58) );
  NAND2_X1 mult_12_U86 ( .A1(mult_12_ab_6__1_), .A2(mult_12_CARRYB_5__1_), 
        .ZN(mult_12_n57) );
  NAND3_X1 mult_12_U85 ( .A1(mult_12_n54), .A2(mult_12_n55), .A3(mult_12_n56), 
        .ZN(mult_12_CARRYB_5__2_) );
  NAND2_X1 mult_12_U84 ( .A1(mult_12_CARRYB_4__2_), .A2(mult_12_SUMB_4__3_), 
        .ZN(mult_12_n56) );
  NAND2_X1 mult_12_U83 ( .A1(mult_12_SUMB_4__3_), .A2(mult_12_ab_5__2_), .ZN(
        mult_12_n55) );
  NAND2_X1 mult_12_U82 ( .A1(mult_12_ab_5__2_), .A2(mult_12_CARRYB_4__2_), 
        .ZN(mult_12_n54) );
  NAND3_X1 mult_12_U81 ( .A1(mult_12_n51), .A2(mult_12_n52), .A3(mult_12_n53), 
        .ZN(mult_12_CARRYB_2__5_) );
  NAND2_X1 mult_12_U80 ( .A1(mult_12_n62), .A2(mult_12_ab_2__5_), .ZN(
        mult_12_n53) );
  NAND2_X1 mult_12_U79 ( .A1(mult_12_SUMB_1__6_), .A2(mult_12_ab_2__5_), .ZN(
        mult_12_n52) );
  NAND2_X1 mult_12_U78 ( .A1(mult_12_SUMB_1__6_), .A2(mult_12_n62), .ZN(
        mult_12_n51) );
  NAND2_X1 mult_12_U77 ( .A1(mult_12_ab_2__6_), .A2(mult_12_ab_1__7_), .ZN(
        mult_12_n50) );
  NAND2_X1 mult_12_U76 ( .A1(mult_12_CARRYB_1__6_), .A2(mult_12_ab_1__7_), 
        .ZN(mult_12_n49) );
  NAND2_X1 mult_12_U75 ( .A1(mult_12_CARRYB_1__6_), .A2(mult_12_ab_2__6_), 
        .ZN(mult_12_n48) );
  XOR2_X1 mult_12_U74 ( .A(mult_12_n47), .B(mult_12_CARRYB_1__6_), .Z(
        mult_12_SUMB_2__6_) );
  XOR2_X1 mult_12_U73 ( .A(mult_12_ab_2__6_), .B(mult_12_ab_1__7_), .Z(
        mult_12_n47) );
  NAND3_X1 mult_12_U72 ( .A1(mult_12_n45), .A2(mult_12_n46), .A3(mult_12_n44), 
        .ZN(mult_12_CARRYB_5__3_) );
  NAND2_X1 mult_12_U71 ( .A1(mult_12_CARRYB_4__3_), .A2(mult_12_SUMB_4__4_), 
        .ZN(mult_12_n46) );
  NAND2_X1 mult_12_U70 ( .A1(mult_12_ab_5__3_), .A2(mult_12_SUMB_4__4_), .ZN(
        mult_12_n45) );
  NAND2_X1 mult_12_U69 ( .A1(mult_12_ab_5__3_), .A2(mult_12_CARRYB_4__3_), 
        .ZN(mult_12_n44) );
  NAND3_X1 mult_12_U68 ( .A1(mult_12_n42), .A2(mult_12_n43), .A3(mult_12_n41), 
        .ZN(mult_12_CARRYB_4__4_) );
  NAND2_X1 mult_12_U67 ( .A1(mult_12_SUMB_3__5_), .A2(mult_12_CARRYB_3__4_), 
        .ZN(mult_12_n43) );
  NAND2_X1 mult_12_U66 ( .A1(mult_12_SUMB_3__5_), .A2(mult_12_ab_4__4_), .ZN(
        mult_12_n42) );
  NAND2_X1 mult_12_U65 ( .A1(mult_12_ab_4__4_), .A2(mult_12_CARRYB_3__4_), 
        .ZN(mult_12_n41) );
  XNOR2_X1 mult_12_U64 ( .A(mult_12_ab_5__3_), .B(mult_12_CARRYB_4__3_), .ZN(
        mult_12_n40) );
  XNOR2_X1 mult_12_U63 ( .A(mult_12_n40), .B(mult_12_SUMB_4__4_), .ZN(
        mult_12_SUMB_5__3_) );
  NAND3_X1 mult_12_U62 ( .A1(mult_12_n37), .A2(mult_12_n38), .A3(mult_12_n39), 
        .ZN(mult_12_CARRYB_3__6_) );
  NAND2_X1 mult_12_U61 ( .A1(mult_12_ab_3__6_), .A2(mult_12_ab_2__7_), .ZN(
        mult_12_n39) );
  NAND2_X1 mult_12_U60 ( .A1(mult_12_n16), .A2(mult_12_ab_2__7_), .ZN(
        mult_12_n38) );
  NAND2_X1 mult_12_U59 ( .A1(mult_12_n16), .A2(mult_12_ab_3__6_), .ZN(
        mult_12_n37) );
  XNOR2_X1 mult_12_U58 ( .A(mult_12_ab_4__4_), .B(mult_12_CARRYB_3__4_), .ZN(
        mult_12_n36) );
  XNOR2_X1 mult_12_U57 ( .A(mult_12_n36), .B(mult_12_n30), .ZN(
        mult_12_SUMB_4__4_) );
  XNOR2_X1 mult_12_U56 ( .A(mult_12_n62), .B(mult_12_ab_2__5_), .ZN(
        mult_12_n35) );
  XNOR2_X1 mult_12_U55 ( .A(mult_12_SUMB_1__6_), .B(mult_12_n35), .ZN(
        mult_12_SUMB_2__5_) );
  XNOR2_X1 mult_12_U54 ( .A(mult_12_ab_5__2_), .B(mult_12_CARRYB_4__2_), .ZN(
        mult_12_n34) );
  XNOR2_X1 mult_12_U53 ( .A(mult_12_n34), .B(mult_12_SUMB_4__3_), .ZN(
        mult_12_SUMB_5__2_) );
  INV_X1 mult_12_U52 ( .A(b_reg[6]), .ZN(mult_12_n82) );
  AND2_X1 mult_12_U51 ( .A1(a_reg[1]), .A2(b_reg[6]), .ZN(mult_12_ab_1__6_) );
  AND2_X1 mult_12_U50 ( .A1(a_reg[0]), .A2(b_reg[5]), .ZN(mult_12_ab_0__5_) );
  XOR2_X1 mult_12_U49 ( .A(mult_12_ab_1__4_), .B(mult_12_ab_0__5_), .Z(
        mult_12_n33) );
  XOR2_X1 mult_12_U48 ( .A(mult_12_ab_1__5_), .B(mult_12_ab_0__6_), .Z(
        mult_12_n32) );
  AND2_X1 mult_12_U47 ( .A1(a_reg[0]), .A2(b_reg[6]), .ZN(mult_12_ab_0__6_) );
  INV_X1 mult_12_U46 ( .A(a_reg[1]), .ZN(mult_12_n31) );
  AND2_X1 mult_12_U45 ( .A1(a_reg[1]), .A2(b_reg[5]), .ZN(mult_12_ab_1__5_) );
  INV_X1 mult_12_U44 ( .A(b_reg[7]), .ZN(mult_12_n92) );
  XNOR2_X1 mult_12_U43 ( .A(mult_12_CARRYB_5__1_), .B(mult_12_ab_6__1_), .ZN(
        mult_12_n29) );
  XNOR2_X1 mult_12_U42 ( .A(mult_12_n29), .B(mult_12_SUMB_5__2_), .ZN(
        mult_12_SUMB_6__1_) );
  AND2_X1 mult_12_U41 ( .A1(a_reg[1]), .A2(b_reg[4]), .ZN(mult_12_ab_1__4_) );
  NAND3_X1 mult_12_U40 ( .A1(mult_12_n26), .A2(mult_12_n27), .A3(mult_12_n28), 
        .ZN(mult_12_CARRYB_4__5_) );
  NAND2_X1 mult_12_U39 ( .A1(mult_12_SUMB_3__6_), .A2(mult_12_ab_4__5_), .ZN(
        mult_12_n28) );
  NAND2_X1 mult_12_U38 ( .A1(mult_12_CARRYB_3__5_), .A2(mult_12_ab_4__5_), 
        .ZN(mult_12_n27) );
  NAND2_X1 mult_12_U37 ( .A1(mult_12_CARRYB_3__5_), .A2(mult_12_SUMB_3__6_), 
        .ZN(mult_12_n26) );
  INV_X1 mult_12_U36 ( .A(a_reg[2]), .ZN(mult_12_n25) );
  XNOR2_X1 mult_12_U35 ( .A(mult_12_ab_3__6_), .B(mult_12_ab_2__7_), .ZN(
        mult_12_n24) );
  XNOR2_X1 mult_12_U34 ( .A(mult_12_n17), .B(mult_12_n24), .ZN(
        mult_12_SUMB_3__6_) );
  INV_X1 mult_12_U33 ( .A(b_reg[4]), .ZN(mult_12_n23) );
  BUF_X1 mult_12_U32 ( .A(mult_12_SUMB_3__5_), .Z(mult_12_n30) );
  AND2_X1 mult_12_U31 ( .A1(a_reg[0]), .A2(b_reg[4]), .ZN(mult_12_ab_0__4_) );
  INV_X1 mult_12_U30 ( .A(b_reg[7]), .ZN(mult_12_n22) );
  AND2_X1 mult_12_U29 ( .A1(b_reg[6]), .A2(a_reg[2]), .ZN(mult_12_ab_2__6_) );
  AND2_X1 mult_12_U28 ( .A1(mult_12_n2), .A2(b_reg[3]), .ZN(mult_12_ab_1__3_)
         );
  XNOR2_X1 mult_12_U27 ( .A(mult_12_SUMB_3__6_), .B(mult_12_ab_4__5_), .ZN(
        mult_12_n21) );
  XNOR2_X1 mult_12_U26 ( .A(mult_12_CARRYB_3__5_), .B(mult_12_n21), .ZN(
        mult_12_SUMB_4__5_) );
  NAND3_X1 mult_12_U25 ( .A1(mult_12_n18), .A2(mult_12_n19), .A3(mult_12_n20), 
        .ZN(mult_12_CARRYB_3__4_) );
  NAND2_X1 mult_12_U24 ( .A1(mult_12_CARRYB_2__4_), .A2(mult_12_ab_3__4_), 
        .ZN(mult_12_n20) );
  NAND2_X1 mult_12_U23 ( .A1(mult_12_SUMB_2__5_), .A2(mult_12_ab_3__4_), .ZN(
        mult_12_n19) );
  NAND2_X1 mult_12_U22 ( .A1(mult_12_SUMB_2__5_), .A2(mult_12_CARRYB_2__4_), 
        .ZN(mult_12_n18) );
  NAND3_X1 mult_12_U21 ( .A1(mult_12_n48), .A2(mult_12_n49), .A3(mult_12_n50), 
        .ZN(mult_12_n17) );
  NAND3_X1 mult_12_U20 ( .A1(mult_12_n48), .A2(mult_12_n49), .A3(mult_12_n50), 
        .ZN(mult_12_n16) );
  XOR2_X1 mult_12_U19 ( .A(mult_12_ab_1__2_), .B(mult_12_ab_0__3_), .Z(
        mult_12_n15) );
  XNOR2_X1 mult_12_U18 ( .A(mult_12_CARRYB_2__4_), .B(mult_12_ab_3__4_), .ZN(
        mult_12_n14) );
  XNOR2_X1 mult_12_U17 ( .A(mult_12_SUMB_2__5_), .B(mult_12_n14), .ZN(
        mult_12_SUMB_3__4_) );
  NAND3_X1 mult_12_U16 ( .A1(mult_12_n11), .A2(mult_12_n12), .A3(mult_12_n13), 
        .ZN(mult_12_CARRYB_4__6_) );
  NAND2_X1 mult_12_U15 ( .A1(mult_12_ab_3__7_), .A2(mult_12_ab_4__6_), .ZN(
        mult_12_n13) );
  NAND2_X1 mult_12_U14 ( .A1(mult_12_CARRYB_3__6_), .A2(mult_12_ab_4__6_), 
        .ZN(mult_12_n12) );
  NAND2_X1 mult_12_U13 ( .A1(mult_12_CARRYB_3__6_), .A2(mult_12_ab_3__7_), 
        .ZN(mult_12_n11) );
  XOR2_X1 mult_12_U12 ( .A(mult_12_CARRYB_3__6_), .B(mult_12_n10), .Z(
        mult_12_SUMB_4__6_) );
  XOR2_X1 mult_12_U11 ( .A(mult_12_ab_3__7_), .B(mult_12_ab_4__6_), .Z(
        mult_12_n10) );
  AND2_X1 mult_12_U10 ( .A1(mult_12_ab_0__1_), .A2(mult_12_ab_1__0_), .ZN(
        mult_12_n9) );
  AND2_X1 mult_12_U9 ( .A1(mult_12_ab_0__4_), .A2(mult_12_ab_1__3_), .ZN(
        mult_12_n8) );
  AND2_X1 mult_12_U8 ( .A1(mult_12_ab_0__2_), .A2(mult_12_ab_1__1_), .ZN(
        mult_12_n7) );
  AND2_X1 mult_12_U7 ( .A1(mult_12_ab_0__5_), .A2(mult_12_ab_1__4_), .ZN(
        mult_12_n6) );
  XOR2_X1 mult_12_U6 ( .A(mult_12_ab_1__3_), .B(mult_12_ab_0__4_), .Z(
        mult_12_n5) );
  XOR2_X1 mult_12_U5 ( .A(mult_12_CARRYB_7__0_), .B(mult_12_SUMB_7__1_), .Z(
        mult_12_n67) );
  XOR2_X1 mult_12_U4 ( .A(mult_12_ab_1__1_), .B(mult_12_ab_0__2_), .Z(
        mult_12_n4) );
  AND2_X1 mult_12_U3 ( .A1(mult_12_ab_0__3_), .A2(mult_12_ab_1__2_), .ZN(
        mult_12_n3) );
  CLKBUF_X1 mult_12_U2 ( .A(a_reg[1]), .Z(mult_12_n2) );
  FA_X1 mult_12_S0_6 ( .A(mult_12_ab_1__6_), .B(1'b0), .CI(mult_12_ab_0__7_), 
        .CO(mult_12_CARRYB_1__6_), .S(mult_12_SUMB_1__6_) );
  FA_X1 mult_12_S2_2_4 ( .A(mult_12_ab_2__4_), .B(mult_12_n6), .CI(mult_12_n32), .CO(mult_12_CARRYB_2__4_), .S(mult_12_SUMB_2__4_) );
  FA_X1 mult_12_S2_2_3 ( .A(mult_12_ab_2__3_), .B(mult_12_n8), .CI(mult_12_n33), .CO(mult_12_CARRYB_2__3_), .S(mult_12_SUMB_2__3_) );
  FA_X1 mult_12_S2_2_2 ( .A(mult_12_ab_2__2_), .B(mult_12_n3), .CI(mult_12_n5), 
        .CO(mult_12_CARRYB_2__2_), .S(mult_12_SUMB_2__2_) );
  FA_X1 mult_12_S2_2_1 ( .A(mult_12_ab_2__1_), .B(mult_12_n7), .CI(mult_12_n15), .CO(mult_12_CARRYB_2__1_), .S(mult_12_SUMB_2__1_) );
  FA_X1 mult_12_S1_2_0 ( .A(mult_12_ab_2__0_), .B(mult_12_n9), .CI(mult_12_n4), 
        .CO(mult_12_CARRYB_2__0_), .S(mult_12_A1_0_) );
  FA_X1 mult_12_S2_3_5 ( .A(mult_12_ab_3__5_), .B(mult_12_SUMB_2__6_), .CI(
        mult_12_CARRYB_2__5_), .CO(mult_12_CARRYB_3__5_), .S(
        mult_12_SUMB_3__5_) );
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
  FA_X1 mult_12_S2_4_3 ( .A(mult_12_ab_4__3_), .B(mult_12_SUMB_3__4_), .CI(
        mult_12_CARRYB_3__3_), .CO(mult_12_CARRYB_4__3_), .S(
        mult_12_SUMB_4__3_) );
  FA_X1 mult_12_S2_4_2 ( .A(mult_12_ab_4__2_), .B(mult_12_CARRYB_3__2_), .CI(
        mult_12_SUMB_3__3_), .CO(mult_12_CARRYB_4__2_), .S(mult_12_SUMB_4__2_)
         );
  FA_X1 mult_12_S2_4_1 ( .A(mult_12_ab_4__1_), .B(mult_12_CARRYB_3__1_), .CI(
        mult_12_SUMB_3__2_), .CO(mult_12_CARRYB_4__1_), .S(mult_12_SUMB_4__1_)
         );
  FA_X1 mult_12_S1_4_0 ( .A(mult_12_ab_4__0_), .B(mult_12_CARRYB_3__0_), .CI(
        mult_12_SUMB_3__1_), .CO(mult_12_CARRYB_4__0_), .S(mult_12_A1_2_) );
  FA_X1 mult_12_S3_5_6 ( .A(mult_12_ab_5__6_), .B(mult_12_CARRYB_4__6_), .CI(
        mult_12_ab_4__7_), .CO(mult_12_CARRYB_5__6_), .S(mult_12_SUMB_5__6_)
         );
  FA_X1 mult_12_S2_5_5 ( .A(mult_12_CARRYB_4__5_), .B(mult_12_ab_5__5_), .CI(
        mult_12_SUMB_4__6_), .CO(mult_12_CARRYB_5__5_), .S(mult_12_SUMB_5__5_)
         );
  FA_X1 mult_12_S2_5_4 ( .A(mult_12_SUMB_4__5_), .B(mult_12_ab_5__4_), .CI(
        mult_12_CARRYB_4__4_), .CO(mult_12_CARRYB_5__4_), .S(
        mult_12_SUMB_5__4_) );
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
  FA_X1 mult_12_S2_6_4 ( .A(mult_12_ab_6__4_), .B(mult_12_CARRYB_5__4_), .CI(
        mult_12_SUMB_5__5_), .CO(mult_12_CARRYB_6__4_), .S(mult_12_SUMB_6__4_)
         );
  FA_X1 mult_12_S2_6_3 ( .A(mult_12_CARRYB_5__3_), .B(mult_12_ab_6__3_), .CI(
        mult_12_SUMB_5__4_), .CO(mult_12_CARRYB_6__3_), .S(mult_12_SUMB_6__3_)
         );
  FA_X1 mult_12_S2_6_2 ( .A(mult_12_ab_6__2_), .B(mult_12_CARRYB_5__2_), .CI(
        mult_12_SUMB_5__3_), .CO(mult_12_CARRYB_6__2_), .S(mult_12_SUMB_6__2_)
         );
  FA_X1 mult_12_S1_6_0 ( .A(mult_12_ab_6__0_), .B(mult_12_CARRYB_5__0_), .CI(
        mult_12_SUMB_5__1_), .CO(mult_12_CARRYB_6__0_), .S(mult_12_A1_4_) );
  FA_X1 mult_12_S14_7 ( .A(mult_12_n91), .B(mult_12_n22), .CI(mult_12_ab_7__7_), .CO(mult_12_CARRYB_7__7_), .S(mult_12_SUMB_7__7_) );
  FA_X1 mult_12_S5_6 ( .A(mult_12_ab_7__6_), .B(mult_12_CARRYB_6__6_), .CI(
        mult_12_ab_6__7_), .CO(mult_12_CARRYB_7__6_), .S(mult_12_SUMB_7__6_)
         );
  FA_X1 mult_12_S4_5 ( .A(mult_12_ab_7__5_), .B(mult_12_CARRYB_6__5_), .CI(
        mult_12_SUMB_6__6_), .CO(mult_12_CARRYB_7__5_), .S(mult_12_SUMB_7__5_)
         );
  FA_X1 mult_12_S4_4 ( .A(mult_12_ab_7__4_), .B(mult_12_CARRYB_6__4_), .CI(
        mult_12_SUMB_6__5_), .CO(mult_12_CARRYB_7__4_), .S(mult_12_SUMB_7__4_)
         );
  FA_X1 mult_12_S4_3 ( .A(mult_12_ab_7__3_), .B(mult_12_CARRYB_6__3_), .CI(
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
  FA_X1 mult_12_S14_7_0 ( .A(a_reg[7]), .B(mult_12_n77), .CI(
        mult_12_SUMB_7__0_), .CO(mult_12_A2_6_), .S(mult_12_A1_5_) );
  INV_X1 mult_12_FS_1_U79 ( .A(mult_12_FS_1_n9), .ZN(mult_12_FS_1_n67) );
  INV_X1 mult_12_FS_1_U78 ( .A(mult_12_FS_1_n64), .ZN(mult_12_FS_1_n70) );
  NAND3_X1 mult_12_FS_1_U77 ( .A1(mult_12_FS_1_n71), .A2(mult_12_FS_1_n6), 
        .A3(mult_12_FS_1_n70), .ZN(mult_12_FS_1_n68) );
  INV_X1 mult_12_FS_1_U76 ( .A(mult_12_FS_1_n32), .ZN(mult_12_FS_1_n29) );
  XNOR2_X1 mult_12_FS_1_U75 ( .A(mult_12_FS_1_n65), .B(mult_12_FS_1_n66), .ZN(
        product_12_) );
  NAND3_X1 mult_12_FS_1_U74 ( .A1(mult_12_FS_1_n28), .A2(mult_12_A2_6_), .A3(
        mult_12_n67), .ZN(mult_12_FS_1_n49) );
  NAND3_X1 mult_12_FS_1_U73 ( .A1(mult_12_FS_1_n11), .A2(mult_12_FS_1_n5), 
        .A3(mult_12_FS_1_n6), .ZN(mult_12_FS_1_n56) );
  INV_X1 mult_12_FS_1_U72 ( .A(mult_12_FS_1_n50), .ZN(mult_12_FS_1_n38) );
  NAND3_X1 mult_12_FS_1_U71 ( .A1(mult_12_FS_1_n7), .A2(mult_12_FS_1_n11), 
        .A3(mult_12_FS_1_n30), .ZN(mult_12_FS_1_n23) );
  INV_X1 mult_12_FS_1_U70 ( .A(mult_12_n67), .ZN(mult_12_FS_1_n35) );
  NAND2_X1 mult_12_FS_1_U69 ( .A1(mult_12_A2_6_), .A2(mult_12_n67), .ZN(
        mult_12_FS_1_n33) );
  NAND2_X1 mult_12_FS_1_U68 ( .A1(mult_12_FS_1_n21), .A2(mult_12_FS_1_n26), 
        .ZN(mult_12_FS_1_n64) );
  NAND2_X1 mult_12_FS_1_U67 ( .A1(mult_12_FS_1_n29), .A2(mult_12_FS_1_n7), 
        .ZN(mult_12_FS_1_n24) );
  NAND2_X1 mult_12_FS_1_U66 ( .A1(mult_12_FS_1_n25), .A2(mult_12_FS_1_n26), 
        .ZN(mult_12_FS_1_n31) );
  NAND2_X1 mult_12_FS_1_U65 ( .A1(mult_12_n63), .A2(mult_12_n64), .ZN(
        mult_12_FS_1_n32) );
  XNOR2_X1 mult_12_FS_1_U64 ( .A(mult_12_FS_1_n58), .B(mult_12_FS_1_n31), .ZN(
        product_10_) );
  AOI21_X1 mult_12_FS_1_U63 ( .B1(mult_12_FS_1_n2), .B2(mult_12_FS_1_n10), .A(
        mult_12_FS_1_n41), .ZN(mult_12_FS_1_n39) );
  NAND2_X1 mult_12_FS_1_U62 ( .A1(mult_12_FS_1_n34), .A2(mult_12_FS_1_n35), 
        .ZN(mult_12_FS_1_n27) );
  OAI21_X1 mult_12_FS_1_U61 ( .B1(mult_12_FS_1_n54), .B2(mult_12_FS_1_n55), 
        .A(mult_12_FS_1_n43), .ZN(mult_12_FS_1_n53) );
  AOI21_X1 mult_12_FS_1_U60 ( .B1(mult_12_FS_1_n2), .B2(mult_12_FS_1_n52), .A(
        mult_12_FS_1_n53), .ZN(mult_12_FS_1_n51) );
  XNOR2_X1 mult_12_FS_1_U59 ( .A(mult_12_FS_1_n51), .B(mult_12_FS_1_n13), .ZN(
        product_14_) );
  OAI21_X1 mult_12_FS_1_U58 ( .B1(mult_12_FS_1_n25), .B2(mult_12_FS_1_n8), .A(
        mult_12_FS_1_n22), .ZN(mult_12_FS_1_n62) );
  NAND2_X1 mult_12_FS_1_U57 ( .A1(mult_12_FS_1_n62), .A2(mult_12_FS_1_n44), 
        .ZN(mult_12_FS_1_n61) );
  NAND2_X1 mult_12_FS_1_U56 ( .A1(mult_12_FS_1_n70), .A2(mult_12_FS_1_n29), 
        .ZN(mult_12_FS_1_n69) );
  AND3_X1 mult_12_FS_1_U55 ( .A1(mult_12_FS_1_n21), .A2(mult_12_n68), .A3(
        mult_12_n66), .ZN(mult_12_FS_1_n46) );
  NOR2_X1 mult_12_FS_1_U54 ( .A1(mult_12_FS_1_n46), .A2(mult_12_FS_1_n47), 
        .ZN(mult_12_FS_1_n54) );
  NOR2_X1 mult_12_FS_1_U53 ( .A1(mult_12_FS_1_n46), .A2(mult_12_FS_1_n47), 
        .ZN(mult_12_FS_1_n42) );
  NAND2_X1 mult_12_FS_1_U52 ( .A1(mult_12_FS_1_n61), .A2(mult_12_FS_1_n48), 
        .ZN(mult_12_FS_1_n60) );
  NAND3_X1 mult_12_FS_1_U51 ( .A1(mult_12_FS_1_n68), .A2(mult_12_FS_1_n69), 
        .A3(mult_12_FS_1_n67), .ZN(mult_12_FS_1_n65) );
  NAND3_X1 mult_12_FS_1_U50 ( .A1(mult_12_FS_1_n23), .A2(mult_12_FS_1_n25), 
        .A3(mult_12_FS_1_n24), .ZN(mult_12_FS_1_n20) );
  BUF_X1 mult_12_FS_1_U49 ( .A(mult_12_A1_3_), .Z(product_5_) );
  BUF_X1 mult_12_FS_1_U48 ( .A(mult_12_A1_5_), .Z(product_7_) );
  INV_X1 mult_12_FS_1_U47 ( .A(mult_12_A2_6_), .ZN(mult_12_FS_1_n34) );
  AND2_X1 mult_12_FS_1_U46 ( .A1(mult_12_A2_6_), .A2(mult_12_n67), .ZN(
        mult_12_FS_1_n30) );
  NAND2_X1 mult_12_FS_1_U45 ( .A1(mult_12_FS_1_n32), .A2(mult_12_FS_1_n56), 
        .ZN(mult_12_FS_1_n52) );
  BUF_X1 mult_12_FS_1_U44 ( .A(mult_12_A1_0_), .Z(product_2_) );
  BUF_X1 mult_12_FS_1_U43 ( .A(mult_12_A1_1_), .Z(product_3_) );
  BUF_X1 mult_12_FS_1_U42 ( .A(mult_12_A1_2_), .Z(product_4_) );
  NAND2_X1 mult_12_FS_1_U41 ( .A1(mult_12_n73), .A2(mult_12_n74), .ZN(
        mult_12_FS_1_n40) );
  OR2_X1 mult_12_FS_1_U40 ( .A1(mult_12_n73), .A2(mult_12_n74), .ZN(
        mult_12_FS_1_n50) );
  BUF_X1 mult_12_FS_1_U39 ( .A(mult_12_A1_4_), .Z(product_6_) );
  NAND2_X1 mult_12_FS_1_U38 ( .A1(mult_12_n72), .A2(mult_12_n71), .ZN(
        mult_12_FS_1_n43) );
  OAI21_X1 mult_12_FS_1_U37 ( .B1(mult_12_FS_1_n38), .B2(mult_12_FS_1_n39), 
        .A(mult_12_FS_1_n40), .ZN(mult_12_FS_1_n36) );
  XNOR2_X1 mult_12_FS_1_U36 ( .A(mult_12_n75), .B(mult_12_A1_13_), .ZN(
        mult_12_FS_1_n37) );
  XNOR2_X1 mult_12_FS_1_U35 ( .A(mult_12_FS_1_n36), .B(mult_12_FS_1_n37), .ZN(
        product_15_) );
  NAND2_X1 mult_12_FS_1_U34 ( .A1(mult_12_n68), .A2(mult_12_n66), .ZN(
        mult_12_FS_1_n25) );
  NAND2_X1 mult_12_FS_1_U33 ( .A1(mult_12_FS_1_n44), .A2(mult_12_FS_1_n48), 
        .ZN(mult_12_FS_1_n66) );
  NAND2_X1 mult_12_FS_1_U32 ( .A1(mult_12_n70), .A2(mult_12_n69), .ZN(
        mult_12_FS_1_n48) );
  NAND2_X1 mult_12_FS_1_U31 ( .A1(mult_12_n61), .A2(mult_12_n65), .ZN(
        mult_12_FS_1_n22) );
  NAND2_X1 mult_12_FS_1_U30 ( .A1(mult_12_FS_1_n49), .A2(mult_12_FS_1_n32), 
        .ZN(mult_12_FS_1_n58) );
  OAI21_X1 mult_12_FS_1_U29 ( .B1(mult_12_FS_1_n42), .B2(mult_12_FS_1_n55), 
        .A(mult_12_FS_1_n43), .ZN(mult_12_FS_1_n41) );
  NAND2_X1 mult_12_FS_1_U28 ( .A1(mult_12_FS_1_n22), .A2(mult_12_FS_1_n48), 
        .ZN(mult_12_FS_1_n47) );
  INV_X1 mult_12_FS_1_U27 ( .A(mult_12_FS_1_n44), .ZN(mult_12_FS_1_n63) );
  NOR2_X1 mult_12_FS_1_U26 ( .A1(mult_12_FS_1_n63), .A2(mult_12_FS_1_n64), 
        .ZN(mult_12_FS_1_n59) );
  AOI21_X1 mult_12_FS_1_U25 ( .B1(mult_12_FS_1_n10), .B2(mult_12_FS_1_n59), 
        .A(mult_12_FS_1_n60), .ZN(mult_12_FS_1_n57) );
  NAND2_X1 mult_12_FS_1_U24 ( .A1(mult_12_FS_1_n44), .A2(mult_12_FS_1_n45), 
        .ZN(mult_12_FS_1_n55) );
  OR2_X2 mult_12_FS_1_U23 ( .A1(mult_12_n72), .A2(mult_12_n71), .ZN(
        mult_12_FS_1_n45) );
  OR2_X2 mult_12_FS_1_U22 ( .A1(mult_12_n70), .A2(mult_12_n69), .ZN(
        mult_12_FS_1_n44) );
  AND2_X1 mult_12_FS_1_U21 ( .A1(mult_12_FS_1_n40), .A2(mult_12_FS_1_n50), 
        .ZN(mult_12_FS_1_n13) );
  NAND2_X1 mult_12_FS_1_U20 ( .A1(mult_12_FS_1_n21), .A2(mult_12_FS_1_n22), 
        .ZN(mult_12_FS_1_n12) );
  XNOR2_X1 mult_12_FS_1_U19 ( .A(mult_12_FS_1_n20), .B(mult_12_FS_1_n12), .ZN(
        product_11_) );
  BUF_X1 mult_12_FS_1_U18 ( .A(mult_12_FS_1_n28), .Z(mult_12_FS_1_n11) );
  AND2_X1 mult_12_FS_1_U17 ( .A1(mult_12_FS_1_n11), .A2(mult_12_FS_1_n5), .ZN(
        mult_12_FS_1_n71) );
  NAND2_X1 mult_12_FS_1_U16 ( .A1(mult_12_FS_1_n49), .A2(mult_12_FS_1_n32), 
        .ZN(mult_12_FS_1_n10) );
  CLKBUF_X1 mult_12_FS_1_U15 ( .A(mult_12_FS_1_n62), .Z(mult_12_FS_1_n9) );
  NOR2_X1 mult_12_FS_1_U14 ( .A1(mult_12_n65), .A2(mult_12_n61), .ZN(
        mult_12_FS_1_n8) );
  XNOR2_X2 mult_12_FS_1_U13 ( .A(mult_12_FS_1_n57), .B(mult_12_FS_1_n3), .ZN(
        product_13_) );
  CLKBUF_X1 mult_12_FS_1_U12 ( .A(mult_12_A2_6_), .Z(mult_12_FS_1_n6) );
  OR2_X2 mult_12_FS_1_U11 ( .A1(mult_12_n66), .A2(mult_12_n68), .ZN(
        mult_12_FS_1_n26) );
  BUF_X1 mult_12_FS_1_U10 ( .A(mult_12_FS_1_n26), .Z(mult_12_FS_1_n7) );
  INV_X1 mult_12_FS_1_U9 ( .A(mult_12_FS_1_n35), .ZN(mult_12_FS_1_n5) );
  OR2_X2 mult_12_FS_1_U8 ( .A1(mult_12_n64), .A2(mult_12_n63), .ZN(
        mult_12_FS_1_n28) );
  OR2_X2 mult_12_FS_1_U7 ( .A1(mult_12_n61), .A2(mult_12_n65), .ZN(
        mult_12_FS_1_n21) );
  AND2_X1 mult_12_FS_1_U6 ( .A1(mult_12_FS_1_n27), .A2(mult_12_FS_1_n33), .ZN(
        product_8_) );
  AND2_X1 mult_12_FS_1_U5 ( .A1(mult_12_FS_1_n43), .A2(mult_12_FS_1_n45), .ZN(
        mult_12_FS_1_n3) );
  AND4_X1 mult_12_FS_1_U4 ( .A1(mult_12_FS_1_n44), .A2(mult_12_FS_1_n45), .A3(
        mult_12_FS_1_n21), .A4(mult_12_FS_1_n26), .ZN(mult_12_FS_1_n2) );
  AND2_X1 mult_12_FS_1_U3 ( .A1(mult_12_FS_1_n28), .A2(mult_12_FS_1_n32), .ZN(
        mult_12_FS_1_n1) );
  XNOR2_X1 mult_12_FS_1_U2 ( .A(mult_12_FS_1_n33), .B(mult_12_FS_1_n1), .ZN(
        product_9_) );
  INV_X1 r60_U144 ( .A(r60_n64), .ZN(r60_n60) );
  NAND3_X1 r60_U143 ( .A1(r60_n56), .A2(r60_n128), .A3(r60_n51), .ZN(r60_n126)
         );
  INV_X1 r60_U142 ( .A(r60_n41), .ZN(r60_n125) );
  OAI21_X1 r60_U141 ( .B1(r60_n3), .B2(r60_n24), .A(r60_n4), .ZN(r60_n115) );
  XNOR2_X1 r60_U140 ( .A(r60_n115), .B(r60_n116), .ZN(N14) );
  INV_X1 r60_U139 ( .A(r60_n85), .ZN(r60_n111) );
  AOI21_X1 r60_U138 ( .B1(r60_n110), .B2(r60_n109), .A(r60_n111), .ZN(r60_n104) );
  NOR2_X1 r60_U137 ( .A1(r60_n16), .A2(r60_n17), .ZN(r60_n106) );
  INV_X1 r60_U136 ( .A(r60_n27), .ZN(r60_n108) );
  NAND2_X1 r60_U135 ( .A1(r60_n107), .A2(r60_n106), .ZN(r60_n105) );
  INV_X1 r60_U134 ( .A(r60_n101), .ZN(r60_n81) );
  XNOR2_X1 r60_U133 ( .A(r60_n99), .B(r60_n100), .ZN(N16) );
  NAND3_X1 r60_U132 ( .A1(r60_n86), .A2(r60_n27), .A3(r60_n97), .ZN(r60_n94)
         );
  OAI21_X1 r60_U131 ( .B1(r60_n9), .B2(r60_n73), .A(r60_n75), .ZN(r60_n93) );
  INV_X1 r60_U130 ( .A(r60_n69), .ZN(r60_n90) );
  NAND3_X1 r60_U129 ( .A1(r60_n7), .A2(r60_n27), .A3(r60_n97), .ZN(r60_n84) );
  NAND2_X1 r60_U128 ( .A1(r60_n84), .A2(r60_n15), .ZN(r60_n76) );
  OAI211_X1 r60_U127 ( .C1(r60_n76), .C2(r60_n77), .A(r60_n79), .B(r60_n78), 
        .ZN(r60_n68) );
  NAND2_X1 r60_U126 ( .A1(product_13_), .A2(acc[13]), .ZN(r60_n75) );
  NOR2_X1 r60_U125 ( .A1(r60_n22), .A2(r60_n75), .ZN(r60_n71) );
  NAND3_X1 r60_U124 ( .A1(r60_n68), .A2(r60_n69), .A3(r60_n70), .ZN(r60_n66)
         );
  XNOR2_X1 r60_U123 ( .A(r60_n66), .B(r60_n67), .ZN(N18) );
  INV_X1 r60_U122 ( .A(r60_n62), .ZN(r60_n59) );
  INV_X1 r60_U121 ( .A(r60_n57), .ZN(r60_n53) );
  INV_X1 r60_U120 ( .A(r60_n56), .ZN(r60_n54) );
  OAI21_X1 r60_U119 ( .B1(r60_n53), .B2(r60_n54), .A(r60_n55), .ZN(r60_n49) );
  XNOR2_X1 r60_U118 ( .A(r60_n49), .B(r60_n50), .ZN(N6) );
  XNOR2_X1 r60_U117 ( .A(r60_n46), .B(r60_n47), .ZN(N7) );
  INV_X1 r60_U116 ( .A(r60_n37), .ZN(r60_n33) );
  INV_X1 r60_U115 ( .A(r60_n36), .ZN(r60_n34) );
  OAI21_X1 r60_U114 ( .B1(r60_n33), .B2(r60_n34), .A(r60_n35), .ZN(r60_n32) );
  XNOR2_X1 r60_U113 ( .A(r60_n29), .B(r60_n1), .ZN(N11) );
  INV_X1 r60_U112 ( .A(product_10_), .ZN(r60_n113) );
  NAND2_X1 r60_U111 ( .A1(r60_n18), .A2(acc[10]), .ZN(r60_n96) );
  NAND2_X1 r60_U110 ( .A1(r60_n104), .A2(r60_n105), .ZN(r60_n102) );
  AOI21_X1 r60_U109 ( .B1(r60_n91), .B2(r60_n92), .A(r60_n93), .ZN(r60_n88) );
  NOR3_X1 r60_U108 ( .A1(r60_n81), .A2(r60_n16), .A3(r60_n9), .ZN(r60_n91) );
  NAND2_X1 r60_U107 ( .A1(r60_n83), .A2(r60_n30), .ZN(r60_n25) );
  NOR2_X1 r60_U106 ( .A1(r60_n82), .A2(r60_n83), .ZN(r60_n110) );
  OAI21_X1 r60_U105 ( .B1(r60_n14), .B2(r60_n2), .A(r60_n96), .ZN(r60_n77) );
  OAI211_X1 r60_U104 ( .C1(r60_n14), .C2(r60_n2), .A(r60_n94), .B(r60_n95), 
        .ZN(r60_n92) );
  XNOR2_X1 r60_U103 ( .A(r60_n103), .B(r60_n102), .ZN(N15) );
  NAND2_X1 r60_U102 ( .A1(product_12_), .A2(acc[12]), .ZN(r60_n73) );
  OAI21_X1 r60_U101 ( .B1(r60_n13), .B2(r60_n10), .A(r60_n6), .ZN(r60_n99) );
  NOR3_X1 r60_U100 ( .A1(r60_n22), .A2(r60_n73), .A3(r60_n74), .ZN(r60_n72) );
  NOR2_X1 r60_U99 ( .A1(r60_n72), .A2(r60_n71), .ZN(r60_n70) );
  NAND2_X1 r60_U98 ( .A1(r60_n25), .A2(r60_n27), .ZN(r60_n118) );
  XNOR2_X1 r60_U97 ( .A(r60_n26), .B(r60_n25), .ZN(N12) );
  XNOR2_X1 r60_U96 ( .A(r60_n88), .B(r60_n89), .ZN(N17) );
  NAND2_X1 r60_U95 ( .A1(r60_n113), .A2(r60_n114), .ZN(r60_n112) );
  NAND2_X1 r60_U94 ( .A1(r60_n31), .A2(r60_n28), .ZN(r60_n83) );
  NAND2_X1 r60_U93 ( .A1(r60_n31), .A2(r60_n30), .ZN(r60_n29) );
  AND2_X1 r60_U92 ( .A1(r60_n101), .A2(r60_n109), .ZN(r60_n78) );
  NOR2_X1 r60_U91 ( .A1(r60_n11), .A2(r60_n90), .ZN(r60_n89) );
  NAND2_X1 r60_U90 ( .A1(r60_n112), .A2(r60_n27), .ZN(r60_n82) );
  NAND2_X1 r60_U89 ( .A1(product_8_), .A2(acc[8]), .ZN(r60_n30) );
  NOR2_X1 r60_U88 ( .A1(acc[14]), .A2(product_14_), .ZN(r60_n80) );
  NAND2_X1 r60_U87 ( .A1(r60_n8), .A2(acc[14]), .ZN(r60_n69) );
  NOR2_X1 r60_U86 ( .A1(acc[13]), .A2(product_13_), .ZN(r60_n74) );
  NAND2_X1 r60_U85 ( .A1(product_11_), .A2(acc[11]), .ZN(r60_n85) );
  NAND2_X1 r60_U84 ( .A1(product_9_), .A2(acc[9]), .ZN(r60_n87) );
  OR2_X1 r60_U83 ( .A1(product_0_), .A2(acc[0]), .ZN(r60_n127) );
  INV_X1 r60_U82 ( .A(acc[10]), .ZN(r60_n114) );
  NAND2_X1 r60_U81 ( .A1(product_0_), .A2(acc[0]), .ZN(r60_n65) );
  NAND2_X1 r60_U80 ( .A1(product_1_), .A2(acc[1]), .ZN(r60_n61) );
  OR2_X1 r60_U79 ( .A1(product_1_), .A2(acc[1]), .ZN(r60_n64) );
  OR2_X1 r60_U78 ( .A1(product_2_), .A2(acc[2]), .ZN(r60_n56) );
  NAND2_X1 r60_U77 ( .A1(product_2_), .A2(acc[2]), .ZN(r60_n55) );
  NAND2_X1 r60_U76 ( .A1(product_3_), .A2(acc[3]), .ZN(r60_n52) );
  OR2_X1 r60_U75 ( .A1(product_3_), .A2(acc[3]), .ZN(r60_n51) );
  XOR2_X1 r60_U74 ( .A(r60_n32), .B(acc[7]), .Z(r60_n23) );
  XOR2_X1 r60_U73 ( .A(product_7_), .B(r60_n23), .Z(N10) );
  OR2_X1 r60_U72 ( .A1(product_4_), .A2(acc[4]), .ZN(r60_n48) );
  NAND2_X1 r60_U71 ( .A1(product_4_), .A2(acc[4]), .ZN(r60_n45) );
  NAND2_X1 r60_U70 ( .A1(product_5_), .A2(acc[5]), .ZN(r60_n40) );
  OR2_X2 r60_U69 ( .A1(product_6_), .A2(acc[6]), .ZN(r60_n36) );
  NAND2_X1 r60_U68 ( .A1(product_6_), .A2(acc[6]), .ZN(r60_n35) );
  AOI211_X1 r60_U67 ( .C1(r60_n123), .C2(r60_n36), .A(r60_n19), .B(acc[7]), 
        .ZN(r60_n119) );
  AOI21_X1 r60_U66 ( .B1(r60_n123), .B2(r60_n36), .A(r60_n20), .ZN(r60_n121)
         );
  INV_X1 r60_U65 ( .A(acc[7]), .ZN(r60_n122) );
  OAI22_X1 r60_U64 ( .A1(r60_n120), .A2(r60_n119), .B1(r60_n121), .B2(r60_n122), .ZN(r60_n28) );
  NOR2_X1 r60_U63 ( .A1(r60_n80), .A2(r60_n74), .ZN(r60_n79) );
  OR2_X2 r60_U62 ( .A1(product_9_), .A2(acc[9]), .ZN(r60_n27) );
  OR2_X1 r60_U61 ( .A1(product_13_), .A2(acc[13]), .ZN(r60_n98) );
  NOR2_X1 r60_U60 ( .A1(product_14_), .A2(acc[14]), .ZN(r60_n22) );
  INV_X1 r60_U59 ( .A(r60_n65), .ZN(r60_n62) );
  AND2_X1 r60_U58 ( .A1(r60_n127), .A2(r60_n65), .ZN(N3) );
  NAND2_X1 r60_U57 ( .A1(r60_n64), .A2(r60_n61), .ZN(r60_n63) );
  XNOR2_X1 r60_U56 ( .A(r60_n62), .B(r60_n63), .ZN(N4) );
  OAI21_X1 r60_U55 ( .B1(r60_n59), .B2(r60_n60), .A(r60_n61), .ZN(r60_n57) );
  NAND2_X1 r60_U54 ( .A1(r60_n56), .A2(r60_n55), .ZN(r60_n58) );
  XNOR2_X1 r60_U53 ( .A(r60_n57), .B(r60_n58), .ZN(N5) );
  NAND2_X1 r60_U52 ( .A1(r60_n51), .A2(r60_n52), .ZN(r60_n50) );
  NAND2_X1 r60_U51 ( .A1(r60_n48), .A2(r60_n45), .ZN(r60_n47) );
  NAND2_X1 r60_U50 ( .A1(r60_n41), .A2(r60_n40), .ZN(r60_n43) );
  XNOR2_X1 r60_U49 ( .A(r60_n42), .B(r60_n43), .ZN(N8) );
  NAND2_X1 r60_U48 ( .A1(r60_n44), .A2(r60_n45), .ZN(r60_n42) );
  NAND2_X1 r60_U47 ( .A1(r60_n36), .A2(r60_n35), .ZN(r60_n38) );
  XNOR2_X1 r60_U46 ( .A(r60_n37), .B(r60_n38), .ZN(N9) );
  NAND2_X1 r60_U45 ( .A1(r60_n41), .A2(r60_n42), .ZN(r60_n39) );
  NAND2_X1 r60_U44 ( .A1(r60_n39), .A2(r60_n40), .ZN(r60_n37) );
  OAI211_X1 r60_U43 ( .C1(r60_n60), .C2(r60_n65), .A(r60_n61), .B(r60_n55), 
        .ZN(r60_n128) );
  NAND2_X1 r60_U42 ( .A1(r60_n126), .A2(r60_n52), .ZN(r60_n46) );
  NAND2_X1 r60_U41 ( .A1(r60_n46), .A2(r60_n48), .ZN(r60_n44) );
  NAND2_X1 r60_U40 ( .A1(r60_n27), .A2(r60_n87), .ZN(r60_n26) );
  AND2_X1 r60_U39 ( .A1(r60_n124), .A2(r60_n36), .ZN(r60_n20) );
  AND2_X1 r60_U38 ( .A1(r60_n36), .A2(r60_n124), .ZN(r60_n19) );
  OAI211_X1 r60_U37 ( .C1(r60_n125), .C2(r60_n45), .A(r60_n40), .B(r60_n35), 
        .ZN(r60_n124) );
  AND2_X1 r60_U36 ( .A1(r60_n85), .A2(r60_n4), .ZN(r60_n95) );
  NAND2_X1 r60_U35 ( .A1(r60_n118), .A2(r60_n87), .ZN(r60_n117) );
  NAND2_X1 r60_U34 ( .A1(r60_n87), .A2(r60_n30), .ZN(r60_n97) );
  NAND2_X1 r60_U33 ( .A1(r60_n12), .A2(r60_n6), .ZN(r60_n103) );
  OAI211_X1 r60_U32 ( .C1(r60_n108), .C2(r60_n30), .A(r60_n87), .B(r60_n96), 
        .ZN(r60_n107) );
  NAND2_X1 r60_U31 ( .A1(r60_n75), .A2(r60_n98), .ZN(r60_n100) );
  NOR2_X1 r60_U30 ( .A1(r60_n44), .A2(r60_n125), .ZN(r60_n123) );
  INV_X1 r60_U29 ( .A(product_7_), .ZN(r60_n120) );
  OR2_X1 r60_U28 ( .A1(product_5_), .A2(acc[5]), .ZN(r60_n41) );
  XNOR2_X1 r60_U27 ( .A(product_15_), .B(acc[15]), .ZN(r60_n67) );
  NAND2_X1 r60_U26 ( .A1(r60_n109), .A2(r60_n15), .ZN(r60_n116) );
  CLKBUF_X1 r60_U25 ( .A(product_10_), .Z(r60_n18) );
  INV_X1 r60_U24 ( .A(r60_n17), .ZN(r60_n86) );
  NOR2_X1 r60_U23 ( .A1(product_11_), .A2(acc[11]), .ZN(r60_n16) );
  CLKBUF_X1 r60_U22 ( .A(r60_n85), .Z(r60_n15) );
  NAND2_X1 r60_U21 ( .A1(r60_n112), .A2(r60_n27), .ZN(r60_n14) );
  OR2_X1 r60_U20 ( .A1(product_11_), .A2(acc[11]), .ZN(r60_n109) );
  AND2_X1 r60_U19 ( .A1(r60_n104), .A2(r60_n105), .ZN(r60_n13) );
  CLKBUF_X1 r60_U18 ( .A(r60_n17), .Z(r60_n24) );
  OR2_X1 r60_U17 ( .A1(product_12_), .A2(acc[12]), .ZN(r60_n101) );
  INV_X1 r60_U16 ( .A(r60_n81), .ZN(r60_n12) );
  CLKBUF_X1 r60_U15 ( .A(r60_n22), .Z(r60_n11) );
  CLKBUF_X1 r60_U14 ( .A(r60_n81), .Z(r60_n10) );
  NOR2_X1 r60_U13 ( .A1(product_13_), .A2(acc[13]), .ZN(r60_n9) );
  CLKBUF_X1 r60_U12 ( .A(product_14_), .Z(r60_n8) );
  INV_X1 r60_U11 ( .A(r60_n17), .ZN(r60_n7) );
  CLKBUF_X1 r60_U10 ( .A(r60_n73), .Z(r60_n6) );
  AND2_X1 r60_U9 ( .A1(r60_n113), .A2(r60_n114), .ZN(r60_n17) );
  OR2_X1 r60_U8 ( .A1(product_8_), .A2(acc[8]), .ZN(r60_n31) );
  NAND2_X1 r60_U7 ( .A1(r60_n4), .A2(r60_n86), .ZN(r60_n5) );
  XNOR2_X1 r60_U6 ( .A(r60_n5), .B(r60_n117), .ZN(N13) );
  NAND2_X1 r60_U5 ( .A1(r60_n18), .A2(acc[10]), .ZN(r60_n4) );
  AND2_X1 r60_U4 ( .A1(r60_n118), .A2(r60_n87), .ZN(r60_n3) );
  BUF_X1 r60_U3 ( .A(r60_n83), .Z(r60_n2) );
  BUF_X1 r60_U2 ( .A(r60_n28), .Z(r60_n1) );
endmodule

