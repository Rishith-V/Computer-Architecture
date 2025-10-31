module and5inp(in1, in2, in3, in4, in5, in6, outp);

    input in1, in2, in3, in4, in5, in6;
    output outp;

    assign outp = in1 & in2 & in3 & in4 & in5 & in6;

endmodule   


module maincont (op, regdst, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop0, aluop1);

    input [5:0] op;
    output regdst, alusrc, memtoreg, memwrite, regwrite, memread, branch, aluop0, aluop1;

    wire r, lw, sw, beq;

    and5inp rform (~op[0], ~op[1], ~op[2], ~op[3], ~op[4], ~op[5], r);
    and5inp lwins (op[0], op[1], ~op[2], ~op[3], ~op[4], op[5], lw);
    and5inp swins (op[0], op[1], ~op[2], op[3], ~op[4], op[5], sw);
    and5inp beqins (~op[0], ~op[1], op[2], ~op[3], ~op[4], ~op[5], beq);

    assign regdst = r;
    assign alusrc = lw | sw;
    assign memtoreg = lw;
    assign regwrite = r | lw;
    assign memread = lw;
    assign memwrite = sw;
    assign branch = beq;
    assign aluop0 = r;
    assign aluop1 = beq;


endmodule