/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 02:41:43 2025
/////////////////////////////////////////////////////////////


module mux_encode_ref ( sel, data, out );
  input [2:0] sel;
  input [63:0] data;
  output [7:0] out;
  wire   n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47;

  BUF_X1 U23 ( .A(sel[2]), .Z(n21) );
  INV_X1 U24 ( .A(sel[2]), .ZN(n22) );
  AND2_X1 U25 ( .A1(n35), .A2(sel[1]), .ZN(n23) );
  BUF_X1 U26 ( .A(sel[2]), .Z(n24) );
  AND2_X1 U27 ( .A1(n26), .A2(sel[1]), .ZN(n25) );
  INV_X1 U28 ( .A(sel[2]), .ZN(n26) );
  AND3_X1 U29 ( .A1(n36), .A2(n39), .A3(sel[0]), .ZN(n27) );
  AND3_X2 U30 ( .A1(n36), .A2(n39), .A3(sel[0]), .ZN(n28) );
  NAND2_X1 U31 ( .A1(data[31]), .A2(n28), .ZN(n29) );
  NAND2_X1 U32 ( .A1(data[15]), .A2(n24), .ZN(n30) );
  NAND2_X1 U33 ( .A1(data[23]), .A2(n38), .ZN(n31) );
  NAND3_X1 U34 ( .A1(n29), .A2(n30), .A3(n31), .ZN(out[7]) );
  AND2_X1 U35 ( .A1(n40), .A2(sel[1]), .ZN(n33) );
  AND2_X1 U36 ( .A1(n22), .A2(sel[1]), .ZN(n38) );
  AND2_X1 U37 ( .A1(n26), .A2(sel[1]), .ZN(n34) );
  AND2_X1 U38 ( .A1(n35), .A2(sel[1]), .ZN(n37) );
  INV_X1 U39 ( .A(sel[2]), .ZN(n35) );
  INV_X1 U40 ( .A(sel[2]), .ZN(n36) );
  INV_X1 U41 ( .A(sel[2]), .ZN(n40) );
  INV_X1 U42 ( .A(sel[1]), .ZN(n39) );
  AOI222_X1 U43 ( .A1(data[24]), .A2(n27), .B1(data[8]), .B2(sel[2]), .C1(n34), 
        .C2(data[16]), .ZN(n41) );
  INV_X1 U44 ( .A(n41), .ZN(out[0]) );
  AOI222_X1 U45 ( .A1(data[25]), .A2(n27), .B1(data[9]), .B2(sel[2]), .C1(n33), 
        .C2(data[17]), .ZN(n42) );
  INV_X1 U46 ( .A(n42), .ZN(out[1]) );
  AOI222_X1 U47 ( .A1(data[26]), .A2(n28), .B1(data[10]), .B2(sel[2]), .C1(n25), .C2(data[18]), .ZN(n43) );
  INV_X1 U48 ( .A(n43), .ZN(out[2]) );
  AOI222_X1 U49 ( .A1(data[27]), .A2(n28), .B1(data[11]), .B2(sel[2]), .C1(n33), .C2(data[19]), .ZN(n44) );
  INV_X1 U50 ( .A(n44), .ZN(out[3]) );
  AOI222_X1 U51 ( .A1(data[28]), .A2(n28), .B1(data[12]), .B2(n21), .C1(n23), 
        .C2(data[20]), .ZN(n45) );
  INV_X1 U52 ( .A(n45), .ZN(out[4]) );
  AOI222_X1 U53 ( .A1(data[29]), .A2(n27), .B1(data[13]), .B2(n24), .C1(n38), 
        .C2(data[21]), .ZN(n46) );
  INV_X1 U54 ( .A(n46), .ZN(out[5]) );
  AOI222_X1 U55 ( .A1(data[30]), .A2(n27), .B1(data[14]), .B2(n21), .C1(n37), 
        .C2(data[22]), .ZN(n47) );
  INV_X1 U56 ( .A(n47), .ZN(out[6]) );
endmodule

