/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:39:02 2025
/////////////////////////////////////////////////////////////


module fsm_dsr ( clk, rst_n, start, data_in, data_out, done );
  input [7:0] data_in;
  output [7:0] data_out;
  input clk, rst_n, start;
  output done;
  wire   N87, N88, N89, N90, N91, N92, N93, N94, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75,
         n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89,
         n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102,
         n103, n104, n105, n106, n107, n108, n109, n110, add_43_n17,
         add_43_n16, add_43_n15, add_43_n14, add_43_n13, add_43_n12,
         add_43_n11, add_43_n10, add_43_n9, add_43_n8, add_43_n7, add_43_n6,
         add_43_n5, add_43_n4, add_43_n3, add_43_n2;
  wire   [3:0] state;
  wire   [3:0] next_state;

  DFFR_X1 state_reg_3_ ( .D(next_state[3]), .CK(clk), .RN(rst_n), .Q(state[3]), 
        .QN(n57) );
  DFFR_X1 state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(rst_n), .Q(state[1]), 
        .QN(n62) );
  DFFR_X1 state_reg_2_ ( .D(next_state[2]), .CK(clk), .RN(rst_n), .Q(state[2]), 
        .QN(n64) );
  DFFR_X1 state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(rst_n), .Q(state[0]), 
        .QN(n60) );
  BUF_X1 U57 ( .A(n64), .Z(n50) );
  BUF_X1 U58 ( .A(n64), .Z(n46) );
  AND2_X1 U59 ( .A1(N87), .A2(n55), .ZN(n42) );
  BUF_X1 U60 ( .A(n57), .Z(n43) );
  INV_X1 U61 ( .A(n92), .ZN(n44) );
  BUF_X1 U62 ( .A(state[2]), .Z(n56) );
  BUF_X1 U63 ( .A(n59), .Z(n45) );
  AND4_X1 U64 ( .A1(n53), .A2(n54), .A3(state[3]), .A4(n46), .ZN(n49) );
  AND4_X1 U65 ( .A1(n58), .A2(n43), .A3(n45), .A4(n46), .ZN(n47) );
  AND4_X1 U66 ( .A1(state[1]), .A2(n46), .A3(n58), .A4(n43), .ZN(n55) );
  NAND2_X1 U67 ( .A1(n84), .A2(n91), .ZN(n48) );
  INV_X1 U68 ( .A(n85), .ZN(n87) );
  NAND2_X1 U69 ( .A1(N91), .A2(n55), .ZN(n99) );
  NAND2_X1 U70 ( .A1(n44), .A2(data_in[3]), .ZN(n101) );
  INV_X1 U71 ( .A(state[3]), .ZN(n67) );
  AND2_X1 U72 ( .A1(n84), .A2(n91), .ZN(n51) );
  NAND2_X1 U73 ( .A1(n87), .A2(n86), .ZN(n52) );
  NAND2_X1 U74 ( .A1(n87), .A2(n86), .ZN(n106) );
  BUF_X1 U75 ( .A(n62), .Z(n53) );
  BUF_X1 U76 ( .A(n60), .Z(n54) );
  NOR2_X1 U77 ( .A1(n63), .A2(n70), .ZN(next_state[2]) );
  INV_X1 U78 ( .A(n60), .ZN(n58) );
  INV_X1 U79 ( .A(n62), .ZN(n59) );
  XNOR2_X1 U80 ( .A(n58), .B(state[2]), .ZN(n86) );
  INV_X1 U81 ( .A(n64), .ZN(n61) );
  AND2_X1 U82 ( .A1(n66), .A2(n46), .ZN(n63) );
  OAI21_X1 U83 ( .B1(n68), .B2(n69), .A(n67), .ZN(n70) );
  NAND2_X1 U84 ( .A1(state[1]), .A2(n61), .ZN(n68) );
  NOR2_X1 U85 ( .A1(data_in[4]), .A2(state[0]), .ZN(n69) );
  OAI21_X1 U86 ( .B1(state[0]), .B2(n77), .A(state[1]), .ZN(n66) );
  INV_X1 U87 ( .A(data_in[2]), .ZN(n65) );
  NAND3_X1 U88 ( .A1(data_in[1]), .A2(data_in[3]), .A3(n65), .ZN(n77) );
  NAND3_X1 U89 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), .ZN(n71)
         );
  NAND3_X1 U90 ( .A1(state[3]), .A2(n71), .A3(n54), .ZN(n73) );
  INV_X1 U91 ( .A(data_in[0]), .ZN(n89) );
  NAND3_X1 U92 ( .A1(n89), .A2(n53), .A3(n58), .ZN(n72) );
  OAI33_X1 U93 ( .A1(n73), .A2(n56), .A3(n45), .B1(n72), .B2(n56), .B3(
        state[3]), .ZN(next_state[3]) );
  NOR2_X1 U94 ( .A1(n61), .A2(data_in[0]), .ZN(n76) );
  INV_X1 U95 ( .A(data_in[7]), .ZN(n74) );
  OAI22_X1 U96 ( .A1(n61), .A2(n59), .B1(state[1]), .B2(n74), .ZN(n75) );
  OAI33_X1 U97 ( .A1(n76), .A2(n54), .A3(n83), .B1(n75), .B2(state[0]), .B3(
        state[3]), .ZN(next_state[1]) );
  OAI33_X1 U98 ( .A1(n46), .A2(data_in[7]), .A3(state[0]), .B1(start), .B2(
        state[1]), .B3(state[2]), .ZN(n81) );
  INV_X1 U99 ( .A(n77), .ZN(n79) );
  AOI22_X1 U100 ( .A1(n61), .A2(n59), .B1(n50), .B2(state[0]), .ZN(n78) );
  OAI211_X1 U101 ( .C1(n79), .C2(n53), .A(n43), .B(n78), .ZN(n80) );
  NOR2_X1 U102 ( .A1(n80), .A2(n81), .ZN(next_state[0]) );
  NAND2_X1 U103 ( .A1(n59), .A2(n57), .ZN(n85) );
  NAND2_X1 U104 ( .A1(state[2]), .A2(n58), .ZN(n82) );
  NOR2_X1 U105 ( .A1(n85), .A2(n82), .ZN(done) );
  INV_X1 U106 ( .A(n82), .ZN(n84) );
  NAND2_X1 U107 ( .A1(n62), .A2(n57), .ZN(n83) );
  INV_X1 U108 ( .A(n83), .ZN(n91) );
  NAND2_X1 U109 ( .A1(n84), .A2(n91), .ZN(n107) );
  INV_X1 U110 ( .A(n106), .ZN(n88) );
  OAI33_X1 U111 ( .A1(n42), .A2(data_in[0]), .A3(n51), .B1(n89), .B2(n88), 
        .B3(n42), .ZN(n90) );
  INV_X1 U112 ( .A(n90), .ZN(data_out[0]) );
  MUX2_X1 U113 ( .A(n107), .B(n52), .S(data_in[1]), .Z(n94) );
  NAND3_X1 U114 ( .A1(n56), .A2(n54), .A3(n91), .ZN(n92) );
  INV_X1 U115 ( .A(n92), .ZN(n108) );
  AOI221_X1 U116 ( .B1(N88), .B2(n55), .C1(data_in[0]), .C2(n108), .A(n49), 
        .ZN(n93) );
  NAND2_X1 U117 ( .A1(n93), .A2(n94), .ZN(data_out[1]) );
  MUX2_X1 U118 ( .A(n48), .B(n52), .S(data_in[2]), .Z(n96) );
  AOI221_X1 U119 ( .B1(N89), .B2(n47), .C1(data_in[1]), .C2(n108), .A(n49), 
        .ZN(n95) );
  NAND2_X1 U120 ( .A1(n95), .A2(n96), .ZN(data_out[2]) );
  MUX2_X1 U121 ( .A(n48), .B(n52), .S(data_in[3]), .Z(n98) );
  AOI221_X1 U122 ( .B1(N90), .B2(n47), .C1(data_in[2]), .C2(n108), .A(n49), 
        .ZN(n97) );
  NAND2_X1 U123 ( .A1(n97), .A2(n98), .ZN(data_out[3]) );
  MUX2_X1 U124 ( .A(n107), .B(n52), .S(data_in[4]), .Z(n100) );
  NAND3_X1 U125 ( .A1(n100), .A2(n101), .A3(n99), .ZN(data_out[4]) );
  MUX2_X1 U126 ( .A(n48), .B(n52), .S(data_in[5]), .Z(n103) );
  AOI221_X1 U127 ( .B1(N92), .B2(n47), .C1(data_in[4]), .C2(n44), .A(n49), 
        .ZN(n102) );
  NAND2_X1 U128 ( .A1(n102), .A2(n103), .ZN(data_out[5]) );
  MUX2_X1 U129 ( .A(n48), .B(n52), .S(data_in[6]), .Z(n105) );
  AOI221_X1 U130 ( .B1(N93), .B2(n47), .C1(data_in[5]), .C2(n44), .A(n49), 
        .ZN(n104) );
  NAND2_X1 U131 ( .A1(n104), .A2(n105), .ZN(data_out[6]) );
  MUX2_X1 U132 ( .A(n107), .B(n106), .S(data_in[7]), .Z(n110) );
  AOI221_X1 U133 ( .B1(N94), .B2(n47), .C1(data_in[6]), .C2(n44), .A(n49), 
        .ZN(n109) );
  NAND2_X1 U134 ( .A1(n109), .A2(n110), .ZN(data_out[7]) );
  NAND2_X1 add_43_U25 ( .A1(data_in[1]), .A2(data_in[0]), .ZN(add_43_n17) );
  XNOR2_X1 add_43_U24 ( .A(add_43_n17), .B(data_in[2]), .ZN(N89) );
  NAND3_X1 add_43_U23 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), 
        .ZN(add_43_n16) );
  XNOR2_X1 add_43_U22 ( .A(add_43_n16), .B(data_in[3]), .ZN(N90) );
  NAND4_X1 add_43_U21 ( .A1(data_in[3]), .A2(data_in[2]), .A3(data_in[1]), 
        .A4(data_in[0]), .ZN(add_43_n15) );
  XNOR2_X1 add_43_U20 ( .A(add_43_n15), .B(data_in[4]), .ZN(N91) );
  NAND3_X1 add_43_U19 ( .A1(data_in[4]), .A2(data_in[3]), .A3(data_in[0]), 
        .ZN(add_43_n13) );
  NAND2_X1 add_43_U18 ( .A1(data_in[1]), .A2(data_in[2]), .ZN(add_43_n14) );
  NAND3_X1 add_43_U17 ( .A1(data_in[1]), .A2(data_in[2]), .A3(data_in[0]), 
        .ZN(add_43_n9) );
  NAND3_X1 add_43_U16 ( .A1(data_in[4]), .A2(data_in[5]), .A3(data_in[3]), 
        .ZN(add_43_n10) );
  NAND2_X1 add_43_U15 ( .A1(data_in[1]), .A2(data_in[0]), .ZN(add_43_n5) );
  NAND2_X1 add_43_U14 ( .A1(data_in[3]), .A2(data_in[2]), .ZN(add_43_n6) );
  NAND2_X1 add_43_U13 ( .A1(add_43_n3), .A2(add_43_n4), .ZN(add_43_n2) );
  XNOR2_X1 add_43_U12 ( .A(add_43_n2), .B(data_in[7]), .ZN(N94) );
  INV_X1 add_43_U11 ( .A(data_in[6]), .ZN(add_43_n7) );
  INV_X1 add_43_U10 ( .A(data_in[5]), .ZN(add_43_n11) );
  NOR2_X1 add_43_U9 ( .A1(add_43_n13), .A2(add_43_n14), .ZN(add_43_n12) );
  NOR2_X1 add_43_U8 ( .A1(add_43_n9), .A2(add_43_n10), .ZN(add_43_n8) );
  NOR2_X1 add_43_U7 ( .A1(add_43_n5), .A2(add_43_n6), .ZN(add_43_n4) );
  AND3_X1 add_43_U6 ( .A1(data_in[5]), .A2(data_in[6]), .A3(data_in[4]), .ZN(
        add_43_n3) );
  INV_X1 add_43_U5 ( .A(data_in[0]), .ZN(N87) );
  XNOR2_X1 add_43_U4 ( .A(add_43_n7), .B(add_43_n8), .ZN(N93) );
  XNOR2_X1 add_43_U3 ( .A(add_43_n11), .B(add_43_n12), .ZN(N92) );
  XOR2_X1 add_43_U2 ( .A(data_in[1]), .B(data_in[0]), .Z(N88) );
endmodule

