module reg_8bit (reg_out, num_in, clock, reset);

	input [7:0] num_in;
	input clock, reset;
	output reg [7:0] reg_out;
	
	always @ (posedge clock)
		if(reset)
			reg_out <= 8'b00000000;
		else
			reg_out <= num_in;

endmodule

/* ----------------------------------------*/

module expansion_box (in, out);

	input [3:0] in;
	output [7:0] out;
	
	assign out = {in[3], in[0], in[1], in[2], in[1], in[3], in[2], in[0]};

endmodule

module xor_8bit (xout_8, xin1_8, xin2_8);

	input [7:0] xin1_8, xin2_8;
	output [7:0] xout_8;
	
	assign xout_8 = xin1_8 ^ xin2_8;

endmodule

module xor_4bit (xout_4, xin1_4, xin2_4);

		input [3:0] xin1_4, xin2_4;
		output [3:0] xout_4;
		
		assign xout_4 = xin1_4 ^ xin2_4;
		
endmodule

module fa (in1, in2, cin, s, cout);


	input in1, in2, cin;
	output s, cout;
	
	assign s = in1 ^ in2 ^ cin;
	assign cout = in1 & in2 | in2 & cin | cin & in1;

endmodule

module rca (in1, in2, cin, cout, s);

	input [3:0] in1, in2;
	input cin;
	output cout;
	output [3:0] s;
	
	wire cin1, cin2, cin3;
	
	fa inst0 (in1[0], in2[0], cin, s[0], cin1);
	fa inst1 (in1[1], in2[1], cin1, s[1], cin2);
	fa inst2 (in1[2], in2[2], cin2, s[2], cin3);
	fa inst3 (in1[3], in2[3], cin3, s[3], cout);

endmodule


module csa_4bit (cin, ina, inb, cout, out);

	input [3:0] ina, inb;
	input cin;
	output cout;
	output [3:0] out;
	
	wire [3:0] sc, sg;
	wire cc, cg;
	
	rca instc (ina, inb, 1'b1, cc, sc);
	rca instg (ina, inb, 1'b0, cg, sg);
	
	assign cout = cin ? cc : cg;
	assign out = cin ? sc : sg;

endmodule

module concat (concat_out, concat_in1, concat_in2);

	input [3:0] concat_in1, concat_in2;
	output [7:0] concat_out;
	
	assign concat_out = {concat_in2, concat_in1};
	
endmodule

module encrypt (number, key, clock, reset, enc_number);

	input [7:0] number, key;
	input clock, reset;
	output [7:0] enc_number;
	
	wire [7:0] regonum, regokey;
	reg_8bit numbreg (regonum, number, clock, reset);
	reg_8bit keyreg (regokey, key, clock, reset);
	
	wire [7:0] numexp;
	expansion_box numbex (regonum[3:0], numexp);
	
	wire [7:0] xoredout;
	xor_8bit numbex_key (xoredout, regokey, numexp);
	
	wire [3:0] csas;
	wire csac;
	csa_4bit inscsa (regokey[0], xoredout[7:4], xoredout[3:0], csac, csas);
	
	wire [3:0] xorcsa;
	xor_4bit csaxor (xorcsa, csas, regonum[7:4]);
	
	concat fincon (enc_number, regonum[3:0], xorcsa);

endmodule


module tb_encrypt ();

	wire [7:0] enc_number;
	reg [7:0] number, key;
	reg clock, reset;
	
	encrypt DUT (number, key, clock, reset, enc_number);
	
	initial
		begin
			clock = 1'b0;
			forever
				begin
					#5 clock = 1'b1;
					#5 clock = 1'b0;
				end
		end
		
	initial
		begin
			reset = 1'b1;
			number = 8'b00000000;
			key = 8'b00000000;
			
			#7 reset = 1'b0;
			number = 8'b01000110;
			key = 8'b10010011;
			
			#10 number = 8'b11001001;
			key = 8'b10101100;
			
			#10 number = 8'b10100101;
			key = 8'b01011010;
			
			#10 number = 8'b11110000;
			key = 8'b10110001;
			
			#20 $finish;
		end
		
		initial
			$monitor($time, " : number = %b, key = %b, encrypt = %b", number, key, enc_number);

endmodule