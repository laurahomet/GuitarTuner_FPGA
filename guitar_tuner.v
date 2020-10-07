`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:13:04 05/04/2018 
// Design Name: 
// Module Name:    guitar_tuner 
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
module guitar_tuner(
	input wire CCLK,
	input wire BTN_NORTH,
	//input wire BTN_EAST,
	//input wire wave, //****Uncomment for test bench 2
	input wire SW3,
   input wire SW2,
	input wire SW1,
   input wire SW0,
	input wire SPIMISO,
	output wire SPIMOSI,
	output wire SPISCK,
	output wire AMPCS,
	output wire DACCS,
	output wire ADCON,
	output wire SFCE,
	output wire FPGAIB,
	output wire AMPSD,
	output wire SPISF,
	output wire LD7,
	output wire LD6,
	output wire LD5,
	output wire LD4,
	output wire LD3,
	output wire LD2,
	output wire LD1,
	output wire LD0,
	output wire 		LCDE,
	output wire 		LCDRS,
	output wire 		LCDRW,	
	output wire [3:0] LCDDAT
    );
	 
	wire [7:0] LED;
	wire CLKDV_OUT;
	//reg [33:0] period;
	wire [33:0] period;
	reg  listening = 1'b1;
	wire wave; //***Comment for Test Bench 2
	
	//Testing LCD and LEDs. NO MICROPHONE YET!
	/*always@(*) begin
				case({SW3,SW2,SW1,SW0})
						4'b0000			:	period <= 25'd15100000; //C_2 - C_2b 			----> C, Sharp1
						4'b0001			:	period <= 25'd14750000; //C_2b - C_2c 			----> C, Sharp2
						4'b0010			:	period <= 25'd14500000; //C_2c - Db_2 			----> C, Sharp3
						4'b0011			:	period <= 25'd14300000; //Db_2 - Db_2b 		----> D, Flat3
						4'b0100			:	period <= 25'd13900000; //Db_2b - Db_2c 		----> D, Flat2
						4'b0101			:	period <= 25'd13700000; //Db_2c - D 			----> D, Flat1
						4'b0110			:	period <= 25'd13621000; //D_2						----> D, On-Pitch
						4'b0111			:	period <= 25'd13400000; //D_2 - D_2b 			----> D, Sharp1
						4'b1000			:	period <= 25'd13200000; //D_2b - D_2c			----> D, Sharp2
						4'b1001			:	period <= 25'd13000000; //D_2c - Eb_2 			----> D, Sharp3
						4'b1010			:	period <= 25'd12700000; //Eb_2 - Eb_2b 		----> E, Flat3
						4'b1011			:	period <= 25'd12400000; //Eb_2b - Eb_2c 		----> E, Flat2
						4'b1100			:	period <= 25'd12200000; //Eb_2c - E_2 			----> E, Flat1
						4'b1101			:	period <= 25'd12135000; //E_2						----> E, On-Pitch
						4'b1110			:	period <= 25'd0; //None 						----> white space
						4'b1111			:	period <= 25'd0; //None 						----> white space
						default			:	period <= 25'd0; //None 						----> white space
				endcase
		end //always
	*/
	
	// Instantiate note_display
	note_display note_display (
    .clk(CLKDV_OUT), 
    .rst(BTN_NORTH), 
	 .start_tuning(listening),
    .period(period), 
    .LED(LED), 
    .LCDE(LCDE), 
    .LCDRS(LCDRS), 
    .LCDRW(LCDRW), 
    .LCDDAT(LCDDAT)
    );
	 
	 
	 //Instantiate Clock Divider
	clock_div clock_div(
    .CLKIN_IN(CCLK), 
    .CLKDV_OUT(CLKDV_OUT), 
    .CLKIN_IBUFG_OUT(), 
    .CLK0_OUT()
    );
	 
	 ///*    //Uncomment for test bench 2
	//Instantiate PreampADC
	preamp_adc_master preamp_adc_master (
    .BTN_NORTH(BTN_NORTH), 
    //.BTN_EAST(BTN_EAST), 
    .CLKDV_OUT(CLKDV_OUT), 
    .SPIMISO(SPIMISO), 
    .SPIMOSI(SPIMOSI), 
    .SPISCK(SPISCK), 
    .AMPCS(AMPCS), 
    .DACCS(DACCS), 
    .ADCON(ADCON), 
    .SFCE(SFCE), 
    .FPGAIB(FPGAIB), 
    .AMPSD(AMPSD), 
    .SPISF(SPISF), 
    .wave(wave)
	 
    );
	 // */    //Uncomment for test bench 2
	 
	 //Instantiate get_period
	 get_period get_period (
    .clk(CLKDV_OUT), //***Comment for test bench 2
	 //.clk(CCLK), //***Uncomment for test bench 2
    .wave(wave), 
    .period(period)
    );
	

	//LEDs
	
		assign LD7 = LED[7];
		assign LD6 = LED[6];
		assign LD5 = LED[5];
		assign LD4 = LED[4];
		assign LD3 = LED[3];
		assign LD2 = LED[2];
		assign LD1 = LED[1];
		assign LD0 = LED[0];
	 
	 
  //Period
	//	assign {LD7,LD6,LD5,LD4,LD3,LD2,LD1} = period[23:17];
	//	assign {LD0} = wave;
	
	
endmodule
