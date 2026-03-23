`timescale 1ns/1ps

module ID_stage(

    input clk,
    input reset,

    input [31:0] instruction,
    input [63:0] pc,

    // writeback signals
    input [4:0] wb_rd,
    input [63:0] wb_data,
    input wb_regwrite,


    output [63:0] read_data1,
    output [63:0] read_data2,
    output [63:0] immediate,

    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,

    output Branch,
    output MemRead,
    output MemtoReg,
    output [1:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite
);


assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd  = instruction[11:7];

wire [6:0] opcode;
assign opcode = instruction[6:0];


// register file
register_file RF(
    .clk(clk),
    .reset(reset),
    .read_reg1(rs1),
    .read_reg2(rs2),

    .write_reg(wb_rd),
    .write_data(wb_data),
    .reg_write_en(wb_regwrite),

    .read_data1(read_data1),
    .read_data2(read_data2)
);


// immediate generator
imm_gen IMM(
    .instruction(instruction),
    .imm_out(immediate)
);


// control unit
control_unit CU(
    .opcode(opcode),

    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);

endmodule