/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:06:15 2025
/////////////////////////////////////////////////////////////


module fsm_ds ( clk, rst_n, start, data_in, data_out, done );
  input [7:0] data_in;
  output [7:0] data_out;
  input clk, rst_n, start;
  output done;
  wire   N91, N92, N93, N94, N95, N96, N97, N98, n66, n67, n68, n69, n70, n71,
         n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, add_41_n17, add_41_n16,
         add_41_n15, add_41_n14, add_41_n13, add_41_n12, add_41_n11,
         add_41_n10, add_41_n9, add_41_n8, add_41_n7, add_41_n6, add_41_n5,
         add_41_n4, add_41_n3, add_41_n2;
  wire   [3:0] state;
  wire   [3:0] next_state;

  DFFR_X1 state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(rst_n), .Q(state[0]), 
        .QN(n86) );
  DFFR_X1 state_reg_2_ ( .D(next_state[2]), .CK(clk), .RN(rst_n), .Q(state[2]), 
        .QN(n88) );
  DFFR_X1 state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(rst_n), .Q(state[1]), 
        .QN(n85) );
  DFFR_X1 state_reg_3_ ( .D(next_state[3]), .CK(clk), .RN(rst_n), .Q(state[3]), 
        .QN(n87) );
  BUF_X1 U82 ( .A(n86), .Z(n83) );
  NAND3_X2 U83 ( .A1(n68), .A2(n85), .A3(state[2]), .ZN(n82) );
  BUF_X2 U84 ( .A(n88), .Z(n79) );
  MUX2_X1 U85 ( .A(n81), .B(n82), .S(n95), .Z(n128) );
  AND3_X1 U86 ( .A1(state[3]), .A2(n85), .A3(n111), .ZN(n66) );
  AND3_X1 U87 ( .A1(state[3]), .A2(n85), .A3(n111), .ZN(n75) );
  AND4_X1 U88 ( .A1(state[2]), .A2(n83), .A3(n85), .A4(n87), .ZN(n74) );
  INV_X1 U89 ( .A(n70), .ZN(n67) );
  AND2_X1 U90 ( .A1(state[0]), .A2(n87), .ZN(n68) );
  OR2_X2 U91 ( .A1(n107), .A2(n69), .ZN(n81) );
  NAND2_X1 U92 ( .A1(n87), .A2(state[1]), .ZN(n69) );
  INV_X1 U93 ( .A(state[1]), .ZN(n70) );
  AND2_X1 U94 ( .A1(state[3]), .A2(state[2]), .ZN(n71) );
  AND2_X1 U95 ( .A1(state[2]), .A2(n85), .ZN(n72) );
  NOR3_X1 U96 ( .A1(n104), .A2(n72), .A3(n71), .ZN(n105) );
  AND3_X1 U97 ( .A1(state[1]), .A2(n79), .A3(n77), .ZN(n73) );
  NAND2_X1 U98 ( .A1(n108), .A2(n109), .ZN(data_out[0]) );
  NAND2_X1 U99 ( .A1(N91), .A2(n73), .ZN(n109) );
  NAND2_X1 U100 ( .A1(N95), .A2(n73), .ZN(n120) );
  NAND2_X1 U101 ( .A1(n74), .A2(data_in[3]), .ZN(n118) );
  BUF_X1 U102 ( .A(state[2]), .Z(n76) );
  AND2_X1 U103 ( .A1(state[0]), .A2(n87), .ZN(n77) );
  NOR2_X1 U104 ( .A1(n107), .A2(state[3]), .ZN(n78) );
  AND3_X1 U105 ( .A1(state[1]), .A2(n79), .A3(n68), .ZN(n80) );
  NAND2_X1 U106 ( .A1(n78), .A2(n67), .ZN(n125) );
  XNOR2_X1 U107 ( .A(state[0]), .B(n88), .ZN(n107) );
  INV_X1 U108 ( .A(n86), .ZN(n84) );
  INV_X1 U109 ( .A(data_in[0]), .ZN(n92) );
  NAND4_X1 U110 ( .A1(n84), .A2(n79), .A3(n85), .A4(n92), .ZN(n91) );
  NAND2_X1 U111 ( .A1(n88), .A2(n86), .ZN(n110) );
  NAND4_X1 U112 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), .A4(n85), 
        .ZN(n89) );
  OAI21_X1 U113 ( .B1(n89), .B2(n110), .A(state[3]), .ZN(n90) );
  NAND2_X1 U114 ( .A1(n91), .A2(n90), .ZN(next_state[3]) );
  OAI22_X1 U115 ( .A1(n83), .A2(n92), .B1(n79), .B2(data_in[7]), .ZN(n93) );
  NAND3_X1 U116 ( .A1(n93), .A2(n87), .A3(n85), .ZN(n94) );
  NAND3_X1 U117 ( .A1(n76), .A2(n85), .A3(n77), .ZN(n126) );
  OAI211_X1 U118 ( .C1(n77), .C2(n70), .A(n94), .B(n126), .ZN(next_state[1])
         );
  INV_X1 U119 ( .A(data_in[7]), .ZN(n95) );
  OAI21_X1 U120 ( .B1(state[3]), .B2(n95), .A(n83), .ZN(n96) );
  OAI221_X1 U121 ( .B1(state[3]), .B2(n85), .C1(state[3]), .C2(n76), .A(n96), 
        .ZN(n101) );
  INV_X1 U122 ( .A(data_in[2]), .ZN(n97) );
  NAND3_X1 U123 ( .A1(data_in[1]), .A2(data_in[3]), .A3(n97), .ZN(n103) );
  INV_X1 U124 ( .A(n103), .ZN(n99) );
  NOR2_X1 U125 ( .A1(state[3]), .A2(n110), .ZN(n98) );
  OAI221_X1 U126 ( .B1(n99), .B2(n85), .C1(start), .C2(n67), .A(n98), .ZN(n100) );
  NAND2_X1 U127 ( .A1(n101), .A2(n100), .ZN(next_state[0]) );
  NOR3_X1 U128 ( .A1(n85), .A2(state[3]), .A3(state[2]), .ZN(n102) );
  OAI21_X1 U129 ( .B1(n84), .B2(n103), .A(n102), .ZN(n106) );
  NOR3_X1 U130 ( .A1(n79), .A2(n84), .A3(data_in[4]), .ZN(n104) );
  NAND2_X1 U131 ( .A1(n105), .A2(n106), .ZN(next_state[2]) );
  NOR4_X1 U132 ( .A1(n70), .A2(n83), .A3(n79), .A4(state[3]), .ZN(done) );
  MUX2_X1 U133 ( .A(n126), .B(n125), .S(data_in[0]), .Z(n108) );
  MUX2_X1 U134 ( .A(n82), .B(n81), .S(data_in[1]), .Z(n113) );
  INV_X1 U135 ( .A(n110), .ZN(n111) );
  AOI221_X1 U136 ( .B1(N92), .B2(n80), .C1(data_in[0]), .C2(n74), .A(n66), 
        .ZN(n112) );
  NAND2_X1 U137 ( .A1(n112), .A2(n113), .ZN(data_out[1]) );
  MUX2_X1 U138 ( .A(n82), .B(n81), .S(data_in[2]), .Z(n115) );
  AOI221_X1 U139 ( .B1(N93), .B2(n80), .C1(data_in[1]), .C2(n74), .A(n66), 
        .ZN(n114) );
  NAND2_X1 U140 ( .A1(n114), .A2(n115), .ZN(data_out[2]) );
  MUX2_X1 U141 ( .A(n82), .B(n81), .S(data_in[3]), .Z(n117) );
  AOI221_X1 U142 ( .B1(N94), .B2(n80), .C1(data_in[2]), .C2(n74), .A(n75), 
        .ZN(n116) );
  NAND2_X1 U143 ( .A1(n116), .A2(n117), .ZN(data_out[3]) );
  MUX2_X1 U144 ( .A(n82), .B(n125), .S(data_in[4]), .Z(n119) );
  NAND3_X1 U145 ( .A1(n119), .A2(n120), .A3(n118), .ZN(data_out[4]) );
  MUX2_X1 U146 ( .A(n82), .B(n81), .S(data_in[5]), .Z(n122) );
  AOI221_X1 U147 ( .B1(N96), .B2(n80), .C1(data_in[4]), .C2(n74), .A(n66), 
        .ZN(n121) );
  NAND2_X1 U148 ( .A1(n121), .A2(n122), .ZN(data_out[5]) );
  MUX2_X1 U149 ( .A(n82), .B(n81), .S(data_in[6]), .Z(n124) );
  AOI221_X1 U150 ( .B1(N97), .B2(n80), .C1(n74), .C2(data_in[5]), .A(n75), 
        .ZN(n123) );
  NAND2_X1 U151 ( .A1(n123), .A2(n124), .ZN(data_out[6]) );
  AOI221_X1 U152 ( .B1(N98), .B2(n73), .C1(n74), .C2(data_in[6]), .A(n75), 
        .ZN(n127) );
  NAND2_X1 U153 ( .A1(n128), .A2(n127), .ZN(data_out[7]) );
  NAND2_X1 add_41_U25 ( .A1(data_in[1]), .A2(data_in[0]), .ZN(add_41_n17) );
  XNOR2_X1 add_41_U24 ( .A(add_41_n17), .B(data_in[2]), .ZN(N93) );
  NAND3_X1 add_41_U23 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), 
        .ZN(add_41_n16) );
  XNOR2_X1 add_41_U22 ( .A(add_41_n16), .B(data_in[3]), .ZN(N94) );
  NAND4_X1 add_41_U21 ( .A1(data_in[3]), .A2(data_in[2]), .A3(data_in[1]), 
        .A4(data_in[0]), .ZN(add_41_n15) );
  XNOR2_X1 add_41_U20 ( .A(add_41_n15), .B(data_in[4]), .ZN(N95) );
  NAND3_X1 add_41_U19 ( .A1(data_in[4]), .A2(data_in[3]), .A3(data_in[0]), 
        .ZN(add_41_n13) );
  NAND2_X1 add_41_U18 ( .A1(data_in[1]), .A2(data_in[2]), .ZN(add_41_n14) );
  NAND3_X1 add_41_U17 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), 
        .ZN(add_41_n9) );
  NAND3_X1 add_41_U16 ( .A1(data_in[4]), .A2(data_in[5]), .A3(data_in[3]), 
        .ZN(add_41_n10) );
  NAND2_X1 add_41_U15 ( .A1(data_in[1]), .A2(data_in[0]), .ZN(add_41_n5) );
  NAND2_X1 add_41_U14 ( .A1(data_in[3]), .A2(data_in[2]), .ZN(add_41_n6) );
  NAND2_X1 add_41_U13 ( .A1(add_41_n3), .A2(add_41_n4), .ZN(add_41_n2) );
  XNOR2_X1 add_41_U12 ( .A(add_41_n2), .B(data_in[7]), .ZN(N98) );
  INV_X1 add_41_U11 ( .A(data_in[6]), .ZN(add_41_n7) );
  INV_X1 add_41_U10 ( .A(data_in[5]), .ZN(add_41_n11) );
  NOR2_X1 add_41_U9 ( .A1(add_41_n13), .A2(add_41_n14), .ZN(add_41_n12) );
  NOR2_X1 add_41_U8 ( .A1(add_41_n9), .A2(add_41_n10), .ZN(add_41_n8) );
  NOR2_X1 add_41_U7 ( .A1(add_41_n5), .A2(add_41_n6), .ZN(add_41_n4) );
  AND3_X1 add_41_U6 ( .A1(data_in[5]), .A2(data_in[6]), .A3(data_in[4]), .ZN(
        add_41_n3) );
  INV_X1 add_41_U5 ( .A(data_in[0]), .ZN(N91) );
  XNOR2_X1 add_41_U4 ( .A(add_41_n7), .B(add_41_n8), .ZN(N97) );
  XNOR2_X1 add_41_U3 ( .A(add_41_n11), .B(add_41_n12), .ZN(N96) );
  XOR2_X1 add_41_U2 ( .A(data_in[1]), .B(data_in[0]), .Z(N92) );
endmodule

