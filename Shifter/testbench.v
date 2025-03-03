`timescale 1ns / 100ps

module shifter_8bit_tb;
  reg clock;
  reg [7:0] d_in;
  reg [2:0] op;
  reg capture;
  wire [7:0] d_out;

  // Instantiate the design
  shifter_8bit uut (
    .clk(clock),
    .d_in(d_in),
    .op(op),
    .capture(capture),
    .d_out(d_out)
  );

  // Clock generation: free-running clock
  initial clock = 0;
  always #5 clock = ~clock;  // 10 ns clock period

  initial begin
        // Monitor changes in key signals
    $monitor("Time = %0t | clock = %b | d_in = %b | op = %b | capture = %b | d_out = %b", 
             $time, clock, d_in, op, capture, d_out);
    
    // Initialize inputs
    d_in = 8'b11101110;
    op = 3'b000;       // Start with shift left by 1
    capture = 1'b0;    // Allow update

    // Wait for a clock edge, then change operations
    #10;  
    op = 3'b001; // Test logical shift right by 1
    
    #10;
    op = 3'b010; // Test shift left by 2
    #10;
    op = 3'b011; // Test logical shift right by 2
    #10;
    op = 3'b100; // Test rotate left by 1
    #10;
    op = 3'b101; // Test rotate right by 1
    #10;
    op = 3'b110; // Test hold
    #10;
   
    // test the capture signal (prevent update)
    capture = 1'b1;
    op = 3'b000;      
    #10;
    op = 3'b001;   
    #10;
    op = 3'b010;
    $finish;
  end
endmodule
