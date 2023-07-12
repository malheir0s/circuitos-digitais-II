module fulladder (
	input wire A,
	input wire B,
	input wire Cin,
	output wire Sum,
	output wire Cout
);
	
	wire t1, t2, t3, t4, t5;
	xor x1(t1, A, B);
	xor x2(Sum, Cin, t1);
	and a1(t2, A, B);
	and a2(t3, B, Cin);
	and a3(t4, A, Cin);
	or o1(t5, t2, t3);
	or o2(Cout, t4, t5);
	
endmodule