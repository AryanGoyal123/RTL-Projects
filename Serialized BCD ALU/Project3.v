`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Aryan Goyal
// Module Name: Project3
//////////////////////////////////////////////////////////////////////////////////

module Project3(
    input clock,
    input reset,
    input din,
    output result
);
  // Wires to connect the datapath and controller.
    wire piso_load;
    wire [40:0] data_packet;

  // Instantiate the datapath.
  datapath dp_inst (
    .clk(clock),
    .reset(reset),
    .din(din),
    .sipo_packet(data_packet),
    .piso_load(piso_load),
    .serial_out(result)
  );

  // Instantiate the controller.
  controller ctrl_inst (
    .clk(clock),
    .reset(reset),
    .sipo_packet(data_packet),
    .piso_load(piso_load)
  );
  
endmodule

module datapath(
    input clk, reset, din, piso_load,
    output [40:0] sipo_packet,
    output serial_out
);

  wire [27:0] out_packet;
  wire [19:0] alu_result; // Result from ALU
  wire [40:0] packet;

  // SIPO instance: captures 41-bit packets from the serial input.
  sipo sipo_inst (
    .clk(clk),
    .reset(reset),
    .din(din),
    .packet(packet)
  );

  // BCD ALU instance: inputs are taken directly from the SIPO packet.
  // Bit positions: [34] = op, [33:18] = operandA, [17:2] = operandB.
  bcd_alu alu_inst (
    .op(packet[34]),
    .operandA(packet[33:18]),
    .operandB(packet[17:2]),
    .result(alu_result)
  );

  // Form the output packet by concatenating the 8-bit header (8'h96) with the 20-bit ALU result.
 assign out_packet = {8'h96, alu_result};

  // PISO instance: serializes the 28-bit output packet.
  piso piso_inst (
    .clk(clk),
    .reset(reset),
    .load(piso_load),
    .parallel_in(out_packet),
    .serial_out(serial_out)
  );
    
   assign sipo_packet = packet;

endmodule

module sipo (
  input clk, reset, din,
  output reg [40:0] packet
);
  always @(posedge clk) begin
    if (reset)
      packet <= 41'b0;
    else
      packet <= {packet[39:0], din};  // Always shift in new bit at LSB
  end
endmodule

module piso (
  input clk, reset, load,
  input [27:0] parallel_in,
  output reg serial_out
);

  reg [27:0] shift_reg;

    always @(posedge clk) begin
      if (reset) begin
        shift_reg  <= 28'd0;
        serial_out <= 1'b0;
      end else if (load) begin
        shift_reg  <= parallel_in;  // Load new data into the shift register
      end else begin
        serial_out <= shift_reg[27];             // Output the MSB
        shift_reg  <= {shift_reg[26:0], 1'b0};      // Shift left
      end
    end 
endmodule

module controller(
    input clk, reset,
    input [40:0] sipo_packet,
    output reg piso_load       // One-cycle pulse to load the ALU result into the PISO.
);

  // Simplified state encoding.
  parameter IDLE  = 1'b0,
            SHIFT  = 1'b1;
           
  reg state;

  always @(posedge clk) begin
    if (reset) begin
      state           <= IDLE;
      piso_load       <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          // Do not freeze SIPO; always shift.
          piso_load <= 1'b0;
          state <= (sipo_packet[40:33] == 8'hA5) ? SHIFT : IDLE;
        end

        SHIFT: begin
          // Assert load
          piso_load <= 1'b1;
          state <= IDLE;
        end

        default: state <= IDLE;
      endcase
    end
  end
endmodule

module bcd_alu(
    input  wire       op,         // 0: addition, 1: subtraction 
    input  wire [15:0] operandA,  // 4-digit BCD number (each digit is 4 bits)
    input  wire [15:0] operandB,  // 4-digit BCD number
    output reg [19:0] result     // 5-digit BCD result (20 bits)
);
  //reg for ADD
    reg [3:0] a0, a1, a2, a3;
    reg [3:0] b0, b1, b2, b3;
    
    // Using 5 bits for each digit sum to include the potential carry.
    reg [4:0] digit_sum0, digit_sum1, digit_sum2, digit_sum3;
    reg       carry0, carry1, carry2, carry3, carry4;
    
  //reg for subtration
    reg [3:0] A1, A2, A3, A4;  // operA digits (A4 is MSB, A1 is LSB)
    reg [3:0] B1, B2, B3, B4;  // operB digits (B4 is MSB, B1 is LSB)
    reg [3:0] C1, C2, C3, C4;  // 9's complement digits for operB
    reg [3:0] T1, T2, T3, T4;  // 10's complement digits for operB
    reg [3:0] S1, S2, S3, S4;  // Sum digits from adding operA and 10's complement
    
    reg [4:0] sum;  // 5-bit temporary for addition (to catch overflow)
    reg carry;      // Carry flag for digit additions
	
    always @(*) begin
        if (op == 1'b0) begin
               
        // Least significant digit is digit 0.
        a0 = operandA[3:0];
        a1 = operandA[7:4];
        a2 = operandA[11:8];
        a3 = operandA[15:12];
        
        b0 = operandB[3:0];
        b1 = operandB[7:4];
        b2 = operandB[11:8];
        b3 = operandB[15:12];
        
        // Start addition from the least significant digit.
        carry0 = 1'b0;
        digit_sum0 = a0 + b0 + carry0;
        if (digit_sum0 > 5'd9) begin
        digit_sum0 = digit_sum0 + 5'd6;
        end
        carry1 = digit_sum0[4];
           
           // Process the second digit.
          digit_sum1 = a1 + b1 + carry1;
          if (digit_sum1 > 5'd9) begin
            digit_sum1 = digit_sum1 + 5'd6;
          end
          carry2 = digit_sum1[4];
    
          // Process the third digit.
          digit_sum2 = a2 + b2 + carry2;
          if (digit_sum2 > 5'd9) begin
            digit_sum2 = digit_sum2 + 5'd6;
          end
          carry3 = digit_sum2[4];
    
          // Process the most significant digit.
          digit_sum3 = a3 + b3 + carry3;
          if (digit_sum3 > 5'd9) begin
            digit_sum3 = digit_sum3 + 5'd6;
          end
          carry4 = digit_sum3[4];

          // Assemble the final 20-bit result:
          // The extra carry becomes the new most significant digit,
          // followed by each 4-bit corrected BCD digit.
          result = {carry4,
                    digit_sum3[3:0],
                    digit_sum2[3:0],
                    digit_sum1[3:0],
                    digit_sum0[3:0] };
    end

    else begin
     
      // Extract each 4-bit BCD digit (LSB is [3:0])
      A1 = operandA[3:0];
      A2 = operandA[7:4];
      A3 = operandA[11:8];
      A4 = operandA[15:12];

      B1 = operandB[3:0];
      B2 = operandB[7:4];
      B3 = operandB[11:8];
      B4 = operandB[15:12];
      
       // --- Step 1: Compute the 9's complement of operB ---
      C1 = 4'd9 - B1;
      C2 = 4'd9 - B2;
      C3 = 4'd9 - B3;
      C4 = 4'd9 - B4;
      
      // --- Step 2: Obtain the 10's complement by adding 1 only to the LSB
    // Add 1 to the least-significant digit of the 9's complement
    sum = C1 + 4'd1;
    if(sum >= 5'd10) begin
      T1 = sum - 5'd10;
      carry = 1;
    end else begin
      T1 = sum[3:0];
      carry = 0;
    end

    // Propagate the carry (if any) to the remaining digits
    sum = C2 + carry;
    if(sum >= 5'd10) begin
      T2 = sum - 5'd10;
      carry = 1;
    end else begin
      T2 = sum[3:0];
      carry = 0;
    end

    sum = C3 + carry;
    if(sum >= 5'd10) begin
      T3 = sum - 5'd10;
      carry = 1;
    end else begin
      T3 = sum[3:0];
      carry = 0;
    end

    sum = C4 + carry;
    if(sum >= 5'd10) begin
      T4 = sum - 5'd10;
      // Final carry is discarded.
    end else begin
      T4 = sum[3:0];
    end

    // --- Step 3: Add operA and the 10's complement of operB (digit-by-digit BCD addition) ---
    // LSB digit addition
    sum = A1 + T1;
    if(sum >= 5'd10) begin
      S1 = sum - 5'd10;
      carry = 1;
    end else begin
      S1 = sum[3:0];
      carry = 0;
    end

    // Next digit
    sum = A2 + T2 + carry;
    if(sum >= 5'd10) begin
      S2 = sum - 5'd10;
      carry = 1;
    end else begin
      S2 = sum[3:0];
      carry = 0;
    end

    // Third digit
    sum = A3 + T3 + carry;
    if(sum >= 5'd10) begin
      S3 = sum - 5'd10;
      carry = 1;
    end else begin
      S3 = sum[3:0];
      carry = 0;
    end

    // MSB digit
    sum = A4 + T4 + carry;
    if(sum >= 5'd10) begin
      S4 = sum - 5'd10;
      // Discard final carry.
    end else begin
      S4 = sum[3:0];
    end

    // Combine BCD result digits (MSB first)
    result = {4'b0000, S4, S3, S2, S1};
    end
  end
  
endmodule
