module datamem(memwrite, memread, raddr, waddr, writedata, clk, outdata);

    input clk, memwrite, memread;
    input [31:0] writedata, raddr, waddr;
    output reg [31:0] outdata;

    reg [31:0] memory [0:31];
    integer i;

    initial
        begin
            for(i = 0; i < 32; i = i + 1)
                begin
                    memory[i] = 32'b0;
                end

                //overwrite the memory locations that you want to write to here
        end

    always @ (posedge clk)
        begin
            if(memwrite)
                begin
                    memory[waddr[6:2]] = writedata;
                end

            else if(memread)
                begin
                    outdata = memory[raddr[6:2]];
                end
        end

endmodule