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
            ShiftOut <= data_out[0];    // ShiftOut primeste bitul cel mai putin semnificativ     
        end else if (en) begin
            //Shiftare la dreapta
            ShiftOut <= data_out[1];    // ShiftOut primeste bitul cel mai putin semnificativ
            data_out <= {ShiftIn, data_out[7:1]}; // Shiftare, ShiftIn e MSB
        end
    end
endmodule

module shift_register_left (clk, reset, pl, en, data_in, ShiftIn, data_out, ShiftOut); 
    input clk, reset, pl, en, ShiftIn;              
    input [7:0] data_in;     
    output reg [7:0] data_out;
    output reg ShiftOut;  

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b00000000; 
            ShiftOut <= 1'b0;
        end else if (pl) begin
            data_out <= data_in;     
        end else if (en) begin
            //Shiftare la stanga
            ShiftOut <= data_out[7];    // ShiftOut primeste bitul cel mai semnificativ
            data_out <= {data_out[6:0], ShiftIn}; // Shiftare, ShiftIn e LSB
        end
    end
endmodule

module counter(clk, rst, inc, if7, out);
  input clk, rst, inc;
  output reg if7;
  output reg [7:0] out;
  
  always @(posedge clk)
    if (rst) begin
      out <= 8'b00000000;  // Resetăm contorul la 0
      if7 <= 1'b0;
    end
    else if (inc) begin
      out <= out + 1;  // Incrementează doar dacă inc este activ
      if (out == 8'b00000111)
        if7 <= 1'b1;  // Setăm if7 la 1 dacă out este 7
      else
        if7 <= 1'b0;  // În caz contrar, setăm if7 la 0
    end
endmodule

`define DATA_WIDTH 16
module adder(datain1, datain2, dataout);
  input [`DATA_WIDTH-1:0] datain1, datain2;
  output [`DATA_WIDTH-1:0] dataout;

  assign dataout = datain1 + datain2; 
endmodule


