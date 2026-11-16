/*

Copyright (c) 2014-2023 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * AXI4-Stream bus width adapter
 */
module axis_adapter #
(
    // Width of input AXI stream interface in bits
    parameter S_DATA_WIDTH = 8,
    // Propagate tkeep signal on input interface
    // If disabled, tkeep assumed to be 1'b1
    parameter S_KEEP_ENABLE = (S_DATA_WIDTH>8),
    // tkeep signal width (words per cycle) on input interface
    parameter S_KEEP_WIDTH = ((S_DATA_WIDTH+7)/8),
    // Width of output AXI stream interface in bits
    parameter M_DATA_WIDTH = 8,
    // Propagate tkeep signal on output interface
    // If disabled, tkeep assumed to be 1'b1
    parameter M_KEEP_ENABLE = (M_DATA_WIDTH>8),
    // tkeep signal width (words per cycle) on output interface
    parameter M_KEEP_WIDTH = ((M_DATA_WIDTH+7)/8),
    // Propagate tid signal
    parameter ID_ENABLE = 0,
    // tid signal width
    parameter ID_WIDTH = 8,
    // Propagate tdest signal
    parameter DEST_ENABLE = 0,
    // tdest signal width
    parameter DEST_WIDTH = 8,
    // Propagate tuser signal
    parameter USER_ENABLE = 1,
    // tuser signal width
    parameter USER_WIDTH = 1
)
(
    input  wire                     clk,
    input  wire                     rst,

    /*
     * AXI input
     */
    input  wire [S_DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire [S_KEEP_WIDTH-1:0]  s_axis_tkeep,
    input  wire                     s_axis_tvalid,
    output wire                     s_axis_tready,
    input  wire                     s_axis_tlast,
    input  wire [ID_WIDTH-1:0]      s_axis_tid,
    input  wire [DEST_WIDTH-1:0]    s_axis_tdest,
    input  wire [USER_WIDTH-1:0]    s_axis_tuser,

    /*
     * AXI output
     */
    output wire [M_DATA_WIDTH-1:0]  m_axis_tdata,
    output wire [M_KEEP_WIDTH-1:0]  m_axis_tkeep,
    output wire                     m_axis_tvalid,
    input  wire                     m_axis_tready,
    output wire                     m_axis_tlast,
    output wire [ID_WIDTH-1:0]      m_axis_tid,
    output wire [DEST_WIDTH-1:0]    m_axis_tdest,
    output wire [USER_WIDTH-1:0]    m_axis_tuser
);

// force keep width to 1 when disabled
localparam S_BYTE_LANES = S_KEEP_ENABLE ? S_KEEP_WIDTH : 1;
localparam M_BYTE_LANES = M_KEEP_ENABLE ? M_KEEP_WIDTH : 1;

// bus byte sizes (must be identical)
localparam S_BYTE_SIZE = S_DATA_WIDTH / S_BYTE_LANES;
localparam M_BYTE_SIZE = M_DATA_WIDTH / M_BYTE_LANES;

// bus width assertions
initial begin
    if (S_BYTE_SIZE * S_BYTE_LANES != S_DATA_WIDTH) begin
        $error("Error: input data width not evenly divisible (instance %m)");
        $finish;
    end

    if (M_BYTE_SIZE * M_BYTE_LANES != M_DATA_WIDTH) begin
        $error("Error: output data width not evenly divisible (instance %m)");
        $finish;
    end

    if (S_BYTE_SIZE != M_BYTE_SIZE) begin
        $error("Error: byte size mismatch (instance %m)");
        $finish;
    end
end

wire [S_KEEP_WIDTH-1:0] s_axis_tkeep_int = S_KEEP_ENABLE ? s_axis_tkeep : {S_KEEP_WIDTH{1'b1}};

generate

if (M_BYTE_LANES == S_BYTE_LANES) begin : bypass
    // same width; bypass

    assign s_axis_tready = m_axis_tready;

    assign m_axis_tdata  = s_axis_tdata;
    assign m_axis_tkeep  = (M_KEEP_ENABLE && S_KEEP_ENABLE) ? s_axis_tkeep : {M_KEEP_WIDTH{1'b1}};
    assign m_axis_tvalid = s_axis_tvalid;
    assign m_axis_tlast  = s_axis_tlast;
    assign m_axis_tid    = ID_ENABLE   ? s_axis_tid   : {ID_WIDTH{1'b0}};
    assign m_axis_tdest  = DEST_ENABLE ? s_axis_tdest : {DEST_WIDTH{1'b0}};
    assign m_axis_tuser  = USER_ENABLE ? s_axis_tuser : {USER_WIDTH{1'b0}};

end else if (M_BYTE_LANES > S_BYTE_LANES) begin : upsize
    // output is wider; upsize

    // required number of segments in wider bus
    localparam SEG_COUNT = M_BYTE_LANES / S_BYTE_LANES;
    // data width and keep width per segment
    localparam SEG_DATA_WIDTH = M_DATA_WIDTH / SEG_COUNT;
    localparam SEG_KEEP_WIDTH = M_BYTE_LANES / SEG_COUNT;

    reg [$clog2(SEG_COUNT)-1:0] seg_reg = 0;

    reg [S_DATA_WIDTH-1:0] s_axis_tdata_reg = {S_DATA_WIDTH{1'b0}};
    reg [S_KEEP_WIDTH-1:0] s_axis_tkeep_reg = {S_KEEP_WIDTH{1'b0}};
    reg s_axis_tvalid_reg = 1'b0;
    reg s_axis_tlast_reg = 1'b0;
    reg [ID_WIDTH-1:0] s_axis_tid_reg = {ID_WIDTH{1'b0}};
    reg [DEST_WIDTH-1:0] s_axis_tdest_reg = {DEST_WIDTH{1'b0}};
    reg [USER_WIDTH-1:0] s_axis_tuser_reg = {USER_WIDTH{1'b0}};

    reg [M_DATA_WIDTH-1:0] m_axis_tdata_reg = {M_DATA_WIDTH{1'b0}};
    reg [M_KEEP_WIDTH-1:0] m_axis_tkeep_reg = {M_KEEP_WIDTH{1'b0}};
    reg m_axis_tvalid_reg = 1'b0;
    reg m_axis_tlast_reg = 1'b0;
    reg [ID_WIDTH-1:0] m_axis_tid_reg = {ID_WIDTH{1'b0}};
    reg [DEST_WIDTH-1:0] m_axis_tdest_reg = {DEST_WIDTH{1'b0}};
    reg [USER_WIDTH-1:0] m_axis_tuser_reg = {USER_WIDTH{1'b0}};

    assign s_axis_tready = !s_axis_tvalid_reg;

    assign m_axis_tdata  = m_axis_tdata_reg;
    assign m_axis_tkeep  = M_KEEP_ENABLE ? m_axis_tkeep_reg : {M_KEEP_WIDTH{1'b1}};
    assign m_axis_tvalid = m_axis_tvalid_reg;
    assign m_axis_tlast  = m_axis_tlast_reg;
    assign m_axis_tid    = ID_ENABLE   ? m_axis_tid_reg   : {ID_WIDTH{1'b0}};
    assign m_axis_tdest  = DEST_ENABLE ? m_axis_tdest_reg : {DEST_WIDTH{1'b0}};
    assign m_axis_tuser  = USER_ENABLE ? m_axis_tuser_reg : {USER_WIDTH{1'b0}};

    always @(posedge clk) begin
        m_axis_tvalid_reg <= m_axis_tvalid_reg && !m_axis_tready;

        if (!m_axis_tvalid_reg || m_axis_tready) begin
            // output register empty

            if (seg_reg == 0) begin
                m_axis_tdata_reg[seg_reg*SEG_DATA_WIDTH +: SEG_DATA_WIDTH] <= s_axis_tvalid_reg ? s_axis_tdata_reg : s_axis_tdata;
                m_axis_tkeep_reg <= s_axis_tvalid_reg ? s_axis_tkeep_reg : s_axis_tkeep_int;
            end else begin
                m_axis_tdata_reg[seg_reg*SEG_DATA_WIDTH +: SEG_DATA_WIDTH] <= s_axis_tdata;
                m_axis_tkeep_reg[seg_reg*SEG_KEEP_WIDTH +: SEG_KEEP_WIDTH] <= s_axis_tkeep_int;
            end
            m_axis_tlast_reg <= s_axis_tvalid_reg ? s_axis_tlast_reg : s_axis_tlast;
            m_axis_tid_reg <= s_axis_tvalid_reg ? s_axis_tid_reg : s_axis_tid;
            m_axis_tdest_reg <= s_axis_tvalid_reg ? s_axis_tdest_reg : s_axis_tdest;
            m_axis_tuser_reg <= s_axis_tvalid_reg ? s_axis_tuser_reg : s_axis_tuser;

            if (s_axis_tvalid_reg) begin
                // consume data from buffer
                s_axis_tvalid_reg <= 1'b0;

                if (s_axis_tlast_reg || seg_reg == SEG_COUNT-1) begin
                    seg_reg <= 0;
                    m_axis_tvalid_reg <= 1'b1;
                end else begin
                    seg_reg <= seg_reg + 1;
                end
            end else if (s_axis_tvalid) begin
                // data direct from input
                if (s_axis_tlast || seg_reg == SEG_COUNT-1) begin
                    seg_reg <= 0;
                    m_axis_tvalid_reg <= 1'b1;
                end else begin
                    seg_reg <= seg_reg + 1;
                end
            end
        end else if (s_axis_tvalid && s_axis_tready) begin
            // store input data in skid buffer
            s_axis_tdata_reg <= s_axis_tdata;
            s_axis_tkeep_reg <= s_axis_tkeep_int;
            s_axis_tvalid_reg <= 1'b1;
            s_axis_tlast_reg <= s_axis_tlast;
            s_axis_tid_reg <= s_axis_tid;
            s_axis_tdest_reg <= s_axis_tdest;
            s_axis_tuser_reg <= s_axis_tuser;
        end

        if (rst) begin
            seg_reg <= 0;
            s_axis_tvalid_reg <= 1'b0;
            m_axis_tvalid_reg <= 1'b0;
        end
    end

end else begin : downsize
    // output is narrower; downsize

    // required number of segments in wider bus
    localparam SEG_COUNT = S_BYTE_LANES / M_BYTE_LANES;
    // data width and keep width per segment
    localparam SEG_DATA_WIDTH = S_DATA_WIDTH / SEG_COUNT;
    localparam SEG_KEEP_WIDTH = S_BYTE_LANES / SEG_COUNT;

    reg [S_DATA_WIDTH-1:0] s_axis_tdata_reg = {S_DATA_WIDTH{1'b0}};
    reg [S_KEEP_WIDTH-1:0] s_axis_tkeep_reg = {S_KEEP_WIDTH{1'b0}};
    reg s_axis_tvalid_reg = 1'b0;
    reg s_axis_tlast_reg = 1'b0;
    reg [ID_WIDTH-1:0] s_axis_tid_reg = {ID_WIDTH{1'b0}};
    reg [DEST_WIDTH-1:0] s_axis_tdest_reg = {DEST_WIDTH{1'b0}};
    reg [USER_WIDTH-1:0] s_axis_tuser_reg = {USER_WIDTH{1'b0}};

    reg [M_DATA_WIDTH-1:0] m_axis_tdata_reg = {M_DATA_WIDTH{1'b0}};
    reg [M_KEEP_WIDTH-1:0] m_axis_tkeep_reg = {M_KEEP_WIDTH{1'b0}};
    reg m_axis_tvalid_reg = 1'b0;
    reg m_axis_tlast_reg = 1'b0;
    reg [ID_WIDTH-1:0] m_axis_tid_reg = {ID_WIDTH{1'b0}};
    reg [DEST_WIDTH-1:0] m_axis_tdest_reg = {DEST_WIDTH{1'b0}};
    reg [USER_WIDTH-1:0] m_axis_tuser_reg = {USER_WIDTH{1'b0}};

    assign s_axis_tready = !s_axis_tvalid_reg;

    assign m_axis_tdata  = m_axis_tdata_reg;
    assign m_axis_tkeep  = M_KEEP_ENABLE ? m_axis_tkeep_reg : {M_KEEP_WIDTH{1'b1}};
    assign m_axis_tvalid = m_axis_tvalid_reg;
    assign m_axis_tlast  = m_axis_tlast_reg;
    assign m_axis_tid    = ID_ENABLE   ? m_axis_tid_reg   : {ID_WIDTH{1'b0}};
    assign m_axis_tdest  = DEST_ENABLE ? m_axis_tdest_reg : {DEST_WIDTH{1'b0}};
    assign m_axis_tuser  = USER_ENABLE ? m_axis_tuser_reg : {USER_WIDTH{1'b0}};

    always @(posedge clk) begin
        m_axis_tvalid_reg <= m_axis_tvalid_reg && !m_axis_tready;

        if (!m_axis_tvalid_reg || m_axis_tready) begin
            // output register empty

            m_axis_tdata_reg <= s_axis_tvalid_reg ? s_axis_tdata_reg : s_axis_tdata;
            m_axis_tkeep_reg <= s_axis_tvalid_reg ? s_axis_tkeep_reg : s_axis_tkeep_int;
            m_axis_tlast_reg <= 1'b0;
            m_axis_tid_reg <= s_axis_tvalid_reg ? s_axis_tid_reg : s_axis_tid;
            m_axis_tdest_reg <= s_axis_tvalid_reg ? s_axis_tdest_reg : s_axis_tdest;
            m_axis_tuser_reg <= s_axis_tvalid_reg ? s_axis_tuser_reg : s_axis_tuser;

            if (s_axis_tvalid_reg) begin
                // buffer has data; shift out from buffer
                s_axis_tdata_reg <= s_axis_tdata_reg >> SEG_DATA_WIDTH;
                s_axis_tkeep_reg <= s_axis_tkeep_reg >> SEG_KEEP_WIDTH;

                m_axis_tvalid_reg <= 1'b1;

                if ((s_axis_tkeep_reg >> SEG_KEEP_WIDTH) == 0) begin
                    s_axis_tvalid_reg <= 1'b0;
                    m_axis_tlast_reg <= s_axis_tlast_reg;
                end
            end else if (s_axis_tvalid && s_axis_tready) begin
                // buffer is empty; store from input
                s_axis_tdata_reg <= s_axis_tdata >> SEG_DATA_WIDTH;
                s_axis_tkeep_reg <= s_axis_tkeep_int >> SEG_KEEP_WIDTH;
                s_axis_tlast_reg <= s_axis_tlast;
                s_axis_tid_reg <= s_axis_tid;
                s_axis_tdest_reg <= s_axis_tdest;
                s_axis_tuser_reg <= s_axis_tuser;

                m_axis_tvalid_reg <= 1'b1;

                if (S_KEEP_ENABLE && (s_axis_tkeep_int >> SEG_KEEP_WIDTH) == 0) begin
                    s_axis_tvalid_reg <= 1'b0;
                    m_axis_tlast_reg <= s_axis_tlast;
                end else begin
                    s_axis_tvalid_reg <= 1'b1;
                end
            end
        end else if (s_axis_tvalid && s_axis_tready) begin
            // store input data
            s_axis_tdata_reg <= s_axis_tdata;
            s_axis_tkeep_reg <= s_axis_tkeep_int;
            s_axis_tvalid_reg <= 1'b1;
            s_axis_tlast_reg <= s_axis_tlast;
            s_axis_tid_reg <= s_axis_tid;
            s_axis_tdest_reg <= s_axis_tdest;
            s_axis_tuser_reg <= s_axis_tuser;
        end

        if (rst) begin
            s_axis_tvalid_reg <= 1'b0;
            m_axis_tvalid_reg <= 1'b0;
        end
    end

end

endgenerate

endmodule

`resetall


/*

Copyright (c) 2014-2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * AXI4-Stream register
 */
module axis_register #
(
    // Width of AXI stream interfaces in bits
    parameter DATA_WIDTH = 8,
    // Propagate tkeep signal
    parameter KEEP_ENABLE = (DATA_WIDTH>8),
    // tkeep signal width (words per cycle)
    parameter KEEP_WIDTH = ((DATA_WIDTH+7)/8),
    // Propagate tlast signal
    parameter LAST_ENABLE = 1,
    // Propagate tid signal
    parameter ID_ENABLE = 0,
    // tid signal width
    parameter ID_WIDTH = 8,
    // Propagate tdest signal
    parameter DEST_ENABLE = 0,
    // tdest signal width
    parameter DEST_WIDTH = 8,
    // Propagate tuser signal
    parameter USER_ENABLE = 1,
    // tuser signal width
    parameter USER_WIDTH = 1,
    // Register type
    // 0 to bypass, 1 for simple buffer, 2 for skid buffer
    parameter REG_TYPE = 2
)
(
    input  wire                   clk,
    input  wire                   rst,

    /*
     * AXI Stream input
     */
    input  wire [DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire [KEEP_WIDTH-1:0]  s_axis_tkeep,
    input  wire                   s_axis_tvalid,
    output wire                   s_axis_tready,
    input  wire                   s_axis_tlast,
    input  wire [ID_WIDTH-1:0]    s_axis_tid,
    input  wire [DEST_WIDTH-1:0]  s_axis_tdest,
    input  wire [USER_WIDTH-1:0]  s_axis_tuser,

    /*
     * AXI Stream output
     */
    output wire [DATA_WIDTH-1:0]  m_axis_tdata,
    output wire [KEEP_WIDTH-1:0]  m_axis_tkeep,
    output wire                   m_axis_tvalid,
    input  wire                   m_axis_tready,
    output wire                   m_axis_tlast,
    output wire [ID_WIDTH-1:0]    m_axis_tid,
    output wire [DEST_WIDTH-1:0]  m_axis_tdest,
    output wire [USER_WIDTH-1:0]  m_axis_tuser
);

generate

if (REG_TYPE > 1) begin
    // skid buffer, no bubble cycles

    // datapath registers
    reg                  s_axis_tready_reg = 1'b0;

    reg [DATA_WIDTH-1:0] m_axis_tdata_reg  = {DATA_WIDTH{1'b0}};
    reg [KEEP_WIDTH-1:0] m_axis_tkeep_reg  = {KEEP_WIDTH{1'b0}};
    reg                  m_axis_tvalid_reg = 1'b0, m_axis_tvalid_next;
    reg                  m_axis_tlast_reg  = 1'b0;
    reg [ID_WIDTH-1:0]   m_axis_tid_reg    = {ID_WIDTH{1'b0}};
    reg [DEST_WIDTH-1:0] m_axis_tdest_reg  = {DEST_WIDTH{1'b0}};
    reg [USER_WIDTH-1:0] m_axis_tuser_reg  = {USER_WIDTH{1'b0}};

    reg [DATA_WIDTH-1:0] temp_m_axis_tdata_reg  = {DATA_WIDTH{1'b0}};
    reg [KEEP_WIDTH-1:0] temp_m_axis_tkeep_reg  = {KEEP_WIDTH{1'b0}};
    reg                  temp_m_axis_tvalid_reg = 1'b0, temp_m_axis_tvalid_next;
    reg                  temp_m_axis_tlast_reg  = 1'b0;
    reg [ID_WIDTH-1:0]   temp_m_axis_tid_reg    = {ID_WIDTH{1'b0}};
    reg [DEST_WIDTH-1:0] temp_m_axis_tdest_reg  = {DEST_WIDTH{1'b0}};
    reg [USER_WIDTH-1:0] temp_m_axis_tuser_reg  = {USER_WIDTH{1'b0}};

    // datapath control
    reg store_axis_input_to_output;
    reg store_axis_input_to_temp;
    reg store_axis_temp_to_output;

    assign s_axis_tready = s_axis_tready_reg;

    assign m_axis_tdata  = m_axis_tdata_reg;
    assign m_axis_tkeep  = KEEP_ENABLE ? m_axis_tkeep_reg : {KEEP_WIDTH{1'b1}};
    assign m_axis_tvalid = m_axis_tvalid_reg;
    assign m_axis_tlast  = LAST_ENABLE ? m_axis_tlast_reg : 1'b1;
    assign m_axis_tid    = ID_ENABLE   ? m_axis_tid_reg   : {ID_WIDTH{1'b0}};
    assign m_axis_tdest  = DEST_ENABLE ? m_axis_tdest_reg : {DEST_WIDTH{1'b0}};
    assign m_axis_tuser  = USER_ENABLE ? m_axis_tuser_reg : {USER_WIDTH{1'b0}};

    // enable ready input next cycle if output is ready or the temp reg will not be filled on the next cycle (output reg empty or no input)
    wire s_axis_tready_early = m_axis_tready || (!temp_m_axis_tvalid_reg && (!m_axis_tvalid_reg || !s_axis_tvalid));

    always @* begin
        // transfer sink ready state to source
        m_axis_tvalid_next = m_axis_tvalid_reg;
        temp_m_axis_tvalid_next = temp_m_axis_tvalid_reg;

        store_axis_input_to_output = 1'b0;
        store_axis_input_to_temp = 1'b0;
        store_axis_temp_to_output = 1'b0;

        if (s_axis_tready_reg) begin
            // input is ready
            if (m_axis_tready || !m_axis_tvalid_reg) begin
                // output is ready or currently not valid, transfer data to output
                m_axis_tvalid_next = s_axis_tvalid;
                store_axis_input_to_output = 1'b1;
            end else begin
                // output is not ready, store input in temp
                temp_m_axis_tvalid_next = s_axis_tvalid;
                store_axis_input_to_temp = 1'b1;
            end
        end else if (m_axis_tready) begin
            // input is not ready, but output is ready
            m_axis_tvalid_next = temp_m_axis_tvalid_reg;
            temp_m_axis_tvalid_next = 1'b0;
            store_axis_temp_to_output = 1'b1;
        end
    end

    always @(posedge clk) begin
        s_axis_tready_reg <= s_axis_tready_early;
        m_axis_tvalid_reg <= m_axis_tvalid_next;
        temp_m_axis_tvalid_reg <= temp_m_axis_tvalid_next;

        // datapath
        if (store_axis_input_to_output) begin
            m_axis_tdata_reg <= s_axis_tdata;
            m_axis_tkeep_reg <= s_axis_tkeep;
            m_axis_tlast_reg <= s_axis_tlast;
            m_axis_tid_reg   <= s_axis_tid;
            m_axis_tdest_reg <= s_axis_tdest;
            m_axis_tuser_reg <= s_axis_tuser;
        end else if (store_axis_temp_to_output) begin
            m_axis_tdata_reg <= temp_m_axis_tdata_reg;
            m_axis_tkeep_reg <= temp_m_axis_tkeep_reg;
            m_axis_tlast_reg <= temp_m_axis_tlast_reg;
            m_axis_tid_reg   <= temp_m_axis_tid_reg;
            m_axis_tdest_reg <= temp_m_axis_tdest_reg;
            m_axis_tuser_reg <= temp_m_axis_tuser_reg;
        end

        if (store_axis_input_to_temp) begin
            temp_m_axis_tdata_reg <= s_axis_tdata;
            temp_m_axis_tkeep_reg <= s_axis_tkeep;
            temp_m_axis_tlast_reg <= s_axis_tlast;
            temp_m_axis_tid_reg   <= s_axis_tid;
            temp_m_axis_tdest_reg <= s_axis_tdest;
            temp_m_axis_tuser_reg <= s_axis_tuser;
        end

        if (rst) begin
            s_axis_tready_reg <= 1'b0;
            m_axis_tvalid_reg <= 1'b0;
            temp_m_axis_tvalid_reg <= 1'b0;
        end
    end

end else if (REG_TYPE == 1) begin
    // simple register, inserts bubble cycles

    // datapath registers
    reg                  s_axis_tready_reg = 1'b0;

    reg [DATA_WIDTH-1:0] m_axis_tdata_reg  = {DATA_WIDTH{1'b0}};
    reg [KEEP_WIDTH-1:0] m_axis_tkeep_reg  = {KEEP_WIDTH{1'b0}};
    reg                  m_axis_tvalid_reg = 1'b0, m_axis_tvalid_next;
    reg                  m_axis_tlast_reg  = 1'b0;
    reg [ID_WIDTH-1:0]   m_axis_tid_reg    = {ID_WIDTH{1'b0}};
    reg [DEST_WIDTH-1:0] m_axis_tdest_reg  = {DEST_WIDTH{1'b0}};
    reg [USER_WIDTH-1:0] m_axis_tuser_reg  = {USER_WIDTH{1'b0}};

    // datapath control
    reg store_axis_input_to_output;

    assign s_axis_tready = s_axis_tready_reg;

    assign m_axis_tdata  = m_axis_tdata_reg;
    assign m_axis_tkeep  = KEEP_ENABLE ? m_axis_tkeep_reg : {KEEP_WIDTH{1'b1}};
    assign m_axis_tvalid = m_axis_tvalid_reg;
    assign m_axis_tlast  = LAST_ENABLE ? m_axis_tlast_reg : 1'b1;
    assign m_axis_tid    = ID_ENABLE   ? m_axis_tid_reg   : {ID_WIDTH{1'b0}};
    assign m_axis_tdest  = DEST_ENABLE ? m_axis_tdest_reg : {DEST_WIDTH{1'b0}};
    assign m_axis_tuser  = USER_ENABLE ? m_axis_tuser_reg : {USER_WIDTH{1'b0}};

    // enable ready input next cycle if output buffer will be empty
    wire s_axis_tready_early = !m_axis_tvalid_next;

    always @* begin
        // transfer sink ready state to source
        m_axis_tvalid_next = m_axis_tvalid_reg;

        store_axis_input_to_output = 1'b0;

        if (s_axis_tready_reg) begin
            m_axis_tvalid_next = s_axis_tvalid;
            store_axis_input_to_output = 1'b1;
        end else if (m_axis_tready) begin
            m_axis_tvalid_next = 1'b0;
        end
    end

    always @(posedge clk) begin
        s_axis_tready_reg <= s_axis_tready_early;
        m_axis_tvalid_reg <= m_axis_tvalid_next;

        // datapath
        if (store_axis_input_to_output) begin
            m_axis_tdata_reg <= s_axis_tdata;
            m_axis_tkeep_reg <= s_axis_tkeep;
            m_axis_tlast_reg <= s_axis_tlast;
            m_axis_tid_reg   <= s_axis_tid;
            m_axis_tdest_reg <= s_axis_tdest;
            m_axis_tuser_reg <= s_axis_tuser;
        end

        if (rst) begin
            s_axis_tready_reg <= 1'b0;
            m_axis_tvalid_reg <= 1'b0;
        end
    end

end else begin
    // bypass

    assign m_axis_tdata  = s_axis_tdata;
    assign m_axis_tkeep  = KEEP_ENABLE ? s_axis_tkeep : {KEEP_WIDTH{1'b1}};
    assign m_axis_tvalid = s_axis_tvalid;
    assign m_axis_tlast  = LAST_ENABLE ? s_axis_tlast : 1'b1;
    assign m_axis_tid    = ID_ENABLE   ? s_axis_tid   : {ID_WIDTH{1'b0}};
    assign m_axis_tdest  = DEST_ENABLE ? s_axis_tdest : {DEST_WIDTH{1'b0}};
    assign m_axis_tuser  = USER_ENABLE ? s_axis_tuser : {USER_WIDTH{1'b0}};

    assign s_axis_tready = m_axis_tready;

end

endgenerate

endmodule

`resetall


// Project-authored composition of the public axis_adapter and axis_register.
// The adapter packs bytes, then a two-entry skid register accepts backpressure.
// Invalid output data and sidebands are explicitly zero in this new interface.
module pw_axis_chain #(
    parameter M_DATA_WIDTH = 32,
    parameter M_KEEP_WIDTH = M_DATA_WIDTH/8
)(
    input wire clk, rst,
    input wire [7:0] s_axis_tdata,
    input wire s_axis_tvalid,
    output wire s_axis_tready,
    input wire s_axis_tlast,
    input wire s_axis_tuser,
    output wire [M_DATA_WIDTH-1:0] m_axis_tdata,
    output wire [M_KEEP_WIDTH-1:0] m_axis_tkeep,
    output wire m_axis_tvalid,
    input wire m_axis_tready,
    output wire m_axis_tlast,
    output wire m_axis_tuser
);
    wire [M_DATA_WIDTH-1:0] packed_data, registered_data;
    wire [M_KEEP_WIDTH-1:0] packed_keep, registered_keep;
    wire packed_valid, packed_ready, packed_last, packed_user;
    wire registered_last, registered_user;

    axis_adapter #(
        .S_DATA_WIDTH(8), .S_KEEP_ENABLE(0), .S_KEEP_WIDTH(1),
        .M_DATA_WIDTH(M_DATA_WIDTH), .M_KEEP_ENABLE(1),
        .M_KEEP_WIDTH(M_KEEP_WIDTH), .ID_ENABLE(0), .ID_WIDTH(1),
        .DEST_ENABLE(0), .DEST_WIDTH(1), .USER_ENABLE(1), .USER_WIDTH(1)
    ) adapter (
        .clk(clk), .rst(rst), .s_axis_tdata(s_axis_tdata), .s_axis_tkeep(1'b1),
        .s_axis_tvalid(s_axis_tvalid), .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast), .s_axis_tid(1'b0), .s_axis_tdest(1'b0),
        .s_axis_tuser(s_axis_tuser), .m_axis_tdata(packed_data),
        .m_axis_tkeep(packed_keep), .m_axis_tvalid(packed_valid),
        .m_axis_tready(packed_ready), .m_axis_tlast(packed_last),
        .m_axis_tid(), .m_axis_tdest(), .m_axis_tuser(packed_user)
    );

    axis_register #(
        .DATA_WIDTH(M_DATA_WIDTH), .KEEP_ENABLE(1), .KEEP_WIDTH(M_KEEP_WIDTH),
        .LAST_ENABLE(1), .ID_ENABLE(0), .ID_WIDTH(1), .DEST_ENABLE(0),
        .DEST_WIDTH(1), .USER_ENABLE(1), .USER_WIDTH(1), .REG_TYPE(2)
    ) skid_register (
        .clk(clk), .rst(rst), .s_axis_tdata(packed_data), .s_axis_tkeep(packed_keep),
        .s_axis_tvalid(packed_valid), .s_axis_tready(packed_ready),
        .s_axis_tlast(packed_last), .s_axis_tid(1'b0), .s_axis_tdest(1'b0),
        .s_axis_tuser(packed_user), .m_axis_tdata(registered_data),
        .m_axis_tkeep(registered_keep), .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready), .m_axis_tlast(registered_last),
        .m_axis_tid(), .m_axis_tdest(), .m_axis_tuser(registered_user)
    );

    genvar lane;
    generate
        for (lane = 0; lane < M_KEEP_WIDTH; lane = lane+1) begin: valid_bytes
            assign m_axis_tdata[lane*8 +: 8] =
                m_axis_tvalid && registered_keep[lane] ? registered_data[lane*8 +: 8] : 0;
        end
    endgenerate
    assign m_axis_tkeep = m_axis_tvalid ? registered_keep : 0;
    assign m_axis_tlast = m_axis_tvalid && registered_last;
    assign m_axis_tuser = m_axis_tvalid && registered_user;
endmodule
