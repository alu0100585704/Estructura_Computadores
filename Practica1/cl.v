//celda lógica, dependiendo del valor de s, se obtendrá una operación logica aplicada a los bits de entrada a y b.
//00  and, 01 or, 10 xor y 11 not
module cl(output wire out, input wire a, b, input wire[1:0] s);
 wire outand,outor,outxor,outnot;

	and and1(outand,a,b);
	or or1(outor,a,b);
	xor(outxor,a,b);
	not(outnot,a);

	mux4_1 muxcl(out,outand,outor,outxor,outnot,s);

endmodule
