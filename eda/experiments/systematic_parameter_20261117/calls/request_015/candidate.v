module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] p;
    wire [WIDTH-1:0] ca, cab, cba;
    wire [WIDTH-1:0] add_result, ab_result, ba_result;
    wire s0, s1, s2, s3, s4, s5, s6;

    assign p = a ^ b;
    pw_alu_carry_tree #(.W(WIDTH)) add_tree (
        .p(p), .g(a & b), .c(ca)
    );
    pw_alu_carry_tree #(.W(WIDTH)) ab_tree (
        .p(~p), .g((~a) & b), .c(cab)
    );
    pw_alu_carry_tree #(.W(WIDTH)) ba_tree (
        .p(~p), .g(a & (~b)), .c(cba)
    );
    assign add_result = p ^ ca;
    assign ab_result = p ^ cab;
    assign ba_result = p ^ cba;

    assign s0 = Oper == 3'b000;
    assign s1 = Oper == 3'b001;
    assign s2 = Oper == 3'b010;
    assign s3 = Oper == 3'b011;
    assign s4 = Oper == 3'b100;
    assign s5 = Oper == 3'b101;
    assign s6 = Oper == 3'b110;

    always @* begin
        sum = ({WIDTH{s0}} & add_result)
            | ({WIDTH{s1}} & ab_result)
            | ({WIDTH{s2}} & ba_result)
            | ({WIDTH{s3}} & (a | b))
            | ({WIDTH{s4}} & (a & b))
            | ({WIDTH{s5}} & p)
            | ({WIDTH{s6}} & (~p));
    end
endmodule

module pw_alu_carry_tree #(
    parameter W = 64
)(
    input wire [W-1:0] p,
    input wire [W-1:0] g,
    output wire [W-1:0] c
);
    localparam N = (W + 3) / 4;
    localparam L = $clog2(N);
    wire [4*N-1:0] pp, gg;
    wire [N-1:0] gp [0:L];
    wire [N-1:0] ge [0:L];
    wire [N-1:0] bc;

    genvar i, k, j;
    generate
        for (i = 0; i < 4*N; i = i + 1) begin: pad
            if (i < W) begin: real_bit
                assign pp[i] = p[i];
                assign gg[i] = g[i];
            end else begin: unused_bit
                assign pp[i] = 1'b1;
                assign gg[i] = 1'b0;
            end
        end
        for (i = 0; i < N; i = i + 1) begin: groups
            assign gp[0][i] = &pp[4*i +: 4];
            assign ge[0][i] = gg[4*i+3]
                | (pp[4*i+3] & gg[4*i+2])
                | (pp[4*i+3] & pp[4*i+2] & gg[4*i+1])
                | (pp[4*i+3] & pp[4*i+2] & pp[4*i+1] & gg[4*i]);
            if (i == 0) begin: first_group
                assign bc[i] = 1'b0;
            end else begin: later_group
                assign bc[i] = ge[L][i-1];
            end
        end
        for (k = 0; k < L; k = k + 1) begin: prefix_level
            for (j = 0; j < N; j = j + 1) begin: prefix_node
                if (j >= (1 << k)) begin: combine
                    assign gp[k+1][j] = gp[k][j] & gp[k][j-(1 << k)];
                    assign ge[k+1][j] = ge[k][j]
                        | (gp[k][j] & ge[k][j-(1 << k)]);
                end else begin: pass_node
                    assign gp[k+1][j] = gp[k][j];
                    assign ge[k+1][j] = ge[k][j];
                end
            end
        end
        for (i = 0; i < W; i = i + 1) begin: bit_carry
            if ((i % 4) == 0) begin: offset_zero
                assign c[i] = bc[i/4];
            end else if ((i % 4) == 1) begin: offset_one
                assign c[i] = gg[i-1] | (pp[i-1] & bc[i/4]);
            end else if ((i % 4) == 2) begin: offset_two
                assign c[i] = gg[i-1]
                    | (pp[i-1] & gg[i-2])
                    | (pp[i-1] & pp[i-2] & bc[i/4]);
            end else begin: offset_three
                assign c[i] = gg[i-1]
                    | (pp[i-1] & gg[i-2])
                    | (pp[i-1] & pp[i-2] & gg[i-3])
                    | (pp[i-1] & pp[i-2] & pp[i-3] & bc[i/4]);
            end
        end
    endgenerate
endmodule
