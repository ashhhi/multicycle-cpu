`timescale 1ns / 1ps

module PC_in_out(
    clk,
    pc_in,
    pc_out
    );
    input                    clk;
    input [   31: 0]         pc_in;
    output reg [   31: 0]         pc_out;

    always  @(posedge clk)begin
        begin
            pc_out <= pc_in;
        end
    end

endmodule
