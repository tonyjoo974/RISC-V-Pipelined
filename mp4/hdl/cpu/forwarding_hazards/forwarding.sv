import rv32i_types::*;

module forwarding
(
    input rv32i_reg ex_mem_rd_out,
    input rv32i_reg mem_wb_rd_out,
    input rv32i_reg if_id_rs1_out,
    input rv32i_reg if_id_rs2_out,
    input rv32i_reg id_ex_rs1_out,
    input rv32i_reg id_ex_rs2_out,
    input rv32i_control_word ex_mem_ctrl_out,
    input rv32i_control_word mem_wb_ctrl_out,
    output logic [1:0] forwardA_sel,
    output logic [1:0] forwardB_sel,
    output logic forwardC_sel,
    output logic forwardD_sel
);

always_comb begin
    forwardA_sel = 2'b00;
    forwardB_sel = 2'b00;
    forwardC_sel = 1'b0;
    forwardD_sel = 1'b0;
    if (ex_mem_ctrl_out.load_regfile && ex_mem_rd_out != 5'd0 && ex_mem_rd_out == id_ex_rs1_out)
        forwardA_sel = 2'b01;
    if (ex_mem_ctrl_out.load_regfile && ex_mem_rd_out != 5'd0 && ex_mem_rd_out == id_ex_rs2_out)
        forwardB_sel = 2'b01;
    if (mem_wb_ctrl_out.load_regfile && mem_wb_rd_out != 5'd0 && mem_wb_rd_out == id_ex_rs1_out 
        && !(ex_mem_ctrl_out.load_regfile && (ex_mem_rd_out != 5'd0) && (ex_mem_rd_out == id_ex_rs1_out)))
        forwardA_sel = 2'b10;
    if (mem_wb_ctrl_out.load_regfile && mem_wb_rd_out != 5'd0 && mem_wb_rd_out == id_ex_rs2_out 
        && !(ex_mem_ctrl_out.load_regfile && (ex_mem_rd_out != 5'd0) && (ex_mem_rd_out == id_ex_rs2_out)))
        forwardB_sel = 2'b10;

    if (mem_wb_ctrl_out.load_regfile && mem_wb_rd_out != 5'd0 && mem_wb_rd_out == if_id_rs1_out)
        forwardC_sel = 1'b1;
    if (mem_wb_ctrl_out.load_regfile && mem_wb_rd_out != 5'd0 && mem_wb_rd_out == if_id_rs2_out)
        forwardD_sel = 1'b1;

end

endmodule : forwarding