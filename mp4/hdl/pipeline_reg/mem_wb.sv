import rv32i_types::*;

module mem_wb (
    input clk,
    input rst,
    input logic mem_wb_load,
    input rv32i_word pc_in,
    input rv32i_control_word ctrl,
    input rv32i_word alu_in,
    input rv32i_word rs1_data_in,
    input rv32i_word rs2_data_in,
    input rv32i_reg rs1_in,
    input rv32i_reg rs2_in,
    input rv32i_reg rd_in,
    input rv32i_word u_imm_in,
    input logic br_en_in,
    input logic do_br_in,
    input rv32i_word mem_rdata,
    input rv32i_word imem_rdata,
    input logic trap,
    input [3:0] rmask_in,
    input [3:0] wmask_in,
    input rv32i_word dmem_address_in,
    input rv32i_word dmem_wdata_in,

    output rv32i_word pc_out,
    output rv32i_control_word ctrl_out,
    output rv32i_word alu_out,
    output rv32i_word rs1_data_out,
    output rv32i_word rs2_data_out,
    output rv32i_reg rs1_out,
    output rv32i_reg rs2_out,
    output rv32i_reg rd_out,    
    output rv32i_word u_imm_out,
    output logic br_en_out,
    output logic do_br_out,
    output rv32i_word mdr_out,
    output rv32i_word imem_rdata_out,
    output logic trap_out,
    output logic [3:0] rmask_out,
    output logic [3:0] wmask_out,
    output rv32i_word dmem_address_out,
    output rv32i_word dmem_wdata_out
);

register #(.width(4)) mem_wb_rmask_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(rmask_in),
    .out(rmask_out)
);

register #(.width(4)) mem_wb_wmask_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(wmask_in),
    .out(wmask_out)
);

register mem_wb_dmem_wdata_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(dmem_wdata_in),
    .out(dmem_wdata_out)
);

register mem_wb_dmem_address_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(dmem_address_in),
    .out(dmem_address_out)
);

register mem_wb_pc_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(pc_in),
    .out(pc_out)
);

register mem_wb_imem_rdata_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(imem_rdata),
    .out(imem_rdata_out)
);

ctrl_register mem_wb_ctrl_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(ctrl),
    .out(ctrl_out)
);

register mem_wb_alu_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(alu_in),
    .out(alu_out)
);

register mem_wb_rs1_data_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(rs1_data_in),
    .out(rs1_data_out)
);

register mem_wb_rs2_data_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(rs2_data_in),
    .out(rs2_data_out)
);


register #(.width(5)) mem_wb_rs1_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(rs1_in),
    .out(rs1_out)
);

register #(.width(5)) mem_wb_rs2_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(rs2_in),
    .out(rs2_out)
);

register #(.width(5)) mem_wb_rd_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(rd_in),
    .out(rd_out)
);

register mem_wb_u_imm_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(u_imm_in),
    .out(u_imm_out)
);

register #(.width(1)) mem_wb_br_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(br_en_in),
    .out(br_en_out)
);

register mem_wb_mdr_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(mem_rdata),
    .out(mdr_out)
);

register #(.width(1)) mem_wb_trap_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(trap),
    .out(trap_out)
);

register #(.width(1)) mem_wb_do_br_reg(
    .clk(clk),
    .rst(rst),
    .load(mem_wb_load),
    .in(do_br_in),
    .out(do_br_out)
);
endmodule : mem_wb