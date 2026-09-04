# sim/tb_mac/Makefile

HW_SRC = ../../hw/core/pe_unit.sv ../../hw/core/mac_unit.sv
TB_SRC = tb_mac.cpp

all: run

run:
	mkdir -p ../waves
	# --top-module mac_unit 을 추가하여 Top을 강제 지정합니다!
	verilator -Wall -Wno-PINCONNECTEMPTY --trace --cc --exe --build --top-module mac_unit $(HW_SRC) $(TB_SRC)
	./obj_dir/Vmac_unit

clean:
	rm -rf obj_dir ../waves/*.vcd
