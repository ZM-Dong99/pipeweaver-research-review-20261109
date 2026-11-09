`timescale 1ns / 1ps

// Register file module for a pipelined CPU

module register_ref (
    input wire clk,             // Clock input
    input wire reset,           // Reset input (active high)
    input wire [4:0] read_addr1, // Address for first read port (register index)
    input wire [4:0] read_addr2, // Address for second read port (register index)
    input wire [4:0] write_addr, // Address for write port (register index)
    input wire [31:0] write_data, // Data to write to register
    input wire reg_write,       // Write enable signal
    output wire [31:0] read_data1, // Data read from first port - 
    output wire [31:0] read_data2  // Data read from second port - 
);

    reg [31:0] registers [0:31];  // 32-register array, including zero register

    // Read port 1: return 0 for $0, forwarded write data if addresses match and not $0, or register value
    assign read_data1 = (read_addr1 == 0) ? 32'h0 :
                       (reg_write && (write_addr == read_addr1) && (write_addr != 0)) ? write_data :
                       registers[read_addr1];

    // Read port 2: return 0 for $0, forwarded write data if addresses match and not $0, or register value
    assign read_data2 = (read_addr2 == 0) ? 32'h0 :
                       (reg_write && (write_addr == read_addr2) && (write_addr != 0)) ? write_data :
                       registers[read_addr2];

    // Initialization of registers: set all to 0, except $sp ($29) to 0x000007fc
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 0;
        end
        registers[29] <= 32'h000007fc;  // Initialize stack pointer ($sp)
    end

    // Reset and write-back logic: clear all registers on reset, set $sp, and handle writes
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;  // Clear all registers
            end
            registers[29] <= 32'h000007fc;  // Reset stack pointer ($sp)
        end
        else if (reg_write && write_addr != 0) begin
            registers[write_addr] <= write_data; // Write to register (except $0)
        end
    end

endmodule