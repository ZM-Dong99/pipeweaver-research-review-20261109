/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:28:59 2025
/////////////////////////////////////////////////////////////


module comparator_16bit_gpt ( A, B, gt, eq, lt );
  input [15:0] A;
  input [15:0] B;
  output gt, eq, lt;
  wire   diff_14_, diff_13_, diff_12_, diff_11_, diff_10_, diff_9_, diff_8_,
         diff_7_, diff_6_, diff_5_, diff_4_, diff_3_, diff_2_, diff_1_,
         diff_0_, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         sub_10_n223, sub_10_n222, sub_10_n221, sub_10_n220, sub_10_n219,
         sub_10_n218, sub_10_n217, sub_10_n216, sub_10_n215, sub_10_n214,
         sub_10_n213, sub_10_n212, sub_10_n211, sub_10_n210, sub_10_n209,
         sub_10_n208, sub_10_n207, sub_10_n206, sub_10_n205, sub_10_n204,
         sub_10_n203, sub_10_n202, sub_10_n201, sub_10_n200, sub_10_n199,
         sub_10_n198, sub_10_n197, sub_10_n196, sub_10_n195, sub_10_n194,
         sub_10_n193, sub_10_n192, sub_10_n191, sub_10_n190, sub_10_n189,
         sub_10_n188, sub_10_n187, sub_10_n186, sub_10_n185, sub_10_n184,
         sub_10_n183, sub_10_n182, sub_10_n181, sub_10_n180, sub_10_n179,
         sub_10_n178, sub_10_n177, sub_10_n176, sub_10_n175, sub_10_n174,
         sub_10_n173, sub_10_n172, sub_10_n171, sub_10_n170, sub_10_n169,
         sub_10_n168, sub_10_n167, sub_10_n166, sub_10_n165, sub_10_n164,
         sub_10_n163, sub_10_n162, sub_10_n161, sub_10_n160, sub_10_n159,
         sub_10_n158, sub_10_n157, sub_10_n156, sub_10_n155, sub_10_n154,
         sub_10_n153, sub_10_n152, sub_10_n151, sub_10_n150, sub_10_n149,
         sub_10_n148, sub_10_n147, sub_10_n146, sub_10_n145, sub_10_n144,
         sub_10_n143, sub_10_n142, sub_10_n141, sub_10_n140, sub_10_n139,
         sub_10_n138, sub_10_n137, sub_10_n136, sub_10_n135, sub_10_n134,
         sub_10_n133, sub_10_n132, sub_10_n131, sub_10_n130, sub_10_n129,
         sub_10_n128, sub_10_n127, sub_10_n126, sub_10_n125, sub_10_n124,
         sub_10_n123, sub_10_n122, sub_10_n121, sub_10_n120, sub_10_n119,
         sub_10_n118, sub_10_n117, sub_10_n116, sub_10_n115, sub_10_n114,
         sub_10_n113, sub_10_n112, sub_10_n111, sub_10_n110, sub_10_n109,
         sub_10_n108, sub_10_n107, sub_10_n106, sub_10_n105, sub_10_n104,
         sub_10_n103, sub_10_n102, sub_10_n101, sub_10_n100, sub_10_n99,
         sub_10_n98, sub_10_n97, sub_10_n96, sub_10_n95, sub_10_n94,
         sub_10_n93, sub_10_n92, sub_10_n91, sub_10_n90, sub_10_n89,
         sub_10_n88, sub_10_n87, sub_10_n86, sub_10_n85, sub_10_n84,
         sub_10_n83, sub_10_n82, sub_10_n81, sub_10_n80, sub_10_n79,
         sub_10_n78, sub_10_n77, sub_10_n76, sub_10_n75, sub_10_n74,
         sub_10_n73, sub_10_n72, sub_10_n71, sub_10_n70, sub_10_n69,
         sub_10_n68, sub_10_n67, sub_10_n66, sub_10_n65, sub_10_n64,
         sub_10_n63, sub_10_n62, sub_10_n61, sub_10_n60, sub_10_n59,
         sub_10_n58, sub_10_n57, sub_10_n56, sub_10_n55, sub_10_n54,
         sub_10_n53, sub_10_n52, sub_10_n51, sub_10_n50, sub_10_n49,
         sub_10_n48, sub_10_n47, sub_10_n46, sub_10_n45, sub_10_n44,
         sub_10_n43, sub_10_n42, sub_10_n41, sub_10_n40, sub_10_n39,
         sub_10_n38, sub_10_n37, sub_10_n36, sub_10_n35, sub_10_n34,
         sub_10_n33, sub_10_n32, sub_10_n31, sub_10_n30, sub_10_n29,
         sub_10_n28, sub_10_n27, sub_10_n26, sub_10_n25, sub_10_n24,
         sub_10_n23, sub_10_n22, sub_10_n21, sub_10_n20, sub_10_n19,
         sub_10_n18, sub_10_n17, sub_10_n16, sub_10_n15, sub_10_n14,
         sub_10_n13, sub_10_n12, sub_10_n11, sub_10_n10, sub_10_n9, sub_10_n8,
         sub_10_n7, sub_10_n6, sub_10_n5, sub_10_n3, sub_10_n2, sub_10_n1;

  NOR2_X1 U13 ( .A1(diff_11_), .A2(diff_10_), .ZN(n11) );
  NOR4_X1 U14 ( .A1(diff_12_), .A2(diff_13_), .A3(diff_9_), .A4(diff_7_), .ZN(
        n12) );
  NOR4_X1 U15 ( .A1(diff_12_), .A2(diff_13_), .A3(diff_9_), .A4(diff_7_), .ZN(
        n17) );
  AND3_X1 U16 ( .A1(n17), .A2(n18), .A3(n14), .ZN(n13) );
  NOR4_X1 U17 ( .A1(n16), .A2(diff_14_), .A3(diff_8_), .A4(diff_6_), .ZN(n14)
         );
  OR3_X2 U18 ( .A1(n15), .A2(diff_5_), .A3(diff_4_), .ZN(n16) );
  OR4_X2 U19 ( .A1(diff_2_), .A2(diff_3_), .A3(diff_1_), .A4(diff_0_), .ZN(n15) );
  NOR4_X1 U20 ( .A1(n16), .A2(diff_14_), .A3(diff_8_), .A4(diff_6_), .ZN(n19)
         );
  NOR2_X1 U21 ( .A1(diff_11_), .A2(diff_10_), .ZN(n18) );
  NAND3_X1 U22 ( .A1(n19), .A2(n11), .A3(n12), .ZN(n20) );
  NOR2_X1 U23 ( .A1(n20), .A2(lt), .ZN(eq) );
  NOR2_X1 U24 ( .A1(n13), .A2(lt), .ZN(gt) );
  NAND2_X2 sub_10_U240 ( .A1(B[8]), .A2(sub_10_n220), .ZN(sub_10_n59) );
  INV_X1 sub_10_U239 ( .A(sub_10_n36), .ZN(sub_10_n184) );
  NAND3_X1 sub_10_U238 ( .A1(sub_10_n35), .A2(sub_10_n59), .A3(sub_10_n50), 
        .ZN(sub_10_n194) );
  NAND4_X2 sub_10_U237 ( .A1(sub_10_n73), .A2(sub_10_n80), .A3(sub_10_n81), 
        .A4(sub_10_n69), .ZN(sub_10_n62) );
  NAND3_X1 sub_10_U236 ( .A1(sub_10_n18), .A2(sub_10_n112), .A3(sub_10_n205), 
        .ZN(sub_10_n89) );
  NAND3_X1 sub_10_U235 ( .A1(sub_10_n193), .A2(sub_10_n194), .A3(sub_10_n195), 
        .ZN(sub_10_n189) );
  NAND3_X1 sub_10_U234 ( .A1(sub_10_n59), .A2(sub_10_n36), .A3(sub_10_n31), 
        .ZN(sub_10_n180) );
  NAND2_X1 sub_10_U233 ( .A1(sub_10_n177), .A2(sub_10_n178), .ZN(sub_10_n173)
         );
  XNOR2_X1 sub_10_U232 ( .A(sub_10_n173), .B(sub_10_n174), .ZN(diff_11_) );
  NAND3_X1 sub_10_U231 ( .A1(sub_10_n43), .A2(sub_10_n2), .A3(sub_10_n60), 
        .ZN(sub_10_n168) );
  NAND2_X2 sub_10_U230 ( .A1(B[12]), .A2(sub_10_n167), .ZN(sub_10_n135) );
  INV_X1 sub_10_U229 ( .A(sub_10_n68), .ZN(sub_10_n139) );
  NAND2_X1 sub_10_U228 ( .A1(sub_10_n2), .A2(sub_10_n135), .ZN(sub_10_n163) );
  NAND3_X1 sub_10_U227 ( .A1(sub_10_n160), .A2(sub_10_n159), .A3(sub_10_n158), 
        .ZN(sub_10_n157) );
  INV_X1 sub_10_U226 ( .A(sub_10_n135), .ZN(sub_10_n153) );
  NAND2_X1 sub_10_U225 ( .A1(sub_10_n43), .A2(sub_10_n152), .ZN(sub_10_n151)
         );
  INV_X1 sub_10_U224 ( .A(sub_10_n125), .ZN(sub_10_n144) );
  NAND3_X1 sub_10_U223 ( .A1(sub_10_n125), .A2(sub_10_n135), .A3(sub_10_n139), 
        .ZN(sub_10_n138) );
  NAND2_X1 sub_10_U222 ( .A1(sub_10_n26), .A2(sub_10_n133), .ZN(sub_10_n132)
         );
  XNOR2_X1 sub_10_U221 ( .A(sub_10_n131), .B(sub_10_n130), .ZN(diff_14_) );
  XNOR2_X1 sub_10_U220 ( .A(sub_10_n100), .B(sub_10_n101), .ZN(diff_3_) );
  NAND3_X1 sub_10_U219 ( .A1(sub_10_n79), .A2(sub_10_n91), .A3(sub_10_n8), 
        .ZN(sub_10_n86) );
  NAND3_X1 sub_10_U218 ( .A1(sub_10_n61), .A2(sub_10_n74), .A3(sub_10_n73), 
        .ZN(sub_10_n72) );
  NAND3_X1 sub_10_U217 ( .A1(sub_10_n61), .A2(sub_10_n60), .A3(sub_10_n59), 
        .ZN(sub_10_n58) );
  NAND2_X1 sub_10_U216 ( .A1(sub_10_n198), .A2(sub_10_n199), .ZN(sub_10_n92)
         );
  NAND4_X1 sub_10_U215 ( .A1(sub_10_n97), .A2(sub_10_n89), .A3(sub_10_n19), 
        .A4(sub_10_n91), .ZN(sub_10_n96) );
  INV_X1 sub_10_U214 ( .A(sub_10_n26), .ZN(sub_10_n66) );
  XNOR2_X1 sub_10_U213 ( .A(sub_10_n43), .B(sub_10_n98), .ZN(diff_4_) );
  NAND4_X1 sub_10_U212 ( .A1(sub_10_n12), .A2(sub_10_n36), .A3(sub_10_n60), 
        .A4(sub_10_n59), .ZN(sub_10_n195) );
  NAND2_X1 sub_10_U211 ( .A1(sub_10_n11), .A2(sub_10_n179), .ZN(sub_10_n178)
         );
  XNOR2_X1 sub_10_U210 ( .A(sub_10_n127), .B(sub_10_n147), .ZN(diff_13_) );
  NAND2_X1 sub_10_U209 ( .A1(sub_10_n105), .A2(sub_10_n117), .ZN(sub_10_n114)
         );
  NAND2_X1 sub_10_U208 ( .A1(A[0]), .A2(sub_10_n51), .ZN(sub_10_n120) );
  NAND2_X1 sub_10_U207 ( .A1(sub_10_n45), .A2(B[1]), .ZN(sub_10_n116) );
  NAND2_X1 sub_10_U206 ( .A1(B[1]), .A2(sub_10_n108), .ZN(sub_10_n105) );
  NAND2_X1 sub_10_U205 ( .A1(sub_10_n105), .A2(sub_10_n115), .ZN(sub_10_n118)
         );
  NAND2_X1 sub_10_U204 ( .A1(sub_10_n88), .A2(sub_10_n89), .ZN(sub_10_n87) );
  AOI21_X1 sub_10_U203 ( .B1(sub_10_n201), .B2(sub_10_n200), .A(sub_10_n202), 
        .ZN(sub_10_n198) );
  OAI211_X1 sub_10_U202 ( .C1(sub_10_n33), .C2(sub_10_n187), .A(sub_10_n71), 
        .B(sub_10_n78), .ZN(sub_10_n209) );
  NAND2_X1 sub_10_U201 ( .A1(sub_10_n151), .A2(sub_10_n150), .ZN(sub_10_n127)
         );
  OAI211_X1 sub_10_U200 ( .C1(sub_10_n66), .C2(sub_10_n62), .A(sub_10_n67), 
        .B(sub_10_n68), .ZN(sub_10_n64) );
  XNOR2_X1 sub_10_U199 ( .A(sub_10_n64), .B(sub_10_n65), .ZN(diff_8_) );
  INV_X1 sub_10_U198 ( .A(B[1]), .ZN(sub_10_n111) );
  NAND2_X1 sub_10_U197 ( .A1(sub_10_n48), .A2(A[1]), .ZN(sub_10_n110) );
  NOR2_X1 sub_10_U196 ( .A1(sub_10_n111), .A2(A[1]), .ZN(sub_10_n202) );
  NAND2_X1 sub_10_U195 ( .A1(A[1]), .A2(sub_10_n49), .ZN(sub_10_n200) );
  NAND2_X1 sub_10_U194 ( .A1(sub_10_n17), .A2(sub_10_n48), .ZN(sub_10_n115) );
  NOR2_X1 sub_10_U193 ( .A1(sub_10_n30), .A2(sub_10_n24), .ZN(sub_10_n77) );
  NOR2_X1 sub_10_U192 ( .A1(sub_10_n21), .A2(sub_10_n30), .ZN(sub_10_n185) );
  NOR2_X1 sub_10_U191 ( .A1(sub_10_n21), .A2(sub_10_n30), .ZN(sub_10_n208) );
  NOR2_X1 sub_10_U190 ( .A1(sub_10_n127), .A2(sub_10_n128), .ZN(sub_10_n122)
         );
  AND2_X1 sub_10_U189 ( .A1(sub_10_n35), .A2(sub_10_n1), .ZN(sub_10_n53) );
  AND3_X1 sub_10_U188 ( .A1(sub_10_n58), .A2(sub_10_n57), .A3(sub_10_n56), 
        .ZN(sub_10_n52) );
  XNOR2_X1 sub_10_U187 ( .A(sub_10_n52), .B(sub_10_n53), .ZN(diff_9_) );
  NAND2_X1 sub_10_U186 ( .A1(sub_10_n44), .A2(B[3]), .ZN(sub_10_n205) );
  INV_X1 sub_10_U185 ( .A(A[2]), .ZN(sub_10_n107) );
  NAND2_X1 sub_10_U184 ( .A1(sub_10_n80), .A2(sub_10_n81), .ZN(sub_10_n75) );
  NAND2_X1 sub_10_U183 ( .A1(sub_10_n80), .A2(sub_10_n78), .ZN(sub_10_n94) );
  NAND2_X1 sub_10_U182 ( .A1(sub_10_n73), .A2(sub_10_n80), .ZN(sub_10_n84) );
  INV_X1 sub_10_U181 ( .A(B[0]), .ZN(sub_10_n51) );
  INV_X1 sub_10_U180 ( .A(A[3]), .ZN(sub_10_n206) );
  NOR3_X1 sub_10_U179 ( .A1(sub_10_n27), .A2(sub_10_n62), .A3(sub_10_n153), 
        .ZN(sub_10_n152) );
  OAI21_X1 sub_10_U178 ( .B1(sub_10_n27), .B2(sub_10_n138), .A(sub_10_n129), 
        .ZN(sub_10_n137) );
  NOR3_X1 sub_10_U177 ( .A1(sub_10_n27), .A2(sub_10_n62), .A3(sub_10_n134), 
        .ZN(sub_10_n133) );
  NAND2_X1 sub_10_U176 ( .A1(sub_10_n96), .A2(sub_10_n73), .ZN(sub_10_n95) );
  NAND2_X1 sub_10_U175 ( .A1(sub_10_n35), .A2(sub_10_n59), .ZN(sub_10_n219) );
  NAND2_X1 sub_10_U174 ( .A1(sub_10_n157), .A2(sub_10_n156), .ZN(sub_10_n142)
         );
  OAI21_X1 sub_10_U173 ( .B1(sub_10_n102), .B2(sub_10_n103), .A(sub_10_n104), 
        .ZN(sub_10_n100) );
  INV_X1 sub_10_U172 ( .A(A[0]), .ZN(sub_10_n119) );
  NAND2_X1 sub_10_U171 ( .A1(B[0]), .A2(sub_10_n46), .ZN(sub_10_n223) );
  INV_X1 sub_10_U170 ( .A(A[1]), .ZN(sub_10_n108) );
  OAI21_X1 sub_10_U169 ( .B1(sub_10_n184), .B2(sub_10_n10), .A(sub_10_n1), 
        .ZN(sub_10_n216) );
  NAND2_X1 sub_10_U168 ( .A1(sub_10_n59), .A2(sub_10_n10), .ZN(sub_10_n65) );
  INV_X1 sub_10_U167 ( .A(B[1]), .ZN(sub_10_n49) );
  INV_X1 sub_10_U166 ( .A(B[1]), .ZN(sub_10_n48) );
  INV_X1 sub_10_U165 ( .A(A[2]), .ZN(sub_10_n47) );
  NAND2_X1 sub_10_U164 ( .A1(sub_10_n142), .A2(sub_10_n143), .ZN(sub_10_n155)
         );
  AOI21_X1 sub_10_U163 ( .B1(sub_10_n142), .B2(sub_10_n143), .A(sub_10_n144), 
        .ZN(sub_10_n136) );
  AND2_X1 sub_10_U162 ( .A1(sub_10_n209), .A2(sub_10_n208), .ZN(sub_10_n50) );
  NOR2_X1 sub_10_U161 ( .A1(sub_10_n139), .A2(sub_10_n50), .ZN(sub_10_n162) );
  NOR2_X1 sub_10_U160 ( .A1(sub_10_n162), .A2(sub_10_n163), .ZN(sub_10_n154)
         );
  NAND4_X1 sub_10_U159 ( .A1(sub_10_n168), .A2(sub_10_n169), .A3(sub_10_n158), 
        .A4(sub_10_n170), .ZN(sub_10_n164) );
  XNOR2_X1 sub_10_U158 ( .A(sub_10_n164), .B(sub_10_n165), .ZN(diff_12_) );
  NOR2_X1 sub_10_U157 ( .A1(sub_10_n154), .A2(sub_10_n155), .ZN(sub_10_n150)
         );
  INV_X1 sub_10_U156 ( .A(A[0]), .ZN(sub_10_n46) );
  INV_X1 sub_10_U155 ( .A(A[1]), .ZN(sub_10_n45) );
  INV_X1 sub_10_U154 ( .A(A[3]), .ZN(sub_10_n44) );
  NAND2_X1 sub_10_U153 ( .A1(sub_10_n22), .A2(sub_10_n25), .ZN(sub_10_n61) );
  NAND2_X1 sub_10_U152 ( .A1(sub_10_n196), .A2(sub_10_n197), .ZN(sub_10_n43)
         );
  XNOR2_X1 sub_10_U151 ( .A(sub_10_n117), .B(sub_10_n118), .ZN(diff_1_) );
  XNOR2_X1 sub_10_U150 ( .A(sub_10_n93), .B(sub_10_n94), .ZN(diff_5_) );
  INV_X1 sub_10_U149 ( .A(B[14]), .ZN(sub_10_n146) );
  NAND2_X1 sub_10_U148 ( .A1(A[14]), .A2(sub_10_n146), .ZN(sub_10_n124) );
  INV_X1 sub_10_U147 ( .A(A[14]), .ZN(sub_10_n145) );
  NAND2_X1 sub_10_U146 ( .A1(B[14]), .A2(sub_10_n145), .ZN(sub_10_n126) );
  INV_X1 sub_10_U145 ( .A(B[12]), .ZN(sub_10_n166) );
  NAND2_X1 sub_10_U144 ( .A1(A[12]), .A2(sub_10_n166), .ZN(sub_10_n143) );
  INV_X1 sub_10_U143 ( .A(B[13]), .ZN(sub_10_n148) );
  NAND2_X1 sub_10_U142 ( .A1(A[13]), .A2(sub_10_n148), .ZN(sub_10_n129) );
  NAND2_X1 sub_10_U141 ( .A1(A[4]), .A2(sub_10_n99), .ZN(sub_10_n79) );
  INV_X1 sub_10_U140 ( .A(A[13]), .ZN(sub_10_n149) );
  NAND2_X1 sub_10_U139 ( .A1(B[13]), .A2(sub_10_n149), .ZN(sub_10_n125) );
  INV_X1 sub_10_U138 ( .A(B[11]), .ZN(sub_10_n175) );
  NAND2_X1 sub_10_U137 ( .A1(A[11]), .A2(sub_10_n175), .ZN(sub_10_n158) );
  INV_X1 sub_10_U136 ( .A(B[7]), .ZN(sub_10_n222) );
  NAND2_X1 sub_10_U135 ( .A1(A[7]), .A2(sub_10_n222), .ZN(sub_10_n68) );
  INV_X1 sub_10_U134 ( .A(B[10]), .ZN(sub_10_n191) );
  INV_X1 sub_10_U133 ( .A(A[12]), .ZN(sub_10_n167) );
  OAI21_X1 sub_10_U132 ( .B1(sub_10_n122), .B2(sub_10_n123), .A(sub_10_n124), 
        .ZN(sub_10_n121) );
  XNOR2_X1 sub_10_U131 ( .A(sub_10_n121), .B(sub_10_n5), .ZN(lt) );
  INV_X1 sub_10_U130 ( .A(A[11]), .ZN(sub_10_n176) );
  NAND2_X1 sub_10_U129 ( .A1(B[11]), .A2(sub_10_n176), .ZN(sub_10_n161) );
  INV_X1 sub_10_U128 ( .A(B[2]), .ZN(sub_10_n113) );
  NAND2_X1 sub_10_U127 ( .A1(A[2]), .A2(sub_10_n113), .ZN(sub_10_n104) );
  INV_X1 sub_10_U126 ( .A(A[4]), .ZN(sub_10_n207) );
  INV_X1 sub_10_U125 ( .A(B[6]), .ZN(sub_10_n211) );
  NAND2_X1 sub_10_U124 ( .A1(A[6]), .A2(sub_10_n211), .ZN(sub_10_n71) );
  NAND2_X1 sub_10_U123 ( .A1(B[0]), .A2(sub_10_n119), .ZN(sub_10_n42) );
  INV_X1 sub_10_U122 ( .A(B[5]), .ZN(sub_10_n210) );
  NAND2_X1 sub_10_U121 ( .A1(A[5]), .A2(sub_10_n210), .ZN(sub_10_n78) );
  INV_X1 sub_10_U120 ( .A(B[3]), .ZN(sub_10_n203) );
  NAND2_X1 sub_10_U119 ( .A1(A[3]), .A2(sub_10_n203), .ZN(sub_10_n91) );
  INV_X1 sub_10_U118 ( .A(B[9]), .ZN(sub_10_n217) );
  NAND2_X1 sub_10_U117 ( .A1(sub_10_n217), .A2(A[9]), .ZN(sub_10_n55) );
  INV_X1 sub_10_U116 ( .A(A[7]), .ZN(sub_10_n214) );
  NAND2_X1 sub_10_U115 ( .A1(B[7]), .A2(sub_10_n214), .ZN(sub_10_n69) );
  INV_X1 sub_10_U114 ( .A(A[8]), .ZN(sub_10_n220) );
  INV_X1 sub_10_U113 ( .A(B[8]), .ZN(sub_10_n218) );
  NAND2_X1 sub_10_U112 ( .A1(sub_10_n218), .A2(A[8]), .ZN(sub_10_n56) );
  INV_X1 sub_10_U111 ( .A(B[4]), .ZN(sub_10_n99) );
  NAND2_X1 sub_10_U110 ( .A1(A[4]), .A2(sub_10_n99), .ZN(sub_10_n187) );
  INV_X1 sub_10_U109 ( .A(A[0]), .ZN(sub_10_n109) );
  NAND2_X1 sub_10_U108 ( .A1(B[2]), .A2(sub_10_n107), .ZN(sub_10_n112) );
  INV_X1 sub_10_U107 ( .A(B[2]), .ZN(sub_10_n204) );
  INV_X1 sub_10_U106 ( .A(A[10]), .ZN(sub_10_n192) );
  NAND2_X1 sub_10_U105 ( .A1(B[2]), .A2(sub_10_n107), .ZN(sub_10_n106) );
  NAND2_X1 sub_10_U104 ( .A1(sub_10_n105), .A2(sub_10_n106), .ZN(sub_10_n103)
         );
  INV_X1 sub_10_U103 ( .A(A[6]), .ZN(sub_10_n213) );
  NAND2_X1 sub_10_U102 ( .A1(B[6]), .A2(sub_10_n213), .ZN(sub_10_n81) );
  INV_X1 sub_10_U101 ( .A(A[9]), .ZN(sub_10_n221) );
  INV_X1 sub_10_U100 ( .A(A[5]), .ZN(sub_10_n212) );
  NAND2_X1 sub_10_U99 ( .A1(B[5]), .A2(sub_10_n212), .ZN(sub_10_n80) );
  NAND2_X1 sub_10_U98 ( .A1(sub_10_n125), .A2(sub_10_n126), .ZN(sub_10_n123)
         );
  NAND2_X1 sub_10_U97 ( .A1(sub_10_n73), .A2(sub_10_n79), .ZN(sub_10_n98) );
  NOR2_X1 sub_10_U96 ( .A1(sub_10_n68), .A2(sub_10_n219), .ZN(sub_10_n215) );
  NOR2_X1 sub_10_U95 ( .A1(sub_10_n180), .A2(sub_10_n62), .ZN(sub_10_n179) );
  NAND2_X1 sub_10_U94 ( .A1(sub_10_n125), .A2(sub_10_n135), .ZN(sub_10_n141)
         );
  NOR2_X1 sub_10_U93 ( .A1(sub_10_n75), .A2(sub_10_n79), .ZN(sub_10_n76) );
  NAND2_X1 sub_10_U92 ( .A1(sub_10_n20), .A2(sub_10_n159), .ZN(sub_10_n171) );
  NAND2_X1 sub_10_U91 ( .A1(sub_10_n216), .A2(sub_10_n31), .ZN(sub_10_n183) );
  OAI21_X1 sub_10_U90 ( .B1(sub_10_n84), .B2(sub_10_n85), .A(sub_10_n23), .ZN(
        sub_10_n82) );
  NAND2_X1 sub_10_U89 ( .A1(sub_10_n81), .A2(sub_10_n9), .ZN(sub_10_n83) );
  XNOR2_X1 sub_10_U88 ( .A(sub_10_n82), .B(sub_10_n83), .ZN(diff_6_) );
  INV_X1 sub_10_U87 ( .A(sub_10_n90), .ZN(sub_10_n88) );
  NOR2_X1 sub_10_U86 ( .A1(sub_10_n86), .A2(sub_10_n87), .ZN(sub_10_n85) );
  NAND2_X1 sub_10_U85 ( .A1(sub_10_n31), .A2(sub_10_n59), .ZN(sub_10_n188) );
  NAND2_X1 sub_10_U84 ( .A1(sub_10_n183), .A2(sub_10_n159), .ZN(sub_10_n182)
         );
  NOR2_X1 sub_10_U83 ( .A1(sub_10_n184), .A2(sub_10_n188), .ZN(sub_10_n181) );
  AOI21_X1 sub_10_U82 ( .B1(sub_10_n181), .B2(sub_10_n63), .A(sub_10_n182), 
        .ZN(sub_10_n177) );
  NAND2_X1 sub_10_U81 ( .A1(sub_10_n161), .A2(sub_10_n158), .ZN(sub_10_n174)
         );
  NAND2_X1 sub_10_U80 ( .A1(sub_10_n135), .A2(sub_10_n125), .ZN(sub_10_n134)
         );
  INV_X1 sub_10_U79 ( .A(sub_10_n129), .ZN(sub_10_n128) );
  NOR2_X1 sub_10_U78 ( .A1(sub_10_n215), .A2(sub_10_n216), .ZN(sub_10_n193) );
  NAND2_X1 sub_10_U77 ( .A1(sub_10_n31), .A2(sub_10_n159), .ZN(sub_10_n190) );
  XNOR2_X1 sub_10_U76 ( .A(sub_10_n189), .B(sub_10_n190), .ZN(diff_10_) );
  NAND2_X1 sub_10_U75 ( .A1(sub_10_n171), .A2(sub_10_n161), .ZN(sub_10_n170)
         );
  NAND2_X1 sub_10_U74 ( .A1(sub_10_n135), .A2(sub_10_n143), .ZN(sub_10_n165)
         );
  AND2_X1 sub_10_U73 ( .A1(sub_10_n19), .A2(sub_10_n91), .ZN(sub_10_n197) );
  INV_X1 sub_10_U72 ( .A(sub_10_n75), .ZN(sub_10_n74) );
  NOR2_X1 sub_10_U71 ( .A1(sub_10_n76), .A2(sub_10_n77), .ZN(sub_10_n70) );
  INV_X1 sub_10_U70 ( .A(sub_10_n90), .ZN(sub_10_n97) );
  NAND2_X1 sub_10_U69 ( .A1(sub_10_n95), .A2(sub_10_n79), .ZN(sub_10_n93) );
  NAND2_X1 sub_10_U68 ( .A1(sub_10_n112), .A2(sub_10_n104), .ZN(sub_10_n41) );
  NAND2_X1 sub_10_U67 ( .A1(sub_10_n114), .A2(sub_10_n115), .ZN(sub_10_n40) );
  XNOR2_X1 sub_10_U66 ( .A(sub_10_n40), .B(sub_10_n41), .ZN(diff_2_) );
  NAND2_X1 sub_10_U65 ( .A1(sub_10_n124), .A2(sub_10_n126), .ZN(sub_10_n130)
         );
  AND2_X1 sub_10_U64 ( .A1(sub_10_n161), .A2(sub_10_n135), .ZN(sub_10_n156) );
  NAND2_X1 sub_10_U63 ( .A1(sub_10_n125), .A2(sub_10_n129), .ZN(sub_10_n147)
         );
  NAND2_X1 sub_10_U62 ( .A1(sub_10_n63), .A2(sub_10_n59), .ZN(sub_10_n57) );
  OAI211_X1 sub_10_U61 ( .C1(sub_10_n33), .C2(sub_10_n187), .A(sub_10_n9), .B(
        sub_10_n23), .ZN(sub_10_n186) );
  NAND2_X1 sub_10_U60 ( .A1(sub_10_n185), .A2(sub_10_n186), .ZN(sub_10_n67) );
  NAND2_X1 sub_10_U59 ( .A1(sub_10_n67), .A2(sub_10_n68), .ZN(sub_10_n63) );
  NAND2_X1 sub_10_U58 ( .A1(sub_10_n205), .A2(sub_10_n91), .ZN(sub_10_n101) );
  INV_X1 sub_10_U57 ( .A(sub_10_n62), .ZN(sub_10_n60) );
  NAND2_X1 sub_10_U56 ( .A1(sub_10_n2), .A2(sub_10_n63), .ZN(sub_10_n169) );
  INV_X1 sub_10_U55 ( .A(sub_10_n50), .ZN(sub_10_n140) );
  NAND2_X1 sub_10_U54 ( .A1(B[9]), .A2(sub_10_n37), .ZN(sub_10_n54) );
  INV_X1 sub_10_U53 ( .A(A[9]), .ZN(sub_10_n38) );
  INV_X1 sub_10_U52 ( .A(A[9]), .ZN(sub_10_n37) );
  NAND2_X1 sub_10_U51 ( .A1(B[9]), .A2(sub_10_n221), .ZN(sub_10_n36) );
  NAND2_X1 sub_10_U50 ( .A1(B[9]), .A2(sub_10_n38), .ZN(sub_10_n35) );
  INV_X1 sub_10_U49 ( .A(A[5]), .ZN(sub_10_n34) );
  AND2_X1 sub_10_U48 ( .A1(B[5]), .A2(sub_10_n34), .ZN(sub_10_n33) );
  NAND2_X1 sub_10_U47 ( .A1(B[10]), .A2(sub_10_n192), .ZN(sub_10_n172) );
  INV_X1 sub_10_U46 ( .A(A[10]), .ZN(sub_10_n32) );
  AND2_X2 sub_10_U45 ( .A1(B[6]), .A2(sub_10_n213), .ZN(sub_10_n30) );
  NAND2_X1 sub_10_U44 ( .A1(sub_10_n55), .A2(sub_10_n56), .ZN(sub_10_n29) );
  AND2_X1 sub_10_U43 ( .A1(sub_10_n172), .A2(sub_10_n54), .ZN(sub_10_n28) );
  NAND2_X1 sub_10_U42 ( .A1(sub_10_n28), .A2(sub_10_n29), .ZN(sub_10_n160) );
  NAND4_X1 sub_10_U41 ( .A1(sub_10_n31), .A2(sub_10_n161), .A3(sub_10_n35), 
        .A4(sub_10_n59), .ZN(sub_10_n27) );
  AND2_X1 sub_10_U40 ( .A1(sub_10_n92), .A2(sub_10_n91), .ZN(sub_10_n25) );
  NAND2_X1 sub_10_U39 ( .A1(A[5]), .A2(sub_10_n210), .ZN(sub_10_n24) );
  NAND2_X1 sub_10_U38 ( .A1(A[5]), .A2(sub_10_n210), .ZN(sub_10_n23) );
  NOR2_X1 sub_10_U37 ( .A1(sub_10_n39), .A2(sub_10_n90), .ZN(sub_10_n196) );
  NOR2_X1 sub_10_U36 ( .A1(sub_10_n39), .A2(sub_10_n90), .ZN(sub_10_n22) );
  AND2_X1 sub_10_U35 ( .A1(B[7]), .A2(sub_10_n214), .ZN(sub_10_n21) );
  CLKBUF_X1 sub_10_U34 ( .A(sub_10_n160), .Z(sub_10_n20) );
  NAND2_X1 sub_10_U33 ( .A1(sub_10_n198), .A2(sub_10_n199), .ZN(sub_10_n19) );
  AND2_X1 sub_10_U32 ( .A1(sub_10_n116), .A2(sub_10_n223), .ZN(sub_10_n18) );
  INV_X1 sub_10_U31 ( .A(sub_10_n108), .ZN(sub_10_n17) );
  AND3_X1 sub_10_U30 ( .A1(sub_10_n110), .A2(B[0]), .A3(sub_10_n109), .ZN(
        sub_10_n102) );
  AND4_X1 sub_10_U29 ( .A1(sub_10_n223), .A2(sub_10_n116), .A3(sub_10_n112), 
        .A4(sub_10_n205), .ZN(sub_10_n39) );
  NAND2_X1 sub_10_U28 ( .A1(sub_10_n197), .A2(sub_10_n22), .ZN(sub_10_n26) );
  INV_X1 sub_10_U27 ( .A(sub_10_n16), .ZN(sub_10_n90) );
  INV_X1 sub_10_U26 ( .A(B[3]), .ZN(sub_10_n15) );
  OAI211_X1 sub_10_U25 ( .C1(A[3]), .C2(sub_10_n15), .A(A[2]), .B(sub_10_n204), 
        .ZN(sub_10_n16) );
  AOI22_X1 sub_10_U24 ( .A1(sub_10_n206), .A2(B[3]), .B1(sub_10_n47), .B2(B[2]), .ZN(sub_10_n199) );
  INV_X1 sub_10_U23 ( .A(sub_10_n136), .ZN(sub_10_n14) );
  INV_X1 sub_10_U22 ( .A(sub_10_n137), .ZN(sub_10_n13) );
  NAND4_X1 sub_10_U21 ( .A1(sub_10_n3), .A2(sub_10_n13), .A3(sub_10_n14), .A4(
        sub_10_n132), .ZN(sub_10_n131) );
  NAND2_X1 sub_10_U20 ( .A1(sub_10_n119), .A2(B[0]), .ZN(sub_10_n117) );
  NAND2_X1 sub_10_U19 ( .A1(sub_10_n51), .A2(A[0]), .ZN(sub_10_n201) );
  CLKBUF_X1 sub_10_U18 ( .A(sub_10_n26), .Z(sub_10_n12) );
  CLKBUF_X1 sub_10_U17 ( .A(sub_10_n43), .Z(sub_10_n11) );
  NAND2_X1 sub_10_U16 ( .A1(sub_10_n218), .A2(A[8]), .ZN(sub_10_n10) );
  NAND2_X1 sub_10_U15 ( .A1(A[6]), .A2(sub_10_n211), .ZN(sub_10_n9) );
  CLKBUF_X1 sub_10_U14 ( .A(sub_10_n19), .Z(sub_10_n8) );
  NAND2_X1 sub_10_U13 ( .A1(sub_10_n69), .A2(sub_10_n68), .ZN(sub_10_n7) );
  NAND3_X1 sub_10_U12 ( .A1(sub_10_n72), .A2(sub_10_n71), .A3(sub_10_n70), 
        .ZN(sub_10_n6) );
  XNOR2_X1 sub_10_U11 ( .A(sub_10_n6), .B(sub_10_n7), .ZN(diff_7_) );
  XOR2_X1 sub_10_U10 ( .A(B[15]), .B(A[15]), .Z(sub_10_n5) );
  NAND2_X1 sub_10_U9 ( .A1(sub_10_n42), .A2(sub_10_n120), .ZN(diff_0_) );
  OR3_X1 sub_10_U8 ( .A1(sub_10_n140), .A2(sub_10_n27), .A3(sub_10_n141), .ZN(
        sub_10_n3) );
  AND4_X1 sub_10_U7 ( .A1(sub_10_n31), .A2(sub_10_n161), .A3(sub_10_n35), .A4(
        sub_10_n59), .ZN(sub_10_n2) );
  NAND2_X1 sub_10_U6 ( .A1(A[10]), .A2(sub_10_n191), .ZN(sub_10_n159) );
  NAND2_X1 sub_10_U5 ( .A1(B[10]), .A2(sub_10_n32), .ZN(sub_10_n31) );
  NAND2_X1 sub_10_U4 ( .A1(B[4]), .A2(sub_10_n207), .ZN(sub_10_n73) );
  CLKBUF_X1 sub_10_U3 ( .A(sub_10_n55), .Z(sub_10_n1) );
endmodule

