`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/13 16:30:56
// Design Name: 
// Module Name: SOC
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


module SOC(
        input wire rst,
        input wire clk_rst,
        input wire clk1,
        input wire clk2,
        input wire use_single,
        
        output wire[7:0] A,
        output wire[7:0] otp,
        output wire[7:0] mem_wdata
        //output reg[31:0] pc
        //output reg[] 
    );

reg clk3;
wire real_clk;
assign real_clk = use_single == `ENABLE_1 ? clk2 : clk3;
reg[4:0] cnt;


always @(posedge clk1) begin
    if(~clk_rst == `ENABLE_1) begin
        clk3 <= 1'b0;
        cnt <= 5'b00000;
    end
    if(~clk_rst == `DISABLE_1) begin
        cnt <= cnt+5'b00001;
        if(cnt == 5'b10011) begin
            clk3 <= ~clk3;
            cnt <= 5'b00000;
        end 
    end
end 

wire[31:0] instr;
wire[31:0] pc;

    CPU cpu(
        .clk(real_clk),
        .rst(~rst),
        .instr(instr),
        .instr_addr(pc),
        .mem_wdata_o(mem_wdata)
    );

    INSTR_MEM ins_mem(
        .pc(pc),
        .instr(instr)
    );

    SEVEN_CVT  s_cvt(
        .clk(clk3),
        .val(pc),
        .enlight(A),
        .datalight(otp)
    );
endmodule
