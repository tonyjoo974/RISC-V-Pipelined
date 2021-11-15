import rv32i_types::*;

module cpu
(
    input clk,
    input rst,
    input mem_resp,
    input rv32i_word mem_rdata,
    output logic mem_read,
    output logic mem_write,
    output logic [3:0] mem_byte_enable,
    output rv32i_word mem_address,
    output rv32i_word mem_wdata
);

/******************* Signals Needed for RVFI Monitor *************************/
logic load_pc;
logic load_regfile;
/*****************************************************************************/

/**************************** Control Signals ********************************/
pcmux::pcmux_sel_t pcmux_sel;
alumux::alumux1_sel_t alumux1_sel;
alumux::alumux2_sel_t alumux2_sel;
regfilemux::regfilemux_sel_t regfilemux_sel;
marmux::marmux_sel_t marmux_sel;
cmpmux::cmpmux_sel_t cmpmux_sel;
/*****************************************************************************/

/* Instantiate MP 1 top level blocks here */
rv32i_opcode opcode;
logic [2:0] funct3;
logic [6:0] funct7;
logic br_en;
alu_ops aluop;
logic load_ir;
logic load_mar;
logic load_mdr;
logic load_data_out;
branch_funct3_t cmpop;
rv32i_reg rs1;
rv32i_reg rs2;
rv32i_reg rd;
rv32i_word rs1_out;
rv32i_word rs2_out;
rv32i_word i_imm, u_imm, b_imm, s_imm, j_imm, pcmux_out, alumux1_out, alumux2_out;
rv32i_word regfilemux_out, marmux_out, cmp_mux_out, alu_out, pc_out, pc_plus4_out, mdrreg_out;
rv32i_word mem_addr;
// assign mem_address = mem_addr;
assign mem_address = {mem_addr[31:2], 2'd0};

// Keep control named `control` for RVFI Monitor
control control(
    .clk(clk),
    .rst(rst),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .br_en(br_en),
    .rs1(rs1),
    .rs2(rs2),
    .mem_resp(mem_resp),
    .marmux_out(marmux_out),
    .mem_address(mem_addr),

    .pcmux_sel(pcmux_sel),
    .alumux1_sel(alumux1_sel),
    .alumux2_sel(alumux2_sel),
    .regfilemux_sel(regfilemux_sel),
    .marmux_sel(marmux_sel),
    .cmpmux_sel(cmpmux_sel),
    .aluop(aluop),
    .load_pc(load_pc),
    .load_ir(load_ir),
    .load_regfile(load_regfile),
    .load_mar(load_mar),
    .load_mdr(load_mdr),
    .load_data_out(load_data_out),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),
    .cmpop(cmpop)
);

// Keep datapath named `datapath` for RVFI Monitor
datapath datapath(
    .clk(clk),
    .rst(rst),
    .load_pc(load_pc),
    .load_ir(load_ir), 
    .load_regfile(load_regfile), 
    .load_mar(load_mar), 
    .load_mdr(load_mdr), 
    .load_data_out(load_data_out),
    .pcmux_sel(pcmux_sel),
    .alumux1_sel(alumux1_sel),
    .alumux2_sel(alumux2_sel),
    .regfilemux_sel(regfilemux_sel),
    .marmux_sel(marmux_sel),
    .cmpmux_sel(cmpmux_sel),
    .aluop(aluop),
    .cmpop(cmpop),
    .mem_rdata(mem_rdata),

    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .rs1_out(rs1_out), 
    .rs2_out(rs2_out), 
    .i_imm(i_imm), 
    .u_imm(u_imm), 
    .b_imm(b_imm), 
    .s_imm(s_imm), 
    .j_imm(j_imm), 
    .pcmux_out(pcmux_out), 
    .alumux1_out(alumux1_out), 
    .alumux2_out(alumux2_out),
    .regfilemux_out(regfilemux_out), 
    .marmux_out(marmux_out), 
    .cmp_mux_out(cmp_mux_out), 
    .alu_out(alu_out), 
    .pc_out(pc_out), 
    .pc_plus4_out(pc_plus4_out), 
    .mdrreg_out(mdrreg_out),
    .mem_wdata(mem_wdata), // signal used by RVFI Monitor
    .mem_address(mem_addr),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .br_en(br_en)
);

endmodule : cpu
