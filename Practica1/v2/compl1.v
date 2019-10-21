// si cpl es 1 salida es igual al complemento a 1, sino, salida = entrada
module compl1(output wire [3:0] sal,input wire [3:0] ent, input wire cpl);
	assign sal= cpl ? ~ent : ent;
endmodule