module cd(input wire clk, reset, s_inc, s_inm, we3, wez, input wire [2:0] op_alu, output wire z, output wire [5:0] opcode);
//Camino de datos de instrucciones de un solo ciclo

wire [9:0] pc_next,pc_actual,pc_incrementado,incrementa_direccion;
wire [15:0] instruccion;

wire [3:0] ra1,ra2,wa3;
wire [7:0] rd1,rd2,wd3;
wire [7:0] valor_operado;
wire zalu; //entrada al flip flop que controla el flag Z

//instancio  modulo del contador de programa PC.
registro #(10)registoPC(clk,reset,pc_next,pc_actual);

//inicializo memoria del programa de 1024 x 16 bits

memprog memoria_programa(clk,pc_actual,instruccion);
assign  opcode [5:0]= instruccion[15:10]; //los bits de opcode los envío a la unidad de control.

//instancio el sumador que incrementará el PC en una 2 bytes, ya que la instrucción ocupa 16 bits.

assign incrementa_direccion=10'b0000000001; //valor constante de 1.
sum sum_pc(pc_actual,incrementa_direccion,pc_incrementado);

//mux que decide si pc es el pc incrementado(porque se ejecutó una instrucción normal, o bien
//el pc es la dirección que aparezca en los bits [9:0] de la instrucción.

mux2 #(10) mux_pc(instruccion[9:0],pc_incrementado,s_inc,pc_next);

//instancio banco de 16 registros de ocho bits


assign ra1=instruccion[11:8];
assign ra2=instruccion[7:4];
assign wa3=instruccion[3:0];
regfile banco_registros(clk,we3,ra1,ra2,wa3,wd3,rd1,rd2);

//instancio la alu
alu unidad_alu(rd1,rd2,op_alu,valor_operado,zalu);

//instancio el mux de la alu o valor inmediato
mux2 #(8) mux_alu(valor_operado,instruccion[11:4],s_inm,wd3);

//instancio flip flop Z
ffd ffz(clk,reset,zalu,wez,z);

endmodule
