module pw_alu_fast_add #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire cin,
    output wire [WIDTH-1:0] sum
);
    localparam BLOCKS = (WIDTH+3)/4;
    localparam PAD_WIDTH = 4*BLOCKS;
    localparam LEVELS = $clog2(BLOCKS);
    wire [PAD_WIDTH-1:0] p, g;
    wire [BLOCKS-1:0] pp [0:LEVELS];
    wire [BLOCKS-1:0] gg [0:LEVELS];
    wire [BLOCKS-1:0] bc;
    genvar i, k, l;
    generate
        for (i=0; i<PAD_WIDTH; i=i+1) begin: bit_terms
            if (i<WIDTH) begin: real_bit
                assign p[i] = a[i] ^ b[i];
                assign g[i] = a[i] & b[i];
            end else begin: padding
                assign p[i] = 1'b0;
                assign g[i] = 1'b0;
            end
        end
        for (k=0; k<BLOCKS; k=k+1) begin: groups
            assign pp[0][k] = p[4*k+3] & p[4*k+2] & p[4*k+1] & p[4*k];
            assign gg[0][k] = g[4*k+3]
                | (p[4*k+3] & g[4*k+2])
                | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
        for (l=0; l<LEVELS; l=l+1) begin: prefix_levels
            for (k=0; k<BLOCKS; k=k+1) begin: prefix_nodes
                if (k >= (1<<l)) begin: combine
                    assign pp[l+1][k] = pp[l][k] & pp[l][k-(1<<l)];
                    assign gg[l+1][k] = gg[l][k]
                        | (pp[l][k] & gg[l][k-(1<<l)]);
                end else begin: pass
                    assign pp[l+1][k] = pp[l][k];
                    assign gg[l+1][k] = gg[l][k];
                end
            end
        end
        for (k=0; k<BLOCKS; k=k+1) begin: block_carries
            if (k==0) begin: first
                assign bc[k] = cin;
            end else begin: later
                assign bc[k] = gg[LEVELS][k-1] | (pp[LEVELS][k-1] & cin);
            end
        end
        for (i=0; i<WIDTH; i=i+1) begin: sum_bits
            wire c;
            if ((i%4)==0) begin: c0
                assign c = bc[i/4];
            end else if ((i%4)==1) begin: c1
                assign c = g[i-1] | (p[i-1] & bc[i/4]);
            end else if ((i%4)==2) begin: c2
                assign c = g[i-1] | (p[i-1] & g[i-2])
                    | (p[i-1] & p[i-2] & bc[i/4]);
            end else begin: c3
                assign c = g[i-1] | (p[i-1] & g[i-2])
                    | (p[i-1] & p[i-2] & g[i-3])
                    | (p[i-1] & p[i-2] & p[i-3] & bc[i/4]);
            end
            assign sum[i] = p[i] ^ c;
        end
    endgenerate
endmodule

module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire add_sel = (Oper == 3'b000);
    wire ab_sel = (Oper == 3'b001);
    wire ba_sel = (Oper == 3'b010);
    wire or_sel = (Oper == 3'b011);
    wire and_sel = (Oper == 3'b100);
    wire xor_sel = (Oper == 3'b101);
    wire xnor_sel = (Oper == 3'b110);
    wire arith_sel = add_sel | ab_sel | ba_sel;
    wire [WIDTH-1:0] aa = a ^ {WIDTH{ba_sel}};
    wire [WIDTH-1:0] bb = b ^ {WIDTH{ab_sel}};
    wire [WIDTH-1:0] arithmetic_sum;
    pw_alu_fast_add #(.WIDTH(WIDTH)) arithmetic (
        .a(aa), .b(bb), .cin(ab_sel | ba_sel), .sum(arithmetic_sum)
    );
    always @* begin
        sum = (arithmetic_sum & {WIDTH{arith_sel}})
            | ((a | b) & {WIDTH{or_sel}})
            | ((a & b) & {WIDTH{and_sel}})
            | ((a ^ b) & {WIDTH{xor_sel}})
            | ((a ~^ b) & {WIDTH{xnor_sel}});
    end
endmodule

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
        for (index=0; index<STAGES-1; index=index+1) begin: output_pipeline
            reg [WIDTH-1:0] data_reg;
            reg valid_reg;
            wire [WIDTH-1:0] next_data;
            wire next_valid;
            if (index==0) begin: first_stage
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
