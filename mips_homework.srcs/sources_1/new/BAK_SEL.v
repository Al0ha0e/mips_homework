`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/08 21:47:25
// Design Name: 
// Module Name: BAK_SEL
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

module BAK_SEL(
    input wire              reg_ex_w,//
    input wire              reg_mem_w,//
    input wire[`WORD_W]     reg_ex_data,//
    input wire[`WORD_W]     reg_mem_data,//
    input wire[`REG_ADDR_W] reg_ex_addr,//
    input wire[`REG_ADDR_W] reg_mem_addr,//
    input wire[`REG_ADDR_W] reg1_addr,//
    input wire[`REG_ADDR_W] reg2_addr,//
    input wire[`WORD_W]     reg1_data,//
    input wire[`WORD_W]     reg2_data,//

    output wire[`WORD_W]    op1,//
    output wire[`WORD_W]    op2//
    );
    assign op1 = reg1_addr ==`ZERO_WORD ? `ZERO_WORD : (reg_ex_w == `ENABLE_1) && (reg_ex_addr==reg1_addr) ? reg_ex_data : (reg_mem_w == `ENABLE_1) && (reg_mem_addr==reg1_addr) ? reg_mem_data : reg1_data;
    assign op2 = reg2_addr ==`ZERO_WORD ? `ZERO_WORD : (reg_ex_w == `ENABLE_1) && (reg_ex_addr==reg2_addr) ? reg_ex_data : (reg_mem_w == `ENABLE_1) && (reg_mem_addr==reg2_addr) ? reg_mem_data : reg2_data;
endmodule
