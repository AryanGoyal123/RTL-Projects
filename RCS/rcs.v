// Code your design here
module full_adder (
    input a,b, cin,
    output sum, cout
);
    wire w_sum, w_ct1, w_ct2;

    xor (w_sum, a, b);      
    xor (sum, w_sum, cin);  // XOR gate for final sum

    and (w_ct1, a, b);       
    and (w_ct2, w_sum, cin); 
    or (cout, w_ct1, w_ct2); // OR gate for carry-out
endmodule

module rcs_8bit #(parameter WIDTH = 8)(
  input [WIDTH-1:0] A, B,
  input carry_in = 1,
  output carry_out,
  output [WIDTH-1:0] diff
);
    wire [WIDTH-1:0] c; // Carry signals between full adders
  	wire [WIDTH-1:0] Bw = ~B;

    // Instantiate full adders for each bit
  full_adder fa0(A[0], Bw[0], carry_in, diff[0], c[0]);
  full_adder fa1(A[1], Bw[1], c[0], diff[1], c[1]);
  full_adder fa2(A[2], Bw[2], c[1], diff[2], c[2]);
  full_adder fa3(A[3], Bw[3], c[2], diff[3], c[3]);
  full_adder fa4(A[4], Bw[4], c[3], diff[4], c[4]);
  full_adder fa5(A[5], Bw[5], c[4], diff[5], c[5]);
  full_adder fa6(A[6], Bw[6], c[5], diff[6], c[6]);
  full_adder fa7(A[7], Bw[7], c[6], diff[7], carry_out);
  
endmodule
