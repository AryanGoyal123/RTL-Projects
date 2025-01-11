`timescale 1ns / 100 ps

module tb_adder_str;

    // Test signals for half adder
    reg ha_a, ha_b;
    wire ha_sum, ha_c_out;

    // Test signals for full adder
    reg fa_a, fa_b, fa_cin;
    wire fa_sum, fa_c_out;

    // Instantiate half adder
    half_adder_str uut_half_adder (
        .a(ha_a),
        .b(ha_b),
        .sum(ha_sum),
        .c_out(ha_c_out)
    );

    // Instantiate full adder
    full_adder_str uut_full_adder (
        .a(fa_a),
        .b(fa_b),
        .cin(fa_cin),
        .sum(fa_sum),
        .c_out(fa_c_out)
    );

    // Monitor signals
    initial begin
        $monitor("Time=%0t | Half Adder: a=%b b=%b | sum=%b c_out=%b || Full Adder: a=%b b=%b c_in=%b | sum=%b c_out=%b", 
                 $time, ha_a, ha_b, ha_sum, ha_c_out, fa_a, fa_b, fa_cin, fa_sum, fa_c_out);

        // Test half adder
        ha_a = 0; ha_b = 0; #10;
        ha_a = 0; ha_b = 1; #10;
        ha_a = 1; ha_b = 0; #10;
        ha_a = 1; ha_b = 1; #10;

        // Test full adder
        fa_a = 0; fa_b = 0; fa_cin = 0; #10;
        fa_a = 0; fa_b = 0; fa_cin = 1; #10;
        fa_a = 0; fa_b = 1; fa_cin = 0; #10;
        fa_a = 0; fa_b = 1; fa_cin = 1; #10;
        fa_a = 1; fa_b = 0; fa_cin = 0; #10;
        fa_a = 1; fa_b = 0; fa_cin = 1; #10;
        fa_a = 1; fa_b = 1; fa_cin = 0; #10;
        fa_a = 1; fa_b = 1; fa_cin = 1; #10;

        // End simulation
        $finish;
    end
endmodule
