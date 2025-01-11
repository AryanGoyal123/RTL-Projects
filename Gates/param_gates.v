`timescale 1 ns / 100 ps

module bitwise_and #(parameter WIDTH = 8)(
  input [WIDTH-1: 0] a, b, 
  output reg [WIDTH-1: 0] result
);
  
  integer i;
  always @(*) begin
    for (i = 0; i < WIDTH; i = i + 1) begin
      result[i] = a[i] & b[i];
    end
  end
endmodule

module bitwise_or #(parameter WIDTH = 8)(
  input [WIDTH-1: 0] a, b, 
  output reg [WIDTH-1: 0] result
);
  
  integer i;
  always @(*) begin
    for (i = 0; i < WIDTH; i = i + 1) begin
      result[i] = a[i] | b[i];
    end
  end
endmodule

module bitwise_nand #(parameter WIDTH = 8)(
  input [WIDTH-1: 0] a, b, 
  output reg [WIDTH-1: 0] result
);
  
  integer i;
  always @(*) begin
    for (i = 0; i < WIDTH; i = i + 1) begin
      result[i] = ~(a[i] & b[i]);
    end
  end
endmodule

module bitwise_nor #(parameter WIDTH = 8)(
  input [WIDTH-1: 0] a, b, 
  output reg [WIDTH-1: 0] result
);
  
  integer i;
  always @(*) begin
    for (i = 0; i < WIDTH; i = i + 1) begin
      result[i] = ~(a[i] | b[i]);
    end
  end
endmodule
