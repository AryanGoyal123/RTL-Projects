//structural versions
module half_adder_str(
	input a,
  	input b,
  	output sum,
  	output c_out);
  
  assign sum = a ^ b;
  assign c_out = a & b;
  
endmodule

module full_adder_str(
	input a,
  	input b,
    input cin,
  	output sum,
  	output c_out);
  
  assign sum = a ^ b ^ cin;
  assign c_out = (a & b) | ((a ^ b) & cin) ;
  
endmodule
