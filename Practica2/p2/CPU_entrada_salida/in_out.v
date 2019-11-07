module in_out (input wire clk, reset,input wire [127:0] entrada_pines,input wire s_puerto,s_puerto_inmediato,input wire [3:0] direccion_puerto,direccion_puerto_solo_entrada,input wire [7:0] valor_escribir_puerto_rd2,input wire [7:0] valor_escribir_puerto_inm,output reg [7:0] valor_leido_puerto,output reg [7:0] valor_leido_puerto_solo_entrada,output reg g_int,output wire [127:0] salida_puertos);

wire [7:0] valor_puerto_a_escribir;
wire [127:0] lectura_puertos_de_entrada;
wire [7:0] puerto0,puerto1,puerto2,puerto3,puerto4,puerto5,puerto6,puerto7,puerto8,puerto9,puerto10,puerto11,puerto12,puerto13,puerto14,puerto15;
wire [7:0] puerto16,puerto17,puerto18,puerto19,puerto20,puerto21,puerto22,puerto23,puerto24,puerto25,puerto26,puerto27,puerto28,puerto29,puerto30,puerto31;


always @(posedge reset)
  g_int=0;
  
always @(entrada_pines) //si se detecta cambio en algún pin de los puertos de entrada genera interrupcion, a no ser que se ponga a cero debido un iret de instrucción.  
	begin
		g_int=1;
		#1;
		g_int=0;
	end



//intancio decodificador de selección de puerto.
//deco deco_habilitar_escritura_puerto (puerto_seleccionado,numero_puerto_habilitado);

//instancio mux de seleccion de valor a escribir en puerto, puede ser inmediato o por registro.
mux2 valor_puerto_registro_o_inmediato(valor_escribir_puerto_rd2,valor_escribir_puerto_inm,s_puerto_inmediato,valor_puerto_a_escribir);

//assign entrada_pines=250;

//16 puertos de 8 bits de solo lectura, para conectar a dispsitivos solo de entrada.
regpuertos_read_only banco_puertos_read_only(clk,entrada_pines,lectura_puertos_de_entrada);
//
//instancio banco de registros de 16 por 8 bits. de salida, también se puede leer basándome en el estado de sus flip flops
regpuertos banco_puertos_16( clk,reset,s_puerto, direccion_puerto,  valor_puerto_a_escribir, salida_puertos);
//
assign puerto0=salida_puertos[7:0];
assign puerto1=salida_puertos[15:8];
assign puerto2=salida_puertos[23:16];
assign puerto3=salida_puertos[31:24];
assign puerto4=salida_puertos[39:32];
assign puerto5=salida_puertos[47:40];
assign puerto6=salida_puertos[55:48];
assign puerto7=salida_puertos[63:56];
assign puerto8=salida_puertos[71:64];
assign puerto9=salida_puertos[79:72];
assign puerto10=salida_puertos[87:80];
assign puerto11=salida_puertos[95:88];
assign puerto12=salida_puertos[103:96];
assign puerto13=salida_puertos[111:104];
assign puerto14=salida_puertos[119:112];
assign puerto15=salida_puertos[127:120];

always @(*)

   case (direccion_puerto)
		4'b0000: valor_leido_puerto=puerto0;
		4'b0001: valor_leido_puerto=puerto1;
		4'b0010: valor_leido_puerto=puerto2;
		4'b0011: valor_leido_puerto=puerto3;
		4'b0100: valor_leido_puerto=puerto4;
		4'b0101: valor_leido_puerto=puerto5;
		4'b0110: valor_leido_puerto=puerto6;
		4'b0111: valor_leido_puerto=puerto7;
		4'b1000: valor_leido_puerto=puerto8;
		4'b1001: valor_leido_puerto=puerto9;
		4'b1010: valor_leido_puerto=puerto10;
		4'b1011: valor_leido_puerto=puerto11;
		4'b1100: valor_leido_puerto=puerto12;
		4'b1101: valor_leido_puerto=puerto13;
		4'b1110: valor_leido_puerto=puerto14;
		4'b1111: valor_leido_puerto=puerto15;
		

   endcase
   
   
assign puerto16=lectura_puertos_de_entrada[7:0];
assign puerto17=lectura_puertos_de_entrada[15:8];
assign puerto18=lectura_puertos_de_entrada[23:16];
assign puerto19=lectura_puertos_de_entrada[31:24];
assign puerto20=lectura_puertos_de_entrada[39:32];
assign puerto21=lectura_puertos_de_entrada[47:40];
assign puerto22=lectura_puertos_de_entrada[55:48];
assign puerto23=lectura_puertos_de_entrada[63:56];
assign puerto24=lectura_puertos_de_entrada[71:64];
assign puerto25=lectura_puertos_de_entrada[79:72];
assign puerto26=lectura_puertos_de_entrada[87:80];
assign puerto27=lectura_puertos_de_entrada[95:88];
assign puerto28=lectura_puertos_de_entrada[103:96];
assign puerto29=lectura_puertos_de_entrada[111:104];
assign puerto30=lectura_puertos_de_entrada[119:112];
assign puerto31=lectura_puertos_de_entrada [127:120];

