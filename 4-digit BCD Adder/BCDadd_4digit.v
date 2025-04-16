`timescale 1ns/1ps
module combBCDadd_digit (
	input [3:0] A, B,
	input cin,
	output cout,
	output [3:0] F );
  
  reg [4:0] digit_sum;
  
  always @(*) begin
    digit_sum = A + B + cin;
    if (digit_sum > 5'd9) begin
      digit_sum = digit_sum + 5'd6;
    end
  end
   
  assign cout = digit_sum[4];
  assign F = digit_sum[3:0];
	
endmodule

module combBCDadd_4d (
  input  [3:0] A3, A2, A1, A0,
  input  [3:0] B3, B2, B1, B0,
  output [3:0] F4, F3, F2, F1, F0
);

  wire [3:1] carry;

  combBCDadd_digit U0 ( A0, B0,     1'b0, carry[1], F0 );
  combBCDadd_digit U1 ( A1, B1, carry[1], carry[2], F1 );
  combBCDadd_digit U2 ( A2, B2, carry[2], carry[3], F2 );
  combBCDadd_digit U3 ( A3, B3, carry[3],    F4[0], F3 );

  // carry will never fill 3 MSb of F4
  assign F4[3:1] = 3'b000;

endmodule
