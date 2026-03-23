`timescale 1ns / 1ps

`define IMEM_SIZE 4096 
module instruction_mem(address, instruction);
input [63:0] address;
output reg [31:0] instruction;

reg [7:0] storage[0:`IMEM_SIZE-1]; //making an array of 4096 bytes, each storage[i] conatins 1 byte

integer file_ptr;
integer i = 0;
integer j, val;

initial begin

    for (i = 0; i < `IMEM_SIZE; i = i + 1)
        storage[i] = 8'b0;
    
    file_ptr = $fopen("instructions.txt","r");

    if(file_ptr == 0) begin
        $display("wasnt able to open the file");
        $finish;
    end
    
    i = 0;
    while($feof(file_ptr) == 0 && i < `IMEM_SIZE) begin
        j = $fscanf(file_ptr, "%h\n", val);
        if(j == 1) 
        begin
            storage[i] = val[7:0];
            i = i + 1;
        end
    end
$fclose(file_ptr);
end

wire [11:0] a = address[11:0];

always @(*) begin
    if (a <= (`IMEM_SIZE - 4)) begin
        instruction = { storage[a], 
                        storage[a+1], 
                        storage[a+2], 
                        storage[a+3] };
    end
    else begin
        instruction = 32'h00000000;
    end
end

endmodule