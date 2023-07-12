`timescale 1ns / 1ps
`default_nettype none

module mux2 #(parameter Dbits = 32) (
    input wire[Dbits-1:0] in0, in1,
    input wire sel,
    output reg [Dbits-1:0] out
);
	 
always @(*) begin
   case (sel)
      1'b0  : out <= in0;
      1'b1  : out <= in1;
      //default : out <= 1'bx;
   endcase
   end
endmodule

