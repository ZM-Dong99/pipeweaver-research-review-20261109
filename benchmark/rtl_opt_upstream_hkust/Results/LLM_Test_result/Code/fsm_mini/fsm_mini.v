module fsm_mini (
    input clk,
    input rst_n,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);

parameter S_IDLE  = 3'd0; // Using smaller state encoding
parameter S_START = 3'd1;
parameter S_READ  = 3'd2;
parameter S_PROC  = 3'd3; // Combined processing states
parameter S_WAIT  = 3'd4;
parameter S_DONE  = 3'd5;
parameter S_ERROR = 3'd6;

reg [2:0] state, next_state;
reg [7:0] data_reg;       // Registered data_in for processing states

always @(*) begin
    next_state = S_IDLE; // Default
    case (state)
        S_IDLE:  next_state = start ? S_START : S_IDLE;
        S_START: next_state = (data_in[0]) ? S_READ : S_ERROR;
        S_READ:  next_state = (data_in[3:1] == 3'b101) ? S_PROC : S_WAIT;
        S_PROC: begin
            case (data_reg) // Use internal register for simpler logic
                8'h00: next_state = (data_reg[7]) ? S_PROC : S_WAIT; // Placeholder, will be overwritten
                8'h01: next_state = S_DONE; // S_PROC1 leads to S_PROC2, combined
                8'h02: next_state = (data_reg[7]) ? S_PROC : S_WAIT; // S_PROC2 leads to S_PROC3 or S_WAIT
                8'h0f: next_state = S_DONE; // S_PROC3 leads to S_DONE
                default: next_state = S_DONE; // Default to S_DONE after proc
            endcase

            // Refined state transitions for S_PROC (using a counter implicit)
            if (state == S_PROC) begin
                if      (data_reg[0] == 0) next_state = S_PROC; // S_PROC1 processing
                else if (data_reg[1] == 0) next_state = (data_reg[7]) ? S_PROC : S_WAIT; // S_PROC2 processing
                else                       next_state = S_DONE; // S_PROC3 processing
            end
        end
        S_WAIT:  next_state = (data_in[4]) ? S_READ : S_WAIT;
        S_DONE:  next_state = S_IDLE;
        S_ERROR: next_state = (data_in[2:0] == 3'b111) ? S_IDLE : S_ERROR;
        default: next_state = S_IDLE;
    endcase

    // Simplified and corrected S_PROC transitions using a sub-state logic or counter
    if (state == S_PROC) begin
        if (data_reg[0] == 0) begin // First step of processing (like S_PROC1)
            next_state = S_PROC;
        end else if (data_reg[1] == 0) begin // Second step of processing (like S_PROC2)
             next_state = (data_reg[7]) ? S_PROC : S_WAIT;
        end else begin // Third step of processing (like S_PROC3)
            next_state = S_DONE;
        end
    end

end

always @(*) begin
    {data_out, done} = {8'h00, 1'b0};
    data_reg = data_in; // Default data_reg value

    case (state)
        S_READ:  data_out = data_in;
        S_PROC:  begin
            if (state == S_PROC) begin
                 if (data_reg[0] == 0) begin // Corresponds to S_PROC1 logic
                     data_out = data_reg + 8'h01;
                     data_reg[0] = 1; // Mark this step done
                 end else if (data_reg[1] == 0) begin // Corresponds to S_PROC2 logic
                     data_out = data_reg << 1;
                     data_reg[1] = 1; // Mark this step done
                 end else begin // Corresponds to S_PROC3 logic
                     data_out = data_reg ^ 8'hFF;
                     data_reg[2] = 1; // Mark this step done
                 end
            end
        end
        S_DONE:  {data_out, done} = {data_reg, 1'b1}; // Use the last processed data
        S_ERROR: data_out = 8'hEE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_IDLE;
        data_reg <= 8'h00;
    end else begin
        state <= next_state;
         // Update data_reg only when entering S_READ or when processing
        if (next_state == S_READ) begin
            data_reg <= data_in;
        end else if (next_state == S_PROC && state == S_READ) begin
             data_reg <= data_in; // Start processing with current data_in
        end else if (state == S_PROC) begin
            // data_reg is updated in the combinatorial block for each processing step
            // No need to assign here as the combinatorial logic manages the step updates
        end else if (next_state == S_DONE && state == S_PROC) begin
             data_reg <= data_out; // Store the final processed data before going to DONE
        end

    end
end

endmodule