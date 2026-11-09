module divider_16bit_gpt (
    input wire [15:0] A,      // 16-bit 被除数
    input wire [7:0] B,       // 8-bit 除数
    output reg [15:0] result, // 16-bit 商
    output reg [15:0] odd     // 16-bit 余数
);

reg [31:0] temp;  // 高16位余数，低16位商
integer i;

always @(*) begin
    temp = {16'b0, A};  // 初始化：余数=0，商=被除数
    
    for (i = 0; i < 16; i = i + 1) begin
        temp = temp << 1;  // 左移1位
        
        // 根据余数符号选择加减（B扩展为16-bit）
        temp[31:16] = temp[31] ? (temp[31:16] + {8'b0, B}) : (temp[31:16] - {8'b0, B});
        
        // 更新商（当前位=余数符号取反）
        temp[0] = ~temp[31];
    end
    
    // 最终调整：若余数为负，加回除数
    if (temp[31]) begin
        temp[31:16] = temp[31:16] + {8'b0, B};
    end
    
    result = temp[15:0];  // 商
    odd = temp[31:16];    // 余数
end

endmodule