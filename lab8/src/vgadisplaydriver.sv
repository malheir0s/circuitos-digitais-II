// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : de2_115top.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//    Top level interface from a DE2-115 FPGA board
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.svh"
module vgadisplaydriver #(
    parameter Nchars=4,                   // quantidade de caracteres/sprites
    parameter smem_size=1200,             // tamanho da memória da tela, 30 linhas x 40 colunas
    parameter bmem_init="bitmap.mem" 	   // arquivo de texto que inicializa a screen memory
)(
   input  wire clk,
   output wire [$clog2(smem_size)-1:0] smem_addr,
   input wire [$clog2(Nchars)-1:0] charcode,
   output wire hsync, vsync, 
   output wire [3:0] red, green, blue,
   output wire avideo
);

wire [11:0] dout;
wire [`xbits-1:0] x;
wire [`ybits-1:0] y;
wire [3:0] yoffset;
wire [3:0] xoffset;
wire [$clog2(Nchars)+7:0] bitmapaddr;

wire [$clog2(smem_size)-1:0] row;
wire [$clog2(smem_size)-1:0] col;


assign yoffset = y[3:0];
assign xoffset = x[3:0];

assign bitmapaddr = {charcode, yoffset, xoffset};

assign row = y >> 4;
assign col = x >> 4;

assign smem_addr = (row << 5) + (row << 3) + col;

rom #(.Nloc(smem_size), .Dbits($clog2(Nchars)), .initfile(bmem_init)) bitmapmem(.addr(bitmapaddr), .dout(dout));
vgasynctimer my_vgatimer (.clock(clk), .hsync(hsync), .vsync(vsync), .activevideo(avideo), .x(x), .y(y));

assign red[3:0]   = (avideo == 1) ?  dout[11:8] : 0;
assign green[3:0] = (avideo == 1) ?  dout[7:4] : 0;
assign blue[3:0]  = (avideo == 1) ?  dout[3:0] : 0;

endmodule