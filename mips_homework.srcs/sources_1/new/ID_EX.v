`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/08 14:26:13
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input wire                  clk,//
    input wire                  rst,//

    input wire[5:0]             op_i,//
    input wire[5:0]             funct_i,//
    input wire[4:0]             shamt_i,//

    input wire[`REG_ADDR_W]     op1_reg_i,//
    input wire[`REG_ADDR_W]     op2_reg_i,//
    input wire[`WORD_W]         op1_i,//
    input wire[`WORD_W]         op2_i,//

    input wire                  we_hi_i,//
    input wire                  we_lo_i,//

    input wire                  we_i,//
    input wire[`REG_ADDR_W]     waddr_i,//
    input wire[`WORD_W]         mem_wdata_i,//

    input wire                  curr_mem_i,//              

    output reg[5:0]             op_o,//
    output reg[5:0]             funct_o,//
    output reg[4:0]             shamt_o,//

    output reg[`REG_ADDR_W]     op1_reg_o,//
    output reg[`REG_ADDR_W]     op2_reg_o,//
    output reg[`WORD_W]         op1_o,//
    output reg[`WORD_W]         op2_o,//

    output reg                  we_hi_o,//
    output reg                  we_lo_o,//

    output reg                  we_o,//
    output reg[`REG_ADDR_W]     waddr_o,//
    output reg[`WORD_W]         mem_wdata_o,//

    output reg                 curr_mem_o//
    );

always @(posedge clk) begin
    if(rst==`ENABLE_1) begin
        op_o <= 6'b000000;
        funct_o <= 6'b000000;
        shamt_o <= 5'b00000;
        op1_reg_o <= 5'b00000;
        op2_reg_o <= 5'b00000;
        op1_o <= `ZERO_WORD;
        op2_o <= `ZERO_WORD;
        we_hi_o <= `DISABLE_1;
        we_lo_o <= `DISABLE_1;
        we_o <= `DISABLE_1;
        waddr_o <= `ZERO_WORD;
        mem_wdata_o <= `ZERO_WORD;
        curr_mem_o <= `DISABLE_1;
    end
    if(rst==`DISABLE_1) begin
        op_o <= op_i;
        funct_o <= funct_i;
        shamt_o <= shamt_i;
        op1_reg_o <= op1_reg_i;
        op2_reg_o <= op2_reg_i;
        op1_o <= op1_i;
        op2_o <= op2_i;
        we_hi_o <= we_hi_i;
        we_lo_o <= we_lo_i;
        we_o <= we_i;
        waddr_o <= waddr_i;
        mem_wdata_o <= mem_wdata_i;
        curr_mem_o <= curr_mem_i;
    end
end
endmodule
