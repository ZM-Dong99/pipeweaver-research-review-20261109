/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:28:54 2025
/////////////////////////////////////////////////////////////


module comparator_8bit_gpt ( A, B, eq, gt, lt );
  input [7:0] A;
  input [7:0] B;
  output eq, gt, lt;
  wire   diff_6_, diff_5_, diff_4_, diff_3_, diff_2_, diff_1_, diff_0_, n8, n9,
         n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23,
         sub_5_n82, sub_5_n81, sub_5_n80, sub_5_n79, sub_5_n78, sub_5_n77,
         sub_5_n76, sub_5_n75, sub_5_n74, sub_5_n73, sub_5_n72, sub_5_n71,
         sub_5_n70, sub_5_n69, sub_5_n68, sub_5_n67, sub_5_n66, sub_5_n65,
         sub_5_n64, sub_5_n63, sub_5_n62, sub_5_n61, sub_5_n60, sub_5_n59,
         sub_5_n58, sub_5_n57, sub_5_n56, sub_5_n55, sub_5_n54, sub_5_n53,
         sub_5_n52, sub_5_n51, sub_5_n50, sub_5_n49, sub_5_n48, sub_5_n47,
         sub_5_n46, sub_5_n45, sub_5_n44, sub_5_n43, sub_5_n42, sub_5_n41,
         sub_5_n40, sub_5_n39, sub_5_n38, sub_5_n37, sub_5_n36, sub_5_n35,
         sub_5_n34, sub_5_n33, sub_5_n32, sub_5_n31, sub_5_n30, sub_5_n29,
         sub_5_n28, sub_5_n27, sub_5_n26, sub_5_n25, sub_5_n24, sub_5_n23,
         sub_5_n22, sub_5_n21, sub_5_n20, sub_5_n19, sub_5_n18, sub_5_n17,
         sub_5_n16, sub_5_n15, sub_5_n14, sub_5_n13, sub_5_n12, sub_5_n11,
         sub_5_n10, sub_5_n9, sub_5_n8, sub_5_n7, sub_5_n6, sub_5_n5, sub_5_n4,
         sub_5_n3, sub_5_n2, sub_5_n1;

  AOI21_X1 U8 ( .B1(n9), .B2(n8), .A(lt), .ZN(gt) );
  AND3_X1 U9 ( .A1(n12), .A2(n11), .A3(n10), .ZN(n8) );
  NOR2_X1 U10 ( .A1(diff_5_), .A2(diff_6_), .ZN(n9) );
  INV_X1 U11 ( .A(diff_3_), .ZN(n10) );
  NOR2_X1 U12 ( .A1(diff_0_), .A2(diff_4_), .ZN(n11) );
  NOR2_X1 U13 ( .A1(diff_1_), .A2(diff_2_), .ZN(n12) );
  XNOR2_X1 U14 ( .A(A[3]), .B(B[3]), .ZN(n18) );
  XNOR2_X1 U15 ( .A(A[0]), .B(B[0]), .ZN(n20) );
  XNOR2_X1 U16 ( .A(A[4]), .B(B[4]), .ZN(n19) );
  XNOR2_X1 U17 ( .A(A[1]), .B(B[1]), .ZN(n21) );
  XNOR2_X1 U18 ( .A(A[2]), .B(B[2]), .ZN(n15) );
  XNOR2_X1 U19 ( .A(A[7]), .B(B[7]), .ZN(n14) );
  XNOR2_X1 U20 ( .A(A[5]), .B(B[5]), .ZN(n16) );
  INV_X1 U21 ( .A(A[6]), .ZN(n13) );
  XOR2_X1 U22 ( .A(n13), .B(B[6]), .Z(n17) );
  NAND4_X1 U23 ( .A1(n17), .A2(n16), .A3(n15), .A4(n14), .ZN(n23) );
  NAND4_X1 U24 ( .A1(n21), .A2(n20), .A3(n19), .A4(n18), .ZN(n22) );
  NOR2_X1 U25 ( .A1(n23), .A2(n22), .ZN(eq) );
  NAND2_X1 sub_5_U92 ( .A1(sub_5_n72), .A2(sub_5_n71), .ZN(sub_5_n76) );
  INV_X1 sub_5_U91 ( .A(sub_5_n70), .ZN(sub_5_n77) );
  INV_X1 sub_5_U90 ( .A(sub_5_n72), .ZN(sub_5_n68) );
  XNOR2_X1 sub_5_U89 ( .A(sub_5_n62), .B(sub_5_n63), .ZN(diff_3_) );
  NOR2_X1 sub_5_U88 ( .A1(sub_5_n10), .A2(sub_5_n3), .ZN(sub_5_n44) );
  NAND3_X1 sub_5_U87 ( .A1(sub_5_n47), .A2(sub_5_n12), .A3(sub_5_n44), .ZN(
        sub_5_n42) );
  INV_X1 sub_5_U86 ( .A(sub_5_n28), .ZN(sub_5_n30) );
  INV_X1 sub_5_U85 ( .A(sub_5_n21), .ZN(sub_5_n26) );
  NAND3_X1 sub_5_U84 ( .A1(sub_5_n8), .A2(sub_5_n1), .A3(sub_5_n19), .ZN(
        sub_5_n18) );
  NAND3_X1 sub_5_U83 ( .A1(sub_5_n18), .A2(sub_5_n17), .A3(sub_5_n16), .ZN(
        sub_5_n15) );
  NAND2_X1 sub_5_U82 ( .A1(sub_5_n20), .A2(sub_5_n29), .ZN(sub_5_n37) );
  NAND2_X1 sub_5_U81 ( .A1(sub_5_n20), .A2(sub_5_n1), .ZN(sub_5_n27) );
  NOR2_X1 sub_5_U80 ( .A1(sub_5_n55), .A2(sub_5_n56), .ZN(sub_5_n48) );
  OAI21_X1 sub_5_U79 ( .B1(sub_5_n57), .B2(sub_5_n58), .A(sub_5_n59), .ZN(
        sub_5_n56) );
  NOR2_X1 sub_5_U78 ( .A1(sub_5_n13), .A2(B[1]), .ZN(sub_5_n58) );
  NAND2_X1 sub_5_U77 ( .A1(sub_5_n43), .A2(sub_5_n47), .ZN(sub_5_n55) );
  NAND2_X1 sub_5_U76 ( .A1(B[1]), .A2(sub_5_n60), .ZN(sub_5_n46) );
  NAND2_X1 sub_5_U75 ( .A1(B[1]), .A2(sub_5_n14), .ZN(sub_5_n59) );
  NAND2_X1 sub_5_U74 ( .A1(sub_5_n46), .A2(sub_5_n12), .ZN(sub_5_n66) );
  AOI21_X1 sub_5_U73 ( .B1(sub_5_n76), .B2(sub_5_n46), .A(sub_5_n77), .ZN(
        sub_5_n73) );
  NAND2_X1 sub_5_U72 ( .A1(sub_5_n46), .A2(sub_5_n70), .ZN(sub_5_n80) );
  NOR2_X1 sub_5_U71 ( .A1(sub_5_n11), .A2(B[0]), .ZN(sub_5_n57) );
  NOR2_X1 sub_5_U70 ( .A1(sub_5_n48), .A2(sub_5_n49), .ZN(sub_5_n41) );
  NAND2_X1 sub_5_U69 ( .A1(sub_5_n41), .A2(sub_5_n42), .ZN(sub_5_n20) );
  INV_X1 sub_5_U68 ( .A(A[0]), .ZN(sub_5_n61) );
  XNOR2_X1 sub_5_U67 ( .A(sub_5_n8), .B(sub_5_n38), .ZN(diff_4_) );
  INV_X1 sub_5_U66 ( .A(sub_5_n9), .ZN(sub_5_n60) );
  NAND2_X1 sub_5_U65 ( .A1(sub_5_n64), .A2(B[3]), .ZN(sub_5_n47) );
  NAND2_X1 sub_5_U64 ( .A1(sub_5_n51), .A2(sub_5_n47), .ZN(sub_5_n63) );
  NAND2_X1 sub_5_U63 ( .A1(sub_5_n27), .A2(sub_5_n26), .ZN(sub_5_n22) );
  NAND2_X1 sub_5_U62 ( .A1(sub_5_n37), .A2(sub_5_n31), .ZN(sub_5_n33) );
  XNOR2_X1 sub_5_U61 ( .A(sub_5_n33), .B(sub_5_n34), .ZN(diff_5_) );
  INV_X1 sub_5_U60 ( .A(A[2]), .ZN(sub_5_n75) );
  NAND2_X1 sub_5_U59 ( .A1(B[2]), .A2(sub_5_n4), .ZN(sub_5_n43) );
  INV_X1 sub_5_U58 ( .A(A[1]), .ZN(sub_5_n14) );
  INV_X1 sub_5_U57 ( .A(A[1]), .ZN(sub_5_n13) );
  NOR2_X1 sub_5_U56 ( .A1(A[3]), .A2(sub_5_n53), .ZN(sub_5_n52) );
  NAND2_X1 sub_5_U55 ( .A1(A[3]), .A2(sub_5_n53), .ZN(sub_5_n51) );
  AOI21_X1 sub_5_U54 ( .B1(sub_5_n50), .B2(sub_5_n51), .A(sub_5_n52), .ZN(
        sub_5_n49) );
  INV_X1 sub_5_U53 ( .A(A[3]), .ZN(sub_5_n64) );
  NAND2_X1 sub_5_U52 ( .A1(sub_5_n71), .A2(sub_5_n45), .ZN(diff_0_) );
  NAND2_X1 sub_5_U51 ( .A1(B[2]), .A2(sub_5_n75), .ZN(sub_5_n12) );
  XNOR2_X1 sub_5_U50 ( .A(sub_5_n22), .B(sub_5_n23), .ZN(diff_6_) );
  XNOR2_X1 sub_5_U49 ( .A(sub_5_n15), .B(sub_5_n5), .ZN(lt) );
  INV_X1 sub_5_U48 ( .A(A[0]), .ZN(sub_5_n11) );
  AND2_X1 sub_5_U47 ( .A1(B[1]), .A2(sub_5_n14), .ZN(sub_5_n10) );
  NAND2_X1 sub_5_U46 ( .A1(sub_5_n9), .A2(sub_5_n81), .ZN(sub_5_n70) );
  BUF_X1 sub_5_U45 ( .A(A[1]), .Z(sub_5_n9) );
  NAND2_X1 sub_5_U44 ( .A1(sub_5_n7), .A2(sub_5_n42), .ZN(sub_5_n8) );
  NOR2_X1 sub_5_U43 ( .A1(sub_5_n48), .A2(sub_5_n49), .ZN(sub_5_n7) );
  NAND2_X1 sub_5_U42 ( .A1(sub_5_n2), .A2(sub_5_n78), .ZN(sub_5_n71) );
  INV_X1 sub_5_U41 ( .A(B[6]), .ZN(sub_5_n25) );
  NAND2_X1 sub_5_U40 ( .A1(A[6]), .A2(sub_5_n25), .ZN(sub_5_n16) );
  INV_X1 sub_5_U39 ( .A(A[6]), .ZN(sub_5_n24) );
  NAND2_X1 sub_5_U38 ( .A1(B[6]), .A2(sub_5_n24), .ZN(sub_5_n19) );
  NOR2_X1 sub_5_U37 ( .A1(sub_5_n2), .A2(sub_5_n78), .ZN(sub_5_n82) );
  NAND2_X1 sub_5_U36 ( .A1(sub_5_n82), .A2(sub_5_n71), .ZN(sub_5_n79) );
  INV_X1 sub_5_U35 ( .A(B[5]), .ZN(sub_5_n36) );
  NAND2_X1 sub_5_U34 ( .A1(A[5]), .A2(sub_5_n36), .ZN(sub_5_n32) );
  INV_X1 sub_5_U33 ( .A(B[4]), .ZN(sub_5_n40) );
  NAND2_X1 sub_5_U32 ( .A1(A[4]), .A2(sub_5_n40), .ZN(sub_5_n31) );
  NAND2_X1 sub_5_U31 ( .A1(B[2]), .A2(sub_5_n75), .ZN(sub_5_n6) );
  AND2_X1 sub_5_U30 ( .A1(sub_5_n6), .A2(sub_5_n67), .ZN(sub_5_n74) );
  NAND2_X1 sub_5_U29 ( .A1(A[2]), .A2(sub_5_n54), .ZN(sub_5_n67) );
  INV_X1 sub_5_U28 ( .A(A[5]), .ZN(sub_5_n35) );
  NAND2_X1 sub_5_U27 ( .A1(B[5]), .A2(sub_5_n35), .ZN(sub_5_n28) );
  INV_X1 sub_5_U26 ( .A(A[4]), .ZN(sub_5_n39) );
  NAND2_X1 sub_5_U25 ( .A1(B[4]), .A2(sub_5_n39), .ZN(sub_5_n29) );
  NOR2_X1 sub_5_U24 ( .A1(sub_5_n2), .A2(sub_5_n78), .ZN(sub_5_n72) );
  INV_X1 sub_5_U23 ( .A(B[1]), .ZN(sub_5_n81) );
  INV_X1 sub_5_U22 ( .A(B[3]), .ZN(sub_5_n53) );
  INV_X1 sub_5_U21 ( .A(B[2]), .ZN(sub_5_n54) );
  NAND2_X1 sub_5_U20 ( .A1(A[2]), .A2(sub_5_n54), .ZN(sub_5_n50) );
  XOR2_X1 sub_5_U19 ( .A(B[7]), .B(A[7]), .Z(sub_5_n5) );
  INV_X1 sub_5_U18 ( .A(B[0]), .ZN(sub_5_n78) );
  NAND2_X1 sub_5_U17 ( .A1(sub_5_n16), .A2(sub_5_n19), .ZN(sub_5_n23) );
  NAND2_X1 sub_5_U16 ( .A1(sub_5_n21), .A2(sub_5_n19), .ZN(sub_5_n17) );
  OAI21_X1 sub_5_U15 ( .B1(sub_5_n30), .B2(sub_5_n31), .A(sub_5_n32), .ZN(
        sub_5_n21) );
  XNOR2_X1 sub_5_U14 ( .A(sub_5_n73), .B(sub_5_n74), .ZN(diff_2_) );
  XNOR2_X1 sub_5_U13 ( .A(sub_5_n79), .B(sub_5_n80), .ZN(diff_1_) );
  NAND2_X1 sub_5_U12 ( .A1(sub_5_n31), .A2(sub_5_n29), .ZN(sub_5_n38) );
  NAND2_X1 sub_5_U11 ( .A1(sub_5_n70), .A2(sub_5_n71), .ZN(sub_5_n69) );
  NOR2_X1 sub_5_U10 ( .A1(sub_5_n68), .A2(sub_5_n69), .ZN(sub_5_n65) );
  OAI21_X1 sub_5_U9 ( .B1(sub_5_n65), .B2(sub_5_n66), .A(sub_5_n67), .ZN(
        sub_5_n62) );
  NAND2_X1 sub_5_U8 ( .A1(sub_5_n32), .A2(sub_5_n28), .ZN(sub_5_n34) );
  INV_X1 sub_5_U7 ( .A(A[2]), .ZN(sub_5_n4) );
  BUF_X1 sub_5_U6 ( .A(A[0]), .Z(sub_5_n2) );
  AND2_X1 sub_5_U5 ( .A1(sub_5_n28), .A2(sub_5_n29), .ZN(sub_5_n1) );
  INV_X1 sub_5_U4 ( .A(sub_5_n3), .ZN(sub_5_n45) );
  AND2_X1 sub_5_U3 ( .A1(B[0]), .A2(sub_5_n61), .ZN(sub_5_n3) );
endmodule

