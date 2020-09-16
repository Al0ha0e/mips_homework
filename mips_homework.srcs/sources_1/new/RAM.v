`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/05 09:41:04
// Design Name: 
// Module Name: RAM
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


module RAM(
    input wire                  clk,//
    input wire                  ce,//

    input wire                  we,//
    input wire[`WORD_W]         addr,//
    input wire[`WORD_W]         wdata,//
    input wire[3:0]             sel,//         

    output reg[`WORD_W]         data//
);

reg[`BYTE_W]    mem0[0:1024];
reg[`BYTE_W]    mem1[0:1024];
reg[`BYTE_W]    mem2[0:1024];
reg[`BYTE_W]    mem3[0:1024];

always @(*) begin
    if((ce==`DISABLE_1)||(we==`ENABLE_1)) begin
        data <= `ZERO_WORD;
    end else begin
        data <= {
            mem3[addr[18:2]],
            mem2[addr[18:2]],
            mem1[addr[18:2]],
            mem0[addr[18:2]]
        };
    end
end

always @(posedge clk) begin
    if((ce == `ENABLE_1) && (we==`ENABLE_1)) begin
        if(sel[3]==`ENABLE_1) begin
            mem3[addr[18:2]] <= wdata[31:24];
        end
        if(sel[2]==`ENABLE_1) begin
            mem2[addr[18:2]] <= wdata[23:16];
        end
        if(sel[1]==`ENABLE_1) begin
            mem1[addr[18:2]] <= wdata[15:8];
        end
        if(sel[0]==`ENABLE_1) begin
            mem0[addr[18:2]] <= wdata[7:0];
        end
    end
end

endmodule
