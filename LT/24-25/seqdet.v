module seq_det (z1, clk, rst, x);

	input clk, rst, x;
	output reg z1;
	
	reg [2:0] state, nst;
	
	always @ (posedge clk)
		begin
			if(rst)
				state <= 3'b000;
			else
				state <= nst;
		end
		
	always @ (state, x)
		begin
			case(state)
				3'b000 : begin
					if(x) nst = 3'b001;
					else nst = 3'b000;
				end
				3'b001 : begin
					if(x) nst = 3'b001;
					else nst = 3'b010;
				end
				3'b010 : begin
					if(x) nst = 3'b001;
					else nst = 3'b011;
				end
				3'b011 : begin
					if(x) nst = 3'b100;
					else nst = 3'b000;
				end
				3'b100 : begin
					if(x) nst = 3'b001;
					else nst = 3'b000;
				end
				default : nst = 3'b000;
			endcase
		end
		
	always @ (state)
		begin
			case(state)
				3'b000 : begin
					z1 = 0;
				end
				3'b001 : begin
					z1 = 0;
				end
				3'b010 : begin
					z1 = 0;
				end
				3'b011 : begin
					z1 = 0;
				end
				3'b100 : begin
					z1 = 1;
				end
				default : z1 = 0;
			endcase
		end

endmodule

/* 			bin_counter			*/

module bin_counter (qout, clr1, clr2, clk);

	input clr1, clr2, clk;
	output reg [2:0] qout;
	
	always @ (posedge clk)
		begin
			if(clr1 | clr2)
				qout <= 3'b000;
			else
				qout <= (qout == 3'b111) ? 3'b111 : qout + 1;
		end
		
	initial
		qout = 3'b000;
	
endmodule

/*			dec_8		*/

module dec_8 (o8, s3);

	input [2:0] s3;
	output reg [7:0] o8;
	
	always @ (s3)
		begin
			o8 = 8'b00000000;
			case(s3)
				 3'b000: O[0] = 1;
				 3'b001: O[1] = 1;
				 3'b010: O[2] = 1;
				 3'b011: O[3] = 1;
				 3'b100: O[4] = 1;
				 3'b101: O[5] = 1;
				 3'b110: O[6] = 1;
				 3'b111: O[7] = 1; 
				 default: O = 8'b00000000;
			endcase
		end
endmodule



/* 		integrator		*/

module intg(z2, z1, x1, clk, res);

	input clk, res, x1;
	output z1;
	output [7:0] z2;
	output [2:0] qout;
		
	seq_det seqdetect (z1, clk, res, x1);
	bin_counter binup (qout, rst, z2[3], clk);
	dec_8 decod (z2, qout);	

endmodule

/*	testbench	*/

module tb_seqdet ();

	wire [7:0] z2;
	wire [2:0] qout;
	wire z1;
	
	reg clk, res, x1;
	
	intg DUT (z2, z1, x1, clk, res);
	
	initial
		begin
			clk = 1'b0;
			forever
				begin
					#5 clk = 1'b1;
					#5 clk = 1'b0;
				end
		end
		
		integer i = 0;
		
		initial
			begin
				#15 i = 1;
				forever	
					#10 i = i + 1;	//clk pulse
			end
			
		initial
			begin
				res = 1'b1;
				x1 = 1'b0
				
				#7 res = 1'b0;
				x1 = 1'b1;
				
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b1;
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b1;
				#10 x1 = 1'b1;
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b1;
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b1;
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b1;
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b1;
				#10 x1 = 1'b0;
				#10 x1 = 1'b0;
				#10 x1 = 1'b1;
				
				#20 $finish;
				
				
			end
		
		initial
			$monitor($time, " : pulse : %b, z1 = %b, z2 = %b, x = %b", i, z1, z2, x);
		

endmodule