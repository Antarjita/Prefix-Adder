module pg(input ai, bi, output pi, gi);
	and2 and_0(ai, bi, gi);
	or2 or_0(ai, bi, pi);
endmodule

module pg_grouped(input pi_k, gi_k, pk_j, gk_j, output pi_j, gi_j);
	wire temp;
	and2 and_0(pi_k, pk_j, pi_j);
	and2 and_1(pi_k, gk_j, temp);
	or2 or_1(gi_k, temp, gi_j);
endmodule

module sum(input gi_blk, ai, bi, output sum_i);
	wire temp;
	xor2 xor_0(ai, bi, temp);
	xor2 xor_1(gi_blk, temp, sum_i);
endmodule

module carry(input p_block, g_block, cin, output cout);
	wire temp;
	and2 and_0(p_block, cin, temp);
	or2 or_0(g_block, temp, cout);
endmodule

//8-bit Prefix Adder
module prefixAdder(input [7:0]ai, bi, input p_minus1, g_minus1, output cout, output [7:0]sum);
//p_minus1 and g_minus1 are = 0 for the first prefix adder block

	wire [7:0]pi, gi; //check syntax - is [7:0] before gi required? -X
	//wire [7:0]pi;
	//wire [7:0]gi;
	//wire p_minus1, g_minus1;
	wire  p0_minus1, p2_1, p4_3, p6_5, p1_minus1, p2_minus1, p5_3, p6_3, p3_minus1, p4_minus1, p5_minus1, p6_minus1, p7_minus1;
	wire  g0_minus1, g2_1, g4_3, g6_5, g1_minus1, g2_minus1, g5_3, g6_3, g3_minus1, g4_minus1, g5_minus1, g6_minus1, g7_minus1;
	
	/*		
	assign p_minus1=1'b0;
	assign g_minus1=1'b0; // pi and gi for -1th column is 0
	*/
	
	//Generation of pi, gi
	pg p0g0(ai[0], bi[0], pi[0], gi[0]);
	pg p1g1(ai[1], bi[1], pi[1], gi[1]);
	pg p2g2(ai[2], bi[2], pi[2], gi[2]);
	pg p3g3(ai[3], bi[3], pi[3], gi[3]);
	pg p4g4(ai[4], bi[4], pi[4], gi[4]);
	pg p5g5(ai[5], bi[5], pi[5], gi[5]);
	pg p6g6(ai[6], bi[6], pi[6], gi[6]);
	pg p7g7(ai[7], bi[7], pi[7], gi[7]);
	
	//Generation of gi:-1 for all i
	
	//Level 1
	pg_grouped pg0_minus1(pi[0], gi[0], p_minus1, g_minus1, p0_minus1, g0_minus1);
	pg_grouped pg2_1(pi[2], gi[2], pi[1], gi[1], p2_1, g2_1);
	pg_grouped pg4_3(pi[4], gi[4], pi[3], gi[3] ,p4_3, g4_3);
	pg_grouped pg6_5(pi[6], gi[6], pi[5], gi[5] ,p6_5, g6_5);
	
	//Level 2
	pg_grouped pg1_minus1(pi[1], gi[1], p0_minus1, g0_minus1, p1_minus1, g1_minus1);
	pg_grouped pg2_minus1(p2_1, g2_1, p0_minus1, g0_minus1, p2_minus1, g2_minus1);
	pg_grouped pg5_3(pi[5], gi[5], p4_3, g4_3, p5_3,g5_3);
	pg_grouped pg6_3(p6_5, g6_5, p4_3, g4_3, p6_3,g6_3);
	
	//Level 3
	pg_grouped pg3_minus1(pi[3], gi[3], p2_minus1, g2_minus1,p3_minus1,g3_minus1);
	pg_grouped pg4_minus1(p4_3, g4_3, p2_minus1, g2_minus1,p4_minus1,g4_minus1);
	pg_grouped pg5_minus1(p5_3,g5_3, p2_minus1, g2_minus1,p5_minus1,g5_minus1);
	pg_grouped pg6_minus1(p6_3,g6_3, p2_minus1, g2_minus1,p6_minus1,g6_minus1);
	
	//Level 4
	pg_grouped pg7_minus1(pi[7], gi[7], p6_minus1, g6_minus1,p7_minus1,g7_minus1);
	
	//Sum Generation:
	//sum s0(g0_minus1, ai[0], bi[0], sum[0]);
	//sum s1(g1_minus1, ai[1], bi[1], sum[1]);
	
	sum s0(g_minus1, ai[0], bi[0], sum[0]);
	sum s1(g0_minus1, ai[1], bi[1], sum[1]);
	sum s2(g1_minus1, ai[2], bi[2], sum[2]);
	sum s3(g2_minus1, ai[3], bi[3], sum[3]);
	sum s4(g3_minus1, ai[4], bi[4], sum[4]);
	sum s5(g4_minus1, ai[5], bi[5], sum[5]);
	sum s6(g5_minus1, ai[6], bi[6], sum[6]);
	sum s7(g6_minus1, ai[7], bi[7], sum[7]);
	
//assign cout=g7_minus1 + p7_minus1*g_minus1; Is assign required? - Yes
	carry c_0(p7_minus1, g7_minus1, g_minus1, cout);
endmodule
