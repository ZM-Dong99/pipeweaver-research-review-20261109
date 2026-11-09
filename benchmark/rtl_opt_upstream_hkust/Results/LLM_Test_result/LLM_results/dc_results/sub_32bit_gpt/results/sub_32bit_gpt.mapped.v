/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03-SP2
// Date      : Mon May 12 14:31:07 2025
/////////////////////////////////////////////////////////////


module sub_32bit_gpt ( a, b, diff, overflow );
  input [31:0] a;
  input [31:0] b;
  output [31:0] diff;
  output overflow;
  wire   n5, n6, sub_11_n516, sub_11_n515, sub_11_n514, sub_11_n513,
         sub_11_n512, sub_11_n511, sub_11_n510, sub_11_n509, sub_11_n508,
         sub_11_n507, sub_11_n506, sub_11_n505, sub_11_n504, sub_11_n503,
         sub_11_n502, sub_11_n501, sub_11_n500, sub_11_n499, sub_11_n498,
         sub_11_n497, sub_11_n496, sub_11_n495, sub_11_n494, sub_11_n493,
         sub_11_n492, sub_11_n491, sub_11_n490, sub_11_n489, sub_11_n488,
         sub_11_n487, sub_11_n486, sub_11_n485, sub_11_n484, sub_11_n483,
         sub_11_n482, sub_11_n481, sub_11_n480, sub_11_n479, sub_11_n478,
         sub_11_n477, sub_11_n476, sub_11_n475, sub_11_n474, sub_11_n473,
         sub_11_n472, sub_11_n471, sub_11_n470, sub_11_n469, sub_11_n468,
         sub_11_n467, sub_11_n466, sub_11_n465, sub_11_n464, sub_11_n463,
         sub_11_n462, sub_11_n461, sub_11_n460, sub_11_n459, sub_11_n458,
         sub_11_n457, sub_11_n456, sub_11_n455, sub_11_n454, sub_11_n453,
         sub_11_n452, sub_11_n451, sub_11_n450, sub_11_n449, sub_11_n448,
         sub_11_n447, sub_11_n446, sub_11_n445, sub_11_n444, sub_11_n443,
         sub_11_n442, sub_11_n441, sub_11_n440, sub_11_n439, sub_11_n438,
         sub_11_n437, sub_11_n436, sub_11_n435, sub_11_n434, sub_11_n433,
         sub_11_n432, sub_11_n431, sub_11_n430, sub_11_n429, sub_11_n428,
         sub_11_n427, sub_11_n426, sub_11_n425, sub_11_n424, sub_11_n423,
         sub_11_n422, sub_11_n421, sub_11_n420, sub_11_n419, sub_11_n418,
         sub_11_n417, sub_11_n416, sub_11_n415, sub_11_n414, sub_11_n413,
         sub_11_n412, sub_11_n411, sub_11_n410, sub_11_n409, sub_11_n408,
         sub_11_n407, sub_11_n406, sub_11_n405, sub_11_n404, sub_11_n403,
         sub_11_n402, sub_11_n401, sub_11_n400, sub_11_n399, sub_11_n398,
         sub_11_n397, sub_11_n396, sub_11_n395, sub_11_n394, sub_11_n393,
         sub_11_n392, sub_11_n391, sub_11_n390, sub_11_n389, sub_11_n388,
         sub_11_n387, sub_11_n386, sub_11_n385, sub_11_n384, sub_11_n383,
         sub_11_n382, sub_11_n381, sub_11_n380, sub_11_n379, sub_11_n378,
         sub_11_n377, sub_11_n376, sub_11_n375, sub_11_n374, sub_11_n373,
         sub_11_n372, sub_11_n371, sub_11_n370, sub_11_n369, sub_11_n368,
         sub_11_n367, sub_11_n366, sub_11_n365, sub_11_n364, sub_11_n363,
         sub_11_n362, sub_11_n361, sub_11_n360, sub_11_n359, sub_11_n358,
         sub_11_n357, sub_11_n356, sub_11_n355, sub_11_n354, sub_11_n353,
         sub_11_n352, sub_11_n351, sub_11_n350, sub_11_n349, sub_11_n348,
         sub_11_n347, sub_11_n346, sub_11_n345, sub_11_n344, sub_11_n343,
         sub_11_n342, sub_11_n341, sub_11_n340, sub_11_n339, sub_11_n338,
         sub_11_n337, sub_11_n336, sub_11_n335, sub_11_n334, sub_11_n333,
         sub_11_n332, sub_11_n331, sub_11_n330, sub_11_n329, sub_11_n328,
         sub_11_n327, sub_11_n326, sub_11_n325, sub_11_n324, sub_11_n323,
         sub_11_n322, sub_11_n321, sub_11_n320, sub_11_n319, sub_11_n318,
         sub_11_n317, sub_11_n316, sub_11_n315, sub_11_n314, sub_11_n313,
         sub_11_n312, sub_11_n311, sub_11_n310, sub_11_n309, sub_11_n308,
         sub_11_n307, sub_11_n306, sub_11_n305, sub_11_n304, sub_11_n303,
         sub_11_n302, sub_11_n301, sub_11_n300, sub_11_n299, sub_11_n298,
         sub_11_n297, sub_11_n296, sub_11_n295, sub_11_n294, sub_11_n293,
         sub_11_n292, sub_11_n291, sub_11_n290, sub_11_n289, sub_11_n288,
         sub_11_n287, sub_11_n286, sub_11_n285, sub_11_n284, sub_11_n283,
         sub_11_n282, sub_11_n281, sub_11_n280, sub_11_n279, sub_11_n278,
         sub_11_n277, sub_11_n276, sub_11_n275, sub_11_n274, sub_11_n273,
         sub_11_n272, sub_11_n271, sub_11_n270, sub_11_n269, sub_11_n268,
         sub_11_n267, sub_11_n266, sub_11_n265, sub_11_n264, sub_11_n263,
         sub_11_n262, sub_11_n261, sub_11_n260, sub_11_n259, sub_11_n258,
         sub_11_n257, sub_11_n256, sub_11_n255, sub_11_n254, sub_11_n253,
         sub_11_n252, sub_11_n251, sub_11_n250, sub_11_n249, sub_11_n248,
         sub_11_n247, sub_11_n246, sub_11_n245, sub_11_n244, sub_11_n243,
         sub_11_n242, sub_11_n241, sub_11_n240, sub_11_n239, sub_11_n238,
         sub_11_n237, sub_11_n236, sub_11_n235, sub_11_n234, sub_11_n233,
         sub_11_n232, sub_11_n231, sub_11_n230, sub_11_n229, sub_11_n228,
         sub_11_n227, sub_11_n226, sub_11_n225, sub_11_n224, sub_11_n223,
         sub_11_n222, sub_11_n221, sub_11_n220, sub_11_n219, sub_11_n218,
         sub_11_n217, sub_11_n216, sub_11_n215, sub_11_n214, sub_11_n213,
         sub_11_n212, sub_11_n211, sub_11_n210, sub_11_n209, sub_11_n208,
         sub_11_n207, sub_11_n206, sub_11_n205, sub_11_n204, sub_11_n203,
         sub_11_n202, sub_11_n201, sub_11_n200, sub_11_n199, sub_11_n198,
         sub_11_n197, sub_11_n196, sub_11_n195, sub_11_n194, sub_11_n193,
         sub_11_n192, sub_11_n191, sub_11_n190, sub_11_n189, sub_11_n188,
         sub_11_n187, sub_11_n186, sub_11_n185, sub_11_n184, sub_11_n183,
         sub_11_n182, sub_11_n181, sub_11_n180, sub_11_n179, sub_11_n178,
         sub_11_n177, sub_11_n176, sub_11_n175, sub_11_n174, sub_11_n173,
         sub_11_n172, sub_11_n171, sub_11_n170, sub_11_n169, sub_11_n168,
         sub_11_n167, sub_11_n166, sub_11_n165, sub_11_n164, sub_11_n163,
         sub_11_n162, sub_11_n161, sub_11_n160, sub_11_n159, sub_11_n158,
         sub_11_n157, sub_11_n156, sub_11_n155, sub_11_n154, sub_11_n153,
         sub_11_n152, sub_11_n151, sub_11_n150, sub_11_n149, sub_11_n148,
         sub_11_n147, sub_11_n146, sub_11_n145, sub_11_n144, sub_11_n143,
         sub_11_n142, sub_11_n141, sub_11_n139, sub_11_n138, sub_11_n137,
         sub_11_n136, sub_11_n135, sub_11_n134, sub_11_n133, sub_11_n132,
         sub_11_n131, sub_11_n130, sub_11_n129, sub_11_n128, sub_11_n127,
         sub_11_n126, sub_11_n125, sub_11_n124, sub_11_n123, sub_11_n122,
         sub_11_n121, sub_11_n120, sub_11_n119, sub_11_n118, sub_11_n117,
         sub_11_n116, sub_11_n115, sub_11_n114, sub_11_n113, sub_11_n112,
         sub_11_n111, sub_11_n110, sub_11_n109, sub_11_n108, sub_11_n107,
         sub_11_n106, sub_11_n105, sub_11_n104, sub_11_n103, sub_11_n102,
         sub_11_n101, sub_11_n100, sub_11_n99, sub_11_n98, sub_11_n97,
         sub_11_n96, sub_11_n95, sub_11_n94, sub_11_n93, sub_11_n92,
         sub_11_n91, sub_11_n90, sub_11_n89, sub_11_n88, sub_11_n87,
         sub_11_n86, sub_11_n85, sub_11_n84, sub_11_n83, sub_11_n82,
         sub_11_n81, sub_11_n80, sub_11_n79, sub_11_n78, sub_11_n77,
         sub_11_n76, sub_11_n75, sub_11_n74, sub_11_n73, sub_11_n72,
         sub_11_n71, sub_11_n70, sub_11_n69, sub_11_n68, sub_11_n67,
         sub_11_n66, sub_11_n65, sub_11_n64, sub_11_n63, sub_11_n62,
         sub_11_n61, sub_11_n60, sub_11_n59, sub_11_n58, sub_11_n57,
         sub_11_n56, sub_11_n55, sub_11_n54, sub_11_n53, sub_11_n52,
         sub_11_n51, sub_11_n50, sub_11_n49, sub_11_n48, sub_11_n47,
         sub_11_n46, sub_11_n45, sub_11_n44, sub_11_n43, sub_11_n42,
         sub_11_n41, sub_11_n40, sub_11_n39, sub_11_n38, sub_11_n37,
         sub_11_n36, sub_11_n35, sub_11_n34, sub_11_n33, sub_11_n32,
         sub_11_n31, sub_11_n30, sub_11_n29, sub_11_n28, sub_11_n27,
         sub_11_n26, sub_11_n25, sub_11_n24, sub_11_n23, sub_11_n22,
         sub_11_n21, sub_11_n20, sub_11_n19, sub_11_n18, sub_11_n17,
         sub_11_n16, sub_11_n15, sub_11_n14, sub_11_n13, sub_11_n12,
         sub_11_n11, sub_11_n10, sub_11_n9, sub_11_n8, sub_11_n7, sub_11_n6,
         sub_11_n5, sub_11_n4, sub_11_n3, sub_11_n2, sub_11_n1;

  XNOR2_X1 U6 ( .A(a[31]), .B(b[31]), .ZN(n5) );
  NOR2_X1 U7 ( .A1(n6), .A2(n5), .ZN(overflow) );
  XNOR2_X1 U8 ( .A(diff[31]), .B(a[31]), .ZN(n6) );
  INV_X1 sub_11_U549 ( .A(sub_11_n404), .ZN(sub_11_n370) );
  INV_X1 sub_11_U548 ( .A(sub_11_n371), .ZN(sub_11_n516) );
  NOR2_X1 sub_11_U547 ( .A1(sub_11_n54), .A2(sub_11_n116), .ZN(sub_11_n494) );
  NAND3_X1 sub_11_U546 ( .A1(sub_11_n183), .A2(sub_11_n182), .A3(sub_11_n181), 
        .ZN(sub_11_n163) );
  INV_X1 sub_11_U545 ( .A(sub_11_n117), .ZN(sub_11_n473) );
  XNOR2_X1 sub_11_U544 ( .A(sub_11_n481), .B(sub_11_n482), .ZN(diff[11]) );
  INV_X1 sub_11_U543 ( .A(sub_11_n464), .ZN(sub_11_n463) );
  NAND2_X1 sub_11_U542 ( .A1(sub_11_n441), .A2(sub_11_n442), .ZN(sub_11_n440)
         );
  NAND3_X1 sub_11_U541 ( .A1(sub_11_n440), .A2(sub_11_n439), .A3(sub_11_n63), 
        .ZN(sub_11_n387) );
  NOR2_X1 sub_11_U540 ( .A1(sub_11_n144), .A2(sub_11_n137), .ZN(sub_11_n399)
         );
  NAND3_X1 sub_11_U539 ( .A1(sub_11_n126), .A2(sub_11_n169), .A3(sub_11_n132), 
        .ZN(sub_11_n427) );
  NAND3_X1 sub_11_U538 ( .A1(sub_11_n136), .A2(sub_11_n419), .A3(sub_11_n154), 
        .ZN(sub_11_n416) );
  NAND3_X1 sub_11_U537 ( .A1(sub_11_n409), .A2(sub_11_n55), .A3(sub_11_n122), 
        .ZN(sub_11_n417) );
  INV_X1 sub_11_U536 ( .A(sub_11_n216), .ZN(sub_11_n317) );
  INV_X1 sub_11_U535 ( .A(sub_11_n215), .ZN(sub_11_n318) );
  NAND2_X1 sub_11_U534 ( .A1(sub_11_n217), .A2(sub_11_n391), .ZN(sub_11_n383)
         );
  NAND3_X1 sub_11_U533 ( .A1(sub_11_n138), .A2(sub_11_n385), .A3(sub_11_n386), 
        .ZN(sub_11_n221) );
  NAND2_X1 sub_11_U532 ( .A1(sub_11_n128), .A2(sub_11_n221), .ZN(sub_11_n384)
         );
  XNOR2_X1 sub_11_U531 ( .A(sub_11_n376), .B(sub_11_n377), .ZN(diff[18]) );
  INV_X1 sub_11_U530 ( .A(sub_11_n376), .ZN(sub_11_n375) );
  XNOR2_X1 sub_11_U529 ( .A(sub_11_n372), .B(sub_11_n373), .ZN(diff[19]) );
  INV_X1 sub_11_U528 ( .A(sub_11_n230), .ZN(sub_11_n285) );
  XNOR2_X1 sub_11_U527 ( .A(sub_11_n343), .B(sub_11_n344), .ZN(diff[20]) );
  XNOR2_X1 sub_11_U526 ( .A(sub_11_n327), .B(sub_11_n328), .ZN(diff[22]) );
  NAND2_X1 sub_11_U525 ( .A1(sub_11_n217), .A2(sub_11_n316), .ZN(sub_11_n315)
         );
  NAND3_X1 sub_11_U524 ( .A1(sub_11_n115), .A2(sub_11_n311), .A3(sub_11_n312), 
        .ZN(sub_11_n307) );
  NAND3_X1 sub_11_U523 ( .A1(sub_11_n310), .A2(sub_11_n309), .A3(b[21]), .ZN(
        sub_11_n308) );
  NAND3_X1 sub_11_U522 ( .A1(sub_11_n307), .A2(sub_11_n306), .A3(sub_11_n308), 
        .ZN(sub_11_n304) );
  XNOR2_X1 sub_11_U521 ( .A(sub_11_n125), .B(sub_11_n302), .ZN(diff[24]) );
  INV_X1 sub_11_U520 ( .A(sub_11_n301), .ZN(sub_11_n256) );
  INV_X1 sub_11_U519 ( .A(sub_11_n296), .ZN(sub_11_n300) );
  XNOR2_X1 sub_11_U518 ( .A(sub_11_n297), .B(sub_11_n298), .ZN(diff[25]) );
  INV_X1 sub_11_U517 ( .A(sub_11_n293), .ZN(sub_11_n294) );
  XNOR2_X1 sub_11_U516 ( .A(sub_11_n288), .B(sub_11_n289), .ZN(diff[26]) );
  XNOR2_X1 sub_11_U515 ( .A(sub_11_n262), .B(sub_11_n263), .ZN(diff[28]) );
  NAND2_X1 sub_11_U514 ( .A1(sub_11_n108), .A2(sub_11_n41), .ZN(sub_11_n257)
         );
  NAND3_X1 sub_11_U513 ( .A1(sub_11_n261), .A2(sub_11_n108), .A3(sub_11_n260), 
        .ZN(sub_11_n258) );
  XNOR2_X1 sub_11_U512 ( .A(sub_11_n252), .B(sub_11_n253), .ZN(diff[29]) );
  INV_X1 sub_11_U511 ( .A(sub_11_n251), .ZN(sub_11_n247) );
  INV_X1 sub_11_U510 ( .A(sub_11_n250), .ZN(sub_11_n248) );
  NAND3_X1 sub_11_U509 ( .A1(sub_11_n15), .A2(sub_11_n107), .A3(sub_11_n111), 
        .ZN(sub_11_n213) );
  INV_X1 sub_11_U508 ( .A(sub_11_n243), .ZN(sub_11_n242) );
  INV_X1 sub_11_U507 ( .A(sub_11_n240), .ZN(sub_11_n237) );
  NAND3_X1 sub_11_U506 ( .A1(sub_11_n234), .A2(sub_11_n103), .A3(sub_11_n233), 
        .ZN(sub_11_n232) );
  NAND2_X1 sub_11_U505 ( .A1(sub_11_n231), .A2(sub_11_n232), .ZN(sub_11_n200)
         );
  NAND3_X1 sub_11_U504 ( .A1(sub_11_n106), .A2(sub_11_n40), .A3(sub_11_n135), 
        .ZN(sub_11_n228) );
  NAND3_X1 sub_11_U503 ( .A1(sub_11_n228), .A2(sub_11_n227), .A3(sub_11_n226), 
        .ZN(sub_11_n222) );
  NAND2_X1 sub_11_U502 ( .A1(sub_11_n220), .A2(sub_11_n221), .ZN(sub_11_n219)
         );
  NAND2_X1 sub_11_U501 ( .A1(sub_11_n148), .A2(sub_11_n216), .ZN(sub_11_n214)
         );
  NOR2_X1 sub_11_U500 ( .A1(sub_11_n130), .A2(sub_11_n214), .ZN(sub_11_n210)
         );
  INV_X1 sub_11_U499 ( .A(sub_11_n201), .ZN(sub_11_n207) );
  NAND2_X1 sub_11_U498 ( .A1(sub_11_n212), .A2(sub_11_n143), .ZN(sub_11_n211)
         );
  INV_X1 sub_11_U497 ( .A(sub_11_n110), .ZN(sub_11_n206) );
  NOR2_X1 sub_11_U496 ( .A1(sub_11_n206), .A2(sub_11_n207), .ZN(sub_11_n202)
         );
  INV_X1 sub_11_U495 ( .A(sub_11_n205), .ZN(sub_11_n204) );
  NAND2_X1 sub_11_U494 ( .A1(sub_11_n200), .A2(sub_11_n201), .ZN(sub_11_n199)
         );
  NAND2_X1 sub_11_U493 ( .A1(sub_11_n199), .A2(sub_11_n198), .ZN(sub_11_n197)
         );
  INV_X1 sub_11_U492 ( .A(sub_11_n193), .ZN(sub_11_n191) );
  OAI21_X1 sub_11_U491 ( .B1(sub_11_n191), .B2(sub_11_n116), .A(sub_11_n192), 
        .ZN(sub_11_n188) );
  XNOR2_X1 sub_11_U490 ( .A(sub_11_n188), .B(sub_11_n189), .ZN(diff[3]) );
  INV_X1 sub_11_U489 ( .A(sub_11_n187), .ZN(sub_11_n186) );
  NAND2_X1 sub_11_U488 ( .A1(sub_11_n186), .A2(sub_11_n23), .ZN(sub_11_n184)
         );
  XNOR2_X1 sub_11_U487 ( .A(sub_11_n184), .B(sub_11_n185), .ZN(diff[4]) );
  NAND3_X1 sub_11_U486 ( .A1(sub_11_n183), .A2(sub_11_n182), .A3(sub_11_n181), 
        .ZN(sub_11_n179) );
  INV_X1 sub_11_U485 ( .A(sub_11_n39), .ZN(sub_11_n174) );
  OAI21_X1 sub_11_U484 ( .B1(sub_11_n20), .B2(sub_11_n174), .A(sub_11_n503), 
        .ZN(sub_11_n172) );
  INV_X1 sub_11_U483 ( .A(sub_11_n170), .ZN(sub_11_n168) );
  XNOR2_X1 sub_11_U482 ( .A(sub_11_n164), .B(sub_11_n165), .ZN(diff[7]) );
  INV_X1 sub_11_U481 ( .A(sub_11_n163), .ZN(sub_11_n161) );
  OAI21_X1 sub_11_U480 ( .B1(sub_11_n161), .B2(sub_11_n19), .A(sub_11_n60), 
        .ZN(sub_11_n159) );
  XNOR2_X1 sub_11_U479 ( .A(sub_11_n159), .B(sub_11_n160), .ZN(diff[8]) );
  INV_X1 sub_11_U478 ( .A(sub_11_n156), .ZN(sub_11_n155) );
  INV_X1 sub_11_U477 ( .A(sub_11_n152), .ZN(sub_11_n151) );
  NOR2_X1 sub_11_U476 ( .A1(sub_11_n151), .A2(sub_11_n141), .ZN(sub_11_n150)
         );
  OAI21_X1 sub_11_U475 ( .B1(sub_11_n285), .B2(sub_11_n336), .A(sub_11_n335), 
        .ZN(sub_11_n342) );
  OAI21_X1 sub_11_U474 ( .B1(sub_11_n285), .B2(sub_11_n325), .A(sub_11_n326), 
        .ZN(sub_11_n324) );
  OAI21_X1 sub_11_U473 ( .B1(sub_11_n285), .B2(sub_11_n286), .A(sub_11_n287), 
        .ZN(sub_11_n284) );
  NAND2_X1 sub_11_U472 ( .A1(sub_11_n413), .A2(sub_11_n123), .ZN(sub_11_n450)
         );
  NAND2_X1 sub_11_U471 ( .A1(sub_11_n382), .A2(sub_11_n135), .ZN(sub_11_n396)
         );
  NAND2_X1 sub_11_U470 ( .A1(sub_11_n458), .A2(sub_11_n413), .ZN(sub_11_n457)
         );
  NAND2_X1 sub_11_U469 ( .A1(sub_11_n413), .A2(sub_11_n411), .ZN(sub_11_n459)
         );
  OAI21_X1 sub_11_U468 ( .B1(sub_11_n285), .B2(sub_11_n336), .A(sub_11_n335), 
        .ZN(sub_11_n343) );
  OAI21_X1 sub_11_U467 ( .B1(sub_11_n68), .B2(sub_11_n325), .A(sub_11_n326), 
        .ZN(sub_11_n327) );
  OAI21_X1 sub_11_U466 ( .B1(sub_11_n68), .B2(sub_11_n286), .A(sub_11_n81), 
        .ZN(sub_11_n288) );
  XNOR2_X1 sub_11_U465 ( .A(sub_11_n135), .B(sub_11_n397), .ZN(diff[16]) );
  NOR2_X1 sub_11_U464 ( .A1(sub_11_n162), .A2(sub_11_n54), .ZN(sub_11_n438) );
  NOR2_X1 sub_11_U463 ( .A1(sub_11_n162), .A2(sub_11_n83), .ZN(sub_11_n388) );
  NAND2_X1 sub_11_U462 ( .A1(sub_11_n82), .A2(sub_11_n158), .ZN(sub_11_n462)
         );
  OAI21_X1 sub_11_U461 ( .B1(sub_11_n476), .B2(sub_11_n82), .A(sub_11_n60), 
        .ZN(sub_11_n475) );
  NAND2_X1 sub_11_U460 ( .A1(sub_11_n342), .A2(sub_11_n313), .ZN(sub_11_n341)
         );
  NOR2_X1 sub_11_U459 ( .A1(sub_11_n213), .A2(sub_11_n207), .ZN(sub_11_n212)
         );
  AOI21_X1 sub_11_U458 ( .B1(sub_11_n241), .B2(sub_11_n229), .A(sub_11_n242), 
        .ZN(sub_11_n231) );
  INV_X1 sub_11_U457 ( .A(b[25]), .ZN(sub_11_n271) );
  NOR2_X1 sub_11_U456 ( .A1(sub_11_n219), .A2(sub_11_n218), .ZN(sub_11_n209)
         );
  AOI21_X1 sub_11_U455 ( .B1(sub_11_n209), .B2(sub_11_n210), .A(sub_11_n211), 
        .ZN(sub_11_n196) );
  NOR2_X1 sub_11_U454 ( .A1(sub_11_n196), .A2(sub_11_n197), .ZN(sub_11_n195)
         );
  XNOR2_X1 sub_11_U453 ( .A(sub_11_n195), .B(sub_11_n194), .ZN(diff[31]) );
  NAND2_X1 sub_11_U452 ( .A1(sub_11_n324), .A2(sub_11_n114), .ZN(sub_11_n323)
         );
  NAND4_X1 sub_11_U451 ( .A1(sub_11_n477), .A2(sub_11_n478), .A3(sub_11_n479), 
        .A4(sub_11_n418), .ZN(sub_11_n390) );
  NOR2_X1 sub_11_U450 ( .A1(sub_11_n146), .A2(sub_11_n390), .ZN(sub_11_n389)
         );
  NOR2_X1 sub_11_U449 ( .A1(sub_11_n146), .A2(sub_11_n390), .ZN(sub_11_n437)
         );
  NAND2_X1 sub_11_U448 ( .A1(sub_11_n284), .A2(sub_11_n96), .ZN(sub_11_n283)
         );
  NOR2_X1 sub_11_U447 ( .A1(sub_11_n318), .A2(sub_11_n317), .ZN(sub_11_n316)
         );
  NOR2_X1 sub_11_U446 ( .A1(sub_11_n318), .A2(sub_11_n392), .ZN(sub_11_n391)
         );
  NOR2_X1 sub_11_U445 ( .A1(sub_11_n318), .A2(sub_11_n317), .ZN(sub_11_n400)
         );
  NAND2_X1 sub_11_U444 ( .A1(sub_11_n283), .A2(sub_11_n269), .ZN(sub_11_n280)
         );
  OAI211_X1 sub_11_U443 ( .C1(sub_11_n431), .C2(sub_11_n432), .A(sub_11_n419), 
        .B(sub_11_n418), .ZN(sub_11_n430) );
  NAND2_X1 sub_11_U442 ( .A1(sub_11_n429), .A2(sub_11_n430), .ZN(sub_11_n386)
         );
  NAND2_X1 sub_11_U441 ( .A1(b[9]), .A2(sub_11_n134), .ZN(sub_11_n479) );
  NOR2_X1 sub_11_U440 ( .A1(b[9]), .A2(sub_11_n133), .ZN(sub_11_n432) );
  NAND2_X1 sub_11_U439 ( .A1(b[9]), .A2(sub_11_n433), .ZN(sub_11_n419) );
  NAND2_X1 sub_11_U438 ( .A1(sub_11_n323), .A2(sub_11_n8), .ZN(sub_11_n319) );
  NAND4_X1 sub_11_U437 ( .A1(b[5]), .A2(sub_11_n38), .A3(sub_11_n88), .A4(
        sub_11_n86), .ZN(sub_11_n508) );
  NAND2_X1 sub_11_U436 ( .A1(sub_11_n427), .A2(sub_11_n426), .ZN(sub_11_n420)
         );
  NAND2_X1 sub_11_U435 ( .A1(sub_11_n503), .A2(sub_11_n33), .ZN(sub_11_n178)
         );
  OAI21_X1 sub_11_U434 ( .B1(sub_11_n168), .B2(sub_11_n25), .A(sub_11_n52), 
        .ZN(sub_11_n164) );
  NAND2_X1 sub_11_U433 ( .A1(sub_11_n167), .A2(sub_11_n121), .ZN(sub_11_n423)
         );
  NAND4_X1 sub_11_U432 ( .A1(sub_11_n423), .A2(sub_11_n413), .A3(sub_11_n385), 
        .A4(sub_11_n28), .ZN(sub_11_n421) );
  NOR2_X1 sub_11_U431 ( .A1(sub_11_n421), .A2(sub_11_n420), .ZN(sub_11_n414)
         );
  INV_X1 sub_11_U430 ( .A(b[24]), .ZN(sub_11_n278) );
  NAND4_X1 sub_11_U429 ( .A1(sub_11_n399), .A2(sub_11_n217), .A3(sub_11_n400), 
        .A4(sub_11_n128), .ZN(sub_11_n230) );
  NAND2_X1 sub_11_U428 ( .A1(sub_11_n341), .A2(sub_11_n109), .ZN(sub_11_n337)
         );
  NAND2_X1 sub_11_U427 ( .A1(sub_11_n445), .A2(sub_11_n84), .ZN(sub_11_n181)
         );
  NAND4_X1 sub_11_U426 ( .A1(sub_11_n158), .A2(sub_11_n22), .A3(sub_11_n181), 
        .A4(sub_11_n183), .ZN(sub_11_n461) );
  NAND2_X1 sub_11_U425 ( .A1(sub_11_n163), .A2(sub_11_n18), .ZN(sub_11_n157)
         );
  NAND2_X1 sub_11_U424 ( .A1(sub_11_n84), .A2(sub_11_n190), .ZN(sub_11_n189)
         );
  XNOR2_X1 sub_11_U423 ( .A(sub_11_n337), .B(sub_11_n338), .ZN(diff[21]) );
  NAND2_X1 sub_11_U422 ( .A1(a[2]), .A2(sub_11_n246), .ZN(sub_11_n501) );
  OAI211_X1 sub_11_U421 ( .C1(a[2]), .C2(sub_11_n61), .A(a[1]), .B(sub_11_n368), .ZN(sub_11_n439) );
  AND3_X1 sub_11_U420 ( .A1(sub_11_n90), .A2(sub_11_n388), .A3(sub_11_n389), 
        .ZN(sub_11_n218) );
  NAND2_X1 sub_11_U419 ( .A1(a[2]), .A2(sub_11_n62), .ZN(sub_11_n192) );
  OAI21_X1 sub_11_U418 ( .B1(sub_11_n405), .B2(sub_11_n406), .A(sub_11_n407), 
        .ZN(sub_11_n215) );
  OAI21_X1 sub_11_U417 ( .B1(sub_11_n405), .B2(sub_11_n406), .A(sub_11_n407), 
        .ZN(sub_11_n148) );
  NAND2_X1 sub_11_U416 ( .A1(a[18]), .A2(sub_11_n365), .ZN(sub_11_n352) );
  NOR2_X1 sub_11_U415 ( .A1(a[18]), .A2(sub_11_n5), .ZN(sub_11_n364) );
  NAND2_X1 sub_11_U414 ( .A1(sub_11_n104), .A2(sub_11_n240), .ZN(sub_11_n335)
         );
  OAI21_X1 sub_11_U413 ( .B1(sub_11_n375), .B2(sub_11_n32), .A(sub_11_n101), 
        .ZN(sub_11_n372) );
  NAND2_X1 sub_11_U412 ( .A1(sub_11_n354), .A2(sub_11_n352), .ZN(sub_11_n377)
         );
  NAND2_X1 sub_11_U411 ( .A1(sub_11_n16), .A2(sub_11_n44), .ZN(sub_11_n236) );
  OAI21_X1 sub_11_U410 ( .B1(a[25]), .B2(sub_11_n271), .A(sub_11_n272), .ZN(
        sub_11_n267) );
  NAND2_X1 sub_11_U409 ( .A1(a[25]), .A2(sub_11_n271), .ZN(sub_11_n273) );
  OAI21_X1 sub_11_U408 ( .B1(sub_11_n256), .B2(sub_11_n236), .A(sub_11_n266), 
        .ZN(sub_11_n262) );
  NOR2_X1 sub_11_U407 ( .A1(sub_11_n235), .A2(sub_11_n236), .ZN(sub_11_n234)
         );
  NAND4_X1 sub_11_U406 ( .A1(sub_11_n422), .A2(sub_11_n424), .A3(sub_11_n122), 
        .A4(sub_11_n67), .ZN(sub_11_n147) );
  NAND4_X1 sub_11_U405 ( .A1(sub_11_n413), .A2(sub_11_n424), .A3(sub_11_n123), 
        .A4(sub_11_n409), .ZN(sub_11_n146) );
  NOR2_X1 sub_11_U404 ( .A1(sub_11_n443), .A2(sub_11_n444), .ZN(sub_11_n441)
         );
  XNOR2_X1 sub_11_U403 ( .A(sub_11_n280), .B(sub_11_n281), .ZN(diff[27]) );
  INV_X1 sub_11_U402 ( .A(a[7]), .ZN(sub_11_n510) );
  NAND2_X1 sub_11_U401 ( .A1(b[8]), .A2(sub_11_n434), .ZN(sub_11_n478) );
  AND4_X1 sub_11_U400 ( .A1(sub_11_n477), .A2(sub_11_n478), .A3(sub_11_n479), 
        .A4(sub_11_n117), .ZN(sub_11_n145) );
  INV_X1 sub_11_U399 ( .A(b[26]), .ZN(sub_11_n279) );
  INV_X1 sub_11_U398 ( .A(b[27]), .ZN(sub_11_n277) );
  NAND2_X1 sub_11_U397 ( .A1(sub_11_n294), .A2(sub_11_n40), .ZN(sub_11_n286)
         );
  XNOR2_X1 sub_11_U396 ( .A(sub_11_n319), .B(sub_11_n320), .ZN(diff[23]) );
  OAI21_X1 sub_11_U395 ( .B1(sub_11_n267), .B2(sub_11_n50), .A(sub_11_n268), 
        .ZN(sub_11_n261) );
  OAI21_X1 sub_11_U394 ( .B1(sub_11_n256), .B2(sub_11_n300), .A(sub_11_n274), 
        .ZN(sub_11_n297) );
  NAND2_X1 sub_11_U393 ( .A1(sub_11_n11), .A2(sub_11_n260), .ZN(sub_11_n266)
         );
  NAND2_X1 sub_11_U392 ( .A1(sub_11_n113), .A2(sub_11_n105), .ZN(sub_11_n290)
         );
  NAND2_X1 sub_11_U391 ( .A1(a[24]), .A2(sub_11_n278), .ZN(sub_11_n274) );
  NAND2_X1 sub_11_U390 ( .A1(sub_11_n157), .A2(sub_11_n60), .ZN(sub_11_n153)
         );
  OAI211_X1 sub_11_U389 ( .C1(sub_11_n59), .C2(sub_11_n490), .A(sub_11_n154), 
        .B(sub_11_n419), .ZN(sub_11_n488) );
  NAND2_X1 sub_11_U388 ( .A1(sub_11_n488), .A2(sub_11_n152), .ZN(sub_11_n484)
         );
  NAND2_X1 sub_11_U387 ( .A1(a[16]), .A2(sub_11_n356), .ZN(sub_11_n348) );
  NOR2_X1 sub_11_U386 ( .A1(sub_11_n34), .A2(sub_11_n293), .ZN(sub_11_n292) );
  INV_X1 sub_11_U385 ( .A(b[19]), .ZN(sub_11_n366) );
  AND3_X1 sub_11_U384 ( .A1(sub_11_n437), .A2(sub_11_n387), .A3(sub_11_n438), 
        .ZN(sub_11_n144) );
  NAND4_X1 sub_11_U383 ( .A1(sub_11_n173), .A2(sub_11_n169), .A3(sub_11_n37), 
        .A4(sub_11_n176), .ZN(sub_11_n426) );
  NAND4_X1 sub_11_U382 ( .A1(sub_11_n38), .A2(sub_11_n88), .A3(sub_11_n33), 
        .A4(sub_11_n39), .ZN(sub_11_n507) );
  NAND2_X1 sub_11_U381 ( .A1(sub_11_n414), .A2(sub_11_n415), .ZN(sub_11_n220)
         );
  NAND2_X1 sub_11_U380 ( .A1(sub_11_n504), .A2(sub_11_n52), .ZN(sub_11_n171)
         );
  AND2_X1 sub_11_U379 ( .A1(sub_11_n422), .A2(sub_11_n142), .ZN(sub_11_n405)
         );
  AND2_X1 sub_11_U378 ( .A1(sub_11_n409), .A2(sub_11_n408), .ZN(sub_11_n407)
         );
  NAND4_X1 sub_11_U377 ( .A1(sub_11_n313), .A2(sub_11_n314), .A3(sub_11_n114), 
        .A4(sub_11_n92), .ZN(sub_11_n235) );
  NAND2_X1 sub_11_U376 ( .A1(sub_11_n358), .A2(sub_11_n359), .ZN(sub_11_n336)
         );
  AND2_X2 sub_11_U375 ( .A1(a[12]), .A2(sub_11_n467), .ZN(sub_11_n142) );
  NOR2_X1 sub_11_U374 ( .A1(b[8]), .A2(sub_11_n65), .ZN(sub_11_n474) );
  NAND2_X1 sub_11_U373 ( .A1(b[8]), .A2(sub_11_n66), .ZN(sub_11_n154) );
  NOR2_X1 sub_11_U372 ( .A1(b[8]), .A2(sub_11_n65), .ZN(sub_11_n431) );
  NAND2_X1 sub_11_U371 ( .A1(a[13]), .A2(sub_11_n460), .ZN(sub_11_n411) );
  NAND2_X1 sub_11_U370 ( .A1(sub_11_n27), .A2(sub_11_n457), .ZN(sub_11_n453)
         );
  NAND2_X1 sub_11_U369 ( .A1(sub_11_n410), .A2(sub_11_n411), .ZN(sub_11_n406)
         );
  AND2_X1 sub_11_U368 ( .A1(b[9]), .A2(sub_11_n134), .ZN(sub_11_n141) );
  INV_X1 sub_11_U367 ( .A(sub_11_n87), .ZN(sub_11_n226) );
  NAND2_X1 sub_11_U366 ( .A1(sub_11_n136), .A2(sub_11_n37), .ZN(sub_11_n165)
         );
  INV_X1 sub_11_U365 ( .A(a[10]), .ZN(sub_11_n487) );
  NAND2_X1 sub_11_U364 ( .A1(b[10]), .A2(sub_11_n118), .ZN(sub_11_n418) );
  NAND2_X1 sub_11_U363 ( .A1(b[4]), .A2(sub_11_n505), .ZN(sub_11_n180) );
  NAND2_X1 sub_11_U362 ( .A1(sub_11_n129), .A2(sub_11_n39), .ZN(sub_11_n185)
         );
  NAND2_X1 sub_11_U361 ( .A1(sub_11_n179), .A2(sub_11_n129), .ZN(sub_11_n175)
         );
  NAND3_X1 sub_11_U360 ( .A1(sub_11_n245), .A2(sub_11_n84), .A3(sub_11_n404), 
        .ZN(sub_11_n403) );
  INV_X1 sub_11_U359 ( .A(b[9]), .ZN(sub_11_n489) );
  NAND2_X1 sub_11_U358 ( .A1(a[9]), .A2(sub_11_n489), .ZN(sub_11_n152) );
  NAND2_X1 sub_11_U357 ( .A1(a[17]), .A2(sub_11_n362), .ZN(sub_11_n381) );
  NAND2_X1 sub_11_U356 ( .A1(a[1]), .A2(sub_11_n53), .ZN(sub_11_n249) );
  NAND2_X1 sub_11_U355 ( .A1(b[1]), .A2(sub_11_n369), .ZN(sub_11_n250) );
  INV_X1 sub_11_U354 ( .A(a[16]), .ZN(sub_11_n398) );
  NAND2_X1 sub_11_U353 ( .A1(b[16]), .A2(sub_11_n398), .ZN(sub_11_n382) );
  INV_X1 sub_11_U352 ( .A(b[8]), .ZN(sub_11_n506) );
  NAND2_X1 sub_11_U351 ( .A1(a[8]), .A2(sub_11_n506), .ZN(sub_11_n156) );
  NAND2_X1 sub_11_U350 ( .A1(a[0]), .A2(sub_11_n499), .ZN(sub_11_n371) );
  INV_X1 sub_11_U349 ( .A(a[25]), .ZN(sub_11_n299) );
  NAND2_X1 sub_11_U348 ( .A1(b[25]), .A2(sub_11_n299), .ZN(sub_11_n291) );
  OR2_X1 sub_11_U347 ( .A1(sub_11_n95), .A2(a[24]), .ZN(sub_11_n296) );
  INV_X1 sub_11_U346 ( .A(b[30]), .ZN(sub_11_n225) );
  NAND2_X1 sub_11_U345 ( .A1(a[30]), .A2(sub_11_n225), .ZN(sub_11_n205) );
  INV_X1 sub_11_U344 ( .A(b[28]), .ZN(sub_11_n264) );
  NAND2_X1 sub_11_U343 ( .A1(a[28]), .A2(sub_11_n264), .ZN(sub_11_n259) );
  INV_X1 sub_11_U342 ( .A(a[30]), .ZN(sub_11_n224) );
  NAND2_X1 sub_11_U341 ( .A1(b[30]), .A2(sub_11_n224), .ZN(sub_11_n201) );
  NAND2_X1 sub_11_U340 ( .A1(a[16]), .A2(sub_11_n357), .ZN(sub_11_n393) );
  INV_X1 sub_11_U339 ( .A(b[29]), .ZN(sub_11_n255) );
  NAND2_X1 sub_11_U338 ( .A1(a[29]), .A2(sub_11_n255), .ZN(sub_11_n243) );
  INV_X1 sub_11_U337 ( .A(a[27]), .ZN(sub_11_n282) );
  NAND2_X1 sub_11_U336 ( .A1(b[27]), .A2(sub_11_n282), .ZN(sub_11_n260) );
  INV_X1 sub_11_U335 ( .A(b[15]), .ZN(sub_11_n449) );
  NAND2_X1 sub_11_U334 ( .A1(a[15]), .A2(sub_11_n449), .ZN(sub_11_n216) );
  INV_X1 sub_11_U333 ( .A(a[19]), .ZN(sub_11_n374) );
  NAND2_X1 sub_11_U332 ( .A1(b[19]), .A2(sub_11_n374), .ZN(sub_11_n240) );
  INV_X1 sub_11_U331 ( .A(b[23]), .ZN(sub_11_n322) );
  NAND2_X1 sub_11_U330 ( .A1(a[23]), .A2(sub_11_n322), .ZN(sub_11_n305) );
  INV_X1 sub_11_U329 ( .A(a[28]), .ZN(sub_11_n265) );
  INV_X1 sub_11_U328 ( .A(a[29]), .ZN(sub_11_n254) );
  INV_X1 sub_11_U327 ( .A(a[21]), .ZN(sub_11_n309) );
  INV_X1 sub_11_U326 ( .A(b[0]), .ZN(sub_11_n499) );
  NAND2_X1 sub_11_U325 ( .A1(a[1]), .A2(sub_11_n368), .ZN(sub_11_n496) );
  NOR2_X1 sub_11_U324 ( .A1(a[19]), .A2(sub_11_n366), .ZN(sub_11_n363) );
  INV_X1 sub_11_U323 ( .A(b[17]), .ZN(sub_11_n362) );
  NOR2_X1 sub_11_U322 ( .A1(a[17]), .A2(sub_11_n362), .ZN(sub_11_n360) );
  NOR2_X1 sub_11_U321 ( .A1(a[6]), .A2(sub_11_n73), .ZN(sub_11_n511) );
  NAND2_X1 sub_11_U320 ( .A1(a[27]), .A2(sub_11_n277), .ZN(sub_11_n270) );
  INV_X1 sub_11_U319 ( .A(a[20]), .ZN(sub_11_n345) );
  NAND2_X1 sub_11_U318 ( .A1(b[20]), .A2(sub_11_n345), .ZN(sub_11_n313) );
  NAND2_X1 sub_11_U317 ( .A1(b[11]), .A2(sub_11_n480), .ZN(sub_11_n477) );
  INV_X1 sub_11_U316 ( .A(a[11]), .ZN(sub_11_n480) );
  NOR2_X1 sub_11_U315 ( .A1(a[1]), .A2(sub_11_n53), .ZN(sub_11_n498) );
  INV_X1 sub_11_U314 ( .A(b[1]), .ZN(sub_11_n368) );
  NOR2_X1 sub_11_U313 ( .A1(b[17]), .A2(sub_11_n355), .ZN(sub_11_n353) );
  NAND2_X1 sub_11_U312 ( .A1(a[26]), .A2(sub_11_n46), .ZN(sub_11_n269) );
  INV_X1 sub_11_U311 ( .A(a[17]), .ZN(sub_11_n355) );
  NAND2_X1 sub_11_U310 ( .A1(b[17]), .A2(sub_11_n355), .ZN(sub_11_n356) );
  INV_X1 sub_11_U309 ( .A(b[16]), .ZN(sub_11_n357) );
  NOR2_X1 sub_11_U308 ( .A1(a[16]), .A2(sub_11_n357), .ZN(sub_11_n361) );
  NOR2_X1 sub_11_U307 ( .A1(sub_11_n360), .A2(sub_11_n361), .ZN(sub_11_n359)
         );
  NOR2_X1 sub_11_U306 ( .A1(sub_11_n363), .A2(sub_11_n364), .ZN(sub_11_n358)
         );
  INV_X1 sub_11_U305 ( .A(a[21]), .ZN(sub_11_n340) );
  NAND2_X1 sub_11_U304 ( .A1(b[13]), .A2(sub_11_n446), .ZN(sub_11_n422) );
  INV_X1 sub_11_U303 ( .A(b[4]), .ZN(sub_11_n513) );
  INV_X1 sub_11_U302 ( .A(b[5]), .ZN(sub_11_n514) );
  NAND2_X1 sub_11_U301 ( .A1(sub_11_n514), .A2(a[5]), .ZN(sub_11_n173) );
  AOI21_X1 sub_11_U300 ( .B1(b[1]), .B2(sub_11_n369), .A(b[0]), .ZN(
        sub_11_n442) );
  INV_X1 sub_11_U299 ( .A(a[2]), .ZN(sub_11_n495) );
  NAND2_X1 sub_11_U298 ( .A1(sub_11_n495), .A2(b[2]), .ZN(sub_11_n245) );
  INV_X1 sub_11_U297 ( .A(a[8]), .ZN(sub_11_n434) );
  INV_X1 sub_11_U296 ( .A(a[0]), .ZN(sub_11_n444) );
  NAND2_X1 sub_11_U295 ( .A1(sub_11_n58), .A2(b[0]), .ZN(sub_11_n404) );
  NAND2_X1 sub_11_U294 ( .A1(a[0]), .A2(sub_11_n499), .ZN(sub_11_n497) );
  NAND2_X1 sub_11_U293 ( .A1(sub_11_n493), .A2(sub_11_n494), .ZN(sub_11_n182)
         );
  INV_X1 sub_11_U292 ( .A(b[14]), .ZN(sub_11_n455) );
  NAND2_X1 sub_11_U291 ( .A1(a[14]), .A2(sub_11_n455), .ZN(sub_11_n410) );
  INV_X1 sub_11_U290 ( .A(a[23]), .ZN(sub_11_n321) );
  INV_X1 sub_11_U289 ( .A(a[18]), .ZN(sub_11_n378) );
  NAND2_X1 sub_11_U288 ( .A1(b[18]), .A2(sub_11_n378), .ZN(sub_11_n354) );
  INV_X1 sub_11_U287 ( .A(b[12]), .ZN(sub_11_n467) );
  INV_X1 sub_11_U286 ( .A(b[13]), .ZN(sub_11_n460) );
  INV_X1 sub_11_U285 ( .A(a[15]), .ZN(sub_11_n448) );
  NAND2_X1 sub_11_U284 ( .A1(b[15]), .A2(sub_11_n448), .ZN(sub_11_n409) );
  INV_X1 sub_11_U283 ( .A(b[20]), .ZN(sub_11_n346) );
  INV_X1 sub_11_U282 ( .A(a[13]), .ZN(sub_11_n446) );
  INV_X1 sub_11_U281 ( .A(b[3]), .ZN(sub_11_n502) );
  NAND2_X1 sub_11_U280 ( .A1(a[3]), .A2(sub_11_n502), .ZN(sub_11_n190) );
  INV_X1 sub_11_U279 ( .A(b[6]), .ZN(sub_11_n512) );
  INV_X1 sub_11_U278 ( .A(b[21]), .ZN(sub_11_n339) );
  NAND2_X1 sub_11_U277 ( .A1(a[21]), .A2(sub_11_n12), .ZN(sub_11_n312) );
  INV_X1 sub_11_U276 ( .A(a[5]), .ZN(sub_11_n428) );
  INV_X1 sub_11_U275 ( .A(b[22]), .ZN(sub_11_n329) );
  NAND2_X1 sub_11_U274 ( .A1(sub_11_n190), .A2(sub_11_n501), .ZN(sub_11_n445)
         );
  INV_X1 sub_11_U273 ( .A(b[2]), .ZN(sub_11_n246) );
  NAND2_X1 sub_11_U272 ( .A1(sub_11_n119), .A2(b[1]), .ZN(sub_11_n402) );
  INV_X1 sub_11_U271 ( .A(a[1]), .ZN(sub_11_n369) );
  INV_X1 sub_11_U270 ( .A(b[18]), .ZN(sub_11_n365) );
  NAND2_X1 sub_11_U269 ( .A1(sub_11_n304), .A2(sub_11_n305), .ZN(sub_11_n241)
         );
  INV_X1 sub_11_U268 ( .A(a[22]), .ZN(sub_11_n330) );
  INV_X1 sub_11_U267 ( .A(b[7]), .ZN(sub_11_n515) );
  NAND2_X1 sub_11_U266 ( .A1(sub_11_n511), .A2(sub_11_n126), .ZN(sub_11_n509)
         );
  INV_X1 sub_11_U265 ( .A(b[11]), .ZN(sub_11_n483) );
  NAND2_X1 sub_11_U264 ( .A1(a[11]), .A2(sub_11_n483), .ZN(sub_11_n436) );
  AND2_X1 sub_11_U263 ( .A1(sub_11_n269), .A2(sub_11_n270), .ZN(sub_11_n268)
         );
  INV_X1 sub_11_U262 ( .A(a[12]), .ZN(sub_11_n468) );
  INV_X1 sub_11_U261 ( .A(a[4]), .ZN(sub_11_n505) );
  INV_X1 sub_11_U260 ( .A(a[3]), .ZN(sub_11_n500) );
  NAND2_X1 sub_11_U259 ( .A1(a[19]), .A2(sub_11_n366), .ZN(sub_11_n351) );
  NAND2_X1 sub_11_U258 ( .A1(sub_11_n353), .A2(sub_11_n354), .ZN(sub_11_n349)
         );
  NAND2_X1 sub_11_U257 ( .A1(sub_11_n354), .A2(sub_11_n357), .ZN(sub_11_n347)
         );
  INV_X1 sub_11_U256 ( .A(a[6]), .ZN(sub_11_n425) );
  INV_X1 sub_11_U255 ( .A(a[14]), .ZN(sub_11_n456) );
  INV_X1 sub_11_U254 ( .A(a[9]), .ZN(sub_11_n433) );
  AND2_X1 sub_11_U253 ( .A1(sub_11_n435), .A2(sub_11_n436), .ZN(sub_11_n429)
         );
  INV_X1 sub_11_U252 ( .A(b[10]), .ZN(sub_11_n486) );
  NAND2_X1 sub_11_U251 ( .A1(a[10]), .A2(sub_11_n486), .ZN(sub_11_n435) );
  NAND2_X1 sub_11_U250 ( .A1(sub_11_n120), .A2(b[7]), .ZN(sub_11_n166) );
  XNOR2_X1 sub_11_U249 ( .A(b[31]), .B(a[31]), .ZN(sub_11_n194) );
  NAND2_X1 sub_11_U248 ( .A1(b[6]), .A2(sub_11_n425), .ZN(sub_11_n504) );
  OR2_X1 sub_11_U247 ( .A1(sub_11_n370), .A2(sub_11_n516), .ZN(diff[0]) );
  NAND2_X1 sub_11_U246 ( .A1(sub_11_n250), .A2(sub_11_n249), .ZN(sub_11_n367)
         );
  XNOR2_X1 sub_11_U245 ( .A(sub_11_n251), .B(sub_11_n367), .ZN(diff[1]) );
  NAND2_X1 sub_11_U244 ( .A1(sub_11_n245), .A2(sub_11_n192), .ZN(sub_11_n244)
         );
  XNOR2_X1 sub_11_U243 ( .A(sub_11_n193), .B(sub_11_n244), .ZN(diff[2]) );
  NAND2_X1 sub_11_U242 ( .A1(sub_11_n370), .A2(sub_11_n371), .ZN(sub_11_n251)
         );
  OAI21_X1 sub_11_U241 ( .B1(sub_11_n247), .B2(sub_11_n248), .A(sub_11_n249), 
        .ZN(sub_11_n193) );
  NAND2_X1 sub_11_U240 ( .A1(sub_11_n313), .A2(sub_11_n314), .ZN(sub_11_n334)
         );
  NAND2_X1 sub_11_U239 ( .A1(sub_11_n296), .A2(sub_11_n291), .ZN(sub_11_n293)
         );
  NAND2_X1 sub_11_U238 ( .A1(sub_11_n154), .A2(sub_11_n156), .ZN(sub_11_n160)
         );
  NAND2_X1 sub_11_U237 ( .A1(sub_11_n382), .A2(sub_11_n393), .ZN(sub_11_n397)
         );
  OR2_X1 sub_11_U236 ( .A1(sub_11_n334), .A2(sub_11_n336), .ZN(sub_11_n325) );
  NAND2_X1 sub_11_U235 ( .A1(sub_11_n175), .A2(sub_11_n98), .ZN(sub_11_n177)
         );
  XNOR2_X1 sub_11_U234 ( .A(sub_11_n177), .B(sub_11_n178), .ZN(diff[5]) );
  NAND2_X1 sub_11_U233 ( .A1(sub_11_n89), .A2(sub_11_n111), .ZN(sub_11_n227)
         );
  AOI21_X1 sub_11_U232 ( .B1(sub_11_n153), .B2(sub_11_n154), .A(sub_11_n155), 
        .ZN(sub_11_n149) );
  XNOR2_X1 sub_11_U231 ( .A(sub_11_n149), .B(sub_11_n150), .ZN(diff[9]) );
  NAND2_X1 sub_11_U230 ( .A1(sub_11_n113), .A2(sub_11_n296), .ZN(sub_11_n302)
         );
  NAND2_X1 sub_11_U229 ( .A1(sub_11_n451), .A2(sub_11_n452), .ZN(sub_11_n458)
         );
  XNOR2_X1 sub_11_U228 ( .A(sub_11_n458), .B(sub_11_n459), .ZN(diff[13]) );
  NAND2_X1 sub_11_U227 ( .A1(sub_11_n396), .A2(sub_11_n393), .ZN(sub_11_n394)
         );
  NAND2_X1 sub_11_U226 ( .A1(sub_11_n356), .A2(sub_11_n381), .ZN(sub_11_n395)
         );
  XNOR2_X1 sub_11_U225 ( .A(sub_11_n394), .B(sub_11_n395), .ZN(diff[17]) );
  NAND2_X1 sub_11_U224 ( .A1(sub_11_n107), .A2(sub_11_n111), .ZN(sub_11_n238)
         );
  XNOR2_X1 sub_11_U223 ( .A(sub_11_n170), .B(sub_11_n171), .ZN(diff[6]) );
  INV_X1 sub_11_U222 ( .A(sub_11_n314), .ZN(sub_11_n333) );
  NOR2_X1 sub_11_U221 ( .A1(sub_11_n334), .A2(sub_11_n335), .ZN(sub_11_n331)
         );
  OAI21_X1 sub_11_U220 ( .B1(sub_11_n333), .B2(sub_11_n109), .A(sub_11_n100), 
        .ZN(sub_11_n332) );
  NOR2_X1 sub_11_U219 ( .A1(sub_11_n331), .A2(sub_11_n332), .ZN(sub_11_n326)
         );
  NAND2_X1 sub_11_U218 ( .A1(sub_11_n205), .A2(sub_11_n201), .ZN(sub_11_n223)
         );
  XNOR2_X1 sub_11_U217 ( .A(sub_11_n222), .B(sub_11_n223), .ZN(diff[30]) );
  NAND2_X1 sub_11_U216 ( .A1(sub_11_n55), .A2(sub_11_n26), .ZN(sub_11_n485) );
  XNOR2_X1 sub_11_U215 ( .A(sub_11_n484), .B(sub_11_n485), .ZN(diff[10]) );
  NAND2_X1 sub_11_U214 ( .A1(sub_11_n96), .A2(sub_11_n269), .ZN(sub_11_n289)
         );
  NAND2_X1 sub_11_U213 ( .A1(sub_11_n114), .A2(sub_11_n45), .ZN(sub_11_n328)
         );
  NAND2_X1 sub_11_U212 ( .A1(sub_11_n43), .A2(sub_11_n313), .ZN(sub_11_n344)
         );
  NAND2_X1 sub_11_U211 ( .A1(sub_11_n22), .A2(sub_11_n181), .ZN(sub_11_n187)
         );
  INV_X1 sub_11_U210 ( .A(sub_11_n142), .ZN(sub_11_n412) );
  NAND2_X1 sub_11_U209 ( .A1(sub_11_n469), .A2(sub_11_n57), .ZN(sub_11_n465)
         );
  NAND2_X1 sub_11_U208 ( .A1(sub_11_n28), .A2(sub_11_n412), .ZN(sub_11_n466)
         );
  XNOR2_X1 sub_11_U207 ( .A(sub_11_n465), .B(sub_11_n466), .ZN(diff[12]) );
  NOR2_X1 sub_11_U206 ( .A1(sub_11_n24), .A2(sub_11_n187), .ZN(sub_11_n476) );
  NAND2_X1 sub_11_U205 ( .A1(sub_11_n145), .A2(sub_11_n475), .ZN(sub_11_n469)
         );
  NOR2_X1 sub_11_U204 ( .A1(sub_11_n474), .A2(sub_11_n432), .ZN(sub_11_n472)
         );
  NOR3_X1 sub_11_U203 ( .A1(sub_11_n472), .A2(sub_11_n141), .A3(sub_11_n473), 
        .ZN(sub_11_n470) );
  NAND2_X1 sub_11_U202 ( .A1(sub_11_n436), .A2(sub_11_n26), .ZN(sub_11_n471)
         );
  OAI21_X1 sub_11_U201 ( .B1(sub_11_n470), .B2(sub_11_n471), .A(sub_11_n385), 
        .ZN(sub_11_n464) );
  OAI21_X1 sub_11_U200 ( .B1(sub_11_n142), .B2(sub_11_n463), .A(sub_11_n28), 
        .ZN(sub_11_n451) );
  NAND2_X1 sub_11_U199 ( .A1(sub_11_n122), .A2(sub_11_n410), .ZN(sub_11_n454)
         );
  XNOR2_X1 sub_11_U198 ( .A(sub_11_n453), .B(sub_11_n454), .ZN(diff[14]) );
  NAND2_X1 sub_11_U197 ( .A1(sub_11_n240), .A2(sub_11_n351), .ZN(sub_11_n373)
         );
  NAND2_X1 sub_11_U196 ( .A1(sub_11_n393), .A2(sub_11_n216), .ZN(sub_11_n392)
         );
  NOR3_X1 sub_11_U195 ( .A1(sub_11_n383), .A2(sub_11_n93), .A3(sub_11_n384), 
        .ZN(sub_11_n379) );
  NAND2_X1 sub_11_U194 ( .A1(sub_11_n382), .A2(sub_11_n356), .ZN(sub_11_n380)
         );
  OAI21_X1 sub_11_U193 ( .B1(sub_11_n379), .B2(sub_11_n380), .A(sub_11_n381), 
        .ZN(sub_11_n376) );
  NAND2_X1 sub_11_U192 ( .A1(sub_11_n172), .A2(sub_11_n33), .ZN(sub_11_n170)
         );
  AND3_X1 sub_11_U191 ( .A1(sub_11_n451), .A2(sub_11_n411), .A3(sub_11_n452), 
        .ZN(sub_11_n139) );
  OAI21_X1 sub_11_U190 ( .B1(sub_11_n139), .B2(sub_11_n450), .A(sub_11_n410), 
        .ZN(sub_11_n447) );
  NAND2_X1 sub_11_U189 ( .A1(sub_11_n107), .A2(sub_11_n259), .ZN(sub_11_n263)
         );
  NAND2_X1 sub_11_U188 ( .A1(sub_11_n291), .A2(sub_11_n105), .ZN(sub_11_n298)
         );
  AND4_X1 sub_11_U187 ( .A1(sub_11_n413), .A2(sub_11_n28), .A3(sub_11_n123), 
        .A4(sub_11_n67), .ZN(sub_11_n138) );
  NAND2_X1 sub_11_U186 ( .A1(sub_11_n258), .A2(sub_11_n259), .ZN(sub_11_n203)
         );
  AOI21_X1 sub_11_U185 ( .B1(sub_11_n203), .B2(sub_11_n202), .A(sub_11_n204), 
        .ZN(sub_11_n198) );
  OAI21_X1 sub_11_U184 ( .B1(sub_11_n256), .B2(sub_11_n257), .A(sub_11_n112), 
        .ZN(sub_11_n252) );
  NAND2_X1 sub_11_U183 ( .A1(sub_11_n243), .A2(sub_11_n110), .ZN(sub_11_n253)
         );
  OAI21_X1 sub_11_U182 ( .B1(sub_11_n71), .B2(sub_11_n56), .A(sub_11_n435), 
        .ZN(sub_11_n481) );
  NAND2_X1 sub_11_U181 ( .A1(sub_11_n385), .A2(sub_11_n436), .ZN(sub_11_n482)
         );
  NAND2_X1 sub_11_U180 ( .A1(sub_11_n60), .A2(sub_11_n156), .ZN(sub_11_n490)
         );
  INV_X1 sub_11_U179 ( .A(sub_11_n54), .ZN(sub_11_n491) );
  NOR2_X1 sub_11_U178 ( .A1(sub_11_n416), .A2(sub_11_n417), .ZN(sub_11_n415)
         );
  NOR2_X1 sub_11_U177 ( .A1(sub_11_n237), .A2(sub_11_n238), .ZN(sub_11_n233)
         );
  AND3_X1 sub_11_U176 ( .A1(sub_11_n386), .A2(sub_11_n385), .A3(sub_11_n138), 
        .ZN(sub_11_n137) );
  NAND2_X1 sub_11_U175 ( .A1(sub_11_n260), .A2(sub_11_n270), .ZN(sub_11_n281)
         );
  NAND2_X1 sub_11_U174 ( .A1(sub_11_n305), .A2(sub_11_n92), .ZN(sub_11_n320)
         );
  NAND2_X1 sub_11_U173 ( .A1(sub_11_n314), .A2(sub_11_n100), .ZN(sub_11_n338)
         );
  NOR2_X1 sub_11_U172 ( .A1(sub_11_n147), .A2(sub_11_n403), .ZN(sub_11_n401)
         );
  NOR3_X1 sub_11_U171 ( .A1(sub_11_n315), .A2(sub_11_n93), .A3(sub_11_n384), 
        .ZN(sub_11_n303) );
  INV_X1 sub_11_U170 ( .A(sub_11_n143), .ZN(sub_11_n295) );
  NAND2_X1 sub_11_U169 ( .A1(b[7]), .A2(sub_11_n510), .ZN(sub_11_n136) );
  INV_X1 sub_11_U168 ( .A(a[9]), .ZN(sub_11_n134) );
  INV_X1 sub_11_U167 ( .A(a[9]), .ZN(sub_11_n133) );
  AND2_X1 sub_11_U166 ( .A1(b[5]), .A2(sub_11_n7), .ZN(sub_11_n132) );
  NAND4_X1 sub_11_U165 ( .A1(sub_11_n401), .A2(sub_11_n69), .A3(sub_11_n145), 
        .A4(sub_11_n402), .ZN(sub_11_n217) );
  AND4_X1 sub_11_U164 ( .A1(sub_11_n401), .A2(sub_11_n145), .A3(sub_11_n69), 
        .A4(sub_11_n402), .ZN(sub_11_n130) );
  NAND2_X1 sub_11_U163 ( .A1(b[4]), .A2(sub_11_n505), .ZN(sub_11_n129) );
  NAND2_X1 sub_11_U162 ( .A1(sub_11_n414), .A2(sub_11_n415), .ZN(sub_11_n128)
         );
  AND2_X1 sub_11_U161 ( .A1(sub_11_n131), .A2(sub_11_n49), .ZN(sub_11_n229) );
  INV_X1 sub_11_U160 ( .A(b[7]), .ZN(sub_11_n127) );
  NAND2_X1 sub_11_U159 ( .A1(a[7]), .A2(sub_11_n127), .ZN(sub_11_n126) );
  OAI21_X1 sub_11_U158 ( .B1(sub_11_n303), .B2(sub_11_n295), .A(sub_11_n97), 
        .ZN(sub_11_n301) );
  CLKBUF_X1 sub_11_U157 ( .A(sub_11_n301), .Z(sub_11_n125) );
  NAND2_X1 sub_11_U156 ( .A1(b[14]), .A2(sub_11_n456), .ZN(sub_11_n408) );
  INV_X1 sub_11_U155 ( .A(a[14]), .ZN(sub_11_n124) );
  NAND2_X1 sub_11_U154 ( .A1(b[14]), .A2(sub_11_n456), .ZN(sub_11_n123) );
  NAND2_X1 sub_11_U153 ( .A1(b[14]), .A2(sub_11_n124), .ZN(sub_11_n122) );
  INV_X1 sub_11_U152 ( .A(a[7]), .ZN(sub_11_n120) );
  INV_X1 sub_11_U151 ( .A(a[1]), .ZN(sub_11_n119) );
  INV_X1 sub_11_U150 ( .A(a[10]), .ZN(sub_11_n118) );
  NAND2_X1 sub_11_U149 ( .A1(b[10]), .A2(sub_11_n487), .ZN(sub_11_n117) );
  NAND3_X1 sub_11_U148 ( .A1(sub_11_n462), .A2(sub_11_n461), .A3(sub_11_n51), 
        .ZN(sub_11_n452) );
  AND2_X1 sub_11_U147 ( .A1(sub_11_n495), .A2(b[2]), .ZN(sub_11_n116) );
  NAND2_X1 sub_11_U146 ( .A1(a[22]), .A2(sub_11_n329), .ZN(sub_11_n115) );
  NAND2_X1 sub_11_U145 ( .A1(b[22]), .A2(sub_11_n85), .ZN(sub_11_n114) );
  NAND2_X1 sub_11_U144 ( .A1(a[24]), .A2(sub_11_n95), .ZN(sub_11_n113) );
  AND2_X1 sub_11_U143 ( .A1(sub_11_n99), .A2(sub_11_n259), .ZN(sub_11_n112) );
  NAND2_X1 sub_11_U142 ( .A1(b[29]), .A2(sub_11_n9), .ZN(sub_11_n208) );
  NAND2_X1 sub_11_U141 ( .A1(b[29]), .A2(sub_11_n254), .ZN(sub_11_n111) );
  NAND2_X1 sub_11_U140 ( .A1(b[29]), .A2(sub_11_n254), .ZN(sub_11_n110) );
  NAND2_X1 sub_11_U139 ( .A1(a[20]), .A2(sub_11_n346), .ZN(sub_11_n109) );
  NAND2_X1 sub_11_U138 ( .A1(b[28]), .A2(sub_11_n265), .ZN(sub_11_n239) );
  NAND2_X1 sub_11_U137 ( .A1(b[28]), .A2(sub_11_n265), .ZN(sub_11_n108) );
  NAND2_X1 sub_11_U136 ( .A1(b[28]), .A2(sub_11_n265), .ZN(sub_11_n107) );
  AND2_X1 sub_11_U135 ( .A1(sub_11_n41), .A2(sub_11_n49), .ZN(sub_11_n106) );
  NAND2_X1 sub_11_U134 ( .A1(a[25]), .A2(sub_11_n271), .ZN(sub_11_n105) );
  OAI211_X1 sub_11_U133 ( .C1(sub_11_n347), .C2(sub_11_n348), .A(sub_11_n349), 
        .B(sub_11_n350), .ZN(sub_11_n104) );
  OAI211_X1 sub_11_U132 ( .C1(sub_11_n347), .C2(sub_11_n348), .A(sub_11_n349), 
        .B(sub_11_n350), .ZN(sub_11_n103) );
  NOR2_X1 sub_11_U131 ( .A1(sub_11_n292), .A2(sub_11_n102), .ZN(sub_11_n287)
         );
  AND2_X1 sub_11_U130 ( .A1(sub_11_n290), .A2(sub_11_n291), .ZN(sub_11_n102)
         );
  NAND2_X1 sub_11_U129 ( .A1(a[18]), .A2(sub_11_n6), .ZN(sub_11_n101) );
  NAND2_X1 sub_11_U128 ( .A1(a[21]), .A2(sub_11_n339), .ZN(sub_11_n100) );
  AND2_X1 sub_11_U127 ( .A1(sub_11_n276), .A2(sub_11_n275), .ZN(sub_11_n131)
         );
  CLKBUF_X1 sub_11_U126 ( .A(sub_11_n258), .Z(sub_11_n99) );
  INV_X1 sub_11_U125 ( .A(sub_11_n174), .ZN(sub_11_n98) );
  CLKBUF_X1 sub_11_U124 ( .A(sub_11_n34), .Z(sub_11_n97) );
  OR2_X1 sub_11_U123 ( .A1(sub_11_n279), .A2(a[26]), .ZN(sub_11_n272) );
  OR2_X1 sub_11_U122 ( .A1(sub_11_n91), .A2(a[26]), .ZN(sub_11_n96) );
  CLKBUF_X1 sub_11_U121 ( .A(sub_11_n278), .Z(sub_11_n95) );
  INV_X1 sub_11_U120 ( .A(b[22]), .ZN(sub_11_n94) );
  AND3_X1 sub_11_U119 ( .A1(sub_11_n90), .A2(sub_11_n388), .A3(sub_11_n389), 
        .ZN(sub_11_n93) );
  NAND2_X1 sub_11_U118 ( .A1(b[23]), .A2(sub_11_n321), .ZN(sub_11_n92) );
  AND2_X1 sub_11_U117 ( .A1(b[6]), .A2(sub_11_n75), .ZN(sub_11_n121) );
  CLKBUF_X1 sub_11_U116 ( .A(sub_11_n47), .Z(sub_11_n91) );
  NAND3_X1 sub_11_U115 ( .A1(sub_11_n440), .A2(sub_11_n439), .A3(sub_11_n63), 
        .ZN(sub_11_n90) );
  INV_X1 sub_11_U114 ( .A(sub_11_n112), .ZN(sub_11_n89) );
  NAND2_X1 sub_11_U113 ( .A1(a[6]), .A2(sub_11_n72), .ZN(sub_11_n88) );
  INV_X1 sub_11_U112 ( .A(a[5]), .ZN(sub_11_n86) );
  INV_X1 sub_11_U111 ( .A(a[22]), .ZN(sub_11_n85) );
  NAND2_X1 sub_11_U110 ( .A1(b[3]), .A2(sub_11_n500), .ZN(sub_11_n84) );
  BUF_X1 sub_11_U109 ( .A(sub_11_n54), .Z(sub_11_n83) );
  NAND4_X1 sub_11_U108 ( .A1(sub_11_n180), .A2(sub_11_n504), .A3(sub_11_n503), 
        .A4(sub_11_n166), .ZN(sub_11_n162) );
  INV_X1 sub_11_U107 ( .A(sub_11_n69), .ZN(sub_11_n82) );
  CLKBUF_X1 sub_11_U106 ( .A(sub_11_n287), .Z(sub_11_n81) );
  INV_X1 sub_11_U105 ( .A(a[26]), .ZN(sub_11_n80) );
  INV_X1 sub_11_U104 ( .A(a[24]), .ZN(sub_11_n79) );
  AOI22_X1 sub_11_U103 ( .A1(sub_11_n79), .A2(b[24]), .B1(sub_11_n80), .B2(
        b[26]), .ZN(sub_11_n275) );
  NAND2_X1 sub_11_U102 ( .A1(sub_11_n74), .A2(a[20]), .ZN(sub_11_n311) );
  NAND2_X1 sub_11_U101 ( .A1(sub_11_n94), .A2(a[22]), .ZN(sub_11_n310) );
  INV_X1 sub_11_U100 ( .A(a[25]), .ZN(sub_11_n78) );
  INV_X1 sub_11_U99 ( .A(a[27]), .ZN(sub_11_n77) );
  AOI22_X1 sub_11_U98 ( .A1(sub_11_n77), .A2(b[27]), .B1(sub_11_n1), .B2(b[25]), .ZN(sub_11_n276) );
  NAND2_X1 sub_11_U97 ( .A1(sub_11_n513), .A2(a[4]), .ZN(sub_11_n176) );
  INV_X1 sub_11_U96 ( .A(a[2]), .ZN(sub_11_n76) );
  AND2_X1 sub_11_U95 ( .A1(sub_11_n76), .A2(b[2]), .ZN(sub_11_n443) );
  NAND2_X1 sub_11_U94 ( .A1(sub_11_n512), .A2(a[6]), .ZN(sub_11_n169) );
  NAND2_X1 sub_11_U93 ( .A1(sub_11_n30), .A2(a[7]), .ZN(sub_11_n167) );
  INV_X1 sub_11_U92 ( .A(a[6]), .ZN(sub_11_n75) );
  INV_X1 sub_11_U91 ( .A(b[20]), .ZN(sub_11_n74) );
  INV_X1 sub_11_U90 ( .A(b[6]), .ZN(sub_11_n73) );
  INV_X1 sub_11_U89 ( .A(b[6]), .ZN(sub_11_n72) );
  AND2_X1 sub_11_U88 ( .A1(sub_11_n488), .A2(sub_11_n152), .ZN(sub_11_n71) );
  NAND2_X1 sub_11_U87 ( .A1(sub_11_n340), .A2(b[21]), .ZN(sub_11_n314) );
  AND4_X1 sub_11_U86 ( .A1(sub_11_n313), .A2(sub_11_n314), .A3(sub_11_n114), 
        .A4(sub_11_n92), .ZN(sub_11_n70) );
  INV_X1 sub_11_U85 ( .A(sub_11_n135), .ZN(sub_11_n68) );
  NAND2_X1 sub_11_U84 ( .A1(b[15]), .A2(sub_11_n448), .ZN(sub_11_n67) );
  INV_X1 sub_11_U83 ( .A(a[8]), .ZN(sub_11_n66) );
  INV_X1 sub_11_U82 ( .A(a[8]), .ZN(sub_11_n65) );
  INV_X1 sub_11_U81 ( .A(a[13]), .ZN(sub_11_n64) );
  AND2_X1 sub_11_U80 ( .A1(sub_11_n190), .A2(sub_11_n501), .ZN(sub_11_n63) );
  INV_X1 sub_11_U79 ( .A(b[2]), .ZN(sub_11_n62) );
  INV_X1 sub_11_U78 ( .A(b[2]), .ZN(sub_11_n61) );
  NAND4_X1 sub_11_U77 ( .A1(sub_11_n508), .A2(sub_11_n507), .A3(sub_11_n509), 
        .A4(sub_11_n136), .ZN(sub_11_n158) );
  NAND4_X1 sub_11_U76 ( .A1(sub_11_n507), .A2(sub_11_n508), .A3(sub_11_n509), 
        .A4(sub_11_n136), .ZN(sub_11_n60) );
  AND4_X2 sub_11_U75 ( .A1(sub_11_n180), .A2(sub_11_n504), .A3(sub_11_n503), 
        .A4(sub_11_n166), .ZN(sub_11_n69) );
  AND2_X1 sub_11_U74 ( .A1(sub_11_n404), .A2(sub_11_n402), .ZN(sub_11_n492) );
  AND2_X1 sub_11_U73 ( .A1(sub_11_n163), .A2(sub_11_n18), .ZN(sub_11_n59) );
  INV_X1 sub_11_U72 ( .A(a[0]), .ZN(sub_11_n58) );
  BUF_X1 sub_11_U71 ( .A(sub_11_n473), .Z(sub_11_n56) );
  NAND2_X1 sub_11_U70 ( .A1(b[10]), .A2(sub_11_n487), .ZN(sub_11_n55) );
  AND2_X2 sub_11_U69 ( .A1(b[3]), .A2(sub_11_n500), .ZN(sub_11_n54) );
  INV_X1 sub_11_U68 ( .A(b[1]), .ZN(sub_11_n53) );
  BUF_X1 sub_11_U67 ( .A(sub_11_n88), .Z(sub_11_n52) );
  AND2_X1 sub_11_U66 ( .A1(sub_11_n29), .A2(sub_11_n424), .ZN(sub_11_n51) );
  AND2_X1 sub_11_U65 ( .A1(sub_11_n273), .A2(sub_11_n274), .ZN(sub_11_n50) );
  AND2_X1 sub_11_U64 ( .A1(sub_11_n239), .A2(sub_11_n208), .ZN(sub_11_n49) );
  NAND2_X1 sub_11_U63 ( .A1(b[11]), .A2(sub_11_n480), .ZN(sub_11_n385) );
  NAND3_X1 sub_11_U62 ( .A1(sub_11_n491), .A2(sub_11_n492), .A3(sub_11_n245), 
        .ZN(sub_11_n183) );
  CLKBUF_X1 sub_11_U61 ( .A(sub_11_n304), .Z(sub_11_n48) );
  INV_X1 sub_11_U60 ( .A(b[26]), .ZN(sub_11_n47) );
  INV_X1 sub_11_U59 ( .A(b[26]), .ZN(sub_11_n46) );
  NAND2_X1 sub_11_U58 ( .A1(sub_11_n10), .A2(sub_11_n2), .ZN(sub_11_n45) );
  AOI22_X1 sub_11_U57 ( .A1(sub_11_n77), .A2(b[27]), .B1(sub_11_n78), .B2(
        b[25]), .ZN(sub_11_n44) );
  NAND2_X1 sub_11_U56 ( .A1(sub_11_n346), .A2(a[20]), .ZN(sub_11_n43) );
  INV_X1 sub_11_U55 ( .A(a[23]), .ZN(sub_11_n42) );
  CLKBUF_X1 sub_11_U54 ( .A(sub_11_n15), .Z(sub_11_n41) );
  NOR2_X1 sub_11_U53 ( .A1(sub_11_n336), .A2(sub_11_n235), .ZN(sub_11_n143) );
  INV_X1 sub_11_U52 ( .A(sub_11_n295), .ZN(sub_11_n40) );
  NAND2_X1 sub_11_U51 ( .A1(sub_11_n513), .A2(a[4]), .ZN(sub_11_n39) );
  NAND2_X1 sub_11_U50 ( .A1(a[7]), .A2(sub_11_n31), .ZN(sub_11_n38) );
  NAND2_X1 sub_11_U49 ( .A1(sub_11_n515), .A2(a[7]), .ZN(sub_11_n37) );
  NAND2_X1 sub_11_U48 ( .A1(sub_11_n48), .A2(sub_11_n305), .ZN(sub_11_n36) );
  AND2_X1 sub_11_U47 ( .A1(sub_11_n70), .A2(sub_11_n240), .ZN(sub_11_n35) );
  AOI21_X1 sub_11_U46 ( .B1(sub_11_n35), .B2(sub_11_n104), .A(sub_11_n36), 
        .ZN(sub_11_n34) );
  NAND2_X1 sub_11_U45 ( .A1(sub_11_n514), .A2(a[5]), .ZN(sub_11_n33) );
  AND2_X1 sub_11_U44 ( .A1(b[18]), .A2(sub_11_n378), .ZN(sub_11_n32) );
  AND2_X2 sub_11_U43 ( .A1(sub_11_n352), .A2(sub_11_n351), .ZN(sub_11_n350) );
  INV_X1 sub_11_U42 ( .A(b[7]), .ZN(sub_11_n31) );
  INV_X1 sub_11_U41 ( .A(b[7]), .ZN(sub_11_n30) );
  AND4_X1 sub_11_U40 ( .A1(sub_11_n477), .A2(sub_11_n478), .A3(sub_11_n479), 
        .A4(sub_11_n418), .ZN(sub_11_n29) );
  NAND2_X1 sub_11_U39 ( .A1(sub_11_n468), .A2(b[12]), .ZN(sub_11_n424) );
  NAND2_X1 sub_11_U38 ( .A1(sub_11_n468), .A2(b[12]), .ZN(sub_11_n28) );
  CLKBUF_X1 sub_11_U37 ( .A(sub_11_n411), .Z(sub_11_n27) );
  NAND2_X1 sub_11_U36 ( .A1(a[10]), .A2(sub_11_n486), .ZN(sub_11_n26) );
  NAND2_X2 sub_11_U35 ( .A1(sub_11_n64), .A2(b[13]), .ZN(sub_11_n413) );
  AND2_X1 sub_11_U34 ( .A1(b[6]), .A2(sub_11_n425), .ZN(sub_11_n25) );
  AND3_X1 sub_11_U33 ( .A1(sub_11_n492), .A2(sub_11_n245), .A3(sub_11_n491), 
        .ZN(sub_11_n24) );
  NAND2_X2 sub_11_U32 ( .A1(sub_11_n428), .A2(b[5]), .ZN(sub_11_n503) );
  INV_X1 sub_11_U31 ( .A(sub_11_n24), .ZN(sub_11_n23) );
  NAND2_X1 sub_11_U30 ( .A1(sub_11_n21), .A2(sub_11_n494), .ZN(sub_11_n22) );
  AOI21_X1 sub_11_U29 ( .B1(sub_11_n496), .B2(sub_11_n497), .A(sub_11_n498), 
        .ZN(sub_11_n493) );
  AOI21_X1 sub_11_U28 ( .B1(sub_11_n496), .B2(sub_11_n497), .A(sub_11_n498), 
        .ZN(sub_11_n21) );
  AND2_X1 sub_11_U27 ( .A1(sub_11_n179), .A2(sub_11_n129), .ZN(sub_11_n20) );
  INV_X1 sub_11_U26 ( .A(sub_11_n18), .ZN(sub_11_n19) );
  BUF_X1 sub_11_U25 ( .A(sub_11_n69), .Z(sub_11_n18) );
  CLKBUF_X1 sub_11_U24 ( .A(sub_11_n464), .Z(sub_11_n57) );
  NAND2_X1 sub_11_U23 ( .A1(sub_11_n216), .A2(sub_11_n67), .ZN(sub_11_n17) );
  XNOR2_X1 sub_11_U22 ( .A(sub_11_n447), .B(sub_11_n17), .ZN(diff[15]) );
  AOI22_X1 sub_11_U21 ( .A1(sub_11_n79), .A2(b[24]), .B1(sub_11_n80), .B2(
        b[26]), .ZN(sub_11_n16) );
  AND2_X1 sub_11_U20 ( .A1(sub_11_n16), .A2(sub_11_n276), .ZN(sub_11_n15) );
  CLKBUF_X1 sub_11_U19 ( .A(sub_11_n200), .Z(sub_11_n87) );
  AND2_X1 sub_11_U18 ( .A1(sub_11_n330), .A2(b[22]), .ZN(sub_11_n14) );
  AND2_X1 sub_11_U17 ( .A1(b[23]), .A2(sub_11_n42), .ZN(sub_11_n13) );
  NOR2_X1 sub_11_U16 ( .A1(sub_11_n13), .A2(sub_11_n14), .ZN(sub_11_n306) );
  INV_X1 sub_11_U15 ( .A(b[21]), .ZN(sub_11_n12) );
  CLKBUF_X1 sub_11_U14 ( .A(sub_11_n261), .Z(sub_11_n11) );
  BUF_X1 sub_11_U13 ( .A(sub_11_n3), .Z(sub_11_n10) );
  INV_X1 sub_11_U12 ( .A(a[29]), .ZN(sub_11_n9) );
  BUF_X1 sub_11_U11 ( .A(sub_11_n230), .Z(sub_11_n135) );
  NAND2_X1 sub_11_U10 ( .A1(sub_11_n2), .A2(sub_11_n4), .ZN(sub_11_n8) );
  INV_X1 sub_11_U9 ( .A(a[5]), .ZN(sub_11_n7) );
  INV_X1 sub_11_U8 ( .A(b[18]), .ZN(sub_11_n6) );
  INV_X1 sub_11_U7 ( .A(b[18]), .ZN(sub_11_n5) );
  INV_X1 sub_11_U6 ( .A(b[22]), .ZN(sub_11_n4) );
  INV_X1 sub_11_U5 ( .A(b[22]), .ZN(sub_11_n3) );
  INV_X1 sub_11_U4 ( .A(sub_11_n85), .ZN(sub_11_n2) );
  INV_X1 sub_11_U3 ( .A(a[25]), .ZN(sub_11_n1) );
endmodule

