module mac_unit (
    input logic clk,
    input logic rst_n,
    input logic [31:0] a,
    input logic [31:0] b,

    output logic [31:0] mul_out,
    output logic [31:0] out

);
  logic [31:0] mul;
  logic [31:0] acc;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      acc <= 32'd0;
      mul <= 32'd0;
    end else begin
      mul <= (a * b);
      acc <= mul + acc;
    end
  end


  assign mul_out = mul;
  assign out = acc;

endmodule
