module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] bit_eq;
    wire [15:0] bit_gt;
    wire [15:0] bit_lt;

    assign bit_eq = ~(A ^ B);
    assign bit_gt = A & ~B;
    assign bit_lt = ~A & B;

    wire [7:0] eq2;
    wire [7:0] gt2;
    wire [7:0] lt2;
    wire [3:0] eq4;
    wire [3:0] gt4;
    wire [3:0] lt4;
    wire [1:0] eq8;
    wire [1:0] gt8;
    wire [1:0] lt8;
    wire eq16;
    wire gt16;
    wire lt16;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pair_level
            assign eq2[i] = bit_eq[2*i] & bit_eq[2*i+1];
            assign gt2[i] = bit_gt[2*i+1] | (bit_eq[2*i+1] & bit_gt[2*i]);
            assign lt2[i] = bit_lt[2*i+1] | (bit_eq[2*i+1] & bit_lt[2*i]);
        end
    endgenerate

    generate
        for (i = 0; i < 4; i = i + 1) begin : quad_level
            assign eq4[i] = eq2[2*i] & eq2[2*i+1];
            assign gt4[i] = gt2[2*i+1] | (eq2[2*i+1] & gt2[2*i]);
            assign lt4[i] = lt2[2*i+1] | (eq2[2*i+1] & lt2[2*i]);
        end
    endgenerate

    generate
        for (i = 0; i < 2; i = i + 1) begin : octet_level
            assign eq8[i] = eq4[2*i] & eq4[2*i+1];
            assign gt8[i] = gt4[2*i+1] | (eq4[2*i+1] & gt4[2*i]);
            assign lt8[i] = lt4[2*i+1] | (eq4[2*i+1] & lt4[2*i]);
        end
    endgenerate

    assign eq16 = eq8[0] & eq8[1];
    assign gt16 = gt8[1] | (eq8[1] & gt8[0]);
    assign lt16 = lt8[1] | (eq8[1] & lt8[0]);

    assign eq = eq16;
    assign gt = gt16;
    assign lt = lt16;
endmodule
