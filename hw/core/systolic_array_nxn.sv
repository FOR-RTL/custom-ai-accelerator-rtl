module systolic_array_nxn #(
    parameter ARRAY_SIZE = 3
) (
    input logic clk,
    input logic rst_n,

    input logic [31:0] row_in[ARRAY_SIZE],
    input logic [31:0] col_in[ARRAY_SIZE],

    output logic [31:0] out_acc[ARRAY_SIZE][ARRAY_SIZE]
);

  logic [31:0] wire_a[  ARRAY_SIZE][ARRAY_SIZE+1];
  logic [31:0] wire_b[ARRAY_SIZE+1][  ARRAY_SIZE];

  genvar i, j;
  generate

    for (i = 0; i < ARRAY_SIZE; i++) begin : assign_inputs
      assign wire_a[i][0] = row_in[i];
      assign wire_b[0][i] = col_in[i];
    end

    for (i = 0; i < ARRAY_SIZE; i++) begin : row
      for (j = 0; j < ARRAY_SIZE; j++) begin : col
        pe_unit pe (
            .clk(clk),
            .rst_n(rst_n),
            .in_a(wire_a[i][j]),
            .in_b(wire_b[i][j]),
            .out_a(wire_a[i][j+1]),
            .out_b(wire_b[i+1][j]),
            .out_acc(out_acc[i][j])
        );

      end
    end

  endgenerate

endmodule
