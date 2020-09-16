`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/13 20:29:01
// Design Name: 
// Module Name: soc_test
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


module soc_test;

reg clk1,clk2,rst,clk_rst,use_single;

always #1 clk1 <= ~clk1;

wire[7:0] A;
wire[7:0] otp;
wire[7:0] mem_wdata;

initial begin
    clk1 <= 1'b0;
    clk2 <= 1'b0;
    rst <= 1'b0;
    clk_rst <= 1'b0;
    use_single <= 1'b0;
    #80
    clk_rst <= 1'b1;
    #80
    rst <= 1'b1;
end

SOC soc(
    .rst(rst),
    .clk_rst(clk_rst),
    .clk1(clk1),
    .clk2(clk2),
    .use_single(use_single),
    .A(A),
    .otp(otp)//,
    //.mem_wadta(mem_wdata)
);


endmodule
