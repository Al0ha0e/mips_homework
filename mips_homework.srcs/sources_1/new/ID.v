`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/08 14:26:35
// Design Name: 
// Module Name: ID
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


module ID(
    input wire                  rst,//

    input wire[`WORD_W]         instr,//
    input wire[`WORD_W]         pc_i,//
    input wire[`WORD_W]         op1_i,//
    input wire[`WORD_W]         op2_i,//

    output reg[5:0]             op_o,//
    output reg[5:0]             funct_o,//
    output reg[4:0]             shamt_o,//

    output reg[`REG_ADDR_W]     op1_reg_o,//
    output reg[`REG_ADDR_W]     op2_reg_o,//
    output reg[`WORD_W]         op1_o,//
    output reg[`WORD_W]         op2_o,//

    output reg                  we_hi_o,//
    output reg                  we_lo_o,//

    output reg                  we_o,//
    output reg[`REG_ADDR_W]     waddr_o,//
    output reg[`WORD_W]         mem_wdata_o,//

    output reg[`WORD_W]         pc_o,//
    output reg                  pc_we,//

    output reg                  curr_mem//
    );

wire[`WORD_W] pcp4; 
wire[5:0] instr_op;
wire[`REG_ADDR_W] instr_rs;
wire[`REG_ADDR_W] instr_rt;
wire[`REG_ADDR_W] instr_rd;
wire[`REG_ADDR_W] instr_shamt;
wire[5:0] instr_funct;
wire[15:0] instr_imm16;
wire[25:0] instr_imm26;
wire[`WORD_W] zex_imm16;
wire[`WORD_W] aex_imm16;
wire[`WORD_W] bex_imm16;

