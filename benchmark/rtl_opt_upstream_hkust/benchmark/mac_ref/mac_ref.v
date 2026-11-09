module mac_ref (
    input clk,
    input signed [7:0] a, b,
    input reset,
    output reg signed [15:0] z
);
    reg signed [15:0] acc; 

    always @(posedge clk) begin

        acc <= reset ? 0 : acc + a * b;  
        
        z <= acc;
    end
    
endmodule