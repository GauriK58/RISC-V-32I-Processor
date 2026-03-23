`timescale 1ns/1ps
module ex_mem_reg(
    input clk,
    input reset,

    //controls
    input MemRead_in,
    input MemWrite_in,
    input MemtoReg_in,
    input RegWrite_in,
    input Branch_in,

    // data signals
    input [63:0] alu_result_in,
    input [63:0] write_data_in,
    input [63:0] branch_target_in,
    input zero_flag_in,
    input [4:0] rd_in,

    // outputs to MEM stage
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemtoReg_out,
    output reg RegWrite_out,
    output reg Branch_out,
    output reg [63:0] alu_result_out,
    output reg [63:0] write_data_out,
    output reg [63:0] branch_target_out,
    output reg zero_flag_out,
    output reg [4:0] rd_out
);

always @(posedge clk or posedge reset) begin
    if (reset) 
    begin
        MemRead_out <= 0; 
        MemWrite_out <= 0; 
        MemtoReg_out <= 0; 
        RegWrite_out <= 0; 
        Branch_out <= 0;
        alu_result_out <= 64'd0; 
        write_data_out <= 64'd0; 
        branch_target_out <= 64'd0; 
        zero_flag_out <= 0; 
        rd_out <= 5'd0;
    end 
    else 
    begin
        MemRead_out <= MemRead_in; 
        MemWrite_out <= MemWrite_in; 
        MemtoReg_out <= MemtoReg_in; 
        RegWrite_out <= RegWrite_in; 
        Branch_out <= Branch_in;
        alu_result_out <= alu_result_in; 
        write_data_out <= write_data_in; 
        branch_target_out <= branch_target_in; 
        zero_flag_out <= zero_flag_in; 
        rd_out <= rd_in;
    end
end
endmodule