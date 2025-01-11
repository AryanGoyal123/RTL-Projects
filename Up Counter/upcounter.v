`timescale 1ns / 100 ps

module upcounter #(parameter WIDTH = 4) (
	input clk, rst, en,
  output reg [WIDTH-1:0] counter
);
  always @(posedge clk or posedge rst) begin  
    if (rst) counter <= {WIDTH{1'b0}};
    
    else if (en) begin
      if (counter == (2**WIDTH -1)) counter <= {WIDTH{1'b0}};
      else counter <= counter + 1;
    end  
  end

endmodule
