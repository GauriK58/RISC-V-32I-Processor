`timescale 1ns/1ps
module IF_stage(
    input clk,
    input reset,
    input stall,                    // from Hazard Detection Unit
    input branch_taken,             // from EX stage
    input [63:0] branch_target,     // from EX stage
    output [63:0] pc,               // current PC
    output [31:0] raw_instruction   // instruction from IMEM
);

    wire [63:0] pc_current;
    wire [63:0] pc_plus4;
    wire [63:0] pc_next;
    wire [63:0] pc_input;
    wire [31:0] instr;

    pc PC(
        .clk(clk),
        .reset(reset),
        .pc_in(pc_input),
        .pc_out(pc_current)
    );

    instruction_mem IMEM(
        .address(pc_current),
        .instruction(instr)
    );

    // PC + 4 adder
    cla64 ADDER(
        .A(pc_current),
        .B(64'd4),
        .Cin(1'b0),
        .Sum(pc_plus4),
        .msbCin(),
        .Cout()
    );

    // Branch decision
    assign pc_next = branch_taken ? branch_target : pc_plus4;

    // Stall: hold PC when stall=1
    assign pc_input = stall ? pc_current : pc_next;

    assign raw_instruction = instr;
    assign pc = pc_current;

endmodule