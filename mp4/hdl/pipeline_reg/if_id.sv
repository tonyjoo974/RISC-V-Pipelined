import rv32i_types::*;

module if_id (
    input clk,
    input rst,
    input logic if_id_load,
    input rv32i_word pc_in,
    input rv32i_word imem_rdata,

    output rv32i_word pc_out,
    output [2:0] funct3,
    output [6:0] funct7,
    output rv32i_opcode opcode,
    output [31:0] i_imm,
    output [31:0] s_imm,
    output [31:0] b_imm,
    output [31:0] u_imm,
    output [31:0] j_imm,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output rv32i_word imem_rdata_out
);

register if_id_pc_reg(
    .clk(clk),
    .rst(rst),
    .load(if_id_load),
    .in(pc_in),
    .out(pc_out)
);

register if_id_imem_rdata_reg(
    .clk(clk),
    .rst(rst),
    .load(if_id_load),
    .in(imem_rdata),
    .out(imem_rdata_out)
);

ir IR(
    .clk(clk),
    .rst(rst),
    .load(if_id_load),
    .in(imem_rdata),
    .funct3(funct3),
    .funct7(funct7),
    .opcode(opcode),
    .i_imm(i_imm),
    .s_imm(s_imm),
    .b_imm(b_imm),
    .u_imm(u_imm),
    .j_imm(j_imm),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd)
);

endmodule : if_id