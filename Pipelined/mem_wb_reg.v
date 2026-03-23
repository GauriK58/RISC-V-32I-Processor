`timescale 1ns/1ps
module mem_wb_reg(
    input clk,
    input reset,

    // control signals
    input MemtoReg_in,
    input RegWrite_in,

    // data signals
    input [63:0] read_data_in,
    input [63:0] alu_result_in,
    input [4:0] rd_in,

    // outputs to WB stage
    output reg MemtoReg_out,
    output reg RegWrite_out,
    output reg [63:0] read_data_out,
    output reg [63:0] alu_result_out,
    output reg [4:0] rd_out
);
always @(posedge clk or posedge reset) begin
    if (reset) 
    begin
        MemtoReg_out <= 0; 
        RegWrite_out <= 0;
        read_data_out <= 64'd0; 
        alu_result_out <= 64'd0; 
        rd_out <= 5'd0;
    end 
    else 
    begin
        MemtoReg_out <= MemtoReg_in; 
        RegWrite_out <= RegWrite_in;
        read_data_out <= read_data_in; 
        alu_result_out <= alu_result_in; 
        rd_out <= rd_in;
    end
end
endmodule