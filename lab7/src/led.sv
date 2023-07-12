module led(
   input logic [7:0] keyb_char,
	 output wire [7:0] LEDG
   );
	
	
	
	 assign LEDG = (
        keyb_char == 8'd1 ? 8'b00000001     
      : keyb_char == 8'd2 ? 8'b00000010   
			: keyb_char == 8'd3 ? 8'b00000100  
			: keyb_char == 8'd4 ? 8'b00001000    
			: keyb_char == 8'd5 ? 8'b00010000    
			: keyb_char == 8'd6 ? 8'b00100000    
			: keyb_char == 8'd7 ? 8'b01000000    
			: keyb_char == 8'd8 ? 8'b10000000 
		: 7'b0000000)	; 
		endmodule
		