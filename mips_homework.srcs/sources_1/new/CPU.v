`timescale 1ns / 1ps
`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/09 21:22:31
// Design Name: 
// Module Name: CPU
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


module CPU(
    input wire                  clk,
    input wire                  rst,

    input wire[`WORD_W]         instr,
    output wire[`WORD_W]        instr_addr,
    output wire[7:0]        mem_wdata_o
    );

wire[`WORD_W]   pc_pc_pipctrl;
wire            pc_we_pc_pipctrl;
wire            pc_stall_pipctrl_pc;
wire[`WORD_W]   pc_o;
assign instr_addr = pc_o;

wire[`WORD_W]   instr_ifid_id;
wire[`WORD_W]   pc_ifid_id;

wire[`WORD_W]   op1_baksel_id;
wire[`WORD_W]   op2_baksel_id;
wire[`REG_ADDR_W]   op1reg_id_baksel;
wire[`REG_ADDR_W]   op2reg_id_baksel;
wire[`WORD_W]   op1_regfile_baksel;
wire[`WORD_W]   op2_regfile_baksel;

wire[5:0]   op_id_pipctrl;
wire[5:0]   funct_id_pipctrl;
wire[4:0]   shamt_id_pipctrl;   
wire[`WORD_W]   op1_id_pipctrl;
wire[`WORD_W]   op2_id_pipctrl;
wire    wehi_id_pipctrl;
wire    welo_id_pipctrl;
wire    we_id_pipctrl;
wire[`REG_ADDR_W]    waddr_id_pipctrl;
wire[`WORD_W]   memwdata_id_pipctrl;
wire[`WORD_W]   pc_id_pipctrl;
wire    pcwe_id_pipctrl;
wire    currmem_id_pipctrl;

wire[5:0]   op_pipctrl_idex;
wire[5:0]   funct_pipctrl_idex;
wire[4:0]   shamt_pipctrl_idex;
wire[`REG_ADDR_W]   op1reg_pipctrl_idex;
wire[`REG_ADDR_W]   op2reg_pipctrl_idex;
wire[`WORD_W]   op1_pipctrl_idex;
wire[`WORD_W]   op2_pipctrl_idex;
wire    wehi_pipctrl_idex;
wire    welo_pipctrl_idex;
wire    we_pipctrl_idex;
wire[`REG_ADDR_W]    waddr_pipctrl_idex;
wire[`WORD_W]   memwdata_pipctrl_idex;
wire    currmem_pipctrl_idex;
wire    currmem_idex_pipctrl;

    PC pc(//
        .clk(clk),
        .rst(rst),
        .pc_i(pc_pc_pipctrl),
        .pc_we(pc_we_pc_pipctrl),
        .pc_stall(pc_stall_pipctrl_pc),
        .pc_o(pc_o)
    );
wire[`REG_ADDR_W]   waddr_idex_ex;//PIP_CTRL
    PIP_CTRL pip_ctrl(//
        .op_i(op_id_pipctrl),
        .funct_i(funct_id_pipctrl),
        .shamt_i(shamt_id_pipctrl),
        .op1_reg_i(op1reg_id_baksel),
        .op2_reg_i(op2reg_id_baksel),
        .op1_i(op1_id_pipctrl),
        .op2_i(op2_id_pipctrl),
        .we_hi_i(wehi_id_pipctrl),
        .we_lo_i(welo_id_pipctrl),
        .we_i(we_id_pipctrl),
        .waddr_i(waddr_id_pipctrl),
        .mem_wdata_i(memwdata_id_pipctrl),
        .pc_i(pc_id_pipctrl),
        .pc_we_i(pcwe_id_pipctrl),
        .curr_mem_i(currmem_id_pipctrl),
        .prev_mem(currmem_idex_pipctrl),
        .prev_waddr(waddr_idex_ex),

        .op_o(op_pipctrl_idex),
        .funct_o(funct_pipctrl_idex),
        .shamt_o(shamt_pipctrl_idex),
        .op1_reg_o(op1reg_pipctrl_idex),
        .op2_reg_o(op2reg_pipctrl_idex),
        .op1_o(op1_pipctrl_idex),
        .op2_o(op2_pipctrl_idex),
        .we_hi_o(wehi_pipctrl_idex),
        .we_lo_o(welo_pipctrl_idex),
        .we_o(we_pipctrl_idex),
        .waddr_o(waddr_pipctrl_idex),
        .mem_wdata_o(memwdata_pipctrl_idex),

        .pc_o(pc_pc_pipctrl),
        .pc_we_o(pc_we_pc_pipctrl),

        .curr_mem_o(currmem_pipctrl_idex),
        .stall(pc_stall_pipctrl_pc)
    );

    IF_ID if_id(//
        .clk(clk),
        .rst(rst),
        .instr_i(instr),
        .pc_i(pc_o),
        .stall(pc_stall_pipctrl_pc),
        .instr_o(instr_ifid_id),
        .pc_o(pc_ifid_id)
    );

    ID id(//
        .rst(rst),
        .instr(instr_ifid_id),
        .pc_i(pc_ifid_id),
        .op1_i(op1_baksel_id),
        .op2_i(op2_baksel_id),

        .op_o(op_id_pipctrl),
        .funct_o(funct_id_pipctrl),
        .shamt_o(shamt_id_pipctrl),

        .op1_reg_o(op1reg_id_baksel),
        .op2_reg_o(op2reg_id_baksel),
        .op1_o(op1_id_pipctrl),
        .op2_o(op2_id_pipctrl),

        .we_hi_o(wehi_id_pipctrl),
        .we_lo_o(welo_id_pipctrl),
        .we_o(we_id_pipctrl),
        .waddr_o(waddr_id_pipctrl),
        .mem_wdata_o(memwdata_id_pipctrl),

        .pc_o(pc_id_pipctrl),
        .pc_we(pcwe_id_pipctrl),
        .curr_mem(currmem_id_pipctrl)
    );

