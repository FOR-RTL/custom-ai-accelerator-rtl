HW_SRC = ../../hw/core/pe_unit.sv \
         ../../hw/core/skewing_buffer_nxn.sv \
         ../../hw/core/systolic_array_nxn.sv \
         ../../hw/core/top_core.sv

TB_SRC = tb_top_core.cpp

all: run

run:
	mkdir -p ../waves
	verilator -Wall -Wno-PINCONNECTEMPTY --trace --cc --exe --build --top-module top_core $(HW_SRC) $(TB_SRC)
	./obj_dir/Vtop_core

clean:
	rm -rf obj_dir ../waves/*.vcd
