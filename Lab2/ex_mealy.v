//mealy machine example(pg 5)
module mealy(clk, rst, inp, outp);

    output reg outp;
    input clk, rst;
    reg [1:0] state;

    always @ (posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    state <= 2'b00;
                    outp <= 1'b0;
                end
            else
                begin
                    case(state)
                        2'b00 : 
                            begin
                                if(inp)
                                    begin
                                        outp <= 1'b0;
                                        state <= 2'b01;
                                    end
                                else
                                    begin
                                        outp <= 1'b0;
                                        state <= 2'b10;
                                    end
                            end
                        2'b01 : 
                            begin
                                if(inp)
                                    begin
                                        outp <= 1'b1;
                                        state <= 2'b00;
                                    end
                                else    
                                    begin   
                                        outp <= 1'b0;
                                        state <= 2'b10;
                                    end
                            end
                            2'b10 :
                                begin
                                    if(inp)
                                        begin
                                            outp <= 1'b0;
                                            state <= 2'b01;
                                        end
                                    else
                                        begin
                                            outp <= 1'b1;
                                            state <= 2'b00;
                                        end
                                end
                            default :
                                begin
                                    outp <= 1'b0;
                                    state <= 2'b00;
                                end
                    endcase
                end
        end
endmodule

module test_mealy;

    reg inp, clk, rst;
    wire outp;
    wire [1:0] state;

    mealy DUT (clk, rst, inp, outp);

    initial
        begin
            clk = 1'b0;
            forever
                begin
                    #5 clk = 1'b1;
                    #5 clk = 1'b0;
                end
        end



endmodule