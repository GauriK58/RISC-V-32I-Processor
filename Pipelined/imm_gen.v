`timescale 1ns/1ps

module imm_gen (
    input  [31:0] instruction,
    output reg [63:0] imm_out
);

    wire [6:0] opcode = instruction[6:0];

    always @(*) begin

        case (opcode)

            // I-Type (addi, ld)
            7'b0010011,   // addi
            7'b0000011:   // ld
                imm_out = {{52{instruction[31]}}, instruction[31:20]};

            // S-Type (sd)
            7'b0100011:
                imm_out = {{52{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // B-Type (beq)
            7'b1100011:
                imm_out = {{51{instruction[31]}},
                           instruction[31],
                           instruction[7],
                           instruction[30:25],
                           instruction[11:8],
                           1'b0}; //shifting it by 1

            default:
                imm_out = 64'd0;
        endcase
    end

endmodule