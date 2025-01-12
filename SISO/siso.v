`timescale 1ns / 1ps
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

// 3 dff siso
module siso(
	input clk, reset, s_in,
  	output s_out
);
  
  wire q1, q0;
  
  dff d1(s_in, clk, reset, q0);
  dff d2(q0, clk, reset, q1);
  dff d3(q1, clk, reset, s_out);
  
endmodule
