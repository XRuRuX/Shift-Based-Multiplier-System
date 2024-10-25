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


module top(
    input clk,
    input ready,
    input ld_sync_op,
    input [7:0] a,
    input [7:0] b
    );
    
    wire ld_sync_op_out;       
    wire ld_sync_op_out_final;      
    wire pla, plb, init; 
    wire [7:0] a_reg;
    wire[7:0] b_reg;
    wire if7;
    wire incc;
    wire plrez;
    wire b0;
    wire sum;
    wire [15:0] rez_reg;
    wire [15:0] out_sum;
    wire sha, shb;
    
    sync u_sync (.clk(clk), .in(ld_sync_op), .out(ld_sync_op_out));
    one_period u_one_period (.clk(clk), .in(ld_sync_op_out), .out(ld_sync_op_out_final));
    pl_gen u_pl_gen(.clk(clk), .ld_sync_op(ld_sync_op_out_final), .ready(ready), .pla(pla), .plb(plb), .init(init));
    shift_register_left u_shift_register_left(.clk(clk), .pl(pla), .en(sha), .data_in(a), .ShiftIn(1'b0), .data_out(a_reg));
    shift_register_right u_shift_register_right(.clk(clk), .pl(plb), .en(shb), .data_in(b), .ShiftIn(1'b0), .data_out(b_reg), .ShiftOut(b0));
    reg16 u_reg16(.clk(clk), .reset(init), .pl(plrez), .di(out_sum), .do(rez_reg));
    counter u_counter(.clk(clk), .rst(init), .inc(incc), .if7(if7));
    adder u_adder(.datain1(rez_reg), .datain2({8'b00000000, a_reg}), .dataout(out_sum));
    secv u_secv(.clk(clk), .init(init), .b0(b0), .if7(if7), .sha(sha), .shb(shb), .incc(incc), .plrez(plrez), .sum(sum), .done(done), .ready(ready));
    
    
endmodule
