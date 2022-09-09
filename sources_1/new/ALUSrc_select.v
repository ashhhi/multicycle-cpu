`timescale 1ns / 1ps
module ALUSrc_select(
ALUSrc,busB,imm36,
src_out
    );
    input ALUSrc;
    input [31:0] busB;
    input [31:0] imm36;
    output [31:0] src_out;
    
    assign src_out=ALUSrc?imm36:busB;
endmodule

