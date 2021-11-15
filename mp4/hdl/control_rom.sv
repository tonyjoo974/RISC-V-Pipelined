import rv32i_types::*;

module control_rom
(
    input rv32i_opcode opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    
    output rv32i_control_word ctrl
);

branch_funct3_t branch_funct3;
store_funct3_t store_funct3;
load_funct3_t load_funct3;
arith_funct3_t arith_funct3;

assign arith_funct3 = arith_funct3_t'(funct3);
assign branch_funct3 = branch_funct3_t'(funct3);
assign load_funct3 = load_funct3_t'(funct3);
assign store_funct3 = store_funct3_t'(funct3);

always_comb
begin
    /* Default assignments */
    ctrl.opcode = opcode;
    ctrl.funct3 = funct3;
    ctrl.load_regfile = 1'b0;
    ctrl.mem_read = 1'b0;
    ctrl.mem_write = 1'b0;
    ctrl.aluop = rv32i_types::alu_add;
    ctrl.pcmux_sel = pcmux::pc_plus4;
    ctrl.alumux1_sel = alumux::rs1_out;
    ctrl.alumux2_sel = alumux::i_imm;
    ctrl.regfilemux_sel = regfilemux::alu_out;
    ctrl.cmpmux_sel = cmpmux::rs2_out;
    ctrl.cmpop = rv32i_types::beq;
    ctrl.valid_inst = 1'b0;
    /* ... other defaults ... */
    /* Assign control signals based on opcode */
    case(opcode)
        op_auipc: begin
            ctrl.alumux1_sel = alumux::pc_out;
            ctrl.alumux2_sel = alumux::u_imm;
            ctrl.load_regfile = 1'b1;
            ctrl.aluop = rv32i_types::alu_add;
            ctrl.valid_inst = 1'b1;
        end
        
        op_imm:
        begin
            if (funct3 == slt) begin
                ctrl.load_regfile = 1'b1;
                ctrl.cmpop = rv32i_types::blt;
                ctrl.regfilemux_sel = regfilemux::br_en;
                ctrl.cmpmux_sel = cmpmux::i_imm;
            end
            else if (funct3 == sltu) begin
                ctrl.load_regfile = 1'b1;
                ctrl.cmpop = rv32i_types::bltu;
                ctrl.regfilemux_sel = regfilemux::br_en;
                ctrl.cmpmux_sel = cmpmux::i_imm;
            end
            else if (funct3 == sr) begin
                ctrl.load_regfile = 1'b1;
                // check bit30 for logical/arithmetic
                if (funct7 == 7'b0100000)
                    ctrl.aluop = rv32i_types::alu_sra;
                else
                    ctrl.aluop = rv32i_types::alu_srl;
            end
            else begin
                ctrl.load_regfile = 1'b1;
                ctrl.aluop = alu_ops'(funct3);
            end
            ctrl.valid_inst = 1'b1;
        end
        
        op_lui:
        begin
            ctrl.load_regfile = 1'b1;
            ctrl.regfilemux_sel = regfilemux::u_imm;
            ctrl.valid_inst = 1'b1;
        end

        op_br:
        begin
            ctrl.alumux1_sel = alumux::pc_out;
            ctrl.alumux2_sel = alumux::b_imm;
            ctrl.aluop = rv32i_types::alu_add;
            ctrl.cmpop = branch_funct3;
            ctrl.valid_inst = 1'b1;
        end
        
        op_load:
        begin
            ctrl.aluop = rv32i_types::alu_add;
            ctrl.mem_read = 1'b1;
            if (load_funct3 == rv32i_types::lh) begin
                ctrl.regfilemux_sel = regfilemux::lh;
            end
            else if (load_funct3 == rv32i_types::lb) begin
                ctrl.regfilemux_sel = regfilemux::lb;
            end
            else if (load_funct3 == rv32i_types::lhu) begin
                ctrl.regfilemux_sel = regfilemux::lhu;
            end
            else if (load_funct3 == rv32i_types::lbu) begin
                ctrl.regfilemux_sel = regfilemux::lbu;
				end
            else begin
                ctrl.regfilemux_sel = regfilemux::lw;
            end
            ctrl.load_regfile = 1'b1;
            ctrl.valid_inst = 1'b1;
        end

        op_store:
        begin
            ctrl.mem_write = 1'b1;
            ctrl.alumux2_sel = alumux::s_imm;
            ctrl.aluop = rv32i_types::alu_add;
            ctrl.valid_inst = 1'b1;
        end
        
        op_reg:
        begin
            ctrl.load_regfile = 1'b1;
            ctrl.aluop = rv32i_types::alu_ops'(funct3);
            ctrl.alumux2_sel = alumux::rs2_out;
            ctrl.valid_inst = 1'b1;
            if ((funct3 == rv32i_types::add) && (funct7 == 7'b0000000))
                ctrl.aluop = rv32i_types::alu_add;
            else if ((funct3 == rv32i_types::add) && (funct7 == 7'b0100000))
                ctrl.aluop = rv32i_types::alu_sub;
            else if (funct3 == rv32i_types::sll)
                ctrl.aluop = rv32i_types::alu_sll;
            else if ((funct3 == rv32i_types::sr) && (funct7 == 7'b0000000))
                ctrl.aluop = rv32i_types::alu_srl;
            else if ((funct3 == rv32i_types::sr) && (funct7 == 7'b0100000))
                ctrl.aluop = rv32i_types::alu_sra;
            else if (funct3 == rv32i_types::axor)
                ctrl.aluop = rv32i_types::alu_xor;
            else if (funct3 == rv32i_types::aor)
                ctrl.aluop = rv32i_types::alu_or;
            else if (funct3 == rv32i_types::aand)
                ctrl.aluop = rv32i_types::alu_and;
            else if (funct3 == slt) begin
                ctrl.cmpop = rv32i_types::blt;
                ctrl.cmpmux_sel = cmpmux::rs2_out;
                ctrl.regfilemux_sel = regfilemux::br_en;
			end
            else if (funct3 == rv32i_types::sltu) begin
                ctrl.cmpop = rv32i_types::bltu;
                ctrl.cmpmux_sel = cmpmux::rs2_out;
                ctrl.regfilemux_sel = regfilemux::br_en;  
			end
        end
        op_jal:
        begin
            ctrl.load_regfile = 1'b1;
            ctrl.regfilemux_sel = regfilemux::pc_plus4;
            ctrl.alumux1_sel = alumux::pc_out;
            ctrl.alumux2_sel = alumux::j_imm;
            ctrl.pcmux_sel = pcmux::alu_mod2;
            ctrl.valid_inst = 1'b1;
        end
        op_jalr:
        begin
            ctrl.load_regfile = 1'b1;
            ctrl.regfilemux_sel = regfilemux::pc_plus4;
            ctrl.alumux1_sel = alumux::rs1_out;
            ctrl.alumux2_sel = alumux::i_imm;
            ctrl.pcmux_sel = pcmux::alu_mod2;
            ctrl.valid_inst = 1'b1;
        end

        /* ... other opcodes ... */
        default: begin
            ctrl = 0; /* Unknown opcode, set control word to zero */
        end
    endcase
end

endmodule : control_rom