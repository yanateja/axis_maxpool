`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2023 14:12:19
// Design Name: 
// Module Name: xpm_fifo_sync_ver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module xpm_fifo_sync_ver
(
    output wire data_valid,
    output wire [31:0]dout,
    output wire empty,
    output wire full,
    output wire prog_full,
    input wire [31:0] din,
    input wire rd_en,
    input wire rst,
    input wire sleep,
    input wire wr_clk,
    input wire wr_en
);

xpm_fifo_sync #(
   .CASCADE_HEIGHT(0),        // DECIMAL
   .DOUT_RESET_VALUE("0"),    // String
   .ECC_MODE("no_ecc"),       // String
   .FIFO_MEMORY_TYPE("auto"), // String
   .FIFO_READ_LATENCY(1),     // DECIMAL
   .FIFO_WRITE_DEPTH(16),   // DECIMAL
   .FULL_RESET_VALUE(1),      // DECIMAL
   .PROG_EMPTY_THRESH(10),    // DECIMAL
   .PROG_FULL_THRESH(10),     // DECIMAL
   .RD_DATA_COUNT_WIDTH(1),   // DECIMAL
   .READ_DATA_WIDTH(32),      // DECIMAL
   .READ_MODE("fwft"),         // String
   .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   //.USE_ADV_FEATURES("0707"), // String
   .WAKEUP_TIME(0),           // DECIMAL
   .WRITE_DATA_WIDTH(32),     // DECIMAL
   .WR_DATA_COUNT_WIDTH(1)    // DECIMAL
)
inst_rd_xpm_fifo_sync (

   .data_valid(data_valid),       // 1-bit output: Read Data Valid: When asserted, this signal indicates
                                  // that valid data is available on the output bus (dout).

   .dout(dout),                   // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                  // when reading the FIFO.

   .empty(empty),                 // 1-bit output: Empty Flag: When asserted, this signal indicates that the
                                  // FIFO is empty. Read requests are ignored when the FIFO is empty,
                                  // initiating a read while empty is not destructive to the FIFO.

   .full(full),                   // 1-bit output: Full Flag: When asserted, this signal indicates that the
                                  // FIFO is full. Write requests are ignored when the FIFO is full,
                                  // initiating a write when the FIFO is full is not destructive to the
                                  // contents of the FIFO.

   .prog_full(prog_full),         // 1-bit output: Programmable Full: This signal is asserted when the
                                  // number of words in the FIFO is greater than or equal to the
                                  // programmable full threshold value. It is de-asserted when the number of
                                  // words in the FIFO is less than the programmable full threshold value.

   .din(din),                     // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                  // writing the FIFO.


   .rd_en(rd_en),                 // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                  // signal causes data (on dout) to be read from the FIFO. Must be held
                                  // active-low when rd_rst_busy is active high.

   .rst(rst),                     // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                  // unstable at the time of applying reset, but reset must be released only
                                  // after the clock(s) is/are stable.

   .sleep(sleep),                 // 1-bit input: Dynamic power saving- If sleep is High, the memory/fifo
                                  // block is in power saving mode.

   .wr_clk(wr_clk),               // 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                  // free running clock.

   .wr_en(wr_en)                  // 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                  // signal causes data (on din) to be written to the FIFO Must be held
                                  // active-low when rst or wr_rst_busy or rd_rst_busy is active high

);

endmodule
