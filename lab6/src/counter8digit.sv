`timescale 1ns / 1ps
`default_nettype none

module counter8digit
   (
      ////////////////////	Clock Input	 	/////////////////////////////////////// 
      input    wire        CLOCK_50,     //	50 MHz
      ////////////////////	 Push Button   ///////////////////////////////////////
      input	   wire [3:0]  KEY,          //	Pushbutton[3:0]
      ////////////////////	7-SEG Display  ///////////////////////////////////////
      output   logic [6:0]  HEX0,         // Display de 7-segmentos (HEX0)
      output   logic [6:0]  HEX1,         // Display de 7-segmentos (HEX1)
      output   logic [6:0]  HEX2,         // Display de 7-segmentos (HEX2)
      output   logic [6:0]  HEX3,          // Display de 7-segmentos (HEX3)
		output   logic [6:0]  HEX4,          // Display de 7-segmentos (HEX4)
		output   logic [6:0]  HEX5,          // Display de 7-segmentos (HEX5)
		output   logic [6:0]  HEX6,          // Display de 7-segmentos (HEX6)
		output   logic [6:0]  HEX7          // Display de 7-segmentos (HEX7)
   );

   //	Parâmetros internos
   localparam NDIG = 8;
   
	//	Sinais internos
   logic [6:0]  segments [0:NDIG-1];
   logic reset;
   logic clock;
	logic [(NDIG*4)-1:0] value;
   
   //	Atribuições de entrada
   assign reset = ~KEY[0];
   assign clock = CLOCK_50;
   

   //	Instanciação de módulos	
   counter count(.clock(clock), .reset(reset), .value(value) );
	displayNdigit dut ( .clock(clock), .value(value), .segments(segments) );

   //	Atribuições de saída
   assign HEX0 = segments[0];
   assign HEX1 = segments[1];
   assign HEX2 = segments[2];
   assign HEX3 = segments[3];	
	assign HEX4 = segments[4];
	assign HEX5 = segments[5];
	assign HEX6 = segments[6];
	assign HEX7 = segments[7];

endmodule