assign pcp4 = pc_i + 4;
assign instr_op = instr[31:26];
assign instr_rs = instr[25:21];
assign instr_rt = instr[20:16];
assign instr_rd = instr[15:11];
assign instr_shamt = instr[10:6];
assign instr_funct = instr[5:0];
assign instr_imm16 = instr[15:0];
assign instr_imm26 = instr[25:0];
assign zex_imm16 = {`ZERO_2, instr_imm16};
assign aex_imm16 = {{16{instr_imm16[15]}}, instr_imm16};
assign bex_imm16 = {{14{instr_imm16[15]}},instr_imm16,2'b00};

always @(*) begin
    if(rst == `ENABLE_1) begin
        op_o <= 6'b000000;
        funct_o <= 6'b000000;
        shamt_o <= 5'b00000;
        op1_reg_o <= 5'b00000;
        op2_reg_o <= 5'b00000;
        op1_o <= `ZERO_WORD;
        op2_o <= `ZERO_WORD;
        we_hi_o <= `DISABLE_1;
        we_lo_o <= `DISABLE_1;
        we_o <= `DISABLE_1;
        waddr_o <= 5'b00000;
        mem_wdata_o <= `ZERO_WORD;
        pc_o <= pc_i;
        pc_we <= `DISABLE_1;
        curr_mem <= `DISABLE_1;
    end else begin
        op_o <= instr_op;
        funct_o <= instr_funct;
        op1_reg_o <= instr_rs;
        op2_reg_o <= instr_rt;
        case (instr_op)
            `OP_SPECIAL: begin
                mem_wdata_o <= `ZERO_WORD;
                curr_mem <= `DISABLE_1;
                case (instr_funct)
                    `FUNCT_AND,`FUNCT_OR,`FUNCT_XOR,`FUNCT_NOR: begin
                        shamt_o <= instr_shamt;
                        op1_o <= op1_i;
                        op2_o <= op2_i;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `ENABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_SLL,`FUNCT_SRL,`FUNCT_SRA: begin
                        shamt_o <= instr_shamt;
                        op1_o <= op2_i;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `ENABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_SLLV,`FUNCT_SRLV,`FUNCT_SRAV: begin
                        shamt_o <= op1_i[4:0];
                        op1_o <= op2_i;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `ENABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_NOP: begin
                        shamt_o <= 5'b00000;
                        op1_o <= `ZERO_WORD;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `DISABLE_1;
                        waddr_o <= 5'b00000;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_MOVN: begin
                        shamt_o <= instr_shamt;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                        if(op2_i==`ZERO_WORD) begin
                            op1_o <= `ZERO_WORD;
                            we_o <= `DISABLE_1;
                        end else begin
                            op1_o <= op1_i;
                            we_o <= `ENABLE_1;
                        end
                    end
                    `FUNCT_MOVZ: begin
                        shamt_o <= instr_shamt;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                        if(op2_i==`ZERO_WORD) begin
                            op1_o <= op1_i;
                            we_o <= `ENABLE_1;
                        end else begin
                            op1_o <= `ZERO_WORD;
                            we_o <= `DISABLE_1;
                        end
                    end
                    `FUNCT_MFHI,`FUNCT_MFLO: begin
                        shamt_o <= instr_shamt;
                        op1_o <= `ZERO_WORD;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `ENABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_MTHI: begin
                        shamt_o <= instr_shamt;
                        op1_o <= op1_i;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `ENABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `DISABLE_1;
                        waddr_o <= 5'b00000;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_MTLO: begin
                        shamt_o <= instr_shamt;
                        op1_o <= op1_i;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `ENABLE_1;
                        we_o <= `DISABLE_1;
                        waddr_o <= 5'b00000;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_ADD,`FUNCT_ADDU,`FUNCT_SUB,`FUNCT_SUBU,`FUNCT_SLT,`FUNCT_SLTU: begin
                        shamt_o <= instr_shamt;
                        op1_o <= op1_i;
                        op2_o <= op2_i;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `ENABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_MULT,`FUNCT_MULTU: begin
                        shamt_o <= instr_shamt;
                        op1_o <= op1_i;
                        op2_o <= op2_i;
                        we_hi_o <= `ENABLE_1;
                        we_lo_o <= `ENABLE_1;
                        we_o <= `DISABLE_1;
                        waddr_o <= 5'b00000;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_JR: begin
                        shamt_o <= instr_shamt;
                        op1_o <= `ZERO_WORD;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `DISABLE_1;
                        waddr_o <= 5'b00000;
                        pc_o <= op1_i;
                        pc_we <= `ENABLE_1;
                    end
                    `FUNCT_JALR: begin
                        shamt_o <= instr_shamt;
                        op1_o <= pc_i;
                        op2_o <= 8;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `ENABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= op1_i;
                        pc_we <= `ENABLE_1;
                    end
                    default: begin
                        shamt_o <= 5'b00000;
                        op1_o <= `ZERO_WORD;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `DISABLE_1;
                        waddr_o <= 5'b00000;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                endcase
            end
            `OP_ANDI,`OP_ORI,`OP_XORI: begin
                shamt_o <= instr_shamt;
                op1_o <= op1_i;
                op2_o <= zex_imm16;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `ENABLE_1;
                waddr_o <= instr_rt;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= `ZERO_WORD;
                pc_we <= `DISABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_LUI: begin
                shamt_o <= instr_shamt;
                op1_o <= `ZERO_WORD;
                op2_o <= {instr_imm16,`ZERO_2};
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `ENABLE_1;
                waddr_o <= instr_rt;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= `ZERO_WORD;
                pc_we <= `DISABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_ADDI,`OP_SLTI,`OP_SLTIU: begin
                shamt_o <= instr_shamt;
                op1_o <= op1_i;
                op2_o <= aex_imm16;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `ENABLE_1;
                waddr_o <= instr_rt;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= `ZERO_WORD;
                pc_we <= `DISABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_ADDIU: begin
                shamt_o <= instr_shamt;
                op1_o <= op1_i;
                op2_o <= zex_imm16;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `ENABLE_1;
                waddr_o <= instr_rt;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= `ZERO_WORD;
                pc_we <= `DISABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_SPECIAL2: begin
                shamt_o <= instr_shamt;
                mem_wdata_o <= `ZERO_WORD;
                curr_mem <= `DISABLE_1;
                case(instr_funct)
                    `FUNCT_CLZ,`FUNCT_CLO: begin
                        op1_o <= op1_i;
                        op2_o <= `ZERO_WORD;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `ENABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                    `FUNCT_MUL: begin
                        op1_o <= op1_i;
                        op2_o <= op2_i;
                        we_hi_o <= `DISABLE_1;
                        we_lo_o <= `DISABLE_1;
                        we_o <= `ENABLE_1;
                        waddr_o <= instr_rd;
                        pc_o <= `ZERO_WORD;
                        pc_we <= `DISABLE_1;
                    end
                endcase
            end
            `OP_J: begin
                shamt_o <= instr_shamt;
                op1_o <= `ZERO_WORD;
                op2_o <= `ZERO_WORD;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `DISABLE_1;
                waddr_o <= 5'b00000;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= {pcp4[31:28],instr_imm26,2'b00};
                pc_we <= `ENABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_JAL: begin
                shamt_o <= instr_shamt;
                op1_o <= pc_i;
                op2_o <= 8;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `ENABLE_1;
                waddr_o <= 5'b11111;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= {pcp4[31:28],instr_imm26,2'b00};
                pc_we <= `ENABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_BEQ: begin
                shamt_o <= instr_shamt;
                op1_o <= `ZERO_WORD;
                op2_o <= `ZERO_WORD;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `DISABLE_1;
                waddr_o <= 5'b00000;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= op1_i == op2_i ? bex_imm16 : pcp4;
                pc_we <= `ENABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_BGTZ: begin
                shamt_o <= instr_shamt;
                op1_o <= `ZERO_WORD;
                op2_o <= `ZERO_WORD;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `DISABLE_1;
                waddr_o <= 5'b00000;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= (op1_i[31] == 1'b0) && (op1_i != `ZERO_WORD) ? bex_imm16 : pcp4;
                pc_we <= `ENABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_BLEZ: begin
                shamt_o <= instr_shamt;
                op1_o <= `ZERO_WORD;
                op2_o <= `ZERO_WORD;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `DISABLE_1;
                waddr_o <= 5'b00000;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= (op1_i[31] == 1'b1) || (op1_i == `ZERO_WORD) ? bex_imm16 : pcp4;
                pc_we <= `ENABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_BNE: begin
                shamt_o <= instr_shamt;
                op1_o <= `ZERO_WORD;
                op2_o <= `ZERO_WORD;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `DISABLE_1;
                waddr_o <= 5'b00000;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= op1_i != op2_i ? bex_imm16 : pcp4;
                pc_we <= `ENABLE_1;
                curr_mem <= `DISABLE_1;
            end
            `OP_REGIMM: begin
                shamt_o <= instr_shamt;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                pc_we <= `ENABLE_1;
                curr_mem <= `DISABLE_1;
                case(instr_rt)
                    5'b00000: begin //BLTZ
                        op1_o <= `ZERO_WORD;
                        op2_o <= `ZERO_WORD;
                        we_o <= `DISABLE_1;
                        waddr_o <= 5'b00000;
                        mem_wdata_o <= `ZERO_WORD;
                        pc_o <= op1_i[31] == 1'b1 ? bex_imm16 : pcp4;
                    end
                    5'b10000: begin //BLTZAL
                        op1_o <= pc_i;
                        op2_o <= 8;
                        we_o <= `ENABLE_1;
                        waddr_o <= 5'b11111;
                        mem_wdata_o <= `ZERO_WORD;
                        pc_o <= op1_i[31] == 1'b1 ? bex_imm16 : pcp4;
                    end
                    5'b00001: begin //BGEZ
                        op1_o <= `ZERO_WORD;
                        op2_o <= `ZERO_WORD;
                        we_o <= `DISABLE_1;
                        waddr_o <= 5'b00000;
                        mem_wdata_o <= `ZERO_WORD;
                        pc_o <= op1_i[31] == 1'b0 ? bex_imm16 : pcp4;
                    end
                    5'b10001: begin //BGEZAL BAL
                        op1_o <= pc_i;
                        op2_o <= 8;
                        we_o <= `ENABLE_1;
                        waddr_o <= 5'b11111;
                        mem_wdata_o <= `ZERO_WORD;
                        pc_o <= op1_i[31] == 1'b0 ? bex_imm16 : pcp4;
                    end
                endcase
            end
            `OP_LB,`OP_LBU,`OP_LH,`OP_LHU,`OP_LW,`OP_LWL,`OP_LWR: begin
                shamt_o <= instr_shamt;
                op1_o <= op1_i;
                op2_o <= aex_imm16;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `ENABLE_1;
                waddr_o <= instr_rt;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= `ZERO_WORD;
                pc_we <= `DISABLE_1;
                curr_mem <= `ENABLE_1;
            end
            `OP_SB,`OP_SH,`OP_SW,`OP_SWL,`OP_SWR: begin
                shamt_o <= instr_shamt;
                op1_o <= op1_i;
                op2_o <= aex_imm16;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `DISABLE_1;
                waddr_o <= 5'b00000;
                mem_wdata_o <= op2_i;
                pc_o <= `ZERO_WORD;
                pc_we <= `DISABLE_1;
                curr_mem <= `DISABLE_1;
            end
            default: begin
                shamt_o <= 5'b00000;
                op1_o <= `ZERO_WORD;
                op2_o <= `ZERO_WORD;
                we_hi_o <= `DISABLE_1;
                we_lo_o <= `DISABLE_1;
                we_o <= `DISABLE_1;
                waddr_o <= 5'b00000;
                mem_wdata_o <= `ZERO_WORD;
                pc_o <= `ZERO_WORD;
                pc_we <= `DISABLE_1;
                curr_mem <= `DISABLE_1;
            end
        endcase
    end
end

endmodule
