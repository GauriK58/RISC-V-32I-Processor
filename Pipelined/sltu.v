// `include "subtract.v"
module sltu(
    input  [63:0] A,
    input  [63:0] B,
    output [63:0] Y
);

    wire [63:0] D;
    wire Cout;

    subtract check(
        .A(A),
        .B(B),
        .Diff(D),
        .Cout(Cout)
    );

    not (Y[0], Cout); //if Cout = 0, A < B, so slt should output 1, vice versa for Cout = 0

    genvar i;
    generate
        for (i = 1; i < 64; i = i + 1) 
        begin: runn
            buf (Y[i], 1'b0);
        end
    endgenerate
endmodule
