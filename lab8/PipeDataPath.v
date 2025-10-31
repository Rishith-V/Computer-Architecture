`include "encoder.v"
`include "alu.v"
`include "paritygen.v"

module pipedp (clk, res, a, b, func, gp);

    input clk, res;
    input [3:0] a, b;
    input [7:0] func;

    reg [2:0] if_ex_op;
    reg [3:0] if_ex_a, if_ex_b;
    reg [3:0] ex_gp_x;

    output gp;

    wire [2:0] op;
    wire [3:0] x;

    encoder funenc (func, op);
    alu resx (if_ex_a, if_ex_b, if_ex_op, x);
    par_gen pgf (ex_gp_x, gp);


    always @ (posedge clk)
        begin
            if(res)
                begin
                    if_ex_a <= 4'b0000;
                    if_ex_b <= 4'b0000;
                    if_ex_op <= 3'b000;
                    ex_gp_x <= 4'b0000;                    
                end
            else
                begin
                    if_ex_a <= a;
                    if_ex_b <= b;
                    if_ex_op <= op;
                    ex_gp_x <= x;
                end
        end

endmodule

module tb_pipdp();

    wire gp;

    reg clk, res;
    reg [3:0] a, b;
    reg [7:0] func;

    pipedp DUT (clk, res, a, b, func, gp);

    initial
        begin
            clk = 1'b0;
            forever     
                begin
                    #5 clk = 1'b1;
                    #5 clk = 1'b0;
                end
        end

        initial 
            begin
                res = 1'b1;
                #7 res = 1'b0;
                a = 4'b0011;
                b = 4'b0011;
                func = 8'b01000000;

                #10 a = 4'b0001;
                b = 4'b0001;
                func = 8'b10000000;

                #40 $finish;
            end
        
        initial
            begin
                $monitor($time, " : a = %b, b = %b, func = %b, op = %b, gp = %b", DUT.if_ex_a, DUT.if_ex_b, func, DUT.op, gp);
            end


endmodule