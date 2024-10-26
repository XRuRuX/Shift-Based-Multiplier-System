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
    reg disp_btn;
    reg clk_btn;
    reg [7:0] ain;
    reg [7:0] bin;
    wire[15:0] rez;
    
    top top_inst(.clk(clk), .ld_sync_op(ld_sync_op), .disp_btn(disp_btn), .clk_btn(clk_btn), .a(ain), .b(bin), .rez_display(rez));
    
    initial
    begin
        #0 clk=1'b0;
        forever #5 clk=~clk;
    end
    
    initial
    begin
        #0 ld_sync_op = 1'b0; ain = 8'd255; bin = 8'd255; disp_btn = 1'b0; clk_btn = 1'b0;
        #30 ld_sync_op = 1'b1;
        #30 ld_sync_op = 1'b0;
        #30
        #30 ld_sync_op = 1'b1;
        #30 ld_sync_op = 1'b0;
        #30 ld_sync_op = 1'b1;
        #30 ld_sync_op = 1'b0;
        #30 ld_sync_op = 1'b1;
        
        #35 clk_btn = 1'b1;
        #35 clk_btn = 1'b0;
        #35 clk_btn = 1'b1;
        #35 clk_btn = 1'b0;
        #35 clk_btn = 1'b1;
        #35 clk_btn = 1'b0;
        #35 clk_btn = 1'b1;
        #35 clk_btn = 1'b0;
        #35 clk_btn = 1'b1;
        #35 clk_btn = 1'b0;
        #35 clk_btn = 1'b1;
        #35 clk_btn = 1'b0;
        #35 clk_btn = 1'b1;
        #35 clk_btn = 1'b0;
        #35 clk_btn = 1'b1;
        #35 clk_btn = 1'b0;
        
        #50 disp_btn = 1'b1;
        #10 disp_btn = 1'b0;
        #10 disp_btn = 1'b1;
        #30 disp_btn = 1'b0;
        #20 disp_btn = 1'b1;
        #20 disp_btn = 1'b0;
        
        #500 $finish;
    end
endmodule
