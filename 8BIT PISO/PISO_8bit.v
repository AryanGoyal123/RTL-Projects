`timescale 1ns / 1ps

module piso #(parameter DATA_WIDTH = 8)(
  input logic clk,
  input logic rstn,
  input logic load,
  input logic enable,
  input logic [DATA_WIDTH-1:0] parallel_in,
  output logic serial_out
)
  logic [DATA_WIDTH-1:0] shift_reg;
  
  always_ff @(posedge clk) begin
    if (!rstn) begin
      shift_reg <= '0;
    end
    else if (load) begin
      shift_reg <= parallel_in;
    end
    else if (enable) begin
      shift_reg <= {shift_reg[WIDTH-2:0], 1'b0}; 
    end
  end
  
  assign serial_out = shift_reg[DATA_WIDTH-1];
  
endmodule
