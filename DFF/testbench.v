`timescale 1ns / 100ps

module dff_tb;

    // Testbench Signals
    reg d;
    reg clk;
    reg rst;
    wire q;

    // Instantiate the Design Under Test (DUT)
    dff dut (
        .d(d),
        .clk(clk),
        .reset(rst),
        .q(q)
    );

  initial begin 
    clk=0;
    d=0;
    forever #4 clk=~clk;
  end
  
  initial  begin
     rst=1;#10;  
     rst=0;
    forever #10 d= ~d;
    end 
    
    initial begin
          // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars;
      
      $monitor("\t clk: %d  D: %d  Q: %d", clk, d, q);
    #80 $finish;
    end
  
endmodule
