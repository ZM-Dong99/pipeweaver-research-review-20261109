module addr_calcu_ds(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);

    parameter [7:0] base = 8'b10000000;

    wire [7:0] offset = base - (control ? ptr1 : ptr2);
    wire [15:0] addr = address - {8'h00, offset};
    assign count = addr + b;

endmodule