// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Autor  	: joaocarlos
// Arquivo	: fsm_template.sv
// Editor 	: Visual Studio Code, tab size (3)
// -----------------------------------------------------------------------------
// Descrição:
//    Modelo de implementação de FSM em SystemVerilog
// -----------------------------------------------------------------------------
// Entradas: 
//    clk    : clock da FSM
//    rst  : sinal de reset da FSM
//    inputs : especifique os sinais de entrada
// -----------------------------------------------------------------------------
// Saidas:
//    outputs : especifique os sinais de saída
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module fsm (
   input  wire  clk,
   input  wire  key0, key1, key2,     // Lista de entradas da FSM
   output logic countup, paused, // Lista de saídas da FSM
   output logic [7:0] keyb_char
                                       // As saídas devem ser sintetizadas como lógica combinacional!
);


   // A próxima linha é o nossa codificação de estados
   // Aqui usamos o comando enum da SystemVerilog. 
   // Você enumera os estados e o compilador decide o padrão de codificação
   //enum { STATE0, STATE1, STATE2, STATE3, STATE4, STATE5, STATE6, STATE7 } state, next_state;

   // -- OU --   
   // Você pode especificar a codificação de estados
   enum { STATE0=1, STATE1=2, STATE2=3, STATE3=4, STATE4=5, STATE5=6, STATE6=7, STATE7=8} state, next_state;



   // Instancia os elementos de armazenamento de estado (flip-flops)
   always@ (*)
      keyb_char <= state;
   
   always @(posedge clk)
      state <= next_state;
  
   // Defina a lógica de próximo estado => combinatória
   // Cada clausula deve ser uma expressão condicional
   // ou um "if" com um "else"
   
   /*
   always @(*)     
   case (state)
      STATE0: next_state = key2 ? STATE2 :
                           key0 ? STATE1 :
                           state;
      STATE1: next_state = key2 ? STATE7 :
                            key1 ? STATE0 :
                            state;
      STATE2: next_state = (~key2) ? STATE4 : state;
      STATE3: next_state = (~key2) ? STATE1 : state;
      STATE4: next_state = key2 ? STATE6 :
                            key0 ? STATE5 : state;
      STATE5: next_state = key2 ? STATE3 : 
                           key1 ? STATE4 : state;
      STATE6: next_state = (~key2) ? STATE0 : state;
      STATE7: next_state = (~key2) ? STATE5 : state;
      default: next_state = STATE0;
   endcase
   */

   always @(*)     
   case (state)
      STATE0: begin
         if (key2)
            next_state <= STATE2;
         else if(key0)
            next_state <= STATE1;
         else
            next_state <= state;
      end
      STATE1: begin
         if (key2)
            next_state <= STATE7;
         else if(key1)
            next_state <= STATE0;
         else
            next_state <= state;
      end
      STATE2: begin
         if (~key2)
            next_state <= STATE4;
         else
            next_state <= state;
      end
      STATE3: begin
         if (~key2)
            next_state <= STATE1;
         else
            next_state <= state;
      end
      STATE4: begin
         if (key2)
            next_state <= STATE6;
         else if(key0)
            next_state <= STATE5;
         else
            next_state <= state;
      end
      STATE5: begin
         if (key2)
            next_state <= STATE3;
         else if(key1)
            next_state <= STATE4;
         else
            next_state <= state;
      end
      STATE6: begin
         if (~key2)
            next_state <= STATE0;
         else
            next_state <= state;
      end
      STATE7: begin
         if (~key2)
            next_state <= STATE5;
         else
            next_state <= state;
      end
      default: next_state <= STATE0;
   endcase



   // Defina a lógica de saída => combinatória
   // Cada clausula deve ser uma expressão condicional
   // ou um "if" com um "else"
   always @(*)     
   case (state)
      STATE0: {countup, paused} = 2'b10;
      STATE1: {countup, paused} = 2'b00;
      STATE2: {countup, paused} = 2'b10;
      STATE3: {countup, paused} = 2'b01;
      STATE4: {countup, paused} = 2'b11;
      STATE5: {countup, paused} = 2'b01;
      STATE6: {countup, paused} = 2'b11;
      STATE7: {countup, paused} = 2'b00;
      default: {countup, paused} = 2'b10;
   endcase

endmodule