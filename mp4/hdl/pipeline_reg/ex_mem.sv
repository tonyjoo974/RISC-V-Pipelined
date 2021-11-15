import rv32i_types::*;

module ex_mem (
    input clk,
    input rst,
    
    input logic ex_mem_load,
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
    // input logic do_br_in,
    input rv32i_word imem_rdata,
    input rv32i_word dmem_wdata_in,

    output rv32i_word pc_out,
    output rv32i_control_word ctrl_out,
    output rv32i_word alu_out,
    input rv32i_word rs1_data_out,
    input rv32i_word rs2_data_out,
    output rv32i_reg rs1_out,
    output rv32i_reg rs2_out,
    output rv32i_reg rd_out,    
    output rv32i_word u_imm_out,
    output logic br_en_out,
    // output logic do_br_out,
    output rv32i_word imem_rdata_out,
    output rv32i_word dmem_wdata_out
);

register ex_mem_pc_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(pc_in),
    .out(pc_out)
);

register ex_mem_imem_rdata_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(imem_rdata),
    .out(imem_rdata_out)
);

ctrl_register ex_mem_ctrl_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(ctrl),
    .out(ctrl_out)
);

register ex_mem_alu_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(alu_in),
    .out(alu_out)
);

register ex_mem_rs1_data_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(rs1_data_in),
    .out(rs1_data_out)
);

register ex_mem_rs2_data_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(rs2_data_in),
    .out(rs2_data_out)
);

register ex_mem_dmem_wdata_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(dmem_wdata_in),
    .out(dmem_wdata_out)
);

register #(.width(5)) ex_mem_rs1_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(rs1_in),
    .out(rs1_out)
);

register #(.width(5)) ex_mem_rs2_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(rs2_in),
    .out(rs2_out)
);

register #(.width(5)) ex_mem_rd_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(rd_in),
    .out(rd_out)
);

register ex_mem_u_imm_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(u_imm_in),
    .out(u_imm_out)
);

register #(.width(1)) ex_mem_br_reg(
    .clk(clk),
    .rst(rst),
    .load(ex_mem_load),
    .in(br_en_in),
    .out(br_en_out)
);

// register #(.width(1)) ex_mem_do_br_reg(
//     .clk(clk),
//     .rst(rst),
//     .load(ex_mem_load),
//     .in(do_br_in),
//     .out(do_br_out)
// );

endmodule : ex_mem