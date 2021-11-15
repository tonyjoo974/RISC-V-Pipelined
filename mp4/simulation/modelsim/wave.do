onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mp4_tb/f
add wave -noupdate -radix hexadecimal /mp4_tb/op_br
add wave -noupdate -radix hexadecimal /mp4_tb/op_store
add wave -noupdate -radix hexadecimal /mp4_tb/op_reg
add wave -noupdate -radix hexadecimal /mp4_tb/valid_rs2
add wave -noupdate -radix hexadecimal /mp4_tb/f
add wave -noupdate -radix hexadecimal /mp4_tb/op_br
add wave -noupdate -radix hexadecimal /mp4_tb/op_store
add wave -noupdate -radix hexadecimal /mp4_tb/op_reg
add wave -noupdate -radix hexadecimal /mp4_tb/valid_rs2
add wave -noupdate -expand -group topsig -radix hexadecimal /mp4_tb/dut/pmem_rdata
add wave -noupdate -expand -group topsig -radix hexadecimal /mp4_tb/dut/pmem_resp
add wave -noupdate -expand -group topsig -radix hexadecimal /mp4_tb/dut/pmem_address
add wave -noupdate -expand -group topsig -radix hexadecimal /mp4_tb/dut/pmem_wdata
add wave -noupdate -expand -group topsig -radix hexadecimal /mp4_tb/dut/pmem_read
add wave -noupdate -expand -group topsig -radix hexadecimal /mp4_tb/dut/pmem_write
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/clk
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/rst
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/imem_rdata
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/dmem_rdata
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/imem_resp
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/dmem_resp
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/imem_address
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/dmem_address
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/dmem_wdata
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/dmem_byte_enable
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/imem_read
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/dmem_read
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/dmem_write
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/load_pc
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/pcmux_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/pcmux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/pc_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/load_regfile
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ctrl
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/rs1_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/rs2_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_load
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/funct3
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/funct7
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/opcode
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_pc_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_i_imm
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_s_imm
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_b_imm
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_u_imm
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_j_imm
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_rs1
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_rs2
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_rd
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/if_id_imem_rdata_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/alumux1_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/alumux2_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/cmpmux_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/aluop
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/cmpop
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/alu_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/br_en
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/do_br
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/alumux1_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/alumux2_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/cmp_mux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_load
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_pc_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_ctrl_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_rs1_data_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_rs2_data_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_rs1_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_rs2_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_rd_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_i_imm_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_u_imm_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_b_imm_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_s_imm_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_j_imm_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/id_ex_imem_rdata_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_load
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_pc_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_ctrl_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_alu_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_rs1_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_rs2_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_rd_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_u_imm_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_br_en_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_do_br_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_mem_wdata
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_imem_rdata_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_rs1_data_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ex_mem_rs2_data_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/regfilemux_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/regfilemux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_load
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_pc_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_ctrl_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_alu_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_rs1_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_rs2_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_rd_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_u_imm_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_br_en_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_do_br_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_mdr_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_imem_rdata_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_trap_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_rs1_data_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_rs2_data_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_rmask_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_wmask_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_dmem_address
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/mem_wb_dmem_wdata
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/forwardA_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/forwardB_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/forwardC_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/forwardD_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/forwardA_mux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/forwardB_mux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/forwardC_mux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/forwardD_mux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/regfilemux_ex_mem_sel
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/regfilemux_ex_mem_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/inst_mux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/stall_pipeline
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ctrl_mux_out
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/ctrl_mux_out_br
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/regfile/data
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/store_funct3
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/branch_funct3
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/load_funct3
add wave -noupdate -expand -group cpusig -radix hexadecimal /mp4_tb/dut/cpu/datapath/arith_funct3
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/clk
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/rst
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/halt
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/commit
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/order
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/inst
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/trap
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/rs1_addr
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/rs2_addr
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/rs1_rdata
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/rs2_rdata
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/load_regfile
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/rd_addr
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/rd_wdata
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/pc_rdata
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/pc_wdata
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/mem_addr
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/mem_rmask
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/mem_wmask
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/mem_rdata
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/mem_wdata
add wave -noupdate -expand -group rvfisig -radix hexadecimal /mp4_tb/rvfi/errcode
add wave -noupdate -radix hexadecimal /mp4_tb/dut/cache_top/pmem_address
add wave -noupdate -radix hexadecimal /mp4_tb/dut/cache_top/pmem_rdata
add wave -noupdate -radix hexadecimal /mp4_tb/dut/cache_top/pmem_wdata
add wave -noupdate -radix hexadecimal /mp4_tb/dut/cache_top/pmem_read
add wave -noupdate -radix hexadecimal /mp4_tb/dut/cache_top/pmem_write
add wave -noupdate -radix hexadecimal /mp4_tb/dut/cache_top/pmem_resp
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/imem_address
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/imem_read
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/imem_rdata
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/imem_resp
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dmem_address
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dmem_wdata
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dmem_byte_enable
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dmem_read
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dmem_write
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dmem_rdata
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dmem_resp
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/ipmem_address
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/ipmem_rdata
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/ipmem_read
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/ipmem_resp
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dpmem_address
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dpmem_wdata
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dpmem_read
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dpmem_write
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dpmem_rdata
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/dpmem_resp
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/address_i
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/address_o
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/line_i
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/line_o
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/read_i
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/write_i
add wave -noupdate -expand -group cachetopsig -radix hexadecimal /mp4_tb/dut/cache_top/resp_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4138631 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 358
configure wave -valuecolwidth 135
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {3808125 ps} {5120625 ps}
