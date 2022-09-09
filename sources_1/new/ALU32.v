`timescale 1ns / 1ps
module ALU32(
ALU_clk,ALUctr,in0,in1,
carryout,overflow,zero,out
    );
    input ALU_clk;
    input [31:0] in0,in1;
    input [2:0] ALUctr;//控制ALU进行何种操作
    output reg[31:0] out;
    output reg carryout,overflow,zero;
   
always@(posedge ALU_clk)
begin
    case(ALUctr)
        //addu
        3'b000:
            begin
            {carryout,out}=in0+in1;
            zero=(out==0)?1:0;
            overflow=0;
            end
            
        //add
        3'b001:
            begin
            out=in0+in1;
            overflow=((in0[31]==in1[31])&&(~out[31]==in0[31]))?1:0;
            zero=(out==0)?1:0;
            carryout=0;
            end
        //or
        3'b010:
            begin
            out=in0|in1;
            zero=(out==0)?1:0;
            carryout=0;
            overflow=0;
            end
        //subu
        3'b100:
            begin
            {carryout,out}=in0-in1;
            zero=(out==0)?1:0;
            overflow=0;
            end
        //sub
        3'b101:
            begin
            out=in0-in1;
            overflow=((in0[31]==0&&in1[31]==1&&out[31]==1)||(in0[31]==1&&in1[31]==0&&out[31]==0))?1:0;
            zero=(in0==in1)?1:0;
            carryout=0;
            end
        //sltu
        3'b110:
            begin
                out=(in0<in1)?1:0;
                carryout=out;
                zero=(out==0)?1:0;
                overflow=0;
            end
        //slt
        3'b111:
            begin                        
            if(in0[31]==1&&in1[31]==0)
                out=1;
            else if(in0[31]==0&&in1[31]==1)
                out=0;
            else 
                out=(in0<in1)?1:0;
           overflow=out; 
           zero=(out==0)?1:0;
           carryout=0;              
           end
        /*
        //and
        11'b00000100100:
            begin
            out=in0&in1;
            zero=(out==0)?1:0;
            carryout=0;
            overflow=0;
            end
       
        //xor
        11'b00000100110:
            begin
            out=in0^in1;
            zero=(out==0)?1:0;
            carryout=0;
            overflow=0;
            end
        //nor
        11'b00000100111:
            begin
            out=~(in0|in1);
            zero=(out==0)?1:0;
            carryout=0;
            overflow=0;
            end
        
        //shl
        11'b00000000100:
            begin
            {carryout,out}=in0<<in1;
            overflow=0;
            zero=(out==0)?1:0;
            end
        //shr
        11'b00000000110:
            begin
            out=in0>>in1;
            carryout=in0[in1-1];
            overflow=0;
            zero=(out==0)?1:0;
            end
        //sar
        11'b00000000111:
            begin
            out=($signed(in0))>>>in1;
            carryout=in0[in1-1];
            overflow=0;
            zero=(out==0)?1:0;
            end
        */
    endcase
end
endmodule

