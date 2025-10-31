module alu(a, b, op, x);

    input [3:0] a, b;
    input [2:0] op;
    output reg [3:0] x;

    always @ (*)
        begin
            if(op == 3'b000)
                x = a + b;
            else if(op == 3'b001)
                x = a - b;
            else if(op == 3'b010)
                x = a ^ b;
            else if(op == 3'b011)
                x = a | b;
            else if(op == 3'b100)
                x = a & b;
            else if(op == 3'b101)
                x = ~(a | b);
            else if(op == 3'b110)
                x = ~(a & b);
            else 
                x = ~(a ^ b);
        end

endmodule