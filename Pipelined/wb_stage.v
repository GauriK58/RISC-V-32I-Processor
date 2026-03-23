`timescale 1ns/1ps

module wb_stage(

    input  [63:0] alu_result,
    input  [63:0] read_data,
    input  MemtoReg,

    output [63:0] write_data

);

// the mux selects what to write back to register file
// I0 = ALU result
// I1 = memory data

mux2_64 wb_mux(
    .I0(alu_result),
    .I1(read_data),
    .S(MemtoReg),
    .Y(write_data)
);

endmodule