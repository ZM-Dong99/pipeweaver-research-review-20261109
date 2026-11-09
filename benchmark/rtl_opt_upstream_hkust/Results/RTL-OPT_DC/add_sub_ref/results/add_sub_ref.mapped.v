/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Wed May 14 19:07:12 2025
/////////////////////////////////////////////////////////////


module add_sub_ref ( a, b, control, result );
  input [15:0] a;
  input [15:0] b;
  output [15:0] result;
  input control;
  wire   N3, N4, N5, N6, N7, N8, N9, N10, N20, N21, N22, N23, N24, N25, N26,
         N27, N28, N29, N30, N31, N32, N33, N34, N35, N45, N46, N47, N48, N49,
         N50, N51, N52, N36, N11, n44, n45, n46, n47, n48, add_20_n61,
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
         add_20_n10, add_20_n9, add_20_n8, add_20_n6, add_20_n5, add_20_n4,
         add_20_n3, add_20_n2, add_20_n1, sub_26_n112, sub_26_n111,
         sub_26_n110, sub_26_n109, sub_26_n108, sub_26_n107, sub_26_n106,
         sub_26_n105, sub_26_n104, sub_26_n103, sub_26_n102, sub_26_n101,
         sub_26_n100, sub_26_n99, sub_26_n98, sub_26_n97, sub_26_n96,
         sub_26_n95, sub_26_n94, sub_26_n93, sub_26_n92, sub_26_n91,
         sub_26_n90, sub_26_n89, sub_26_n88, sub_26_n87, sub_26_n86,
         sub_26_n85, sub_26_n84, sub_26_n83, sub_26_n82, sub_26_n81,
         sub_26_n80, sub_26_n79, sub_26_n78, sub_26_n77, sub_26_n76,
         sub_26_n75, sub_26_n74, sub_26_n73, sub_26_n72, sub_26_n71,
         sub_26_n70, sub_26_n69, sub_26_n68, sub_26_n67, sub_26_n66,
         sub_26_n65, sub_26_n64, sub_26_n63, sub_26_n62, sub_26_n61,
         sub_26_n60, sub_26_n59, sub_26_n58, sub_26_n57, sub_26_n56,
         sub_26_n55, sub_26_n54, sub_26_n53, sub_26_n52, sub_26_n51,
         sub_26_n50, sub_26_n49, sub_26_n48, sub_26_n47, sub_26_n46,
         sub_26_n45, sub_26_n44, sub_26_n43, sub_26_n42, sub_26_n41,
         sub_26_n40, sub_26_n39, sub_26_n38, sub_26_n37, sub_26_n36,
         sub_26_n35, sub_26_n34, sub_26_n33, sub_26_n32, sub_26_n31,
         sub_26_n30, sub_26_n29, sub_26_n28, sub_26_n27, sub_26_n26,
         sub_26_n25, sub_26_n24, sub_26_n23, sub_26_n21, sub_26_n20,
         sub_26_n19, sub_26_n18, sub_26_n17, sub_26_n16, sub_26_n15,
         sub_26_n14, sub_26_n13, sub_26_n12, sub_26_n10, sub_26_n9, sub_26_n8,
         sub_26_n7, sub_26_n6, sub_26_n5, sub_26_n4, sub_26_n3, sub_26_n2,
         sub_26_n1, sub_1_root_sub_28_2_n91, sub_1_root_sub_28_2_n90,
         sub_1_root_sub_28_2_n89, sub_1_root_sub_28_2_n88,
         sub_1_root_sub_28_2_n87, sub_1_root_sub_28_2_n86,
         sub_1_root_sub_28_2_n85, sub_1_root_sub_28_2_n84,
         sub_1_root_sub_28_2_n83, sub_1_root_sub_28_2_n82,
         sub_1_root_sub_28_2_n81, sub_1_root_sub_28_2_n80,
         sub_1_root_sub_28_2_n79, sub_1_root_sub_28_2_n78,
         sub_1_root_sub_28_2_n77, sub_1_root_sub_28_2_n76,
         sub_1_root_sub_28_2_n75, sub_1_root_sub_28_2_n74,
         sub_1_root_sub_28_2_n73, sub_1_root_sub_28_2_n72,
         sub_1_root_sub_28_2_n71, sub_1_root_sub_28_2_n70,
         sub_1_root_sub_28_2_n69, sub_1_root_sub_28_2_n68,
         sub_1_root_sub_28_2_n67, sub_1_root_sub_28_2_n66,
         sub_1_root_sub_28_2_n65, sub_1_root_sub_28_2_n64,
         sub_1_root_sub_28_2_n63, sub_1_root_sub_28_2_n62,
         sub_1_root_sub_28_2_n61, sub_1_root_sub_28_2_n60,
         sub_1_root_sub_28_2_n59, sub_1_root_sub_28_2_n58,
         sub_1_root_sub_28_2_n57, sub_1_root_sub_28_2_n56,
         sub_1_root_sub_28_2_n55, sub_1_root_sub_28_2_n54,
         sub_1_root_sub_28_2_n53, sub_1_root_sub_28_2_n52,
         sub_1_root_sub_28_2_n51, sub_1_root_sub_28_2_n50,
         sub_1_root_sub_28_2_n49, sub_1_root_sub_28_2_n48,
         sub_1_root_sub_28_2_n47, sub_1_root_sub_28_2_n46,
         sub_1_root_sub_28_2_n45, sub_1_root_sub_28_2_n44,
         sub_1_root_sub_28_2_n43, sub_1_root_sub_28_2_n42,
         sub_1_root_sub_28_2_n41, sub_1_root_sub_28_2_n40,
         sub_1_root_sub_28_2_n39, sub_1_root_sub_28_2_n38,
         sub_1_root_sub_28_2_n37, sub_1_root_sub_28_2_n36,
         sub_1_root_sub_28_2_n35, sub_1_root_sub_28_2_n34,
         sub_1_root_sub_28_2_n33, sub_1_root_sub_28_2_n32,
         sub_1_root_sub_28_2_n31, sub_1_root_sub_28_2_n30,
         sub_1_root_sub_28_2_n29, sub_1_root_sub_28_2_n28,
         sub_1_root_sub_28_2_n27, sub_1_root_sub_28_2_n26,
         sub_1_root_sub_28_2_n25, sub_1_root_sub_28_2_n24,
         sub_1_root_sub_28_2_n23, sub_1_root_sub_28_2_n22,
         sub_1_root_sub_28_2_n21, sub_1_root_sub_28_2_n20,
         sub_1_root_sub_28_2_n19, sub_1_root_sub_28_2_n18,
         sub_1_root_sub_28_2_n17, sub_1_root_sub_28_2_n16,
         sub_1_root_sub_28_2_n15, sub_1_root_sub_28_2_n14,
         sub_1_root_sub_28_2_n13, sub_1_root_sub_28_2_n12,
         sub_1_root_sub_28_2_n11, sub_1_root_sub_28_2_n10,
         sub_1_root_sub_28_2_n9, sub_1_root_sub_28_2_n8,
         sub_1_root_sub_28_2_n7, sub_1_root_sub_28_2_n6,
         sub_1_root_sub_28_2_n5, sub_1_root_sub_28_2_n4,
         sub_1_root_sub_28_2_n3, sub_1_root_sub_28_2_n2,
         sub_1_root_sub_28_2_n1, add_1_root_add_22_2_n67,
         add_1_root_add_22_2_n66, add_1_root_add_22_2_n65,
         add_1_root_add_22_2_n64, add_1_root_add_22_2_n63,
         add_1_root_add_22_2_n62, add_1_root_add_22_2_n61,
         add_1_root_add_22_2_n60, add_1_root_add_22_2_n59,
         add_1_root_add_22_2_n58, add_1_root_add_22_2_n57,
         add_1_root_add_22_2_n56, add_1_root_add_22_2_n55,
         add_1_root_add_22_2_n54, add_1_root_add_22_2_n53,
         add_1_root_add_22_2_n52, add_1_root_add_22_2_n51,
         add_1_root_add_22_2_n50, add_1_root_add_22_2_n49,
         add_1_root_add_22_2_n48, add_1_root_add_22_2_n47,
         add_1_root_add_22_2_n46, add_1_root_add_22_2_n45,
         add_1_root_add_22_2_n44, add_1_root_add_22_2_n43,
         add_1_root_add_22_2_n42, add_1_root_add_22_2_n41,
         add_1_root_add_22_2_n40, add_1_root_add_22_2_n39,
         add_1_root_add_22_2_n38, add_1_root_add_22_2_n37,
         add_1_root_add_22_2_n36, add_1_root_add_22_2_n35,
         add_1_root_add_22_2_n34, add_1_root_add_22_2_n33,
         add_1_root_add_22_2_n32, add_1_root_add_22_2_n31,
         add_1_root_add_22_2_n30, add_1_root_add_22_2_n29,
         add_1_root_add_22_2_n28, add_1_root_add_22_2_n27,
         add_1_root_add_22_2_n26, add_1_root_add_22_2_n25,
         add_1_root_add_22_2_n24, add_1_root_add_22_2_n23,
         add_1_root_add_22_2_n22, add_1_root_add_22_2_n21,
         add_1_root_add_22_2_n20, add_1_root_add_22_2_n19,
         add_1_root_add_22_2_n18, add_1_root_add_22_2_n17,
         add_1_root_add_22_2_n16, add_1_root_add_22_2_n15,
         add_1_root_add_22_2_n14, add_1_root_add_22_2_n13,
         add_1_root_add_22_2_n12, add_1_root_add_22_2_n11,
         add_1_root_add_22_2_n10, add_1_root_add_22_2_n9,
         add_1_root_add_22_2_n8, add_1_root_add_22_2_n7,
         add_1_root_add_22_2_n6, add_1_root_add_22_2_n5,
         add_1_root_add_22_2_n4, add_1_root_add_22_2_n3,
         add_1_root_add_22_2_n2, add_1_root_add_22_2_n1;

  BUF_X1 U36 ( .A(b[2]), .Z(n44) );
  MUX2_X1 U37 ( .A(N28), .B(N3), .S(control), .Z(result[0]) );
  MUX2_X1 U38 ( .A(N29), .B(N4), .S(control), .Z(result[1]) );
  MUX2_X1 U39 ( .A(N30), .B(N5), .S(control), .Z(result[2]) );
  MUX2_X1 U40 ( .A(N31), .B(N6), .S(control), .Z(result[3]) );
  MUX2_X1 U41 ( .A(N32), .B(N7), .S(control), .Z(result[4]) );
  MUX2_X1 U42 ( .A(N33), .B(N8), .S(control), .Z(result[5]) );
  MUX2_X1 U43 ( .A(N34), .B(N9), .S(control), .Z(result[6]) );
  INV_X1 U44 ( .A(control), .ZN(n47) );
  AOI22_X1 U45 ( .A1(N35), .A2(n47), .B1(N10), .B2(control), .ZN(n45) );
  INV_X1 U46 ( .A(n45), .ZN(result[7]) );
  MUX2_X1 U47 ( .A(N45), .B(N20), .S(control), .Z(result[8]) );
  MUX2_X1 U48 ( .A(N46), .B(N21), .S(control), .Z(result[9]) );
  MUX2_X1 U49 ( .A(N47), .B(N22), .S(control), .Z(result[10]) );
  MUX2_X1 U50 ( .A(N48), .B(N23), .S(control), .Z(result[11]) );
  MUX2_X1 U51 ( .A(N49), .B(N24), .S(control), .Z(result[12]) );
  MUX2_X1 U52 ( .A(N50), .B(N25), .S(control), .Z(result[13]) );
  AOI22_X1 U53 ( .A1(N51), .A2(n47), .B1(N26), .B2(control), .ZN(n46) );
  INV_X1 U54 ( .A(n46), .ZN(result[14]) );
  AOI22_X1 U55 ( .A1(N27), .A2(control), .B1(N52), .B2(n47), .ZN(n48) );
  INV_X1 U56 ( .A(n48), .ZN(result[15]) );
  INV_X1 add_20_U70 ( .A(add_20_n59), .ZN(add_20_n57) );
  INV_X1 add_20_U69 ( .A(add_20_n28), .ZN(add_20_n58) );
  INV_X1 add_20_U68 ( .A(add_20_n55), .ZN(add_20_n53) );
  INV_X1 add_20_U67 ( .A(add_20_n48), .ZN(add_20_n54) );
  OAI21_X1 add_20_U66 ( .B1(add_20_n53), .B2(add_20_n54), .A(add_20_n47), .ZN(
        add_20_n52) );
  INV_X1 add_20_U65 ( .A(add_20_n47), .ZN(add_20_n45) );
  INV_X1 add_20_U64 ( .A(add_20_n6), .ZN(add_20_n34) );
  INV_X1 add_20_U63 ( .A(add_20_n24), .ZN(add_20_n33) );
  NAND3_X1 add_20_U62 ( .A1(add_20_n5), .A2(add_20_n20), .A3(add_20_n21), .ZN(
        add_20_n13) );
  INV_X1 add_20_U61 ( .A(add_20_n19), .ZN(add_20_n15) );
  NAND2_X1 add_20_U60 ( .A1(add_20_n13), .A2(add_20_n14), .ZN(add_20_n12) );
  AOI21_X2 add_20_U59 ( .B1(add_20_n11), .B2(add_20_n2), .A(add_20_n12), .ZN(
        N11) );
  NOR2_X1 add_20_U58 ( .A1(add_20_n17), .A2(add_20_n18), .ZN(add_20_n16) );
  NOR2_X1 add_20_U57 ( .A1(add_20_n16), .A2(add_20_n15), .ZN(add_20_n14) );
  NOR2_X1 add_20_U56 ( .A1(add_20_n22), .A2(add_20_n3), .ZN(add_20_n11) );
  NAND2_X1 add_20_U55 ( .A1(add_20_n27), .A2(add_20_n28), .ZN(add_20_n49) );
  NAND2_X1 add_20_U54 ( .A1(add_20_n27), .A2(add_20_n28), .ZN(add_20_n26) );
  AOI21_X1 add_20_U53 ( .B1(add_20_n32), .B2(add_20_n18), .A(add_20_n33), .ZN(
        add_20_n31) );
  NAND2_X1 add_20_U52 ( .A1(add_20_n28), .A2(add_20_n50), .ZN(add_20_n60) );
  OAI21_X1 add_20_U51 ( .B1(add_20_n34), .B2(add_20_n20), .A(add_20_n21), .ZN(
        add_20_n32) );
  NAND2_X1 add_20_U50 ( .A1(b[1]), .A2(a[1]), .ZN(add_20_n50) );
  NAND2_X1 add_20_U49 ( .A1(add_20_n45), .A2(add_20_n46), .ZN(add_20_n29) );
  NAND2_X1 add_20_U48 ( .A1(add_20_n48), .A2(add_20_n46), .ZN(add_20_n25) );
  XNOR2_X1 add_20_U47 ( .A(add_20_n59), .B(add_20_n60), .ZN(N4) );
  XNOR2_X1 add_20_U46 ( .A(add_20_n55), .B(add_20_n56), .ZN(N5) );
  NAND2_X1 add_20_U45 ( .A1(add_20_n50), .A2(add_20_n51), .ZN(add_20_n27) );
  OAI21_X1 add_20_U44 ( .B1(add_20_n57), .B2(add_20_n58), .A(add_20_n50), .ZN(
        add_20_n55) );
  XNOR2_X1 add_20_U43 ( .A(add_20_n31), .B(add_20_n8), .ZN(N10) );
  OR2_X1 add_20_U42 ( .A1(b[0]), .A2(a[0]), .ZN(add_20_n61) );
  XNOR2_X1 add_20_U41 ( .A(add_20_n6), .B(add_20_n43), .ZN(N7) );
  NAND2_X1 add_20_U40 ( .A1(add_20_n47), .A2(add_20_n48), .ZN(add_20_n56) );
  NAND2_X1 add_20_U39 ( .A1(b[3]), .A2(a[3]), .ZN(add_20_n30) );
  AND2_X1 add_20_U38 ( .A1(add_20_n30), .A2(add_20_n46), .ZN(add_20_n10) );
  XOR2_X1 add_20_U37 ( .A(add_20_n52), .B(add_20_n10), .Z(N6) );
  XNOR2_X1 add_20_U36 ( .A(add_20_n40), .B(add_20_n41), .ZN(N8) );
  NAND2_X1 add_20_U35 ( .A1(n44), .A2(a[2]), .ZN(add_20_n47) );
  OR2_X1 add_20_U34 ( .A1(b[7]), .A2(a[7]), .ZN(add_20_n19) );
  OR2_X1 add_20_U33 ( .A1(b[6]), .A2(a[6]), .ZN(add_20_n18) );
  AND2_X1 add_20_U32 ( .A1(add_20_n24), .A2(add_20_n18), .ZN(add_20_n9) );
  XOR2_X1 add_20_U31 ( .A(add_20_n32), .B(add_20_n9), .Z(N9) );
  NAND2_X1 add_20_U30 ( .A1(b[7]), .A2(a[7]), .ZN(add_20_n23) );
  NAND2_X1 add_20_U29 ( .A1(b[5]), .A2(a[5]), .ZN(add_20_n38) );
  NAND2_X1 add_20_U28 ( .A1(b[0]), .A2(a[0]), .ZN(add_20_n51) );
  NAND2_X1 add_20_U27 ( .A1(b[6]), .A2(a[6]), .ZN(add_20_n24) );
  NAND2_X1 add_20_U26 ( .A1(b[4]), .A2(a[4]), .ZN(add_20_n37) );
  NAND2_X1 add_20_U25 ( .A1(add_20_n38), .A2(add_20_n36), .ZN(add_20_n41) );
  NAND2_X1 add_20_U24 ( .A1(add_20_n39), .A2(add_20_n37), .ZN(add_20_n43) );
  AND2_X1 add_20_U23 ( .A1(add_20_n23), .A2(add_20_n19), .ZN(add_20_n8) );
  INV_X1 add_20_U22 ( .A(add_20_n51), .ZN(add_20_n59) );
  NAND2_X1 add_20_U21 ( .A1(add_20_n6), .A2(add_20_n39), .ZN(add_20_n42) );
  NAND2_X1 add_20_U20 ( .A1(add_20_n4), .A2(add_20_n42), .ZN(add_20_n40) );
  NOR2_X1 add_20_U19 ( .A1(add_20_n25), .A2(add_20_n26), .ZN(add_20_n22) );
  NAND2_X1 add_20_U18 ( .A1(add_20_n39), .A2(add_20_n36), .ZN(add_20_n20) );
  OAI21_X1 add_20_U17 ( .B1(add_20_n25), .B2(add_20_n49), .A(add_20_n30), .ZN(
        add_20_n44) );
  NAND2_X1 add_20_U16 ( .A1(add_20_n24), .A2(add_20_n23), .ZN(add_20_n17) );
  NAND2_X1 add_20_U15 ( .A1(add_20_n37), .A2(add_20_n38), .ZN(add_20_n35) );
  NAND2_X1 add_20_U14 ( .A1(add_20_n35), .A2(add_20_n36), .ZN(add_20_n21) );
  AND2_X1 add_20_U13 ( .A1(add_20_n51), .A2(add_20_n61), .ZN(N3) );
  OR2_X1 add_20_U12 ( .A1(b[4]), .A2(a[4]), .ZN(add_20_n39) );
  OR2_X1 add_20_U11 ( .A1(b[5]), .A2(a[5]), .ZN(add_20_n36) );
  OR2_X1 add_20_U10 ( .A1(b[1]), .A2(a[1]), .ZN(add_20_n28) );
  OR2_X1 add_20_U9 ( .A1(add_20_n44), .A2(add_20_n1), .ZN(add_20_n6) );
  AND2_X1 add_20_U8 ( .A1(add_20_n23), .A2(add_20_n24), .ZN(add_20_n5) );
  CLKBUF_X1 add_20_U7 ( .A(add_20_n37), .Z(add_20_n4) );
  CLKBUF_X1 add_20_U6 ( .A(add_20_n17), .Z(add_20_n3) );
  AND3_X1 add_20_U5 ( .A1(add_20_n29), .A2(add_20_n30), .A3(add_20_n21), .ZN(
        add_20_n2) );
  OR2_X2 add_20_U4 ( .A1(n44), .A2(a[2]), .ZN(add_20_n48) );
  OR2_X2 add_20_U3 ( .A1(b[3]), .A2(a[3]), .ZN(add_20_n46) );
  AND2_X1 add_20_U2 ( .A1(add_20_n45), .A2(add_20_n46), .ZN(add_20_n1) );
  INV_X1 sub_26_U122 ( .A(sub_26_n27), .ZN(sub_26_n111) );
  INV_X1 sub_26_U121 ( .A(sub_26_n109), .ZN(sub_26_n107) );
  XNOR2_X1 sub_26_U120 ( .A(sub_26_n105), .B(sub_26_n106), .ZN(N30) );
  INV_X1 sub_26_U119 ( .A(sub_26_n105), .ZN(sub_26_n104) );
  INV_X1 sub_26_U118 ( .A(sub_26_n62), .ZN(sub_26_n92) );
  OAI21_X1 sub_26_U117 ( .B1(sub_26_n104), .B2(sub_26_n92), .A(sub_26_n1), 
        .ZN(sub_26_n101) );
  XNOR2_X1 sub_26_U116 ( .A(sub_26_n101), .B(sub_26_n102), .ZN(N31) );
  INV_X1 sub_26_U115 ( .A(sub_26_n15), .ZN(sub_26_n95) );
  INV_X1 sub_26_U114 ( .A(sub_26_n33), .ZN(sub_26_n91) );
  NOR2_X1 sub_26_U113 ( .A1(sub_26_n91), .A2(sub_26_n92), .ZN(sub_26_n89) );
  INV_X1 sub_26_U112 ( .A(sub_26_n90), .ZN(sub_26_n57) );
  OAI21_X1 sub_26_U111 ( .B1(sub_26_n12), .B2(sub_26_n6), .A(sub_26_n76), .ZN(
        sub_26_n77) );
  XNOR2_X1 sub_26_U110 ( .A(sub_26_n77), .B(sub_26_n78), .ZN(N34) );
  OAI21_X1 sub_26_U109 ( .B1(sub_26_n21), .B2(sub_26_n73), .A(sub_26_n74), 
        .ZN(sub_26_n69) );
  XNOR2_X1 sub_26_U108 ( .A(sub_26_n69), .B(sub_26_n70), .ZN(N35) );
  NOR2_X1 sub_26_U107 ( .A1(sub_26_n29), .A2(sub_26_n36), .ZN(sub_26_n51) );
  NOR2_X1 sub_26_U106 ( .A1(sub_26_n34), .A2(sub_26_n53), .ZN(sub_26_n52) );
  NAND3_X1 sub_26_U105 ( .A1(sub_26_n51), .A2(sub_26_n45), .A3(sub_26_n52), 
        .ZN(sub_26_n50) );
  INV_X1 sub_26_U104 ( .A(sub_26_n47), .ZN(sub_26_n40) );
  NAND2_X1 sub_26_U103 ( .A1(sub_26_n27), .A2(sub_26_n65), .ZN(sub_26_n100) );
  NAND2_X1 sub_26_U102 ( .A1(sub_26_n15), .A2(sub_26_n108), .ZN(sub_26_n110)
         );
  NAND2_X1 sub_26_U101 ( .A1(sub_26_n98), .A2(sub_26_n62), .ZN(sub_26_n106) );
  NOR2_X1 sub_26_U100 ( .A1(sub_26_n58), .A2(sub_26_n59), .ZN(sub_26_n48) );
  AND2_X1 sub_26_U99 ( .A1(sub_26_n9), .A2(sub_26_n33), .ZN(sub_26_n38) );
  AND2_X1 sub_26_U98 ( .A1(sub_26_n35), .A2(sub_26_n93), .ZN(sub_26_n37) );
  AOI21_X1 sub_26_U97 ( .B1(sub_26_n48), .B2(sub_26_n49), .A(sub_26_n50), .ZN(
        sub_26_n39) );
  INV_X1 sub_26_U96 ( .A(a[1]), .ZN(sub_26_n67) );
  NAND2_X1 sub_26_U95 ( .A1(sub_26_n28), .A2(b[1]), .ZN(sub_26_n61) );
  NAND2_X1 sub_26_U94 ( .A1(b[1]), .A2(sub_26_n67), .ZN(sub_26_n65) );
  AOI21_X1 sub_26_U93 ( .B1(sub_26_n45), .B2(sub_26_n30), .A(sub_26_n32), .ZN(
        sub_26_n42) );
  NAND4_X1 sub_26_U92 ( .A1(a[4]), .A2(sub_26_n44), .A3(sub_26_n45), .A4(
        sub_26_n46), .ZN(sub_26_n43) );
  AOI21_X1 sub_26_U91 ( .B1(sub_26_n42), .B2(sub_26_n43), .A(sub_26_n7), .ZN(
        sub_26_n41) );
  NAND2_X1 sub_26_U90 ( .A1(sub_26_n66), .A2(b[2]), .ZN(sub_26_n62) );
  NAND2_X1 sub_26_U89 ( .A1(sub_26_n25), .A2(b[2]), .ZN(sub_26_n64) );
  INV_X1 sub_26_U88 ( .A(a[5]), .ZN(sub_26_n82) );
  AND2_X1 sub_26_U87 ( .A1(b[5]), .A2(sub_26_n19), .ZN(sub_26_n36) );
  INV_X1 sub_26_U86 ( .A(a[2]), .ZN(sub_26_n66) );
  NOR2_X1 sub_26_U85 ( .A1(sub_26_n66), .A2(b[2]), .ZN(sub_26_n35) );
  INV_X1 sub_26_U84 ( .A(a[4]), .ZN(sub_26_n85) );
  AND2_X1 sub_26_U83 ( .A1(b[4]), .A2(sub_26_n85), .ZN(sub_26_n34) );
  INV_X1 sub_26_U82 ( .A(a[0]), .ZN(sub_26_n68) );
  NAND2_X1 sub_26_U81 ( .A1(sub_26_n68), .A2(b[0]), .ZN(sub_26_n60) );
  INV_X1 sub_26_U80 ( .A(sub_26_n35), .ZN(sub_26_n98) );
  INV_X1 sub_26_U79 ( .A(a[3]), .ZN(sub_26_n103) );
  NAND2_X1 sub_26_U78 ( .A1(b[3]), .A2(sub_26_n103), .ZN(sub_26_n93) );
  NAND2_X1 sub_26_U77 ( .A1(b[3]), .A2(sub_26_n103), .ZN(sub_26_n33) );
  CLKBUF_X1 sub_26_U76 ( .A(sub_26_n30), .Z(sub_26_n31) );
  NOR2_X1 sub_26_U75 ( .A1(sub_26_n82), .A2(b[5]), .ZN(sub_26_n30) );
  INV_X1 sub_26_U74 ( .A(a[7]), .ZN(sub_26_n71) );
  AND2_X1 sub_26_U73 ( .A1(b[7]), .A2(sub_26_n71), .ZN(sub_26_n29) );
  INV_X1 sub_26_U72 ( .A(a[1]), .ZN(sub_26_n28) );
  CLKBUF_X1 sub_26_U71 ( .A(sub_26_n60), .Z(sub_26_n27) );
  CLKBUF_X1 sub_26_U70 ( .A(sub_26_n45), .Z(sub_26_n26) );
  INV_X1 sub_26_U69 ( .A(a[2]), .ZN(sub_26_n25) );
  INV_X1 sub_26_U68 ( .A(a[6]), .ZN(sub_26_n79) );
  NOR2_X1 sub_26_U67 ( .A1(sub_26_n79), .A2(b[6]), .ZN(sub_26_n32) );
  INV_X1 sub_26_U66 ( .A(a[0]), .ZN(sub_26_n24) );
  NOR2_X1 sub_26_U65 ( .A1(a[3]), .A2(sub_26_n54), .ZN(sub_26_n53) );
  AOI21_X1 sub_26_U64 ( .B1(sub_26_n88), .B2(sub_26_n89), .A(sub_26_n57), .ZN(
        sub_26_n87) );
  NOR2_X1 sub_26_U63 ( .A1(sub_26_n57), .A2(sub_26_n37), .ZN(sub_26_n49) );
  NAND2_X1 sub_26_U62 ( .A1(sub_26_n23), .A2(sub_26_n96), .ZN(sub_26_n108) );
  BUF_X1 sub_26_U61 ( .A(a[1]), .Z(sub_26_n23) );
  NAND2_X1 sub_26_U60 ( .A1(b[5]), .A2(sub_26_n82), .ZN(sub_26_n44) );
  OAI21_X1 sub_26_U59 ( .B1(sub_26_n107), .B2(sub_26_n95), .A(sub_26_n108), 
        .ZN(sub_26_n105) );
  NAND2_X1 sub_26_U58 ( .A1(sub_26_n86), .A2(sub_26_n87), .ZN(sub_26_n81) );
  XNOR2_X1 sub_26_U57 ( .A(sub_26_n81), .B(sub_26_n84), .ZN(N32) );
  NAND2_X1 sub_26_U56 ( .A1(sub_26_n81), .A2(sub_26_n55), .ZN(sub_26_n83) );
  NAND2_X1 sub_26_U54 ( .A1(b[7]), .A2(sub_26_n71), .ZN(sub_26_n56) );
  NAND2_X1 sub_26_U53 ( .A1(sub_26_n47), .A2(sub_26_n56), .ZN(sub_26_n70) );
  NAND2_X1 sub_26_U52 ( .A1(a[4]), .A2(sub_26_n46), .ZN(sub_26_n80) );
  NAND2_X1 sub_26_U51 ( .A1(b[4]), .A2(sub_26_n85), .ZN(sub_26_n55) );
  XNOR2_X1 sub_26_U50 ( .A(sub_26_n109), .B(sub_26_n110), .ZN(N29) );
  NAND2_X1 sub_26_U49 ( .A1(sub_26_n80), .A2(sub_26_n55), .ZN(sub_26_n84) );
  INV_X1 sub_26_U48 ( .A(b[1]), .ZN(sub_26_n96) );
  INV_X1 sub_26_U47 ( .A(b[7]), .ZN(sub_26_n72) );
  NAND2_X1 sub_26_U46 ( .A1(a[7]), .A2(sub_26_n72), .ZN(sub_26_n47) );
  INV_X1 sub_26_U45 ( .A(b[0]), .ZN(sub_26_n112) );
  INV_X1 sub_26_U44 ( .A(b[4]), .ZN(sub_26_n46) );
  INV_X1 sub_26_U43 ( .A(b[3]), .ZN(sub_26_n54) );
  NAND2_X1 sub_26_U42 ( .A1(a[3]), .A2(sub_26_n54), .ZN(sub_26_n90) );
  NAND2_X1 sub_26_U41 ( .A1(sub_26_n90), .A2(sub_26_n33), .ZN(sub_26_n102) );
  INV_X1 sub_26_U40 ( .A(sub_26_n32), .ZN(sub_26_n75) );
  NAND2_X1 sub_26_U39 ( .A1(sub_26_n75), .A2(sub_26_n26), .ZN(sub_26_n78) );
  INV_X1 sub_26_U38 ( .A(sub_26_n30), .ZN(sub_26_n76) );
  NAND2_X1 sub_26_U37 ( .A1(sub_26_n111), .A2(sub_26_n94), .ZN(sub_26_n109) );
  NAND2_X1 sub_26_U36 ( .A1(sub_26_n33), .A2(sub_26_n62), .ZN(sub_26_n99) );
  NOR2_X1 sub_26_U35 ( .A1(sub_26_n100), .A2(sub_26_n99), .ZN(sub_26_n97) );
  AOI21_X1 sub_26_U34 ( .B1(sub_26_n31), .B2(sub_26_n26), .A(sub_26_n8), .ZN(
        sub_26_n74) );
  NAND2_X1 sub_26_U33 ( .A1(sub_26_n44), .A2(sub_26_n26), .ZN(sub_26_n73) );
  NOR2_X1 sub_26_U32 ( .A1(sub_26_n97), .A2(sub_26_n38), .ZN(sub_26_n86) );
  NOR3_X2 sub_26_U31 ( .A1(sub_26_n39), .A2(sub_26_n40), .A3(sub_26_n41), .ZN(
        N36) );
  AND2_X1 sub_26_U30 ( .A1(sub_26_n76), .A2(sub_26_n44), .ZN(sub_26_n20) );
  INV_X1 sub_26_U29 ( .A(a[5]), .ZN(sub_26_n19) );
  AOI21_X1 sub_26_U28 ( .B1(sub_26_n16), .B2(sub_26_n10), .A(sub_26_n63), .ZN(
        sub_26_n58) );
  NAND2_X1 sub_26_U27 ( .A1(sub_26_n79), .A2(b[6]), .ZN(sub_26_n45) );
  INV_X1 sub_26_U26 ( .A(sub_26_n18), .ZN(sub_26_n88) );
  OAI21_X1 sub_26_U25 ( .B1(sub_26_n13), .B2(sub_26_n14), .A(sub_26_n65), .ZN(
        sub_26_n18) );
  INV_X1 sub_26_U24 ( .A(b[2]), .ZN(sub_26_n17) );
  OAI22_X1 sub_26_U23 ( .A1(sub_26_n96), .A2(a[1]), .B1(sub_26_n17), .B2(a[2]), 
        .ZN(sub_26_n63) );
  OR2_X1 sub_26_U22 ( .A1(b[1]), .A2(sub_26_n67), .ZN(sub_26_n16) );
  CLKBUF_X1 sub_26_U21 ( .A(sub_26_n65), .Z(sub_26_n15) );
  AND2_X2 sub_26_U20 ( .A1(a[0]), .A2(sub_26_n112), .ZN(sub_26_n14) );
  AND2_X1 sub_26_U19 ( .A1(sub_26_n23), .A2(sub_26_n96), .ZN(sub_26_n13) );
  AND2_X1 sub_26_U18 ( .A1(sub_26_n83), .A2(sub_26_n80), .ZN(sub_26_n12) );
  XNOR2_X1 sub_26_U17 ( .A(sub_26_n21), .B(sub_26_n20), .ZN(N33) );
  OR2_X1 sub_26_U16 ( .A1(sub_26_n111), .A2(sub_26_n14), .ZN(N28) );
  OR2_X1 sub_26_U15 ( .A1(b[0]), .A2(sub_26_n24), .ZN(sub_26_n10) );
  INV_X1 sub_26_U14 ( .A(sub_26_n14), .ZN(sub_26_n94) );
  INV_X1 sub_26_U13 ( .A(sub_26_n98), .ZN(sub_26_n9) );
  INV_X1 sub_26_U12 ( .A(sub_26_n75), .ZN(sub_26_n8) );
  BUF_X1 sub_26_U11 ( .A(sub_26_n29), .Z(sub_26_n7) );
  AND2_X1 sub_26_U10 ( .A1(b[5]), .A2(sub_26_n19), .ZN(sub_26_n6) );
  AND2_X1 sub_26_U9 ( .A1(sub_26_n87), .A2(sub_26_n80), .ZN(sub_26_n5) );
  INV_X1 sub_26_U8 ( .A(sub_26_n80), .ZN(sub_26_n4) );
  OR2_X1 sub_26_U7 ( .A1(sub_26_n4), .A2(sub_26_n55), .ZN(sub_26_n3) );
  NAND2_X1 sub_26_U6 ( .A1(sub_26_n2), .A2(sub_26_n3), .ZN(sub_26_n21) );
  NAND2_X1 sub_26_U5 ( .A1(sub_26_n86), .A2(sub_26_n5), .ZN(sub_26_n2) );
  INV_X1 sub_26_U4 ( .A(sub_26_n9), .ZN(sub_26_n1) );
  AND4_X1 sub_26_U3 ( .A1(sub_26_n60), .A2(sub_26_n61), .A3(sub_26_n64), .A4(
        1'b1), .ZN(sub_26_n59) );
  INV_X1 sub_1_root_sub_28_2_U101 ( .A(sub_1_root_sub_28_2_n86), .ZN(
        sub_1_root_sub_28_2_n85) );
  XNOR2_X1 sub_1_root_sub_28_2_U100 ( .A(sub_1_root_sub_28_2_n81), .B(
        sub_1_root_sub_28_2_n82), .ZN(N47) );
  NAND3_X1 sub_1_root_sub_28_2_U99 ( .A1(sub_1_root_sub_28_2_n2), .A2(
        sub_1_root_sub_28_2_n79), .A3(sub_1_root_sub_28_2_n58), .ZN(
        sub_1_root_sub_28_2_n74) );
  INV_X1 sub_1_root_sub_28_2_U98 ( .A(sub_1_root_sub_28_2_n58), .ZN(
        sub_1_root_sub_28_2_n67) );
  NOR2_X1 sub_1_root_sub_28_2_U97 ( .A1(sub_1_root_sub_28_2_n67), .A2(
        sub_1_root_sub_28_2_n68), .ZN(sub_1_root_sub_28_2_n62) );
  INV_X1 sub_1_root_sub_28_2_U96 ( .A(sub_1_root_sub_28_2_n9), .ZN(
        sub_1_root_sub_28_2_n54) );
  INV_X1 sub_1_root_sub_28_2_U95 ( .A(sub_1_root_sub_28_2_n59), .ZN(
        sub_1_root_sub_28_2_n12) );
  INV_X1 sub_1_root_sub_28_2_U94 ( .A(sub_1_root_sub_28_2_n18), .ZN(
        sub_1_root_sub_28_2_n30) );
  NAND2_X1 sub_1_root_sub_28_2_U93 ( .A1(sub_1_root_sub_28_2_n2), .A2(
        sub_1_root_sub_28_2_n30), .ZN(sub_1_root_sub_28_2_n55) );
  OAI211_X1 sub_1_root_sub_28_2_U92 ( .C1(sub_1_root_sub_28_2_n54), .C2(
        sub_1_root_sub_28_2_n12), .A(sub_1_root_sub_28_2_n55), .B(
        sub_1_root_sub_28_2_n19), .ZN(sub_1_root_sub_28_2_n51) );
  XNOR2_X1 sub_1_root_sub_28_2_U91 ( .A(sub_1_root_sub_28_2_n51), .B(
        sub_1_root_sub_28_2_n52), .ZN(N49) );
  INV_X1 sub_1_root_sub_28_2_U90 ( .A(sub_1_root_sub_28_2_n19), .ZN(
        sub_1_root_sub_28_2_n48) );
  INV_X1 sub_1_root_sub_28_2_U89 ( .A(sub_1_root_sub_28_2_n50), .ZN(
        sub_1_root_sub_28_2_n49) );
  INV_X1 sub_1_root_sub_28_2_U88 ( .A(sub_1_root_sub_28_2_n22), .ZN(
        sub_1_root_sub_28_2_n47) );
  NOR2_X1 sub_1_root_sub_28_2_U87 ( .A1(sub_1_root_sub_28_2_n12), .A2(
        sub_1_root_sub_28_2_n47), .ZN(sub_1_root_sub_28_2_n46) );
  NAND3_X1 sub_1_root_sub_28_2_U86 ( .A1(sub_1_root_sub_28_2_n22), .A2(
        sub_1_root_sub_28_2_n30), .A3(sub_1_root_sub_28_2_n2), .ZN(
        sub_1_root_sub_28_2_n45) );
  NAND3_X1 sub_1_root_sub_28_2_U85 ( .A1(sub_1_root_sub_28_2_n45), .A2(
        sub_1_root_sub_28_2_n44), .A3(sub_1_root_sub_28_2_n43), .ZN(
        sub_1_root_sub_28_2_n39) );
  XNOR2_X1 sub_1_root_sub_28_2_U84 ( .A(sub_1_root_sub_28_2_n39), .B(
        sub_1_root_sub_28_2_n40), .ZN(N50) );
  INV_X1 sub_1_root_sub_28_2_U83 ( .A(sub_1_root_sub_28_2_n20), .ZN(
        sub_1_root_sub_28_2_n34) );
  INV_X1 sub_1_root_sub_28_2_U82 ( .A(sub_1_root_sub_28_2_n32), .ZN(
        sub_1_root_sub_28_2_n31) );
  NAND3_X1 sub_1_root_sub_28_2_U81 ( .A1(sub_1_root_sub_28_2_n30), .A2(
        sub_1_root_sub_28_2_n31), .A3(sub_1_root_sub_28_2_n2), .ZN(
        sub_1_root_sub_28_2_n29) );
  NAND3_X1 sub_1_root_sub_28_2_U80 ( .A1(sub_1_root_sub_28_2_n29), .A2(
        sub_1_root_sub_28_2_n28), .A3(sub_1_root_sub_28_2_n27), .ZN(
        sub_1_root_sub_28_2_n23) );
  XNOR2_X1 sub_1_root_sub_28_2_U79 ( .A(sub_1_root_sub_28_2_n23), .B(
        sub_1_root_sub_28_2_n24), .ZN(N51) );
  NAND3_X1 sub_1_root_sub_28_2_U78 ( .A1(sub_1_root_sub_28_2_n21), .A2(
        sub_1_root_sub_28_2_n15), .A3(sub_1_root_sub_28_2_n22), .ZN(
        sub_1_root_sub_28_2_n13) );
  AOI22_X1 sub_1_root_sub_28_2_U77 ( .A1(sub_1_root_sub_28_2_n14), .A2(
        sub_1_root_sub_28_2_n15), .B1(sub_1_root_sub_28_2_n17), .B2(
        sub_1_root_sub_28_2_n16), .ZN(sub_1_root_sub_28_2_n6) );
  INV_X1 sub_1_root_sub_28_2_U76 ( .A(sub_1_root_sub_28_2_n11), .ZN(
        sub_1_root_sub_28_2_n10) );
  INV_X1 sub_1_root_sub_28_2_U75 ( .A(N36), .ZN(sub_1_root_sub_28_2_n17) );
  OAI211_X1 sub_1_root_sub_28_2_U74 ( .C1(sub_1_root_sub_28_2_n3), .C2(
        sub_1_root_sub_28_2_n80), .A(sub_1_root_sub_28_2_n78), .B(
        sub_1_root_sub_28_2_n65), .ZN(sub_1_root_sub_28_2_n81) );
  NAND2_X1 sub_1_root_sub_28_2_U73 ( .A1(sub_1_root_sub_28_2_n56), .A2(
        sub_1_root_sub_28_2_n2), .ZN(sub_1_root_sub_28_2_n90) );
  XNOR2_X1 sub_1_root_sub_28_2_U72 ( .A(b[15]), .B(a[15]), .ZN(
        sub_1_root_sub_28_2_n5) );
  AND2_X1 sub_1_root_sub_28_2_U71 ( .A1(sub_1_root_sub_28_2_n6), .A2(
        sub_1_root_sub_28_2_n7), .ZN(sub_1_root_sub_28_2_n4) );
  XNOR2_X1 sub_1_root_sub_28_2_U70 ( .A(sub_1_root_sub_28_2_n4), .B(
        sub_1_root_sub_28_2_n5), .ZN(N52) );
  CLKBUF_X1 sub_1_root_sub_28_2_U69 ( .A(N36), .Z(sub_1_root_sub_28_2_n3) );
  INV_X1 sub_1_root_sub_28_2_U68 ( .A(b[12]), .ZN(sub_1_root_sub_28_2_n53) );
  NAND2_X1 sub_1_root_sub_28_2_U67 ( .A1(a[12]), .A2(sub_1_root_sub_28_2_n53), 
        .ZN(sub_1_root_sub_28_2_n50) );
  INV_X1 sub_1_root_sub_28_2_U66 ( .A(b[14]), .ZN(sub_1_root_sub_28_2_n25) );
  NAND2_X1 sub_1_root_sub_28_2_U65 ( .A1(a[14]), .A2(sub_1_root_sub_28_2_n25), 
        .ZN(sub_1_root_sub_28_2_n11) );
  INV_X1 sub_1_root_sub_28_2_U64 ( .A(b[11]), .ZN(sub_1_root_sub_28_2_n73) );
  NAND2_X1 sub_1_root_sub_28_2_U63 ( .A1(a[11]), .A2(sub_1_root_sub_28_2_n73), 
        .ZN(sub_1_root_sub_28_2_n19) );
  INV_X1 sub_1_root_sub_28_2_U62 ( .A(b[10]), .ZN(sub_1_root_sub_28_2_n83) );
  NAND2_X1 sub_1_root_sub_28_2_U61 ( .A1(a[10]), .A2(sub_1_root_sub_28_2_n83), 
        .ZN(sub_1_root_sub_28_2_n61) );
  INV_X1 sub_1_root_sub_28_2_U60 ( .A(a[8]), .ZN(sub_1_root_sub_28_2_n91) );
  INV_X1 sub_1_root_sub_28_2_U59 ( .A(a[11]), .ZN(sub_1_root_sub_28_2_n72) );
  NAND2_X1 sub_1_root_sub_28_2_U58 ( .A1(b[11]), .A2(sub_1_root_sub_28_2_n72), 
        .ZN(sub_1_root_sub_28_2_n59) );
  INV_X1 sub_1_root_sub_28_2_U57 ( .A(a[9]), .ZN(sub_1_root_sub_28_2_n89) );
  NAND2_X1 sub_1_root_sub_28_2_U56 ( .A1(a[8]), .A2(sub_1_root_sub_28_2_n66), 
        .ZN(sub_1_root_sub_28_2_n86) );
  OAI21_X1 sub_1_root_sub_28_2_U55 ( .B1(b[12]), .B2(sub_1_root_sub_28_2_n37), 
        .A(sub_1_root_sub_28_2_n38), .ZN(sub_1_root_sub_28_2_n36) );
  NAND2_X1 sub_1_root_sub_28_2_U54 ( .A1(sub_1_root_sub_28_2_n21), .A2(
        sub_1_root_sub_28_2_n36), .ZN(sub_1_root_sub_28_2_n20) );
  INV_X1 sub_1_root_sub_28_2_U53 ( .A(b[13]), .ZN(sub_1_root_sub_28_2_n41) );
  NAND2_X1 sub_1_root_sub_28_2_U52 ( .A1(a[13]), .A2(sub_1_root_sub_28_2_n41), 
        .ZN(sub_1_root_sub_28_2_n38) );
  INV_X1 sub_1_root_sub_28_2_U51 ( .A(a[14]), .ZN(sub_1_root_sub_28_2_n26) );
  NAND2_X1 sub_1_root_sub_28_2_U50 ( .A1(b[14]), .A2(sub_1_root_sub_28_2_n26), 
        .ZN(sub_1_root_sub_28_2_n15) );
  INV_X1 sub_1_root_sub_28_2_U49 ( .A(a[13]), .ZN(sub_1_root_sub_28_2_n42) );
  NAND2_X1 sub_1_root_sub_28_2_U48 ( .A1(b[13]), .A2(sub_1_root_sub_28_2_n42), 
        .ZN(sub_1_root_sub_28_2_n21) );
  NAND2_X1 sub_1_root_sub_28_2_U47 ( .A1(a[8]), .A2(sub_1_root_sub_28_2_n66), 
        .ZN(sub_1_root_sub_28_2_n64) );
  INV_X1 sub_1_root_sub_28_2_U46 ( .A(b[8]), .ZN(sub_1_root_sub_28_2_n66) );
  NOR2_X1 sub_1_root_sub_28_2_U45 ( .A1(a[9]), .A2(sub_1_root_sub_28_2_n69), 
        .ZN(sub_1_root_sub_28_2_n68) );
  INV_X1 sub_1_root_sub_28_2_U44 ( .A(a[12]), .ZN(sub_1_root_sub_28_2_n37) );
  INV_X1 sub_1_root_sub_28_2_U43 ( .A(b[9]), .ZN(sub_1_root_sub_28_2_n69) );
  INV_X1 sub_1_root_sub_28_2_U42 ( .A(a[10]), .ZN(sub_1_root_sub_28_2_n84) );
  XNOR2_X1 sub_1_root_sub_28_2_U41 ( .A(sub_1_root_sub_28_2_n87), .B(
        sub_1_root_sub_28_2_n88), .ZN(N46) );
  XNOR2_X1 sub_1_root_sub_28_2_U40 ( .A(sub_1_root_sub_28_2_n70), .B(
        sub_1_root_sub_28_2_n71), .ZN(N48) );
  NAND2_X1 sub_1_root_sub_28_2_U39 ( .A1(sub_1_root_sub_28_2_n58), .A2(
        sub_1_root_sub_28_2_n61), .ZN(sub_1_root_sub_28_2_n82) );
  NAND2_X1 sub_1_root_sub_28_2_U38 ( .A1(sub_1_root_sub_28_2_n21), .A2(
        sub_1_root_sub_28_2_n38), .ZN(sub_1_root_sub_28_2_n40) );
  NAND2_X1 sub_1_root_sub_28_2_U37 ( .A1(sub_1_root_sub_28_2_n15), .A2(
        sub_1_root_sub_28_2_n11), .ZN(sub_1_root_sub_28_2_n24) );
  NAND2_X1 sub_1_root_sub_28_2_U36 ( .A1(sub_1_root_sub_28_2_n19), .A2(
        sub_1_root_sub_28_2_n59), .ZN(sub_1_root_sub_28_2_n71) );
  NAND2_X1 sub_1_root_sub_28_2_U35 ( .A1(sub_1_root_sub_28_2_n50), .A2(
        sub_1_root_sub_28_2_n22), .ZN(sub_1_root_sub_28_2_n52) );
  NAND2_X1 sub_1_root_sub_28_2_U34 ( .A1(sub_1_root_sub_28_2_n57), .A2(
        sub_1_root_sub_28_2_n65), .ZN(sub_1_root_sub_28_2_n88) );
  NAND2_X1 sub_1_root_sub_28_2_U33 ( .A1(sub_1_root_sub_28_2_n56), .A2(
        sub_1_root_sub_28_2_n57), .ZN(sub_1_root_sub_28_2_n80) );
  NOR2_X1 sub_1_root_sub_28_2_U32 ( .A1(sub_1_root_sub_28_2_n19), .A2(
        sub_1_root_sub_28_2_n32), .ZN(sub_1_root_sub_28_2_n35) );
  NAND2_X1 sub_1_root_sub_28_2_U31 ( .A1(sub_1_root_sub_28_2_n21), .A2(
        sub_1_root_sub_28_2_n22), .ZN(sub_1_root_sub_28_2_n32) );
  NAND4_X1 sub_1_root_sub_28_2_U30 ( .A1(sub_1_root_sub_28_2_n56), .A2(
        sub_1_root_sub_28_2_n57), .A3(sub_1_root_sub_28_2_n58), .A4(
        sub_1_root_sub_28_2_n59), .ZN(sub_1_root_sub_28_2_n18) );
  NAND2_X1 sub_1_root_sub_28_2_U29 ( .A1(sub_1_root_sub_28_2_n85), .A2(
        sub_1_root_sub_28_2_n57), .ZN(sub_1_root_sub_28_2_n78) );
  OAI21_X1 sub_1_root_sub_28_2_U28 ( .B1(sub_1_root_sub_28_2_n13), .B2(
        sub_1_root_sub_28_2_n19), .A(sub_1_root_sub_28_2_n20), .ZN(
        sub_1_root_sub_28_2_n14) );
  NAND2_X1 sub_1_root_sub_28_2_U27 ( .A1(sub_1_root_sub_28_2_n64), .A2(
        sub_1_root_sub_28_2_n65), .ZN(sub_1_root_sub_28_2_n63) );
  NAND2_X1 sub_1_root_sub_28_2_U26 ( .A1(sub_1_root_sub_28_2_n62), .A2(
        sub_1_root_sub_28_2_n63), .ZN(sub_1_root_sub_28_2_n60) );
  NAND2_X1 sub_1_root_sub_28_2_U25 ( .A1(sub_1_root_sub_28_2_n46), .A2(
        sub_1_root_sub_28_2_n9), .ZN(sub_1_root_sub_28_2_n44) );
  AOI21_X1 sub_1_root_sub_28_2_U24 ( .B1(sub_1_root_sub_28_2_n48), .B2(
        sub_1_root_sub_28_2_n22), .A(sub_1_root_sub_28_2_n49), .ZN(
        sub_1_root_sub_28_2_n43) );
  NAND2_X1 sub_1_root_sub_28_2_U23 ( .A1(sub_1_root_sub_28_2_n90), .A2(
        sub_1_root_sub_28_2_n86), .ZN(sub_1_root_sub_28_2_n87) );
  NAND2_X1 sub_1_root_sub_28_2_U22 ( .A1(sub_1_root_sub_28_2_n61), .A2(
        sub_1_root_sub_28_2_n65), .ZN(sub_1_root_sub_28_2_n76) );
  OAI21_X1 sub_1_root_sub_28_2_U21 ( .B1(sub_1_root_sub_28_2_n76), .B2(
        sub_1_root_sub_28_2_n77), .A(sub_1_root_sub_28_2_n58), .ZN(
        sub_1_root_sub_28_2_n75) );
  NAND2_X1 sub_1_root_sub_28_2_U20 ( .A1(sub_1_root_sub_28_2_n74), .A2(
        sub_1_root_sub_28_2_n75), .ZN(sub_1_root_sub_28_2_n70) );
  AOI21_X1 sub_1_root_sub_28_2_U19 ( .B1(sub_1_root_sub_28_2_n8), .B2(
        sub_1_root_sub_28_2_n9), .A(sub_1_root_sub_28_2_n10), .ZN(
        sub_1_root_sub_28_2_n7) );
  INV_X1 sub_1_root_sub_28_2_U18 ( .A(sub_1_root_sub_28_2_n80), .ZN(
        sub_1_root_sub_28_2_n79) );
  NOR2_X1 sub_1_root_sub_28_2_U17 ( .A1(sub_1_root_sub_28_2_n12), .A2(
        sub_1_root_sub_28_2_n32), .ZN(sub_1_root_sub_28_2_n33) );
  INV_X1 sub_1_root_sub_28_2_U16 ( .A(sub_1_root_sub_28_2_n78), .ZN(
        sub_1_root_sub_28_2_n77) );
  NOR2_X1 sub_1_root_sub_28_2_U15 ( .A1(sub_1_root_sub_28_2_n18), .A2(
        sub_1_root_sub_28_2_n13), .ZN(sub_1_root_sub_28_2_n16) );
  NOR2_X1 sub_1_root_sub_28_2_U14 ( .A1(sub_1_root_sub_28_2_n12), .A2(
        sub_1_root_sub_28_2_n13), .ZN(sub_1_root_sub_28_2_n8) );
  NAND2_X1 sub_1_root_sub_28_2_U13 ( .A1(sub_1_root_sub_28_2_n33), .A2(
        sub_1_root_sub_28_2_n9), .ZN(sub_1_root_sub_28_2_n28) );
  NOR2_X1 sub_1_root_sub_28_2_U12 ( .A1(sub_1_root_sub_28_2_n34), .A2(
        sub_1_root_sub_28_2_n35), .ZN(sub_1_root_sub_28_2_n27) );
  INV_X1 sub_1_root_sub_28_2_U11 ( .A(N36), .ZN(sub_1_root_sub_28_2_n2) );
  AND2_X1 sub_1_root_sub_28_2_U10 ( .A1(sub_1_root_sub_28_2_n56), .A2(
        sub_1_root_sub_28_2_n86), .ZN(sub_1_root_sub_28_2_n1) );
  XNOR2_X1 sub_1_root_sub_28_2_U9 ( .A(sub_1_root_sub_28_2_n3), .B(
        sub_1_root_sub_28_2_n1), .ZN(N45) );
  NAND2_X1 sub_1_root_sub_28_2_U8 ( .A1(b[8]), .A2(sub_1_root_sub_28_2_n91), 
        .ZN(sub_1_root_sub_28_2_n56) );
  NAND2_X1 sub_1_root_sub_28_2_U7 ( .A1(sub_1_root_sub_28_2_n60), .A2(
        sub_1_root_sub_28_2_n61), .ZN(sub_1_root_sub_28_2_n9) );
  NAND2_X1 sub_1_root_sub_28_2_U6 ( .A1(b[12]), .A2(sub_1_root_sub_28_2_n37), 
        .ZN(sub_1_root_sub_28_2_n22) );
  NAND2_X1 sub_1_root_sub_28_2_U5 ( .A1(b[9]), .A2(sub_1_root_sub_28_2_n89), 
        .ZN(sub_1_root_sub_28_2_n57) );
  NAND2_X1 sub_1_root_sub_28_2_U4 ( .A1(b[10]), .A2(sub_1_root_sub_28_2_n84), 
        .ZN(sub_1_root_sub_28_2_n58) );
  NAND2_X1 sub_1_root_sub_28_2_U3 ( .A1(a[9]), .A2(sub_1_root_sub_28_2_n69), 
        .ZN(sub_1_root_sub_28_2_n65) );
  INV_X1 add_1_root_add_22_2_U76 ( .A(add_1_root_add_22_2_n44), .ZN(
        add_1_root_add_22_2_n67) );
  OAI21_X1 add_1_root_add_22_2_U75 ( .B1(add_1_root_add_22_2_n61), .B2(
        add_1_root_add_22_2_n67), .A(add_1_root_add_22_2_n64), .ZN(
        add_1_root_add_22_2_n65) );
  XNOR2_X1 add_1_root_add_22_2_U74 ( .A(add_1_root_add_22_2_n65), .B(
        add_1_root_add_22_2_n66), .ZN(N21) );
  INV_X1 add_1_root_add_22_2_U73 ( .A(add_1_root_add_22_2_n45), .ZN(
        add_1_root_add_22_2_n63) );
  INV_X1 add_1_root_add_22_2_U72 ( .A(add_1_root_add_22_2_n57), .ZN(
        add_1_root_add_22_2_n56) );
  NAND3_X1 add_1_root_add_22_2_U71 ( .A1(N11), .A2(add_1_root_add_22_2_n46), 
        .A3(add_1_root_add_22_2_n56), .ZN(add_1_root_add_22_2_n55) );
  NAND3_X1 add_1_root_add_22_2_U70 ( .A1(add_1_root_add_22_2_n54), .A2(
        add_1_root_add_22_2_n49), .A3(add_1_root_add_22_2_n55), .ZN(
        add_1_root_add_22_2_n52) );
  XNOR2_X1 add_1_root_add_22_2_U69 ( .A(add_1_root_add_22_2_n52), .B(
        add_1_root_add_22_2_n53), .ZN(N23) );
  INV_X1 add_1_root_add_22_2_U68 ( .A(add_1_root_add_22_2_n51), .ZN(
        add_1_root_add_22_2_n50) );
  INV_X1 add_1_root_add_22_2_U67 ( .A(add_1_root_add_22_2_n47), .ZN(
        add_1_root_add_22_2_n14) );
  NAND2_X1 add_1_root_add_22_2_U66 ( .A1(add_1_root_add_22_2_n42), .A2(
        add_1_root_add_22_2_n43), .ZN(add_1_root_add_22_2_n40) );
  XNOR2_X1 add_1_root_add_22_2_U65 ( .A(add_1_root_add_22_2_n40), .B(
        add_1_root_add_22_2_n41), .ZN(N24) );
  NAND3_X1 add_1_root_add_22_2_U64 ( .A1(N11), .A2(add_1_root_add_22_2_n30), 
        .A3(add_1_root_add_22_2_n3), .ZN(add_1_root_add_22_2_n38) );
  NAND3_X1 add_1_root_add_22_2_U63 ( .A1(add_1_root_add_22_2_n21), .A2(
        add_1_root_add_22_2_n30), .A3(add_1_root_add_22_2_n18), .ZN(
        add_1_root_add_22_2_n39) );
  INV_X1 add_1_root_add_22_2_U62 ( .A(add_1_root_add_22_2_n29), .ZN(
        add_1_root_add_22_2_n32) );
  INV_X1 add_1_root_add_22_2_U61 ( .A(add_1_root_add_22_2_n31), .ZN(
        add_1_root_add_22_2_n17) );
  INV_X1 add_1_root_add_22_2_U60 ( .A(add_1_root_add_22_2_n11), .ZN(
        add_1_root_add_22_2_n28) );
  NAND3_X1 add_1_root_add_22_2_U59 ( .A1(N11), .A2(add_1_root_add_22_2_n28), 
        .A3(add_1_root_add_22_2_n3), .ZN(add_1_root_add_22_2_n25) );
  NAND3_X1 add_1_root_add_22_2_U58 ( .A1(add_1_root_add_22_2_n28), .A2(
        add_1_root_add_22_2_n21), .A3(add_1_root_add_22_2_n18), .ZN(
        add_1_root_add_22_2_n27) );
  INV_X1 add_1_root_add_22_2_U57 ( .A(add_1_root_add_22_2_n15), .ZN(
        add_1_root_add_22_2_n16) );
  NAND3_X1 add_1_root_add_22_2_U56 ( .A1(N11), .A2(add_1_root_add_22_2_n3), 
        .A3(add_1_root_add_22_2_n22), .ZN(add_1_root_add_22_2_n6) );
  NOR2_X1 add_1_root_add_22_2_U55 ( .A1(add_1_root_add_22_2_n16), .A2(
        add_1_root_add_22_2_n17), .ZN(add_1_root_add_22_2_n9) );
  NAND3_X1 add_1_root_add_22_2_U54 ( .A1(add_1_root_add_22_2_n6), .A2(
        add_1_root_add_22_2_n7), .A3(add_1_root_add_22_2_n8), .ZN(
        add_1_root_add_22_2_n4) );
  XNOR2_X1 add_1_root_add_22_2_U53 ( .A(add_1_root_add_22_2_n4), .B(
        add_1_root_add_22_2_n5), .ZN(N27) );
  INV_X1 add_1_root_add_22_2_U52 ( .A(N11), .ZN(add_1_root_add_22_2_n61) );
  NAND2_X1 add_1_root_add_22_2_U51 ( .A1(N11), .A2(add_1_root_add_22_2_n3), 
        .ZN(add_1_root_add_22_2_n43) );
  NAND4_X1 add_1_root_add_22_2_U50 ( .A1(add_1_root_add_22_2_n17), .A2(
        add_1_root_add_22_2_n25), .A3(add_1_root_add_22_2_n26), .A4(
        add_1_root_add_22_2_n27), .ZN(add_1_root_add_22_2_n23) );
  XNOR2_X1 add_1_root_add_22_2_U49 ( .A(add_1_root_add_22_2_n23), .B(
        add_1_root_add_22_2_n24), .ZN(N26) );
  XNOR2_X1 add_1_root_add_22_2_U48 ( .A(b[15]), .B(a[15]), .ZN(
        add_1_root_add_22_2_n5) );
  NAND2_X1 add_1_root_add_22_2_U47 ( .A1(b[14]), .A2(a[14]), .ZN(
        add_1_root_add_22_2_n13) );
  NAND2_X1 add_1_root_add_22_2_U46 ( .A1(b[8]), .A2(a[8]), .ZN(
        add_1_root_add_22_2_n64) );
  NAND2_X1 add_1_root_add_22_2_U45 ( .A1(b[10]), .A2(a[10]), .ZN(
        add_1_root_add_22_2_n49) );
  NAND2_X1 add_1_root_add_22_2_U44 ( .A1(b[13]), .A2(a[13]), .ZN(
        add_1_root_add_22_2_n34) );
  NAND2_X1 add_1_root_add_22_2_U43 ( .A1(b[12]), .A2(a[12]), .ZN(
        add_1_root_add_22_2_n33) );
  NAND2_X1 add_1_root_add_22_2_U42 ( .A1(b[11]), .A2(a[11]), .ZN(
        add_1_root_add_22_2_n47) );
  OR2_X2 add_1_root_add_22_2_U41 ( .A1(b[8]), .A2(a[8]), .ZN(
        add_1_root_add_22_2_n44) );
  OR2_X2 add_1_root_add_22_2_U40 ( .A1(b[13]), .A2(a[13]), .ZN(
        add_1_root_add_22_2_n29) );
  NAND2_X1 add_1_root_add_22_2_U39 ( .A1(b[9]), .A2(a[9]), .ZN(
        add_1_root_add_22_2_n51) );
  OR2_X2 add_1_root_add_22_2_U38 ( .A1(b[11]), .A2(a[11]), .ZN(
        add_1_root_add_22_2_n21) );
  OR2_X2 add_1_root_add_22_2_U37 ( .A1(b[12]), .A2(a[12]), .ZN(
        add_1_root_add_22_2_n30) );
  OR2_X2 add_1_root_add_22_2_U36 ( .A1(b[10]), .A2(a[10]), .ZN(
        add_1_root_add_22_2_n46) );
  OR2_X2 add_1_root_add_22_2_U35 ( .A1(b[9]), .A2(a[9]), .ZN(
        add_1_root_add_22_2_n45) );
  NAND2_X1 add_1_root_add_22_2_U34 ( .A1(add_1_root_add_22_2_n45), .A2(
        add_1_root_add_22_2_n51), .ZN(add_1_root_add_22_2_n66) );
  NAND2_X1 add_1_root_add_22_2_U33 ( .A1(add_1_root_add_22_2_n21), .A2(
        add_1_root_add_22_2_n47), .ZN(add_1_root_add_22_2_n53) );
  NAND2_X1 add_1_root_add_22_2_U32 ( .A1(add_1_root_add_22_2_n30), .A2(
        add_1_root_add_22_2_n33), .ZN(add_1_root_add_22_2_n41) );
  XNOR2_X1 add_1_root_add_22_2_U31 ( .A(add_1_root_add_22_2_n59), .B(
        add_1_root_add_22_2_n60), .ZN(N22) );
  XNOR2_X1 add_1_root_add_22_2_U30 ( .A(add_1_root_add_22_2_n35), .B(
        add_1_root_add_22_2_n36), .ZN(N25) );
  NAND2_X1 add_1_root_add_22_2_U29 ( .A1(add_1_root_add_22_2_n34), .A2(
        add_1_root_add_22_2_n29), .ZN(add_1_root_add_22_2_n36) );
  NAND2_X1 add_1_root_add_22_2_U28 ( .A1(add_1_root_add_22_2_n13), .A2(
        add_1_root_add_22_2_n15), .ZN(add_1_root_add_22_2_n24) );
  NAND2_X1 add_1_root_add_22_2_U27 ( .A1(add_1_root_add_22_2_n49), .A2(
        add_1_root_add_22_2_n46), .ZN(add_1_root_add_22_2_n60) );
  NAND2_X1 add_1_root_add_22_2_U26 ( .A1(add_1_root_add_22_2_n44), .A2(
        add_1_root_add_22_2_n45), .ZN(add_1_root_add_22_2_n57) );
  OAI21_X1 add_1_root_add_22_2_U25 ( .B1(add_1_root_add_22_2_n63), .B2(
        add_1_root_add_22_2_n64), .A(add_1_root_add_22_2_n51), .ZN(
        add_1_root_add_22_2_n58) );
  NAND2_X1 add_1_root_add_22_2_U24 ( .A1(add_1_root_add_22_2_n21), .A2(
        add_1_root_add_22_2_n15), .ZN(add_1_root_add_22_2_n20) );
  NOR2_X1 add_1_root_add_22_2_U23 ( .A1(add_1_root_add_22_2_n11), .A2(
        add_1_root_add_22_2_n20), .ZN(add_1_root_add_22_2_n19) );
  OAI21_X1 add_1_root_add_22_2_U22 ( .B1(add_1_root_add_22_2_n32), .B2(
        add_1_root_add_22_2_n33), .A(add_1_root_add_22_2_n34), .ZN(
        add_1_root_add_22_2_n31) );
  NAND2_X1 add_1_root_add_22_2_U21 ( .A1(add_1_root_add_22_2_n14), .A2(
        add_1_root_add_22_2_n15), .ZN(add_1_root_add_22_2_n12) );
  OAI21_X1 add_1_root_add_22_2_U20 ( .B1(add_1_root_add_22_2_n11), .B2(
        add_1_root_add_22_2_n12), .A(add_1_root_add_22_2_n13), .ZN(
        add_1_root_add_22_2_n10) );
  AND4_X1 add_1_root_add_22_2_U19 ( .A1(add_1_root_add_22_2_n44), .A2(
        add_1_root_add_22_2_n45), .A3(add_1_root_add_22_2_n46), .A4(
        add_1_root_add_22_2_n21), .ZN(add_1_root_add_22_2_n3) );
  NAND2_X1 add_1_root_add_22_2_U18 ( .A1(add_1_root_add_22_2_n29), .A2(
        add_1_root_add_22_2_n30), .ZN(add_1_root_add_22_2_n11) );
  OAI211_X1 add_1_root_add_22_2_U17 ( .C1(add_1_root_add_22_2_n50), .C2(
        add_1_root_add_22_2_n1), .A(add_1_root_add_22_2_n45), .B(
        add_1_root_add_22_2_n46), .ZN(add_1_root_add_22_2_n48) );
  NAND2_X1 add_1_root_add_22_2_U16 ( .A1(add_1_root_add_22_2_n48), .A2(
        add_1_root_add_22_2_n49), .ZN(add_1_root_add_22_2_n18) );
  AOI21_X1 add_1_root_add_22_2_U15 ( .B1(add_1_root_add_22_2_n18), .B2(
        add_1_root_add_22_2_n21), .A(add_1_root_add_22_2_n14), .ZN(
        add_1_root_add_22_2_n42) );
  NAND2_X1 add_1_root_add_22_2_U14 ( .A1(add_1_root_add_22_2_n58), .A2(
        add_1_root_add_22_2_n46), .ZN(add_1_root_add_22_2_n54) );
  NAND2_X1 add_1_root_add_22_2_U13 ( .A1(add_1_root_add_22_2_n14), .A2(
        add_1_root_add_22_2_n28), .ZN(add_1_root_add_22_2_n26) );
  NAND2_X1 add_1_root_add_22_2_U12 ( .A1(add_1_root_add_22_2_n14), .A2(
        add_1_root_add_22_2_n30), .ZN(add_1_root_add_22_2_n37) );
  NAND4_X1 add_1_root_add_22_2_U11 ( .A1(add_1_root_add_22_2_n37), .A2(
        add_1_root_add_22_2_n38), .A3(add_1_root_add_22_2_n33), .A4(
        add_1_root_add_22_2_n39), .ZN(add_1_root_add_22_2_n35) );
  NOR2_X1 add_1_root_add_22_2_U10 ( .A1(add_1_root_add_22_2_n16), .A2(
        add_1_root_add_22_2_n11), .ZN(add_1_root_add_22_2_n22) );
  NOR2_X1 add_1_root_add_22_2_U9 ( .A1(add_1_root_add_22_2_n9), .A2(
        add_1_root_add_22_2_n10), .ZN(add_1_root_add_22_2_n8) );
  NAND2_X1 add_1_root_add_22_2_U8 ( .A1(add_1_root_add_22_2_n18), .A2(
        add_1_root_add_22_2_n19), .ZN(add_1_root_add_22_2_n7) );
  INV_X1 add_1_root_add_22_2_U7 ( .A(add_1_root_add_22_2_n58), .ZN(
        add_1_root_add_22_2_n62) );
  OAI21_X1 add_1_root_add_22_2_U6 ( .B1(add_1_root_add_22_2_n61), .B2(
        add_1_root_add_22_2_n57), .A(add_1_root_add_22_2_n62), .ZN(
        add_1_root_add_22_2_n59) );
  OR2_X1 add_1_root_add_22_2_U5 ( .A1(b[14]), .A2(a[14]), .ZN(
        add_1_root_add_22_2_n15) );
  AND2_X1 add_1_root_add_22_2_U4 ( .A1(add_1_root_add_22_2_n64), .A2(
        add_1_root_add_22_2_n44), .ZN(add_1_root_add_22_2_n2) );
  XNOR2_X1 add_1_root_add_22_2_U3 ( .A(add_1_root_add_22_2_n61), .B(
        add_1_root_add_22_2_n2), .ZN(N20) );
  AND2_X1 add_1_root_add_22_2_U2 ( .A1(b[8]), .A2(a[8]), .ZN(
        add_1_root_add_22_2_n1) );
endmodule

