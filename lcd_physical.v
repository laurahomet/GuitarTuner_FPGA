`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:00:50 04/28/2018 
// Design Name: 
// Module Name:    LCD_physical 
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
module lcd_physical(
	input	wire			clk,
	input	wire			reset,
	input	wire			do_init,
	input	wire			do_send_data,
	input	wire	[7:0] data_to_send,
	input	wire			lcdrs_in,
	output reg			init_done,
	output reg			lcde,
	output wire			lcdrs,
	output wire			lcdrw,
	output reg	[3:0] lcddat,
	output reg			send_data_done
    );

	//Variables
	reg		[3:0]	state;
	reg		[3:0]	next_state;
	reg		[19:0]count; //to be able to represent 205000 dec value
	reg				reset_count;

	
	//States
	parameter	IDLE				=	4'h0;
	parameter	ASSERT_LCDE_1	=	4'h1;
	parameter	WAIT_4_1MS		=	4'h2;
	parameter	ASSERT_LCDE_2	=	4'h3;
	parameter	WAIT_100US		=	4'h4;
	parameter	ASSERT_LCDE_3	=	4'h5;
	parameter	WAIT_40US_1		=	4'h6;
	parameter	ASSERT_LCDE_4	=	4'h7;
	parameter	WAIT_40US_2		=	4'h8;
	
	parameter	SEND_NIBBLE1			=	4'h9;
	parameter	ASSERT_LCDE_NIBBLE1	=	4'hA;
	parameter	BETWEEN_NIBBLES		=	4'hB;
	parameter	SEND_NIBBLE2			=	4'hC;
	parameter	ASSERT_LCDE_NIBBLE2	=	4'hD;
	parameter	WAIT_40US_AFTER_CMD	=	4'hE;

	assign	lcdrs  = lcdrs_in;
	assign	lcdrw  = 1'b0; //LCDRW value for write	
	
	always @* begin
	//Defaults
	next_state 		= IDLE;
	init_done 		= 1'b0;
	send_data_done = 1'b0;
	lcde 				= 1'b0;
	lcddat			= 8'h00;
	reset_count 	= 1'b0;

	case(state)
	      //Remain in IDLE until told to do_init or do_send_data
	      IDLE: begin
						if(do_init) begin
							 next_state = ASSERT_LCDE_1;
							 reset_count = 1'b1;
						end
						else if(do_send_data) begin
							 next_state = SEND_NIBBLE1;
							 reset_count = 1'b1;
							 send_data_done = 1'b0;
						end
						else begin
							 next_state = IDLE;
						end
					end

	      //Initialization - Pulse LCDE for at least 240ns
	      ASSERT_LCDE_1: begin
									lcddat = 4'h3;
									if(count == 24) begin //12 clk cycles correspond to 240ns //24
										 lcde = 1'b0;
										 next_state = WAIT_4_1MS;
										 reset_count = 1'b1;
									end
									else begin
										 lcde = 1'b1;
										 next_state = ASSERT_LCDE_1;
									end
								end

	      //Initialization - Wait at least 4.1ms
	      WAIT_4_1MS: begin
								lcddat = 4'h3;
								if(count == 250000) begin //205000 clk cycles correspond to 4100000ns = 4.1ms //410000
									next_state = ASSERT_LCDE_2;
									reset_count = 1'b1;
								end
								else begin
									next_state = WAIT_4_1MS;
								end
							end

	      //Initialization - Pulse LCDE for at least 240ns
	      ASSERT_LCDE_2: begin
									lcddat = 4'h3;
									if(count == 24) begin //12 clk cycles correspond to 240ns //24
										 lcde = 1'b0;
										 next_state = WAIT_100US;
										 reset_count = 1'b1;
									end
									else begin
										 lcde = 1'b1;
										 next_state = ASSERT_LCDE_2;
									end
								end

	      //Initialization - Wait at least 100us
	      WAIT_100US: begin
								lcddat = 4'h3;
								if(count == 10000) begin //5000 clk cycles correspond to 100000 ns = 100us //10000
									next_state = ASSERT_LCDE_3;
									reset_count = 1'b1;
								end
								else begin
									next_state = WAIT_100US;
								end
							end

	      //Initialization - Pulse LCDE for at least 240ns
	      ASSERT_LCDE_3: begin
									lcddat = 4'h3;
									if(count == 24) begin //12 clk cycles correspond to 240ns //24
										 lcde = 1'b0;
										 next_state = WAIT_40US_1;
										 reset_count = 1'b1;
									end
									else begin
										 lcde = 1'b1;
										 next_state = ASSERT_LCDE_3;
									end
								end

	      //Initialization - Wait at least 40us
	      WAIT_40US_1: begin
								lcddat = 4'h3;
								if(count == 4000) begin //2000 clk cycles correspond to 40000 ns = 40us //4000
								  next_state = ASSERT_LCDE_4;
								  reset_count = 1'b1;
								end
								else begin
									next_state = WAIT_40US_1;
								end
							 end

	      //Initialization - Pulse LCDE for at least 240ns
	      ASSERT_LCDE_4: begin
									lcddat = 4'h2;
									if(count == 24) begin //12 clk cycles correspond to 240ns //24
										 lcde = 1'b0;
										 next_state = WAIT_40US_2;
										 reset_count = 1'b1;
									end
									else begin
										 lcde = 1'b1;
										 next_state = ASSERT_LCDE_4;
									end
								end

	      //Initialization - Wait at least 40us
	      WAIT_40US_2: begin
								lcddat = 4'h2;
								if(count == 4000) begin //2000 clk cycles correspond to 40000 ns = 40us //4000
								  next_state = IDLE;
								  reset_count = 1'b1;
								  init_done = 1;
								end
								else begin
									next_state = WAIT_40US_2;
								end
							 end

	      //Send data - Store data_to_send at data lines to send the first nibble
	      SEND_NIBBLE1: begin
									lcde = 1'b0;
									lcddat = data_to_send[7:4];
									next_state = ASSERT_LCDE_NIBBLE1;
									reset_count = 1'b1;
							  end

	      //Send data - Send the first nibble
	      ASSERT_LCDE_NIBBLE1: begin
											lcde = 1'b1;
											lcddat = data_to_send[7:4];
											if(count == 24) begin //12 clk cycles correspond to 240ns //24
												lcde = 1'b0;
												next_state = BETWEEN_NIBBLES;
												reset_count = 1'b1;
											end
											else begin
												next_state = ASSERT_LCDE_NIBBLE1;
											end
										 end

	      //Send data - Wait for 1us between nibbles
	      BETWEEN_NIBBLES: begin
									  lcde = 1'b0;
									  lcddat = data_to_send[7:4];
									  if(count == 100) begin //50 clk cycles correspond to 1000ns = 1us //100
											next_state = SEND_NIBBLE2;
											reset_count = 1'b1;
									  end
									  else begin
											next_state = BETWEEN_NIBBLES;
									  end
									end

	      //Send data - Store data_to_send at data lines to send the second nibble
	      SEND_NIBBLE2: begin
									lcde = 1'b0;
									lcddat = data_to_send[3:0];
									next_state = ASSERT_LCDE_NIBBLE2;
									reset_count = 1'b1;
							  end

	      //Send data - Send the second nibble
	      ASSERT_LCDE_NIBBLE2: begin
											lcde = 1'b1;
											lcddat = data_to_send[3:0];
											if(count == 24) begin //12 clk cycles correspond to 240ns //24
												  lcde = 1'b0;
												  next_state = WAIT_40US_AFTER_CMD;
												  reset_count = 1'b1;
											end
											else begin
												  next_state = ASSERT_LCDE_NIBBLE2;
												  lcde = 1'b1;
											end
										 end

	      //Send data - Wait for 40us
	      WAIT_40US_AFTER_CMD: begin
											lcde = 1'b0;
											lcddat = data_to_send[3:0];
											if(count == 4000) begin //2000 clk cycles correspond to 40000 ns = 40us //4000
												  next_state = IDLE;
												  reset_count = 1'b1;
												  send_data_done = 1'b1;
											end
											else begin
												next_state = WAIT_40US_AFTER_CMD;
											end
										end
	      endcase
	end //always
	
	//Current state gets next state at the positive edge of the clock
	always @ (posedge clk or posedge reset) begin
				 if(reset) begin
						state <= IDLE;
				 end
				 else begin
						state <= next_state;
				 end
	end //always 

	//Counter design
   always @(posedge clk or posedge reset)
			begin
             if(reset) begin
                  count <= 0;
             end
             else if(reset_count) begin
                  count <= 0;
             end
             else begin
                  count <= count + 1;
         end
	end //always 

endmodule
