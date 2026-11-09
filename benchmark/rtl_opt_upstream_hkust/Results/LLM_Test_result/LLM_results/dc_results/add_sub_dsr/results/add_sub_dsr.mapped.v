/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Thu May 15 22:34:32 2025
/////////////////////////////////////////////////////////////


module add_sub_dsr ( a, b, control, result );
  input [15:0] a;
  input [15:0] b;
  output [15:0] result;
  input control;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N31, N30, N29, N28, N27, N26, N25, N24, N23, N22, N21, N20, N19, N18,
         N16, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72,
         n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83,
         add_0_root_add_0_root_add_8_2_n139,
         add_0_root_add_0_root_add_8_2_n138,
         add_0_root_add_0_root_add_8_2_n137,
         add_0_root_add_0_root_add_8_2_n136,
         add_0_root_add_0_root_add_8_2_n135,
         add_0_root_add_0_root_add_8_2_n134,
         add_0_root_add_0_root_add_8_2_n133,
         add_0_root_add_0_root_add_8_2_n132,
         add_0_root_add_0_root_add_8_2_n131,
         add_0_root_add_0_root_add_8_2_n130,
         add_0_root_add_0_root_add_8_2_n129,
         add_0_root_add_0_root_add_8_2_n128,
         add_0_root_add_0_root_add_8_2_n127,
         add_0_root_add_0_root_add_8_2_n126,
         add_0_root_add_0_root_add_8_2_n125,
         add_0_root_add_0_root_add_8_2_n124,
         add_0_root_add_0_root_add_8_2_n123,
         add_0_root_add_0_root_add_8_2_n122,
         add_0_root_add_0_root_add_8_2_n121,
         add_0_root_add_0_root_add_8_2_n120,
         add_0_root_add_0_root_add_8_2_n119,
         add_0_root_add_0_root_add_8_2_n118,
         add_0_root_add_0_root_add_8_2_n117,
         add_0_root_add_0_root_add_8_2_n116,
         add_0_root_add_0_root_add_8_2_n115,
         add_0_root_add_0_root_add_8_2_n114,
         add_0_root_add_0_root_add_8_2_n113,
         add_0_root_add_0_root_add_8_2_n112,
         add_0_root_add_0_root_add_8_2_n111,
         add_0_root_add_0_root_add_8_2_n110,
         add_0_root_add_0_root_add_8_2_n109,
         add_0_root_add_0_root_add_8_2_n108,
         add_0_root_add_0_root_add_8_2_n107,
         add_0_root_add_0_root_add_8_2_n106,
         add_0_root_add_0_root_add_8_2_n105,
         add_0_root_add_0_root_add_8_2_n104,
         add_0_root_add_0_root_add_8_2_n103,
         add_0_root_add_0_root_add_8_2_n102,
         add_0_root_add_0_root_add_8_2_n101,
         add_0_root_add_0_root_add_8_2_n100, add_0_root_add_0_root_add_8_2_n99,
         add_0_root_add_0_root_add_8_2_n98, add_0_root_add_0_root_add_8_2_n97,
         add_0_root_add_0_root_add_8_2_n96, add_0_root_add_0_root_add_8_2_n95,
         add_0_root_add_0_root_add_8_2_n94, add_0_root_add_0_root_add_8_2_n93,
         add_0_root_add_0_root_add_8_2_n92, add_0_root_add_0_root_add_8_2_n91,
         add_0_root_add_0_root_add_8_2_n90, add_0_root_add_0_root_add_8_2_n89,
         add_0_root_add_0_root_add_8_2_n88, add_0_root_add_0_root_add_8_2_n87,
         add_0_root_add_0_root_add_8_2_n86, add_0_root_add_0_root_add_8_2_n85,
         add_0_root_add_0_root_add_8_2_n84, add_0_root_add_0_root_add_8_2_n83,
         add_0_root_add_0_root_add_8_2_n82, add_0_root_add_0_root_add_8_2_n81,
         add_0_root_add_0_root_add_8_2_n80, add_0_root_add_0_root_add_8_2_n79,
         add_0_root_add_0_root_add_8_2_n78, add_0_root_add_0_root_add_8_2_n77,
         add_0_root_add_0_root_add_8_2_n76, add_0_root_add_0_root_add_8_2_n75,
         add_0_root_add_0_root_add_8_2_n74, add_0_root_add_0_root_add_8_2_n73,
         add_0_root_add_0_root_add_8_2_n72, add_0_root_add_0_root_add_8_2_n71,
         add_0_root_add_0_root_add_8_2_n70, add_0_root_add_0_root_add_8_2_n69,
         add_0_root_add_0_root_add_8_2_n68, add_0_root_add_0_root_add_8_2_n67,
         add_0_root_add_0_root_add_8_2_n66, add_0_root_add_0_root_add_8_2_n65,
         add_0_root_add_0_root_add_8_2_n64, add_0_root_add_0_root_add_8_2_n63,
         add_0_root_add_0_root_add_8_2_n62, add_0_root_add_0_root_add_8_2_n61,
         add_0_root_add_0_root_add_8_2_n60, add_0_root_add_0_root_add_8_2_n59,
         add_0_root_add_0_root_add_8_2_n58, add_0_root_add_0_root_add_8_2_n57,
         add_0_root_add_0_root_add_8_2_n56, add_0_root_add_0_root_add_8_2_n55,
         add_0_root_add_0_root_add_8_2_n54, add_0_root_add_0_root_add_8_2_n53,
         add_0_root_add_0_root_add_8_2_n52, add_0_root_add_0_root_add_8_2_n51,
         add_0_root_add_0_root_add_8_2_n50, add_0_root_add_0_root_add_8_2_n49,
         add_0_root_add_0_root_add_8_2_n48, add_0_root_add_0_root_add_8_2_n47,
         add_0_root_add_0_root_add_8_2_n46, add_0_root_add_0_root_add_8_2_n44,
         add_0_root_add_0_root_add_8_2_n43, add_0_root_add_0_root_add_8_2_n42,
         add_0_root_add_0_root_add_8_2_n41, add_0_root_add_0_root_add_8_2_n40,
         add_0_root_add_0_root_add_8_2_n39, add_0_root_add_0_root_add_8_2_n38,
         add_0_root_add_0_root_add_8_2_n37, add_0_root_add_0_root_add_8_2_n36,
         add_0_root_add_0_root_add_8_2_n35, add_0_root_add_0_root_add_8_2_n34,
         add_0_root_add_0_root_add_8_2_n33, add_0_root_add_0_root_add_8_2_n32,
         add_0_root_add_0_root_add_8_2_n31, add_0_root_add_0_root_add_8_2_n30,
         add_0_root_add_0_root_add_8_2_n29, add_0_root_add_0_root_add_8_2_n28,
         add_0_root_add_0_root_add_8_2_n27, add_0_root_add_0_root_add_8_2_n26,
         add_0_root_add_0_root_add_8_2_n25, add_0_root_add_0_root_add_8_2_n24,
         add_0_root_add_0_root_add_8_2_n23, add_0_root_add_0_root_add_8_2_n22,
         add_0_root_add_0_root_add_8_2_n21, add_0_root_add_0_root_add_8_2_n20,
         add_0_root_add_0_root_add_8_2_n19, add_0_root_add_0_root_add_8_2_n18,
         add_0_root_add_0_root_add_8_2_n17, add_0_root_add_0_root_add_8_2_n16,
         add_0_root_add_0_root_add_8_2_n15, add_0_root_add_0_root_add_8_2_n14,
         add_0_root_add_0_root_add_8_2_n13, add_0_root_add_0_root_add_8_2_n12,
         add_0_root_add_0_root_add_8_2_n11, add_0_root_add_0_root_add_8_2_n10,
         add_0_root_add_0_root_add_8_2_n9, add_0_root_add_0_root_add_8_2_n8,
         add_0_root_add_0_root_add_8_2_n7, add_0_root_add_0_root_add_8_2_n6,
         add_0_root_add_0_root_add_8_2_n5, add_0_root_add_0_root_add_8_2_n4,
         add_0_root_add_0_root_add_8_2_n3, add_0_root_add_0_root_add_8_2_n2,
         add_0_root_add_0_root_add_8_2_n1;

  INV_X1 U20 ( .A(a[1]), .ZN(n3) );
  AND2_X2 U21 ( .A1(n31), .A2(n60), .ZN(n26) );
  OR3_X2 U22 ( .A1(a[1]), .A2(a[5]), .A3(a[2]), .ZN(n5) );
  AND3_X1 U23 ( .A1(n72), .A2(n69), .A3(n71), .ZN(n4) );
  NOR2_X1 U24 ( .A1(a[3]), .A2(a[2]), .ZN(n37) );
  INV_X1 U25 ( .A(control), .ZN(n23) );
  INV_X2 U26 ( .A(control), .ZN(n25) );
  BUF_X2 U27 ( .A(a[3]), .Z(n21) );
  OR3_X1 U28 ( .A1(a[1]), .A2(a[9]), .A3(a[2]), .ZN(n6) );
  AND2_X1 U29 ( .A1(n12), .A2(n49), .ZN(n7) );
  AND2_X1 U30 ( .A1(n49), .A2(n48), .ZN(n8) );
  INV_X1 U31 ( .A(control), .ZN(n82) );
  INV_X1 U32 ( .A(n66), .ZN(n9) );
  BUF_X1 U33 ( .A(n35), .Z(n10) );
  INV_X1 U34 ( .A(control), .ZN(n28) );
  AND2_X1 U35 ( .A1(n65), .A2(n10), .ZN(n11) );
  AND4_X2 U36 ( .A1(n19), .A2(n17), .A3(n18), .A4(n20), .ZN(n65) );
  AND2_X1 U37 ( .A1(n33), .A2(n4), .ZN(n12) );
  AOI211_X1 U38 ( .C1(n27), .C2(a[0]), .A(a[4]), .B(a[3]), .ZN(n53) );
  XNOR2_X1 U39 ( .A(a[11]), .B(n50), .ZN(N27) );
  XNOR2_X1 U40 ( .A(a[13]), .B(n47), .ZN(N29) );
  NAND2_X1 U41 ( .A1(n82), .A2(a[0]), .ZN(n35) );
  NAND3_X1 U42 ( .A1(n28), .A2(a[1]), .A3(a[0]), .ZN(n80) );
  AND4_X1 U43 ( .A1(n13), .A2(n14), .A3(n15), .A4(n16), .ZN(n32) );
  INV_X1 U44 ( .A(a[2]), .ZN(n13) );
  INV_X1 U45 ( .A(a[1]), .ZN(n14) );
  INV_X1 U46 ( .A(a[5]), .ZN(n15) );
  INV_X1 U47 ( .A(a[6]), .ZN(n16) );
  INV_X1 U48 ( .A(a[2]), .ZN(n17) );
  INV_X1 U49 ( .A(a[3]), .ZN(n18) );
  INV_X1 U50 ( .A(a[1]), .ZN(n19) );
  INV_X1 U51 ( .A(a[4]), .ZN(n20) );
  NOR2_X1 U52 ( .A1(n61), .A2(n5), .ZN(n64) );
  INV_X1 U53 ( .A(control), .ZN(n22) );
  XNOR2_X1 U54 ( .A(control), .B(b[1]), .ZN(N14) );
  INV_X1 U55 ( .A(control), .ZN(n27) );
  INV_X1 U56 ( .A(control), .ZN(n24) );
  NOR2_X1 U57 ( .A1(n41), .A2(n29), .ZN(n33) );
  NAND2_X1 U58 ( .A1(n36), .A2(n34), .ZN(n29) );
  AOI211_X1 U59 ( .C1(a[0]), .C2(n22), .A(a[4]), .B(n21), .ZN(n30) );
  AND2_X1 U60 ( .A1(n32), .A2(n53), .ZN(n31) );
  NAND2_X1 U61 ( .A1(n12), .A2(n8), .ZN(n47) );
  NAND2_X1 U62 ( .A1(n33), .A2(n4), .ZN(n50) );
  INV_X1 U63 ( .A(a[10]), .ZN(n34) );
  NOR3_X1 U64 ( .A1(a[1]), .A2(a[9]), .A3(a[2]), .ZN(n36) );
  NOR2_X1 U65 ( .A1(n41), .A2(n6), .ZN(n42) );
  XNOR2_X1 U66 ( .A(a[14]), .B(n44), .ZN(N30) );
  INV_X1 U67 ( .A(a[8]), .ZN(n58) );
  INV_X1 U68 ( .A(a[2]), .ZN(n77) );
  INV_X1 U69 ( .A(control), .ZN(n38) );
  INV_X1 U70 ( .A(control), .ZN(n39) );
  AND2_X1 U71 ( .A1(n26), .A2(n58), .ZN(n40) );
  NAND3_X1 U72 ( .A1(n35), .A2(n19), .A3(n37), .ZN(n73) );
  XNOR2_X1 U73 ( .A(n76), .B(n77), .ZN(N18) );
  AOI21_X1 U74 ( .B1(n24), .B2(a[0]), .A(a[1]), .ZN(n76) );
  XOR2_X1 U75 ( .A(n23), .B(b[15]), .Z(N0) );
  XOR2_X1 U76 ( .A(n25), .B(b[14]), .Z(N1) );
  XOR2_X1 U77 ( .A(n22), .B(b[13]), .Z(N2) );
  XOR2_X1 U78 ( .A(n25), .B(b[12]), .Z(N3) );
  XOR2_X1 U79 ( .A(n22), .B(b[11]), .Z(N4) );
  XOR2_X1 U80 ( .A(n23), .B(b[10]), .Z(N5) );
  XOR2_X1 U81 ( .A(n39), .B(b[9]), .Z(N6) );
  XOR2_X1 U82 ( .A(n23), .B(b[8]), .Z(N7) );
  XOR2_X1 U83 ( .A(n23), .B(b[7]), .Z(N8) );
  XOR2_X1 U84 ( .A(n25), .B(b[6]), .Z(N9) );
  XOR2_X1 U85 ( .A(n25), .B(b[5]), .Z(N10) );
  XOR2_X1 U86 ( .A(n23), .B(b[4]), .Z(N11) );
  XOR2_X1 U87 ( .A(n28), .B(b[3]), .Z(N12) );
  XOR2_X1 U88 ( .A(n38), .B(b[2]), .Z(N13) );
  XOR2_X1 U89 ( .A(n24), .B(b[0]), .Z(N15) );
  INV_X1 U90 ( .A(a[11]), .ZN(n49) );
  INV_X1 U91 ( .A(a[12]), .ZN(n48) );
  INV_X1 U92 ( .A(a[5]), .ZN(n66) );
  INV_X1 U93 ( .A(a[7]), .ZN(n60) );
  INV_X1 U94 ( .A(a[6]), .ZN(n63) );
  NAND4_X1 U95 ( .A1(n66), .A2(n60), .A3(n63), .A4(n58), .ZN(n41) );
  INV_X1 U96 ( .A(a[3]), .ZN(n72) );
  INV_X1 U97 ( .A(a[4]), .ZN(n69) );
  NAND2_X1 U98 ( .A1(a[0]), .A2(n38), .ZN(n71) );
  NAND3_X1 U99 ( .A1(n72), .A2(n69), .A3(n71), .ZN(n61) );
  NAND2_X1 U100 ( .A1(n4), .A2(n42), .ZN(n55) );
  INV_X1 U101 ( .A(n55), .ZN(n52) );
  INV_X1 U102 ( .A(a[10]), .ZN(n51) );
  INV_X1 U103 ( .A(n47), .ZN(n46) );
  INV_X1 U104 ( .A(a[13]), .ZN(n45) );
  NAND2_X1 U105 ( .A1(n46), .A2(n45), .ZN(n44) );
  NOR2_X1 U106 ( .A1(a[14]), .A2(n44), .ZN(n43) );
  XOR2_X1 U107 ( .A(a[15]), .B(n43), .Z(N31) );
  OAI21_X1 U108 ( .B1(n7), .B2(n48), .A(n47), .ZN(N28) );
  OAI21_X1 U109 ( .B1(n52), .B2(n51), .A(n50), .ZN(N26) );
  NOR4_X1 U110 ( .A1(a[6]), .A2(a[5]), .A3(a[1]), .A4(a[2]), .ZN(n54) );
  NAND2_X1 U111 ( .A1(n30), .A2(n54), .ZN(n62) );
  NAND2_X1 U112 ( .A1(n31), .A2(n60), .ZN(n59) );
  NAND2_X1 U113 ( .A1(n26), .A2(n58), .ZN(n57) );
  INV_X1 U114 ( .A(a[9]), .ZN(n56) );
  OAI21_X1 U115 ( .B1(n40), .B2(n56), .A(n55), .ZN(N25) );
  OAI21_X1 U116 ( .B1(n58), .B2(n26), .A(n57), .ZN(N24) );
  OAI21_X1 U117 ( .B1(n60), .B2(n31), .A(n59), .ZN(N23) );
  OAI21_X1 U118 ( .B1(n64), .B2(n63), .A(n62), .ZN(N22) );
  NAND2_X1 U119 ( .A1(n65), .A2(n10), .ZN(n68) );
  OAI22_X1 U120 ( .A1(n11), .A2(n66), .B1(n68), .B2(n9), .ZN(N21) );
  INV_X1 U121 ( .A(a[1]), .ZN(n78) );
  NAND2_X1 U122 ( .A1(n72), .A2(n3), .ZN(n67) );
  AOI211_X1 U123 ( .C1(a[0]), .C2(n25), .A(a[2]), .B(n67), .ZN(n70) );
  OAI21_X1 U124 ( .B1(n70), .B2(n69), .A(n68), .ZN(N20) );
  NAND3_X1 U125 ( .A1(n21), .A2(a[0]), .A3(n39), .ZN(n75) );
  OAI21_X1 U126 ( .B1(a[1]), .B2(a[2]), .A(n21), .ZN(n74) );
  NAND3_X1 U127 ( .A1(n73), .A2(n74), .A3(n75), .ZN(N19) );
  INV_X1 U128 ( .A(a[0]), .ZN(n79) );
  OAI21_X1 U129 ( .B1(control), .B2(n79), .A(n78), .ZN(n81) );
  NAND2_X1 U130 ( .A1(n81), .A2(n80), .ZN(n83) );
  XOR2_X1 U131 ( .A(n27), .B(a[0]), .Z(N16) );
  INV_X1 add_0_root_add_0_root_add_8_2_U155 ( .A(
        add_0_root_add_0_root_add_8_2_n1), .ZN(
        add_0_root_add_0_root_add_8_2_n112) );
  NOR2_X1 add_0_root_add_0_root_add_8_2_U154 ( .A1(
        add_0_root_add_0_root_add_8_2_n42), .A2(
        add_0_root_add_0_root_add_8_2_n33), .ZN(
        add_0_root_add_0_root_add_8_2_n128) );
  INV_X1 add_0_root_add_0_root_add_8_2_U153 ( .A(
        add_0_root_add_0_root_add_8_2_n37), .ZN(
        add_0_root_add_0_root_add_8_2_n76) );
  INV_X1 add_0_root_add_0_root_add_8_2_U152 ( .A(
        add_0_root_add_0_root_add_8_2_n74), .ZN(
        add_0_root_add_0_root_add_8_2_n134) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U151 ( .A1(
        add_0_root_add_0_root_add_8_2_n132), .A2(
        add_0_root_add_0_root_add_8_2_n133), .ZN(
        add_0_root_add_0_root_add_8_2_n131) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U150 ( .A1(
        add_0_root_add_0_root_add_8_2_n129), .A2(
        add_0_root_add_0_root_add_8_2_n19), .A3(
        add_0_root_add_0_root_add_8_2_n128), .ZN(
        add_0_root_add_0_root_add_8_2_n127) );
  INV_X1 add_0_root_add_0_root_add_8_2_U149 ( .A(
        add_0_root_add_0_root_add_8_2_n125), .ZN(
        add_0_root_add_0_root_add_8_2_n121) );
  INV_X1 add_0_root_add_0_root_add_8_2_U148 ( .A(
        add_0_root_add_0_root_add_8_2_n124), .ZN(
        add_0_root_add_0_root_add_8_2_n111) );
  INV_X1 add_0_root_add_0_root_add_8_2_U147 ( .A(
        add_0_root_add_0_root_add_8_2_n117), .ZN(
        add_0_root_add_0_root_add_8_2_n123) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U146 ( .A(
        add_0_root_add_0_root_add_8_2_n29), .B(
        add_0_root_add_0_root_add_8_2_n122), .ZN(result[10]) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U145 ( .A(
        add_0_root_add_0_root_add_8_2_n119), .B(
        add_0_root_add_0_root_add_8_2_n120), .ZN(result[11]) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U144 ( .A1(N26), .A2(N5), .ZN(
        add_0_root_add_0_root_add_8_2_n117) );
  INV_X1 add_0_root_add_0_root_add_8_2_U143 ( .A(
        add_0_root_add_0_root_add_8_2_n116), .ZN(
        add_0_root_add_0_root_add_8_2_n115) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U142 ( .A1(
        add_0_root_add_0_root_add_8_2_n47), .A2(
        add_0_root_add_0_root_add_8_2_n109), .A3(
        add_0_root_add_0_root_add_8_2_n110), .ZN(
        add_0_root_add_0_root_add_8_2_n108) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U141 ( .A1(N2), .A2(N3), .A3(N28), 
        .ZN(add_0_root_add_0_root_add_8_2_n94) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U140 ( .A1(N3), .A2(N29), .A3(N28), 
        .ZN(add_0_root_add_0_root_add_8_2_n95) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U139 ( .A1(
        add_0_root_add_0_root_add_8_2_n94), .A2(
        add_0_root_add_0_root_add_8_2_n95), .A3(
        add_0_root_add_0_root_add_8_2_n96), .ZN(
        add_0_root_add_0_root_add_8_2_n93) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U138 ( .A1(
        add_0_root_add_0_root_add_8_2_n49), .A2(
        add_0_root_add_0_root_add_8_2_n91), .A3(
        add_0_root_add_0_root_add_8_2_n25), .ZN(
        add_0_root_add_0_root_add_8_2_n90) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U137 ( .A1(
        add_0_root_add_0_root_add_8_2_n90), .A2(
        add_0_root_add_0_root_add_8_2_n89), .A3(
        add_0_root_add_0_root_add_8_2_n88), .ZN(
        add_0_root_add_0_root_add_8_2_n86) );
  INV_X1 add_0_root_add_0_root_add_8_2_U136 ( .A(
        add_0_root_add_0_root_add_8_2_n78), .ZN(
        add_0_root_add_0_root_add_8_2_n75) );
  OAI21_X1 add_0_root_add_0_root_add_8_2_U135 ( .B1(
        add_0_root_add_0_root_add_8_2_n75), .B2(
        add_0_root_add_0_root_add_8_2_n76), .A(
        add_0_root_add_0_root_add_8_2_n26), .ZN(
        add_0_root_add_0_root_add_8_2_n71) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U134 ( .A(
        add_0_root_add_0_root_add_8_2_n71), .B(
        add_0_root_add_0_root_add_8_2_n72), .ZN(result[3]) );
  OAI21_X1 add_0_root_add_0_root_add_8_2_U133 ( .B1(
        add_0_root_add_0_root_add_8_2_n121), .B2(
        add_0_root_add_0_root_add_8_2_n111), .A(
        add_0_root_add_0_root_add_8_2_n117), .ZN(
        add_0_root_add_0_root_add_8_2_n119) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U132 ( .A1(
        add_0_root_add_0_root_add_8_2_n92), .A2(
        add_0_root_add_0_root_add_8_2_n25), .ZN(
        add_0_root_add_0_root_add_8_2_n99) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U131 ( .A1(n83), .A2(N14), .ZN(
        add_0_root_add_0_root_add_8_2_n81) );
  OAI211_X1 add_0_root_add_0_root_add_8_2_U130 ( .C1(
        add_0_root_add_0_root_add_8_2_n12), .C2(
        add_0_root_add_0_root_add_8_2_n85), .A(
        add_0_root_add_0_root_add_8_2_n81), .B(
        add_0_root_add_0_root_add_8_2_n77), .ZN(
        add_0_root_add_0_root_add_8_2_n133) );
  OAI21_X1 add_0_root_add_0_root_add_8_2_U129 ( .B1(
        add_0_root_add_0_root_add_8_2_n11), .B2(
        add_0_root_add_0_root_add_8_2_n12), .A(
        add_0_root_add_0_root_add_8_2_n81), .ZN(
        add_0_root_add_0_root_add_8_2_n78) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U128 ( .A(
        add_0_root_add_0_root_add_8_2_n35), .B(
        add_0_root_add_0_root_add_8_2_n53), .ZN(result[8]) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U127 ( .A1(N29), .A2(N2), .ZN(
        add_0_root_add_0_root_add_8_2_n96) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U126 ( .A(
        add_0_root_add_0_root_add_8_2_n86), .B(
        add_0_root_add_0_root_add_8_2_n87), .ZN(result[15]) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U125 ( .A1(N25), .A2(N6), .ZN(
        add_0_root_add_0_root_add_8_2_n52) );
  OAI211_X1 add_0_root_add_0_root_add_8_2_U124 ( .C1(
        add_0_root_add_0_root_add_8_2_n32), .C2(
        add_0_root_add_0_root_add_8_2_n54), .A(
        add_0_root_add_0_root_add_8_2_n52), .B(
        add_0_root_add_0_root_add_8_2_n117), .ZN(
        add_0_root_add_0_root_add_8_2_n114) );
  OAI21_X1 add_0_root_add_0_root_add_8_2_U123 ( .B1(
        add_0_root_add_0_root_add_8_2_n50), .B2(
        add_0_root_add_0_root_add_8_2_n112), .A(
        add_0_root_add_0_root_add_8_2_n16), .ZN(
        add_0_root_add_0_root_add_8_2_n125) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U122 ( .A(
        add_0_root_add_0_root_add_8_2_n97), .B(
        add_0_root_add_0_root_add_8_2_n98), .ZN(result[14]) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U121 ( .A1(N27), .A2(N4), .ZN(
        add_0_root_add_0_root_add_8_2_n116) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U120 ( .A1(
        add_0_root_add_0_root_add_8_2_n92), .A2(
        add_0_root_add_0_root_add_8_2_n101), .ZN(
        add_0_root_add_0_root_add_8_2_n105) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U119 ( .A(
        add_0_root_add_0_root_add_8_2_n31), .B(
        add_0_root_add_0_root_add_8_2_n106), .ZN(result[12]) );
  OAI211_X1 add_0_root_add_0_root_add_8_2_U118 ( .C1(
        add_0_root_add_0_root_add_8_2_n42), .C2(
        add_0_root_add_0_root_add_8_2_n67), .A(
        add_0_root_add_0_root_add_8_2_n63), .B(
        add_0_root_add_0_root_add_8_2_n60), .ZN(
        add_0_root_add_0_root_add_8_2_n137) );
  AOI21_X1 add_0_root_add_0_root_add_8_2_U117 ( .B1(
        add_0_root_add_0_root_add_8_2_n137), .B2(
        add_0_root_add_0_root_add_8_2_n136), .A(
        add_0_root_add_0_root_add_8_2_n30), .ZN(
        add_0_root_add_0_root_add_8_2_n126) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U116 ( .A1(
        add_0_root_add_0_root_add_8_2_n131), .A2(
        add_0_root_add_0_root_add_8_2_n130), .ZN(
        add_0_root_add_0_root_add_8_2_n68) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U115 ( .A1(
        add_0_root_add_0_root_add_8_2_n19), .A2(
        add_0_root_add_0_root_add_8_2_n69), .ZN(
        add_0_root_add_0_root_add_8_2_n66) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U114 ( .A(
        add_0_root_add_0_root_add_8_2_n70), .B(
        add_0_root_add_0_root_add_8_2_n68), .ZN(result[4]) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U113 ( .A1(
        add_0_root_add_0_root_add_8_2_n96), .A2(
        add_0_root_add_0_root_add_8_2_n100), .ZN(
        add_0_root_add_0_root_add_8_2_n103) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U112 ( .A1(
        add_0_root_add_0_root_add_8_2_n24), .A2(N1), .ZN(
        add_0_root_add_0_root_add_8_2_n89) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U111 ( .A1(
        add_0_root_add_0_root_add_8_2_n93), .A2(
        add_0_root_add_0_root_add_8_2_n91), .ZN(
        add_0_root_add_0_root_add_8_2_n88) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U110 ( .A1(
        add_0_root_add_0_root_add_8_2_n91), .A2(
        add_0_root_add_0_root_add_8_2_n89), .ZN(
        add_0_root_add_0_root_add_8_2_n98) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U109 ( .A1(
        add_0_root_add_0_root_add_8_2_n57), .A2(
        add_0_root_add_0_root_add_8_2_n61), .ZN(
        add_0_root_add_0_root_add_8_2_n129) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U108 ( .A1(
        add_0_root_add_0_root_add_8_2_n105), .A2(
        add_0_root_add_0_root_add_8_2_n104), .ZN(
        add_0_root_add_0_root_add_8_2_n102) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U107 ( .A(
        add_0_root_add_0_root_add_8_2_n102), .B(
        add_0_root_add_0_root_add_8_2_n103), .ZN(result[13]) );
  AOI21_X1 add_0_root_add_0_root_add_8_2_U106 ( .B1(
        add_0_root_add_0_root_add_8_2_n18), .B2(
        add_0_root_add_0_root_add_8_2_n113), .A(
        add_0_root_add_0_root_add_8_2_n115), .ZN(
        add_0_root_add_0_root_add_8_2_n107) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U105 ( .A1(
        add_0_root_add_0_root_add_8_2_n118), .A2(
        add_0_root_add_0_root_add_8_2_n124), .ZN(
        add_0_root_add_0_root_add_8_2_n110) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U104 ( .A1(
        add_0_root_add_0_root_add_8_2_n107), .A2(
        add_0_root_add_0_root_add_8_2_n38), .ZN(
        add_0_root_add_0_root_add_8_2_n92) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U103 ( .A1(N19), .A2(N12), .ZN(
        add_0_root_add_0_root_add_8_2_n74) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U102 ( .A1(
        add_0_root_add_0_root_add_8_2_n34), .A2(N8), .ZN(
        add_0_root_add_0_root_add_8_2_n58) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U101 ( .A1(N21), .A2(N10), .ZN(
        add_0_root_add_0_root_add_8_2_n63) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U100 ( .A(N31), .B(N0), .ZN(
        add_0_root_add_0_root_add_8_2_n87) );
  INV_X1 add_0_root_add_0_root_add_8_2_U99 ( .A(
        add_0_root_add_0_root_add_8_2_n15), .ZN(
        add_0_root_add_0_root_add_8_2_n139) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U98 ( .A1(
        add_0_root_add_0_root_add_8_2_n138), .A2(
        add_0_root_add_0_root_add_8_2_n139), .ZN(
        add_0_root_add_0_root_add_8_2_n135) );
  INV_X1 add_0_root_add_0_root_add_8_2_U97 ( .A(N16), .ZN(
        add_0_root_add_0_root_add_8_2_n138) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U96 ( .A1(N28), .A2(N3), .ZN(
        add_0_root_add_0_root_add_8_2_n104) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U95 ( .A1(N20), .A2(N11), .ZN(
        add_0_root_add_0_root_add_8_2_n67) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U94 ( .A1(N24), .A2(N7), .ZN(
        add_0_root_add_0_root_add_8_2_n54) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U93 ( .A1(N22), .A2(N9), .ZN(
        add_0_root_add_0_root_add_8_2_n60) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U92 ( .A1(N26), .A2(N5), .ZN(
        add_0_root_add_0_root_add_8_2_n124) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U91 ( .A1(N18), .A2(N13), .ZN(
        add_0_root_add_0_root_add_8_2_n77) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U90 ( .A1(N28), .A2(N3), .ZN(
        add_0_root_add_0_root_add_8_2_n101) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U89 ( .A1(n83), .A2(N14), .ZN(
        add_0_root_add_0_root_add_8_2_n84) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U88 ( .A1(N19), .A2(N12), .ZN(
        add_0_root_add_0_root_add_8_2_n73) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U87 ( .A1(N18), .A2(N13), .ZN(
        add_0_root_add_0_root_add_8_2_n80) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U86 ( .A1(N15), .A2(N16), .ZN(
        add_0_root_add_0_root_add_8_2_n85) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U85 ( .A1(N29), .A2(N2), .ZN(
        add_0_root_add_0_root_add_8_2_n100) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U84 ( .A1(
        add_0_root_add_0_root_add_8_2_n84), .A2(
        add_0_root_add_0_root_add_8_2_n81), .ZN(
        add_0_root_add_0_root_add_8_2_n83) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U83 ( .A(
        add_0_root_add_0_root_add_8_2_n82), .B(
        add_0_root_add_0_root_add_8_2_n83), .ZN(result[1]) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U82 ( .A1(
        add_0_root_add_0_root_add_8_2_n5), .A2(
        add_0_root_add_0_root_add_8_2_n2), .ZN(
        add_0_root_add_0_root_add_8_2_n70) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U81 ( .A1(
        add_0_root_add_0_root_add_8_2_n37), .A2(
        add_0_root_add_0_root_add_8_2_n26), .ZN(
        add_0_root_add_0_root_add_8_2_n79) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U80 ( .A(
        add_0_root_add_0_root_add_8_2_n78), .B(
        add_0_root_add_0_root_add_8_2_n79), .ZN(result[2]) );
  INV_X1 add_0_root_add_0_root_add_8_2_U79 ( .A(
        add_0_root_add_0_root_add_8_2_n11), .ZN(
        add_0_root_add_0_root_add_8_2_n82) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U78 ( .A1(
        add_0_root_add_0_root_add_8_2_n73), .A2(
        add_0_root_add_0_root_add_8_2_n74), .ZN(
        add_0_root_add_0_root_add_8_2_n72) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U77 ( .A1(
        add_0_root_add_0_root_add_8_2_n23), .A2(
        add_0_root_add_0_root_add_8_2_n3), .ZN(
        add_0_root_add_0_root_add_8_2_n53) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U76 ( .A1(
        add_0_root_add_0_root_add_8_2_n1), .A2(
        add_0_root_add_0_root_add_8_2_n16), .ZN(
        add_0_root_add_0_root_add_8_2_n48) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U75 ( .A(
        add_0_root_add_0_root_add_8_2_n39), .B(
        add_0_root_add_0_root_add_8_2_n48), .ZN(result[9]) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U74 ( .A1(
        add_0_root_add_0_root_add_8_2_n104), .A2(
        add_0_root_add_0_root_add_8_2_n101), .ZN(
        add_0_root_add_0_root_add_8_2_n106) );
  NOR2_X1 add_0_root_add_0_root_add_8_2_U73 ( .A1(
        add_0_root_add_0_root_add_8_2_n111), .A2(
        add_0_root_add_0_root_add_8_2_n123), .ZN(
        add_0_root_add_0_root_add_8_2_n122) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U72 ( .A1(
        add_0_root_add_0_root_add_8_2_n62), .A2(
        add_0_root_add_0_root_add_8_2_n8), .ZN(
        add_0_root_add_0_root_add_8_2_n59) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U71 ( .A1(
        add_0_root_add_0_root_add_8_2_n59), .A2(
        add_0_root_add_0_root_add_8_2_n60), .ZN(
        add_0_root_add_0_root_add_8_2_n56) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U70 ( .A1(
        add_0_root_add_0_root_add_8_2_n66), .A2(
        add_0_root_add_0_root_add_8_2_n5), .ZN(
        add_0_root_add_0_root_add_8_2_n64) );
  OAI21_X1 add_0_root_add_0_root_add_8_2_U69 ( .B1(
        add_0_root_add_0_root_add_8_2_n4), .B2(
        add_0_root_add_0_root_add_8_2_n36), .A(
        add_0_root_add_0_root_add_8_2_n63), .ZN(
        add_0_root_add_0_root_add_8_2_n62) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U68 ( .A1(
        add_0_root_add_0_root_add_8_2_n27), .A2(
        add_0_root_add_0_root_add_8_2_n61), .ZN(
        add_0_root_add_0_root_add_8_2_n136) );
  INV_X1 add_0_root_add_0_root_add_8_2_U67 ( .A(
        add_0_root_add_0_root_add_8_2_n134), .ZN(
        add_0_root_add_0_root_add_8_2_n130) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U66 ( .A1(
        add_0_root_add_0_root_add_8_2_n116), .A2(
        add_0_root_add_0_root_add_8_2_n118), .ZN(
        add_0_root_add_0_root_add_8_2_n120) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U65 ( .A1(
        add_0_root_add_0_root_add_8_2_n126), .A2(
        add_0_root_add_0_root_add_8_2_n21), .ZN(
        add_0_root_add_0_root_add_8_2_n47) );
  AOI21_X1 add_0_root_add_0_root_add_8_2_U64 ( .B1(
        add_0_root_add_0_root_add_8_2_n114), .B2(
        add_0_root_add_0_root_add_8_2_n113), .A(
        add_0_root_add_0_root_add_8_2_n115), .ZN(
        add_0_root_add_0_root_add_8_2_n46) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U63 ( .A1(
        add_0_root_add_0_root_add_8_2_n135), .A2(
        add_0_root_add_0_root_add_8_2_n11), .ZN(result[0]) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U62 ( .A1(N24), .A2(N7), .ZN(
        add_0_root_add_0_root_add_8_2_n55) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U61 ( .A1(N23), .A2(N8), .ZN(
        add_0_root_add_0_root_add_8_2_n57) );
  OR2_X2 add_0_root_add_0_root_add_8_2_U60 ( .A1(N30), .A2(N1), .ZN(
        add_0_root_add_0_root_add_8_2_n91) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U59 ( .A1(
        add_0_root_add_0_root_add_8_2_n65), .A2(
        add_0_root_add_0_root_add_8_2_n63), .ZN(
        add_0_root_add_0_root_add_8_2_n44) );
  XOR2_X1 add_0_root_add_0_root_add_8_2_U58 ( .A(
        add_0_root_add_0_root_add_8_2_n64), .B(
        add_0_root_add_0_root_add_8_2_n44), .Z(result[5]) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U57 ( .A1(
        add_0_root_add_0_root_add_8_2_n8), .A2(
        add_0_root_add_0_root_add_8_2_n60), .ZN(
        add_0_root_add_0_root_add_8_2_n43) );
  XOR2_X1 add_0_root_add_0_root_add_8_2_U56 ( .A(
        add_0_root_add_0_root_add_8_2_n62), .B(
        add_0_root_add_0_root_add_8_2_n43), .Z(result[6]) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U55 ( .A1(
        add_0_root_add_0_root_add_8_2_n55), .A2(
        add_0_root_add_0_root_add_8_2_n20), .ZN(
        add_0_root_add_0_root_add_8_2_n41) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U54 ( .A1(
        add_0_root_add_0_root_add_8_2_n40), .A2(
        add_0_root_add_0_root_add_8_2_n41), .ZN(
        add_0_root_add_0_root_add_8_2_n50) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U53 ( .A1(
        add_0_root_add_0_root_add_8_2_n73), .A2(
        add_0_root_add_0_root_add_8_2_n80), .ZN(
        add_0_root_add_0_root_add_8_2_n132) );
  INV_X1 add_0_root_add_0_root_add_8_2_U52 ( .A(
        add_0_root_add_0_root_add_8_2_n36), .ZN(
        add_0_root_add_0_root_add_8_2_n65) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U51 ( .A1(
        add_0_root_add_0_root_add_8_2_n47), .A2(
        add_0_root_add_0_root_add_8_2_n14), .A3(
        add_0_root_add_0_root_add_8_2_n110), .ZN(
        add_0_root_add_0_root_add_8_2_n38) );
  NOR2_X1 add_0_root_add_0_root_add_8_2_U50 ( .A1(N21), .A2(N10), .ZN(
        add_0_root_add_0_root_add_8_2_n42) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U49 ( .A(
        add_0_root_add_0_root_add_8_2_n42), .Z(
        add_0_root_add_0_root_add_8_2_n36) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U48 ( .A(
        add_0_root_add_0_root_add_8_2_n47), .Z(
        add_0_root_add_0_root_add_8_2_n35) );
  NOR2_X1 add_0_root_add_0_root_add_8_2_U47 ( .A1(N20), .A2(N11), .ZN(
        add_0_root_add_0_root_add_8_2_n33) );
  NOR2_X1 add_0_root_add_0_root_add_8_2_U46 ( .A1(N25), .A2(N6), .ZN(
        add_0_root_add_0_root_add_8_2_n32) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U45 ( .A(
        add_0_root_add_0_root_add_8_2_n49), .Z(
        add_0_root_add_0_root_add_8_2_n31) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U44 ( .A1(
        add_0_root_add_0_root_add_8_2_n34), .A2(N8), .ZN(
        add_0_root_add_0_root_add_8_2_n30) );
  AOI21_X1 add_0_root_add_0_root_add_8_2_U43 ( .B1(
        add_0_root_add_0_root_add_8_2_n9), .B2(
        add_0_root_add_0_root_add_8_2_n137), .A(
        add_0_root_add_0_root_add_8_2_n7), .ZN(
        add_0_root_add_0_root_add_8_2_n28) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U42 ( .A1(
        add_0_root_add_0_root_add_8_2_n99), .A2(
        add_0_root_add_0_root_add_8_2_n10), .ZN(
        add_0_root_add_0_root_add_8_2_n97) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U41 ( .A1(N23), .A2(N8), .ZN(
        add_0_root_add_0_root_add_8_2_n27) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U40 ( .A1(
        add_0_root_add_0_root_add_8_2_n118), .A2(
        add_0_root_add_0_root_add_8_2_n124), .ZN(
        add_0_root_add_0_root_add_8_2_n113) );
  BUF_X1 add_0_root_add_0_root_add_8_2_U39 ( .A(
        add_0_root_add_0_root_add_8_2_n80), .Z(
        add_0_root_add_0_root_add_8_2_n37) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U38 ( .A(
        add_0_root_add_0_root_add_8_2_n77), .Z(
        add_0_root_add_0_root_add_8_2_n26) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U37 ( .A1(
        add_0_root_add_0_root_add_8_2_n28), .A2(
        add_0_root_add_0_root_add_8_2_n127), .A3(
        add_0_root_add_0_root_add_8_2_n54), .ZN(
        add_0_root_add_0_root_add_8_2_n40) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U36 ( .A1(
        add_0_root_add_0_root_add_8_2_n46), .A2(
        add_0_root_add_0_root_add_8_2_n108), .ZN(
        add_0_root_add_0_root_add_8_2_n49) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U35 ( .A1(
        add_0_root_add_0_root_add_8_2_n51), .A2(
        add_0_root_add_0_root_add_8_2_n55), .ZN(
        add_0_root_add_0_root_add_8_2_n109) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U34 ( .A1(
        add_0_root_add_0_root_add_8_2_n100), .A2(
        add_0_root_add_0_root_add_8_2_n101), .ZN(
        add_0_root_add_0_root_add_8_2_n25) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U33 ( .A(N30), .Z(
        add_0_root_add_0_root_add_8_2_n24) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U32 ( .A(
        add_0_root_add_0_root_add_8_2_n54), .Z(
        add_0_root_add_0_root_add_8_2_n23) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U31 ( .A(N20), .Z(
        add_0_root_add_0_root_add_8_2_n22) );
  NAND3_X1 add_0_root_add_0_root_add_8_2_U30 ( .A1(
        add_0_root_add_0_root_add_8_2_n6), .A2(
        add_0_root_add_0_root_add_8_2_n68), .A3(
        add_0_root_add_0_root_add_8_2_n128), .ZN(
        add_0_root_add_0_root_add_8_2_n21) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U29 ( .A1(N24), .A2(N7), .ZN(
        add_0_root_add_0_root_add_8_2_n20) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U28 ( .A1(
        add_0_root_add_0_root_add_8_2_n131), .A2(
        add_0_root_add_0_root_add_8_2_n130), .ZN(
        add_0_root_add_0_root_add_8_2_n19) );
  BUF_X1 add_0_root_add_0_root_add_8_2_U27 ( .A(N23), .Z(
        add_0_root_add_0_root_add_8_2_n34) );
  OAI211_X1 add_0_root_add_0_root_add_8_2_U26 ( .C1(
        add_0_root_add_0_root_add_8_2_n32), .C2(
        add_0_root_add_0_root_add_8_2_n54), .A(
        add_0_root_add_0_root_add_8_2_n52), .B(
        add_0_root_add_0_root_add_8_2_n117), .ZN(
        add_0_root_add_0_root_add_8_2_n18) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U25 ( .A(
        add_0_root_add_0_root_add_8_2_n27), .Z(
        add_0_root_add_0_root_add_8_2_n17) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U24 ( .A(
        add_0_root_add_0_root_add_8_2_n52), .Z(
        add_0_root_add_0_root_add_8_2_n16) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U23 ( .A(N15), .Z(
        add_0_root_add_0_root_add_8_2_n15) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U22 ( .A1(
        add_0_root_add_0_root_add_8_2_n51), .A2(
        add_0_root_add_0_root_add_8_2_n55), .ZN(
        add_0_root_add_0_root_add_8_2_n14) );
  NAND2_X1 add_0_root_add_0_root_add_8_2_U21 ( .A1(
        add_0_root_add_0_root_add_8_2_n17), .A2(
        add_0_root_add_0_root_add_8_2_n58), .ZN(
        add_0_root_add_0_root_add_8_2_n13) );
  XNOR2_X1 add_0_root_add_0_root_add_8_2_U20 ( .A(
        add_0_root_add_0_root_add_8_2_n56), .B(
        add_0_root_add_0_root_add_8_2_n13), .ZN(result[7]) );
  NOR2_X1 add_0_root_add_0_root_add_8_2_U19 ( .A1(n83), .A2(N14), .ZN(
        add_0_root_add_0_root_add_8_2_n12) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U18 ( .A(
        add_0_root_add_0_root_add_8_2_n85), .Z(
        add_0_root_add_0_root_add_8_2_n11) );
  AND3_X1 add_0_root_add_0_root_add_8_2_U17 ( .A1(
        add_0_root_add_0_root_add_8_2_n95), .A2(
        add_0_root_add_0_root_add_8_2_n96), .A3(
        add_0_root_add_0_root_add_8_2_n94), .ZN(
        add_0_root_add_0_root_add_8_2_n10) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U16 ( .A1(
        add_0_root_add_0_root_add_8_2_n22), .A2(N11), .ZN(
        add_0_root_add_0_root_add_8_2_n69) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U15 ( .A1(
        add_0_root_add_0_root_add_8_2_n27), .A2(
        add_0_root_add_0_root_add_8_2_n8), .ZN(
        add_0_root_add_0_root_add_8_2_n9) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U14 ( .A1(N22), .A2(N9), .ZN(
        add_0_root_add_0_root_add_8_2_n61) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U13 ( .A1(N22), .A2(N9), .ZN(
        add_0_root_add_0_root_add_8_2_n8) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U12 ( .A1(
        add_0_root_add_0_root_add_8_2_n34), .A2(N8), .ZN(
        add_0_root_add_0_root_add_8_2_n7) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U11 ( .A1(
        add_0_root_add_0_root_add_8_2_n57), .A2(
        add_0_root_add_0_root_add_8_2_n61), .ZN(
        add_0_root_add_0_root_add_8_2_n6) );
  BUF_X1 add_0_root_add_0_root_add_8_2_U10 ( .A(
        add_0_root_add_0_root_add_8_2_n67), .Z(
        add_0_root_add_0_root_add_8_2_n5) );
  AND2_X1 add_0_root_add_0_root_add_8_2_U9 ( .A1(
        add_0_root_add_0_root_add_8_2_n66), .A2(
        add_0_root_add_0_root_add_8_2_n5), .ZN(
        add_0_root_add_0_root_add_8_2_n4) );
  BUF_X1 add_0_root_add_0_root_add_8_2_U8 ( .A(
        add_0_root_add_0_root_add_8_2_n55), .Z(
        add_0_root_add_0_root_add_8_2_n3) );
  INV_X1 add_0_root_add_0_root_add_8_2_U7 ( .A(
        add_0_root_add_0_root_add_8_2_n33), .ZN(
        add_0_root_add_0_root_add_8_2_n2) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U6 ( .A(
        add_0_root_add_0_root_add_8_2_n50), .Z(
        add_0_root_add_0_root_add_8_2_n39) );
  CLKBUF_X1 add_0_root_add_0_root_add_8_2_U5 ( .A(
        add_0_root_add_0_root_add_8_2_n121), .Z(
        add_0_root_add_0_root_add_8_2_n29) );
  OR2_X2 add_0_root_add_0_root_add_8_2_U4 ( .A1(N27), .A2(N4), .ZN(
        add_0_root_add_0_root_add_8_2_n118) );
  OR2_X1 add_0_root_add_0_root_add_8_2_U3 ( .A1(N25), .A2(N6), .ZN(
        add_0_root_add_0_root_add_8_2_n51) );
  BUF_X1 add_0_root_add_0_root_add_8_2_U2 ( .A(
        add_0_root_add_0_root_add_8_2_n51), .Z(
        add_0_root_add_0_root_add_8_2_n1) );
endmodule

