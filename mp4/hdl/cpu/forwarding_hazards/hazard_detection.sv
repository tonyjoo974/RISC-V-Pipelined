import rv32i_types::*;

module hazard_detection
(
    input rv32i_reg if_id_rs1_out,
    input rv32i_reg if_id_rs2_out,
    input rv32i_reg id_ex_rd_out,
    input rv32i_control_word id_ex_ctrl_out,
    
    output logic stall_pipeline
);


always_comb begin
    stall_pipeline = 1'b0;

    // stall pipeline
    if (id_ex_ctrl_out.mem_read && ((id_ex_rd_out == if_id_rs1_out) || (id_ex_rd_out == if_id_rs2_out))) begin
        stall_pipeline = 1'b1;
    end
end
endmodule : hazard_detection