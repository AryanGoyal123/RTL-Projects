`timescale 1ns / 100 ps

// positive edge triggered
module dff (
	  input d, clk, reset,
  	output reg q
);
  
  always @(posedge clk) begin
    if (reset) q <= 1'b0;
    else q <= d;
  end
  
endmodule
