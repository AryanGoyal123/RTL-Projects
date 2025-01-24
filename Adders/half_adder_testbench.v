`timescale 1ns / 100ps

// Half Adder Testbench
module tb_half_adder;
    reg a, b;
    wire sum, c_out;

    // Instantiate the half adder
    half_adder uut (
        .a(a),
        .b(b),
        .sum(sum),
        .c_out(c_out)
    );

    // Monitor signals
    initial begin
        $monitor("Time = %0t | Half Adder: a = %b, b = %b | sum = %b, c_out = %b", 
                 $time, a, b, sum, c_out);

        // Test cases for half adder
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        // End simulation
        $finish;
    end
endmodule
