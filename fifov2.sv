`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.06.2026 20:00:18
// Design Name: 
// Module Name: fifov2
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


module fifov2 #(parameter DEPTH=8, WIDTH=8)(data_in,clk,reset,wr_en,rd_en,data_out,full,empty);
input logic [WIDTH-1:0]data_in;
input logic clk,reset,wr_en,rd_en;
output logic [WIDTH-1:0]data_out;
output logic full,empty;
logic [WIDTH-1:0] mem [0:DEPTH-1];

localparam PTR_WIDTH = $clog2(DEPTH);
logic [PTR_WIDTH-1:0]wr_ptr;
logic [PTR_WIDTH-1:0]rd_ptr;
logic [PTR_WIDTH:0]count;

logic write_valid;
logic read_valid;

assign full = (count==DEPTH);
assign empty = (count==0);
assign write_valid = wr_en && (!full || (rd_en && !empty));
assign read_valid  = rd_en && !empty;

always_ff @(posedge clk)
begin 
    if(reset)
    begin
     wr_ptr <= 0;
     rd_ptr <= 0;
     count <= 0;
     data_out <= 0;
     end
     
    else
     
      begin
        if(write_valid)
        begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end

       if(read_valid)
        begin
         $display("Reading mem[%0d] = %h", rd_ptr, mem[rd_ptr]);
         data_out <= mem[rd_ptr];
         rd_ptr <= rd_ptr + 1;
        end

        if(write_valid && !read_valid)
            count <= count + 1;
        else if(read_valid && !write_valid)
            count <= count - 1;
        end
end

endmodule
