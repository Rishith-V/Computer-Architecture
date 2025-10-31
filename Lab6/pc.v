module pc (q, clk, res);

    output reg [31:0] q;
    input clk, res;

    always @ (posedge clk)
        begin
            if(!res)
                begin
                    q <= 32'b0;
                end
            else
                begin
                    q <= q + 4; 
                end
        end

endmodule