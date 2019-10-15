module alu(output wire [3:0] R,output wire zero, carry,sign,input wire [3:0] A,B, input wire [1:0] ALUOp, input wire L);
	wire [3:0] OP1;
	wire [3:0] OP2,OP2_ANTES_COMPLEMENTO1;
	wire op1_A,op2_B,cpl,Cin0,Cout0,Cout1,Cout2;
	wire x,y,z;
		//para resultarme más facil con el algebra de boole
		assign {x,y,z}={L,ALUOp[1:0]};
		
		//dependiendo de los valores de L y ALUOp, pongo a 1 op1_A, que después entrará al mux.
		// SU EXPRESION BOLEANA es como suma de productos: y'+x
		assign op1_A = (~y) | x;

		//dependiendo de los valores de L y ALUOp, pongo a 1 op1_B, que después entrará al mux.
		// SU EXPRESION BOLEANA es como suma de productos:  ~y + z + x
														

		assign op2_B = (~y) | z | x;
		
		//dependiendo de los valores de L y ALUOp, pongo a 1 cpl, que después entrará al mux.
		// SU EXPRESION BOLEANA es como suma de productos: ~xz + ~xy 
		assign cpl = (~x&z) |(~x&y);
		//dependiendo de los valores de L y ALUOp, pongo a 1 Cin0, que después entrará al mux.
		// SU EXPRESION BOLEANA es como suma de productos: ~xz + ~xy
		assign Cin0 = (~x&z) | (~x&y);
	
		mux2_4 mux_op1_A(OP1, 4'b0000, A, op1_A);
		mux2_4 mux_op2_B(OP2_ANTES_COMPLEMENTO1, A, B, op2_B);
		compl1 complemento1(OP2,OP2_ANTES_COMPLEMENTO1,cpl);
		//primer bit CAL.
		cal cal0(R[0],Cout0,OP1[0],OP2[0],L,Cin0,ALUOp);
		
		cal cal1(R[1],Cout1,OP1[1],OP2[1],L,Cout0,ALUOp);
		cal cal2(R[2],Cout2,OP1[2],OP2[2],L,Cout1,ALUOp);
		cal cal3(R[3],carry,OP1[3],OP2[3],L,Cout2,ALUOp);
		
		assign sign= R[3]; //signo		
		
		//flag de cero
		assign zero = ~(|R);   //hago OR y como la única forma de que de cero es que todo el valor sea cero, si es así, hago un NOT y pongo a 1 el flag de cero.

endmodule