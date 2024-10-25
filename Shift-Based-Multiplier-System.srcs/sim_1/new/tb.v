`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2024 01:38:52 PM
// Design Name: 
// Module Name: tb
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


module tb();
    reg clk, ld_sync_op;
    reg [7:0] ain;
    reg [7:0] bin;
    wire pla, plb, init;
    
    top top_inst(.clk(clk), .ld_sync_op(ld_sync_op), .a(ain), .b(bin));
    
    initial
    begin
        #0 clk=1'b0;
        forever #5 clk=~clk;
    end
    
    initial
    begin
        #0 ld_sync_op = 1'b0; ain = 8'd22; bin = 8'd1;
        #30 ld_sync_op = 1'b1;
        #30 ld_sync_op = 1'b0;
        #30
        #30 ld_sync_op = 1'b1;
        #30 ld_sync_op = 1'b0;
        #30 ld_sync_op = 1'b1;
        #30 ld_sync_op = 1'b0;
        #30 ld_sync_op = 1'b1;
        
        #500 $finish;
    end
endmodule
