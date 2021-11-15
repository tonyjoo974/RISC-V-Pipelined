import rv32i_types::*; /* Import types defined in rv32i_types.sv */

module control
(
    input clk,
    input rst,
    input rv32i_opcode opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic br_en,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic mem_resp,
    input rv32i_word marmux_out,
    input rv32i_word mem_address,

    output pcmux::pcmux_sel_t pcmux_sel,
    output alumux::alumux1_sel_t alumux1_sel,
    output alumux::alumux2_sel_t alumux2_sel,
    output regfilemux::regfilemux_sel_t regfilemux_sel,
    output marmux::marmux_sel_t marmux_sel,
    output cmpmux::cmpmux_sel_t cmpmux_sel,
    output alu_ops aluop,
    output logic load_pc,
    output logic load_ir,
    output logic load_regfile,
    output logic load_mar,
    output logic load_mdr,
    output logic load_data_out,
    output logic mem_read,
    output logic mem_write,
    output logic [3:0] mem_byte_enable,
    output branch_funct3_t cmpop
);

/***************** USED BY RVFIMON --- ONLY MODIFY WHEN TOLD *****************/
logic trap;
logic [4:0] rs1_addr, rs2_addr;
logic [3:0] rmask, wmask;

branch_funct3_t branch_funct3;
store_funct3_t store_funct3;
load_funct3_t load_funct3;
arith_funct3_t arith_funct3;

assign arith_funct3 = arith_funct3_t'(funct3);
assign branch_funct3 = branch_funct3_t'(funct3);
assign load_funct3 = load_funct3_t'(funct3);
assign store_funct3 = store_funct3_t'(funct3);
assign rs1_addr = rs1;
assign rs2_addr = rs2;

always_comb
begin : trap_check
    trap = 0;
    rmask = '0;
    wmask = '0;

    case (opcode)
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
                rv32i_types::lh, rv32i_types::lhu: rmask = (mem_byte_enable << marmux_out[1:0]) /* Modify for MP1 Final */ ;
                rv32i_types::lb, rv32i_types::lbu: rmask = (mem_byte_enable << marmux_out[1:0]) /* Modify for MP1 Final */ ;
                default: trap = 1;
            endcase
        end

        op_store: begin
            case (store_funct3)
                rv32i_types::sw: wmask = 4'b1111;
                rv32i_types::sh: wmask = 4'b0011 << mem_address[1:0]/* Modify for MP1 Final */ ;
                rv32i_types::sb: wmask = 4'b0001 << mem_address[1:0]/* Modify for MP1 Final */ ;
                default: trap = 1;
            endcase
        end

        default: trap = 1;
    endcase
end
/*****************************************************************************/

enum int unsigned {
    /* List of states */
    fetch1 = 0,
    fetch2 = 1,
    fetch3 = 2,
    decode = 3,
    imm = 4,
    lui = 5,
    auipc = 6,
    br = 7,
    calc_addr_ld = 8,
    ld1 = 9,
    ld2 = 10,
    calc_addr_st = 11,
    st1 = 12,
    st2 = 13,
    regop = 14,
    jal = 15,
    jalr = 16
} state, next_states;

/************************* Function Definitions *******************************/
/**
 *  You do not need to use these functions, but it can be nice to encapsulate
 *  behavior in such a way.  For example, if you use the `loadRegfile`
 *  function, then you only need to ensure that you set the load_regfile bit
 *  to 1'b1 in one place, rather than in many.
 *
 *  SystemVerilog functions must take zero "simulation time" (as opposed to 
 *  tasks).  Thus, they are generally synthesizable, and appropraite
 *  for design code.  Arguments to functions are, by default, input.  But
 *  may be passed as outputs, inouts, or by reference using the `ref` keyword.
**/

/**
 *  Rather than filling up an always_block with a whole bunch of default values,
 *  set the default values for controller output signals in this function,
 *   and then call it at the beginning of your always_comb block.
**/
function void set_defaults();
    load_pc = 1'b0;
    load_ir = 1'b0;
    load_regfile = 1'b0;
    load_mar = 1'b0;
    load_mdr = 1'b0;
    load_data_out = 1'b0;
    pcmux_sel = pcmux::pc_plus4;
    cmpop = rv32i_types::beq;
    alumux1_sel = alumux::rs1_out;
    alumux2_sel = alumux::i_imm;
    regfilemux_sel = regfilemux::alu_out;
    marmux_sel = marmux::pc_out;
    cmpmux_sel = cmpmux::rs2_out;
    aluop = rv32i_types::alu_add;
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_byte_enable = 4'b1111;
endfunction

