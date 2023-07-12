`default_nettype none

module alu #(
   parameter N=32
)(
   input  wire [N-1:0] A, B,
   output wire [N-1:0] R,
   input  wire [4:0]   ALUfn,
   output wire         FlagN, FlagC, FlagV, FlagZ
);

   wire subtract, bool1, bool0, shft, math;
   //left e logical
   wire left, logical0;
   assign left = (~bool0 & ~bool1);
   assign logical0 = (bool0 & ~bool1);
   // Separando ALUfn em bits nomeados
   assign {subtract, bool0, bool1, shft, math} = ALUfn[4:0];
   // 1x011
   // Resultados dos três componentes da ALU
   wire [N-1:0] addsubResult, shiftResult, logicalResult;
   wire comparatorResult;
	
	comparator CP (FlagN, FlagV, FlagC, bool1, comparatorResult);
   addsub   #(N) AS (A, B, subtract, addsubResult,FlagN,FlagC,FlagV);
   shifter  #(N) S (B, A[$clog2(N)-1:0],left,logical0,shiftResult);
   logical  #(N) L (A, B, {bool0,bool1}, logicalResult);

   // Multiplexador de 4 entradas para selecionar a saída
   assign R =  (~shft & math)  ? addsubResult:
               (shft & ~math)  ? shiftResult:
               (~shft & ~math) ? logicalResult:
					(shft & math) ? comparatorResult:
					0;

   // Utilize o operador de redução aqui
   assign FlagZ =    ~(|R) ;

endmodule