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
      memory[0]=32'b000000_00111_00010_00010_00000_100000;//add reg[2]=reg[7]+reg[2]                         //reg[2]=9
      memory[1]=32'b000000_00010_00111_00100_00000_100011;//subu reg[4]=reg[2]-reg[7]                       //reg[4]=2
      memory[2]=32'b000000_00000_00001_00010_00000_101011;//sltu reg[0]<reg[1]?reg[2]=1:reg[2]=0            //reg[2]=1
      memory[3]=32'b001101_00011_00100_0010011111000001;//ori reg[4]=reg[3]|zeroext(0010011111000001)       //reg[4]=27c3
      memory[4]=32'b101011_00101_00110_0000000000000111;//sw reg[6]=6 MEM[reg[5]+SignExt(imm16)<=reg[6]     //mem[5+7]=reg[6]=6
      memory[5]=32'b100011_00101_00111_0000000000000111;//lw reg[7]<=MEM[reg[5]+SignExt(imm16)              //reg[7]=mem[5+7]=6
      memory[6]=32'b000000_00111_00010_00011_00000_100000;//add reg[7]=6,reg[2]=1,reg[3]=reg[7]+reg[2]     //reg[3]=7
      memory[7]=32'b000000_00011_00111_01000_00000_100010;//sub reg[8],reg[3],reg[7]    //reg[8]=reg[3]-reg[7]=1
      memory[8]=32'b000000_00100_00010_10000_00000_101010;//slt reg[4]<reg[2]?reg[16]=1:reg[16]=0           //reg[16]=0    
      memory[9]=32'b000100_00001_00010_0000000000000001;//beq reg[1]==reg[2]?pc<=pc+4+SignExt(0000000000000001)*4:pc<=pc+4//beq跳转到memory[9]
      memory[11]=32'b000010_00000_00000_00000_00000_001101;//jump pc<=34
      memory[13]=32'b001101_00100_10001_0010100101101100;//ori reg[17]=reg[4]|zeroext(0010100101101100)     //reg[17]=2fef
      memory[14]=32'b101011_00011_10001_0000000000001000;//sw reg[17]=2fef MEM[reg[3]+SignExt(imm16)]     //mem[3+8]=reg[6]=2fef
      memory[15]=32'b000000_00011_00001_00010_00000_100000; //add reg[3],reg[1],reg[2]                      //reg[3]=2
      memory[16]=32'b001001_00111_10100_0000000000000001;//addiu reg[20],reg[7],1                           reg[20]=7
      memory[17]=32'b000000_10100_00111_00110_00000_100010;//sub reg[6],reg[20],reg[7]    //reg[6]=reg[20]-reg[7]=1
      memory[18]=32'b000000_00110_00011_00110_00000_101011;//reg[3]<reg[6]?reg[6]=1:reg[6]=0                //reg[6]=0
      memory[19]=32'b101011_00011_10011_0000000000000000;//sw reg[19]=19 MEM[reg[3]+SignExt(imm16)]     //mem[7]=reg[19]=19
      memory[20]=32'b000100_00011_00111_0000000000000010;//beq reg[3]==reg[7]?pc<=pc+4+SignExt(0000000000000010)*4:pc<=pc+4//不发生跳转
      memory[21]=32'b100011_00001_11000_0000000000001010;//lw reg[24]<=MEM[reg[1]+SignExt(imm16)              //reg[24]=mem[1+10]=2fef
      memory[22]=32'b001101_00100_00011_0000000001100010;//ori reg[3],reg[4],98                                //reg[3]=27E3
      memory[23]=32'b001001_01110_01010_0000000000001000;//addiu reg[10],reg[14],8                           //reg[10]=14+8=22
      memory[24]=32'b000000_00111_00011_00010_00000_101010;//slt reg[7]<reg[3]?reg[2]=1:reg[2]=0           //reg[2]=0
      memory[25]=32'b000000_00011_01000_01001_00000_100010;//sub reg[9],reg[3],reg[8]    //reg[9]=reg[3]-reg[8]=1
      memory[26]=32'b101011_00001_11100_0000000000001000;//sw reg[28]=28 MEM[reg[1]+SignExt(imm16)]     //mem[1+8]=reg[28]=28
      memory[27]=32'b000000_00001_00100_00000_00000_100000;//add reg[1]=1,reg[4]=27c3,reg[0]=reg[1]+reg[4]     //reg[0]=27c4
      memory[28]=32'b000100_00111_00110_0000000000000001;//beq reg[7]==reg[6]?pc<=pc+4+SignExt(0000000000000001)*4:pc<=pc+4//beq跳转到30
      memory[29]=32'b001101_00101_10110_1101100110110101;//ori reg[22],reg[5],55,733                                //reg[22]=D9B7
      memory[30]=32'b000000_00100_00010_00011_00000_100000; //add reg[4],reg[2],reg[3]                      //reg[4]=2
      memory[31]=32'b000010_00000_00000_00000_00000_000000;//jump pc<=60
    end
    
    always @(posedge IF_clk)
    begin
       ins_Opcode=memory[pc[31:2]][31:26];      //pc[31:2]指的是pc除以4，即对应指令的索引
       ins_func=memory[pc[31:2]][5:0];
       ins_rs=memory[pc[31:2]][25:21];
       ins_rt=memory[pc[31:2]][20:16];
       ins_rd=memory[pc[31:2]][15:11];
       ins_imm=memory[pc[31:2]][25:0];
    end
        
endmodule

