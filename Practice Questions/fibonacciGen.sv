module fibonacciGen #(parameter
  DATA_WIDTH=32
) (
  input clk,
  input resetn,
  output logic [DATA_WIDTH-1:0] out
);

  logic [DATA_WIDTH-1:0] prev;

  always_ff @(posedge clk) begin
    if (!resetn) begin
      out <= 1;
      prev <= 0;
    end else begin
      out <= out + prev;
      prev <= out;
    end
  end

endmodule
