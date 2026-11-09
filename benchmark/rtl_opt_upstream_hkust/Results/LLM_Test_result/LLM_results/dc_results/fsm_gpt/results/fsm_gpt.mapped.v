/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:29:56 2025
/////////////////////////////////////////////////////////////


module fsm_gpt ( clk, rst_n, start, data_in, data_out, done );
  input [7:0] data_in;
  output [7:0] data_out;
  input clk, rst_n, start;
  output done;
  wire   N161, N162, N163, N164, N165, N166, N167, N168, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136,
         n137, n138, n139, n140, n141, n142, n143, n144, n145, n146, n147,
         n148, n149, n150, n151, n152, n153, n154, n155, n156, n157, n158,
         n159, n160, n161, n162, n163, n164, n165, n166, n167, n168,
         add_42_n17, add_42_n16, add_42_n15, add_42_n14, add_42_n13,
         add_42_n12, add_42_n11, add_42_n10, add_42_n9, add_42_n8, add_42_n7,
         add_42_n6, add_42_n5, add_42_n4, add_42_n3, add_42_n2;
  wire   [8:0] state;
  wire   [8:0] next_state;

  DFFS_X1 state_reg_0_ ( .D(next_state[0]), .CK(clk), .SN(rst_n), .Q(state[0]), 
        .QN(n98) );
  DFFR_X1 state_reg_3_ ( .D(next_state[3]), .CK(clk), .RN(rst_n), .Q(state[3]), 
        .QN(n104) );
  DFFR_X1 state_reg_7_ ( .D(n75), .CK(clk), .RN(rst_n), .Q(n84), .QN(n96) );
  DFFR_X1 state_reg_6_ ( .D(next_state[6]), .CK(clk), .RN(rst_n), .Q(state[6]), 
        .QN(n94) );
  DFFR_X1 state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(rst_n), .Q(state[1]), 
        .QN(n95) );
  DFFR_X1 state_reg_5_ ( .D(next_state[5]), .CK(clk), .RN(rst_n), .Q(state[5]), 
        .QN(n102) );
  DFFR_X1 state_reg_8_ ( .D(next_state[8]), .CK(clk), .RN(rst_n), .Q(state[8]), 
        .QN(n105) );
  DFFR_X1 state_reg_2_ ( .D(next_state[2]), .CK(clk), .RN(rst_n), .Q(state[2]), 
        .QN(n103) );
  DFFR_X1 state_reg_4_ ( .D(n78), .CK(clk), .RN(rst_n), .Q(state[4]), .QN(n101) );
  BUF_X2 U78 ( .A(n105), .Z(n74) );
  BUF_X1 U79 ( .A(n102), .Z(n93) );
  AND2_X1 U80 ( .A1(state[3]), .A2(n103), .ZN(n59) );
  AND2_X1 U81 ( .A1(N161), .A2(n77), .ZN(n60) );
  AND2_X1 U82 ( .A1(n79), .A2(n63), .ZN(n61) );
  CLKBUF_X1 U83 ( .A(n120), .Z(n62) );
  AND3_X1 U84 ( .A1(n93), .A2(n74), .A3(state[4]), .ZN(n63) );
  AND4_X1 U85 ( .A1(n96), .A2(n105), .A3(n101), .A4(n102), .ZN(n67) );
  AND4_X2 U86 ( .A1(n96), .A2(n105), .A3(n101), .A4(n102), .ZN(n100) );
  MUX2_X1 U87 ( .A(n81), .B(n83), .S(n113), .Z(n160) );
  AND4_X1 U88 ( .A1(n99), .A2(n87), .A3(n93), .A4(n86), .ZN(n64) );
  CLKBUF_X1 U89 ( .A(n98), .Z(n65) );
  AND2_X2 U90 ( .A1(n64), .A2(n71), .ZN(n66) );
  NAND2_X1 U91 ( .A1(n128), .A2(n59), .ZN(n132) );
  NAND2_X1 U92 ( .A1(n123), .A2(n122), .ZN(n124) );
  AND3_X1 U93 ( .A1(n59), .A2(n146), .A3(n67), .ZN(n78) );
  NAND2_X1 U94 ( .A1(N165), .A2(n77), .ZN(n161) );
  NAND2_X1 U95 ( .A1(data_in[3]), .A2(n61), .ZN(n159) );
  NAND2_X1 U96 ( .A1(n125), .A2(n124), .ZN(n133) );
  NAND2_X1 U97 ( .A1(n64), .A2(n71), .ZN(n68) );
  AND2_X1 U98 ( .A1(n91), .A2(n148), .ZN(n69) );
  AND2_X1 U99 ( .A1(n91), .A2(n148), .ZN(n81) );
  INV_X1 U100 ( .A(state[1]), .ZN(n70) );
  INV_X1 U101 ( .A(n80), .ZN(n71) );
  BUF_X1 U102 ( .A(n121), .Z(n80) );
  AND2_X1 U103 ( .A1(n107), .A2(n108), .ZN(n72) );
  AND2_X1 U104 ( .A1(n108), .A2(n107), .ZN(n73) );
  AND2_X1 U105 ( .A1(n108), .A2(n107), .ZN(n79) );
  INV_X1 U106 ( .A(n69), .ZN(n158) );
  AND2_X1 U107 ( .A1(n111), .A2(n73), .ZN(n75) );
  AND2_X1 U108 ( .A1(n63), .A2(n72), .ZN(n76) );
  BUF_X1 U109 ( .A(n166), .Z(n83) );
  AND3_X2 U110 ( .A1(n59), .A2(n146), .A3(n100), .ZN(n77) );
  NOR2_X1 U111 ( .A1(n80), .A2(n62), .ZN(n125) );
  CLKBUF_X1 U112 ( .A(n91), .Z(n82) );
  INV_X1 U113 ( .A(n84), .ZN(n85) );
  BUF_X1 U114 ( .A(n101), .Z(n86) );
  INV_X1 U115 ( .A(state[2]), .ZN(n87) );
  CLKBUF_X1 U116 ( .A(n143), .Z(n88) );
  INV_X1 U117 ( .A(n94), .ZN(n89) );
  CLKBUF_X1 U118 ( .A(n104), .Z(n90) );
  NAND4_X1 U119 ( .A1(n115), .A2(n100), .A3(n90), .A4(state[2]), .ZN(n91) );
  CLKBUF_X1 U120 ( .A(n89), .Z(n92) );
  NOR2_X1 U121 ( .A1(n74), .A2(n136), .ZN(n138) );
  OAI21_X1 U122 ( .B1(n141), .B2(n140), .A(n139), .ZN(next_state[0]) );
  NOR2_X1 U123 ( .A1(n138), .A2(n137), .ZN(n139) );
  CLKBUF_X1 U124 ( .A(n166), .Z(n97) );
  NAND2_X1 U125 ( .A1(n135), .A2(n134), .ZN(n140) );
  NAND4_X1 U126 ( .A1(n131), .A2(n68), .A3(n132), .A4(n133), .ZN(n141) );
  AND3_X1 U127 ( .A1(state[8]), .A2(n104), .A3(n95), .ZN(n99) );
  NOR2_X1 U128 ( .A1(start), .A2(n143), .ZN(n137) );
  AND2_X1 U129 ( .A1(n143), .A2(n106), .ZN(n131) );
  NOR2_X1 U130 ( .A1(n127), .A2(n126), .ZN(n128) );
  NAND4_X1 U131 ( .A1(n115), .A2(n67), .A3(state[2]), .A4(n90), .ZN(n106) );
  NAND3_X1 U132 ( .A1(n93), .A2(n74), .A3(state[4]), .ZN(n122) );
  INV_X1 U133 ( .A(state[3]), .ZN(n129) );
  NAND3_X1 U134 ( .A1(n104), .A2(n95), .A3(n103), .ZN(n120) );
  INV_X1 U135 ( .A(n120), .ZN(n107) );
  NAND3_X1 U136 ( .A1(n96), .A2(n98), .A3(n94), .ZN(n121) );
  INV_X1 U137 ( .A(n121), .ZN(n108) );
  NAND2_X1 U138 ( .A1(n79), .A2(n63), .ZN(n151) );
  INV_X1 U139 ( .A(data_in[7]), .ZN(n116) );
  NOR2_X1 U140 ( .A1(n151), .A2(n116), .ZN(next_state[5]) );
  NAND3_X1 U141 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), .ZN(n136)
         );
  INV_X1 U142 ( .A(n136), .ZN(n110) );
  NOR3_X1 U143 ( .A1(n89), .A2(state[2]), .A3(n95), .ZN(n109) );
  NAND4_X1 U144 ( .A1(n109), .A2(n67), .A3(n129), .A4(n65), .ZN(n134) );
  OAI22_X1 U145 ( .A1(n68), .A2(n110), .B1(n134), .B2(data_in[0]), .ZN(
        next_state[8]) );
  NAND3_X1 U146 ( .A1(state[5]), .A2(n86), .A3(n74), .ZN(n123) );
  INV_X1 U147 ( .A(n123), .ZN(n111) );
  NAND2_X1 U148 ( .A1(n111), .A2(n73), .ZN(n166) );
  INV_X1 U149 ( .A(data_in[4]), .ZN(n113) );
  NOR3_X1 U150 ( .A1(state[0]), .A2(state[2]), .A3(state[3]), .ZN(n112) );
  NAND4_X1 U151 ( .A1(n86), .A2(n74), .A3(n85), .A4(n93), .ZN(n127) );
  NAND4_X1 U152 ( .A1(n92), .A2(n70), .A3(n112), .A4(n100), .ZN(n135) );
  INV_X1 U153 ( .A(data_in[0]), .ZN(n149) );
  OAI22_X1 U154 ( .A1(n113), .A2(n135), .B1(n134), .B2(n149), .ZN(
        next_state[2]) );
  INV_X1 U155 ( .A(data_in[2]), .ZN(n114) );
  NAND3_X1 U156 ( .A1(data_in[1]), .A2(data_in[3]), .A3(n114), .ZN(n119) );
  INV_X1 U157 ( .A(n119), .ZN(n118) );
  NOR3_X1 U158 ( .A1(state[1]), .A2(state[6]), .A3(state[0]), .ZN(n115) );
  NAND3_X1 U159 ( .A1(n72), .A2(n116), .A3(n63), .ZN(n117) );
  OAI221_X1 U160 ( .B1(n91), .B2(n118), .C1(data_in[4]), .C2(n135), .A(n117), 
        .ZN(next_state[6]) );
  NOR2_X1 U161 ( .A1(n82), .A2(n119), .ZN(next_state[3]) );
  NAND3_X1 U162 ( .A1(n95), .A2(n94), .A3(n98), .ZN(n126) );
  INV_X1 U163 ( .A(n126), .ZN(n146) );
  NAND2_X1 U164 ( .A1(n104), .A2(n103), .ZN(n144) );
  NOR4_X1 U165 ( .A1(n144), .A2(state[1]), .A3(state[6]), .A4(n98), .ZN(n130)
         );
  NAND2_X1 U166 ( .A1(n100), .A2(n130), .ZN(n143) );
  INV_X1 U167 ( .A(start), .ZN(n142) );
  NOR2_X1 U168 ( .A1(n88), .A2(n142), .ZN(next_state[1]) );
  NOR4_X1 U169 ( .A1(state[5]), .A2(state[4]), .A3(state[8]), .A4(n96), .ZN(
        n147) );
  INV_X1 U170 ( .A(n144), .ZN(n145) );
  NAND3_X1 U171 ( .A1(n145), .A2(n146), .A3(n147), .ZN(n148) );
  INV_X1 U172 ( .A(n148), .ZN(done) );
  OAI33_X1 U173 ( .A1(n158), .A2(n60), .A3(n149), .B1(n60), .B2(data_in[0]), 
        .B3(n75), .ZN(n150) );
  INV_X1 U174 ( .A(n150), .ZN(data_out[0]) );
  AOI221_X1 U175 ( .B1(data_in[0]), .B2(n76), .C1(N162), .C2(n78), .A(n66), 
        .ZN(n153) );
  MUX2_X1 U176 ( .A(n83), .B(n69), .S(data_in[1]), .Z(n152) );
  NAND2_X1 U177 ( .A1(n152), .A2(n153), .ZN(data_out[1]) );
  AOI221_X1 U178 ( .B1(data_in[1]), .B2(n76), .C1(N163), .C2(n77), .A(n66), 
        .ZN(n155) );
  MUX2_X1 U179 ( .A(n83), .B(n69), .S(data_in[2]), .Z(n154) );
  NAND2_X1 U180 ( .A1(n154), .A2(n155), .ZN(data_out[2]) );
  AOI221_X1 U181 ( .B1(data_in[2]), .B2(n76), .C1(N164), .C2(n78), .A(n66), 
        .ZN(n157) );
  MUX2_X1 U182 ( .A(n83), .B(n81), .S(data_in[3]), .Z(n156) );
  NAND2_X1 U183 ( .A1(n156), .A2(n157), .ZN(data_out[3]) );
  NAND3_X1 U184 ( .A1(n160), .A2(n161), .A3(n159), .ZN(data_out[4]) );
  AOI221_X1 U185 ( .B1(data_in[4]), .B2(n76), .C1(N166), .C2(n77), .A(n66), 
        .ZN(n163) );
  MUX2_X1 U186 ( .A(n97), .B(n69), .S(data_in[5]), .Z(n162) );
  NAND2_X1 U187 ( .A1(n162), .A2(n163), .ZN(data_out[5]) );
  AOI221_X1 U188 ( .B1(data_in[5]), .B2(n61), .C1(N167), .C2(n78), .A(n66), 
        .ZN(n165) );
  MUX2_X1 U189 ( .A(n97), .B(n81), .S(data_in[6]), .Z(n164) );
  NAND2_X1 U190 ( .A1(n164), .A2(n165), .ZN(data_out[6]) );
  AOI221_X1 U191 ( .B1(data_in[6]), .B2(n61), .C1(N168), .C2(n77), .A(n66), 
        .ZN(n168) );
  MUX2_X1 U192 ( .A(n97), .B(n81), .S(data_in[7]), .Z(n167) );
  NAND2_X1 U193 ( .A1(n167), .A2(n168), .ZN(data_out[7]) );
  NAND2_X1 add_42_U25 ( .A1(data_in[1]), .A2(data_in[0]), .ZN(add_42_n17) );
  XNOR2_X1 add_42_U24 ( .A(add_42_n17), .B(data_in[2]), .ZN(N163) );
  NAND3_X1 add_42_U23 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), 
        .ZN(add_42_n16) );
  XNOR2_X1 add_42_U22 ( .A(add_42_n16), .B(data_in[3]), .ZN(N164) );
  NAND4_X1 add_42_U21 ( .A1(data_in[3]), .A2(data_in[2]), .A3(data_in[1]), 
        .A4(data_in[0]), .ZN(add_42_n15) );
  XNOR2_X1 add_42_U20 ( .A(add_42_n15), .B(data_in[4]), .ZN(N165) );
  NAND3_X1 add_42_U19 ( .A1(data_in[4]), .A2(data_in[3]), .A3(data_in[0]), 
        .ZN(add_42_n13) );
  NAND2_X1 add_42_U18 ( .A1(data_in[1]), .A2(data_in[2]), .ZN(add_42_n14) );
  NAND3_X1 add_42_U17 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), 
        .ZN(add_42_n9) );
  NAND3_X1 add_42_U16 ( .A1(data_in[4]), .A2(data_in[5]), .A3(data_in[3]), 
        .ZN(add_42_n10) );
  NAND2_X1 add_42_U15 ( .A1(data_in[1]), .A2(data_in[0]), .ZN(add_42_n5) );
  NAND2_X1 add_42_U14 ( .A1(data_in[3]), .A2(data_in[2]), .ZN(add_42_n6) );
  NAND2_X1 add_42_U13 ( .A1(add_42_n3), .A2(add_42_n4), .ZN(add_42_n2) );
  XNOR2_X1 add_42_U12 ( .A(add_42_n2), .B(data_in[7]), .ZN(N168) );
  INV_X1 add_42_U11 ( .A(data_in[6]), .ZN(add_42_n7) );
  INV_X1 add_42_U10 ( .A(data_in[5]), .ZN(add_42_n11) );
  NOR2_X1 add_42_U9 ( .A1(add_42_n13), .A2(add_42_n14), .ZN(add_42_n12) );
  NOR2_X1 add_42_U8 ( .A1(add_42_n9), .A2(add_42_n10), .ZN(add_42_n8) );
  NOR2_X1 add_42_U7 ( .A1(add_42_n5), .A2(add_42_n6), .ZN(add_42_n4) );
  AND3_X1 add_42_U6 ( .A1(data_in[5]), .A2(data_in[6]), .A3(data_in[4]), .ZN(
        add_42_n3) );
  INV_X1 add_42_U5 ( .A(data_in[0]), .ZN(N161) );
  XNOR2_X1 add_42_U4 ( .A(add_42_n11), .B(add_42_n12), .ZN(N166) );
  XNOR2_X1 add_42_U3 ( .A(add_42_n7), .B(add_42_n8), .ZN(N167) );
  XOR2_X1 add_42_U2 ( .A(data_in[1]), .B(data_in[0]), .Z(N162) );
endmodule

