`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/12 22:41:24
// Design Name: 
// Module Name: test_cpu
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


module test_cpu;

    reg clk;
    reg rst;
    wire[31:0] instr;
    wire[31:0] pc;

    initial begin
        clk = 0;
        rst = 1'b1;
        #40
        rst = 1'b0;
    end

    always #20 clk <= ~clk;

    CPU cpu(
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .instr_addr(pc)
    );
    INSTR_MEM ins_mem(
        .pc(pc),
        .instr(instr)
    );
endmodule
