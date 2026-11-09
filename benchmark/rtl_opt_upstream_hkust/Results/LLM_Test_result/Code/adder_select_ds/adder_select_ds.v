module adder_select_ds(
    input wire s,
    input wire [31:0] A, B, C, D,
    output wire [32:0] Z
);

assign Z = s ? (A + B) : (C + D);

endmodule