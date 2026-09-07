#include "Vsystolic_array_nxn.h"
#include <iomanip>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define N 3

vluint64_t main_time = 0;

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);

  Vsystolic_array_nxn *dut = new Vsystolic_array_nxn();
  VerilatedVcdC *tfp = new VerilatedVcdC();
  dut->trace(tfp, 99);
  tfp->open("../waves/systolic_nxn_wave.vcd");

  auto tick = [&]() {
    dut->eval();
    tfp->dump(main_time++);
    dut->clk = 1;
    dut->eval();
    tfp->dump(main_time++);
    dut->clk = 0;
    dut->eval();
    tfp->dump(main_time++);
  };

  int A[N][N] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
  int B[N][N] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};

  dut->rst_n = 0;
  for (int i = 0; i < N; i++) {
    dut->row_in[i] = 0;
    dut->col_in[i] = 0;
  }
  tick();
  dut->rst_n = 1;

  int TOTAL_CYCLES = 3 * N;

  std::cout << "🚀 " << N << "x" << N
            << " Systolic Array Simulation Start!\n\n";

  for (int cycle = 0; cycle < TOTAL_CYCLES; cycle++) {

    for (int i = 0; i < N; i++) {

      if (cycle >= i && cycle - i < N) {
        dut->row_in[i] = A[i][cycle - i];
      } else {
        dut->row_in[i] = 0;
      }

      if (cycle >= i && cycle - i < N) {
        dut->col_in[i] = B[cycle - i][i];
      } else {
        dut->col_in[i] = 0;
      }
    }

    tick();

    std::cout << "[ Cycle " << cycle + 1 << " ]\n";
    for (int i = 0; i < N; i++) {
      std::cout << "  ";
      for (int j = 0; j < N; j++) {
        std::cout << "[" << std::setw(3) << dut->out_acc[i][j] << "] ";
      }
      std::cout << "\n";
    }
    std::cout << "------------------------\n";
  }

  dut->final();
  tfp->close();
  delete tfp;
  delete dut;
  return 0;
}
