module maincont (op, clk, res, pcw, pcwcond, iord, memr, memw, irw, memtoreg, alusrca, regw, regdst, pcsrc, aluop, alusrcb);
    input [5:0] op;
    input clk, res;
    output pcw;
    output pcwcond;
    output iord;
    output memr;
    output memw;
    output irw;
    output memtoreg;
    output alusrca;
    output regw;
    output regdst;
    output [1:0] pcsrc;
    output [1:0] aluop;
    output [1:0] alusrcb;

    reg pcw, pcwcond, iord, memr, memw, irw, memtoreg, alusrca, regw, regdst;
    reg [1:0] pcsrc, aluop, alusrcb;
    
    reg [3:0] S;
    reg [3:0] NS;

    always @(posedge clk)
    begin
        if(res)
            S <= 4'b0000;
        else
            S <= NS;
    end

    always @(*)
    begin
        
        pcw = 1'b0;       pcwcond = 1'b0; iord = 1'b0;      memr = 1'b0;
        memw = 1'b0;      irw = 1'b0;     memtoreg = 1'b0;  alusrca = 1'b0;
        regw = 1'b0;      regdst = 1'b0;  pcsrc = 2'b00;    aluop = 2'b00;
        alusrcb = 2'b00;
        
        NS = S; 

        case (S)
            
            4'b0000: begin
                memr = 1'b1;
                irw = 1'b1;
                pcw = 1'b1;
                alusrcb = 2'b01;
                aluop = 2'b00;
                pcsrc = 2'b00;
                
                NS = 4'b0001;
            end

            4'b0001: begin
                alusrcb = 2'b11;
                aluop = 2'b00;

                if (op == 6'b100011 || op == 6'b101011)
                    NS = 4'b0010;
                else if (op == 6'b000000)
                    NS = 4'b0110;
                else if (op == 6'b000100)
                    NS = 4'b1000;
                else if (op == 6'b000010)
                    NS = 4'b1001;
                else
                    NS = 4'b0000; 
            end

            4'b0010: begin
                alusrca = 1'b1;
                alusrcb = 2'b10;
                aluop = 2'b00;
                
                if (op == 6'b100011)
                    NS = 4'b0011;
                else
                    NS = 4'b0101;
            end

            4'b0011: begin
                memr = 1'b1;
                iord = 1'b1;
                
                NS = 4'b0100;
            end

            4'b0100: begin
                regw = 1'b1;
                regdst = 1'b0;
                memtoreg = 1'b1;
                
                NS = 4'b0000;
            end

            4'b0101: begin
                memw = 1'b1;
                iord = 1'b1;
                
                NS = 4'b0000;
            end

            4'b0110: begin
                alusrca = 1'b1;
                alusrcb = 2'b00;
                aluop = 2'b10;
                
                NS = 4'b0111;
            end

            4'b0111: begin
                regw = 1'b1;
                regdst = 1'b1;
                memtoreg = 1'b0;
                
                NS = 4'b0000;
            end

            4'b1000: begin
                alusrca = 1'b1;
                alusrcb = 2'b00;
                aluop = 2'b01;
                pcwcond = 1'b1;
                pcsrc = 2'b01;
                
                NS = 4'b0000;
            end

            4'b1001: begin
                pcw = 1'b1;
                pcsrc = 2'b10;
                
                NS = 4'b0000;
            end 
            
            default: begin
                NS = 4'b0000;
            end
            
        endcase
    end

endmodule


module tb_maincont();

    wire pcw;
    wire pcwcond;
    wire iord;
    wire memr;
    wire memw;
    wire irw;
    wire memtoreg;
    wire alusrca;
    wire regw;
    wire regdst;
    wire [1:0] pcsrc;
    wire [1:0] aluop;
    wire [1:0] alusrcb;

    reg [5:0] op;
    reg clk, res;

    maincont DUT (op, clk, res, pcw, pcwcond, iord, memr, memw, irw, memtoreg, alusrca, regw, regdst, pcsrc, aluop, alusrcb);

    initial
        begin
            $monitor($time, " : state : %b, op : %b, pcw=%b memr=%b memw=%b regw=%b, next state : %b", DUT.S, op, pcw, memr, memw, regw, DUT.NS);
        end


    initial begin
        clk = 1'b0;
        forever begin
            #5 clk = 1'b1;
            #5 clk = 1'b0;
        end
    end

    initial
        begin
            op = 6'b100011;
            res = 1'b1;
            #7 res = 1'b0;

            #60;

            op = 6'b000000;
            #60 $finish;
        end     

endmodule