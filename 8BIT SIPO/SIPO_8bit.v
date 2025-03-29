`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Aryan Goyal
// Module Name: SIPO_8bit
//////////////////////////////////////////////////////////////////////////////////

module dff(
	input d, clk, reset,
  	output reg q
);
  
  always @(posedge clk) begin
    if (reset) q <= 1'b0;
    else q <= d;
  end
  
endmodule

// 2:1 Multiplexer module
module mux2x1(
  input sel,      // when high, choose d1; when low, choose d0
  input d0,       // current (held) value
  input d1,       // new (shifted in) value
  output out
);
  assign out = sel ? d1 : d0;
endmodule

module muxdff (
  input sel, clk, rst,  // when high, choose d1; when low, choose d0
  input d0,       // current (held) value
  input d1,       // new (shifted in) value
  output data_out
);
	
  wire out;
  mux2x1 m1(sel, d0, d1, out);
  dff dff0(out, clk, rst, data_out);
  
endmodule

module SIPO_8BIT#(parameter WIDTH = 8)(
  input clk, rst, serial_in, shift,
  output [WIDTH-1:0] p_out
);
  
  muxdff d1 (.sel(shift), .clk(clk), .rst(rst), .d0(p_out[0]), .d1(serial_in), .data_out(p_out[0]));
  muxdff d2 (.sel(shift), .clk(clk), .rst(rst), .d0(p_out[1]), .d1(p_out[0]), .data_out(p_out[1]));
  muxdff d3 (.sel(shift), .clk(clk), .rst(rst), .d0(p_out[2]), .d1(p_out[1]), .data_out(p_out[2]));
  muxdff d4 (.sel(shift), .clk(clk), .rst(rst), .d0(p_out[3]), .d1(p_out[2]), .data_out(p_out[3]));
  muxdff d5 (.sel(shift), .clk(clk), .rst(rst), .d0(p_out[4]), .d1(p_out[3]), .data_out(p_out[4]));
  muxdff d6 (.sel(shift), .clk(clk), .rst(rst), .d0(p_out[5]), .d1(p_out[4]), .data_out(p_out[5]));
  muxdff d7 (.sel(shift), .clk(clk), .rst(rst), .d0(p_out[6]), .d1(p_out[5]), .data_out(p_out[6]));
  muxdff d8 (.sel(shift), .clk(clk), .rst(rst), .d0(p_out[7]), .d1(p_out[6]), .data_out(p_out[7]));
endmodule
