`timescale 1ns / 1ps

module sipo #(parameter DATA_WIDTH = 8) (
  input logic clk,
  input logic rstn,
  input logic enable,
  input logic serial_in,
  output logic [DATA_WIDTH-1:0] parallel_out
);
  
  always_ff @(posedge clk) begin
    if (!rstn)
      parallel_out <= '0;
    if else (enable)
      parallel_out <= {parallel_out[WIDTH-2:0], serial_in}; 
  end
  
endmodule
