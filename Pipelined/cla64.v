// `include "cla8.v"
module cla64(
    input  [63:0] A,
    input  [63:0] B,
    input  Cin,
    output [63:0] Sum,
    output msbCin,
    output Cout
);

    wire c8, c16, c24, c32, c40, c48, c56;

    cla8 block0 (.A(A[7:0]),    .B(B[7:0]),    .Cin(Cin), .Sum(Sum[7:0]),    .Cout(c8));
    cla8 block1 (.A(A[15:8]),   .B(B[15:8]),   .Cin(c8),  .Sum(Sum[15:8]),   .Cout(c16));
    cla8 block2 (.A(A[23:16]),  .B(B[23:16]),  .Cin(c16), .Sum(Sum[23:16]),  .Cout(c24));
    cla8 block3 (.A(A[31:24]),  .B(B[31:24]),  .Cin(c24), .Sum(Sum[31:24]),  .Cout(c32));
    cla8 block4 (.A(A[39:32]),  .B(B[39:32]),  .Cin(c32), .Sum(Sum[39:32]),  .Cout(c40));
    cla8 block5 (.A(A[47:40]),  .B(B[47:40]),  .Cin(c40), .Sum(Sum[47:40]),  .Cout(c48));
    cla8 block6 (.A(A[55:48]),  .B(B[55:48]),  .Cin(c48), .Sum(Sum[55:48]),  .Cout(c56));
    cla8 block7 (.A(A[63:56]),  .B(B[63:56]),  .Cin(c56), .Sum(Sum[63:56]),  .Cout(Cout));

    buf (msbCin, c56);

endmodule