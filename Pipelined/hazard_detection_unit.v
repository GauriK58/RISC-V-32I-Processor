`timescale 1ns/1ps
module hazard_detection_unit (
    input [4:0] rs1_id, rs2_id,  
    input [4:0] rd_idex,         
    input memread_idex,          
    output reg stall // Stall: hold PC/IF/ID, bubble ID/EX (as in, the EX stage gets a no operation (NOP) instruction)
);
    always @(*) begin
        stall = 1'b0;
        if (memread_idex && (rd_idex != 0) && ((rd_idex == rs1_id) || (rd_idex == rs2_id))) stall = 1'b1;
    end
endmodule