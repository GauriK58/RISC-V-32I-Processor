`timescale 1ns/1ps

module cpu_wrapper(
    input clk,
    input reset,
    output [63:0] write_data
);

    wire stall, flush, branch_taken;
    wire [1:0] forwardA, forwardB;

    wire [63:0] if_id_pc;
    wire [31:0] if_id_instruction;

    wire [63:0] id_read_data1, id_read_data2, id_immediate;
    wire [4:0] id_rs1, id_rs2, id_rd;
    wire id_Branch, id_MemRead, id_MemWrite, id_MemtoReg, id_RegWrite, id_ALUSrc;
    wire [1:0] id_ALUOp;

    wire [2:0] id_funct3;
    wire id_funct7;

    assign id_funct3 = if_id_instruction[14:12];
    assign id_funct7 = if_id_instruction[30];

    wire [63:0] id_ex_rd1, id_ex_rd2, id_ex_imm, id_ex_pc;
    wire [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd;
    wire [2:0] id_ex_funct3;
    wire id_ex_funct7;

    wire id_ex_Branch, id_ex_MemRead, id_ex_MemWrite, id_ex_MemtoReg, id_ex_RegWrite, id_ex_ALUSrc;
    wire [1:0] id_ex_ALUOp;

    wire [63:0] ex_alu_result, ex_branch_target;
    wire ex_zero_flag;
    wire ex_branch_taken;

    wire [63:0] ex_mem_alu_result, ex_mem_write_data, ex_mem_branch_target;
    wire ex_mem_zero_flag;
    wire [4:0] ex_mem_rd;
    wire ex_mem_MemRead, ex_mem_MemWrite, ex_mem_MemtoReg, ex_mem_RegWrite, ex_mem_Branch;

    wire [63:0] mem_read_data;

    wire [63:0] mem_wb_read_data, mem_wb_alu_result;
    wire [4:0] mem_wb_rd;
    wire mem_wb_MemtoReg, mem_wb_RegWrite;

    wire [4:0] id_rs1_dec = if_id_instruction[19:15];
    wire [4:0] id_rs2_dec = if_id_instruction[24:20];

    wire [63:0] forwarded_rd1 = (forwardA == 2'b10) ? ex_mem_alu_result : (forwardA == 2'b01) ? write_data : id_ex_rd1;

    wire [63:0] forwarded_rd2 = (forwardB == 2'b10) ? ex_mem_alu_result : (forwardB == 2'b01) ? write_data : id_ex_rd2;

    wire [63:0] ex_alu_ip2 = id_ex_ALUSrc ? id_ex_imm : forwarded_rd2; //chking if the 2nd alu input should be immediate value given in instr or from register
    
    forwarding_unit FU(
        .rs1_idex(id_ex_rs1),
        .rs2_idex(id_ex_rs2),
        .rd_exmem(ex_mem_rd),
        .rd_memwb(mem_wb_rd),
        .regwrite_exmem(ex_mem_RegWrite),
        .regwrite_memwb(mem_wb_RegWrite),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    hazard_detection_unit HDU(
        .rs1_id(id_rs1_dec),
        .rs2_id(id_rs2_dec),
        .rd_idex(id_ex_rd),
        .memread_idex(id_ex_MemRead),
        .stall(stall)
    );

    assign flush = ex_branch_taken; 
    assign branch_taken = ex_branch_taken;

    wire [63:0] if_pc_current;
    wire [31:0] raw_instr;

    IF_stage IF(
        .clk(clk),
        .reset(reset),//
        .stall(stall),
        .branch_taken(branch_taken),
        .branch_target(ex_branch_target),
        .pc(if_pc_current),
        .raw_instruction(raw_instr)
    );

    IF_ID IFID(
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .instr_in(raw_instr),
        .pc_in(if_pc_current),
        .instr_out(if_id_instruction),
        .pc_out(if_id_pc)
    );

    ID_stage ID(
        .clk(clk),
        .reset(reset),
        .instruction(if_id_instruction),
        .pc(if_id_pc),
        .wb_rd(mem_wb_rd),
        .wb_data(write_data),
        .wb_regwrite(mem_wb_RegWrite),
        .read_data1(id_read_data1),
        .read_data2(id_read_data2),
        .immediate(id_immediate),
        .rs1(id_rs1),
        .rs2(id_rs2),
        .rd(id_rd),
        .Branch(id_Branch),
        .MemRead(id_MemRead),
        .MemtoReg(id_MemtoReg),
        .ALUOp(id_ALUOp),
        .MemWrite(id_MemWrite),
        .ALUSrc(id_ALUSrc),
        .RegWrite(id_RegWrite)
    );

    ID_EX IDEX(
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),

        .rd1_in(id_read_data1),
        .rd2_in(id_read_data2),
        .imm_in(id_immediate),
        .pc_in(if_id_pc),

        .rs1_in(id_rs1),
        .rs2_in(id_rs2),
        .rd_in(id_rd),

        .funct3_in(id_funct3),
        .funct7_in(id_funct7),

        .Branch_in(id_Branch),
        .MemRead_in(id_MemRead),
        .MemtoReg_in(id_MemtoReg),
        .ALUOp_in(id_ALUOp),
        .MemWrite_in(id_MemWrite),
        .ALUSrc_in(id_ALUSrc),
        .RegWrite_in(id_RegWrite),

        .rd1_out(id_ex_rd1),
        .rd2_out(id_ex_rd2),
        .imm_out(id_ex_imm),
        .pc_out(id_ex_pc),

        .rs1_out(id_ex_rs1),
        .rs2_out(id_ex_rs2),
        .rd_out(id_ex_rd),

        .funct3_out(id_ex_funct3),
        .funct7_out(id_ex_funct7),

        .Branch_out(id_ex_Branch),
        .MemRead_out(id_ex_MemRead),
        .MemtoReg_out(id_ex_MemtoReg),
        .ALUOp_out(id_ex_ALUOp),
        .MemWrite_out(id_ex_MemWrite),
        .ALUSrc_out(id_ex_ALUSrc),
        .RegWrite_out(id_ex_RegWrite)
    );

    ex_stage EX(
        .pc(id_ex_pc),
        .alu_ip1(forwarded_rd1),
        .alu_ip2(ex_alu_ip2),
        .imm(id_ex_imm),
        .ALUOp(id_ex_ALUOp),
        .Branch(id_ex_Branch),
        .funct3(id_ex_funct3),
        .funct7_bit(id_ex_funct7),
        .alu_result(ex_alu_result),
        .zero_flag(ex_zero_flag),
        .branch_target(ex_branch_target),
        .branch_taken(ex_branch_taken)
    );

    ex_mem_reg EXMEM(
        .clk(clk),
        .reset(reset),
        .MemRead_in(id_ex_MemRead),
        .MemWrite_in(id_ex_MemWrite),
        .MemtoReg_in(id_ex_MemtoReg),
        .RegWrite_in(id_ex_RegWrite),
        .Branch_in(id_ex_Branch),
        .alu_result_in(ex_alu_result),

        .write_data_in(forwarded_rd2),

        .branch_target_in(ex_branch_target),
        .zero_flag_in(ex_zero_flag),
        .rd_in(id_ex_rd),

        .MemRead_out(ex_mem_MemRead),
        .MemWrite_out(ex_mem_MemWrite),
        .MemtoReg_out(ex_mem_MemtoReg),
        .RegWrite_out(ex_mem_RegWrite),
        .Branch_out(ex_mem_Branch),
        .alu_result_out(ex_mem_alu_result),
        .write_data_out(ex_mem_write_data),
        .branch_target_out(ex_mem_branch_target),
        .zero_flag_out(ex_mem_zero_flag),
        .rd_out(ex_mem_rd)
    );

    mem_stage MEM(
        .clk(clk),
        .reset(reset),
        .MemRead(ex_mem_MemRead),
        .MemWrite(ex_mem_MemWrite),
        .alu_result(ex_mem_alu_result),
        .write_data(ex_mem_write_data),
        .read_data(mem_read_data)
    );

    mem_wb_reg MEMWB(
        .clk(clk),
        .reset(reset),
        .MemtoReg_in(ex_mem_MemtoReg),
        .RegWrite_in(ex_mem_RegWrite),
        .read_data_in(mem_read_data),
        .alu_result_in(ex_mem_alu_result),
        .rd_in(ex_mem_rd),
        .MemtoReg_out(mem_wb_MemtoReg),
        .RegWrite_out(mem_wb_RegWrite),
        .read_data_out(mem_wb_read_data),
        .alu_result_out(mem_wb_alu_result),
        .rd_out(mem_wb_rd)
    );

    wb_stage WB(
        .alu_result(mem_wb_alu_result),
        .read_data(mem_wb_read_data),
        .MemtoReg(mem_wb_MemtoReg),
        .write_data(write_data)
    );

endmodule