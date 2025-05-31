module model #(parameter
  DATA_WIDTH = 32
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);

  logic [DATA_WIDTH-1:0] seclarg_val;
  logic [DATA_WIDTH-1:0] larg_val;

  always_ff @(posedge clk) begin
    if(!resetn) begin
      dout <= '0;
      seclarg_val <= '0;
      larg_val <= '0;
    end else begin
      if (din > larg_val) begin
        larg_val <= din;   
        seclarg_val <= larg_val;
      end else if (din > seclarg_val)
        seclarg_val <= din;
      else 
        seclarg_val <= seclarg_val;
    end
  end

  assign dout = seclarg_val;

endmodule
