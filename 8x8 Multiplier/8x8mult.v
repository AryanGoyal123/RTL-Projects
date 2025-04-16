`timescale 1ns/1ps

module mult_seq_8x8 (
  input reset, clk,
  input [7:0] multiplier,
  input [7:0] multiplicand,
  output reg [15:0] product
);
  
  reg [15:0] mulcand_reg;
  reg [7:0] multiplier_reg;
  reg [3:0] count;
  
  
  always @(posedge clk or posedge reset) begin
    
    if (reset) begin
      product <= 16'b0;
      mulcand_reg  <= {8'b0, multiplicand};
      multiplier_reg    <= multiplier;
      count             <= 0;
    end
    
    else if (count < 8) begin
      // If LSB is 1, add the multiplicand to the product
      if (multiplier_reg[0] == 1'b1) begin
        product <= product + mulcand_reg;
      end

      // Always shift both registers to move to the next bit
      mulcand_reg    <= mulcand_reg << 1;
      multiplier_reg <= multiplier_reg >> 1;

      // Increment the iteration count
      count <= count + 1;
     
  	end
  end
endmodule
