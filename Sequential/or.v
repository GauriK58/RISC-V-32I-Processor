module or_op(
    input [63:0] A,
    input [63:0] B,
    output [63:0] Y
);

    genvar i;
    generate 
        for(i = 0; i < 64; i=i+1) 
        begin
            or or1(Y[i], A[i], B[i]);
        end
    endgenerate
endmodule 