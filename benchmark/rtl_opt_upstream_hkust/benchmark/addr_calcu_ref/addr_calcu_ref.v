module addr_calcu_ref (
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control, // control is late arriving
    output [15:0] count
);

    parameter [7:0] base = 8'b10000000;

    wire [7:0] ptr, offset;
    wire [15:0] addr;

    assign ptr = (control == 1'b1) ? ptr1 : ptr2;
    assign offset = base - ptr;
    assign addr = address - {8'h00, offset};
    assign count = addr + b;

endmodule