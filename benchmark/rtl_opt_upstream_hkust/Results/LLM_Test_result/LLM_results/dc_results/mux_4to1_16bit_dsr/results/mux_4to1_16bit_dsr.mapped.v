/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:39:42 2025
/////////////////////////////////////////////////////////////


module mux_4to1_16bit_dsr ( data0, data1, data2, data3, sel, out );
  input [15:0] data0;
  input [15:0] data1;
  input [15:0] data2;
  input [15:0] data3;
  input [1:0] sel;
  output [15:0] out;
  wire   n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51,
         n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93,
         n94;

  AND2_X2 U54 ( .A1(n40), .A2(sel[0]), .ZN(n42) );
  AND2_X2 U55 ( .A1(n49), .A2(sel[0]), .ZN(n51) );
  AND2_X2 U56 ( .A1(sel[0]), .A2(sel[1]), .ZN(n54) );
  AND2_X2 U57 ( .A1(n41), .A2(sel[0]), .ZN(n43) );
  AOI22_X1 U58 ( .A1(data1[11]), .A2(n42), .B1(n58), .B2(data0[11]), .ZN(n84)
         );
  OR2_X2 U59 ( .A1(sel[0]), .A2(sel[1]), .ZN(n38) );
  INV_X1 U60 ( .A(sel[0]), .ZN(n39) );
  INV_X1 U61 ( .A(sel[1]), .ZN(n40) );
  INV_X1 U62 ( .A(sel[1]), .ZN(n41) );
  INV_X1 U63 ( .A(n60), .ZN(n44) );
  INV_X1 U64 ( .A(n50), .ZN(n45) );
  INV_X1 U65 ( .A(n50), .ZN(n46) );
  INV_X1 U66 ( .A(n60), .ZN(n47) );
  AND2_X2 U67 ( .A1(sel[0]), .A2(sel[1]), .ZN(n48) );
  INV_X1 U68 ( .A(sel[1]), .ZN(n49) );
  OR2_X2 U69 ( .A1(sel[0]), .A2(sel[1]), .ZN(n50) );
  AND2_X2 U70 ( .A1(n61), .A2(sel[0]), .ZN(n52) );
  AND2_X2 U71 ( .A1(n39), .A2(sel[1]), .ZN(n53) );
  AND2_X2 U72 ( .A1(n59), .A2(sel[1]), .ZN(n57) );
  OR2_X2 U73 ( .A1(sel[0]), .A2(sel[1]), .ZN(n60) );
  INV_X1 U74 ( .A(n50), .ZN(n55) );
  INV_X1 U75 ( .A(n60), .ZN(n56) );
  INV_X1 U76 ( .A(n38), .ZN(n92) );
  INV_X1 U77 ( .A(n38), .ZN(n58) );
  INV_X1 U78 ( .A(sel[0]), .ZN(n59) );
  AOI22_X1 U79 ( .A1(n57), .A2(data2[0]), .B1(data3[0]), .B2(n48), .ZN(n63) );
  INV_X1 U80 ( .A(sel[1]), .ZN(n61) );
  AOI22_X1 U81 ( .A1(n55), .A2(data0[0]), .B1(data1[0]), .B2(n51), .ZN(n62) );
  NAND2_X1 U82 ( .A1(n62), .A2(n63), .ZN(out[0]) );
  AOI22_X1 U83 ( .A1(n53), .A2(data2[1]), .B1(data3[1]), .B2(n48), .ZN(n65) );
  AOI22_X1 U84 ( .A1(data0[1]), .A2(n92), .B1(data1[1]), .B2(n52), .ZN(n64) );
  NAND2_X1 U85 ( .A1(n65), .A2(n64), .ZN(out[1]) );
  AOI22_X1 U86 ( .A1(n57), .A2(data2[2]), .B1(data3[2]), .B2(n54), .ZN(n67) );
  AOI22_X1 U87 ( .A1(n44), .A2(data0[2]), .B1(data1[2]), .B2(n42), .ZN(n66) );
  NAND2_X1 U88 ( .A1(n66), .A2(n67), .ZN(out[2]) );
  AOI22_X1 U89 ( .A1(n53), .A2(data2[3]), .B1(data3[3]), .B2(n54), .ZN(n69) );
  AOI22_X1 U90 ( .A1(n45), .A2(data0[3]), .B1(data1[3]), .B2(n43), .ZN(n68) );
  NAND2_X1 U91 ( .A1(n68), .A2(n69), .ZN(out[3]) );
  AOI22_X1 U92 ( .A1(n57), .A2(data2[4]), .B1(data3[4]), .B2(n48), .ZN(n71) );
  AOI22_X1 U93 ( .A1(n58), .A2(data0[4]), .B1(n43), .B2(data1[4]), .ZN(n70) );
  NAND2_X1 U94 ( .A1(n71), .A2(n70), .ZN(out[4]) );
  AOI22_X1 U95 ( .A1(n53), .A2(data2[5]), .B1(data3[5]), .B2(n48), .ZN(n73) );
  AOI22_X1 U96 ( .A1(n45), .A2(data0[5]), .B1(data1[5]), .B2(n52), .ZN(n72) );
  NAND2_X1 U97 ( .A1(n72), .A2(n73), .ZN(out[5]) );
  AOI22_X1 U98 ( .A1(n57), .A2(data2[6]), .B1(data3[6]), .B2(n54), .ZN(n75) );
  AOI22_X1 U99 ( .A1(n56), .A2(data0[6]), .B1(data1[6]), .B2(n51), .ZN(n74) );
  NAND2_X1 U100 ( .A1(n74), .A2(n75), .ZN(out[6]) );
  AOI22_X1 U101 ( .A1(n53), .A2(data2[7]), .B1(data3[7]), .B2(n54), .ZN(n77)
         );
  AOI22_X1 U102 ( .A1(n47), .A2(data0[7]), .B1(data1[7]), .B2(n51), .ZN(n76)
         );
  NAND2_X1 U103 ( .A1(n76), .A2(n77), .ZN(out[7]) );
  AOI22_X1 U104 ( .A1(n57), .A2(data2[8]), .B1(data3[8]), .B2(n48), .ZN(n79)
         );
  AOI22_X1 U105 ( .A1(data0[8]), .A2(n92), .B1(n51), .B2(data1[8]), .ZN(n78)
         );
  NAND2_X1 U106 ( .A1(n79), .A2(n78), .ZN(out[8]) );
  AOI22_X1 U107 ( .A1(n53), .A2(data2[9]), .B1(data3[9]), .B2(n48), .ZN(n81)
         );
  AOI22_X1 U108 ( .A1(n46), .A2(data0[9]), .B1(data1[9]), .B2(n42), .ZN(n80)
         );
  NAND2_X1 U109 ( .A1(n80), .A2(n81), .ZN(out[9]) );
  AOI22_X1 U110 ( .A1(n57), .A2(data2[10]), .B1(data3[10]), .B2(n54), .ZN(n83)
         );
  AOI22_X1 U111 ( .A1(n44), .A2(data0[10]), .B1(data1[10]), .B2(n42), .ZN(n82)
         );
  NAND2_X1 U112 ( .A1(n82), .A2(n83), .ZN(out[10]) );
  AOI22_X1 U113 ( .A1(n53), .A2(data2[11]), .B1(data3[11]), .B2(n54), .ZN(n85)
         );
  NAND2_X1 U114 ( .A1(n84), .A2(n85), .ZN(out[11]) );
  AOI22_X1 U115 ( .A1(n57), .A2(data2[12]), .B1(data3[12]), .B2(n48), .ZN(n87)
         );
  AOI22_X1 U116 ( .A1(n56), .A2(data0[12]), .B1(data1[12]), .B2(n43), .ZN(n86)
         );
  NAND2_X1 U117 ( .A1(n86), .A2(n87), .ZN(out[12]) );
  AOI22_X1 U118 ( .A1(n53), .A2(data2[13]), .B1(data3[13]), .B2(n48), .ZN(n89)
         );
  AOI22_X1 U119 ( .A1(data0[13]), .A2(n55), .B1(data1[13]), .B2(n52), .ZN(n88)
         );
  NAND2_X1 U120 ( .A1(n88), .A2(n89), .ZN(out[13]) );
  AOI22_X1 U121 ( .A1(n57), .A2(data2[14]), .B1(data3[14]), .B2(n54), .ZN(n91)
         );
  AOI22_X1 U122 ( .A1(n46), .A2(data0[14]), .B1(data1[14]), .B2(n43), .ZN(n90)
         );
  NAND2_X1 U123 ( .A1(n90), .A2(n91), .ZN(out[14]) );
  AOI22_X1 U124 ( .A1(n53), .A2(data2[15]), .B1(data3[15]), .B2(n54), .ZN(n94)
         );
  AOI22_X1 U125 ( .A1(n47), .A2(data0[15]), .B1(data1[15]), .B2(n52), .ZN(n93)
         );
  NAND2_X1 U126 ( .A1(n93), .A2(n94), .ZN(out[15]) );
endmodule

