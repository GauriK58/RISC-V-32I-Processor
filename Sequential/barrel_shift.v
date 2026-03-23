// `include "step.v"
module barrel_shift(
input [63:0]A,
input [5:0]B,
input extend,
output [63:0]Y
);

wire [63:0] y1, y2, y3, y4, y5; //6 steps cuz only the last 6 bits are used for shifting

step #(1) s1(.A(A), .B(B[0]), .extend(extend), .Y(y1));
step #(2) s2(.A(y1), .B(B[1]), .extend(extend), .Y(y2));
step #(4) s3(.A(y2), .B(B[2]), .extend(extend), .Y(y3));
step #(8) s4(.A(y3), .B(B[3]), .extend(extend), .Y(y4));
step #(16) s5(.A(y4), .B(B[4]), .extend(extend), .Y(y5));
step #(32) s6(.A(y5), .B(B[5]), .extend(extend), .Y(Y));

endmodule