/**
 *  Use the next several functions to set the signals needed to
 *  load various registers
**/
function void loadPC(pcmux::pcmux_sel_t sel);
    load_pc = 1'b1;
    pcmux_sel = sel;
endfunction

function void loadRegfile(regfilemux::regfilemux_sel_t sel);
endfunction

function void loadMAR(marmux::marmux_sel_t sel);
endfunction

function void loadMDR();
endfunction

/**
 * SystemVerilog allows for default argument values in a way similar to
 *   C++.
**/
function void setALU(alumux::alumux1_sel_t sel1,
                               alumux::alumux2_sel_t sel2,
                               logic setop = 1'b0, alu_ops op = alu_add);
    /* Student code here */


    if (setop)
        aluop = op; // else default value
endfunction

function automatic void setCMP(cmpmux::cmpmux_sel_t sel, branch_funct3_t op);
endfunction

/*****************************************************************************/

    /* Remember to deal with rst signal */

always_comb
begin : state_actions
    /* Default output assignments */
    set_defaults();
    /* Actions for each state */
    case (state)
        fetch1:
        begin
            load_mar = 1'b1;
            marmux_sel = marmux::pc_out;
        end
        fetch2:
        begin
            load_mdr = 1'b1;
            mem_read = 1'b1;
        end
        fetch3:
        begin
            load_ir = 1'b1;
        end
        decode: ;

        imm:
        begin
            if (funct3 == slt) begin
                load_regfile = 1'b1;
                load_pc = 1'b1;
                cmpop = rv32i_types::blt;
                regfilemux_sel = regfilemux::br_en;
                cmpmux_sel = cmpmux::i_imm;
            end
            else if (funct3 == sltu) begin
                load_regfile = 1'b1;
                load_pc = 1'b1;
                cmpop = rv32i_types::bltu;
                regfilemux_sel = regfilemux::br_en;
                cmpmux_sel = cmpmux::i_imm;
            end
            else if (funct3 == sr) begin
                load_regfile = 1'b1;
                load_pc = 1'b1;
                // check bit30 for logical/arithmetic
                if (funct7 == 7'b0100000)
                    aluop = rv32i_types::alu_sra;
                else
                    aluop = rv32i_types::alu_srl;
            end
            else begin
                load_regfile = 1'b1;
                load_pc = 1'b1;
                aluop = alu_ops'(funct3);
            end
        end
        lui:
        begin
            load_regfile = 1'b1;
            load_pc = 1'b1;
            regfilemux_sel = regfilemux::u_imm;
        end
        auipc:
        begin
            alumux1_sel = alumux::pc_out;
            alumux2_sel = alumux::u_imm;
            load_regfile = 1'b1;
            load_pc = 1'b1;
            aluop = rv32i_types::alu_add;
            marmux_sel = marmux::alu_out;
        end
        br:
        begin
            pcmux_sel = pcmux::pcmux_sel_t'(br_en);
            load_pc = 1'b1;
            alumux1_sel = alumux::pc_out;
            alumux2_sel = alumux::b_imm;
            aluop = rv32i_types::alu_add;
            cmpop = branch_funct3;
        end
        calc_addr_ld:
        begin
            aluop = rv32i_types::alu_add;
            load_mar = 1'b1;
            marmux_sel = marmux::alu_out;
        end
        ld1:
        begin
            load_mdr = 1'b1;
            mem_read = 1'b1;
            marmux_sel = marmux::alu_out;
        end
        ld2:
        begin
            if (load_funct3 == rv32i_types::lh) begin
                regfilemux_sel = regfilemux::lh;
                mem_byte_enable = 4'b0011;
            end
            else if (load_funct3 == rv32i_types::lb) begin
                regfilemux_sel = regfilemux::lb;
                mem_byte_enable = 4'b0001;
            end
            else if (load_funct3 == rv32i_types::lhu) begin
                regfilemux_sel = regfilemux::lhu;
                mem_byte_enable = 4'b0011;
            end
            else if (load_funct3 == rv32i_types::lbu) begin
                regfilemux_sel = regfilemux::lbu;
                mem_byte_enable = 4'b0001;
				end
            else regfilemux_sel = regfilemux::lw;
            load_regfile = 1'b1;
            load_pc = 1'b1;
            aluop = rv32i_types::alu_add;
            marmux_sel = marmux::alu_out;
        end
        calc_addr_st:
        begin
            alumux2_sel = alumux::s_imm;
            aluop = rv32i_types::alu_add;
            load_mar = 1'b1;
            load_data_out = 1'b1;
            marmux_sel = marmux::alu_out;
        end
        st1:
        begin
            mem_write = 1'b1;
            if (store_funct3 == rv32i_types::sw)
                mem_byte_enable = 4'b1111;
            else if (store_funct3 == rv32i_types::sh)
                mem_byte_enable = 4'b0011 << mem_address[1:0];
            else if (store_funct3 == rv32i_types::sb)
                mem_byte_enable = 4'b0001 << mem_address[1:0];
            else
                mem_byte_enable = 4'b0000;

            alumux2_sel = alumux::s_imm;
            marmux_sel = marmux::alu_out;
        end
        st2:
        begin
            load_pc = 1'b1;
            alumux2_sel = alumux::s_imm;
            marmux_sel = marmux::alu_out;
        end
        regop:
        begin
            load_pc = 1'b1;
            load_regfile = 1'b1;
            aluop = rv32i_types::alu_ops'(funct3);
            alumux2_sel = alumux::rs2_out;
            if ((funct3 == rv32i_types::add) && (funct7 == 7'b0000000))
                aluop = rv32i_types::alu_add;
            else if ((funct3 == rv32i_types::add) && (funct7 == 7'b0100000))
                aluop = rv32i_types::alu_sub;
            else if (funct3 == rv32i_types::sll)
                aluop = rv32i_types::alu_sll;
            else if ((funct3 == rv32i_types::sr) && (funct7 == 7'b0000000))
                aluop = rv32i_types::alu_srl;
            else if ((funct3 == rv32i_types::sr) && (funct7 == 7'b0100000))
                aluop = rv32i_types::alu_sra;
            else if (funct3 == rv32i_types::axor)
                aluop = rv32i_types::alu_xor;
            else if (funct3 == rv32i_types::aor)
                aluop = rv32i_types::alu_or;
            else if (funct3 == rv32i_types::aand)
                aluop = rv32i_types::alu_and;
            else if (funct3 == slt)
					 begin
                cmpop = rv32i_types::blt;
                cmpmux_sel = cmpmux::rs2_out;
                regfilemux_sel = regfilemux::br_en;
					 end
            else if (funct3 == rv32i_types::sltu)
					 begin
                cmpop = rv32i_types::bltu;
                cmpmux_sel = cmpmux::rs2_out;
                regfilemux_sel = regfilemux::br_en;  
					 end
        end
        jal:
        begin
            load_regfile = 1'b1;
            load_pc = 1'b1;
            regfilemux_sel = regfilemux::pc_plus4;
            alumux1_sel = alumux::pc_out;
            alumux2_sel = alumux::j_imm;
            pcmux_sel = pcmux::alu_mod2;
        end
        jalr:
        begin
            load_regfile = 1'b1;
            load_pc = 1'b1;
            regfilemux_sel = regfilemux::pc_plus4;
            alumux1_sel = alumux::rs1_out;
            alumux2_sel = alumux::i_imm;
            pcmux_sel = pcmux::alu_mod2;
        end
    endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
    unique case (state)
    fetch1:
        next_states = fetch2;
    fetch2:
        begin
            if (mem_resp == 1'b0) next_states = fetch2;
            else next_states = fetch3;
        end
    fetch3:
        next_states = decode;
    decode:
        begin
            unique case (opcode)
                op_lui: 
                    next_states = lui;
                op_auipc: 
                    next_states = auipc;
                op_br: 
                    next_states = br;
                op_load: 
                    next_states = calc_addr_ld;
                op_store:
                    next_states = calc_addr_st;
                op_imm:
                    next_states = imm;
                op_reg:
                    next_states = regop;
				op_jal:
				    next_states = jal;
				op_jalr:
					next_states = jalr;
                default: 
                    next_states = fetch1;
            endcase
        end
    calc_addr_ld:
        next_states = ld1;
    calc_addr_st:
        next_states = st1;
    ld1:
        begin
            if(mem_resp == 1'b0)
                next_states = ld1;
            else
                next_states = ld2;
        end
    st1:
        begin
            if(mem_resp == 1'b0)
                next_states = st1;
            else
                next_states = st2;
        end
    default: 
        next_states = fetch1;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    if (rst)
        state <= fetch1;
    else
        state <= next_states;
end

endmodule : control
