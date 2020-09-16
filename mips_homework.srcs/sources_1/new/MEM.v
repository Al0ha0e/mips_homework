`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/05 09:40:29
// Design Name: 
// Module Name: MEM
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


module MEM(
    input wire                  rst,//

    input wire[5:0]             op,//

    //HI
    input wire                  we_hi_i,//
    input wire[`WORD_W]         wdata_hi_i,//
    //LO
    input wire                  we_lo_i,//
    input wire[`WORD_W]         wdata_lo_i,//
    //register file
    input wire                  we_i,//
    input wire[`REG_ADDR_W]     waddr_i,//
    input wire[`WORD_W]         wdata_i,//
    //memory
    //input wire                  ce_i,
    //input wire                  mem_we_i,
    input wire[`WORD_W]         mem_addr_i,//
    input wire[`WORD_W]         mem_wdata_i,//
    //input wire[3:0]             sel_i,
    input wire[`WORD_W]         mem_data_i,//

    //HI
    output reg                  we_hi_o,//
    output reg[`WORD_W]         wdata_hi_o,//
    //LO
    output reg                  we_lo_o,//
    output reg[`WORD_W]         wdata_lo_o,//
    //register file
    output reg                  we_o,//
    output reg[`REG_ADDR_W]     waddr_o,//
    output reg[`WORD_W]         wdata_o,//
    //memory
    output reg                  ce_o,//
    output reg                  mem_we_o,//
    output reg[`WORD_W]         mem_addr_o,//
    output reg[`WORD_W]         mem_wdata_o,//
    output reg[3:0]             sel_o//
);

