`timescale 1ns / 1ps

module adder_tb;

  // Define bit-width of the adder
  parameter N = 4; 

  // Inputs annd Outputs
  reg [N-1:0] A, B;
  wire [N-1:0] Sum;
  wire Cout;

  // Instantiate the Kogge-Stone Adder
  adder #(N) uut (
    .A(A),
    .B(B),
    .Sum(Sum),
    .Cout(Cout)
  );
  
  // Monitor output
  initial begin
    $monitor("Time=%0t | A=%b B=%b | Sum=%b | Cout=%b", $time, A, B, Sum, Cout);
    
    A = 4'b0000; B = 4'b0000; #10;  
    A = 4'b1111; B = 4'b0001; #10;  
    A = 4'b1100; B = 4'b0011; #10;  
    A = 4'b1110; B = 4'b0001; #10;  
    A = 4'b1000; B = 4'b1000; #10;  
    A = 4'b1010; B = 4'b1101; #10;  
  end

endmodule
