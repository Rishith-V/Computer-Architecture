`include "instmem.v"
`include "maincont.v"
`include "regfile32b.v"
`include "alu32b.v"



module scdatapath (pcres, clk);

    input pcres, clk;
    wire [31:0] pcin, pco;

    pc pcm (pcin, pco, clk, pcres);
    wire [31:0] pcn;
    assign pcn = pco + 4;   //1 for pcin

    wire [31:0] inst;
    instmem inmem (inst, pco);

    wire [31:0] jaddr;
    assign jaddr = {pcn[31:28], inst[25:0], 2'b00}; //2 for pcin

    assign baddr = {{14{inst[15]}}, inst[15:0], 2'b00}; //3 for pcin
    wire bcont;

    wire branch, zero, jump, regdst, alusrc, memtoreg, regwrite, memread, memwrite, aluop0, aluop1;    //to get, got!
    assign bcont = branch & zero;   

    assign pcin = jump ? jaddr : (bcont ? (pcn + baddr) : pcn);

    maincont contro (inst[31:26], regdst, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop0, aluop1);

    wire [4:0] writereg;
    assign writereg = regdst ? inst[15:11] : inst[20:16];
    wire [31:0] writedata; //to get
    wire [31:0] readdata1, readdata2;
    regfile regf (clk, pcres, inst[25:21], inst[20:16], writedata, writereg, regwrite, readdata1, readdata2);

    wire [31:0] aluin2;
    assign aluin2 = alusrc ? baddr : readdata2;
    wire [31:0] alures;

    alu_final aluf (readdata1, aluin2, alures, inst[1], {aluop1, aluop2}, )



endmodule