/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 02:41:47 2025
/////////////////////////////////////////////////////////////


module saturating_add_ref ( clk, a, b, z );
  input [7:0] a;
  input [7:0] b;
  output [7:0] z;
  input clk;
  wire   n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, add_6_n84,
         add_6_n83, add_6_n82, add_6_n81, add_6_n80, add_6_n79, add_6_n78,
         add_6_n77, add_6_n76, add_6_n75, add_6_n74, add_6_n73, add_6_n72,
         add_6_n71, add_6_n70, add_6_n69, add_6_n68, add_6_n67, add_6_n66,
         add_6_n65, add_6_n64, add_6_n63, add_6_n62, add_6_n61, add_6_n60,
         add_6_n59, add_6_n58, add_6_n57, add_6_n56, add_6_n55, add_6_n54,
         add_6_n53, add_6_n52, add_6_n51, add_6_n50, add_6_n49, add_6_n48,
         add_6_n47, add_6_n46, add_6_n45, add_6_n44, add_6_n43, add_6_n42,
         add_6_n41, add_6_n40, add_6_n39, add_6_n38, add_6_n37, add_6_n36,
         add_6_n35, add_6_n34, add_6_n33, add_6_n32, add_6_n31, add_6_n30,
         add_6_n29, add_6_n28, add_6_n27, add_6_n26, add_6_n25, add_6_n24,
         add_6_n23, add_6_n22, add_6_n21, add_6_n20, add_6_n19, add_6_n18,
         add_6_n17, add_6_n16, add_6_n15, add_6_n14, add_6_n13, add_6_n12,
         add_6_n11, add_6_n10, add_6_n9, add_6_n7, add_6_n6, add_6_n5,
         add_6_n4, add_6_n3, add_6_n2, add_6_n1;
  wire   [8:0] sum;

  DFF_X1 z_reg_7_ ( .D(n22), .CK(clk), .Q(z[7]) );
  DFF_X1 z_reg_6_ ( .D(n41), .CK(clk), .Q(z[6]) );
  DFF_X1 z_reg_5_ ( .D(n40), .CK(clk), .Q(z[5]) );
  DFF_X1 z_reg_4_ ( .D(n39), .CK(clk), .Q(z[4]) );
  DFF_X1 z_reg_3_ ( .D(n38), .CK(clk), .Q(z[3]) );
  DFF_X1 z_reg_2_ ( .D(n37), .CK(clk), .Q(z[2]) );
  DFF_X1 z_reg_1_ ( .D(n36), .CK(clk), .Q(z[1]) );
  DFF_X1 z_reg_0_ ( .D(n35), .CK(clk), .Q(z[0]) );
  CLKBUF_X1 U25 ( .A(n18), .Z(n16) );
  AND2_X1 U26 ( .A1(sum[8]), .A2(n21), .ZN(n17) );
  AND2_X1 U27 ( .A1(sum[8]), .A2(n21), .ZN(n19) );
  OR2_X2 U28 ( .A1(sum[8]), .A2(n23), .ZN(n18) );
  INV_X1 U29 ( .A(n19), .ZN(n34) );
  NAND2_X1 U30 ( .A1(n20), .A2(n16), .ZN(n22) );
  NAND2_X1 U31 ( .A1(n34), .A2(sum[7]), .ZN(n20) );
  AND2_X1 U32 ( .A1(n24), .A2(n25), .ZN(n21) );
  OR2_X2 U33 ( .A1(sum[8]), .A2(n23), .ZN(n33) );
  NAND2_X1 U34 ( .A1(a[7]), .A2(b[7]), .ZN(n23) );
  INV_X1 U35 ( .A(a[7]), .ZN(n25) );
  INV_X1 U36 ( .A(b[7]), .ZN(n24) );
  AOI21_X1 U37 ( .B1(sum[0]), .B2(n33), .A(n17), .ZN(n26) );
  INV_X1 U38 ( .A(n26), .ZN(n35) );
  AOI21_X1 U39 ( .B1(sum[1]), .B2(n18), .A(n17), .ZN(n27) );
  INV_X1 U40 ( .A(n27), .ZN(n36) );
  AOI21_X1 U41 ( .B1(sum[2]), .B2(n33), .A(n19), .ZN(n28) );
  INV_X1 U42 ( .A(n28), .ZN(n37) );
  AOI21_X1 U43 ( .B1(sum[3]), .B2(n18), .A(n19), .ZN(n29) );
  INV_X1 U44 ( .A(n29), .ZN(n38) );
  AOI21_X1 U45 ( .B1(sum[4]), .B2(n33), .A(n17), .ZN(n30) );
  INV_X1 U46 ( .A(n30), .ZN(n39) );
  AOI21_X1 U47 ( .B1(sum[5]), .B2(n18), .A(n17), .ZN(n31) );
  INV_X1 U48 ( .A(n31), .ZN(n40) );
  AOI21_X1 U49 ( .B1(sum[6]), .B2(n33), .A(n19), .ZN(n32) );
  INV_X1 U50 ( .A(n32), .ZN(n41) );
  INV_X1 add_6_U93 ( .A(add_6_n79), .ZN(add_6_n78) );
  OAI21_X1 add_6_U92 ( .B1(add_6_n78), .B2(add_6_n14), .A(add_6_n71), .ZN(
        add_6_n74) );
  XNOR2_X1 add_6_U91 ( .A(add_6_n74), .B(add_6_n75), .ZN(sum[3]) );
  INV_X1 add_6_U90 ( .A(add_6_n71), .ZN(add_6_n70) );
  INV_X1 add_6_U89 ( .A(add_6_n38), .ZN(add_6_n53) );
  INV_X1 add_6_U88 ( .A(add_6_n35), .ZN(add_6_n66) );
  INV_X1 add_6_U87 ( .A(add_6_n49), .ZN(add_6_n56) );
  NOR2_X1 add_6_U86 ( .A1(add_6_n53), .A2(add_6_n9), .ZN(add_6_n51) );
  NAND2_X1 add_6_U85 ( .A1(b[7]), .A2(a[7]), .ZN(add_6_n45) );
  INV_X1 add_6_U84 ( .A(add_6_n18), .ZN(add_6_n44) );
  INV_X1 add_6_U83 ( .A(add_6_n32), .ZN(add_6_n24) );
  OAI211_X1 add_6_U82 ( .C1(add_6_n35), .C2(add_6_n36), .A(add_6_n37), .B(
        add_6_n38), .ZN(add_6_n34) );
  NAND2_X1 add_6_U81 ( .A1(add_6_n67), .A2(add_6_n12), .ZN(add_6_n35) );
  NAND2_X1 add_6_U80 ( .A1(add_6_n70), .A2(add_6_n13), .ZN(add_6_n37) );
  XNOR2_X1 add_6_U79 ( .A(add_6_n43), .B(add_6_n44), .ZN(sum[7]) );
  NAND2_X1 add_6_U78 ( .A1(add_6_n30), .A2(add_6_n31), .ZN(add_6_n27) );
  NAND4_X1 add_6_U77 ( .A1(add_6_n33), .A2(add_6_n5), .A3(add_6_n29), .A4(
        add_6_n26), .ZN(add_6_n22) );
  OAI21_X1 add_6_U76 ( .B1(add_6_n25), .B2(add_6_n24), .A(add_6_n26), .ZN(
        add_6_n23) );
  NAND2_X1 add_6_U75 ( .A1(add_6_n28), .A2(add_6_n5), .ZN(add_6_n61) );
  NAND2_X1 add_6_U74 ( .A1(add_6_n39), .A2(add_6_n40), .ZN(add_6_n36) );
  OAI21_X1 add_6_U73 ( .B1(add_6_n21), .B2(add_6_n22), .A(add_6_n23), .ZN(
        add_6_n20) );
  NAND2_X1 add_6_U72 ( .A1(add_6_n10), .A2(add_6_n29), .ZN(add_6_n52) );
  NAND2_X1 add_6_U71 ( .A1(add_6_n49), .A2(add_6_n29), .ZN(add_6_n48) );
  NAND2_X1 add_6_U70 ( .A1(add_6_n32), .A2(add_6_n29), .ZN(add_6_n55) );
  NAND2_X1 add_6_U69 ( .A1(add_6_n10), .A2(add_6_n58), .ZN(add_6_n57) );
  NAND2_X1 add_6_U68 ( .A1(add_6_n58), .A2(add_6_n33), .ZN(add_6_n64) );
  XNOR2_X1 add_6_U67 ( .A(add_6_n58), .B(add_6_n65), .ZN(sum[4]) );
  AND2_X1 add_6_U66 ( .A1(add_6_n70), .A2(add_6_n12), .ZN(add_6_n17) );
  NAND2_X1 add_6_U65 ( .A1(b[0]), .A2(a[0]), .ZN(add_6_n69) );
  NAND2_X1 add_6_U64 ( .A1(add_6_n69), .A2(add_6_n68), .ZN(add_6_n39) );
  INV_X1 add_6_U63 ( .A(a[5]), .ZN(add_6_n63) );
  INV_X1 add_6_U62 ( .A(b[5]), .ZN(add_6_n62) );
  AND2_X1 add_6_U61 ( .A1(add_6_n62), .A2(add_6_n63), .ZN(add_6_n16) );
  NAND2_X1 add_6_U60 ( .A1(add_6_n72), .A2(add_6_n73), .ZN(add_6_n40) );
  NAND2_X1 add_6_U59 ( .A1(add_6_n72), .A2(add_6_n73), .ZN(add_6_n15) );
  MUX2_X1 add_6_U58 ( .A(add_6_n19), .B(add_6_n18), .S(add_6_n20), .Z(sum[8])
         );
  NAND2_X1 add_6_U57 ( .A1(add_6_n56), .A2(add_6_n57), .ZN(add_6_n54) );
  XNOR2_X1 add_6_U56 ( .A(add_6_n54), .B(add_6_n55), .ZN(sum[6]) );
  NAND2_X1 add_6_U55 ( .A1(add_6_n64), .A2(add_6_n59), .ZN(add_6_n60) );
  XNOR2_X1 add_6_U54 ( .A(add_6_n60), .B(add_6_n61), .ZN(sum[5]) );
  AOI21_X1 add_6_U53 ( .B1(add_6_n50), .B2(add_6_n51), .A(add_6_n52), .ZN(
        add_6_n46) );
  NOR2_X1 add_6_U52 ( .A1(add_6_n46), .A2(add_6_n47), .ZN(add_6_n43) );
  INV_X1 add_6_U51 ( .A(a[3]), .ZN(add_6_n77) );
  AOI21_X1 add_6_U50 ( .B1(add_6_n27), .B2(add_6_n28), .A(add_6_n4), .ZN(
        add_6_n25) );
  INV_X1 add_6_U49 ( .A(b[3]), .ZN(add_6_n76) );
  NAND2_X1 add_6_U48 ( .A1(b[3]), .A2(a[3]), .ZN(add_6_n38) );
  INV_X1 add_6_U47 ( .A(a[2]), .ZN(add_6_n82) );
  INV_X1 add_6_U46 ( .A(b[2]), .ZN(add_6_n81) );
  AND2_X1 add_6_U45 ( .A1(add_6_n81), .A2(add_6_n82), .ZN(add_6_n14) );
  NAND2_X1 add_6_U44 ( .A1(b[1]), .A2(a[1]), .ZN(add_6_n68) );
  NAND2_X1 add_6_U43 ( .A1(add_6_n15), .A2(add_6_n7), .ZN(add_6_n83) );
  OAI21_X1 add_6_U42 ( .B1(add_6_n3), .B2(add_6_n11), .A(add_6_n7), .ZN(
        add_6_n79) );
  NAND2_X1 add_6_U41 ( .A1(add_6_n76), .A2(add_6_n77), .ZN(add_6_n13) );
  NAND2_X1 add_6_U40 ( .A1(add_6_n76), .A2(add_6_n77), .ZN(add_6_n12) );
  OR2_X2 add_6_U39 ( .A1(b[6]), .A2(a[6]), .ZN(add_6_n29) );
  NAND2_X1 add_6_U38 ( .A1(add_6_n81), .A2(add_6_n82), .ZN(add_6_n67) );
  INV_X1 add_6_U37 ( .A(a[1]), .ZN(add_6_n73) );
  OR2_X1 add_6_U36 ( .A1(b[0]), .A2(a[0]), .ZN(add_6_n84) );
  NAND2_X1 add_6_U35 ( .A1(b[4]), .A2(a[4]), .ZN(add_6_n59) );
  NAND2_X1 add_6_U34 ( .A1(add_6_n45), .A2(add_6_n26), .ZN(add_6_n18) );
  NAND2_X1 add_6_U33 ( .A1(b[6]), .A2(a[6]), .ZN(add_6_n32) );
  NAND2_X1 add_6_U32 ( .A1(b[5]), .A2(a[5]), .ZN(add_6_n28) );
  OR2_X2 add_6_U31 ( .A1(b[4]), .A2(a[4]), .ZN(add_6_n33) );
  INV_X1 add_6_U30 ( .A(b[7]), .ZN(add_6_n42) );
  INV_X1 add_6_U29 ( .A(a[7]), .ZN(add_6_n41) );
  AND2_X1 add_6_U28 ( .A1(a[4]), .A2(b[4]), .ZN(add_6_n30) );
  NAND2_X1 add_6_U27 ( .A1(b[2]), .A2(a[2]), .ZN(add_6_n71) );
  INV_X1 add_6_U26 ( .A(b[1]), .ZN(add_6_n72) );
  OAI21_X1 add_6_U25 ( .B1(add_6_n16), .B2(add_6_n59), .A(add_6_n28), .ZN(
        add_6_n49) );
  AND2_X1 add_6_U24 ( .A1(add_6_n72), .A2(add_6_n73), .ZN(add_6_n11) );
  AND2_X1 add_6_U23 ( .A1(add_6_n33), .A2(add_6_n5), .ZN(add_6_n10) );
  NAND2_X1 add_6_U22 ( .A1(add_6_n42), .A2(add_6_n41), .ZN(add_6_n26) );
  NAND2_X1 add_6_U21 ( .A1(add_6_n48), .A2(add_6_n32), .ZN(add_6_n47) );
  AND3_X1 add_6_U20 ( .A1(add_6_n2), .A2(add_6_n15), .A3(add_6_n66), .ZN(
        add_6_n9) );
  INV_X1 add_6_U19 ( .A(add_6_n34), .ZN(add_6_n21) );
  NAND2_X1 add_6_U18 ( .A1(add_6_n41), .A2(add_6_n42), .ZN(add_6_n19) );
  NAND2_X1 add_6_U17 ( .A1(add_6_n59), .A2(add_6_n33), .ZN(add_6_n65) );
  NAND2_X1 add_6_U16 ( .A1(add_6_n38), .A2(add_6_n13), .ZN(add_6_n75) );
  NAND2_X1 add_6_U15 ( .A1(add_6_n71), .A2(add_6_n67), .ZN(add_6_n80) );
  XNOR2_X1 add_6_U14 ( .A(add_6_n79), .B(add_6_n80), .ZN(sum[2]) );
  XNOR2_X1 add_6_U13 ( .A(add_6_n1), .B(add_6_n83), .ZN(sum[1]) );
  AND2_X1 add_6_U12 ( .A1(add_6_n3), .A2(add_6_n84), .ZN(sum[0]) );
  INV_X1 add_6_U11 ( .A(add_6_n17), .ZN(add_6_n50) );
  NAND2_X1 add_6_U10 ( .A1(b[1]), .A2(a[1]), .ZN(add_6_n7) );
  NAND2_X1 add_6_U9 ( .A1(add_6_n38), .A2(add_6_n50), .ZN(add_6_n6) );
  OR2_X2 add_6_U8 ( .A1(add_6_n9), .A2(add_6_n6), .ZN(add_6_n58) );
  NAND2_X1 add_6_U7 ( .A1(add_6_n62), .A2(add_6_n63), .ZN(add_6_n5) );
  NOR2_X1 add_6_U6 ( .A1(b[6]), .A2(a[6]), .ZN(add_6_n4) );
  OR2_X2 add_6_U5 ( .A1(b[5]), .A2(a[5]), .ZN(add_6_n31) );
  NAND2_X1 add_6_U4 ( .A1(b[0]), .A2(a[0]), .ZN(add_6_n3) );
  CLKBUF_X1 add_6_U3 ( .A(add_6_n39), .Z(add_6_n2) );
  AND2_X1 add_6_U2 ( .A1(b[0]), .A2(a[0]), .ZN(add_6_n1) );
endmodule

