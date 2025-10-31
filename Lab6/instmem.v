module instmem (inst, pc);

    input [31:0] pc;
    output reg [31:0] inst;

    reg [31:0] mem [0:31];
    integer i;

    initial
        begin
            for(i = 0; i < 32; i = i + 1)
                begin
                    mem[i] = 32'b0;
                end

            mem[0] = 32'b000000_01001_01010_01000_00000_100000; //add t0, t1, t2
            mem[1] = 32'b000000_10000_10001_01011_00000_100010; //sub t3, s0, s1
            mem[2] = 32'b000000_01000_01001_01000_00000_100100; //and t0, t0, t1
        end

        always @ (*)
            begin
                inst = mem[pc[6:2]];
            end

endmodule