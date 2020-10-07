`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:11:16 05/04/2018 
// Design Name: 
// Module Name:    preamp 
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
`default_nettype none

module preamp(

	//input wire spimiso, // SPI read data 
	input wire clk,
	input wire reset,	// Active high
	input wire get_rdid, // Flag telling us to Get Identification
	input wire [7:0] gain,
	output reg spisck,  // SPI clock
	output wire spimosi,  // SPI Data to write  //output wire spimosi,
	output reg prom_cs_n // PROM chip select, active low 
	);

	reg [2:0] current_state, next_state;
	reg [2:0] send_count;
	reg [4:0] get_count;
	reg enable_get_count, enable_send_count;
	reg assert_prom_cs_n;
	//reg [33:0] read_data;
	

	localparam [2:0] SEND_COUNT_MAX = 3'h7; //or 8?
	localparam [4:0] GET_COUNT_MAX = 5'd0; //Preamp does not receive
	//localparam [7:0] RDID_CMD = 8'h0;
	localparam [2:0] IDLE = 3'd0,

	ASSERT_CS 			= 3'd1,
	SEND_INSTRUCTION 	= 3'd2,
	GET_DATA 			= 3'd3,
	DEASSERT_CS 		= 3'd4;
  
  //No read data

	always @* begin

		// Defaults
		next_state 			= IDLE;
		enable_send_count = 1'b0;
		enable_get_count 	= 1'b0;
		assert_prom_cs_n 	= 1'b0;

		case (current_state)

			//	Remain in idle until told to get do RDID 
			IDLE: begin
						if (get_rdid)
							next_state = ASSERT_CS;
						else
							next_state = IDLE; 
					end
					
			//	Assert chip select in it's own state to meet chip select assertion setup time 
			ASSERT_CS: begin
							next_state = SEND_INSTRUCTION; 
              						assert_prom_cs_n = 1'b1;
						  end
						  
			//	Provide clocks to send the instructions
			SEND_INSTRUCTION: begin
										enable_send_count = 1'b1;
										assert_prom_cs_n = 1'b1;
										if (send_count == 0)
											next_state = GET_DATA;
										else
											next_state = SEND_INSTRUCTION;
										end
                    
			// Provide clocks to get the data 
      			GET_DATA: begin         
						    enable_get_count = 1'b1;         
						    assert_prom_cs_n = 1'b0;         
						    if (get_count == 0)           
						      next_state = DEASSERT_CS; 
						    else 
						      next_state = GET_DATA;       
						    end 

			//	Deassert chip select in it's own state to meet chip select deassertion setup time 
			DEASSERT_CS: begin
								assert_prom_cs_n = 1'b0; 
								next_state = IDLE;
							 end
						 
		endcase
		
	end //always
	
	//	Need a register so the chip select doesn't glitch 
	always @(posedge clk or posedge reset) begin
		if (reset)
			prom_cs_n <= 1'b1;
		else if (assert_prom_cs_n) 
			prom_cs_n <= 1'b0;
		else
			prom_cs_n <= 1'b1; 
	end //always

	//	Current state gets next state at the positive edge of the clock 
	always @(posedge clk or posedge reset) begin
		if (reset)
			current_state <= IDLE; 
		else
			current_state <= next_state; 
	end //always

	//	maintain a count of the spisck's we've provided sending 
	always @(posedge clk or posedge reset) begin
		if (reset)
			send_count <= SEND_COUNT_MAX;
			//	Reset counter every time we're asked to get the ID again. 
			else if (get_rdid)
				send_count <= SEND_COUNT_MAX; 
			else if (enable_send_count && spisck)
				send_count <= send_count - 1'b1;
			end

	//	maintain a count of the spisck's we've provided getting 
	always @(posedge clk or posedge reset) begin
		if (reset)
			get_count <= GET_COUNT_MAX;
			//	Reset counter every time we're asked to get the ID again. 
			else if (get_rdid)
				get_count <= GET_COUNT_MAX;
			else if (enable_get_count && spisck)
				get_count <= get_count - 1'b1;
			end
			
	// Collect read_data
	/* always @(posedge spisck or posedge reset) begin
	if (reset)
		read_data <= 24'b0;
	else
		read_data[get_count] <= spimiso;
	end */

	//	Toggle spi_sck. Need a register so the clock doesn't glitch 
	always @(posedge clk or posedge reset) begin
		if (reset) 
			spisck <= 1'b0;
		else if (enable_send_count || enable_get_count) 
			spisck <= !spisck;
		else if (get_rdid) 
			spisck <= 1'b0;
	end

	//	spimosi is just an index into the RDID_CMD vector 
	assign spimosi = gain[send_count];
	
	//synopsys_translate off
	reg [95:0] ASCII_current_state, ASCII_next_state; // Hold 12 characters (8*12=96)
	
	always @* begin
		case (current_state)
			IDLE: ASCII_current_state = "IDLE";
			ASSERT_CS: ASCII_current_state = "ASSERT_CS";
			SEND_INSTRUCTION: ASCII_current_state = "SEND_INSTRUCTION";
			GET_DATA: ASCII_current_state = "GET_DATA";
			DEASSERT_CS: ASCII_current_state = "DEASSERT_CS"; 
		endcase
	end //always
	
	always @* begin
		case (next_state)
			IDLE: ASCII_next_state = "IDLE";
			ASSERT_CS: ASCII_next_state = "ASSERT_CS";
			SEND_INSTRUCTION: ASCII_next_state = "SEND_INSTRUCTION";
			GET_DATA: ASCII_next_state = "GET_DATA";
			DEASSERT_CS: ASCII_next_state = "DEASSERT_CS";
		endcase
	end
	//synopsys_translate on
	
endmodule

