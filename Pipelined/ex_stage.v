`timescale 1ns/1ps
module ex_stage(
    input [63:0] pc,
    input [63:0] alu_ip1,
    input [63:0] alu_ip2,
    input [63:0] imm,
    input [1:0] ALUOp,
    input Branch,
    input [2:0] funct3,
    input funct7_bit,

    output [63:0] alu_result,
    output zero_flag,
    output [63:0] branch_target,
    output branch_taken
);

    wire [3:0] alu_control_signal;
    wire cout, carry_flag, overflow_flag;

    alu_control alu_ctrl(
        .ALUOp(ALUOp),
        .funct7_bit(funct7_bit),
        .funct3(funct3),
        .ALUControl(alu_control_signal)
    );

    alu alu_unit(
        .a(alu_ip1),
        .b(alu_ip2),
        .control(alu_control_signal),
        .result(alu_result),
        .cout(cout),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag),
        .zero_flag(zero_flag)
    );

    assign branch_target = pc + imm;
    assign branch_taken = Branch & zero_flag;

endmodule

