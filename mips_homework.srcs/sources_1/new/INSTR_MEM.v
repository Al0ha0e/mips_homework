`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 21:11:59
// Design Name: 
// Module Name: INSTR_MEM
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


module INSTR_MEM(
    input wire[`WORD_W]         pc,

    output reg[`WORD_W]         instr      
    );
reg[`WORD_W]    instrs[0:1024];

initial begin/*
    instrs[0] = 32'b00111100000000011111111111111111;//LUI
    instrs[4] = 32'b00111100000000100111111111111110;//LUI
    instrs[8] = 32'b10101100000000100000000000000000;//SW
    instrs[12] = 32'b10001100000000110000000000000000;//LW
    instrs[16] = 32'b00000000001000110000000000011001;//MUL
        */
    //addiu $0 $1 1
    instrs[0] = 32'b00100100000000010000000000000001;	
    //add $0 $0 $2
    instrs[4] = 32'b00000000000000000001000000100000;
    //sw $2 $1 0
    instrs[8] = 32'b10101100010000010000000000000000;
    //sw $2 $1 4
    instrs[12] = 32'b10101100010000010000000000000100;
    //lw $2 $3 0
    instrs[16] = 32'b10001100010000110000000000000000;
    //lw $2 $4 4
    instrs[20] = 32'b10001100010001000000000000000100;
    //add $3 $4 $5
    instrs[24] = 32'b00000000011001000010100000100000;
    //sw $2 $5 8
    instrs[28] = 32'b10101100010001010000000000001000;
    //addiu $2 $2 4
    instrs[32] = 32'b00100100010000100000000000000100;
    //addi $2 $5 -32
    instrs[36] = 32'b00100000010001011111111111100000;
    //blez $5 16
    instrs[40] = 32'b00011000101000000000000000000100;
    instrs[44] = 32'b00000000000000000000000000000000;
end

always @(*) begin
    instr <= instrs[pc];
end

endmodule
