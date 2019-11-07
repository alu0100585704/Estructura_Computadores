module uc(input wire clk, reset,z,input wire [5:0] opcode, output reg s_abs,s_inc, s_inm,we3,wez, output reg [2:0] op_alu);

//He utilizado el método de EXPANSION para la codificación de instrucciones.
//Codificación.
//Bits:    15  14  13  12  11  10  09  08  07  06  05  04  03  02  01  00
//Saltos:  Op  Op  Op  Op  Op  Op   D   D   D   D   D   D   D   D   D   D
//Inm:     Op  Op  Op  Op   C   C   C   C   C   C   C   C  Rd  Rd  Rd  Rd
//Alu:     Op  Op  Op  Op  R1  R1  R1  R1  R2  R2  R2  R2  Rd  Rd  Rd  Rd

//operaciones en la ALU
parameter [5:0] movr   =6'b0000??;   // mov R1,RD  o sea, R1->RD
parameter [5:0] cpl1r1 =6'b0001??;   // complemento a 1 de  R1,RD  o sea, ~R1-> RD
parameter [5:0] add    =6'b0010??;   // add R1,R2,RD  o sea, R1+R2->RD
parameter [5:0] sub    =6'b0011??;   // sub R1,R2,RD  o sea, R1-R2->RD
parameter [5:0] andr1r2=6'b0100??;   // and  R1,R2,RD  o sea, R1&R2->RD
parameter [5:0] orr1r2 =6'b0101??;   // or R1,R2,RD  o sea, R1|R2->RD
parameter [5:0] cpl2r1 =6'b0110??;   // complemento a 2 R1,RD  o sea, cpl2 R1->RD
parameter [5:0] cpl2r2 =6'b0111??;   // complemento a 2 de  R2,RD o sea, cpl2 R2->RD

//operacion carga inmediata
parameter [5:0] li     =6'b1000??;  //carga inmediata constante,RD    C->RD
//desde opcodes 1001?? hasta 1101?? quedan disponibles para futuras instrucciones de cuatro bits de opcode.(5 instrucciones más)

//operaciones de salto
parameter [5:0] jmp    =6'b111000; // jmp D  (salto absoluto a direccion PC <- D)
parameter [5:0] jr     =6'b111001; // jr D (salto relativo. PC <- PC + D)
parameter [5:0] jabsz  =6'b111010; // jabsz D (salto condicional absoluto si Z==1 a PC <- D)
parameter [5:0] jabsnz =6'b111011; // jabsnz D (salto condicional absoluto si Z==0 a PC <- D)
parameter [5:0] jrz    =6'b111100; // jrz D (salto condicional relativo si Z==1 a PC <- PC + D)
parameter [5:0] jrnz   =6'b111101; // jrnz D (salto condicional relativo si Z==0 a PC <- PC+ D)

//desde opcodes 111110 hasta 111111 quedan disponibles para futuras instrucciones de cuatro bits de opcode.(2 instrucciones más)




always @(posedge reset)
  begin
  				     s_inc=1;
					 s_abs=1;
					 s_inm=0;
					 wez=0;
					 we3=0;
					
  end

always  @(*)
begin

	casez (opcode)
	//operaciones de alu
								movr:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=0;
									wez=1;
									we3=1;
									op_alu=opcode[4:2];
							    end
								
								cpl1r1:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=0;
									wez=1;
									we3=1;
									op_alu=opcode[4:2];
							    end			
								add:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=0;
									wez=1;
									we3=1;
									op_alu=opcode[4:2];
							    end			
								sub:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=0;
									wez=1;
									we3=1;
									op_alu=opcode[4:2];
							    end			
								andr1r2:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=0;
									wez=1;
									we3=1;
									op_alu=opcode[4:2];
							    end			
								orr1r2:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=0;
									wez=1;
									we3=1;
									op_alu=opcode[4:2];
							    end			
								cpl2r1:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=0;
									wez=1;
									we3=1;
									op_alu=opcode[4:2];
							    end			

								cpl2r2:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=0;
									wez=1;
									we3=1;
									op_alu=opcode[4:2];
							    end										

//operaciones de carga inmediata
								li:
								begin
									s_inc=1;	
									s_abs=1;
									s_inm=1;
									wez=0;
									we3=1;
									
							    end										
//operaciones de salto														
												
								jmp:
								begin
									s_abs=0;
									wez=0;
									we3=0;								
							    end										


								jr:
								begin
									s_abs=1;
									s_inc=0;
									wez=0;
									we3=0;								
							    end			


								jabsz:
								begin
									s_inc=1;
									if (z==1)									  
									    s_abs=0;																		     
									else 									  
									    s_abs=1;
									wez=0;
									we3=0;								
							    end										
								
								jabsnz:
								begin
								    s_inc=1;
									if (z==0)
										s_abs=0;
									else 
										s_abs=1;
										
									wez=0;
									we3=0;								
							    end				

								jrz:
								begin
								    s_abs=1;
									
									if (z==1)
										s_inc=0;
									else 
										s_inc=1;
										
									wez=0;
									we3=0;								
							    end										
								
								jrnz:
								begin
								    s_abs=1;
									
									if (z==0)
										s_inc=0;
									else 
										s_inc=1;
										
									wez=0;
									we3=0;								
							    end												
								
																
								
				default:  //por defecto no hay salto y la operacion no es por la alu
				   begin
					 s_abs=1;
					 s_inc=1;
					 s_inm=0;
					 wez=0;
					 we3=0;
					end

	endcase
end


endmodule
