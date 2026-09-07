module skewing_buffer_nxn #(
    parameter ARRAY_SIZE = 3
) (
    input logic clk,
    input logic rst_n,

    input logic [31:0] flat_row_in[ARRAY_SIZE],
    input logic [31:0] flat_col_in[ARRAY_SIZE],

    output logic [31:0] skewed_row_in[ARRAY_SIZE],
    output logic [31:0] skewed_col_in[ARRAY_SIZE]
);

  logic [31:0] row_delay_regs[ARRAY_SIZE][ARRAY_SIZE];
  logic [31:0] col_delay_regs[ARRAY_SIZE][ARRAY_SIZE];

  genvar i;
  generate

    for (i = 0; i < ARRAY_SIZE; i++) begin : gen_skew
      assign row_delay_regs[i][0] = flat_row_in[i];
      assign col_delay_regs[i][0] = flat_col_in[i];

      if (i > 0) begin : gen_delay
        always_ff @(posedge clk or negedge rst_n) begin

          if (!rst_n) begin

            for (int k = 1; k <= i; k++) begin
              row_delay_regs[i][i] <= 32'd0;
              col_delay_regs[i][i] <= 32'd0;
            end
          end else begin
            for (int k = 1; k <= i; k++) begin
              row_delay_regs[i][k] <= row_delay_regs[i][k-1];
              col_delay_regs[i][k] <= col_delay_regs[i][k-1];
            end

          end
        end
      end
      assign skewed_row_in[i] = row_delay_regs[i][i];
      assign skewed_col_in[i] = col_delay_regs[i][i];
    end

  endgenerate

endmodule

