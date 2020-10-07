`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:31:58 04/28/2018 
// Design Name: 
// Module Name:    LED_out 
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
module LED_out(
	input wire [3:0]	tone,
	output reg [7:0]  LED
    );

	localparam [3:0] DEFAULT	= 4'h0;
	localparam [3:0] FLAT_3		= 4'h1;
	localparam [3:0] FLAT_2		= 4'h2;
	localparam [3:0] FLAT_1		= 4'h3;
	localparam [3:0] ON_PITCH	= 4'h4;
	localparam [3:0] SHARP_1	= 4'h5;
	localparam [3:0] SHARP_2	= 4'h6;
	localparam [3:0] SHARP_3	= 4'h7;
	
	
	always @ (tone) begin
		case (tone)
			DEFAULT:		LED = 8'b00000000;
			FLAT_3:		LED = 8'b11000000;
			FLAT_2:		LED = 8'b01100000;
			FLAT_1:		LED = 8'b00110000;
			ON_PITCH:	LED = 8'b00011000;
			SHARP_1:		LED = 8'b00001100;
			SHARP_2:		LED = 8'b00000110;
			SHARP_3:		LED = 8'b00000011;			
		endcase
	end //always


endmodule
