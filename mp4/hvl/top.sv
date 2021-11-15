module mp4_tb;
`timescale 1ns/10ps

/********************* Do not touch for proper compilation *******************/
// Instantiate Interfaces
tb_itf itf();
rvfi_itf rvfi(itf.clk, itf.rst);

// Instantiate Testbench
source_tb tb(
    .magic_mem_itf(itf),
    .mem_itf(itf),
    .sm_itf(itf),
    .tb_itf(itf),
    .rvfi(rvfi)
);

// For local simulation, add signal for Modelsim to display by default
// Note that this signal does nothing and is not used for anything
bit f;

/****************************** End do not touch *****************************/
logic [6:0] op_br = 7'b1100011;
logic [6:0] op_store = 7'b0100011;
logic [6:0] op_reg = 7'b0110011;
logic valid_rs2;

assign valid_rs2 = (dut.cpu.datapath.mem_wb_ctrl_out.opcode == op_br || dut.cpu.datapath.mem_wb_ctrl_out.opcode == op_store || dut.cpu.datapath.mem_wb_ctrl_out.opcode == op_reg);

/************************ Signals necessary for monitor **********************/
// This section not required until CP2

//The following signals need to be set:
assign rvfi.commit = dut.cpu.datapath.mem_wb_load && dut.cpu.datapath.mem_wb_ctrl_out.valid_inst; // Set high when a valid instruction is modifying regfile or PC
// assign rvfi.halt = dut.cpu.datapath.halt;
assign rvfi.halt = (rvfi.pc_wdata == rvfi.pc_rdata);   // Set high when you detect an infinite loop, removed && rvfi.commit
initial rvfi.order = 0;
always @(posedge itf.clk iff rvfi.commit) rvfi.order <= rvfi.order + 1; // Modify for OoO

// Instruction and trap:
assign rvfi.inst = dut.cpu.datapath.mem_wb_imem_rdata_out;
assign rvfi.trap = dut.cpu.datapath.mem_wb_trap_out;

// Regfile:

assign rvfi.rs1_addr = dut.cpu.datapath.mem_wb_rs1_out;
assign rvfi.rs2_addr = (valid_rs2) ? dut.cpu.datapath.mem_wb_rs2_out : 5'b0;
assign rvfi.rs1_rdata = dut.cpu.datapath.mem_wb_rs1_data_out;
assign rvfi.rs2_rdata = dut.cpu.datapath.mem_wb_rs2_data_out;
assign rvfi.load_regfile = dut.cpu.datapath.mem_wb_ctrl_out.load_regfile;
assign rvfi.rd_addr = dut.cpu.datapath.mem_wb_rd_out;
assign rvfi.rd_wdata = (dut.cpu.datapath.mem_wb_rd_out == 5'b0) ? 32'b0 : dut.cpu.datapath.regfilemux_out;

// PC:
assign rvfi.pc_rdata = dut.cpu.datapath.mem_wb_pc_out;
assign rvfi.pc_wdata = (dut.cpu.datapath.mem_wb_do_br_out) ? dut.cpu.datapath.mem_wb_alu_out : (dut.cpu.datapath.mem_wb_pc_out + 32'd4);
// assign rvfi.pc_wdata = (dut.cpu.datapath.mem_wb_br_en_out) ? dut.cpu.datapath.mem_wb_alu_out : dut.cpu.datapath.ex_mem_pc_out;

// Memory:
assign rvfi.mem_addr = dut.cpu.datapath.mem_wb_dmem_address;
assign rvfi.mem_rmask = dut.cpu.datapath.mem_wb_rmask_out;
assign rvfi.mem_wmask = dut.cpu.datapath.mem_wb_wmask_out;
assign rvfi.mem_rdata = dut.cpu.datapath.mem_wb_mdr_out;
assign rvfi.mem_wdata = dut.cpu.datapath.mem_wb_dmem_wdata;



// Please refer to rvfi_itf.sv for more information.


/**************************** End RVFIMON signals ****************************/

/********************* Assign Shadow Memory Signals Here *********************/
// This section not required until CP2

// The following signals need to be set:

// assign itf.inst_resp = dut.imem_resp;
// assign itf.inst_rdata = dut.imem_rdata;



// assign itf.data_resp = dut.dmem_resp;
// assign itf.data_rdata = dut.dmem_rdata;

initial begin
    // icache signals:
    itf.inst_read = dut.imem_read;
    itf.inst_addr = dut.imem_address;
    itf.inst_rdata = dut.imem_rdata;
    itf.inst_resp = dut.imem_resp;
    
    // dcache signals:
    itf.data_read = dut.dmem_read;
    itf.data_write = dut.dmem_write;
    itf.data_mbe = dut.dmem_byte_enable;
    itf.data_addr = dut.dmem_address;
    itf.data_wdata = dut.dmem_wdata;
    itf.data_rdata = dut.dmem_rdata;
    itf.data_resp = dut.dmem_resp;
end

// Please refer to tb_itf.sv for more information.


/*********************** End Shadow Memory Assignments ***********************/

// Set this to the proper value
assign itf.registers = '{default: '0};

/*********************** Instantiate your design here ************************/
/*
The following signals need to be connected to your top level:
Clock and reset signals:
    itf.clk
    itf.rst

Burst Memory Ports:
    itf.mem_read
    itf.mem_write
    itf.mem_wdata
    itf.mem_rdata
    itf.mem_addr
    itf.mem_resp

Please refer to tb_itf.sv for more information.
*/


 
mp4 dut(    
    .clk(itf.clk),
    .rst(itf.rst),
    .pmem_rdata(itf.mem_rdata),
    .pmem_resp(itf.mem_resp),
    .pmem_address(itf.mem_addr),
    .pmem_wdata(itf.mem_wdata), 
    .pmem_read(itf.mem_read),
    .pmem_write(itf.mem_write)
);

/***************************** End Instantiation *****************************/

endmodule
