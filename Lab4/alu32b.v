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
  decoder dec(d, x, y, z);
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

module mux2to1 (sel, in1, in2, outp);

    input in1, in2, sel;
    output outp;

    wire nsel, a1, a2;

    not(nsel, sel);
    and(a1, nsel, in1);
    and(a2, sel, in2);
    or(outp, a1, a2);

endmodule

module bit8_mux2to1 (in1, in2, sel, outp);

    input [7:0] in1;
    input [7:0] in2;
    input sel;
    output [7:0] outp;

    genvar j;

    generate
        for(j = 0; j < 8; j = j + 1) 
            begin : mux_loop
                mux2to1 m1 (sel, in1[j], in2[j], outp[j]);  //each mux named mux_loop[j].m1
            end

    endgenerate

endmodule

module bit32_mux2to1 (in1, in2, sel, outp);

    input [31:0] in1;
    input [31:0] in2;
    input sel;
    output [31:0] outp;

    bit8_mux2to1 first (in1[7:0], in2[7:0], sel, outp[7:0]);
    bit8_mux2to1 second (in1[15:8], in2[15:8], sel, outp[15:8]);
    bit8_mux2to1 third (in1[23:16], in2[23:16], sel, outp[23:16]);
    bit8_mux2to1 fourth (in1[31:24], in2[31:24], sel, outp[31:24]);

endmodule

// module tb_bit32_mux2to1;     

//     reg [31:0] in1;
//     reg [31:0] in2;
//     reg sel;
//     wire [31:0] outp;

//     bit32_mux2to1 DUT (in1, in2, sel, outp);

//     initial
//         begin
//             $monitor($time, " : in1 = %b, in2 = %b, sel = %b, output = %b", in1, in2, sel, outp);
//         end

//     initial
//         begin
//             in1 = 32'haaaa; in2 = 32'h5555; sel = 1'b0;
//             #5 sel = 1'b1;
//             #20 $finish;
//         end

// endmodule

module bit32_mux3to1(in1, in2, in3, sel, outp);

    input [31:0] in1;
    input [31:0] in2;
    input [31:0] in3;
    input [1:0] sel;
    output [31:0] outp;

    wire [31:0] a;

    bit32_mux2to1 inst1 (in1, in2, sel[0], a);
    bit32_mux2to1 inst2 (a, in3, sel[1], outp);

endmodule

// module tb_bit32_mux3to1;     

//     reg [31:0] in1;
//     reg [31:0] in2;
//     reg [31:0] in3;
//     reg [1:0] sel;
//     wire [31:0] outp;

//     bit32_mux3to1 DUT (in1, in2, in3, sel, outp);

//     initial
//         begin
//             $monitor($time, " : in1 = %b, in2 = %b, in3 = %b, sel = %b, output = %b", in1, in2, in3, sel, outp);
//         end

//     initial
//         begin
//             in1 = 32'haaaa; in2 = 32'h5555; in3 = 32'h7777; sel = 2'b00;
//             #5 sel = 2'b01;
//             #5 sel = 2'b10;
//             #20 $finish;
//         end

// endmodule

module or32b(in1, in2, outp);

    input [31:0] in1;
    input [31:0] in2;
    output [31:0] outp;

    assign outp = in1 | in2;

endmodule

module and32b(in1, in2, outp);

    input [31:0] in1;
    input [31:0] in2;
    output [31:0] outp;

    assign outp = in1 & in2;

endmodule

module alu_final(in1, in2, outp, binvert, op, carryout);

    input [31:0] in1;
    input [31:0] in2;
    input binvert;
    input [1:0] op;

    output carryout;
    output [31:0] outp;

    wire [31:0] a1, a2, a3, a4;
    wire [31:0] nin2;

    and32b instand (in1, in2, a1);
    or32b insor (in1, in2, a2);

    assign nin2 = ~in2;

    bit32_mux2to1 instmux2 (in2, nin2, binvert, a3);
    bit32_fadder instadder (carryout, a4, in1, a3, binvert);

    bit32_mux3to1 instmux3 (a1, a2, a4, op, outp);

endmodule

module tb_alu;

    reg [31:0] in1, in2;
    reg [1:0] op;
    reg binvert;

    wire carryout;
    wire [31:0] outp;

    alu_final DUT (in1, in2, outp, binvert, op, carryout);

    initial
        begin
            $monitor($time, " : in1 = %b, in2 = %b, binvert = %b, op = %b, outp = %b, carryout = %b", in1, in2, binvert, op, outp, carryout);
        end

    initial
        begin
            in1 = 32'ha5a5a5a5;
            in2 = 32'h5a5a5a5a;
            op = 2'b00;
            binvert = 1'b0;
            #10 op = 2'b01;
            #10 op = 2'b10;
            #10 binvert = 1'b1;
            #20 $finish;
            
        end

endmodule