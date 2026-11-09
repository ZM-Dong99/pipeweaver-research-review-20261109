/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 03:08:03 2025
/////////////////////////////////////////////////////////////


module mux_4to1_16bit_ref ( data0, data1, data2, data3, sel, out );
  input [15:0] data0;
  input [15:0] data1;
  input [15:0] data2;
  input [15:0] data3;
  input [1:0] sel;
  output [15:0] out;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51;

  AND2_X1 U1 ( .A1(sel[0]), .A2(n12), .ZN(n1) );
  AND2_X1 U2 ( .A1(sel[0]), .A2(n12), .ZN(n2) );
  NOR2_X2 U3 ( .A1(sel[0]), .A2(sel[1]), .ZN(n3) );
  AND2_X1 U4 ( .A1(n7), .A2(sel[1]), .ZN(n4) );
  AND2_X1 U5 ( .A1(n7), .A2(sel[1]), .ZN(n5) );
  AND2_X2 U6 ( .A1(n51), .A2(sel[1]), .ZN(n6) );
  INV_X1 U7 ( .A(sel[0]), .ZN(n7) );
  INV_X1 U8 ( .A(n48), .ZN(n8) );
  NOR2_X2 U9 ( .A1(sel[0]), .A2(sel[1]), .ZN(n10) );
  AND2_X1 U10 ( .A1(n7), .A2(sel[1]), .ZN(n9) );
  AND2_X2 U11 ( .A1(sel[0]), .A2(n49), .ZN(n11) );
  INV_X1 U12 ( .A(sel[1]), .ZN(n12) );
  AND2_X2 U13 ( .A1(n51), .A2(sel[1]), .ZN(n13) );
  AND2_X2 U14 ( .A1(sel[0]), .A2(sel[1]), .ZN(n14) );
  NAND2_X1 U15 ( .A1(n16), .A2(n15), .ZN(out[0]) );
  AOI22_X1 U16 ( .A1(data3[0]), .A2(n14), .B1(data2[0]), .B2(n5), .ZN(n16) );
  AOI22_X1 U17 ( .A1(data1[0]), .A2(n11), .B1(n50), .B2(data0[0]), .ZN(n15) );
  NAND2_X1 U18 ( .A1(n19), .A2(n18), .ZN(out[1]) );
  AOI22_X1 U19 ( .A1(data3[1]), .A2(n14), .B1(data2[1]), .B2(n13), .ZN(n19) );
  AOI22_X1 U20 ( .A1(data1[1]), .A2(n11), .B1(n3), .B2(data0[1]), .ZN(n18) );
  NAND2_X1 U21 ( .A1(n21), .A2(n20), .ZN(out[2]) );
  AOI22_X1 U22 ( .A1(data3[2]), .A2(n14), .B1(data2[2]), .B2(n9), .ZN(n21) );
  AOI22_X1 U23 ( .A1(data1[2]), .A2(n2), .B1(n3), .B2(data0[2]), .ZN(n20) );
  NAND2_X1 U24 ( .A1(n23), .A2(n22), .ZN(out[3]) );
  AOI22_X1 U25 ( .A1(data3[3]), .A2(n14), .B1(data2[3]), .B2(n13), .ZN(n23) );
  AOI22_X1 U26 ( .A1(data1[3]), .A2(n11), .B1(data0[3]), .B2(n10), .ZN(n22) );
  NAND2_X1 U27 ( .A1(n25), .A2(n24), .ZN(out[4]) );
  AOI22_X1 U28 ( .A1(data3[4]), .A2(n14), .B1(data2[4]), .B2(n5), .ZN(n25) );
  AOI22_X1 U29 ( .A1(data1[4]), .A2(n1), .B1(data0[4]), .B2(n10), .ZN(n24) );
  NAND2_X1 U30 ( .A1(n27), .A2(n26), .ZN(out[5]) );
  AOI22_X1 U31 ( .A1(data3[5]), .A2(n14), .B1(data2[5]), .B2(n9), .ZN(n27) );
  AOI22_X1 U32 ( .A1(data1[5]), .A2(n11), .B1(n17), .B2(data0[5]), .ZN(n26) );
  NAND2_X1 U33 ( .A1(n29), .A2(n28), .ZN(out[6]) );
  AOI22_X1 U34 ( .A1(data3[6]), .A2(n14), .B1(data2[6]), .B2(n4), .ZN(n29) );
  AOI22_X1 U35 ( .A1(data1[6]), .A2(n1), .B1(data0[6]), .B2(n10), .ZN(n28) );
  NAND2_X1 U36 ( .A1(n31), .A2(n30), .ZN(out[7]) );
  AOI22_X1 U37 ( .A1(data3[7]), .A2(n14), .B1(data2[7]), .B2(n6), .ZN(n31) );
  AOI22_X1 U38 ( .A1(data1[7]), .A2(n11), .B1(data0[7]), .B2(n10), .ZN(n30) );
  NAND2_X1 U39 ( .A1(n33), .A2(n32), .ZN(out[8]) );
  AOI22_X1 U40 ( .A1(data3[8]), .A2(n14), .B1(data2[8]), .B2(n4), .ZN(n33) );
  AOI22_X1 U41 ( .A1(data1[8]), .A2(n2), .B1(data0[8]), .B2(n10), .ZN(n32) );
  NAND2_X1 U42 ( .A1(n35), .A2(n34), .ZN(out[9]) );
  AOI22_X1 U43 ( .A1(data3[9]), .A2(n14), .B1(data2[9]), .B2(n6), .ZN(n35) );
  AOI22_X1 U44 ( .A1(data1[9]), .A2(n1), .B1(data0[9]), .B2(n10), .ZN(n34) );
  NAND2_X1 U45 ( .A1(n37), .A2(n36), .ZN(out[10]) );
  AOI22_X1 U46 ( .A1(data3[10]), .A2(n14), .B1(data2[10]), .B2(n13), .ZN(n37)
         );
  AOI22_X1 U47 ( .A1(data1[10]), .A2(n11), .B1(n3), .B2(data0[10]), .ZN(n36)
         );
  NAND2_X1 U48 ( .A1(n39), .A2(n38), .ZN(out[11]) );
  AOI22_X1 U49 ( .A1(data3[11]), .A2(n14), .B1(data2[11]), .B2(n6), .ZN(n39)
         );
  AOI22_X1 U50 ( .A1(data1[11]), .A2(n11), .B1(n50), .B2(data0[11]), .ZN(n38)
         );
  NAND2_X1 U51 ( .A1(n41), .A2(n40), .ZN(out[12]) );
  AOI22_X1 U52 ( .A1(data3[12]), .A2(n14), .B1(data2[12]), .B2(n13), .ZN(n41)
         );
  AOI22_X1 U53 ( .A1(data1[12]), .A2(n11), .B1(data0[12]), .B2(n10), .ZN(n40)
         );
  NAND2_X1 U54 ( .A1(n43), .A2(n42), .ZN(out[13]) );
  AOI22_X1 U55 ( .A1(data3[13]), .A2(n14), .B1(data2[13]), .B2(n6), .ZN(n43)
         );
  AOI22_X1 U56 ( .A1(data1[13]), .A2(n11), .B1(n17), .B2(data0[13]), .ZN(n42)
         );
  NAND2_X1 U57 ( .A1(n45), .A2(n44), .ZN(out[14]) );
  AOI22_X1 U58 ( .A1(data3[14]), .A2(n14), .B1(data2[14]), .B2(n13), .ZN(n45)
         );
  AOI22_X1 U59 ( .A1(data1[14]), .A2(n11), .B1(n3), .B2(data0[14]), .ZN(n44)
         );
  NAND2_X1 U60 ( .A1(n47), .A2(n46), .ZN(out[15]) );
  AOI22_X1 U61 ( .A1(data3[15]), .A2(n14), .B1(n6), .B2(data2[15]), .ZN(n47)
         );
  AOI22_X1 U62 ( .A1(data1[15]), .A2(n11), .B1(data0[15]), .B2(n8), .ZN(n46)
         );
  INV_X1 U63 ( .A(sel[1]), .ZN(n49) );
  INV_X1 U64 ( .A(n48), .ZN(n17) );
  INV_X1 U65 ( .A(n48), .ZN(n50) );
  INV_X1 U66 ( .A(sel[0]), .ZN(n51) );
  OR2_X2 U67 ( .A1(sel[0]), .A2(sel[1]), .ZN(n48) );
endmodule

