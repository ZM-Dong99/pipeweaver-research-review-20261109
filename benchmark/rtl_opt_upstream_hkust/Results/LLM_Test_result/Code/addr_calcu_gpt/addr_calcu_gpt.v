module addr_calcu_gpt(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control, // control is late arriving
    output [15:0] count
);

    parameter [7:0] base = 8'b10000000;

    wire [7:0] offset1 = base - ptr1;
    wire [7:0] offset2 = base - ptr2;
    wire [15:0] addr1 = {8'h00, address} - {8'h00, offset1};
    wire [15:0] addr2 = {8'h00, address} - {8'h00, offset2};
    wire [15:0] count1 = addr1 + {8'h00, b};
    wire [15:0] count2 = addr2 + {8'h00, b};
    assign count = control ? count1 : count2;

endmodule