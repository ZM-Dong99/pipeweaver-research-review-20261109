module register_ds
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

reg [31:0] data [31:1];
reg [31:0] read_data1_reg, read_data2_reg;

// Use blocking assignments for combinational logic
always @(*) begin
    read_data1_reg = (read_addr1 == 0) ? 32'h0 :
                    (reg_write && (write_addr == read_addr1)) ? write_data :
                    data[read_addr1];
    
    read_data2_reg = (read_addr2 == 0) ? 32'h0 :
                    (reg_write && (write_addr == read_addr2)) ? write_data :
                    data[read_addr2];
end

assign read_data1 = read_data1_reg;
assign read_data2 = read_data2_reg;

// Initialize only the stack pointer ($29) and keep others uninitialized
// Synthesis tools will optimize this to power-up values
initial begin
    data[29] = 32'h000007fc;
end

// Simplified reset and write logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        data[29] <= 32'h000007fc;
    end
    else if (reg_write && write_addr != 0) begin
        data[write_addr] <= write_data;
    end
end

endmodule