module mux2_64 #(parameter WIDTH = 64)(
    input  [WIDTH-1:0] I0,
    input  [WIDTH-1:0] I1,
    input  S,
    output [WIDTH-1:0] Y
);

    assign Y = S ? I1 : I0;

endmodule