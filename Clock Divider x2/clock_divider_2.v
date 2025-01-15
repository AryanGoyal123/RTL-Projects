`timescale 1ns / 100ps

module clock_divide_2 (
	input clk_in, reset, 
  	output reg clk_out
);
  
  always @(posedge clk_in or posedge reset) begin
    
    if (reset) clk_out <= 0;
    else clk_out <= ~clk_out;
    
  end
  
endmodule
