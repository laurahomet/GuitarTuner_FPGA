`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:08:23 05/04/2018 
// Design Name: 
// Module Name:    preamp_oneshot 
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
module preamp_oneshot(
	input wire			clk,
	input wire			rst,
	input wire			get_rdid_debounce,
   output wire			get_rdid_oneshot
    );

	//Variables
	reg	get_rdid_debounce_q;
	
	always@(posedge clk or posedge rst)
		begin
			if(rst)
				begin
					get_rdid_debounce_q <= 1'b0;
				end
			else
				begin
					get_rdid_debounce_q <= get_rdid_debounce;
				end
		end
		
	assign get_rdid_oneshot = ((!get_rdid_debounce_q)&&(get_rdid_debounce));
	
endmodule
