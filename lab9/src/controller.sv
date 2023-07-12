// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <Yuri Lima dos Santos Silva> <seu email>
// File   : controller.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//		Unidade de controle para o processador RISC231-M1
// -----------------------------------------------------------------------------
// Entradas: 
// 	enable : sinal de controle de escrita
// 	op     : opcode da instrução
// 	func   : função para instruções R-type
//    Z      : flag zero vinda da ALU
// -----------------------------------------------------------------------------					
// Saidas:
// 	pcsel  : seletor do multiplexador de PC.
//    wasel  : seletor do multiplexador do endereço de escrita no register file
//    sext   : controle do sign extend (0 zero-extends, 1 sign-extends)
//    bsel   : seletor do multiplexador da entrada B da ALU
//    wdsel  : seletor do multiplexador de dados de escrita no register file
//    alufn  : função a ser executada pela ALU
//    wr     : write enable da memória de dados
//    werf   : write enable do register file
//    asel   : seletor do multiplexador da entrada A da ALU
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

`define RTYPE  6'b 000000
`define LW     6'b 100011
`define SW     6'b 101011

`define ADDI   6'b 001000
`define ADDIU  6'b 001001     // NOTE:  addiu *estende o sinal* do imediato
`define SLTI   6'b 001010
`define SLTIU  6'b 001011
`define ORI    6'b 001101
`define LUI    6'b 001111
`define ANDI   6'b 001100
`define XORI   6'b 001110

`define BEQ    6'b 000100
`define BNE    6'b 000101
`define J      6'b 000010
`define JAL    6'b 000011


// Essas são todas as instruções tipo-R, i.e., OPCODE=0.  
// Campo FUNC definido aqui:

`define ADD    6'b 100000
`define ADDU   6'b 100001
`define SUB    6'b 100010
`define AND    6'b 100100
`define OR     6'b 100101
`define XOR    6'b 100110
`define NOR    6'b 100111
`define SLT    6'b 101010
`define SLTU   6'b 101011
`define SLL    6'b 000000
`define SLLV   6'b 000100
`define SRL    6'b 000010
`define SRLV   6'b 000110
`define SRA    6'b 000011
`define SRAV   6'b 000111
`define JR     6'b 001000
`define JALR   6'b 001001 

