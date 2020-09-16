`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/05 00:07:03
// Design Name: 
// Module Name: register_file
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


module REG_FILE(
    input wire                  clk,//
    input wire                  rst,//

    input wire                  we,//
    input wire[`REG_ADDR_W]     waddr,//
    input wire[`WORD_W]         wdata,//

    input wire[`REG_ADDR_W]     raddr1,//
    input wire[`REG_ADDR_W]     raddr2,//

    output reg[`WORD_W]         data1,//
    output reg[`WORD_W]         data2//
    );

reg[`WORD_W]    regs[`REG_CNT_W];

always @ (*) begin
    if ((rst == `ENABLE_1) || (raddr1 == 5'b00000)) begin
        data1 <= `ZERO_WORD;
    end else if((we == `ENABLE_1) && (raddr1 == waddr)) begin
        data1 <= wdata;
    end else begin
        data1 <= regs[raddr1];
    end
end

always @(*) begin
    if ((rst == `ENABLE_1) || (raddr2 == 5'b00000)) begin
        data2 <= `ZERO_WORD;
    end else if((we == `ENABLE_1) && (raddr2 == waddr)) begin
        data2 <= wdata;
    end else begin
        data2 <= regs[raddr2];
    end
end

always @(posedge clk) begin
    if (rst == `DISABLE_1) begin
        if ((we==`ENABLE_1) && (waddr != 5'b00000)) begin
            regs[waddr] <= wdata;
        end 
    end
    
end

endmodule
