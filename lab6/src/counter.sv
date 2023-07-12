`timescale 1ns / 1ps
`default_nettype none

module counter (
	input  wire 		 clock,
	input  wire 		 reset,
	output logic [31:0] value = 4'b0000
);

	logic [36:0] clock_counter;
	
   always @(posedge clock) begin : mod4_counter
		clock_counter <= clock_counter + 1'b1;
		value <= clock_counter[36:5];
	end

endmodule