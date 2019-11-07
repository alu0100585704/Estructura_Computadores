module uc(input wire [5:0] opcode, input wire z, output wire s_inc, s_inm, we3, wez, output wire [2:0] op_alu);

//opcodes definicos:

//Bits [15:12] 1xxx Operación de alu, donde xxx identifica el tipo de operacion
//Bits [15:12] 0100 Operación de carga inmediata en registro
//Bits [15:10] 000100 salto incondicional.
//Bits [15:10] 000010 jz salto condicional si z=1
//Bits [15:10] 000001 jnz salto condicional si z=0

// salto condicional activado si es absoluto o si es condicional ya z = 0 o z=1 según su opcode.

assign s_inc=(opcode==6'b000100) | ((opcode==6'b000010) &  (z==1'b1)) | ((opcode==6'b000001) &  (z==1'b0))? 0:1;

//activo carga inmediata
assign s_inm=(opcode[5:2]==4'b0100)? 1:0;

//asigno el op_alu si es el opcode es operacion de alu.
assign op_alu=(opcode[5]==1'b1)? opcode[4:2]:0;

//activo we3 siempre que no sea una instruccion de salto, o sea, solo si es de carga inmediata o de alu
assign we3=(opcode[5:2]==4'b0100) | (opcode[5]==1'b1) ? 1:0;

//activo escrigura de flag z si es operacion de alu, puesto que son las únicas que pueden modificar este flag.

assign wez=(opcode[5]==1'b1) ? 1:0;

endmodule