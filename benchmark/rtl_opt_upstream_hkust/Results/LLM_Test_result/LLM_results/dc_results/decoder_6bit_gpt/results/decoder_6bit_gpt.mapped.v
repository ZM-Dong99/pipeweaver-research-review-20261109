/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:29:07 2025
/////////////////////////////////////////////////////////////


module decoder_6bit_gpt ( in, out );
  input [5:0] in;
  output [63:0] out;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64;

  NAND3_X1 U73 ( .A1(n27), .A2(in[3]), .A3(in[5]), .ZN(n19) );
  NAND3_X1 U75 ( .A1(n62), .A2(in[3]), .A3(in[4]), .ZN(n21) );
  BUF_X1 U87 ( .A(in[0]), .Z(n23) );
  BUF_X1 U88 ( .A(in[1]), .Z(n24) );
  BUF_X1 U89 ( .A(in[2]), .Z(n25) );
  BUF_X1 U90 ( .A(in[5]), .Z(n26) );
  NAND3_X1 U91 ( .A1(n2), .A2(n62), .A3(n60), .ZN(n47) );
  INV_X1 U92 ( .A(in[4]), .ZN(n27) );
  INV_X1 U93 ( .A(in[5]), .ZN(n28) );
  INV_X1 U94 ( .A(in[3]), .ZN(n29) );
  OR3_X2 U95 ( .A1(in[1]), .A2(in[2]), .A3(in[0]), .ZN(n30) );
  INV_X1 U96 ( .A(n48), .ZN(n31) );
  BUF_X1 U97 ( .A(in[0]), .Z(n32) );
  NAND3_X2 U98 ( .A1(in[1]), .A2(in[2]), .A3(in[0]), .ZN(n10) );
  NAND3_X2 U99 ( .A1(in[4]), .A2(in[5]), .A3(in[3]), .ZN(n13) );
  NAND3_X1 U100 ( .A1(n5), .A2(n52), .A3(n23), .ZN(n33) );
  NAND3_X1 U101 ( .A1(n5), .A2(n52), .A3(in[0]), .ZN(n7) );
  NAND3_X1 U102 ( .A1(n50), .A2(n6), .A3(in[2]), .ZN(n34) );
  NAND3_X1 U103 ( .A1(n50), .A2(n63), .A3(in[2]), .ZN(n15) );
  BUF_X2 U104 ( .A(in[3]), .Z(n35) );
  NAND3_X1 U105 ( .A1(n60), .A2(in[4]), .A3(in[5]), .ZN(n36) );
  NAND3_X1 U106 ( .A1(n29), .A2(in[4]), .A3(in[5]), .ZN(n18) );
  NAND3_X1 U107 ( .A1(n61), .A2(n1), .A3(in[3]), .ZN(n37) );
  NAND3_X1 U108 ( .A1(n58), .A2(n1), .A3(in[3]), .ZN(n8) );
  NAND3_X1 U109 ( .A1(n4), .A2(n42), .A3(in[1]), .ZN(n38) );
  NAND3_X1 U110 ( .A1(n4), .A2(n6), .A3(in[1]), .ZN(n17) );
  NAND3_X1 U111 ( .A1(n42), .A2(in[1]), .A3(in[2]), .ZN(n39) );
  NAND3_X1 U112 ( .A1(n63), .A2(in[1]), .A3(in[2]), .ZN(n12) );
  NAND3_X1 U113 ( .A1(n58), .A2(n48), .A3(in[5]), .ZN(n40) );
  NAND3_X1 U114 ( .A1(n27), .A2(n3), .A3(in[5]), .ZN(n20) );
  NAND3_X1 U115 ( .A1(n32), .A2(n57), .A3(in[1]), .ZN(n41) );
  INV_X1 U116 ( .A(in[0]), .ZN(n42) );
  OR3_X2 U117 ( .A1(in[1]), .A2(in[2]), .A3(in[0]), .ZN(n43) );
  NAND3_X1 U118 ( .A1(n51), .A2(n5), .A3(n25), .ZN(n44) );
  NAND3_X1 U119 ( .A1(n51), .A2(n64), .A3(n25), .ZN(n45) );
  NAND3_X1 U120 ( .A1(n32), .A2(n64), .A3(in[2]), .ZN(n14) );
  NAND3_X1 U121 ( .A1(n51), .A2(n57), .A3(n24), .ZN(n46) );
  NAND3_X1 U122 ( .A1(n57), .A2(n23), .A3(n24), .ZN(n16) );
  BUF_X2 U123 ( .A(in[0]), .Z(n51) );
  INV_X1 U124 ( .A(in[3]), .ZN(n48) );
  NAND3_X1 U125 ( .A1(n28), .A2(n29), .A3(in[4]), .ZN(n49) );
  NAND3_X1 U126 ( .A1(n59), .A2(n3), .A3(in[4]), .ZN(n22) );
  INV_X1 U127 ( .A(in[1]), .ZN(n50) );
  INV_X1 U128 ( .A(in[2]), .ZN(n52) );
  NAND3_X1 U129 ( .A1(n35), .A2(n28), .A3(in[4]), .ZN(n53) );
  NAND3_X1 U130 ( .A1(n35), .A2(n59), .A3(in[4]), .ZN(n54) );
  OR3_X2 U131 ( .A1(in[4]), .A2(in[5]), .A3(in[3]), .ZN(n11) );
  NAND3_X1 U132 ( .A1(n35), .A2(n2), .A3(n26), .ZN(n55) );
  NAND3_X1 U133 ( .A1(n31), .A2(n61), .A3(n26), .ZN(n56) );
  INV_X1 U134 ( .A(in[2]), .ZN(n57) );
  INV_X1 U135 ( .A(in[4]), .ZN(n58) );
  INV_X1 U136 ( .A(in[5]), .ZN(n59) );
  NOR2_X1 U137 ( .A1(n30), .A2(n13), .ZN(out[56]) );
  NOR2_X1 U138 ( .A1(n12), .A2(n13), .ZN(out[62]) );
  NOR2_X1 U139 ( .A1(n10), .A2(n13), .ZN(out[63]) );
  INV_X1 U140 ( .A(in[3]), .ZN(n60) );
  NOR2_X1 U141 ( .A1(n11), .A2(n10), .ZN(out[7]) );
  NOR2_X1 U142 ( .A1(n47), .A2(n15), .ZN(out[4]) );
  NOR2_X1 U143 ( .A1(n11), .A2(n43), .ZN(out[0]) );
  INV_X1 U144 ( .A(in[4]), .ZN(n61) );
  INV_X1 U145 ( .A(in[5]), .ZN(n62) );
  INV_X1 U146 ( .A(in[0]), .ZN(n63) );
  INV_X1 U147 ( .A(in[1]), .ZN(n64) );
  NOR2_X1 U148 ( .A1(n15), .A2(n13), .ZN(out[60]) );
  NOR2_X1 U149 ( .A1(n7), .A2(n13), .ZN(out[57]) );
  NOR2_X1 U150 ( .A1(n7), .A2(n11), .ZN(out[1]) );
  OR3_X2 U151 ( .A1(in[1]), .A2(in[2]), .A3(in[0]), .ZN(n9) );
  INV_X1 U152 ( .A(in[1]), .ZN(n5) );
  INV_X1 U153 ( .A(in[2]), .ZN(n4) );
  INV_X1 U154 ( .A(in[0]), .ZN(n6) );
  NOR2_X1 U155 ( .A1(n47), .A2(n12), .ZN(out[6]) );
  NOR2_X1 U156 ( .A1(n47), .A2(n14), .ZN(out[5]) );
  NOR2_X1 U157 ( .A1(n14), .A2(n13), .ZN(out[61]) );
  NOR2_X1 U158 ( .A1(n47), .A2(n16), .ZN(out[3]) );
  NOR2_X1 U159 ( .A1(n16), .A2(n13), .ZN(out[59]) );
  NOR2_X1 U160 ( .A1(n17), .A2(n13), .ZN(out[58]) );
  NOR2_X1 U161 ( .A1(n47), .A2(n38), .ZN(out[2]) );
  NOR2_X1 U162 ( .A1(n7), .A2(n8), .ZN(out[9]) );
  NOR2_X1 U163 ( .A1(n37), .A2(n43), .ZN(out[8]) );
  NOR2_X1 U164 ( .A1(n37), .A2(n10), .ZN(out[15]) );
  NOR2_X1 U165 ( .A1(n8), .A2(n39), .ZN(out[14]) );
  NOR2_X1 U166 ( .A1(n37), .A2(n14), .ZN(out[13]) );
  NOR2_X1 U167 ( .A1(n8), .A2(n15), .ZN(out[12]) );
  NOR2_X1 U168 ( .A1(n37), .A2(n16), .ZN(out[11]) );
  NOR2_X1 U169 ( .A1(n8), .A2(n38), .ZN(out[10]) );
  INV_X1 U170 ( .A(in[4]), .ZN(n2) );
  INV_X1 U171 ( .A(in[5]), .ZN(n1) );
  INV_X1 U172 ( .A(in[3]), .ZN(n3) );
  NOR2_X1 U173 ( .A1(n20), .A2(n10), .ZN(out[39]) );
  NOR2_X1 U174 ( .A1(n39), .A2(n40), .ZN(out[38]) );
  NOR2_X1 U175 ( .A1(n20), .A2(n44), .ZN(out[37]) );
  NOR2_X1 U176 ( .A1(n34), .A2(n40), .ZN(out[36]) );
  NOR2_X1 U177 ( .A1(n20), .A2(n41), .ZN(out[35]) );
  NOR2_X1 U178 ( .A1(n38), .A2(n40), .ZN(out[34]) );
  NOR2_X1 U179 ( .A1(n7), .A2(n20), .ZN(out[33]) );
  NOR2_X1 U180 ( .A1(n9), .A2(n40), .ZN(out[32]) );
  NOR2_X1 U181 ( .A1(n55), .A2(n10), .ZN(out[47]) );
  NOR2_X1 U182 ( .A1(n39), .A2(n19), .ZN(out[46]) );
  NOR2_X1 U183 ( .A1(n45), .A2(n56), .ZN(out[45]) );
  NOR2_X1 U184 ( .A1(n15), .A2(n55), .ZN(out[44]) );
  NOR2_X1 U185 ( .A1(n41), .A2(n19), .ZN(out[43]) );
  NOR2_X1 U186 ( .A1(n17), .A2(n56), .ZN(out[42]) );
  NOR2_X1 U187 ( .A1(n33), .A2(n55), .ZN(out[41]) );
  NOR2_X1 U188 ( .A1(n30), .A2(n19), .ZN(out[40]) );
  NOR2_X1 U189 ( .A1(n10), .A2(n18), .ZN(out[55]) );
  NOR2_X1 U190 ( .A1(n39), .A2(n36), .ZN(out[54]) );
  NOR2_X1 U191 ( .A1(n44), .A2(n18), .ZN(out[53]) );
  NOR2_X1 U192 ( .A1(n34), .A2(n36), .ZN(out[52]) );
  NOR2_X1 U193 ( .A1(n41), .A2(n18), .ZN(out[51]) );
  NOR2_X1 U194 ( .A1(n17), .A2(n36), .ZN(out[50]) );
  NOR2_X1 U195 ( .A1(n33), .A2(n18), .ZN(out[49]) );
  NOR2_X1 U196 ( .A1(n9), .A2(n36), .ZN(out[48]) );
  NOR2_X1 U197 ( .A1(n49), .A2(n10), .ZN(out[23]) );
  NOR2_X1 U198 ( .A1(n49), .A2(n12), .ZN(out[22]) );
  NOR2_X1 U199 ( .A1(n22), .A2(n45), .ZN(out[21]) );
  NOR2_X1 U200 ( .A1(n22), .A2(n34), .ZN(out[20]) );
  NOR2_X1 U201 ( .A1(n49), .A2(n46), .ZN(out[19]) );
  NOR2_X1 U202 ( .A1(n38), .A2(n49), .ZN(out[18]) );
  NOR2_X1 U203 ( .A1(n33), .A2(n22), .ZN(out[17]) );
  NOR2_X1 U204 ( .A1(n30), .A2(n22), .ZN(out[16]) );
  NOR2_X1 U205 ( .A1(n53), .A2(n10), .ZN(out[31]) );
  NOR2_X1 U206 ( .A1(n12), .A2(n21), .ZN(out[30]) );
  NOR2_X1 U207 ( .A1(n44), .A2(n54), .ZN(out[29]) );
  NOR2_X1 U208 ( .A1(n34), .A2(n53), .ZN(out[28]) );
  NOR2_X1 U209 ( .A1(n46), .A2(n21), .ZN(out[27]) );
  NOR2_X1 U210 ( .A1(n17), .A2(n54), .ZN(out[26]) );
  NOR2_X1 U211 ( .A1(n33), .A2(n53), .ZN(out[25]) );
  NOR2_X1 U212 ( .A1(n9), .A2(n21), .ZN(out[24]) );
endmodule

