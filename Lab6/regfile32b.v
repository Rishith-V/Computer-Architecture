// `include "mux32to1.v"
`include "decoder5to32.v"
`include "reg32b.v"

module regfile(clk, reset, readreg1, readreg2, writedata, writereg, regwrite, readdata1, readdata2);

    input clk, reset, regwrite;
    input [4:0] readreg1, readreg2, writereg;
    input [31:0] writedata;
    output [31:0] readdata1, readdata2;

    wire [31:0] decout;

    wire [31:0] reg_d [0:31];   //inputs to registers
    wire [31:0] reg_q [0:31];   //outputs of registers

    dec5to32 dec (writereg, decout);

    // mux32to1 read1 (reg_q, readreg1, readdata1);
    // always@(*)
    //     begin
        assign readdata1 = reg_q[readreg1];
        // end
    // mux32to1 read2 (reg_q, readreg2, readdata2);
    // always@(*)
    //     begin
        assign readdata2 = reg_q[readreg2];
        // end

    genvar i;

    generate    
        for(i = 0; i < 32; i = i+1) begin: write_reg
            assign reg_d[i] = (regwrite && decout[i]) ? writedata : reg_q[i];
            reg_32b regs (reg_q[i], reg_d[i], clk, reset);
        end
    endgenerate


endmodule

module tb_regfile();

    wire [31:0] readdata1, readdata2;

    reg clk, reset, regwrite;
    reg [4:0] readreg1, readreg2, writereg;
    reg [31:0] writedata;

    regfile DUT (clk, reset, readreg1, readreg2, writedata, writereg, regwrite, readdata1, readdata2);

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
            reset = 1'b0;
            regwrite = 1'b0;
            readreg1 = 5'b0;
            readreg2 = 5'b01101;
            writereg = 5'b0;
            writedata = 32'b0;

            #7 reset = 1'b1;
            writedata = 32'hffffffff;
            writereg = 5'b01101;
            regwrite = 1'b1;

            #10 writedata = 32'hffffffff;
            writereg = 5'b00000;

            #10 regwrite = 1'b0;
            writedata = 32'b0;

            #20 $finish;
        end

    initial
            begin
                $monitor($time, " clk=%b rst=%b | Write(en=%b, reg=%d, data=%h) | Read1(reg=%d, data=%h) | Read2(reg=%d, data=%h)",
                        clk, reset, regwrite, writereg, writedata,
                        readreg1, readdata1,
                        readreg2, readdata2);
            end

endmodule