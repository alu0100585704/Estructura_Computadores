module uc(input wire clk, reset,z,input wire [5:0] opcode, output reg s_abs,s_inc, s_inm,we3,wez, output reg [2:0] op_alu);



//opcodes definicos:

//Bits [15:10] 100000xxxxxxxxxx  jal, PC=xxxxxxxxxx y PC+1 a la pila.
//Bits [15:10] 100001??????????  jr, salta donde diga valor de pila
//Bits [15:10] 100010??????xxxx  pop pila a registro indicado por xxxx
//Bits [15:10] 100011??????????  iret, salta donde diga valor de pila y restaura flag g_int a cero, indicando que ya se ha terminado de atender la interrupción
//Bits [15:12] 1???aaaabbbbcccc Operación de alu, donde ? identifica el tipo de operacion, a operando 1(numero de registro) y b operando 2(numero de registro), resultado en c(numero de registro destino)
//Bits [15:12] 0100xxxxxxxxzzzz Operación de carga inmediata en registro, x valor inmediato de 8 bits y z(numero de registro donde almacenar el resultado)

//Bits [15:12] 0101xxxx0000zzzz Opercion IN puerto como registro(x),registro destino(z)
//Bits [15:12] 0110xxxxzzzzzzzz Opercion OUT puerto como registro(x),valor inmediato(z)
//Bits [15:12] 0111xxxxzzzz0000 Opercion OUT puerto como registro(x),registro(z)

//Bits [15:12] 0010xxxx???????? Opercion debug(para debug), puestra el valor del registro xxxx, o sea, el valor rd1
//Bits [15:12] 0011xxxx???????? push pila valor del registro indicado en xxxx
//Bits [15:12] 0001????xxxxzzzz Operación IN puerto de solo lectura. xxxx(numero de puerto) zzzz(registro destino) inr

//Bits [15:10] 000001xxxxxxxxxx salto incondicional x direccion del banco de memoria
//Bits [15:10] 000010xxxxxxxxxx jz salto condicional si z=1. x direccion del salto de memoria
//Bits [15:10] 000011xxxxxxxxxx jnz salto condicional si z=0  x direccion de la memoria.

 
 
//  libre_pero_no_recomendada= 6'b000000; //libre pero a no ser que termine bien el programa, como el fichero de instrucciones esta lleno de esta combinación, podrían ejecutarse la instruccion utilizada
//con este teórico opcode repetidas veces.

parameter [5:0] jal=            6'b100000; //estas deben de ir primero en el case, porque si no provocarían conflictos con las operaciones de alu.
parameter [5:0] jr=             6'b100001;
parameter [5:0] pop=           6'b100010; 
parameter [5:0] iret_int=           6'b100011; //instruccion iret(retorno de interrupcion)
// parameter [5:0] libre_pero_no_recomendada= 6'b000000; //libre pero a no ser que termine bien el programa, como el fichero de instrucciones esta lleno de esta combinación, podrían ejecutarse la instruccion utilizada
//con este teórico opcode repetidas veces.

parameter [5:0] operacion_alu=  6'b1?????;
parameter [5:0] carga_inmediata=6'b0100??;

parameter [5:0] in_registro =   6'b0101??;
parameter [5:0] out_inmediato = 6'b0110??;
parameter [5:0] out_registro =  6'b0111??;
parameter [5:0] debug=            6'b0010??;
parameter [5:0] push=           6'b0011??;
parameter [5:0] in_solo_lectura=6'b0001??;

