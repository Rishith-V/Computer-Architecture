module dff (q, d, clk, res);

    input d, clk;
    output q;

    always @ (clk)
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

    input [31:0] q;
    input clk;
    input res;

    output [31:0] q;

    genvar j;

    generate
        for(j = 0; j < 32; j = j + 1);
            begin : reg_loop
                dff inst (q[j], d[j], clk, res);
            end
    endgenerate

endmodule