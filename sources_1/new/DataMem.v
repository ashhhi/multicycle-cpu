`timescale 1ns / 1ps
module DataMem(
MEM_clk,WrEn,Adr,DataIn,
DataOut
    );
    input MEM_clk;
    input WrEn;
    input [31:0] Adr;
    input [31:0] DataIn;
    output reg [31:0] DataOut;
    //32个32位宽寄存器
    reg [31:0] memory[0:31];
    integer i;
    initial
    begin
        for(i=0;i<32;i=i+1)
            memory[i]<=0;
    end
    
    always@ (posedge MEM_clk)
    begin
        if(WrEn==0)
            DataOut=memory[Adr];
        else
            memory[Adr]=DataIn;
    end
    
endmodule


