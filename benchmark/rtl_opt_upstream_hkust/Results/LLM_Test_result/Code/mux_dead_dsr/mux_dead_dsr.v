module mux_dead_dsr(
    input x,
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result
);

always @(*) begin
    result = x ? (a & b) : (a | b);
end

endmodule