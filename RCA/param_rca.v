// full adder
module full_adder (
    input  a, b, cin,
    output sum, cout
);
  assign sum  = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Parameterized RCA
module RCA #(parameter BITS = 8)(
  input [BITS-1:0] a, b,
  input cin,
  output [BITS-1:0] sum,
  output cout
);
  
  wire [WIDTH:0] carry;
  assign carry[0] = cin;
  
  genvar i;
  generate for (i = 0; i < BITS; i++) begin
        full_adder fa (
        .a    (a[i]),
        .b    (b[i]),
        .cin  (carry[i]),
        .sum  (sum[i]),
        .cout (carry[i+1])
      );
  end
  endgenerate
    
  assign cout = carry[WIDTH];

endmodule
