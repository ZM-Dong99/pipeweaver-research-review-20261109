module mux_dead_gpt(
    input x,
    input sel,
    input [7:0] a,        // 8-bit input operand A
    input [7:0] b,        // 8-bit input operand B
    output reg [7:0] result  // Output result
);

// Optimize the logic by combining AND and OR operations into one logic block
always @(*) begin
    if (x) begin
        result = a & b;  // Directly perform AND operation
    end else begin
        result = a | b;  // Directly perform OR operation
    end
end

endmodule