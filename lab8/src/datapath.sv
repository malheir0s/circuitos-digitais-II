// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none

module datapath #(
   parameter Nreg = 32,                      // Quantidade de posições de memória
   parameter Dbits = 32                      // Quantidade de bits de dado
)(
   input wire [4:0] ALUFN,
   input wire clock,
   //input wire wr,                            // WriteEnable:  se wr==1, o dado é escrito em mem
   input wire RegWrite,
   output wire FlagZ,
   input wire [$clog2(Nreg)-1 : 0] ReadAddr1, ReadAddr2, WriteAddr, 	
                                             // 3 endereóco, dois para leitura e um para escrita
   input wire [Dbits-1 : 0] WriteData,       // Dado a ser escrito na memória (se wr==1)
   output logic [Dbits-1 : 0] ReadData1, ReadData2,
   output wire [Dbits-1 : 0] ALUResult
                                             // 2 portas de saída
   );

   wire FlagN, FlagC, FlagV;
   alu #(Dbits) al(.A(ReadData1), .B(ReadData2), .R(ALUResult), .ALUfn(ALUFN), .FlagN(FlagN), .FlagC(FlagC), .FlagV(FlagV), .FlagZ(FlagZ));
   register_file #(Nreg, Dbits) rf(.clock(clock), .wr(RegWrite), .ReadAddr1(ReadAddr1), .ReadAddr2(ReadAddr2), .WriteAddr(WriteAddr), .WriteData(WriteData), .ReadData1(ReadData1), .ReadData2(ReadData2));

endmodule
