transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/l2_cache_datapath.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/l2_cache_control.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/l2_cache.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/bus_adaptor.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/data_array.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/cache_datapath.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/cache_control.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/array.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cacheline_adaptor.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl {/home/alberty3/ece411/Fried-Rice/mp4/hdl/rv32i_mux_types.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/register.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/regfile.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/pc_reg.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl {/home/alberty3/ece411/Fried-Rice/mp4/hdl/rv32i_types.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/cache_top.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/cache.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache {/home/alberty3/ece411/Fried-Rice/mp4/hdl/our_cache/arbiter.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl {/home/alberty3/ece411/Fried-Rice/mp4/hdl/mp4.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl {/home/alberty3/ece411/Fried-Rice/mp4/hdl/control_rom.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/pipeline_reg {/home/alberty3/ece411/Fried-Rice/mp4/hdl/pipeline_reg/mem_wb.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/pipeline_reg {/home/alberty3/ece411/Fried-Rice/mp4/hdl/pipeline_reg/if_id.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/pipeline_reg {/home/alberty3/ece411/Fried-Rice/mp4/hdl/pipeline_reg/id_ex.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/pipeline_reg {/home/alberty3/ece411/Fried-Rice/mp4/hdl/pipeline_reg/ex_mem.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/forwarding_hazards {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/forwarding_hazards/hazard_detection.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/forwarding_hazards {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/forwarding_hazards/forwarding.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/ir.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/datapath.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/ctrl_register.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/cpu.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/cmp.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu {/home/alberty3/ece411/Fried-Rice/mp4/hdl/cpu/alu.sv}

vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hvl {/home/alberty3/ece411/Fried-Rice/mp4/hvl/magic_dual_port.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hvl {/home/alberty3/ece411/Fried-Rice/mp4/hvl/param_memory.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hvl {/home/alberty3/ece411/Fried-Rice/mp4/hvl/rvfi_itf.sv}
vlog -vlog01compat -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hvl {/home/alberty3/ece411/Fried-Rice/mp4/hvl/rvfimon.v}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hvl {/home/alberty3/ece411/Fried-Rice/mp4/hvl/shadow_memory.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hvl {/home/alberty3/ece411/Fried-Rice/mp4/hvl/source_tb.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hvl {/home/alberty3/ece411/Fried-Rice/mp4/hvl/tb_itf.sv}
vlog -sv -work work +incdir+/home/alberty3/ece411/Fried-Rice/mp4/hvl {/home/alberty3/ece411/Fried-Rice/mp4/hvl/top.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L arriaii_hssi_ver -L arriaii_pcie_hip_ver -L arriaii_ver -L rtl_work -L work -voptargs="+acc"  mp4_tb

add wave *
view structure
view signals
run -all
