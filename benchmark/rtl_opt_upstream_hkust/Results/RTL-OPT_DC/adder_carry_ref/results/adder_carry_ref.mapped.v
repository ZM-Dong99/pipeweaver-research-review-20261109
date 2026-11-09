/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 02:38:46 2025
/////////////////////////////////////////////////////////////


module adder_carry_ref ( a, b, cin, sum, cout );
  input [7:0] a;
  input [7:0] b;
  output [7:0] sum;
  input cin;
  output cout;
  wire   u_adder0_n3, u_adder0_n2, u_adder0_n1, adder_gen_1__u_adder_n5,
         adder_gen_1__u_adder_n4, adder_gen_1__u_adder_n3,
         adder_gen_1__u_adder_n2, adder_gen_1__u_adder_n1,
         adder_gen_2__u_adder_n4, adder_gen_2__u_adder_n3,
         adder_gen_2__u_adder_n2, adder_gen_2__u_adder_n1,
         adder_gen_3__u_adder_n4, adder_gen_3__u_adder_n3,
         adder_gen_3__u_adder_n2, adder_gen_3__u_adder_n1,
         adder_gen_4__u_adder_n4, adder_gen_4__u_adder_n3,
         adder_gen_4__u_adder_n2, adder_gen_4__u_adder_n1,
         adder_gen_5__u_adder_n5, adder_gen_5__u_adder_n4,
         adder_gen_5__u_adder_n3, adder_gen_5__u_adder_n2,
         adder_gen_5__u_adder_n1, adder_gen_6__u_adder_n5,
         adder_gen_6__u_adder_n4, adder_gen_6__u_adder_n3,
         adder_gen_6__u_adder_n2, adder_gen_6__u_adder_n1, u_adder1_n4,
         u_adder1_n3, u_adder1_n2, u_adder1_n1;
  wire   [6:0] c;

  OAI21_X1 u_adder0_U5 ( .B1(b[0]), .B2(a[0]), .A(cin), .ZN(u_adder0_n3) );
  NAND2_X1 u_adder0_U4 ( .A1(u_adder0_n3), .A2(u_adder0_n2), .ZN(c[0]) );
  NAND2_X1 u_adder0_U3 ( .A1(a[0]), .A2(b[0]), .ZN(u_adder0_n2) );
  XNOR2_X1 u_adder0_U2 ( .A(a[0]), .B(cin), .ZN(u_adder0_n1) );
  XNOR2_X1 u_adder0_U1 ( .A(b[0]), .B(u_adder0_n1), .ZN(sum[0]) );
  XOR2_X1 adder_gen_1__u_adder_U7 ( .A(adder_gen_1__u_adder_n3), .B(
        adder_gen_1__u_adder_n1), .Z(sum[1]) );
  INV_X1 adder_gen_1__u_adder_U6 ( .A(adder_gen_1__u_adder_n5), .ZN(c[1]) );
  XOR2_X1 adder_gen_1__u_adder_U5 ( .A(a[1]), .B(b[1]), .Z(
        adder_gen_1__u_adder_n4) );
  CLKBUF_X1 adder_gen_1__u_adder_U4 ( .A(c[0]), .Z(adder_gen_1__u_adder_n3) );
  AND2_X1 adder_gen_1__u_adder_U3 ( .A1(b[1]), .A2(a[1]), .ZN(
        adder_gen_1__u_adder_n2) );
  AOI21_X1 adder_gen_1__u_adder_U2 ( .B1(c[0]), .B2(adder_gen_1__u_adder_n4), 
        .A(adder_gen_1__u_adder_n2), .ZN(adder_gen_1__u_adder_n5) );
  XOR2_X1 adder_gen_1__u_adder_U1 ( .A(a[1]), .B(b[1]), .Z(
        adder_gen_1__u_adder_n1) );
  XOR2_X1 adder_gen_2__u_adder_U6 ( .A(adder_gen_2__u_adder_n1), .B(
        adder_gen_2__u_adder_n3), .Z(sum[2]) );
  INV_X1 adder_gen_2__u_adder_U5 ( .A(adder_gen_2__u_adder_n4), .ZN(c[2]) );
  XOR2_X1 adder_gen_2__u_adder_U4 ( .A(a[2]), .B(b[2]), .Z(
        adder_gen_2__u_adder_n3) );
  AND2_X1 adder_gen_2__u_adder_U3 ( .A1(b[2]), .A2(a[2]), .ZN(
        adder_gen_2__u_adder_n2) );
  CLKBUF_X1 adder_gen_2__u_adder_U2 ( .A(c[1]), .Z(adder_gen_2__u_adder_n1) );
  AOI21_X1 adder_gen_2__u_adder_U1 ( .B1(c[1]), .B2(adder_gen_2__u_adder_n3), 
        .A(adder_gen_2__u_adder_n2), .ZN(adder_gen_2__u_adder_n4) );
  XOR2_X1 adder_gen_3__u_adder_U6 ( .A(adder_gen_3__u_adder_n1), .B(
        adder_gen_3__u_adder_n3), .Z(sum[3]) );
  INV_X1 adder_gen_3__u_adder_U5 ( .A(adder_gen_3__u_adder_n4), .ZN(c[3]) );
  XOR2_X1 adder_gen_3__u_adder_U4 ( .A(a[3]), .B(b[3]), .Z(
        adder_gen_3__u_adder_n3) );
  AND2_X1 adder_gen_3__u_adder_U3 ( .A1(b[3]), .A2(a[3]), .ZN(
        adder_gen_3__u_adder_n2) );
  CLKBUF_X1 adder_gen_3__u_adder_U2 ( .A(c[2]), .Z(adder_gen_3__u_adder_n1) );
  AOI21_X1 adder_gen_3__u_adder_U1 ( .B1(c[2]), .B2(adder_gen_3__u_adder_n3), 
        .A(adder_gen_3__u_adder_n2), .ZN(adder_gen_3__u_adder_n4) );
  XOR2_X1 adder_gen_4__u_adder_U6 ( .A(adder_gen_4__u_adder_n3), .B(
        adder_gen_4__u_adder_n2), .Z(sum[4]) );
  INV_X1 adder_gen_4__u_adder_U5 ( .A(adder_gen_4__u_adder_n4), .ZN(c[4]) );
  CLKBUF_X1 adder_gen_4__u_adder_U4 ( .A(c[3]), .Z(adder_gen_4__u_adder_n3) );
  XOR2_X1 adder_gen_4__u_adder_U3 ( .A(a[4]), .B(b[4]), .Z(
        adder_gen_4__u_adder_n2) );
  AND2_X1 adder_gen_4__u_adder_U2 ( .A1(b[4]), .A2(a[4]), .ZN(
        adder_gen_4__u_adder_n1) );
  AOI21_X1 adder_gen_4__u_adder_U1 ( .B1(c[3]), .B2(adder_gen_4__u_adder_n2), 
        .A(adder_gen_4__u_adder_n1), .ZN(adder_gen_4__u_adder_n4) );
  XOR2_X1 adder_gen_5__u_adder_U7 ( .A(adder_gen_5__u_adder_n5), .B(
        adder_gen_5__u_adder_n4), .Z(sum[5]) );
  CLKBUF_X1 adder_gen_5__u_adder_U6 ( .A(c[4]), .Z(adder_gen_5__u_adder_n5) );
  XOR2_X1 adder_gen_5__u_adder_U5 ( .A(a[5]), .B(b[5]), .Z(
        adder_gen_5__u_adder_n4) );
  INV_X1 adder_gen_5__u_adder_U4 ( .A(c[4]), .ZN(adder_gen_5__u_adder_n3) );
  INV_X1 adder_gen_5__u_adder_U3 ( .A(adder_gen_5__u_adder_n4), .ZN(
        adder_gen_5__u_adder_n2) );
  OAI21_X1 adder_gen_5__u_adder_U2 ( .B1(adder_gen_5__u_adder_n3), .B2(
        adder_gen_5__u_adder_n2), .A(adder_gen_5__u_adder_n1), .ZN(c[5]) );
  NAND2_X1 adder_gen_5__u_adder_U1 ( .A1(b[5]), .A2(a[5]), .ZN(
        adder_gen_5__u_adder_n1) );
  XOR2_X1 adder_gen_6__u_adder_U7 ( .A(adder_gen_6__u_adder_n5), .B(
        adder_gen_6__u_adder_n4), .Z(sum[6]) );
  CLKBUF_X1 adder_gen_6__u_adder_U6 ( .A(c[5]), .Z(adder_gen_6__u_adder_n5) );
  XOR2_X1 adder_gen_6__u_adder_U5 ( .A(a[6]), .B(b[6]), .Z(
        adder_gen_6__u_adder_n4) );
  INV_X1 adder_gen_6__u_adder_U4 ( .A(c[5]), .ZN(adder_gen_6__u_adder_n3) );
  INV_X1 adder_gen_6__u_adder_U3 ( .A(adder_gen_6__u_adder_n4), .ZN(
        adder_gen_6__u_adder_n2) );
  OAI21_X1 adder_gen_6__u_adder_U2 ( .B1(adder_gen_6__u_adder_n3), .B2(
        adder_gen_6__u_adder_n2), .A(adder_gen_6__u_adder_n1), .ZN(c[6]) );
  NAND2_X1 adder_gen_6__u_adder_U1 ( .A1(b[6]), .A2(a[6]), .ZN(
        adder_gen_6__u_adder_n1) );
  OAI22_X1 u_adder1_U6 ( .A1(u_adder1_n3), .A2(u_adder1_n4), .B1(u_adder1_n2), 
        .B2(u_adder1_n1), .ZN(cout) );
  INV_X1 u_adder1_U5 ( .A(b[7]), .ZN(u_adder1_n1) );
  INV_X1 u_adder1_U4 ( .A(c[6]), .ZN(u_adder1_n3) );
  XOR2_X1 u_adder1_U3 ( .A(u_adder1_n2), .B(b[7]), .Z(u_adder1_n4) );
  INV_X1 u_adder1_U2 ( .A(a[7]), .ZN(u_adder1_n2) );
  XNOR2_X1 u_adder1_U1 ( .A(c[6]), .B(u_adder1_n4), .ZN(sum[7]) );
endmodule

