`timescale 1ns / 100ps

`define DUT_MODULE_NAME Project2

module project_2_ex_tb;
    // Inputs to be fed into DUT
    reg reset_n, clock, capture;
    reg [1:0] op;
    reg [7:0] d_in;
    
    // Outputs from DUT
    wire [8:0] result;
    wire valid;
    
    // Internal testbench registers
    reg [7:0] Ain, Bin, Cin, Din;
    reg [8:0] correct_result;
    reg [4:0] cycle_counter;
    reg timeout,valid_asserted, correct, done,pass;
    reg [8:0] received;
    integer i;
    reg [7:0] OP_in;
    integer de [0:3];

    // max number of clock cycles after all inputs before result and valid should availalble from the DUT.
    parameter TIMEOUT_CYCLES = 10;
    
    // Clock generation parameters
    parameter CLOCK_PERIOD = 10;
    parameter CLOCK_HALF_PERIOD = CLOCK_PERIOD/2;
    
    // Used to alter the order of inputs.
    parameter [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;
    
    // Instantiate the DUT (Device Under Test)
    `DUT_MODULE_NAME dut (
        .reset_n    (reset_n),  // input  wire reset_n
        .clock      (clock),    // input  wire clock
        .d_in       (d_in),     // input  wire [7:0] d_in
        .op         (op),       // input  wire [7:0] d_in
        .capture    (capture),  // input  wire capture
        .result     (result),   // output wire [8:0] result (may be wire or reg in your module)
        .valid      (valid)     // output wire valid (may be wire or reg in your module)
    );
    
    // Clock generation.
    initial begin
        clock = 0;
        forever #CLOCK_HALF_PERIOD clock = ~clock;
    end

    // Delay task.
    task delay_task;
        input integer delay_time;
        begin
            #delay_time; // Delay as timing control
        end
    endtask
    
    // Task that asserts reset_n for 1 cycle.
    task assert_reset;
    begin
        @(posedge clock);
        reset_n = 0;
        @(posedge clock);
        reset_n = 1;
    end
    endtask

    // Main test task without fork-join, using sequential logic
    task test_task;    
        input [7:0] op_tb;
        input [31:0] ABCD;
        input [8:0] expected_result;
        input integer delay0, delay1, delay2, delay3; // Individual delay values
    
        begin
            correct = 0;
            timeout = 0;
        
            delay_task(delay0);
            d_in = ABCD[31:24]; op = op_tb[7:6]; capture = 1; #10 capture = 0;
            
            delay_task(delay1);
            d_in = ABCD[23:16]; op = op_tb[5:4]; capture = 1; #10 capture = 0;
            
            delay_task(delay2);
            d_in = ABCD[15:8];  op = op_tb[3:2]; capture = 1; #10 capture = 0;
            
            delay_task(delay3);
            d_in = ABCD[7:0];   op = op_tb[1:0]; capture = 1; #10 capture = 0;
            
            done = 1;

            while(!timeout && !valid_asserted)begin           
                if (valid == 1'b1) begin
                    correct = (expected_result == result);
                    pass = correct;
                    if (correct) begin
                        $display("PASS: Test case passed!");
                        received = result;
                    end
                    else begin
                        $display("FAIL: Test case failed! Incorrect result.");
                        received = result;
                    end
                    valid_asserted = 1'b1;
                end  
                else begin
                    cycle_counter = cycle_counter + 1;
                    if(cycle_counter > TIMEOUT_CYCLES)begin
                            $display("FAIL: Test case failed! Timed out! Valid not received in ");
                            received = 9'bX;
                            pass = 0;
                            cycle_counter = 0;
                            timeout = 1;
                    end
                end
                #5;      
            end
            valid_asserted = 0;
            done = 0;
            cycle_counter = 0;
        end
    endtask
    
    initial begin
        // Clear testbench registers
        i = 0;
        reset_n = 1;
        cycle_counter = 0;
        capture = 0;
        valid_asserted = 0;
        correct = 0;
        timeout = 0;
        done = 0;
        pass = 0;
        
        
        // TEST CASES
        
        // TEST CASE-1
        Ain = 8'h00; Bin = 8'h00; Cin = 8'h00; Din = 8'h00; // Inputs A, B, C, and D
        OP_in = {A, B, C, D}; // Order of inputs
        de[0] = CLOCK_PERIOD; de[1] = CLOCK_PERIOD; de[2] = CLOCK_PERIOD; de[3] = CLOCK_PERIOD; // delay between inputs
        correct_result = (Ain - Bin) + (Cin - Din); // expected result
        assert_reset(); // assert reset for 1 cycle
        $display("TEST CASE 1: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in); // display inputs and order of inputs.
        test_task(OP_in, {Ain, Bin, Cin, Din}, correct_result, de[0], de[1], de[2], de[3]); // single test
        $display("EXPECTED: %h",correct_result); // 
        $display("RECEIVED: %h",received);
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-2
        Ain = 8'h55; Bin = 8'h55; Cin = 8'h55; Din = 8'h55;
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();
        $display("TEST CASE 2: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Ain, Bin, Cin, Din}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-3
        Ain = 8'hF0; Bin = 8'h0F; Cin = 8'hF0; Din = 8'hF0;
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();       
        $display("TEST CASE 3: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Ain, Bin, Cin, Din}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-4
        Ain = 8'hEF; Bin = 8'h01; Cin = 8'h0F; Din = 8'h01;
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();
        $display("TEST CASE 4: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Ain, Bin, Cin, Din}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-5
        Ain = 8'h92; Bin = 8'h56; Cin = 8'h3D; Din = 8'h24;
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();        
        $display("TEST CASE 5: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Ain, Bin, Cin, Din}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-6
        Ain = 8'h92; Bin = 8'h56; Cin = 8'h3D; Din = 8'h24;
        OP_in = {C, D, B, A}; // Change order for variation
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();       
        $display("TEST CASE 6: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Cin, Din, Bin, Ain}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-7
        Ain = 8'h81; Bin = 8'h72; Cin = 8'h9F; Din = 8'h2A;
        OP_in = {D, C, A, B}; // Different operation order
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();        
        $display("TEST CASE 7: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Din, Cin, Ain, Bin}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-8
        Ain = 8'h5A; Bin = 8'h17; Cin = 8'h3F; Din = 8'h21;
        OP_in = {A, B, C, D}; 
        de[0] = (CLOCK_PERIOD*3); de[1] = (CLOCK_PERIOD*2); de[2] = (CLOCK_PERIOD*4); de[3] = (CLOCK_PERIOD*1); // Different delays
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();        
        $display("TEST CASE 8: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Ain, Bin, Cin, Din}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-9
        Ain = 8'hD4; Bin = 8'h23; Cin = 8'hC9; Din = 8'h03;
        OP_in = {A, B, C, D}; 
        de[0] = (CLOCK_PERIOD*5); de[1] = (CLOCK_PERIOD*10); de[2] = (CLOCK_PERIOD*1); de[3] = (CLOCK_PERIOD*7); // Different delays
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();        
        $display("TEST CASE 9: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Ain, Bin, Cin, Din}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
        
        // TEST CASE-10
        Ain = 8'h82; Bin = 8'h75; Cin = 8'hE0; Din = 8'h11;
        OP_in = {A, B, C, D}; 
        de[0] = (CLOCK_PERIOD*5); de[1] = (CLOCK_PERIOD*5); de[2] = (CLOCK_PERIOD*5); de[3] = (CLOCK_PERIOD*5); // Different delays
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();       
        $display("TEST CASE 10: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Ain, Bin, Cin, Din}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
      
         // TEST CASE-11
        Ain = 8'hFF; Bin = 8'h0E; Cin = 8'hFF; Din = 8'h01;
        OP_in = {C, D, B, A}; 
        de[0] = (CLOCK_PERIOD*5); de[1] = (CLOCK_PERIOD*5); de[2] = (CLOCK_PERIOD*5); de[3] = (CLOCK_PERIOD*5); // Different delays
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();       
      	$display("TEST CASE 11: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Cin, Din, Bin, Ain}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
      
         // TEST CASE-12
        Ain = 8'h88; Bin = 8'h77; Cin = 8'h66; Din = 8'h55;
        OP_in = {D, C, A, B}; 
        de[0] = (CLOCK_PERIOD*5); de[1] = (CLOCK_PERIOD*5); de[2] = (CLOCK_PERIOD*5); de[3] = (CLOCK_PERIOD*5); // Different delays
        correct_result = (Ain - Bin) + (Cin - Din);
        assert_reset();       
      	$display("TEST CASE 12: A=%h B=%h C=%h D=%h OP(order of inputs)=%b",Ain,Bin,Cin,Din,OP_in);
        test_task(OP_in, {Din, Cin, Ain, Bin}, correct_result, de[0], de[1], de[2], de[3]);
        $display("EXPECTED: %h",correct_result);
        $display("RECEIVED: %h",received);        
        if (pass) i = i + 1;
        pass = 0;
      
        $display("SCORE: %d/12 TEST CASES PASSED", i);
        $finish;
    end
endmodule
