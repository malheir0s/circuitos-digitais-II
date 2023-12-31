`default_nettype none

module comparator (
   input  wire FlagN, FlagV, FlagC, bool0,
   output wire comparison
);

   assign comparison =   bool0 ?   (FlagV | FlagN) : ~FlagC;

endmodule