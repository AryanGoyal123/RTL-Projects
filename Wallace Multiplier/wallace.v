`timescale 1ns / 100ps
// Gate Level Modelling
module half_adder (
    input a, b,
    output s, cout
);
  	xor (s, a, b);
  	and (cout, a, b);
    
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

module wallace_multiplier(
  input [7:0] A, B,
  output [15:0] Out
);

wire [7:0] p [7:0]; // Partial products

    //Generate Partial Products
    genvar i, j;
    generate
      for (i = 0; i < 8; i = i + 1) begin
        for (j = 0; j < 8; j = j + 1) begin
          and a1(p[i][j], A[i], B[j]); // AND gate for partial products
        end
      end
    endgenerate
  
  // f0
  assign Out[0] = p[0][0];
  
  // i = A, j = B
  //f1
  wire s1, c1;
  half_adder h1(p[0][1], p[1][0], Out[1], c1);
  
  //f2
  wire s2, s3, c2, c3;
  full_adder f1(p[0][2], p[2][0], c1, s2, c2);
  half_adder h2(s2, p[1][1], Out[2], c3);
  
  //f3
  wire s4, s5, s6, c4, c5, c6;
  full_adder f2(p[0][3], p[3][0], c2, s4, c4);
  full_adder f3(s4, p[2][1], c3, s5, c5);
  half_adder h3(s5, p[1][2], Out[3], c6);
	
  // f4
  wire s7, s8, s9, s10, c7, c8, c9, c10;
  full_adder f4(p[0][4], p[4][0], c4, s7, c7);
  full_adder f5(s7, p[1][3], c5, s8, c8);
  full_adder f6(s8, p[2][2], c6, s9, c9);
  half_adder h4(s9, p[3][1], Out[4], c10);

  // f5
  wire s11, s12, s13, s14, s15;
  wire c11, c12, c13, c14, c15;
  full_adder f7(p[0][5], p[5][0], c7, s11, c11);
  full_adder f8(s11, p[4][1], c8, s12, c12);
  full_adder f9(s12, p[3][2], c9, s13, c13);
  full_adder f10(s13, p[2][3], c10, s14, c14);
  half_adder h5(s14, p[1][4], Out[5], c15);
  
    // f6
  wire s16, s17, s18, s19, s20, s21;
  wire c16, c17, c18, c19, c20, c21;
  full_adder f11(p[0][6], p[6][0], c11, s16, c16);
  full_adder f12(s16, p[5][1], c12, s17, c17);
  full_adder f13(s17, p[4][2], c13, s18, c18);
  full_adder f14(s18, p[3][3], c14, s19, c19);
  full_adder f15(s19, p[2][4], c15, s20, c20);
  half_adder h6(s20, p[1][5], Out[6], c21);

  // f7
  wire s22, s23, s24, s25, s26, s27, s28;
  wire c22, c23, c24, c25, c26, c27, c28;
  full_adder f16(p[0][7], p[7][0], c16, s22, c22);
  full_adder f17(s22, p[6][1], c17, s23, c23);
  full_adder f18(s23, p[5][2], c18, s24, c24);
  full_adder f19(s24, p[4][3], c19, s25, c25);
  full_adder f20(s25, p[3][4], c20, s26, c26);
  full_adder f21(s26, p[2][5], c21, s27, c27);
  half_adder h7(s27, p[1][6], Out[7], c28);
  
    // f8
  wire s29, s30, s31, s32, s33, s34, s35;
  wire c29, c30, c31, c32, c33, c34, c35;
  full_adder f22(p[1][7], p[7][1], c22, s29, c29);
  full_adder f23(s29, p[6][2], c23, s30, c30);
  full_adder f24(s30, p[5][3], c24, s31, c31);
  full_adder f25(s31, p[4][4], c25, s32, c32);
  full_adder f26(s32, p[3][5], c26, s33, c33);
  full_adder f27(s33, p[2][6], c27, s34, c34);
  half_adder h8(s34, c28, Out[8], c35);

  // f9
  wire s36, s37, s38, s39, s40, s41, s42, s43;
  wire c36, c37, c38, c39, c40, c41, c42, c43;
  full_adder f28(p[2][7], p[7][2], c29, s36, c36);
  full_adder f29(s36, p[6][3], c30, s37, c37);
  full_adder f30(s37, p[5][4], c31, s38, c38);
  full_adder f31(s38, p[4][5], c32, s39, c39);
  full_adder f32(s39, p[3][6], c33, s40, c40);
  full_adder f33(s40, c34, c35, Out[9], c41);
  
  // f10
  wire s44, s45, s46, s47, s48, s49, s50;
  wire c44, c45, c46, c47, c48, c49, c50;
  full_adder f34(p[3][7], p[7][3], c36, s44, c44);
  full_adder f35(s44, p[6][4], c37, s45, c45);
  full_adder f36(s45, p[5][5], c38, s46, c46);
  full_adder f37(s46, p[4][6], c39, s47, c47);
  full_adder f38(s47, c40, c47, Out[10], c48);
  
  // f11
  wire s51, s52, s53, s54, s55;
  wire c51, c52, c53, c54, c55;
  full_adder f39(p[4][7], p[7][4], c44, s51, c51);
  full_adder f40(s51, p[6][5], c45, s52, c52);
  full_adder f41(s52, p[5][6], c46, s53, c53);
  full_adder f42(s53, c47, c48, Out[11], c54);

  // f12
  wire s56, s57, s58, s59;
  wire c56, c57, c58, c59;
  full_adder f43(p[5][7], p[7][5], c51, s56, c56);
  full_adder f44(s56, p[6][6], c52, s57, c57);
  full_adder f45(s57, c53, c54, Out[12], c58);

  // f13
  wire s60, s61, s62, s63;
  wire c60, c61, c62, c63;
  full_adder f46(p[6][7], p[7][6], c56, s60, c60);
  full_adder f47(s60, c57, c58, Out[13], c61);

  // f14, f15
  wire s64, s65;
  wire c64, c65;
  full_adder f48(p[7][7], c60, c61, Out[14], Out[15]);
  
endmodule
