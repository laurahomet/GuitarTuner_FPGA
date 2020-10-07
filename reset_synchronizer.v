`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:07:58 05/04/2018 
// Design Name: 
// Module Name:    reset_synchronizer 
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
module reset_synchronizer(
	input wire			clk,
	input wire			rst,
   output reg			reset_sync
    );
 
	always@(posedge clk or posedge rst)
		begin
			if(rst)
				begin
					reset_sync <= rst;
				end
			else
				begin
					reset_sync <= 1'b0;
				end
		end
		
endmodule
