/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 02:42:02 2025
/////////////////////////////////////////////////////////////


module sub_32bit_ref ( a, b, diff, overflow );
  input [31:0] a;
  input [31:0] b;
  output [31:0] diff;
  output overflow;
  wire   n4, extended_diff_32_, sub_8_n483, sub_8_n482, sub_8_n481, sub_8_n480,
         sub_8_n479, sub_8_n478, sub_8_n477, sub_8_n476, sub_8_n475,
         sub_8_n474, sub_8_n473, sub_8_n472, sub_8_n471, sub_8_n470,
         sub_8_n469, sub_8_n468, sub_8_n467, sub_8_n466, sub_8_n465,
         sub_8_n464, sub_8_n463, sub_8_n462, sub_8_n461, sub_8_n460,
         sub_8_n459, sub_8_n458, sub_8_n457, sub_8_n456, sub_8_n455,
         sub_8_n454, sub_8_n453, sub_8_n452, sub_8_n451, sub_8_n450,
         sub_8_n449, sub_8_n448, sub_8_n447, sub_8_n446, sub_8_n445,
         sub_8_n444, sub_8_n443, sub_8_n442, sub_8_n441, sub_8_n440,
         sub_8_n439, sub_8_n438, sub_8_n437, sub_8_n436, sub_8_n435,
         sub_8_n434, sub_8_n433, sub_8_n432, sub_8_n431, sub_8_n430,
         sub_8_n429, sub_8_n428, sub_8_n427, sub_8_n426, sub_8_n425,
         sub_8_n424, sub_8_n423, sub_8_n422, sub_8_n421, sub_8_n420,
         sub_8_n419, sub_8_n418, sub_8_n417, sub_8_n416, sub_8_n415,
         sub_8_n414, sub_8_n413, sub_8_n412, sub_8_n411, sub_8_n410,
         sub_8_n409, sub_8_n408, sub_8_n407, sub_8_n406, sub_8_n405,
         sub_8_n404, sub_8_n403, sub_8_n402, sub_8_n401, sub_8_n400,
         sub_8_n399, sub_8_n398, sub_8_n397, sub_8_n396, sub_8_n395,
         sub_8_n394, sub_8_n393, sub_8_n392, sub_8_n391, sub_8_n390,
         sub_8_n389, sub_8_n388, sub_8_n387, sub_8_n386, sub_8_n385,
         sub_8_n384, sub_8_n383, sub_8_n382, sub_8_n381, sub_8_n380,
         sub_8_n379, sub_8_n378, sub_8_n377, sub_8_n376, sub_8_n375,
         sub_8_n374, sub_8_n373, sub_8_n372, sub_8_n371, sub_8_n370,
         sub_8_n369, sub_8_n368, sub_8_n367, sub_8_n366, sub_8_n365,
         sub_8_n364, sub_8_n363, sub_8_n362, sub_8_n361, sub_8_n360,
         sub_8_n359, sub_8_n358, sub_8_n357, sub_8_n356, sub_8_n355,
         sub_8_n354, sub_8_n353, sub_8_n352, sub_8_n351, sub_8_n350,
         sub_8_n349, sub_8_n348, sub_8_n347, sub_8_n346, sub_8_n345,
         sub_8_n344, sub_8_n343, sub_8_n342, sub_8_n341, sub_8_n340,
         sub_8_n339, sub_8_n338, sub_8_n337, sub_8_n336, sub_8_n335,
         sub_8_n334, sub_8_n333, sub_8_n332, sub_8_n331, sub_8_n330,
         sub_8_n329, sub_8_n328, sub_8_n327, sub_8_n326, sub_8_n325,
         sub_8_n324, sub_8_n323, sub_8_n322, sub_8_n321, sub_8_n320,
         sub_8_n319, sub_8_n318, sub_8_n317, sub_8_n316, sub_8_n315,
         sub_8_n314, sub_8_n313, sub_8_n312, sub_8_n311, sub_8_n310,
         sub_8_n309, sub_8_n308, sub_8_n307, sub_8_n306, sub_8_n305,
         sub_8_n304, sub_8_n303, sub_8_n302, sub_8_n301, sub_8_n300,
         sub_8_n299, sub_8_n298, sub_8_n297, sub_8_n296, sub_8_n295,
         sub_8_n294, sub_8_n293, sub_8_n292, sub_8_n291, sub_8_n290,
         sub_8_n289, sub_8_n288, sub_8_n287, sub_8_n286, sub_8_n285,
         sub_8_n284, sub_8_n283, sub_8_n282, sub_8_n281, sub_8_n280,
         sub_8_n279, sub_8_n278, sub_8_n277, sub_8_n276, sub_8_n275,
         sub_8_n274, sub_8_n273, sub_8_n272, sub_8_n271, sub_8_n270,
         sub_8_n269, sub_8_n268, sub_8_n267, sub_8_n266, sub_8_n265,
         sub_8_n264, sub_8_n263, sub_8_n262, sub_8_n261, sub_8_n260,
         sub_8_n259, sub_8_n258, sub_8_n257, sub_8_n256, sub_8_n255,
         sub_8_n254, sub_8_n253, sub_8_n252, sub_8_n251, sub_8_n250,
         sub_8_n249, sub_8_n248, sub_8_n247, sub_8_n246, sub_8_n245,
         sub_8_n244, sub_8_n243, sub_8_n242, sub_8_n241, sub_8_n240,
         sub_8_n239, sub_8_n238, sub_8_n237, sub_8_n236, sub_8_n235,
         sub_8_n234, sub_8_n233, sub_8_n232, sub_8_n231, sub_8_n230,
         sub_8_n229, sub_8_n228, sub_8_n227, sub_8_n226, sub_8_n225,
         sub_8_n224, sub_8_n223, sub_8_n222, sub_8_n221, sub_8_n220,
         sub_8_n219, sub_8_n218, sub_8_n217, sub_8_n216, sub_8_n215,
         sub_8_n214, sub_8_n213, sub_8_n212, sub_8_n211, sub_8_n210,
         sub_8_n209, sub_8_n208, sub_8_n207, sub_8_n206, sub_8_n205,
         sub_8_n204, sub_8_n203, sub_8_n202, sub_8_n201, sub_8_n200,
         sub_8_n199, sub_8_n198, sub_8_n197, sub_8_n196, sub_8_n195,
         sub_8_n194, sub_8_n193, sub_8_n192, sub_8_n191, sub_8_n190,
         sub_8_n189, sub_8_n188, sub_8_n187, sub_8_n186, sub_8_n185,
         sub_8_n184, sub_8_n183, sub_8_n182, sub_8_n181, sub_8_n180,
         sub_8_n179, sub_8_n178, sub_8_n177, sub_8_n176, sub_8_n175,
         sub_8_n174, sub_8_n173, sub_8_n172, sub_8_n171, sub_8_n170,
         sub_8_n169, sub_8_n168, sub_8_n167, sub_8_n166, sub_8_n165,
         sub_8_n164, sub_8_n163, sub_8_n162, sub_8_n161, sub_8_n160,
         sub_8_n159, sub_8_n158, sub_8_n157, sub_8_n156, sub_8_n155,
         sub_8_n154, sub_8_n153, sub_8_n152, sub_8_n151, sub_8_n150,
         sub_8_n149, sub_8_n148, sub_8_n147, sub_8_n146, sub_8_n145,
         sub_8_n144, sub_8_n143, sub_8_n142, sub_8_n141, sub_8_n140,
         sub_8_n139, sub_8_n138, sub_8_n137, sub_8_n136, sub_8_n135,
         sub_8_n134, sub_8_n133, sub_8_n132, sub_8_n131, sub_8_n130,
         sub_8_n129, sub_8_n128, sub_8_n127, sub_8_n126, sub_8_n125,
         sub_8_n124, sub_8_n123, sub_8_n122, sub_8_n120, sub_8_n119,
         sub_8_n118, sub_8_n117, sub_8_n116, sub_8_n115, sub_8_n114,
         sub_8_n113, sub_8_n112, sub_8_n111, sub_8_n110, sub_8_n109,
         sub_8_n108, sub_8_n107, sub_8_n106, sub_8_n105, sub_8_n104,
         sub_8_n103, sub_8_n102, sub_8_n101, sub_8_n100, sub_8_n99, sub_8_n98,
         sub_8_n97, sub_8_n96, sub_8_n95, sub_8_n94, sub_8_n93, sub_8_n92,
         sub_8_n91, sub_8_n90, sub_8_n89, sub_8_n88, sub_8_n87, sub_8_n86,
         sub_8_n85, sub_8_n84, sub_8_n83, sub_8_n82, sub_8_n81, sub_8_n80,
         sub_8_n79, sub_8_n78, sub_8_n77, sub_8_n76, sub_8_n75, sub_8_n74,
         sub_8_n73, sub_8_n72, sub_8_n71, sub_8_n70, sub_8_n69, sub_8_n68,
         sub_8_n67, sub_8_n66, sub_8_n65, sub_8_n64, sub_8_n63, sub_8_n62,
         sub_8_n61, sub_8_n60, sub_8_n59, sub_8_n58, sub_8_n57, sub_8_n56,
         sub_8_n55, sub_8_n54, sub_8_n53, sub_8_n52, sub_8_n51, sub_8_n50,
         sub_8_n49, sub_8_n48, sub_8_n47, sub_8_n46, sub_8_n45, sub_8_n44,
         sub_8_n43, sub_8_n42, sub_8_n41, sub_8_n40, sub_8_n39, sub_8_n38,
         sub_8_n37, sub_8_n36, sub_8_n35, sub_8_n34, sub_8_n33, sub_8_n32,
         sub_8_n31, sub_8_n30, sub_8_n29, sub_8_n28, sub_8_n27, sub_8_n26,
         sub_8_n25, sub_8_n24, sub_8_n23, sub_8_n22, sub_8_n21, sub_8_n20,
         sub_8_n19, sub_8_n18, sub_8_n17, sub_8_n16, sub_8_n15, sub_8_n14,
         sub_8_n13, sub_8_n12, sub_8_n11, sub_8_n10, sub_8_n9, sub_8_n8,
         sub_8_n7, sub_8_n6, sub_8_n5, sub_8_n4, sub_8_n3, sub_8_n2, sub_8_n1;

  CLKBUF_X1 U4 ( .A(n4), .Z(diff[31]) );
  XOR2_X1 U5 ( .A(extended_diff_32_), .B(n4), .Z(overflow) );
  INV_X1 sub_8_U517 ( .A(sub_8_n350), .ZN(sub_8_n483) );
  NOR2_X1 sub_8_U516 ( .A1(sub_8_n135), .A2(sub_8_n125), .ZN(sub_8_n459) );
  NAND3_X1 sub_8_U515 ( .A1(sub_8_n458), .A2(sub_8_n100), .A3(sub_8_n21), .ZN(
        sub_8_n404) );
  NAND3_X1 sub_8_U514 ( .A1(sub_8_n147), .A2(sub_8_n27), .A3(sub_8_n151), .ZN(
        sub_8_n456) );
  INV_X1 sub_8_U513 ( .A(sub_8_n151), .ZN(sub_8_n145) );
  XNOR2_X1 sub_8_U512 ( .A(sub_8_n433), .B(sub_8_n434), .ZN(diff[12]) );
  NAND3_X1 sub_8_U511 ( .A1(sub_8_n426), .A2(sub_8_n92), .A3(sub_8_n59), .ZN(
        sub_8_n419) );
  NAND3_X1 sub_8_U510 ( .A1(sub_8_n419), .A2(sub_8_n418), .A3(sub_8_n412), 
        .ZN(sub_8_n414) );
  INV_X1 sub_8_U509 ( .A(sub_8_n154), .ZN(sub_8_n400) );
  NAND2_X1 sub_8_U508 ( .A1(sub_8_n99), .A2(sub_8_n382), .ZN(sub_8_n377) );
  NAND3_X1 sub_8_U507 ( .A1(sub_8_n304), .A2(sub_8_n305), .A3(sub_8_n362), 
        .ZN(sub_8_n375) );
  NAND2_X1 sub_8_U506 ( .A1(sub_8_n363), .A2(sub_8_n137), .ZN(sub_8_n361) );
  INV_X1 sub_8_U505 ( .A(sub_8_n362), .ZN(sub_8_n302) );
  XNOR2_X1 sub_8_U504 ( .A(sub_8_n65), .B(sub_8_n356), .ZN(diff[18]) );
  NAND3_X1 sub_8_U503 ( .A1(sub_8_n68), .A2(sub_8_n69), .A3(sub_8_n342), .ZN(
        sub_8_n338) );
  INV_X1 sub_8_U502 ( .A(sub_8_n77), .ZN(sub_8_n328) );
  NAND3_X1 sub_8_U501 ( .A1(sub_8_n130), .A2(sub_8_n300), .A3(sub_8_n321), 
        .ZN(sub_8_n316) );
  INV_X1 sub_8_U500 ( .A(sub_8_n309), .ZN(sub_8_n308) );
  NAND2_X1 sub_8_U499 ( .A1(sub_8_n306), .A2(sub_8_n137), .ZN(sub_8_n301) );
  XNOR2_X1 sub_8_U498 ( .A(sub_8_n76), .B(sub_8_n287), .ZN(diff[24]) );
  INV_X1 sub_8_U497 ( .A(sub_8_n268), .ZN(sub_8_n248) );
  OAI21_X1 sub_8_U496 ( .B1(sub_8_n248), .B2(sub_8_n8), .A(sub_8_n202), .ZN(
        sub_8_n254) );
  XNOR2_X1 sub_8_U495 ( .A(sub_8_n254), .B(sub_8_n255), .ZN(diff[28]) );
  INV_X1 sub_8_U494 ( .A(sub_8_n199), .ZN(sub_8_n250) );
  INV_X1 sub_8_U493 ( .A(sub_8_n209), .ZN(sub_8_n237) );
  OAI21_X1 sub_8_U492 ( .B1(sub_8_n248), .B2(sub_8_n236), .A(sub_8_n249), .ZN(
        sub_8_n244) );
  NAND2_X2 sub_8_U491 ( .A1(b[29]), .A2(sub_8_n247), .ZN(sub_8_n200) );
  XNOR2_X1 sub_8_U490 ( .A(sub_8_n244), .B(sub_8_n245), .ZN(diff[29]) );
  INV_X1 sub_8_U489 ( .A(sub_8_n243), .ZN(sub_8_n241) );
  INV_X1 sub_8_U488 ( .A(sub_8_n236), .ZN(sub_8_n235) );
  NAND3_X1 sub_8_U487 ( .A1(sub_8_n122), .A2(sub_8_n75), .A3(sub_8_n232), .ZN(
        sub_8_n231) );
  NAND3_X1 sub_8_U486 ( .A1(sub_8_n231), .A2(sub_8_n230), .A3(sub_8_n229), 
        .ZN(sub_8_n225) );
  INV_X1 sub_8_U485 ( .A(sub_8_n210), .ZN(sub_8_n194) );
  INV_X1 sub_8_U484 ( .A(sub_8_n224), .ZN(sub_8_n222) );
  NAND2_X1 sub_8_U483 ( .A1(sub_8_n75), .A2(sub_8_n210), .ZN(sub_8_n218) );
  NAND2_X1 sub_8_U482 ( .A1(sub_8_n37), .A2(sub_8_n119), .ZN(sub_8_n207) );
  NAND2_X1 sub_8_U481 ( .A1(sub_8_n35), .A2(sub_8_n134), .ZN(sub_8_n208) );
  INV_X1 sub_8_U480 ( .A(sub_8_n200), .ZN(sub_8_n198) );
  INV_X1 sub_8_U479 ( .A(sub_8_n195), .ZN(sub_8_n193) );
  NOR2_X1 sub_8_U478 ( .A1(sub_8_n193), .A2(sub_8_n194), .ZN(sub_8_n192) );
  MUX2_X1 sub_8_U477 ( .A(sub_8_n182), .B(sub_8_n183), .S(sub_8_n184), .Z(
        extended_diff_32_) );
  INV_X1 sub_8_U476 ( .A(sub_8_n181), .ZN(sub_8_n177) );
  INV_X1 sub_8_U475 ( .A(sub_8_n180), .ZN(sub_8_n178) );
  OAI21_X1 sub_8_U474 ( .B1(sub_8_n177), .B2(sub_8_n178), .A(sub_8_n179), .ZN(
        sub_8_n173) );
  XNOR2_X1 sub_8_U473 ( .A(sub_8_n173), .B(sub_8_n174), .ZN(diff[3]) );
  XNOR2_X1 sub_8_U472 ( .A(sub_8_n117), .B(sub_8_n166), .ZN(diff[5]) );
  INV_X1 sub_8_U471 ( .A(sub_8_n165), .ZN(sub_8_n161) );
  INV_X1 sub_8_U470 ( .A(sub_8_n164), .ZN(sub_8_n162) );
  XNOR2_X1 sub_8_U469 ( .A(sub_8_n128), .B(sub_8_n160), .ZN(diff[6]) );
  XNOR2_X1 sub_8_U468 ( .A(sub_8_n148), .B(sub_8_n149), .ZN(diff[8]) );
  INV_X1 sub_8_U467 ( .A(sub_8_n147), .ZN(sub_8_n144) );
  NAND2_X1 sub_8_U466 ( .A1(sub_8_n142), .A2(sub_8_n27), .ZN(sub_8_n138) );
  XNOR2_X1 sub_8_U465 ( .A(sub_8_n138), .B(sub_8_n139), .ZN(diff[9]) );
  NAND4_X1 sub_8_U464 ( .A1(sub_8_n470), .A2(sub_8_n169), .A3(sub_8_n158), 
        .A4(sub_8_n154), .ZN(sub_8_n150) );
  NAND4_X1 sub_8_U463 ( .A1(a[4]), .A2(sub_8_n164), .A3(sub_8_n62), .A4(
        sub_8_n172), .ZN(sub_8_n399) );
  AOI21_X1 sub_8_U462 ( .B1(sub_8_n401), .B2(sub_8_n62), .A(sub_8_n402), .ZN(
        sub_8_n398) );
  NOR2_X1 sub_8_U461 ( .A1(sub_8_n150), .A2(sub_8_n116), .ZN(sub_8_n378) );
  NAND2_X1 sub_8_U460 ( .A1(sub_8_n164), .A2(sub_8_n158), .ZN(sub_8_n478) );
  OAI211_X1 sub_8_U459 ( .C1(sub_8_n106), .C2(sub_8_n124), .A(sub_8_n3), .B(
        sub_8_n151), .ZN(sub_8_n431) );
  NAND2_X1 sub_8_U458 ( .A1(sub_8_n185), .A2(sub_8_n217), .ZN(sub_8_n216) );
  INV_X1 sub_8_U457 ( .A(sub_8_n123), .ZN(sub_8_n274) );
  INV_X1 sub_8_U456 ( .A(sub_8_n123), .ZN(sub_8_n320) );
  NAND2_X1 sub_8_U455 ( .A1(sub_8_n37), .A2(sub_8_n123), .ZN(sub_8_n333) );
  NAND2_X1 sub_8_U454 ( .A1(sub_8_n159), .A2(sub_8_n62), .ZN(sub_8_n157) );
  NAND2_X1 sub_8_U453 ( .A1(sub_8_n122), .A2(sub_8_n334), .ZN(sub_8_n370) );
  NAND2_X1 sub_8_U452 ( .A1(sub_8_n118), .A2(sub_8_n123), .ZN(sub_8_n326) );
  OAI21_X1 sub_8_U451 ( .B1(sub_8_n106), .B2(sub_8_n124), .A(sub_8_n151), .ZN(
        sub_8_n148) );
  NAND2_X1 sub_8_U450 ( .A1(sub_8_n158), .A2(sub_8_n111), .ZN(sub_8_n160) );
  XNOR2_X1 sub_8_U449 ( .A(sub_8_n122), .B(sub_8_n371), .ZN(diff[16]) );
  NAND2_X1 sub_8_U448 ( .A1(sub_8_n188), .A2(sub_8_n189), .ZN(sub_8_n187) );
  NOR2_X1 sub_8_U447 ( .A1(sub_8_n203), .A2(sub_8_n8), .ZN(sub_8_n201) );
  OAI211_X1 sub_8_U446 ( .C1(sub_8_n274), .C2(sub_8_n315), .A(sub_8_n316), .B(
        sub_8_n34), .ZN(sub_8_n313) );
  OAI211_X1 sub_8_U445 ( .C1(sub_8_n320), .C2(sub_8_n315), .A(sub_8_n34), .B(
        sub_8_n316), .ZN(sub_8_n317) );
  NAND2_X1 sub_8_U444 ( .A1(sub_8_n130), .A2(sub_8_n34), .ZN(sub_8_n323) );
  OAI211_X1 sub_8_U443 ( .C1(sub_8_n238), .C2(sub_8_n237), .A(sub_8_n197), .B(
        sub_8_n199), .ZN(sub_8_n224) );
  NAND2_X1 sub_8_U442 ( .A1(sub_8_n88), .A2(sub_8_n200), .ZN(sub_8_n229) );
  OAI21_X1 sub_8_U441 ( .B1(sub_8_n222), .B2(sub_8_n223), .A(sub_8_n196), .ZN(
        sub_8_n221) );
  NOR2_X1 sub_8_U440 ( .A1(sub_8_n221), .A2(sub_8_n220), .ZN(sub_8_n215) );
  NAND2_X1 sub_8_U439 ( .A1(sub_8_n394), .A2(sub_8_n73), .ZN(sub_8_n442) );
  NOR2_X1 sub_8_U438 ( .A1(sub_8_n380), .A2(sub_8_n381), .ZN(sub_8_n379) );
  NOR2_X1 sub_8_U437 ( .A1(sub_8_n380), .A2(sub_8_n381), .ZN(sub_8_n396) );
  AND2_X1 sub_8_U436 ( .A1(sub_8_n146), .A2(sub_8_n73), .ZN(sub_8_n455) );
  OAI21_X1 sub_8_U435 ( .B1(sub_8_n437), .B2(sub_8_n55), .A(sub_8_n1), .ZN(
        sub_8_n433) );
  NAND2_X1 sub_8_U434 ( .A1(sub_8_n73), .A2(sub_8_n58), .ZN(sub_8_n139) );
  NAND4_X1 sub_8_U433 ( .A1(sub_8_n86), .A2(sub_8_n131), .A3(sub_8_n16), .A4(
        sub_8_n133), .ZN(sub_8_n307) );
  NAND2_X1 sub_8_U432 ( .A1(sub_8_n475), .A2(a[6]), .ZN(sub_8_n156) );
  NAND2_X1 sub_8_U431 ( .A1(sub_8_n155), .A2(sub_8_n156), .ZN(sub_8_n402) );
  AOI21_X1 sub_8_U430 ( .B1(sub_8_n399), .B2(sub_8_n398), .A(sub_8_n400), .ZN(
        sub_8_n397) );
  NAND2_X1 sub_8_U429 ( .A1(sub_8_n107), .A2(sub_8_n110), .ZN(sub_8_n473) );
  NAND2_X1 sub_8_U428 ( .A1(sub_8_n397), .A2(sub_8_n396), .ZN(sub_8_n304) );
  NAND2_X1 sub_8_U427 ( .A1(sub_8_n157), .A2(sub_8_n110), .ZN(sub_8_n152) );
  XNOR2_X1 sub_8_U426 ( .A(sub_8_n212), .B(sub_8_n182), .ZN(n4) );
  NAND4_X1 sub_8_U425 ( .A1(sub_8_n86), .A2(sub_8_n16), .A3(sub_8_n133), .A4(
        sub_8_n131), .ZN(sub_8_n137) );
  NOR2_X1 sub_8_U424 ( .A1(sub_8_n115), .A2(b[1]), .ZN(sub_8_n464) );
  NAND2_X1 sub_8_U423 ( .A1(sub_8_n114), .A2(b[1]), .ZN(sub_8_n388) );
  NAND2_X1 sub_8_U422 ( .A1(sub_8_n115), .A2(b[1]), .ZN(sub_8_n348) );
  NOR2_X1 sub_8_U421 ( .A1(b[1]), .A2(sub_8_n114), .ZN(sub_8_n383) );
  NOR2_X1 sub_8_U420 ( .A1(sub_8_n462), .A2(sub_8_n461), .ZN(sub_8_n460) );
  NAND2_X1 sub_8_U419 ( .A1(sub_8_n51), .A2(sub_8_n170), .ZN(sub_8_n147) );
  NAND2_X1 sub_8_U418 ( .A1(sub_8_n431), .A2(sub_8_n430), .ZN(sub_8_n425) );
  AOI21_X1 sub_8_U417 ( .B1(sub_8_n51), .B2(sub_8_n67), .A(sub_8_n145), .ZN(
        sub_8_n437) );
  XNOR2_X1 sub_8_U416 ( .A(sub_8_n67), .B(sub_8_n171), .ZN(diff[4]) );
  NAND2_X1 sub_8_U415 ( .A1(sub_8_n216), .A2(sub_8_n215), .ZN(sub_8_n212) );
  NAND2_X1 sub_8_U414 ( .A1(sub_8_n118), .A2(sub_8_n130), .ZN(sub_8_n315) );
  OAI21_X1 sub_8_U413 ( .B1(sub_8_n201), .B2(sub_8_n18), .A(sub_8_n119), .ZN(
        sub_8_n188) );
  NAND2_X1 sub_8_U412 ( .A1(sub_8_n297), .A2(sub_8_n296), .ZN(sub_8_n295) );
  AOI21_X1 sub_8_U411 ( .B1(sub_8_n74), .B2(sub_8_n35), .A(sub_8_n205), .ZN(
        sub_8_n203) );
  INV_X1 sub_8_U410 ( .A(b[20]), .ZN(sub_8_n331) );
  NAND2_X1 sub_8_U409 ( .A1(sub_8_n94), .A2(a[20]), .ZN(sub_8_n299) );
  NAND2_X1 sub_8_U408 ( .A1(sub_8_n282), .A2(sub_8_n7), .ZN(sub_8_n277) );
  NAND4_X1 sub_8_U407 ( .A1(a[24]), .A2(sub_8_n263), .A3(sub_8_n7), .A4(
        sub_8_n266), .ZN(sub_8_n260) );
  OAI21_X1 sub_8_U406 ( .B1(sub_8_n106), .B2(sub_8_n50), .A(sub_8_n168), .ZN(
        sub_8_n165) );
  NAND2_X1 sub_8_U405 ( .A1(a[2]), .A2(sub_8_n48), .ZN(sub_8_n179) );
  NAND2_X1 sub_8_U404 ( .A1(sub_8_n425), .A2(sub_8_n411), .ZN(sub_8_n426) );
  NAND2_X1 sub_8_U403 ( .A1(sub_8_n253), .A2(sub_8_n252), .ZN(sub_8_n238) );
  OAI211_X1 sub_8_U402 ( .C1(sub_8_n377), .C2(sub_8_n376), .A(sub_8_n378), .B(
        sub_8_n379), .ZN(sub_8_n362) );
  AND2_X1 sub_8_U401 ( .A1(sub_8_n298), .A2(sub_8_n299), .ZN(sub_8_n136) );
  NAND2_X1 sub_8_U400 ( .A1(sub_8_n105), .A2(b[3]), .ZN(sub_8_n175) );
  NAND2_X1 sub_8_U399 ( .A1(sub_8_n175), .A2(sub_8_n176), .ZN(sub_8_n174) );
  NAND2_X1 sub_8_U398 ( .A1(sub_8_n180), .A2(sub_8_n175), .ZN(sub_8_n461) );
  NAND4_X1 sub_8_U397 ( .A1(sub_8_n405), .A2(sub_8_n406), .A3(sub_8_n407), 
        .A4(sub_8_n408), .ZN(sub_8_n380) );
  AND2_X1 sub_8_U396 ( .A1(sub_8_n408), .A2(sub_8_n407), .ZN(sub_8_n409) );
  NAND2_X1 sub_8_U395 ( .A1(sub_8_n127), .A2(sub_8_n20), .ZN(sub_8_n303) );
  NAND2_X1 sub_8_U394 ( .A1(sub_8_n420), .A2(sub_8_n92), .ZN(sub_8_n418) );
  NAND2_X1 sub_8_U393 ( .A1(sub_8_n92), .A2(sub_8_n412), .ZN(sub_8_n422) );
  NOR2_X1 sub_8_U392 ( .A1(sub_8_n237), .A2(sub_8_n202), .ZN(sub_8_n251) );
  INV_X1 sub_8_U391 ( .A(a[3]), .ZN(sub_8_n467) );
  INV_X1 sub_8_U390 ( .A(a[1]), .ZN(sub_8_n384) );
  AND2_X1 sub_8_U389 ( .A1(b[1]), .A2(sub_8_n384), .ZN(sub_8_n135) );
  NAND2_X1 sub_8_U388 ( .A1(sub_8_n76), .A2(sub_8_n267), .ZN(sub_8_n286) );
  NOR2_X1 sub_8_U387 ( .A1(sub_8_n2), .A2(sub_8_n53), .ZN(sub_8_n457) );
  NAND2_X1 sub_8_U386 ( .A1(sub_8_n457), .A2(sub_8_n404), .ZN(sub_8_n170) );
  NAND2_X1 sub_8_U385 ( .A1(sub_8_n455), .A2(sub_8_n456), .ZN(sub_8_n453) );
  INV_X1 sub_8_U384 ( .A(b[21]), .ZN(sub_8_n324) );
  NAND2_X1 sub_8_U383 ( .A1(sub_8_n19), .A2(a[21]), .ZN(sub_8_n298) );
  INV_X1 sub_8_U382 ( .A(a[21]), .ZN(sub_8_n325) );
  NAND2_X1 sub_8_U381 ( .A1(sub_8_n29), .A2(b[21]), .ZN(sub_8_n297) );
  NAND2_X1 sub_8_U380 ( .A1(b[4]), .A2(sub_8_n471), .ZN(sub_8_n169) );
  AND4_X1 sub_8_U379 ( .A1(sub_8_n169), .A2(sub_8_n470), .A3(sub_8_n62), .A4(
        sub_8_n154), .ZN(sub_8_n133) );
  NAND2_X1 sub_8_U378 ( .A1(sub_8_n28), .A2(b[22]), .ZN(sub_8_n296) );
  NAND2_X1 sub_8_U377 ( .A1(sub_8_n129), .A2(sub_8_n33), .ZN(sub_8_n318) );
  AOI21_X1 sub_8_U376 ( .B1(sub_8_n313), .B2(sub_8_n129), .A(sub_8_n314), .ZN(
        sub_8_n310) );
  NAND2_X1 sub_8_U375 ( .A1(sub_8_n409), .A2(sub_8_n410), .ZN(sub_8_n365) );
  NOR2_X1 sub_8_U374 ( .A1(sub_8_n91), .A2(sub_8_n308), .ZN(sub_8_n306) );
  NAND2_X1 sub_8_U373 ( .A1(b[18]), .A2(sub_8_n358), .ZN(sub_8_n336) );
  AND2_X1 sub_8_U372 ( .A1(sub_8_n335), .A2(sub_8_n336), .ZN(sub_8_n340) );
  NAND2_X1 sub_8_U371 ( .A1(sub_8_n355), .A2(sub_8_n85), .ZN(sub_8_n354) );
  NAND2_X1 sub_8_U370 ( .A1(sub_8_n85), .A2(sub_8_n344), .ZN(sub_8_n356) );
  NAND2_X1 sub_8_U369 ( .A1(sub_8_n300), .A2(sub_8_n113), .ZN(sub_8_n330) );
  NAND2_X1 sub_8_U368 ( .A1(sub_8_n328), .A2(sub_8_n113), .ZN(sub_8_n321) );
  NAND2_X1 sub_8_U367 ( .A1(sub_8_n70), .A2(sub_8_n440), .ZN(sub_8_n450) );
  INV_X1 sub_8_U366 ( .A(a[11]), .ZN(sub_8_n448) );
  NAND2_X1 sub_8_U365 ( .A1(b[11]), .A2(sub_8_n10), .ZN(sub_8_n392) );
  NAND2_X1 sub_8_U364 ( .A1(b[11]), .A2(sub_8_n448), .ZN(sub_8_n132) );
  NAND2_X1 sub_8_U363 ( .A1(b[13]), .A2(sub_8_n429), .ZN(sub_8_n406) );
  AND4_X1 sub_8_U362 ( .A1(sub_8_n405), .A2(sub_8_n406), .A3(sub_8_n92), .A4(
        sub_8_n13), .ZN(sub_8_n131) );
  INV_X1 sub_8_U361 ( .A(b[6]), .ZN(sub_8_n475) );
  OAI211_X1 sub_8_U360 ( .C1(sub_8_n274), .C2(sub_8_n275), .A(sub_8_n276), .B(
        sub_8_n277), .ZN(sub_8_n272) );
  AOI21_X1 sub_8_U359 ( .B1(sub_8_n272), .B2(sub_8_n56), .A(sub_8_n273), .ZN(
        sub_8_n269) );
  INV_X1 sub_8_U358 ( .A(a[9]), .ZN(sub_8_n482) );
  NAND2_X1 sub_8_U357 ( .A1(sub_8_n63), .A2(b[9]), .ZN(sub_8_n140) );
  CLKBUF_X1 sub_8_U356 ( .A(sub_8_n32), .Z(sub_8_n130) );
  INV_X1 sub_8_U355 ( .A(a[22]), .ZN(sub_8_n319) );
  INV_X1 sub_8_U354 ( .A(a[10]), .ZN(sub_8_n452) );
  NAND2_X1 sub_8_U353 ( .A1(sub_8_n60), .A2(b[10]), .ZN(sub_8_n394) );
  NAND2_X1 sub_8_U352 ( .A1(sub_8_n262), .A2(sub_8_n263), .ZN(sub_8_n261) );
  CLKBUF_X1 sub_8_U351 ( .A(sub_8_n31), .Z(sub_8_n129) );
  OR2_X1 sub_8_U350 ( .A1(sub_8_n319), .A2(b[22]), .ZN(sub_8_n294) );
  INV_X1 sub_8_U349 ( .A(sub_8_n33), .ZN(sub_8_n314) );
  NAND2_X1 sub_8_U348 ( .A1(sub_8_n293), .A2(sub_8_n294), .ZN(sub_8_n291) );
  NOR2_X1 sub_8_U347 ( .A1(sub_8_n441), .A2(sub_8_n442), .ZN(sub_8_n438) );
  OAI21_X1 sub_8_U346 ( .B1(sub_8_n438), .B2(sub_8_n391), .A(sub_8_n132), .ZN(
        sub_8_n432) );
  NAND2_X1 sub_8_U345 ( .A1(sub_8_n345), .A2(sub_8_n309), .ZN(sub_8_n364) );
  NAND2_X1 sub_8_U344 ( .A1(sub_8_n370), .A2(sub_8_n345), .ZN(sub_8_n366) );
  NAND2_X1 sub_8_U343 ( .A1(sub_8_n334), .A2(sub_8_n345), .ZN(sub_8_n371) );
  OAI21_X1 sub_8_U342 ( .B1(sub_8_n161), .B2(sub_8_n162), .A(sub_8_n163), .ZN(
        sub_8_n159) );
  OAI21_X1 sub_8_U341 ( .B1(sub_8_n161), .B2(sub_8_n162), .A(sub_8_n163), .ZN(
        sub_8_n128) );
  NAND2_X1 sub_8_U340 ( .A1(sub_8_n397), .A2(sub_8_n396), .ZN(sub_8_n127) );
  NAND2_X1 sub_8_U339 ( .A1(sub_8_n204), .A2(sub_8_n35), .ZN(sub_8_n290) );
  NAND2_X1 sub_8_U338 ( .A1(sub_8_n290), .A2(sub_8_n206), .ZN(sub_8_n234) );
  INV_X1 sub_8_U337 ( .A(b[18]), .ZN(sub_8_n357) );
  INV_X1 sub_8_U336 ( .A(a[13]), .ZN(sub_8_n429) );
  NAND2_X1 sub_8_U335 ( .A1(sub_8_n284), .A2(a[25]), .ZN(sub_8_n264) );
  NAND2_X1 sub_8_U334 ( .A1(sub_8_n264), .A2(sub_8_n283), .ZN(sub_8_n282) );
  INV_X1 sub_8_U333 ( .A(sub_8_n264), .ZN(sub_8_n262) );
  NAND2_X1 sub_8_U332 ( .A1(a[9]), .A2(sub_8_n454), .ZN(sub_8_n141) );
  OR2_X1 sub_8_U331 ( .A1(sub_8_n375), .A2(sub_8_n374), .ZN(sub_8_n185) );
  NAND2_X1 sub_8_U330 ( .A1(sub_8_n348), .A2(sub_8_n242), .ZN(sub_8_n347) );
  XNOR2_X1 sub_8_U329 ( .A(sub_8_n243), .B(sub_8_n347), .ZN(diff[1]) );
  INV_X1 sub_8_U328 ( .A(b[5]), .ZN(sub_8_n167) );
  NAND2_X1 sub_8_U327 ( .A1(a[5]), .A2(sub_8_n167), .ZN(sub_8_n163) );
  INV_X1 sub_8_U326 ( .A(b[1]), .ZN(sub_8_n349) );
  NAND2_X1 sub_8_U325 ( .A1(a[1]), .A2(sub_8_n349), .ZN(sub_8_n242) );
  INV_X1 sub_8_U324 ( .A(b[31]), .ZN(sub_8_n214) );
  NAND2_X1 sub_8_U323 ( .A1(a[31]), .A2(sub_8_n214), .ZN(sub_8_n213) );
  NAND2_X1 sub_8_U322 ( .A1(sub_8_n213), .A2(sub_8_n195), .ZN(sub_8_n182) );
  NAND2_X1 sub_8_U321 ( .A1(a[24]), .A2(sub_8_n266), .ZN(sub_8_n283) );
  NAND2_X1 sub_8_U320 ( .A1(a[4]), .A2(sub_8_n172), .ZN(sub_8_n168) );
  NAND2_X1 sub_8_U319 ( .A1(b[8]), .A2(sub_8_n444), .ZN(sub_8_n146) );
  NAND2_X1 sub_8_U318 ( .A1(sub_8_n389), .A2(a[0]), .ZN(sub_8_n350) );
  INV_X1 sub_8_U317 ( .A(b[30]), .ZN(sub_8_n227) );
  NAND2_X1 sub_8_U316 ( .A1(a[30]), .A2(sub_8_n227), .ZN(sub_8_n196) );
  INV_X1 sub_8_U315 ( .A(b[28]), .ZN(sub_8_n256) );
  NAND2_X1 sub_8_U314 ( .A1(a[28]), .A2(sub_8_n256), .ZN(sub_8_n199) );
  INV_X1 sub_8_U313 ( .A(b[29]), .ZN(sub_8_n246) );
  NAND2_X1 sub_8_U312 ( .A1(a[29]), .A2(sub_8_n246), .ZN(sub_8_n197) );
  INV_X1 sub_8_U311 ( .A(b[15]), .ZN(sub_8_n417) );
  NAND2_X1 sub_8_U310 ( .A1(a[15]), .A2(sub_8_n417), .ZN(sub_8_n309) );
  INV_X1 sub_8_U309 ( .A(a[30]), .ZN(sub_8_n228) );
  NAND2_X1 sub_8_U308 ( .A1(b[30]), .A2(sub_8_n228), .ZN(sub_8_n210) );
  INV_X1 sub_8_U307 ( .A(a[31]), .ZN(sub_8_n211) );
  NAND2_X1 sub_8_U306 ( .A1(b[31]), .A2(sub_8_n211), .ZN(sub_8_n195) );
  INV_X1 sub_8_U305 ( .A(a[29]), .ZN(sub_8_n247) );
  INV_X1 sub_8_U304 ( .A(b[4]), .ZN(sub_8_n172) );
  INV_X1 sub_8_U303 ( .A(a[28]), .ZN(sub_8_n257) );
  INV_X1 sub_8_U302 ( .A(b[19]), .ZN(sub_8_n353) );
  NAND2_X1 sub_8_U301 ( .A1(a[19]), .A2(sub_8_n353), .ZN(sub_8_n339) );
  INV_X1 sub_8_U300 ( .A(b[0]), .ZN(sub_8_n389) );
  INV_X1 sub_8_U299 ( .A(b[24]), .ZN(sub_8_n266) );
  INV_X1 sub_8_U298 ( .A(b[27]), .ZN(sub_8_n270) );
  NAND2_X1 sub_8_U297 ( .A1(a[27]), .A2(sub_8_n270), .ZN(sub_8_n259) );
  INV_X1 sub_8_U296 ( .A(b[26]), .ZN(sub_8_n280) );
  INV_X1 sub_8_U295 ( .A(a[17]), .ZN(sub_8_n343) );
  NOR2_X1 sub_8_U294 ( .A1(b[5]), .A2(sub_8_n11), .ZN(sub_8_n481) );
  NOR2_X1 sub_8_U293 ( .A1(b[4]), .A2(sub_8_n471), .ZN(sub_8_n480) );
  NOR2_X1 sub_8_U292 ( .A1(sub_8_n480), .A2(sub_8_n481), .ZN(sub_8_n477) );
  INV_X1 sub_8_U291 ( .A(b[11]), .ZN(sub_8_n447) );
  NAND2_X1 sub_8_U290 ( .A1(a[11]), .A2(sub_8_n447), .ZN(sub_8_n439) );
  NOR2_X1 sub_8_U289 ( .A1(b[5]), .A2(sub_8_n12), .ZN(sub_8_n401) );
  INV_X1 sub_8_U288 ( .A(b[10]), .ZN(sub_8_n451) );
  NAND2_X1 sub_8_U287 ( .A1(a[10]), .A2(sub_8_n451), .ZN(sub_8_n440) );
  INV_X1 sub_8_U286 ( .A(a[12]), .ZN(sub_8_n436) );
  NAND2_X1 sub_8_U285 ( .A1(sub_8_n436), .A2(b[12]), .ZN(sub_8_n405) );
  INV_X1 sub_8_U284 ( .A(b[14]), .ZN(sub_8_n423) );
  NAND2_X1 sub_8_U283 ( .A1(a[14]), .A2(sub_8_n423), .ZN(sub_8_n412) );
  INV_X1 sub_8_U282 ( .A(b[12]), .ZN(sub_8_n435) );
  NAND2_X1 sub_8_U281 ( .A1(a[12]), .A2(sub_8_n435), .ZN(sub_8_n411) );
  INV_X1 sub_8_U280 ( .A(a[15]), .ZN(sub_8_n416) );
  NAND2_X1 sub_8_U279 ( .A1(b[15]), .A2(sub_8_n416), .ZN(sub_8_n408) );
  NAND2_X1 sub_8_U278 ( .A1(b[5]), .A2(sub_8_n11), .ZN(sub_8_n470) );
  INV_X1 sub_8_U277 ( .A(a[14]), .ZN(sub_8_n424) );
  NAND2_X1 sub_8_U276 ( .A1(sub_8_n424), .A2(b[14]), .ZN(sub_8_n407) );
  NAND2_X1 sub_8_U275 ( .A1(b[5]), .A2(sub_8_n403), .ZN(sub_8_n164) );
  INV_X1 sub_8_U274 ( .A(a[7]), .ZN(sub_8_n474) );
  INV_X1 sub_8_U273 ( .A(a[16]), .ZN(sub_8_n373) );
  NAND2_X1 sub_8_U272 ( .A1(b[16]), .A2(sub_8_n373), .ZN(sub_8_n334) );
  INV_X1 sub_8_U271 ( .A(b[13]), .ZN(sub_8_n428) );
  INV_X1 sub_8_U270 ( .A(a[4]), .ZN(sub_8_n471) );
  INV_X1 sub_8_U269 ( .A(a[6]), .ZN(sub_8_n479) );
  INV_X1 sub_8_U268 ( .A(a[23]), .ZN(sub_8_n312) );
  NAND2_X1 sub_8_U267 ( .A1(b[23]), .A2(sub_8_n312), .ZN(sub_8_n292) );
  NAND2_X1 sub_8_U266 ( .A1(a[8]), .A2(sub_8_n395), .ZN(sub_8_n393) );
  INV_X1 sub_8_U265 ( .A(b[25]), .ZN(sub_8_n284) );
  INV_X1 sub_8_U264 ( .A(a[20]), .ZN(sub_8_n332) );
  INV_X1 sub_8_U263 ( .A(a[17]), .ZN(sub_8_n369) );
  NAND2_X1 sub_8_U262 ( .A1(b[17]), .A2(sub_8_n369), .ZN(sub_8_n337) );
  INV_X1 sub_8_U261 ( .A(b[23]), .ZN(sub_8_n311) );
  NAND2_X1 sub_8_U260 ( .A1(a[23]), .A2(sub_8_n311), .ZN(sub_8_n293) );
  INV_X1 sub_8_U259 ( .A(b[7]), .ZN(sub_8_n476) );
  NAND2_X1 sub_8_U258 ( .A1(a[7]), .A2(sub_8_n108), .ZN(sub_8_n155) );
  INV_X1 sub_8_U257 ( .A(b[8]), .ZN(sub_8_n395) );
  NAND2_X1 sub_8_U256 ( .A1(a[8]), .A2(sub_8_n395), .ZN(sub_8_n143) );
  NAND2_X1 sub_8_U255 ( .A1(sub_8_n388), .A2(a[0]), .ZN(sub_8_n387) );
  INV_X1 sub_8_U254 ( .A(a[24]), .ZN(sub_8_n288) );
  NAND2_X1 sub_8_U253 ( .A1(b[24]), .A2(sub_8_n288), .ZN(sub_8_n267) );
  INV_X1 sub_8_U252 ( .A(b[16]), .ZN(sub_8_n372) );
  INV_X1 sub_8_U251 ( .A(b[9]), .ZN(sub_8_n454) );
  INV_X1 sub_8_U250 ( .A(a[27]), .ZN(sub_8_n271) );
  NAND2_X1 sub_8_U249 ( .A1(b[27]), .A2(sub_8_n271), .ZN(sub_8_n252) );
  INV_X1 sub_8_U248 ( .A(a[8]), .ZN(sub_8_n444) );
  NAND2_X1 sub_8_U247 ( .A1(sub_8_n383), .A2(sub_8_n49), .ZN(sub_8_n382) );
  INV_X1 sub_8_U246 ( .A(a[2]), .ZN(sub_8_n466) );
  INV_X1 sub_8_U245 ( .A(b[2]), .ZN(sub_8_n240) );
  INV_X1 sub_8_U244 ( .A(a[19]), .ZN(sub_8_n352) );
  NAND2_X1 sub_8_U243 ( .A1(b[19]), .A2(sub_8_n352), .ZN(sub_8_n335) );
  INV_X1 sub_8_U242 ( .A(a[0]), .ZN(sub_8_n465) );
  NAND2_X1 sub_8_U241 ( .A1(sub_8_n61), .A2(b[8]), .ZN(sub_8_n443) );
  NAND4_X1 sub_8_U240 ( .A1(sub_8_n394), .A2(sub_8_n392), .A3(sub_8_n140), 
        .A4(sub_8_n443), .ZN(sub_8_n381) );
  INV_X1 sub_8_U239 ( .A(a[18]), .ZN(sub_8_n358) );
  INV_X1 sub_8_U238 ( .A(a[25]), .ZN(sub_8_n285) );
  NAND2_X1 sub_8_U237 ( .A1(sub_8_n285), .A2(b[25]), .ZN(sub_8_n265) );
  NAND2_X1 sub_8_U236 ( .A1(sub_8_n71), .A2(sub_8_n339), .ZN(sub_8_n204) );
  INV_X1 sub_8_U235 ( .A(b[17]), .ZN(sub_8_n368) );
  NAND2_X1 sub_8_U234 ( .A1(a[17]), .A2(sub_8_n368), .ZN(sub_8_n346) );
  INV_X1 sub_8_U233 ( .A(a[26]), .ZN(sub_8_n281) );
  NAND2_X1 sub_8_U232 ( .A1(sub_8_n54), .A2(sub_8_n52), .ZN(sub_8_n385) );
  INV_X1 sub_8_U231 ( .A(b[3]), .ZN(sub_8_n469) );
  NOR2_X1 sub_8_U230 ( .A1(b[0]), .A2(sub_8_n465), .ZN(sub_8_n463) );
  OAI21_X1 sub_8_U229 ( .B1(sub_8_n464), .B2(sub_8_n463), .A(sub_8_n388), .ZN(
        sub_8_n462) );
  NAND2_X1 sub_8_U228 ( .A1(b[31]), .A2(sub_8_n211), .ZN(sub_8_n183) );
  OR2_X1 sub_8_U227 ( .A1(sub_8_n98), .A2(sub_8_n483), .ZN(diff[0]) );
  INV_X1 sub_8_U226 ( .A(sub_8_n258), .ZN(sub_8_n273) );
  INV_X1 sub_8_U225 ( .A(sub_8_n413), .ZN(sub_8_n420) );
  NAND2_X1 sub_8_U224 ( .A1(sub_8_n101), .A2(sub_8_n179), .ZN(sub_8_n239) );
  XNOR2_X1 sub_8_U223 ( .A(sub_8_n181), .B(sub_8_n239), .ZN(diff[2]) );
  NAND2_X1 sub_8_U222 ( .A1(sub_8_n168), .A2(sub_8_n169), .ZN(sub_8_n171) );
  NAND2_X1 sub_8_U221 ( .A1(sub_8_n98), .A2(sub_8_n350), .ZN(sub_8_n243) );
  OAI21_X1 sub_8_U220 ( .B1(sub_8_n241), .B2(sub_8_n135), .A(sub_8_n242), .ZN(
        sub_8_n181) );
  AND2_X1 sub_8_U219 ( .A1(sub_8_n267), .A2(sub_8_n265), .ZN(sub_8_n120) );
  NAND2_X1 sub_8_U218 ( .A1(sub_8_n146), .A2(sub_8_n393), .ZN(sub_8_n149) );
  NAND2_X1 sub_8_U217 ( .A1(sub_8_n164), .A2(sub_8_n163), .ZN(sub_8_n166) );
  NAND2_X1 sub_8_U216 ( .A1(sub_8_n405), .A2(sub_8_n411), .ZN(sub_8_n434) );
  NOR2_X1 sub_8_U215 ( .A1(sub_8_n198), .A2(sub_8_n199), .ZN(sub_8_n190) );
  AND4_X1 sub_8_U214 ( .A1(sub_8_n209), .A2(sub_8_n200), .A3(sub_8_n210), .A4(
        sub_8_n195), .ZN(sub_8_n119) );
  AND2_X1 sub_8_U213 ( .A1(sub_8_n37), .A2(sub_8_n300), .ZN(sub_8_n118) );
  OAI21_X1 sub_8_U212 ( .B1(sub_8_n144), .B2(sub_8_n145), .A(sub_8_n146), .ZN(
        sub_8_n142) );
  NAND2_X1 sub_8_U211 ( .A1(sub_8_n267), .A2(sub_8_n283), .ZN(sub_8_n287) );
  XNOR2_X1 sub_8_U210 ( .A(sub_8_n449), .B(sub_8_n450), .ZN(diff[10]) );
  NAND2_X1 sub_8_U209 ( .A1(sub_8_n59), .A2(sub_8_n93), .ZN(sub_8_n427) );
  XNOR2_X1 sub_8_U208 ( .A(sub_8_n426), .B(sub_8_n427), .ZN(diff[13]) );
  NAND2_X1 sub_8_U207 ( .A1(sub_8_n337), .A2(sub_8_n346), .ZN(sub_8_n367) );
  XNOR2_X1 sub_8_U206 ( .A(sub_8_n366), .B(sub_8_n367), .ZN(diff[17]) );
  NAND2_X1 sub_8_U205 ( .A1(sub_8_n333), .A2(sub_8_n328), .ZN(sub_8_n329) );
  XNOR2_X1 sub_8_U204 ( .A(sub_8_n329), .B(sub_8_n330), .ZN(diff[20]) );
  NAND2_X1 sub_8_U203 ( .A1(sub_8_n321), .A2(sub_8_n300), .ZN(sub_8_n327) );
  NAND2_X1 sub_8_U202 ( .A1(sub_8_n326), .A2(sub_8_n327), .ZN(sub_8_n322) );
  XNOR2_X1 sub_8_U201 ( .A(sub_8_n322), .B(sub_8_n323), .ZN(diff[21]) );
  XNOR2_X1 sub_8_U200 ( .A(sub_8_n317), .B(sub_8_n318), .ZN(diff[22]) );
  NOR2_X1 sub_8_U199 ( .A1(sub_8_n478), .A2(sub_8_n477), .ZN(sub_8_n472) );
  NAND2_X1 sub_8_U198 ( .A1(sub_8_n210), .A2(sub_8_n196), .ZN(sub_8_n226) );
  XNOR2_X1 sub_8_U197 ( .A(sub_8_n225), .B(sub_8_n226), .ZN(diff[30]) );
  OAI211_X1 sub_8_U196 ( .C1(sub_8_n320), .C2(sub_8_n275), .A(sub_8_n277), .B(
        sub_8_n276), .ZN(sub_8_n278) );
  NAND2_X1 sub_8_U195 ( .A1(sub_8_n263), .A2(sub_8_n258), .ZN(sub_8_n279) );
  XNOR2_X1 sub_8_U194 ( .A(sub_8_n278), .B(sub_8_n279), .ZN(diff[26]) );
  NAND2_X1 sub_8_U193 ( .A1(sub_8_n439), .A2(sub_8_n440), .ZN(sub_8_n391) );
  NOR2_X1 sub_8_U192 ( .A1(sub_8_n91), .A2(sub_8_n364), .ZN(sub_8_n363) );
  OAI211_X1 sub_8_U191 ( .C1(sub_8_n126), .C2(sub_8_n411), .A(sub_8_n412), .B(
        sub_8_n413), .ZN(sub_8_n410) );
  NAND2_X1 sub_8_U190 ( .A1(sub_8_n200), .A2(sub_8_n210), .ZN(sub_8_n223) );
  NAND2_X1 sub_8_U189 ( .A1(sub_8_n209), .A2(sub_8_n199), .ZN(sub_8_n255) );
  NOR2_X1 sub_8_U188 ( .A1(sub_8_n250), .A2(sub_8_n251), .ZN(sub_8_n249) );
  NAND2_X1 sub_8_U187 ( .A1(sub_8_n200), .A2(sub_8_n197), .ZN(sub_8_n245) );
  NAND2_X1 sub_8_U186 ( .A1(sub_8_n339), .A2(sub_8_n23), .ZN(sub_8_n351) );
  NOR3_X1 sub_8_U185 ( .A1(sub_8_n303), .A2(sub_8_n361), .A3(sub_8_n302), .ZN(
        sub_8_n359) );
  NAND2_X1 sub_8_U184 ( .A1(sub_8_n334), .A2(sub_8_n337), .ZN(sub_8_n360) );
  NOR2_X1 sub_8_U183 ( .A1(sub_8_n219), .A2(sub_8_n218), .ZN(sub_8_n217) );
  NAND2_X1 sub_8_U182 ( .A1(sub_8_n101), .A2(sub_8_n389), .ZN(sub_8_n386) );
  XNOR2_X1 sub_8_U181 ( .A(sub_8_n310), .B(sub_8_n39), .ZN(diff[23]) );
  XNOR2_X1 sub_8_U180 ( .A(sub_8_n269), .B(sub_8_n40), .ZN(diff[27]) );
  NAND2_X1 sub_8_U179 ( .A1(sub_8_n309), .A2(sub_8_n13), .ZN(sub_8_n415) );
  XNOR2_X1 sub_8_U178 ( .A(sub_8_n414), .B(sub_8_n415), .ZN(diff[15]) );
  INV_X1 sub_8_U177 ( .A(sub_8_n116), .ZN(sub_8_n458) );
  NOR3_X1 sub_8_U176 ( .A1(sub_8_n303), .A2(sub_8_n301), .A3(sub_8_n302), .ZN(
        sub_8_n289) );
  NOR2_X1 sub_8_U175 ( .A1(sub_8_n386), .A2(sub_8_n387), .ZN(sub_8_n376) );
  NAND2_X1 sub_8_U174 ( .A1(sub_8_n453), .A2(sub_8_n141), .ZN(sub_8_n449) );
  NAND2_X1 sub_8_U173 ( .A1(sub_8_n132), .A2(sub_8_n439), .ZN(sub_8_n446) );
  XNOR2_X1 sub_8_U172 ( .A(sub_8_n445), .B(sub_8_n446), .ZN(diff[11]) );
  OAI21_X1 sub_8_U171 ( .B1(sub_8_n38), .B2(sub_8_n26), .A(sub_8_n93), .ZN(
        sub_8_n421) );
  XNOR2_X1 sub_8_U170 ( .A(sub_8_n421), .B(sub_8_n422), .ZN(diff[14]) );
  NAND2_X1 sub_8_U169 ( .A1(sub_8_n134), .A2(sub_8_n209), .ZN(sub_8_n236) );
  NAND2_X1 sub_8_U168 ( .A1(sub_8_n235), .A2(sub_8_n200), .ZN(sub_8_n219) );
  NAND2_X1 sub_8_U167 ( .A1(sub_8_n154), .A2(sub_8_n107), .ZN(sub_8_n153) );
  XNOR2_X1 sub_8_U166 ( .A(sub_8_n152), .B(sub_8_n153), .ZN(diff[7]) );
  NAND2_X1 sub_8_U165 ( .A1(sub_8_n196), .A2(sub_8_n197), .ZN(sub_8_n191) );
  OAI21_X1 sub_8_U164 ( .B1(sub_8_n190), .B2(sub_8_n191), .A(sub_8_n192), .ZN(
        sub_8_n189) );
  OAI21_X1 sub_8_U163 ( .B1(sub_8_n96), .B2(sub_8_n291), .A(sub_8_n292), .ZN(
        sub_8_n206) );
  NOR2_X1 sub_8_U162 ( .A1(sub_8_n207), .A2(sub_8_n208), .ZN(sub_8_n186) );
  NAND2_X1 sub_8_U161 ( .A1(sub_8_n232), .A2(sub_8_n9), .ZN(sub_8_n230) );
  NAND2_X1 sub_8_U160 ( .A1(sub_8_n120), .A2(sub_8_n75), .ZN(sub_8_n275) );
  NAND2_X1 sub_8_U159 ( .A1(sub_8_n120), .A2(sub_8_n234), .ZN(sub_8_n276) );
  INV_X1 sub_8_U158 ( .A(sub_8_n219), .ZN(sub_8_n232) );
  INV_X1 sub_8_U157 ( .A(sub_8_n161), .ZN(sub_8_n117) );
  AND2_X1 sub_8_U156 ( .A1(b[3]), .A2(sub_8_n467), .ZN(sub_8_n116) );
  INV_X1 sub_8_U155 ( .A(a[1]), .ZN(sub_8_n115) );
  INV_X1 sub_8_U154 ( .A(a[1]), .ZN(sub_8_n114) );
  NAND2_X1 sub_8_U153 ( .A1(sub_8_n307), .A2(sub_8_n89), .ZN(sub_8_n374) );
  NAND2_X1 sub_8_U152 ( .A1(a[20]), .A2(sub_8_n331), .ZN(sub_8_n113) );
  INV_X1 sub_8_U151 ( .A(b[6]), .ZN(sub_8_n112) );
  NAND2_X1 sub_8_U150 ( .A1(a[6]), .A2(sub_8_n112), .ZN(sub_8_n111) );
  NAND2_X1 sub_8_U149 ( .A1(a[6]), .A2(sub_8_n112), .ZN(sub_8_n110) );
  INV_X1 sub_8_U148 ( .A(sub_8_n16), .ZN(sub_8_n109) );
  INV_X1 sub_8_U147 ( .A(b[7]), .ZN(sub_8_n108) );
  NAND2_X1 sub_8_U146 ( .A1(a[7]), .A2(sub_8_n476), .ZN(sub_8_n107) );
  INV_X1 sub_8_U145 ( .A(a[3]), .ZN(sub_8_n105) );
  INV_X1 sub_8_U144 ( .A(a[0]), .ZN(sub_8_n104) );
  NAND2_X1 sub_8_U143 ( .A1(b[2]), .A2(sub_8_n103), .ZN(sub_8_n180) );
  INV_X1 sub_8_U142 ( .A(a[2]), .ZN(sub_8_n103) );
  INV_X1 sub_8_U141 ( .A(a[2]), .ZN(sub_8_n102) );
  NAND2_X1 sub_8_U140 ( .A1(b[2]), .A2(sub_8_n466), .ZN(sub_8_n101) );
  NAND2_X1 sub_8_U139 ( .A1(b[2]), .A2(sub_8_n102), .ZN(sub_8_n100) );
  AND2_X1 sub_8_U138 ( .A1(sub_8_n176), .A2(sub_8_n468), .ZN(sub_8_n99) );
  AND2_X1 sub_8_U137 ( .A1(b[0]), .A2(sub_8_n104), .ZN(sub_8_n125) );
  AND2_X1 sub_8_U136 ( .A1(b[0]), .A2(sub_8_n104), .ZN(sub_8_n98) );
  NAND3_X1 sub_8_U135 ( .A1(sub_8_n87), .A2(sub_8_n127), .A3(sub_8_n20), .ZN(
        sub_8_n97) );
  NAND2_X1 sub_8_U134 ( .A1(sub_8_n479), .A2(b[6]), .ZN(sub_8_n158) );
  NOR2_X1 sub_8_U133 ( .A1(sub_8_n30), .A2(sub_8_n295), .ZN(sub_8_n96) );
  NOR2_X1 sub_8_U132 ( .A1(sub_8_n95), .A2(sub_8_n187), .ZN(sub_8_n184) );
  INV_X1 sub_8_U131 ( .A(b[20]), .ZN(sub_8_n94) );
  NAND2_X1 sub_8_U130 ( .A1(a[13]), .A2(sub_8_n428), .ZN(sub_8_n413) );
  CLKBUF_X1 sub_8_U129 ( .A(sub_8_n413), .Z(sub_8_n93) );
  NAND2_X1 sub_8_U128 ( .A1(sub_8_n6), .A2(b[14]), .ZN(sub_8_n92) );
  AND2_X1 sub_8_U127 ( .A1(sub_8_n410), .A2(sub_8_n409), .ZN(sub_8_n91) );
  NOR2_X1 sub_8_U126 ( .A1(sub_8_n90), .A2(sub_8_n442), .ZN(sub_8_n390) );
  AND2_X1 sub_8_U125 ( .A1(sub_8_n141), .A2(sub_8_n143), .ZN(sub_8_n90) );
  AND2_X1 sub_8_U124 ( .A1(sub_8_n365), .A2(sub_8_n309), .ZN(sub_8_n89) );
  CLKBUF_X1 sub_8_U123 ( .A(sub_8_n224), .Z(sub_8_n88) );
  OAI211_X1 sub_8_U122 ( .C1(sub_8_n376), .C2(sub_8_n377), .A(sub_8_n72), .B(
        sub_8_n396), .ZN(sub_8_n87) );
  AND3_X1 sub_8_U121 ( .A1(sub_8_n458), .A2(sub_8_n101), .A3(sub_8_n459), .ZN(
        sub_8_n86) );
  NAND3_X1 sub_8_U120 ( .A1(sub_8_n260), .A2(sub_8_n261), .A3(sub_8_n36), .ZN(
        sub_8_n253) );
  NAND2_X1 sub_8_U119 ( .A1(b[18]), .A2(sub_8_n81), .ZN(sub_8_n85) );
  INV_X1 sub_8_U118 ( .A(sub_8_n292), .ZN(sub_8_n84) );
  AOI21_X1 sub_8_U117 ( .B1(sub_8_n83), .B2(sub_8_n22), .A(sub_8_n84), .ZN(
        sub_8_n205) );
  AND4_X1 sub_8_U116 ( .A1(sub_8_n200), .A2(sub_8_n234), .A3(sub_8_n210), .A4(
        sub_8_n235), .ZN(sub_8_n220) );
  NAND2_X1 sub_8_U115 ( .A1(sub_8_n469), .A2(a[3]), .ZN(sub_8_n176) );
  NAND2_X1 sub_8_U114 ( .A1(sub_8_n240), .A2(a[2]), .ZN(sub_8_n468) );
  INV_X1 sub_8_U113 ( .A(sub_8_n82), .ZN(sub_8_n95) );
  OAI21_X1 sub_8_U112 ( .B1(sub_8_n375), .B2(sub_8_n17), .A(sub_8_n186), .ZN(
        sub_8_n82) );
  NAND2_X1 sub_8_U111 ( .A1(sub_8_n357), .A2(a[18]), .ZN(sub_8_n344) );
  INV_X1 sub_8_U110 ( .A(a[18]), .ZN(sub_8_n81) );
  OAI211_X1 sub_8_U109 ( .C1(sub_8_n81), .C2(b[18]), .A(sub_8_n343), .B(b[17]), 
        .ZN(sub_8_n342) );
  NAND2_X1 sub_8_U108 ( .A1(sub_8_n372), .A2(a[16]), .ZN(sub_8_n345) );
  NAND2_X1 sub_8_U107 ( .A1(sub_8_n280), .A2(a[26]), .ZN(sub_8_n258) );
  OR2_X1 sub_8_U106 ( .A1(sub_8_n295), .A2(sub_8_n136), .ZN(sub_8_n83) );
  INV_X1 sub_8_U105 ( .A(a[17]), .ZN(sub_8_n80) );
  INV_X1 sub_8_U104 ( .A(a[18]), .ZN(sub_8_n79) );
  INV_X1 sub_8_U103 ( .A(a[16]), .ZN(sub_8_n78) );
  OAI222_X1 sub_8_U102 ( .A1(sub_8_n78), .A2(b[16]), .B1(sub_8_n79), .B2(b[18]), .C1(sub_8_n80), .C2(b[17]), .ZN(sub_8_n341) );
  OR2_X2 sub_8_U101 ( .A1(sub_8_n97), .A2(sub_8_n374), .ZN(sub_8_n123) );
  CLKBUF_X1 sub_8_U100 ( .A(sub_8_n74), .Z(sub_8_n77) );
  OAI21_X1 sub_8_U99 ( .B1(sub_8_n289), .B2(sub_8_n233), .A(sub_8_n24), .ZN(
        sub_8_n268) );
  OAI21_X1 sub_8_U98 ( .B1(sub_8_n289), .B2(sub_8_n233), .A(sub_8_n24), .ZN(
        sub_8_n76) );
  NAND2_X2 sub_8_U97 ( .A1(sub_8_n474), .A2(b[7]), .ZN(sub_8_n154) );
  AND2_X2 sub_8_U96 ( .A1(sub_8_n37), .A2(sub_8_n35), .ZN(sub_8_n75) );
  NAND2_X1 sub_8_U95 ( .A1(sub_8_n338), .A2(sub_8_n339), .ZN(sub_8_n74) );
  NAND2_X1 sub_8_U94 ( .A1(sub_8_n482), .A2(b[9]), .ZN(sub_8_n73) );
  NAND2_X1 sub_8_U93 ( .A1(b[26]), .A2(sub_8_n281), .ZN(sub_8_n263) );
  NOR2_X1 sub_8_U92 ( .A1(sub_8_n116), .A2(sub_8_n57), .ZN(sub_8_n72) );
  NAND3_X1 sub_8_U91 ( .A1(sub_8_n340), .A2(sub_8_n342), .A3(sub_8_n341), .ZN(
        sub_8_n71) );
  NAND2_X1 sub_8_U90 ( .A1(b[10]), .A2(sub_8_n452), .ZN(sub_8_n70) );
  OAI222_X1 sub_8_U89 ( .A1(sub_8_n78), .A2(b[16]), .B1(sub_8_n79), .B2(b[18]), 
        .C1(sub_8_n80), .C2(b[17]), .ZN(sub_8_n69) );
  AND2_X1 sub_8_U88 ( .A1(sub_8_n335), .A2(sub_8_n336), .ZN(sub_8_n68) );
  OAI21_X1 sub_8_U87 ( .B1(sub_8_n472), .B2(sub_8_n473), .A(sub_8_n154), .ZN(
        sub_8_n151) );
  CLKBUF_X1 sub_8_U86 ( .A(sub_8_n170), .Z(sub_8_n67) );
  NOR2_X1 sub_8_U85 ( .A1(sub_8_n460), .A2(sub_8_n53), .ZN(sub_8_n66) );
  OAI21_X1 sub_8_U84 ( .B1(sub_8_n359), .B2(sub_8_n360), .A(sub_8_n346), .ZN(
        sub_8_n355) );
  OAI21_X1 sub_8_U83 ( .B1(sub_8_n359), .B2(sub_8_n360), .A(sub_8_n346), .ZN(
        sub_8_n65) );
  NAND2_X1 sub_8_U82 ( .A1(sub_8_n354), .A2(sub_8_n344), .ZN(sub_8_n64) );
  XNOR2_X1 sub_8_U81 ( .A(sub_8_n64), .B(sub_8_n351), .ZN(diff[19]) );
  OR2_X1 sub_8_U80 ( .A1(sub_8_n97), .A2(sub_8_n17), .ZN(sub_8_n122) );
  INV_X1 sub_8_U79 ( .A(a[9]), .ZN(sub_8_n63) );
  NAND2_X1 sub_8_U78 ( .A1(sub_8_n5), .A2(b[6]), .ZN(sub_8_n62) );
  INV_X1 sub_8_U77 ( .A(a[8]), .ZN(sub_8_n61) );
  INV_X1 sub_8_U76 ( .A(a[10]), .ZN(sub_8_n60) );
  CLKBUF_X1 sub_8_U75 ( .A(sub_8_n406), .Z(sub_8_n59) );
  CLKBUF_X1 sub_8_U74 ( .A(sub_8_n57), .Z(sub_8_n124) );
  AND2_X1 sub_8_U73 ( .A1(sub_8_n393), .A2(sub_8_n58), .ZN(sub_8_n441) );
  NAND2_X1 sub_8_U72 ( .A1(a[9]), .A2(sub_8_n454), .ZN(sub_8_n58) );
  NAND4_X1 sub_8_U71 ( .A1(sub_8_n470), .A2(sub_8_n169), .A3(sub_8_n158), .A4(
        sub_8_n154), .ZN(sub_8_n57) );
  NAND2_X1 sub_8_U70 ( .A1(b[26]), .A2(sub_8_n281), .ZN(sub_8_n56) );
  BUF_X1 sub_8_U69 ( .A(sub_8_n109), .Z(sub_8_n55) );
  NAND2_X1 sub_8_U68 ( .A1(sub_8_n469), .A2(a[3]), .ZN(sub_8_n54) );
  AND2_X1 sub_8_U67 ( .A1(sub_8_n385), .A2(sub_8_n175), .ZN(sub_8_n53) );
  NAND2_X1 sub_8_U66 ( .A1(sub_8_n240), .A2(a[2]), .ZN(sub_8_n52) );
  BUF_X1 sub_8_U65 ( .A(sub_8_n133), .Z(sub_8_n51) );
  AND2_X1 sub_8_U64 ( .A1(b[4]), .A2(sub_8_n471), .ZN(sub_8_n50) );
  NAND2_X1 sub_8_U63 ( .A1(b[2]), .A2(sub_8_n102), .ZN(sub_8_n49) );
  INV_X1 sub_8_U62 ( .A(b[2]), .ZN(sub_8_n48) );
  AND2_X1 sub_8_U61 ( .A1(sub_8_n141), .A2(sub_8_n440), .ZN(sub_8_n47) );
  INV_X1 sub_8_U60 ( .A(sub_8_n440), .ZN(sub_8_n46) );
  OR2_X1 sub_8_U59 ( .A1(sub_8_n46), .A2(sub_8_n70), .ZN(sub_8_n45) );
  AND2_X1 sub_8_U58 ( .A1(sub_8_n455), .A2(sub_8_n45), .ZN(sub_8_n44) );
  INV_X1 sub_8_U57 ( .A(sub_8_n45), .ZN(sub_8_n43) );
  OR2_X1 sub_8_U56 ( .A1(sub_8_n43), .A2(sub_8_n47), .ZN(sub_8_n42) );
  NAND2_X1 sub_8_U55 ( .A1(sub_8_n41), .A2(sub_8_n42), .ZN(sub_8_n445) );
  NAND2_X1 sub_8_U54 ( .A1(sub_8_n456), .A2(sub_8_n44), .ZN(sub_8_n41) );
  AND2_X1 sub_8_U53 ( .A1(sub_8_n252), .A2(sub_8_n259), .ZN(sub_8_n40) );
  AND2_X1 sub_8_U52 ( .A1(sub_8_n292), .A2(sub_8_n293), .ZN(sub_8_n39) );
  AND2_X1 sub_8_U51 ( .A1(sub_8_n425), .A2(sub_8_n411), .ZN(sub_8_n38) );
  AND4_X1 sub_8_U50 ( .A1(sub_8_n334), .A2(sub_8_n23), .A3(sub_8_n85), .A4(
        sub_8_n337), .ZN(sub_8_n37) );
  AND2_X1 sub_8_U49 ( .A1(sub_8_n258), .A2(sub_8_n259), .ZN(sub_8_n36) );
  NAND2_X1 sub_8_U48 ( .A1(b[28]), .A2(sub_8_n257), .ZN(sub_8_n209) );
  NAND2_X1 sub_8_U47 ( .A1(sub_8_n332), .A2(b[20]), .ZN(sub_8_n300) );
  AND2_X1 sub_8_U46 ( .A1(b[13]), .A2(sub_8_n429), .ZN(sub_8_n126) );
  INV_X1 sub_8_U45 ( .A(sub_8_n75), .ZN(sub_8_n233) );
  NAND2_X1 sub_8_U44 ( .A1(sub_8_n324), .A2(a[21]), .ZN(sub_8_n34) );
  OR2_X1 sub_8_U43 ( .A1(sub_8_n319), .A2(b[22]), .ZN(sub_8_n33) );
  NAND2_X1 sub_8_U42 ( .A1(sub_8_n325), .A2(b[21]), .ZN(sub_8_n32) );
  NAND2_X1 sub_8_U41 ( .A1(b[22]), .A2(sub_8_n319), .ZN(sub_8_n31) );
  AND2_X1 sub_8_U40 ( .A1(sub_8_n25), .A2(sub_8_n34), .ZN(sub_8_n30) );
  INV_X1 sub_8_U39 ( .A(a[21]), .ZN(sub_8_n29) );
  INV_X1 sub_8_U38 ( .A(a[22]), .ZN(sub_8_n28) );
  BUF_X1 sub_8_U37 ( .A(sub_8_n143), .Z(sub_8_n27) );
  AND4_X1 sub_8_U36 ( .A1(sub_8_n267), .A2(sub_8_n252), .A3(sub_8_n56), .A4(
        sub_8_n265), .ZN(sub_8_n134) );
  INV_X1 sub_8_U35 ( .A(sub_8_n59), .ZN(sub_8_n26) );
  NAND2_X1 sub_8_U34 ( .A1(sub_8_n331), .A2(a[20]), .ZN(sub_8_n25) );
  AND2_X1 sub_8_U33 ( .A1(sub_8_n290), .A2(sub_8_n206), .ZN(sub_8_n24) );
  NAND2_X1 sub_8_U32 ( .A1(b[19]), .A2(sub_8_n352), .ZN(sub_8_n23) );
  AND2_X1 sub_8_U31 ( .A1(sub_8_n293), .A2(sub_8_n294), .ZN(sub_8_n22) );
  NOR2_X1 sub_8_U30 ( .A1(sub_8_n135), .A2(sub_8_n125), .ZN(sub_8_n21) );
  OAI211_X1 sub_8_U29 ( .C1(sub_8_n390), .C2(sub_8_n391), .A(sub_8_n131), .B(
        sub_8_n132), .ZN(sub_8_n305) );
  OAI211_X1 sub_8_U28 ( .C1(sub_8_n390), .C2(sub_8_n391), .A(sub_8_n131), .B(
        sub_8_n132), .ZN(sub_8_n20) );
  INV_X1 sub_8_U27 ( .A(b[21]), .ZN(sub_8_n19) );
  AND4_X2 sub_8_U26 ( .A1(sub_8_n300), .A2(sub_8_n292), .A3(sub_8_n31), .A4(
        sub_8_n32), .ZN(sub_8_n35) );
  INV_X4 sub_8_U25 ( .A(sub_8_n18), .ZN(sub_8_n202) );
  AND2_X1 sub_8_U24 ( .A1(sub_8_n253), .A2(sub_8_n252), .ZN(sub_8_n18) );
  NAND2_X1 sub_8_U23 ( .A1(sub_8_n307), .A2(sub_8_n89), .ZN(sub_8_n17) );
  AND4_X1 sub_8_U22 ( .A1(sub_8_n394), .A2(sub_8_n392), .A3(sub_8_n443), .A4(
        sub_8_n140), .ZN(sub_8_n16) );
  AND2_X1 sub_8_U21 ( .A1(sub_8_n265), .A2(sub_8_n264), .ZN(sub_8_n15) );
  AND2_X1 sub_8_U20 ( .A1(sub_8_n286), .A2(sub_8_n283), .ZN(sub_8_n14) );
  XNOR2_X1 sub_8_U19 ( .A(sub_8_n14), .B(sub_8_n15), .ZN(diff[25]) );
  NAND2_X1 sub_8_U18 ( .A1(b[15]), .A2(sub_8_n416), .ZN(sub_8_n13) );
  INV_X1 sub_8_U17 ( .A(a[5]), .ZN(sub_8_n403) );
  INV_X1 sub_8_U16 ( .A(a[5]), .ZN(sub_8_n12) );
  INV_X1 sub_8_U15 ( .A(a[5]), .ZN(sub_8_n11) );
  INV_X1 sub_8_U14 ( .A(a[11]), .ZN(sub_8_n10) );
  INV_X1 sub_8_U13 ( .A(sub_8_n24), .ZN(sub_8_n9) );
  NAND4_X1 sub_8_U12 ( .A1(sub_8_n267), .A2(sub_8_n252), .A3(sub_8_n56), .A4(
        sub_8_n265), .ZN(sub_8_n8) );
  NAND2_X1 sub_8_U11 ( .A1(sub_8_n285), .A2(b[25]), .ZN(sub_8_n7) );
  INV_X1 sub_8_U10 ( .A(a[14]), .ZN(sub_8_n6) );
  INV_X1 sub_8_U9 ( .A(a[6]), .ZN(sub_8_n5) );
  NAND2_X1 sub_8_U8 ( .A1(sub_8_n432), .A2(sub_8_n109), .ZN(sub_8_n4) );
  AND2_X1 sub_8_U7 ( .A1(sub_8_n4), .A2(sub_8_n405), .ZN(sub_8_n430) );
  BUF_X1 sub_8_U6 ( .A(sub_8_n432), .Z(sub_8_n3) );
  NOR2_X1 sub_8_U5 ( .A1(sub_8_n462), .A2(sub_8_n461), .ZN(sub_8_n2) );
  BUF_X1 sub_8_U4 ( .A(sub_8_n3), .Z(sub_8_n1) );
  AND2_X2 sub_8_U3 ( .A1(sub_8_n66), .A2(sub_8_n404), .ZN(sub_8_n106) );
endmodule

