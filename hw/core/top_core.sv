module top_core #(
    parameter ARRAY_SIZE = 3
) (
    input logic clk,
    input logic rst_n,
    input logic [31:0] flat_row_in[ARRAY_SIZE],
    input logic [31:0] flat_col_in[ARRAY_SIZE],

    output logic [31:0] out_acc[ARRAY_SIZE][ARRAY_SIZE]

);

  logic [31:0] skewed_row_wire[ARRAY_SIZE];
  logic [31:0] skewed_col_wire[ARRAY_SIZE];


  skewing_buffer_nxn #(
      .ARRAY_SIZE(ARRAY_SIZE)
  ) u_skewing_buffer_nxn (
      .clk(clk),
      .rst_n(rst_n),
      .flat_row_in(flat_row_in),
      .flat_col_in(flat_col_in),
      .skewed_row_in(skewed_row_wire),
      .skewed_col_in(skewed_col_wire)
  );

  systolic_array_nxn #(
      .ARRAY_SIZE(ARRAY_SIZE)
  ) u_systolic_array_nxn (
      .clk(clk),
      .rst_n(rst_n),
      .row_in(skewed_row_wire),
      .col_in(skewed_col_wire),
      .out_acc(out_acc)
  );

endmodule
