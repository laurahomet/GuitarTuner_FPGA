`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:31:35 04/28/2018 
// Design Name: 
// Module Name:    note_finder 
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
module note_finder(	
	input  wire [33:0] period, //in us
	output reg [4:0] note,
	output reg [3:0] tone
    );
	
	localparam [3:0] DEFAULT	= 4'h0;
	localparam [3:0] FLAT_3		= 4'h1;
	localparam [3:0] FLAT_2		= 4'h2;
	localparam [3:0] FLAT_1		= 4'h3;
	localparam [3:0] ON_PITCH	= 4'h4;
	localparam [3:0] SHARP_1	= 4'h5;
	localparam [3:0] SHARP_2	= 4'h6;
	localparam [3:0] SHARP_3	= 4'h7;
	
	localparam [25:0] E_1	= 25'd24270000; //E_1
	localparam [25:0] E_1b	= 25'd23816000;
	localparam [25:0] E_1c	= 25'd23361000;
	localparam [25:0] F_1	= 25'd22907000; //F_1
	localparam [25:0] F_1b	= 25'd22479000;
	localparam [25:0] F_1c	= 25'd22050000;
	localparam [25:0] Gb_1	= 25'd21622000; //Gb_1
	localparam [25:0] Gb_1b	= 25'd21217000;
	localparam [25:0] Gb_1c	= 25'd20813000;
	localparam [25:0] G_1	= 25'd20408000; //G_1
	localparam [25:0] G_1b	= 25'd20026000;
	localparam [25:0] G_1c	= 25'd19645000;
	localparam [25:0] Ab_1	= 25'd19263000; //Ab_1
	localparam [25:0] Ab_1b	= 25'd18903000;
	localparam [25:0] Ab_1c	= 25'd18542000;
	localparam [25:0] A_1	= 25'd18182000; //A_1
	localparam [25:0] A_1b	= 25'd17842000;
	localparam [25:0] A_1c	= 25'd17501000;
	localparam [25:0] Bb_1	= 25'd17161000; //Bb_1
	localparam [25:0] Bb_1b	= 25'd16840000;
	localparam [25:0] Bb_1c	= 25'd16519000;
	localparam [25:0] B_1	= 25'd16198000; //B_1
	localparam [25:0] B_1b	= 25'd15895000;
	localparam [25:0] B_1c  = 25'd15592000;
	
	localparam [25:0] C_2	= 24'd15289000; //C_2
	localparam [25:0] C_2b	= 24'd15003000;
	localparam [25:0] C_2c	= 24'd14717000;
	localparam [25:0] Db_2	= 24'd14431000; //Db_2
	localparam [25:0] Db_2b = 24'd14161000;
	localparam [25:0] Db_2c = 24'd13891000;
	localparam [25:0] D_2	= 24'd13621000; //D_2
	localparam [25:0] D_2b 	= 24'd13366000;
	localparam [25:0] D_2c 	= 24'd13111000;
	localparam [25:0] Eb_2	= 24'd12856000; //Eb_2
	localparam [25:0] Eb_2b = 24'd12616000;
	localparam [25:0] Eb_2c = 24'd12375000;
	localparam [25:0] E_2	= 24'd12135000; //E_2
	localparam [25:0] E_2b 	= 24'd11908000;
	localparam [25:0] E_2c 	= 24'd11681000;
	localparam [25:0] F_2	= 24'd11454000; //F_2
	localparam [25:0] F_2b 	= 24'd11240000;
	localparam [25:0] F_2c 	= 24'd11025000;
	localparam [25:0] Gb_2	= 24'd10811000; //Gb_2
	localparam [25:0] Gb_2b = 24'd10609000;
	localparam [25:0] Gb_2c = 24'd10406000;
	localparam [25:0] G_2	= 24'd10204000; //G_2
	localparam [25:0] G_2b 	= 24'd10013000;
	localparam [25:0] G_2c 	= 24'd9822000;
	localparam [25:0] Ab_2	= 24'd9631000; //Ab_2
	localparam [25:0] Ab_2b = 24'd9451000;
	localparam [25:0] Ab_2c = 24'd9271000;
	localparam [25:0] A_2	= 24'd9091000; //A_2
	localparam [25:0] A_2b 	= 24'd8921000;
	localparam [25:0] A_2c 	= 24'd8751000;
	localparam [25:0] Bb_2	= 24'd8581000; //Bb_2
	localparam [25:0] Bb_2b = 24'd8420000;
	localparam [25:0] Bb_2c = 24'd8260000;
	localparam [25:0] B_2	= 24'd8099000; //B_2
	localparam [25:0] B_2b 	= 24'd7947000;
	localparam [25:0] B_2c 	= 24'd7796000;
	
	localparam [25:0] C_3	= 24'd7644000; //C_3
	localparam [25:0] C_3b 	= 24'd7501000;
	localparam [25:0] C_3c 	= 24'd7358000;
	localparam [25:0] Db_3	= 24'd7215000; //Db_3
	localparam [25:0] Db_3b = 24'd7080000;
	localparam [25:0] Db_3c = 24'd6946000;
	localparam [25:0] D_3	= 24'd6811000; //D_3
	localparam [25:0] D_3b 	= 24'd6683000;
	localparam [25:0] D_3c 	= 24'd6556000;
	localparam [25:0] Eb_3	= 24'd6428000; //Eb_3
	localparam [25:0] Eb_3b = 24'd6308000;
	localparam [25:0] Eb_3c = 24'd6187000;
	localparam [25:0] E_3	= 24'd6067000; //E_3
	localparam [25:0] E_3b 	= 24'd5954000;
	localparam [25:0] E_3c 	= 24'd5840000;
	localparam [25:0] F_3	= 24'd5727000; //F_3
	localparam [25:0] F_3b 	= 24'd5620000;
	localparam [25:0] F_3c 	= 24'd5512000;
	localparam [25:0] Gb_3	= 24'd5405000; //Gb_3
	localparam [25:0] Gb_3b = 24'd5304000;
	localparam [25:0] Gb_3c = 24'd5203000;
	localparam [25:0] G_3	= 24'd5102000; //G_3
	localparam [25:0] G_3b 	= 24'd5007000;
	localparam [25:0] G_3c 	= 24'd4911000;
	localparam [25:0] Ab_3	= 24'd4816000; //Ab_3
	localparam [25:0] Ab_3b = 24'd4726000;
	localparam [25:0] Ab_3c = 24'd4635000;
	localparam [25:0] A_3	= 24'd4545000; //A_3
	localparam [25:0] A_3b 	= 24'd4460000;
	localparam [25:0] A_3c 	= 24'd4375000;
	localparam [25:0] Bb_3	= 24'd4290000; //Bb_3
	localparam [25:0] Bb_3b = 24'd4210000;
	localparam [25:0] Bb_3c = 24'd4129000;
	localparam [25:0] B_3	= 24'd4049000; //B_3
	localparam [25:0] B_3b 	= 24'd3973000;
	localparam [25:0] B_3c 	= 24'd3898000;
	
	localparam [25:0] C_4	= 24'd3822000; //C_4
	localparam [25:0] C_4b	= 24'd3751000;
	localparam [25:0] C_4c	= 24'd3679000;
	localparam [25:0] Db_4	= 24'd3608000; //Db_4
	localparam [25:0] Db_4b	= 24'd3540000;
	localparam [25:0] Db_4c	= 24'd3473000;
	localparam [25:0] D_4	= 24'd3405000; //D_4
	localparam [25:0] D_4b	= 24'd3341000;
	localparam [25:0] D_4c	= 24'd3278000;
	localparam [25:0] Eb_4	= 24'd3214000; //Eb_4
	localparam [25:0] Eb_4b	= 24'd3154000;
	localparam [25:0] Eb_4c	= 24'd3094000;
	localparam [25:0] E_4	= 24'd3034000; //E_4
	localparam [25:0] E_4b	= 24'd2977000;
	localparam [25:0] E_4c	= 24'd2920000;
	localparam [25:0] F_4	= 24'd2863000; //F_4
	localparam [25:0] F_4b	= 24'd2810000;
	localparam [25:0] F_4c	= 24'd2756000;
	localparam [25:0] Gb_4	= 24'd2703000; //Gb_4
	localparam [25:0] Gb_4b	= 24'd2652000;
	localparam [25:0] Gb_4c	= 24'd2602000;
	localparam [25:0] G_4	= 24'd2551000; //G_4
	localparam [25:0] G_4b	= 24'd2503000;
	localparam [25:0] G_4c	= 24'd2456000;
	localparam [25:0] Ab_4	= 24'd2408000; //Ab_4
	localparam [25:0] Ab_4b	= 24'd2363000;
	localparam [25:0] Ab_4c	= 24'd2318000;
	localparam [25:0] A_4	= 24'd2273000; //A_4
	localparam [25:0] A_4b	= 24'd2230000;
	localparam [25:0] A_4c	= 24'd2188000;
	localparam [25:0] Bb_4	= 24'd2145000; //Bb_4
	localparam [25:0] Bb_4b	= 24'd2104000;
	localparam [25:0] Bb_4c	= 24'd2064000;
	localparam [25:0] B_4	= 24'd2023000; //B_4
	localparam [25:0] B_4b	= 24'd1986000;
	localparam [25:0] B_4c	= 24'd1948000;
	
	localparam [25:0] C_5	= 24'd1911000; //C_5
	localparam [25:0] C_5b	= 24'd1875000;
	localparam [25:0] C_5c	= 24'd1840000;
	localparam [25:0] Db_5	= 24'd1804000; //Db_5
	localparam [25:0] Db_5b	= 24'd1770000;
	localparam [25:0] Db_5c	= 24'd1737000;
	localparam [25:0] D_5	= 24'd1703000; //D_5
	localparam [25:0] D_5b	= 24'd1671000;
	localparam [25:0] D_5c	= 24'd1639000;
	localparam [25:0] Eb_5	= 24'd1607000; //Eb_5
	localparam [25:0] Eb_5b	= 24'd1577000;
	localparam [25:0] Eb_5c	= 24'd1547000;
	localparam [25:0] E_5	= 24'd1517000; //E_5

	always@(*) begin
	
		// ----------------------------------- C -----------------------------------
		// No C FLAT, because we consider values between B and C as B SHARP.
		if ( ( period < (C_2 + 20000) && period > (C_2 - 20000) ) | ( period < (C_3 + 20000) && period > (C_3 - 20000) ) | ( period < (C_4 + 20000) && period > (C_4 - 20000) ) | ( period < (C_5 + 20000) && period > (C_5 - 20000) ) ) begin 
			note = 1; 
			tone = ON_PITCH;
		end
		else if ( (period < C_2 && period > Db_2) | ( period < C_3  && period > Db_3) | ( period < C_4  && period > Db_4) | ( period < C_5  && period > Db_5) ) begin
			note = 1;
			
			//C - C_b
			if ( (period < C_2 && period > C_2b) | ( period < C_3  && period > C_3b) | ( period < C_4  && period > C_4b) | ( period < C_5  && period > C_5b) )
				tone = SHARP_1;
			//C_b - C_c
			else if ( (period < C_2b && period > C_2c) | ( period < C_3b  && period > C_3c) | ( period < C_4b  && period > C_4c) | ( period < C_5b  && period > C_5c) )
				tone = SHARP_2;
			//C_c - Db
			else if ( (period < C_2c && period > Db_2) | ( period < C_3c  && period > Db_3) | ( period < C_4c  && period > Db_4) | ( period < C_5c  && period > Db_5) )
				tone = SHARP_3;
		end
		// -------------------------------------------------------------------------
		
		
		// ----------------------------------- D -----------------------------------
		else if ( ( period < (D_2 + 20000) && period > (D_2 - 20000) ) | ( period < (D_3 + 20000) && period > (D_3 - 20000) ) | ( period < (D_4 + 20000) && period > (D_4 - 20000) ) | ( period < (D_5 + 20000) && period > (D_5 - 20000) ) ) begin 
			note = 2; 
			tone = ON_PITCH;
		end
		else if ( (period < Db_2 && period > D_2) | ( period < Db_3  && period > D_3) | ( period < Db_4  && period > D_4) | ( period < Db_5  && period > D_5) ) begin
			note = 2; 
			
			//Db - Db_b
			if ( (period < Db_2 && period > Db_2b) | ( period < Db_3  && period > Db_3b) | ( period < Db_4  && period > Db_4b) | ( period < Db_5  && period > Db_5b) )
				tone = FLAT_3;
			//Db_b - Db_c
			else if ( (period < Db_2b && period > Db_2c) | ( period < Db_3b  && period > Db_3c) | ( period < Db_4b  && period > Db_4c) | ( period < Db_5b  && period > Db_5c) )
				tone = FLAT_2;
			//Db_c - D
			else if ( (period < Db_2c && period > D_2) | ( period < Db_3c  && period > D_3) | ( period < Db_4c  && period > D_4) | ( period < Db_5c  && period > D_5) )
				tone = FLAT_1;
		end	
		else if ( (period < D_2 && period > Eb_2) | ( period < D_3  && period > Eb_3) | ( period < D_4  && period > Eb_4) | ( period < D_5  && period > Eb_5) ) begin
			note = 2; 
			
			//D - D_b
			if ( (period < D_2 && period > D_2b) | ( period < D_3  && period > D_3b) | ( period < D_4  && period > D_4b) | ( period < D_5  && period > D_5b) )
				tone = SHARP_1;
			//D_b - D_c
			else if ( (period < D_2b && period > D_2c) | ( period < D_3b  && period > D_3c) | ( period < D_4b  && period > D_4c) | ( period < D_5b  && period > D_5c) )
				tone = SHARP_2;
			//D_c - Eb
			else if ( (period < D_2c && period > Eb_2) | ( period < D_3c  && period > Eb_3) | ( period < D_4c  && period > Eb_4) | ( period < D_5c  && period > Eb_5) )
				tone = SHARP_3;
		end
		// -------------------------------------------------------------------------
		

		// ----------------------------------- E -----------------------------------
		else if ( ( period < (E_1 + 20000) && period > (E_1 - 20000) ) | ( period < (E_2 + 20000) && period > (E_2 - 20000) ) | ( period < (E_3 + 20000) && period > (E_3 - 20000) ) | ( period < (E_4 + 20000) && period > (E_4 - 20000) ) | ( ( period < (E_5 + 20000) && period > (E_5 - 20000) ) ) )  begin 
			note = 3;
			tone = ON_PITCH;
		end
		else if ( (period < Eb_2 && period > E_2) | ( period < Eb_3  && period > E_3) | ( period < Eb_4  && period > E_4) | ( period < Eb_5  && period > E_5) ) begin
			note = 3; 
			
			//Eb - Eb_b
			if ( (period < Eb_2 && period > Eb_2b) | ( period < Eb_3  && period > Eb_3b) | ( period < Eb_4  && period > Eb_4b) | ( period < Eb_5  && period > Eb_5b) )
				tone = FLAT_3;
			//Eb_b - Eb_c
			else if ( (period < Eb_2b && period > Eb_2c) | ( period < Eb_3b  && period > Eb_3c) | ( period < Eb_4b  && period > Eb_4c) | ( period < Eb_5b  && period > Eb_5c) )
				tone = FLAT_2;
			//Eb_c - E
			else if ( (period < Eb_2c && period > E_2) | ( period < Eb_3c  && period > E_3) | ( period < Eb_4c  && period > E_4) | ( period < Eb_5c  && period > E_5) )
				tone = FLAT_1;
		end			
		else if ( (period < E_1 && period > F_1) | ( period < E_2  && period > F_2) | ( period < E_4  && period > F_4)) begin
			note = 3; 
			
			//E - E_b
			if ( (period < E_1 && period > E_1b) | ( period < E_2  && period > E_2b) | ( period < E_3  && period > E_3b) | ( period < E_4  && period > E_4b) )
				tone = SHARP_1;
			//E_b - E_c
			else if ( (period < E_1b && period > E_1c) | ( period < E_2b  && period > E_2c) | ( period < E_3b  && period > E_3c) | ( period < E_4b  && period > E_4c) )
				tone = SHARP_2;
			//E_c - F
			else if ( (period < E_1c && period > F_1) | ( period < E_2c  && period > F_2) | ( period < E_3c  && period > F_3) | ( period < E_4c  && period > F_4) )
				tone = SHARP_3;
		end
		// -------------------------------------------------------------------------
		
		
		// ----------------------------------- F -----------------------------------
		// No F FLAT, because we consider values between E and F as E SHARP.
		else if ( ( period < (F_1 + 20000) && period > (F_1 - 20000) ) | ( period < (F_2 + 20000) && period > (F_2 - 20000) ) | ( period < (F_3 + 20000) && period > (F_3 - 20000) ) | ( period < (F_4 + 20000) && period > (F_4 - 20000) ) ) begin 
			note = 4; 
			tone = ON_PITCH;
		end
		else if ( (period < F_1 && period > Gb_1) | ( period < F_2  && period > Gb_2) | ( period < F_3  && period > Gb_3) | ( period < F_4  && period > Gb_4) ) begin
			note = 4;
			
			//F - F_b
			if ( (period < F_1 && period > F_1b) | ( period < F_2  && period > F_2b) | ( period < F_3  && period > F_3b) | ( period < F_4  && period > F_4b) )
				tone = SHARP_1;
			//F_b - F_c
			else if ( (period < F_1b && period > F_1c) | ( period < F_2b  && period > F_2c) | ( period < F_3b  && period > F_3c) | ( period < F_4b  && period > F_4c) )
				tone = SHARP_2;
			//F_c - Gb
			else if ( (period < F_1c && period > Gb_1) | ( period < F_2c  && period > Gb_2) | ( period < F_3c  && period > Gb_3) | ( period < F_4c  && period > Gb_4) )
				tone = SHARP_3;
		end
		// -------------------------------------------------------------------------
		
		
		// ----------------------------------- G -----------------------------------
		else if ( ( period < (G_1 + 20000) && period > (G_1 - 20000) ) | ( period < (G_2 + 20000) && period > (G_2 - 20000) ) | ( period < (G_3 + 20000) && period > (G_3 - 20000) ) | ( period < (G_4 + 20000) && period > (G_4 - 20000) ) ) begin 
			note = 5; 
			tone = ON_PITCH;
		end
		else if ( (period < Gb_1 && period > G_1) | ( period < Gb_2  && period > G_2) | ( period < Gb_3  && period > G_3) | ( period < Gb_4  && period > G_4) ) begin
			note = 5; 
			
			//Gb - Gb_b
			if ( (period < Gb_1 && period > Gb_1b) | ( period < Gb_2  && period > Gb_2b) | ( period < Gb_3  && period > Gb_3b) | ( period < Gb_4  && period > Gb_4b) )
				tone = FLAT_3;
			//Gb_b - Gb_c
			else if ( (period < Gb_1b && period > Gb_1c) | ( period < Gb_2b  && period > Gb_2c) | ( period < Gb_3b  && period > Gb_3c) | ( period < Gb_4b  && period > Gb_4c) )
				tone = FLAT_2;
			//Gb_c - G
			else if ( (period < Gb_1c && period > G_1) | ( period < Gb_2c  && period > G_2) | ( period < Gb_3c  && period > G_3) | ( period < Gb_4c  && period > G_4) )
				tone = FLAT_1;
		end
		else if ( (period < G_1 && period > Ab_1) | ( period < G_2  && period > Ab_2) | ( period < G_3  && period > Ab_3) | ( period < G_4  && period > Ab_4) ) begin
			note = 5; 
			
			//G - G_b
			if ( (period < G_1 && period > G_1b) | ( period < G_2  && period > G_2b) | ( period < G_3  && period > G_3b) | ( period < G_4  && period > G_4b) )
				tone = SHARP_1;
			//G_b - G_c
			else if ( (period < G_1b && period > G_1c) | ( period < G_2b  && period > G_2c) | ( period < G_3b  && period > G_3c) | ( period < G_4b  && period > G_4c) )
				tone = SHARP_2;
			//G_c - Ab
			else if ( (period < G_1c && period > Ab_1) | ( period < G_2c  && period > Ab_2) | ( period < G_3c  && period > Ab_3) | ( period < G_4c  && period > Ab_4) )
				tone = SHARP_3;
		end
		// -------------------------------------------------------------------------
		
		
		// ----------------------------------- A -----------------------------------
		else if ( ( period < (A_1 + 20000) && period > (A_1 - 20000) ) | ( period < (A_2 + 20000) && period > (A_2 - 20000) ) | ( period < (A_3 + 20000) && period > (A_3 - 20000) ) | ( period < (A_4 + 20000) && period > (A_4 - 20000) ) ) begin 
			note = 6; 
			tone = ON_PITCH;
		end
		else if ( (period < Ab_1 && period > A_1) | ( period < Ab_2  && period > A_2) | ( period < Ab_3  && period > A_3) | ( period < Ab_4  && period > A_4) ) begin
			note = 6; 
			
			//Ab - Ab_b
			if ( (period < Ab_1 && period > Ab_1b) | ( period < Ab_2  && period > Ab_2b) | ( period < Ab_3  && period > Ab_3b) | ( period < Ab_4  && period > Ab_4b) )
				tone = FLAT_3;
			//Ab_b - Ab_c
			else if ( (period < Ab_1b && period > Ab_1c) | ( period < Ab_2b  && period > Ab_2c) | ( period < Ab_3b  && period > Ab_3c) | ( period < Ab_4b  && period > Ab_4c) )
				tone = FLAT_2;
			//Ab_c - A
			else if ( (period < Ab_1c && period > A_1) | ( period < Ab_2c  && period > A_2) | ( period < Ab_3c  && period > A_3) | ( period < Ab_4c  && period > A_4) )
				tone = FLAT_1;
		end	
		else if ( (period < A_1 && period > Bb_1) | ( period < A_2  && period > Bb_2) | ( period < A_3  && period > Bb_3) | ( period < A_4  && period > Bb_4) ) begin
			note = 6; 
			
			//A - A_b
			if ( (period < A_1 && period > A_1b) | ( period < A_2  && period > A_2b) | ( period < A_3  && period > A_3b) | ( period < A_4  && period > A_4b) )
				tone = SHARP_1;
			//A_b - A_c
			else if ( (period < A_1b && period > A_1c) | ( period < A_2b  && period > A_2c) | ( period < A_3b  && period > A_3c) | ( period < A_4b  && period > A_4c) )
				tone = SHARP_2;
			//A_c - Bb
			else if ( (period < A_1c && period > Bb_1) | ( period < A_2c  && period > Bb_2) | ( period < A_3c  && period > Bb_3) | ( period < A_4c  && period > Bb_4) )
				tone = SHARP_3;
		end
		// -------------------------------------------------------------------------
			
		
		// ----------------------------------- B -----------------------------------
		else if ( ( period < (B_1 + 20000) && period > (B_1 - 20000) ) | ( period < (B_2 + 20000) && period > (B_2 - 20000) ) | ( period < (B_3 + 20000) && period > (B_3 - 20000) ) | ( period < (B_4 + 20000) && period > (B_4 - 20000) )) begin 
			note = 7; 
			tone = ON_PITCH;
		end
		else if ( (period < Bb_1 && period > B_1) | ( period < Bb_2  && period > B_2) | ( period < Bb_3  && period > B_3) | ( period < Bb_4  && period > B_4) ) begin
			note = 7; 
			
			//Bb - Bb_b
			if ( (period < Bb_1 && period > Bb_1b) | ( period < Bb_2  && period > Bb_2b) | ( period < Bb_3  && period > Bb_3b) | ( period < Bb_4  && period > Bb_4b) )
				tone = FLAT_3;
			//Bb_b - Bb_c
			else if ( (period < Bb_1b && period > Bb_1c) | ( period < Bb_2b  && period > Bb_2c) | ( period < Bb_3b  && period > Bb_3c) | ( period < Bb_4b  && period > Bb_4c) )
				tone = FLAT_2;
			//Bb_c - B
			else if ( (period < Bb_1c && period > B_1) | ( period < Bb_2c  && period > B_2) | ( period < Bb_3c  && period > B_3) | ( period < Bb_4c  && period > B_4) )
				tone = FLAT_1;
		end
		else if ( (period < B_1 && period > C_2) | ( period < B_2  && period > C_3) | ( period < B_3  && period > C_4) | ( period < B_4  && period > C_5) ) begin
			note = 7; 
			
			//B - B_b
			if ( (period < B_1 && period > B_1b) | ( period < B_2  && period > B_2b) | ( period < B_3  && period > B_3b) | ( period < B_4  && period > B_4b) )
				tone = SHARP_1;
			//B_b - B_c
			else if ( (period < B_1b && period > B_1c) | ( period < B_2b  && period > B_2c) | ( period < B_3b  && period > B_3c) | ( period < B_4b  && period > B_4c) )
				tone = SHARP_2;
			//B_c - C
			else if ( (period < B_1c && period > C_2) | ( period < B_2c  && period > C_3) | ( period < B_3c  && period > C_4) | ( period < B_4c  && period > C_5) )
				tone = SHARP_3;
		end
		// -------------------------------------------------------------------------
		
		
		
		//No note
		else begin
			note = 0;
			tone = DEFAULT;
		end
	
	end //always

endmodule
