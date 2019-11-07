//Componentes varios

//Banco de registros de dos salidas y una entrada
module regfile(input  wire        clk, 
               input  wire        we3,           //señal de habilitación de escritura
               input  wire [3:0]  ra1, ra2, wa3, //direcciones de regs leidos y reg a escribir
               input  wire [7:0]  wd3, 			 //dato a escribir
               output wire [7:0]  rd1, rd2);     //datos leidos

  reg [7:0] regb[0:15]; //memoria de 16 registros de 8 bits de ancho

  initial
  begin
    $readmemb("regfile.dat",regb); // inicializa los registros a valores conocidos
  end  
  
  // El registro 0 siempre es cero
  // se leen dos reg combinacionalmente
  // y la escritura del tercero ocurre en flanco de subida del reloj
  
  always @(posedge clk)  
begin   
 if (we3) 
 begin
 regb[wa3] <= wd3;	
//$display ("Se va a escribir en el registro %d el valor %d. El valor actual es %d",wa3,wd3,regb[wa3]);
end
 end 
  assign rd1 = (ra1 != 0) ? regb[ra1] : 0;
  assign rd2 = (ra2 != 0) ? regb[ra2] : 0;

endmodule

//modulo sumador  
module sum(input  wire [9:0] a, b,
             output wire [9:0] y);

  assign y = a + b;

endmodule

//modulo registro para modelar el PC, cambia en cada flanco de subida de reloj o de reset
module registro #(parameter WIDTH = 10)
              (input wire             clk, reset,
               input wire [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;

endmodule


//memoria para PC.
module registro_interrupcion #(parameter WIDTH = 10)
              (input wire             clk, t_int,
               input wire [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk)
    if (t_int) 
			q <= d;

endmodule

//modulo multiplexor, si s=1 sale d1, s=0 sale d0
module mux2 #(parameter WIDTH = 8)
             (input  wire [WIDTH-1:0] d0, d1, 
              input  wire             s, 
              output wire [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 

endmodule

//modulo multiplexor de 4, si s=0 sale alu, s=1 sale inmediato,s=2 sale puerto leido, s=3 sale puerto_leido de solo lectura.

module mux8 #(parameter WIDTH = 8)
             (input  wire [WIDTH-1:0] alu, inmediato,puerto_leido,puerto_leido_solo_lectura,valor_pila,
              input  wire [2:0] s, 
              output reg [WIDTH-1:0] y);

always @(*)
begin
   case (s)
		3'b000: y = alu;
		3'b001: y = inmediato;
		3'b010: y = puerto_leido;
		3'b011: y= puerto_leido_solo_lectura;
		3'b011: y= puerto_leido_solo_lectura;
		3'b100: y= valor_pila;
		default: y=alu;
		
    endcase
end
endmodule

//Biestable para el flag de cero
//Biestable tipo D síncrono con reset asíncrono por flanco y entrada de habilitación de carga
module ffd(input wire clk, reset, d, carga, output reg q);

  always @(posedge clk, posedge reset)
    if (reset)
	    q <= 1'b0;
	  else
	    if (carga)
	      q <= d;

endmodule 

module stack(input  wire        clk, w_push,w_pop,               
			   input wire [9:0] escribir_pila,
               output wire [9:0] valor_pila);
  
  
  reg [7:0] i;
  reg [9:0] mem_stack[0:256]; //memoria de 256 palabras de 10 bits, tamaño del PC.

 always @(posedge clk)  
begin   
 if (w_push) 
             begin 
              mem_stack[i]=escribir_pila;
               i=i+1;
              end
 if (w_pop)             
                        i=i-1;

 		
end
  
  initial
	i=0;
    
  
  assign valor_pila= mem_stack[i-1];

endmodule
