//`timescale 1ns
module nand_gate (out, x, y);
	output out;
	input x, y;
	wire ando;
	and a1(ando, x, y);
	not n1(out, ando);
endmodule


module nand_tb;
	reg x, y;
	wire out;
	nand_gate dut (out, x, y);
	initial
		begin
			$monitor(,$time , " : x = %b, y = %b, out = %b", x,  y, out);
			#0 x = 1'b0; y = 1'b0;
			#5 x = 1'b1; y = 1'b0;
			#5 x = 1'b0; y = 1'b1;
			#5 x = 1'b1; y = 1'b1;
			#15 $finish;
		end
endmodule