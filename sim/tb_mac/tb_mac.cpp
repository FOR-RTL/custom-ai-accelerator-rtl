#include "Vmac_unit.h"
#include <iomanip>
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
  tfp->open("../waves/systolic_wave.vcd");

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

  // 1. 데이터 스큐잉 (Data Skewing) 셋업 - 빈 공간은 0으로 채움
  // A = [[1,2], [3,4]], B = [[5,6], [7,8]]
  int row_in_0_seq[] = {1, 2, 0, 0, 0, 0, 0};
  int row_in_1_seq[] = {0, 3, 4, 0, 0, 0, 0}; // 1 사이클 지연

  int col_in_0_seq[] = {5, 7, 0, 0, 0, 0, 0};
  int col_in_1_seq[] = {0, 6, 8, 0, 0, 0, 0}; // 1 사이클 지연

  // 2. 리셋
  dut->rst_n = 0;
  dut->row_in_0 = 0;
  dut->row_in_1 = 0;
  dut->col_in_0 = 0;
  dut->col_in_1 = 0;
  tick();
  dut->rst_n = 1;

  // 3. 사이클별로 데이터 주입 및 관찰
  std::cout << "=======================================\n";
  std::cout << " 2x2 Systolic Array Simulation Start!\n";
  std::cout << "=======================================\n";

  for (int cycle = 0; cycle < 6; cycle++) {
    // 입력 포트에 사이클에 맞는 데이터 주입
    dut->row_in_0 = row_in_0_seq[cycle];
    dut->row_in_1 = row_in_1_seq[cycle];
    dut->col_in_0 = col_in_0_seq[cycle];
    dut->col_in_1 = col_in_1_seq[cycle];

    tick(); // 1 클럭 진행! (이때 하드웨어 연산 발생)

    // 현재 사이클의 상태 출력
    std::cout << "\n[ Cycle " << cycle + 1 << " ]\n";
    std::cout << "Inputs  -> Row0:" << dut->row_in_0
              << " Row1:" << dut->row_in_1 << " / Col0:" << dut->col_in_0
              << " Col1:" << dut->col_in_1 << "\n";

    // 2x2 형태를 시각적으로 터미널에 출력
    std::cout << "  [" << std::setw(2) << dut->output_acc00 << "]  ["
              << std::setw(2) << dut->output_acc01 << "]\n";
    std::cout << "  [" << std::setw(2) << dut->output_acc10 << "]  ["
              << std::setw(2) << dut->output_acc11 << "]\n";
  }

  dut->final();
  tfp->close();
  delete tfp;
  delete dut;
  return 0;
}
