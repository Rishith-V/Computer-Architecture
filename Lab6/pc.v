module pc (d, q, clk, res);

    output reg [31:0] q;
    input clk, res;
    input [31:0] d;

    always @ (posedge clk)
        begin
            if(!res)
                begin
                    q <= 32'b0;
                end
            else
                begin
                    q <= d; 
                end
        end

endmodule