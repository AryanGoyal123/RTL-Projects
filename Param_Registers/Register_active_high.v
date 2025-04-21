module Register_active_high #(parameter WIDTH = 8)(
  input clk, rst, en,
  input [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q
);
  
  always @(posedge clk) begin
    if (rst)
      q <= {WIDTH{1'b0}};
    else if (en)
      q <= d;
    else 
      q <= q;
  end
  
endmodule
