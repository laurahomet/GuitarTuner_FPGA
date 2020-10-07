`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:00:26 04/28/2018 
// Design Name: 
// Module Name:    LCD_out 
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
module LCD_out(
	input	wire	      clk,
	input	wire	      rst,
	input wire 			start_tuning,
	input wire [4:0]	note,
	output wire 		LCDE,
	output wire 		LCDRS,
	output wire 		LCDRW,	
	output wire [3:0] LCDDAT
    );
	
	
	//Variables
	reg	[3:0]	state;
	reg	[3:0]	next_state;
	reg	[7:0] count; //Counter from 128 to 0
	reg			count_down; //Asserts when we want count = count - 8
	reg			reset_count;
	reg			line;
	reg			next_line;
	wire	[127:0] line0;
	wire	[127:0] line1; 
  
	//Variables to transaction
	reg       	do_write_data;
	reg  	[7:0] data_to_write;
	reg 		 	do_set_dd_ram_addr;
	reg	[6:0] dd_ram_addr;

	//Variables from transaction
	wire			set_dd_ram_addr_done;
	wire			send_data_done;


	//Instantiate transaction
	lcd_transaction lcd_transaction (
    .clk(clk),
    .reset(rst), 
    .do_write_data(do_write_data), 
    .data_to_write(data_to_write), 
    .do_set_dd_ram_addr(do_set_dd_ram_addr), 
    .dd_ram_addr(dd_ram_addr), 
    .LCDE_q(LCDE), 
    .LCDRS_q(LCDRS), 
    .LCDRW_q(LCDRW), 
    .LCDDAT_q(LCDDAT), 
    .set_dd_ram_addr_done(set_dd_ram_addr_done), 
    .send_data_done(send_data_done)
    );


   //LCD_rows - CG ROM Values for our characters
	parameter	C				=	8'b01000011;
	parameter	D				=	8'b01000100;
	parameter	E				=	8'b01000101;
	parameter	F				=	8'b01000110;
	parameter	G				=	8'b01000111;
	parameter	A				=	8'b01000001;
	parameter	B				=	8'b01000010;
	parameter   white_space =  8'b11111110;
	parameter 	Y				=  8'b01011001;
	parameter	O				=  8'b01001111;
	parameter	U				=  8'b01010101;
	parameter	R				=  8'b01010010;
	parameter	N				=  8'b01001110;
	parameter	T				=  8'b01010100;
	parameter	I				=  8'b01001001;
	parameter	S				=  8'b01010011;
	parameter	dot			=  8'b00101110;
	
  
	//LCD_rows - cg_rom_value function regarding CG ROM Table
	function [7:0] cg_rom_value (
		input	[4:0] note
		);
			case(note)
				5'd0: cg_rom_value = white_space;
				5'd1: cg_rom_value = C; //C
				5'd2: cg_rom_value = D;
				5'd3: cg_rom_value = E;
				5'd4: cg_rom_value = F;
				5'd5: cg_rom_value = G;
				5'd6: cg_rom_value = A;
				5'd7: cg_rom_value = B;
			endcase
	endfunction
		
		
	//LCD Display characters
			assign line0 = {Y, O, U, R, white_space, N, O, T, E, white_space, I, S, dot, dot, dot, white_space};
			assign line1 = {cg_rom_value(note), white_space, white_space, white_space, white_space, white_space, white_space, white_space, white_space, white_space, white_space, white_space, white_space, white_space, white_space, white_space};
      
		//States
	parameter	IDLE	       		  	=	4'h0;
	parameter	WAIT_GET_RDID_DONE	=	4'h1;
	parameter	SEND_BYTE				=	4'h2;
	parameter	WAIT_DONE				=	4'h3;
	parameter	SET_ADDR					=	4'h4;
	
		
	always @ (*) begin
   //Defaults
   next_state 					= IDLE;
	reset_count 				= 1'b0;
	next_line 					= 1'b0;
	count_down					= 1'b0;
	do_write_data				= 1'b0;
	data_to_write				= 8'hZZ;
	do_set_dd_ram_addr		= 1'b0;
	
	case(state)
      
      IDLE: begin
					do_write_data = 1'b0;
					do_set_dd_ram_addr = 1'b0;
					if(start_tuning) begin
						next_state = SEND_BYTE;
						reset_count = 1'b1;
					end
					else begin
						next_state = IDLE;
					end
				end
      
		SEND_BYTE: begin
					if(count != 255) begin
						next_state = WAIT_DONE;
						do_write_data = 1'b1;
						count_down = 1'b0;
					end
					else begin
						next_state = SET_ADDR;
						do_set_dd_ram_addr = 1'b1;
						reset_count = 1'b1;
						next_line = 1'b1;
					end
				end
				
		
      WAIT_DONE: begin
					if(line == 0) begin
							data_to_write = line0[count-:8];
					end
					else /*if(line == 1)*/ begin
						data_to_write = line1[count-:8];
					end 
					if(send_data_done) begin
						next_state = SEND_BYTE;
						count_down = 1'b1;
					end
					else begin
						next_state = WAIT_DONE;
					end
				end
		
		//
      SET_ADDR: begin
							count_down = 1'b0;
							if(line == 1) begin
								dd_ram_addr = 7'b1000000; //0x40
							end
							else begin
								dd_ram_addr = 7'b0000000; //0x00
							end
							if((line == 1) && (set_dd_ram_addr_done == 1)) begin
								next_state = SEND_BYTE;
							end
							else if((line == 0) && (set_dd_ram_addr_done == 1)) begin
								next_state = IDLE;
							end
							else begin
								next_state = SET_ADDR;
							end
					 end
					 
		endcase
		
	end //always
	
	//Current state gets next state at the positive edge of the clock
	always @ (posedge clk or posedge rst) begin
		if(rst) begin
			state <= IDLE;
      end
		else begin
			state <= next_state;
      end
  end //always 
  
  
	//Lines transition design
	always@(posedge clk or posedge rst) begin
		if	(rst) begin
			line <= 1'b0;
		end
		else if (next_line) begin
			line <= ~line;
		end
	end
	
	
	//Counter design
	always@(posedge clk or posedge rst) begin
		if	(rst) begin
			count <= 8'd127;
		end
		else if (reset_count) begin
			count <= 8'd127;
		end
		else if (count_down) begin
			count <= count - 8;
		end
	end

endmodule