wire    we_ex_exmem;//BAL_SEL
wire[`REG_ADDR_W]   waddr_ex_exmem;//BAL_SEL
wire[`WORD_W]   aluotp_ex_exmem;//BAL_SEL

wire    we_mem_memwb;//BAL_SEL
wire[`REG_ADDR_W]   waddr_mem_memwb;//BAK_SEL
wire[`WORD_W]   wdata_mem_memwb;//BAK_SEL

    BAK_SEL bak_sel(//
        .reg_ex_w(we_ex_exmem),
        .reg_ex_data(aluotp_ex_exmem),
        .reg_ex_addr(waddr_ex_exmem),

        .reg_mem_w(we_mem_memwb),
        .reg_mem_data(wdata_mem_memwb),
        .reg_mem_addr(waddr_mem_memwb),

        .reg1_addr(op1reg_id_baksel),
        .reg2_addr(op2reg_id_baksel),
        .reg1_data(op1_regfile_baksel),
        .reg2_data(op2_regfile_baksel),

        .op1(op1_baksel_id),
        .op2(op2_baksel_id)
    );

wire    we_wb_regfile;
wire[`REG_ADDR_W]   waddr_wb_regfile;
wire[`WORD_W]   wdata_wb_regfile;

    REG_FILE reg_file(//
        .clk(clk),
        .rst(rst),

        .we(we_wb_regfile),
        .waddr(waddr_wb_regfile),
        .wdata(wdata_wb_regfile),

        .raddr1(op1reg_id_baksel),
        .raddr2(op2reg_id_baksel),

        .data1(op1_regfile_baksel),
        .data2(op2_regfile_baksel)
    );

