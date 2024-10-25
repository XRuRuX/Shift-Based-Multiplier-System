`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2024 01:04:47 PM
// Design Name: 
// Module Name: data_path
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

`define DATA_WIDTH 16


// Synchronizes input 'in' with clock 'clk', outputting it as 'out' on each rising edge
module sync(clk, in, out);
	input clk, in;
	output reg out;
	reg n;

	always @(posedge clk)
	begin
		n <= in;
		out <= n;
	end
	
endmodule


// Generates a single clock cycle output high ('out') when 'in' goes high, regardless of its duration
module one_period(clk, in, out);
	input clk, in;
	output out;
	reg [1:0] cs = 2'b00, ns;

	always @(posedge clk)
		cs <= ns;

	always @(cs or in)
		case({cs,in})
			3'b00_0: ns = 2'b00;
			3'b00_1: ns = 2'b01;
			3'b01_0: ns = 2'b00;
			3'b01_1: ns = 2'b10;
			3'b10_1: ns = 2'b10;
			3'b10_0: ns = 2'b00;
			default: ns = 2'b00;
		endcase

	assign out = (cs == 2'b01);
	
endmodule


// 16-bit register that loads 'di' on 'pl' and resets to 0 on 'reset'
module reg16(clk, reset, pl, di, do);
	input clk, reset, pl;
	input [15:0] di;
	output reg [15:0] do;

	always @(posedge clk)
		if(reset)
			do <= 16'b0;
		else
			if(pl)
				do <= di;
				
endmodule


// 8-bit right shift register that loads 'data_in' on 'pl' and shifts right on 'en', with 'ShiftOut' as the least significant bit
module shift_register_right (clk, reset, pl, en, data_in, ShiftIn, data_out, ShiftOut); 
    input clk, reset, pl, en, ShiftIn;              
    input [7:0] data_in;     
    output reg [7:0] data_out;
    output reg ShiftOut;  

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b00000000; 
        end else if (pl) begin
            data_out <= data_in;
            ShiftOut <= data_out[0];    // ShiftOut receives the least significant bit     
        end else if (en) begin
            // Shift right
            ShiftOut <= data_out[1];    // ShiftOut receives the least significant bit
            data_out <= {ShiftIn, data_out[7:1]}; // Shift, ShiftIn is MSB
        end
    end
    
endmodule


// 16-bit left shift register that loads 'data_in' on 'pl' and shifts left on 'en', with 'ShiftOut' as the most significant bit
module shift_register_left (clk, reset, pl, en, data_in, ShiftIn, data_out, ShiftOut); 
    input clk, reset, pl, en, ShiftIn;              
    input [15:0] data_in;     
    output reg [15:0] data_out;
    output reg ShiftOut;  

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 15'b0000000000000000; 
            ShiftOut <= 1'b0;
        end else if (pl) begin
            data_out <= data_in;     
        end else if (en) begin
            // Shift left
            ShiftOut <= data_out[15];    // ShiftOut gets the most significant bit
            data_out <= {data_out[14:0], ShiftIn}; // Shift, ShiftIn is LSB
        end
    end
    
endmodule


// 8-bit counter that increments on 'inc', resets on 'rst', and sets 'if7' high when 'out' reaches 7
module counter(clk, rst, inc, if7, out);
  input clk, rst, inc;
  output reg if7;
  output reg [7:0] out;
  
  always @(posedge clk)
    if (rst) begin
      out <= 8'b00000000; 
      if7 <= 1'b0;
    end
    else if (inc) begin
      out <= out + 1; 
      if (out == 8'b00000111)
        if7 <= 1'b1;  // Set if7 to 1 if the counter counted up to 7
      else
        if7 <= 1'b0; 
    end
    
endmodule


module adder(datain1, datain2, dataout);
  input [`DATA_WIDTH-1:0] datain1, datain2;
  output [`DATA_WIDTH-1:0] dataout;

  assign dataout = datain1 + datain2; 
  
endmodule