parameter [5:0] jmp = 		    6'b000001;
parameter [5:0] jz =            6'b000010;
parameter [5:0] jnz =           6'b000011;
/*

always @(posedge reset)
  begin
  				     s_inc=1;
					 s_inm=3'b000;
					 wez=0;
					 we3=0;
					 s_puerto=0;
					s_puerto_inmediato=0;					 
					w_push=0;
					w_pop=0;
					s_stack=2'b00;					
					t_int=0;
					int_en_curso=0;
					s_jal=0;
				   t_int=0;					
					int_en_curso=0;
					iret=0;
  end

always @(posedge g_int)
	if (int_en_curso==0)
		begin	
			int_en_curso=1;
			t_int=1;			
			iret=0;
		end	

always  @(*)
begin

	casez (opcode)
								jal:
								begin
								s_inc=0;
								s_inm=3'b000;
								wez=0;
								we3=0;
								s_puerto=0;
								s_puerto_inmediato=0;					 
								w_push=1;
								w_pop=0;
								s_stack=2'b00;     
								s_jal=1;
								   t_int=0;
								iret=0;								   
								end
								
								jr:
								begin
								s_inc=0;
								s_inm=3'b000;
								wez=0;
								we3=0;
								s_puerto=0;
								s_puerto_inmediato=0;					 
								w_push=0;
								w_pop=1;
								s_stack=2'b01;                                
								s_jal=0;
								   t_int=0;
								iret=0;								   
								end
								
								
                                pop:
                                begin
								s_inc=1;
								s_inm=3'b100;
									wez=0;
									we3=1;
								s_puerto=0;
								s_puerto_inmediato=0;					 
								w_push=0;
								w_pop=1;
								s_stack=2'b00;                                
								s_jal=0;       
								   t_int=0;
								iret=0;
                                end

                                iret_int:
                                begin
								s_inc=0;
								s_inm=3'b000;
								wez=0;
								we3=0;
								s_puerto=0;
								s_puerto_inmediato=0;					 
								w_push=0;
								w_pop=1;
								s_stack=2'b01;                                
								s_jal=0;
								int_en_curso=0;
								 t_int=1;
								 iret=1;

                                end       
								
                                push:
                                begin
								s_inc=1;
								s_inm=3'b000;
									wez=0;
									we3=0;
								s_puerto=0;
								s_puerto_inmediato=0;					 
								w_push=1;
								w_pop=0;
								s_stack=2'b00;                                
								s_jal=0;	
								   t_int=0;
								iret=0;								   
                                end
								
                                				
				in_solo_lectura:
						begin
						  s_puerto=0; //las operaciones de lectura de puertos de solo entrada no las considero como puerto,puesto que s_puerto es el flag para habilitar la escritura en 
									//el bando de registros de salida.
						  s_puerto_inmediato=0;
						  we3=1;
						  wez=0;
						  s_inc=1;
						  s_inm=3'b011; //operacion de lectura en el mux indicando lectura valor del puerto de entrada seleccionado en ra2
					w_push=0;
					w_pop=0;
					s_stack=2'b00;
								s_jal=0;						  
								   t_int=0;
								iret=0;
						end 

				jmp: 
						begin
						s_inc=0;
						wez=0;
						we3=0;
						s_inm=3'b000;
						s_puerto=0;
					w_push=0;
					w_pop=0;
					s_stack=2'b00;
								s_jal=0;		
								   t_int=0;
								iret=0;
						end
					
			    jz:
					begin
					if (z==1)
						s_inc=0;
						else 
						s_inc=1;
						wez=0;
						we3=0;
						s_inm=3'b000;
						s_puerto=0;
					w_push=0;
					w_pop=0;
					s_stack=2'b00;			
								s_jal=0;					
								   t_int=0;
								iret=0;
				    end
				jnz:
					begin
					if (z==0)
						s_inc=0;
						else
						s_inc=1;
						wez=0;
						we3=0;
					s_inm=3'b000;
					s_puerto=0;
					w_push=0;
					w_pop=0;
					s_stack=2'b00;			
								s_jal=0;		
								   t_int=0;
								iret=0;
				    end
						
				carga_inmediata: 
					begin
					 s_inm=3'b001;
					 we3=1;
					 wez=0;
				     s_inc=1;					 
					 s_puerto=0;
					 					w_push=0;
					w_pop=0;
					s_stack=2'b00;
													s_jal=0;
								   t_int=0;
								iret=0;
						end
			    
				operacion_alu:
						begin
						op_alu=opcode[4:2];
						we3=1;
						wez=1;
						s_inm=3'b000;						
						s_inc=1;						
						s_puerto=0;						
					w_push=0;
					w_pop=0;
					s_stack=2'b00;						
													s_jal=0;
								   t_int=0;
								iret=0;
						end
						
				out_inmediato:
						begin
						  s_puerto=1;
						  s_puerto_inmediato=1;
						  we3=0;
						  wez=0;
						  s_inc=1;
						  s_inm=3'b010; //indico puerto leido
					w_push=0;
					w_pop=0;
					s_stack=2'b00;						  
													s_jal=0;
								   t_int=0;
								iret=0;
						end
						
				out_registro:
						begin
						  s_puerto=1;
						  s_puerto_inmediato=0;
						  we3=0;
						  wez=0;
						  s_inc=1;
						  s_inm=3'b010; //
					w_push=0;
					w_pop=0;
					s_stack=2'b00;						  
													s_jal=0;
								   t_int=0;
								iret=0;
						end
				in_registro:
						begin
						  s_puerto=0;
						  s_puerto_inmediato=0;
						  we3=1;
						  wez=0;
						  s_inc=1;
						  s_inm=3'b010; //
					w_push=0;
					w_pop=0;
					s_stack=2'b00;						  
													s_jal=0;
								   t_int=0;
								iret=0;
						end
				debug:
						begin
						s_inc=1;
						wez=0;
						we3=0;
						s_inm=3'b000;
						s_puerto=0;								
						s_puerto_inmediato=0;
											w_push=0;
					w_pop=0;
					s_stack=2'b00;
								   t_int=0;
								iret=0;
						#1;
						   $display("Valor registro numero %d : %d", direccion_puerto,rd1);						   				   
						   s_jal=0;
						end						
															
															
				default:  //por defecto no hay salto y la operacion es por la alu y no es una operacion de puerto
				   begin
				     s_inc=1;
					 s_inm=3'b000;
					 wez=0;
					 we3=0;
					 s_puerto=0;
					s_puerto_inmediato=0;					 
					w_push=0;
					w_pop=0;
					s_stack=2'b00;					
					t_int=0;
					int_en_curso=0;
													s_jal=0;
								   t_int=0;
								iret=0;
				   end

	endcase
end
*/

endmodule
