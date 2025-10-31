module datamem(addr, datain, dataout, memread, memwrite, clk);

    input [31:0] addr, datain;
    input memread, memwrite;
    output reg [31:0] dataout;

    reg [31:0] mem [0:31];
    integer i;

    initial
        begin
            for(i = 0; i<32; i=i+1)
                begin
                    mem[i] = 32'b0;
                end
        end

    always @ (posedge clk)
        begin
            if(memwrite)
                begin
                    mem[addr[6:2]] <= datain;
                end
        end

    assign dataout = mem[addr[6:2]];

endmodule