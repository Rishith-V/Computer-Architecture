module alucont (aluop0, aluop1, func0, func1, func2, func3, op0, op1, op2);

    input aluop0, aluop1, func0, func1, func2, func3;
    output op0, op1, op2;

    wire f03o, f1o1a;

    assign f1o1a = aluop1 & func1;
    assign f03o = func0 | func3;

    assign op0 = f03o & aluop1;
    assign op1 = ~func2 | ~aluop1;
    assign op2 = aluop0 | f1o1a;

endmodule