// Project-authored integration benchmark. STAGES is exactly 2 or 3 in this study.
// Sampled operands and opcode feed a combinational ALU and registered outputs.
// All data and valid registers synchronously reset. Inputs are unconstrained.
module pw_pipeline_alu #(
    parameter WIDTH = 32,
    parameter STAGES = 2
)(
    input wire clk, rst,
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    input wire in_valid,
    output wire [WIDTH-1:0] result,
    output wire out_valid
);
    reg [WIDTH-1:0] operand_a, operand_b;
    reg [2:0] opcode;
    reg input_valid;
    wire [WIDTH-1:0] alu_result;
    wire [WIDTH-1:0] stage_data [0:STAGES-2];
    wire stage_valid [0:STAGES-2];

    always @(posedge clk) begin
        if (rst) begin
            operand_a <= 0;
            operand_b <= 0;
            opcode <= 0;
            input_valid <= 0;
        end else begin
            operand_a <= a;
            operand_b <= b;
            opcode <= Oper;
            input_valid <= in_valid;
        end
    end

    pw_alu #(.WIDTH(WIDTH)) alu (
        .a(operand_a), .b(operand_b), .Oper(opcode), .sum(alu_result)
    );

    genvar index;
    generate
        for (index = 0; index < STAGES-1; index = index+1) begin: output_pipeline
            reg [WIDTH-1:0] data_reg;
            reg valid_reg;
            wire [WIDTH-1:0] next_data;
            wire next_valid;
            if (index == 0) begin: first_stage
                assign next_data = alu_result;
                assign next_valid = input_valid;
            end else begin: following_stage
                assign next_data = stage_data[index-1];
                assign next_valid = stage_valid[index-1];
            end
            always @(posedge clk) begin
                if (rst) begin
                    data_reg <= 0;
                    valid_reg <= 0;
                end else begin
                    data_reg <= next_data;
                    valid_reg <= next_valid;
                end
            end
            assign stage_data[index] = data_reg;
            assign stage_valid[index] = valid_reg;
        end
    endgenerate
    assign result = stage_data[STAGES-2];
    assign out_valid = stage_valid[STAGES-2];
endmodule
