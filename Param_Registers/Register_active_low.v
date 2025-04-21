// Register with enable and sync active low reset
module Register_active_low #(parameter WIDTH = 8)(
  input clk, rst, en,
  input [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q
);
  
  always @(posedge clk) begin
    if (!rst) // active low reset
      q <= {WIDTH{1'b0}};
    else if (en)
      q <= d;
    else 
      q <= q;
  end
  
endmodule
