`timescale 1ns / 100ps
// Testbench for vending_25c_moore
module vending_25c_moore_tb;
    reg clock;
    reg reset_n;
    reg D;
    reg Q;
    wire P;
    wire C;

    // Instantiate the vending machine module
    vending_25c_moore uut (
        .clock(clock),
        .reset_n(reset_n),
        .D(D),
        .Q(Q),
        .P(P),
        .C(C)
    );
    // Clock generation
    always #5 clock = ~clock;

    // Test sequence
    initial begin
        $monitor("Time=%0t | Reset=%b | D=%b | Q=%b | P=%b | C=%b", $time, reset_n, D, Q, P, C);
        
        clock = 0;
        reset_n = 0;
        D = 0;
        Q = 0;
        
        #10 reset_n = 1;  // Release reset
        
        // Best-case scenario: Insert a quarter immediately
        #10 Q = 1; D = 0;  // 25 cents
        #10 Q = 0; D = 0;  // Wait
        
        // Test case where smaller increments are used
        #10 D = 1; Q = 0;  // 10 cents
        #10 D = 1; Q = 0;  // 20 cents
        #10 D = 1; Q = 0;  // 30 cents (product + change)
        #10 D = 0; Q = 0;  // Wait
        
        #50 $finish;
    end
endmodule
