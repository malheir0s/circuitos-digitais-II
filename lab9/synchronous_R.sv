`timescale 1ns / 1ps
`default_nettype none

module synchronous_R (
    input wire clk, reset, enable,
    input wire [31:0] in,
    output reg [31:0] out
);

    initial out = 32'h400000;

    
    always @(posedge clk) begin
        
        if (reset)
            out <= 32'h400000;
        else if (enable) 
                out <= in;
    end

endmodule
