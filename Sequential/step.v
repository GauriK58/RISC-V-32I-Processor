// `include "mux2.v"
//this is for right shift 
module step #(parameter integer n = 1) (
    input  [63:0] A,
    input  B,        
    input  extend,    
    output [63:0] Y
);
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) 
        begin: runn
            if (i + n >= 64) 
            begin: fill2
                mux2 m3 (
                    .I0(A[i]),
                    .I1(extend),
                    .S(B),
                    .Y(Y[i])
                );
            end

            else 
            begin: shift
                mux2 m4 (
                    .I0(A[i]),
                    .I1(A[i+n]),
                    .S(B),
                    .Y(Y[i])
                );
            end
        end
    endgenerate
endmodule
