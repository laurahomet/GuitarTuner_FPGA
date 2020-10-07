`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:47:31 05/04/2018 
// Design Name: 
// Module Name:    preamp_adc_master 
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
module preamp_adc_master (
  input wire BTN_NORTH,
  //input wire BTN_EAST,
  //input wire CCLK,
  input wire CLKDV_OUT,
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
  output reg wave
  //output wire LD0
  );

  
  wire reset_sync;
  wire get_rdid_debounce_adc;
  wire get_rdid_oneshot_adc;
  wire get_rdid_debounce_preamp;
  wire get_rdid_oneshot_preamp;
  wire [7:0] sample_right;
  wire [7:0] sample_left;
  reg [7:0] gain;
  wire spisck_adc;
  wire spisck_preamp;
  wire adcon;
  wire ampcs;
  reg spisck;
  reg [15:0] sample;
  wire set_gain = 1;
  reg get_sample = 1;
  //wire CLKDV_OUT;
  wire adc_done;
	//reg wave;
  
  //localparam [15:0] THRESHOLD = 16'd7969; //square wave
  localparam [15:0] THRESHOLD = 16'd8022; //sine wave
  
  localparam [15:0] THRESHOLD_1 = 16'd11836; //sine wave up
  localparam [15:0] THRESHOLD_2 = 16'd4176; //sine wave down
  
  assign DACCS 	= 1'b1;
  assign SPISF 	= 1'b1;
  assign SFCE		= 1'b1;
  assign FPGAIB 	= 1'b0;
  assign AMPSD		= 1'b0;
  
  
  //Instantiate Reset Synchronizer
  reset_synchronizer reset_syncronizer  (
    .clk(CLKDV_OUT), 
    .rst(BTN_NORTH), 
    .reset_sync(reset_sync)
    );
	 
	 
  //Instantiate Debouncer for ADC
  adc_debounce adc_debounce (
    .clk(CLKDV_OUT), 
    .rst(reset_sync), 
    .get_rdid(get_sample), 
    .get_rdid_debounce(get_rdid_debounce_adc)
    );


  //Instantiate One-shot for ADC
  adc_oneshot adc_oneshot (
    .clk(CLKDV_OUT), 
    .rst(reset_sync), 
    .get_rdid_debounce(get_rdid_debounce_adc), 
    .get_rdid_oneshot(get_rdid_oneshot_adc)
    );
	 
	 
	 
  //Instantiate ADC
  adc adc (
    .spimiso(SPIMISO), 
    .clk(CLKDV_OUT), 
    .reset(reset_sync), 
    .get_rdid(get_rdid_oneshot_adc), 
    .spisck(spisck_adc),
    .prom_cs(ADCON), 
    .sample_left(sample_left), 
    .sample_right(sample_right),
	 .enable_adc(adcon),
	 .adc_done(adc_done)
    );

  
  //Instantiate Debouncer for Preamp
  preamp_debounce preamp_debounce (
    .clk(CLKDV_OUT), 
    .rst(reset_sync), 
    .get_rdid(set_gain), 
    .get_rdid_debounce(get_rdid_debounce_preamp)
    );
  
  
  //Instantiate One-shot for Preamp
  preamp_oneshot preamp_oneshot (
    .clk(CLKDV_OUT), 
    .rst(reset_sync), 
    .get_rdid_debounce(get_rdid_debounce_preamp),
    .get_rdid_oneshot(get_rdid_oneshot_preamp)
    );


  //Instantiate Preamp
	preamp preamp (
    //.spimiso(SPIMISO), 
    .clk(CLKDV_OUT), 
    .reset(reset_sync), 
    .get_rdid(get_rdid_oneshot_preamp), 
    .spisck(spisck_preamp), 
    .spimosi(SPIMOSI), 
    .prom_cs_n(ampcs), 
    .gain(gain)
    );
  
  
   //dcm
	/*dcm instance_name (
    .CLKIN_IN(CCLK), 
    .CLKDV_OUT(CLKDV_OUT), 
    .CLKIN_IBUFG_OUT(), 
    .CLK0_OUT()
    );
	 */
	 
	//Get_sample
	always@(adc_done) begin
		if(adc_done)
			get_sample = 1;
		else
			get_sample = 0;
	end
	
	//Gain
	always@(posedge CLKDV_OUT) begin
		gain = {4'b0000,{2'b00,{1'b1,1'b1}}}; //gain 5 for channel A
	end

		
	//Sample
	/*
   always@(posedge adc_done) begin
		sample = {sample_left, sample_right};
		if (sample > THRESHOLD)
			wave = 1'b1;
		else if (sample < THRESHOLD)
			wave = 1'b0;
		else
			wave = 1'b0;
	end
		*/
	 always@(posedge adc_done) begin
		sample = {sample_left, sample_right};
		if (sample > THRESHOLD_1)
			wave = 1'b1;
		else if (sample < THRESHOLD_2)
			wave = 1'b0;
		else
			wave = wave;
	end	
		
	
	//spisck control
	always @ (posedge CLKDV_OUT or posedge BTN_NORTH) begin
		if (BTN_NORTH) 
			spisck = 1'b0;
		else if (adcon)
			spisck = spisck_adc;
		else if (!ampcs)
			spisck = spisck_preamp;
		else
			spisck = 1'b0;
	end
   
  assign SPISCK = spisck;	

  
  //assign ADCON = adcon;
  assign AMPCS = ampcs;
  
  //LED
  //assign LD0 = wave;
  
  
  
endmodule
