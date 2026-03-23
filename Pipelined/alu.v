`include "cla8.v"
`include "cla64.v"
`include "adder.v"
`include "subtract.v"
`include "and.v"
`include "xor.v"
`include "or.v"
`include "sltu.v"
`include "slt.v"
`include "mux2.v"
`include "step.v"
`include "barrel_shift.v"
`include "sll.v"
`include "srl.v"
`include "sra.v"


module alu(
    input [63:0] a,
    input [63:0] b,
    input [3:0] control,
    output reg [63:0] result,
    output reg cout, carry_flag, overflow_flag, zero_flag
);

localparam ADD_Oper  = 4'b0000,
           SLL_Oper  = 4'b0001,
           SLT_Oper  = 4'b0010,
           SLTU_Oper = 4'b0011,
           XOR_Oper  = 4'b0100,
           SRL_Oper  = 4'b0101,
           OR_Oper   = 4'b0110,
           AND_Oper  = 4'b0111,
           SUB_Oper  = 4'b1000,
           SRA_Oper  = 4'b1101;

wire [63:0] add_sum, sub_diff, and_out, or_out, xor_out, srl_out, sll_out, sra_out, slt_out, sltu_out; 
wire add_cout, add_carryF, add_overF, sub_cout, sub_carryF, sub_overF;

adder add_mod(.A(a), .B(b), .Sum(add_sum), .Cout(add_cout), .carry_flag(add_carryF), .overflow_flag(add_overF));
subtract sub_mod(.A(a), .B(b), .Diff(sub_diff), .Cout(sub_cout), .carry_flag(sub_carryF), .overflow_flag(sub_overF));

and_op and_mod(.A(a), .B(b), .Y(and_out));
xor_op xor_mod(.A(a), .B(b), .Y(xor_out));
or_op or_mod(.A(a), .B(b), .Y(or_out));

slt  slt_mod (.A(a), .B(b), .Y(slt_out));
sltu sltu_mod(.A(a), .B(b), .Y(sltu_out));

sll sll_mod(.A(a), .B(b), .Y(sll_out));
srl srl_mod(.A(a), .B(b), .Y(srl_out));
sra sra_mod(.A(a), .B(b), .Y(sra_out));

always @(*) begin
    result        = 64'd0;
    cout          = 1'b0;
    carry_flag    = 1'b0;
    overflow_flag = 1'b0;

    case(control)
        ADD_Oper: 
        begin
            result = add_sum;
            cout = add_cout;
            carry_flag = add_carryF;
            overflow_flag = add_overF;
        end 

        SUB_Oper: 
        begin
            result = sub_diff;
            cout = sub_cout;
            carry_flag = sub_carryF;
            overflow_flag = sub_overF;
        end

        AND_Oper: 
        begin
            result = and_out;
        end

        XOR_Oper: 
        begin
            result = xor_out;
        end

        OR_Oper: 
        begin
            result = or_out;
        end

        SLTU_Oper: 
        begin
            result = sltu_out;
        end

        SLT_Oper: 
        begin
            result = slt_out;
        end

        SLL_Oper: 
        begin
            result = sll_out;
        end

        SRL_Oper: 
        begin
            result = srl_out;
        end

        SRA_Oper: 
        begin
            result = sra_out;
        end
    endcase

    zero_flag = (result == 64'b0);
end


endmodule