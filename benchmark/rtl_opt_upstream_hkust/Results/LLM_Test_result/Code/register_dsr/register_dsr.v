module register_dsr
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

parameter SP_INIT = 32'h000007fc;
reg [31:0] data [31:1];

assign read_data1 = (read_addr1 == 0) ? 32'h0 :
                    (reg_write && write_addr == read_addr1) ? write_data : data[read_addr1];

assign read_data2 = (read_addr2 == 0) ? 32'h0 :
                    (reg_write && write_addr == read_addr2) ? write_data : data[read_addr2];

integer i;

initial begin
    for (i = 1; i < 32; i = i +1) begin
        data[i] <= (i == 29) ? SP_INIT : 0;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 1; i < 32; i = i +1)
            data[i] <= (i == 29) ? SP_INIT : 0;
    end
    else if (reg_write && write_addr != 0)
        data[write_addr] <= write_data;
end

endmodule