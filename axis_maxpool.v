`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2023 14:45:35
// Design Name: 
// Module Name: maxpool_axis
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Maxpooling 2x2 Implemanttion
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`timescale 1 ns / 1 ps 

module axis_maxpool #(
    //parameter WIDTH = 32,
    parameter C_DATA_WIDTH = 8,
    parameter C_NUM_CHANNELS = 2,
    parameter K = 2,
    parameter S = 2,
    //parameter Win = 4,
    //parameter Hin = 4,
    parameter Win = 28,
    parameter Hin = 28,
    //parameter N = 1,
    parameter N = 6,
    parameter Wout = ((Win-K)/S)+1,
    parameter Hout = ((Hin-K)/S)+1,
    parameter MAX_COUNT_POOL_SIZE = K*K,
    parameter MAX_COUNT_POOL_OUT = Wout * Hout * N
    )
    (
        // *** AXI4 clock and reset port ***
        input wire         aclk,
        input wire         aresetn,
        // *** AXI4-stream slave port ***
        output wire        s_axis_tready,
        input wire [C_DATA_WIDTH-1:0] s_axis_tdata,
        input wire         s_axis_tvalid,
        // *** AXI4-stream master port ***
        input wire         m_axis_tready,
        output wire [C_DATA_WIDTH-1:0] m_axis_tdata,
        output wire        m_axis_tvalid
    );

    reg [3:0] count_pool_size;
    reg [10:0] count_pool_out;
    reg [10:0] count_out;
    //reg s_axis_tready_reg;
    reg [C_DATA_WIDTH-1:0] temp [0:MAX_COUNT_POOL_SIZE-1];
    //reg [WIDTH-1:0] temp_save [0:MAX_COUNT_POOL_OUT-1];
    reg [C_DATA_WIDTH-1:0] max;
    reg [C_DATA_WIDTH-1:0] top_reg;
    reg out_valid_reg;
    reg s_axis_tready_reg;
    integer i;

    reg [1:0] state, nextstate;
    parameter S0 = 2'd0, S1 = 2'd1, S2 = 2'd2;

    // State Transition
    always @(posedge aclk or negedge aresetn)
    begin
        if (!aresetn)
        begin
            // Reset State
            state = S0;
        end
        else
        begin
            // Next State
            state = nextstate;
        end
    end

    // State Transition due to input and internal signal changes
    always @(s_axis_tvalid or m_axis_tready or state or count_pool_size or count_pool_out or MAX_COUNT_POOL_OUT or MAX_COUNT_POOL_SIZE or count_out)
    begin
        nextstate = state;
        if(state == S0)
        begin
            if (m_axis_tready)
            begin
                // Input State
                nextstate = S1;
            end
            else
            begin
                nextstate = S0;
            end
        end
        
        if(state == S1)
        begin
            // Remain in S1 if number of input is less than number of K*K
            if (count_pool_size < MAX_COUNT_POOL_SIZE && count_pool_out < MAX_COUNT_POOL_OUT)
            begin
                nextstate = S1;
            end
            else 
            begin
                nextstate = S0;
            end
        end
    end

    // State outputs
    always @(posedge aclk)
    begin
        //In S0, reset all of the register into zero
        if(state == S0)
        begin
            count_pool_size = 0;
            count_pool_out = 0;
            count_out = 0;
            max = 0;
            top_reg = 0;
            s_axis_tready_reg = 0;
            out_valid_reg = 0;
            for (i = 0; i < MAX_COUNT_POOL_SIZE; i = i + 1)
            begin
                temp[i] = 0;
            end
        end
        //In S1, Start counting number of input and also save those inputs into K*K in one dimension array
        if(state == S1)
        begin
            s_axis_tready_reg = 1;
            if(s_axis_tvalid)
            begin
                out_valid_reg = 0;
                count_out = 0;
                count_pool_size = count_pool_size + 1;
                temp[count_pool_size-1] = s_axis_tdata;
                if(count_pool_size == MAX_COUNT_POOL_SIZE)
                begin
                    count_pool_size = 0;
                    count_pool_out = count_pool_out + 1;
                    max = temp[0];
                    for (i = 0; i < MAX_COUNT_POOL_SIZE; i = i + 1)
                    begin
                        if (temp[i] > max)
                        begin
                            max = temp[i];
                        end
                    end
                    out_valid_reg = 1;
                    top_reg = max;
                end
            end
        end
    end

    // Assign the output of maxpool
    assign m_axis_tvalid = out_valid_reg;
    assign m_axis_tdata = top_reg;
    //assign s_axis_tready = s_axis_tready_reg & s_axis_tvalid;
    assign s_axis_tready = s_axis_tready_reg;

endmodule : axis_maxpool

`default_nettype wire
