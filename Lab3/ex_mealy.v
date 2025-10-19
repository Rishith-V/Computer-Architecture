//mealy machine example(pg 5)
module mealy(clk, rst, inp, outp);

    output reg outp;
    input clk, rst, inp;
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
    reg [15:0] sequence;
    integer i;

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

    initial
        begin
            sequence = 16'b0101011101110010;
            rst = 1;
            #2 rst = 0;
            #1;
            for(i = 0; i < 16; i = i+1)
                begin
                    inp = sequence[i];
                    #10;
                end
            testing;
            #20 $finish;
        end

    task testing;
        for(i = 0; i <= 15; i = i+1)
            begin
                inp = $random % 2;
            end
    endtask

    initial
        begin
            $monitor($time, " : clock = %b, reset = %b, input = %b, state = %b, output = %b", clk, rst, inp, DUT.state, outp);
        end

endmodule