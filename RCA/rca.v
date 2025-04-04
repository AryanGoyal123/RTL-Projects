`timescale 1ns / 100ps

module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output c_out
);
    wire w_sum;
    wire w_ct1, w_ct2;

    xor (w_sum, a, b);       // XOR gate for intermediate sum
    xor (sum, w_sum, cin);  // XOR gate for final sum

    and (w_ct1, a, b);       // AND gate for a and b
    and (w_ct2, w_sum, cin); // AND gate for w_sum and c_in
    or (c_out, w_ct1, w_ct2); // OR gate for carry-out
endmodule

module rca_4bit #(parameter WIDTH = 4) (
  input [WIDTH-1:0] A, B,
  input carry_in,
  output carry_out,
  output [WIDTH-1:0] sum);

  wire [2:0] c;

  full_adder fa1(A[0], B[0], carry_in, sum[0], c[0]);
  full_adder fa2(A[1], B[1], c[0], sum[1], c[1]);
  full_adder fa3(A[2], B[2], c[1], sum[2], c[2]);
  full_adder fa4(A[3], B[3], c[2], sum[3], carry_out);
  
endmodule

module rca_8bit #(parameter WIDTH = 8) (
  input [WIDTH-1:0] A, B,
  input carry_in,
  output carry_out,
  output [WIDTH-1:0] sum
);

    wire [WIDTH-1:0] c; // Carry signals between full adders

    // Instantiate full adders for each bit
    full_adder fa0(A[0], B[0], carry_in, sum[0], c[0]);
    full_adder fa1(A[1], B[1], c[0], sum[1], c[1]);
    full_adder fa2(A[2], B[2], c[1], sum[2], c[2]);
    full_adder fa3(A[3], B[3], c[2], sum[3], c[3]);
    full_adder fa4(A[4], B[4], c[3], sum[4], c[4]);
    full_adder fa5(A[5], B[5], c[4], sum[5], c[5]);
    full_adder fa6(A[6], B[6], c[5], sum[6], c[6]);
    full_adder fa7(A[7], B[7], c[6], sum[7], carry_out);

endmodule
