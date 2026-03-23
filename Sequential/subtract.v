// `include "cla64.v"
module subtract(
    input  [63:0] A,
    input  [63:0] B,
    output [63:0] Diff,
    output carry_flag,
    output overflow_flag,
    output Cout
);

    wire [63:0] Bcomp;
    wire msbCin;
    genvar i;
    generate 
        for(i = 0; i < 64; i=i+1) 
        begin
            not (Bcomp[i], B[i]);
        end
    endgenerate

    cla64 sub(
        .A(A),
        .B(Bcomp),
        .Cin(1'b1),
        .Sum(Diff),
        .Cout(Cout),
        .msbCin(msbCin)
    );

    buf (carry_flag, Cout);
    xor (overflow_flag, msbCin, Cout);
    
endmodule