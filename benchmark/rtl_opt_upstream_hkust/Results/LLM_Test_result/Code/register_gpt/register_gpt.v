`timescale 1ns / 1ps

// Optimized Register file module for a pipelined CPU
module register_gpt
(
    input wire clk,             
    input wire reset,           
    input wire [4:0] read_addr1, 
    input wire [4:0] read_addr2, 
    input wire [4:0] write_addr, 
    input wire [31:0] write_data, 
    input wire reg_write,       
    output wire [31:0] read_data1, 
    output wire [31:0] read_data2 
);

reg [31:0] data [0:31];         // Register array (32 registers, $0 to $31)

// Read port 1: return 0 for $0, forwarded write data if addresses match, or register value
assign read_data1 = (read_addr1 == 0) ? 32'h0 :
                    (reg_write && write_addr == read_addr1) ? write_data : 
                    data[read_addr1];

// Read port 2: return 0 for $0, forwarded write data if addresses match, or register value
assign read_data2 = (read_addr2 == 0) ? 32'h0 :
                    (reg_write && write_addr == read_addr2) ? write_data : 
                    data[read_addr2];

integer j;
// Initialize registers: set $sp ($29) to 0x000007fc, others to 0
initial begin
    data[0] = 32'h0; // Hardwired $0 to 0
    data[29] = 32'h000007fc; // Initialize stack pointer ($sp)
    for (j = 1; j < 29; j = j + 1) begin
        data[j] = 32'h0; // Set $1 to $28 to 0
    end
    for (j = 30; j < 32; j = j + 1) begin
        data[j] = 32'h0; // Set $30 to $31 to 0
    end
end

// Handle register writes and reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        data[0] <= 32'h0; // Ensure $0 remains 0
        data[29] <= 32'h000007fc; // Reset stack pointer ($sp)
        for (j = 1; j < 29; j = j + 1) begin
            data[j] <= 32'h0; // Clear registers $1 to $28
        end
        for (j = 30; j < 32; j = j + 1) begin
            data[j] <= 32'h0; // Clear registers $30 to $31
        end
    end else if (reg_write && write_addr != 0) begin
        data[write_addr] <= write_data; // Write to register (except $0)
    end
end

endmodule