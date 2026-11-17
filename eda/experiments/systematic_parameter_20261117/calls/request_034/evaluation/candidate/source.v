module pw_crc32_d4 (
    input  wire [3:0]  data_in,
    input  wire [31:0] state_in,
    output wire [3:0]  data_out,
    output wire [31:0] state_out
);
    // Reflected Ethernet CRC polynomial.  Its low four bits are zero,
    // so none of these four feedback bits depends on an earlier step.
    localparam [31:0] P3 = 32'hedb88320;
    localparam [31:0] P2 = P3 >> 1;
    localparam [31:0] P1 = P3 >> 2;
    localparam [31:0] P0 = P3 >> 3;

    wire [3:0] f;
    wire [31:0] shifted;
    assign f = state_in[3:0] ^ data_in;
    assign data_out = f;
    assign shifted = {4'b0000, state_in[31:4]};

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : crc_bit
            localparam [3:0] M = {P3[i], P2[i], P1[i], P0[i]};
            if (M == 4'h0) begin
                assign state_out[i] = shifted[i];
            end else if (M == 4'h1) begin
                assign state_out[i] = shifted[i] ^ f[0];
            end else if (M == 4'h2) begin
                assign state_out[i] = shifted[i] ^ f[1];
            end else if (M == 4'h3) begin
                assign state_out[i] = shifted[i] ^ (f[0] ^ f[1]);
            end else if (M == 4'h4) begin
                assign state_out[i] = shifted[i] ^ f[2];
            end else if (M == 4'h5) begin
                assign state_out[i] = shifted[i] ^ (f[0] ^ f[2]);
            end else if (M == 4'h6) begin
                assign state_out[i] = shifted[i] ^ (f[1] ^ f[2]);
            end else if (M == 4'h7) begin
                assign state_out[i] = (shifted[i] ^ f[0]) ^ (f[1] ^ f[2]);
            end else if (M == 4'h8) begin
                assign state_out[i] = shifted[i] ^ f[3];
            end else if (M == 4'h9) begin
                assign state_out[i] = shifted[i] ^ (f[0] ^ f[3]);
            end else if (M == 4'ha) begin
                assign state_out[i] = shifted[i] ^ (f[1] ^ f[3]);
            end else if (M == 4'hb) begin
                assign state_out[i] = (shifted[i] ^ f[0]) ^ (f[1] ^ f[3]);
            end else if (M == 4'hc) begin
                assign state_out[i] = shifted[i] ^ (f[2] ^ f[3]);
            end else if (M == 4'hd) begin
                assign state_out[i] = (shifted[i] ^ f[0]) ^ (f[2] ^ f[3]);
            end else if (M == 4'he) begin
                assign state_out[i] = (shifted[i] ^ f[1]) ^ (f[2] ^ f[3]);
            end else begin
                assign state_out[i] = (shifted[i] ^ f[0]) ^ (f[1] ^ (f[2] ^ f[3]));
            end
        end
    endgenerate
endmodule
