`timescale 1ns / 100ps
// Full Adder Testbench
module tb_full_adder;
    reg a, b, cin;
    wire sum, c_out;

    // Instantiate the full adder
    full_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .c_out(c_out)
    );

    // Monitor signals
    initial begin
        $monitor("Time = %0t | Full Adder: a = %b, b = %b, c_in = %b | sum = %b, c_out = %b", 
                 $time, a, b, cin, sum, c_out);

        // Test cases for full adder
        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 0; cin = 1; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 0; b = 1; cin = 1; #10;
        a = 1; b = 0; cin = 0; #10;
        a = 1; b = 0; cin = 1; #10;
        a = 1; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 1; #10;

        // End simulation
        $finish;
    end
endmodule
