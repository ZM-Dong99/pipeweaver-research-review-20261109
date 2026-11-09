module gray_mini (
    input wire clk,
    input wire rst_n,
    input wire [3:0] cmd,
    output reg [7:0] out
);

reg [3:0] state;
reg [3:0] next_state;

// State transition logic
always @(*) begin
    case (state)
        4'b0000: next_state = (cmd[0])       ? 4'b0001 : 4'b1100; // S0 to S1 or S8
        4'b0001: next_state = (cmd[1:0] == 2'b11) ? 4'b0011 : 4'b0000; // S1 to S2 or S0
        4'b0011: next_state = 4'b0010;                               // S2 to S3
        4'b0010: next_state = (cmd[2])       ? 4'b0110 : 4'b0001; // S3 to S4 or S1
        4'b0110: next_state = (cmd[3])       ? 4'b0111 : 4'b1010; // S4 to S5 or S12
        4'b0111: next_state = 4'b0101;                               // S5 to S6
        4'b0101: next_state = (|cmd)         ? 4'b0100 : 4'b0110; // S6 to S7 or S4
        4'b0100: next_state = 4'b0000;                               // S7 to S0
        4'b1100: next_state = (cmd[3:2] == 2'b01) ? 4'b1101 : 4'b1000; // S8 to S9 or S15
        4'b1101: next_state = 4'b1111;                               // S9 to S10
        4'b1111: next_state = (cmd[1])       ? 4'b1110 : 4'b1101; // S10 to S11 or S9
        4'b1110: next_state = 4'b1010;                               // S11 to S12
        4'b1010: next_state = (cmd[0]^cmd[1]) ? 4'b1011 : 4'b1001; // S12 to S13 or S14
        4'b1011: next_state = 4'b0000;                               // S13 to S0
        4'b1001: next_state = 4'b1000;                               // S14 to S15
        4'b1000: next_state = 4'b0000;                               // S15 to S0
        default: next_state = 4'b0000;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        4'b0000: out = 8'b0000_0001; // S0
        4'b0001: out = 8'b0000_0010; // S1
        4'b0011: out = 8'b0000_0100; // S2
        4'b0010: out = 8'b0000_1000; // S3
        4'b0110: out = 8'b0001_0000; // S4
        4'b0111: out = 8'b0010_0000; // S5
        4'b0101: out = 8'b0100_0000; // S6
        4'b0100: out = 8'b1000_0000; // S7
        4'b1100: out = 8'b0000_0010; // S8 (shifted 1)
        4'b1101: out = 8'b0000_0100; // S9 (shifted 2)
        4'b1111: out = 8'b0000_1000; // S10 (shifted 3)
        4'b1110: out = 8'b0001_0000; // S11 (shifted 4)
        4'b1010: out = 8'b0010_0000; // S12 (shifted 5)
        4'b1011: out = 8'b0100_0000; // S13 (shifted 6)
        4'b1001: out = 8'b1000_0000; // S14 (shifted 7)
        4'b1000: out = 8'b0000_0001; // S15
        default: out = 8'b0000_0000;
    endcase
end

// State register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 4'b0000; // S0
    end else begin
        state <= next_state;
    end
end

endmodule