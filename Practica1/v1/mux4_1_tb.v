// Testbench para multiplexor 4 entradas

`timescale 1 ns / 10 ps //Directiva que fija la unidad de tiempo de simulación y el paso de simulación
module mux4_1_tb;

//declaracion de señales

reg[1:0] s;
reg a,b,c,d;
wire out;

//instancio el mux 4 en uno
mux4_1 mux(out,a,b,c,d,s);

initial
begin
  $monitor("A=%0b B=%b C=%b D=%b Salida=%b Seleccion=%b", a, b, c, d, out,s);
  $dumpfile("mux4_1_tb.vcd");
  $dumpvars;
  
//Algunos valores de prueba
a=1'b1;
b=1'b0;
c=1'b0;
d=1'b0;
s=2'b00;

  #1;

//Algunos valores de prueba
a=1'b1;
b=1'b0;
c=1'b0;
d=1'b1;
s=2'b11;

#2;  
//Algunos valores de prueba
a=1'b1;
b=1'b0;
c=1'b0;
d=1'b0;
s=2'b01;
  
  
  //fin simulacion
  $finish;
end

endmodule
