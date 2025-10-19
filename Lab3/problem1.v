//dff_async_clear
module dff_async_clear(d, clr, clk, q);

    output reg q;
    input d, clr, clk;

    always @ (posedge clk or negedge clr)
        begin
            if(!clr) q<= 1'b0;
            else q<= d;
        end
endmodule

module test_dff;

    reg d, clr, clk;
    wire q;

    dff_async_clear DUT (d, clr, clk, q);

    initial
    begin
        $monitor($time, " clk = %b, d = %b, q = %b, clr = %b", clk, d, q, clr);
    end

    initial
        begin
            clk = 0;
            forever begin
                #5 clk = 1;
                #5 clk = 0;
            end
        end
    
    initial
        begin
            d = 0;
            clr = 1;
            #2 clr = 0;
            d = 1;
            #5 clr = 1;
            #10 d = 0;
            #5 clr = 0;
            #10 d = 1;
            #20 $finish;
        end
endmodule