`timescale 1 ns / 100 ps

module testbench;
	reg a, b, c, d;
  reg s1, s0;
  wire out;
  	
  m41 uut (
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .s1(s1),
    .s0(s0),
    .out(out)
  );
  
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars;

    
    $monitor("Time=%0t | s1=%b s0=%b | a=%b b=%b c=%b d=%b | out=%b", $time, s1, s0, a, b, c, d, out);

      // Generate test cases
      // Apply test cases with a delay
      a = 0; b = 0; c = 0; d = 0; s1 = 0; s0 = 0; #10;
      a = 1; b = 0; c = 0; d = 0; s1 = 0; s0 = 0; #10;
      a = 0; b = 1; c = 0; d = 0; s1 = 0; s0 = 1; #10;
      a = 0; b = 0; c = 1; d = 0; s1 = 1; s0 = 0; #10;
      a = 0; b = 0; c = 0; d = 1; s1 = 1; s0 = 1; #10;

      // End simulation
      $finish;
  end
endmodule
