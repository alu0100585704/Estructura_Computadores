rem iverilog -Wall -o cpu cpu_tb.v cpu.v cd.v uc.v alu.v componentes.v memprog.v in_out.v
iverilog  -o cpu cpu_tb.v cpu.v cd.v uc.v alu.v componentes.v memprog.v in_out.v
vvp cpu
rem gtkwave cpu_tb.vcd
pause