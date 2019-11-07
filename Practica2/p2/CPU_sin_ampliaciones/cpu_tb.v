`timescale 1 ns / 10 ps

module cpu_tb;


reg clk, reset;


// generaci�n de reloj clk
always //siempre activo, no hay condici�n de activaci�n
begin
  clk = 1'b0;
  #30;
  clk = 1'b1;
  #30;
end

// instanciaci�n del procesador
cpu micpu(clk, reset);

initial
begin
  $dumpfile("cpu_tb.vcd");
  $dumpvars;
  reset=0;
  #1
  reset = 1;  //a partir del flanco de subida del reset empieza el funcionamiento normal
  #10;
  reset = 0;  //bajamos el reset 
end

initial
begin
  #(30*60);  //Esperamos 1010 ciclos o 1010 instrucciones, puesto que el contador puede ser de hasta 256.
  $finish;
end

endmodule