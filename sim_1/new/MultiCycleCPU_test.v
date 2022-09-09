`timescale 1ns / 1ps
module MultiCycleCPU_test(

    );
    
//    module MultiCycleCPU(
//                CLK,
//                Opcode,ALU_in1,ALU_in2,ALU_result,STATE_out,PC_out,
//                IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk
//                    );
    reg CLK;
    wire IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk;
    wire [5:0] Opcode;
    
    wire [31:0] ALU_in1;
    wire [31:0] ALU_in2;
    wire [31:0] ALU_result;
    wire [31:0] PC_out;
    
    MultiCycleCPU cpu32(
            .CLK(CLK),
            .Opcode(Opcode),
            .ALU_in1(ALU_in1),
            .ALU_in2(ALU_in2),
            .ALU_result(ALU_result),
            .PC_out(PC_out),
            .IF_clk(IF_clk),
            .ID_clk(ID_clk),
            .ALU_clk(ALU_clk),
            .MEM_clk(MEM_clk),
            .WB_clk(WB_clk)
            );
            
    initial
        begin
            CLK=0;
        end
    always #0.001 CLK=~CLK;
endmodule

