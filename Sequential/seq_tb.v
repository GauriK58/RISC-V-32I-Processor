`timescale 1ns/1ps
`include "alu.v"
`include "alu_control.v"
`include "control_unit.v"
`include "data_mem.v"
`include "imm_gen.v"
`include "instruction_mem.v"
`include "mux2_64.v"
`include "pc.v"
`include "processor.v"
`include "register_file.v"

module seq_tb;

    reg clk;
    reg reset;
    integer cycle_count;

    processor DUT (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        cycle_count = 0;

        #20 
        reset = 0;
    end

    always @(posedge clk) begin
        if (!reset) begin
            cycle_count = cycle_count + 1;

            // stop when fetched instruction = 0
            if (DUT.instruction == 32'b0) begin
                dump_registers;
                $finish;
            end
        end
    end

    task dump_registers;
        integer file, i;
        begin
            file = $fopen("register_file.txt","w");

            for (i=0;i<32;i=i+1)
                $fwrite(file,"%016h\n",DUT.RF.registers[i]);

            $fwrite(file,"%0d\n",cycle_count);

            $fclose(file);
        end
    endtask

endmodule