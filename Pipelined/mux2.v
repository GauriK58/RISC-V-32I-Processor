module mux2( 
    input I0, 
    input I1, 
    input S, 
    output Y 
); 

    wire Scomp, t1, t2; 
    not(Scomp, S); 
    and(t1, I0, Scomp); 
    and(t2, I1, S); 
    or(Y, t1, t2); 
    
endmodule