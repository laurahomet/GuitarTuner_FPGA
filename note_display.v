`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:31:18 04/28/2018 
// Design Name: 
// Module Name:    note_display 
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
module note_display(
	input wire clk,
	input wire rst,
	input wire [33:0] period,
	input wire start_tuning,
	output wire [7:0] LED,
	output wire 		LCDE,
	output wire 		LCDRS,
	output wire 		LCDRW,	
	output wire [3:0] LCDDAT
    );

	wire [3:0] tone;
	wire [4:0] note;


	// Instantiate LED_out
	LED_out LED_out (
		 .tone(tone), 
		 .LED(LED)
		 );

	// Instantiate LCD_out
	LCD_out LCD_out (
    .clk(clk), 
    .rst(rst), 
    .start_tuning(start_tuning), 
	 .note(note),
    .LCDE(LCDE), 
    .LCDRS(LCDRS), 
    .LCDRW(LCDRW), 
    .LCDDAT(LCDDAT)
    );

	//Instantiate note_finder
	note_finder note_finder (
		 .period(period), 
		 .note(note), 
		 .tone(tone)
		 );


endmodule
