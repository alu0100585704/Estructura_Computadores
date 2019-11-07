module microc(input wire clk, reset, s_abs, s_inc, s_inm, we3, wez, input wire [2:0] op_alu, output wire z, output wire [5:0] opcode);
//Microcontrolador sin memoria de datos de un solo ciclo

//Instanciar e interconectar pc, memprog, regfile, alu, sum, biestable Z y mux's
wire [9:0] pc_next,pc_actual,pc_incrementado,nuevo_pc;
wire [15:0] instruccion;

wire [7:0] rd1,rd2,wd3;
wire [7:0] valor_operado;
wire zalu; //entrada al flip flop que controla el flag Z

//instancio  modulo del contador de programa PC.
registro #(10) PC(clk,reset,pc_next,pc_actual);

//inicializo memoria del programa de 1024 x 16 bits

memprog memoria_programa(clk,pc_actual,instruccion);
assign  opcode [5:0]= instruccion[15:10]; //los bits de opcode los envío a la unidad de control.

//mux encargado de seleccionar entre valor direccion (s_inc==0) o 1(s_inc==1) Esto es para los saltos relativos o continuar instruccines secuenciales.
mux2 #(10) mux_jr(instruccion[9:0],10'b0000000001,s_inc,pc_incrementado);

//tengo el nuevo PC que será el adecuado a no ser que se haya seleccionado salto absoluto.
sum sum_pc(pc_actual,pc_incrementado,nuevo_pc);

//mux que si s_abs==0 salto pc es igual al la dirección de la instrucción de salto absoluto, de lo contrario, pc=pc +1 o pc=pc+salto relativo
mux2 #(10) mux_s_abs(instruccion[9:0],nuevo_pc,s_abs,pc_next);

//instancio banco de 16 registros de ocho bits
regfile banco_registros(clk,we3,instruccion[11:8],instruccion[7:4],instruccion[3:0],wd3,rd1,rd2);

//instancio la alu
alu unidad_alu(rd1,rd2,op_alu,valor_operado,zalu);


//instancio flip flop Z
ffd ffz(clk,reset,zalu,wez,z);


//instancio el mux de la alu o valor inmediato
mux2 #(8) mux_alu(valor_operado,instruccion[11:4],s_inm,wd3);

endmodule
