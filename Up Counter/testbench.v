`timescale 1ns / 100 ps

module tb_upcounter;
  
  parameter WIDTH = 4;
  reg clk;
  reg rst;
  reg en;
  wire [WIDTH-1: 0] count;
  
  upcounter #(WIDTH) uut(
    .clk(clk),
    .rst(rst),
    .en(en),
    .counter(count)
  );
  
  // Generate clock signal
  initial begin 
  clk=0;
  forever #5 clk= ~clk;
  end
  
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars;
   
    // Monitor changes in signals
    $monitor("Time=%0t | rst=%b en=%b | count=%b", $time, rst, en, count);
   		
    // Test sequence
    rst = 1; #10; // Assert reset
    rst = 0; #10; // Deassert reset
    en = 1;       // Enable counter
    #200;         // Wait for several clock cycles

    $finish;
   
  end
endmodule
