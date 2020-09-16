`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/05 00:40:27
// Design Name: 
// Module Name: WB
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


module WB(
    input wire              rst,//

    input wire                  we_hi_i,//
    input wire[`WORD_W]         wdata_hi_i,//
    
    input wire                  we_lo_i,//
    input wire[`WORD_W]         wdata_lo_i,//

    input wire                  we_i,//
    input wire[`REG_ADDR_W]     waddr_i,//
    input wire[`WORD_W]         wdata_i,//

    output reg                  we_hi_o,//
    output reg[`WORD_W]        wdata_hi_o,//
    
    output reg                 we_lo_o,//
    output reg[`WORD_W]        wdata_lo_o,//

    output reg                  we_o,//
    output reg[`REG_ADDR_W]     waddr_o,//
    output reg[`WORD_W]         wdata_o//
    );

always @(*) begin
    if (rst==`ENABLE_1) begin
        we_hi_o <= 1'b0;
        wdata_hi_o <= `ZERO_WORD;
        we_lo_o <= 1'b0;
        wdata_lo_o <= `ZERO_WORD;
        we_o <= 1'b0;
        waddr_o <= 5'b00000;
        wdata_o <= `ZERO_WORD;
    end else begin
        we_hi_o <= we_hi_i;
        wdata_hi_o <= wdata_hi_i;
        we_lo_o <= we_lo_i;
        wdata_lo_o <= wdata_lo_i;
        we_o <= we_i;
        waddr_o <= waddr_i;
        wdata_o <= wdata_i;
    end
end
endmodule
