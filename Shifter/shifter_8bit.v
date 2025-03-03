`timescale 1ns / 100ps

module shifter_8bit #(parameter WIDTH = 8)(
  input [WIDTH-1 : 0] d_in,
  input [2:0] op,
  input clk, capture,
  output [WIDTH-1 : 0] d_out
);
 
  // Intermediate wire carrying the multiplexer output
  wire [WIDTH-1:0] mux_out;
  
  wire [WIDTH-1:0] d_hold = d_out;
 
  // wire carrying 0-7 outputs from compute to mux
  wire [WIDTH-1:0] out0;
  wire [WIDTH-1:0] out1;
  wire [WIDTH-1:0] out2;
  wire [WIDTH-1:0] out3;
  wire [WIDTH-1:0] out4;
  wire [WIDTH-1:0] out5;
  wire [WIDTH-1:0] out6;
  wire [WIDTH-1:0] out7;
 
    // Instantiate the compute
  compute #(WIDTH) com_inst (
      .d_in(d_in),
      .d_hold(d_hold),
      .op0(out0),
      .op1(out1),
      .op2(out2),
      .op3(out3),
      .op4(out4),
      .op5(out5),
      .op6(out6),
      .op7(out7)
  );
 
    // Instantiate the mux selector.
  mux #(WIDTH) mux_inst (
      .in0(out0),
      .in1(out1),
      .in2(out2),
      .in3(out3),
      .in4(out4),
      .in5(out5),
      .in6(out6),
      .in7(out7),
      .op(op),
      .y(mux_out)
  );
 
  // Instantiate the register module (built from 8 DFFs):
  // It loads the mux result on the rising edge when capture==0.
  register #(WIDTH) reg_inst(
      .d(mux_out),
      .clk(clk),
      .capture(capture),
      .q(d_out)
  );
 
endmodule


module mux #(parameter WIDTH = 8)(
  input  [WIDTH-1:0] in0,
  input  [WIDTH-1:0] in1,
  input  [WIDTH-1:0] in2,
  input  [WIDTH-1:0] in3,
  input  [WIDTH-1:0] in4,
  input  [WIDTH-1:0] in5,
  input  [WIDTH-1:0] in6,
  input  [WIDTH-1:0] in7,
  input  [2:0] op,  // Operation selector
    output [WIDTH-1:0] y    // Final output
);

  // Dataflow selection using the ternary operator
  assign y = (op == 3'b000) ? in0 :
    (op == 3'b001) ? in1 :
    (op == 3'b010) ? in2 :
             (op == 3'b011) ? in3 :
             (op == 3'b100) ? in4 :
             (op == 3'b101) ? in5 :
             (op == 3'b110) ? in6 :in7;

endmodule


module compute #(parameter WIDTH = 8)(
    input  [WIDTH-1:0] d_in,    // Input data to be shifted/rotated
    input  [WIDTH-1:0] d_hold,  // Current register value (for hold)
    output [WIDTH-1:0] op0,  // d_in shifted left by 1
    output [WIDTH-1:0] op1,  // d_in logically shifted right by 1
    output [WIDTH-1:0] op2,  // d_in shifted left by 2
    output [WIDTH-1:0] op3,  // d_in logically shifted right by 2
    output [WIDTH-1:0] op4,  // d_in rotated left by 1
    output [WIDTH-1:0] op5,  // d_in rotated right by 1
    output [WIDTH-1:0] op6,  // Hold current value
    output [WIDTH-1:0] op7   // Default: load zeros
);

  // Compute each candidate using dataflow (continuous assign)
  assign op0 = d_in << 1;
  assign op1 = d_in >> 1;
  assign op2 = d_in << 2;
  assign op3 = d_in >> 2;
  assign op4 = {d_in[WIDTH-2:0], d_in[WIDTH-1]};
  assign op5 = {d_in[0], d_in[WIDTH-1:1]};
  assign op6 = d_hold;
  assign op7 = {WIDTH{1'b0}};

endmodule

module dff (
    input clk, capture,  // Capture enable
    input d,        
    output reg q    
);
    always @(posedge clk) begin
      if (!capture)
            q <= d;  // Capture = 0
    end
endmodule
 

module register #(parameter WIDTH = 8) (
    input [WIDTH-1:0] d, // 8-bit input data
    input clk, capture,        
    output [WIDTH-1:0] q // 8-bit output
);

    // Declare an array of 8 D flip-flops, each for one bit
    dff dff0 (.d(d[0]), .clk(clk), .capture(capture), .q(q[0]));
    dff dff1 (.d(d[1]), .clk(clk), .capture(capture), .q(q[1]));
    dff dff2 (.d(d[2]), .clk(clk), .capture(capture), .q(q[2]));
    dff dff3 (.d(d[3]), .clk(clk), .capture(capture), .q(q[3]));
    dff dff4 (.d(d[4]), .clk(clk), .capture(capture), .q(q[4]));
    dff dff5 (.d(d[5]), .clk(clk), .capture(capture), .q(q[5]));
    dff dff6 (.d(d[6]), .clk(clk), .capture(capture), .q(q[6]));
    dff dff7 (.d(d[7]), .clk(clk), .capture(capture), .q(q[7]));

endmodule
