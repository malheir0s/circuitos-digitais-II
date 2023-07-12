
`timescale 1ns / 1ps
`default_nettype none

// NÃO MODIFIQUE NADA NO CÓDIGO ABAIXO !!!!!!!!!!!!!!!!
// NÃO MODIFIQUE NADA NO CÓDIGO ABAIXO !!!!!!!!!!!!!!!!
// NÃO MODIFIQUE NADA NO CÓDIGO ABAIXO !!!!!!!!!!!!!!!!
// NÃO MODIFIQUE NADA NO CÓDIGO ABAIXO !!!!!!!!!!!!!!!!
// NÃO MODIFIQUE NADA NO CÓDIGO ABAIXO !!!!!!!!!!!!!!!!
// NÃO MODIFIQUE NADA NO CÓDIGO ABAIXO !!!!!!!!!!!!!!!!

module rom_module #(
   parameter Nloc = 16,                         // Quantidade de posições de memória
   parameter Dbits = 4,                         // Número de bits do dado
   parameter initfile = "C:/Users/Yuri/Documents/lab9/im/tests/wherever_code_is.mem"          // Nome do arquivo contendo os valores iniciais
)(
   input wire [$clog2(Nloc)-1 : 0] addr,        // Endereço para especificar a posição da memória
                                                //   número de bits em addr é ceiling(log2(quantidade de posições))
   output wire [Dbits-1 : 0] dout               // Dado lido da memória (assíncrono, ou seja, contínuo)
   );

   logic [Dbits-1 : 0] mem [Nloc-1 : 0];        // Unidade de armazenamento onde o dado será guardado
   initial $readmemh(initfile, mem, 0, Nloc-1); // Inicializa o conteúdo da memória a partir de um arquivo
   
   assign dout = mem[addr];                     // Leitura da memória: leitura contínua, sem envolvimento do clock

endmodule
