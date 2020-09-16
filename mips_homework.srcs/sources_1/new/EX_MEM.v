`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/05 15:45:00
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(//
    input wire                  clk,//
    input wire                  rst,//

    input wire[5:0]             op_i,//

    //HI
    input wire                  we_hi_i,//
    input wire[`WORD_W]         wdata_hi_i,//
    //LO
    input wire                  we_lo_i,//
    input wire[`WORD_W]         wdata_lo_i,//
    //register file
    input wire                  we_i,//
    input wire[`REG_ADDR_W]     waddr_i,//
    //memory
    input wire[`WORD_W]         mem_addr_i,//
    input wire[`WORD_W]         mem_wdata_i,//

    input wire[`WORD_W]         alu_otp_i,//

    output reg[5:0]             op_o,//

    //HI
    output reg                  we_hi_o,//
    output reg[`WORD_W]         wdata_hi_o,//
    //LO
    output reg                  we_lo_o,//
    output reg[`WORD_W]         wdata_lo_o,//
    //register file
    output reg                  we_o,//
    output reg[`REG_ADDR_W]     waddr_o,//
    //memory
    output reg[`WORD_W]         mem_addr_o,//
    output reg[`WORD_W]         mem_wdata_o,//

    output reg[`WORD_W]         alu_otp_o//
    );


always @(posedge clk) begin
    if(rst == `ENABLE_1) begin
        op_o <= 6'b000000;
        we_hi_o <= `DISABLE_1;
        wdata_hi_o <= `ZERO_WORD;
        we_lo_o <= `DISABLE_1;
        wdata_lo_o <= `ZERO_WORD;
        we_o <= `DISABLE_1;
        waddr_o <= 5'b00000;
        mem_addr_o <= `ZERO_WORD;
        mem_wdata_o <= `ZERO_WORD;
        alu_otp_o <= `ZERO_WORD;
    end
    if (rst == `DISABLE_1) begin
        op_o <= op_i;
        we_hi_o <= we_hi_i;
        wdata_hi_o <= wdata_hi_i;
        we_lo_o <= we_lo_i;
        wdata_lo_o <= wdata_lo_i;
        we_o <= we_i;
        waddr_o <= waddr_i;
        mem_addr_o <= mem_addr_i;
        mem_wdata_o <= mem_wdata_i;
        alu_otp_o <= alu_otp_i;
    end
end
endmodule
