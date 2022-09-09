`timescale 1ns / 1ps


module PCctr(
PCWre,Branch, Jump, Zero, imm,pc_in,pc_out
    );
    //input clk;
    input PCWre;
    input Branch;
    input Jump;
    input Zero;
    input [25:0] imm;//imm取自指令的后26位
    input [31:0] pc_in;
    output reg [31:0] pc_out;
    initial
    begin
        pc_out=0;
    end
    //clk上升沿触发
    always @(Jump or Branch or Zero or PCWre)
    if(Jump)
        pc_out={pc_in[31:28],imm[25:0],1'b0,1'b0};
    else if(Branch&&Zero)
        pc_out=pc_in+{{14{imm[15]}},imm[15:0],1'b0,1'b0};
    else if(!Jump&&PCWre)
        pc_out=pc_in+4;
        
endmodule


