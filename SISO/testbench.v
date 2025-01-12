`timescale 1ns / 100ps

module tb_siso;
reg clk, reset, serial_in;
wire serial_out;

siso dut(
  .clk(clk),
  .reset(reset),
  .s_in(serial_in),
  .s_out(serial_out)
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
   
    $monitor("\t\t clk: %d  reset: %d  serial_in: %d  serial_out: %d", clk, reset, serial_in, serial_out);
    #120 
   	$finish;
    end

endmodule
