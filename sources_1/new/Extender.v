`timescale 1ns / 1ps
module Extender(
ExtOp,ex_imm,
ex_out
    );
    input ExtOp;
    input [25:0] ex_imm;
    output  [31:0] ex_out;
    assign ex_out=ExtOp?{ {16{ex_imm[15]}} ,ex_imm[15:0]}:{ 16'b0,ex_imm[15:0]};    //符号扩展
endmodule
