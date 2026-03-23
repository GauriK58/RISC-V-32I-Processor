`timescale 1ns/1ps
module forwarding_unit (
    input [4:0] rs1_idex, rs2_idex,  // rs1/rs2 from id stage
    input [4:0] rd_exmem, rd_memwb,  // rd from either EX/MEM or MEM/WB
    input regwrite_exmem, regwrite_memwb,
    output reg [1:0] forwardA, forwardB
);
    always @(*) begin
        forwardA = 2'b00; forwardB = 2'b00;
        // ForwardA FOR rs1

        // data needed in current instr was changed in prev one, so we forward value from EX/MEM register to EX stage 
        if (regwrite_exmem && (rd_exmem != 0) && (rd_exmem == rs1_idex)) forwardA = 2'b10;  
        // data needed in current instr has been changed and is not written back yet, so we forward value from MEM/WB register to EX stage
        else if (regwrite_memwb && (rd_memwb != 0) && (rd_memwb == rs1_idex)) forwardA = 2'b01;  


        //Slly, ForwardB FOR rs2
        if (regwrite_exmem && (rd_exmem != 0) && (rd_exmem == rs2_idex)) forwardB = 2'b10;
        else if (regwrite_memwb && (rd_memwb != 0) && (rd_memwb == rs2_idex)) forwardB = 2'b01;
    end
endmodule