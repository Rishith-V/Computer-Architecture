module par_gen(x, par);

    input [3:0] x;
    output par;

    assign par = x[0] ^ x[1] ^ x[2] ^ x[3]; 

endmodule