always @(*) begin
    if(rst==`ENABLE_1) begin
        //HI
        we_hi_o <= `DISABLE_1;
        wdata_hi_o <= `ZERO_WORD;
        //LO
        we_lo_o <= `DISABLE_1;
        wdata_lo_o <= `ZERO_WORD;
        //register file
        we_o <= `DISABLE_1;
        waddr_o <= 5'b00000;
        wdata_o <= `ZERO_WORD;
        //memory
        ce_o <= `DISABLE_1;
        mem_we_o <= `DISABLE_1;
        mem_addr_o <= `ZERO_WORD;
        mem_wdata_o <= `ZERO_WORD;
        sel_o <= 4'b0000;
    end else begin
        we_hi_o <= we_hi_i;
        wdata_hi_o <= wdata_hi_i;
        we_lo_o <= we_lo_i;
        wdata_lo_o <= wdata_lo_i;

        we_o <= we_i;
        waddr_o <= waddr_i;
        
        if ((op==`OP_LB)||(op==`OP_LBU)||(op==`OP_LH)||(op==`OP_LHU)||(op==`OP_LW)||(op==`OP_LWL)||(op==`OP_LWR)) begin
            ce_o <= `ENABLE_1;
            mem_we_o <= `DISABLE_1;
            mem_addr_o <= {mem_addr_i[31:2], 2'b00};
            mem_wdata_o <= `ZERO_WORD;
            sel_o <= 4'b0000;
            case (op)
                `OP_LB: begin
                    case (mem_addr_i[1:0])
                        2'b00: wdata_o <= {{24{mem_data_i[31]}},mem_data_i[31:24]};
                        2'b01: wdata_o <= {{24{mem_data_i[23]}},mem_data_i[23:16]};
                        2'b10: wdata_o <= {{24{mem_data_i[15]}},mem_data_i[15:8]};
                        2'b11: wdata_o <= {{24{mem_data_i[7]}},mem_data_i[7:0]};
                        default: wdata_o <= wdata_i;
                    endcase
                end
                `OP_LBU: begin
                    case (mem_addr_i[1:0])
                        2'b00: wdata_o <= {{24{1'b0}},mem_data_i[31:24]};
                        2'b01: wdata_o <= {{24{1'b0}},mem_data_i[23:16]};
                        2'b10: wdata_o <= {{24{1'b0}},mem_data_i[15:8]};
                        2'b11: wdata_o <= {{24{1'b0}},mem_data_i[7:0]};
                        default: wdata_o <= wdata_i;
                    endcase
                end
                `OP_LH: begin
                    case (mem_addr_i[1:0])
                        2'b00: wdata_o <= {{16{mem_data_i[31]}},mem_data_i[31:16]};
                        2'b10: wdata_o <= {{16{mem_data_i[15]}},mem_data_i[15:0]};
                        default: wdata_o <= wdata_i;
                    endcase
                end
                `OP_LHU: begin
                    case (mem_addr_i[1:0])
                        2'b00: wdata_o <= {{16{1'b0}},mem_data_i[31:16]};
                        2'b10: wdata_o <= {{16{1'b0}},mem_data_i[15:0]};
                        default: wdata_o <= wdata_i;
                    endcase
                end
                `OP_LW: wdata_o <= mem_data_i;
                `OP_LWL: begin
                    case (mem_addr_i[1:0])
                        2'b00: wdata_o <= mem_data_i;
                        2'b01: wdata_o <= {mem_data_i[23:0],wdata_i[7:0]};
                        2'b10: wdata_o <= {mem_data_i[15:0],wdata_i[15:0]};
                        2'b11: wdata_o <= {mem_data_i[7:0],wdata_i[23:0]};
                        default: wdata_o <= wdata_i;
                    endcase
                end
                `OP_LWR: begin
                    case (mem_addr_i[1:0])
                        2'b00: wdata_o <= {wdata_i[31:8],mem_data_i[31:24]};
                        2'b01: wdata_o <= {wdata_i[31:16],mem_data_i[31:16]};
                        2'b10: wdata_o <= {wdata_i[31:24],mem_data_i[31:8]};
                        2'b11: wdata_o <= mem_data_i[7:0];
                        default: wdata_o <= wdata_i;
                    endcase
                end 
            endcase
        end else begin
            wdata_o <= wdata_i;
            case (op)
                `OP_SB: begin
                    ce_o <= `ENABLE_1;
                    mem_we_o <= `ENABLE_1;
                    mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                    mem_wdata_o <= {mem_wdata_i[7:0],mem_wdata_i[7:0],mem_wdata_i[7:0],mem_wdata_i[7:0]};
                    case (mem_addr_i[1:0])
                        2'b00: sel_o <= 4'b1000;
                        2'b01: sel_o <= 4'b0100;
                        2'b10: sel_o <= 4'b0010;
                        2'b11: sel_o <= 4'b0001;
                        default: sel_o <= 4'b0000;
                    endcase
                end
                `OP_SH: begin
                    ce_o <= `ENABLE_1;
                    mem_we_o <= `ENABLE_1;
                    mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                    mem_wdata_o <= {mem_wdata_i[15:0],mem_wdata_i[15:0]};
                    case (mem_addr_i[1:0])
                        2'b00: sel_o <= 4'b1100;
                        2'b10: sel_o <= 4'b0011;
                        default: sel_o <= 4'b0000;
                    endcase
                end
                `OP_SW: begin
                    ce_o <= `ENABLE_1;
                    mem_we_o <= `ENABLE_1;
                    mem_addr_o <= mem_addr_i;
                    mem_wdata_o <= mem_wdata_i;
                    sel_o <= 4'b1111;
                end
                `OP_SWL: begin
                    ce_o <= `ENABLE_1;
                    mem_we_o <= `ENABLE_1;
                    mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                    case (mem_addr_i[1:0])
                        2'b00: begin
                            mem_wdata_o <= mem_wdata_i;
                            sel_o <= 4'b1111;
                        end
                        2'b01: begin
                            mem_wdata_o <= {`ZERO_1,mem_wdata_i[31:8]};
                            sel_o <= 4'b0111;
                        end
                        2'b10: begin
                            mem_wdata_o <= {`ZERO_2,mem_wdata_i[31:16]};
                            sel_o <= 4'b0011;
                        end
                        2'b11: begin
                            mem_wdata_o <= {`ZERO_3,mem_wdata_i[31:24]};
                            sel_o <= 4'b0001;
                        end 
                        default: begin
                            mem_wdata_o <= `ZERO_WORD;
                            sel_o <= 4'b0000;
                        end
                    endcase
                end
                `OP_SWR: begin
                    ce_o <= `ENABLE_1;
                    mem_we_o <= `ENABLE_1;
                    mem_addr_o <= {mem_addr_i[31:2], 2'b00};
                    case (mem_addr_i[1:0])
                        2'b00: begin
                            mem_wdata_o <= {mem_data_i[7:0],`ZERO_3};
                            sel_o <= 4'b1000;
                        end
                        2'b01: begin
                            mem_wdata_o <= {mem_wdata_i[15:0],`ZERO_2};
                            sel_o <= 4'b1100;
                        end
                        2'b10: begin
                            mem_wdata_o <= {mem_wdata_i[23:0],`ZERO_1};
                            sel_o <= 4'b1110;
                        end
                        2'b11: begin
                            mem_wdata_o <= mem_wdata_i;
                            sel_o <= 4'b1111;
                        end 
                        default: begin
                            mem_wdata_o <= `ZERO_WORD;
                            sel_o <= 4'b0000;
                        end
                    endcase
                end
                default: begin
                    ce_o <= `DISABLE_1;
                    mem_we_o <= `DISABLE_1;
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    sel_o <= 4'b0000;
                end
            endcase
        end
    end
end

endmodule