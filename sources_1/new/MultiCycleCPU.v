`timescale 1ns / 1ps
module MultiCycleCPU(
CLK,
Opcode,ALU_in1,ALU_in2,ALU_result,PC_out,
IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk
    );
    input CLK;
    output [5:0] Opcode;
    output [31:0] ALU_in1;
    output [31:0] ALU_in2;
    output [31:0] ALU_result;
    output [31:0] PC_out;//计算出的下一个pc值
    
    output IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk;
    //ControlUnit输出信号
    wire PCWre,Branch,Jump,RegDst,ALUSrc,MemorReg,MemWr,ExtOp;
    wire RegWr;
    wire [2:0] ALUctr;
    
    wire [2:0] STATE_out;
    
    //ALU输出信号
    wire Carryout,Zero,Overflow;
    
    wire [31:0] PC_in;
    
    //从指令中取出的相关数据
    wire [25:0] Imm26;
    wire [5:0] FUNC;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [4:0] RD;
    
    wire [31:0] DataMem_out;
    
    //RegisterFile相关
    wire [31:0] data_to_registerfile;
    //wire [31:0] ALU_data1;
    wire [31:0] ALU_temp_data1;
    
    wire [31:0] ALU_temp_data2;
    //wire [31:0] ALU_data2;
//    module PCctr(
//           clk,PCWre,Branch, Jump, Zero, imm,pc_in,pc_out);
//imm取自指令后26位
    PCctr pcctr(
                .PCWre(PCWre),
                .Branch(Branch),
                .Jump(Jump),
                .Zero(Zero),
                .imm(Imm26),
                .pc_in(PC_in),
                .pc_out(PC_out)
                );
      
      
//      module PC_in_out(
//                        clk,pc_in,
//                        pc_out  ); 
//把当前pc值PC_out，送入PC_in，以便PCctr下一次计算
        PC_in_out pc_in_out(
                    .clk(CLK),
                    .pc_in(PC_out),
                    .pc_out(PC_in)
                    );            
    
//    module InstructionMem(
//        pc,IF_clk,
//        ins_Opcode,ins_func,ins_rs,ins_rt,ins_rd,ins_imm );
//imm取自指令后26位
    InstructionMem IM(
                        .pc(PC_out),
                        .IF_clk(IF_clk),
                        .ins_Opcode(Opcode),
                        .ins_func(FUNC),
                        .ins_rs(RS),
                        .ins_rt(RT),
                        .ins_rd(RD),
                        .ins_imm(Imm26)
                        );
       
//       module ControlUnit(
//                    clk,Opcode,func,
//                    Branch,Jump,RegDst,ALUSrc,ALUctr,MemorReg,RegWr,MemWr,ExtOp,PCWre,
//                    IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk,
//                    state_out
//                        );
        ControlUnit controlunit(
                    .clk(CLK),
                    .Opcode(Opcode),
                    .func(FUNC),
                    .Branch(Branch),
                    .Jump(Jump),
                    .RegDst(RegDst),
                    .ALUSrc(ALUSrc),
                    .ALUctr(ALUctr),
                    .MemorReg(MemorReg),
                    .RegWr(RegWr),
                    .MemWr(MemWr),
                    .ExtOp(ExtOp),
                    .PCWre(PCWre),
                    .IF_clk(IF_clk),
                    .ID_clk(ID_clk),
                    .ALU_clk(ALU_clk),
                    .MEM_clk(MEM_clk),
                    .WB_clk(WB_clk),
                    .state_out(STATE_out)
                    );
                    
              
//      module RegisterFile(
//                WB_clk,RegWr,Overflow,RegDst,Ra,Rb,Rc,busW,
//                busA,busB ); 
        RegisterFile registerfile(
                    .WB_clk(WB_clk),
                    .RegWr(RegWr),
                    .Overflow(Overflow),
                    .RegDst(RegDst),
                    .Ra(RS),
                    .Rb(RT),
                    .Rc(RD),
                    .busW(data_to_registerfile),
                    .busA(ALU_in1),
                    .busB(ALU_temp_data1)
                    );  
           
           
//           module Extender(
//                    ExtOp,ex_imm,
//                    ex_out
//                        ); 
            Extender extender(
                        .ExtOp(ExtOp),
                        .ex_imm(Imm26),
                        .ex_out(ALU_temp_data2)
                        );
                                
//         module ALUSrc_select(
//                        ALUSrc,busB,imm36,
//                        src_out );           
           ALUSrc_select alusrc_select(
                    .ALUSrc(ALUSrc),
                    .busB(ALU_temp_data1),
                    .imm36(ALU_temp_data2),
                    .src_out(ALU_in2)
           );
           
//           module ALU32(
//                    ALU_clk,ALUctr,in0,in1,
//                    carryout,overflow,zero,out );
           ALU32 alu32(
                       .ALU_clk(ALU_clk),
                       .ALUctr(ALUctr),
                       .in0(ALU_in1),
                       .in1(ALU_in2),
                       .carryout(Carryout),
                       .overflow(Overflow),
                       .zero(Zero),
                       .out(ALU_result)
                       );
                       
                       
//           module DataMem(
//                    MEM_clk,WrEn,Adr,DataIn,
//                    DataOut
//                        );
             DataMem datamem(
                      .MEM_clk(MEM_clk),
                      .WrEn(MemWr),
                      .Adr(ALU_result),
                      .DataIn(ALU_temp_data1),
                      .DataOut(DataMem_out)
                      );
                      
//             module Data_select(
//                    MemorReg,ALU_out,DataMem_out,
//                    Data_out
//                        );
               Data_select data_select(
                        .MemorReg(MemorReg),
                        .ALU_out(ALU_result),
                        .DataMem_out(DataMem_out),
                        .Data_out(data_to_registerfile)
                        );
                      
                       
endmodule

