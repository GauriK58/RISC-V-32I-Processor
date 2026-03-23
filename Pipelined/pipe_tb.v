`timescale 1ns/1ps

`include "pc.v"
`include "instruction_mem.v"
`include "control_unit.v"
`include "imm_gen.v"
`include "alu_control.v"
`include "alu.v"
`include "data_mem.v"
`include "register_file.v"
`include "cpu_wrapper.v"
`include "IF_stage.v"
`include "ID_stage.v"
`include "ex_stage.v"
`include "mem_stage.v"
`include "wb_stage.v"
`include "IF_ID.v"
`include "ID_EX.v" 
`include "ex_mem_reg.v"
`include "mem_wb_reg.v"
`include "forwarding_unit.v"
`include "hazard_detection_unit.v"
`include "mux2_64.v"

module pipe_tb;

    reg clk;
    reg reset;
    integer cycle_count;

    wire [63:0] write_data;

    cpu_wrapper uut (
        .clk(clk),
        .reset(reset),
        .write_data(write_data)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, pipe_tb);
    end

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        cycle_count = 0;

        #20 
        reset = 0;
    end

    always @(posedge clk) 
    begin
        if (!reset) begin
            cycle_count = cycle_count + 1;

            // stop when fetched instruction = 0
            if (uut.raw_instr == 32'b0) 
            begin
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
                $fwrite(file,"%016h\n",uut.ID.RF.registers[i]);

            $fwrite(file,"%0d\n",cycle_count);

            $fclose(file);
        end
    endtask

endmodule