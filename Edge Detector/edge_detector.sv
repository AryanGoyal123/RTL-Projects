module rising_edge_det(
	input logic clk, rst, sig,
  	output logic rising_edge
);
  
  logic prev_sig;
  
  always_ff @(posedge clk) begin
    
    if (!rst) begin // synch active low reset
      prev_sig <= 0;
      rising_edge <= 0;
    end else begin
      rising_edge <= ~prev_sig & sig;
      prev_sig <= sig;
    end
        
  end
endmodule

module falling_edge_det(
	input logic clk, rst, sig,
  	output logic falling_edge
);
  
  logic prev_sig;
  
  always_ff @(posedge clk) begin
	
    if (!rst) begin
      prev_sig <= 0;
      falling_edge <= 0;
    end else begin
      falling_edge <= prev_sig & ~sig;
      prev_sig <= sig;
    end
    
  end
  
endmodule
