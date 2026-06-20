`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.06.2026 20:16:46
// Design Name: 
// Module Name: fifov2_tb
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


module fifov2_tb;

logic clk;
logic reset;
logic wr_en;
logic rd_en;
logic [7:0] data_in;
logic [7:0] data_out;
logic full;
logic empty;
logic [3:0] count_before;

fifov2 dut(
    .data_in(data_in),
    .clk(clk),
    .reset(reset),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    // Reset
    reset   = 1;
    wr_en   = 0;
    rd_en   = 0;
    data_in = 0;

    #20;
    reset = 0;

    // --------------------------
    // WRITE AA BB CC
    // --------------------------

    @(posedge clk);
    wr_en   <= 1;
    data_in <= 8'hAA;

    @(posedge clk);
    data_in <= 8'hBB;

    @(posedge clk);
    data_in <= 8'hCC;

    @(posedge clk);
    wr_en <= 0;

    // Give one idle cycle
    @(posedge clk);

    $display("mem[0] = %h", dut.mem[0]);
    $display("mem[1] = %h", dut.mem[1]);
    $display("mem[2] = %h", dut.mem[2]);

    // --------------------------
    // READ
    // --------------------------

    rd_en <= 1;

    @(posedge clk);
    #1;
    $display("Read = %h", data_out);

    @(posedge clk);
    #1;
    $display("Read = %h", data_out);

    @(posedge clk);
    #1;
    $display("Read = %h", data_out);

    rd_en <= 0;

    // --------------------------
    // EMPTY CHECK
    // --------------------------

    @(posedge clk);

    if(empty)
        $display("FIFO EMPTY PASS");
    else
        $display("FIFO EMPTY FAIL");

    // --------------------------
    // FILL FIFO
    // --------------------------

    wr_en <= 1;

    repeat(8)
    begin
        data_in <= $random;
        @(posedge clk);
    end

    wr_en <= 0;

    @(posedge clk);

    if(full)
        $display("FIFO FULL PASS");
    else
        $display("FIFO FULL FAIL");

    // --------------------------
    // SIMULTANEOUS R/W
    // --------------------------

       count_before = dut.count;

data_in = 8'hDD;
wr_en   = 1;
rd_en   = 1;

@(posedge clk);

wr_en = 0;
rd_en = 0;

assert(dut.count == count_before)
    $display("SIMULTANEOUS R/W TEST PASSED");
else
    $error("Count changed during simultaneous R/W");
end

endmodule