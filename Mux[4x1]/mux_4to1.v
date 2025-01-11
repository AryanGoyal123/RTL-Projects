module m41 (
	input a, 
	input b, 
	input c, 
	input d, 
	input s1, s0,
	output out); 

 	assign out = s1 ? (s0 ? d : c) : (s0 ? b : a); 
  
endmodule
