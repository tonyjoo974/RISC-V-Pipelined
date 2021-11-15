`define BAD_MUX_SEL $fatal("%0t %s %0d: Illegal mux select", $time, `__FILE__, `__LINE__)

import rv32i_types::*;
import pcmux::*;
import marmux::*;
import cmpmux::*;
import alumux::*;
import regfilemux::*;

/******************* Signals Needed for RVFI Monitor *************************/
// rv32i_word mdrreg_out;
rv32i_word mem_data_in;
// rv32i_word mem_addr;
logic trap;
logic [3:0] rmask, wmask;

module datapath
(
    input logic clk, rst,  
    input rv32i_word imem_rdata,
    input rv32i_word dmem_rdata,
    input logic imem_resp,
    input logic dmem_resp,
    output rv32i_word imem_address,
    output rv32i_word dmem_address,
    output rv32i_word dmem_wdata, // signal used by RVFI Monitor
    output logic [3:0] dmem_byte_enable, 
    output logic imem_read,
    output logic dmem_read,
    output logic dmem_write
    /* You will need to connect more signals to your datapath module*/
);


// INSTRUCTION FETCH

logic load_pc;
pcmux_sel_t pcmux_sel;
rv32i_word pcmux_out;
rv32i_word pc_out;

// INSTRUCTION DECODE

logic load_regfile;
rv32i_control_word ctrl;
rv32i_word rs1_out;
rv32i_word rs2_out;

// if_id register signals
logic if_id_load;
logic [2:0] funct3;
logic [6:0] funct7;
rv32i_opcode opcode;
rv32i_word if_id_pc_out;
rv32i_word if_id_i_imm;
rv32i_word if_id_s_imm;
rv32i_word if_id_b_imm;
rv32i_word if_id_u_imm;
rv32i_word if_id_j_imm;
rv32i_reg if_id_rs1;
rv32i_reg if_id_rs2;
rv32i_reg if_id_rd;
rv32i_word if_id_imem_rdata_out;

// EXECUTE

alumux1_sel_t alumux1_sel;
alumux2_sel_t alumux2_sel;
cmpmux_sel_t cmpmux_sel;
alu_ops aluop;
branch_funct3_t cmpop;
rv32i_word alu_out;
logic br_en;

rv32i_word alumux1_out;
rv32i_word alumux2_out;
rv32i_word cmp_mux_out;

// id_ex register signals
logic id_ex_load;
rv32i_word id_ex_pc_out;
rv32i_control_word id_ex_ctrl_out;
rv32i_control_word id_ex_ctrl_mux_out;
rv32i_word id_ex_rs1_data_out;
rv32i_word id_ex_rs2_data_out;
rv32i_reg id_ex_rs1_out;
rv32i_reg id_ex_rs2_out;
rv32i_reg id_ex_rd_out;
rv32i_word id_ex_i_imm_out;
rv32i_word id_ex_u_imm_out;
rv32i_word id_ex_b_imm_out;
rv32i_word id_ex_s_imm_out;
rv32i_word id_ex_j_imm_out;
rv32i_word id_ex_imem_rdata_out;


// MEM

// ex_mem register signals
logic do_br;
logic ex_mem_load;
rv32i_word ex_mem_pc_out;
rv32i_control_word ex_mem_ctrl_out;
rv32i_word ex_mem_alu_out;
rv32i_reg ex_mem_rs1_out;
rv32i_reg ex_mem_rs2_out;
rv32i_reg ex_mem_rd_out;
rv32i_word ex_mem_u_imm_out;
logic ex_mem_br_en_out;
// logic ex_mem_do_br_out;
rv32i_word ex_mem_mem_wdata;
rv32i_word ex_mem_imem_rdata_out;
rv32i_word ex_mem_rs1_data_out;
rv32i_word ex_mem_rs2_data_out;


// WB 

regfilemux_sel_t regfilemux_sel;
rv32i_word regfilemux_out;

// mem_wb register signals
logic mem_wb_load;
rv32i_word mem_wb_pc_out;
rv32i_control_word mem_wb_ctrl_out;
rv32i_word mem_wb_alu_out;
rv32i_reg mem_wb_rs1_out;
rv32i_reg mem_wb_rs2_out;
logic [4:0] mem_wb_rd_out;    
rv32i_word mem_wb_u_imm_out;
logic mem_wb_br_en_out;
logic mem_wb_do_br_out;
rv32i_word mem_wb_mdr_out;
rv32i_word mem_wb_imem_rdata_out;
logic mem_wb_trap_out;
rv32i_word mem_wb_rs1_data_out;
rv32i_word mem_wb_rs2_data_out;
logic [3:0] mem_wb_rmask_out;
logic [3:0] mem_wb_wmask_out;
rv32i_word mem_wb_dmem_address;
rv32i_word mem_wb_dmem_wdata;


// FORWARDING signals
logic [1:0] forwardA_sel;
logic [1:0] forwardB_sel;
logic forwardC_sel;
logic forwardD_sel;

rv32i_word forwardA_mux_out;
rv32i_word forwardB_mux_out;
rv32i_word forwardC_mux_out;
rv32i_word forwardD_mux_out;
regfilemux_sel_t regfilemux_ex_mem_sel;
rv32i_word regfilemux_ex_mem_out;


// HAZARD DETECTION signals
rv32i_word inst_mux_out;
logic stall_pipeline;
rv32i_control_word ctrl_mux_out;
rv32i_control_word ctrl_mux_out_br;

// Halt signal
// logic halt;

/*****************************************************************************/
/***************************** Registers *************************************/
// Keep Instruction register named `IR` for RVFI Monitor

pc_register PC(
    .clk(clk),
    .rst(rst),
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

// regfile and control ROM

regfile regfile(
    .clk(clk),
    .rst(rst),
    .load(load_regfile),
    .in(regfilemux_out),
    .src_a(if_id_rs1),
    .src_b(if_id_rs2),
    .dest(mem_wb_rd_out),
    .reg_a(rs1_out),
    .reg_b(rs2_out)
);

control_rom CONTROL_ROM(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .ctrl(ctrl)
);

// ALU and CMP

alu alu_inst(
      .aluop(aluop),
      .a(alumux1_out),
      .b(alumux2_out),
      .f(alu_out)
);

cmp cmp(
      .cmpop(cmpop),
      .a(forwardA_mux_out),
      .b(cmp_mux_out),
      .out(br_en)
);

// pipeline modules

if_id if_id (
    .clk(clk),
    .rst(rst),
    .if_id_load(if_id_load),
    .pc_in(pc_out),
    .imem_rdata(inst_mux_out),

    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode),
    .pc_out(if_id_pc_out),
    .i_imm(if_id_i_imm),
    .s_imm(if_id_s_imm),
    .b_imm(if_id_b_imm),
    .u_imm(if_id_u_imm),
    .j_imm(if_id_j_imm),
    .rs1(if_id_rs1),
    .rs2(if_id_rs2),
    .rd(if_id_rd),
    .imem_rdata_out(if_id_imem_rdata_out)
);

id_ex id_ex (
    .clk(clk),
    .rst(rst),
    .id_ex_load(id_ex_load),
    .pc_in(if_id_pc_out),
    .ctrl(ctrl_mux_out_br),
    .rs1_data_in(forwardC_mux_out), // from regfile
    .rs2_data_in(forwardD_mux_out), // from regfile
    .rs1_in(if_id_rs1),
    .rs2_in(if_id_rs2),
    .rd_in(if_id_rd),
    .i_imm(if_id_i_imm),
    .u_imm(if_id_u_imm),
    .b_imm(if_id_b_imm),
    .s_imm(if_id_s_imm),
    .j_imm(if_id_j_imm),
    .imem_rdata(if_id_imem_rdata_out),
    
    .pc_out(id_ex_pc_out),
    .ctrl_out(id_ex_ctrl_out),
    // .rs1_data_out(id_ex_rs1_data_out_prev),
    // .rs2_data_out(id_ex_rs2_data_out_prev),
    .rs1_data_out(id_ex_rs1_data_out),
    .rs2_data_out(id_ex_rs2_data_out),
    .rs1_out(id_ex_rs1_out),
    .rs2_out(id_ex_rs2_out),
    .rd_out(id_ex_rd_out),
    .i_imm_out(id_ex_i_imm_out),
    .u_imm_out(id_ex_u_imm_out),
    .b_imm_out(id_ex_b_imm_out),
    .s_imm_out(id_ex_s_imm_out),
    .j_imm_out(id_ex_j_imm_out),
    .imem_rdata_out(id_ex_imem_rdata_out)
);

ex_mem ex_mem (
    .clk(clk),
    .rst(rst),
    .ex_mem_load(ex_mem_load),
    .pc_in(id_ex_pc_out),
    .ctrl(id_ex_ctrl_mux_out),
    .alu_in(alu_out),
    .rs1_data_in(forwardA_mux_out),
    .rs2_data_in(forwardB_mux_out),
    .rs1_in(id_ex_rs1_out),
    .rs2_in(id_ex_rs2_out),
    .rd_in(id_ex_rd_out),
    .u_imm_in(id_ex_u_imm_out),
    .br_en_in(br_en),
    // .do_br_in(do_br),
    .dmem_wdata_in(mem_data_in),
    .imem_rdata(id_ex_imem_rdata_out),

    .pc_out(ex_mem_pc_out),
    .ctrl_out(ex_mem_ctrl_out),
    .alu_out(ex_mem_alu_out),
    .rs1_data_out(ex_mem_rs1_data_out),
    .rs2_data_out(ex_mem_rs2_data_out),
    .rs1_out(ex_mem_rs1_out),
    .rs2_out(ex_mem_rs2_out),
    .rd_out(ex_mem_rd_out),    
    .u_imm_out(ex_mem_u_imm_out),
    .br_en_out(ex_mem_br_en_out),
    // .do_br_out(ex_mem_do_br_out),
    .dmem_wdata_out(ex_mem_mem_wdata),
    .imem_rdata_out(ex_mem_imem_rdata_out)
);

mem_wb mem_wb (
    .clk(clk),
    .rst(rst),
    .mem_wb_load(mem_wb_load),
    .pc_in(ex_mem_pc_out),
    .ctrl(ex_mem_ctrl_out),
    .alu_in(ex_mem_alu_out),
    .rs1_data_in(ex_mem_rs1_data_out),
    .rs2_data_in(ex_mem_rs2_data_out),
    .rs1_in(ex_mem_rs1_out),
    .rs2_in(ex_mem_rs2_out),
    .rd_in(ex_mem_rd_out),
    .u_imm_in(ex_mem_u_imm_out),
    .br_en_in(ex_mem_br_en_out),
    .do_br_in(do_br),
    .mem_rdata(dmem_rdata),
    .imem_rdata(ex_mem_imem_rdata_out),
    .trap(trap),
    .rmask_in(rmask),
    .wmask_in(wmask),
    .dmem_address_in(dmem_address),
    .dmem_wdata_in(dmem_wdata),

    .pc_out(mem_wb_pc_out),
    .ctrl_out(mem_wb_ctrl_out),
    .alu_out(mem_wb_alu_out),
    .rs1_data_out(mem_wb_rs1_data_out),
    .rs2_data_out(mem_wb_rs2_data_out),
    .rs1_out(mem_wb_rs1_out),
    .rs2_out(mem_wb_rs2_out),
    .rd_out(mem_wb_rd_out),    
    .u_imm_out(mem_wb_u_imm_out),
    .br_en_out(mem_wb_br_en_out),
    .do_br_out(mem_wb_do_br_out),
    .mdr_out(mem_wb_mdr_out),
    .imem_rdata_out(mem_wb_imem_rdata_out),
    .trap_out(mem_wb_trap_out),
    .rmask_out(mem_wb_rmask_out),
    .wmask_out(mem_wb_wmask_out),
    .dmem_address_out(mem_wb_dmem_address),
    .dmem_wdata_out(mem_wb_dmem_wdata)
);

// forwarding, hazard detection
forwarding forwarding (
    .ex_mem_rd_out(ex_mem_rd_out),
    .mem_wb_rd_out(mem_wb_rd_out),
    .if_id_rs1_out(if_id_rs1),
    .if_id_rs2_out(if_id_rs2),
    .id_ex_rs1_out(id_ex_rs1_out),
    .id_ex_rs2_out(id_ex_rs2_out),
    .ex_mem_ctrl_out(ex_mem_ctrl_out),
    .mem_wb_ctrl_out(mem_wb_ctrl_out),
    
    .forwardA_sel(forwardA_sel),
    .forwardB_sel(forwardB_sel),
    .forwardC_sel(forwardC_sel),
    .forwardD_sel(forwardD_sel)
);


hazard_detection hazard_detection(
    .if_id_rs1_out(if_id_rs1),
    .if_id_rs2_out(if_id_rs2),
    .id_ex_rd_out(id_ex_rd_out),
    .id_ex_ctrl_out(id_ex_ctrl_out),
    
    .stall_pipeline(stall_pipeline)
);

// control signals

function void set_default_load();
    load_pc = 1'b1;
    load_regfile = mem_wb_ctrl_out.load_regfile;
    if_id_load = 1'b1;
    id_ex_load = 1'b1;
    ex_mem_load = 1'b1;
    mem_wb_load = 1'b1;
endfunction


always_comb begin    
    alumux1_sel = id_ex_ctrl_out.alumux1_sel;
    alumux2_sel = id_ex_ctrl_out.alumux2_sel;
    cmpmux_sel =  id_ex_ctrl_out.cmpmux_sel;
    aluop = id_ex_ctrl_out.aluop;
    cmpop = id_ex_ctrl_out.cmpop;
    regfilemux_sel = mem_wb_ctrl_out.regfilemux_sel;
    regfilemux_ex_mem_sel = ex_mem_ctrl_out.regfilemux_sel;
end

branch_funct3_t branch_funct3;
store_funct3_t store_funct3;
load_funct3_t load_funct3;
arith_funct3_t arith_funct3;

assign arith_funct3 = arith_funct3_t'(ex_mem_ctrl_out.funct3);
assign branch_funct3 = branch_funct3_t'(ex_mem_ctrl_out.funct3);
assign load_funct3 = load_funct3_t'(ex_mem_ctrl_out.funct3);
assign store_funct3 = store_funct3_t'(ex_mem_ctrl_out.funct3);

assign imem_address = pc_out;
assign imem_read = 1'b1;

assign dmem_byte_enable = wmask;
assign dmem_address = {ex_mem_alu_out[31:2], 2'b0};
assign dmem_wdata = ex_mem_mem_wdata;
assign dmem_read = ex_mem_ctrl_out.mem_read;
assign dmem_write = ex_mem_ctrl_out.mem_write;
// assign halt = (id_ex_pc_out == alu_out) & (id_ex_ctrl_out.opcode == op_br) & (br_en == 1'b1);

always_comb
begin : trap_check
    trap = 0;
    rmask = '0;
    wmask = '0;
    pcmux_sel = ex_mem_ctrl_out.pcmux_sel;
    do_br = 1'b0;
    case (ex_mem_ctrl_out.opcode)
        op_br: begin
            pcmux_sel = pcmux_sel_t'(ex_mem_br_en_out);
            do_br = ex_mem_br_en_out;
        end
        op_jal, op_jalr: begin
            do_br = 1'b1;
        end
    endcase

    case (ex_mem_ctrl_out.opcode)
        op_lui, op_auipc, op_imm, op_reg, op_jal, op_jalr:;

        op_br: begin
            case (branch_funct3)
                beq, bne, blt, bge, bltu, bgeu:;
                default: trap = 1;
            endcase
        end

        op_load: begin
            
            case (load_funct3)
                rv32i_types::lw: rmask = 4'b1111;
                rv32i_types::lh, rv32i_types::lhu: rmask = 4'b0011 << ex_mem_alu_out[1:0];
                rv32i_types::lb, rv32i_types::lbu: rmask =  4'b0001 << ex_mem_alu_out[1:0];
                default: trap = 1;
            endcase
        end

        op_store: begin
            case (store_funct3)
                rv32i_types::sw: begin
                    wmask = 4'b1111;
                end
                rv32i_types::sh: begin
                    wmask = 4'b0011 << ex_mem_alu_out[1:0];    
                end
                rv32i_types::sb: begin
                    wmask = 4'b0001 << ex_mem_alu_out[1:0];    
                end
                default: trap = 1;
            endcase
        end

        default: trap = 1;
    endcase
end

/******************************** Muxes **************************************/
always_comb begin : MUXES
    // We provide one (incomplete) example of a mux instantiated using
    // a case statement.  Using enumerated types rather than bit vectors
    // provides compile time type safety.  Defensive programming is extremely
    // useful in SystemVerilog.  In this case, we actually use
    // Offensive programming --- making simulation halt with a fatal message
    // warning when an unexpected mux select value occurs
    set_default_load();

    

    unique case (regfilemux_sel)
      regfilemux::alu_out: regfilemux_out = mem_wb_alu_out;
      regfilemux::br_en: regfilemux_out =  {31'd0, mem_wb_br_en_out};
      regfilemux::u_imm: regfilemux_out = mem_wb_u_imm_out;
      regfilemux::pc_plus4: regfilemux_out = mem_wb_pc_out + 32'd4;
      regfilemux::lw: regfilemux_out = mem_wb_mdr_out;
      regfilemux::lb: 
                    unique case (mem_wb_alu_out[1:0])
                        2'b00: regfilemux_out = {{24{mem_wb_mdr_out[7]}}, mem_wb_mdr_out[7:0]};
                        2'b01: regfilemux_out = {{24{mem_wb_mdr_out[15]}}, mem_wb_mdr_out[15:8]};
                        2'b10: regfilemux_out = {{24{mem_wb_mdr_out[23]}}, mem_wb_mdr_out[23:16]};
                        2'b11: regfilemux_out = {{24{mem_wb_mdr_out[31]}}, mem_wb_mdr_out[31:24]};
                    endcase
      regfilemux::lbu:
                    unique case (mem_wb_alu_out[1:0])
                        2'b00: regfilemux_out = {24'd0, mem_wb_mdr_out[7:0]};
                        2'b01: regfilemux_out = {24'd0, mem_wb_mdr_out[15:8]};
                        2'b10: regfilemux_out = {24'd0, mem_wb_mdr_out[23:16]};
                        2'b11: regfilemux_out = {24'd0, mem_wb_mdr_out[31:24]};
                    endcase
      regfilemux::lh: 
                    unique case (mem_wb_alu_out[1:0])
                        2'b00: regfilemux_out = {{16{mem_wb_mdr_out[15]}}, mem_wb_mdr_out[15:0]};
                        2'b01: regfilemux_out = {{16{mem_wb_mdr_out[23]}}, mem_wb_mdr_out[23:8]};
                        2'b10: regfilemux_out = {{16{mem_wb_mdr_out[31]}}, mem_wb_mdr_out[31:16]};
                        2'b11: regfilemux_out = 32'd0;
                    endcase
      regfilemux::lhu:
                    unique case (mem_wb_alu_out[1:0])
                        2'b00: regfilemux_out = {16'd0, mem_wb_mdr_out[15:0]};
                        2'b01: regfilemux_out = {16'd0, mem_wb_mdr_out[23:8]};
                        2'b10: regfilemux_out = {16'd0, mem_wb_mdr_out[31:16]};
                        2'b11: regfilemux_out = 32'd0;
                    endcase   
    endcase

    unique case (regfilemux_ex_mem_sel)
        regfilemux::alu_out: regfilemux_ex_mem_out = ex_mem_alu_out;
        regfilemux::br_en: regfilemux_ex_mem_out = {31'd0, ex_mem_br_en_out};
        regfilemux::u_imm: regfilemux_ex_mem_out = ex_mem_u_imm_out;
        regfilemux::pc_plus4: regfilemux_ex_mem_out = ex_mem_pc_out + 32'd4;
        regfilemux::lw: regfilemux_ex_mem_out = dmem_rdata;
        regfilemux::lb: 
                    unique case (ex_mem_alu_out[1:0])
                        2'b00: regfilemux_ex_mem_out = {{24{dmem_rdata[7]}}, dmem_rdata[7:0]};
                        2'b01: regfilemux_ex_mem_out = {{24{dmem_rdata[15]}}, dmem_rdata[15:8]};
                        2'b10: regfilemux_ex_mem_out = {{24{dmem_rdata[23]}}, dmem_rdata[23:16]};
                        2'b11: regfilemux_ex_mem_out = {{24{dmem_rdata[31]}}, dmem_rdata[31:24]};
                    endcase
        regfilemux::lbu:
                    unique case (ex_mem_alu_out[1:0])
                        2'b00: regfilemux_ex_mem_out = {24'b0, dmem_rdata[7:0]};
                        2'b01: regfilemux_ex_mem_out = {24'b0, dmem_rdata[15:8]};
                        2'b10: regfilemux_ex_mem_out = {24'b0, dmem_rdata[23:16]};
                        2'b11: regfilemux_ex_mem_out = {24'b0, dmem_rdata[31:24]};
                    endcase
        regfilemux::lh: 
                    unique case (ex_mem_alu_out[1:0])
                        2'b00: regfilemux_ex_mem_out = {{16{dmem_rdata[15]}}, dmem_rdata[15:0]};
                        2'b01: regfilemux_ex_mem_out = {{16{dmem_rdata[23]}}, dmem_rdata[23:8]};
                        2'b10: regfilemux_ex_mem_out = {{16{dmem_rdata[31]}}, dmem_rdata[31:16]};
                        2'b11: regfilemux_ex_mem_out = 32'd0;
                    endcase
        regfilemux::lhu:
                    unique case (ex_mem_alu_out[1:0])
                        2'b00: regfilemux_ex_mem_out = {16'b0, dmem_rdata[15:0]};
                        2'b01: regfilemux_ex_mem_out = {16'b0, dmem_rdata[23:8]};
                        2'b10: regfilemux_ex_mem_out = {16'b0, dmem_rdata[31:16]};
                        2'b11: regfilemux_ex_mem_out = 32'd0;
                    endcase
    endcase

    unique case (forwardC_sel)
        1'b1: forwardC_mux_out = regfilemux_out;
        default: forwardC_mux_out = rs1_out;
    endcase

    unique case (forwardD_sel)
        1'b1: forwardD_mux_out = regfilemux_out;
        default: forwardD_mux_out = rs2_out;
    endcase

    unique case (forwardA_sel)
        2'b00: forwardA_mux_out = id_ex_rs1_data_out;
        2'b01: forwardA_mux_out = regfilemux_ex_mem_out;
        2'b10: forwardA_mux_out = regfilemux_out;
        default: forwardA_mux_out = 32'd0;
    endcase
    
    unique case (forwardB_sel)
        2'b00: forwardB_mux_out = id_ex_rs2_data_out;
        2'b01: forwardB_mux_out = regfilemux_ex_mem_out;
        2'b10: forwardB_mux_out = regfilemux_out;
        default: forwardB_mux_out = 32'd0;
    endcase

    unique case (alumux1_sel)
      alumux::rs1_out: alumux1_out = forwardA_mux_out;
      alumux::pc_out: alumux1_out = id_ex_pc_out;
      default: `BAD_MUX_SEL;
    endcase
    unique case (alumux2_sel)
      alumux::i_imm: alumux2_out = id_ex_i_imm_out;
      alumux::u_imm: alumux2_out = id_ex_u_imm_out;
      alumux::b_imm: alumux2_out = id_ex_b_imm_out;
      alumux::s_imm: alumux2_out = id_ex_s_imm_out;
      alumux::j_imm: alumux2_out = id_ex_j_imm_out;
      alumux::rs2_out: alumux2_out = forwardB_mux_out;
      default: `BAD_MUX_SEL;
    endcase
	 unique case (cmpmux_sel)
        cmpmux::rs2_out: cmp_mux_out = forwardB_mux_out;
        cmpmux::i_imm: cmp_mux_out = id_ex_i_imm_out;
		  default: `BAD_MUX_SEL;
	 endcase

    unique case (funct3)
        rv32i_types::sw: mem_data_in = forwardB_mux_out;
        default: mem_data_in = forwardB_mux_out << {alu_out[1:0], 3'd0};
    endcase

    if (imem_resp == 1'b0 || (dmem_resp == 1'b0 && (ex_mem_ctrl_out.mem_read | ex_mem_ctrl_out.mem_write))) begin
        load_pc = 1'b0;
        load_regfile = 1'b0;
        if_id_load = 1'b0;
        id_ex_load = 1'b0;
        ex_mem_load = 1'b0;
        mem_wb_load = 1'b0;
    end

    if (stall_pipeline) begin
        load_pc = 1'b0;
        if_id_load = 1'b0;
    end

    unique case (stall_pipeline)
        1'b1: ctrl_mux_out = '0;   // set to zero
        default: ctrl_mux_out = ctrl; // control rom output
    endcase
    
    unique case (pcmux_sel)
        pcmux::pc_plus4: begin
            pcmux_out = pc_out + 32'd4;
            inst_mux_out = imem_rdata;
            ctrl_mux_out_br = ctrl_mux_out;
            id_ex_ctrl_mux_out = id_ex_ctrl_out;
        end
        pcmux::alu_out: begin
            pcmux_out = ex_mem_alu_out;
            inst_mux_out = 32'd0;
            ctrl_mux_out_br = '0;
            id_ex_ctrl_mux_out = '0;
        end
        pcmux::alu_mod2: begin
            pcmux_out = {ex_mem_alu_out[31:2], 2'd0};
            inst_mux_out = 32'd0;
            ctrl_mux_out_br = '0;
            id_ex_ctrl_mux_out = '0;
        end
        default: `BAD_MUX_SEL;
    endcase
end



endmodule : datapath
