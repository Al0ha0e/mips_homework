`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/05 19:59:09
// Design Name: 
// Module Name: EX
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


module EX(
    input wire                  rst,//

    input wire[5:0]             op_i,//
    input wire[5:0]             funct,//
    input wire[4:0]             shamt,//

    input wire[`REG_ADDR_W]     op1_reg,//
    input wire[`REG_ADDR_W]     op2_reg,//
    input wire[`WORD_W]         op1,//
    input wire[`WORD_W]         op2,//
    input wire[`WORD_W]         hi_i,//
    input wire[`WORD_W]         lo_i,//

    input wire                  we_hi_i,//
    input wire                  we_lo_i,//

    input wire                  we_i,//
    input wire[`REG_ADDR_W]     waddr_i,//
    input wire[`WORD_W]         mem_wdata_i,//

    output reg[5:0]             op_o,//
    //HI
    output reg                  we_hi_o,//
    output reg[`WORD_W]         wdata_hi_o,//
    //LO
    output reg                  we_lo_o,//
    output reg[`WORD_W]         wdata_lo_o,//
    //register file
    output reg                  we_o,//
    output reg[`REG_ADDR_W]     waddr_o,//
    //memory
    output reg[`WORD_W]         mem_addr_o,//
    output reg[`WORD_W]         mem_wdata_o,//

    output reg[`WORD_W]         alu_otp_o//
    );

wire[`WORD_W] op1_not;
wire[`WORD_W] op1_compl;
wire[`WORD_W] op2_compl;
wire[`WORD_W] calc_and;
wire[`WORD_W] calc_or;
wire[`WORD_W] calc_xor;
wire[`WORD_W] calc_nor;
wire[`WORD_W] calc_sl;
wire[`WORD_W] calc_sr_l;
wire[`WORD_W] calc_sr_a;
wire[`WORD_W] calc_plus;
wire          calc_plus_overflow;
wire[`WORD_W] calc_minus;
wire          calc_minus_overflow;
wire[`WORD_W] calc_lt_s;
wire[`WORD_W] calc_lt_u;
wire[63:0] calc_mul_t;
wire[63:0] calc_mul_s;
wire[63:0] calc_mul_u;

assign op1_not = ~op1;
assign op1_compl = op1_not+1;
assign op2_compl = (~op2)+1;
assign calc_and  = op1 & op2;
assign calc_or   = op1 | op2;
assign calc_xor  = op1 ^ op2;
assign calc_nor  = ~calc_or;
assign calc_sl   = op1 << shamt;
assign calc_sr_l = op1 >> shamt;
assign calc_sr_a = ($signed(op1)) >>> shamt;
assign calc_plus = op1 + op2;
assign calc_plus_overflow = (op1[31] && op2[31] && !calc_plus[31])||(!op1[31] && !op2[31] && calc_plus[31]);
assign calc_minus = op1 + op2_compl;
assign calc_minus_overflow = (op1[31] && op2_compl[31] && !calc_minus[31])||(!op1[31] && !op2_compl[31] && calc_minus[31]);
assign calc_lt_s = (op1[31] && !op2[31]) || (!op1[31] && !op2[31] && calc_minus[31]) || (op1[31] && op2[31] && calc_minus[31]);
assign calc_lt_u = op1 < op2;
assign calc_mul_t = (op1[31]==1'b1 ? op1_compl : op1) * (op2[31]==1'b1 ? op2_compl : op2);
assign calc_mul_s = (op1[31] ^ op2[31]) == 1'b1 ? (~calc_mul_t) + 1 : calc_mul_t;
assign calc_mul_u = op1 * op2;

always @(*) begin
    if (rst||(op_i==`OP_SPECIAL && funct==`FUNCT_NOP)) begin
        op_o <= 6'b000000;
        we_hi_o <= `DISABLE_1;
        wdata_hi_o <= `ZERO_WORD;
        we_lo_o <= `DISABLE_1;
        wdata_lo_o <= `ZERO_WORD;
        we_o <= `DISABLE_1;
        waddr_o <= 5'b00000;
        mem_addr_o <= `ZERO_WORD;
        mem_wdata_o <= `ZERO_WORD;
        alu_otp_o <= `ZERO_WORD;
    end else if(((op_i==`OP_SPECIAL)&&(funct==`FUNCT_ADD || funct==`FUNCT_SUB)) ||(op_i==`OP_ADDI)) begin
        op_o <= op_i;
        we_hi_o <= we_hi_i;
        wdata_hi_o <= `ZERO_WORD;
        we_lo_o <= we_lo_i;
        wdata_lo_o <= `ZERO_WORD;
        waddr_o <= waddr_i;
        mem_addr_o <= `ZERO_WORD;
        mem_wdata_o <= `ZERO_WORD;
        if(funct==`FUNCT_ADD || op_i==`OP_ADDI)begin
            if (calc_plus_overflow) begin
                we_o <= `DISABLE_1;
                alu_otp_o <= `ZERO_WORD;
            end else begin 
                we_o <= `ENABLE_1;
                alu_otp_o <= calc_plus;
            end
        end else if(funct==`FUNCT_SUB) begin
            if (calc_minus_overflow) begin
                we_o <= `DISABLE_1;
                alu_otp_o <= `ZERO_WORD;
            end else begin
                we_o <= `ENABLE_1;
                alu_otp_o <= calc_minus;
            end
        end
    end else begin
        op_o <= op_i;
        we_hi_o <=we_hi_i;
        we_lo_o <= we_lo_i;
        we_o <= we_i;
        waddr_o <= waddr_i;
        if((op_i==`OP_SPECIAL) && //write hi/lo
        ((funct==`FUNCT_MTHI)||(funct==`FUNCT_MTLO)||(funct==`FUNCT_MULT)||(funct==`FUNCT_MULTU))) begin //write hi/lo
            mem_addr_o <= `ZERO_WORD;
            mem_wdata_o <= `ZERO_WORD;
            alu_otp_o <= `ZERO_WORD;
            case (funct)
                `FUNCT_MTHI: begin
                    wdata_hi_o <= op1;
                    wdata_lo_o <= `ZERO_WORD;
                end
                `FUNCT_MTLO: begin
                    wdata_hi_o <= `ZERO_WORD;
                    wdata_lo_o <= op1; 
                end
                `FUNCT_MULT: begin
                    wdata_hi_o <= calc_mul_s[63:32];
                    wdata_lo_o <= calc_mul_s[31:0];    
                end
                `FUNCT_MULTU: begin
                    wdata_hi_o <= calc_mul_u[63:32];
                    wdata_lo_o <= calc_mul_u[31:0];   
                end
                default: begin
                    wdata_hi_o <= `ZERO_WORD;
                    wdata_lo_o <= `ZERO_WORD;
                end
            endcase
        end else begin
            wdata_hi_o <= `ZERO_WORD;
            wdata_lo_o <= `ZERO_WORD;
            case (op_i)
                `OP_SPECIAL: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    case (funct)
                        `FUNCT_AND: alu_otp_o <= calc_and;
                        `FUNCT_OR: alu_otp_o <= calc_or;
                        `FUNCT_XOR: alu_otp_o <= calc_xor;
                        `FUNCT_NOR: alu_otp_o <= calc_nor;
                        `FUNCT_SLL: alu_otp_o <= calc_sl;
                        `FUNCT_SRL: alu_otp_o <= calc_sr_l;
                        `FUNCT_SRA: alu_otp_o <= calc_sr_a;
                        `FUNCT_SLLV: alu_otp_o <= calc_sl;
                        `FUNCT_SRLV: alu_otp_o <= calc_sr_l;
                        `FUNCT_SRAV: alu_otp_o <= calc_sr_a;
                        `FUNCT_MOVN: alu_otp_o <= op1;
                        `FUNCT_MOVZ: alu_otp_o <= op1;
                        `FUNCT_MFHI: alu_otp_o <= hi_i;
                        `FUNCT_MFLO: alu_otp_o <= lo_i;
                        `FUNCT_ADDU: alu_otp_o <= calc_plus;
                        `FUNCT_SUBU: alu_otp_o <= calc_minus;
                        `FUNCT_SLT: alu_otp_o <= calc_lt_s;
                        `FUNCT_SLTU: alu_otp_o <= calc_lt_u;
                        `FUNCT_JR: alu_otp_o <= `ZERO_WORD;
                        `FUNCT_JALR: alu_otp_o <= calc_plus;
                    endcase
                end
                `OP_ANDI: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= calc_and;
                end
                `OP_ORI: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= calc_or;
                end
                `OP_XORI:begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= calc_xor;
                end
                `OP_LUI: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= op2;
                end
                `OP_ADDIU: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= calc_plus;
                end
                `OP_SLTI: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= calc_lt_s;
                end
                `OP_SLTIU: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= calc_lt_u;
                end
                `OP_SPECIAL2: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    case (funct)
                        `FUNCT_CLZ: begin
                            alu_otp_o <= (op1_not[31] ? 0 :
                            op1_not[30] ? 1:
                            op1_not[29] ? 2:
                            op1_not[28] ? 3:
                            op1_not[27] ? 4:
                            op1_not[26] ? 5:
                            op1_not[25] ? 6:
                            op1_not[24] ? 7:
                            op1_not[23] ? 8:
                            op1_not[22] ? 9:
                            op1_not[21] ? 10:
                            op1_not[20] ? 11:
                            op1_not[19] ? 12:
                            op1_not[18] ? 13:
                            op1_not[17] ? 14:
                            op1_not[16] ? 15:
                            op1_not[15] ? 16:
                            op1_not[14] ? 17:
                            op1_not[13] ? 18:
                            op1_not[12] ? 19:
                            op1_not[11] ? 20:
                            op1_not[10] ? 21:
                            op1_not[9] ? 22:
                            op1_not[8] ? 23:
                            op1_not[7] ? 24:
                            op1_not[6] ? 25:
                            op1_not[5] ? 26:
                            op1_not[4] ? 27:
                            op1_not[3] ? 28:
                            op1_not[2] ? 29:
                            op1_not[1] ? 30:
                            op1_not[0] ? 31: 32);
                        end
                        `FUNCT_CLO: begin
                            alu_otp_o <= (op1[31] ? 0 :
                            op1[30] ? 1:
                            op1[29] ? 2:
                            op1[28] ? 3:
                            op1[27] ? 4:
                            op1[26] ? 5:
                            op1[25] ? 6:
                            op1[24] ? 7:
                            op1[23] ? 8:
                            op1[22] ? 9:
                            op1[21] ? 10:
                            op1[20] ? 11:
                            op1[19] ? 12:
                            op1[18] ? 13:
                            op1[17] ? 14:
                            op1[16] ? 15:
                            op1[15] ? 16:
                            op1[14] ? 17:
                            op1[13] ? 18:
                            op1[12] ? 19:
                            op1[11] ? 20:
                            op1[10] ? 21:
                            op1[9] ? 22:
                            op1[8] ? 23:
                            op1[7] ? 24:
                            op1[6] ? 25:
                            op1[5] ? 26:
                            op1[4] ? 27:
                            op1[3] ? 28:
                            op1[2] ? 29:
                            op1[1] ? 30:
                            op1[0] ? 31: 32);
                        end
                        `FUNCT_MUL: alu_otp_o <= calc_mul_s[31:0];
                    endcase
                end
                `OP_J: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= `ZERO_WORD;
                end
                `OP_JAL: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= calc_plus;
                end
                `OP_BEQ,`OP_BGTZ,`OP_BLEZ,`OP_BNE: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= `ZERO_WORD;
                end
                `OP_REGIMM: begin
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    case (op2_reg)
                        5'b00000: alu_otp_o <= `ZERO_WORD;
                        5'b10000: alu_otp_o <= calc_plus;
                        5'b00001: alu_otp_o <= `ZERO_WORD;
                        5'b10001: alu_otp_o <= calc_plus;
                    endcase
                end
                `OP_LB,`OP_LBU,`OP_LH,`OP_LHU,`OP_LW,`OP_LWL,`OP_LWR: begin
                    mem_addr_o <= calc_plus;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= calc_plus;
                end
                `OP_SB,`OP_SH,`OP_SW,`OP_SWL,`OP_SWR: begin
                    mem_addr_o <= calc_plus;
                    mem_wdata_o <= mem_wdata_i;
                    alu_otp_o <= calc_plus;
                end
                default: begin
                    op_o <= 6'b000000;
                    we_hi_o <= `DISABLE_1;
                    wdata_hi_o <= `ZERO_WORD;
                    we_lo_o <= `DISABLE_1;
                    wdata_lo_o <= `ZERO_WORD;
                    we_o <= `DISABLE_1;
                    waddr_o <= 5'b00000;
                    mem_addr_o <= `ZERO_WORD;
                    mem_wdata_o <= `ZERO_WORD;
                    alu_otp_o <= `ZERO_WORD;
                end
            endcase
        end
    end
end

endmodule
