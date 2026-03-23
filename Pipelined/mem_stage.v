`timescale 1ns/1ps

module mem_stage(

    input clk,
    input reset,

    input MemRead,
    input MemWrite,

    input [63:0] alu_result,
    input [63:0] write_data,

    output [63:0] read_data

);

wire [9:0] mem_address;

assign mem_address = alu_result[9:0];

data_mem data_memory(
    .clk(clk),
    .reset(reset),
    .address(mem_address),
    .write_data(write_data),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .read_data(read_data)

);

endmodule