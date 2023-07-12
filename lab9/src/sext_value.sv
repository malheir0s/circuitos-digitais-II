`timescale 1ns / 1ps
`default_nettype none

module sext_value(
	input wire sext,
	input wire signed [15:0] in,
	output logic signed [31:0] out
);

	always @(*) begin
		if (sext) begin
			if (in > 0) 
				out = {{(16){1'b0}}, in[15:0]};
			else
				out = {{(16){1'b1}}, in[15:0]};
		end else begin
			out = {{(16){1'b0}}, in[15:0]};
		end
	end

endmodule