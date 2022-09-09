module ControlUnit(
clk,Opcode,func,
Branch,Jump,RegDst,ALUSrc,ALUctr,MemorReg,RegWr,MemWr,ExtOp,PCWre,
IF_clk,ID_clk,ALU_clk,MEM_clk,WB_clk,
state_out
    );
    input clk;
    input [5:0] Opcode;
    input [5:0] func;
    
    output reg Branch;
    output reg Jump;
    output reg RegDst;  //ѡ��д�ؽ���ļĴ������
    output reg ALUSrc;
    output reg [2:0] ALUctr;    //ALU������
    output reg MemorReg;        //�������Դ洢������ALU���
    output reg RegWr;           //RegisterFileдʹ��
    output reg MemWr;           //�洢��дʹ��
    output reg ExtOp;           //��չ��ʽ
    output reg PCWre;           //�޸�PCֵ
    output reg [2:0] state_out; //״̬���
    
    output reg IF_clk;          //ȡָ�ź�
    output reg ID_clk;          //ָ�������ź�
    output reg ALU_clk;         //ָ��ִ���ź�
    output reg MEM_clk;         //�洢�������ź�
    output reg WB_clk;          //���д���ź�
    
    parameter [2:0] IF=3'b000,//IF state
                     ID=3'b001,//ID state
                     EXE1=3'b110,//add,sub,subu,slt,sltu,ori,addiu
                     EXE2=3'b101,//beq
                     EXE3=3'b010,//sw lw
                     MEM=3'b011,//MEM state
                     WB1=3'b111,//add,sub,subu,slt,sltu,ori,addiu
                     WB2=3'b100;//lw
    
    //op
    parameter [5:0] R_type=6'b000000,
                     ori=6'b001101,
                     addiu=6'b001001,
                     lw=6'b100011,
                     sw=6'b101011,
                     beq=6'b000100,
                     jump=6'b000010;
    //״̬�Ĵ���                 
    reg [2:0] state,next_state;
  
    initial
        begin
        Branch=0;
        Jump=0;
        RegDst=0;
        ALUSrc=0;
        ALUctr=0;
        MemorReg=0;
        RegWr=0;
        MemWr=0;
        ExtOp=0;
        PCWre=0;
        state=3'b000;
        state_out=state;
        end
        
        //�����ش���
        always@(posedge clk)
        begin
            state_out <= state;
            state <= next_state;
        end
        
        //״̬��ת��1
        always@(state)
        begin
        case(state)
            //IF�׶���������ת��ID�׶�
            IF:  next_state<=ID;
            //ID�׶�
            ID:
                begin
                    if(Opcode == jump)
                        next_state<=IF;
                    else if(Opcode==beq)
                        next_state<=EXE2;
                    else if(Opcode==lw||Opcode==sw)
                        next_state<=EXE3;
                    else
                        next_state<=EXE1;
                end
            EXE1:next_state<=WB1;
            EXE2:next_state<=IF;
            EXE3:next_state<=MEM;
            MEM:
                begin
                    if(Opcode==lw)
                        next_state=WB2;
                    else
                        next_state=IF;
                end
           WB1:next_state<=IF;
           WB2:next_state<=IF;
           default:next_state=IF;
      endcase
      end
      
      
      //״̬��ת��2
      always @(next_state)
      begin
            if(next_state==IF)
                IF_clk=1;
            else
                IF_clk=0;
            
            if(next_state==ID)
                ID_clk=1;
            else
                ID_clk=0;
            
            if(next_state==EXE1||next_state==EXE2||next_state==EXE3)
                ALU_clk=1;
            else
                ALU_clk=0;
                
            if(next_state==MEM)
                MEM_clk=1;
            else
                MEM_clk=0;
            
            if(next_state==WB1||next_state==WB2)
                WB_clk=1;
            else
                WB_clk=0;
                
      end
      
      //״̬��ת��3
      always@(state)
      begin
        if(state==IF&&Opcode!=jump)
            PCWre<=1;
        else
            PCWre<=0;
        if(Opcode==R_type)
            begin
            Branch<=0;
            Jump<=0;
            RegDst<=1;
            ALUSrc<=0;
            MemorReg<=0;
            RegWr<=1;
            MemWr<=0;
            ALUctr[2]<=(~func[2])&func[1];
            ALUctr[1]<=func[3]&(~func[2])&func[1];
            ALUctr[0]<=((~func[3])&(~func[2])&(~func[1])&(~func[0])) | ((~func[2])&func[1]&(~func[0]));
            end
        else
            begin
            if(Opcode==beq)
                Branch<=1;
            else
                Branch<=0;
                
            if(Opcode==jump)
                Jump<=1;
            else
                Jump<=0;
                
            RegDst<=0;
            
            if(Opcode==ori||Opcode==addiu||Opcode==lw||Opcode==sw)
                ALUSrc<=1;
            else
                ALUSrc<=0;
                
            if(Opcode==lw)
                MemorReg<=1;
            else
                MemorReg<=0;
                
            if(Opcode==ori||Opcode==addiu||Opcode==lw)
                RegWr<=1;
             else
                RegWr<=0;
                
             if(Opcode==sw)
                MemWr<=1;
             else
                MemWr<=0;
                
             if(Opcode==addiu||Opcode==lw||Opcode==sw)
                ExtOp<=1;
             else
                ExtOp<=0;
                
             ALUctr[2]<=~Opcode[5]&~Opcode[4]&~Opcode[3]&Opcode[2]&~Opcode[1]&~Opcode[0];
             ALUctr[1]<=~Opcode[5]&~Opcode[4]&Opcode[3]&Opcode[2]&~Opcode[1]&Opcode[0];
             ALUctr[0]<=0;
             end
       end  
            
      
           
endmodule
