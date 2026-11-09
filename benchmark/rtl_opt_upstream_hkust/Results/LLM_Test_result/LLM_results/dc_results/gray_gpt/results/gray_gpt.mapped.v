/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:30:08 2025
/////////////////////////////////////////////////////////////


module gray_gpt ( clk, rst_n, cmd, out );
  input [3:0] cmd;
  output [7:0] out;
  input clk, rst_n;
  wire   net1533, net1535, net1537, net1542, net1544, net1545, net1552,
         net1554, net1556, net1563, net1564, net1574, net1576, net1585,
         net1592, net1598, net1600, net1601, net1602, net1605, net1608,
         net1612, net1614, net1617, net1622, net1627, net1628, net1634,
         net1636, net1637, net1658, net1659, net1660, net1610, net1561,
         net1558, net1548, net1567, net1624, n46, n47, n48, n49, n50, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n70, n71, n72, n73, n74, n75, n76;
  wire   [3:0] state;
  wire   [3:0] next_state;

  DFFR_X1 state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(rst_n), .Q(state[0]), 
        .QN(net1601) );
  DFFR_X1 state_reg_3_ ( .D(next_state[3]), .CK(clk), .RN(rst_n), .Q(state[3]), 
        .QN(net1600) );
  DFFR_X1 state_reg_2_ ( .D(next_state[2]), .CK(clk), .RN(rst_n), .Q(state[2]), 
        .QN(net1598) );
  DFFR_X1 state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(rst_n), .Q(state[1]), 
        .QN(net1602) );
  CLKBUF_X1 U59 ( .A(n61), .Z(n46) );
  AND2_X1 U60 ( .A1(state[2]), .A2(net1585), .ZN(n47) );
  BUF_X1 U61 ( .A(state[1]), .Z(n48) );
  NAND4_X1 U62 ( .A1(net1605), .A2(state[1]), .A3(net1600), .A4(state[0]), 
        .ZN(n67) );
  INV_X1 U63 ( .A(net1564), .ZN(n49) );
  NOR2_X1 U64 ( .A1(net1624), .A2(net1533), .ZN(out[5]) );
  BUF_X1 U65 ( .A(state[1]), .Z(net1624) );
  OR2_X1 U66 ( .A1(net1598), .A2(net1601), .ZN(net1533) );
  NAND3_X1 U67 ( .A1(net1600), .A2(net1563), .A3(n48), .ZN(net1561) );
  OAI221_X1 U68 ( .B1(cmd[2]), .B2(net1567), .C1(n49), .C2(n51), .A(n52), .ZN(
        n50) );
  NAND4_X1 U69 ( .A1(state[1]), .A2(net1608), .A3(net1610), .A4(net1600), .ZN(
        net1567) );
  NAND4_X1 U70 ( .A1(net1610), .A2(cmd[0]), .A3(net1608), .A4(net1600), .ZN(
        n51) );
  BUF_X1 U71 ( .A(net1598), .Z(net1610) );
  BUF_X1 U72 ( .A(net1601), .Z(net1608) );
  NAND2_X1 U73 ( .A1(net1592), .A2(n53), .ZN(n52) );
  INV_X1 U74 ( .A(net1537), .ZN(net1592) );
  AND2_X1 U75 ( .A1(state[1]), .A2(state[3]), .ZN(n53) );
  NOR2_X1 U76 ( .A1(n50), .A2(net1558), .ZN(net1548) );
  INV_X1 U77 ( .A(net1567), .ZN(net1542) );
  NAND4_X1 U78 ( .A1(net1548), .A2(n54), .A3(n55), .A4(n56), .ZN(next_state[0]) );
  OAI21_X1 U79 ( .B1(n57), .B2(n58), .A(net1561), .ZN(net1558) );
  NAND3_X1 U80 ( .A1(net1610), .A2(cmd[0]), .A3(cmd[1]), .ZN(n57) );
  NAND2_X1 U81 ( .A1(net1602), .A2(net1627), .ZN(n58) );
  AND2_X1 U82 ( .A1(state[0]), .A2(net1600), .ZN(net1627) );
  INV_X1 U83 ( .A(net1533), .ZN(net1563) );
  NAND2_X1 U84 ( .A1(net1660), .A2(net1556), .ZN(n54) );
  AND3_X1 U85 ( .A1(net1628), .A2(net1614), .A3(net1622), .ZN(net1660) );
  INV_X1 U86 ( .A(cmd[1]), .ZN(net1556) );
  NAND3_X1 U87 ( .A1(net1554), .A2(cmd[3]), .A3(net1658), .ZN(n55) );
  INV_X1 U88 ( .A(net1535), .ZN(net1554) );
  AND2_X1 U89 ( .A1(net1624), .A2(net1600), .ZN(net1658) );
  AND2_X1 U90 ( .A1(net1545), .A2(net1552), .ZN(n56) );
  NAND4_X1 U91 ( .A1(n47), .A2(state[3]), .A3(net1602), .A4(cmd[2]), .ZN(
        net1545) );
  NAND3_X1 U92 ( .A1(net1612), .A2(net1602), .A3(net1659), .ZN(net1552) );
  AND2_X1 U93 ( .A1(state[0]), .A2(state[3]), .ZN(net1659) );
  INV_X1 U94 ( .A(net1537), .ZN(net1637) );
  AND2_X1 U95 ( .A1(state[2]), .A2(net1585), .ZN(net1636) );
  INV_X1 U96 ( .A(net1592), .ZN(net1634) );
  AND2_X1 U97 ( .A1(n61), .A2(net1602), .ZN(n59) );
  BUF_X1 U98 ( .A(net1612), .Z(net1628) );
  AND2_X1 U99 ( .A1(net1637), .A2(n53), .ZN(n60) );
  BUF_X1 U100 ( .A(state[3]), .Z(net1622) );
  INV_X1 U101 ( .A(net1563), .ZN(net1617) );
  INV_X1 U102 ( .A(net1608), .ZN(net1614) );
  INV_X1 U103 ( .A(net1598), .ZN(net1612) );
  BUF_X1 U104 ( .A(net1598), .Z(net1605) );
  INV_X1 U105 ( .A(state[1]), .ZN(net1564) );
  NAND2_X1 U106 ( .A1(net1601), .A2(state[2]), .ZN(net1535) );
  INV_X1 U107 ( .A(cmd[3]), .ZN(net1585) );
  NAND3_X1 U108 ( .A1(net1658), .A2(net1554), .A3(net1585), .ZN(n63) );
  NOR4_X1 U109 ( .A1(net1612), .A2(state[0]), .A3(state[3]), .A4(cmd[0]), .ZN(
        n61) );
  NAND2_X1 U110 ( .A1(n46), .A2(net1602), .ZN(n73) );
  AOI221_X1 U111 ( .B1(net1622), .B2(net1628), .C1(net1659), .C2(net1564), .A(
        n60), .ZN(n62) );
  NAND3_X1 U112 ( .A1(n63), .A2(n73), .A3(n62), .ZN(next_state[3]) );
  INV_X1 U113 ( .A(cmd[0]), .ZN(net1576) );
  XOR2_X1 U114 ( .A(net1576), .B(cmd[1]), .Z(n64) );
  NOR2_X1 U115 ( .A1(n64), .A2(net1634), .ZN(n69) );
  NOR4_X1 U116 ( .A1(net1601), .A2(cmd[1]), .A3(cmd[2]), .A4(cmd[0]), .ZN(n65)
         );
  NAND3_X1 U117 ( .A1(net1636), .A2(net1602), .A3(n65), .ZN(n66) );
  OAI211_X1 U118 ( .C1(net1602), .C2(net1535), .A(n67), .B(n66), .ZN(n68) );
  AOI221_X1 U119 ( .B1(net1542), .B2(cmd[2]), .C1(n69), .C2(n53), .A(n68), 
        .ZN(n72) );
  NAND2_X1 U120 ( .A1(net1605), .A2(state[0]), .ZN(n76) );
  NOR4_X1 U121 ( .A1(n76), .A2(net1622), .A3(net1576), .A4(net1556), .ZN(n70)
         );
  INV_X1 U122 ( .A(net1552), .ZN(net1574) );
  AOI211_X1 U123 ( .C1(net1660), .C2(cmd[1]), .A(n70), .B(net1574), .ZN(n71)
         );
  NAND2_X1 U124 ( .A1(n72), .A2(n71), .ZN(next_state[1]) );
  NAND3_X1 U125 ( .A1(net1658), .A2(net1628), .A3(cmd[3]), .ZN(n75) );
  INV_X1 U126 ( .A(net1545), .ZN(net1544) );
  AOI211_X1 U127 ( .C1(net1542), .C2(cmd[2]), .A(net1544), .B(n59), .ZN(n74)
         );
  NAND3_X1 U128 ( .A1(n75), .A2(net1617), .A3(n74), .ZN(next_state[2]) );
  NAND2_X1 U129 ( .A1(net1601), .A2(net1598), .ZN(net1537) );
  NOR2_X1 U130 ( .A1(net1624), .A2(net1537), .ZN(out[0]) );
  NOR2_X1 U131 ( .A1(n76), .A2(n48), .ZN(out[1]) );
  NOR2_X1 U132 ( .A1(net1602), .A2(net1537), .ZN(out[2]) );
  NOR2_X1 U133 ( .A1(n76), .A2(net1602), .ZN(out[3]) );
  NOR2_X1 U134 ( .A1(n48), .A2(net1535), .ZN(out[4]) );
  NOR2_X1 U135 ( .A1(net1535), .A2(net1602), .ZN(out[6]) );
  NOR2_X1 U136 ( .A1(net1533), .A2(net1602), .ZN(out[7]) );
endmodule

