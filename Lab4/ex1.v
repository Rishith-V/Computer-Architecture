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

module bit32_mux4to1(in1, in2, in3, sel, outp);

    input [31:0] in1;
    input [31:0] in2;
    input [31:0] in3;
    input [1:0] sel;
    output [31:0] outp;

    wire [31:0] a;

    bit32_mux2to1 inst1 (in1, in2, sel[0], a);
    bit32_mux2to1 inst2 (a, in3, sel[1], outp);

endmodule

module tb_bit32_mux4to1;     

    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [1:0] sel;
    wire [31:0] outp;

    bit32_mux4to1 DUT (in1, in2, in3, sel, outp);

    initial
        begin
            $monitor($time, " : in1 = %b, in2 = %b, in3 = %b, sel = %b, output = %b", in1, in2, in3, sel, outp);
        end

    initial
        begin
            in1 = 32'haaaa; in2 = 32'h5555; in3 = 32'h7777; sel = 2'b00;
            #5 sel = 2'b01;
            #5 sel = 2'b10;
            #20 $finish;
        end

endmodule