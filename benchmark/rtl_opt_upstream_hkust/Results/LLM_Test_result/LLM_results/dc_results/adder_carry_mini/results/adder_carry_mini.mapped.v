/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 15:06:48 2025
/////////////////////////////////////////////////////////////


module adder_carry_mini ( a, b, cin, sum, cout );
  input [7:0] a;
  input [7:0] b;
  output [7:0] sum;
  input cin;
  output cout;
  wire   n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37,
         n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51,
         n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93,
         n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105,
         n106, n107, n108, n109, n110, n111, n112;

  CLKBUF_X1 U33 ( .A(n41), .Z(n25) );
  CLKBUF_X1 U34 ( .A(n81), .Z(n24) );
  XOR2_X1 U35 ( .A(a[1]), .B(b[1]), .Z(n26) );
  XOR2_X1 U36 ( .A(a[1]), .B(b[1]), .Z(n27) );
  AND3_X1 U37 ( .A1(n28), .A2(n34), .A3(n29), .ZN(n87) );
  XNOR2_X1 U38 ( .A(a[1]), .B(b[1]), .ZN(n28) );
  AND2_X1 U39 ( .A1(n72), .A2(n81), .ZN(n29) );
  XOR2_X1 U40 ( .A(a[2]), .B(b[2]), .Z(n54) );
  BUF_X1 U41 ( .A(b[6]), .Z(n30) );
  XNOR2_X1 U42 ( .A(a[6]), .B(n30), .ZN(n31) );
  OAI21_X1 U43 ( .B1(n70), .B2(n69), .A(n26), .ZN(n32) );
  NOR2_X1 U44 ( .A1(n31), .A2(n44), .ZN(n33) );
  AND2_X2 U45 ( .A1(b[2]), .A2(a[2]), .ZN(n53) );
  NAND2_X1 U46 ( .A1(b[3]), .A2(a[3]), .ZN(n34) );
  XNOR2_X1 U47 ( .A(n95), .B(n98), .ZN(sum[5]) );
  CLKBUF_X1 U48 ( .A(n72), .Z(n35) );
  AND2_X1 U49 ( .A1(n72), .A2(n81), .ZN(n36) );
  AND2_X1 U50 ( .A1(n36), .A2(n37), .ZN(n93) );
  AND2_X1 U51 ( .A1(n97), .A2(n34), .ZN(n37) );
  INV_X1 U52 ( .A(n92), .ZN(n38) );
  BUF_X1 U53 ( .A(n54), .Z(n39) );
  AND2_X1 U54 ( .A1(n36), .A2(n34), .ZN(n40) );
  XOR2_X1 U55 ( .A(a[3]), .B(b[3]), .Z(n41) );
  NOR2_X1 U56 ( .A1(n43), .A2(n44), .ZN(n42) );
  XNOR2_X1 U57 ( .A(a[6]), .B(b[6]), .ZN(n43) );
  NOR2_X1 U58 ( .A1(b[5]), .A2(a[5]), .ZN(n44) );
  XNOR2_X1 U59 ( .A(a[4]), .B(b[4]), .ZN(n45) );
  OAI21_X1 U60 ( .B1(b[0]), .B2(a[0]), .A(cin), .ZN(n46) );
  OAI21_X1 U61 ( .B1(b[0]), .B2(a[0]), .A(cin), .ZN(n47) );
  AND2_X1 U62 ( .A1(b[1]), .A2(a[1]), .ZN(n48) );
  XNOR2_X1 U63 ( .A(n91), .B(n45), .ZN(sum[4]) );
  AOI21_X1 U64 ( .B1(n74), .B2(n75), .A(n73), .ZN(n85) );
  NOR2_X1 U65 ( .A1(n53), .A2(n48), .ZN(n75) );
  NAND4_X1 U66 ( .A1(n85), .A2(n84), .A3(n83), .A4(n82), .ZN(sum[3]) );
  NAND2_X1 U67 ( .A1(n53), .A2(n79), .ZN(n83) );
  XOR2_X1 U68 ( .A(n49), .B(n80), .Z(sum[2]) );
  AND2_X1 U69 ( .A1(n32), .A2(n35), .ZN(n49) );
  XNOR2_X1 U70 ( .A(n86), .B(n66), .ZN(sum[1]) );
  XNOR2_X1 U71 ( .A(a[3]), .B(b[3]), .ZN(n79) );
  XNOR2_X1 U72 ( .A(n107), .B(n50), .ZN(sum[6]) );
  XNOR2_X1 U73 ( .A(a[6]), .B(n52), .ZN(n50) );
  XNOR2_X1 U74 ( .A(a[5]), .B(b[5]), .ZN(n98) );
  XNOR2_X1 U75 ( .A(a[7]), .B(b[7]), .ZN(n111) );
  XNOR2_X1 U76 ( .A(b[0]), .B(n51), .ZN(sum[0]) );
  XNOR2_X1 U77 ( .A(cin), .B(a[0]), .ZN(n51) );
  INV_X1 U78 ( .A(n59), .ZN(n52) );
  NOR2_X1 U79 ( .A1(n76), .A2(n35), .ZN(n73) );
  NAND2_X1 U80 ( .A1(n78), .A2(n77), .ZN(n84) );
  NOR2_X1 U81 ( .A1(n78), .A2(n79), .ZN(n74) );
  INV_X1 U82 ( .A(n39), .ZN(n80) );
  AND2_X1 U83 ( .A1(n110), .A2(n65), .ZN(n64) );
  XNOR2_X1 U84 ( .A(n112), .B(n111), .ZN(sum[7]) );
  XOR2_X1 U85 ( .A(a[4]), .B(b[4]), .Z(n55) );
  XNOR2_X1 U86 ( .A(a[1]), .B(b[1]), .ZN(n66) );
  INV_X1 U87 ( .A(n100), .ZN(n56) );
  NAND2_X1 U88 ( .A1(b[7]), .A2(a[7]), .ZN(n65) );
  INV_X1 U89 ( .A(a[6]), .ZN(n60) );
  INV_X1 U90 ( .A(n30), .ZN(n59) );
  NAND2_X1 U91 ( .A1(b[5]), .A2(a[5]), .ZN(n96) );
  INV_X1 U92 ( .A(n96), .ZN(n57) );
  NAND2_X1 U93 ( .A1(b[4]), .A2(a[4]), .ZN(n97) );
  INV_X1 U94 ( .A(n97), .ZN(n92) );
  OAI21_X1 U95 ( .B1(n57), .B2(n92), .A(n42), .ZN(n58) );
  OAI21_X1 U96 ( .B1(n60), .B2(n59), .A(n58), .ZN(n108) );
  NAND2_X1 U97 ( .A1(b[0]), .A2(a[0]), .ZN(n68) );
  OAI21_X1 U98 ( .B1(b[0]), .B2(a[0]), .A(cin), .ZN(n67) );
  AOI21_X1 U99 ( .B1(n68), .B2(n67), .A(n66), .ZN(n63) );
  NAND2_X1 U100 ( .A1(b[1]), .A2(a[1]), .ZN(n72) );
  NAND2_X1 U101 ( .A1(b[2]), .A2(a[2]), .ZN(n81) );
  NAND2_X1 U102 ( .A1(b[3]), .A2(a[3]), .ZN(n89) );
  NAND2_X1 U103 ( .A1(n36), .A2(n34), .ZN(n102) );
  INV_X1 U104 ( .A(a[2]), .ZN(n71) );
  INV_X1 U105 ( .A(b[2]), .ZN(n61) );
  NAND3_X1 U106 ( .A1(n71), .A2(n61), .A3(n89), .ZN(n62) );
  OAI211_X1 U107 ( .C1(b[3]), .C2(a[3]), .A(n62), .B(n55), .ZN(n94) );
  INV_X1 U108 ( .A(n94), .ZN(n100) );
  OAI211_X1 U109 ( .C1(n63), .C2(n102), .A(n100), .B(n33), .ZN(n109) );
  AOI22_X1 U110 ( .A1(n111), .A2(n65), .B1(n64), .B2(n109), .ZN(cout) );
  NAND2_X1 U111 ( .A1(n68), .A2(n47), .ZN(n86) );
  INV_X1 U112 ( .A(n46), .ZN(n70) );
  INV_X1 U113 ( .A(n68), .ZN(n69) );
  OAI21_X1 U114 ( .B1(n70), .B2(n69), .A(n27), .ZN(n103) );
  INV_X1 U115 ( .A(n103), .ZN(n78) );
  NAND2_X1 U116 ( .A1(n39), .A2(n79), .ZN(n76) );
  INV_X1 U117 ( .A(n76), .ZN(n77) );
  NAND3_X1 U118 ( .A1(n25), .A2(n24), .A3(n80), .ZN(n82) );
  OAI21_X1 U119 ( .B1(n54), .B2(n53), .A(n41), .ZN(n90) );
  INV_X1 U120 ( .A(n86), .ZN(n88) );
  AOI221_X1 U121 ( .B1(n90), .B2(n34), .C1(n88), .C2(n40), .A(n87), .ZN(n91)
         );
  INV_X1 U122 ( .A(n98), .ZN(n99) );
  AOI22_X1 U123 ( .A1(n56), .A2(n38), .B1(n93), .B2(n32), .ZN(n95) );
  OAI21_X1 U124 ( .B1(n98), .B2(n97), .A(n96), .ZN(n101) );
  INV_X1 U125 ( .A(n101), .ZN(n106) );
  NAND2_X1 U126 ( .A1(n100), .A2(n99), .ZN(n105) );
  NOR2_X1 U127 ( .A1(n102), .A2(n101), .ZN(n104) );
  AOI22_X1 U128 ( .A1(n105), .A2(n106), .B1(n104), .B2(n32), .ZN(n107) );
  INV_X1 U129 ( .A(n108), .ZN(n110) );
  NAND2_X1 U130 ( .A1(n109), .A2(n110), .ZN(n112) );
endmodule

