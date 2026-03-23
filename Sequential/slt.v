// `include "sltu.v"  

module slt(
    input  [63:0] A,
    input  [63:0] B,
    output [63:0] Y
);

    wire [63:0] sltu_out;          
    wire sign_diff, sign_same, slt_bit, same_cond, diff_cond;              

    sltu check(
        .A(A),
        .B(B),
        .Y(sltu_out)
    );

    xor (sign_diff, A[63], B[63]); //sign_diff = A[63] XOR B[63]
    not (sign_same, sign_diff);

    and (diff_cond, sign_diff, A[63]);     //gives 1 if signs differ AND A is -ve
    and (same_cond, sign_same, sltu_out[0]); //gives 1 if signs are same AND A<B
    or  (slt_bit, diff_cond, same_cond); //gives 1 if EITHER the signed bits are diff and A is -ve OR if they are the same and A<B 

    genvar i;
    generate
        for (i = 1; i < 64; i = i + 1) 
        begin: runn
            buf (Y[i], 1'b0);
        end
    endgenerate

    buf (Y[0], slt_bit);

endmodule
