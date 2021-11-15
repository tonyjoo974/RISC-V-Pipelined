import rv32i_types::*;

module id_ex (
    input clk,
    input rst,
    
    input logic id_ex_load,
    
    input rv32i_word pc_in,
    input rv32i_control_word ctrl,
    input rv32i_word rs1_data_in,
    input rv32i_word rs2_data_in,
    input rv32i_reg rs1_in,
    input rv32i_reg rs2_in,
    input rv32i_reg rd_in,
    input rv32i_word i_imm,
    input rv32i_word u_imm,
    input rv32i_word b_imm,
    input rv32i_word s_imm,
    input rv32i_word j_imm,
    input rv32i_word imem_rdata,
    
    output rv32i_word pc_out,
    output rv32i_control_word ctrl_out,
    output rv32i_word rs1_data_out,
    output rv32i_word rs2_data_out,
    output rv32i_reg rs1_out,
    output rv32i_reg rs2_out,
    output rv32i_reg rd_out,
    output rv32i_word i_imm_out,
    output rv32i_word u_imm_out,
    output rv32i_word b_imm_out,
    output rv32i_word s_imm_out,
    output rv32i_word j_imm_out,
    output rv32i_word imem_rdata_out
);

register id_ex_pc_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(pc_in),
    .out(pc_out)
);

register id_ex_imem_rdata_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(imem_rdata),
    .out(imem_rdata_out)
);

ctrl_register id_ex_ctrl_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(ctrl),
    .out(ctrl_out)
);

register id_ex_rs1_data_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(rs1_data_in),
    .out(rs1_data_out)
);

register id_ex_rs2_data_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(rs2_data_in),
    .out(rs2_data_out)
);

register #(.width(5)) id_ex_rs1_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(rs1_in),
    .out(rs1_out)
);

register #(.width(5)) id_ex_rs2_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(rs2_in),
    .out(rs2_out)
);

register #(.width(5)) id_ex_rd_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(rd_in),
    .out(rd_out)
);

register id_ex_i_imm_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(i_imm),
    .out(i_imm_out)
);

register id_ex_u_imm_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(u_imm),
    .out(u_imm_out)
);

register id_ex_b_imm_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(b_imm),
    .out(b_imm_out)
);

register id_ex_s_imm_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(s_imm),
    .out(s_imm_out)
);

register id_ex_j_imm_reg(
    .clk(clk),
    .rst(rst),
    .load(id_ex_load),
    .in(j_imm),
    .out(j_imm_out)
);


endmodule : id_ex