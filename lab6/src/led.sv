module led(
   input logic [7:0] keyb_char,
	 output wire [7:0] LEDG
   );
	
	
	
	 assign LEDG = (
        keyb_char == 8'h70 ? 8'b00000001     
      : keyb_char == 8'h69 ? 8'b00000010   
			: keyb_char == 8'h72 ? 8'b00000100  
			: keyb_char == 8'h7A ? 8'b00001000    
			: keyb_char == 8'h68 ? 8'b00010000    
			: keyb_char == 8'h73 ? 8'b00100000    
			: keyb_char == 8'h74 ? 8'b01000000    
			: keyb_char == 8'h6C ? 8'b10000000 
		: 7'b0000000)	; 
		endmodule
		