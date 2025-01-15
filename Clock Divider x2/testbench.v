`timescale 1ns / 100ps
module tb_clock_divide;
  
  reg clk_in, reset;
  wire clk_out;

  clock_divide_2 uut (
    .clk_in(clk_in),
    .reset(reset),
    .clk_out(clk_out)
  );
  
     // Generate the input clock
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in; // Toggle every 5 ns (100 MHz clock)
    end
  
      // Apply stimulus
    initial begin
        // Initialize reset
        reset = 1;    // Assert reset
        #15;          // Hold reset for 15 ns
        reset = 0;    // Deassert reset

        #100 $stop;   // End simulation after 100 ns
    end

    // Monitor signals
    initial begin
       // Dump waves
      $dumpfile("dump.vcd");
      $dumpvars;
   
      $monitor("Time = %0t | clk_in = %b | reset = %b | clk_out = %b",
               $time, clk_in, reset, clk_out);
      #100
      $finish;
      
    end
  
endmodule
