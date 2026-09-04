module pe_unit (

    input logic clk,
    input logic rst_n,
    input logic [31:0] in_a,
    input logic [31:0] in_b,

    output logic [31:0] out_a,
    output logic [31:0] out_b,
    output logic [31:0] out_acc
);


  logic [31:0] acc;
  logic [31:0] reg_a, reg_b;

  always_ff @(posedge clk or negedge rst_n) begin

    if (!rst_n) begin
      acc   <= 32'd0;
      reg_a <= 32'd0;
      reg_b <= 32'd0;
    end else begin

      acc   <= (in_a * in_b) + acc;

      reg_a <= in_a;
      reg_b <= in_b;

    end
  end

  assign out_a   = reg_a;
  assign out_b   = reg_b;
  assign out_acc = acc;

endmodule
