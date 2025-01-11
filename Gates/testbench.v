`timescale 1 ns / 100 ps
module tb_bitwise_gates();
  
  parameter WIDTH = 8;

  // Testbench signals
  reg [WIDTH-1:0] a, b;
  wire [WIDTH-1:0] and_result, or_result, nand_result, nor_result;

  // Instantiate the Device Under Test (DUT)
  bitwise_and #(WIDTH) dut_and (
    .a(a),
    .b(b),
    .result(and_result)
  );

  bitwise_or #(WIDTH) dut_or (
    .a(a),
    .b(b),
    .result(or_result)
  );

  bitwise_nand #(WIDTH) dut_nand (
    .a(a),
    .b(b),
    .result(nand_result)
  );

  bitwise_nor #(WIDTH) dut_nor (
    .a(a),
    .b(b),
    .result(nor_result)
  );

  // Test sequence
  initial begin
    // Monitor signals
    $monitor("Time=%0t | a=%b, b=%b | AND=%b, OR=%b, NAND=%b, NOR=%b", $time, a, b, and_result, or_result, nand_result, nor_result);

    // Initialize inputs
    a = 8'b00000000;
    b = 8'b00000000;

    // Wait for global reset
    #10;

    // Apply test vectors
    a = 8'b11001100; b = 8'b10101010; #10;
    a = 8'b11110000; b = 8'b00001111; #10;
    a = 8'b11111111; b = 8'b00000000; #10;
    a = 8'b10101010; b = 8'b01010101; #10;

    // Complete simulation
    $finish;
  end
endmodule
