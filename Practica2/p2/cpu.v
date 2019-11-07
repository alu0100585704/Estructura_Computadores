module cpu(input wire clk,reset);

//Procesador sin memoria de datos de un solo ciclo

wire s_abs,s_inc,s_inm,we3,wez,z;
wire [5:0] opcode;
wire [2:0] op_alu;

//instancio camino de datos
microc caminodatos(clk, reset, s_abs, s_inc, s_inm, we3, wez, op_alu,  z,  opcode);

//instancio unidad de control
uc unidadcontrol(clk, reset,z, opcode,  s_abs, s_inc, s_inm, we3, wez, op_alu);

endmodule
