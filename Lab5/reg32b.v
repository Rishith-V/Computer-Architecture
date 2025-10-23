module dff (q, d, clk, res);

    input d, clk, res;
    output reg q;

    always @ (posedge clk)
        begin
            if(!res)
                begin
                    q <= 1'b0;
                end
            else
                begin
                    q <= d;
                end
        end

endmodule

module reg_32b (q, d, clk, res);

    input [31:0] d;
    input clk;
    input res;

    output [31:0] q;

    genvar j;

    generate
        for(j = 0; j < 32; j = j + 1)
            begin : reg_loop
                dff inst (q[j], d[j], clk, res);
            end
    endgenerate

endmodule

module tb_reg32b;

    reg [31:0] d;
    reg clk, res;
    wire [31:0] q;

    reg_32b DUT (q, d, clk, res);

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
            res = 1'b0;
            #10 res = 1'b1;
            d = 32'hafafafaf;
            #20 $finish;
        end

    initial 
        begin
            $monitor($time, " : clk = %b, d = %b, res = %b, q = %b", clk, d, res, q);
        end

endmodule