wire[5:0]   op_idex_ex;
wire[5:0]   funct_idex_ex;
wire[4:0]   shamt_idex_ex;
wire[`REG_ADDR_W]   op1reg_idex_ex;
wire[`REG_ADDR_W]   op2reg_idex_ex;
wire[`WORD_W]   op1_idex_ex;
wire[`WORD_W]   op2_idex_ex;
wire    wehi_idex_ex;
wire    welo_idex_ex;
wire    we_idex_ex;
//wire[`REG_ADDR_W]   waddr_idex_ex;//PIP_CTRL
wire[`WORD_W]   memwdata_idex_ex;

    ID_EX id_ex(//
        .clk(clk),
        .rst(rst),

        .op_i(op_pipctrl_idex),
        .funct_i(funct_pipctrl_idex),
        .shamt_i(shamt_pipctrl_idex),
        .op1_reg_i(op1reg_pipctrl_idex),
        .op2_reg_i(op2reg_pipctrl_idex),
        .op1_i(op1_pipctrl_idex),
        .op2_i(op2_pipctrl_idex),
        .we_hi_i(wehi_pipctrl_idex),
        .we_lo_i(welo_pipctrl_idex),
        .we_i(we_pipctrl_idex),
        .waddr_i(waddr_pipctrl_idex),
        .mem_wdata_i(memwdata_pipctrl_idex),
        .curr_mem_i(currmem_pipctrl_idex),

        .op_o(op_idex_ex),
        .funct_o(funct_idex_ex),
        .shamt_o(shamt_idex_ex),

        .op1_reg_o(op1reg_idex_ex),
        .op2_reg_o(op2reg_idex_ex),
        .op1_o(op1_idex_ex),
        .op2_o(op2_idex_ex),
        .we_hi_o(wehi_idex_ex),
        .we_lo_o(welo_idex_ex),
        .we_o(we_idex_ex),
        .waddr_o(waddr_idex_ex),
        .mem_wdata_o(memwdata_idex_ex),

        .curr_mem_o(currmem_idex_pipctrl)
    );

wire    wehi_wb_hilo;
wire[`WORD_W]   wdatahi_wb_hilo;
wire    welo_wb_hilo;
wire[`WORD_W]   wdatalo_wb_hilo;

wire[`WORD_W]   hi_hilo_mulbak;
wire[`WORD_W]   lo_hilo_mulbak;
    HI_LO hi_lo(
        .clk(clk),
        .rst(rst),

        .we_hi(wehi_wb_hilo),
        .wdata_hi(wdatahi_wb_hilo),
        .we_lo(welo_wb_hilo),
        .wdata_lo(wdatalo_wb_hilo),

        .data_hi(hi_hilo_mulbak),
        .data_lo(lo_hilo_mulbak)
    );
wire    wehi_exmem_mem; //MUL_BAK
wire[`WORD_W]   wdatahi_exmem_mem; //MUL_BAK
wire    welo_exmem_mem; //MUL_BAK
wire[`WORD_W]   wdatalo_exmem_mem; //MUL_BAK

wire[`WORD_W]   hi_mulbak_ex;
wire[`WORD_W]   lo_mulbak_ex;
    MUL_BAK mul_bak(//
        .hi_mem_w(wehi_exmem_mem),
        .hi_mem_data(wdatahi_exmem_mem),

        .lo_mem_w(welo_exmem_mem),
        .lo_mem_data(wdatalo_exmem_mem),

        .hi_data(hi_hilo_mulbak),
        .lo_data(lo_hilo_mulbak),

        .hi(hi_mulbak_ex),
        .lo(lo_mulbak_ex)
    );

wire[5:0]   op_ex_exmem;
wire    wehi_ex_exmem;
wire[`WORD_W]   wdatahi_ex_exmem;
wire    welo_ex_exmem;
wire[`WORD_W]   wdatalo_ex_exmem;

//wire    we_ex_exmem; //BAK_SEL
//wire[`REG_ADDR_W]   waddr_ex_exmem; //BAK_SEL
wire[`WORD_W]   memaddr_ex_exmem;
wire[`WORD_W]   memwdata_ex_exmem;
//wire[`WORD_W]   aluotp_ex_exmem; //BAK_SEL

    EX ex(//
        .rst(rst),

        .op_i(op_idex_ex),
        .funct(funct_idex_ex),
        .shamt(shamt_idex_ex),

        .op1_reg(op1reg_idex_ex),
        .op2_reg(op2reg_idex_ex),
        .op1(op1_idex_ex),
        .op2(op2_idex_ex),
        .hi_i(hi_mulbak_ex),
        .lo_i(lo_mulbak_ex),

        .we_hi_i(wehi_idex_ex),
        .we_lo_i(welo_idex_ex),

        .we_i(we_idex_ex),
        .waddr_i(waddr_idex_ex),
        .mem_wdata_i(memwdata_idex_ex),

        .op_o(op_ex_exmem),
        .we_hi_o(wehi_ex_exmem),
        .wdata_hi_o(wdatahi_ex_exmem),
        .we_lo_o(welo_ex_exmem),
        .wdata_lo_o(wdatalo_ex_exmem),

        .we_o(we_ex_exmem),
        .waddr_o(waddr_ex_exmem),
        .mem_addr_o(memaddr_ex_exmem),
        .mem_wdata_o(memwdata_ex_exmem),
        .alu_otp_o(aluotp_ex_exmem)
    );

wire[5:0]   op_exmem_mem;
//wire    wehi_exmem_mem; //MUL_BAK
//wire[`WORD_W]   wdatahi_exmem_mem; //MUL_BAK
//wire    welo_exmem_mem; //MUL_BAK
//wire[`WORD_W]   wdatalo_exmem_mem; //MUL_BAK
wire    we_exmem_mem;
wire[`REG_ADDR_W]   waddr_exmem_mem;
wire[`WORD_W]   memaddr_exmem_mem;
wire[`WORD_W]   memwdata_exmem_mem;
wire[`WORD_W]   aluotp_exmem_mem;

    EX_MEM ex_mem(//
        .clk(clk),
        .rst(rst),

        .op_i(op_ex_exmem),
        .we_hi_i(wehi_ex_exmem),
        .wdata_hi_i(wdatahi_ex_exmem),
        .we_lo_i(welo_ex_exmem),
        .wdata_lo_i(wdatalo_ex_exmem),

        .we_i(we_ex_exmem),
        .waddr_i(waddr_ex_exmem),

        .mem_addr_i(memaddr_ex_exmem),
        .mem_wdata_i(memwdata_ex_exmem),
        .alu_otp_i(aluotp_ex_exmem),

        .op_o(op_exmem_mem),
        
        .we_hi_o(wehi_exmem_mem),
        .wdata_hi_o(wdatahi_exmem_mem),

        .we_lo_o(welo_exmem_mem),
        .wdata_lo_o(wdatalo_exmem_mem),

        .we_o(we_exmem_mem),
        .waddr_o(waddr_exmem_mem),
        .mem_addr_o(memaddr_exmem_mem),
        .mem_wdata_o(memwdata_exmem_mem),
        .alu_otp_o(aluotp_exmem_mem)
    );

