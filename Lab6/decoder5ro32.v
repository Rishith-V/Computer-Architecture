module dec5to32(d, q);
    
    input [4:0] d;
    output reg [31:0] q;
    
    always @ (*)
        begin
            q = 32'b0;
            q[d] = 1'b1;
        end

endmodule