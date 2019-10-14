//celda aritmético lógica. con l a 1 se obtine salida de la celda lógica, con l a 0 se obtiene salida del full-adder.
module cal(output wire out, c_out,input wire a,b,l,c_in,input wire [1:0] s);
	wire out_fa, out_cl;
	//instancio full adder y celda lógica.
	fa fa1(cout,out_fa,a,b,c_in);
	cl cl1(out_cl,a,b,s);
	
	mux2_1 mux_fa_o_cl(out, out_fa, out_cl,l); 
endmodule