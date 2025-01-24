`timescale 1ns / 100 ps

module half_adder(
    input a,
    input b,
    output sum,
    output c_out
);
    xor (sum, a, b); // XOR gate for sum
    and (c_out, a, b); // AND gate for carry-out
endmodule

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