module controller(
   // NÃO MODIFICAR
   input  wire enable,
   input  wire [5:0] op, 
   input  wire [5:0] func,
   input  wire Z,
   output wire [1:0] pcsel,
   output wire [1:0] wasel, 
   output wire sext,
   output wire bsel,
   output wire [1:0] wdsel, 
   output logic [4:0] alufn, 	   // vai virar um wire
   output wire wr,
   output wire werf, 
   output wire [1:0] asel
   ); 

   // MODIFIQUE o código abaixo preenchendo as partes que faltam
   assign pcsel = ((op == 6'b0) & (func == `JR)) ? 2'b11   // controla o multiplexador de  4-entradas
					: ((op == 6'b0) & (func == `ADDIU)) ? 2'b11
               : (op == `J || op == `JAL) ? 2'b10 // J-type
               : (op == `BEQ) ? {1'b0,Z} //I-type
               : (op == `BNE) ? {1'b0,~Z} //I-type
               : 2'b0;

  logic [9:0] controls;                // vai virar um conjunt de wires
  wire  _werf_, _wr_;                  // precisa de uma AND com o enable para "congelar" o processador
  assign werf = _werf_ & enable;       // desativa as escritas no registrador quando o processador está desativado
  assign wr = _wr_ & enable;           // destiva a escrita na memória quando o processador está desativado 
 
  assign {_werf_, wdsel[1:0], wasel[1:0], asel[1:0], bsel, sext, _wr_} = controls[9:0];

   always @(*)
     case(op)                                       // instruções não-tipo-R 
        `LW: controls <=   10'b1_10_01_00_1_1_0;     // LW
        `SW: controls <=   10'b0_xx_xx_00_1_1_1;                         // SW
      `ADDI: controls <=   10'b1_01_01_00_1_1_0;                                        // ADDI
     `ADDIU: controls <=   10'b1_01_01_00_1_1_0;                       // ADDIU
      `SLTI: controls <=   10'b1_01_01_00_1_1_0;
       `SLTIU: controls <= 10'b1_01_01_00_1_1_0;
         `ORI: controls <= 10'b1_01_01_00_1_0_0;                        // ORI
         `LUI: controls <= 10'b1_01_01_10_1_1_0; 
        `ANDI: controls <= 10'b1_01_01_00_1_0_0;
		  `XORI: controls <= 10'b1_01_01_00_1_0_0;
	      `BEQ: controls <= 10'b0_xx_xx_00_0_1_0;
	      `BNE: controls <= 10'b0_xx_xx_00_0_1_0;
	        `J: controls <= 10'b0_xx_xx_xx_x_x_0;
	      `JAL: controls <= 10'b1_00_10_xx_x_x_0;
	
	`RTYPE:		
         case(func)                                 // Tipo-R
             `ADD: controls <= 10'b 1_01_00_00_0_x_0;
	         `ADDU: controls <= 10'b 1_01_00_00_0_x_0; // ADD e ADDU
             `SUB: controls <= 10'b 1_01_00_00_0_x_0; // SUB
             `AND: controls <= 10'b 1_01_00_00_0_x_0;
				 `OR: controls <=  10'b 1_01_00_00_0_x_0;
				 `XOR: controls <= 10'b 1_01_00_00_0_x_0;
				 `NOR: controls <= 10'b 1_01_00_00_0_x_0;
				 `SLT: controls <= 10'b 1_01_00_00_0_x_0;
				 `SLTU: controls <=10'b 1_01_00_00_0_x_0;
				 `SLL: controls <= 10'b 1_01_00_01_0_x_0;
				 `SLLV: controls <=10'b 1_01_00_00_0_x_0;
				 `SRL: controls <= 10'b 1_01_00_01_0_x_0;
				 `SRLV: controls <=10'b 1_01_00_00_0_x_0;
				 `SRA: controls <= 10'b 1_01_00_01_0_x_0;
				 `SRAV: controls <=10'b 1_01_00_00_0_x_0;
				 `JR: controls <=  10'b 0_xx_xx_xx_x_x_0;
				 `JALR: controls <=10'b 1_00_00_xx_x_x_0;
            default:   controls <= 10'b 0_xx_xx_xx_x_x_0; // instrução desconhecida, desative a escrita no registrador e na memória
         endcase
	default:   controls <= 10'b 0_xx_xx_xx_x_x_0;
    endcase
   always @(*)
      case(op)                         // instruções que não são do tipo-R
         `LW: alufn <= 5'b0xx01;        // LW
         `SW: alufn <= 5'b0xx01;            // SW
         `ADDI: alufn <= 5'b0xx01;                        // ADDI
      	 `ADDIU: alufn <= 5'b0xx01;      // ADDIU
         `SLTI: alufn <= 5'b1x011;    // SLTI
         `BEQ: alufn <= 5'b1xx01;            // BEQ
         `BNE: alufn <= 5'b1xx01;            // BNE
			`SLTIU: alufn <= 5'b1x111;
			`ORI: alufn <= 5'b_x0100;
			`LUI: alufn <= 5'bx0010;
			`ANDI: alufn <= 5'b_x0000;
			`XORI: alufn <= 5'b_x1000;
			`J: alufn <= 5'b_xxxxx;
			`JAL: alufn <= 5'b_xxxxx; 
			6'b000000:            
		
	
            case(func)                 // tipo-R
               `ADD:  alufn <= 5'b0xx01; //ADD
               `ADDU: alufn <= 5'b0xx01; // ADD e ADDU
               `SUB: alufn <= 5'b1xx01;  // SUB
               `AND: alufn <= 5'b_x0000;
					`OR: alufn <= 5'b_x0100;
					`XOR: alufn <= 5'b_x1000;
					`NOR: alufn <= 5'b_x1100;
					`SLT: alufn <= 5'b1x011;
					`SLTU:alufn <= 5'b1x111;
					`SLL: alufn <= 5'b_x0010;
					`SLLV: alufn <= 5'b_x0010;
					`SRL: alufn <= 5'b_x1010;
					`SRLV: alufn <= 5'b_x1010;
					`SRA: alufn <= 5'b_x1110;
					`SRAV: alufn <= 5'b_x1110;
					`JR: alufn <= 5'b_xxxxx;
					`JALR: alufn <= 5'b_xxxxx;
               default:   alufn <= 5'b_xxxxx; // função desconhecida
            endcase
	  default: alufn <= 5'b_xxxxx;
	endcase
endmodule
