module mac_unit (
    input logic clk,
    input logic rst_n,

    input logic [31:0] row_in_0,
    input logic [31:0] row_in_1,
    input logic [31:0] row_in_2,

    input logic [31:0] col_in_0,
    input logic [31:0] col_in_1,
    input logic [31:0] col_in_2,

    output logic [31:0] output_acc_a_100,
    output logic [31:0] output_acc_a_010,
    output logic [31:0] output_acc_a_001,
    output logic [31:0] output_acc_b_100,
    output logic [31:0] output_acc_b_010,
    output logic [31:0] output_acc_b_001,
    output logic [31:0] output_acc_c_100,
    output logic [31:0] output_acc_c_010,
    output logic [31:0] output_acc_c_001

);

  logic [31:0] wire_col_a100_to_a010;
  logic [31:0] wire_col_a010_to_a001;

  logic [31:0] wire_col_b100_to_b010;
  logic [31:0] wire_col_b010_to_b001;

  logic [31:0] wire_col_c100_to_c010;
  logic [31:0] wire_col_c010_to_c001;

  // ROW
  logic [31:0] wire_row_a100_to_b100;
  logic [31:0] wire_row_a010_to_b010;
  logic [31:0] wire_row_a001_to_b001;

  logic [31:0] wire_row_b100_to_c100;
  logic [31:0] wire_row_b010_to_c010;
  logic [31:0] wire_row_b001_to_c001;


  // logic [31:0] dummy_a_01;
  // logic [31:0] dummy_a_11;
  // logic [31:0] dummy_b_10;
  // logic [31:0] dummy_b_11;


  pe_unit pe_a_100 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(row_in_0),
      .in_b(col_in_0),
      .out_a(wire_col_a100_to_a010),
      .out_b(wire_row_a100_to_b100),
      .out_acc(output_acc_a_100)
  );

  pe_unit pe_a_010 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(wire_col_a100_to_a010),
      .in_b(col_in_1),
      .out_a(wire_col_a010_to_a001),
      .out_b(wire_row_a010_to_b010),
      .out_acc(output_acc_a_010)
  );

  pe_unit pe_a_001 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(wire_col_a010_to_a001),
      .in_b(col_in_2),
      .out_a(),
      .out_b(wire_row_a001_to_b001),
      .out_acc(output_acc_a_001)
  );

  pe_unit pe_b_100 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(row_in_1),
      .in_b(wire_row_a100_to_b100),
      .out_a(wire_col_b100_to_b010),
      .out_b(wire_row_b100_to_c100),
      .out_acc(output_acc_b_100)
  );
  pe_unit pe_b_010 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(wire_col_b100_to_b010),
      .in_b(wire_row_a010_to_b010),
      .out_a(wire_col_b010_to_b001),
      .out_b(wire_row_b010_to_c010),
      .out_acc(output_acc_b_010)
  );
  pe_unit pe_b_001 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(wire_col_b010_to_b001),
      .in_b(wire_row_a001_to_b001),
      .out_a(),
      .out_b(wire_row_b001_to_c001),
      .out_acc(output_acc_b_001)
  );
  pe_unit pe_c_100 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(row_in_2),
      .in_b(wire_row_b100_to_c100),
      .out_a(wire_col_c100_to_c010),
      .out_b(),
      .out_acc(output_acc_c_100)
  );
  pe_unit pe_c_010 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(wire_col_c100_to_c010),
      .in_b(wire_row_b010_to_c010),
      .out_a(wire_col_c010_to_c001),
      .out_b(),
      .out_acc(output_acc_c_010)
  );
  pe_unit pe_c_001 (
      .clk(clk),
      .rst_n(rst_n),
      .in_a(wire_col_c010_to_c001),
      .in_b(wire_row_b001_to_c001),
      .out_a(),
      .out_b(),
      .out_acc(output_acc_c_001)
  );
endmodule
