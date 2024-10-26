`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2024 12:49:06 PM
// Design Name: 
// Module Name: top
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


// Top-level module connecting submodules
module top(
    input clk,
    input ld_sync_op,
    input disp_btn,
    input [7:0] a,
    input [7:0] b,
    output [15:0] rez_display
    );
    
    wire [15:0] a_reg;
    wire[7:0] b_reg;
    wire ld_sync_op_out, disp_btn_out;       
    wire ld_sync_op_out_final, disp_btn_out_final;      
    wire pla, plb, init; 
    wire if7, b0, incc, plrez, sum, sha, shb, ready;
    wire [15:0] rez_reg;
    wire [15:0] out_sum;
    wire [1:0] sel;
    
    // Sync buttons
    sync u_sync (.clk(clk), .in(ld_sync_op), .out(ld_sync_op_out));
    sync u2_sync (.clk(clk), .in(disp_btn), .out(disp_btn_out));
    
    // One period buttons
    one_period u_one_period (.clk(clk), .in(ld_sync_op_out), .out(ld_sync_op_out_final));
    one_period u2_one_period (.clk(clk), .in(disp_btn_out), .out(disp_btn_out_final));
    
    // Buttons that change states
    pl_gen u_pl_gen(.clk(clk), .ld_sync_op(ld_sync_op_out_final), .ready(ready), .pla(pla), .plb(plb), .init(init));
    display_gen u_display_gen(.clk(clk), .disp_btn(disp_btn_out_final), .sel(sel));
    
    // Registers
    shift_register_left u_shift_register_left(.clk(clk), .pl(pla), .en(sha), .data_in({8'b00000000, a}), .ShiftIn(1'b0), .data_out(a_reg));
    shift_register_right u_shift_register_right(.clk(clk), .pl(plb), .en(shb), .data_in(b), .ShiftIn(1'b0), .data_out(b_reg), .ShiftOut(b0));
    reg16 u_reg16(.clk(clk), .reset(init), .pl(plrez), .di(out_sum), .do(rez_reg));
    
    // Counter
    counter u_counter(.clk(clk), .rst(init), .inc(incc), .if7(if7));
    
    // Adder
    adder u_adder(.datain1(rez_reg), .datain2({8'b00000000, a_reg}), .dataout(out_sum));
    
    // Main state machine
    secv u_secv(.clk(clk), .init(init), .b0(b0), .if7(if7), .sha(sha), .shb(shb), .incc(incc), .plrez(plrez), .sum(sum), .done(done), .ready(ready));
    
    // Out mux
    mux_3_1 u_mux_3_1(.in0(rez_reg), .in1(a_reg), .in2(b_reg), .sel(sel), .out(rez_display));
    
endmodule
