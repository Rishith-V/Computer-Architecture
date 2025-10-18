//example for for and join
module ex(a, b, c, d);

    output reg a, b, c, d;

    initial begin
        fork
            #5 a = 1'b1;
            #10 b = 1'b0;
            #c = b;
        join
        #30 d = 1'b0;
    end
endmodule