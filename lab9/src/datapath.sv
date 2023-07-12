
`timescale 1ns / 1ps
`default_nettype none

module datapath #(
    parameter Nreg = 32,
    parameter Dbits = 32
) (
    input wire clk, reset, enable, sext, bsel, werf,
    input wire [Dbits-1:0] instr,
    input wire [1:0] pcsel, wasel, wdsel, asel,
    input wire [4:0] alufn,
    input wire [Dbits-1 : 0] mem_readdata,
    
    output wire Z,
    output wire [Dbits-1:0] mem_addr, mem_writedata, pc
);

    wire [Dbits-1:0] alu_result;
    wire [Dbits-1:0] ReadData1, ReadData2;
    wire [Dbits-1:0] BT, reg_writedata;
    wire [Dbits-1:0] new_pc, current_pc, pc_plus;
    wire [Dbits-1:0] aluA, aluB, signImm;

    
    assign pc_plus = pc + 4; 
    assign mem_addr = alu_result; //OK
    assign mem_writedata = ReadData2; //OK
    assign BT = pc_plus + (signImm<<2); // BT = current_pc + 32'd4 + (signImm << 2) OK
	
	 
	 
							//current_pc + 32'd4;   //BT       //||        //RD             //PCSEL           
    mux4 #(Dbits) new_pc_mux (.in0(pc_plus), .in1(BT), .in2({pc[31:28],instr[25:0],2'b0}), .in3(ReadData1), .sel(pcsel), .out(new_pc)); //OK
    pc program_counter (.clk(clk), 
                                    .reset(reset),
                                    .enable(enable),
                                    .in(new_pc),
                                    .out(pc)); //OK
    
	 
	 
    wire [4:0] reg_writeaddr; 
												//OK							//OK            //OK            //OK         //OK             //OK +-
    mux4 #(5) reg_waddr_mux (.in0( instr[15:11]), .in1(instr[20:16]), .in2(5'b11111), .in3(5'b11011), .sel(wasel), .out(reg_writeaddr));

    register_file #(.Nloc(Nreg), .Dbits(Dbits)) rf  (.clock(clk),
                                                    .wr(werf), 
                                                    .ReadAddr1(instr[25:21]), 
                                                    .ReadAddr2(instr[20:16]), 
                                                    .WriteAddr(reg_writeaddr), 
                                                    .WriteData(reg_writedata), 
                                                    .ReadData1(ReadData1), 
                                                    .ReadData2(ReadData2)); //OK



   
    
	 mux3 #(Dbits,Nreg) mux_asel (.a(ReadData1), .b({27'b0,instr[10:6]}), .c(16), .select(asel), .out(aluA)); //OK 
   
	 sext_value signImm_mux(.sext(sext), .in(instr[15:0]), .out(signImm));
    
    mux2 #(Dbits) B_mux (.in0(ReadData2), .in1(signImm), .sel(bsel), .out(aluB)); //OK
	 
    alu #(.N(Dbits)) alu (.A(aluA),
                            .B(aluB),
                            .R(alu_result), 
                            .ALUfn(alufn), 
                            .FlagZ(Z)); //OK
	
	
	 mux3 #(Dbits,Nreg) mux_wdsel (.a(pc_plus), .b(alu_result), .c(mem_readdata), .select(wdsel), .out(reg_writedata)); //OK
		

endmodule