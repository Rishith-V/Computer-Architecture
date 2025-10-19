module shiftreg(d, si, clk, lden, shen, so, q);

    parameter n = 4;

    input [n-1:0] d;
    input si, clk, lden, shen;
    output so;
    output reg [n-1:0] q;

    assign so = q[0];

    always@(posedge clk)
        begin
            if(lden)
                begin
                    q <= d; //parallel load
                end
            else if(shen)
                begin
                    q <= {si, q[n-1:1]};
                end
        end

endmodule

module dff(d, q, clk, clr);

    input d, clk, clr;
    output reg q;

    always@(posedge clk or posedge clr)
        begin
            if(clr)
                begin
                    q<=1'b0;
                end
            else
                q<=d;
        end

endmodule

module fa(x, y, z, s, c);

    input x, y, z;
    output s, c;

    assign s = x ^ y ^ z;
    assign c = (x&y) | (y&z) | (z&x);

endmodule

module serialadder(clk, lden, shen, clr, a, b, qa);

    input clk, lden, shen, clr;
    output [3:0] qa;
    input [3:0] a, b;

    wire so_a, so_b, fa_s, fa_c, d_q, dff_clk_gated;

    shiftreg fora (a, fa_s, clk, lden, shen, so_a, qa);
    shiftreg forb (b, 1'b0, clk, lden, shen, so_b, );

    fa FA(so_a, so_b, d_q, fa_s, fa_c);
    
    assign dff_clk_gated = shen & clk;

    dff DFF(fa_c, d_q, dff_clk_gated, clr);

endmodule

module tb_serialadder;
endmodule