module digit_display(
    input clk_led1,
    input clk_led2,
    input [1:0] state,
    input [1:0] light_mode,
    input [11:0] bottle_max,
    input [11:0] bottle_cur,
    input [11:0] pill_max,
    input [11:0] pill_cur,
    input [27:0] pill_tot,
    input [3:0] digit_choice,
    output [7:0] enlight,
    output [7:0] datalight
);

//数码管使能和数据
integer light_cnt = 0;//数码管循环计数
reg [7:0] enlight_r = 8'b00000000;//数码管使能
reg [31:0] light_r = 32'b00000000000000000000000000000000;//数码管全数位数据前值
reg [3:0] datalight_r = 4'b0000;//单数位数据前值
reg [7:0] datalight_r_r = 8'b00000000;//数据显示信号

//数码管显示
always@(posedge clk_led1)
begin
    //数码管显示全数位前值赋值
    if( state == 2'b10 || state == 2'b11)//加药片模式
    begin  
        if(light_mode == 2'b00 || light_mode == 2'b11) //初始状态
        begin
            light_r = {bottle_max, 8'b11111111, pill_max};
        end
        else if(light_mode == 2'b01)//当前状态
        begin
            light_r = {bottle_cur, 8'b11111111, pill_cur};
        end
        else if(light_mode == 2'b10)//当前总药片数
        begin
            light_r = {4'b1111, pill_tot};
        end
    end
    else if(state == 2'b01 )//置数模式
        light_r = {bottle_max, 8'b11111111, pill_max};
    else //其它
    begin
        light_r = 32'b11111111111111111111111111111111;
    end
    
    //数码管显示单数位显示
    light_cnt = (light_cnt + 1)%8;//数位选择

    //单数位使能
    if((state == 2'b01) && (digit_choice > 4'b0000 && digit_choice < 4'b1001 && digit_choice != 4'b0100 && digit_choice != 4'b0101) && (light_cnt == digit_choice - 1) && clk_led2) //置数状态且数位选择有效
        enlight_r = 8'b00000000;
    else
        enlight_r = 8'b00000001 << light_cnt;

    //单数位赋值
    case(light_cnt)
        0: datalight_r = light_r[3 : 0];
        1: datalight_r = light_r[7 : 4];
        2: datalight_r = light_r[11: 8];
        3: datalight_r = light_r[15: 12];
        4: datalight_r = light_r[19: 16];
        5: datalight_r = light_r[23: 20];
        6: datalight_r = light_r[27: 24];
        7: datalight_r = light_r[31: 28];
    endcase
    //单数位译码
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
        default: datalight_r_r = 8'b01000000;//G
    endcase
end

//低有效，按位取反
assign enlight = ~enlight_r;
assign datalight = ~datalight_r_r;

endmodule
