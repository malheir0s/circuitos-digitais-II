// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : dec7seg.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//		Conversor de binário para display de 7 segmentos
// -----------------------------------------------------------------------------
// Entradas: 
// 	x: dígito binário
// -----------------------------------------------------------------------------
// Saidas:
// 	segments: codigo para exibição no display de 7 segmentos
// 50000000 HZ
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none

module counter1second(
   input  wire  CLOCK_50,
   //output logic [25:0] counter=0, 
   output logic [3:0] value
);
    logic [31:0] counter = 0;
   	always @(posedge CLOCK_50) begin
      counter <= counter + 1;
      value <= counter[29:26];
		end

endmodule