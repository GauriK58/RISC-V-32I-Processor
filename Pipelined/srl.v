// `include "barrel_shift.v"
module srl(
    input [63:0] A,
    input [63:0] B,
    output [63:0] Y
);

    barrel_shift shift_right(
        .A(A),
        .B(B[5:0]),
        .extend(1'b0),
        .Y(Y)
    );

endmodule