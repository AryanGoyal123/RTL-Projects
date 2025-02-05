`timescale 1ns / 100 ps

module rca_4bit_tb;
  parameter WIDTH = 4;
  reg [WIDTH-1:0] a;
  reg [WIDTH-1:0] b;
  reg cin;
  wire [WIDTH-1:0] sum;
  wire cout;
  
  rca_4bit uut(
    .A(a),
    .B(b),
    .carry_in(cin),
    .carry_out(cout),
    .sum(sum)
  );
  
  initial begin

    $display("Time\tA\tB\tCin\tSum\tCout");
    
    $monitor("%4t\t%b\t%b\t%b\t%b\t%b", $time, a, b, cin, sum, cout);
    
    a = 4'b0000; b = 4'b0000; cin = 0; #10;
    a = 4'b0000; b = 4'b0000; cin = 1; #10;
    
    a = 4'b0001; b = 4'b0000; cin = 0; #10;
    a = 4'b0001; b = 4'b0000; cin = 1; #10;
    a = 4'b0001; b = 4'b0001; cin = 0; #10;
    a = 4'b0001; b = 4'b0001; cin = 1; #10;
    
    a = 4'b0010; b = 4'b0001; cin = 0; #10;
    a = 4'b0010; b = 4'b0001; cin = 1; #10;
    
    a = 4'b0011; b = 4'b0001; cin = 1; #10;
    a = 4'b0011; b = 4'b0011; cin = 0; #10;
    a = 4'b0011; b = 4'b0011; cin = 1; #10;
    
    a = 4'b0100; b = 4'b0000; cin = 0; #10;
    a = 4'b0100; b = 4'b0000; cin = 1; #10;
    a = 4'b0100; b = 4'b0011; cin = 0; #10;
    a = 4'b0100; b = 4'b0011; cin = 1; #10;
    
    a = 4'b0101; b = 4'b0000; cin = 0; #10;
    a = 4'b0101; b = 4'b0000; cin = 1; #10;
    a = 4'b0101; b = 4'b0011; cin = 0; #10;
    a = 4'b0101; b = 4'b0011; cin = 1; #10;
    
    a = 4'b1000; b = 4'b0000; cin = 0; #10;
    a = 4'b1000; b = 4'b0000; cin = 1; #10;
    a = 4'b1000; b = 4'b0011; cin = 0; #10;
    a = 4'b1000; b = 4'b0011; cin = 1; #10;
    a = 4'b1000; b = 4'b0111; cin = 0; #10;
    a = 4'b1000; b = 4'b0111; cin = 1; #10;

    $finish;
    
  end
endmodule
