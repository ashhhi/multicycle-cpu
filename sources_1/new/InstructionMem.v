`timescale 1ns / 1ps
module InstructionMem(
pc,IF_clk,
ins_Opcode,ins_func,ins_rs,ins_rt,ins_rd,ins_imm
    );
    input [31:0] pc;
    input IF_clk;
    output reg [5:0] ins_Opcode;
    output reg [5:0] ins_func;
    output reg [4:0] ins_rs;
    output reg [4:0] ins_rt;
    output reg [4:0] ins_rd;
    output reg [25:0] ins_imm;
    reg [31:0] memory[64:0];
    
    initial
    begin
      memory[0]=32'b000000_00111_00010_00010_00000_100000;//add reg[2]=reg[7]+reg[2]
      memory[1]=32'b000000_00010_00111_00100_00000_100011;//subu reg[4]=reg[2]-reg[7]
      memory[2]=32'b000000_00000_00001_00010_00000_101011;//sltu reg[0]<reg[1]?reg[2]=1:reg[2]=0
      memory[3]=32'b001101_00011_00100_0010011111000001;//ori reg[4]=reg[3]|zeroext(0010011111000001)
      memory[4]=32'b101011_00101_00110_0000000000000111;//sw reg[6]=6 MEM[reg[5]+SignExt(imm16)<=reg[6]
      memory[5]=32'b100011_00101_00111_0000000000000111;//lw reg[7]<=MEM[reg[5]+SignExt(imm16)
      memory[6]=32'b000000_00111_00010_00011_00000_100000;//add reg[7]=6,,reg[2]=1,reg[3]=reg[7]+reg[2]
      memory[7]=32'b000100_00001_00010_0000000000000001;//beq reg[1]==reg[2] ? pc<=pc+4+SignExt(0000000000000001)*4 : pc<=pc+4
      //memory[8]beq跳转到memory[9]
      memory[9]=32'b000010_00000_00000_00000_00000_111111;//jump pc<=0000_00000_00000_00000_00000_111111_00
    end
    
    always @(posedge IF_clk)
    begin
       ins_Opcode=memory[pc[31:2]][31:26];
       ins_func=memory[pc[31:2]][5:0];
       ins_rs=memory[pc[31:2]][25:21];
       ins_rt=memory[pc[31:2]][20:16];
       ins_rd=memory[pc[31:2]][15:11];
       ins_imm=memory[pc[31:2]][25:0];
    end
        
endmodule

