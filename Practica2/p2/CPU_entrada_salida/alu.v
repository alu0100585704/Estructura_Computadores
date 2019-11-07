module alu(input wire [7:0] a, b,
           input wire [2:0] op_alu,
           output wire [7:0] y,
           output wire zero);

reg [7:0] s;		   
		   
always @(a, b, op_alu)
begin
  case (op_alu)              
    //3'b000: s = a; 	 aprovecho esta combinaci�n puesto que me hace falta para mas instrucciones. el equivalente a esta opci�n lo puedo complementar con a + b siendo b el registro 0,
	//obteniendo as� el mismo resultado.
    3'b001: s = ~a;
    3'b010: s = a + b;
    3'b011: s = a - b;
    3'b100: s = a & b;
    3'b101: s = a | b;
    3'b110: s = -a;
    3'b111: s = -b;
	default: s = 'bx; //desconocido en cualquier otro caso (x � z), por si se modifica el c�digo
  endcase
end

assign y = s;

//Calculo del flag de cero
assign zero = ~(|y);   //operador de reducci�n |y hace la or de los bits del vector 'y' y devuelve 1 bit resultado
		   
endmodule
