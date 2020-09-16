`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/08 22:26:08
// Design Name: 
// Module Name: MUL_BAK
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


module MUL_BAK(
    input wire              hi_mem_w,//
    input wire[`WORD_W]     hi_mem_data,//

    input wire              lo_mem_w,//
    input wire[`WORD_W]     lo_mem_data,//

    input wire[`WORD_W]     hi_data,//
    input wire[`WORD_W]     lo_data,//

    output wire[`WORD_W]    hi,//
    output wire[`WORD_W]    lo//
    );
    assign hi = (hi_mem_w == `ENABLE_1)  ? hi_mem_data : hi_data;
    assign lo = (lo_mem_w == `ENABLE_1)  ? lo_mem_data : lo_data;
endmodule
