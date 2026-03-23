`timescale 1ns / 1ps

module control_unit (
    input  wire [6:0] opcode,

    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);

    always @(*) begin

        case (opcode)

            // R-type: add, sub, and, or
            7'b0110011: begin
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end

            // I-type: addi
            7'b0010011: begin
                ALUSrc   = 1;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end

            // Load: ld
            7'b0000011: begin
                ALUSrc   = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end

            // Store: sd
            7'b0100011: begin
                ALUSrc   = 1;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                ALUOp    = 2'b00;
            end

            // Branch: beq
            7'b1100011: begin
                ALUSrc   = 0;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                ALUOp    = 2'b01;
            end

            default: 
            begin
                Branch   = 0;
                MemRead  = 0;
                MemtoReg = 0;
                ALUOp    = 2'b00;
                MemWrite = 0;
                ALUSrc   = 0;
                RegWrite = 0;
            end

        endcase
    end

endmodule