iverilog  -o microc microc_tb.v cpu.v microc.v uc.v alu.v componentes.v memprog.v
vvp cpu
rem gtkwave cpu_tb.vcd
pause