module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  input din_en,
  output logic dout
);
logic [DATA_WIDTH-1:0] shift_reg;

always_ff @(posedge clk) begin
  if (!resetn) begin
    shift_reg <= '0;
  end else if (din_en) begin
    shift_reg  <= din;
  end else begin
    shift_reg <= shift_reg >> 1;
  end 
end

assign dout = shift_reg[0];
 
endmodule
