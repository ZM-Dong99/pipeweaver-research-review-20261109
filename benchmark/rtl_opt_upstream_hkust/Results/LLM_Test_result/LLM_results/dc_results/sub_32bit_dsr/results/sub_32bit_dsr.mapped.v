/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Tue May 13 12:40:12 2025
/////////////////////////////////////////////////////////////


module sub_32bit_dsr ( a, b, diff, overflow );
  input [31:0] a;
  input [31:0] b;
  output [31:0] diff;
  output overflow;
  wire   full_sub_32_, n5, n6, sub_8_n493, sub_8_n492, sub_8_n491, sub_8_n490,
         sub_8_n489, sub_8_n488, sub_8_n487, sub_8_n486, sub_8_n485,
         sub_8_n484, sub_8_n483, sub_8_n482, sub_8_n481, sub_8_n480,
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
         sub_8_n124, sub_8_n123, sub_8_n122, sub_8_n121, sub_8_n120,
         sub_8_n119, sub_8_n118, sub_8_n117, sub_8_n116, sub_8_n115,
         sub_8_n114, sub_8_n113, sub_8_n112, sub_8_n111, sub_8_n110,
         sub_8_n109, sub_8_n108, sub_8_n107, sub_8_n106, sub_8_n105,
         sub_8_n104, sub_8_n103, sub_8_n102, sub_8_n101, sub_8_n100, sub_8_n99,
         sub_8_n98, sub_8_n97, sub_8_n96, sub_8_n95, sub_8_n94, sub_8_n93,
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

  XNOR2_X1 U6 ( .A(a[31]), .B(b[31]), .ZN(n5) );
  NOR2_X1 U7 ( .A1(n6), .A2(n5), .ZN(overflow) );
  XNOR2_X1 U8 ( .A(diff[31]), .B(full_sub_32_), .ZN(n6) );
  INV_X1 sub_8_U527 ( .A(sub_8_n361), .ZN(sub_8_n492) );
  NAND3_X1 sub_8_U526 ( .A1(sub_8_n110), .A2(sub_8_n171), .A3(sub_8_n100), 
        .ZN(sub_8_n400) );
  XNOR2_X1 sub_8_U525 ( .A(sub_8_n457), .B(sub_8_n458), .ZN(diff[10]) );
  NAND3_X1 sub_8_U524 ( .A1(sub_8_n449), .A2(sub_8_n26), .A3(sub_8_n446), .ZN(
        sub_8_n448) );
  INV_X1 sub_8_U523 ( .A(sub_8_n438), .ZN(sub_8_n444) );
  INV_X1 sub_8_U522 ( .A(sub_8_n425), .ZN(sub_8_n442) );
  INV_X1 sub_8_U521 ( .A(sub_8_n419), .ZN(sub_8_n439) );
  NOR2_X1 sub_8_U520 ( .A1(sub_8_n442), .A2(sub_8_n439), .ZN(sub_8_n441) );
  NAND2_X1 sub_8_U519 ( .A1(sub_8_n426), .A2(sub_8_n425), .ZN(sub_8_n432) );
  XNOR2_X1 sub_8_U518 ( .A(sub_8_n432), .B(sub_8_n433), .ZN(diff[13]) );
  INV_X1 sub_8_U517 ( .A(sub_8_n16), .ZN(sub_8_n401) );
  NAND3_X1 sub_8_U516 ( .A1(a[12]), .A2(sub_8_n394), .A3(sub_8_n126), .ZN(
        sub_8_n393) );
  NAND2_X1 sub_8_U515 ( .A1(sub_8_n300), .A2(sub_8_n301), .ZN(sub_8_n389) );
  INV_X1 sub_8_U514 ( .A(sub_8_n357), .ZN(sub_8_n384) );
  XNOR2_X1 sub_8_U513 ( .A(sub_8_n381), .B(sub_8_n382), .ZN(diff[17]) );
  INV_X1 sub_8_U512 ( .A(sub_8_n370), .ZN(sub_8_n377) );
  INV_X1 sub_8_U511 ( .A(sub_8_n380), .ZN(sub_8_n379) );
  INV_X1 sub_8_U510 ( .A(sub_8_n369), .ZN(sub_8_n378) );
  XNOR2_X1 sub_8_U509 ( .A(sub_8_n372), .B(sub_8_n373), .ZN(diff[18]) );
  INV_X1 sub_8_U508 ( .A(sub_8_n371), .ZN(sub_8_n367) );
  INV_X1 sub_8_U507 ( .A(sub_8_n350), .ZN(sub_8_n346) );
  INV_X1 sub_8_U506 ( .A(sub_8_n349), .ZN(sub_8_n348) );
  INV_X1 sub_8_U505 ( .A(sub_8_n69), .ZN(sub_8_n342) );
  XNOR2_X1 sub_8_U504 ( .A(sub_8_n338), .B(sub_8_n339), .ZN(diff[20]) );
  INV_X1 sub_8_U503 ( .A(sub_8_n308), .ZN(sub_8_n337) );
  XNOR2_X1 sub_8_U502 ( .A(sub_8_n333), .B(sub_8_n334), .ZN(diff[21]) );
  INV_X1 sub_8_U501 ( .A(sub_8_n332), .ZN(sub_8_n331) );
  INV_X1 sub_8_U500 ( .A(sub_8_n307), .ZN(sub_8_n328) );
  INV_X1 sub_8_U499 ( .A(sub_8_n321), .ZN(sub_8_n329) );
  XNOR2_X1 sub_8_U498 ( .A(sub_8_n323), .B(sub_8_n324), .ZN(diff[22]) );
  INV_X1 sub_8_U497 ( .A(sub_8_n322), .ZN(sub_8_n319) );
  NAND2_X1 sub_8_U496 ( .A1(sub_8_n87), .A2(sub_8_n309), .ZN(sub_8_n304) );
  NOR2_X1 sub_8_U495 ( .A1(sub_8_n47), .A2(sub_8_n9), .ZN(sub_8_n305) );
  NAND3_X1 sub_8_U494 ( .A1(sub_8_n307), .A2(sub_8_n308), .A3(sub_8_n309), 
        .ZN(sub_8_n306) );
  NAND3_X1 sub_8_U493 ( .A1(sub_8_n305), .A2(sub_8_n304), .A3(sub_8_n306), 
        .ZN(sub_8_n302) );
  INV_X1 sub_8_U492 ( .A(sub_8_n233), .ZN(sub_8_n192) );
  INV_X1 sub_8_U491 ( .A(sub_8_n301), .ZN(sub_8_n215) );
  NAND2_X1 sub_8_U490 ( .A1(sub_8_n299), .A2(sub_8_n214), .ZN(sub_8_n297) );
  NAND3_X1 sub_8_U489 ( .A1(sub_8_n17), .A2(sub_8_n211), .A3(sub_8_n134), .ZN(
        sub_8_n298) );
  OAI21_X1 sub_8_U488 ( .B1(sub_8_n297), .B2(sub_8_n298), .A(sub_8_n105), .ZN(
        sub_8_n296) );
  INV_X1 sub_8_U487 ( .A(sub_8_n261), .ZN(sub_8_n278) );
  NOR2_X1 sub_8_U486 ( .A1(sub_8_n21), .A2(sub_8_n66), .ZN(sub_8_n289) );
  NAND3_X1 sub_8_U485 ( .A1(sub_8_n287), .A2(sub_8_n214), .A3(sub_8_n134), 
        .ZN(sub_8_n284) );
  NAND3_X1 sub_8_U484 ( .A1(sub_8_n192), .A2(sub_8_n193), .A3(sub_8_n282), 
        .ZN(sub_8_n279) );
  INV_X1 sub_8_U483 ( .A(sub_8_n263), .ZN(sub_8_n281) );
  NOR2_X1 sub_8_U482 ( .A1(sub_8_n66), .A2(sub_8_n281), .ZN(sub_8_n280) );
  NAND2_X1 sub_8_U481 ( .A1(sub_8_n279), .A2(sub_8_n280), .ZN(sub_8_n276) );
  XNOR2_X1 sub_8_U480 ( .A(sub_8_n271), .B(sub_8_n272), .ZN(diff[26]) );
  INV_X1 sub_8_U479 ( .A(sub_8_n271), .ZN(sub_8_n270) );
  XNOR2_X1 sub_8_U478 ( .A(sub_8_n266), .B(sub_8_n267), .ZN(diff[27]) );
  NAND3_X1 sub_8_U477 ( .A1(sub_8_n248), .A2(sub_8_n247), .A3(sub_8_n246), 
        .ZN(sub_8_n191) );
  INV_X1 sub_8_U476 ( .A(sub_8_n191), .ZN(sub_8_n254) );
  OAI21_X1 sub_8_U475 ( .B1(sub_8_n46), .B2(sub_8_n249), .A(sub_8_n254), .ZN(
        sub_8_n250) );
  XNOR2_X1 sub_8_U474 ( .A(sub_8_n250), .B(sub_8_n251), .ZN(diff[28]) );
  NAND2_X1 sub_8_U473 ( .A1(sub_8_n198), .A2(sub_8_n131), .ZN(sub_8_n244) );
  OAI21_X1 sub_8_U472 ( .B1(sub_8_n46), .B2(sub_8_n244), .A(sub_8_n245), .ZN(
        sub_8_n241) );
  INV_X1 sub_8_U471 ( .A(sub_8_n240), .ZN(sub_8_n238) );
  AND3_X2 sub_8_U470 ( .A1(sub_8_n198), .A2(sub_8_n186), .A3(sub_8_n136), .ZN(
        sub_8_n231) );
  NAND3_X1 sub_8_U469 ( .A1(sub_8_n230), .A2(sub_8_n102), .A3(sub_8_n229), 
        .ZN(sub_8_n225) );
  INV_X1 sub_8_U468 ( .A(sub_8_n185), .ZN(sub_8_n222) );
  INV_X1 sub_8_U467 ( .A(sub_8_n187), .ZN(sub_8_n220) );
  NAND2_X1 sub_8_U466 ( .A1(sub_8_n221), .A2(sub_8_n187), .ZN(sub_8_n217) );
  AOI21_X1 sub_8_U465 ( .B1(sub_8_n120), .B2(sub_8_n187), .A(sub_8_n219), .ZN(
        sub_8_n218) );
  NAND3_X1 sub_8_U464 ( .A1(sub_8_n216), .A2(sub_8_n217), .A3(sub_8_n218), 
        .ZN(sub_8_n204) );
  NAND2_X1 sub_8_U463 ( .A1(sub_8_n214), .A2(sub_8_n213), .ZN(sub_8_n208) );
  NAND3_X1 sub_8_U462 ( .A1(sub_8_n128), .A2(sub_8_n212), .A3(sub_8_n211), 
        .ZN(sub_8_n209) );
  NOR2_X1 sub_8_U461 ( .A1(sub_8_n208), .A2(sub_8_n209), .ZN(sub_8_n206) );
  NAND2_X1 sub_8_U460 ( .A1(sub_8_n15), .A2(sub_8_n105), .ZN(sub_8_n207) );
  INV_X1 sub_8_U459 ( .A(sub_8_n182), .ZN(sub_8_n201) );
  NOR2_X1 sub_8_U458 ( .A1(sub_8_n201), .A2(sub_8_n93), .ZN(sub_8_n200) );
  NAND2_X1 sub_8_U457 ( .A1(sub_8_n11), .A2(sub_8_n131), .ZN(sub_8_n195) );
  INV_X1 sub_8_U456 ( .A(sub_8_n180), .ZN(sub_8_n197) );
  NAND2_X1 sub_8_U455 ( .A1(sub_8_n112), .A2(sub_8_n197), .ZN(sub_8_n196) );
  INV_X1 sub_8_U454 ( .A(sub_8_n175), .ZN(sub_8_n173) );
  OAI21_X1 sub_8_U453 ( .B1(sub_8_n173), .B2(sub_8_n129), .A(sub_8_n89), .ZN(
        sub_8_n169) );
  XNOR2_X1 sub_8_U452 ( .A(sub_8_n169), .B(sub_8_n170), .ZN(diff[3]) );
  INV_X1 sub_8_U451 ( .A(sub_8_n166), .ZN(sub_8_n164) );
  INV_X1 sub_8_U450 ( .A(sub_8_n162), .ZN(sub_8_n158) );
  INV_X1 sub_8_U449 ( .A(sub_8_n72), .ZN(sub_8_n159) );
  XNOR2_X1 sub_8_U448 ( .A(sub_8_n25), .B(sub_8_n156), .ZN(diff[6]) );
  OAI21_X1 sub_8_U447 ( .B1(sub_8_n32), .B2(sub_8_n149), .A(sub_8_n146), .ZN(
        sub_8_n147) );
  XNOR2_X1 sub_8_U446 ( .A(sub_8_n147), .B(sub_8_n148), .ZN(diff[8]) );
  NAND2_X1 sub_8_U445 ( .A1(sub_8_n355), .A2(sub_8_n75), .ZN(sub_8_n343) );
  NAND2_X1 sub_8_U444 ( .A1(sub_8_n135), .A2(sub_8_n55), .ZN(sub_8_n282) );
  NAND2_X1 sub_8_U443 ( .A1(sub_8_n112), .A2(sub_8_n312), .ZN(sub_8_n332) );
  NAND2_X1 sub_8_U442 ( .A1(sub_8_n379), .A2(sub_8_n75), .ZN(sub_8_n369) );
  NAND2_X1 sub_8_U441 ( .A1(sub_8_n357), .A2(sub_8_n76), .ZN(sub_8_n371) );
  NAND2_X1 sub_8_U440 ( .A1(sub_8_n75), .A2(sub_8_n370), .ZN(sub_8_n382) );
  XNOR2_X1 sub_8_U439 ( .A(sub_8_n199), .B(sub_8_n200), .ZN(diff[31]) );
  INV_X1 sub_8_U438 ( .A(a[21]), .ZN(sub_8_n336) );
  NOR2_X1 sub_8_U437 ( .A1(sub_8_n204), .A2(sub_8_n205), .ZN(sub_8_n199) );
  OAI21_X1 sub_8_U436 ( .B1(sub_8_n34), .B2(sub_8_n322), .A(sub_8_n327), .ZN(
        sub_8_n323) );
  OAI21_X1 sub_8_U435 ( .B1(sub_8_n42), .B2(sub_8_n332), .A(sub_8_n35), .ZN(
        sub_8_n333) );
  OAI21_X1 sub_8_U434 ( .B1(sub_8_n34), .B2(sub_8_n371), .A(sub_8_n376), .ZN(
        sub_8_n372) );
  OAI21_X1 sub_8_U433 ( .B1(sub_8_n34), .B2(sub_8_n384), .A(sub_8_n380), .ZN(
        sub_8_n381) );
  OAI21_X1 sub_8_U432 ( .B1(sub_8_n42), .B2(sub_8_n130), .A(sub_8_n342), .ZN(
        sub_8_n338) );
  NAND2_X1 sub_8_U431 ( .A1(sub_8_n174), .A2(sub_8_n172), .ZN(sub_8_n478) );
  AOI21_X1 sub_8_U430 ( .B1(sub_8_n413), .B2(sub_8_n412), .A(sub_8_n48), .ZN(
        sub_8_n411) );
  OAI211_X1 sub_8_U429 ( .C1(sub_8_n60), .C2(sub_8_n149), .A(sub_8_n438), .B(
        sub_8_n146), .ZN(sub_8_n437) );
  OAI21_X1 sub_8_U428 ( .B1(sub_8_n32), .B2(sub_8_n164), .A(sub_8_n51), .ZN(
        sub_8_n162) );
  NAND2_X1 sub_8_U427 ( .A1(sub_8_n437), .A2(sub_8_n436), .ZN(sub_8_n426) );
  NAND2_X1 sub_8_U426 ( .A1(sub_8_n100), .A2(sub_8_n89), .ZN(sub_8_n236) );
  AOI21_X1 sub_8_U425 ( .B1(sub_8_n176), .B2(sub_8_n319), .A(sub_8_n320), .ZN(
        sub_8_n318) );
  AOI21_X1 sub_8_U424 ( .B1(sub_8_n176), .B2(sub_8_n367), .A(sub_8_n368), .ZN(
        sub_8_n366) );
  NAND2_X1 sub_8_U423 ( .A1(sub_8_n45), .A2(sub_8_n123), .ZN(sub_8_n230) );
  AOI21_X1 sub_8_U422 ( .B1(sub_8_n45), .B2(sub_8_n177), .A(sub_8_n178), .ZN(
        full_sub_32_) );
  OAI21_X1 sub_8_U421 ( .B1(sub_8_n318), .B2(sub_8_n47), .A(sub_8_n309), .ZN(
        sub_8_n314) );
  XNOR2_X1 sub_8_U420 ( .A(sub_8_n45), .B(sub_8_n385), .ZN(diff[16]) );
  NOR2_X1 sub_8_U419 ( .A1(sub_8_n206), .A2(sub_8_n207), .ZN(sub_8_n205) );
  NAND2_X1 sub_8_U418 ( .A1(sub_8_n114), .A2(sub_8_n70), .ZN(sub_8_n156) );
  INV_X1 sub_8_U417 ( .A(b[6]), .ZN(sub_8_n471) );
  NAND2_X1 sub_8_U416 ( .A1(a[6]), .A2(sub_8_n67), .ZN(sub_8_n157) );
  OAI21_X1 sub_8_U415 ( .B1(sub_8_n106), .B2(sub_8_n424), .A(sub_8_n116), .ZN(
        sub_8_n420) );
  XNOR2_X1 sub_8_U414 ( .A(sub_8_n420), .B(sub_8_n421), .ZN(diff[15]) );
  AND2_X1 sub_8_U413 ( .A1(sub_8_n409), .A2(sub_8_n95), .ZN(sub_8_n408) );
  NAND2_X1 sub_8_U412 ( .A1(sub_8_n44), .A2(sub_8_n95), .ZN(sub_8_n146) );
  OAI21_X1 sub_8_U411 ( .B1(sub_8_n366), .B2(sub_8_n57), .A(sub_8_n350), .ZN(
        sub_8_n362) );
  NAND2_X1 sub_8_U410 ( .A1(sub_8_n81), .A2(sub_8_n53), .ZN(sub_8_n168) );
  NAND2_X1 sub_8_U409 ( .A1(sub_8_n234), .A2(sub_8_n235), .ZN(sub_8_n224) );
  NAND2_X1 sub_8_U408 ( .A1(sub_8_n14), .A2(sub_8_n198), .ZN(sub_8_n245) );
  NOR2_X1 sub_8_U407 ( .A1(b[1]), .A2(sub_8_n74), .ZN(sub_8_n486) );
  NAND2_X1 sub_8_U406 ( .A1(b[1]), .A2(sub_8_n13), .ZN(sub_8_n416) );
  NAND2_X1 sub_8_U405 ( .A1(b[1]), .A2(sub_8_n52), .ZN(sub_8_n359) );
  NOR2_X1 sub_8_U404 ( .A1(b[1]), .A2(sub_8_n127), .ZN(sub_8_n415) );
  NOR2_X1 sub_8_U403 ( .A1(sub_8_n484), .A2(sub_8_n483), .ZN(sub_8_n477) );
  NAND2_X1 sub_8_U402 ( .A1(sub_8_n167), .A2(sub_8_n4), .ZN(sub_8_n145) );
  NAND2_X1 sub_8_U401 ( .A1(sub_8_n457), .A2(sub_8_n61), .ZN(sub_8_n456) );
  XNOR2_X1 sub_8_U400 ( .A(sub_8_n167), .B(sub_8_n168), .ZN(diff[4]) );
  NOR2_X1 sub_8_U399 ( .A1(sub_8_n78), .A2(sub_8_n215), .ZN(sub_8_n287) );
  NOR2_X1 sub_8_U398 ( .A1(sub_8_n78), .A2(sub_8_n215), .ZN(sub_8_n299) );
  NAND2_X1 sub_8_U397 ( .A1(a[7]), .A2(sub_8_n85), .ZN(sub_8_n153) );
  AND2_X1 sub_8_U396 ( .A1(sub_8_n157), .A2(sub_8_n153), .ZN(sub_8_n469) );
  NAND4_X1 sub_8_U395 ( .A1(sub_8_n90), .A2(sub_8_n117), .A3(sub_8_n119), .A4(
        sub_8_n125), .ZN(sub_8_n212) );
  NAND4_X1 sub_8_U394 ( .A1(sub_8_n411), .A2(sub_8_n117), .A3(sub_8_n119), 
        .A4(sub_8_n125), .ZN(sub_8_n134) );
  NOR2_X1 sub_8_U393 ( .A1(sub_8_n418), .A2(b[0]), .ZN(sub_8_n414) );
  NOR2_X1 sub_8_U392 ( .A1(b[0]), .A2(sub_8_n101), .ZN(sub_8_n485) );
  INV_X1 sub_8_U391 ( .A(a[0]), .ZN(sub_8_n418) );
  NOR2_X1 sub_8_U390 ( .A1(sub_8_n220), .A2(sub_8_n224), .ZN(sub_8_n223) );
  NAND2_X1 sub_8_U389 ( .A1(sub_8_n224), .A2(sub_8_n188), .ZN(sub_8_n232) );
  NAND4_X1 sub_8_U388 ( .A1(sub_8_n125), .A2(sub_8_n113), .A3(sub_8_n119), 
        .A4(sub_8_n117), .ZN(sub_8_n214) );
  NAND2_X1 sub_8_U387 ( .A1(sub_8_n474), .A2(sub_8_n400), .ZN(sub_8_n167) );
  NAND4_X1 sub_8_U386 ( .A1(sub_8_n27), .A2(sub_8_n446), .A3(sub_8_n406), .A4(
        sub_8_n144), .ZN(sub_8_n410) );
  NOR2_X1 sub_8_U385 ( .A1(sub_8_n405), .A2(sub_8_n410), .ZN(sub_8_n407) );
  AOI21_X1 sub_8_U384 ( .B1(sub_8_n438), .B2(sub_8_n10), .A(sub_8_n439), .ZN(
        sub_8_n436) );
  NAND2_X1 sub_8_U383 ( .A1(sub_8_n27), .A2(sub_8_n63), .ZN(sub_8_n462) );
  AOI21_X1 sub_8_U382 ( .B1(sub_8_n145), .B2(sub_8_n146), .A(sub_8_n10), .ZN(
        sub_8_n445) );
  NAND2_X1 sub_8_U381 ( .A1(sub_8_n143), .A2(sub_8_n63), .ZN(sub_8_n142) );
  NAND2_X1 sub_8_U380 ( .A1(sub_8_n63), .A2(sub_8_n77), .ZN(sub_8_n148) );
  XNOR2_X1 sub_8_U379 ( .A(sub_8_n314), .B(sub_8_n315), .ZN(diff[23]) );
  NAND2_X1 sub_8_U378 ( .A1(b[6]), .A2(sub_8_n82), .ZN(sub_8_n154) );
  NAND4_X1 sub_8_U377 ( .A1(sub_8_n53), .A2(sub_8_n72), .A3(sub_8_n114), .A4(
        sub_8_n94), .ZN(sub_8_n149) );
  NAND2_X1 sub_8_U376 ( .A1(sub_8_n161), .A2(sub_8_n154), .ZN(sub_8_n468) );
  AOI21_X1 sub_8_U375 ( .B1(sub_8_n155), .B2(sub_8_n115), .A(sub_8_n99), .ZN(
        sub_8_n150) );
  AND4_X1 sub_8_U374 ( .A1(sub_8_n113), .A2(sub_8_n117), .A3(sub_8_n119), .A4(
        sub_8_n125), .ZN(sub_8_n132) );
  AND4_X1 sub_8_U373 ( .A1(sub_8_n263), .A2(sub_8_n73), .A3(sub_8_n258), .A4(
        sub_8_n264), .ZN(sub_8_n136) );
  NAND2_X1 sub_8_U372 ( .A1(sub_8_n79), .A2(sub_8_n124), .ZN(sub_8_n433) );
  NAND2_X1 sub_8_U371 ( .A1(sub_8_n432), .A2(sub_8_n79), .ZN(sub_8_n431) );
  NAND2_X1 sub_8_U370 ( .A1(sub_8_n79), .A2(sub_8_n108), .ZN(sub_8_n424) );
  NAND4_X1 sub_8_U369 ( .A1(sub_8_n419), .A2(sub_8_n30), .A3(sub_8_n399), .A4(
        sub_8_n398), .ZN(sub_8_n405) );
  NAND2_X1 sub_8_U368 ( .A1(sub_8_n140), .A2(sub_8_n141), .ZN(sub_8_n449) );
  NAND2_X1 sub_8_U367 ( .A1(sub_8_n210), .A2(sub_8_n109), .ZN(sub_8_n402) );
  NAND2_X1 sub_8_U366 ( .A1(sub_8_n109), .A2(sub_8_n210), .ZN(sub_8_n285) );
  NAND2_X1 sub_8_U365 ( .A1(sub_8_n146), .A2(sub_8_n37), .ZN(sub_8_n466) );
  NAND2_X1 sub_8_U364 ( .A1(sub_8_n77), .A2(sub_8_n142), .ZN(sub_8_n137) );
  NAND4_X1 sub_8_U363 ( .A1(sub_8_n357), .A2(sub_8_n347), .A3(sub_8_n355), 
        .A4(sub_8_n76), .ZN(sub_8_n130) );
  INV_X1 sub_8_U362 ( .A(a[2]), .ZN(sub_8_n487) );
  NAND2_X1 sub_8_U361 ( .A1(b[2]), .A2(sub_8_n487), .ZN(sub_8_n237) );
  NOR2_X1 sub_8_U360 ( .A1(sub_8_n477), .A2(sub_8_n59), .ZN(sub_8_n474) );
  INV_X1 sub_8_U359 ( .A(a[1]), .ZN(sub_8_n417) );
  OAI21_X1 sub_8_U358 ( .B1(sub_8_n275), .B2(sub_8_n276), .A(sub_8_n277), .ZN(
        sub_8_n271) );
  NOR3_X1 sub_8_U357 ( .A1(sub_8_n286), .A2(sub_8_n284), .A3(sub_8_n285), .ZN(
        sub_8_n275) );
  OAI21_X1 sub_8_U356 ( .B1(sub_8_n69), .B2(sub_8_n337), .A(sub_8_n312), .ZN(
        sub_8_n330) );
  AND3_X1 sub_8_U355 ( .A1(sub_8_n231), .A2(sub_8_n194), .A3(sub_8_n111), .ZN(
        sub_8_n221) );
  NAND2_X1 sub_8_U354 ( .A1(sub_8_n111), .A2(sub_8_n194), .ZN(sub_8_n193) );
  NAND2_X1 sub_8_U353 ( .A1(sub_8_n69), .A2(sub_8_n11), .ZN(sub_8_n283) );
  INV_X1 sub_8_U352 ( .A(a[13]), .ZN(sub_8_n435) );
  NAND2_X1 sub_8_U351 ( .A1(b[13]), .A2(sub_8_n435), .ZN(sub_8_n395) );
  NAND2_X1 sub_8_U350 ( .A1(sub_8_n473), .A2(a[5]), .ZN(sub_8_n160) );
  NAND2_X1 sub_8_U349 ( .A1(sub_8_n72), .A2(sub_8_n80), .ZN(sub_8_n163) );
  OAI21_X1 sub_8_U348 ( .B1(sub_8_n158), .B2(sub_8_n159), .A(sub_8_n80), .ZN(
        sub_8_n155) );
  INV_X1 sub_8_U347 ( .A(b[13]), .ZN(sub_8_n434) );
  NAND2_X1 sub_8_U346 ( .A1(sub_8_n31), .A2(a[13]), .ZN(sub_8_n397) );
  NOR2_X1 sub_8_U345 ( .A1(sub_8_n223), .A2(sub_8_n222), .ZN(sub_8_n216) );
  NAND2_X1 sub_8_U344 ( .A1(sub_8_n407), .A2(sub_8_n121), .ZN(sub_8_n210) );
  NAND2_X1 sub_8_U343 ( .A1(sub_8_n408), .A2(sub_8_n407), .ZN(sub_8_n128) );
  INV_X1 sub_8_U342 ( .A(a[1]), .ZN(sub_8_n127) );
  NAND2_X1 sub_8_U341 ( .A1(sub_8_n28), .A2(a[14]), .ZN(sub_8_n396) );
  NAND2_X1 sub_8_U340 ( .A1(sub_8_n108), .A2(sub_8_n116), .ZN(sub_8_n428) );
  AND2_X1 sub_8_U339 ( .A1(sub_8_n397), .A2(sub_8_n396), .ZN(sub_8_n392) );
  NAND2_X1 sub_8_U338 ( .A1(b[13]), .A2(sub_8_n29), .ZN(sub_8_n126) );
  NAND2_X1 sub_8_U337 ( .A1(sub_8_n431), .A2(sub_8_n124), .ZN(sub_8_n427) );
  AND4_X2 sub_8_U336 ( .A1(sub_8_n166), .A2(sub_8_n161), .A3(sub_8_n115), .A4(
        sub_8_n152), .ZN(sub_8_n125) );
  NAND2_X1 sub_8_U335 ( .A1(sub_8_n260), .A2(sub_8_n261), .ZN(sub_8_n255) );
  NAND4_X1 sub_8_U334 ( .A1(sub_8_n255), .A2(sub_8_n256), .A3(sub_8_n73), .A4(
        sub_8_n71), .ZN(sub_8_n248) );
  NAND2_X1 sub_8_U333 ( .A1(sub_8_n481), .A2(a[2]), .ZN(sub_8_n174) );
  NAND2_X1 sub_8_U332 ( .A1(sub_8_n478), .A2(sub_8_n479), .ZN(sub_8_n412) );
  NAND2_X1 sub_8_U331 ( .A1(sub_8_n145), .A2(sub_8_n146), .ZN(sub_8_n143) );
  INV_X1 sub_8_U330 ( .A(b[14]), .ZN(sub_8_n429) );
  NAND2_X1 sub_8_U329 ( .A1(a[13]), .A2(sub_8_n434), .ZN(sub_8_n124) );
  AND2_X1 sub_8_U328 ( .A1(sub_8_n105), .A2(sub_8_n231), .ZN(sub_8_n123) );
  NAND2_X1 sub_8_U327 ( .A1(sub_8_n192), .A2(sub_8_n193), .ZN(sub_8_n190) );
  AOI21_X1 sub_8_U326 ( .B1(sub_8_n131), .B2(sub_8_n190), .A(sub_8_n191), .ZN(
        sub_8_n179) );
  AND2_X1 sub_8_U325 ( .A1(sub_8_n107), .A2(sub_8_n95), .ZN(sub_8_n121) );
  AND2_X1 sub_8_U324 ( .A1(sub_8_n233), .A2(sub_8_n231), .ZN(sub_8_n120) );
  NAND2_X1 sub_8_U323 ( .A1(b[8]), .A2(sub_8_n464), .ZN(sub_8_n144) );
  NAND2_X1 sub_8_U322 ( .A1(sub_8_n448), .A2(sub_8_n447), .ZN(sub_8_n404) );
  NAND2_X1 sub_8_U321 ( .A1(sub_8_n422), .A2(b[15]), .ZN(sub_8_n398) );
  NAND2_X1 sub_8_U320 ( .A1(b[14]), .A2(sub_8_n430), .ZN(sub_8_n399) );
  INV_X1 sub_8_U319 ( .A(a[3]), .ZN(sub_8_n480) );
  NAND2_X1 sub_8_U318 ( .A1(a[14]), .A2(sub_8_n429), .ZN(sub_8_n116) );
  INV_X1 sub_8_U317 ( .A(a[6]), .ZN(sub_8_n489) );
  NAND2_X1 sub_8_U316 ( .A1(b[6]), .A2(sub_8_n83), .ZN(sub_8_n115) );
  NAND2_X1 sub_8_U315 ( .A1(b[6]), .A2(sub_8_n489), .ZN(sub_8_n114) );
  OAI21_X1 sub_8_U314 ( .B1(sub_8_n270), .B2(sub_8_n97), .A(sub_8_n262), .ZN(
        sub_8_n266) );
  INV_X1 sub_8_U313 ( .A(b[2]), .ZN(sub_8_n481) );
  NAND2_X1 sub_8_U312 ( .A1(sub_8_n3), .A2(sub_8_n103), .ZN(sub_8_n438) );
  NAND2_X1 sub_8_U311 ( .A1(sub_8_n403), .A2(sub_8_n404), .ZN(sub_8_n211) );
  NOR2_X1 sub_8_U310 ( .A1(sub_8_n43), .A2(sub_8_n466), .ZN(sub_8_n461) );
  OAI21_X1 sub_8_U309 ( .B1(sub_8_n461), .B2(sub_8_n462), .A(sub_8_n24), .ZN(
        sub_8_n457) );
  NAND2_X1 sub_8_U308 ( .A1(sub_8_n456), .A2(sub_8_n450), .ZN(sub_8_n452) );
  NAND2_X1 sub_8_U307 ( .A1(sub_8_n392), .A2(sub_8_n393), .ZN(sub_8_n391) );
  INV_X1 sub_8_U306 ( .A(a[5]), .ZN(sub_8_n490) );
  NAND2_X1 sub_8_U305 ( .A1(sub_8_n490), .A2(b[5]), .ZN(sub_8_n161) );
  NOR2_X1 sub_8_U304 ( .A1(sub_8_n402), .A2(sub_8_n401), .ZN(sub_8_n387) );
  XNOR2_X1 sub_8_U303 ( .A(sub_8_n33), .B(sub_8_n163), .ZN(diff[5]) );
  NAND2_X1 sub_8_U302 ( .A1(sub_8_n480), .A2(b[3]), .ZN(sub_8_n171) );
  AND3_X1 sub_8_U301 ( .A1(sub_8_n475), .A2(sub_8_n171), .A3(sub_8_n476), .ZN(
        sub_8_n113) );
  INV_X1 sub_8_U300 ( .A(sub_8_n130), .ZN(sub_8_n112) );
  OAI21_X1 sub_8_U299 ( .B1(sub_8_n468), .B2(sub_8_n118), .A(sub_8_n469), .ZN(
        sub_8_n409) );
  XNOR2_X1 sub_8_U298 ( .A(sub_8_n427), .B(sub_8_n428), .ZN(diff[14]) );
  NAND2_X1 sub_8_U297 ( .A1(sub_8_n171), .A2(sub_8_n86), .ZN(sub_8_n170) );
  NAND2_X1 sub_8_U296 ( .A1(sub_8_n237), .A2(sub_8_n171), .ZN(sub_8_n483) );
  NOR2_X1 sub_8_U295 ( .A1(sub_8_n68), .A2(sub_8_n122), .ZN(sub_8_n110) );
  OAI21_X1 sub_8_U294 ( .B1(sub_8_n485), .B2(sub_8_n486), .A(sub_8_n416), .ZN(
        sub_8_n484) );
  OAI21_X1 sub_8_U293 ( .B1(sub_8_n179), .B2(sub_8_n180), .A(sub_8_n181), .ZN(
        sub_8_n178) );
  NAND2_X1 sub_8_U292 ( .A1(sub_8_n283), .A2(sub_8_n192), .ZN(sub_8_n286) );
  NAND2_X1 sub_8_U291 ( .A1(sub_8_n403), .A2(sub_8_n103), .ZN(sub_8_n109) );
  NAND2_X1 sub_8_U290 ( .A1(sub_8_n302), .A2(sub_8_n303), .ZN(sub_8_n233) );
  CLKBUF_X1 sub_8_U289 ( .A(sub_8_n36), .Z(sub_8_n108) );
  NAND2_X1 sub_8_U288 ( .A1(sub_8_n391), .A2(sub_8_n390), .ZN(sub_8_n300) );
  OAI21_X1 sub_8_U287 ( .B1(sub_8_n104), .B2(sub_8_n49), .A(sub_8_n98), .ZN(
        sub_8_n107) );
  NAND2_X1 sub_8_U286 ( .A1(b[21]), .A2(sub_8_n88), .ZN(sub_8_n311) );
  OR2_X1 sub_8_U285 ( .A1(sub_8_n330), .A2(sub_8_n87), .ZN(sub_8_n321) );
  INV_X1 sub_8_U284 ( .A(b[26]), .ZN(sub_8_n274) );
  NAND2_X1 sub_8_U283 ( .A1(a[26]), .A2(sub_8_n274), .ZN(sub_8_n262) );
  NAND2_X1 sub_8_U282 ( .A1(sub_8_n246), .A2(sub_8_n257), .ZN(sub_8_n267) );
  NAND2_X1 sub_8_U281 ( .A1(sub_8_n18), .A2(sub_8_n257), .ZN(sub_8_n247) );
  AND3_X1 sub_8_U280 ( .A1(sub_8_n426), .A2(sub_8_n425), .A3(sub_8_n124), .ZN(
        sub_8_n106) );
  AOI21_X1 sub_8_U279 ( .B1(sub_8_n346), .B2(sub_8_n347), .A(sub_8_n348), .ZN(
        sub_8_n345) );
  NAND2_X1 sub_8_U278 ( .A1(sub_8_n347), .A2(sub_8_n349), .ZN(sub_8_n363) );
  OAI21_X1 sub_8_U277 ( .B1(sub_8_n351), .B2(sub_8_n352), .A(sub_8_n347), .ZN(
        sub_8_n344) );
  AND2_X1 sub_8_U276 ( .A1(sub_8_n133), .A2(sub_8_n135), .ZN(sub_8_n105) );
  NAND2_X1 sub_8_U275 ( .A1(sub_8_n94), .A2(sub_8_n84), .ZN(sub_8_n151) );
  NAND2_X1 sub_8_U274 ( .A1(sub_8_n64), .A2(a[4]), .ZN(sub_8_n165) );
  AND2_X1 sub_8_U273 ( .A1(sub_8_n160), .A2(sub_8_n165), .ZN(sub_8_n118) );
  AND2_X1 sub_8_U272 ( .A1(sub_8_n160), .A2(sub_8_n81), .ZN(sub_8_n104) );
  NAND2_X1 sub_8_U271 ( .A1(sub_8_n448), .A2(sub_8_n447), .ZN(sub_8_n103) );
  NAND3_X1 sub_8_U270 ( .A1(sub_8_n11), .A2(sub_8_n231), .A3(sub_8_n12), .ZN(
        sub_8_n102) );
  INV_X1 sub_8_U269 ( .A(a[0]), .ZN(sub_8_n101) );
  INV_X1 sub_8_U268 ( .A(b[3]), .ZN(sub_8_n482) );
  NAND2_X1 sub_8_U267 ( .A1(sub_8_n50), .A2(a[3]), .ZN(sub_8_n172) );
  INV_X1 sub_8_U266 ( .A(b[24]), .ZN(sub_8_n294) );
  NAND2_X1 sub_8_U265 ( .A1(a[24]), .A2(sub_8_n294), .ZN(sub_8_n261) );
  OAI211_X1 sub_8_U264 ( .C1(sub_8_n414), .C2(sub_8_n415), .A(sub_8_n416), .B(
        sub_8_n237), .ZN(sub_8_n413) );
  NAND2_X1 sub_8_U263 ( .A1(sub_8_n311), .A2(sub_8_n307), .ZN(sub_8_n334) );
  NAND2_X1 sub_8_U262 ( .A1(sub_8_n331), .A2(sub_8_n311), .ZN(sub_8_n322) );
  AND2_X1 sub_8_U261 ( .A1(sub_8_n398), .A2(sub_8_n36), .ZN(sub_8_n390) );
  AND2_X1 sub_8_U260 ( .A1(a[6]), .A2(sub_8_n471), .ZN(sub_8_n99) );
  AND2_X1 sub_8_U259 ( .A1(sub_8_n70), .A2(sub_8_n84), .ZN(sub_8_n98) );
  INV_X1 sub_8_U258 ( .A(a[26]), .ZN(sub_8_n273) );
  AND2_X1 sub_8_U257 ( .A1(b[26]), .A2(sub_8_n20), .ZN(sub_8_n97) );
  INV_X1 sub_8_U256 ( .A(b[4]), .ZN(sub_8_n472) );
  INV_X1 sub_8_U255 ( .A(b[19]), .ZN(sub_8_n364) );
  NAND2_X1 sub_8_U254 ( .A1(sub_8_n364), .A2(a[19]), .ZN(sub_8_n349) );
  NAND2_X1 sub_8_U253 ( .A1(b[25]), .A2(sub_8_n290), .ZN(sub_8_n264) );
  AOI21_X1 sub_8_U252 ( .B1(sub_8_n278), .B2(sub_8_n256), .A(sub_8_n21), .ZN(
        sub_8_n277) );
  INV_X1 sub_8_U251 ( .A(b[5]), .ZN(sub_8_n473) );
  NAND2_X1 sub_8_U250 ( .A1(sub_8_n291), .A2(a[25]), .ZN(sub_8_n260) );
  INV_X1 sub_8_U249 ( .A(b[8]), .ZN(sub_8_n467) );
  NAND2_X1 sub_8_U248 ( .A1(a[8]), .A2(sub_8_n467), .ZN(sub_8_n141) );
  AND4_X2 sub_8_U247 ( .A1(sub_8_n419), .A2(sub_8_n395), .A3(sub_8_n399), .A4(
        sub_8_n6), .ZN(sub_8_n117) );
  NAND2_X1 sub_8_U246 ( .A1(sub_8_n301), .A2(sub_8_n6), .ZN(sub_8_n421) );
  XNOR2_X1 sub_8_U245 ( .A(sub_8_n362), .B(sub_8_n363), .ZN(diff[19]) );
  AND4_X1 sub_8_U244 ( .A1(sub_8_n263), .A2(sub_8_n257), .A3(sub_8_n258), .A4(
        sub_8_n264), .ZN(sub_8_n131) );
  NAND2_X1 sub_8_U243 ( .A1(sub_8_n58), .A2(sub_8_n65), .ZN(sub_8_n292) );
  AOI21_X1 sub_8_U242 ( .B1(sub_8_n265), .B2(sub_8_n65), .A(sub_8_n278), .ZN(
        sub_8_n288) );
  INV_X1 sub_8_U241 ( .A(b[7]), .ZN(sub_8_n470) );
  INV_X1 sub_8_U240 ( .A(a[7]), .ZN(sub_8_n488) );
  NAND2_X1 sub_8_U239 ( .A1(b[7]), .A2(sub_8_n488), .ZN(sub_8_n152) );
  NAND2_X1 sub_8_U238 ( .A1(b[7]), .A2(sub_8_n488), .ZN(sub_8_n95) );
  NAND2_X1 sub_8_U237 ( .A1(b[7]), .A2(sub_8_n488), .ZN(sub_8_n94) );
  NAND2_X1 sub_8_U236 ( .A1(sub_8_n359), .A2(sub_8_n239), .ZN(sub_8_n358) );
  XNOR2_X1 sub_8_U235 ( .A(sub_8_n240), .B(sub_8_n358), .ZN(diff[1]) );
  NAND2_X1 sub_8_U234 ( .A1(a[12]), .A2(sub_8_n394), .ZN(sub_8_n425) );
  INV_X1 sub_8_U233 ( .A(b[1]), .ZN(sub_8_n360) );
  NAND2_X1 sub_8_U232 ( .A1(a[1]), .A2(sub_8_n360), .ZN(sub_8_n239) );
  INV_X1 sub_8_U231 ( .A(b[17]), .ZN(sub_8_n383) );
  NAND2_X1 sub_8_U230 ( .A1(a[17]), .A2(sub_8_n383), .ZN(sub_8_n370) );
  INV_X1 sub_8_U229 ( .A(b[16]), .ZN(sub_8_n386) );
  NAND2_X1 sub_8_U228 ( .A1(a[16]), .A2(sub_8_n386), .ZN(sub_8_n380) );
  INV_X1 sub_8_U227 ( .A(b[0]), .ZN(sub_8_n493) );
  NAND2_X1 sub_8_U226 ( .A1(a[0]), .A2(sub_8_n493), .ZN(sub_8_n361) );
  AND2_X1 sub_8_U225 ( .A1(a[31]), .A2(sub_8_n202), .ZN(sub_8_n93) );
  INV_X1 sub_8_U224 ( .A(b[30]), .ZN(sub_8_n227) );
  NAND2_X1 sub_8_U223 ( .A1(a[30]), .A2(sub_8_n227), .ZN(sub_8_n185) );
  INV_X1 sub_8_U222 ( .A(a[31]), .ZN(sub_8_n203) );
  NAND2_X1 sub_8_U221 ( .A1(b[31]), .A2(sub_8_n203), .ZN(sub_8_n182) );
  INV_X1 sub_8_U220 ( .A(b[23]), .ZN(sub_8_n317) );
  NAND2_X1 sub_8_U219 ( .A1(a[23]), .A2(sub_8_n317), .ZN(sub_8_n303) );
  INV_X1 sub_8_U218 ( .A(b[15]), .ZN(sub_8_n423) );
  NAND2_X1 sub_8_U217 ( .A1(a[15]), .A2(sub_8_n423), .ZN(sub_8_n301) );
  INV_X1 sub_8_U216 ( .A(b[29]), .ZN(sub_8_n242) );
  NAND2_X1 sub_8_U215 ( .A1(a[29]), .A2(sub_8_n242), .ZN(sub_8_n188) );
  INV_X1 sub_8_U214 ( .A(a[30]), .ZN(sub_8_n228) );
  INV_X1 sub_8_U213 ( .A(b[27]), .ZN(sub_8_n269) );
  NAND2_X1 sub_8_U212 ( .A1(a[27]), .A2(sub_8_n269), .ZN(sub_8_n246) );
  INV_X1 sub_8_U211 ( .A(a[29]), .ZN(sub_8_n243) );
  NAND2_X1 sub_8_U210 ( .A1(b[29]), .A2(sub_8_n243), .ZN(sub_8_n186) );
  INV_X1 sub_8_U209 ( .A(a[28]), .ZN(sub_8_n253) );
  NAND2_X1 sub_8_U208 ( .A1(b[28]), .A2(sub_8_n253), .ZN(sub_8_n198) );
  INV_X1 sub_8_U207 ( .A(b[28]), .ZN(sub_8_n252) );
  NAND2_X1 sub_8_U206 ( .A1(a[28]), .A2(sub_8_n252), .ZN(sub_8_n189) );
  INV_X1 sub_8_U205 ( .A(b[12]), .ZN(sub_8_n394) );
  INV_X1 sub_8_U204 ( .A(b[11]), .ZN(sub_8_n454) );
  NAND2_X1 sub_8_U203 ( .A1(a[11]), .A2(sub_8_n454), .ZN(sub_8_n451) );
  INV_X1 sub_8_U202 ( .A(b[10]), .ZN(sub_8_n459) );
  NAND2_X1 sub_8_U201 ( .A1(a[10]), .A2(sub_8_n459), .ZN(sub_8_n450) );
  INV_X1 sub_8_U200 ( .A(b[20]), .ZN(sub_8_n340) );
  NAND2_X1 sub_8_U199 ( .A1(a[20]), .A2(sub_8_n340), .ZN(sub_8_n308) );
  INV_X1 sub_8_U198 ( .A(b[21]), .ZN(sub_8_n335) );
  NAND2_X1 sub_8_U197 ( .A1(a[21]), .A2(sub_8_n335), .ZN(sub_8_n307) );
  NOR2_X1 sub_8_U196 ( .A1(b[17]), .A2(sub_8_n354), .ZN(sub_8_n351) );
  INV_X1 sub_8_U195 ( .A(a[12]), .ZN(sub_8_n443) );
  NAND2_X1 sub_8_U194 ( .A1(b[12]), .A2(sub_8_n443), .ZN(sub_8_n419) );
  NOR2_X1 sub_8_U193 ( .A1(b[16]), .A2(sub_8_n353), .ZN(sub_8_n352) );
  INV_X1 sub_8_U192 ( .A(b[22]), .ZN(sub_8_n325) );
  NAND2_X1 sub_8_U191 ( .A1(a[22]), .A2(sub_8_n325), .ZN(sub_8_n309) );
  INV_X1 sub_8_U190 ( .A(a[4]), .ZN(sub_8_n491) );
  NAND2_X1 sub_8_U189 ( .A1(b[4]), .A2(sub_8_n491), .ZN(sub_8_n166) );
  INV_X1 sub_8_U188 ( .A(a[16]), .ZN(sub_8_n353) );
  INV_X1 sub_8_U187 ( .A(a[18]), .ZN(sub_8_n375) );
  NAND2_X1 sub_8_U186 ( .A1(b[18]), .A2(sub_8_n375), .ZN(sub_8_n355) );
  INV_X1 sub_8_U185 ( .A(a[14]), .ZN(sub_8_n430) );
  INV_X1 sub_8_U184 ( .A(a[15]), .ZN(sub_8_n422) );
  INV_X1 sub_8_U183 ( .A(a[19]), .ZN(sub_8_n365) );
  INV_X1 sub_8_U182 ( .A(a[20]), .ZN(sub_8_n341) );
  NAND2_X1 sub_8_U181 ( .A1(b[20]), .A2(sub_8_n341), .ZN(sub_8_n312) );
  INV_X1 sub_8_U180 ( .A(a[23]), .ZN(sub_8_n316) );
  NAND2_X1 sub_8_U179 ( .A1(b[23]), .A2(sub_8_n316), .ZN(sub_8_n310) );
  INV_X1 sub_8_U178 ( .A(a[11]), .ZN(sub_8_n455) );
  NAND2_X1 sub_8_U177 ( .A1(b[11]), .A2(sub_8_n455), .ZN(sub_8_n406) );
  INV_X1 sub_8_U176 ( .A(a[24]), .ZN(sub_8_n293) );
  NAND2_X1 sub_8_U175 ( .A1(b[24]), .A2(sub_8_n293), .ZN(sub_8_n263) );
  NAND2_X1 sub_8_U174 ( .A1(b[26]), .A2(sub_8_n273), .ZN(sub_8_n258) );
  INV_X1 sub_8_U173 ( .A(a[10]), .ZN(sub_8_n460) );
  NAND2_X1 sub_8_U172 ( .A1(sub_8_n5), .A2(b[10]), .ZN(sub_8_n446) );
  INV_X1 sub_8_U171 ( .A(b[25]), .ZN(sub_8_n291) );
  INV_X1 sub_8_U170 ( .A(a[25]), .ZN(sub_8_n259) );
  NAND2_X1 sub_8_U169 ( .A1(b[25]), .A2(sub_8_n259), .ZN(sub_8_n256) );
  INV_X1 sub_8_U168 ( .A(b[18]), .ZN(sub_8_n374) );
  NAND2_X1 sub_8_U167 ( .A1(a[18]), .A2(sub_8_n374), .ZN(sub_8_n350) );
  INV_X1 sub_8_U166 ( .A(a[22]), .ZN(sub_8_n326) );
  NAND2_X1 sub_8_U165 ( .A1(b[22]), .A2(sub_8_n326), .ZN(sub_8_n313) );
  INV_X1 sub_8_U164 ( .A(a[17]), .ZN(sub_8_n354) );
  INV_X1 sub_8_U163 ( .A(a[25]), .ZN(sub_8_n290) );
  INV_X1 sub_8_U162 ( .A(a[27]), .ZN(sub_8_n268) );
  NAND2_X1 sub_8_U161 ( .A1(b[27]), .A2(sub_8_n268), .ZN(sub_8_n257) );
  AND2_X1 sub_8_U160 ( .A1(b[0]), .A2(sub_8_n101), .ZN(sub_8_n122) );
  INV_X1 sub_8_U159 ( .A(a[9]), .ZN(sub_8_n465) );
  INV_X1 sub_8_U158 ( .A(a[8]), .ZN(sub_8_n464) );
  INV_X1 sub_8_U157 ( .A(b[9]), .ZN(sub_8_n463) );
  NAND2_X1 sub_8_U156 ( .A1(a[9]), .A2(sub_8_n463), .ZN(sub_8_n140) );
  NAND2_X1 sub_8_U155 ( .A1(b[3]), .A2(sub_8_n39), .ZN(sub_8_n479) );
  OR2_X1 sub_8_U154 ( .A1(sub_8_n122), .A2(sub_8_n492), .ZN(diff[0]) );
  XNOR2_X1 sub_8_U153 ( .A(sub_8_n175), .B(sub_8_n236), .ZN(diff[2]) );
  NAND2_X1 sub_8_U152 ( .A1(sub_8_n122), .A2(sub_8_n361), .ZN(sub_8_n240) );
  OAI21_X1 sub_8_U151 ( .B1(sub_8_n238), .B2(sub_8_n68), .A(sub_8_n239), .ZN(
        sub_8_n175) );
  NAND4_X1 sub_8_U150 ( .A1(sub_8_n198), .A2(sub_8_n186), .A3(sub_8_n187), 
        .A4(sub_8_n182), .ZN(sub_8_n180) );
  NAND2_X1 sub_8_U149 ( .A1(sub_8_n357), .A2(sub_8_n380), .ZN(sub_8_n385) );
  NAND2_X1 sub_8_U148 ( .A1(sub_8_n186), .A2(sub_8_n187), .ZN(sub_8_n184) );
  AND2_X1 sub_8_U147 ( .A1(sub_8_n188), .A2(sub_8_n189), .ZN(sub_8_n91) );
  NAND2_X1 sub_8_U146 ( .A1(sub_8_n446), .A2(sub_8_n450), .ZN(sub_8_n458) );
  NOR2_X1 sub_8_U145 ( .A1(sub_8_n232), .A2(sub_8_n96), .ZN(sub_8_n229) );
  NAND2_X1 sub_8_U144 ( .A1(sub_8_n26), .A2(sub_8_n24), .ZN(sub_8_n138) );
  XNOR2_X1 sub_8_U143 ( .A(sub_8_n137), .B(sub_8_n138), .ZN(diff[9]) );
  XNOR2_X1 sub_8_U142 ( .A(sub_8_n265), .B(sub_8_n292), .ZN(diff[24]) );
  NOR2_X1 sub_8_U141 ( .A1(sub_8_n444), .A2(sub_8_n445), .ZN(sub_8_n440) );
  XNOR2_X1 sub_8_U140 ( .A(sub_8_n440), .B(sub_8_n441), .ZN(diff[12]) );
  NAND2_X1 sub_8_U139 ( .A1(sub_8_n262), .A2(sub_8_n71), .ZN(sub_8_n272) );
  NOR2_X1 sub_8_U138 ( .A1(sub_8_n220), .A2(sub_8_n188), .ZN(sub_8_n219) );
  XNOR2_X1 sub_8_U137 ( .A(sub_8_n288), .B(sub_8_n289), .ZN(diff[25]) );
  XOR2_X1 sub_8_U136 ( .A(sub_8_n150), .B(sub_8_n151), .Z(diff[7]) );
  AND2_X1 sub_8_U135 ( .A1(sub_8_n450), .A2(sub_8_n451), .ZN(sub_8_n447) );
  NAND2_X1 sub_8_U134 ( .A1(sub_8_n369), .A2(sub_8_n370), .ZN(sub_8_n368) );
  NAND2_X1 sub_8_U133 ( .A1(sub_8_n198), .A2(sub_8_n189), .ZN(sub_8_n251) );
  NAND2_X1 sub_8_U132 ( .A1(sub_8_n321), .A2(sub_8_n307), .ZN(sub_8_n320) );
  NAND2_X1 sub_8_U131 ( .A1(sub_8_n310), .A2(sub_8_n303), .ZN(sub_8_n315) );
  NAND2_X1 sub_8_U130 ( .A1(sub_8_n187), .A2(sub_8_n185), .ZN(sub_8_n226) );
  XNOR2_X1 sub_8_U129 ( .A(sub_8_n225), .B(sub_8_n226), .ZN(diff[30]) );
  NOR2_X1 sub_8_U128 ( .A1(sub_8_n329), .A2(sub_8_n328), .ZN(sub_8_n327) );
  NAND2_X1 sub_8_U127 ( .A1(sub_8_n313), .A2(sub_8_n309), .ZN(sub_8_n324) );
  NAND2_X1 sub_8_U126 ( .A1(sub_8_n312), .A2(sub_8_n308), .ZN(sub_8_n339) );
  NOR2_X1 sub_8_U125 ( .A1(sub_8_n377), .A2(sub_8_n378), .ZN(sub_8_n376) );
  NAND2_X1 sub_8_U124 ( .A1(sub_8_n355), .A2(sub_8_n350), .ZN(sub_8_n373) );
  NAND2_X1 sub_8_U123 ( .A1(sub_8_n56), .A2(sub_8_n451), .ZN(sub_8_n453) );
  XNOR2_X1 sub_8_U122 ( .A(sub_8_n452), .B(sub_8_n453), .ZN(diff[11]) );
  INV_X1 sub_8_U121 ( .A(sub_8_n129), .ZN(sub_8_n100) );
  OAI21_X1 sub_8_U120 ( .B1(sub_8_n91), .B2(sub_8_n184), .A(sub_8_n185), .ZN(
        sub_8_n183) );
  AOI21_X1 sub_8_U119 ( .B1(sub_8_n182), .B2(sub_8_n183), .A(sub_8_n93), .ZN(
        sub_8_n181) );
  NOR2_X1 sub_8_U118 ( .A1(sub_8_n405), .A2(sub_8_n62), .ZN(sub_8_n403) );
  AND2_X1 sub_8_U117 ( .A1(sub_8_n186), .A2(sub_8_n198), .ZN(sub_8_n234) );
  AND4_X1 sub_8_U116 ( .A1(sub_8_n357), .A2(sub_8_n347), .A3(sub_8_n355), .A4(
        sub_8_n356), .ZN(sub_8_n133) );
  INV_X1 sub_8_U115 ( .A(sub_8_n129), .ZN(sub_8_n475) );
  INV_X1 sub_8_U114 ( .A(sub_8_n131), .ZN(sub_8_n249) );
  NOR2_X1 sub_8_U113 ( .A1(sub_8_n195), .A2(sub_8_n196), .ZN(sub_8_n177) );
  AND2_X1 sub_8_U112 ( .A1(sub_8_n283), .A2(sub_8_n192), .ZN(sub_8_n295) );
  NAND2_X1 sub_8_U111 ( .A1(sub_8_n296), .A2(sub_8_n295), .ZN(sub_8_n265) );
  AOI21_X1 sub_8_U110 ( .B1(sub_8_n412), .B2(sub_8_n413), .A(sub_8_n48), .ZN(
        sub_8_n90) );
  CLKBUF_X1 sub_8_U109 ( .A(sub_8_n120), .Z(sub_8_n96) );
  CLKBUF_X1 sub_8_U108 ( .A(sub_8_n174), .Z(sub_8_n89) );
  INV_X1 sub_8_U107 ( .A(a[21]), .ZN(sub_8_n88) );
  AND2_X1 sub_8_U106 ( .A1(b[21]), .A2(sub_8_n336), .ZN(sub_8_n87) );
  NAND2_X1 sub_8_U105 ( .A1(a[3]), .A2(sub_8_n482), .ZN(sub_8_n86) );
  INV_X1 sub_8_U104 ( .A(b[7]), .ZN(sub_8_n85) );
  NAND2_X1 sub_8_U103 ( .A1(sub_8_n470), .A2(a[7]), .ZN(sub_8_n84) );
  INV_X1 sub_8_U102 ( .A(a[6]), .ZN(sub_8_n83) );
  INV_X1 sub_8_U101 ( .A(a[6]), .ZN(sub_8_n82) );
  NAND2_X1 sub_8_U100 ( .A1(a[4]), .A2(sub_8_n472), .ZN(sub_8_n81) );
  CLKBUF_X1 sub_8_U99 ( .A(sub_8_n160), .Z(sub_8_n80) );
  NAND3_X1 sub_8_U98 ( .A1(sub_8_n248), .A2(sub_8_n247), .A3(sub_8_n22), .ZN(
        sub_8_n235) );
  CLKBUF_X1 sub_8_U97 ( .A(sub_8_n395), .Z(sub_8_n79) );
  INV_X1 sub_8_U96 ( .A(sub_8_n300), .ZN(sub_8_n78) );
  CLKBUF_X1 sub_8_U95 ( .A(sub_8_n37), .Z(sub_8_n77) );
  NAND2_X1 sub_8_U94 ( .A1(b[17]), .A2(sub_8_n354), .ZN(sub_8_n356) );
  NAND2_X1 sub_8_U93 ( .A1(b[17]), .A2(sub_8_n354), .ZN(sub_8_n76) );
  NAND2_X1 sub_8_U92 ( .A1(b[17]), .A2(sub_8_n354), .ZN(sub_8_n75) );
  INV_X1 sub_8_U91 ( .A(a[1]), .ZN(sub_8_n74) );
  NAND2_X1 sub_8_U90 ( .A1(b[27]), .A2(sub_8_n268), .ZN(sub_8_n73) );
  CLKBUF_X1 sub_8_U89 ( .A(sub_8_n161), .Z(sub_8_n72) );
  AND4_X2 sub_8_U88 ( .A1(sub_8_n56), .A2(sub_8_n61), .A3(sub_8_n139), .A4(
        sub_8_n144), .ZN(sub_8_n119) );
  NAND2_X1 sub_8_U87 ( .A1(b[26]), .A2(sub_8_n19), .ZN(sub_8_n71) );
  NAND2_X1 sub_8_U86 ( .A1(a[6]), .A2(sub_8_n471), .ZN(sub_8_n70) );
  OAI21_X1 sub_8_U85 ( .B1(sub_8_n343), .B2(sub_8_n344), .A(sub_8_n345), .ZN(
        sub_8_n194) );
  OAI21_X1 sub_8_U84 ( .B1(sub_8_n343), .B2(sub_8_n344), .A(sub_8_n345), .ZN(
        sub_8_n69) );
  AND2_X1 sub_8_U83 ( .A1(b[1]), .A2(sub_8_n417), .ZN(sub_8_n68) );
  INV_X1 sub_8_U82 ( .A(b[6]), .ZN(sub_8_n67) );
  AND2_X1 sub_8_U81 ( .A1(b[25]), .A2(sub_8_n290), .ZN(sub_8_n66) );
  CLKBUF_X1 sub_8_U80 ( .A(sub_8_n263), .Z(sub_8_n65) );
  INV_X1 sub_8_U79 ( .A(b[4]), .ZN(sub_8_n64) );
  NAND2_X1 sub_8_U78 ( .A1(b[8]), .A2(sub_8_n464), .ZN(sub_8_n63) );
  AND2_X1 sub_8_U77 ( .A1(b[11]), .A2(sub_8_n2), .ZN(sub_8_n62) );
  NAND2_X1 sub_8_U76 ( .A1(b[10]), .A2(sub_8_n460), .ZN(sub_8_n61) );
  AND2_X1 sub_8_U75 ( .A1(sub_8_n478), .A2(sub_8_n479), .ZN(sub_8_n59) );
  INV_X1 sub_8_U74 ( .A(sub_8_n278), .ZN(sub_8_n58) );
  AND2_X1 sub_8_U73 ( .A1(b[18]), .A2(sub_8_n375), .ZN(sub_8_n57) );
  NAND2_X1 sub_8_U72 ( .A1(b[11]), .A2(sub_8_n1), .ZN(sub_8_n56) );
  AND4_X1 sub_8_U71 ( .A1(sub_8_n357), .A2(sub_8_n347), .A3(sub_8_n355), .A4(
        sub_8_n356), .ZN(sub_8_n55) );
  NAND2_X1 sub_8_U70 ( .A1(sub_8_n390), .A2(sub_8_n391), .ZN(sub_8_n54) );
  AND2_X1 sub_8_U69 ( .A1(sub_8_n301), .A2(sub_8_n54), .ZN(sub_8_n213) );
  NAND2_X1 sub_8_U68 ( .A1(b[4]), .A2(sub_8_n491), .ZN(sub_8_n53) );
  INV_X1 sub_8_U67 ( .A(a[1]), .ZN(sub_8_n52) );
  CLKBUF_X1 sub_8_U66 ( .A(sub_8_n165), .Z(sub_8_n51) );
  INV_X1 sub_8_U65 ( .A(b[3]), .ZN(sub_8_n50) );
  NAND2_X1 sub_8_U64 ( .A1(sub_8_n161), .A2(sub_8_n154), .ZN(sub_8_n49) );
  AND2_X1 sub_8_U63 ( .A1(b[3]), .A2(sub_8_n40), .ZN(sub_8_n48) );
  AND2_X1 sub_8_U62 ( .A1(b[22]), .A2(sub_8_n326), .ZN(sub_8_n47) );
  AND2_X1 sub_8_U61 ( .A1(sub_8_n296), .A2(sub_8_n295), .ZN(sub_8_n46) );
  NAND2_X1 sub_8_U60 ( .A1(sub_8_n41), .A2(sub_8_n388), .ZN(sub_8_n176) );
  NAND2_X1 sub_8_U59 ( .A1(sub_8_n387), .A2(sub_8_n388), .ZN(sub_8_n45) );
  OAI21_X1 sub_8_U58 ( .B1(sub_8_n104), .B2(sub_8_n49), .A(sub_8_n98), .ZN(
        sub_8_n44) );
  AND2_X1 sub_8_U57 ( .A1(sub_8_n4), .A2(sub_8_n167), .ZN(sub_8_n43) );
  AND2_X1 sub_8_U56 ( .A1(sub_8_n41), .A2(sub_8_n388), .ZN(sub_8_n42) );
  NOR2_X1 sub_8_U55 ( .A1(sub_8_n402), .A2(sub_8_n401), .ZN(sub_8_n41) );
  INV_X1 sub_8_U54 ( .A(a[3]), .ZN(sub_8_n40) );
  INV_X1 sub_8_U53 ( .A(a[3]), .ZN(sub_8_n39) );
  AND2_X1 sub_8_U52 ( .A1(sub_8_n186), .A2(sub_8_n188), .ZN(sub_8_n38) );
  XOR2_X1 sub_8_U51 ( .A(sub_8_n241), .B(sub_8_n38), .Z(diff[29]) );
  NAND2_X1 sub_8_U50 ( .A1(a[8]), .A2(sub_8_n467), .ZN(sub_8_n37) );
  NAND2_X1 sub_8_U49 ( .A1(b[14]), .A2(sub_8_n430), .ZN(sub_8_n36) );
  BUF_X1 sub_8_U48 ( .A(sub_8_n330), .Z(sub_8_n35) );
  NOR2_X2 sub_8_U47 ( .A1(sub_8_n132), .A2(sub_8_n389), .ZN(sub_8_n388) );
  AND2_X1 sub_8_U46 ( .A1(sub_8_n41), .A2(sub_8_n388), .ZN(sub_8_n34) );
  OAI21_X1 sub_8_U45 ( .B1(sub_8_n32), .B2(sub_8_n164), .A(sub_8_n51), .ZN(
        sub_8_n33) );
  AND2_X1 sub_8_U44 ( .A1(sub_8_n474), .A2(sub_8_n400), .ZN(sub_8_n60) );
  AND2_X1 sub_8_U43 ( .A1(sub_8_n474), .A2(sub_8_n400), .ZN(sub_8_n32) );
  INV_X1 sub_8_U42 ( .A(b[13]), .ZN(sub_8_n31) );
  NAND2_X1 sub_8_U41 ( .A1(b[13]), .A2(sub_8_n435), .ZN(sub_8_n30) );
  INV_X1 sub_8_U40 ( .A(a[13]), .ZN(sub_8_n29) );
  INV_X1 sub_8_U39 ( .A(b[14]), .ZN(sub_8_n28) );
  NAND2_X1 sub_8_U38 ( .A1(b[9]), .A2(sub_8_n465), .ZN(sub_8_n139) );
  NAND2_X1 sub_8_U37 ( .A1(b[9]), .A2(sub_8_n465), .ZN(sub_8_n27) );
  NAND2_X1 sub_8_U36 ( .A1(b[9]), .A2(sub_8_n465), .ZN(sub_8_n26) );
  OAI21_X1 sub_8_U35 ( .B1(sub_8_n23), .B2(sub_8_n159), .A(sub_8_n80), .ZN(
        sub_8_n25) );
  NAND2_X1 sub_8_U34 ( .A1(a[9]), .A2(sub_8_n463), .ZN(sub_8_n24) );
  INV_X1 sub_8_U33 ( .A(sub_8_n33), .ZN(sub_8_n23) );
  AND2_X1 sub_8_U32 ( .A1(sub_8_n189), .A2(sub_8_n246), .ZN(sub_8_n22) );
  INV_X1 sub_8_U31 ( .A(b[31]), .ZN(sub_8_n202) );
  NAND2_X1 sub_8_U30 ( .A1(b[30]), .A2(sub_8_n228), .ZN(sub_8_n187) );
  NAND2_X1 sub_8_U29 ( .A1(b[16]), .A2(sub_8_n353), .ZN(sub_8_n357) );
  AND2_X1 sub_8_U28 ( .A1(sub_8_n291), .A2(a[25]), .ZN(sub_8_n21) );
  INV_X1 sub_8_U27 ( .A(a[26]), .ZN(sub_8_n20) );
  INV_X1 sub_8_U26 ( .A(a[26]), .ZN(sub_8_n19) );
  AND2_X1 sub_8_U25 ( .A1(a[26]), .A2(sub_8_n274), .ZN(sub_8_n18) );
  CLKBUF_X1 sub_8_U24 ( .A(sub_8_n128), .Z(sub_8_n17) );
  CLKBUF_X1 sub_8_U23 ( .A(sub_8_n212), .Z(sub_8_n16) );
  AND2_X1 sub_8_U22 ( .A1(sub_8_n187), .A2(sub_8_n231), .ZN(sub_8_n15) );
  CLKBUF_X1 sub_8_U21 ( .A(sub_8_n235), .Z(sub_8_n14) );
  INV_X1 sub_8_U20 ( .A(a[1]), .ZN(sub_8_n13) );
  INV_X1 sub_8_U19 ( .A(sub_8_n342), .ZN(sub_8_n12) );
  BUF_X1 sub_8_U18 ( .A(sub_8_n135), .Z(sub_8_n111) );
  BUF_X1 sub_8_U17 ( .A(sub_8_n135), .Z(sub_8_n11) );
  NAND4_X1 sub_8_U16 ( .A1(sub_8_n27), .A2(sub_8_n446), .A3(sub_8_n406), .A4(
        sub_8_n63), .ZN(sub_8_n10) );
  AND2_X1 sub_8_U15 ( .A1(b[23]), .A2(sub_8_n316), .ZN(sub_8_n9) );
  NAND2_X1 sub_8_U14 ( .A1(sub_8_n418), .A2(b[0]), .ZN(sub_8_n8) );
  NAND2_X1 sub_8_U13 ( .A1(sub_8_n417), .A2(b[1]), .ZN(sub_8_n7) );
  AND2_X1 sub_8_U12 ( .A1(sub_8_n7), .A2(sub_8_n8), .ZN(sub_8_n476) );
  AND4_X2 sub_8_U11 ( .A1(sub_8_n312), .A2(sub_8_n310), .A3(sub_8_n313), .A4(
        sub_8_n311), .ZN(sub_8_n135) );
  NAND2_X2 sub_8_U10 ( .A1(sub_8_n365), .A2(b[19]), .ZN(sub_8_n347) );
  NAND2_X1 sub_8_U9 ( .A1(sub_8_n422), .A2(b[15]), .ZN(sub_8_n6) );
  AND2_X2 sub_8_U8 ( .A1(b[2]), .A2(sub_8_n487), .ZN(sub_8_n129) );
  INV_X1 sub_8_U7 ( .A(a[10]), .ZN(sub_8_n5) );
  BUF_X1 sub_8_U6 ( .A(sub_8_n125), .Z(sub_8_n4) );
  CLKBUF_X1 sub_8_U5 ( .A(sub_8_n406), .Z(sub_8_n3) );
  INV_X1 sub_8_U4 ( .A(a[11]), .ZN(sub_8_n2) );
  INV_X1 sub_8_U3 ( .A(a[11]), .ZN(sub_8_n1) );
endmodule

