`timescale 1ns / 1ps
`default_nettype none

module alu #(
	parameter N=32
)(
   input    wire [N-1:0] A, B,
   input    wire [4:0] ALUfn,
	output   wire [N-1:0] R,
   output   wire FlagN, FlagC, FlagV, FlagZ
);

   wire subtract, bool1, bool0, shft, math;

   assign {subtract, bool1, bool0, shft, math} = ALUfn[4:0];

   wire [N-1:0] addsubResult, shiftResult, logicalResult;
	wire left, logical, comparatorResult;
	
	assign left = ~bool1 & ~bool0;
	assign logical = bool1 & ~bool0;

   addsub   #(N) AS(A, B, subtract, addsubResult, FlagN, FlagC, FlagV);
   shifter  #(N) S(B, A[$clog2(N)-1:0], left, logical, shiftResult);
   logical  #(N) L(A, B, {bool1, bool0}, logicalResult);
	comparator C(FlagN, FlagV, FlagC, bool0, comparatorResult);

					
	assign R = (~shft & math) ? addsubResult : 
				(shft & ~math) ? shiftResult : 
				(~shft & ~math) ? logicalResult : {{(N-1){1'b0}}, comparatorResult};

   assign FlagZ = ~|R;

 endmodule