`timescale 1ns / 100ps

module vending_25c_moore(
	input clock, reset_n,
  	input D, Q,
  	output reg P, C
);
    
  	parameter S0 = 3'b000,  // 0 cents
              S1 = 3'b001,  // 10 cents
              S2 = 3'b010,  // 20 cents
              S3 = 3'b011,  // 25 cents (Dispense product)
              S4 = 3'b100;  // More than 25 cents (Dispense product + Change)
  	reg [2:0] current_state, next_state;
  
  	 // State transition logic
    always @(posedge clock) begin
        if (!reset_n)
            current_state <= S0;  // Reset to initial state
        else
            current_state <= next_state;
    end
  	
  	    // Next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (D && !Q) next_state = S1;  // 10 cents
                else if (!D && Q) next_state = S3; // 25 cents
                else next_state = S0;
            end
            S1: begin
                if (D && !Q) next_state = S2;  // 20 cents
                else if (!D && Q) next_state = S4; // 35 cents (Change required)
                else next_state = S1;
            end
            S2: begin
              if (D && !Q) next_state = S4;  // 30 cents (Product dispensed + Change)
              else if (!D && Q) next_state = S4; // 45 cents (Product + Change required)
                else next_state = S2;
            end
            S3: begin
                next_state = S0;  // Dispense product, go back to idle
            end
            S4: begin
                next_state = S0;  // Dispense product + change, go back to idle
            end
            default: next_state = S0;
        endcase
    end
  
  	always @(posedge clock) begin
   		if (!reset_n) begin
            P <= 0;
            C <= 0;
        end 
      	else begin
            P <= (current_state == S3 || current_state == S4) ? 1'b1 : 1'b0;
            C <= (current_state == S4) ? 1'b1 : 1'b0;
        end
    end
endmodule
