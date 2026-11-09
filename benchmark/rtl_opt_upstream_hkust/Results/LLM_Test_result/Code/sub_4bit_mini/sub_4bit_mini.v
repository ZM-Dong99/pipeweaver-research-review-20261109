module sub_4bit_mini (
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output overflow
);

    wire [3:0] difference;
    wire borrow_out;
    wire [4:0] a_ext, b_ext;
    wire [4:0] sum_ext;
    wire [3:0] sum_result;
    wire cout;

    assign a_ext = {1'b0, a};
    assign b_ext = {1'b0, b};

    // Using two's complement addition for subtraction
    assign {cout, sum_ext} = a_ext + (~b_ext + 1'b1);

    assign difference = sum_ext[3:0];

    // Overflow detection for 4-bit signed subtraction using 5-bit addition
    // Overflow occurs if cout != sum_ext[4]
    assign overflow = cout ^ sum_ext[4];

endmodule