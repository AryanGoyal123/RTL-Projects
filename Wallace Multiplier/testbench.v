`timescale 1ns / 100ps

module wallace_multiplier_tb;
    // Declare inputs and outputs
    reg [7:0] A, B;
    wire [15:0] Out;

    // Instantiate the Wallace multiplier
    wallace_multiplier uut (
        .A(A),
        .B(B),
        .Out(Out)
    );

    // Test Vectors
    initial begin
        $monitor("Time=%0t | A=%d, B=%d | Out=%d", $time, A, B, Out);

        // Test Case 1: 3 * 5 = 15
        A = 8'd3; B = 8'd5; #10;

        // Test Case 2: 7 * 8 = 56
        A = 8'd7; B = 8'd8; #10;

        // Test Case 3: 25 * 17 = 425
        A = 8'd25; B = 8'd17; #10;
		
        // Test Case 4: 45 * 32 = 1440
        A = 8'd45; B = 8'd32; #10;
     
        // Test Case 5: 125 * 112 = 20250
        A = 8'd125; B = 8'd162; #10;
      	
      	// Test Case 6: 255 * 255 = 65025
      	A = 8'd255; B = 8'd255; #10;
      	
        // Test Case 7: 1 * 1 = 1 
        A = 8'd1; B = 8'd1; #10;

        // Test Case 8: 16 * 16 = 256 
        A = 8'd16; B = 8'd16; #10;

        // Test Case 9: 99 * 99 = 9801
        A = 8'd99; B = 8'd99; #10;

        // Test Case 10: 200 * 50 = 10000 
        A = 8'd200; B = 8'd50; #10;
      
        $finish;
    end
endmodule
