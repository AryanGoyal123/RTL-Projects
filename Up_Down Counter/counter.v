`timescale 1ns / 100 ps

module up_down_counter #(parameter WIDTH = 4) (
	input clk, rst, up_down, en,
  	output reg [WIDTH-1:0] counter
);
  // up_down => 1; up counter
  // up_down => 0; down counter
  always @(posedge clk or posedge rst) begin  
    
    if (rst) begin
      if (up_down) counter <= {WIDTH{1'b0}};
      else counter <= {WIDTH{1'b1}};
    end
	
    else if (en) begin
      if (up_down) begin // up counter
        if (counter == {WIDTH{1'b1}}) counter <= {WIDTH{1'b0}};
      	else counter <= counter + 1;
      end
      
      else begin // down counter
        if (counter == {WIDTH{1'b0}}) counter <= {WIDTH{1'b1}};
      	else counter <= counter - 1;
      end
      
    end
  end

endmodule
