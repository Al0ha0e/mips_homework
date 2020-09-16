`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 20:13:28
// Design Name: 
// Module Name: PC
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


module PC(
    input wire                  clk,//
    input wire                  rst,//
    input wire[`WORD_W]         pc_i,//
    input wire                  pc_we,//
    input wire                  pc_stall,//

    output reg[`WORD_W]         pc_o//
    );

//reg[`WORD_W] pc;

//assign pc_o = pc;

always @(posedge clk) begin

    if(rst==`ENABLE_1) begin
        pc_o <= `ZERO_WORD;
    end
    
    if(rst == `DISABLE_1) begin
        if(pc_stall == `DISABLE_1) begin
            if (pc_we==`ENABLE_1) begin
                pc_o <= pc_i;
            end else begin
                pc_o <= pc_o + 4;
            end
        end
    end
end

endmodule
