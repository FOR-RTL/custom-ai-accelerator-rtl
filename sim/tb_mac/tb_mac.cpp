// sim/tb_mac/tb_mac.cpp
#include "Vmac_unit.h"
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>

vluint64_t main_time = 0;

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);

  Vmac_unit *dut = new Vmac_unit();
  VerilatedVcdC *tfp = new VerilatedVcdC();

  dut->trace(tfp, 99);
  tfp->open("../waves/mac_wave.vcd");

  auto tick = [&]() {
    dut->clk = 1;
    dut->eval();
    tfp->dump(main_time++);

    dut->clk = 0;
    dut->eval();
    tfp->dump(main_time++);
  };

  dut->rst_n = 0;
  dut->a = 0;
  dut->b = 0;
  tick();

  dut->rst_n = 1;
  dut->a = 2;
  dut->b = 3;
  tick();
  std::cout << "Cycle 1 (2*3)     : mul = " << dut->mul_out << std::endl;
  std::cout << "Cycle 2 (2*3 + 0) : acc = " << dut->out << std::endl;

  dut->a = 4;
  dut->b = 5;
  tick();
  std::cout << "Cycle 2 (4*5) : mul = " << dut->mul_out << std::endl;
  std::cout << "Cycle 2 (4*5 + 6) : acc = " << dut->out << std::endl;

  tick();
  std::cout << "Cycle 2 (4*5) : mul = " << dut->mul_out << std::endl;
  std::cout << "Cycle 2 (4*5 + 6) : acc = " << dut->out << std::endl;
  dut->final();
  tfp->close();

  delete tfp;
  delete dut;
  return 0;
}
