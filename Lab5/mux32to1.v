module mux32to1(d, sel, q);

    input [31:0] d [0:31];
    input [4:0] sel;

    output reg [31:0] q;

    always @ (*)
        begin
            q = d[sel];
        end

endmodule