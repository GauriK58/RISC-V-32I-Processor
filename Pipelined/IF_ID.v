`timescale 1ns/1ps
module IF_ID(
    input clk,
    input reset,
    input stall,
    input flush,
    input [31:0] instr_in,
    input [63:0] pc_in,
    output reg [31:0] instr_out,
    output reg [63:0] pc_out
);
always @(posedge clk or posedge reset) 
    begin
        if (reset || flush) begin
            instr_out <= 32'd0;
            pc_out <= 64'd0;
        end else if (!stall) begin
            instr_out <= instr_in;
            pc_out <= pc_in;
        end
    end
endmodule

