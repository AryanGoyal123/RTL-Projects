module tb_rcs_8bit;
  reg [7:0] A, B;
  wire carry_out;
  wire [7:0] sum;

  // Instantiate the rcs_8bit module
  rcs_8bit uut (
    .A(A),
    .B(B),
    .carry_out(carry_out),
    .sum(sum)
  );

  initial begin
    $monitor("Time=%0t | A=%d | B=%d | Subtract=%d | Carry_out=%b", 
              $time, A, B, sum, carry_out);

    // Test Case 1: A = 8'd15, B = 8'd10
    A = 8'd15; B = 8'd10;
    #10;
    
    // Test Case 2: A = 8'd50, B = 8'd25
    A = 8'd50; B = 8'd25;
    #10;
    
    // Test Case 3: A = 8'd100, B = 8'd200
    A = 8'd100; B = 8'd200;
    #10;
    
    // Test Case 4: A = 8'd255, B = 8'd1 (Overflow case)
    A = 8'd255; B = 8'd1;
    #10;
    
    // Test Case 5: A = 8'd0, B = 8'd0
    A = 8'd0; B = 8'd0;
    #10;
    
    $finish;
  end
endmodule
