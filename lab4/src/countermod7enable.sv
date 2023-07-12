`timescale 1ns / 1ps
`default_nettype none

module countermod7enable(
	input  wire clock, 
	input  wire reset,
  input wire enable,
	output logic [2:0] value // Observe como esta linha é diferente da Parte I
	);

	always @(posedge clock) begin
		value <= reset ? 3'b000 : 
            ~enable ? value :
						(value == 3'b110) ? 3'b000 : 
						value + 1'b1;
	end

endmodule
