iverilog  -o alu alu_tb.v alu.v mux4_1.v mux2_1.v mux2_4.v fa.v cal.v cl.v compl1.v 
vvp alu
rem gtkwave alu.vcd
pause