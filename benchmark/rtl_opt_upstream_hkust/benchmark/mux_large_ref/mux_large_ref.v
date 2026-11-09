module mux_large_ref (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,  // 4 bit select signal
    output reg [7:0] block_out
);

    wire [7:0] intermediate1, intermediate2;
    reg [7:0] mux1_out, mux2_out;

    // first stage
    always @(*) begin
        // mux1: select block_a to block_e
        case (sel[2:0])  // use the low 3 bits of sel
            3'b000: mux1_out = block_a;  // sel = 0000
            3'b001: mux1_out = block_b;  // sel = 0001
            3'b010: mux1_out = block_c;  // sel = 0010
            3'b011: mux1_out = block_d;  // sel = 0011
            3'b100: mux1_out = block_e;  // sel = 0100
            default: mux1_out = block_a; // default select block_a
        endcase
    end

    always @(*) begin
        // mux2: select block_f to block_j
        case (sel[2:0])  // use the low 3 bits of sel
            3'b101: mux2_out = block_f;  // sel = 0101 或 1101
            3'b110: mux2_out = block_g;  // sel = 0110 或 1110
            3'b111: mux2_out = block_h;  // sel = 0111 或 1111
            3'b000: mux2_out = block_i;  // sel = 1000
            3'b001: mux2_out = block_j;  // sel = 1001
            default: mux2_out = block_a; // default select block_a
        endcase
    end

    // second stage
    always @(*) begin
        if (sel[3] == 1'b0) begin
            if (sel[2:0] <= 3'b100) // select range is 0-4 corresponding to a-e
                block_out = mux1_out;
            else // select range is 5-7 corresponding to f-h 
                block_out = mux2_out;
        end else begin
            if (sel[2:0] <= 3'b001) // select range is 8-9 corresponding to i-j
                block_out = mux2_out;
            else // out of range, default select a
                block_out = block_a;
        end
    end

endmodule