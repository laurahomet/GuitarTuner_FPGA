`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:54:48 05/04/2018 
// Design Name: 
// Module Name:    get_period 
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
module get_period(
	input wire clk,
	input wire wave,
	output reg [33:0] period
    );

	
	//Variables
	reg [33:0] counter = 0;
	reg pos_wave;
	
	localparam WAIT = 0;
	localparam GET_PERIOD = 1;
	
	reg state = WAIT;
	reg next_state;
	
	reg reset_counter = 0;
	reg rst_pos_wave = 0;

	
	always@(posedge clk) begin
		case(state)
			WAIT: begin
						reset_counter = 0;
						rst_pos_wave = 0;
						if(pos_wave) begin
							next_state = GET_PERIOD;
						end
						else
							next_state = WAIT;
					end
			
			GET_PERIOD: begin
								period = ((counter+1)*100); //ns
								reset_counter = 1; 
								next_state = WAIT;
								rst_pos_wave = 1;
							end
		endcase
	end
	
	//states
	always@(posedge clk) begin
		state = next_state;
	end
	
	//counter
	always@(posedge clk) begin
		if(reset_counter)
			counter = 0;
		else
			counter = counter + 1;
	end

	//pos_wave
	always@(posedge wave or posedge rst_pos_wave) begin
		if(rst_pos_wave)
			pos_wave = 0;
		else
		if(wave)
			pos_wave = 1;
	end

	
endmodule
