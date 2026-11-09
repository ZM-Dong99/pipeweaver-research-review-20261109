/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:46:16 2025
/////////////////////////////////////////////////////////////


module decoder_6bit_dsr ( in, out );
  input [5:0] in;
  output [63:0] out;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65;

  INV_X1 U98 ( .A(in[5]), .ZN(n34) );
  NAND2_X1 U99 ( .A1(n5), .A2(in[1]), .ZN(n43) );
  INV_X1 U100 ( .A(in[1]), .ZN(n35) );
  OR2_X2 U101 ( .A1(in[0]), .A2(in[1]), .ZN(n36) );
  NAND2_X1 U102 ( .A1(n17), .A2(n25), .ZN(n37) );
  NAND2_X1 U103 ( .A1(n15), .A2(n47), .ZN(n38) );
  NAND2_X1 U104 ( .A1(n42), .A2(n56), .ZN(n39) );
  NAND2_X1 U105 ( .A1(n60), .A2(n19), .ZN(n40) );
  NAND2_X1 U106 ( .A1(n45), .A2(n48), .ZN(n41) );
  AND2_X1 U107 ( .A1(n53), .A2(in[3]), .ZN(n42) );
  AND2_X1 U108 ( .A1(n53), .A2(in[3]), .ZN(n15) );
  AND2_X2 U109 ( .A1(in[2]), .A2(in[3]), .ZN(n17) );
  NAND2_X1 U110 ( .A1(in[1]), .A2(n5), .ZN(n7) );
  NAND2_X2 U111 ( .A1(n4), .A2(in[0]), .ZN(n44) );
  NAND2_X1 U112 ( .A1(in[0]), .A2(n35), .ZN(n11) );
  AND2_X1 U113 ( .A1(n61), .A2(in[3]), .ZN(n45) );
  INV_X1 U114 ( .A(in[2]), .ZN(n46) );
  NOR2_X1 U115 ( .A1(in[5]), .A2(in[4]), .ZN(n47) );
  NOR2_X1 U116 ( .A1(in[5]), .A2(in[4]), .ZN(n63) );
  NOR2_X1 U117 ( .A1(n34), .A2(in[4]), .ZN(n48) );
  INV_X1 U118 ( .A(in[5]), .ZN(n49) );
  NOR2_X1 U119 ( .A1(n1), .A2(in[4]), .ZN(n65) );
  INV_X1 U120 ( .A(in[4]), .ZN(n50) );
  INV_X1 U121 ( .A(in[4]), .ZN(n51) );
  NOR2_X1 U122 ( .A1(n49), .A2(in[4]), .ZN(n52) );
  NOR2_X1 U123 ( .A1(n58), .A2(in[4]), .ZN(n13) );
  INV_X1 U124 ( .A(in[2]), .ZN(n53) );
  NAND2_X2 U125 ( .A1(in[0]), .A2(in[1]), .ZN(n8) );
  NOR2_X1 U126 ( .A1(n3), .A2(in[3]), .ZN(n54) );
  NOR2_X1 U127 ( .A1(n46), .A2(in[3]), .ZN(n55) );
  NOR2_X1 U128 ( .A1(n2), .A2(in[5]), .ZN(n56) );
  NOR2_X1 U129 ( .A1(n50), .A2(in[5]), .ZN(n57) );
  INV_X1 U130 ( .A(in[5]), .ZN(n58) );
  NOR2_X1 U131 ( .A1(in[2]), .A2(in[3]), .ZN(n59) );
  NOR2_X1 U132 ( .A1(in[2]), .A2(in[3]), .ZN(n20) );
  AND2_X1 U133 ( .A1(n61), .A2(in[3]), .ZN(n60) );
  NOR2_X1 U134 ( .A1(n22), .A2(n8), .ZN(out[63]) );
  NOR2_X1 U135 ( .A1(n22), .A2(n36), .ZN(out[60]) );
  NAND2_X1 U136 ( .A1(n19), .A2(n17), .ZN(n22) );
  NOR2_X1 U137 ( .A1(n10), .A2(n37), .ZN(out[12]) );
  NOR2_X1 U138 ( .A1(n8), .A2(n28), .ZN(out[15]) );
  NAND2_X1 U139 ( .A1(n17), .A2(n25), .ZN(n28) );
  NOR2_X1 U140 ( .A1(n51), .A2(in[5]), .ZN(n64) );
  NOR2_X1 U141 ( .A1(n36), .A2(n33), .ZN(out[28]) );
  NOR2_X1 U142 ( .A1(n8), .A2(n33), .ZN(out[31]) );
  NOR2_X1 U143 ( .A1(n6), .A2(n8), .ZN(out[35]) );
  NOR2_X1 U144 ( .A1(n6), .A2(n36), .ZN(out[32]) );
  NOR2_X1 U145 ( .A1(n16), .A2(n10), .ZN(out[44]) );
  NOR2_X1 U146 ( .A1(n8), .A2(n16), .ZN(out[47]) );
  NAND2_X1 U147 ( .A1(n17), .A2(n64), .ZN(n33) );
  INV_X1 U148 ( .A(in[2]), .ZN(n61) );
  NOR2_X1 U149 ( .A1(n6), .A2(n7), .ZN(out[34]) );
  NOR2_X1 U150 ( .A1(n7), .A2(n16), .ZN(out[46]) );
  NOR2_X1 U151 ( .A1(n7), .A2(n28), .ZN(out[14]) );
  NOR2_X1 U152 ( .A1(n22), .A2(n7), .ZN(out[62]) );
  NOR2_X1 U153 ( .A1(n7), .A2(n33), .ZN(out[30]) );
  NOR2_X1 U154 ( .A1(n11), .A2(n16), .ZN(out[45]) );
  NOR2_X1 U155 ( .A1(n22), .A2(n11), .ZN(out[61]) );
  NOR2_X1 U156 ( .A1(n11), .A2(n37), .ZN(out[13]) );
  NOR2_X1 U157 ( .A1(n11), .A2(n33), .ZN(out[29]) );
  NOR2_X1 U158 ( .A1(n6), .A2(n11), .ZN(out[33]) );
  NOR2_X1 U159 ( .A1(n3), .A2(in[3]), .ZN(n62) );
  NOR2_X1 U160 ( .A1(n46), .A2(in[3]), .ZN(n12) );
  INV_X1 U161 ( .A(in[2]), .ZN(n3) );
  NAND2_X1 U162 ( .A1(n17), .A2(n52), .ZN(n16) );
  NOR2_X1 U163 ( .A1(in[5]), .A2(in[4]), .ZN(n25) );
  NOR2_X1 U164 ( .A1(n10), .A2(n18), .ZN(out[48]) );
  NOR2_X1 U165 ( .A1(n11), .A2(n18), .ZN(out[49]) );
  NOR2_X1 U166 ( .A1(n7), .A2(n18), .ZN(out[50]) );
  NOR2_X1 U167 ( .A1(n8), .A2(n18), .ZN(out[51]) );
  NOR2_X1 U168 ( .A1(n24), .A2(n36), .ZN(out[0]) );
  NOR2_X1 U169 ( .A1(n24), .A2(n44), .ZN(out[1]) );
  NOR2_X1 U170 ( .A1(n24), .A2(n7), .ZN(out[2]) );
  NOR2_X1 U171 ( .A1(n24), .A2(n8), .ZN(out[3]) );
  NOR2_X1 U172 ( .A1(n51), .A2(in[5]), .ZN(n30) );
  OR2_X2 U173 ( .A1(in[0]), .A2(in[1]), .ZN(n10) );
  INV_X1 U174 ( .A(in[0]), .ZN(n5) );
  INV_X1 U175 ( .A(in[1]), .ZN(n4) );
  NOR2_X1 U176 ( .A1(n36), .A2(n41), .ZN(out[40]) );
  NOR2_X1 U177 ( .A1(n44), .A2(n14), .ZN(out[41]) );
  NOR2_X1 U178 ( .A1(n43), .A2(n41), .ZN(out[42]) );
  NOR2_X1 U179 ( .A1(n8), .A2(n14), .ZN(out[43]) );
  NAND2_X1 U180 ( .A1(n45), .A2(n48), .ZN(n14) );
  NOR2_X1 U181 ( .A1(n10), .A2(n29), .ZN(out[16]) );
  NOR2_X1 U182 ( .A1(n44), .A2(n29), .ZN(out[17]) );
  NOR2_X1 U183 ( .A1(n43), .A2(n29), .ZN(out[18]) );
  NOR2_X1 U184 ( .A1(n8), .A2(n29), .ZN(out[19]) );
  NAND2_X1 U185 ( .A1(n19), .A2(n59), .ZN(n18) );
  NAND2_X1 U186 ( .A1(n63), .A2(n20), .ZN(n24) );
  NAND2_X1 U187 ( .A1(n30), .A2(n20), .ZN(n29) );
  NAND2_X1 U188 ( .A1(n65), .A2(n59), .ZN(n6) );
  NOR2_X1 U189 ( .A1(n36), .A2(n40), .ZN(out[56]) );
  NOR2_X1 U190 ( .A1(n44), .A2(n23), .ZN(out[57]) );
  NOR2_X1 U191 ( .A1(n43), .A2(n40), .ZN(out[58]) );
  NOR2_X1 U192 ( .A1(n8), .A2(n23), .ZN(out[59]) );
  NAND2_X1 U193 ( .A1(n60), .A2(n19), .ZN(n23) );
  NOR2_X1 U194 ( .A1(n21), .A2(n36), .ZN(out[52]) );
  NOR2_X1 U195 ( .A1(n44), .A2(n21), .ZN(out[53]) );
  NOR2_X1 U196 ( .A1(n43), .A2(n21), .ZN(out[54]) );
  NOR2_X1 U197 ( .A1(n8), .A2(n21), .ZN(out[55]) );
  NOR2_X1 U198 ( .A1(n26), .A2(n10), .ZN(out[4]) );
  NOR2_X1 U199 ( .A1(n44), .A2(n26), .ZN(out[5]) );
  NOR2_X1 U200 ( .A1(n43), .A2(n26), .ZN(out[6]) );
  NOR2_X1 U201 ( .A1(n8), .A2(n26), .ZN(out[7]) );
  NOR2_X1 U202 ( .A1(n10), .A2(n39), .ZN(out[24]) );
  NOR2_X1 U203 ( .A1(n44), .A2(n32), .ZN(out[25]) );
  NOR2_X1 U204 ( .A1(n43), .A2(n39), .ZN(out[26]) );
  NOR2_X1 U205 ( .A1(n8), .A2(n32), .ZN(out[27]) );
  NAND2_X1 U206 ( .A1(n42), .A2(n56), .ZN(n32) );
  NOR2_X1 U207 ( .A1(n9), .A2(n10), .ZN(out[36]) );
  NOR2_X1 U208 ( .A1(n9), .A2(n11), .ZN(out[37]) );
  NOR2_X1 U209 ( .A1(n43), .A2(n9), .ZN(out[38]) );
  NOR2_X1 U210 ( .A1(n8), .A2(n9), .ZN(out[39]) );
  NOR2_X1 U211 ( .A1(n31), .A2(n10), .ZN(out[20]) );
  NOR2_X1 U212 ( .A1(n44), .A2(n31), .ZN(out[21]) );
  NOR2_X1 U213 ( .A1(n43), .A2(n31), .ZN(out[22]) );
  NOR2_X1 U214 ( .A1(n8), .A2(n31), .ZN(out[23]) );
  NOR2_X1 U215 ( .A1(n36), .A2(n38), .ZN(out[8]) );
  NOR2_X1 U216 ( .A1(n44), .A2(n27), .ZN(out[9]) );
  NOR2_X1 U217 ( .A1(n43), .A2(n38), .ZN(out[10]) );
  NOR2_X1 U218 ( .A1(n8), .A2(n27), .ZN(out[11]) );
  NAND2_X1 U219 ( .A1(n15), .A2(n47), .ZN(n27) );
  NAND2_X1 U220 ( .A1(n55), .A2(n13), .ZN(n9) );
  NAND2_X1 U221 ( .A1(n12), .A2(n19), .ZN(n21) );
  NAND2_X1 U222 ( .A1(n62), .A2(n63), .ZN(n26) );
  NAND2_X1 U223 ( .A1(n54), .A2(n57), .ZN(n31) );
  AND2_X2 U224 ( .A1(in[5]), .A2(in[4]), .ZN(n19) );
  INV_X1 U225 ( .A(in[4]), .ZN(n2) );
  INV_X1 U226 ( .A(in[5]), .ZN(n1) );
endmodule

