module decoder(out, x, y, z);
  input x, y, z;
  output  [0:7]out;
  wire  x0, y0, z0;
  not g1(x0, x);
  not g2(y0, y);
  not g3(z0, z);
  and g4(out[0], x0, y0, z0);
  and g5(out[1], x0, y0, z);
  and g6(out[2], x0, y, z0);
  and g7(out[3], x0, y, z);
  and g8(out[4], x, y0, z0);
  and g9(out[5], x, y0, z);
  and g10(out[6], x, y, z0);
  and g11(out[7], x, y, z);
endmodule

module  fadder(carry, sum, x, y, z);
  input x, y, z;
  output  sum, carry;
  wire  [0:7] d; 
  DECODER dec(d, x, y, z);
  assign  sum = d[1] | d[2] | d[4] | d[7],
          carry = d[3] | d[5] | d[6] | d[7];
endmodule

module bit8_fadder(c, s, in1, in2, cin);

    input [7:0] in1;
    input [7:0] in2;
    input cin;
    output [7:0] s;
    output c;

    wire carry[8:0];
    assign c = carry[8];
    assign carry[0] = cin;

    genvar j;

    generate
        for(j = 0; j < 8; j = j + 1) 
            begin : fadder_loop
                fadder inst (carry[j+1], s[j], in1[j], in2[j], carry[j]);
            end
    endgenerate


endmodule

module bit32_fadder (c, s, in1, in2, cin);

    input [31:0] in1;
    input [31:0] in2;
    input cin;
    output [31:0] s;
    output c;

    wire c1, c2, c3;

    bit8_fadder inst1 (c1, s[7:0], in1[7:0], in2[7:0], cin);
    bit8_fadder inst2 (c2, s[15:8], in1[15:8], in2[15:8], c1);
    bit8_fadder inst3 (c3, s[23:16], in1[23:16], in2[23:16], c2);
    bit8_fadder inst4 (c, s[31:24], in1[31:24], in2[31:24], c3);    

endmodule