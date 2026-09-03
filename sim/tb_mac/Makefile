# sim/tb_mac/Makefile

HW_SRC = ../../hw/core/mac_unit.sv
TB_SRC = tb_mac.cpp

all: run

run:
	mkdir -p ../waves
	
	verilator -Wall --trace --cc --exe --build $(HW_SRC) $(TB_SRC)
	
	./obj_dir/Vmac_unit

clean:
	rm -rf obj_dir ../waves/*.vcd
