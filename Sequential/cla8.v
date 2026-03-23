module cla8(
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);

    wire [7:0] P;
    wire [7:0] G;

    //propagate
    xor (P[0], A[0], B[0]);
    xor (P[1], A[1], B[1]);
    xor (P[2], A[2], B[2]);
    xor (P[3], A[3], B[3]);
    xor (P[4], A[4], B[4]);
    xor (P[5], A[5], B[5]);
    xor (P[6], A[6], B[6]);
    xor (P[7], A[7], B[7]);

    //generate
    and (G[0], A[0], B[0]);
    and (G[1], A[1], B[1]);
    and (G[2], A[2], B[2]);
    and (G[3], A[3], B[3]);
    and (G[4], A[4], B[4]);
    and (G[5], A[5], B[5]);
    and (G[6], A[6], B[6]);
    and (G[7], A[7], B[7]);

    wire C1, C2, C3, C4, C5, C6, C7;

    //temp variables :(
    wire t10;
    wire t20, t21;
    wire t30, t31, t32;
    wire t40, t41, t42, t43;
    wire t50, t51, t52, t53, t54;
    wire t60, t61, t62, t63, t64, t65;
    wire t70, t71, t72, t73, t74, t75, t76;
    wire t80, t81, t82, t83, t84, t85, t86, t87;

    // C1 = G0 + P0*Cin
    and (t10, P[0], Cin);
    or  (C1,  G[0], t10);

    // C2 = G1 + P1*G0 + P1*P0*Cin
    and (t20, P[1], G[0]);
    and (t21, P[1], P[0], Cin);
    or  (C2,  G[1], t20, t21);

    // C3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    and (t30, P[2], G[1]);
    and (t31, P[2], P[1], G[0]);
    and (t32, P[2], P[1], P[0], Cin);
    or  (C3,  G[2], t30, t31, t32);

    // C4 = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*Cin
    and (t40, P[3], G[2]);
    and (t41, P[3], P[2], G[1]);
    and (t42, P[3], P[2], P[1], G[0]);
    and (t43, P[3], P[2], P[1], P[0], Cin);
    or  (C4,  G[3], t40, t41, t42, t43);

    // C5 = G4 + P4*G3 + P4*P3*G2 + P4*P3*P2*G1 + P4*P3*P2*P1*G0 + P4*P3*P2*P1*P0*Cin
    and (t50, P[4], G[3]);
    and (t51, P[4], P[3], G[2]);
    and (t52, P[4], P[3], P[2], G[1]);
    and (t53, P[4], P[3], P[2], P[1], G[0]);
    and (t54, P[4], P[3], P[2], P[1], P[0], Cin);
    or  (C5,  G[4], t50, t51, t52, t53, t54);

    // C6 = G5 + P5*G4 + P5*P4*G3 + P5*P4*P3*G2 + P5*P4*P3*P2*G1 + P5*P4*P3*P2*P1*G0 + P5*P4*P3*P2*P1*P0*Cin
    and (t60, P[5], G[4]);
    and (t61, P[5], P[4], G[3]);
    and (t62, P[5], P[4], P[3], G[2]);
    and (t63, P[5], P[4], P[3], P[2], G[1]);
    and (t64, P[5], P[4], P[3], P[2], P[1], G[0]);
    and (t65, P[5], P[4], P[3], P[2], P[1], P[0], Cin);
    or  (C6,  G[5], t60, t61, t62, t63, t64, t65);

    // C7 = G6 + P6*G5 + P6*P5*G4 + P6*P5*P4*G3 + P6*P5*P4*P3*G2 + P6*P5*P4*P3*P2*G1 + P6*P5*P4*P3*P2*P1*G0 + P6*P5*P4*P3*P2*P1*P0*Cin
    and (t70, P[6], G[5]);
    and (t71, P[6], P[5], G[4]);
    and (t72, P[6], P[5], P[4], G[3]);
    and (t73, P[6], P[5], P[4], P[3], G[2]);
    and (t74, P[6], P[5], P[4], P[3], P[2], G[1]);
    and (t75, P[6], P[5], P[4], P[3], P[2], P[1], G[0]);
    and (t76, P[6], P[5], P[4], P[3], P[2], P[1], P[0], Cin);
    or  (C7,  G[6], t70, t71, t72, t73, t74, t75, t76);

    // Cout = G7 + P7*G6 + P7*P6*G5 + P7*P6*P5*G4 + P7*P6*P5*P4*G3 + P7*P6*P5*P4*P3*G2
    //        + P7*P6*P5*P4*P3*P2*G1 + P7*P6*P5*P4*P3*P2*P1*G0 + P7*P6*P5*P4*P3*P2*P1*P0*Cin
    and (t80, P[7], G[6]);
    and (t81, P[7], P[6], G[5]);
    and (t82, P[7], P[6], P[5], G[4]);
    and (t83, P[7], P[6], P[5], P[4], G[3]);
    and (t84, P[7], P[6], P[5], P[4], P[3], G[2]);
    and (t85, P[7], P[6], P[5], P[4], P[3], P[2], G[1]);
    and (t86, P[7], P[6], P[5], P[4], P[3], P[2], P[1], G[0]);
    and (t87, P[7], P[6], P[5], P[4], P[3], P[2], P[1], P[0], Cin);
    or  (Cout, G[7], t80, t81, t82, t83, t84, t85, t86, t87);

    // Sums: Sum[i] = P[i] xor Ci (C0=Cin)
    xor (Sum[0], P[0], Cin);
    xor (Sum[1], P[1], C1);
    xor (Sum[2], P[2], C2);
    xor (Sum[3], P[3], C3);
    xor (Sum[4], P[4], C4);
    xor (Sum[5], P[5], C5);
    xor (Sum[6], P[6], C6);
    xor (Sum[7], P[7], C7);

endmodule

