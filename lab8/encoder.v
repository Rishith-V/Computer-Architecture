module encoder(func, op);

    input [7:0] func;
    output reg [2:0] op;

    always@(*)
        begin
            if(func[7])
                op = 3'b0;
            else if(func[6])
                op = 3'b001;
            else if(func[5])
                op = 3'b010;
            else if(func[4])
                op = 3'b011;
            else if(func[3])
                op = 3'b100;
            else if(func[2])
                op = 3'b101;
            else if(func[1])
                op = 3'b110;
            else
                op = 3'b111;
        end

endmodule