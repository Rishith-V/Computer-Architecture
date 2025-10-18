module fourBcomp (out, x, y);
	input [3:0] x, y;
	output out;
	assign out = (~(x[3] ^ y[3])) & (~(x[2] ^ y[2])) & (~(x[1] ^ y[1])) & (~(x[0] ^ y[0])) ? 
	