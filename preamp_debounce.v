`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:08:12 05/04/2018 
// Design Name: 
// Module Name:    preamp_debounce 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module preamp_debounce(
	input wire			clk,
	input wire			rst,
	input wire			get_rdid,
   output reg			get_rdid_debounce
    );

	//Variables
	reg get_rdid_q;
	
	always@(posedge clk or posedge rst)
		begin
			if(rst)
				begin
					get_rdid_q <= 1'b0;
				end
			else
				begin
					get_rdid_q <= get_rdid;
				end
		end
				
	always@(posedge clk or posedge rst)
		begin
			if(rst)
				begin
					get_rdid_debounce <= 1'b0;
				end
			else
				begin
					get_rdid_debounce <= get_rdid_q;
				end
		end

endmodule