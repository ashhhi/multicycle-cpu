`timescale 1ns / 1ps
module RegisterFile(
WB_clk,RegWr,Overflow,RegDst,Ra,Rb,Rc,busW,
busA,busB
    );
    input WB_clk;
    input RegWr;
    input Overflow;
    input RegDst;
    //Ra(Rs),Rb(Rt),Rc(Rd)
    input [4:0] Ra;
    input [4:0] Rb;
    input [4:0] Rc;
    
    input [31:0] busW;
    output  reg [31:0] busA;
    output  reg [31:0] busB;
    reg [31:0] RegMem [31:0];//32个32位宽寄存器
    
    //初始化寄存器中的值
    integer i;
    initial 
    begin
        for(i=0;i<32;i=i+1)
            RegMem[i]<=i;
    end
    
    always @(Ra or Rb)
    begin
     busA=RegMem[Ra];
     busB=RegMem[Rb];
    end
    
    always@(posedge WB_clk or RegWr)
    begin
        if(RegWr&&!Overflow)
        begin
            if(RegDst)
                RegMem[Rc]<=busW;
            else
                RegMem[Rb]<=busW;
                
        end
     end
    
endmodule

