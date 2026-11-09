`timescale 1ns / 1ps

// Register file module for a pipelined CPU
// Stores 31 general-purpose registers (32-bit), with $0 hardwired to 0
// Supports two simultaneous reads and one write with write forwarding
module register
(
    input wire clk,             // Clock input
    input wire reset,           // Reset input (active high)
    input wire [4:0] read_addr1, // Address for first read port (register index)
    input wire [4:0] read_addr2, // Address for second read port (register index)
    input wire [4:0] write_addr, // Address for write port (register index)
    input wire [31:0] write_data, // Data to write to register
    input wire reg_write,       // Write enable signal
    output wire [31:0] read_data1, // Data read from first port
    output wire [31:0] read_data2 // Data read from second port
);

reg [31:0] data [31:1];         // Register array (31 registers, $1 to $31)

// Read port 1: return 0 for $0, forwarded write data if addresses match, or register value
assign read_data1 =
            read_addr1 == 0 ? 32'h0 :
            reg_write && write_addr == read_addr1 ? write_data :
            data[read_addr1];

// Read port 2: return 0 for $0, forwarded write data if addresses match, or register value
assign read_data2 =
            read_addr2 == 0 ? 32'h0 :
            reg_write && write_addr == read_addr2 ? write_data :
            data[read_addr2];

integer j;
// Initialize registers: set $sp ($29) to 0x000007fc, others to 0
initial begin
    for (j = 1; j < 29; j = j + 1) begin
        data[j] <= 0;
    end
    data[29] <= 32'h000007fc;   // Initialize stack pointer ($sp)
    for (j = 30; j < 32; j = j + 1) begin
        data[j] <= 0;
    end
end

integer i;
// Handle register writes and reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 1; i < 29; i = i + 1) begin
            data[i] <= 0;       // Clear registers $1 to $28
        end
        data[29] <= 32'h000007fc; // Reset stack pointer ($sp)
        for (i = 30; i < 32; i = i + 1) begin
            data[i] <= 0;       // Clear registers $30 to $31
        end
    end
    else begin
        if (reg_write && write_addr != 0) begin
            data[write_addr] <= write_data; // Write to register (except $0)
        end
    end
end

endmodule