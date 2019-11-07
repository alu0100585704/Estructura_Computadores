iverilog  -o microc microc_tb.v cpu.v microc.v uc.v alu.v componentes.v memprog.v
vvp microc
rem gtkwave microc_tb.vcd
pause