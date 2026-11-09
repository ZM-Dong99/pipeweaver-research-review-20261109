module addr_calcu_mini(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control, // control is late arriving
    output [15:0] count
);

    parameter [7:0] base = 8'b10000000;

    wire [15:0] diff1, diff2;
    wire [15:0] sum1, sum2;

    // Calculate a - (b - c) as a - b + c
    // This can potentially simplify the subtraction and addition chain
    assign diff1 = {8'h00, address} - {8'h00, base} + {8'h00, ptr1};
    assign diff2 = {8'h00, address} - {8'h00, base} + {8'h00, ptr2};

    assign sum1 = diff1 + {8'h00, b};
    assign sum2 = diff2 + {8'h00, b};

    // Use a standard multiplexer for the late arriving control signal
    assign count = control ? sum1 : sum2;

endmodule