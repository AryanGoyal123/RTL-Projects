`timescale 1ns / 1ps

module adder #(WIDTH = 4)(
  input [WIDTH-1:0] A, B,
  output [WIDTH-1:0] Sum, 
  output Cout
);
  
  wire [WIDTH-1:0] G, P, C;
  
  // Generate & Propagate
  assign G = A & B;  
  assign P = A ^ B; 
  
  // Prefix tree
  assign C[0] = G[0];
  assign C[1] = G[1] | (P[1] & G[0]);
  assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);
  assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
  
  // Sum Computation
  assign Sum = P ^ {C[2:0], 1'b0}; // Adding carry shift
  assign Cout = C[3];
  
endmodule
