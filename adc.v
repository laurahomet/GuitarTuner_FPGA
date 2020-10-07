`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:33 05/04/2018 
// Design Name: 
// Module Name:    adc 
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

module adc(

	input wire spimiso, // SPI read data 
	input wire clk,
	input wire reset,	// Active high
	input wire get_rdid, // Flag telling us to Get Identification
	output reg spisck,  // SPI clock
	output reg prom_cs, // PROM chip select, active high 
	output wire [7:0] sample_left, // Aclarir més endavant
	output wire [7:0] sample_right, // Aclarir més endavant
	output reg enable_adc,
	output reg adc_done
	);

	reg [2:0] current_state, next_state;
	reg [2:0] send_count;
	reg [5:0] get_count;
	reg enable_get_count, enable_send_count;
	reg assert_prom_cs_n;
	reg [33:0] read_data;
	wire spimosi;

	localparam [2:0] SEND_COUNT_MAX = 3'h0; //ADC no envia res
	localparam [5:0] GET_COUNT_MAX = 6'd34;
	localparam [7:0] RDID_CMD = 8'h0; //ADC no envia res
	localparam [2:0] IDLE = 3'd0,

	ASSERT_CS 			= 3'd1,
	SEND_INSTRUCTION 	= 3'd2,
	GET_DATA 			= 3'd3,
	DEASSERT_CS 		= 3'd4;
	
	assign	sample_left = read_data[31:26];
	assign	sample_right = read_data[25:18];
	
	//assign	sample_left = read_data[15:10];
	//assign	sample_right = read_data[9:2];

	always @* begin

		// Defaults
		next_state 			= IDLE;
		enable_send_count = 1'b0;
		enable_get_count 	= 1'b0;
		assert_prom_cs_n 	= 1'b0;

		case (current_state)

			//	Remain in idle until told to get do RDID 
			IDLE: begin
						enable_adc = 1'b0; 
						adc_done = 1;
						if (get_rdid)
							next_state = ASSERT_CS;
						else
							next_state = IDLE;
					end
					
			//	Assert chip select in it's own state to meet chip select assertion setup time 
			ASSERT_CS: begin
										next_state = SEND_INSTRUCTION; 
              						assert_prom_cs_n = 1'b1;
										enable_adc = 1'b1;
										adc_done = 0;
						  end
						  
			//	Provide clocks to send the instructions
			SEND_INSTRUCTION: begin
										enable_send_count = 1'b1;
										assert_prom_cs_n = 1'b0;
										enable_adc = 1'b1;
										if (send_count == 0) begin
											next_state = GET_DATA;
											enable_send_count = 1'b0;
										end
										else
											next_state = SEND_INSTRUCTION;
										end
                    
			// Provide clocks to get the data 
      	GET_DATA: begin         
						    enable_get_count = 1'b1;         
						    assert_prom_cs_n = 1'b0;
							enable_adc = 1'b1;
							 
						    if (get_count == 63) begin         
						      next_state = DEASSERT_CS;
								enable_get_count = 1'b0;
								adc_done = 1;
							 end
						    else 
						      next_state = GET_DATA;       
						    end 

			//	Deassert chip select in it's own state to meet chip select deassertion setup time 
			DEASSERT_CS: begin
								assert_prom_cs_n = 1'b0;
								enable_adc = 1'b0; 
								next_state = IDLE;
							 end
						 
		endcase
		
	end //always
	
	//	Need a register so the chip select doesn't glitch 
	always @(posedge clk or posedge reset) begin
		if (reset)
			prom_cs <= 1'b0;
		else if (assert_prom_cs_n) 
			prom_cs <= 1'b1;
		else
			prom_cs <= 1'b0; 
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
	always @(posedge spisck or posedge reset) begin
	if (reset)
		read_data <= 24'b0;
	else
		read_data[get_count] <= spimiso;
	end

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
	assign spimosi = RDID_CMD[send_count];
	
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

