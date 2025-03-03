`timescale 1ns / 100ps

module Project2 #(parameter WIDTH = 8)(
	input reset_n, clock, capture,
    input [1:0] op,
  	input [WIDTH-1:0] d_in,
    output valid,
  	output [WIDTH:0] result
);
  //4 capture wires from the controller
  wire cap1, cap2, cap3, cap4;
  
  //instance of datapath
  datapath dp1(.reset_n(reset_n), .clock(clock), .capture(capture), .op(op), .d_in(d_in),.cap1(cap1), .cap2(cap2), .cap3(cap3), .cap4(cap4), .result(result));
  
  //instance of controller
  controller con1(.capture(capture), .clock(clock), .reset_n(reset_n), .op(op), .cap1(cap1), .cap2(cap2), .cap3(cap3), .cap4(cap4), .valid(valid));
  
endmodule

module datapath #(parameter WIDTH = 8)(
	input reset_n, clock, capture,
    input [1:0] op,
  	input [WIDTH-1:0] d_in,
  	input cap1, cap2, cap3, cap4,
  	output [WIDTH:0] result 
);

    // 4 wires to connect the demux to the reg_tlvl
  wire [WIDTH-1:0] out1, out2, out3, out4;
  // 2 wires for the 2 subtracter outputs
  wire [WIDTH-1:0] sub1, sub2;
  //wire for the adder output
  wire [WIDTH-1:0] add0;
  wire add_cout;
  
  // 4 wires for reg_level output to subtractor
  wire [WIDTH-1:0] reg1_out, reg2_out, reg3_out, reg4_out;
  
  //demux
  demux d1 (.din(d_in), .sel(op), .dout0(out1), .dout1(out2), .dout2(out3), .dout3(out4));
  
  // 4 instances of the reg_lvl to store
  reg_tlvl reg1(.din(out1), .clk(clock), .reset(reset_n), .sel(cap1), .q(reg1_out));
  reg_tlvl reg2(.din(out2), .clk(clock), .reset(reset_n), .sel(cap2), .q(reg2_out));
  reg_tlvl reg3(.din(out3), .clk(clock), .reset(reset_n), .sel(cap3), .q(reg3_out));
  reg_tlvl reg4(.din(out4), .clk(clock), .reset(reset_n), .sel(cap4), .q(reg4_out));
  
  // 2 instances of subtractor
  rcs_8bit rcs1(.A(reg1_out), .B(reg2_out), .carry_in(1'b1), .sub(sub1));
  rcs_8bit rcs2(.A(reg3_out), .B(reg4_out), .carry_in(1'b1), .sub(sub2));
  
  //1 adder
  rca_8bit rca1(.A(sub1), .B(sub2), .carry_in(1'b0), .carry_out(add_cout), .sum(add0));
  
  // instance of output register
  register_9bit reg_9bit1 (.d(add0), .d_cout(add_cout), .clk(clock), .reset(reset), .q(result));
  
endmodule
  
module controller (
	input capture, clock, reset_n,
    input [1:0] op,
    output cap1, cap2, cap3, cap4,
    output valid
);
     // State encoding (using 2 bits)
    // IDLE: waiting for a capture event
    // CAPTURE: capturing an operand (note: in a full design you’d have flags to mark captured operands)
    // VALID: result is ready and valid is asserted for one clock cycle
    localparam IDLE    = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam VALID   = 2'b10;
  
     // State register (implemented with an allowed DFF module)
    wire [1:0] state;
    wire [1:0] next_state;
  
     // Operand loaded flags for A, B, C, D. Each flag is updated when its operand is captured.
    wire loaded_A, loaded_B, loaded_C, loaded_D;

    // Next value for each flag: if a capture occurs for the specific operand, set the flag to 1.
    wire d_A, d_B, d_C, d_D;
    assign d_A = (capture && (op == 2'b00)) ? 1'b1 : loaded_A;
    assign d_B = (capture && (op == 2'b01)) ? 1'b1 : loaded_B;
    assign d_C = (capture && (op == 2'b10)) ? 1'b1 : loaded_C;
    assign d_D = (capture && (op == 2'b11)) ? 1'b1 : loaded_D;
  
    dff dff_A (.q(loaded_A), .d(d_A), .clk(clock), .reset(reset_n));  
    dff dff_B (.q(loaded_B), .d(d_B), .clk(clock), .reset(reset_n));  
    dff dff_C (.q(loaded_C), .d(d_C), .clk(clock), .reset(reset_n));  
    dff dff_D (.q(loaded_D), .d(d_D), .clk(clock), .reset(reset_n));  

  
    wire all_loaded;
    assign all_loaded = loaded_A & loaded_B & loaded_C & loaded_D;
  
    assign next_state = (state == IDLE)    ? (capture ? CAPTURE : IDLE) :
                        (state == CAPTURE) ? (all_loaded ? VALID : CAPTURE) :
                        (state == VALID)   ? IDLE :
                        IDLE;
  
  	dff dff0 (.q(state[0]), .d(next_state[0]), .clk(clock), .reset(reset_n));  
  	dff dff1 (.q(state[1]), .d(next_state[1]), .clk(clock), .reset(reset_n));  

    assign cap1 = (capture && (op == 2'b00)) ? 1'b1 : 1'b0;
    assign cap2 = (capture && (op == 2'b01)) ? 1'b1 : 1'b0;
    assign cap3 = (capture && (op == 2'b10)) ? 1'b1 : 1'b0;
    assign cap4 = (capture && (op == 2'b11)) ? 1'b1 : 1'b0;
  
 	assign valid = (state == VALID) ? 1'b1 : 1'b0;
  
endmodule

module full_adder (
    input a,b, cin,
    output sum, cout
);
    wire w_sum, w_ct1, w_ct2;

    xor (w_sum, a, b);      
    xor (sum, w_sum, cin);  // XOR gate for final sum

    and (w_ct1, a, b);       
    and (w_ct2, w_sum, cin); 
    or (cout, w_ct1, w_ct2); // OR gate for carry-out
endmodule

module dff (
	input d, clk, reset,
  	output reg q
);
  always @(posedge clk) begin
    if (!reset) q <= 1'b0;
    else q <= d;
  end
endmodule

module rca_8bit #(parameter WIDTH = 8) (
  input [WIDTH-1:0] A, B,
  input carry_in,
  output carry_out,
  output [WIDTH-1:0] sum
);

    wire [WIDTH-1:0] c; // Carry signals between full adders

    // Instantiate full adders for each bit
    full_adder fa0(A[0], B[0], carry_in, sum[0], c[0]);
    full_adder fa1(A[1], B[1], c[0], sum[1], c[1]);
    full_adder fa2(A[2], B[2], c[1], sum[2], c[2]);
    full_adder fa3(A[3], B[3], c[2], sum[3], c[3]);
    full_adder fa4(A[4], B[4], c[3], sum[4], c[4]);
    full_adder fa5(A[5], B[5], c[4], sum[5], c[5]);
    full_adder fa6(A[6], B[6], c[5], sum[6], c[6]);
    full_adder fa7(A[7], B[7], c[6], sum[7], carry_out);

endmodule

module rcs_8bit #(parameter WIDTH = 8)(
  input [WIDTH-1:0] A, B,
  input carry_in,
  output carry_out,
  output [WIDTH-1:0] sub
);
    wire [WIDTH-1:0] c; // Carry signals between full adders
  	wire [WIDTH-1:0] Bw = ~B;

    // Instantiate full adders for each bit
  full_adder fa0(A[0], Bw[0], carry_in, sub[0], c[0]);
  full_adder fa1(A[1], Bw[1], c[0], sub[1], c[1]);
  full_adder fa2(A[2], Bw[2], c[1], sub[2], c[2]);
  full_adder fa3(A[3], Bw[3], c[2], sub[3], c[3]);
  full_adder fa4(A[4], Bw[4], c[3], sub[4], c[4]);
  full_adder fa5(A[5], Bw[5], c[4], sub[5], c[5]);
  full_adder fa6(A[6], Bw[6], c[5], sub[6], c[6]);
  full_adder fa7(A[7], Bw[7], c[6], sub[7], carry_out);
  
endmodule

module demux #(parameter WIDTH = 8) (
    input [WIDTH-1:0] din,  
    input [1:0] sel,        // 2-bit selection lines
    output [WIDTH-1:0] dout0, // A
    output [WIDTH-1:0] dout1, // B
    output [WIDTH-1:0] dout2, // C
    output [WIDTH-1:0] dout3  // D
);
    assign dout0 = (sel == 2'b00) ? din : 8'b0;
    assign dout1 = (sel == 2'b01) ? din : 8'b0;
    assign dout2 = (sel == 2'b10) ? din : 8'b0;
    assign dout3 = (sel == 2'b11) ? din : 8'b0;

endmodule

module mux_2to1 #(parameter WIDTH = 8)(
  input [WIDTH-1:0] din, d_rep, //d_rep is the repeated data from register  
  input sel, // 2-bit selection lines
  output [WIDTH-1:0] dout // A
);
  assign dout = sel ? din : d_rep;
endmodule

module register_8bit #(parameter WIDTH = 8) (
    input [WIDTH-1:0] d, // 8-bit input data
    input clk, reset,         
    output [WIDTH-1:0] q // 8-bit output
);
    // Declare an array of 8 D flip-flops, each for one bit
    dff dff0 (.d(d[0]), .clk(clk), .reset(reset), .q(q[0]));
    dff dff1 (.d(d[1]), .clk(clk), .reset(reset), .q(q[1]));
    dff dff2 (.d(d[2]), .clk(clk), .reset(reset), .q(q[2]));
    dff dff3 (.d(d[3]), .clk(clk), .reset(reset), .q(q[3]));
    dff dff4 (.d(d[4]), .clk(clk), .reset(reset), .q(q[4]));
    dff dff5 (.d(d[5]), .clk(clk), .reset(reset), .q(q[5]));
    dff dff6 (.d(d[6]), .clk(clk), .reset(reset), .q(q[6]));
    dff dff7 (.d(d[7]), .clk(clk), .reset(reset), .q(q[7]));

endmodule

module register_9bit #(parameter WIDTH = 9) (
    input [WIDTH-2:0] d, // 8-bit input data
  	input d_cout,
    input clk, reset,         
    output [WIDTH-1:0] q // 8-bit output
);
    // Declare an array of 8 D flip-flops, each for one bit
    dff dff0 (.d(d[0]), .clk(clk), .reset(reset), .q(q[0]));
    dff dff1 (.d(d[1]), .clk(clk), .reset(reset), .q(q[1]));
    dff dff2 (.d(d[2]), .clk(clk), .reset(reset), .q(q[2]));
    dff dff3 (.d(d[3]), .clk(clk), .reset(reset), .q(q[3]));
    dff dff4 (.d(d[4]), .clk(clk), .reset(reset), .q(q[4]));
    dff dff5 (.d(d[5]), .clk(clk), .reset(reset), .q(q[5]));
    dff dff6 (.d(d[6]), .clk(clk), .reset(reset), .q(q[6]));
    dff dff7 (.d(d[7]), .clk(clk), .reset(reset), .q(q[7]));
  	dff dff8 (.d(d_cout), .clk(clk), .reset(reset), .q(q[8]));

endmodule

module reg_tlvl #(parameter WIDTH = 8) (
  input [WIDTH-1:0] din,
  input clk, reset, sel,
  output [WIDTH-1:0] q
);
  wire [WIDTH-1:0] d_rep;
  wire [WIDTH-1:0] d_wire;
  
  mux_2to1 mux1(.din(din), .d_rep(d_rep), .sel(sel), .dout(d_wire));
  register_8bit reg1(.d(d_wire), .clk(clk), .reset(reset), .q(q));
  assign d_rep = q;
  
endmodule
