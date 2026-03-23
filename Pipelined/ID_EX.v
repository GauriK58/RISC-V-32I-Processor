`timescale 1ns/1ps
module ID_EX(
    input clk,
    input reset,
    input stall,

    input [63:0] rd1_in,
    input [63:0] rd2_in,
    input [63:0] imm_in,
    input [63:0] pc_in,

    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,

    input [2:0] funct3_in,
    input funct7_in,

    input Branch_in,
    input MemRead_in,
    input MemtoReg_in,
    input [1:0] ALUOp_in,
    input MemWrite_in,
    input ALUSrc_in,
    input RegWrite_in,
    input flush,

    output reg [63:0] rd1_out,
    output reg [63:0] rd2_out,
    output reg [63:0] imm_out,
    output reg [63:0] pc_out,

    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    output reg [2:0] funct3_out,
    output reg funct7_out,

    output reg Branch_out,
    output reg MemRead_out,
    output reg MemtoReg_out,
    output reg [1:0] ALUOp_out,
    output reg MemWrite_out,
    output reg ALUSrc_out,
    output reg RegWrite_out
);

always @(posedge clk or posedge reset) begin

    if (reset || flush) 
    begin
        rd1_out      <= 0;
        rd2_out      <= 0;
        imm_out      <= 0;
        pc_out       <= 0;

        rs1_out      <= 0;
        rs2_out      <= 0;
        rd_out       <= 0;

        funct3_out   <= 0;
        funct7_out   <= 0;

        Branch_out   <= 0;
        MemRead_out  <= 0;
        MemtoReg_out <= 0;
        ALUOp_out    <= 0;
        MemWrite_out <= 0;
        ALUSrc_out   <= 0;
        RegWrite_out <= 0;
    end
    else if (stall) 
    begin
        // Insert NOP bubble (zero only the control signals)
        // Data signals are left unchanged and bcz because IF/ID is frozen, the same instruction will re-enter in the next cycle
        Branch_out   <= 0;
        MemRead_out  <= 0;
        MemtoReg_out <= 0;
        ALUOp_out    <= 0;
        MemWrite_out <= 0;
        ALUSrc_out   <= 0;
        RegWrite_out <= 0;
    end
    else 
    begin
        rd1_out      <= rd1_in;
        rd2_out      <= rd2_in;
        imm_out      <= imm_in;
        pc_out       <= pc_in;

        rs1_out      <= rs1_in;
        rs2_out      <= rs2_in;
        rd_out       <= rd_in;

        funct3_out   <= funct3_in;
        funct7_out   <= funct7_in;

        Branch_out   <= Branch_in;
        MemRead_out  <= MemRead_in;
        MemtoReg_out <= MemtoReg_in;
        ALUOp_out    <= ALUOp_in;
        MemWrite_out <= MemWrite_in;
        ALUSrc_out   <= ALUSrc_in;
        RegWrite_out <= RegWrite_in;
    end

end

endmodule