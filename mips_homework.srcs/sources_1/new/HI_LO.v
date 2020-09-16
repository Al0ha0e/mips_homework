`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/05 00:41:33
// Design Name: 
// Module Name: HI_LO
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


module HI_LO(
    input wire              clk,//
    input wire              rst,//

    input wire              we_hi,//
    input wire[`WORD_W]     wdata_hi,//
    
    input wire              we_lo,//
    input wire[`WORD_W]     wdata_lo,//

    output reg[`WORD_W]     data_hi,//
    output reg[`WORD_W]     data_lo//
    );

    reg[`WORD_W] hi;
    reg[`WORD_W] lo;

    always @(*) begin
        if(rst==`DISABLE_1) begin
            if(we_hi==`ENABLE_1) begin
                data_hi <= wdata_hi;
            end else begin
                data_hi <= hi;
            end
            if(we_lo==`ENABLE_1) begin
                data_lo <= wdata_lo;
            end else begin
                data_lo <= lo;
            end
        end else begin
            data_hi <= `ZERO_WORD;
            data_lo <= `ZERO_WORD;
        end
    end

    always @(posedge clk) begin
        if(rst == `ENABLE_1) begin
            hi <= `ZERO_WORD;
            lo <= `ZERO_WORD;
        end
        if(rst == `DISABLE_1 && we_hi == `ENABLE_1) begin
            hi <= wdata_hi;
        end

        if(rst == `DISABLE_1 && we_lo == `ENABLE_1) begin
            lo <= wdata_lo;
        end
    end

endmodule
