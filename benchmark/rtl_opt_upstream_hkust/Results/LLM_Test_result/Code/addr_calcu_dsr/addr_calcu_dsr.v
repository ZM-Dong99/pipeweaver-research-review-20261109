module addr_calcu_dsr(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);

    parameter [7:0] base = 8'b10000000;

    wire [7:0] offset1 = base - ptr1;
    wire [7:0] offset2 = base - ptr2;
    wire [8:0] address_plus_b = address + b;
    wire [8:0] count1 = address_plus_b - offset1;
    wire [8:0] count2 = address_plus_b - offset2;

    assign count = control ? count1 : count2;

endmodule