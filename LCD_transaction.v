`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:00:41 04/28/2018 
// Design Name: 
// Module Name:    LCD_transaction 
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

module lcd_transaction(
	input	wire	      clk,
	input	wire	      reset,
	input	wire	      do_write_data,
	input	wire  [7:0] data_to_write,
	input	wire	      do_set_dd_ram_addr,
	input	wire	[6:0] dd_ram_addr,
	output reg	      LCDE_q,
	output reg	      LCDRS_q,
	output reg	      LCDRW_q,
	output reg	[3:0] LCDDAT_q,
	output reg        set_dd_ram_addr_done,
	output wire       send_data_done // pq aquest wire?
    );

	//Variables
	reg	[3:0]	state;
	reg	[3:0]	next_state;
  
	//Variables to physical
	reg       do_init;
	reg       do_send_data;
	reg [7:0] data_to_send;
	reg       lcdrs_in;

	//Variables from physical
	wire       init_done;
	wire       lcde;
	wire       lcdrs;
	wire       lcdrw;
	wire [3:0] lcddat;
 
	//States
	parameter	INIT	         =	4'h0;
	parameter	FUNCTION_SET	=	4'h1;
	parameter	ENTRY_MODE_SET	=	4'h2;
	parameter	DISPLAY_ON_OFF	=	4'h3;
	parameter	CLEAR_DISPLAY	=	4'h4;
 	parameter	IDLE	         =	4'h5;
	parameter	DO_WRITE_RAM	=	4'h6;
	parameter	DO_SET_ADDR	   =	4'h7;
  
  
	always @* begin
    //Defaults
    next_state 				= INIT;
    do_init						= 1'b0;
    do_send_data 				= 1'b0;
    data_to_send 				= 1'b0;
    lcdrs_in 					= 1'b0;
    set_dd_ram_addr_done 	= 1'b0;
	
	case(state)
      //Do initialization
      INIT: begin
                do_init = 1'b1;
                if(init_done == 1) begin
                    next_state = FUNCTION_SET;
						  do_init = 1'b0;
                end
                else begin
                    next_state = INIT; 
                end
             end
            
      //Function Set Command
      FUNCTION_SET: begin
                      do_send_data = 1'b1;
                      data_to_send = 8'h28;
                      lcdrs_in = 1'b0; //LCDRS value in Function Set Command
                      if(send_data_done) begin
                         next_state = ENTRY_MODE_SET;
                      end
                      else begin
                          next_state = FUNCTION_SET; 
                      end
                   end
                   
      //Entry Mode Set Command
      ENTRY_MODE_SET: begin 
                        do_send_data = 1'b1;
                        data_to_send = 8'h06;
                        lcdrs_in = 1'b0; //LCDRS value in Entry Mode Set Command
                        if(send_data_done) begin
                           next_state = DISPLAY_ON_OFF;
                        end
                        else begin
                            next_state = ENTRY_MODE_SET; 
                        end
                   end
      
      //Display ON/OFF command
      DISPLAY_ON_OFF: begin
                          do_send_data = 1'b1;
                          data_to_send = 8'h0F;
                          lcdrs_in = 1'b0; //LCDRS value in Display ON/OFF Command
                          if(send_data_done) begin
                             next_state = CLEAR_DISPLAY;
                          end
                          else begin
                              next_state = DISPLAY_ON_OFF; 
                          end
                      end
                   
      //Clear Display command
      CLEAR_DISPLAY: begin 
                          do_send_data = 1'b1;
                          data_to_send = 8'h01;
                          lcdrs_in = 1'b0; //LCDRS value in Clear Display Command
                          if(send_data_done) begin
                             next_state = IDLE;
                          end
                          else begin
                              next_state = CLEAR_DISPLAY; 
                          end
                      end
      //
      IDLE: begin 
                if(do_write_data) begin
                    next_state = DO_WRITE_RAM;
                end
                else if(do_set_dd_ram_addr) begin
                    next_state = DO_SET_ADDR;
                end
                else begin
                    next_state = IDLE;
                end
             end
      
      //Write Data to CG Ram or DD Ram Command
      DO_WRITE_RAM: begin
                        do_send_data = 1;
                        data_to_send = data_to_write;
                        lcdrs_in = 1'b1; //LCDRS value in Write Data to CG Ram or DD Ram Command
                        if(send_data_done) begin
                            next_state = IDLE;
                        end
                        else begin
                            next_state = DO_WRITE_RAM;
                        end
                     end
      
      //Set DD Ram Address Command
      DO_SET_ADDR: begin 
                        do_send_data = 1;
                        data_to_send = {1'b1, dd_ram_addr};
                        lcdrs_in = 1'b0; //LCDRS value in Set DD Ram Address Command
                        if(send_data_done) begin
                            next_state = IDLE;
                            set_dd_ram_addr_done = 1'b1;
                        end
                        else begin
                            next_state = DO_SET_ADDR;
                        end
                     end
      endcase
	end //always
  
  //Current state gets next state at the positive edge of the clock
  always @ (posedge clk or posedge reset) begin
               if(reset) begin
                    state <= INIT;
               end
               else begin
                    state <= next_state;
               end
  end //always 
  
  //Output values
  always @ (posedge clk or posedge reset) begin
               if(reset) begin
							LCDE_q    <= 1'b0;
							LCDRS_q   <= 1'b0;
							LCDRW_q   <= 1'b1; //LCDRW value for read
							LCDDAT_q  <= 4'h0;
               end
               else begin
							LCDE_q    <= lcde;
							LCDRS_q   <= lcdrs;
							LCDRW_q   <= lcdrw;
							LCDDAT_q  <= lcddat;
               end
  end 
  
  
  //Instantiate phyisical module
  lcd_physical lcd_physical(
     .clk(clk),
     .reset(reset),
     .do_init(do_init), 
     .do_send_data(do_send_data), 
     .data_to_send(data_to_send),
     .lcdrs_in(lcdrs_in),
     .init_done(init_done),     
     .lcde(lcde),  
     .lcdrs(lcdrs), 
     .lcdrw(lcdrw), 
     .lcddat(lcddat),
     .send_data_done(send_data_done)
        );

endmodule
	