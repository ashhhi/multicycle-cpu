`timescale 1ns / 1ps
module Data_select(
MemorReg,ALU_out,DataMem_out,
Data_out
    );
    input MemorReg;
    input [31:0] ALU_out;
    input [31:0] DataMem_out;
    output [31:0] Data_out;
    
    assign Data_out=MemorReg?DataMem_out:ALU_out;
endmodule

