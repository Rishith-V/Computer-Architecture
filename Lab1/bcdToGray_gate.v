module bcdToGray(g, b);
	output [3:0] g;
	input [3:0] b;
	assign g[3] = b[3];
	xor x1 (g[2], b[3], b[2]);
	xor x2 (g[1], b[2],  b[1]);
	xor x3 (g[0], b[1], b[0]);
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