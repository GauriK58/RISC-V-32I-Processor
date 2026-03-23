// `include "barrel_shift.v"
module sll(
    input [63:0]A,
    input [63:0]B,
    output [63:0]Y
);

    wire [63:0] Arev;
    wire [63:0] Yrev;

    genvar i;
    generate 
        for(i = 0; i < 64; i=i+1) 
        begin
            buf (Arev[i], A[63-i]);
        end
    endgenerate

    barrel_shift shift_left(
        .A(Arev),
        .B(B[5:0]),
        .extend(1'b0),
        .Y(Yrev)
    );

    genvar j;
    generate 
        for(j = 0; j < 64; j=j+1) 
        begin
            buf (Y[j], Yrev[63-j]);
        end
    endgenerate

endmodule