module divider_4bit_ref(
    input wire [3:0] A,
    input wire [1:0] B,
    output wire [3:0] result,
    output wire [3:0] odd
    );

reg [3:0] a_reg;
reg [3:0] b_reg;
reg [7:0] tmp_a;
reg [7:0] tmp_b;
integer i;

always@(*) begin
    a_reg = A;
    b_reg = B;
end

always@(*) begin
    begin
        tmp_a = {4'b0, a_reg};
        tmp_b = {b_reg, 4'b0};
        for(i = 0;i < 4;i = i+1) begin
            tmp_a = tmp_a << 1;
            if (tmp_a >= tmp_b) begin
                tmp_a = tmp_a - tmp_b + 1;
            end
            else begin
                tmp_a = tmp_a;
            end
        end
    end
end

assign odd = tmp_a[7:4];
assign result = tmp_a[3:0];

endmodule