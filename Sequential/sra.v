// `include "barrel_shift.v"
module sra(
    input [63:0] A,
    input [63:0] B,
    output [63:0] Y
);

    barrel_shift shift_right_a(
        .A(A),
        .B(B[5:0]),
        .extend(A[63]),
        .Y(Y)
    );

endmodule
