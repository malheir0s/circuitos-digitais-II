module mux3 #(
parameter Dbits=32,
parameter Nreg=32
)(
input [Dbits-1:0] a,
input [Dbits-1:0] b,
input [Dbits-1:0] c,
input [1:0] select,
output reg [Dbits-1:0] out
);

always @(*) begin
   case (select)
      2'b00  : out = a;
      2'b01  : out = b;
      2'b10  : out = c;
      default : out = 1'bX;
   endcase
   end
endmodule

