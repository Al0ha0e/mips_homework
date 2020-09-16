`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 20:13:10
// Design Name: 
// Module Name: IF_ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IF_ID(
    input wire                  clk,//
    input wire                  rst,//

    input wire[`WORD_W]         instr_i,//
    input wire[`WORD_W]         pc_i,//
    input wire                  stall,//

    output reg[`WORD_W]         instr_o,//
    output reg[`WORD_W]         pc_o//
    );

always @(posedge clk) begin
    if(rst==`ENABLE_1) begin
        instr_o <= `ZERO_WORD;
        pc_o <= `ZERO_WORD;
    end
    if(rst==`DISABLE_1 && stall==`DISABLE_1) begin
        instr_o <= instr_i;
        pc_o <= pc_i;
    end
end

endmodule
