`timescale 1ns / 1ps

// Register file module for a pipelined CPU
// Stores 31 general-purpose registers (32-bit), with $0 hardwired to 0
// Supports two simultaneous reads and one write with write forwarding
module register_mini
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

// Read port 1: return 0 for $0, forwarded write data if addresses match and write is active, or register value
assign read_data1 =
            (read_addr1 == 5'd0) ? 32'h0 :
            (reg_write && (write_addr == read_addr1)) ? write_data :
            data[read_addr1];

// Read port 2: return 0 for $0, forwarded write data if addresses match and write is active, or register value
assign read_data2 =
            (read_addr2 == 5'd0) ? 32'h0 :
            (reg_write && (write_addr == read_addr2)) ? write_data :
            data[read_addr2];

// Handle register writes and reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        integer i;
        for (i = 1; i < 32; i = i + 1) begin
            data[i] <= (i == 29) ? 32'h000007fc : 32'h0; // Initialize $sp ($29) and clear others
        end
    end
    else begin
        if (reg_write && (write_addr != 5'd0)) begin
            data[write_addr] <= write_data; // Write to register (except $0)
        end
    end
end

// Removed initial block as it's redundant with the reset logic

endmodule