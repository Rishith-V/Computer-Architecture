module jkff (j, k, q, clk);

	input j, k, clk;
	output reg q;
	
	always @ (negedge clk)
		begin
			case ({j, k})
				2'b00: q<=q;
				2'b01:q<=1'b0;
				2'b10:q<=1'b1;
				2'b11:q<=~q;
			endcase
		end

endmodule

module bcd_count (qout, clk);

	input clk;
	output [3:0] qout;
	
	jkff jk0 (1'b1, 1'b1, qout[0], clk);
	jkff jk1 (~qout[3], 1'b1, qout[1], qout[0]);
	jkff jk2 (1'b1, 1'b1, qout[2], q[1]);
	jkff jk3 ((qout[2] & qout[1]), 1'b1, qout[3], q[0]);

endmodule
