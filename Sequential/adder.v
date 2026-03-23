// `include "cla64.v"
module adder(
    input  [63:0] A,
    input  [63:0] B,
    output [63:0] Sum,
    output carry_flag,
    output overflow_flag,
    output Cout
);

    wire msbCin;

    cla64 add(
        .A(A),
        .B(B),
        .Cin(1'b0),
        .Sum(Sum),
        .Cout(cout),
        .msbCin(msbCin)
    );
    
    buf (carry_flag, cout);
    xor (overflow_flag, msbCin, cout);

endmodule