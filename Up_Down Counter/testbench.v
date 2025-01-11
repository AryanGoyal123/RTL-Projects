`timescale 1ns / 100 ps

module tb_up_down_counter;
  
  parameter WIDTH = 4;
  reg clk;
  reg rst;
  reg en;
  reg up_down;
  wire [WIDTH-1: 0] count;
  
  up_down_counter #(WIDTH) uut(
    .clk(clk),
    .rst(rst),
    .en(en),
    .up_down(up_down),
    .counter(count)
  );
  
  // Generate clock signal
  initial begin 
  clk=0;
  forever #5 clk= ~clk;
  end
  
  initial begin

    $dumpfile("dump.vcd");
    $dumpvars;
      
    // Monitor changes in signals
    $monitor("Time=%0t | rst=%b en=%b | count=%b | up_down=%b", $time, rst, en, count, up_down);
   		
    // Test sequence
    up_down = 1;
    rst = 1; #10; // Assert reset
    rst = 0; #10; // Deassert reset
    en = 1;       // Enable counter
    #200;         // Wait for several clock cycles
    
    up_down = 0;
    rst = 1; #10; // Assert reset
    rst = 0; #10; // Deassert reset
    en = 1;       // Enable counter
    #200;         // Wait for several clock cycles

    $finish;
   
  end
endmodule
