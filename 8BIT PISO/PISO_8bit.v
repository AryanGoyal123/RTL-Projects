`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Aryan Goyal
// Module Name: PISO_8bit
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

module PISO_8bit(
	input clk, rst, shift, load,
  	input [7:0] parallel_in,
  	output serial_out
);

  wire [7:0] d_out, sel1;
  
  assign sel1[0] = load ? parallel_in[0] : (shift ? d_out[1] : d_out[0]);
  assign sel1[1] = load ? parallel_in[1] : (shift ? d_out[2] : d_out[1]);
  assign sel1[2] = load ? parallel_in[2] : (shift ? d_out[3] : d_out[2]);
  assign sel1[3] = load ? parallel_in[3] : (shift ? d_out[4] : d_out[3]);
  assign sel1[4] = load ? parallel_in[4] : (shift ? d_out[5] : d_out[4]);
  assign sel1[5] = load ? parallel_in[5] : (shift ? d_out[6] : d_out[5]);
  assign sel1[6] = load ? parallel_in[6] : (shift ? d_out[7] : d_out[6]);
  assign sel1[7] = load ? parallel_in[7] : (shift ? 1'b0 : d_out[7]);
  
  dff d1(sel1[0], clk, rst, d_out[0]);
  dff d2(sel1[1], clk, rst, d_out[1]);
  dff d3(sel1[2], clk, rst, d_out[2]);
  dff d4(sel1[3], clk, rst, d_out[3]);
  dff d5(sel1[4], clk, rst, d_out[4]);
  dff d6(sel1[5], clk, rst, d_out[5]);
  dff d7(sel1[6], clk, rst, d_out[6]);
  dff d8(sel1[7], clk, rst, d_out[7]);
  
  assign serial_out = d_out[0];
  
endmodule
