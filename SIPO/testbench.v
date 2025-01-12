`timescale 1ns / 100ps

module tb_sipo;
reg clk, reset, serial_in;
wire [2:0] parallel_out;

sipo dut(
  .clk(clk),
  .reset(reset),
  .s_in(serial_in),
  .p_out(parallel_out)
);

initial begin
    clk=1'b0;
    forever #5 clk=~clk;
    end
    
 initial begin
    reset= 1'b1;
    serial_in= 1'b0;
    #10 reset= 1'b0;
    
    #0  serial_in= 1'b1;
    #10 serial_in= 1'b0;
    #10 serial_in= 1'b1;
    #10 serial_in= 1'b1;
    #10 serial_in= 1'b0;
    #10 serial_in= 1'b0;
    #10 serial_in= 1'b1;
    #10 serial_in= 1'b0;
    #10 serial_in= 1'bx;
    end
    
 initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars;
   
    $monitor("\t\t clk: %d  reset: %d  serial_in: %d  parallel_out: %b", clk, reset, serial_in, parallel_out);
    #120 $finish;
    end
endmodule