always @(*)

   case (direccion_puerto_solo_entrada)
		4'b0000: valor_leido_puerto_solo_entrada=puerto16;
		4'b0001: valor_leido_puerto_solo_entrada=puerto17;
		4'b0010: valor_leido_puerto_solo_entrada=puerto18;
		4'b0011: valor_leido_puerto_solo_entrada=puerto19;
		4'b0100: valor_leido_puerto_solo_entrada=puerto20;
		4'b0101: valor_leido_puerto_solo_entrada=puerto21;
		4'b0110: valor_leido_puerto_solo_entrada=puerto22;
		4'b0111: valor_leido_puerto_solo_entrada=puerto23;
		4'b1000: valor_leido_puerto_solo_entrada=puerto24;
		4'b1001: valor_leido_puerto_solo_entrada=puerto25;
		4'b1010: valor_leido_puerto_solo_entrada=puerto26;
		4'b1011: valor_leido_puerto_solo_entrada=puerto27;
		4'b1100: valor_leido_puerto_solo_entrada=puerto28;
		4'b1101: valor_leido_puerto_solo_entrada=puerto29;
		4'b1110: valor_leido_puerto_solo_entrada=puerto30;
		4'b1111: valor_leido_puerto_solo_entrada=puerto31;
		

   endcase
   
   
endmodule


//Banco de registros 16x8 registros de salida con opcion a ser leidos basándonos en sus biestables
module regpuertos(input  wire        clk, 
				input wire 			reset,
				input  wire        s_puerto,           //señal de habilitación de escritura
               input  wire [3:0]  direccion_puerto, //direccion de registro
               input  wire [7:0]  valor_puerto_a_escribir, 			 //dato a escribir
               output wire [127:0] salida_puertos);     //valores almacenados en todos los puertos.

  reg [7:0] regb[0:15]; //memoria de 16 registros de 8 bits de ancho

    
always @ (posedge reset)  //inicializo todo a cero
   begin
		regb[0] =0;
		regb[1] =0;
		regb[2] =0;
		regb[3] =0;
		regb[4] =0;		
		regb[5] =0;
		regb[6] =0;	
		regb[7] =0;	
		regb[8] =0;	
		regb[9] =0;	
		regb[10] =0;	
		regb[11] =0;	
		regb[12] =0;	
		regb[13] =0;	
		regb[14] =0;	
		regb[15] =0;	
						
				
   end
   
  always @(posedge clk)  
		if (s_puerto) 
			regb[direccion_puerto] <= valor_puerto_a_escribir;	

assign salida_puertos={regb[15],regb[14],regb[13],regb[12],regb[11],regb[10],regb[9],regb[8],regb[7],regb[6],regb[5],regb[4],regb[3],regb[2],regb[1],regb[0]};

endmodule
//
//Banco de registros 16x8 registros solo lectura
//
module regpuertos_read_only(input wire clk, input wire [127:0] entrada_pines,output wire [127:0] lectura_puertos_de_entrada);     //valores leidos de todos los puertos de lectura

  reg [7:0] regb[0:15]; //memoria de 16 registros de 8 bits de ancho.

  always @(posedge clk)  
	begin
regb[0]<= entrada_pines[7:0];
regb[1]<= entrada_pines[15:8];
regb[2]<= entrada_pines[23:16];
regb[3]<= entrada_pines[31:24];
regb[4]<= entrada_pines[39:32];
regb[5]<= entrada_pines[47:40];
regb[6]<= entrada_pines[55:48];
regb[7]<= entrada_pines[63:56];
regb[8]<= entrada_pines[71:64];
regb[9]<= entrada_pines[79:72];
regb[10]<= entrada_pines[87:80];
regb[11]<= entrada_pines[95:88];
regb[12]<= entrada_pines[103:96];
regb[13]<= entrada_pines[111:104];
regb[14]<= entrada_pines[119:112];
regb[15]<= entrada_pines[127:120];		
	end
                        
assign lectura_puertos_de_entrada={regb[15],regb[14],regb[13],regb[12],regb[11],regb[10],regb[9],regb[8],regb[7],regb[6],regb[5],regb[4],regb[3],regb[2],regb[1],regb[0]};
endmodule
