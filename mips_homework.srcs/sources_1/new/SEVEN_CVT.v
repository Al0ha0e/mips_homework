`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/13 22:58:54
// Design Name: 
// Module Name: SEVEN_CVT
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


module SEVEN_CVT(
        input wire  clk,
        input wire[31:0]    val,

        output [7:0] enlight,
        output [7:0] datalight
    );
    reg clk1;
    reg[19:0] clk_cnt;

integer light_cnt = 0;
reg [7:0] enlight_r = 8'b00000000;//数码管使�?
reg [3:0] datalight_r = 4'b0000;
reg [7:0] datalight_r_r = 8'b00000000;//数据显示信号
    
    //assign A = 8'b00000000;
    initial begin
        clk_cnt <= 20'b00000000000000000000;
        clk1 <= 1'b0;
    end

    always @(posedge clk) begin
        clk_cnt <= clk_cnt + 20'b00000000000000000001;
        if(clk_cnt==20'd1000) begin
            clk_cnt <= 20'b00000000000000000000;
            clk1 <= ~clk1;
        end
    end

    always @(posedge clk1) begin
        light_cnt = (light_cnt + 1)%8;//数位选择
        enlight_r = 8'b00000001 << light_cnt;
        case(light_cnt)
        0: datalight_r = val[3 : 0];
        1: datalight_r = val[7 : 4];
        2: datalight_r = val[11: 8];
        3: datalight_r = val[15: 12];
        4: datalight_r = val[19: 16];
        5: datalight_r = val[23: 20];
        6: datalight_r = val[27: 24];
        7: datalight_r = val[31: 28];
    endcase
    //单数位译�?
    case(datalight_r)
        4'b0000: datalight_r_r = 8'b00111111;//ABCDEF
        4'b0001: datalight_r_r = 8'b00000110;//BC
        4'b0010: datalight_r_r = 8'b01011011;//ABDEG
        4'b0011: datalight_r_r = 8'b01001111;//ABCDG
        4'b0100: datalight_r_r = 8'b01100110;//BCFG
        4'b0101: datalight_r_r = 8'b01101101;//ACDFG
        4'b0110: datalight_r_r = 8'b01111101;//ACDEFG
        4'b0111: datalight_r_r = 8'b00000111;//ABC
        4'b1000: datalight_r_r = 8'b01111111;//ABCDEFG
        4'b1001: datalight_r_r = 8'b01101111;//ABCFG
        4'b1010: datalight_r_r = 8'b00110111;
        4'b1011: datalight_r_r = 8'b01111100;
        4'b1100: datalight_r_r = 8'b01011000;
        4'b1101: datalight_r_r = 8'b01011110;
        4'b1110: datalight_r_r = 8'b01111001;
        4'b1111: datalight_r_r = 8'b01110001;
        default: datalight_r_r = 8'b01000000;//G
    endcase
    end
    //低有效，按位取反
assign enlight = ~enlight_r;
assign datalight = ~datalight_r_r;

endmodule