`timescale 1ns / 1ps

module processor (
    input clk,
    input reset
);

    wire [63:0] pc_out, pc_in;
    wire [31:0] instruction;

    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;
    wire [3:0] ALUControl;

    wire [63:0] read_data1, read_data2;
    wire [63:0] immediate;
    wire [63:0] alu_input2, alu_result;
    wire zero;

    wire [63:0] data_read, data_to_write;

    wire [63:0] pc_plus_4;
    wire [63:0] branch_target;

    pc PC (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    adder ADD_PC4 (
        .A(pc_out),
        .B(64'd4),
        .Sum(pc_plus_4)
    );

    instruction_mem IMEM (
        .address(pc_out),
        .instruction(instruction)
    );

    control_unit CU (
        .opcode(instruction[6:0]), //bcz last 7-bits are opcode
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    register_file RF (
        .clk(clk),
        .reset(reset),
        .read_reg1(instruction[19:15]),
        .read_reg2(instruction[24:20]),
        .write_reg(instruction[11:7]),
        .write_data(data_to_write),
        .reg_write_en(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    imm_gen IMM (
        .instruction(instruction),
        .imm_out(immediate)
    );

    alu_control ALUCTRL (
        .ALUOp(ALUOp),
        .funct7_bit(instruction[30]),
        .funct3(instruction[14:12]),
        .ALUControl(ALUControl)
    );

    mux2_64 MUX_ALUSRC (
        .I0(read_data2),
        .I1(immediate),
        .S(ALUSrc),
        .Y(alu_input2)
    );

    alu ALU (
        .a(read_data1),
        .b(alu_input2),
        .control(ALUControl),
        .result(alu_result),
        .zero_flag(zero)
    );

    data_mem DM (
        .clk(clk),
        .reset(reset),
        .address(alu_result[9:0]),
        .write_data(read_data2),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .read_data(data_read)
    );

    mux2_64 MUX_MEMTOREG (
        .I0(alu_result),
        .I1(data_read),
        .S(MemtoReg),
        .Y(data_to_write)
    );

    adder ADD_BRANCH (
        .A(pc_out),
        .B(immediate),
        .Sum(branch_target)
    );

    assign take_branch = Branch & zero; //if the inputs are both equal for beq, ALU will set zeroflag = 1 (as SUB is the op being performed and the result will be 0) 
    //and thn u chk if branching was indeed the condition by anding and give this as the select line for the ALU that determines whether PC = PC + 4 or the branch address

    mux2_64 MUX_PC (
        .I0(pc_plus_4),
        .I1(branch_target),
        .S(take_branch),
        .Y(pc_in)
    );

endmodule