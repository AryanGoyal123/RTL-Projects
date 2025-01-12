`timescale 1ns / 100ps
// dff with sync reset
module dff(
	input d, clk, reset,
  	output reg q
);
  
  always @(posedge clk) begin
    if (reset) q <= 1'b0;
    else q <= d;
  end
  
endmodule

module sipo(
	input clk, reset, s_in,
  	output [2:0] p_out
);
  
  dff d1(s_in, clk, reset, p_out[2]);
  dff d2(p_out[2], clk, reset, p_out[1]);
  dff d3(p_out[1], clk, reset, p_out[0]);
endmodule