wire[`WORD_W]   memdata_ram_mem;

wire    wehi_mem_memwb;
wire[`WORD_W]   wdatahi_mem_memwb;
wire    welo_mem_memwb;
wire[`WORD_W]   wdatalo_mem_memwb;
//wire    we_mem_memwb;//BAL_SEL
//wire[`REG_ADDR_W]   waddr_mem_memwb;//BAK_SEL
//wire[`WORD_W]   wdata_mem_memwb;//BAK_SEL

wire    ce_mem_ram;
wire    memwe_mem_ram;
wire[`WORD_W]    memaddr_mem_ram;
wire[`WORD_W]    memwdata_mem_ram;
wire[3:0]    sel_mem_ram;
assign mem_wdata_o = memwdata_mem_ram[7:0];
    MEM mem(//
        .rst(rst),

        .op(op_exmem_mem),
        .we_hi_i(wehi_exmem_mem),
        .wdata_hi_i(wdatahi_exmem_mem),
        .we_lo_i(welo_exmem_mem),
        .wdata_lo_i(wdatalo_exmem_mem),
        .we_i(we_exmem_mem),
        .waddr_i(waddr_exmem_mem),
        .wdata_i(aluotp_exmem_mem),
        .mem_addr_i(memaddr_exmem_mem),
        .mem_wdata_i(memwdata_exmem_mem),
        .mem_data_i(memdata_ram_mem),

        .we_hi_o(wehi_mem_memwb),
        .wdata_hi_o(wdatahi_mem_memwb),
        .we_lo_o(welo_mem_memwb),
        .wdata_lo_o(wdatalo_mem_memwb),

        .we_o(we_mem_memwb),
        .waddr_o(waddr_mem_memwb),
        .wdata_o(wdata_mem_memwb),

        .ce_o(ce_mem_ram),
        .mem_we_o(memwe_mem_ram),
        .mem_addr_o(memaddr_mem_ram),
        .mem_wdata_o(memwdata_mem_ram),
        .sel_o(sel_mem_ram)
    );

    RAM ram(//
        .clk(clk),
        .ce(ce_mem_ram),
        .we(memwe_mem_ram),
        .addr(memaddr_mem_ram),
        .wdata(memwdata_mem_ram),
        .sel(sel_mem_ram),
        .data(memdata_ram_mem)
    );

wire    wehi_memwb_wb;
wire[`WORD_W]   wdatahi_memwb_wb;
wire    welo_memwb_wb;
wire[`WORD_W]   wdatalo_memwb_wb;
wire    we_memwb_wb;
wire[`REG_ADDR_W]   waddr_memwb_wb;
wire[`WORD_W]   wdata_memwb_wb;


    MEM_WB mem_wb(
        .clk(clk),
        .rst(rst),
        .we_hi_i(wehi_mem_memwb),
        .wdata_hi_i(wdatahi_mem_memwb),
        .we_lo_i(welo_mem_memwb),
        .wdata_lo_i(wdatalo_mem_memwb),

        .we_i(we_mem_memwb),
        .waddr_i(waddr_mem_memwb),
        .wdata_i(wdata_mem_memwb),

        .we_hi_o(wehi_memwb_wb),
        .wdata_hi_o(wdatahi_memwb_wb),
        .we_lo_o(welo_memwb_wb),
        .wdata_lo_o(wdatalo_memwb_wb),

        .we_o(we_memwb_wb),
        .waddr_o(waddr_memwb_wb),
        .wdata_o(wdata_memwb_wb)
    );

    WB wb(
        .rst(rst),

        .we_hi_i(wehi_memwb_wb),
        .wdata_hi_i(wdatahi_memwb_wb),
        .we_lo_i(welo_memwb_wb),
        .wdata_lo_i(wdatalo_memwb_wb),

        .we_i(we_memwb_wb),
        .waddr_i(waddr_memwb_wb),
        .wdata_i(wdata_memwb_wb),

        .we_hi_o(wehi_wb_hilo),
        .wdata_hi_o(wdatahi_wb_hilo),
        .we_lo_o(welo_wb_hilo),
        .wdata_lo_o(wdatalo_wb_hilo),

        .we_o(we_wb_regfile),
        .waddr_o(waddr_wb_regfile),
        .wdata_o(wdata_wb_regfile)
    );

endmodule
