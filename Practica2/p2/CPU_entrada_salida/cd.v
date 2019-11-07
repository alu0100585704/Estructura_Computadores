module cd(input wire clk, reset, input wire t_int,iret ,input wire s_stack,w_push,w_pop,s_jal,s_inc, input wire [2:0] s_inm, input wire we3, wez, input wire [2:0] op_alu, input wire [7:0] valor_leido_puerto,input wire [7:0] valor_leido_puerto_solo_entrada, output wire z, output wire [5:0] opcode,output wire [3:0] direccion_puerto,output wire [3:0] direccion_puerto_solo_entrada,output wire [7:0] valor_escribir_puerto_rd2,output wire [7:0] valor_escribir_puerto_inm,output wire [7:0] valor_puerto_rd1);
//Camino de datos de instrucciones de un solo ciclo

wire [9:0] pc_next,pc_actual,pc_incrementado,incrementa_direccion,dir_salto,valor_pila,escribir_pila,direccion_interrupcion,direccion_salto,pc_next_guardado,direccion_iret_o_interrupcion;
wire [15:0] instruccion;

wire [3:0] ra1,ra2,wa3;
wire [7:0] rd1,rd2,wd3;
wire [7:0] valor_operado;
wire zalu; //entrada al flip flop que controla el flag Z

//inicializo memoria del programa de 1024 x 16 bits

memprog memoria_programa(clk,pc_actual,instruccion);
assign  opcode [5:0]= instruccion[15:10]; //los bits de opcode los envío a la unidad de control.

//instancio el sumador que incrementará el PC en una 2 bytes, ya que la instrucción ocupa 16 bits.

assign incrementa_direccion=10'b0000000001; //valor constante de 1.
sum sum_pc(pc_actual,incrementa_direccion,pc_incrementado);


//mux que decide si pc  es la dirección que aparezca en los bits [9:0] de la instrucción
//o bien , el valor último en entrar de la pila,

mux2 #(10) mux_salto_pila(instruccion[9:0],valor_pila,s_stack,dir_salto);

//mux que decide si pc es el pc incrementado(porque se ejecutó una instrucción normal, o bien
//el pc es la dirección que aparezca en los bits [9:0] de la instrucción.

mux2 #(10) mux_pc(dir_salto,pc_incrementado,s_inc,pc_next);

//instancio banco de 16 registros de ocho bits

assign ra1=instruccion[11:8];
assign ra2=instruccion[7:4];
assign wa3=instruccion[3:0];
regfile banco_registros(clk,we3,ra1,ra2,wa3,wd3,rd1,rd2);


//instancio  modulo del registro que almacena el PC que contenía antes de una interrupción
registro_interrupcion #(10)registointerrupcion(clk,t_int,pc_next,pc_next_guardado);

assign direccion_interrupcion=10'b1100100000; //direccion 800 decimal donde residirá la rutina de tratamiento de interrucpciones generadas por cualquier cambio en los registros de entrada, o sea, los 128 bits asignados a entrada_pines
//mux que decide segun iret si direccion interrupcion o bien pc next almacenado tras una interrupcion
mux2 #(10) mux_pc_next_guardado_o_direccion_interrupcion(direccion_interrupcion,pc_next_guardado,iret,direccion_iret_o_interrupcion);


mux2 #(10) mux_salto_interrupcion(pc_next,direccion_iret_o_interrupcion,t_int,direccion_salto);


//instancio  modulo del contador de programa PC.
registro #(10)registoPC(clk,reset,direccion_salto,pc_actual);

// mux anterior a la pila, dependiendo de s_jal, entra rd1 o pc_incrementado
mux2 #(10) mux_stack({2'b00,rd1},pc_incrementado,s_jal,escribir_pila);



//instancio pila  de 256 posiciones de memoria de 10 bits
stack pila_lifo(clk,w_push,w_pop,escribir_pila,valor_pila);

//instancio la alu
alu unidad_alu(rd1,rd2,op_alu,valor_operado,zalu);

//instancio el mux de la alu, valor inmediato o valor puerto leido o valor puerto leido desde puerto de solo lectura
mux8 #(8) mux_alu(valor_operado,instruccion[11:4],valor_leido_puerto,valor_leido_puerto_solo_entrada,valor_pila[7:0],s_inm,wd3);



//instancio flip flop Z
ffd ffz(clk,reset,zalu,wez,z);


assign direccion_puerto=ra1; //como salida la la direccion de este registro que se usará en las instrucciones de entrada salida., como dirección de puerto.
assign direccion_puerto_solo_entrada=ra2; //como salida la direccion del puerto rd2, que será utilizada como indice en el caso de lectura de puertos de solo entrada
assign valor_escribir_puerto_rd2=rd2; //como salida valor a escribir en caso de que sea una operacion de escritura a un puerto.
assign valor_escribir_puerto_inm=instruccion[11:4];
assign valor_puerto_rd1=rd1; //como salida valor del registro indicado en ra1, o sea, el contenido de rd1, para usarlo en el comando display.
endmodule
