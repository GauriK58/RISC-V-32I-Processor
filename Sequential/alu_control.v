`timescale 1ns / 1ps

module alu_control (
    input  [1:0] ALUOp,
    input  funct7_bit, // Instruction[30] is funct7 2nd msb if it's R-Type
    input  [2:0] funct3, // Instruction[14:12]
    output reg  [3:0] ALUControl
);

localparam ADD  = 4'b0000,
           SLL  = 4'b0001,
           SLT  = 4'b0010,
           SLTU = 4'b0011,
           XOR  = 4'b0100,
           SRL  = 4'b0101,
           OR   = 4'b0110,
           AND  = 4'b0111,
           SUB  = 4'b1000,
           SRA  = 4'b1101;

    always @(*) begin
        case (ALUOp)

            // 00 means Load/Store/Addi which means we need to do the ADD operation
            2'b00: begin
                ALUControl = ADD; // ADD
            end

            // 01 means subtract for beq
            2'b01: begin
                ALUControl = SUB; // SUB
            end

            // 10 means it's an R-type instruction, so it could be ADD, SUB, OR, AND, so we use funct fields
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (funct7_bit == 1'b1)
                            ALUControl = SUB;  
                        else
                            ALUControl = ADD;  
                    end

                    3'b111: ALUControl = AND;  
                    3'b110: ALUControl = OR;  

                    default: ALUControl = 4'b1111; //bcz no other operation uses this so it's basically the o/p given for an invalid funct3 is given as i/p
                endcase
            end

            default: ALUControl = 4'b1111; //o/p given for invalid ALUop

        endcase
    end

endmodule