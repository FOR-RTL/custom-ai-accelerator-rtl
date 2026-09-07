#include "Vtop_core.h" // 이름이 바뀐 최상위 헤더!
#include <iomanip>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define N 3

vluint64_t main_time = 0;

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);

  Vtop_core *dut = new Vtop_core();
  VerilatedVcdC *tfp = new VerilatedVcdC();
  dut->trace(tfp, 99);
  tfp->open("../waves/top_core_wave.vcd");

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
    dut->flat_row_in[i] = 0;
    dut->flat_col_in[i] = 0;
  }
  tick();
  dut->rst_n = 1;

  int TOTAL_CYCLES = 3 * N;
  std::cout << "🚀 Hardware Skewing " << N << "x" << N
            << " Simulation Start!\n\n";

  for (int cycle = 0; cycle < TOTAL_CYCLES; cycle++) {

    // ✨ 이 테스트벤치의 하이라이트: 복잡한 엇갈림 계산이 싹 사라짐! ✨
    for (int i = 0; i < N; i++) {
      if (cycle < N) {
        // 그냥 정직하게 cycle 인덱스에 맞춰 데이터를 통째로 밀어넣음
        dut->flat_row_in[i] = A[i][cycle];
        dut->flat_col_in[i] = B[cycle][i];
      } else {
        // N 사이클 이후에는 데이터를 다 넣었으니 빈 값(0)만 줌
        dut->flat_row_in[i] = 0;
        dut->flat_col_in[i] = 0;
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
