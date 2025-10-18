module bcdToGray (g, b);
	input [3:0] b;
	output [3:0] g;
	assign g[3] = b[3];
	assign g[2] = b[3] ^ b[2];
	assign g[1] = b[2] ^ b[1];
	assign g[0] = b[1] ^ b[0];
endmodule

module bcdToGray_tb;
	reg [3:0] b;
	wire [3:0] g;
	bcdToGray dut (g, b);
	initial
		begin
			$monitor(,$time , " : g = %b, b = %b", g,  b);
			#0 b = 4'b0001;
			#5 b = 4'b0010;
			#5 b = 4'b0011;
			#5 b = 4'b0100;
			#15 $finish;
		end
endmodule