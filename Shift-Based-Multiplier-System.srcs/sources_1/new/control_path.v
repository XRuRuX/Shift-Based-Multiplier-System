`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2024 01:53:50 PM
// Design Name: 
// Module Name: control_path
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


module pl_gen(clk, ld_sync_op, ready, pla, plb, init);
    input clk, ld_sync_op, ready;
    output reg pla, plb, init;
    reg [1:0] cs = 2'b00, ns = 2'b00;
    
    always @(posedge clk)
        if(ready)
		    cs <= ns;
    
    always @(cs or ld_sync_op)
        case({cs, ld_sync_op})
            3'b00_0: ns = 2'b00;
            3'b00_1: ns = 2'b01;
            3'b01_0: ns = 2'b01;
            3'b01_1: ns = 2'b10;
            3'b10_0: ns = 2'b11;
            3'b10_1: ns = 2'b11;
            3'b11_0: ns = 2'b00;
            3'b11_1: ns = 2'b00;
            default: ns = 2'b00;
        endcase
        
    always @(cs)
        case(cs)
            2'b00: begin pla = 1'b0; plb = 1'b0; init = 1'b0; end
            2'b01: begin pla = 1'b1; plb = 1'b0; init = 1'b0; end
            2'b10: begin pla = 1'b0; plb = 1'b1; init = 1'b0; end
            2'b11: init = 1'b1;
        endcase
endmodule

module secv(
        input clk, init, b0, if7,
        output reg sha, shb, incc, plrez, sum, done, ready
    );
    
    reg [2:0] cs = 3'b000, ns = 3'b000;
    
    always @(posedge clk)
        cs <= ns;
    
    always @(cs or init or b0 or if7)
        casex({cs, b0, if7, init})
            6'b000_x_x_0: ns = 3'b000;
            6'b000_x_x_1: ns = 3'b001;
            6'b001_0_0_x: ns = 3'b010;
            6'b001_0_1_x: ns = 3'b011;
            6'b001_1_0_x: ns = 3'b100;   
            6'b001_1_1_x: ns = 3'b101;
            6'b010_x_x_x: ns = 3'b001;
            6'b011_x_x_x: ns = 3'b000;
            6'b100_x_x_x: ns = 3'b001;
            6'b101_x_x_x: ns = 3'b000;
            default: ns = 3'b000;
        endcase
    
    always @(cs)
        case(cs)
            3'b000: ready = 1'b1;
            3'b001: begin sha = 1'b0; shb = 1'b0; incc = 1'b0; plrez = 1'b0; sum = 1'b0; done = 1'b0; ready = 1'b0; end
            3'b100: begin sum = 1'b1; sha = 1'b1; shb = 1'b1; incc = 1'b1; plrez = 1'b1; done = 1'b0; ready = 1'b0; end
            3'b101: begin sum = 1'b1; sha = 1'b0; shb = 1'b0; incc = 1'b0; plrez = 1'b1; done = 1'b1; ready = 1'b0; end
            3'b010: begin sum = 1'b0; sha = 1'b1; shb = 1'b1; incc = 1'b1; plrez = 1'b0; done = 1'b0; ready = 1'b0; end
            3'b011: begin sum = 1'b0; sha = 1'b0; shb = 1'b0; incc = 1'b0; plrez = 1'b1; done = 1'b1; ready = 1'b0; end
        endcase
    
endmodule

