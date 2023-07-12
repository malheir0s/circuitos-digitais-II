`timescale 1ns / 1ps
`default_nettype none

module updowncounter (
	input  wire clock,
	input wire countup,
	input wire paused,
	output logic [31:0] value = 0 //4'b0000
);

/*
50.10^6 x

periodo = 0.02 us

2^n x 0.02us = 1/256

n = log 2 (1/256 /0.02us)
n =~ 16
*/

	logic [46:0] clock_counter;
	 always @(posedge clock) begin : mod4_counter
		case ({paused, countup})
		2'b01 : clock_counter <= clock_counter + 1'b1;
		2'b00 : clock_counter <= clock_counter - 1'b1;
		endcase
    /*
	  if(paused == 0 & countup ==1)
			clock_counter <= clock_counter + 1'b1;
		else if(paused == 0 & countup == 0)
			clock_counter <= clock_counter - 1'b1;
		*/
		value <= clock_counter[46:15];
	end

endmodule