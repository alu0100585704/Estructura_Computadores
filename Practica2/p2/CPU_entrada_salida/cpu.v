module cpu(input wire clk, reset);
//Procesador sin memoria de datos de un solo ciclo
wire s_stack,w_push,w_pop,s_jal,s_inc,we3,wez,z,s_puerto,s_puerto_inmediato,g_int,t_int,iret;
wire [2:0] s_inm;
wire [5:0] opcode;
wire [2:0] op_alu;
wire [7:0] valor_leido_puerto, valor_leido_puerto_solo_entrada,valor_escribir_puerto_rd2,valor_escribir_puerto_inm,valor_puerto_rd1;
wire [3:0] direccion_puerto,direccion_puerto_solo_entrada;
wire [127:0] salida_puertos;
reg [127:0] entrada_pines;


initial
begin
    entrada_pines=128'b0;
 #2;
$display("Salida pines puertos (1,2,3) %d  %d %d", salida_puertos[7:0],salida_puertos[15:8],salida_puertos[23:16]);						   				   

  #(10*39);
  entrada_pines=128'b1;
  
#(500*40);
$display("Salida pines puertos (1,2,3) %d  %d %d", salida_puertos[7:0],salida_puertos[15:8],salida_puertos[23:16]);						   				   

  //entrada_pines=128'b0;
#(100500*40);
$display("Salida pines puertos (1,2,3) %d  %d %d", salida_puertos[7:0],salida_puertos[15:8],salida_puertos[23:16]);						   				   

entrada_pines=128'b1;
#(500*40);
$display("Salida pines puertos (1,2,3) %d  %d %d", salida_puertos[7:0],salida_puertos[15:8],salida_puertos[23:16]);						   				   
  
  
end	
cd caminodatos(clk, reset,t_int,iret,s_stack,w_push,w_pop,s_jal, s_inc, s_inm, we3, wez, op_alu,valor_leido_puerto,valor_leido_puerto_solo_entrada,  z,  opcode,direccion_puerto,direccion_puerto_solo_entrada,valor_escribir_puerto_rd2,valor_escribir_puerto_inm,valor_puerto_rd1);
uc unidadcontrol(reset,opcode,  z, g_int,valor_puerto_rd1,direccion_puerto,  s_inc, s_inm, we3, wez, op_alu,s_puerto,s_puerto_inmediato,s_stack,w_push,w_pop,s_jal,t_int,iret);

//instancio modulo de entrada salida. 
in_out entrada_salida(clk, reset,entrada_pines,s_puerto,s_puerto_inmediato,direccion_puerto,direccion_puerto_solo_entrada,valor_escribir_puerto_rd2,valor_escribir_puerto_inm, valor_leido_puerto,valor_leido_puerto_solo_entrada,g_int,salida_puertos);


endmodule
