module mac_unit (
    input logic clk,
    input logic rst_n,

    input logic [31:0] row_in_0,
    input logic [31:0] row_in_1,

    input logic [31:0] col_in_0,
    input logic [31:0] col_in_1,

    output logic [31:0] output_acc00,
    output logic [31:0] output_acc01,
    output logic [31:0] output_acc10,
    output logic [31:0] output_acc11

);

  logic [31:0] wire_a_00_to_01;
  logic [31:0] wire_a_10_to_11;
  logic [31:0] wire_b_00_to_10;
  logic [31:0] wire_b_01_to_11;

  // logic [31:0] dummy_a_01;
  // logic [31:0] dummy_a_11;
  // logic [31:0] dummy_b_10;
  // logic [31:0] dummy_b_11;


  pe_unit pe00 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(row_in_0),
      .in_b(col_in_0),
      .out_a(wire_a_00_to_01),
      .out_b(wire_b_00_to_10),
      .out_acc(output_acc00)
  );

  pe_unit pe01 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(wire_a_00_to_01),
      .in_b(col_in_1),
      .out_a(),
      .out_b(wire_b_01_to_11),
      .out_acc(output_acc01)
  );

  pe_unit pe10 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(row_in_1),
      .in_b(wire_b_00_to_10),
      .out_a(wire_a_10_to_11),
      .out_b(),
      .out_acc(output_acc10)
  );

  pe_unit pe11 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(wire_a_10_to_11),
      .in_b(wire_b_01_to_11),
      .out_a(),
      .out_b(),
      .out_acc(output_acc11)
  );

endmodule
